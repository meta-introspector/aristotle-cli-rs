import Mathlib
import RequestProject.AZ.TenfoldWay
import RequestProject.AZ.Classification
import RequestProject.AZ.CliffordK
import RequestProject.AZ.BladeClassify

/-!
# Domain-specific spectral reductions and higher K-theory for AZ blades

This file builds two further layers on top of the blade classifier
(`RequestProject.AZ.BladeClassify`) and the Clifford / K-theory front-end
(`RequestProject.AZ.CliffordK`).

## 1. Degenerate / massless boundaries

A blade records a Clifford signature `Cl_{p,q}`; a coefficient `0` is a **degenerate
direction** (a massless / gapless mode that does not square to `±1`).  We make precise
the physical statement that *degenerate directions are spectators*: appending degenerate
directions to a blade changes neither its signature, its Clifford degree, its nearest AZ
class, nor its classifying group `kGroup` (`padDegenerate_*`).  Conversely, *activating* a
degenerate direction into a genuine massive mode (a domain wall / gap-closing event)
advances the Bott clock by one step (`activateNeg_realIndex_succ`), which is exactly the
dimensional shift mechanism of the tenfold way.

## 2. Symmetry-protected primaries (the joint spectral origin `(0,0)`)

The "joint spectral origin" is the empty blade with signature `(p,q) = (0,0)` and degree
`0` (`originBlade`).  We show a real primary is classified to `AI` and a complex primary
to `A` — the two degree-`0` classes — and that `AI` is the *unique* real class at the
origin (`originBlade_unique_real`).  These primaries carry a `ℤ` strong invariant in
dimension `0` (`originBlade_kGroup_zero`): the joint spectral origin sits in a
topologically non-trivial cell, so symmetry-protected primaries are not confined to the
trivial phase.

## 3. Higher K-theory `K_n`

`Blade.kGroupN b n` evaluates the Bott-periodic K-group of a blade's governing spectrum
(`KU` for complex, `KO` for real) at an *arbitrary integer* degree `n`, extending the
physical (natural-number) dimensional classification `Blade.kGroup` to the full integer
ladder of higher / lower K-groups.  We prove it agrees with `Blade.kGroup` on natural
dimensions (`kGroup_eq_kGroupN`) and is Bott-periodic: period `8` for real blades
(`kGroupN_periodic8`) and period `2` for complex blades (`kGroupN_periodic2`).
-/

namespace AZ

open Class

namespace Blade

/-! ## Bott-clock position of a blade's nearest class -/

/-- For a real blade, the nearest class sits at the `ℤ₈` Bott position equal to the
blade's Clifford degree. -/
theorem nearestClass_realIndex (b : Blade) (hb : b.complex = false) :
    b.nearestClass.realIndex = (b.degree : ZMod 8) := by
  simp [nearestClass, hb]

/-- For a complex blade, the nearest class sits at the `ℤ₂` Bott position equal to the
blade's Clifford degree. -/
theorem nearestClass_complexIndex (b : Blade) (hb : b.complex = true) :
    b.nearestClass.complexIndex = (b.degree : ZMod 2) := by
  simp [nearestClass, hb]

/-! ## 1. Degenerate / massless boundaries -/

/-- The number of **degenerate directions** of a blade: coefficients equal to `0`,
i.e. massless / gapless generators that square to neither `+1` nor `-1`. -/
def degenCount (b : Blade) : ℕ := (b.coeffs.filter (fun x => x = 0)).length

/-- Append `k` degenerate directions (zero coefficients) to a blade.  Physically this
adjoins `k` massless boundary modes. -/
def padDegenerate (b : Blade) (k : ℕ) : Blade :=
  { b with coeffs := b.coeffs ++ List.replicate k (0 : ℤ) }

@[simp] theorem padDegenerate_complex (b : Blade) (k : ℕ) :
    (b.padDegenerate k).complex = b.complex := rfl

