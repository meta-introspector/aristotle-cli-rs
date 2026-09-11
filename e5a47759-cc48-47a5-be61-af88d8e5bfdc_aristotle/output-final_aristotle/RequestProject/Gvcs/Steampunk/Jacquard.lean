import RequestProject.Gvcs.Printer.SelfPrint
import Mathlib.Tactic

/-!
# The Jacquard loom as the machine's program store

The fluidic controller of `RequestProject/Steampunk/Fluidic.lean` computes, but
it does not remember.  This file supplies the memory: a **Jacquard card
chain**, the 1804 punched-card program store, read by needles and — this is the
point — *re-punchable from the cloth the loom weaves*.

Three things are proved.

* **The loom is lossless exactly when its comber board is onto.**  A loom is a
  tie-up `tie : Fin warp → Fin needles` saying which needle lifts which warp
  thread.  `punchRow_weaveRow` recovers the card from the woven pick when `tie`
  is surjective, so the chain can be read back off the cloth
  (`loom_self_hosting`); `weave_not_injective_of_not_surjective` shows that if
  some needle drives no warp thread then two different cards weave the same
  cloth and the program is *not* recoverable.  Self-hosting is a condition on
  the machine, not a slogan.

* **A printer job fits on cards.**  `encodeInstr` punches one instruction of
  `RequestProject/Printer/Machine.lean` onto one card of `cardWidth = 71`
  columns — a three-column opcode and four sixteen-bit signed fields — and
  `decodeInstr_encodeInstr` reads it back, provided the numbers fit in the
  fields (`Fits`).  Real Jacquard cards carried several hundred hole positions,
  so seventy-one columns is a small card.

* **End to end.**  `jacquard_roundtrip`: punch the job, weave the cloth, punch
  the cloth back into cards, read the cards — you get the job you started with.
  `selfPrint_chain_length` and `selfPrint_jacquard_roundtrip` instantiate this
  at the printer's own self-print job: **910 cards**, recovered exactly.

Nothing here is electronic.  Cards are pasteboard, needles are wire, the
cylinder is wood.
-/

namespace LifeTrac
namespace Steampunk

open LifeTrac.Printer

/-! ## The loom -/

/-- A Jacquard head: `needles` hole positions across a card, `warp` threads in
the cloth, and a comber board `tie` saying which needle lifts which thread. -/
structure Loom where
  /-- Hole positions across one card. -/
  needles : ℕ
  /-- Warp threads in the cloth. -/
  warp : ℕ
  /-- The comber board: warp thread `j` is lifted by needle `tie j`. -/
  tie : Fin warp → Fin needles

/-- A punched card: which of the `n` hole positions are open. -/
abbrev Card (n : ℕ) := Fin n → Bool

/-- One pick of cloth: which of the `w` warp threads were lifted. -/
abbrev Pick (w : ℕ) := Fin w → Bool

/-- Weaving one pick: a thread is lifted when its needle finds a hole. -/
def Loom.weaveRow (L : Loom) (c : Card L.needles) : Pick L.warp :=
  fun j => c (L.tie j)

/-- Weaving a whole card chain: one pick per card. -/
def Loom.weave (L : Loom) (chain : List (Card L.needles)) : List (Pick L.warp) :=
  chain.map L.weaveRow

/-- Reading a pick of cloth back as a card, using a right inverse of the
comber board: to find whether needle `i` was punched, look at any warp thread
that needle `i` drives. -/
noncomputable def Loom.punchRow (L : Loom) (hs : Function.Surjective L.tie)
    (r : Pick L.warp) : Card L.needles :=
  fun i => r (Function.surjInv hs i)

/-- Re-punching a whole bolt of cloth into a card chain. -/
noncomputable def Loom.punch (L : Loom) (hs : Function.Surjective L.tie)
    (cloth : List (Pick L.warp)) : List (Card L.needles) :=
  cloth.map (L.punchRow hs)

/-- **The cloth remembers the card.**  If every needle drives at least one warp
thread, the card is recovered from the pick it wove. -/
theorem Loom.punchRow_weaveRow (L : Loom) (hs : Function.Surjective L.tie)
    (c : Card L.needles) : L.punchRow hs (L.weaveRow c) = c := by
  funext i
  simp [Loom.punchRow, Loom.weaveRow, Function.surjInv_eq hs i]

/-- **A self-hosting loom.**  The card chain is recovered from the cloth it
wove, so a loom with an onto comber board can re-punch its own program. -/
theorem loom_self_hosting (L : Loom) (hs : Function.Surjective L.tie)
    (chain : List (Card L.needles)) : L.punch hs (L.weave chain) = chain := by
  simp [Loom.punch, Loom.weave, List.map_map, Function.comp_def,
    L.punchRow_weaveRow hs]

