import Mathlib

open scoped BigOperators

/-!
# Hecke operator relations for higher Fourier coefficients

This file formalizes the action of the classical Hecke operators `T_m` on the Fourier
coefficient sequences of modular forms, and the relations these operators satisfy among
the higher coefficients `c_n`.

For a modular form `f(z) = ∑ a(n) qⁿ` of weight `k`, the `m`-th Hecke operator produces a
form `T_m f = ∑ b(n) qⁿ` whose coefficients are given by the explicit formula

  `b(n) = ∑_{d ∣ gcd(m, n)} d^{k-1} · a(mn / d²)`.

We package this transformation as `heckeOp k m a : ℕ → R` acting on an arbitrary
coefficient sequence `a : ℕ → R` over a commutative ring `R`. We then establish:

* `heckeOp_apply_one`  — `(T_m a)(1) = a(m)`, recovering the original coefficient.
* `heckeOp_apply_zero` — `(T_m a)(0) = σ_{k-1}(m) · a(0)`, so cusp forms (`a 0 = 0`) are
  preserved (`heckeOp_apply_zero_of_cusp`).
* `heckeOp_prime` — the clean prime-index formula
  `(T_p a)(n) = a(pn) + [p ∣ n] · p^{k-1} · a(n/p)`.
* `heckeOp_mul_coprime` — the fundamental **multiplicativity relation**: for coprime
  indices `T_m ∘ T_n = T_{mn}`.
* `heckeOp_comm_coprime` — Hecke operators with coprime indices commute, exhibiting the
  commutativity of the Hecke algebra.
* `IsNormalizedEigenform` and `eigenform_coeff_relation` — for a normalized simultaneous
  eigenform the eigenvalues satisfy
  `a(m) a(n) = ∑_{d ∣ gcd(m,n)} d^{k-1} a(mn/d²)`,
  the relation proved by Mordell for the Ramanujan tau function.

The development is purely arithmetic (it works over any commutative ring with a fixed
weight parameter `k`), capturing exactly the combinatorial heart of the Hecke relations.
-/

namespace HeckeRelations

variable {R : Type*} [CommRing R]

/-- The `m`-th Hecke operator of weight `k`, acting on a coefficient sequence
`a : ℕ → R`. Its value at `n` is
`(T_m a)(n) = ∑_{d ∣ gcd(m,n)} d^{k-1} · a(mn / d²)`. -/
def heckeOp (k m : ℕ) (a : ℕ → R) (n : ℕ) : R :=
  ∑ d ∈ (Nat.gcd m n).divisors, (d : R) ^ (k - 1) * a (m * n / d ^ 2)

/-
The coefficient `(T_m a)(1)` recovers `a(m)`.
-/
theorem heckeOp_apply_one (k m : ℕ) (a : ℕ → R) :
    heckeOp k m a 1 = a m := by
  unfold heckeOp; aesop;

/-
The zeroth coefficient `(T_m a)(0)` is `σ_{k-1}(m) · a(0)`.
-/
theorem heckeOp_apply_zero (k m : ℕ) (a : ℕ → R) :
    heckeOp k m a 0 = (∑ d ∈ m.divisors, (d : R) ^ (k - 1)) * a 0 := by
  unfold heckeOp;
  simp +decide [ Finset.sum_mul _ _ _ ]

/-
Hecke operators preserve cusp forms: if `a 0 = 0` then `(T_m a)(0) = 0`.
-/
theorem heckeOp_apply_zero_of_cusp (k m : ℕ) (a : ℕ → R) (h : a 0 = 0) :
    heckeOp k m a 0 = 0 := by
  rw [ heckeOp_apply_zero, h, MulZeroClass.mul_zero ]

/-
The prime-index Hecke operator has the explicit two-term form
`(T_p a)(n) = a(pn) + [p ∣ n] · p^{k-1} · a(n/p)`.
-/
theorem heckeOp_prime (k : ℕ) {p : ℕ} (hp : p.Prime) (a : ℕ → R) (n : ℕ) :
    heckeOp k p a n = a (p * n) + (if p ∣ n then (p : R) ^ (k - 1) * a (n / p) else 0) := by
  unfold heckeOp
  by_cases h : p ∣ n
  · obtain ⟨t, rfl⟩ := h
    rw [Nat.gcd_eq_left ⟨t, rfl⟩, hp.divisors, Finset.sum_pair hp.one_lt.ne]
    have h1 : p * (p * t) / p ^ 2 = t := by
      rw [show p * (p * t) = p ^ 2 * t by ring]
      exact Nat.mul_div_cancel_left _ (pow_pos hp.pos 2)
    simp [h1, Nat.mul_div_cancel_left _ hp.pos]
  · rw [(hp.coprime_iff_not_dvd.mpr h).gcd_eq_one]
    simp [h]

