/-
Copyright (c) 2026. Released under Apache 2.0 license.
-/
import Mathlib

/-!
# The Doud–Moore even icosahedral field of prime conductor 1951

This file records, as *data*, the quintic

  `f₁₉₅₁ = X^5 - X^4 - 780 X^3 - 1795 X^2 + 3106 X + 344`

from Doud–Moore, *Even icosahedral Galois representations of prime conductor*
(arXiv:math/0405534).  Its Galois closure is an `A₅`-extension of `ℚ`, the field is
totally real, and the associated projective representation
`Gal(ℚ̄/ℚ) → PGL₂(ℂ)` is *even* icosahedral of Artin conductor the prime `1951`
(the smallest prime conductor of an even icosahedral representation).

## What is proved here

* `poly1951` is monic of degree `5`;
* `condPrime = 1951` is prime;
* `poly1951` is **irreducible** over `ℚ` — proved honestly, by checking that its
  reduction mod `3` has no linear and no quadratic factor over `𝔽₃`;
* `poly1951` is **totally real**: it splits over `ℝ` (five distinct real roots,
  located by the intermediate value theorem);
* the recorded discriminant `disc1951` is a perfect square.

## What is proved elsewhere in the library

`Gal(f₁₉₅₁) ≅ A₅` is the fourth field of the bundling structure `EvenIcosahedral1951` below.
It is not proved in this file, but it *is* proved, in `ArtinA5Even.GalA5`
(`gal1951_equiv_alternating`), using the discriminant computation of
`ArtinA5Even.Discr1951`; `ArtinA5Even.evenIcosahedral1951` is a term of the structure.

## What is *not* proved anywhere

No lift `ρ̃ : Gal(ℚ̄/ℚ) → SL₂(ℂ) = 2.A₅` is constructed, no matrices in `SL₂(ℂ)` are
written down, no `L`-function statement is made, and no Artin-conjecture or
modularity claim of any kind is asserted.  See `docs/ARTIN_A5_EVEN_1951.md`.
-/

set_option maxHeartbeats 1000000

namespace ArtinA5Even

open Polynomial

/-! ## Task 1: the quintic, as data -/

/-- The Doud–Moore quintic of prime conductor `1951`:
`X^5 - X^4 - 780 X^3 - 1795 X^2 + 3106 X + 344`. -/
noncomputable def poly1951 : ℤ[X] :=
  X ^ 5 - X ^ 4 - 780 * X ^ 3 - 1795 * X ^ 2 + 3106 * X + 344

theorem poly1951_monic : poly1951.Monic := by
  unfold poly1951; monicity!

theorem poly1951_natDegree : poly1951.natDegree = 5 := by
  unfold poly1951; compute_degree!

theorem poly1951_degree : poly1951.degree = 5 := by
  unfold poly1951; compute_degree!

/-- The conductor of the associated (projective) even icosahedral representation. -/
def condPrime : ℕ := 1951

theorem condPrime_prime : Nat.Prime condPrime := by
  unfold condPrime; norm_num

/-- The discriminant of `poly1951`.

This value is *recorded data*, computed outside Lean as the Sylvester resultant
`Res(f, f')`; Mathlib has no polynomial discriminant, so nothing in this file derives
it.  It factors as `(2 · 7 · 71 · 137 · 1951²)²`, and in particular is a square —
consistent with (but not a proof of) the Galois group being contained in `A₅`. -/
def disc1951 : ℤ := 268684727248076769842884

theorem disc1951_eq : disc1951 = (2 * 7 * 71 * 137 * 1951 ^ 2) ^ 2 := by
  unfold disc1951; norm_num

theorem disc1951_isSquare : IsSquare disc1951 :=
  ⟨518348075378, by unfold disc1951; norm_num⟩

/-! ### Irreducibility, via reduction mod 3 -/

/-- The reduction of `poly1951` modulo `3`. -/
noncomputable def poly1951Mod3 : (ZMod 3)[X] := X ^ 5 + 2 * X ^ 4 + 2 * X ^ 2 + X + 2