/-- **And it is really a condition.**  If some needle drives no warp thread
then two different cards weave identical cloth, and no machine can recover the
program from the pattern. -/
theorem weave_not_injective_of_not_surjective (L : Loom)
    (hs : ¬ Function.Surjective L.tie) :
    ∃ c c' : Card L.needles, c ≠ c' ∧ L.weaveRow c = L.weaveRow c' := by
  simp only [Function.Surjective, not_forall] at hs
  obtain ⟨i, hi⟩ := hs
  push_neg at hi
  refine ⟨fun _ => false, fun k => decide (k = i), ?_, ?_⟩
  · intro h
    have := congrFun h i
    simp at this
  · funext j
    have : L.tie j ≠ i := hi j
    simp [Loom.weaveRow, this]

/-! ## Cards as rows of holes

The loom above works with cards as functions; the code below punches them as
lists of holes.  These two lemmas move between the two. -/

/-- Read a list of holes as a card of width `n`. -/
def toCard (n : ℕ) (l : List Bool) : Card n := fun i => l.getD i false

/-- Write a card of width `n` out as a list of holes. -/
def ofCard {n : ℕ} (c : Card n) : List Bool := List.ofFn c

@[simp] theorem ofCard_toCard {n : ℕ} {l : List Bool} (h : l.length = n) :
    ofCard (toCard n l) = l := by
  subst h
  apply List.ext_getElem
  · simp [ofCard]
  · intro i h1 h2
    simp only [ofCard, toCard, List.getElem_ofFn, List.getD_eq_getElem?_getD]
    rw [List.getElem?_eq_getElem h2]
    rfl

/-! ## Punching numbers

Little-endian, fixed width: `writeNat k n` is `k` columns, `writeInt k z` is a
sign column and `k` magnitude columns.  The readers are prefix parsers, so
fields concatenate. -/

/-- `k` columns holding `n` in binary, least significant first. -/
def writeNat : ℕ → ℕ → List Bool
  | 0, _ => []
  | k + 1, n => (n % 2 == 1) :: writeNat k (n / 2)

/-- Read `k` columns as a number, returning the rest of the card. -/
def readNat : ℕ → List Bool → Option (ℕ × List Bool)
  | 0, l => some (0, l)
  | _ + 1, [] => none
  | k + 1, b :: l => (readNat k l).map (fun p => ((if b then 1 else 0) + 2 * p.1, p.2))

@[simp] theorem writeNat_length (k n : ℕ) : (writeNat k n).length = k := by
  induction k generalizing n with
  | zero => rfl
  | succ k ih => simp [writeNat, ih]

theorem readNat_writeNat (k n : ℕ) (rest : List Bool) (h : n < 2 ^ k) :
    readNat k (writeNat k n ++ rest) = some (n, rest) := by
  induction k generalizing n with
  | zero =>
      simp only [pow_zero, Nat.lt_one_iff] at h
      subst h
      rfl
  | succ k ih =>
      have h2 : n / 2 < 2 ^ k := by
        have : 2 ^ (k + 1) = 2 ^ k * 2 := by ring
        omega
      have hif : (if (n % 2 == 1) = true then 1 else 0) = n % 2 := by
        rcases Nat.mod_two_eq_zero_or_one n with hm | hm <;> simp [hm]
      have key : (if (n % 2 == 1) = true then 1 else 0) + 2 * (n / 2) = n := by
        rw [hif]; omega
      simp only [writeNat, List.cons_append]
      rw [readNat, ih (n / 2) h2]
      simp only [Option.map_some, key]

/-- A sign column and `k` magnitude columns. -/
def writeInt (k : ℕ) (z : ℤ) : List Bool := decide (0 ≤ z) :: writeNat k z.natAbs

/-- Read a sign column and `k` magnitude columns. -/
def readInt (k : ℕ) : List Bool → Option (ℤ × List Bool)
  | [] => none
  | b :: l => (readNat k l).map (fun p => (if b then (p.1 : ℤ) else -(p.1 : ℤ), p.2))

theorem readInt_writeInt (k : ℕ) (z : ℤ) (rest : List Bool) (h : z.natAbs < 2 ^ k) :
    readInt k (writeInt k z ++ rest) = some (z, rest) := by
  by_cases hz : 0 ≤ z
  · simp [writeInt, readInt, readNat_writeNat k z.natAbs rest h, hz, Int.natAbs_of_nonneg hz]
  · push_neg at hz
    have hz' : ¬ (0 ≤ z) := not_le.mpr hz
    simp only [writeInt, readInt, List.cons_append, readNat_writeNat k z.natAbs rest h,
      Option.map_some, hz', decide_false, Bool.false_eq_true, if_false,
      Nat.cast_natAbs, Int.cast_id, Option.some.injEq, Prod.mk.injEq, and_true]
    rw [abs_of_neg hz]
    ring

