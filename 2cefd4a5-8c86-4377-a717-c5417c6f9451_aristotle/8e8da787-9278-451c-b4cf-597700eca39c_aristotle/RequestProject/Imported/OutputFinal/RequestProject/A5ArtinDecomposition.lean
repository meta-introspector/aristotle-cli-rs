/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

One decomposition datum for the representations of `A₅`, and its three
consequences: characters, conductors, Euler factors.
-/
import RequestProject.Imported.OutputFinal.RequestProject.A5ArtinConductor

/-!
# One decomposition, three consequences

`RequestProject/A5Artin.lean` and `RequestProject/A5ArtinConductor.lean` record
the decomposition of the permutation representations `π₅, π₆, π₁₂` and of the
regular representation of `A₅` into irreducibles *three* times: once in the
character identities, once in the codimension/conductor identities, and once in
the local Euler factors.

This file introduces the decomposition once and for all,

  `decompose : IRep → List (ℕ × IRep)`,

and derives all three from it:

* `chi_eq_decompose` — the character identity `χ_R = Σ mᵢ χ_{Rᵢ}`;
* `codim_eq_decompose`, `condExpQ_eq_decompose`, `condExp_eq_decompose`,
  `artinConductor_eq_decompose` — the codimension identity and, from it, the
  conductor factorisation `N(R) = ∏ N(Rᵢ)^{mᵢ}`;
* `euler_eq_decompose` — the local Euler-factor identity
  `L_R(T) = ∏ L_{Rᵢ}(T)^{mᵢ}`, from which the already-proved identities
  `permPoly5_eq`, `permPoly6_eq`, `permPoly12_eq`, `regPoly_eq` are recovered
  (`permPoly5_eq_of_decompose`, …).

So "compatibility with the zeta factorisation" and "the conductor
factorisation" are now the same theorem, applied to the same datum.
-/

namespace A5Artin

open Cls IRep

/-! ## 1. The decomposition datum -/

/-- The decomposition of each representation of `A₅` in the list `IRep` into
irreducibles, as a list of pairs `(multiplicity, irreducible constituent)`:

  `π₅ = 1 ⊕ ρ₄`,  `π₆ = 1 ⊕ ρ₅`,  `π₁₂ = 1 ⊕ ρ₃ ⊕ ρ₃′ ⊕ ρ₅`,
  `ρ_reg = 1 ⊕ 3ρ₃ ⊕ 3ρ₃′ ⊕ 4ρ₄ ⊕ 5ρ₅`,

each irreducible being its own decomposition. -/
def decompose : IRep → List (ℕ × IRep)
  | r1 => [(1, r1)]
  | r3 => [(1, r3)]
  | r3b => [(1, r3b)]
  | r4 => [(1, r4)]
  | r5 => [(1, r5)]
  | perm5 => [(1, r1), (1, r4)]
  | perm6 => [(1, r1), (1, r5)]
  | perm12 => [(1, r1), (1, r3), (1, r3b), (1, r5)]
  | reg => [(1, r1), (3, r3), (3, r3b), (4, r4), (5, r5)]

/-- Every constituent listed by `decompose` is irreducible. -/
theorem decompose_irreducible (R : IRep) :
    ∀ q ∈ decompose R, q.2 = r1 ∨ q.2 = r3 ∨ q.2 = r3b ∨ q.2 = r4 ∨ q.2 = r5 := by
  cases R <;> decide

/-- Dimensions add up: `dim R = Σ mᵢ dim Rᵢ`. -/
theorem dim_eq_decompose (R : IRep) :
    R.dim = ((decompose R).map fun q => q.1 * q.2.dim).sum := by
  cases R <;> decide

/-! ## 2. First consequence: characters -/

/-- The character identity `χ_R = Σ mᵢ χ_{Rᵢ}`. -/
theorem chi_eq_decompose (R : IRep) (c : Cls) :
    R.chi c = ((decompose R).map fun q => (q.1 : ℝ) * q.2.chi c).sum := by
  cases R
  case perm5 => simpa [decompose, IRep.chi] using chiPerm5_eq c
  case perm6 => simpa [decompose, IRep.chi] using chiPerm6_eq c
  case perm12 =>
    have h := chiPerm12_eq c
    simp only [decompose, IRep.chi, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
      Nat.cast_one, one_mul, add_zero]
    rw [h]; ring
  case reg =>
    have h := chiReg_eq c
    simp only [decompose, IRep.chi, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
      Nat.cast_one, Nat.cast_ofNat, one_mul, add_zero]
    rw [h]; ring
  all_goals simp [decompose, IRep.chi]

/-! ## 3. Second consequence: codimensions and conductors -/

