/-
# CliffordMorphismLift — which scale morphisms lift to the Clifford algebra?

`RequestProject.Math.Bridge.CliffordBladeEmbedding` realizes the combinatorial
blade `bladeOfAddr a` of an arrow as an honest element `bladeElement Q b a` of a
Mathlib `CliffordAlgebra Q`.  The roadmap asks whether the *morphisms* of the
scale tower (`RequestProject.Compute.ScaleCategory`) lift to maps of the Clifford
algebra.  This file answers that precisely.

## The dichotomy

A scale morphism `f : s ⟶ t` is only required to preserve the **conformal weight**
`distFromJ` — *not* the address.  The Clifford element, by contrast, is determined
by the full address (via the binary support).  Hence:

* **Address-preserving morphisms lift to an honest algebra homomorphism.**  When
  `f.map = id` on addresses, the induced action on the Clifford algebra is the
  identity algebra automorphism `AlgHom.id`, and every blade element is preserved
  (`IsAddrPreserving.lifts_to_algHom`, `IsAddrPreserving.bladeElement_eq`).

* **Weight-preserving morphisms need not lift.**  We exhibit `swapHom`, a genuine
  scale endomorphism that preserves the weight (and even the blade *grade*) yet
  changes the blade itself, so it does **not** act compatibly with the Clifford
  embedding (`swapHom_preserves_weight`, `swapHom_preserves_grade`,
  `swapHom_not_addr_preserving`, `swapHom_changes_blade`).  Weight-preservation is
  strictly weaker than the data needed to descend to the Clifford algebra.

The upshot: the Clifford bridge is functorial on the **address-preserving**
subcategory, and the obstruction to extending it to all weight-preserving arrows
is exactly the failure of address-preservation.
-/

import Mathlib
import RequestProject.Compute.ScaleCategory
import RequestProject.Math.Bridge.CliffordBladeEmbedding

namespace RequestProject.Compute.CFT

open RequestProject.Compute.DistanceFromJ
open CategoryTheory

/-! ## §1. Address-preserving scale morphisms -/

/-- A scale morphism is **address-preserving** when its underlying relabelling is
    the identity on addresses (a strictly stronger condition than preserving the
    conformal weight). -/
def ScaleHom.IsAddrPreserving {s t : Scale} (f : ScaleHom s t) : Prop :=
  ∀ n, f.map n = n

/-- The categorical identity is address-preserving. -/
theorem ScaleHom.id_isAddrPreserving (s : Scale) :
    (𝟙 s : ScaleHom s s).IsAddrPreserving := fun _ => rfl

/-- Address-preserving morphisms are closed under composition. -/
theorem ScaleHom.IsAddrPreserving.comp {s t u : Scale} {f : ScaleHom s t}
    {g : ScaleHom t u} (hf : f.IsAddrPreserving) (hg : g.IsAddrPreserving) :
    (ScaleHom.comp f g).IsAddrPreserving := by
  intro n
  show g.map (f.map n) = n
  rw [hf n, hg n]

/-! ## §2. Address-preserving morphisms lift to an algebra homomorphism -/

section Lift

variable {R M : Type*} [CommRing R] [AddCommGroup M] [Module R M]

/-- An address-preserving morphism keeps every Clifford blade element fixed: the
    blade of `f.map n` is the blade of `n`. -/
theorem ScaleHom.IsAddrPreserving.bladeElement_eq (Q : QuadraticForm R M) (b : ℕ → M)
    {s t : Scale} {f : ScaleHom s t} (hf : f.IsAddrPreserving) (n : ℕ) :
    bladeElement Q b ((f.map n : ℕ)) = bladeElement Q b (n : ℕ) :=
  bladeElement_eq_of_addr_eq Q b _ _ (by simp [addr, hf n])

/-- **Address-preserving morphisms lift to an honest algebra homomorphism.**  The
    identity algebra automorphism `AlgHom.id` realizes the action of any
    address-preserving morphism on the Clifford algebra: it sends each blade
    element to the blade element of the relabelled address. -/