theorem poly1951_map_three :
    poly1951.map (Int.castRingHom (ZMod 3)) = poly1951Mod3 := by
  have e1 : (780 : (ZMod 3)[X]) = 0 := by
    rw [← Polynomial.C_ofNat, show ((780 : ZMod 3)) = 0 by decide, map_zero]
  have e2 : (1795 : (ZMod 3)[X]) = 1 := by
    rw [← Polynomial.C_ofNat, show ((1795 : ZMod 3)) = 1 by decide, map_one]
  have e3 : (3106 : (ZMod 3)[X]) = 1 := by
    rw [← Polynomial.C_ofNat, show ((3106 : ZMod 3)) = 1 by decide, map_one]
  have e4 : (344 : (ZMod 3)[X]) = 2 := by
    rw [← Polynomial.C_ofNat, show ((344 : ZMod 3)) = 2 by decide, Polynomial.C_ofNat]
  have e5 : (2 : (ZMod 3)[X]) = -1 := by
    rw [← Polynomial.C_ofNat, show ((2 : ZMod 3)) = -1 by decide, map_neg, map_one]
  simp only [poly1951, poly1951Mod3, Polynomial.map_add, Polynomial.map_sub, Polynomial.map_mul,
    Polynomial.map_pow, Polynomial.map_X, Polynomial.map_ofNat, e1, e2, e3, e4, e5]
  ring

/-- A monic quadratic over a field is `X² + bX + c`. -/
theorem monic_quadratic_normal_form {K : Type*} [Field K] {g : K[X]} (hm : g.Monic)
    (hd : g.natDegree = 2) : ∃ b c : K, g = X ^ 2 + C b * X + C c := by
  have hdeg : g.degree = 2 := by rw [degree_eq_natDegree hm.ne_zero, hd]; rfl
  have hX : (X ^ 2 : K[X]).degree = 2 := by simp
  have hlt : (g - X ^ 2).degree < 2 := by
    have h := Polynomial.degree_sub_lt (p := g) (q := (X ^ 2 : K[X]))
      (by rw [hdeg, hX]) hm.ne_zero (by rw [hm.leadingCoeff, (monic_X_pow (R := K) 2).leadingCoeff])
    rwa [hdeg] at h
  by_cases hz : g - X ^ 2 = 0
  · exact ⟨0, 0, by simp; linear_combination (norm := ring_nf) hz⟩
  · have hnd : (g - X ^ 2).natDegree ≤ 1 :=
      Nat.lt_succ_iff.mp ((Polynomial.natDegree_lt_iff_degree_lt hz).mpr hlt)
    obtain ⟨a, b, hab⟩ := Polynomial.exists_eq_X_add_C_of_natDegree_le_one hnd
    exact ⟨a, b, by linear_combination (norm := ring_nf) hab⟩

