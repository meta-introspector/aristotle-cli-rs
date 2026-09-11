/-
# SpectralPlane — exploiting the 2-D `(moonshine, hecke)` spectral plane

`RequestProject.Compute.ScaleCategory` equips every addressed arrow with a point
`spectralPoint a = (moonshineWeight a, heckeWeight a)` in a 2-D spectral plane:
the *moonshine* axis (distance from the `j`-spectrum) and the *Hecke* axis (the
`T₁₉`-residue of the address).  This file pushes that structure further along the
roadmap.

## What is built here

1. **Primary State Isolation.**  An arrow is a *joint primary* when it sits at the
   spectral origin `(0,0)`: it is a genuine `j`-coefficient (`moonshineWeight = 0`)
   *and* has trivial Hecke residue (`heckeWeight = 0`).  The headline result is
   that **the spectral origin is unoccupied**: no natural-number arrow is a joint
   primary (`no_joint_primary`), because none of the reference `j`-coefficients is
   divisible by the Hecke prime `19`.  Equivalently, `moonshineWeight = 0` already
   forces a *nonzero* Hecke residue (`onCFT_hecke_ne_zero`).

2. **Axis independence.**  The two coordinates are genuinely independent: there
   are arrows sharing a moonshine weight while differing in Hecke weight
   (`moonshine_eq_hecke_ne`) and arrows sharing a Hecke weight while differing in
   moonshine weight (`hecke_eq_moonshine_ne`).  So the spectral plane is honestly
   two-dimensional.

3. **Spectral clustering of lossy operations.**  Address-preserving lossy
   operations (`coarsenNgram`, `eraseDeclDetail`) move an arrow along *neither*
   axis (`*_preserves_spectralPoint`), whereas the Hecke shift `+19` moves along
   *neither the Hecke axis* yet can move along the moonshine axis
   (`heckeShift_preserves_hecke`, `heckeShift_moves_moonshine`).  This is the
   precise sense in which different operations cluster along different axes.
-/

import Mathlib
import RequestProject.Compute.ScaleCategory

namespace RequestProject.Compute.CFT

open RequestProject.Compute.DistanceFromJ

/-! ## §1. `onJ` lands exactly on the reference `j`-coefficients -/

/-- `distFromJ n = 0` exactly when `n` is one of the reference `j`-coefficients.
    (The distance is a minimum of `absDiff n c`, which vanishes iff `n = c`.) -/
theorem distFromJ_eq_zero_iff (n : ℕ) : distFromJ n = 0 ↔ n ∈ jValues := by
  constructor <;> intro h
  · contrapose! h
    unfold distFromJ
    simp +decide [jValues] at h ⊢
    simp +decide [absDiff]
    omega
  · native_decide +revert

/-! ## §2. Primary State Isolation: the spectral origin is unoccupied -/

/-- Being on the Monster CFT forces a **nonzero** Hecke residue: every genuine
    `j`-coefficient in the reference set has `heckeOfAddr ≠ 0`. -/
theorem onCFT_hecke_ne_zero (n : ℕ) (h : moonshineWeight n = 0) :
    heckeWeight n ≠ 0 := by
  obtain ⟨l, hl⟩ : ∃ l : List ℕ, jValues = l ∧ n ∈ l :=
    ⟨_, rfl, by simpa using distFromJ_eq_zero_iff n |>.1 h⟩
  rcases hl with ⟨rfl, hn⟩
  fin_cases hn <;> native_decide

/-- **Primary State Isolation.**  No natural-number arrow is a joint primary: the
    spectral origin `(0,0)` is unoccupied.  A field cannot simultaneously lie on
    the `j`-spectrum and have trivial Hecke residue. -/
theorem no_joint_primary (n : ℕ) : ¬ IsJointPrimary n := by
  rintro ⟨hm, hh⟩
  exact onCFT_hecke_ne_zero n hm hh

/-- Restated via `spectralPoint`: no arrow lands at the origin of the plane. -/
theorem spectralPoint_ne_origin (n : ℕ) : spectralPoint n ≠ (0, 0) := by
  intro h
  exact no_joint_primary n ((primary_iff_moonshine_hecke n).2 h)

/-! ## §3. Axis independence -/

/-- The two axes are independent (I): `c(1)=196884` and `c(2)=21493760` share
    moonshine weight `0` but differ in Hecke weight (`6 ≠ 10`). -/
theorem moonshine_eq_hecke_ne :
    moonshineWeight (196884 : ℕ) = moonshineWeight (21493760 : ℕ) ∧
    heckeWeight (196884 : ℕ) ≠ heckeWeight (21493760 : ℕ) := by
  native_decide

/-- The two axes are independent (II): `196884` and `196903 = 196884 + 19` share
    Hecke weight `6` but differ in moonshine weight (`0 ≠ 19`). -/
theorem hecke_eq_moonshine_ne :
    heckeWeight (196884 : ℕ) = heckeWeight (196903 : ℕ) ∧
    moonshineWeight (196884 : ℕ) ≠ moonshineWeight (196903 : ℕ) := by
  native_decide

/-! ## §4. Spectral clustering of operations -/

/-- The joint spectral point of an arrow only depends on its address. -/
theorem spectralPoint_eraseDeclDetail (d : DeclArrow) :
    spectralPoint (eraseDeclDetail d) = spectralPoint d :=
  spectralPoint_eq_of_addr_eq _ _ rfl

/-- Coarsening n-grams moves along neither spectral axis. -/
theorem spectralPoint_coarsenNgram (l : List ℕ) :
    spectralPoint (coarsenNgram l) = spectralPoint l :=
  spectralPoint_eq_of_addr_eq _ _ rfl

/-- The **Hecke shift**: add one full Hecke period `19` to an address. -/
def heckeShift (n : ℕ) : ℕ := n + heckePrime

/-- The Hecke shift moves along *neither* the Hecke axis: `+19` is invisible mod
    `19`. -/
theorem heckeShift_preserves_hecke (n : ℕ) :
    heckeWeight (heckeShift n) = heckeWeight n := by
  unfold heckeWeight heckeOfAddr heckeShift heckePrime
  simp [addr]

/-- … yet the Hecke shift *can* move along the moonshine axis: starting from the
    on-CFT point `196884`, one Hecke period away has moonshine weight `19`. -/
theorem heckeShift_moves_moonshine :
    moonshineWeight (heckeShift 196884) ≠ moonshineWeight (196884 : ℕ) := by
  native_decide

end RequestProject.Compute.CFT