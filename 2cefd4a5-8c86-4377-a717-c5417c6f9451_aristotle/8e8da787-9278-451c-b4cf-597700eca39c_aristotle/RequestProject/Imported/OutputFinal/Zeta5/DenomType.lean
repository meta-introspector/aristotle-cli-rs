/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

Companion effort: arithmetic holonomy certificate for `ζ_5(3)`.
-/
import Mathlib
import RequestProject.Imported.OutputFinal.Zeta5.Coefficients

/-!
# The denominator type `τ(b) = 45/16`

The *denominator type* of a sequence of rationals is the exponential growth rate
of its denominators,

`τ(b) = lim_{n→∞} (1/n) log den(bₙ)`.

For the coefficient sequence of the certificate,
`bₙ = 5^{3n}/Dₙ` with `Dₙ` the prime-to-`5` part of
`lcm(1,…,n)² · lcm(1,…,⌊13n/16⌋)`, the denominator is exactly `Dₙ`
(`Zeta5.bseq_den`), and

`log Dₙ = 2 log lcm(1,…,n) + log lcm(1,…,⌊13n/16⌋) - v₅ · log 5`,

where the `5`-adic correction `v₅` is `O(log n)` and therefore invisible in the
limit.  With the Chebyshev/prime-number-theorem asymptotic
`log lcm(1,…,n) ∼ n` the type comes out as

`τ(b) = 2 + 13/16 = 45/16`.

**External input.**  The asymptotic `log lcm(1,…,n)/n → 1` (equivalently the
prime number theorem in the form `ψ(n) ∼ n`) is *not* available in Mathlib and
is *not* proved here; it is carried through the file as the explicit hypothesis
`ChebyshevPNT`.  Everything else — the exact denominator bookkeeping, the
negligibility of the `5`-part, and the arithmetic `2 + 13/16 = 45/16` — is
proved.
-/

namespace Zeta5

open Filter Topology

/-- The Chebyshev / prime-number-theorem input: `log lcm(1,…,n) ∼ n`.
This is the one external analytic certificate used for the denominator type. -/
def ChebyshevPNT : Prop :=
  Tendsto (fun n : ℕ => Real.log (lcmUpTo n) / n) atTop (𝓝 1)

/-- `b` has denominator type `τ`. -/
def DenomType (b : ℕ → ℚ) (τ : ℝ) : Prop :=
  Tendsto (fun n : ℕ => Real.log ((b n).den) / n) atTop (𝓝 τ)

/-! ### The `5`-part of the denominator is negligible -/

theorem lcmUpTo_succ (n : ℕ) : lcmUpTo (n + 1) = Nat.lcm (lcmUpTo n) (n + 1) := by
  rw [lcmUpTo, lcmUpTo, show Finset.Icc 1 (n + 1) = insert (n + 1) (Finset.Icc 1 n) by
    ext x; simp [Finset.mem_Icc]; omega]
  rw [Finset.lcm_insert]
  simpa using lcm_comm (n + 1) ((Finset.Icc 1 n).lcm id)

/-- The `p`-part of `lcm(1,…,n)` is at most `n`: `p^{v_p(lcm(1,…,n))} ≤ max 1 n`. -/
theorem ordProj_lcmUpTo_le (p n : ℕ) :
    p ^ ((lcmUpTo n).factorization p) ≤ max 1 n := by
  induction n with
  | zero =>
      have : lcmUpTo 0 = 1 := by simp [lcmUpTo]
      simp [this]
  | succ n ih =>
      have hL : lcmUpTo n ≠ 0 := lcmUpTo_ne_zero n
      have hn1 : (n + 1 : ℕ) ≠ 0 := by omega
      have hfac : (lcmUpTo (n + 1)).factorization p
          = max ((lcmUpTo n).factorization p) ((n + 1).factorization p) := by
        rw [lcmUpTo_succ, Nat.factorization_lcm hL hn1]
        simp
      have h2 : p ^ ((n + 1).factorization p) ≤ n + 1 :=
        Nat.le_of_dvd (by omega) (Nat.ordProj_dvd _ _)
      rw [hfac]
      rcases le_total ((lcmUpTo n).factorization p) ((n + 1).factorization p) with h | h
      · rw [max_eq_right h]
        exact le_trans h2 (le_max_of_le_right (by omega))
      · rw [max_eq_left h]
        exact le_trans ih (by
          rcases Nat.eq_zero_or_pos n with rfl | hn
          · simp
          · simp only [max_eq_right (by omega : 1 ≤ n), max_eq_right (by omega : 1 ≤ n + 1)]
            omega)

