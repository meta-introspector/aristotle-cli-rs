/-
CFTMorphisms.lean — the "CFT layer": fusion rules and arrows on the crystal table.

`RequestProject/PeriodicTable.lean` assigns every Lean declaration of size signature `N`
a *crystal cell*: the Altland–Zirnbauer real symmetry class `crystalCell N` sitting at
residue `N mod 8` on the real Bott clock `ℤ₈`.  This file adds the **morphism / fusion
structure** between those cells — the verified backbone of the requested "conformal-field-
theory" picture of code transitions:

* **Fusion rules.**  When two declarations are *composed* (a product type, an application,
  a `∘`), their size signatures **add**, so the resulting cell is obtained by adding the
  two Bott-clock residues.  `fuse c d` is exactly this 8×8 fusion operation on real cells,
  and `crystalCell_fuse` proves it is the genuine fusion rule:
  `crystalCell (M + N) = fuse (crystalCell M) (crystalCell N)`.
  `fuse` is commutative and associative, with the cell `AI` (residue `0`) as unit, so the
  eight real cells form a commutative fusion monoid isomorphic to `ℤ₈`.  The whole 8×8
  fusion matrix is captured compactly by `fuse_realIndex`
  (`(fuse c d).realIndex = c.realIndex + d.realIndex`).

* **Arrows / RG steps.**  The elementary "add one leaf / wrap in a constructor" operation
  increases a declaration's size by `1`, hence advances its cell by the generator arrow
  `arrow := fuse · BDI` (residue `+1`).  `crystalCell_succ` proves
  `crystalCell (N + 1) = arrow (crystalCell N)`, and `arrow_cycle` exhibits the full
  Bott-clock cycle `AI → BDI → D → DIII → AII → CII → C → CI → AI`, an 8-step orbit
  (`arrow_iterate8`).  In particular `arrow_AI : arrow AI = BDI` is the requested explicit
  transition from class `AI` to class `BDI`.

* **A concrete code transformation.**  `addLeaf` wraps a shape with one extra leaf (size
  `+1`); `crystalCell_addLeaf` shows it realises the arrow on cells, and
  `addLeaf_AI_to_BDI` is a worked instance of a Lean structural transformation moving a
  declaration from cell `AI` to cell `BDI`.

Everything is `sorry`-free and axiom-clean (only `propext`, `Classical.choice`,
`Quot.sound`).  The executable companion is `RequestProject/ArrowFinder.lean`
(`arrowfinder`), which scans a real environment's dependency edges and logs the actual
cell-to-cell arrows it finds into `arrows.json`.
-/
import Mathlib
import RequestProject.PeriodicTable
import RequestProject.ShapeBott
import RequestProject.SizeSignature

namespace CFTMorphisms

open AZ ShapeBott PeriodicTable SizeSignature

/-! ## Fusion of crystal cells -/

/-- **Fusion of two crystal cells.**  Compose two declarations: their size signatures add,
so the resulting cell is read off by *adding their Bott-clock residues* and naming the real
class there.  This is the 8×8 fusion operation of the code-CFT. -/
def fuse (c d : AZ.Class) : AZ.Class :=
  ShapeBott.realClassOfResidue (c.realIndex + d.realIndex)

/-- The whole 8×8 fusion matrix, in compact form: the Bott-clock residue of a fusion is the
sum of the residues of its inputs.  (Equivalently, `realIndex` is a fusion homomorphism
onto the additive group `ℤ₈`.) -/
@[simp] theorem fuse_realIndex (c d : AZ.Class) :
    (fuse c d).realIndex = c.realIndex + d.realIndex := by
  unfold fuse
  exact realIndex_realClassOfResidue _

/-- Every fusion lands in a *real* Altland–Zirnbauer class. -/
theorem fuse_isComplex_false (c d : AZ.Class) : (fuse c d).isComplex = false := by
  unfold fuse
  exact realClassOfResidue_isComplex_false _

/-- **Fusion is commutative.** -/
theorem fuse_comm (c d : AZ.Class) : fuse c d = fuse d c := by
  unfold fuse; rw [add_comm]

/-- **Fusion is associative.** -/
theorem fuse_assoc (c d e : AZ.Class) :
    fuse (fuse c d) e = fuse c (fuse d e) := by
  simp only [fuse, realIndex_realClassOfResidue, add_assoc]

