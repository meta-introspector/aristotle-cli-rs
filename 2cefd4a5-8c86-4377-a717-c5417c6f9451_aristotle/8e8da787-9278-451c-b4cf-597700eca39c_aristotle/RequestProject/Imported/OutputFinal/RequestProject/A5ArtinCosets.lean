/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

The 12 cosets of a Sylow 5-subgroup of `A₅` and the 12-point permutation
representation.
-/
import RequestProject.Imported.OutputFinal.RequestProject.A5ArtinOrbits

/-!
# The 12-point action of `A₅` on the cosets of a Sylow 5-subgroup

The character `χ_{π₁₂}` of the 12-point permutation representation of `A₅` — the
one carrying `1 ⊕ ρ₃ ⊕ ρ₃′ ⊕ ρ₅` — was recorded in
`RequestProject/A5ArtinConductor.lean` as a table.  Here the 12-point set is
realised concretely as the set of left cosets `g · S` of the fixed Sylow
5-subgroup `S = syl5 0` of `RequestProject/A5ArtinSylow.lean`, with `A₅` acting
by left translation, and the table becomes a fixed-point count.

* `lcoset g C = g · C`, with `lcoset_one`, `lcoset_mul`, `lcoset_injective`;
* `cosets12` — the set of the twelve left cosets of `sylS = syl5 0` inside `A₅`
  (`card_cosets12`), each of them a genuine coset of the subgroup
  `syl5Subgroup 0` (`coe_lcoset_sylS`), the set being stable under the action
  (`lcoset_mem_cosets12`);
* `lcoset_sylS_eq_self_iff` — the stabiliser of the base point is exactly the
  Sylow 5-subgroup;
* `chiPerm12_eq_card_fixed` — `χ_{π₁₂}(c)` is the number of cosets fixed by
  `rep c`;
* `chi3_add_chi3b_eq_sub`, `chi3_add_chi3b_eq_card_fixed_sub` — hence
  `χ₃ + χ₃′ = χ_{π₁₂} − 1 − χ₅` is *derived*: it is the number of fixed cosets
  minus the number of fixed Sylow 5-subgroups;
* `fixedDim_perm12_eq_numOrbits` — the `π₁₂` row of the invariant table is the
  number of orbits of the genuine subgroup `H.toSubgroup` on the twelve cosets.
-/

namespace A5Artin

open Cls IRep Equiv
open scoped Pointwise

set_option maxRecDepth 100000
set_option maxHeartbeats 2000000

/-! ## 1. Left cosets of a fixed Sylow 5-subgroup -/

/-- The fixed Sylow 5-subgroup `S = ⟨(0 1 2 3 4)⟩`, as a `Finset`. -/
def sylS : Finset (Perm (Fin 5)) := syl5 0

/-- Left translation of a set of permutations: `lcoset g C = g · C`. -/
def lcoset (g : Perm (Fin 5)) (C : Finset (Perm (Fin 5))) : Finset (Perm (Fin 5)) :=
  C.image fun x => g * x

@[simp] theorem mem_lcoset {g x : Perm (Fin 5)} {C : Finset (Perm (Fin 5))} :
    x ∈ lcoset g C ↔ ∃ y ∈ C, g * y = x := Finset.mem_image

theorem lcoset_one (C : Finset (Perm (Fin 5))) : lcoset 1 C = C := by
  simp [lcoset]

theorem lcoset_mul (g h : Perm (Fin 5)) (C : Finset (Perm (Fin 5))) :
    lcoset (g * h) C = lcoset g (lcoset h C) := by
  simp only [lcoset, Finset.image_image]
  refine Finset.image_congr ?_
  intro x _
  simp [mul_assoc]

theorem lcoset_injective (g : Perm (Fin 5)) : Function.Injective (lcoset g) := by
  intro C D h
  have h' : lcoset g⁻¹ (lcoset g C) = lcoset g⁻¹ (lcoset g D) := by rw [h]
  rwa [← lcoset_mul, ← lcoset_mul, inv_mul_cancel, lcoset_one, lcoset_one] at h'

