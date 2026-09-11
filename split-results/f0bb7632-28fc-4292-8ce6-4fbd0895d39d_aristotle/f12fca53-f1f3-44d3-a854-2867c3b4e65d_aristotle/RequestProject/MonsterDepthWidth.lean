/-
# Two Conformal Views: Log-scale and Graded Neural Architectures

This module formalizes the depth/width decomposition of divisors using prime valuations.

Given a prime `p` and a natural number `d`, we decompose:
- **depth** = `v_p(d)` (the p-adic valuation / multiplicity of p in d)
- **width** = `d / p^(v_p(d))` (the p-free part)

These give two "conformal views" of the divisor lattice:
1. **Log-scale (additive):** In the log_p coordinate, multiplicative structure becomes additive.
   The depth `v_p(d)` is the integer part of `log_p(d)`.
2. **Graded architecture:** Each divisor `d` is a "layer" with depth from the prime power
   and width from the cofactor. This models graded neural architectures where
   depth = number of layers and width = channels per layer.

The two axes from the conversation:
- **2-axis** (multiplicative/struct): v₂(d) captures binary structural complexity
- **3-axis** (additive/enum): v₃(d) captures ternary graded depth
-/

import Mathlib
import RequestProject.MonsterLattice

open Finsupp

/-! ## Monster group prime factorization

The Monster order has the prime factorization:
|M| = 2^46 · 3^20 · 5^9 · 7^6 · 11^2 · 13^3 · 17 · 19 · 23 · 29 · 31 · 41 · 47 · 59 · 71 -/

/-- The 2-adic valuation of the Monster order is 46. -/
theorem monster_val_2 : MonsterOrder.factorization 2 = 46 := by native_decide

/-- The 3-adic valuation of the Monster order is 20. -/
theorem monster_val_3 : MonsterOrder.factorization 3 = 20 := by native_decide

/-- The 5-adic valuation of the Monster order is 9. -/
theorem monster_val_5 : MonsterOrder.factorization 5 = 9 := by native_decide

/-- The 7-adic valuation of the Monster order is 6. -/
theorem monster_val_7 : MonsterOrder.factorization 7 = 6 := by native_decide

/-- The 11-adic valuation of the Monster order is 2. -/
theorem monster_val_11 : MonsterOrder.factorization 11 = 2 := by native_decide

/-- The 13-adic valuation of the Monster order is 3. -/
theorem monster_val_13 : MonsterOrder.factorization 13 = 3 := by native_decide

/-! ## Depth and Width decomposition

For a prime `p` and a natural number `d`, define:
- depth_p(d) = v_p(d) = the exponent of p in the factorization of d
- width_p(d) = d / p^v_p(d) = the p-free part of d

Then d = p^depth * width, and gcd(width, p) = 1.
-/

/-- The "depth" of `d` at prime `p`: the p-adic valuation `v_p(d)`.
    In the neural architecture interpretation, this is the number of p-scaled layers. -/
def depth (p d : ℕ) : ℕ := d.factorization p

/-- The "width" of `d` at prime `p`: the p-free part `d / p^v_p(d)`.
    In the neural architecture interpretation, this is the number of channels. -/
def width (p d : ℕ) : ℕ := d / p ^ (d.factorization p)

/-- Depth-width reconstruction: `p^depth(d) * width(d) = d`.
    This is the fundamental decomposition: every number factors as a prime power times
    a coprime cofactor. -/
theorem depth_width_reconstruction (p d : ℕ) :
    p ^ depth p d * width p d = d := by
  simp only [depth, width]
  exact Nat.mul_div_cancel' (Nat.ordProj_dvd d p)

/-
The width is coprime to the prime `p` when `d > 0` and `p` is prime.
-/
theorem width_coprime (p d : ℕ) (hp : Nat.Prime p) (hd : 0 < d) :
    Nat.Coprime (width p d) p := by
  exact Nat.Coprime.symm ( hp.coprime_iff_not_dvd.mpr <| Nat.not_dvd_ordCompl ( by aesop ) <| by aesop )