/-! ## One instruction, one card -/

/-- Columns in a numeric field. -/
def fieldWidth : ℕ := 16

/-- Columns across one card: a three-column opcode and four signed fields. -/
def cardWidth : ℕ := 3 + 4 * (1 + fieldWidth)

theorem cardWidth_eq : cardWidth = 71 := by decide

/-- Punch one instruction onto one card. -/
def encodeInstr : Instr → List Bool
  | .home =>
      writeNat 3 0 ++ writeInt fieldWidth 0 ++ writeInt fieldWidth 0 ++
        writeInt fieldWidth 0 ++ writeInt fieldWidth 0
  | .setTemp t =>
      writeNat 3 1 ++ writeInt fieldWidth t ++ writeInt fieldWidth 0 ++
        writeInt fieldWidth 0 ++ writeInt fieldWidth 0
  | .travel p =>
      writeNat 3 2 ++ writeInt fieldWidth p.1 ++ writeInt fieldWidth p.2.1 ++
        writeInt fieldWidth p.2.2 ++ writeInt fieldWidth 0
  | .extrude p =>
      writeNat 3 3 ++ writeInt fieldWidth p.1 ++ writeInt fieldWidth p.2.1 ++
        writeInt fieldWidth p.2.2 ++ writeInt fieldWidth 0
  | .dwell n =>
      writeNat 3 4 ++ writeInt fieldWidth (n : ℤ) ++ writeInt fieldWidth 0 ++
        writeInt fieldWidth 0 ++ writeInt fieldWidth 0

/-- Read one card back as an instruction. -/
def decodeInstr (l : List Bool) : Option Instr := do
  let (t, l) ← readNat 3 l
  let (a, l) ← readInt fieldWidth l
  let (b, l) ← readInt fieldWidth l
  let (c, l) ← readInt fieldWidth l
  let (_, _) ← readInt fieldWidth l
  match t with
  | 0 => some .home
  | 1 => some (.setTemp a)
  | 2 => some (.travel (a, b, c))
  | 3 => some (.extrude (a, b, c))
  | 4 => some (.dwell a.toNat)
  | _ => none

/-- The numbers of an instruction fit in the fields of a card. -/
def Fits : Instr → Prop
  | .home => True
  | .setTemp t => t.natAbs < 2 ^ fieldWidth
  | .travel p => p.1.natAbs < 2 ^ fieldWidth ∧ p.2.1.natAbs < 2 ^ fieldWidth ∧
      p.2.2.natAbs < 2 ^ fieldWidth
  | .extrude p => p.1.natAbs < 2 ^ fieldWidth ∧ p.2.1.natAbs < 2 ^ fieldWidth ∧
      p.2.2.natAbs < 2 ^ fieldWidth
  | .dwell n => n < 2 ^ fieldWidth

@[simp] theorem encodeInstr_length (i : Instr) : (encodeInstr i).length = cardWidth := by
  cases i <;> simp [encodeInstr, writeInt, cardWidth, fieldWidth]

/-- **The card is read back as the instruction punched on it.** -/
theorem decodeInstr_encodeInstr (i : Instr) (h : Fits i) :
    decodeInstr (encodeInstr i) = some i := by
  have hz : (0 : ℤ).natAbs < 2 ^ fieldWidth := by norm_num [fieldWidth]
  have hz0 : readInt fieldWidth (writeInt fieldWidth 0) = some (0, []) := by
    simpa using readInt_writeInt fieldWidth 0 [] hz
  cases i with
  | home =>
      simp [encodeInstr, decodeInstr, List.append_assoc,
        readNat_writeNat 3 0 _ (by norm_num), readInt_writeInt fieldWidth 0 _ hz, hz0]
  | setTemp t =>
      simp [encodeInstr, decodeInstr, List.append_assoc,
        readNat_writeNat 3 1 _ (by norm_num), readInt_writeInt fieldWidth t _ h,
        readInt_writeInt fieldWidth 0 _ hz, hz0]
  | travel p =>
      obtain ⟨h1, h2, h3⟩ := h
      simp [encodeInstr, decodeInstr, List.append_assoc,
        readNat_writeNat 3 2 _ (by norm_num), readInt_writeInt fieldWidth p.1 _ h1,
        readInt_writeInt fieldWidth p.2.1 _ h2, readInt_writeInt fieldWidth p.2.2 _ h3, hz0]
  | extrude p =>
      obtain ⟨h1, h2, h3⟩ := h
      simp [encodeInstr, decodeInstr, List.append_assoc,
        readNat_writeNat 3 3 _ (by norm_num), readInt_writeInt fieldWidth p.1 _ h1,
        readInt_writeInt fieldWidth p.2.1 _ h2, readInt_writeInt fieldWidth p.2.2 _ h3, hz0]
  | dwell n =>
      have hn : ((n : ℤ)).natAbs < 2 ^ fieldWidth := by simpa using h
      simp [encodeInstr, decodeInstr, List.append_assoc,
        readNat_writeNat 3 4 _ (by norm_num), readInt_writeInt fieldWidth (n : ℤ) _ hn,
        readInt_writeInt fieldWidth 0 _ hz, hz0]