/-- A monic quintic over a field with no root and no monic quadratic factor is irreducible. -/
theorem quintic_irreducible_criterion {K : Type*} [Field K] {f : K[X]} (hm : f.Monic)
    (hd : f.natDegree = 5) (h1 : ∀ c : K, f.eval c ≠ 0)
    (h2 : ∀ b c : K, ¬ (X ^ 2 + C b * X + C c) ∣ f) : Irreducible f := by
  constructor
  · exact fun h => by simpa [hd] using Polynomial.natDegree_eq_zero_of_isUnit h
  · rintro a b rfl
    have hane : a ≠ 0 := left_ne_zero_of_mul hm.ne_zero
    have hbne : b ≠ 0 := right_ne_zero_of_mul hm.ne_zero
    have hsum : a.natDegree + b.natDegree = 5 := by
      rw [← hd, Polynomial.natDegree_mul hane hbne]
    have key : ∀ p q : K[X], p * q = a * b → p ≠ 0 → p.natDegree = 1 ∨ p.natDegree = 2 →
        False := by
      intro p q hpq hp hdeg
      rcases hdeg with h | h
      · obtain ⟨x, hx⟩ := Polynomial.exists_root_of_degree_eq_one
          (p := p) (by rw [Polynomial.degree_eq_natDegree hp, h]; rfl)
        refine h1 x ?_
        rw [← hpq]
        simp [Polynomial.IsRoot.def] at hx ⊢
        simp [hx]
      · set g : K[X] := C (p.leadingCoeff)⁻¹ * p with hg
        have hlc : p.leadingCoeff ≠ 0 := Polynomial.leadingCoeff_ne_zero.mpr hp
        have hgm : g.Monic := by
          simpa [hg, Polynomial.Monic, Polynomial.leadingCoeff_mul, Polynomial.leadingCoeff_C]
            using inv_mul_cancel₀ hlc
        have hgd : g.natDegree = 2 := by
          rw [hg, Polynomial.natDegree_C_mul (inv_ne_zero hlc), h]
        obtain ⟨u, v, huv⟩ := monic_quadratic_normal_form hgm hgd
        refine h2 u v ⟨C (p.leadingCoeff) * q, ?_⟩
        rw [← hpq, ← huv, hg,
          show (C p.leadingCoeff⁻¹ * p) * (C p.leadingCoeff * q)
            = (C p.leadingCoeff⁻¹ * C p.leadingCoeff) * (p * q) from by ring,
          ← Polynomial.C_mul, inv_mul_cancel₀ hlc, map_one, one_mul]
    by_cases hA : a.natDegree = 0
    · exact Or.inl (Polynomial.isUnit_iff.mpr ⟨a.coeff 0,
        isUnit_iff_ne_zero.mpr (fun h0 => hane (by
          rw [Polynomial.eq_C_of_natDegree_eq_zero hA, h0, map_zero])),
        (Polynomial.eq_C_of_natDegree_eq_zero hA).symm⟩)
    · by_cases hB : b.natDegree = 0
      · exact Or.inr (Polynomial.isUnit_iff.mpr ⟨b.coeff 0,
          isUnit_iff_ne_zero.mpr (fun h0 => hbne (by
            rw [Polynomial.eq_C_of_natDegree_eq_zero hB, h0, map_zero])),
          (Polynomial.eq_C_of_natDegree_eq_zero hB).symm⟩)
      · exfalso
        rcases Nat.lt_or_ge a.natDegree 3 with h | h
        · exact key a b rfl hane (by omega)
        · exact key b a (mul_comm _ _) hbne (by omega)

