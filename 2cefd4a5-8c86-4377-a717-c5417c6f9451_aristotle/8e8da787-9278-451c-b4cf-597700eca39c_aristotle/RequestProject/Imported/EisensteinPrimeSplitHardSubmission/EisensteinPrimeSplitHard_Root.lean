import Mathlib
import RequestProject.Imported.EisensteinPrimeSplitHardSubmission.EisensteinIntegers_Root

/-!
# Split primes for the Eisenstein integers (Piece 4b)

This file proves the *hard* direction of the prime classification in `ℤ[ω]`:
every rational prime `p` with `p ≡ 1 (mod 3)` is the norm of some Eisenstein
integer, i.e. `p = a² - ab + b²` for some integers `a, b`.

## Strategy

We use the classical Thue's-lemma route, which avoids Zagier-style
combinatorial involutions entirely:

1. `exists_cube_root_of_unity`: since `(ZMod p)ˣ` is cyclic of order `p - 1`
   and `3 ∣ p - 1`, there is `ζ : ZMod p` with `ζ² + ζ + 1 = 0`.
2. `thue`: a pigeonhole argument produces `(u, v) ≠ (0, 0)` with
   `|u|, |v| ≤ ⌊√p⌋` and `(u : ZMod p) = ζ * v`.
3. The quadratic form `Q = u² + u v + v²` then satisfies `(Q : ZMod p) = 0`,
   i.e. `p ∣ Q`, because `u² + uv + v² ≡ (ζ² + ζ + 1) v² ≡ 0`.
4. A bound `0 < Q < 3p` forces `Q ∈ {p, 2p}`, and the parity fact
   `u² + uv + v² ≢ 2 (mod 3)` (while `2p ≡ 2`) rules out `2p`, giving `Q = p`.
5. Setting `z = ⟨u, -v⟩` gives `norm z = u² + uv + v² = p`.

The two pieces not already in Mathlib — the order-3 element and Thue's lemma —
are built here.
-/

noncomputable section

open scoped Classical

namespace Eisenstein

/-! ## Helper lemma for natAbs bounds -/

/-- If `a ≤ m` and `b ≤ m` (as naturals), then `|(a : ℤ) - (b : ℤ)|.natAbs ≤ m`. -/
private theorem Int.natAbs_coe_sub_coe_le_of_le {a b m : ℕ} (ha : a ≤ m) (hb : b ≤ m) :
    ((a : ℤ) - (b : ℤ)).natAbs ≤ m := by
  rw [show ((a : ℤ) - (b : ℤ)).natAbs = max a b - min a b from by omega]
  omega

/-! ## A cube root of unity mod `p` -/

/-- If `p` is a prime with `p ≡ 1 (mod 3)`, then there is an element
`ζ : ZMod p` satisfying `ζ² + ζ + 1 = 0`. -/
theorem exists_cube_root_of_unity (p : ℕ) (hp : p.Prime) (hmod : p % 3 = 1) :
    ∃ ζ : ZMod p, ζ ^ 2 + ζ + 1 = 0 := by
  haveI : Fact p.Prime := ⟨hp⟩
  haveI : Fact (Nat.Prime 3) := ⟨by norm_num⟩
  have hcard : Fintype.card (ZMod p)ˣ = p - 1 := by
    rw [ZMod.card_units_eq_totient, Nat.totient_prime hp]
  have hdvd : 3 ∣ Fintype.card (ZMod p)ˣ := by rw [hcard]; omega
  obtain ⟨ζu, hζu⟩ := exists_prime_orderOf_dvd_card (G := (ZMod p)ˣ) 3 hdvd
  have hζu3 : ζu ^ 3 = 1 := by
    rw [← hζu]; exact pow_orderOf_eq_one ζu
  have hζu_ne : ζu ≠ 1 := by
    intro h; rw [h, orderOf_one] at hζu; norm_num at hζu
  refine ⟨(ζu : ZMod p), ?_⟩
  have hcube : (ζu : ZMod p) ^ 3 = 1 := by
    rw [← Units.val_pow_eq_pow_val, hζu3, Units.val_one]
  have hne1 : (ζu : ZMod p) ≠ 1 := by
    intro h; apply hζu_ne; ext; rw [h, Units.val_one]
  have hfac : ((ζu : ZMod p) - 1) * ((ζu : ZMod p) ^ 2 + (ζu : ZMod p) + 1) = 0 := by
    have : ((ζu : ZMod p) - 1) * ((ζu : ZMod p) ^ 2 + (ζu : ZMod p) + 1)
        = (ζu : ZMod p) ^ 3 - 1 := by ring
    rw [this, hcube, sub_self]
  rcases mul_eq_zero.mp hfac with h | h
  · exact absurd (sub_eq_zero.mp h) hne1
  · exact h

/-! ## Thue's lemma -/

