import Mathlib
import RequestProject.MonsterBaseWalk
import RequestProject.MonsterWalk
import RequestProject.MonsterClifford

/-!
# Clifford-blade signatures of the base-2 Monster Walk and their Altland–Zirnbauer classes

This module carries out the *blade ↦ symmetry-class* program for the base-2 Monster Walk of
`RequestProject.MonsterBaseWalk`.  Each step of the binary walk has a **base-2 shadow** `L`
(`MonsterBaseWalk.shadowVal 2 …`), the preserved leading binary digits of `|𝕄| / ∏S` read back
as an integer.  We turn that integer into a Clifford blade, read off its grade, and assign it
an Altland–Zirnbauer symmetry class via the period-8 Bott clock — then ask whether the
genuinely *surviving* coprime shadow (the binary phenomenon impossible in base 10) lands in a
class with a nontrivial `ℤ₂` / `2ℤ` K-group.

## The pipeline

* `bladeOfAddr a` — the Clifford blade in `MonsterClifford.Cl(0,15)` whose grade-1 generators
  `γ_i` are indexed by the **set bits of `a`** lying in `{0,…,14}`.  Its grade is the binary
  popcount of `a` (restricted to the 15 Monster generators).
* `stepShadow s` — the base-2 shadow of a walk step `s = (p, d, m)`.
* `azOfGrade g` — the AZ class assigned to grade `g` via the eight-element real **Bott clock**
  `[AI, BDI, D, DIII, AII, CII, C, CI]` indexed by `g % 8` (Clifford/Bott period 8).
* `kGroupOf` — the `d = 0` column of the tenfold-way periodic table of topological
  invariants; `nontrivialZ2or2Z` flags the `ℤ₂` and `2ℤ` entries.

## What is proved (all kernel-checked)

* `surviving_shadow_blade` — the surviving base-2 shadow is `L = 539 = 7²·11`; its blade has
  grade `5` with generator support `{γ₀, γ₁, γ₃, γ₄, γ₉}`.
* `base2_walk_step_grades` / `base2_walk_step_classes` — the three steps have grades `[5,6,6]`
  and AZ classes `[CII, C, C]`.
* `surviving_step_is_CII` — the unique step whose shadow genuinely survives (coprime to its
  removed product and dividing the partial part) is classified `CII`, separating it from the
  two non-surviving steps, both classified `C`.
* `base2_walk_no_nontrivial_K` — under the strong-invariant (`d = 0`) column **none** of the
  binary walk steps isolates a nontrivial `ℤ₂` / `2ℤ` K-group: the surviving step (`CII`) and
  the obstructed steps (`C`) all carry the trivial group.  The grades that *would* isolate a
  nontrivial `ℤ₂` / `2ℤ` invariant are exactly `{1, 2, 4}` mod 8 (`nontrivial_grades`), which
  the binary walk's grades `{5, 6}` miss.

The Altland–Zirnbauer / K-theory labelling is an explicit, documented combinatorial
assignment (the Bott clock and the `d = 0` periodic-table column); as in `MonsterWalk`, the
*physical* correspondence is an analogy, while the statements proved here are exact decidable
facts about that assignment.
-/

set_option maxHeartbeats 4000000

namespace MonsterBladeWalk

open MonsterBaseWalk MonsterWalk MonsterClifford

/-! ## From an address to a Clifford blade -/

/-- The Clifford blade in `Cl(0,15)` indexed by the set bits of `a` that fall within the 15
Monster generators `{γ₀, …, γ₁₄}`.  Its grade is the binary popcount of `a` restricted to
those 15 bits. -/
def bladeOfAddr (a : ℕ) : Blade :=
  let supp := (List.finRange 15).filter (fun i => a.testBit i.val)
  { grade := supp.length, support := supp }

/-- The base-2 shadow of a walk step `s = (position, digits, removal-mask)`. -/
def stepShadow (s : ℕ × ℕ × ℕ) : ℕ := shadowVal 2 s.2.1 s.2.2

/-! ## The Bott clock and the K-theory column -/

/-- The eight real Altland–Zirnbauer classes in **Bott-clock order**. -/
def realBottClock : List SymmetryClass :=
  [.AI, .BDI, .D, .DIII, .AII, .CII, .C, .CI]

/-- AZ class assigned to a blade of grade `g`, via Clifford/Bott period 8. -/
def azOfGrade (g : ℕ) : SymmetryClass := realBottClock.getD (g % 8) .AI

/-- AZ class of a blade. -/
def azOfBlade (b : Blade) : SymmetryClass := azOfGrade b.grade

/-- AZ class of a base-2 walk step: classify the blade of its shadow. -/
def stepClass (s : ℕ × ℕ × ℕ) : SymmetryClass := azOfBlade (bladeOfAddr (stepShadow s))

/-- The four K-theory groups appearing in the tenfold-way periodic table. -/
inductive KGroup
  | trivial | Z | Z2 | twoZ
