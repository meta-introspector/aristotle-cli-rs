/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

Invariant dimensions of the permutation representations as orbit counts.
-/
import RequestProject.Imported.OutputFinal.RequestProject.A5ArtinSylow

/-!
# `fixedDim` for the permutation representations is an orbit count

For a permutation representation the dimension of the space of `H`-invariants is
the number of orbits of `H` on the underlying set.  The conductor computation of
`RequestProject/A5ArtinConductor.lean` uses `fixedDim perm5` and `fixedDim
perm6` (through `codim perm5 = codim r4` and `codim perm6 = codim r5`) from a
table; this file proves that those two rows of the table are the orbit counts of
the *genuine* subgroups `H.toSubgroup ≤ Equiv.Perm (Fin 5)` of
`RequestProject/A5ArtinSubgroup.lean`:

* on `Fin 5`, for the natural action (`fixedDim_perm5_eq_numOrbits`), where the
  orbits are literally `MulAction.orbit H.toSubgroup i` (`orbit5Set_eq_orbit`);
* on the six Sylow 5-subgroups, for the conjugation action `act6`
  (`fixedDim_perm6_eq_numOrbits`).

Together with `chiPerm5_eq_card_fixed`, `chiPerm6_eq_card_fixed` and
`chi4_eq_sub`, `chi5_eq_sub`, the rows of the invariant table used for `ρ₄` and
`ρ₅` are therefore derived from the group `Equiv.Perm (Fin 5)` and nothing
else.
-/

namespace A5Artin

open Cls IRep Equiv

set_option maxRecDepth 100000

/-! ## 1. Orbits on `Fin 5` -/

/-- The orbit of `i` under the subgroup attached to `H`, as a `Finset`. -/
def orbit5 (H : Subgp) (i : Fin 5) : Finset (Fin 5) := H.elems.image fun h => h i

/-- The same orbit as a set, defined through the genuine subgroup
`H.toSubgroup`. -/
def orbit5Set (H : Subgp) (i : Fin 5) : Set (Fin 5) := {j | ∃ h ∈ H.toSubgroup, h i = j}

theorem coe_orbit5 (H : Subgp) (i : Fin 5) : ↑(orbit5 H i) = orbit5Set H i := by
  ext j
  simp [orbit5, orbit5Set, Subgp.mem_toSubgroup]

/-- The orbit set really is the `MulAction` orbit of the subgroup. -/
theorem orbit5Set_eq_orbit (H : Subgp) (i : Fin 5) :
    orbit5Set H i = MulAction.orbit H.toSubgroup i := by
  ext j
  constructor
  · rintro ⟨h, hh, rfl⟩
    exact ⟨⟨h, hh⟩, rfl⟩
  · rintro ⟨⟨h, hh⟩, rfl⟩
    exact ⟨h, hh, rfl⟩

/-- The number of orbits on `Fin 5`, computed as a `Finset` cardinality. -/
def orbitCount5 (H : Subgp) : ℕ := (Finset.univ.image (orbit5 H)).card

theorem ncard_range_orbit5Set (H : Subgp) :
    (Set.range fun i : Fin 5 => orbit5Set H i).ncard = orbitCount5 H := by
  have h : (Set.range fun i : Fin 5 => orbit5Set H i)
      = (fun s : Finset (Fin 5) => (↑s : Set (Fin 5))) '' ↑(Finset.univ.image (orbit5 H)) := by
    ext s
    simp only [Set.mem_range, Set.mem_image, Finset.coe_image, Finset.coe_univ, Set.image_univ]
    constructor
    · rintro ⟨i, rfl⟩
      exact ⟨orbit5 H i, ⟨i, rfl⟩, coe_orbit5 H i⟩
    · rintro ⟨t, ⟨i, rfl⟩, rfl⟩
      exact ⟨i, (coe_orbit5 H i).symm⟩
  rw [h, Set.ncard_image_of_injective _ Finset.coe_injective, Set.ncard_coe_finset]
  rfl

/-- **The invariants of the 5-point representation are the orbits.** -/
theorem fixedDim_perm5_eq_orbitCount5 (H : Subgp) : fixedDim perm5 H = orbitCount5 H := by
  revert H; decide

