/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

Companion effort: arithmetic holonomy certificate for `ζ_5(3)`.
-/
import Mathlib

/-!
# The coefficient sequence `b` of the certificate

The arithmetic side of an arithmetic-holonomy estimate is controlled by two
invariants of the coefficient sequence `b : ℕ → ℚ` of the auxiliary holonomic
function:

* its **denominator type** `τ(b) = lim (1/n) log den(bₙ)` (a growth rate of the
  denominators away from the distinguished prime), and
* its **`p`-adic overconvergence radius** `R_p` (how far the series
  `Σ bₙ zⁿ` converges `p`-adically).

This file fixes the coefficient sequence used by the certificate, namely

`bₙ = 5^{3n} / Dₙ`,  `Dₙ = the prime-to-5 part of  lcm(1,…,n)² · lcm(1,…,⌊13n/16⌋)`.

The two shapes are exactly the ones the certificate needs:

* the numerator `5^{3n}` makes the series `5`-adically overconvergent of radius
  `R₅ = 5³` (proved unconditionally in `Zeta5/Radius.lean`), and
* the denominator, three `lcm`-factors of which the last is truncated at
  `13n/16`, has logarithmic growth `2 + 13/16 = 45/16` — the denominator type
  `τ(b) = 45/16` (proved in `Zeta5/DenomType.lean` from the Chebyshev/PNT
  asymptotic `log lcm(1,…,n) ∼ n`, which is carried as an explicit hypothesis).

Everything in *this* file is unconditional and purely arithmetic.
-/

namespace Zeta5

open Finset

/-- `lcmUpTo n = lcm(1, 2, …, n)`. -/
def lcmUpTo (n : ℕ) : ℕ := (Finset.Icc 1 n).lcm id

theorem lcmUpTo_ne_zero (n : ℕ) : lcmUpTo n ≠ 0 := by
  rw [lcmUpTo, Ne, Finset.lcm_eq_zero_iff]
  rintro ⟨x, hx, hx0⟩
  simp only [Finset.mem_Icc, id_eq] at hx hx0
  omega

theorem lcmUpTo_pos (n : ℕ) : 0 < lcmUpTo n := Nat.pos_of_ne_zero (lcmUpTo_ne_zero n)

/-- Every `k` with `1 ≤ k ≤ n` divides `lcm(1,…,n)`. -/
theorem dvd_lcmUpTo {k n : ℕ} (h1 : 1 ≤ k) (h2 : k ≤ n) : k ∣ lcmUpTo n :=
  Finset.dvd_lcm (f := id) (by simp [Finset.mem_Icc, h1, h2])

/-- The unreduced denominator `lcm(1,…,n)² · lcm(1,…,⌊13n/16⌋)`. -/
def rawDen (n : ℕ) : ℕ := (lcmUpTo n) ^ 2 * lcmUpTo (13 * n / 16)

theorem rawDen_ne_zero (n : ℕ) : rawDen n ≠ 0 := by
  simp [rawDen, lcmUpTo_ne_zero]

/-- The denominator of `bₙ`: the prime-to-`5` part of `rawDen n`. -/
def bDen (n : ℕ) : ℕ := ordCompl[5] (rawDen n)

theorem bDen_pos (n : ℕ) : 0 < bDen n := Nat.ordCompl_pos 5 (rawDen_ne_zero n)

theorem bDen_ne_zero (n : ℕ) : bDen n ≠ 0 := (bDen_pos n).ne'

theorem five_not_dvd_bDen (n : ℕ) : ¬ (5 ∣ bDen n) :=
  Nat.not_dvd_ordCompl (by norm_num) (rawDen_ne_zero n)

/-- The coefficient sequence of the certificate. -/
def bseq (n : ℕ) : ℚ := (5 : ℚ) ^ (3 * n) / (bDen n : ℚ)

theorem coprime_pow_five_bDen (n : ℕ) : Nat.Coprime (5 ^ (3 * n)) (bDen n) :=
  Nat.Coprime.pow_left _
    ((Nat.Prime.coprime_iff_not_dvd (by norm_num)).mpr (five_not_dvd_bDen n))

theorem bseq_pos (n : ℕ) : 0 < bseq n := by
  have h : (0 : ℚ) < (bDen n : ℚ) := by exact_mod_cast bDen_pos n
  exact div_pos (by positivity) h

theorem bseq_ne_zero (n : ℕ) : bseq n ≠ 0 := (bseq_pos n).ne'

/-- The denominator of `bₙ` is exactly `Dₙ`: the fraction `5^{3n}/Dₙ` is already
in lowest terms, since `Dₙ` is prime to `5`. -/
theorem bseq_den (n : ℕ) : (bseq n).den = bDen n := by
  have hb : ((bDen n : ℤ) : ℚ) ≠ 0 := by
    exact_mod_cast (bDen_ne_zero n)
  have h : bseq n = ((5 ^ (3 * n) : ℤ) : ℚ) / ((bDen n : ℤ) : ℚ) := by
    rw [bseq]; push_cast; ring
  have hcop : Nat.Coprime ((5 ^ (3 * n) : ℤ)).natAbs ((bDen n : ℤ)).natAbs := by
    simpa using coprime_pow_five_bDen n
  have hden := Rat.den_div_eq_of_coprime (a := (5 ^ (3 * n) : ℤ)) (b := (bDen n : ℤ))
    (by exact_mod_cast bDen_pos n) hcop
  rw [h]
  exact_mod_cast hden

end Zeta5