/-! ## The two orthogonal axes: v₂ and v₃

The user's framework declares:
- **2-axis** = multiplicative group = product = struct
- **3-axis** = additive group = sum = disjoint union = enum

For any divisor `d | |M|`, its position in the (v₂, v₃) plane gives the
"two sheaf coordinates". The pair `(v₂(d), v₃(d))` determines the
structural-vs-enumerative character of that divisor's box. -/

/-- The (v₂, v₃) coordinate pair for a natural number. -/
def valuation_pair (d : ℕ) : ℕ × ℕ :=
  (d.factorization 2, d.factorization 3)

/-- The (v₂, v₃) coordinates of the Monster order. -/
theorem monster_valuation_pair : valuation_pair MonsterOrder = (46, 20) := by
  simp only [valuation_pair]; exact Prod.mk.injEq .. |>.mpr ⟨by native_decide, by native_decide⟩

/-- For the Monster, the 2-axis has 47 levels (0 through 46) and
    the 3-axis has 21 levels (0 through 20). The total number of
    (v₂, v₃) grid points is 47 × 21 = 987.

    Remarkably, 987 is the 16th Fibonacci number! This connects
    the Monster's prime structure to the Fibonacci/golden-ratio theme. -/
theorem monster_grid_size : (46 + 1) * (20 + 1) = 987 := by norm_num

/-- 987 is indeed the 16th Fibonacci number (F₁₆). -/
def fib : ℕ → ℕ
  | 0 => 0
  | 1 => 1
  | n + 2 => fib n + fib (n + 1)

theorem fib_16_eq : fib 16 = 987 := by native_decide

/-! ## Depth chains and layer structure

A divisor chain d₁ | d₂ | ⋯ | dₖ where each step multiplies by p
gives a chain of increasing depths. This is the "deepening architecture"
where each multiplication by p adds one layer. -/

/-
If `d₁ ∣ d₂`, then `depth p d₁ ≤ depth p d₂` for any prime `p`.
-/
theorem depth_monotone_of_dvd (p d₁ d₂ : ℕ) (_hp : Nat.Prime p) (h : d₁ ∣ d₂)
    (hd₂ : d₂ ≠ 0) :
    depth p d₁ ≤ depth p d₂ := by
  exact Nat.factorization_le_iff_dvd ( by aesop ) ( by aesop ) |>.2 h p

/-! ## Log-scale view

In the log_p coordinate, the divisor lattice becomes "almost linear":
- log_p(d) = v_p(d) + log_p(width_p(d))
- For d in a p-power chain, the fractional part is constant

The "additive displacement" in the log₃ view is exactly the change in v₃. -/

/-- The log-base-p of a natural number, as a real number. -/
noncomputable def logBase (p : ℕ) (d : ℕ) : ℝ :=
  Real.logb p d

/-
The integer part of log_p(d) is at least v_p(d).
-/
theorem logBase_ge_depth (p d : ℕ) (hp : 1 < p) (hd : 0 < d) :
    depth p d ≤ logBase p d := by
  unfold logBase;
  rw [ Real.le_logb_iff_rpow_le ] <;> norm_cast;
  exact Nat.le_of_dvd hd ( Nat.ordProj_dvd _ _ )

/-! ## Evaluation: Monster depth/width at primes 2 and 3 -/

-- The Monster's depth at 2 is 46 (46 binary layers)
example : depth 2 MonsterOrder = 46 := by native_decide
-- The Monster's depth at 3 is 20 (20 ternary layers)
example : depth 3 MonsterOrder = 20 := by native_decide

-- Width at 2: the odd part of |M|
-- Width at 3: the 3-free part of |M|
#eval width 2 MonsterOrder  -- odd part
#eval width 3 MonsterOrder