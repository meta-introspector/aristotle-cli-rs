/-
# Projective Special Linear Groups

The groups PSL(n, q) = SL(n, q) / Z(SL(n, q)) form one of the
principal families of finite simple groups. PSL(2, q) is simple
for q ≥ 4 (with some small exceptions).

## Atlas data for small PSL groups

| Group      | Order   | Also known as     |
|------------|---------|-------------------|
| PSL(2,4)   | 60      | ≅ A₅              |
| PSL(2,5)   | 60      | ≅ A₅              |
| PSL(2,7)   | 168     | ≅ GL(3,2)         |
| PSL(2,9)   | 360     | ≅ A₆              |
| PSL(2,11)  | 660     |                   |
| PSL(3,2)   | 168     | ≅ PSL(2,7)        |
| PSL(3,4)   | 20160   |                   |

## Orders

The order of PSL(n, q) where q = pᵏ is:
  |PSL(n,q)| = (1/gcd(n,q-1)) · q^(n(n-1)/2) · ∏_{i=1}^{n-1} (q^(i+1) - 1)
-/

import Mathlib

/-! ## Order of PSL(2, q) -/

/-- The order formula for PSL(2, q):
    |PSL(2, q)| = q(q² - 1) / gcd(2, q - 1)

    For q = p^k with p prime:
    - If p = 2: |PSL(2, q)| = q(q² - 1) = q(q-1)(q+1)
    - If p odd: |PSL(2, q)| = q(q² - 1) / 2 = q(q-1)(q+1) / 2
-/
def psl2_order (q : ℕ) : ℕ :=
  q * (q ^ 2 - 1) / Nat.gcd 2 (q - 1)

/-- PSL(2,4) has order 60. -/
theorem psl2_order_4 : psl2_order 4 = 60 := by native_decide

/-- PSL(2,5) has order 60. -/
theorem psl2_order_5 : psl2_order 5 = 60 := by native_decide

/-- PSL(2,7) has order 168. -/
theorem psl2_order_7 : psl2_order 7 = 168 := by native_decide

/-- PSL(2,9) has order 360. -/
theorem psl2_order_9 : psl2_order 9 = 360 := by native_decide

/-- PSL(2,11) has order 660. -/
theorem psl2_order_11 : psl2_order 11 = 660 := by native_decide

/-- PSL(2,13) has order 1092. -/
theorem psl2_order_13 : psl2_order 13 = 1092 := by native_decide

/-! ## Order of GL(n, q)

The order of GL(n, q) is ∏_{i=0}^{n-1} (qⁿ - qⁱ)
-/

/-- The order of GL(n, q). -/
def gl_order (n q : ℕ) : ℕ :=
  (Finset.range n).prod (fun i => q ^ n - q ^ i)

/-- GL(2, 2) has order 6. -/
theorem gl_order_2_2 : gl_order 2 2 = 6 := by native_decide

/-- GL(3, 2) has order 168. This group is isomorphic to PSL(2, 7). -/
theorem gl_order_3_2 : gl_order 3 2 = 168 := by native_decide

/-- GL(2, 3) has order 48. -/
theorem gl_order_2_3 : gl_order 2 3 = 48 := by native_decide
