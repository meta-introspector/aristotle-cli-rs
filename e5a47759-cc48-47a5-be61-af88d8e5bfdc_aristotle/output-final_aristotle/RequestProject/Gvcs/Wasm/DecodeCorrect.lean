import RequestProject.Gvcs.Wasm.Decode
import RequestProject.Gvcs.Wasm.Compile
import Mathlib.Tactic

/-!
# The encoder is read back exactly

`RequestProject/Wasm/Decode.lean` is a parser for the fragment of the
WebAssembly binary format the extractor emits.  Here we prove the round trip:

* `ulebDec_uleb`, `slebDec_sleb` — the LEB128 numbers;
* `decInstr_encInstr`, `decBlock_encInstrs` — the instruction encoding,
  including the multi-instruction patterns used for `load` and `store`;
* `decFuncType_funcType`, `decCode_funcCode` — the type and code entries;
* `decodeMod_encodeMod` — a whole module.

The consequence is that the byte string the extractor writes determines the
abstract syntax it was made from: no length prefix, opcode or LEB128 field in
`lifetrac.wasm` can be wrong in a way that still parses, because parsing it
gives back exactly the module the correctness proofs of
`RequestProject/Wasm/Correct.lean` are about.
-/

namespace LifeTrac
namespace Wasm

/-! ## LEB128 -/

