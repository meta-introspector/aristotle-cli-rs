import RequestProject.Nix.NixWars.WasmBinary

/-!
# The emitted bytes are the module

`WasmBinary.lean` encodes a module as a list of bytes. That encoder is the last
step of the pipeline, and on its own it is only as trustworthy as its author:
nothing so far rules out a section length that is off by one, an ambiguous
vector, or an opcode that collides with the terminator of a function body.

This file removes that gap. It defines a *decoder* — written independently of
the encoder, reading bytes and rebuilding a `Module` — and proves that decoding
an encoded module returns exactly the module that was encoded
(`decodeModule_encodeModule`). Two side conditions are needed and are true of
everything we emit: export names are ASCII, and the constants in the code fit in
a signed 32-bit LEB128 word.

The decoder is deliberately strict: it checks the magic number, the section
ids, the declared section lengths, the declared vector counts, that the local
declarations of a body are empty, and that each section's payload is consumed
exactly. The only field it does not re-check is the function index attached to
an export, which the encoder always writes as the function's position.
-/

set_option maxRecDepth 100000

namespace NixWars
namespace Wasm

/-! ## Signed LEB128 -/

/-- Reading a non-negative signed LEB128 number off the front of a stream. A
final byte with bit 6 set would denote a negative number and is rejected. -/
def slebDecode : List UInt8 → Option (Nat × List UInt8)
  | [] => none
  | b :: bs =>
      if b.toNat < 128 then
        (if b.toNat < 64 then some (b.toNat, bs) else none)
      else
        match slebDecode bs with
        | none => none
        | some (n, rest) => some (b.toNat - 128 + 128 * n, rest)

/-- The fuel does not matter as long as there is enough of it. -/
theorem slebAux_fuel : ∀ (n f g : Nat), n ≤ f → n ≤ g → slebAux f n = slebAux g n := by
  intro n
  induction n using Nat.strong_induction_on with
  | _ n ih =>
    intro f g hf hg
    by_cases h : n < 64
    · match f, g with
      | 0, 0 => rfl
      | 0, g + 1 => simp [slebAux, h, Nat.mod_eq_of_lt (by omega : n < 128)]
      | f + 1, 0 => simp [slebAux, h, Nat.mod_eq_of_lt (by omega : n < 128)]
      | f + 1, g + 1 => simp [slebAux, h]
    · match f, g with
      | 0, _ => omega
      | _, 0 => omega
      | f + 1, g + 1 =>
        have hlt : n / 128 < n := by omega
        have h1 : n / 128 ≤ f := by omega
        have h2 : n / 128 ≤ g := by omega
        simp [slebAux, h, ih (n / 128) hlt f g h1 h2]

/-- The defining equation of `slebNat`. -/
theorem slebNat_eq (n : Nat) :
    slebNat n = if n < 64 then [UInt8.ofNat n]
      else UInt8.ofNat (n % 128 + 128) :: slebNat (n / 128) := by
  by_cases h : n < 64
  · match n with
    | 0 => rfl
    | m + 1 => simp [slebNat, slebAux, h]
  · match n with
    | 0 => omega
    | m + 1 =>
      have h1 : (m + 1) / 128 ≤ m := by omega
      simp only [slebNat, slebAux, if_neg h]
      rw [slebAux_fuel ((m + 1) / 128) m ((m + 1) / 128) h1 le_rfl]