/-- If `f = g q + r` with `r` a nonzero remainder of degree `< 2 = deg g`, then `g ∤ f`. -/
theorem not_dvd_of_rem {K : Type*} [Field K] {g f q r : K[X]} (hfe : f = g * q + r)
    (hrd : r.degree = 1 ∨ r.degree = 0) (hgd : g.degree = 2) : ¬ g ∣ f := by
  have hr : r ≠ 0 := by
    intro h
    rcases hrd with h1 | h1 <;> rw [h, Polynomial.degree_zero] at h1 <;>
      exact absurd h1 (by decide)
  have hrd' : r.degree ≤ 1 := by
    rcases hrd with h1 | h1
    · rw [h1]
    · rw [h1]; decide
  rintro ⟨s, hs⟩
  have hgr : g ∣ r := ⟨s - q, by rw [mul_sub, ← hs, hfe]; ring⟩
  have hle := Polynomial.degree_le_of_dvd hgr hr
  rw [hgd] at hle
  exact absurd (hle.trans hrd') (by decide)

theorem poly1951Mod3_no_root (c : ZMod 3) : poly1951Mod3.eval c ≠ 0 := by
  revert c
  simp only [poly1951Mod3, Polynomial.eval_add, Polynomial.eval_mul, Polynomial.eval_pow,
    Polynomial.eval_X, Polynomial.eval_ofNat]
  decide

theorem poly1951Mod3_no_quadratic_factor (b c : ZMod 3) :
    ¬ (X ^ 2 + C b * X + C c) ∣ poly1951Mod3 := by
  have h3 : (3 : (ZMod 3)[X]) = 0 := by
    rw [← Polynomial.C_ofNat, show ((3 : ZMod 3)) = 0 by decide, map_zero]
  have hall : ∀ x : ZMod 3, x = 0 ∨ x = 1 ∨ x = 2 := by decide
  simp only [poly1951Mod3]
  rcases hall b with rfl | rfl | rfl <;> rcases hall c with rfl | rfl | rfl <;>
    simp only [map_zero, map_one, Polynomial.C_ofNat]
  · exact not_dvd_of_rem (q := X ^ 3 + 2 * X ^ 2 + 2) (r := X + 2)
      (by ring) (Or.inl (by compute_degree!)) (by compute_degree!)
  · exact not_dvd_of_rem (q := X ^ 3 + 2 * X ^ 2 + 2 * X) (r := 2 * X + 2)
      (by linear_combination (norm := ring_nf) (-X ^ 3 - X) * h3)
      (Or.inl (by compute_degree!)) (by compute_degree!)
  · exact not_dvd_of_rem (q := X ^ 3 + 2 * X ^ 2 + X + 1) (r := 2 * X)
      (by linear_combination (norm := ring_nf) (-X ^ 3 - X ^ 2 - X) * h3)
      (Or.inl (by compute_degree!)) (by compute_degree!)
  · exact not_dvd_of_rem (q := X ^ 3 + X ^ 2 + 2 * X) (r := X + 2)
      (by linear_combination (norm := ring_nf) (-X ^ 3) * h3)
      (Or.inl (by compute_degree!)) (by compute_degree!)
  · exact not_dvd_of_rem (q := X ^ 3 + X ^ 2 + X) (r := 2)
      (by linear_combination (norm := ring_nf) (-X ^ 3) * h3)
      (Or.inr (by compute_degree!)) (by compute_degree!)
  · exact not_dvd_of_rem (q := X ^ 3 + X ^ 2) (r := X + 2)
      (by linear_combination (norm := ring_nf) (-X ^ 3) * h3)
      (Or.inl (by compute_degree!)) (by compute_degree!)
  · exact not_dvd_of_rem (q := X ^ 3 + 2) (r := 2)
      (by linear_combination (norm := ring_nf) (-X) * h3)
      (Or.inr (by compute_degree!)) (by compute_degree!)
  · exact not_dvd_of_rem (q := X ^ 3 + 2 * X + 1) (r := 1)
      (by linear_combination (norm := ring_nf) (-X ^ 3 - X ^ 2 - X) * h3)
      (Or.inr (by compute_degree!)) (by compute_degree!)
  · exact not_dvd_of_rem (q := X ^ 3 + X) (r := 2 * X + 2)
      (by linear_combination (norm := ring_nf) (-X ^ 3 - X) * h3)
      (Or.inl (by compute_degree!)) (by compute_degree!)

theorem poly1951Mod3_irreducible : Irreducible poly1951Mod3 := by
  refine quintic_irreducible_criterion ?_ ?_ poly1951Mod3_no_root
    poly1951Mod3_no_quadratic_factor
  · unfold poly1951Mod3; monicity!
  · unfold poly1951Mod3; compute_degree!

/-- `poly1951` is irreducible over `ℤ` (Gauss + irreducibility of its reduction mod `3`). -/
theorem poly1951_irreducible_int : Irreducible poly1951 :=
  poly1951_monic.irreducible_of_irreducible_map (Int.castRingHom (ZMod 3)) _
    (by rw [poly1951_map_three]; exact poly1951Mod3_irreducible)

/-- `poly1951` is irreducible over `ℚ`. -/
theorem poly1951_irreducible_rat :
    Irreducible (poly1951.map (algebraMap ℤ ℚ)) :=
  (poly1951_monic.irreducible_iff_irreducible_map_fraction_map (K := ℚ)).mp
    poly1951_irreducible_int

/-! ### Total reality: `poly1951` splits over `ℝ` -/

/-- The real avatar of `poly1951`. -/
noncomputable def poly1951R : ℝ[X] := poly1951.map (Int.castRingHom ℝ)

theorem poly1951R_eval (x : ℝ) :
    poly1951R.eval x = x ^ 5 - x ^ 4 - 780 * x ^ 3 - 1795 * x ^ 2 + 3106 * x + 344 := by
  simp [poly1951R, poly1951]

theorem poly1951R_monic : poly1951R.Monic := poly1951_monic.map _

theorem poly1951R_natDegree : poly1951R.natDegree = 5 := by
  rw [poly1951R, Polynomial.natDegree_map_eq_of_injective Int.cast_injective,
    poly1951_natDegree]

/-- A sign change on `[a, b]` produces a root in `(a, b)`. -/
theorem exists_root_Ioo {P : ℝ[X]} {a b : ℝ} (hab : a < b)
    (hs : P.eval a < 0 ∧ 0 < P.eval b ∨ 0 < P.eval a ∧ P.eval b < 0) :
    ∃ x ∈ Set.Ioo a b, P.eval x = 0 := by
  have hcont : ContinuousOn (fun x => P.eval x) (Set.Icc a b) :=
    (P.continuous_aeval).continuousOn
  rcases hs with ⟨h1, h2⟩ | ⟨h1, h2⟩
  · obtain ⟨x, hx, hx0⟩ := intermediate_value_Ioo hab.le hcont ⟨h1, h2⟩
    exact ⟨x, hx, hx0⟩
  · obtain ⟨x, hx, hx0⟩ := intermediate_value_Ioo' hab.le hcont ⟨h2, h1⟩
    exact ⟨x, hx, hx0⟩

/-- `poly1951` has five real roots, one in each of the intervals
`(-27,-26)`, `(-4,-3)`, `(-1,0)`, `(1,2)`, `(29,30)`. -/
theorem poly1951R_five_roots :
    ∃ x₁ x₂ x₃ x₄ x₅ : ℝ,
      x₁ ∈ Set.Ioo (-27 : ℝ) (-26) ∧ x₂ ∈ Set.Ioo (-4 : ℝ) (-3) ∧
      x₃ ∈ Set.Ioo (-1 : ℝ) 0 ∧ x₄ ∈ Set.Ioo (1 : ℝ) 2 ∧ x₅ ∈ Set.Ioo (29 : ℝ) 30 ∧
      poly1951R.eval x₁ = 0 ∧ poly1951R.eval x₂ = 0 ∧ poly1951R.eval x₃ = 0 ∧
      poly1951R.eval x₄ = 0 ∧ poly1951R.eval x₅ = 0 := by
  obtain ⟨x₁, h₁, e₁⟩ := exists_root_Ioo (P := poly1951R) (a := -27) (b := -26) (by norm_num)
    (Or.inl ⟨by rw [poly1951R_eval]; norm_num, by rw [poly1951R_eval]; norm_num⟩)
  obtain ⟨x₂, h₂, e₂⟩ := exists_root_Ioo (P := poly1951R) (a := -4) (b := -3) (by norm_num)
    (Or.inr ⟨by rw [poly1951R_eval]; norm_num, by rw [poly1951R_eval]; norm_num⟩)
  obtain ⟨x₃, h₃, e₃⟩ := exists_root_Ioo (P := poly1951R) (a := -1) (b := 0) (by norm_num)
    (Or.inl ⟨by rw [poly1951R_eval]; norm_num, by rw [poly1951R_eval]; norm_num⟩)
  obtain ⟨x₄, h₄, e₄⟩ := exists_root_Ioo (P := poly1951R) (a := 1) (b := 2) (by norm_num)
    (Or.inr ⟨by rw [poly1951R_eval]; norm_num, by rw [poly1951R_eval]; norm_num⟩)
  obtain ⟨x₅, h₅, e₅⟩ := exists_root_Ioo (P := poly1951R) (a := 29) (b := 30) (by norm_num)
    (Or.inl ⟨by rw [poly1951R_eval]; norm_num, by rw [poly1951R_eval]; norm_num⟩)
  exact ⟨x₁, x₂, x₃, x₄, x₅, h₁, h₂, h₃, h₄, h₅, e₁, e₂, e₃, e₄, e₅⟩

/-- **Total reality.** `poly1951` splits over `ℝ`: all five of its complex roots are real. -/
theorem poly1951_totally_real : poly1951R.Splits := by
  classical
  obtain ⟨x₁, x₂, x₃, x₄, x₅, h₁, h₂, h₃, h₄, h₅, e₁, e₂, e₃, e₄, e₅⟩ := poly1951R_five_roots
  have hne : poly1951R ≠ 0 := poly1951R_monic.ne_zero
  have hsub : ({x₁, x₂, x₃, x₄, x₅} : Finset ℝ) ⊆ poly1951R.roots.toFinset := by
    intro y hy
    simp only [Finset.mem_insert, Finset.mem_singleton] at hy
    simp only [Multiset.mem_toFinset, Polynomial.mem_roots hne, Polynomial.IsRoot.def]
    rcases hy with rfl | rfl | rfl | rfl | rfl <;> assumption
  have hcard : ({x₁, x₂, x₃, x₄, x₅} : Finset ℝ).card = 5 := by
    obtain ⟨a₁, b₁⟩ := h₁; obtain ⟨a₂, b₂⟩ := h₂; obtain ⟨a₃, b₃⟩ := h₃
    obtain ⟨a₄, b₄⟩ := h₄; obtain ⟨a₅, b₅⟩ := h₅
    rw [Finset.card_insert_of_notMem (by
        simp only [Finset.mem_insert, Finset.mem_singleton]
        push_neg
        exact ⟨by linarith, by linarith, by linarith, by linarith⟩),
      Finset.card_insert_of_notMem (by
        simp only [Finset.mem_insert, Finset.mem_singleton]
        push_neg
        exact ⟨by linarith, by linarith, by linarith⟩),
      Finset.card_insert_of_notMem (by
        simp only [Finset.mem_insert, Finset.mem_singleton]
        push_neg
        exact ⟨by linarith, by linarith⟩),
      Finset.card_insert_of_notMem (by
        simp only [Finset.mem_singleton]
        linarith),
      Finset.card_singleton]
  rw [Polynomial.splits_iff_card_roots, poly1951R_natDegree]
  refine le_antisymm (by simpa [poly1951R_natDegree] using poly1951R.card_roots') ?_
  calc (5 : ℕ) = ({x₁, x₂, x₃, x₄, x₅} : Finset ℝ).card := hcard.symm
    _ ≤ poly1951R.roots.toFinset.card := Finset.card_le_card hsub
    _ ≤ poly1951R.roots.card := Multiset.toFinset_card_le _

/-! ### The bundling structure

The four defining properties of the Doud–Moore even icosahedral field of conductor
`1951`.  Three of the four fields are discharged above; the fourth, `gal_eq_A5`, is proved in
`ArtinA5Even.GalA5` (it needs the discriminant computation *inside* Lean, which is carried out
in `ArtinA5Even.Discr1951`, together with a reduction-mod-`p` argument), and a term of this
structure is constructed there as `ArtinA5Even.evenIcosahedral1951`. -/
structure EvenIcosahedral1951 : Prop where
  /-- `poly1951` is irreducible over `ℚ` (proved: `poly1951_irreducible_rat`). -/
  irreducible : Irreducible (poly1951.map (algebraMap ℤ ℚ))
  /-- The discriminant is a perfect square (proved for the recorded value:
  `disc1951_isSquare`). -/
  disc_sq : IsSquare disc1951
  /-- The field is totally real (proved: `poly1951_totally_real`). -/
  totally_real : poly1951R.Splits
  /-- The Galois group of the splitting field is `A₅`.  **Not proved in this library.** -/
  gal_eq_A5 :
    Nonempty ((poly1951.map (algebraMap ℤ ℚ)).Gal ≃* alternatingGroup (Fin 5))

/-! ## Task 2: what a `2.A₅` lift would be — types only, no construction

`H²(A₅, {±1}) ≅ C₂`, so the extension `2.A₅ = SL₂(𝔽₅) → A₅` is the unique nonsplit
central extension of `A₅` by `{±1}`.  A projective representation
`ρ̄ : Gal(ℚ̄/ℚ) → PGL₂(ℂ)` with image `A₅` therefore has an obstruction class in
`H²(Gal(ℚ̄/ℚ), {±1}) = Br₂` pulled back from that generator: `ρ̄` lifts to a genuine
`ρ̃ : Gal(ℚ̄/ℚ) → GL₂(ℂ)` with determinant a Dirichlet character only after this class
is killed, which in general requires passing to the central extension `2.A₅` and, at the
level of determinants, a quadratic twist.  Tate's theorem says the obstruction does
vanish over a number field, but the resulting lift is *not* canonical and is *not*
constructed here.  **No cocycle is computed below**; the declarations are types and
`Prop`s only. -/

/-- The absolute Galois group of `ℚ`. -/
noncomputable abbrev GalQ := AlgebraicClosure ℚ ≃ₐ[ℚ] AlgebraicClosure ℚ

/-- `GL₂(ℂ)`. -/
abbrev GL2C := Matrix.GeneralLinearGroup (Fin 2) ℂ

/-- `PGL₂(ℂ) = GL₂(ℂ) / (centre)`. -/
abbrev PGL2C := GL2C ⧸ Subgroup.center GL2C

/-- `SL₂(ℂ)`. -/
abbrev SL2C := Matrix.SpecialLinearGroup (Fin 2) ℂ

/-- Projective even icosahedral representation of conductor 1951.

A lift to `SL₂(ℂ)` is *not* constructed.

The bundled data is: a projective representation `rho` of the absolute Galois group of
`ℚ`, a complex conjugation `conj` (an involution), evenness `rho conj = 1`, the
requirement that `rho` factors through the Galois group of the splitting field of
`poly1951` (this is what pins the object to conductor `1951`), and the requirement that
the image is `A₅`.

The Artin conductor itself is *not* a field of this structure: Mathlib has no Artin
conductor, so `condPrime = 1951` is recorded separately as data. -/
structure ProjectiveEvenIcosahedral where
  /-- The projective representation. -/
  rho : GalQ →* PGL2C
  /-- A complex conjugation: an element of order dividing 2 that is not the identity. -/
  conj : GalQ
  /-- `conj` is an involution. -/
  conj_sq : conj * conj = 1
  /-- `conj` is nontrivial. -/
  conj_ne_one : conj ≠ 1
  /-- **Evenness**: `ρ(c) = +I` in `PGL₂(ℂ)`. -/
  even : rho conj = 1
  /-- `rho` factors through `Gal` of the splitting field of `poly1951`: any automorphism
  fixing every root of `poly1951` is killed by `rho`. -/
  factors_through_splitting_field :
    ∀ σ : GalQ, (∀ z : AlgebraicClosure ℚ,
      Polynomial.aeval z (poly1951.map (algebraMap ℤ ℚ)) = 0 → σ z = z) → rho σ = 1
  /-- The image is the icosahedral group `A₅`. -/
  image_icosahedral : Nonempty (rho.range ≃* alternatingGroup (Fin 5))

/-- A lift of a projective even icosahedral representation to `SL₂(ℂ) = 2.A₅`.

**No term of this structure is constructed in this library.**  Producing one — and then
proving modularity of the lift — is exactly the missing input for an Artin-type theorem
in the even icosahedral case; see `docs/ARTIN_A5_EVEN_1951.md`. -/
structure SL2Lift (P : ProjectiveEvenIcosahedral) where
  /-- The lifted representation. -/
  rhoTilde : GalQ →* SL2C
  /-- Compatibility with `P.rho` under `SL₂(ℂ) → GL₂(ℂ) → PGL₂(ℂ)`. -/
  lifts : ∀ σ : GalQ,
    QuotientGroup.mk' (Subgroup.center GL2C)
      (Matrix.SpecialLinearGroup.toGL (rhoTilde σ)) = P.rho σ

end ArtinA5Even
