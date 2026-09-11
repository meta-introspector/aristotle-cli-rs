/-
# ConformalWeightGrading — the address line graded by conformal weight

`RequestProject.Compute.ConformalSectionFunctor` and
`RequestProject.Compute.ConformalSectionColimit` exhibit the global CFT state
space — the limit *and* the colimit of the constant address presheaf over the
connected scale tower — as the address line `ℕ`.  This file equips that address
line (and hence the global state space) with the **conformal-weight grading**
asked for by the roadmap: the decomposition of the address line into the fibers
of `moonshineWeight`.

## What is built here

1. `weightFiber w` — the weight-`w` sector of the address line: the addresses
   whose conformal weight (distance from the `j`-spectrum) is exactly `w`.

2. **The address line is weight-graded.**  `addrLine_weightGraded :
   (Σ w, weightFiber w) ≃ ℕ` realizes the address line as the disjoint union of
   its weight sectors — a genuine `ℕ`-grading by conformal weight.

3. **The global state space inherits the grading.**  Transporting along the
   colimit isomorphism gives `globalStates_weightGraded : colimit
   confSectionFunctor ≃ (Σ w, weightFiber w)`: the glued CFT state space splits
   into conformal-weight sectors.

4. **The bottom sector is the Monster CFT.**  `mem_weightFiber_zero_iff` /
   `weightFiber_zero_equiv` identify the weight-`0` sector with the reference
   `j`-coefficients (`jValues`) — the genuine primaries lying on the Monster CFT.
   Nonemptiness of the low sectors is witnessed by `c(1) = 196884` (weight `0`)
   and McKay's `χ₂ = 196883` (weight `1`).
-/

import Mathlib
import RequestProject.Compute.CFTArrow
import RequestProject.Compute.ScaleCategory
import RequestProject.Compute.ConformalSectionColimit
import RequestProject.Compute.SpectralPlane

namespace RequestProject.Compute.CFT

open RequestProject.Compute.DistanceFromJ
open CategoryTheory CategoryTheory.Limits

/-! ## §1. The weight sectors of the address line -/

/-- The **weight-`w` sector** of the address line: the addresses whose conformal
    weight (distance from the `j`-spectrum) is exactly `w`. -/
abbrev weightFiber (w : ℕ) : Type := {n : ℕ // moonshineWeight (n : ℕ) = w}

/-- Each address sits in the sector of its own conformal weight. -/
def toWeightFiber (n : ℕ) : weightFiber (moonshineWeight (n : ℕ)) := ⟨n, rfl⟩

/-- Membership in a weight sector is exactly having that conformal weight. -/
theorem mem_weightFiber_iff (w n : ℕ) :
    (∃ x : weightFiber w, (x : ℕ) = n) ↔ moonshineWeight (n : ℕ) = w := by
  constructor
  · rintro ⟨⟨m, hm⟩, rfl⟩; exact hm
  · intro h; exact ⟨⟨n, h⟩, rfl⟩

/-! ## §2. The address line is graded by conformal weight -/

/-- **The address line is weight-graded.**  It is the disjoint union of its
    conformal-weight sectors: `(Σ w, weightFiber w) ≃ ℕ`. -/
noncomputable def addrLine_weightGraded : (Σ w : ℕ, weightFiber w) ≃ ℕ :=
  Equiv.sigmaFiberEquiv (fun n : ℕ => moonshineWeight (n : ℕ))

/-- The grading equivalence sends a sector element to its underlying address. -/
@[simp] theorem addrLine_weightGraded_apply (w : ℕ) (x : weightFiber w) :
    addrLine_weightGraded ⟨w, x⟩ = (x : ℕ) := rfl

/-! ## §3. The global state space inherits the grading -/

/-- **The global CFT state space is weight-graded.**  Transporting the address
    grading along the colimit isomorphism splits the glued state space (the
    colimit of `confSectionFunctor`) into conformal-weight sectors. -/
noncomputable def globalStates_weightGraded :
    colimit confSectionFunctor ≃ (Σ w : ℕ, weightFiber w) :=
  globalStatesIso.toEquiv.trans addrLine_weightGraded.symm

/-! ## §4. The bottom sector is the Monster CFT -/

/-- The weight-`0` sector consists exactly of the reference `j`-coefficients: the
    genuine primaries lying on the Monster CFT. -/
theorem mem_weightFiber_zero_iff (n : ℕ) :
    moonshineWeight (n : ℕ) = 0 ↔ n ∈ jValues :=
  distFromJ_eq_zero_iff n

/-- The weight-`0` sector is in bijection with (the subtype of) reference
    `j`-coefficients — the on-CFT primaries. -/
def weightFiber_zero_equiv : weightFiber 0 ≃ {n : ℕ // n ∈ jValues} :=
  Equiv.subtypeEquivRight (fun n => mem_weightFiber_zero_iff n)

/-- `c(1) = 196884` lives in the bottom (on-CFT) sector. -/
def c1_weightFiber_zero : weightFiber 0 := ⟨196884, by native_decide⟩

/-- McKay's `χ₂ = 196883` lives in the weight-`1` sector. -/
def chi2_weightFiber_one : weightFiber 1 := ⟨196883, by native_decide⟩

/-- The bottom sector is nonempty (it contains `c(1)`). -/
theorem weightFiber_zero_nonempty : Nonempty (weightFiber 0) :=
  ⟨c1_weightFiber_zero⟩

/-- The weight-`1` sector is nonempty (it contains `χ₂`). -/
theorem weightFiber_one_nonempty : Nonempty (weightFiber 1) :=
  ⟨chi2_weightFiber_one⟩

end RequestProject.Compute.CFT