theorem ulebDec_uleb (n : Nat) (rest : List UInt8) :
    ulebDec (uleb n ++ rest) = some (n, rest) := by
  induction n using Nat.strong_induction_on with
  | _ n ih =>
    rw [uleb]
    by_cases h : n / 128 = 0
    · have h2 : n < 128 := by omega
      have h3 : n % 128 % 256 = n := by omega
      simp [h, ulebDec, h3, h2]
    · have h1 : n % 128 + 128 < 256 := by omega
      simp only [h, if_false, List.cons_append, ulebDec, UInt8.toNat_ofNat_of_lt' h1]
      rw [if_neg (by omega), ih (n / 128) (by omega)]
      simp
      omega

theorem slebDec_sleb (n : Int) (rest : List UInt8) :
    slebDec (sleb n ++ rest) = some (n, rest) := by
  generalize hk : n.natAbs = k
  induction k using Nat.strong_induction_on generalizing n with
  | _ k ih =>
    subst hk
    have hred : (n - n % 128) / 128 = n / 128 := by omega
    rw [sleb, hred]
    by_cases h : (n / 128 = 0 ∧ n % 128 < 64) ∨ (n / 128 = -1 ∧ 64 ≤ n % 128)
    · have hb : (n % 128).toNat < 128 := by omega
      simp only [h, if_true, List.cons_append, List.nil_append, slebDec,
        UInt8.toNat_ofNat_of_lt' (show (n % 128).toNat < 256 by omega)]
      rw [if_pos hb]
      rcases h with ⟨h1, h2⟩ | ⟨h1, h2⟩
      · rw [if_pos (by omega)]; norm_num; omega
      · rw [if_neg (by omega)]; norm_num; omega
    · have hb : (n % 128).toNat + 128 < 256 := by omega
      simp only [h, if_false, List.cons_append, slebDec, UInt8.toNat_ofNat_of_lt' hb]
      rw [if_neg (by omega), ih (n / 128).natAbs (by omega) _ rfl]
      simp
      omega

/-! ## Framing -/

theorem takeN_append (l rest : List UInt8) : takeN l.length (l ++ rest) = some (l, rest) := by
  simp [takeN]

theorem decVecBytes_vecBytes (bs rest : List UInt8) :
    decVecBytes (vecBytes bs ++ rest) = some (bs, rest) := by
  simp [decVecBytes, vecBytes, List.append_assoc, ulebDec_uleb, takeN_append]

theorem runDec_of_eq {α : Type} {d : Dec α} {l : List UInt8} {a : α}
    (h : d l = some (a, [])) : runDec d l = some a := by
  simp [runDec, h]

theorem decSection_section' (id : Nat) (body rest : List UInt8) :
    decSection id.toUInt8 (section' id body ++ rest) = some (body, rest) := by
  simp [decSection, section', decVecBytes_vecBytes]

theorem decVecN_flatten {α : Type} {d : Dec α} {enc : α → List UInt8} :
    ∀ (l : List α) (rest : List UInt8),
      (∀ a ∈ l, ∀ r : List UInt8, d (enc a ++ r) = some (a, r)) →
      decVecN d l.length ((l.map enc).flatten ++ rest) = some (l, rest)
  | [], rest, _ => by simp [decVecN]
  | a :: l, rest, h => by
      have h1 : d (enc a ++ ((l.map enc).flatten ++ rest)) = some (a, (l.map enc).flatten ++ rest) :=
        h a (by simp) _
      have h2 := decVecN_flatten (d := d) (enc := enc) l rest (fun b hb => h b (by simp [hb]))
      simp only [List.map_cons, List.flatten_cons, List.append_assoc, List.length_cons,
        decVecN, h1, h2]

theorem decVec_vec {α : Type} {d : Dec α} {enc : α → List UInt8} (l : List α) (rest : List UInt8)
    (h : ∀ a ∈ l, ∀ r : List UInt8, d (enc a ++ r) = some (a, r)) :
    decVec d (vec (l.map enc) ++ rest) = some (l, rest) := by
  have : (l.map enc).length = l.length := by simp
  simp only [decVec, vec, List.append_assoc, ulebDec_uleb, this]
  exact decVecN_flatten l rest h

theorem runDec_decVec {α : Type} {d : Dec α} {enc : α → List UInt8} (l : List α)
    (h : ∀ a ∈ l, ∀ r : List UInt8, d (enc a ++ r) = some (a, r)) :
    runDec (decVec d) (vec (l.map enc)) = some l := by
  refine runDec_of_eq ?_
  have hv := decVec_vec (d := d) (enc := enc) l [] h
  rwa [List.append_nil] at hv

/-! ## Instructions

The one place where the encoding is not a simple prefix code is `i64.store`,
which the encoder spells as four instructions passing through the scratch
local.  Reading it back therefore needs to know that a genuine `local.set` of
the scratch local is never followed by the byte pair `A7 20`; that is
`noWrapGet_encInstrs` below, and it holds because no instruction of the IR
begins with those two bytes. -/

/-- The byte string does not begin with `i32.wrap_i64; local.get`, the two
bytes that distinguish the encoder's `i64.store` pattern. -/
def NoWrapGet (rest : List UInt8) : Prop := ∀ r, rest ≠ 0xA7 :: 0x20 :: r

/-- The tail left after a block: nothing, an `else`, or an `end`. -/
def TermTail (rest : List UInt8) : Prop :=
  rest = [] ∨ (∃ r, rest = 0x05 :: r) ∨ (∃ r, rest = 0x0B :: r)

theorem noWrapGet_of_termTail {rest : List UInt8} (h : TermTail rest) : NoWrapGet rest := by
  rcases h with rfl | ⟨r, rfl⟩ | ⟨r, rfl⟩ <;> intro r' hr' <;> simp at hr'

/-- `storeTail` fails on a byte string that does not begin with the two bytes
that open the encoder's store pattern. -/
theorem storeTail_none (sc : Nat) {l : List UInt8} (h : NoWrapGet l) : storeTail sc l = none := by
  unfold storeTail
  split
  · exact absurd rfl (h _)
  · rfl

theorem szI_pos (i : Instr) : 1 ≤ szI i := by cases i <;> simp [szI] <;> omega

theorem szL_pos (l : List Instr) : 1 ≤ szL l := by cases l <;> simp [szL]; omega

theorem noWrapGet_encInstrs (sc : Nat) (l : List Instr) (rest : List UInt8)
    (h : TermTail rest) : NoWrapGet (encInstrs sc l ++ rest) := by
  cases l with
  | nil => simpa [encInstrs] using noWrapGet_of_termTail h
  | cons i l =>
      intro r hr
      cases i <;> simp [encInstrs, encInstr, cmp] at hr

/-- Unfolding `decBlock` on a byte that is neither `else` nor `end`. -/
theorem decBlock_cons (f sc : Nat) (b : UInt8) (tl : List UInt8) (h5 : b ≠ 0x05) (h11 : b ≠ 0x0B) :
    decBlock (f + 1) sc (b :: tl) =
      match decInstr f sc (b :: tl) with
      | none => none
      | some (i, r) =>
        match decBlock f sc r with
        | none => none
        | some (is, r') => some (i :: is, r') := by
  rw [decBlock.eq_def]; simp only [h5, h11, or_self, if_false]; rfl

/-- Every instruction's encoding begins with a byte that closes no block. -/
theorem encInstr_head (sc : Nat) (i : Instr) :
    ∃ b t, encInstr sc i = b :: t ∧ b ≠ 0x05 ∧ b ≠ 0x0B := by
  cases i <;> exact ⟨_, _, rfl, by decide, by decide⟩

/-- Reading back one instruction, and reading back a block. -/
theorem dec_encInstr (fuel : Nat) :
    (∀ (sc : Nat) (i : Instr) (rest : List UInt8), szI i ≤ fuel → NoWrapGet rest →
        decInstr fuel sc (encInstr sc i ++ rest) = some (i, rest)) ∧
    (∀ (sc : Nat) (l : List Instr) (rest : List UInt8), szL l ≤ fuel → TermTail rest →
        decBlock fuel sc (encInstrs sc l ++ rest) = some (l, rest)) := by
  induction fuel using Nat.strong_induction_on with
  | _ fuel ih =>
    constructor
    · intro sc i rest hf hnw
      obtain ⟨f, rfl⟩ : ∃ f, fuel = f + 1 := by
        cases fuel with
        | zero => exact absurd hf (by have := szI_pos i; omega)
        | succ f => exact ⟨f, rfl⟩
      have ihb : ∀ (sc : Nat) (l : List Instr) (rest : List UInt8), szL l ≤ f → TermTail rest →
          decBlock f sc (encInstrs sc l ++ rest) = some (l, rest) := (ih f (by omega)).2
      cases i with
      | const n => rw [encInstr, decInstr.eq_def]; simp [slebDec_sleb]
      | localGet j => rw [encInstr, decInstr.eq_def]; simp [ulebDec_uleb]
      | localTee j => rw [encInstr, decInstr.eq_def]; simp [ulebDec_uleb]
      | localSet j =>
          rw [encInstr, decInstr.eq_def]
          simp [ulebDec_uleb, storeTail_none sc hnw]
      | store => rw [encInstr, decInstr.eq_def]; simp [ulebDec_uleb, storeTail]
      | load => rw [encInstr, decInstr.eq_def]; simp
      | add => rw [encInstr, decInstr.eq_def]; simp
      | sub => rw [encInstr, decInstr.eq_def]; simp
      | mul => rw [encInstr, decInstr.eq_def]; simp
      | divs => rw [encInstr, decInstr.eq_def]; simp
      | and => rw [encInstr, decInstr.eq_def]; simp
      | or => rw [encInstr, decInstr.eq_def]; simp
      | drop => rw [encInstr, decInstr.eq_def]; simp
      | lt => rw [encInstr, decInstr.eq_def]; simp [cmp]
      | le => rw [encInstr, decInstr.eq_def]; simp [cmp]
      | gt => rw [encInstr, decInstr.eq_def]; simp [cmp]
      | ge => rw [encInstr, decInstr.eq_def]; simp [cmp]
      | eq => rw [encInstr, decInstr.eq_def]; simp [cmp]
      | ne => rw [encInstr, decInstr.eq_def]; simp [cmp]
      | eqz => rw [encInstr, decInstr.eq_def]; simp [cmp]
      | ifte t e =>
          have hszt : szL t ≤ f := by have := szL_pos e; rw [szI] at hf; omega
          have hsze : szL e ≤ f := by have := szL_pos t; rw [szI] at hf; omega
          have h1 : decInstr (f + 1) sc (encInstr sc (Instr.ifte t e) ++ rest)
              = decIf f sc true (encInstrs sc t ++ 0x05 :: (encInstrs sc e ++ 0x0B :: rest)) := by
            rw [encInstr, decInstr.eq_def]; simp
          rw [h1, decIf.eq_def, ihb sc t _ hszt (Or.inr (Or.inl ⟨_, rfl⟩))]
          simp only [ihb sc e _ hsze (Or.inr (Or.inr ⟨_, rfl⟩))]
          simp
      | ifstmt t e =>
          have hszt : szL t ≤ f := by have := szL_pos e; rw [szI] at hf; omega
          have hsze : szL e ≤ f := by have := szL_pos t; rw [szI] at hf; omega
          have h1 : decInstr (f + 1) sc (encInstr sc (Instr.ifstmt t e) ++ rest)
              = decIf f sc false (encInstrs sc t ++ 0x05 :: (encInstrs sc e ++ 0x0B :: rest)) := by
            rw [encInstr, decInstr.eq_def]; simp
          rw [h1, decIf.eq_def, ihb sc t _ hszt (Or.inr (Or.inl ⟨_, rfl⟩))]
          simp only [ihb sc e _ hsze (Or.inr (Or.inr ⟨_, rfl⟩))]
          simp
    · intro sc l rest hf ht
      obtain ⟨f, rfl⟩ : ∃ f, fuel = f + 1 := by
        cases fuel with
        | zero => exact absurd hf (by have := szL_pos l; omega)
        | succ f => exact ⟨f, rfl⟩
      cases l with
      | nil =>
          rcases ht with rfl | ⟨r, rfl⟩ | ⟨r, rfl⟩ <;> simp [encInstrs, decBlock.eq_def]
      | cons i l =>
          have hszi : szI i ≤ f := by rw [szL] at hf; have := szL_pos l; omega
          have hszl : szL l ≤ f := by rw [szL] at hf; have := szI_pos i; omega
          obtain ⟨b, tl, hbt, h5, h11⟩ := encInstr_head sc i
          have hsplit : encInstrs sc (i :: l) ++ rest = b :: (tl ++ (encInstrs sc l ++ rest)) := by
            rw [encInstrs, hbt]; simp
          have hback : b :: (tl ++ (encInstrs sc l ++ rest))
              = encInstr sc i ++ (encInstrs sc l ++ rest) := by rw [hbt]; simp
          rw [hsplit, decBlock_cons f sc b _ h5 h11, hback,
            (ih f (by omega)).1 sc i _ hszi (noWrapGet_encInstrs sc l rest ht)]
          dsimp only
          rw [(ih f (by omega)).2 sc l rest hszl ht]

theorem decInstr_encInstr (fuel sc : Nat) (i : Instr) (rest : List UInt8)
    (hf : szI i ≤ fuel) (hr : NoWrapGet rest) :
    decInstr fuel sc (encInstr sc i ++ rest) = some (i, rest) :=
  (dec_encInstr fuel).1 sc i rest hf hr

theorem decBlock_encInstrs (fuel sc : Nat) (l : List Instr) (rest : List UInt8)
    (hf : szL l ≤ fuel) (hr : TermTail rest) :
    decBlock fuel sc (encInstrs sc l ++ rest) = some (l, rest) :=
  (dec_encInstr fuel).2 sc l rest hf hr

/-! ## Sections -/

theorem decFuncType_funcType (f : Func) (rest : List UInt8) :
    decFuncType (funcType f ++ rest) = some ((f.params, f.returns), rest) := by
  have htake : ∀ X : List UInt8, takeN f.params (List.replicate f.params (0x7E : UInt8) ++ X)
      = some (List.replicate f.params 0x7E, X) := fun X => by simp [takeN]
  have hsplit : funcType f ++ rest
      = 0x60 :: (uleb f.params ++ (List.replicate f.params (0x7E : UInt8) ++
          ((if f.returns then [0x01, 0x7E] else [0x00]) ++ rest))) := by
    simp [funcType, List.append_assoc]
  rw [hsplit]
  cases hret : f.returns <;>
    simp [decFuncType, ulebDec_uleb, htake]

theorem decCode_funcCode (fuel : Nat) (f : Func) (rest : List UInt8)
    (hf : szL f.body ≤ fuel) :
    decCode fuel f.params (funcCode f ++ rest) = some ((f.locals, f.body), rest) := by
  have hsplit : funcCode f = vecBytes (0x01 :: (uleb (f.locals + 1) ++
      (0x7E :: (encInstrs (f.params + f.locals) f.body ++ [0x0B])))) := by
    simp [funcCode, encBody, List.append_assoc]
  rw [hsplit, decCode, decVecBytes_vecBytes]
  simp only [ulebDec_uleb]
  rw [if_neg (by omega), Nat.add_sub_cancel,
    decBlock_encInstrs fuel _ f.body [0x0B] hf (Or.inr (Or.inr ⟨[], rfl⟩))]
  simp

theorem decCodes_map (fuel : Nat) : ∀ (fs : List Func) (rest : List UInt8),
    (∀ f ∈ fs, szL f.body ≤ fuel) →
    decCodes fuel (fs.map (fun f => (f.params, f.returns)))
        ((fs.map funcCode).flatten ++ rest)
      = some (fs.map (fun f => (f.locals, f.body)), rest)
  | [], rest, _ => by simp [decCodes]
  | f :: fs, rest, h => by
      have h1 := decCode_funcCode fuel f ((fs.map funcCode).flatten ++ rest) (h f (by simp))
      have h2 := decCodes_map fuel fs rest (fun g hg => h g (by simp [hg]))
      simp only [List.map_cons, List.flatten_cons, List.append_assoc, decCodes, h1, h2]

theorem decMem_mem (pages : Nat) (rest : List UInt8) :
    decMem ([0x00] ++ uleb pages ++ rest) = some (pages, rest) := by
  simp [decMem, ulebDec_uleb]

theorem decData_data (img rest : List UInt8) :
    decData ([0x00, 0x41, 0x00, 0x0B] ++ vecBytes img ++ rest) = some (img, rest) := by
  simp [decData, decVecBytes_vecBytes]

theorem decExport_export (nm : List UInt8) (kind : UInt8) (i : Nat) (rest : List UInt8) :
    decExport (vecBytes nm ++ [kind] ++ uleb i ++ rest) = some ((nm, kind, i), rest) := by
  simp [decExport, List.append_assoc, decVecBytes_vecBytes, ulebDec_uleb]

theorem zipIdx_map_snd' {α β : Type} (l : List α) (g : Nat → β) :
    l.zipIdx.map (fun p => g p.2) = (List.range l.length).map g := by
  simp [show (fun p : α × Nat => g p.2) = g ∘ Prod.snd from rfl, ← List.map_map,
    List.zipIdx_map_snd, List.range_eq_range']

theorem zipIdx_map_fst' {α β : Type} (l : List α) (g : α → β) :
    l.zipIdx.map (fun p => g p.1) = l.map g := by
  simp [show (fun p : α × Nat => g p.1) = g ∘ Prod.fst from rfl, ← List.map_map]

/-- The types, names and code entries recombine into the functions. -/
theorem zipFuncs_map (fs : List Func) :
    zipFuncs (fs.map (fun f => f.name.toUTF8.toList)) (fs.map (fun f => (f.params, f.returns)))
        (fs.map (fun f => (f.locals, f.body)))
      = fs.map (fun f =>
          (⟨f.name.toUTF8.toList, f.params, f.locals, f.returns, f.body⟩ : DecFunc)) := by
  induction fs with
  | nil => rfl
  | cons f fs ih => rw [List.map_cons, List.map_cons, List.map_cons, zipFuncs, ih, List.map_cons]; rfl

/-! ## The module -/

/-- The type entry of a function depends only on its arity and its result. -/
def funcTypeOf (t : Nat × Bool) : List UInt8 :=
  0x60 :: uleb t.1 ++ List.replicate t.1 (0x7E : UInt8) ++ (if t.2 then [0x01, 0x7E] else [0x00])

theorem funcType_eq (f : Func) : funcType f = funcTypeOf (f.params, f.returns) := rfl

theorem decFuncType_funcTypeOf (t : Nat × Bool) (rest : List UInt8) :
    decFuncType (funcTypeOf t ++ rest) = some (t, rest) := by
  have h := decFuncType_funcType ⟨"", t.1, 0, t.2, []⟩ rest
  simpa [funcType_eq] using h

/-- One export entry: a name, a kind byte and an index. -/
def expEntry (e : List UInt8 × UInt8 × Nat) : List UInt8 := vecBytes e.1 ++ [e.2.1] ++ uleb e.2.2

/-- One memory entry: an unbounded memory of the given number of pages. -/
def memEntry (p : Nat) : List UInt8 := [0x00] ++ uleb p

/-- One data segment: active, in memory 0, at offset `i32.const 0`. -/
def dataEntry (b : List UInt8) : List UInt8 := [0x00, 0x41, 0x00, 0x0B] ++ vecBytes b

/-- The fuel needed to read a module back. -/
def modFuel (m : Mod) : Nat := (m.funcs.map (fun f => szL f.body)).sum

/-- Reading back the bytes the extractor writes gives exactly the module it was
given: the memory size, the data segment, and every function with its name,
its type, its locals and its body. -/
theorem decodeMod_encodeMod (m : Mod) (fuel : Nat) (hf : modFuel m ≤ fuel) :
    decodeMod fuel (encodeMod m) =
      some ⟨m.memPages, imageBytes m.image, m.funcs.map (fun f =>
        (⟨f.name.toUTF8.toList, f.params, f.locals, f.returns, f.body⟩ : DecFunc))⟩ := by
  have hfuel : ∀ f ∈ m.funcs, szL f.body ≤ fuel := by
    intro f hfm
    refine le_trans (List.single_le_sum (fun x _ => Nat.zero_le x) _ ?_) hf
    exact List.mem_map_of_mem hfm
  set tys : List (Nat × Bool) := m.funcs.map (fun f => (f.params, f.returns)) with htys
  set exps : List (List UInt8 × UInt8 × Nat) :=
    ("mem".toUTF8.toList, (0x02 : UInt8), 0) ::
      m.funcs.zipIdx.map (fun p => (p.1.name.toUTF8.toList, (0x00 : UInt8), p.2)) with hexps
  have htylen : tys.length = m.funcs.length := by simp [htys]
  -- the sections, in the shape the decoder reads them
  have hty : m.funcs.map funcType = tys.map funcTypeOf := by
    simp [htys, List.map_map, funcType_eq, Function.comp]
  have hidx : m.funcs.zipIdx.map (fun p => uleb p.2)
      = (List.range m.funcs.length).map uleb := zipIdx_map_snd' _ _
  have hexp : (nameBytes "mem" ++ [0x02] ++ uleb 0) ::
      m.funcs.zipIdx.map (fun p => nameBytes p.1.name ++ [(0x00 : UInt8)] ++ uleb p.2)
      = exps.map expEntry := by
    simp [hexps, expEntry, nameBytes, List.map_map, Function.comp]
  have hdata : ∀ img : List UInt8,
      [([0x00, 0x41, 0x00, 0x0B] ++ vecBytes img)] = [img].map dataEntry := by
    intro img; simp [dataEntry]
  -- reading each section back
  have rty : runDec (decVec decFuncType) (vec (tys.map funcTypeOf)) = some tys :=
    runDec_decVec (d := decFuncType) (enc := funcTypeOf) tys
      (fun t _ r => decFuncType_funcTypeOf t r)
  have ridx : runDec (decVec ulebDec) (vec ((List.range m.funcs.length).map uleb))
      = some (List.range m.funcs.length) :=
    runDec_decVec (d := ulebDec) (enc := uleb) _ (fun n _ r => ulebDec_uleb n r)
  have rmem : runDec (decVec decMem) (vec ([m.memPages].map memEntry)) = some [m.memPages] :=
    runDec_decVec (d := decMem) (enc := memEntry) _ (fun p _ r => decMem_mem p r)
  have rexp : runDec (decVec decExport) (vec (exps.map expEntry)) = some exps :=
    runDec_decVec (d := decExport) (enc := expEntry) exps (fun e _ r => by
      simpa [expEntry, List.append_assoc] using decExport_export e.1 e.2.1 e.2.2 r)
  have rdata : ∀ img : List UInt8,
      runDec (decVec decData) (vec ([img].map dataEntry)) = some [img] := fun img =>
    runDec_decVec (d := decData) (enc := dataEntry) _ (fun b _ r => by
      simpa [dataEntry, List.append_assoc] using decData_data b r)
  have rcode : runDec (fun l => do
      let (n, l') ← ulebDec l
      guard (n = tys.length)
      decCodes fuel tys l') (vec (m.funcs.map funcCode))
      = some (m.funcs.map (fun f => (f.locals, f.body))) := by
    refine runDec_of_eq ?_
    have h1 : ulebDec (vec (m.funcs.map funcCode))
        = some (m.funcs.length, (m.funcs.map funcCode).flatten) := by
      simpa [vec] using ulebDec_uleb (m.funcs.map funcCode).length (m.funcs.map funcCode).flatten
    have h2 := decCodes_map fuel m.funcs [] hfuel
    simp only [h1, htylen, guard]
    simpa [htys] using h2
  simp only [guard, htylen, Option.bind_eq_bind] at rcode
  -- the names, indices and codes recombine
  have hnames : exps.tail.map Prod.fst = m.funcs.map (fun f => f.name.toUTF8.toList) := by
    rw [hexps]
    simp only [List.tail_cons, List.map_map]
    exact zipIdx_map_fst' m.funcs (fun f => f.name.toUTF8.toList)
  have hkinds : exps.tail.map Prod.snd
      = (List.range tys.length).map (fun i => ((0x00 : UInt8), i)) := by
    rw [hexps, htylen]
    simp only [List.tail_cons, List.map_map]
    exact zipIdx_map_snd' m.funcs (fun i => ((0x00 : UInt8), i))
  have h8 : ∀ X : List UInt8, takeN 8 (wasmMagic ++ X) = some (wasmMagic, X) :=
    fun X => takeN_append wasmMagic X
  have hs : ∀ (id : Nat) (body rest : List UInt8),
      decSection id.toUInt8 (section' id body ++ rest) = some (body, rest) := decSection_section'
  set dsec : List UInt8 := (if (imageBytes m.image).isEmpty then [] else
      section' 11 (vec ([imageBytes m.image].map dataEntry))) with hdsec
  have henc : encodeMod m = wasmMagic ++ (section' 1 (vec (tys.map funcTypeOf)) ++
      (section' 3 (vec ((List.range m.funcs.length).map uleb)) ++
      (section' 5 (vec ([m.memPages].map memEntry)) ++
      (section' 7 (vec (exps.map expEntry)) ++
      (section' 10 (vec (m.funcs.map funcCode)) ++ dsec))))) := by
    rw [hdsec, encodeMod]
    simp [hty, hidx, ← hexp, memEntry, dataEntry, wasmMagic, List.append_assoc]
  have hs1 : ∀ body rest : List UInt8, decSection 1 (section' 1 body ++ rest) = some (body, rest) :=
    fun body rest => decSection_section' 1 body rest
  have hs3 : ∀ body rest : List UInt8, decSection 3 (section' 3 body ++ rest) = some (body, rest) :=
    fun body rest => decSection_section' 3 body rest
  have hs5 : ∀ body rest : List UInt8, decSection 5 (section' 5 body ++ rest) = some (body, rest) :=
    fun body rest => decSection_section' 5 body rest
  have hs7 : ∀ body rest : List UInt8, decSection 7 (section' 7 body ++ rest) = some (body, rest) :=
    fun body rest => decSection_section' 7 body rest
  have hs10 : ∀ body rest : List UInt8,
      decSection 10 (section' 10 body ++ rest) = some (body, rest) :=
    fun body rest => decSection_section' 10 body rest
  have hs11 : ∀ body rest : List UInt8,
      decSection 11 (section' 11 body ++ rest) = some (body, rest) :=
    fun body rest => decSection_section' 11 body rest
  rw [henc]
  unfold decodeMod
  rw [h8]
  simp (maxSteps := 1000000) only [Option.bind_eq_bind, Option.bind_some, guard,
    hs1, hs3, hs5, hs7, hs10, rty, ridx, rmem, rexp, rcode, htylen, if_true]
  rw [hexps]
  have hnames' : List.map Prod.fst
      (List.map (fun p => (p.1.name.toUTF8.toList, (0 : UInt8), p.2)) m.funcs.zipIdx)
      = List.map (fun f => f.name.toUTF8.toList) m.funcs := by
    have h := hnames; rw [hexps] at h; simpa using h
  have hkinds' : List.map Prod.snd
      (List.map (fun p => (p.1.name.toUTF8.toList, (0 : UInt8), p.2)) m.funcs.zipIdx)
      = List.map (fun i => ((0 : UInt8), i)) (List.range m.funcs.length) := by
    have h := hkinds; rw [hexps, htylen] at h; simpa using h
  simp only [Option.pure_def, and_self, if_true, Option.bind_some, hkinds', hnames', htys,
    zipFuncs_map]
  by_cases hemp : (imageBytes m.image).isEmpty
  · have him : imageBytes m.image = [] := List.isEmpty_iff.mp hemp
    have hd : dsec = [] := by rw [hdsec, if_pos hemp]
    rw [hd, him]
    simp
  · have hd : dsec = section' 11 (vec (List.map dataEntry [imageBytes m.image])) := by
      rw [hdsec, if_neg hemp]
    have hne : dsec ≠ [] := by rw [hd]; simp [section']
    have h11 : decSection 11 dsec
        = some (vec (List.map dataEntry [imageBytes m.image]), ([] : List UInt8)) := by
      rw [hd]
      simpa using hs11 (vec (List.map dataEntry [imageBytes m.image])) []
    rw [if_neg hne, h11]
    simp only [Option.bind_some, rdata (imageBytes m.image), if_true]

/-- The file the extractor writes, `web/lifetrac.wasm`, parses back to the very
module the correctness proofs of `RequestProject/Wasm/Correct.lean` and
`RequestProject/Wasm/Shell.lean` are about: one page of memory, the data
segment of `gameMod`, and the six entry points with their names, their types,
their locals and their bodies. -/
theorem decodeMod_encodeMod_gameMod :
    decodeMod (modFuel gameMod) (encodeMod gameMod) =
      some ⟨gameMod.memPages, imageBytes gameMod.image, gameMod.funcs.map (fun f =>
        (⟨f.name.toUTF8.toList, f.params, f.locals, f.returns, f.body⟩ : DecFunc))⟩ :=
  decodeMod_encodeMod gameMod _ le_rfl

end Wasm
end LifeTrac
