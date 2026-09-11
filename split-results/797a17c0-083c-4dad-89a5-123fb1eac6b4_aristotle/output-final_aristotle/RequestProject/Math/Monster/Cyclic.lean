/-
# Cyclic groups of prime order

The simplest family of finite simple groups: the cyclic groups ℤ/pℤ
for p prime. These are the abelian simple groups.

From the Atlas: every abelian simple group is cyclic of prime order.
-/

import Mathlib

/-! ## Cyclic groups of prime order are simple -/

/-
A cyclic group of prime order is simple.
    We use `Multiplicative (ZMod p)` to get a multiplicative group structure.
    This is a fundamental fact recorded in the Atlas.
-/
theorem ZMod.isSimpleGroup_of_prime (p : ℕ) [hp : Fact (Nat.Prime p)] :
    IsSimpleGroup (Multiplicative (ZMod p)) := by
  -- By the previous result, a cyclic group of prime order is simple.
  have h_simple : IsSimpleGroup (Multiplicative (ZMod p)) := by
    have h_card : Nat.card (Multiplicative (ZMod p)) = p := by
      simp +zetaDelta at *
    convert isSimpleGroup_of_prime_card h_card;
  exact h_simple

/-- The order of ZMod p is p. -/
theorem ZMod.card_eq' (p : ℕ) [NeZero p] :
    Fintype.card (ZMod p) = p :=
  ZMod.card p

/-- Every finite group of prime order is simple.
    This follows directly from Mathlib's `isSimpleGroup_of_prime_card`. -/
theorem isSimpleGroup_of_prime_order
    (G : Type*) [Group G] [Fintype G] (p : ℕ) [hp : Fact (Nat.Prime p)]
    (hcard : Fintype.card G = p) :
    IsSimpleGroup G :=
  isSimpleGroup_of_prime_card (p := p) (by rw [Nat.card_eq_fintype_card]; exact hcard)