/-
A coprime divisor double-sum reindexing: when `A` and `B` are coprime, summing a
function over the divisors of `A * B` is the same as the double sum over divisors of `A`
and of `B`, evaluated at the product. (The multiplication map
`A.divisors ×ˢ B.divisors → (A*B).divisors` is a bijection.)
-/
theorem sum_divisors_coprime_mul {S : Type*} [AddCommMonoid S] {A B : ℕ}
    (hAB : Nat.Coprime A B) (f : ℕ → S) :
    ∑ c ∈ (A * B).divisors, f c = ∑ d ∈ A.divisors, ∑ e ∈ B.divisors, f (d * e) := by
  rw [ Nat.divisors_mul, ← Finset.sum_product' ];
  rw [ Finset.mul_def, Finset.sum_image ];
  intros p hp q hq h_eq;
  -- Since $p.1 \mid A$ and $q.1 \mid A$, and $A$ and $B$ are coprime, it follows that $p.1 = q.1$.
  have hp1_eq_q1 : p.1 = q.1 := by
    norm_num +zetaDelta at *;
    exact Nat.dvd_antisymm ( by exact Nat.Coprime.dvd_of_dvd_mul_right ( Nat.Coprime.coprime_dvd_left hp.1.1 <| Nat.Coprime.coprime_dvd_right hq.2.1 hAB ) <| h_eq.symm ▸ dvd_mul_right _ _ ) ( by exact Nat.Coprime.dvd_of_dvd_mul_right ( Nat.Coprime.coprime_dvd_left hq.1.1 <| Nat.Coprime.coprime_dvd_right hp.2.1 hAB ) <| h_eq.symm ▸ dvd_mul_right _ _ );
  aesop

/-
For `d` dividing both `m` and `l`, and with `m` coprime to `n`, the inner gcd in the
composition collapses: `gcd (n) (m*l/d²) = gcd n l`.
-/
theorem gcd_div_sq_coprime {m n l d : ℕ} (hco : Nat.Coprime m n)
    (hdm : d ∣ m) (hdl : d ∣ l) :
    Nat.gcd n (m * l / d ^ 2) = Nat.gcd n l := by
  rcases eq_or_ne d 0 with rfl | hd
  · obtain rfl : m = 0 := by simpa using hdm
    obtain rfl : l = 0 := by simpa using hdl
    simp
  · obtain ⟨m', rfl⟩ := hdm
    obtain ⟨l', rfl⟩ := hdl
    have hdpos : 0 < d ^ 2 := pow_pos (Nat.pos_of_ne_zero hd) 2
    have hmul : d * m' * (d * l') / d ^ 2 = m' * l' := by
      rw [show d * m' * (d * l') = d ^ 2 * (m' * l') by ring]
      exact Nat.mul_div_cancel_left _ hdpos
    have hcm' : Nat.Coprime m' n := hco.coprime_dvd_left ⟨d, by ring⟩
    have hcd : Nat.Coprime d n := hco.coprime_dvd_left ⟨m', rfl⟩
    rw [hmul, Nat.gcd_comm n (m' * l'), Nat.gcd_comm n (d * l'),
      Nat.Coprime.gcd_mul_left_cancel l' hcm', Nat.Coprime.gcd_mul_left_cancel l' hcd]

/-
**Multiplicativity of Hecke operators on coprime indices.** When `gcd(m,n) = 1`,
`T_m ∘ T_n = T_{mn}`. This is one of the fundamental Hecke relations; together with the
prime-power recursion it generates the whole (commutative) Hecke algebra.
-/
theorem heckeOp_mul_coprime (k : ℕ) {m n : ℕ}
    (hco : Nat.Coprime m n) (a : ℕ → R) (l : ℕ) :
    heckeOp k m (heckeOp k n a) l = heckeOp k (m * n) a l := by
  unfold heckeOp;
  rw [ Nat.Coprime.mul_gcd ];
  · rw [ sum_divisors_coprime_mul ];
    · refine' Finset.sum_congr rfl fun d hd => _;
      rw [ gcd_div_sq_coprime hco ( Nat.dvd_trans ( Nat.dvd_of_mem_divisors hd ) ( Nat.gcd_dvd_left _ _ ) ) ( Nat.dvd_trans ( Nat.dvd_of_mem_divisors hd ) ( Nat.gcd_dvd_right _ _ ) ) ];
      rw [ Finset.mul_sum _ _ _ ] ; refine' Finset.sum_congr rfl fun e he => _ ; push_cast ; ring_nf;
      rw [ ← Nat.mul_div_assoc ];
      · rw [ Nat.div_div_eq_div_mul, mul_assoc ];
        ring_nf;
      · simp +zetaDelta at *;
        exact dvd_trans ( pow_two d ▸ mul_dvd_mul ( Nat.dvd_trans hd.1 ( Nat.gcd_dvd_left _ _ ) ) ( Nat.dvd_trans hd.1 ( Nat.gcd_dvd_right _ _ ) ) ) ( by ring_nf; norm_num );
    · exact hco.coprime_dvd_left ( Nat.gcd_dvd_left _ _ ) |> Nat.Coprime.coprime_dvd_right ( Nat.gcd_dvd_left _ _ );
  · assumption

/-
**Commutativity on coprime indices.** Hecke operators with coprime indices commute:
`T_m ∘ T_n = T_n ∘ T_m`. (The full Hecke algebra is commutative; this is the part that
follows directly from multiplicativity, since `T_m ∘ T_n = T_{mn} = T_{nm} = T_n ∘ T_m`.)
-/
theorem heckeOp_comm_coprime (k : ℕ) {m n : ℕ}
    (hco : Nat.Coprime m n) (a : ℕ → R) (l : ℕ) :
    heckeOp k m (heckeOp k n a) l = heckeOp k n (heckeOp k m a) l := by
  convert heckeOp_mul_coprime k hco a l using 1;
  rw [ mul_comm, ← heckeOp_mul_coprime k hco.symm a l ]

/-- A normalized simultaneous Hecke eigenform: the first coefficient is `1`, and each
Hecke operator `T_m` (for `m ≥ 1`) acts on the sequence by multiplication by `a m`. -/
structure IsNormalizedEigenform (k : ℕ) (a : ℕ → R) : Prop where
  normalized : a 1 = 1
  eigen : ∀ m, 1 ≤ m → ∀ n, heckeOp k m a n = a m * a n

/-
**Hecke relation for the eigenvalues / coefficients of a normalized eigenform.**
For a normalized simultaneous eigenform, the coefficients satisfy
`a(m) a(n) = ∑_{d ∣ gcd(m,n)} d^{k-1} a(mn/d²)`.
-/
theorem eigenform_coeff_relation (k : ℕ) (a : ℕ → R) (h : IsNormalizedEigenform k a)
    {m : ℕ} (hm : 1 ≤ m) (n : ℕ) :
    a m * a n = ∑ d ∈ (Nat.gcd m n).divisors, (d : R) ^ (k - 1) * a (m * n / d ^ 2) := by
  convert h.eigen m hm n |> Eq.symm using 1

/-
**Multiplicativity of eigenvalues.** For a normalized eigenform, the coefficients are
multiplicative on coprime indices: `a(m) a(n) = a(mn)` when `gcd(m,n) = 1`.
-/
theorem eigenform_coprime_mul (k : ℕ) (a : ℕ → R) (h : IsNormalizedEigenform k a)
    {m n : ℕ} (hm : 1 ≤ m) (hco : Nat.Coprime m n) :
    a m * a n = a (m * n) := by
  convert eigenform_coeff_relation k a h hm n using 1;
  aesop

/-
**Prime-power recursion for eigenvalues.** For a normalized eigenform and a prime `p`,
the coefficients satisfy `a(p) · a(pʳ) = a(p^{r+1}) + p^{k-1} · a(p^{r-1})` for `r ≥ 1`.
-/
theorem eigenform_prime_pow_rec (k : ℕ) (a : ℕ → R) (h : IsNormalizedEigenform k a)
    {p : ℕ} (hp : p.Prime) (r : ℕ) (hr : 1 ≤ r) :
    a p * a (p ^ r) = a (p ^ (r + 1)) + (p : R) ^ (k - 1) * a (p ^ (r - 1)) := by
  obtain ⟨s, rfl⟩ : ∃ s, r = s + 1 := ⟨r - 1, by omega⟩
  rw [eigenform_coeff_relation k a h hp.pos (p ^ (s + 1)),
    Nat.gcd_eq_left (dvd_pow_self p (Nat.succ_ne_zero s)), hp.divisors,
    Finset.sum_pair hp.one_lt.ne]
  have e2 : p * p ^ (s + 1) / p ^ 2 = p ^ s := by
    rw [show p * p ^ (s + 1) = p ^ 2 * p ^ s by ring]
    exact Nat.mul_div_cancel_left _ (pow_pos hp.pos 2)
  have e1 : p * p ^ (s + 1) / 1 ^ 2 = p ^ (s + 1 + 1) := by
    rw [one_pow, Nat.div_one]; ring
  rw [e1, e2]
  simp

end HeckeRelations