/-- The set of left cosets of `sylS` inside `A₅`. -/
def cosets12 : Finset (Finset (Perm (Fin 5))) :=
  A5finset.image fun g => lcoset g sylS

theorem mem_cosets12 {C : Finset (Perm (Fin 5))} :
    C ∈ cosets12 ↔ ∃ g ∈ alternatingGroup (Fin 5), lcoset g sylS = C := by
  simp [cosets12, mem_A5finset]

/-- There are twelve of them: `|A₅| / |S| = 60 / 5`. -/
theorem card_cosets12 : cosets12.card = 12 := by decide +kernel

/-- Each element of `cosets12` really is a left coset of the genuine subgroup
`syl5Subgroup 0` of `Equiv.Perm (Fin 5)`. -/
theorem coe_lcoset_sylS (g : Perm (Fin 5)) :
    (↑(lcoset g sylS) : Set (Perm (Fin 5))) = g • (syl5Subgroup 0 : Set (Perm (Fin 5))) := by
  ext x
  simp only [Finset.coe_image, lcoset, Set.mem_image, Set.mem_smul_set,
    SetLike.mem_coe, mem_syl5Subgroup, sylS, smul_eq_mul]

/-- The stabiliser of the base point is exactly the Sylow 5-subgroup. -/
theorem lcoset_sylS_eq_self_iff {g : Perm (Fin 5)} : lcoset g sylS = sylS ↔ g ∈ syl5 0 := by
  constructor
  · intro h
    have : g ∈ lcoset g sylS := by
      refine mem_lcoset.2 ⟨1, ?_, by simp⟩
      simpa [sylS] using one_mem_syl5 0
    rw [h] at this
    simpa [sylS] using this
  · intro hg
    ext x
    rw [mem_lcoset]
    constructor
    · rintro ⟨y, hy, rfl⟩
      exact mul_mem_syl5 0 g hg y hy
    · intro hx
      refine ⟨g⁻¹ * x, ?_, by group⟩
      exact mul_mem_syl5 0 g⁻¹ (inv_mem_syl5 0 g hg) x hx

/-- The twelve cosets are permuted by left translation by elements of `A₅`. -/
theorem lcoset_mem_cosets12 {g : Perm (Fin 5)} (hg : g ∈ alternatingGroup (Fin 5))
    {C : Finset (Perm (Fin 5))} (hC : C ∈ cosets12) : lcoset g C ∈ cosets12 := by
  obtain ⟨h, hh, rfl⟩ := mem_cosets12.1 hC
  exact mem_cosets12.2 ⟨g * h, mul_mem hg hh, lcoset_mul g h sylS⟩

/-! ## 2. The character of the 12-point representation -/

/-- The character of the 12-point permutation representation is the number of
cosets of the Sylow 5-subgroup fixed by the class representative: the table
`chiPerm12` is a theorem. -/
theorem chiPerm12_eq_card_fixed (c : Cls) :
    chiPerm12 c = ((cosets12.filter fun C => lcoset (rep c) C = C).card : ℝ) := by
  cases c
  · rw [show (cosets12.filter fun C => lcoset (rep c1) C = C).card = 12 from by decide +kernel]
    norm_num [chiPerm12]
  · rw [show (cosets12.filter fun C => lcoset (rep c2) C = C).card = 0 from by decide +kernel]
    norm_num [chiPerm12]
  · rw [show (cosets12.filter fun C => lcoset (rep c3) C = C).card = 0 from by decide +kernel]
    norm_num [chiPerm12]
  · rw [show (cosets12.filter fun C => lcoset (rep c5A) C = C).card = 2 from by decide +kernel]
    norm_num [chiPerm12]
  · rw [show (cosets12.filter fun C => lcoset (rep c5B) C = C).card = 2 from by decide +kernel]
    norm_num [chiPerm12]