/-- **Thue's lemma** (the form we need). For a prime `p` and any `c : ZMod p`,
there exist integers `u, v`, not both zero, with `|u| ≤ ⌊√p⌋`, `|v| ≤ ⌊√p⌋`,
and `(u : ZMod p) = c * v`. -/
theorem thue (p : ℕ) (hp : p.Prime) (c : ZMod p) :
    ∃ u v : ℤ, (u ≠ 0 ∨ v ≠ 0) ∧ u.natAbs ≤ Nat.sqrt p ∧
      v.natAbs ≤ Nat.sqrt p ∧ (u : ZMod p) = c * v := by
  haveI : Fact p.Prime := ⟨hp⟩
  set m := Nat.sqrt p with hm
  set f : ℕ × ℕ → ZMod p := fun st => (st.1 : ZMod p) - c * (st.2 : ZMod p) with hf
  set grid : Finset (ℕ × ℕ) := (Finset.range (m + 1)) ×ˢ (Finset.range (m + 1)) with hgrid
  have hcardgrid : grid.card = (m + 1) * (m + 1) := by
    simp [hgrid, Finset.card_product]
  have hbig : (Finset.univ : Finset (ZMod p)).card < grid.card := by
    rw [Finset.card_univ, ZMod.card p, hcardgrid]
    exact Nat.lt_succ_sqrt p
  obtain ⟨a, ha, b, hb, hab, hfab⟩ :=
    Finset.exists_ne_map_eq_of_card_lt_of_maps_to hbig
      (f := f) (fun x _ => Finset.mem_univ (f x))
  have ha1 : a.1 ≤ m := Nat.lt_succ_iff.mp (Finset.mem_range.mp (Finset.mem_product.mp ha).1)
  have ha2 : a.2 ≤ m := Nat.lt_succ_iff.mp (Finset.mem_range.mp (Finset.mem_product.mp ha).2)
  have hb1 : b.1 ≤ m := Nat.lt_succ_iff.mp (Finset.mem_range.mp (Finset.mem_product.mp hb).1)
  have hb2 : b.2 ≤ m := Nat.lt_succ_iff.mp (Finset.mem_range.mp (Finset.mem_product.mp hb).2)
  refine ⟨(a.1 : ℤ) - (b.1 : ℤ), (a.2 : ℤ) - (b.2 : ℤ), ?_, ?_, ?_, ?_⟩
  · by_contra h
    push_neg at h
    obtain ⟨h1, h2⟩ := h
    apply hab
    have n1 : a.1 = b.1 := by
      have : (a.1 : ℤ) = (b.1 : ℤ) := by linarith [sub_eq_zero.mp h1]
      exact_mod_cast this
    have n2 : a.2 = b.2 := by
      have : (a.2 : ℤ) = (b.2 : ℤ) := by linarith [sub_eq_zero.mp h2]
      exact_mod_cast this
    exact Prod.ext n1 n2
  · exact Int.natAbs_coe_sub_coe_le_of_le ha1 hb1
  · exact Int.natAbs_coe_sub_coe_le_of_le ha2 hb2
  · have hfe : (a.1 : ZMod p) - c * (a.2 : ZMod p) = (b.1 : ZMod p) - c * (b.2 : ZMod p) := hfab
    push_cast
    linear_combination hfe

/-! ## The quadratic form value -/

/-- The parity fact ruling out `2p`: in `ZMod 3`, the form `u² + uv + v²` is never `2`.
This is the key obstruction that excludes `Q = 2p` when `p ≡ 1 (mod 3)`. -/
theorem quadForm_zmod_three (u v : ℤ) :
    ((u ^ 2 + u * v + v ^ 2 : ℤ) : ZMod 3) ≠ 2 := by
  have key : ∀ a b : ZMod 3, a ^ 2 + a * b + b ^ 2 ≠ 2 := by decide
  intro hcontra
  apply key (u : ZMod 3) (v : ZMod 3)
  push_cast at hcontra
  linear_combination hcontra

/-! ## Main theorem -/

