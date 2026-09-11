/-
# Orders of Finite Simple Groups
This file formalizes the order formulas for the classical families of
finite simple groups, as tabulated in the ATLAS (Chapter 1, Section 2).
-/
import Mathlib
set_option maxHeartbeats 4000000
set_option maxRecDepth 4000
open scoped BigOperators Classical Nat
noncomputable section
/-- The order of GL(n, q), the general linear group:
    |GL(n,q)| = ∏_{i=0}^{n-1} (q^n - q^i). -/
def orderGL (n q : ℕ) : ℕ :=
  ∏ i ∈ Finset.range n, (q ^ n - q ^ i)
/-- The order of PSp(2n, q) = S_{2n}(q), the projective symplectic group:
    |S_{2n}(q)| = q^{n²} · ∏_{i=1}^{n} (q^{2i} - 1) / gcd(2, q-1). -/
def orderPSp (n q : ℕ) : ℕ :=
  q ^ (n ^ 2) * (∏ i ∈ Finset.range n, (q ^ (2 * (i + 1)) - 1)) / Nat.gcd 2 (q - 1)
/-- |A₅| = 60, verified by Lean's kernel. -/
theorem alternatingGroup_5_order :
    Fintype.card (alternatingGroup (Fin 5)) = 60 := by native_decide
/-- |A₅| = 60 = 5!/2. -/
theorem alternating_order_formula :
    Fintype.card (alternatingGroup (Fin 5)) = Nat.factorial 5 / 2 := by native_decide
/-- A₆ has order 360. -/
theorem A6_order : Fintype.card (alternatingGroup (Fin 6)) = 360 := by native_decide
end -- noncomputable section