/-- The codimension identity `codim V_R^H = Σ mᵢ codim V_{Rᵢ}^H`, the local
input of the conductor factorisation. -/
theorem codim_eq_decompose (R : IRep) (H : Subgp) :
    codim R H = ((decompose R).map fun q => q.1 * codim q.2 H).sum := by
  cases R <;> cases H <;> decide

private theorem condQ_sum_list (F : Filt) (l : List (ℕ × IRep)) :
    condQ F (fun H => ((l.map fun q => (q.1 : ℚ) * (codim q.2 H : ℚ)).sum))
      = (l.map fun q => (q.1 : ℚ) * condExpQ q.2 F).sum := by
  induction l with
  | nil => simpa using condQ_zero F
  | cons q t ih =>
      have h : condQ F (fun H => ((q.1 : ℚ) * (codim q.2 H : ℚ)
            + ((t.map fun r => (r.1 : ℚ) * (codim r.2 H : ℚ)).sum)))
          = condQ F (fun H => (q.1 : ℚ) * (codim q.2 H : ℚ))
            + condQ F (fun H => ((t.map fun r => (r.1 : ℚ) * (codim r.2 H : ℚ)).sum)) :=
        condQ_add F _ _
      simp only [List.map_cons, List.sum_cons]
      rw [h, condQ_const_mul, ih]
      rfl

/-- The conductor exponent is additive along the decomposition (rational form). -/
theorem condExpQ_eq_decompose (R : IRep) (F : Filt) :
    condExpQ R F = ((decompose R).map fun q => (q.1 : ℚ) * condExpQ q.2 F).sum := by
  have hcast : ∀ H : Subgp, ((codim R H : ℚ))
      = ((decompose R).map fun q => (q.1 : ℚ) * (codim q.2 H : ℚ)).sum := by
    intro H
    have h := codim_eq_decompose R H
    have : (((decompose R).map fun q => q.1 * codim q.2 H).sum : ℚ)
        = ((decompose R).map fun q => (q.1 : ℚ) * (codim q.2 H : ℚ)).sum := by
      induction (decompose R) with
      | nil => simp
      | cons q t ih => push_cast [List.map_cons, List.sum_cons] at ih ⊢; rw [ih]
    rw [h, this]
  simp only [condExpQ]
  rw [condQ_congr F hcast, condQ_sum_list]
  simp only [condExpQ]

private theorem cast_sum_condExp (F : Filt) (h : Integral F) (l : List (ℕ × IRep)) :
    (((l.map fun q => q.1 * condExp q.2 F).sum : ℕ) : ℚ)
      = (l.map fun q => (q.1 : ℚ) * condExpQ q.2 F).sum := by
  induction l with
  | nil => simp
  | cons q t ih =>
      simp only [List.map_cons, List.sum_cons, Nat.cast_add, Nat.cast_mul, ih,
        condExp_cast (h q.2)]

/-- The conductor exponent is additive along the decomposition:
`a(R) = Σ mᵢ a(Rᵢ)`, whenever the individual terms of the filtration sum are
integral. -/
theorem condExp_eq_decompose {R : IRep} {F : Filt} (h : Integral F) :
    condExp R F = ((decompose R).map fun q => q.1 * condExp q.2 F).sum := by
  have h1 := condExpQ_eq_decompose R F
  rw [← condExp_cast (h R), ← cast_sum_condExp F h] at h1
  exact_mod_cast h1

private theorem prod_pow_split (p : ℕ) (l : List (ℕ × IRep)) (a : IRep → ℕ) (A : IRep → ℕ) :
    ((l.map fun q => (p ^ a q.2 * A q.2) ^ q.1).prod)
      = p ^ ((l.map fun q => q.1 * a q.2).sum) * (l.map fun q => A q.2 ^ q.1).prod := by
  induction l with
  | nil => simp
  | cons q t ih =>
      have hq : (p ^ a q.2 * A q.2) ^ q.1 = p ^ (q.1 * a q.2) * A q.2 ^ q.1 := by
        rw [mul_pow, ← pow_mul, mul_comm (a q.2) q.1]
      rw [List.map_cons, List.prod_cons, hq, ih, List.map_cons, List.sum_cons,
        List.map_cons, List.prod_cons, pow_add]
      ring