/-- **`AI` is a right unit** for fusion (it sits at residue `0`). -/
theorem fuse_AI_right (c : AZ.Class) (hc : c.isComplex = false) : fuse c .AI = c := by
  unfold fuse
  rw [show (AZ.Class.AI).realIndex = 0 from rfl, add_zero]
  exact realClassOfResidue_surjective_on_reals c hc

/-- **`AI` is a left unit** for fusion. -/
theorem AI_fuse_left (c : AZ.Class) (hc : c.isComplex = false) : fuse .AI c = c := by
  rw [fuse_comm]; exact fuse_AI_right c hc

/-- **The fusion rule for code composition.**  Composing two declarations of size
signatures `M` and `N` (so the sizes add) lands in the fusion of their crystal cells:
`crystalCell (M + N) = fuse (crystalCell M) (crystalCell N)`. -/
theorem crystalCell_fuse (M N : ℕ) :
    crystalCell (M + N) = fuse (crystalCell M) (crystalCell N) := by
  unfold fuse
  rw [crystalCell_realIndex, crystalCell_realIndex]
  unfold crystalCell
  congr 1
  push_cast
  ring

/-! ## Arrows / RG steps -/

/-- The elementary **arrow** (RG step / "add one leaf"): fuse with the residue-`1` cell
`BDI`, advancing the Bott clock by one. -/
def arrow (c : AZ.Class) : AZ.Class := fuse c .BDI

/-- The requested explicit transition: the elementary arrow sends class `AI` to class
`BDI`. -/
theorem arrow_AI : arrow .AI = .BDI := by decide

/-- An arrow advances the Bott-clock residue by exactly one. -/
@[simp] theorem arrow_realIndex (c : AZ.Class) :
    (arrow c).realIndex = c.realIndex + 1 := by
  unfold arrow; rw [fuse_realIndex]; rfl

/-- **Increasing a declaration's size by one advances its cell by one arrow.** -/
theorem crystalCell_succ (N : ℕ) : crystalCell (N + 1) = arrow (crystalCell N) := by
  rw [crystalCell_fuse N 1]
  unfold arrow
  rw [show crystalCell 1 = AZ.Class.BDI from by decide]

/-- **The full Bott-clock cycle of arrows** on the eight real cells:
`AI → BDI → D → DIII → AII → CII → C → CI → AI`. -/
theorem arrow_cycle :
    arrow .AI = .BDI ∧ arrow .BDI = .D ∧ arrow .D = .DIII ∧ arrow .DIII = .AII ∧
    arrow .AII = .CII ∧ arrow .CII = .C ∧ arrow .C = .CI ∧ arrow .CI = .AI := by
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩ <;> decide

/-- **Eight arrows return home.**  Iterating the elementary arrow eight times is the
identity on every real cell — the period-`8` Bott orbit. -/
theorem arrow_iterate8 (c : AZ.Class) (hc : c.isComplex = false) : arrow^[8] c = c := by
  cases c <;> revert hc <;> decide

/-! ## A concrete Lean code transformation realising the arrow -/

/-- A structural transformation on shapes: **wrap a shape with one extra leaf** (e.g. add a
field / argument).  Its size signature increases by exactly one. -/
def addLeaf (s : Shape) : Shape := .node [s, .leaf]

/-- Wrapping in an extra leaf adds one to the size signature. -/
@[simp] theorem size_addLeaf (s : Shape) : size (addLeaf s) = size s + 1 := by
  simp [addLeaf]

/-- The `addLeaf` transformation realises the elementary arrow on crystal cells. -/
theorem crystalCell_addLeaf (s : Shape) :
    crystalCell (size (addLeaf s)) = arrow (crystalCell (size s)) := by
  rw [size_addLeaf, crystalCell_succ]

/-- **Worked instance of the requested `AI → BDI` transition.**  A declaration whose size
signature lands in cell `AI` is moved by the `addLeaf` transformation into cell `BDI`. -/
theorem addLeaf_AI_to_BDI (s : Shape) (h : crystalCell (size s) = .AI) :
    crystalCell (size (addLeaf s)) = .BDI := by
  rw [crystalCell_addLeaf, h, arrow_AI]

end CFTMorphisms