theorem ScaleHom.IsAddrPreserving.lifts_to_algHom (Q : QuadraticForm R M) (b : ℕ → M)
    {s t : Scale} {f : ScaleHom s t} (hf : f.IsAddrPreserving) :
    ∃ φ : CliffordAlgebra Q →ₐ[R] CliffordAlgebra Q,
      ∀ n : ℕ, φ (bladeElement Q b (n : ℕ)) = bladeElement Q b ((f.map n : ℕ)) := by
  refine ⟨AlgHom.id R (CliffordAlgebra Q), fun n => ?_⟩
  rw [AlgHom.id_apply, hf.bladeElement_eq Q b n]

end Lift

/-! ## §3. A weight-preserving morphism that does not lift -/

/-- A relabelling of addresses swapping the two weight-`1` addresses `196883` and
    `196885` (both are distance `1` from `c(1) = 196884`), fixing everything
    else. -/
def swapAddr (n : ℕ) : ℕ :=
  if n = 196883 then 196885 else if n = 196885 then 196883 else n

/-- Both swapped addresses sit at conformal distance `1` from the `j`-spectrum. -/
theorem dist_196883 : distFromJ 196883 = 1 := by native_decide

theorem dist_196885 : distFromJ 196885 = 1 := by native_decide

/-- The swap preserves the conformal weight: both swapped addresses are distance
    `1` from the `j`-spectrum, and all other addresses are fixed. -/
theorem swapAddr_preserves (n : ℕ) : distFromJ (swapAddr n) = distFromJ n := by
  by_cases h1 : n = 196883
  · subst h1; simp [swapAddr, dist_196883, dist_196885]
  · by_cases h2 : n = 196885
    · subst h2; simp [swapAddr, dist_196883, dist_196885]
    · simp [swapAddr, h1, h2]

/-- The swap as a genuine scale endomorphism (a weight-preserving relabelling). -/
def swapHom : ScaleHom Scale.bit Scale.bit := ⟨swapAddr, swapAddr_preserves⟩

/-- `swapHom` sends `196883` to `196885`. -/
theorem swapHom_map_196883 : (swapHom.map 196883 : ℕ) = 196885 := by
  show swapAddr 196883 = 196885
  unfold swapAddr
  rw [if_pos rfl]

/-- `swapHom` preserves the conformal weight (it is a bona-fide scale morphism). -/
theorem swapHom_preserves_weight (n : ℕ) :
    moonshineWeight ((swapHom.map n : ℕ)) = moonshineWeight (n : ℕ) := by
  show distFromJ (swapHom.map n) = distFromJ n
  exact swapAddr_preserves n

set_option maxHeartbeats 400000 in
/-- `swapHom` even preserves the blade **grade** at the swapped address (both
    `196883` and `196885` have six bits set). -/
theorem swapHom_preserves_grade :
    bladeGrade ((swapHom.map 196883 : ℕ)) = bladeGrade (196883 : ℕ) := by
  rw [swapHom_map_196883]; native_decide

/-- `swapHom` is **not** address-preserving: it genuinely moves `196883`. -/
theorem swapHom_not_addr_preserving : ¬ swapHom.IsAddrPreserving := by
  intro h
  have := h 196883
  simp [swapHom, swapAddr] at this

/-- Despite preserving both the weight and the grade, `swapHom` **changes the
    Clifford blade**: the binary supports of `196883` and `196885` differ.  Hence
    for any faithful generator family the blade *element* changes too, so `swapHom`
    does not act compatibly with the Clifford embedding. -/
theorem swapHom_changes_blade :
    bladeOfAddr ((swapHom.map 196883 : ℕ)) ≠ bladeOfAddr (196883 : ℕ) := by
  rw [swapHom_map_196883]
  intro h
  have hmem : (1 : ℕ) ∈ bladeOfAddr (196885 : ℕ) ↔ (1 : ℕ) ∈ bladeOfAddr (196883 : ℕ) := by
    rw [h]
  have h83 : (1 : ℕ) ∈ bladeOfAddr (196883 : ℕ) := by
    unfold bladeOfAddr bladeSupport
    simp only [addr, id_eq, Finset.mem_filter, Finset.mem_range]
    refine ⟨by omega, ?_⟩
    native_decide
  have h85 : (1 : ℕ) ∉ bladeOfAddr (196885 : ℕ) := by
    unfold bladeOfAddr bladeSupport
    simp only [addr, id_eq, Finset.mem_filter, Finset.mem_range, not_and]
    intro _
    native_decide
  exact h85 (hmem.2 h83)

end RequestProject.Compute.CFT