/-- The `5`-adic valuation of the unreduced denominator. -/
theorem factorization_rawDen (n : ℕ) :
    (rawDen n).factorization 5
      = 2 * (lcmUpTo n).factorization 5 + (lcmUpTo (13 * n / 16)).factorization 5 := by
  rw [rawDen, Nat.factorization_mul (pow_ne_zero 2 (lcmUpTo_ne_zero n)) (lcmUpTo_ne_zero _)]
  simp [Nat.factorization_pow]

/-- The `5`-part of the unreduced denominator is at most `(max 1 n)³`. -/
theorem ordProj_rawDen_le (n : ℕ) :
    5 ^ ((rawDen n).factorization 5) ≤ (max 1 n) ^ 3 := by
  have h1 := ordProj_lcmUpTo_le 5 n
  have h2 := ordProj_lcmUpTo_le 5 (13 * n / 16)
  have h2' : 5 ^ ((lcmUpTo (13 * n / 16)).factorization 5) ≤ max 1 n := by
    refine le_trans h2 ?_
    rcases Nat.eq_zero_or_pos n with rfl | hn
    · simp
    · simp only [max_le_iff]
      constructor
      · omega
      · exact le_max_of_le_right (by omega)
  rw [factorization_rawDen, pow_add, pow_mul']
  calc (5 ^ ((lcmUpTo n).factorization 5)) ^ 2 * 5 ^ ((lcmUpTo (13 * n / 16)).factorization 5)
      ≤ (max 1 n) ^ 2 * (max 1 n) := by
        exact Nat.mul_le_mul (Nat.pow_le_pow_left h1 2) h2'
    _ = (max 1 n) ^ 3 := by ring

/-! ### Logarithmic bookkeeping -/

theorem log_bDen (n : ℕ) :
    Real.log (bDen n)
      = Real.log (rawDen n) - ((rawDen n).factorization 5 : ℝ) * Real.log 5 := by
  have hsplit : 5 ^ ((rawDen n).factorization 5) * bDen n = rawDen n :=
    Nat.ordProj_mul_ordCompl_eq_self (rawDen n) 5
  have h1 : Real.log ((5 : ℝ) ^ ((rawDen n).factorization 5) * (bDen n : ℝ))
      = Real.log (rawDen n) := by
    rw [show ((5 : ℝ) ^ ((rawDen n).factorization 5) * (bDen n : ℝ))
        = ((5 ^ ((rawDen n).factorization 5) * bDen n : ℕ) : ℝ) by push_cast; ring, hsplit]
  rw [Real.log_mul (pow_ne_zero _ (by norm_num : (5 : ℝ) ≠ 0))
    (by exact_mod_cast bDen_ne_zero n), Real.log_pow] at h1
  linarith

theorem log_rawDen (n : ℕ) :
    Real.log (rawDen n)
      = 2 * Real.log (lcmUpTo n) + Real.log (lcmUpTo (13 * n / 16)) := by
  rw [rawDen]
  push_cast
  rw [Real.log_mul (pow_ne_zero 2 (by exact_mod_cast lcmUpTo_ne_zero n))
    (by exact_mod_cast lcmUpTo_ne_zero _), Real.log_pow]
  push_cast
  ring

/-! ### The three limits -/

private theorem tendsto_log_div_nat : Tendsto (fun n : ℕ => Real.log n / n) atTop (𝓝 0) := by
  have h := Real.tendsto_pow_log_div_mul_add_atTop 1 0 1 one_ne_zero
  simp only [pow_one, one_mul, add_zero] at h
  exact h.comp tendsto_natCast_atTop_atTop

/-- The `5`-adic correction is negligible. -/
theorem tendsto_five_part :
    Tendsto (fun n : ℕ => ((rawDen n).factorization 5 : ℝ) * Real.log 5 / n) atTop (𝓝 0) := by
  have hlog5 : (0 : ℝ) ≤ Real.log 5 := Real.log_nonneg (by norm_num)
  refine squeeze_zero' (g := fun n : ℕ => 3 * (Real.log n / n))
    (Filter.Eventually.of_forall fun n ↦ by positivity) ?_ ?_
  · filter_upwards [Filter.eventually_ge_atTop 1] with n hn
    have hmax : max 1 n = n := max_eq_right hn
    have hle : (5 : ℝ) ^ ((rawDen n).factorization 5) ≤ (n : ℝ) ^ 3 := by
      have := ordProj_rawDen_le n
      rw [hmax] at this
      exact_mod_cast this
    have hlog : ((rawDen n).factorization 5 : ℝ) * Real.log 5 ≤ 3 * Real.log n := by
      have h1 : Real.log ((5 : ℝ) ^ ((rawDen n).factorization 5)) ≤ Real.log ((n : ℝ) ^ 3) :=
        Real.log_le_log (by positivity) hle
      rw [Real.log_pow, Real.log_pow] at h1
      push_cast at h1 ⊢
      linarith
    have hn0 : (0 : ℝ) < n := by exact_mod_cast hn
    calc ((rawDen n).factorization 5 : ℝ) * Real.log 5 / n
        ≤ (3 * Real.log n) / n := (div_le_div_iff_of_pos_right hn0).mpr hlog
      _ = 3 * (Real.log n / n) := by ring
  · have h := tendsto_log_div_nat
    simpa using h.const_mul (3 : ℝ)

/-- The truncated `lcm` contributes `13/16`. -/
theorem tendsto_log_lcm_trunc (h : ChebyshevPNT) :
    Tendsto (fun n : ℕ => Real.log (lcmUpTo (13 * n / 16)) / n) atTop (𝓝 (13 / 16)) := by
  have hm : Tendsto (fun n : ℕ => 13 * n / 16) atTop atTop := by
    apply Filter.tendsto_atTop_atTop.2
    intro b
    exact ⟨2 * b + 16, fun a ha ↦ by omega⟩
  have h1 : Tendsto (fun n : ℕ => Real.log (lcmUpTo (13 * n / 16)) / (13 * n / 16 : ℕ))
      atTop (𝓝 1) := h.comp hm
  have h2 : Tendsto (fun n : ℕ => ((13 * n / 16 : ℕ) : ℝ) / n) atTop (𝓝 (13 / 16)) := by
    have hlower : Tendsto (fun n : ℕ => (13 : ℝ) / 16 - 1 / n) atTop (𝓝 (13 / 16)) := by
      simpa using (tendsto_one_div_atTop_nhds_zero_nat).const_sub ((13 : ℝ) / 16)
    refine tendsto_of_tendsto_of_tendsto_of_le_of_le' hlower tendsto_const_nhds ?_ ?_
    · filter_upwards [Filter.eventually_ge_atTop 1] with n hn
      have hn0 : (0 : ℝ) < n := by exact_mod_cast hn
      have hlow : (13 * n : ℝ) - 16 < 16 * ((13 * n / 16 : ℕ) : ℝ) := by
        have h' : 13 * n < 16 * (13 * n / 16) + 16 := by omega
        have h'' : (13 * n : ℝ) < 16 * ((13 * n / 16 : ℕ) : ℝ) + 16 := by exact_mod_cast h'
        linarith
      rw [sub_le_iff_le_add, ← sub_le_iff_le_add']
      rw [div_sub_div _ _ (by norm_num : (16 : ℝ) ≠ 0) hn0.ne', div_le_div_iff₀ (by positivity) hn0]
      nlinarith
    · filter_upwards [Filter.eventually_ge_atTop 1] with n hn
      have hn0 : (0 : ℝ) < n := by exact_mod_cast hn
      have hhigh : 16 * ((13 * n / 16 : ℕ) : ℝ) ≤ (13 * n : ℝ) := by
        have h' : 16 * (13 * n / 16) ≤ 13 * n := by omega
        exact_mod_cast h'
      rw [div_le_div_iff₀ hn0 (by norm_num : (0 : ℝ) < 16)]
      nlinarith
  have := h1.mul h2
  rw [one_mul] at this
  refine this.congr' ?_
  filter_upwards [Filter.eventually_ge_atTop 16] with n hn
  have hpos : (0 : ℝ) < ((13 * n / 16 : ℕ) : ℝ) := by
    have : 1 ≤ 13 * n / 16 := by omega
    exact_mod_cast this
  field_simp

/-- **Task 3 (denominator type).**  Given the Chebyshev/PNT asymptotic, the
coefficient sequence has denominator type `τ(b) = 45/16`. -/
theorem denomType_bseq (h : ChebyshevPNT) : DenomType bseq (45 / 16) := by
  have key : ∀ n : ℕ, Real.log ((bseq n).den) / n
      = 2 * (Real.log (lcmUpTo n) / n) + Real.log (lcmUpTo (13 * n / 16)) / n
        - ((rawDen n).factorization 5 : ℝ) * Real.log 5 / n := by
    intro n
    rw [bseq_den, log_bDen, log_rawDen]
    ring
  have hlim : Tendsto (fun n : ℕ =>
      2 * (Real.log (lcmUpTo n) / n) + Real.log (lcmUpTo (13 * n / 16)) / n
        - ((rawDen n).factorization 5 : ℝ) * Real.log 5 / n) atTop
      (𝓝 (2 * 1 + 13 / 16 - 0)) :=
    ((h.const_mul 2).add (tendsto_log_lcm_trunc h)).sub tendsto_five_part
  rw [DenomType]
  have : (2 * 1 + 13 / 16 - 0 : ℝ) = 45 / 16 := by norm_num
  rw [← this]
  exact hlim.congr fun n ↦ (key n).symm

end Zeta5
