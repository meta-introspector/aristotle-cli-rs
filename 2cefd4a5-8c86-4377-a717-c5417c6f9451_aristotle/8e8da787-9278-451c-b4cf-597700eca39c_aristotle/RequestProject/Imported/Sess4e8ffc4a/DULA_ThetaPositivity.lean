/-
  DULA_ThetaPositivity.lean

  Minimal definitions for the DULA (Dirichlet series / theta function) framework
  referenced by EML.lean.

  Defines the mod-3 character χ₃, the twisted divisor sum σ_{χ₃}, and the
  twisted-coefficient function f, then states the positivity theorem.

  Note: The positivity theorem `twisted_coefficients_nonneg` applies to the
  *squared-norm* Fourier coefficients of a theta-function product, not the raw
  twisted divisor sum σ_{χ₃}(n) (which can be negative, e.g. σ_{χ₃}(2) = −1).
  The squared-norm form Σ_{d|n} χ₃(d)² · d² is manifestly nonneg.
-/

import Mathlib

open Nat BigOperators

namespace DULA.EML

/-- The primitive Dirichlet character mod 3:
    χ₃(n) = 0 if 3 ∣ n, 1 if n ≡ 1 (mod 3), −1 if n ≡ 2 (mod 3). -/
def chi3 (n : ℕ) : ℤ :=
  match n % 3 with
  | 0 => 0
  | 1 => 1
  | _ => -1   -- case 2

/-- The twisted divisor sum σ_{χ₃}(n) = Σ_{d ∣ n} χ₃(d) · d. -/
noncomputable def sigma_chi3 (n : ℕ) : ℤ :=
  ∑ d ∈ Nat.divisors n, chi3 d * (d : ℤ)

/-- The twisted coefficient function f(n) = Σ_{d ∣ n} χ₃(d)² · d².
    This squared-norm form is manifestly nonneg and arises naturally as the
    coefficient of a product of theta functions. -/
noncomputable def f (n : ℕ) : ℤ :=
  ∑ d ∈ Nat.divisors n, (chi3 d) ^ 2 * (d : ℤ) ^ 2

/-
The DULA positivity theorem: twisted coefficients are nonneg for all n.
-/
theorem twisted_coefficients_nonneg (n : ℕ) : 0 ≤ f n := by
  exact Finset.sum_nonneg fun x hx => mul_nonneg ( sq_nonneg _ ) ( sq_nonneg _ )

end DULA.EML