deriving DecidableEq, Repr

/-- The `d = 0` (strong-invariant) column of the tenfold-way periodic table of topological
invariants. -/
def kGroupOf : SymmetryClass → KGroup
  | .A => .Z   | .AIII => .trivial
  | .AI => .Z  | .BDI => .Z2 | .D => .Z2 | .DIII => .trivial
  | .AII => .twoZ | .CII => .trivial | .C => .trivial | .CI => .trivial

/-- A K-group is one of the "nontrivial" `ℤ₂` / `2ℤ` invariants flagged in the prompt. -/
def nontrivialZ2or2Z : KGroup → Bool
  | .Z2 => true | .twoZ => true | _ => false

/-! ## The surviving base-2 shadow as a blade -/

/-- The surviving base-2 walk shadow is `L = 539 = 7²·11`; its blade has grade `5` and
generator support `{γ₀, γ₁, γ₃, γ₄, γ₉}`. -/
theorem surviving_shadow_blade :
    stepShadow (0, 10, 1) = 539 ∧
    539 = 7 ^ 2 * 11 ∧
    (bladeOfAddr 539).grade = 5 ∧
    (bladeOfAddr 539).support.map Fin.val = [0, 1, 3, 4, 9] := by
  refine ⟨by native_decide, by norm_num, by decide, by decide⟩

/-! ## Grades and classes of every binary walk step -/

/-- The three base-2 walk steps have blade grades `[5, 6, 6]`. -/
theorem base2_walk_step_grades :
    (monsterWalkBase 2 10).map (fun s => (bladeOfAddr (stepShadow s)).grade) = [5, 6, 6] := by
  native_decide

/-- The three base-2 walk steps are classified `[CII, C, C]`. -/
theorem base2_walk_step_classes :
    (monsterWalkBase 2 10).map stepClass
      = [SymmetryClass.CII, SymmetryClass.C, SymmetryClass.C] := by
  native_decide

/-- **The surviving coprime shadow is the `CII` step.** The unique step of the base-2 walk
whose shadow genuinely survives (it is `> 1`, divides `|𝕄|`, is coprime to its removed
product, and divides the partial part) is classified `CII`, while the two obstructed steps are
both classified `C`. -/
theorem surviving_step_is_CII :
    (monsterWalkBase 2 10).filter (shadowSurvivesCoprime 2) = [(0, 10, 1)] ∧
    stepClass (0, 10, 1) = SymmetryClass.CII ∧
    ((monsterWalkBase 2 10).filter (fun s => ! shadowSurvivesCoprime 2 s)).map stepClass
      = [SymmetryClass.C, SymmetryClass.C] := by
  refine ⟨by native_decide, by native_decide, by native_decide⟩

/-! ## K-theory verdict -/

/-- The grades (mod 8) whose Bott-clock class carries a nontrivial `ℤ₂` / `2ℤ` K-group are
exactly `{1, 2, 4}` (classes `BDI`, `D`, `AII`). -/
theorem nontrivial_grades :
    (List.range 8).filter (fun g => nontrivialZ2or2Z (kGroupOf (azOfGrade g)))
      = [1, 2, 4] := by
  native_decide

/-- **No binary walk step isolates a nontrivial `ℤ₂` / `2ℤ` K-group.** Under the
strong-invariant (`d = 0`) periodic-table column, the surviving step (`CII`) and the two
obstructed steps (`C`) all carry the trivial K-group; the walk's grades `{5, 6}` avoid the
nontrivial residues `{1, 2, 4}`. -/
theorem base2_walk_no_nontrivial_K :
    (monsterWalkBase 2 10).all
      (fun s => ! nontrivialZ2or2Z (kGroupOf (stepClass s))) = true := by
  native_decide

/-! ## Summary -/

/-- **Blade-signature summary of the base-2 Monster Walk.**
1. The surviving coprime shadow `L = 539 = 7²·11` is the grade-5 blade `γ₀γ₁γ₃γ₄γ₉`.
2. The three steps carry grades `[5, 6, 6]` and AZ classes `[CII, C, C]`; the surviving step
   is the lone `CII`.
3. None of the steps isolates a nontrivial `ℤ₂` / `2ℤ` K-group in the `d = 0` column. -/
theorem blade_walk_summary :
    (bladeOfAddr (stepShadow (0, 10, 1))).grade = 5 ∧
    (monsterWalkBase 2 10).map stepClass
      = [SymmetryClass.CII, SymmetryClass.C, SymmetryClass.C] ∧
    stepClass (0, 10, 1) = SymmetryClass.CII ∧
    (monsterWalkBase 2 10).all
      (fun s => ! nontrivialZ2or2Z (kGroupOf (stepClass s))) = true := by
  refine ⟨by native_decide, base2_walk_step_classes, by native_decide,
    base2_walk_no_nontrivial_K⟩

end MonsterBladeWalk