/-! ## 3. The sum `χ₃ + χ₃′` in derived form -/

/-- `χ₃ + χ₃′ = χ_{π₁₂} − χ₁ − χ₅`. -/
theorem chi3_add_chi3b_eq_sub (c : Cls) : chi3 c + chi3b c = chiPerm12 c - chi1 c - chi5 c := by
  rw [chiPerm12_eq c]; ring

/-- Hence `χ₃(c) + χ₃′(c)` is the number of cosets of a Sylow 5-subgroup fixed by
`rep c` minus the number of Sylow 5-subgroups fixed by `rep c`: both sides are
fixed-point counts of genuine actions, and no table intervenes. -/
theorem chi3_add_chi3b_eq_card_fixed_sub (c : Cls) :
    chi3 c + chi3b c =
      ((cosets12.filter fun C => lcoset (rep c) C = C).card : ℝ) -
        ((Finset.univ.filter fun i : Fin 6 => act6 (rep c) i = i).card : ℝ) := by
  rw [chi3_add_chi3b_eq_sub, chiPerm12_eq_card_fixed, chi5_eq_card_fixed_sub_one]
  simp only [chi1]
  ring

/-! ## 4. Orbits on the twelve cosets -/

/-- The orbit of a coset under the subgroup attached to `H`. -/
def orbit12 (H : Subgp) (C : Finset (Perm (Fin 5))) : Finset (Finset (Perm (Fin 5))) :=
  H.elems.image fun h => lcoset h C

/-- The same orbit as a set, defined through the genuine subgroup
`H.toSubgroup`. -/
def orbit12Set (H : Subgp) (C : Finset (Perm (Fin 5))) : Set (Finset (Perm (Fin 5))) :=
  {D | ∃ h ∈ H.toSubgroup, lcoset h C = D}

theorem coe_orbit12 (H : Subgp) (C : Finset (Perm (Fin 5))) :
    ↑(orbit12 H C) = orbit12Set H C := by
  ext D
  simp [orbit12, orbit12Set, Subgp.mem_toSubgroup]

/-- The number of orbits on the twelve cosets. -/
def orbitCount12 (H : Subgp) : ℕ := (cosets12.image (orbit12 H)).card

theorem ncard_orbit12Set_image (H : Subgp) :
    ((fun C => orbit12Set H C) '' ↑cosets12).ncard = orbitCount12 H := by
  have h : ((fun C => orbit12Set H C) '' ↑cosets12)
      = (fun s : Finset (Finset (Perm (Fin 5))) => (↑s : Set (Finset (Perm (Fin 5))))) ''
          ↑(cosets12.image (orbit12 H)) := by
    ext s
    simp only [Set.mem_image, Finset.coe_image, Finset.mem_coe]
    constructor
    · rintro ⟨C, hC, rfl⟩
      exact ⟨orbit12 H C, ⟨C, hC, rfl⟩, coe_orbit12 H C⟩
    · rintro ⟨t, ⟨C, hC, rfl⟩, rfl⟩
      exact ⟨C, hC, (coe_orbit12 H C).symm⟩
  rw [h, Set.ncard_image_of_injective _ Finset.coe_injective, Set.ncard_coe_finset]
  rfl

/-- **The invariants of the 12-point representation are the orbits.** -/
theorem fixedDim_perm12_eq_orbitCount12 (H : Subgp) : fixedDim perm12 H = orbitCount12 H := by
  revert H; decide +kernel

/-- `dim V^H` for the 12-point representation is the number of orbits of the
genuine subgroup `H.toSubgroup` on the twelve cosets. -/
theorem fixedDim_perm12_eq_numOrbits (H : Subgp) :
    fixedDim perm12 H = ((fun C => orbit12Set H C) '' ↑cosets12).ncard := by
  rw [ncard_orbit12Set_image, fixedDim_perm12_eq_orbitCount12]

end A5Artin