/-- Appending degenerate directions leaves the `+1` count unchanged. -/
@[simp] theorem padDegenerate_pCount (b : Blade) (k : ℕ) :
    (b.padDegenerate k).pCount = b.pCount := by
  simp [padDegenerate, pCount, List.filter_append]

/-- Appending degenerate directions leaves the `-1` count unchanged. -/
@[simp] theorem padDegenerate_qCount (b : Blade) (k : ℕ) :
    (b.padDegenerate k).qCount = b.qCount := by
  simp [padDegenerate, qCount, List.filter_append]

/-- Appending degenerate directions leaves the Clifford signature unchanged. -/
@[simp] theorem padDegenerate_signature (b : Blade) (k : ℕ) :
    (b.padDegenerate k).signature = b.signature := by
  simp [signature]

/-- Appending degenerate directions leaves the Clifford degree unchanged. -/
@[simp] theorem padDegenerate_degree (b : Blade) (k : ℕ) :
    (b.padDegenerate k).degree = b.degree := by
  simp [degree, signature, ClIndex.degree]

/-- **Degenerate directions are spectators (class).**  Adjoining massless boundary modes
does not change the AZ class a blade is classified to. -/
@[simp] theorem padDegenerate_nearestClass (b : Blade) (k : ℕ) :
    (b.padDegenerate k).nearestClass = b.nearestClass := by
  simp [nearestClass]

/-- **Degenerate directions are spectators (classifying group).**  Adjoining massless
boundary modes does not shift the classifying group `kGroup` in any dimension. -/
@[simp] theorem padDegenerate_kGroup (b : Blade) (k : ℕ) (d : ℕ) :
    (b.padDegenerate k).kGroup d = b.kGroup d := by
  simp [kGroup]

/-- **Activating a degenerate direction.**  Turning a massless mode into a genuine
generator squaring to `-1` (a domain-wall / gap-closing event). -/
def activateNeg (b : Blade) : Blade :=
  { b with coeffs := b.coeffs ++ [(-1 : ℤ)] }

@[simp] theorem activateNeg_complex (b : Blade) : b.activateNeg.complex = b.complex := rfl

/-- Activating a `-1` generator raises the Clifford degree by one. -/
@[simp] theorem activateNeg_degree (b : Blade) :
    b.activateNeg.degree = b.degree + 1 := by
  simp [activateNeg, degree, signature, ClIndex.degree, pCount, qCount,
    List.filter_append]
  ring

/-- **A domain wall advances the Bott clock by one step.**  For a real blade, activating a
massless direction into a massive `-1` mode moves the nearest AZ class one step along the
`ℤ₈` Bott clock — the same shift induced by changing the spatial dimension by one. -/
theorem activateNeg_realIndex_succ (b : Blade) (hb : b.complex = false) :
    (b.activateNeg.nearestClass).realIndex = b.nearestClass.realIndex + 1 := by
  rw [nearestClass_realIndex b.activateNeg (by simpa using hb),
    nearestClass_realIndex b hb, activateNeg_degree]
  push_cast
  ring

end Blade

/-! ## 2. Symmetry-protected primaries: the joint spectral origin `(0,0)` -/

/-- The **joint spectral origin**: the empty blade, with Clifford signature `(0,0)` and
degree `0`.  It models a primary state sitting at the origin of the joint spectrum. -/
def originBlade (complex : Bool) : Blade := { coeffs := [], complex := complex }

@[simp] theorem originBlade_pCount (c : Bool) : (originBlade c).pCount = 0 := rfl
@[simp] theorem originBlade_qCount (c : Bool) : (originBlade c).qCount = 0 := rfl

@[simp] theorem originBlade_signature (c : Bool) :
    (originBlade c).signature = ⟨0, 0⟩ := rfl

@[simp] theorem originBlade_degree (c : Bool) : (originBlade c).degree = 0 := rfl

@[simp] theorem originBlade_complex (c : Bool) : (originBlade c).complex = c := rfl

/-- A **real primary** at the joint spectral origin is classified to `AI` (the degree-`0`
real class). -/
@[simp] theorem originBlade_nearestClass_real :
    (originBlade false).nearestClass = Class.AI := by decide

