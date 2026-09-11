/-
  DULA_Bridge1_Representation.lean
  
  SPLITTING IN ℤ[ω] ⟺ REPRESENTATION BY THE A₂ NORM FORM
  ============================================================
  
  Main theorem: For a prime p > 3,
    p splits in ℤ[ω]  ⟺  ∃ a b : ℤ, p = a² + ab + b²
  
  For Lean 4 + Mathlib.
-/

import Mathlib

/-
PROVIDED SOLUTION
This is a pigeonhole argument. Let s = Nat.sqrt p. Consider the (s+1)² pairs (a, b) with 0 ≤ a, b ≤ s. Since (s+1)² > p (because (s+1)² > s² ≥ ... and we can use Nat.lt_succ_sqrt), by the pigeonhole principle, there exist two distinct pairs (a₁, b₁), (a₂, b₂) such that a₁ - t*b₁ ≡ a₂ - t*b₂ mod p. Then x = a₁ - a₂, y = b₁ - b₂ satisfy p | (x - t*y), |x| ≤ s, |y| ≤ s, and (x, y) ≠ (0, 0).

More precisely, define f : Fin (s+1) × Fin (s+1) → ZMod p by f(a,b) = a - t*b. The domain has size (s+1)² > p = card (ZMod p), so f is not injective. Take two distinct preimages and subtract.
-/
open Finset in
/-- Thue's lemma: For a prime p and any integer t, there exist integers x, y,
    not both zero, with |x|, |y| ≤ √p, such that p ∣ (x - t*y). -/
theorem thue_lemma (p : ℕ) (hp : Nat.Prime p) (t : ℤ) :
    ∃ x y : ℤ, (x ≠ 0 ∨ y ≠ 0) ∧
    x.natAbs ≤ Nat.sqrt p ∧ y.natAbs ≤ Nat.sqrt p ∧
    (p : ℤ) ∣ (x - t * y) := by
  by_contra h_contra;
  -- Let $s = \lfloor \sqrt{p} \rfloor$.
  set s := Nat.sqrt p with hs_def

  -- Consider the set $S$ of pairs $(a, b)$ where $0 \leq a, b \leq s$.
  set S : Finset (ℤ × ℤ) := Finset.product (Finset.Icc 0 s) (Finset.Icc 0 s) with hS_def

  -- By the pigeonhole principle, since $|S| > p$, there exist distinct pairs $(a_1, b_1), (a_2, b_2) \in S$ such that $a_1 - t b_1 \equiv a_2 - t b_2 \pmod{p}$.
  obtain ⟨a1, b1, a2, b2, h_pair, h_cong⟩ : ∃ a1 b1 a2 b2 : ℤ, (0 ≤ a1 ∧ a1 ≤ s) ∧ (0 ≤ b1 ∧ b1 ≤ s) ∧ (0 ≤ a2 ∧ a2 ≤ s) ∧ (0 ≤ b2 ∧ b2 ≤ s) ∧ (a1, b1) ≠ (a2, b2) ∧ (a1 - t * b1) ≡ (a2 - t * b2) [ZMOD p] := by
    -- By the pigeonhole principle, since $|S| > p$, there exist distinct pairs $(a_1, b_1), (a_2, b_2) \in S$ such that $a_1 - t b_1 \equiv a_2 - t b_2 \pmod{p}$ because there are more pairs than possible remainders modulo $p$.
    have h_pigeonhole : Finset.card (Finset.image (fun (ab : ℤ × ℤ) => (ab.1 - t * ab.2) % p) S) ≤ p := by
      exact le_trans ( Finset.card_le_card <| Finset.image_subset_iff.mpr fun x hx => Finset.mem_Ico.mpr ⟨ Int.emod_nonneg _ <| Nat.cast_ne_zero.mpr hp.ne_zero, Int.emod_lt_of_pos _ <| Nat.cast_pos.mpr hp.pos ⟩ ) ( by norm_num );
    contrapose! h_pigeonhole;
    erw [ Finset.card_image_of_injOn fun x hx y hy hxy => Classical.not_not.1 fun h => h_pigeonhole _ _ _ _ ( Finset.mem_Icc.mp ( Finset.mem_product.mp hx |>.1 ) ) ( Finset.mem_Icc.mp ( Finset.mem_product.mp hx |>.2 ) ) ( Finset.mem_Icc.mp ( Finset.mem_product.mp hy |>.1 ) ) ( Finset.mem_Icc.mp ( Finset.mem_product.mp hy |>.2 ) ) h hxy ] ; erw [ Finset.card_product ] ; norm_num ; nlinarith [ Nat.lt_succ_sqrt p, hp.two_le ] ;
  refine' h_contra ⟨ a1 - a2, b1 - b2, _, _, _, _ ⟩ <;> simp_all +decide [ Int.ModEq, Int.emod_eq_emod_iff_emod_sub_eq_zero ];
  · grind +ring;
  · grind;
  · grind +qlia;
  · convert h_cong.2.2.2.2 using 1 ; ring

