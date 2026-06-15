import Mathlib

/-!
# The Altland–Zirnbauer "tenfold way"

This file builds a self-contained, machine-checked model of the
**Altland–Zirnbauer (AZ) symmetry classification** of non-interacting fermionic
systems — the "tenfold way" — together with the associated *periodic table of
topological insulators and superconductors* (Kitaev; Schnyder–Ryu–Furusaki–Ludwig).

The model has three layers.

1. **The ten symmetry classes.** Each Altland–Zirnbauer class is characterised by
   the behaviour of the Hamiltonian under three non-spatial symmetries:
   * time–reversal `T` (antiunitary, `T² = ±1`, or absent),
   * particle–hole / charge conjugation `C` (antiunitary, `C² = ±1`, or absent),
   * chiral / sublattice symmetry `S = T·C` (present or absent).
   We encode `T, C ∈ {-1, 0, +1}` (with `0` meaning "absent") and `S ∈ {0, 1}`.
   There are exactly ten consistent combinations — the ten Cartan labels
   `A, AIII, AI, BDI, D, DIII, AII, CII, C, CI`.

2. **The classifying groups.** The topological invariant of a gapped phase in a
   given class and spatial dimension is one of the four abelian groups
   `0, ℤ, ℤ₂, 2ℤ`, encoded by `KGroup`.

3. **The periodic table.** `classify c d` gives the classifying group of class `c`
   in spatial dimension `d`.  The two *complex* classes (`A`, `AIII`) are governed
   by period-2 Bott periodicity; the eight *real* classes are governed by period-8
   Bott periodicity.  We prove these periodicities, verify the entire table
   against its standard values, and prove the celebrated fact that **in every
   spatial dimension exactly five of the ten classes are topologically
   non-trivial**.
-/

namespace AZ

open scoped Classical
open Finset

/-- The four abelian groups that occur as topological-invariant groups in the
periodic table: the trivial group `0` (`null`), the integers `ℤ`, the two–element
group `ℤ₂`, and the even integers `2ℤ` (abstractly `≅ ℤ`, but a distinct entry of
the table). -/
inductive KGroup
  | null
  | Z
  | Z2
  | twoZ
deriving DecidableEq, Repr

/-- The ten Altland–Zirnbauer symmetry classes, labelled by their Cartan names. -/
inductive Class
  | A | AIII | AI | BDI | D | DIII | AII | CII | C | CI
deriving DecidableEq, Fintype, Repr

namespace Class

/-! ## Symmetry data of each class

`trs c`, `phs c`, `chiral c` record the values of `T²`, `C²` and the chiral flag
for the class `c`.  Here `0` means "the symmetry is absent". -/

/-- Time-reversal symmetry datum `T² ∈ {-1, 0, +1}` (`0` = absent). -/
def trs : Class → ℤ
  | A => 0 | AIII => 0
  | AI => 1 | BDI => 1 | D => 0 | DIII => -1
  | AII => -1 | CII => -1 | C => 0 | CI => 1

/-- Particle-hole symmetry datum `C² ∈ {-1, 0, +1}` (`0` = absent). -/
def phs : Class → ℤ
  | A => 0 | AIII => 0
  | AI => 0 | BDI => 1 | D => 1 | DIII => 1
  | AII => 0 | CII => -1 | C => -1 | CI => -1

/-- Chiral (sublattice) symmetry flag `S ∈ {0, 1}` (`1` = present). -/
def chiral : Class → ℕ
  | A => 0 | AIII => 1
  | AI => 0 | BDI => 1 | D => 0 | DIII => 1
  | AII => 0 | CII => 1 | C => 0 | CI => 1

/-- A class is *complex* (belongs to the complex / unitary subseries, classes
`A` and `AIII`) iff it has neither time-reversal nor particle-hole symmetry. -/
def isComplex : Class → Bool
  | A => true | AIII => true | _ => false

/-! ## Bott clocks (Cartan–Bott indices)

The complex classes are placed on a `ℤ₂`-clock, the real classes on a `ℤ₈`-clock.
These indices encode the position of each class in Bott periodicity. -/

