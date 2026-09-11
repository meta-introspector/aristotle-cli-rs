import Mathlib

/-!
# Čech cohomology of the Serre twisting sheaves `O(d)` on the projective line

This file is a **standalone, supergeometry-free** development of the classical Čech
computation of the cohomology of the line bundles `O(d)` on `ℙ¹` over an arbitrary
field `K`.  It is the pure linear-algebra engine reused by the supergeometry application
in `RequestProject.Main`, but it has *no* dependency on that context and is phrased
entirely in terms of Laurent polynomials.

## Modelling

Over the standard two-chart cover `{U = Spec K[z], V = Spec K[z⁻¹]}` of `ℙ¹`, a Čech
`0`-cochain for the line bundle `O(d)` is a pair of Laurent polynomials, and the Čech
differential is the difference, taken in the overlap `Spec K[z, z⁻¹]`, after applying the
transition function `z ↦ z` for `O(d)` (so the `V`-sections are recorded in the
`z`-coordinate with degrees `≤ d`).  We model the ring of Laurent polynomials
`K[z, z⁻¹]` by the finitely supported functions `ℤ →₀ K`: a monomial `c · zʲ` is the
single-support function `j ↦ c`.

* `Upoly`     — the sections regular on `U`: nonnegative powers of `z` (`{j | 0 ≤ j}`).
* `Vpoly d`   — the sections regular on `V`, in the `z`-coordinate for `O(d)`:
  powers of `z` at most `d` (`{j | j ≤ d}`).

With this dictionary

* `H⁰(O(d)) = K[z] ∩ zᵈ·K[z⁻¹] = Upoly ⊓ Vpoly d`, the global sections, supported on
  `{0 ≤ j ≤ d}` (the degree-`d` forms), of dimension `max(0, d+1)`;
* `H¹(O(d)) = K[z, z⁻¹] / (K[z] + zᵈ·K[z⁻¹]) = (ℤ →₀ K) ⧸ (Upoly ⊔ Vpoly d)`, supported on
  the "middle" monomials `{d < j < 0}`, of dimension `max(0, -d-1)`.

These are exactly the classical values `h⁰(O(d)) = max(0, d+1)` and
`h¹(O(d)) = max(0, -d-1)` for `ℙ¹`.

## Main results

* `finrank_cechH0` : `dim H⁰(O(d)) = (d + 1).toNat`.
* `finrank_cechH1` : `dim H¹(O(d)) = (-d - 1).toNat`.
* `cechH0Equiv`, `cechH1Equiv` : explicit identifications with free modules on the
  surviving monomials, together with the corresponding `Module.Free`/`Module.Finite`
  instances.
* `cech_euler_char` : the Euler characteristic `h⁰ - h¹ = d + 1` (Riemann–Roch for `ℙ¹`).
-/

open Finsupp

namespace LaurentCohomology

variable (K : Type*) [Field K]

/-- Čech `0`-cochains regular on the chart `U`: Laurent polynomials with only nonnegative
powers of `z`, i.e. ordinary polynomials `K[z]`. -/
def Upoly : Submodule K (ℤ →₀ K) := Finsupp.supported K K {j : ℤ | 0 ≤ j}

/-- Čech `0`-cochains regular on the chart `V`, written in the `z`-coordinate via the
transition function for the line bundle `O(d)`: Laurent polynomials with powers of `z`
at most `d`, i.e. `zᵈ · K[z⁻¹]`. -/
def Vpoly (d : ℤ) : Submodule K (ℤ →₀ K) := Finsupp.supported K K {j : ℤ | j ≤ d}

/-- The zeroth Čech cohomology (the global sections) of the line bundle `O(d)` on `ℙ¹`,
modelled on Laurent polynomials `K[z, z⁻¹] ≅ (ℤ →₀ K)`:
`H⁰(O(d)) = K[z] ∩ zᵈ·K[z⁻¹]`. -/
abbrev cechH0 (d : ℤ) : Submodule K (ℤ →₀ K) := Upoly K ⊓ Vpoly K d

/-- The first Čech cohomology of the line bundle `O(d)` on `ℙ¹`, modelled on Laurent
polynomials `K[z, z⁻¹] ≅ (ℤ →₀ K)`:
`H¹(O(d)) = K[z, z⁻¹] / (K[z] + zᵈ·K[z⁻¹])`. -/
abbrev cechH1 (d : ℤ) := (ℤ →₀ K) ⧸ (Upoly K ⊔ Vpoly K d)

/-- The complement of `{j | 0 ≤ j} ∪ {j | j ≤ d}` is the "middle" open interval `(d, 0)`,
which indexes the monomials surviving in `H¹`. -/
theorem compl_supp_set (d : ℤ) :
    ({j : ℤ | 0 ≤ j} ∪ {j : ℤ | j ≤ d})ᶜ = (Set.Ioo d 0 : Set ℤ) := by
  ext; simp [Set.mem_Ioo]; tauto

/-- The two `0`-cochain subspaces span exactly the cochains supported on the union of the
two index sets. -/
theorem Upoly_sup_Vpoly (d : ℤ) :
    Upoly K ⊔ Vpoly K d
      = Finsupp.supported K K ({j : ℤ | 0 ≤ j} ∪ {j : ℤ | j ≤ d}) := by
  convert (Finsupp.supported_union _ _).symm

