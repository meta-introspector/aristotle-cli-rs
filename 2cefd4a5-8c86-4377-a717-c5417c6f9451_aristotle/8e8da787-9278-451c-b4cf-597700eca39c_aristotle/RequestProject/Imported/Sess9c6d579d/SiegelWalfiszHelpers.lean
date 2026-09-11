import Mathlib

open Finset Real ArithmeticFunction Nat
open scoped BigOperators

noncomputable section

/-
Λ(n) = -Σ_{d|n} μ(d) log(d). Möbius inversion of log = Λ * 1.
-/
theorem vonMangoldt_moebius_log (n : ℕ) (hn : 0 < n) :
    (Λ n : ℝ) = -∑ d ∈ n.divisors, (ArithmeticFunction.moebius d : ℝ) * Real.log d := by
  -- By definition of the von Mangoldt function, we have $\Lambda(n) = \sum_{de=n} \mu(d) \log(e)$.
  have h_def : Λ n = ∑ d ∈ Nat.divisors n, (moebius d : ℝ) * Real.log (n / d) := by
    -- By definition of Möbius inversion, we have $\Lambda = \mu * \log$, where $*$ denotes Dirichlet convolution.
    have h_conv : ArithmeticFunction.vonMangoldt = ArithmeticFunction.moebius * ArithmeticFunction.log := by
      exact?;
    rw [ h_conv, ArithmeticFunction.log ];
    simp +decide [ ArithmeticFunction.moebius, ArithmeticFunction.mul_apply ];
    rw [ Nat.sum_divisorsAntidiagonal fun x y => if Squarefree x then ( -1 : ℝ ) ^ cardFactors x * Real.log y else 0 ];
    exact Finset.sum_congr rfl fun x hx => by aesop;
  rw [ h_def, ← Finset.sum_neg_distrib ];
  -- Since $\sum_{d|n} \mu(d) = 0$ for $n > 1$, we can simplify the expression.
  have h_sum_zero : ∑ d ∈ Nat.divisors n, (moebius d : ℝ) = if n = 1 then 1 else 0 := by
    -- By definition of the Möbius function, we know that $\sum_{d \mid n} \mu(d) = (1 * \mu)(n)$.
    have h_sum_mu : ∑ d ∈ Nat.divisors n, (moebius d : ℝ) = (ArithmeticFunction.moebius * ArithmeticFunction.zeta) n := by
      simp +decide [ ArithmeticFunction.moebius, ArithmeticFunction.zeta ];
      rw [ Nat.sum_divisorsAntidiagonal fun x y => if y = 0 then 0 else if Squarefree x then ( -1 : ℝ ) ^ cardFactors x else 0 ];
      exact Finset.sum_congr rfl fun x hx => by rw [ if_neg ( Nat.ne_of_gt ( Nat.div_pos ( Nat.le_of_dvd hn ( Nat.dvd_of_mem_divisors hx ) ) ( Nat.pos_of_mem_divisors hx ) ) ) ] ;
    aesop;
  rw [ Finset.sum_congr rfl fun x hx => by rw [ Real.log_div ( by positivity ) ( by aesop ) ] ];
  simp_all +decide [ mul_sub, ← Finset.sum_mul _ _ _ ]