/-- Signed LEB128 of a non-negative number is unambiguous. -/
theorem slebDecode_slebNat (n : Nat) :
    ∀ rest : List UInt8, slebDecode (slebNat n ++ rest) = some (n, rest) := by
  induction n using Nat.strong_induction_on with
  | _ n ih =>
    intro rest
    rw [slebNat_eq]
    by_cases h : n < 64
    · have hn : (UInt8.ofNat n).toNat = n := by
        simp [Nat.mod_eq_of_lt (by omega : n < 256)]
      simp [h, slebDecode, hn]
      omega
    · have hlt : n / 128 < n := by omega
      have hb : (UInt8.ofNat (n % 128 + 128)).toNat = n % 128 + 128 := by
        have hlt' : n % 128 + 128 < 256 := by omega
        simp [Nat.mod_eq_of_lt hlt']
      simp only [h, if_false, List.cons_append, slebDecode, hb]
      rw [if_neg (by omega), ih (n / 128) hlt rest]
      simp only [Option.some.injEq, Prod.mk.injEq, and_true]
      omega

/-! ## Instructions -/

/-- Reading one instruction off the front of a stream. -/
def decodeInstr : List UInt8 → Option (Instr × List UInt8)
  | [] => none
  | b :: bs =>
      if b = 0x41 then
        match slebDecode bs with
        | none => none
        | some (n, rest) => some (.const n, rest)
      else if b = 0x20 then
        match ulebDecode bs with
        | none => none
        | some (i, rest) => some (.localGet i, rest)
      else if b = 0x6a then some (.add, bs)
      else if b = 0x6c then some (.mul, bs)
      else if b = 0x6b then some (.sub, bs)
      else if b = 0x6e then some (.divU, bs)
      else if b = 0x4d then some (.leU, bs)
      else if b = 0x45 then some (.eqz, bs)
      else if b = 0x1b then some (.select, bs)
      else if b = 0x10 then
        match ulebDecode bs with
        | none => none
        | some (f, rest) => some (.call f, rest)
      else none

/-- Reading instructions up to the `end` opcode. -/
def decodeInstrs : Nat → List UInt8 → Option (List Instr × List UInt8)
  | 0, _ => none
  | _ + 1, [] => none
  | f + 1, b :: bs =>
      if b = 0x0b then some ([], bs)
      else
        match decodeInstr (b :: bs) with
        | none => none
        | some (i, rest) =>
            match decodeInstrs f rest with
            | none => none
            | some (is, rest') => some (i :: is, rest')

/-- An instruction is at least one byte long. -/
theorem length_encodeInstr_pos (i : Instr) : 0 < (encodeInstr i).length := by
  cases i <;> simp [encodeInstr]

/-- An instruction sequence is at least as long, in bytes, as it is in
instructions. -/
theorem length_le_flatMap_encodeInstr (is : List Instr) :
    is.length ≤ (is.flatMap encodeInstr).length := by
  induction is with
  | nil => simp
  | cons i is ih =>
    have := length_encodeInstr_pos i
    simp only [List.flatMap_cons, List.length_append, List.length_cons]
    omega

/-- The constants of an instruction fit in a signed 32-bit LEB128 word. -/
def constOk : Instr → Bool
  | .const n => n < 2147483648
  | _ => true

/-- One instruction is read back exactly. -/
theorem decodeInstr_encodeInstr (i : Instr) (h : constOk i) :
    ∀ rest, decodeInstr (encodeInstr i ++ rest) = some (i, rest) := by
  intro rest
  cases i with
  | const n =>
      have hn : n % 2147483648 = n := Nat.mod_eq_of_lt (by simpa [constOk] using h)
      simp [encodeInstr, decodeInstr, hn, slebDecode_slebNat]
  | localGet j => simp [encodeInstr, decodeInstr, ulebDecode_uleb]
  | call f => simp [encodeInstr, decodeInstr, ulebDecode_uleb]
  | _ => simp [encodeInstr, decodeInstr]

/-- No instruction starts with the `end` opcode, so a body cannot be misframed. -/
theorem encodeInstr_cons (i : Instr) :
    ∃ b bs, encodeInstr i = b :: bs ∧ b ≠ 0x0b := by
  cases i
  case const n => exact ⟨0x41, _, rfl, by decide⟩
  case localGet j => exact ⟨0x20, _, rfl, by decide⟩
  case add => exact ⟨0x6a, _, rfl, by decide⟩
  case mul => exact ⟨0x6c, _, rfl, by decide⟩
  case sub => exact ⟨0x6b, _, rfl, by decide⟩
  case divU => exact ⟨0x6e, _, rfl, by decide⟩
  case leU => exact ⟨0x4d, _, rfl, by decide⟩
  case eqz => exact ⟨0x45, _, rfl, by decide⟩
  case select => exact ⟨0x1b, _, rfl, by decide⟩
  case call f => exact ⟨0x10, _, rfl, by decide⟩

/-- One step of the body reader. -/
theorem decodeInstrs_succ (f : Nat) (b : UInt8) (bs : List UInt8) (hne : b ≠ 0x0b) :
    decodeInstrs (f + 1) (b :: bs) =
      match decodeInstr (b :: bs) with
      | none => none
      | some (i, rest) =>
          match decodeInstrs f rest with
          | none => none
          | some (is, rest') => some (i :: is, rest') := by
  simp [decodeInstrs, hne]

/-- A function body is read back exactly. -/
theorem decodeInstrs_encode (is : List Instr) (h : ∀ i ∈ is, constOk i) :
    ∀ (f : Nat), is.length < f → ∀ rest,
      decodeInstrs f (is.flatMap encodeInstr ++ 0x0b :: rest) = some (is, rest) := by
  induction is with
  | nil =>
      intro f hf rest
      cases f with
      | zero => simp at hf
      | succ f => simp [decodeInstrs]
  | cons i is ih =>
      intro f hf rest
      cases f with
      | zero => simp at hf
      | succ f =>
        obtain ⟨b, bs, hbs, hne⟩ := encodeInstr_cons i
        have hi : constOk i := h i (by simp)
        have htail : ∀ j ∈ is, constOk j := fun j hj => h j (by simp [hj])
        have hlen : is.length < f := by simpa using hf
        have key : decodeInstr (encodeInstr i ++ (is.flatMap encodeInstr ++ 0x0b :: rest))
            = some (i, is.flatMap encodeInstr ++ 0x0b :: rest) :=
          decodeInstr_encodeInstr i hi _
        rw [List.flatMap_cons, List.append_assoc, hbs] at *
        rw [List.cons_append, decodeInstrs_succ f b _ hne, ← List.cons_append, key]
        simp [ih htail f hlen rest]

/-! ## Vectors and sections -/

/-- Reading a fixed number of items. -/
def decodeVec {α : Type} (dec : List UInt8 → Option (α × List UInt8)) :
    Nat → List UInt8 → Option (List α × List UInt8)
  | 0, bs => some ([], bs)
  | n + 1, bs =>
      match dec bs with
      | none => none
      | some (a, bs') =>
          match decodeVec dec n bs' with
          | none => none
          | some (as, bs'') => some (a :: as, bs'')

/-- Reading a whole payload as a vector: a count, then exactly that many items,
with nothing left over. -/
def decodeVecAll {α : Type} (dec : List UInt8 → Option (α × List UInt8))
    (bs : List UInt8) : Option (List α) :=
  match ulebDecode bs with
  | none => none
  | some (n, rest) =>
      match decodeVec dec n rest with
      | some (as, []) => some as
      | _ => none

/-- Reading a section with the expected id, honouring its declared length. -/
def decodeSection (id : Nat) : List UInt8 → Option (List UInt8 × List UInt8)
  | [] => none
  | b :: bs =>
      if b.toNat = id then
        match ulebDecode bs with
        | none => none
        | some (n, rest) =>
            if n ≤ rest.length then some (rest.take n, rest.drop n) else none
      else none

/-- A vector is read back exactly, given that its elements are. -/
theorem decodeVec_map {α : Type} (dec : List UInt8 → Option (α × List UInt8))
    (enc : α → List UInt8) (xs : List α)
    (h : ∀ x ∈ xs, ∀ r, dec (enc x ++ r) = some (x, r)) :
    ∀ rest, decodeVec dec xs.length ((xs.map enc).flatten ++ rest) = some (xs, rest) := by
  induction xs with
  | nil => intro rest; simp [decodeVec]
  | cons x xs ih =>
      intro rest
      have hx : dec (enc x ++ ((xs.map enc).flatten ++ rest)) = some (x, (xs.map enc).flatten ++ rest) :=
        h x (by simp) _
      have htail : ∀ y ∈ xs, ∀ r, dec (enc y ++ r) = some (y, r) := fun y hy => h y (by simp [hy])
      simp only [List.length_cons, List.map_cons, List.flatten_cons, List.append_assoc,
        decodeVec, hx]
      simp [ih htail rest]

/-- A whole vector payload is read back exactly. -/
theorem decodeVecAll_wvec {α : Type} (dec : List UInt8 → Option (α × List UInt8))
    (enc : α → List UInt8) (xs : List α)
    (h : ∀ x ∈ xs, ∀ r, dec (enc x ++ r) = some (x, r)) :
    decodeVecAll dec (wvec (xs.map enc)) = some xs := by
  have hlen : (xs.map enc).length = xs.length := by simp
  have := decodeVec_map dec enc xs h []
  simp only [List.append_nil] at this
  simp [decodeVecAll, wvec, hlen, ulebDecode_uleb, this]

/-- A section is read back exactly, payload and all. -/
theorem decodeSection_wsection (id : Nat) (hid : id < 256) (payload rest : List UInt8) :
    decodeSection id (wsection id payload ++ rest) = some (payload, rest) := by
  have hb : (UInt8.ofNat id).toNat = id := by simp [Nat.mod_eq_of_lt hid]
  simp only [wsection, List.cons_append, decodeSection, hb, List.append_assoc,
    ulebDecode_uleb]
  simp

/-! ## The pieces of a module -/

/-- Skipping a run of `i32` value types. -/
def dropReps : Nat → List UInt8 → Option (List UInt8)
  | 0, bs => some bs
  | _ + 1, [] => none
  | n + 1, b :: bs => if b = i32 then dropReps n bs else none

theorem dropReps_replicate (n : Nat) (rest : List UInt8) :
    dropReps n (List.replicate n i32 ++ rest) = some rest := by
  induction n with
  | zero => simp [dropReps]
  | succ n ih => simp [List.replicate_succ, dropReps, ih]

/-- Reading a function type. -/
def decodeFType : List UInt8 → Option ((Nat × Nat) × List UInt8)
  | [] => none
  | b :: bs =>
      if b = 0x60 then
        match ulebDecode bs with
        | none => none
        | some (n, bs1) =>
            match dropReps n bs1 with
            | none => none
            | some bs2 =>
                match ulebDecode bs2 with
                | none => none
                | some (m, bs3) =>
                    match dropReps m bs3 with
                    | none => none
                    | some bs4 => some ((n, m), bs4)
      else none

theorem decodeFType_ftype (n m : Nat) (rest : List UInt8) :
    decodeFType (ftype n m ++ rest) = some ((n, m), rest) := by
  simp only [ftype, List.cons_append, decodeFType, List.append_assoc, ulebDecode_uleb,
    dropReps_replicate]
  rfl

/-- Reading a name. -/
def decodeName : List UInt8 → Option (String × List UInt8) := fun bs =>
  match ulebDecode bs with
  | none => none
  | some (n, rest) =>
      if n ≤ rest.length then
        some (String.ofList ((rest.take n).map (fun b => Char.ofNat b.toNat)), rest.drop n)
      else none

theorem decodeName_encodeName (s : String) (h : ∀ c ∈ s.toList, c.toNat < 128)
    (rest : List UInt8) : decodeName (encodeName s ++ rest) = some (s, rest) := by
  have hmap : (s.toList.map (fun c => UInt8.ofNat c.toNat)).map (fun b => Char.ofNat b.toNat)
      = s.toList := by
    rw [List.map_map]
    refine Eq.trans (List.map_congr_left ?_) (List.map_id _)
    intro c hc
    have hc' : c.toNat < 256 := by have := h c hc; omega
    simp [Function.comp, Nat.mod_eq_of_lt hc', Char.ofNat_toNat]
  simp [encodeName, decodeName, ulebDecode_uleb, hmap, String.ofList_toList]

/-- Reading an export entry: a name, the kind byte `0x00` for a function, and
the function index. -/
def decodeExport : List UInt8 → Option ((String × Nat) × List UInt8) := fun bs =>
  match decodeName bs with
  | none => none
  | some (nm, rest) =>
      match rest with
      | [] => none
      | b :: rest' =>
          if b = 0x00 then
            match ulebDecode rest' with
            | none => none
            | some (i, rest'') => some ((nm, i), rest'')
          else none

theorem decodeExport_encode (p : String × Nat) (h : ∀ c ∈ p.1.toList, c.toNat < 128)
    (rest : List UInt8) :
    decodeExport ((encodeName p.1 ++ [0x00] ++ uleb p.2) ++ rest) = some (p, rest) := by
  simp only [List.append_assoc, decodeExport, decodeName_encodeName p.1 h, List.cons_append,
    List.nil_append, ulebDecode_uleb]
  simp

/-- The bytes of a function body, as a function of the instructions alone. -/
def encodeCode (is : List Instr) : List UInt8 :=
  let code := uleb 0 ++ is.flatMap encodeInstr ++ [0x0b]
  uleb code.length ++ code

theorem encodeBody_eq (fn : Func) : encodeBody fn = encodeCode fn.body := rfl

/-- Reading a function body. -/
def decodeBody : List UInt8 → Option (List Instr × List UInt8) := fun bs =>
  match ulebDecode bs with
  | none => none
  | some (n, rest) =>
      if n ≤ rest.length then
        match ulebDecode (rest.take n) with
        | some (0, code) =>
            match decodeInstrs (code.length + 1) code with
            | some (is, []) => some (is, rest.drop n)
            | _ => none
        | _ => none
      else none

theorem decodeBody_encodeCode (is : List Instr) (h : ∀ i ∈ is, constOk i) (rest : List UInt8) :
    decodeBody (encodeCode is ++ rest) = some (is, rest) := by
  have hlen := length_le_flatMap_encodeInstr is
  set body := is.flatMap encodeInstr ++ [(0x0b : UInt8)] with hbodydef
  have hblen : (is.flatMap encodeInstr).length ≤ body.length := by
    simp [hbodydef]
  have hbody : decodeInstrs (body.length + 1) body = some (is, []) := by
    have h1 : is.length < body.length + 1 := by omega
    have := decodeInstrs_encode is h (body.length + 1) h1 []
    simpa [hbodydef] using this
  set code := (uleb 0 : List UInt8) ++ body with hcode
  have hEnc : encodeCode is ++ rest = uleb code.length ++ (code ++ rest) := by
    simp [encodeCode, hcode, hbodydef, List.append_assoc]
  have hcode0 : ulebDecode code = some (0, body) := by
    rw [hcode]; exact ulebDecode_uleb 0 body
  have htake : (code ++ rest).take code.length = code := by simp
  have hdrop : (code ++ rest).drop code.length = rest := by simp
  rw [hEnc]
  simp only [decodeBody, ulebDecode_uleb, htake, hdrop, hcode0, if_pos (by simp :
    code.length ≤ (code ++ rest).length)]
  simp [hbody]

/-! ## Putting a module back together -/

/-- Rebuilding the functions of a module from the four decoded sections. -/
def assemble (types : List (Nat × Nat)) :
    List Nat → List (String × Nat) → List (List Instr) → Option Module
  | [], [], [] => some []
  | t :: ts, e :: es, b :: bs =>
      match types[t]? with
      | none => none
      | some (a, r) =>
          match assemble types ts es bs with
          | none => none
          | some M => some (⟨e.1, a, r, b⟩ :: M)
  | _, _, _ => none

theorem assemble_of_module (T : List (Nat × Nat)) (idx : Func → Nat) (L : Module)
    (hT : ∀ fn ∈ L, T[idx fn]? = some (typeOf fn))
    (es : List (String × Nat)) (hes : es.map Prod.fst = L.map Func.name) :
    assemble T (L.map idx) es (L.map Func.body) = some L := by
  induction L generalizing es with
  | nil =>
      have : es = [] := by
        cases es with
        | nil => rfl
        | cons e es => simp at hes
      subst this
      rfl
  | cons fn L ih =>
      cases es with
      | nil => simp at hes
      | cons e es =>
          have hname : e.1 = fn.name := by simpa using congrArg (fun l => l.headI) hes
          have hes' : es.map Prod.fst = L.map Func.name := by simpa using congrArg List.tail hes
          have hT' : ∀ g ∈ L, T[idx g]? = some (typeOf g) := fun g hg => hT g (by simp [hg])
          have hfn : T[idx fn]? = some (typeOf fn) := hT fn (by simp)
          simp only [List.map_cons, assemble, hfn, typeOf, ih hT' es hes', hname]

/-- Every function's type is where its type index says it is. -/
theorem getElem?_moduleTypes (M : Module) (fn : Func) (h : fn ∈ M) :
    (moduleTypes M)[typeIndexOf M fn]? = some (typeOf fn) := by
  have hmem : typeOf fn ∈ moduleTypes M := by
    simp [moduleTypes, List.mem_dedup]
    exact ⟨fn, h, rfl⟩
  exact List.getElem?_idxOf hmem

/-! ## The decoder -/

/-- Reading a whole module: magic number, then the type, function, export and
code sections, then nothing. -/
def decodeModule (bs : List UInt8) : Option Module :=
  if bs.take 8 = [0x00, 0x61, 0x73, 0x6d, 0x01, 0x00, 0x00, 0x00] then
    match decodeSection 1 (bs.drop 8) with
    | none => none
    | some (tsec, r1) =>
        match decodeSection 3 r1 with
        | none => none
        | some (fsec, r2) =>
            match decodeSection 7 r2 with
            | none => none
            | some (esec, r3) =>
                match decodeSection 10 r3 with
                | none => none
                | some (csec, r4) =>
                    if r4.isEmpty then
                      match decodeVecAll decodeFType tsec, decodeVecAll ulebDecode fsec,
                            decodeVecAll decodeExport esec, decodeVecAll decodeBody csec with
                      | some types, some tyidx, some exports, some bodies =>
                          assemble types tyidx exports bodies
                      | _, _, _, _ => none
                    else none
  else none

/-- **The bytes are the module.** Decoding the emitted binary returns exactly
the module that was encoded, provided the export names are ASCII and the
constants in the code fit in a signed 32-bit LEB128 word (`constOk`) — both of which hold
for everything the board emits. -/
theorem decodeModule_encodeModule (M : Module)
    (hname : ∀ fn ∈ M, ∀ c ∈ fn.name.toList, c.toNat < 128)
    (hconst : ∀ fn ∈ M, ∀ i ∈ fn.body, constOk i) :
    decodeModule (encodeModule M) = some M := by
  classical
  set types := moduleTypes M with htypes
  set exs := M.zipIdx.map (fun p => (p.1.name, p.2)) with hexs
  set tsec := wvec (types.map (fun p => ftype p.1 p.2)) with htsec
  set fsec := wvec (M.map (fun fn => uleb (typeIndexOf M fn))) with hfsec
  set esec := wvec (M.zipIdx.map (fun p => encodeName p.1.name ++ [(0x00 : UInt8)] ++ uleb p.2))
    with hesec
  set csec := wvec (M.map encodeBody) with hcsec
  -- the bytes, reassociated
  have henc : encodeModule M =
      [0x00, 0x61, 0x73, 0x6d, 0x01, 0x00, 0x00, 0x00] ++
        (wsection 1 tsec ++ (wsection 3 fsec ++ (wsection 7 esec ++ wsection 10 csec))) := by
    simp [encodeModule, htsec, hfsec, hesec, hcsec, htypes, List.append_assoc]
  have htake : (encodeModule M).take 8 = [0x00, 0x61, 0x73, 0x6d, 0x01, 0x00, 0x00, 0x00] := by
    rw [henc]; simp
  have hdrop : (encodeModule M).drop 8 =
      wsection 1 tsec ++ (wsection 3 fsec ++ (wsection 7 esec ++ wsection 10 csec)) := by
    rw [henc]; simp
  -- the four sections
  have hs1 := decodeSection_wsection 1 (by norm_num) tsec
    (wsection 3 fsec ++ (wsection 7 esec ++ wsection 10 csec))
  have hs3 := decodeSection_wsection 3 (by norm_num) fsec (wsection 7 esec ++ wsection 10 csec)
  have hs7 := decodeSection_wsection 7 (by norm_num) esec (wsection 10 csec)
  have hs10 := decodeSection_wsection 10 (by norm_num) csec []
  rw [List.append_nil] at hs10
  -- the four vectors
  have hv1 : decodeVecAll decodeFType tsec = some types :=
    decodeVecAll_wvec decodeFType (fun p => ftype p.1 p.2) types
      (fun p _ r => decodeFType_ftype p.1 p.2 r)
  have hv3 : decodeVecAll ulebDecode fsec = some (M.map (typeIndexOf M)) := by
    have hmap : M.map (fun fn => uleb (typeIndexOf M fn))
        = (M.map (typeIndexOf M)).map uleb := by simp [List.map_map, Function.comp]
    rw [hfsec, hmap]
    exact decodeVecAll_wvec ulebDecode uleb _ (fun x _ r => ulebDecode_uleb x r)
  have hv7 : decodeVecAll decodeExport esec = some exs := by
    have hmap : M.zipIdx.map (fun p => encodeName p.1.name ++ [(0x00 : UInt8)] ++ uleb p.2)
        = exs.map (fun q => encodeName q.1 ++ [(0x00 : UInt8)] ++ uleb q.2) := by
      simp [hexs, List.map_map, Function.comp]
    rw [hesec, hmap]
    refine decodeVecAll_wvec decodeExport _ exs ?_
    intro q hq r
    refine decodeExport_encode q ?_ r
    rw [hexs] at hq
    obtain ⟨pr, hpr, rfl⟩ := List.mem_map.1 hq
    exact hname pr.1 (List.fst_mem_of_mem_zipIdx hpr)
  have hv10 : decodeVecAll decodeBody csec = some (M.map Func.body) := by
    have hmap : M.map encodeBody = (M.map Func.body).map encodeCode := by
      simp [List.map_map, Function.comp, encodeBody_eq]
    rw [hcsec, hmap]
    refine decodeVecAll_wvec decodeBody encodeCode _ ?_
    intro is his r
    obtain ⟨fn, hfn, rfl⟩ := List.mem_map.1 his
    exact decodeBody_encodeCode fn.body (hconst fn hfn) r
  -- reassembling
  have hasm : assemble types (M.map (typeIndexOf M)) exs (M.map Func.body) = some M := by
    refine assemble_of_module types (typeIndexOf M) M ?_ exs ?_
    · intro fn hfn
      exact getElem?_moduleTypes M fn hfn
    · rw [hexs, List.map_map,
        show Prod.fst ∘ (fun p : Func × Nat => (p.1.name, p.2)) = Func.name ∘ Prod.fst from rfl,
        ← List.map_map, List.zipIdx_map_fst]
  rw [decodeModule, if_pos htake, hdrop]
  simp only [hs1, hs3, hs7, hs10, List.isEmpty_nil, if_true, hv1, hv3, hv7, hv10, hasm]

/-! ## The file the page ships -/

/-- Every export name of the board is ASCII. -/
theorem board_names_ascii : ∀ fn ∈ board, ∀ c ∈ fn.name.toList, c.toNat < 128 := by
  have h : board.all (fun fn => fn.name.toList.all (fun c => decide (c.toNat < 128))) = true := rfl
  simpa using h

/-- **`www/nixwars.wasm` is the board.** The concrete bytes written to disk and
embedded in the page decode to exactly the module the correctness theorems
`wasm_step_correct` and `wasm_dash_step_correct` are about. -/
theorem decodeModule_wasmBytes : decodeModule wasmBytes = some board :=
  decodeModule_encodeModule board board_names_ascii (by decide)

end Wasm
end NixWars