/-- `dim V^H` for the 5-point representation is the number of orbits of the
genuine subgroup `H.toSubgroup` on `Fin 5`. -/
theorem fixedDim_perm5_eq_numOrbits (H : Subgp) :
    fixedDim perm5 H = (Set.range fun i : Fin 5 => MulAction.orbit H.toSubgroup i).ncard := by
  simp only [← orbit5Set_eq_orbit]
  rw [ncard_range_orbit5Set, fixedDim_perm5_eq_orbitCount5]

/-! ## 2. Orbits on the six Sylow 5-subgroups -/

/-- The orbit of the `i`-th Sylow 5-subgroup under the subgroup attached to
`H`. -/
def orbit6 (H : Subgp) (i : Fin 6) : Finset (Fin 6) := H.elems.image fun h => act6 h i

/-- The same orbit as a set, defined through the genuine subgroup
`H.toSubgroup`. -/
def orbit6Set (H : Subgp) (i : Fin 6) : Set (Fin 6) := {j | ∃ h ∈ H.toSubgroup, act6 h i = j}

theorem coe_orbit6 (H : Subgp) (i : Fin 6) : ↑(orbit6 H i) = orbit6Set H i := by
  ext j
  simp [orbit6, orbit6Set, Subgp.mem_toSubgroup]

/-- The number of orbits on the six Sylow 5-subgroups. -/
def orbitCount6 (H : Subgp) : ℕ := (Finset.univ.image (orbit6 H)).card

theorem ncard_range_orbit6Set (H : Subgp) :
    (Set.range fun i : Fin 6 => orbit6Set H i).ncard = orbitCount6 H := by
  have h : (Set.range fun i : Fin 6 => orbit6Set H i)
      = (fun s : Finset (Fin 6) => (↑s : Set (Fin 6))) '' ↑(Finset.univ.image (orbit6 H)) := by
    ext s
    simp only [Set.mem_range, Set.mem_image, Finset.coe_image, Finset.coe_univ, Set.image_univ]
    constructor
    · rintro ⟨i, rfl⟩
      exact ⟨orbit6 H i, ⟨i, rfl⟩, coe_orbit6 H i⟩
    · rintro ⟨t, ⟨i, rfl⟩, rfl⟩
      exact ⟨i, (coe_orbit6 H i).symm⟩
  rw [h, Set.ncard_image_of_injective _ Finset.coe_injective, Set.ncard_coe_finset]
  rfl

/-- **The invariants of the 6-point representation are the orbits** of the
conjugation action on the six Sylow 5-subgroups. -/
theorem fixedDim_perm6_eq_orbitCount6 (H : Subgp) : fixedDim perm6 H = orbitCount6 H := by
  revert H; decide +kernel

/-- `dim V^H` for the 6-point representation is the number of orbits of the
genuine subgroup `H.toSubgroup` on the six Sylow 5-subgroups. -/
theorem fixedDim_perm6_eq_numOrbits (H : Subgp) :
    fixedDim perm6 H = (Set.range fun i : Fin 6 => orbit6Set H i).ncard := by
  rw [ncard_range_orbit6Set, fixedDim_perm6_eq_orbitCount6]

/-! ## 3. The rows for `ρ₄` and `ρ₅` -/

/-- The invariants of `ρ₄` are those of the 5-point representation minus the
trivial summand: hence an orbit count. -/
theorem fixedDim_r4_add_one (H : Subgp) : fixedDim r4 H + 1 = fixedDim perm5 H := by
  revert H; decide

/-- The invariants of `ρ₅` are those of the 6-point representation minus the
trivial summand: hence an orbit count. -/
theorem fixedDim_r5_add_one (H : Subgp) : fixedDim r5 H + 1 = fixedDim perm6 H := by
  revert H; decide

/-- `dim V^H` for `ρ₄`, as an orbit count of the genuine subgroup. -/
theorem fixedDim_r4_add_one_eq_numOrbits (H : Subgp) :
    fixedDim r4 H + 1 = (Set.range fun i : Fin 5 => MulAction.orbit H.toSubgroup i).ncard := by
  rw [fixedDim_r4_add_one, fixedDim_perm5_eq_numOrbits]

/-- `dim V^H` for `ρ₅`, as an orbit count of the genuine subgroup. -/
theorem fixedDim_r5_add_one_eq_numOrbits (H : Subgp) :
    fixedDim r5 H + 1 = (Set.range fun i : Fin 6 => orbit6Set H i).ncard := by
  rw [fixedDim_r5_add_one, fixedDim_perm6_eq_numOrbits]

end A5Artin
