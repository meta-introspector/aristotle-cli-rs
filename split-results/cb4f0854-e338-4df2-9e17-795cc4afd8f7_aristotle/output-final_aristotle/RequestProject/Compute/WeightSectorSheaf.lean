/-
# WeightSectorSheaf — the sheaf of conformal-weight sectors over the weight line

`RequestProject.Compute.ConformalWeightGrading` decomposed the address line (and,
via the colimit, the global CFT state space) into the conformal-weight sectors
`weightFiber w` — the addresses whose distance from the `j`-spectrum is exactly
`w`.  This file builds the **sheaf layer** on top of that grading: it organizes
the discrete family `w ↦ weightFiber w` into an honest sheaf over the *weight
line* `ℕ` (carrying its discrete topology, so every subset is open).

## What is built here

1. `WeightSection U` — the sections of the weight-sector presheaf over an open
   set `U ⊆ ℕ` of weights: a choice, for each weight `w ∈ U`, of an address whose
   conformal weight is exactly `w`.  Restriction along inclusions (`restrict`)
   makes this a presheaf, with the functoriality laws `restrict_id` /
   `restrict_restrict`.

2. **It is a sheaf.**  Over the discrete weight line the presheaf already
   satisfies the sheaf axioms:
   * `WeightSection.separated` — a section is determined by its restrictions to an
     open cover (locality / separatedness);
   * `WeightSection.gluing` — a compatible family of local sections over a cover
     glues to a section over the union;
   * `WeightSection.isSheaf` — the two together: the gluing exists and is unique.
   Sheafification is therefore the identity on this presheaf.

3. **The stalks are the weight sectors.**  `WeightSection.stalkEquiv` identifies
   the stalk at a weight `w` (sections over the singleton `{w}`) with
   `weightFiber w`, and `WeightSection.globalEquiv` identifies the global sections
   with the full product `Π w, weightFiber w`.

4. **Every sector is inhabited.**  `weightFiber_nonempty` shows each conformal
   weight is realized — beyond the largest `j`-coefficient the nearest coefficient
   is constant, so `maxJ + w` has weight exactly `w` — and hence the sheaf admits
   a global section (`WeightSection.global_nonempty`).
-/

import Mathlib
import RequestProject.Compute.ConformalWeightGrading

namespace RequestProject.Compute.CFT

open RequestProject.Compute.DistanceFromJ

/-! ## §1. The weight-sector presheaf -/

/-- Sections of the weight-sector presheaf over an open set `U ⊆ ℕ` of weights: a
    choice, for each weight `w ∈ U`, of an address whose conformal weight is `w`. -/
def WeightSection (U : Set ℕ) : Type := (w : U) → weightFiber (w : ℕ)

/-- Restriction of a section along an inclusion `V ⊆ U`. -/
def WeightSection.restrict {U V : Set ℕ} (h : V ⊆ U) (s : WeightSection U) :
    WeightSection V := fun w => s ⟨(w : ℕ), h w.2⟩

/-- Restriction along the identity inclusion is the identity. -/
@[simp] theorem WeightSection.restrict_id {U : Set ℕ} (s : WeightSection U) :
    s.restrict (subset_refl U) = s := rfl

/-- Restriction is functorial: restricting along `W ⊆ V` then `V ⊆ U` equals
    restricting along `W ⊆ U`. -/
theorem WeightSection.restrict_restrict {U V W : Set ℕ} (hVU : V ⊆ U) (hWV : W ⊆ V)
    (s : WeightSection U) :
    (s.restrict hVU).restrict hWV = s.restrict (hWV.trans hVU) := rfl

/-! ## §2. The sheaf axioms -/

/-
**Separatedness (locality).**  A section over `S` is determined by its
    restrictions to any open cover `U` of `S`.
-/
theorem WeightSection.separated {S : Set ℕ} {ι : Type*} (U : ι → Set ℕ)
    (hUS : ∀ i, U i ⊆ S) (hcover : S ⊆ ⋃ i, U i)
    (s t : WeightSection S)
    (h : ∀ i, s.restrict (hUS i) = t.restrict (hUS i)) : s = t := by
  funext w;
  obtain ⟨ i, hi ⟩ := Set.mem_iUnion.mp ( hcover w.2 );
  convert congr_fun ( h i ) ⟨ w, hi ⟩

/-- Compatibility of a family of local sections: they agree on overlaps. -/
def WeightSection.Compatible {ι : Type*} (U : ι → Set ℕ)
    (s : (i : ι) → WeightSection (U i)) : Prop :=
  ∀ (i j : ι) (w : ℕ) (hi : w ∈ U i) (hj : w ∈ U j), s i ⟨w, hi⟩ = s j ⟨w, hj⟩