/-- **Split primes.** Every rational prime `p ≡ 1 (mod 3)` is the norm of an
Eisenstein integer: there is `z : Eisenstein` with `norm z = p`. -/
theorem split_prime (p : ℕ) (hp : p.Prime) (hmod : p % 3 = 1) :
    ∃ z : Eisenstein, norm z = (p : ℤ) := by
  haveI : Fact p.Prime := ⟨hp⟩
  have hp_gt3 : 3 < p := by
    rcases hp.eq_two_or_odd with h2 | _
    · omega
    · have h2 := hp.two_le; omega
  obtain ⟨ζ, hζ⟩ := exists_cube_root_of_unity p hp hmod
  obtain ⟨u, v, hne, hu, hv, hcong⟩ := thue p hp ζ
  set Q : ℤ := u ^ 2 + u * v + v ^ 2 with hQ
  -- Step 3: `p ∣ Q`.
  have hpdvd : (p : ℤ) ∣ Q := by
    rw [← ZMod.intCast_zmod_eq_zero_iff_dvd]
    have : ((Q : ℤ) : ZMod p) = (ζ ^ 2 + ζ + 1) * (v : ZMod p) ^ 2 := by
      rw [hQ]; push_cast; rw [hcong]; ring
    rw [this, hζ, zero_mul]
  -- Step 4: `Q > 0`.
  have hQpos : 0 < Q := by
    have h4 : (4 : ℤ) * Q = (2 * u + v) ^ 2 + 3 * v ^ 2 := by rw [hQ]; ring
    rcases hne with hu0 | hv0
    · nlinarith [sq_nonneg (2 * u + v), sq_nonneg v, sq_nonneg u,
        h4, sq_pos_of_ne_zero hu0]
    · nlinarith [sq_nonneg (2 * u + v), sq_nonneg v, h4, sq_pos_of_ne_zero hv0]
  -- Step 5: bound `Q < 3p`.
  set m := Nat.sqrt p with hm
  have hm_sq_lt : (m : ℤ) ^ 2 < (p : ℤ) := by
    have h1 : m * m ≤ p := Nat.sqrt_le p
    have hne_sq : m * m ≠ p := by
      intro he
      have hmdvd : m ∣ p := ⟨m, he.symm⟩
      rcases Nat.Prime.eq_one_or_self_of_dvd hp m hmdvd with h | h
      · rw [h] at he; simp at he; omega
      · rw [h] at he; nlinarith [hp_gt3]
    have hlt : m * m < p := lt_of_le_of_ne h1 hne_sq
    have hlt' : m ^ 2 < p := by linarith [sq m]
    exact_mod_cast hlt'
  have habs_u : (u ^ 2 : ℤ) ≤ (m : ℤ) ^ 2 := by
    calc u ^ 2 = (u.natAbs : ℤ) ^ 2 := (Int.natAbs_sq u).symm
      _ ≤ (m : ℤ) ^ 2 := by gcongr
  have habs_v : (v ^ 2 : ℤ) ≤ (m : ℤ) ^ 2 := by
    calc v ^ 2 = (v.natAbs : ℤ) ^ 2 := (Int.natAbs_sq v).symm
      _ ≤ (m : ℤ) ^ 2 := by gcongr
  have habs_uv : u * v ≤ (m : ℤ) ^ 2 := by
    have hub : u * v ≤ |u * v| := le_abs_self _
    have habsmul : |u * v| = (u.natAbs : ℤ) * (v.natAbs : ℤ) := by
      rw [abs_mul, Int.abs_eq_natAbs, Int.abs_eq_natAbs]
    have hle : (u.natAbs : ℤ) * (v.natAbs : ℤ) ≤ (m : ℤ) ^ 2 := by
      calc (u.natAbs : ℤ) * (v.natAbs : ℤ)
          ≤ (m : ℤ) * (m : ℤ) := by gcongr
        _ = (m : ℤ) ^ 2 := by ring
    linarith
  have hQ_lt : Q < 3 * (p : ℤ) := by
    have hsum : Q ≤ 3 * (m : ℤ) ^ 2 := by rw [hQ]; linarith
    nlinarith [hm_sq_lt, hsum]
  -- Step 6: `Q = k·p` with `0 < k < 3`.
  obtain ⟨k, hk⟩ := hpdvd
  have hppos : (0 : ℤ) < (p : ℤ) := by exact_mod_cast hp.pos
  have hkpos : 0 < k := by
    by_contra h; push_neg at h
    have : Q ≤ 0 := by rw [hk]; exact mul_nonpos_of_nonneg_of_nonpos hppos.le h
    linarith
  have hk_lt3 : k < 3 := by
    by_contra h; push_neg at h
    have : 3 * (p : ℤ) ≤ Q := by rw [hk]; nlinarith
    linarith
  -- Step 7: exclude `k = 2` via the mod-3 parity.
  interval_cases k
  · -- k = 1: `Q = p`.
    refine ⟨⟨u, -v⟩, ?_⟩
    have hQp : Q = (p : ℤ) := by rw [hk]; ring
    show u ^ 2 - u * (-v) + (-v) ^ 2 = (p : ℤ)
    rw [← hQp, hQ]; ring
  · -- k = 2: `Q = 2p`, contradiction with parity.
    exfalso
    have h2p : Q = 2 * (p : ℤ) := by rw [hk]; ring
    apply quadForm_zmod_three u v
    have hcastQ : ((u ^ 2 + u * v + v ^ 2 : ℤ) : ZMod 3) = ((2 * (p : ℤ) : ℤ) : ZMod 3) := by
      rw [← hQ, h2p]
    rw [hcastQ]
    have hp1 : ((p : ℤ) : ZMod 3) = 1 := by
      have : (p : ZMod 3) = 1 := by
        conv_lhs => rw [show p = 3 * (p / 3) + 1 from by omega]
        push_cast
        simp [show (3 : ZMod 3) = 0 from by decide]
      exact_mod_cast this
    simp only [Int.cast_mul, Int.cast_ofNat]
    rw [hp1]
    norm_num

end Eisenstein