/-- Position of a complex class on the `ℤ₂` Bott clock. -/
def complexIndex : Class → ZMod 2
  | AIII => 1 | _ => 0

/-- Position of a real class on the `ℤ₈` Bott clock. -/
def realIndex : Class → ZMod 8
  | AI => 0 | BDI => 1 | D => 2 | DIII => 3
  | AII => 4 | CII => 5 | C => 6 | CI => 7 | _ => 0

end Class

/-! ## The periodic table -/

/-- The period-8 pattern of classifying groups for the real series, as a function
of the Bott index `(realIndex c) - d` taken in `ℤ₈`. -/
def realPattern (n : ZMod 8) : KGroup :=
  if n = 0 then KGroup.Z
  else if n = 1 then KGroup.Z2
  else if n = 2 then KGroup.Z2
  else if n = 4 then KGroup.twoZ
  else KGroup.null

/-- The period-2 pattern of classifying groups for the complex series, as a
function of the Bott index `(complexIndex c) - d` taken in `ℤ₂`. -/
def complexPattern (n : ZMod 2) : KGroup :=
  if n = 0 then KGroup.Z else KGroup.null

/-- `classify c d` is the group of topological invariants of a gapped phase in
Altland–Zirnbauer class `c` in spatial dimension `d`: the periodic table of
topological insulators and superconductors. -/
def classify (c : Class) (d : ℕ) : KGroup :=
  if c.isComplex then complexPattern (c.complexIndex - (d : ZMod 2))
  else realPattern (c.realIndex - (d : ZMod 8))

/-! ## Basic structural facts about the ten classes -/

/-- There are exactly ten Altland–Zirnbauer symmetry classes. -/
theorem card_classes : Fintype.card Class = 10 := by decide

/-- Exactly two classes are complex (`A` and `AIII`). -/
theorem card_complex :
    (Finset.univ.filter (fun c : Class => c.isComplex = true)).card = 2 := by decide

/-- Exactly eight classes are real. -/
theorem card_real :
    (Finset.univ.filter (fun c : Class => c.isComplex = false)).card = 8 := by decide

/-- Each class is uniquely determined by its symmetry data `(T², C², S)`:
the assignment `c ↦ (trs c, phs c, chiral c)` is injective. -/
theorem symmetryData_injective :
    Function.Injective (fun c : Class => (c.trs, c.phs, c.chiral)) := by decide

/-- The chiral symmetry is *forced present* whenever both time-reversal and
particle-hole symmetries are present. -/
theorem chiral_of_both (c : Class) (hT : c.trs ≠ 0) (hC : c.phs ≠ 0) :
    c.chiral = 1 := by
  cases c <;> simp_all [Class.trs, Class.phs, Class.chiral]

/-- If exactly one of time-reversal / particle-hole is present, the chiral
symmetry is absent. -/
theorem chiral_absent_of_one (c : Class)
    (h : (c.trs ≠ 0 ∧ c.phs = 0) ∨ (c.trs = 0 ∧ c.phs ≠ 0)) :
    c.chiral = 0 := by
  cases c <;> simp_all [Class.trs, Class.phs, Class.chiral]

/-- When neither time-reversal nor particle-hole is present, the class is exactly
`A` (no chiral symmetry) or `AIII` (chiral symmetry present). -/
theorem complex_dichotomy (c : Class) (hT : c.trs = 0) (hC : c.phs = 0) :
    c = Class.A ∨ c = Class.AIII := by
  cases c <;> simp_all [Class.trs, Class.phs]

/-! ## Bott periodicity -/

/-- **Bott periodicity (period 8).** The classifying group of every class is
invariant under shifting the spatial dimension by `8`. -/
theorem classify_periodic8 (c : Class) (d : ℕ) :
    classify c (d + 8) = classify c d := by
  have h2 : ((d + 8 : ℕ) : ZMod 2) = (d : ZMod 2) := by
    push_cast; rw [show (8 : ZMod 2) = 0 from by decide]; ring
  have h8 : ((d + 8 : ℕ) : ZMod 8) = (d : ZMod 8) := by
    push_cast; rw [show (8 : ZMod 8) = 0 from by decide]; ring
  unfold classify; rw [h2, h8]