/-- **The conductor factorisation**: `N(R) = ∏ N(Rᵢ)^{mᵢ}`, one theorem for all
four decompositions.  Specialising `R` to `perm5`, `perm6`, `perm12`, `reg`
gives the conductor forms of the four factorisations of Dedekind zeta
functions. -/
theorem artinConductor_eq_decompose (R : IRep) :
    ∀ D : RamData, (∀ L ∈ D, Integral L.fil) →
      artinConductor R D = ((decompose R).map fun q => artinConductor q.2 D ^ q.1).prod := by
  intro D
  induction D with
  | nil =>
      intro _
      simp only [artinConductor, List.map_nil, List.prod_nil, one_pow]
      exact (List.prod_eq_one (by simp)).symm
  | cons L t ih =>
      intro h
      have hL : Integral L.fil := h L (by simp)
      have ht : ∀ K ∈ t, Integral K.fil := fun K hK => h K (by simp [hK])
      have hsplit := prod_pow_split L.p (decompose R) (fun S => condExp S L.fil)
        (fun S => artinConductor S t)
      simp only [artinConductor, List.map_cons, List.prod_cons] at ih hsplit ⊢
      rw [condExp_eq_decompose hL, ih ht, ← hsplit]

/-! ## 4. Third consequence: the local Euler factors -/

/-- The local factor of the trivial representation. -/
noncomputable def E1 : Cls → ℝ → ℝ := fun _ T => 1 - T

/-- The local Euler factor `det(1 − T·ρ(Frob))` of each representation in
`IRep`, over `ℝ` (the two 3-dimensional factors have coefficients in
`ℚ(√5)`). -/
noncomputable def IRep.euler : IRep → Cls → ℝ → ℝ
  | r1 => E1 | r3 => E3 | r3b => E3b | r4 => E4 | r5 => E5
  | perm5 => permPoly5 | perm6 => permPoly6 | perm12 => permPoly12 | reg => regPoly

/-- **The Euler-factor identity**: `L_R(T) = ∏ L_{Rᵢ}(T)^{mᵢ}`, from the same
decomposition datum as the conductor factorisation. -/
theorem euler_eq_decompose (R : IRep) (c : Cls) (T : ℝ) :
    R.euler c T = ((decompose R).map fun q => (q.2.euler c T) ^ q.1).prod := by
  cases R
  case perm5 =>
    simp only [decompose, IRep.euler, E1, List.map_cons, List.map_nil, List.prod_cons,
      List.prod_nil, pow_one, mul_one]
    exact permPoly5_eq c T
  case perm6 =>
    simp only [decompose, IRep.euler, E1, List.map_cons, List.map_nil, List.prod_cons,
      List.prod_nil, pow_one, mul_one]
    exact permPoly6_eq c T
  case perm12 =>
    have h := permPoly12_eq (R := ℝ) c T
    have h3 := E3_mul_E3b c T
    simp only [decompose, IRep.euler, E1, List.map_cons, List.map_nil, List.prod_cons,
      List.prod_nil, pow_one, mul_one]
    rw [h, ← h3]; ring
  case reg =>
    have h := regPoly_eq (R := ℝ) c T
    have h3 := E3_mul_E3b c T
    simp only [decompose, IRep.euler, E1, List.map_cons, List.map_nil, List.prod_cons,
      List.prod_nil, pow_one, mul_one]
    rw [h, ← h3]; ring
  all_goals
    simp only [decompose, IRep.euler, List.map_cons, List.map_nil, List.prod_cons,
      List.prod_nil, pow_one, mul_one]

/-! ### The four classical identities, recovered from the single datum -/

theorem permPoly5_eq_of_decompose (c : Cls) (T : ℝ) :
    permPoly5 c T = (1 - T) * E4 c T := by
  simpa [decompose, IRep.euler, E1] using euler_eq_decompose perm5 c T

theorem permPoly6_eq_of_decompose (c : Cls) (T : ℝ) :
    permPoly6 c T = (1 - T) * E5 c T := by
  simpa [decompose, IRep.euler, E1] using euler_eq_decompose perm6 c T

theorem permPoly12_eq_of_decompose (c : Cls) (T : ℝ) :
    permPoly12 c T = (1 - T) * (E3 c T * E3b c T) * E5 c T := by
  have h := euler_eq_decompose perm12 c T
  simp only [decompose, IRep.euler, E1, List.map_cons, List.map_nil, List.prod_cons,
    List.prod_nil, pow_one, mul_one] at h
  rw [h]; ring

theorem regPoly_eq_of_decompose (c : Cls) (T : ℝ) :
    regPoly c T = (1 - T) * (E3 c T) ^ 3 * (E3b c T) ^ 3 * (E4 c T) ^ 4 * (E5 c T) ^ 5 := by
  have h := euler_eq_decompose reg c T
  simp only [decompose, IRep.euler, E1, List.map_cons, List.map_nil, List.prod_cons,
    List.prod_nil, pow_one, mul_one] at h
  rw [h]; ring

end A5Artin