/-- A **complex primary** at the joint spectral origin is classified to `A` (the degree-`0`
complex class). -/
@[simp] theorem originBlade_nearestClass_complex :
    (originBlade true).nearestClass = Class.A := by decide

/-- **The real primary is symmetry-protected exclusively in class `AI`.**  Among the real
classes, `AI` is the unique one at distance `0` from the joint spectral origin. -/
theorem originBlade_unique_real (c : Class) (hc : c.isComplex = false) :
    (originBlade false).distToReal c = 0 ↔ c = Class.AI := by
  rw [Blade.distToReal_eq_zero_iff (originBlade false) rfl c hc,
    originBlade_nearestClass_real]

/-- **The joint spectral origin carries a `ℤ` strong invariant in dimension `0`.**
Both the real and the complex primary land in a topologically non-trivial cell — the
generator class of K-theory — so symmetry-protected primaries are not confined to the
trivial phase. -/
theorem originBlade_kGroup_zero (c : Bool) : (originBlade c).kGroup 0 = KGroup.Z := by
  cases c <;> decide

theorem originBlade_kGroup_zero_nontrivial (c : Bool) :
    (originBlade c).kGroup 0 ≠ KGroup.null := by
  rw [originBlade_kGroup_zero]; decide

/-! ## 3. Higher K-theory `K_n` -/

namespace Blade

/-- The K-theory spectrum governing a blade: `KU` for a complex blade, `KO` for a real
blade. -/
def spectrum (b : Blade) : Spectrum := if b.complex then Spectrum.KU else Spectrum.KO

@[simp] theorem spectrum_real (b : Blade) (hb : b.complex = false) :
    b.spectrum = Spectrum.KO := by simp [spectrum, hb]

@[simp] theorem spectrum_complex (b : Blade) (hb : b.complex = true) :
    b.spectrum = Spectrum.KU := by simp [spectrum, hb]

/-- The **higher K-group** `K_n` of a blade: the Bott-periodic K-group of the blade's
spectrum evaluated at the integer degree `b.degree - n`.  Unlike `kGroup`, the index `n`
ranges over all of `ℤ`, exposing the full ladder of higher and lower K-groups. -/
def kGroupN (b : Blade) (n : ℤ) : KGroup := KGroupOf b.spectrum (b.degree - n)

/-- The higher K-group ladder restricts to the physical (natural-dimension) classification
`Blade.kGroup`. -/
theorem kGroup_eq_kGroupN (b : Blade) (d : ℕ) :
    b.kGroup d = b.kGroupN (d : ℤ) := by
  rcases hb : b.complex with _ | _
  · rw [kGroupN, spectrum_real b hb, KGroupOf_KO, kGroup, classify,
      if_neg (by simp [nearestClass, hb]), nearestClass_realIndex b hb]
    push_cast
    congr 1
  · rw [kGroupN, spectrum_complex b hb, KGroupOf_KU, kGroup, classify,
      if_pos (by simp [nearestClass, hb]), nearestClass_complexIndex b hb]
    push_cast
    congr 1

/-- **Bott periodicity (period 8) for real blades.** -/
theorem kGroupN_periodic8 (b : Blade) (hb : b.complex = false) (n : ℤ) :
    b.kGroupN (n + 8) = b.kGroupN n := by
  rw [kGroupN, kGroupN, spectrum_real b hb, KGroupOf_KO, KGroupOf_KO]
  congr 1
  push_cast
  rw [show (8 : ZMod 8) = 0 from by decide]
  ring

/-- **Bott periodicity (period 2) for complex blades.** -/
theorem kGroupN_periodic2 (b : Blade) (hb : b.complex = true) (n : ℤ) :
    b.kGroupN (n + 2) = b.kGroupN n := by
  rw [kGroupN, kGroupN, spectrum_complex b hb, KGroupOf_KU, KGroupOf_KU]
  congr 1
  push_cast
  rw [show (2 : ZMod 2) = 0 from by decide]
  ring

end Blade

end AZ