/-- **Bott periodicity for the complex series (period 2).** For the two complex
classes the period is already `2`. -/
theorem classify_periodic2_complex (c : Class) (hc : c.isComplex = true) (d : ℕ) :
    classify c (d + 2) = classify c d := by
  have h2 : ((d + 2 : ℕ) : ZMod 2) = (d : ZMod 2) := by
    push_cast; rw [show (2 : ZMod 2) = 0 from by decide]; ring
  unfold classify; rw [if_pos hc, if_pos hc, h2]

/-- The classifying group depends on the dimension only through `d % 8`. -/
theorem classify_mod8 (c : Class) (d : ℕ) :
    classify c d = classify c (d % 8) := by
  have h2 : ((d : ℕ) : ZMod 2) = ((d % 8 : ℕ) : ZMod 2) := by
    conv_lhs => rw [← Nat.div_add_mod d 8]
    push_cast; rw [show (8 : ZMod 2) = 0 from by decide]; ring
  have h8 : ((d : ℕ) : ZMod 8) = ((d % 8 : ℕ) : ZMod 8) := by
    conv_lhs => rw [← Nat.div_add_mod d 8]
    push_cast; rw [show (8 : ZMod 8) = 0 from by decide]; ring
  unfold classify; rw [h2, h8]

/-! ## Verification of the standard periodic table

The following theorem records the full periodic table for spatial dimensions
`d = 0, 1, 2, 3`, exactly as it appears in Kitaev / Schnyder–Ryu–Furusaki–Ludwig.
Together with `classify_periodic8` it pins down `classify` in every dimension. -/

open Class KGroup in
/-- The periodic table of topological insulators and superconductors, for spatial
dimensions `d = 0, 1, 2, 3`. -/
theorem periodic_table :
    (∀ c : Class, classify c 0 =
      match c with
      | A => Z | AIII => null | AI => Z | BDI => Z2 | D => Z2
      | DIII => null | AII => twoZ | CII => null | C => null | CI => null) ∧
    (∀ c : Class, classify c 1 =
      match c with
      | A => null | AIII => Z | AI => null | BDI => Z | D => Z2
      | DIII => Z2 | AII => null | CII => twoZ | C => null | CI => null) ∧
    (∀ c : Class, classify c 2 =
      match c with
      | A => Z | AIII => null | AI => null | BDI => null | D => Z
      | DIII => Z2 | AII => Z2 | CII => null | C => twoZ | CI => null) ∧
    (∀ c : Class, classify c 3 =
      match c with
      | A => null | AIII => Z | AI => null | BDI => null | D => null
      | DIII => Z | AII => Z2 | CII => Z2 | C => null | CI => twoZ) := by
  refine ⟨?_, ?_, ?_, ?_⟩ <;> (intro c; cases c <;> decide)

/-! ## The five topological insulators in every dimension

The headline qualitative consequence of the tenfold way: in *every* spatial
dimension exactly five of the ten symmetry classes support a non-trivial
topological phase. -/

/-- **Five topological insulators/superconductors in every dimension.**
For every spatial dimension `d`, exactly five of the ten Altland–Zirnbauer
classes have a non-trivial classifying group. -/
theorem five_nontrivial_per_dimension (d : ℕ) :
    (Finset.univ.filter (fun c : Class => classify c d ≠ KGroup.null)).card = 5 := by
  have hcong : (Finset.univ.filter (fun c : Class => classify c d ≠ KGroup.null))
      = (Finset.univ.filter (fun c : Class => classify c (d % 8) ≠ KGroup.null)) := by
    apply Finset.filter_congr; intro c _; rw [classify_mod8 c d]
  rw [hcong]
  have hlt : d % 8 < 8 := Nat.mod_lt d (by norm_num)
  interval_cases h : (d % 8) <;> decide

end AZ