/-- `H⁰(O(d))` is the cochains supported on the closed interval `[0, d]` (the degree-`d`
forms). -/
theorem Upoly_inf_Vpoly (d : ℤ) :
    Upoly K ⊓ Vpoly K d = Finsupp.supported K K (Set.Icc (0 : ℤ) d) := by
  rw [Upoly, Vpoly, ← Finsupp.supported_inter]; rfl

/-- **Čech cohomology of `O(d)` on `ℙ¹`, degree `0`.** The global sections have dimension
`max(0, d+1)`, the classical `h⁰(ℙ¹, O(d))`. -/
theorem finrank_cechH0 (d : ℤ) :
    Module.finrank K (cechH0 K d) = (d + 1).toNat := by
  rw [show Module.finrank K (cechH0 K d)
        = Module.finrank K (Finsupp.supported K K (Set.Icc (0 : ℤ) d))
        from by rw [cechH0, Upoly_inf_Vpoly],
      (Finsupp.supportedEquivFinsupp (Set.Icc (0 : ℤ) d)).finrank_eq,
      Module.finrank_finsupp_self]
  rw [Fintype.card_ofFinset]; simp [Int.card_Icc]

/-- **Čech cohomology of `O(d)` on `ℙ¹`, degree `1`** (the building block of the
supergeometry application).  The first cohomology has dimension `max(0, -d-1)`, the
classical `h¹(ℙ¹, O(d))`, with explicit basis the "middle" monomials `{zʲ : d < j < 0}`. -/
theorem finrank_cechH1 (d : ℤ) :
    Module.finrank K (cechH1 K d) = (-d - 1).toNat := by
  have h_def : cechH1 K d ≃ₗ[K] (↥(Finsupp.supported K K (Set.Ioo d 0))) := by
    have h_compl : IsCompl (Upoly K ⊔ Vpoly K d)
        (Finsupp.supported K K (Set.Ioo d 0)) := by
      rw [Upoly_sup_Vpoly, ← compl_supp_set]
      exact ⟨Finsupp.disjoint_supported_supported disjoint_compl_right,
             Finsupp.codisjoint_supported_supported isCompl_compl.codisjoint⟩
    exact Submodule.quotientEquivOfIsCompl _ _ h_compl
  rw [h_def.finrank_eq,
      (Finsupp.supportedEquivFinsupp (Set.Ioo d 0)).finrank_eq,
      Module.finrank_finsupp_self]
  rw [Fintype.card_ofFinset]; simp [Int.card_Ioo]

/-- The explicit identification of `H⁰(O(d))` with the finite free module on the global
"degree-`d`" monomials `{zʲ : 0 ≤ j ≤ d}`, indexed by `Set.Icc 0 d`. -/
noncomputable def cechH0Equiv (d : ℤ) :
    cechH0 K d ≃ₗ[K] (↥(Set.Icc (0 : ℤ) d) →₀ K) :=
  (LinearEquiv.ofEq _ _ (Upoly_inf_Vpoly K d)).trans
    (Finsupp.supportedEquivFinsupp (Set.Icc (0 : ℤ) d))

/-- The explicit identification of `H¹(O(d))` with the finite free module on the "middle"
monomials `{zʲ : d < j < 0}`, indexed by `Set.Ioo d 0`. -/
noncomputable def cechH1Equiv (d : ℤ) :
    cechH1 K d ≃ₗ[K] (↥(Set.Ioo d 0) →₀ K) :=
  have h_compl : IsCompl (Upoly K ⊔ Vpoly K d) (Finsupp.supported K K (Set.Ioo d 0)) := by
    rw [Upoly_sup_Vpoly, ← compl_supp_set]
    exact ⟨Finsupp.disjoint_supported_supported disjoint_compl_right,
           Finsupp.codisjoint_supported_supported isCompl_compl.codisjoint⟩
  (Submodule.quotientEquivOfIsCompl _ _ h_compl).trans
    (Finsupp.supportedEquivFinsupp (Set.Ioo d 0))

instance instFreeCechH1 (d : ℤ) : Module.Free K (cechH1 K d) :=
  Module.Free.of_equiv (cechH1Equiv K d).symm

instance instFiniteCechH1 (d : ℤ) : Module.Finite K (cechH1 K d) :=
  Module.Finite.equiv (cechH1Equiv K d).symm

instance instFreeCechH0 (d : ℤ) : Module.Free K (cechH0 K d) :=
  Module.Free.of_equiv (cechH0Equiv K d).symm

instance instFiniteCechH0 (d : ℤ) : Module.Finite K (cechH0 K d) :=
  Module.Finite.equiv (cechH0Equiv K d).symm

/-- **Riemann–Roch for `ℙ¹`.** The Euler characteristic of `O(d)` is
`h⁰(O(d)) - h¹(O(d)) = d + 1`. -/
theorem cech_euler_char (d : ℤ) :
    (Module.finrank K (cechH0 K d) : ℤ) - Module.finrank K (cechH1 K d) = d + 1 := by
  rw [finrank_cechH0, finrank_cechH1]; omega

end LaurentCohomology