/-
**Gluing.**  A compatible family of local sections over an open cover `U` of
    `S` glues to a section over `S` restricting to each member of the family.
-/
theorem WeightSection.gluing {S : Set ℕ} {ι : Type*} (U : ι → Set ℕ)
    (hUS : ∀ i, U i ⊆ S) (hcover : S ⊆ ⋃ i, U i)
    (s : (i : ι) → WeightSection (U i)) (hs : WeightSection.Compatible U s) :
    ∃ t : WeightSection S, ∀ i, t.restrict (hUS i) = s i := by
  -- By the hypothesis `hcover`, for every `w` in `S`, there exists an `i` such that `w` is in `U i`.
  have h_exists_i : ∀ w : S, ∃ i : ι, w.val ∈ U i := by
    exact fun w => by simpa using hcover w.2;
  choose f hf using h_exists_i;
  use fun w => s (f w) ⟨w, hf w⟩;
  intro i; funext w; exact hs ( f ⟨ w, hUS i w.2 ⟩ ) i w ( hf ⟨ w, hUS i w.2 ⟩ ) w.2;

/-- **The weight-sector presheaf is a sheaf.**  A compatible family over an open
    cover glues to a *unique* global section.  (Over the discrete weight line the
    presheaf is already a sheaf, so sheafification is the identity.) -/
theorem WeightSection.isSheaf {S : Set ℕ} {ι : Type*} (U : ι → Set ℕ)
    (hUS : ∀ i, U i ⊆ S) (hcover : S ⊆ ⋃ i, U i)
    (s : (i : ι) → WeightSection (U i)) (hs : WeightSection.Compatible U s) :
    ∃! t : WeightSection S, ∀ i, t.restrict (hUS i) = s i := by
  obtain ⟨t, ht⟩ := WeightSection.gluing U hUS hcover s hs
  refine ⟨t, ht, fun t' ht' => ?_⟩
  exact WeightSection.separated U hUS hcover t' t (fun i => by rw [ht', ht])

/-! ## §3. Stalks are the weight sectors -/

/-- **The stalk at a weight is its conformal-weight sector.**  Sections over the
    singleton open `{w}` are exactly the elements of `weightFiber w`. -/
def WeightSection.stalkEquiv (w : ℕ) : WeightSection ({w} : Set ℕ) ≃ weightFiber w where
  toFun s := s ⟨w, rfl⟩
  invFun a := fun x => cast (congrArg weightFiber (Set.mem_singleton_iff.1 x.2)).symm a
  left_inv := by
    intro s; funext x; rcases x with ⟨xv, hx⟩; rw [Set.mem_singleton_iff] at hx; subst hx; rfl
  right_inv := by
    intro a; simp

/-- **Global sections are the full product of sectors.**  A global section is a
    choice of an address for every conformal weight. -/
def WeightSection.globalEquiv :
    WeightSection (Set.univ : Set ℕ) ≃ ((w : ℕ) → weightFiber w) where
  toFun s w := s ⟨w, Set.mem_univ w⟩
  invFun f := fun w => f (w : ℕ)
  left_inv := fun s => funext fun w => by cases w; rfl
  right_inv := fun f => rfl

/-! ## §4. Every conformal-weight sector is inhabited -/

/-- Beyond the largest `j`-coefficient the nearest coefficient is constant, so the
    distance-from-`J` of `maxJ + n` is exactly `n`. -/
theorem distFromJ_add_maxJ (n : ℕ) :
    distFromJ (22567393309593600 + n) = n := by
  unfold distFromJ jValues absDiff
  simp only [List.map_cons, List.map_nil, List.min?_cons, List.min?_nil, Option.elim,
    Option.getD_some]
  omega

/-- **Every conformal weight is realized.**  The address `maxJ + w` lies in the
    weight-`w` sector. -/
theorem weightFiber_nonempty (w : ℕ) : Nonempty (weightFiber w) :=
  ⟨⟨22567393309593600 + w, distFromJ_add_maxJ w⟩⟩

/-- **The sheaf admits a global section.**  Since every sector is inhabited, there
    is a global choice of an address for each conformal weight. -/
theorem WeightSection.global_nonempty :
    Nonempty (WeightSection (Set.univ : Set ℕ)) :=
  ⟨fun w => (weightFiber_nonempty (w : ℕ)).some⟩

end RequestProject.Compute.CFT