/-
Counting lattice points: #{n ≤ x : n ≡ a mod q} = x/q + O(1).
-/
theorem lattice_point_count (x : ℝ) (hx : x ≥ 0) (q : ℕ) (hq : 0 < q) (a : ℕ) (ha : a < q) :
    |((Finset.Icc 1 (Nat.floor x)).filter (fun n => n % q = a)).card -
      x / (q : ℝ)| ≤ 1 := by
  -- For a < q, the count of n ∈ [1, ⌊x⌋] with n % q = a can be computed as follows:
  -- - If a = 0: the count is ⌊⌊x⌋/q⌋
  -- - If a > 0: the count is ⌊(⌊x⌋ - a)/q⌋ + 1 if a ≤ ⌊x⌋, else 0
  have h_count : (Finset.filter (fun n => n % q = a) (Finset.Icc 1 ⌊x⌋₊)).card = if a = 0 then ⌊x⌋₊ / q else if a ≤ ⌊x⌋₊ then (⌊x⌋₊ - a) / q + 1 else 0 := by
    split_ifs;
    · rw [ show { n ∈ Finset.Icc 1 ⌊x⌋₊ | n % q = a } = Finset.image ( fun n => n * q ) ( Finset.Icc 1 ( ⌊x⌋₊ / q ) ) from ?_, Finset.card_image_of_injective _ fun a b h => mul_right_cancel₀ hq.ne' h ] ; aesop;
      ext;
      simp_all +decide [ Nat.mod_eq_of_lt ];
      exact ⟨ fun h => ⟨ ‹_› / q, ⟨ Nat.div_pos ( Nat.le_of_dvd ( by linarith ) ( Nat.dvd_of_mod_eq_zero h.2 ) ) hq, Nat.div_le_div_right h.1.2 ⟩, Nat.div_mul_cancel ( Nat.dvd_of_mod_eq_zero h.2 ) ⟩, by rintro ⟨ a, ⟨ ha₁, ha₂ ⟩, rfl ⟩ ; exact ⟨ ⟨ by nlinarith, by nlinarith [ Nat.div_mul_le_self ( ⌊x⌋₊ ) q ] ⟩, by norm_num ⟩ ⟩;
    · -- Let's count the number of elements in the set $\{n \in [1, \lfloor x \rfloor] \mid n \equiv a \pmod{q}\}$.
      have h_count : Finset.filter (fun n => n % q = a) (Finset.Icc 1 ⌊x⌋₊) = Finset.image (fun k => a + k * q) (Finset.Icc 0 ((⌊x⌋₊ - a) / q)) := by
        ext;
        simp +zetaDelta at *;
        constructor;
        · exact fun h => ⟨ ‹_› / q, Nat.le_div_iff_mul_le hq |>.2 <| Nat.le_sub_of_add_le <| by linarith [ Nat.mod_add_div ‹_› q ], by linarith [ Nat.mod_add_div ‹_› q ] ⟩;
        · rintro ⟨ k, hk₁, rfl ⟩;
          exact ⟨ ⟨ by nlinarith [ Nat.pos_of_ne_zero ‹_› ], by nlinarith [ Nat.div_mul_le_self ( ⌊x⌋₊ - a ) q, Nat.sub_add_cancel ‹a ≤ ⌊x⌋₊› ] ⟩, by norm_num [ Nat.add_mod, Nat.mod_eq_of_lt ha ] ⟩;
      rw [ h_count, Finset.card_image_of_injective ] <;> aesop_cat;
    · exact Finset.card_eq_zero.mpr <| Finset.filter_eq_empty_iff.mpr fun n hn => by linarith [ Nat.mod_le n q, Finset.mem_Icc.mp hn ] ;
  -- Let's consider the two cases: $a = 0$ and $a > 0$.
  by_cases ha0 : a = 0;
  · rw [ abs_le ];
    constructor <;> simp_all +decide [ Nat.div_eq_of_lt ];
    · rw [ div_le_iff₀ ( by positivity ) ];
      exact le_trans ( Nat.lt_floor_add_one x |> le_of_lt ) ( by norm_cast; linarith [ Nat.div_add_mod ( ⌊x⌋₊ ) q, Nat.mod_lt ( ⌊x⌋₊ ) hq ] );
    · exact le_trans ( Nat.cast_div_le .. ) ( by rw [ add_div', div_le_div_iff_of_pos_right ] <;> norm_num <;> linarith [ Nat.floor_le hx ] );
  · split_ifs at h_count <;> simp_all +decide [ abs_le ];
    · constructor <;> norm_num [ add_comm, add_left_comm, add_assoc ];
      · rw [ div_le_iff₀ ] <;> norm_cast;
        exact le_trans ( Nat.lt_floor_add_one x |> le_of_lt ) ( by norm_cast; nlinarith [ Nat.div_add_mod ( ⌊x⌋₊ - a ) q, Nat.mod_lt ( ⌊x⌋₊ - a ) hq, Nat.sub_add_cancel ‹_› ] );
      · rw [ le_div_iff₀ ( by positivity ) ];
        exact le_trans ( mod_cast Nat.div_mul_le_self _ _ ) ( Nat.cast_le.mpr ( Nat.sub_le _ _ ) ) |> le_trans <| Nat.floor_le hx;
    · rw [ Finset.card_eq_zero.mpr ] <;> norm_num;
      · exact ⟨ by rw [ div_le_iff₀ ( by positivity ) ] ; nlinarith [ Nat.lt_floor_add_one x, show ( a : ℝ ) ≤ q by norm_cast; linarith, show ( ⌊x⌋₊ : ℝ ) + 1 ≤ a by norm_cast ], by positivity ⟩;
      · assumption

end