/-
PROBLEM
If p ≡ 1 mod 3, then x² + x + 1 has a root modulo p.

PROVIDED SOLUTION
Since p ≡ 1 mod 3, we have 3 | (p-1). The multiplicative group (ZMod p)* is cyclic of order p-1. Since 3 | (p-1), there exists an element g of order 3 in this group. Then g ≠ 1, g³ = 1, so g² + g + 1 = 0 in ZMod p (since g³ - 1 = (g-1)(g² + g + 1) = 0 and g ≠ 1 and ZMod p is a field so g - 1 is invertible). Take r to be the ℤ representative (ZMod.val g). Then p | r² + r + 1.

Alternatively: use the fact that (ZMod p)* has order p-1 divisible by 3, so there is an element of order dividing 3 but not 1. Use orderOf_dvd_card_sub_one or similar, and the fact that the group is cyclic so has elements of every order dividing its cardinality.
-/
theorem exists_root_of_cyclotomic_mod (p : ℕ) (hp : Nat.Prime p) (hp1 : p % 3 = 1) :
    ∃ r : ℤ, (p : ℤ) ∣ (r ^ 2 + r + 1) := by
  obtain ⟨g, hg⟩ : ∃ g : ZMod p, orderOf g = 3 := by
    obtain ⟨g, hg⟩ : ∃ g : (ZMod p)ˣ, orderOf g = 3 := by
      have h_order : 3 ∣ (p - 1) := by
        omega;
      have h_card : Nat.card (ZMod p)ˣ = p - 1 := by
        haveI := Fact.mk hp; norm_num [ Nat.totient_prime hp ] ;
      haveI := Fact.mk hp; exact Exists.imp ( by aesop ) ( exists_prime_orderOf_dvd_card 3 <| by aesop ) ;
    exact ⟨ g, by simpa [ orderOf_units ] using hg ⟩;
  haveI := Fact.mk hp; use g.val; simp_all +decide [ ← ZMod.intCast_zmod_eq_zero_iff_dvd, orderOf_eq_iff ] ;
  exact mul_left_cancel₀ ( sub_ne_zero_of_ne ( hg.2 1 ( by decide ) ( by decide ) ) ) ( by linear_combination' hg.1 )

namespace DULA.Bridge1.Representation

/-! ## The Eisenstein Integers: Basic Setup -/

/-- The Eisenstein norm: N(a + bω) = a² + ab + b². -/
def eisenstein_norm (a b : ℤ) : ℤ := a ^ 2 + a * b + b ^ 2

/-- The identity 4·N(a,b) = (2a + b)² + 3b². -/
theorem four_times_norm (a b : ℤ) :
    4 * eisenstein_norm a b = (2 * a + b) ^ 2 + 3 * b ^ 2 := by
  unfold eisenstein_norm; ring

/-- The norm is always non-negative. -/
theorem norm_nonneg (a b : ℤ) : eisenstein_norm a b ≥ 0 := by
  have h := four_times_norm a b
  have h1 : (2 * a + b) ^ 2 ≥ 0 := sq_nonneg _
  have h2 : 3 * b ^ 2 ≥ 0 := by positivity
  linarith

/-- The norm is zero iff both coordinates are zero. -/
theorem norm_eq_zero_iff (a b : ℤ) :
    eisenstein_norm a b = 0 ↔ a = 0 ∧ b = 0 := by
  constructor
  · intro h
    have h4 := four_times_norm a b
    have h1 : (2 * a + b) ^ 2 ≥ 0 := sq_nonneg _
    have h2 : 3 * b ^ 2 ≥ 0 := by positivity
    have h3 : (2 * a + b) ^ 2 + 3 * b ^ 2 = 0 := by linarith
    have hb2 : b ^ 2 = 0 := by nlinarith
    have hb : b = 0 := by nlinarith [sq_nonneg b]
    have ha : a = 0 := by nlinarith [sq_nonneg a, sq_nonneg (2 * a)]
    exact ⟨ha, hb⟩
  · intro ⟨ha, hb⟩; unfold eisenstein_norm; rw [ha, hb]; ring

/-- The norm is multiplicative. -/
theorem norm_mul (a b c d : ℤ) :
    eisenstein_norm (a * c - b * d) (a * d + b * c + b * d) =
    eisenstein_norm a b * eisenstein_norm c d := by
  unfold eisenstein_norm; ring

/-! ## Units of ℤ[ω] -/

example : eisenstein_norm 1 0 = 1 := by unfold eisenstein_norm; ring
example : eisenstein_norm (-1) 0 = 1 := by unfold eisenstein_norm; ring
example : eisenstein_norm 0 1 = 1 := by unfold eisenstein_norm; ring
example : eisenstein_norm 0 (-1) = 1 := by unfold eisenstein_norm; ring
example : eisenstein_norm 1 (-1) = 1 := by unfold eisenstein_norm; ring
example : eisenstein_norm (-1) 1 = 1 := by unfold eisenstein_norm; ring

def is_eisenstein_unit (a b : ℤ) : Prop := eisenstein_norm a b = 1

theorem units_have_norm_one :
    is_eisenstein_unit 1 0 ∧
    is_eisenstein_unit (-1) 0 ∧
    is_eisenstein_unit 0 1 ∧
    is_eisenstein_unit 0 (-1) ∧
    is_eisenstein_unit 1 (-1) ∧
    is_eisenstein_unit (-1) 1 := by
  unfold is_eisenstein_unit eisenstein_norm
  refine ⟨by ring, by ring, by ring, by ring, by ring, by ring⟩

/-! ## The Representation Theorem -/

def represented_by_norm (p : ℤ) : Prop :=
  ∃ a b : ℤ, eisenstein_norm a b = p

def nontrivially_represented (p : ℤ) : Prop :=
  ∃ a b : ℤ, eisenstein_norm a b = p ∧ ¬ is_eisenstein_unit a b

/-- Concrete representations of splitting primes. -/
theorem repr_7  : represented_by_norm 7  := ⟨3, -1, by unfold eisenstein_norm; ring⟩
theorem repr_13 : represented_by_norm 13 := ⟨4, -1, by unfold eisenstein_norm; ring⟩
theorem repr_19 : represented_by_norm 19 := ⟨5, -2, by unfold eisenstein_norm; ring⟩
theorem repr_31 : represented_by_norm 31 := ⟨6, -1, by unfold eisenstein_norm; ring⟩
theorem repr_37 : represented_by_norm 37 := ⟨7, -3, by unfold eisenstein_norm; ring⟩
theorem repr_43 : represented_by_norm 43 := ⟨7, -1, by unfold eisenstein_norm; ring⟩
theorem repr_61 : represented_by_norm 61 := ⟨9, -4, by unfold eisenstein_norm; ring⟩
theorem repr_67 : represented_by_norm 67 := ⟨9, -2, by unfold eisenstein_norm; ring⟩
theorem repr_73 : represented_by_norm 73 := ⟨9, -1, by unfold eisenstein_norm; ring⟩
theorem repr_79 : represented_by_norm 79 := ⟨10, -3, by unfold eisenstein_norm; ring⟩

/-- Inert primes are NOT represented. -/
theorem not_repr_5 : ¬ represented_by_norm 5 := by
  intro ⟨a, b, h⟩
  have h4 := four_times_norm a b
  rw [h] at h4
  have hc := sq_nonneg (2 * a + b)
  have hd := sq_nonneg b
  have hbl : -2 ≤ b := by nlinarith
  have hbu : b ≤ 2 := by nlinarith
  have hal : -4 ≤ 2 * a + b := by nlinarith [sq_nonneg (2 * a + b + 5)]
  have hau : 2 * a + b ≤ 4 := by nlinarith [sq_nonneg (2 * a + b - 5)]
  set c := 2 * a + b with hc_def
  interval_cases b <;> interval_cases c <;> omega

theorem not_repr_11 : ¬ represented_by_norm 11 := by
  intro ⟨a, b, h⟩
  have h4 := four_times_norm a b
  rw [h] at h4
  have hc := sq_nonneg (2 * a + b)
  have hd := sq_nonneg b
  have hbl : -3 ≤ b := by nlinarith
  have hbu : b ≤ 3 := by nlinarith
  have hal : -6 ≤ 2 * a + b := by nlinarith [sq_nonneg (2 * a + b + 7)]
  have hau : 2 * a + b ≤ 6 := by nlinarith [sq_nonneg (2 * a + b - 7)]
  set c := 2 * a + b with hc_def
  interval_cases b <;> interval_cases c <;> omega

/-! ## The Main Theorem: Splitting ⟺ Representation -/

/-- The eisenstein norm mod 3 is always 0 or 1, never 2. -/
theorem eisenstein_norm_mod3 (a b : ℤ) :
    eisenstein_norm a b % 3 = 0 ∨ eisenstein_norm a b % 3 = 1 := by
  unfold eisenstein_norm
  obtain ⟨qa, ra, rfl, hra⟩ : ∃ q r, a = 3 * q + r ∧ (r = 0 ∨ r = 1 ∨ r = 2) :=
    ⟨a / 3, a % 3, by omega, by omega⟩
  obtain ⟨qb, rb, rfl, hrb⟩ : ∃ q r, b = 3 * q + r ∧ (r = 0 ∨ r = 1 ∨ r = 2) :=
    ⟨b / 3, b % 3, by omega, by omega⟩
  rcases hra with rfl | rfl | rfl <;> rcases hrb with rfl | rfl | rfl <;> ring_nf <;> omega

/-- The norm is positive when (a,b) ≠ (0,0). -/
theorem norm_pos_of_ne_zero (a b : ℤ) (h : a ≠ 0 ∨ b ≠ 0) : eisenstein_norm a b > 0 := by
  have hge := norm_nonneg a b
  cases' lt_or_eq_of_le hge with hgt heq
  · exact hgt
  · exfalso
    have := (norm_eq_zero_iff a b).mp heq.symm
    rcases h with ha | hb
    · exact ha this.1
    · exact hb this.2

/-
PROBLEM
Divisibility of eisenstein_norm by p when x ≡ ry mod p and p | r² + r + 1.

PROVIDED SOLUTION
We have x ≡ r*y mod p. So eisenstein_norm x y = x² + xy + y². Replace x with r*y + kp: x² + xy + y² = (r*y)² + (r*y)*y + y² + (terms divisible by p) = y²(r² + r + 1) + (terms divisible by p). Since p | r² + r + 1 and p divides the other terms, p | eisenstein_norm x y. More precisely, eisenstein_norm x y = x^2 + x*y + y^2, and x = r*y + p*q for some q. So x^2 + x*y + y^2 = (r*y + pq)^2 + (r*y + pq)*y + y^2 = r²y² + 2rpqy + p²q² + ry² + pqy + y² = y²(r² + r + 1) + pq(2ry + pq + y). Both terms are divisible by p.
-/
theorem norm_div_of_cong (x y r : ℤ) (p : ℕ) (hp : Nat.Prime p)
    (hr : (p : ℤ) ∣ r ^ 2 + r + 1)
    (hcong : (p : ℤ) ∣ x - r * y) :
    (p : ℤ) ∣ eisenstein_norm x y := by
  obtain ⟨ k, hk ⟩ := hcong;
  -- Substitute $x = ry + pk$ into the norm expression.
  have h_sub : eisenstein_norm x y = (r * y + p * k) ^ 2 + (r * y + p * k) * y + y ^ 2 := by
    exact hk ▸ by unfold eisenstein_norm; ring;
  obtain ⟨ a, ha ⟩ := hr; exact ⟨ a * y ^ 2 + k * ( 2 * r * y + p * k + y ), by rw [ h_sub ] ; linear_combination ha * y ^ 2 ⟩ ;

/-
PROBLEM
Upper bound on eisenstein_norm when |x|, |y| ≤ √p.

PROVIDED SOLUTION
We have |x|, |y| ≤ √p. Using 4·eisenstein_norm = (2x+y)² + 3y², we get 4·eisenstein_norm ≤ (2√p + √p)² + 3p = 9p + 3p = 12p, so eisenstein_norm ≤ 3p. But we need the strict bound eisenstein_norm ≤ 3p - 2. Note that (2x+y)² + 3y² = 4(x² + xy + y²). We have x.natAbs ≤ Nat.sqrt p, so x² ≤ (Nat.sqrt p)² ≤ p. Similarly y² ≤ p. And |xy| ≤ p. But actually Nat.sqrt p satisfies (Nat.sqrt p)² ≤ p < (Nat.sqrt p + 1)². Since p > 3 is prime, p is not a perfect square, so (Nat.sqrt p)² < p, hence (Nat.sqrt p)² ≤ p - 1. So x² ≤ p - 1, y² ≤ p - 1. And |x*y| ≤ (Nat.sqrt p)² ≤ p - 1. So eisenstein_norm x y = x² + xy + y² ≤ |x|² + |x||y| + |y|² ≤ 3(p-1) = 3p - 3 ≤ 3p - 2. Wait, but x² + xy + y² need not equal |x|² + |x||y| + |y|² (since xy could be negative). Use the identity: eisenstein_norm x y = x² + xy + y² ≤ x² + |xy| + y² ≤ (p-1) + (p-1) + (p-1) = 3(p-1) = 3p-3 ≤ 3p-2. Key facts: Int.natAbs_sq for x² = x.natAbs², Nat.sqrt_lt_self for p > 1, and Nat.sq_lt_sq' or similar for the bound.
-/
theorem norm_upper_bound (x y : ℤ) (p : ℕ) (hp : Nat.Prime p) (hp3 : p > 3)
    (hx : x.natAbs ≤ Nat.sqrt p) (hy : y.natAbs ≤ Nat.sqrt p)
    (hne : x ≠ 0 ∨ y ≠ 0) :
    eisenstein_norm x y ≤ 3 * (p : ℤ) - 2 := by
  -- We have |x|, |y| ≤ √p, which implies x.natAbs^2 ≤ (Nat.sqrt p)^2 ≤ p - 1, similarly for y.natAbs^2.
  have hxy_sq : x.natAbs^2 ≤ p - 1 ∧ y.natAbs^2 ≤ p - 1 := by
    exact ⟨ Nat.le_sub_one_of_lt ( lt_of_le_of_lt ( Nat.pow_le_pow_left hx 2 ) ( Nat.lt_of_le_of_ne ( Nat.sqrt_le' p ) fun h => by have := hp.isUnit_or_isUnit h.symm; aesop_cat ) ), Nat.le_sub_one_of_lt ( lt_of_le_of_lt ( Nat.pow_le_pow_left hy 2 ) ( Nat.lt_of_le_of_ne ( Nat.sqrt_le' p ) fun h => by have := hp.isUnit_or_isUnit h.symm; aesop_cat ) ) ⟩;
  -- Using the inequality |xy| ≤ p - 1, we get x^2 + xy + y^2 ≤ x^2 + |xy| + y^2 ≤ (p-1) + (p-1) + (p-1) = 3(p-1) = 3p-3.
  have hxy_bound : x^2 + |x * y| + y^2 ≤ 3 * (p - 1) := by
    cases abs_cases ( x * y ) <;> nlinarith [ abs_mul_abs_self x, abs_mul_abs_self y, Nat.sub_add_cancel hp.pos ];
  unfold eisenstein_norm; cases abs_cases ( x * y ) <;> linarith;

/-- REVERSE DIRECTION: If p = a² + ab + b² for some integers a, b,
    then p ≡ 1 mod 3. -/
theorem represented_implies_splits (p : ℕ) (hp_prime : Nat.Prime p) (hp_gt3 : p > 3)
    (hrep : represented_by_norm (p : ℤ)) : p % 3 = 1 := by
  obtain ⟨a, b, hab⟩ := hrep
  have hmod := eisenstein_norm_mod3 a b
  rw [hab] at hmod
  have hp3_ne0 : (p : ℤ) % 3 ≠ 0 := by
    intro h0
    have h3p : (3 : ℕ) ∣ p := by rw [Nat.dvd_iff_mod_eq_zero]; omega
    exact absurd (hp_prime.eq_one_or_self_of_dvd 3 h3p) (by omega)
  omega

/-- FORWARD DIRECTION: If p ≡ 1 mod 3, then p is represented by the norm form.
    
    Proof:
    1. By exists_root_of_cyclotomic_mod, ∃ r with p | r² + r + 1.
    2. By thue_lemma, ∃ x, y not both zero with |x|, |y| ≤ √p and p | x - ry.
    3. By norm_div_of_cong, p | eisenstein_norm x y.
    4. By norm_pos_of_ne_zero, eisenstein_norm x y > 0.
    5. By norm_upper_bound, eisenstein_norm x y < 3p.
    6. So eisenstein_norm x y ∈ {p, 2p}.
    7. By eisenstein_norm_mod3, eisenstein_norm x y mod 3 ∈ {0, 1}.
    8. Since p ≡ 1 mod 3, 2p ≡ 2 mod 3, so eisenstein_norm x y ≠ 2p.
    9. Therefore eisenstein_norm x y = p.
-/
theorem splits_implies_represented (p : ℕ) (hp_prime : Nat.Prime p) (hp_gt3 : p > 3)
    (hsplit : p % 3 = 1) : represented_by_norm (p : ℤ) := by
  obtain ⟨r, hr⟩ := exists_root_of_cyclotomic_mod p hp_prime hsplit
  obtain ⟨x, y, hne, hx, hy, hcong⟩ := thue_lemma p hp_prime r
  have hdvd := norm_div_of_cong x y r p hp_prime hr hcong
  have hpos := norm_pos_of_ne_zero x y hne
  have hub := norm_upper_bound x y p hp_prime hp_gt3 hx hy hne
  have hmod := eisenstein_norm_mod3 x y
  -- eisenstein_norm x y is a positive multiple of p, at most 3p - 2 < 3p
  obtain ⟨k, hk⟩ := hdvd
  have hkpos : k > 0 := by
    by_contra h; push_neg at h
    have : eisenstein_norm x y ≤ 0 := by
      rw [hk]; nlinarith [hp_prime.pos]
    linarith
  have hkle : k ≤ 2 := by
    by_contra h; push_neg at h
    have : eisenstein_norm x y ≥ 3 * (p : ℤ) := by
      rw [hk]; nlinarith [hp_prime.pos]
    linarith
  -- So k = 1 or k = 2
  interval_cases k
  · -- k = 1: eisenstein_norm x y = p
    exact ⟨x, y, by linarith⟩
  · -- k = 2: eisenstein_norm x y = 2p
    exfalso
    rw [hk] at hmod
    -- 2p mod 3: since p % 3 = 1, we have 2p % 3 = 2
    have : (2 * (p : ℤ)) % 3 = 2 := by omega
    omega

/-! ## Part: Complete Bridge 1 Statement -/

theorem complete_bridge1 (p : ℕ) (hp_prime : Nat.Prime p) (hp_gt3 : p > 3) 
    (hp_cop : Nat.Coprime p 6) :
    (p % 6 = 1 ↔ p % 3 = 1) ∧
    (p % 3 = 1 ↔ represented_by_norm (p : ℤ)) ∧
    (p % 6 = 5 ↔ p % 3 = 2) ∧
    (p % 3 = 2 ↔ ¬ represented_by_norm (p : ℤ)) := by
  have hp2 : p % 2 = 1 := by
    have : ¬ 2 ∣ p := by
      intro h
      exact (Nat.not_coprime_of_dvd_of_dvd (by norm_num : 1 < 2) h dvd_rfl).elim
        (hp_cop.coprime_dvd_right (by norm_num : 2 ∣ 6))
    omega
  have hp3_ne0 : p % 3 ≠ 0 := by
    intro h0
    have : 3 ∣ p := Nat.dvd_of_mod_eq_zero h0
    exact (Nat.not_coprime_of_dvd_of_dvd (by norm_num : 1 < 3) this dvd_rfl).elim
      (hp_cop.coprime_dvd_right (by norm_num : 3 ∣ 6))
  constructor
  · constructor <;> intro h <;> omega
  constructor
  · exact ⟨fun h => splits_implies_represented p hp_prime hp_gt3 h, 
           fun h => represented_implies_splits p hp_prime hp_gt3 h⟩
  constructor
  · constructor <;> intro h <;> omega
  · constructor
    · intro h hrep
      have := represented_implies_splits p hp_prime hp_gt3 hrep
      omega
    · intro h
      by_contra h2; push_neg at h2
      have : p % 3 = 1 ∨ p % 3 = 2 := by omega
      rcases this with h1 | h1
      · exact h (splits_implies_represented p hp_prime hp_gt3 h1)
      · exact h2 h1

#check complete_bridge1
#check four_times_norm
#check norm_nonneg
#check norm_eq_zero_iff
#check norm_mul

end DULA.Bridge1.Representation