/-! ## A whole job on a chain of cards -/

/-- The card chain of a job: one card per instruction. -/
def chainOf (job : List Instr) : List (Card cardWidth) :=
  job.map (fun i => toCard cardWidth (encodeInstr i))

/-- Read a card chain back as a job. -/
def jobOf (chain : List (Card cardWidth)) : Option (List Instr) :=
  chain.mapM (fun c => decodeInstr (ofCard c))

@[simp] theorem chainOf_length (job : List Instr) : (chainOf job).length = job.length := by
  simp [chainOf]

/-- **A job punched onto cards is the job read off them.** -/
theorem jobOf_chainOf (job : List Instr) (h : ∀ i ∈ job, Fits i) :
    jobOf (chainOf job) = some job := by
  induction job with
  | nil => rfl
  | cons i job ih =>
      have hi : Fits i := h i (by simp)
      have hrest : ∀ j ∈ job, Fits j := fun j hj => h j (by simp [hj])
      have hcard : decodeInstr (ofCard (toCard cardWidth (encodeInstr i))) = some i := by
        rw [ofCard_toCard (encodeInstr_length i)]
        exact decodeInstr_encodeInstr i hi
      simp only [jobOf, chainOf, List.map_cons, List.mapM_cons] at ih ⊢
      rw [hcard]
      rw [ih hrest]
      rfl

/-! ## The whole path: cards, cloth, cards -/

/-- **End to end.**  Punch a job onto cards, weave the cloth, re-punch the
cloth into cards, read the cards: the job comes back.  The loom is a program
store that can copy its own program. -/
theorem jacquard_roundtrip {w : ℕ} (tie : Fin w → Fin cardWidth)
    (hs : Function.Surjective tie) (job : List Instr) (h : ∀ i ∈ job, Fits i) :
    jobOf ((Loom.mk cardWidth w tie).punch hs
        ((Loom.mk cardWidth w tie).weave (chainOf job))) = some job := by
  rw [loom_self_hosting (Loom.mk cardWidth w tie) hs]
  exact jobOf_chainOf job h

/-! ## The printer's own job on cards -/

open Voxel

/-- Every instruction of the self-print job fits on a card: the bed is
22 × 24 × 8 cells and the hot end runs at 205 °C. -/
theorem selfPrint_job_fits :
    ∀ i ∈ job d3d 205 printerParts, Fits i := by
  intro i hi
  rw [Printer.job, List.mem_cons, List.mem_cons] at hi
  rcases hi with rfl | rfl | hi
  · trivial
  · norm_num [Fits, fieldWidth]
  · rw [List.mem_map] at hi
    obtain ⟨v, hv, rfl⟩ := hi
    have hmem := ((mem_enum d3d.env printerParts v).1 hv).2
    rw [Envelope.mem_iff] at hmem
    obtain ⟨⟨hx0, hx1⟩, ⟨hy0, hy1⟩, hz0, hz1⟩ := hmem
    have h216 : (2 : ℕ) ^ fieldWidth = 65536 := by norm_num [fieldWidth]
    simp only [Vox.x, Vox.y, Vox.z, d3d] at hx0 hx1 hy0 hy1 hz0 hz1
    refine ⟨?_, ?_, ?_⟩ <;> rw [h216] <;> omega

/-- The self-print job is a chain of **910 cards** — one to home, one to heat,
and 908 to lay down the 908 cells of plastic. -/
theorem selfPrint_chain_length :
    (chainOf (job d3d 205 printerParts)).length = 910 := by
  rw [chainOf_length, Printer.job]
  simp [printerParts_cells]

/-- **The printer's own program survives the loom.**  Punched onto cards, woven
into cloth and re-punched, the self-print job of
`RequestProject/Printer/SelfPrint.lean` comes back unchanged. -/
theorem selfPrint_jacquard_roundtrip {w : ℕ} (tie : Fin w → Fin cardWidth)
    (hs : Function.Surjective tie) :
    jobOf ((Loom.mk cardWidth w tie).punch hs
        ((Loom.mk cardWidth w tie).weave (chainOf (job d3d 205 printerParts)))) =
      some (job d3d 205 printerParts) :=
  jacquard_roundtrip tie hs _ selfPrint_job_fits

end Steampunk
end LifeTrac
