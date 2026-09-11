import Mathlib
import RequestProject.HeckeOperator
import RequestProject.HeckeFFI

/-!
# Correctness of the executable Hecke operator

This file connects the `Mathlib`-free executable implementation `HeckeFFI.heckeOpInt`
(used for FFI) with the verified definition `HeckeRelations.heckeOp` from
`RequestProject.HeckeOperator`.  The main result `HeckeFFI.heckeOpInt_eq` certifies that
the code called from Rust computes exactly the classical Hecke-operator coefficient
formula

  `(T_m a)(n) = ∑_{d ∣ gcd(m,n)} d^{k-1} · a(m·n / d²)`.

Combined with the theorems in `HeckeOperator.lean`, every property proved there
(`heckeOp_apply_one`, `heckeOp_mul_coprime`, the eigenform relations, …) therefore holds
of the executable code as well.
-/

open scoped BigOperators

namespace HeckeFFI

/-
The list `heckeDivisors g` is exactly the (ascending) list of divisors of `g`; as a
finite set it agrees with `Nat.divisors g`.
-/
theorem heckeDivisors_toFinset (g : Nat) :
    (heckeDivisors g).toFinset = g.divisors := by
  ext; simp [heckeDivisors];
  exact ⟨ fun h => ⟨ Nat.dvd_of_mod_eq_zero h.2.2, by aesop ⟩, fun h => ⟨ Nat.le_of_dvd ( Nat.pos_of_ne_zero h.2 ) h.1, by aesop, Nat.mod_eq_zero_of_dvd h.1 ⟩ ⟩

/-
`heckeDivisors g` has no duplicate entries.
-/
theorem heckeDivisors_nodup (g : Nat) : (heckeDivisors g).Nodup := by
  exact List.Nodup.filterMap (by grind) List.nodup_range

/-
**Correctness of the executable Hecke operator.** The `Int`/`Array`-based
implementation used for FFI computes exactly the verified Hecke-operator coefficient
`HeckeRelations.heckeOp`.
-/
theorem heckeOpInt_eq (k m : ℕ) (coeffs : Array Int) (n : ℕ) :
    heckeOpInt k m coeffs n
      = HeckeRelations.heckeOp k m (coeffOfArray coeffs) n := by
  -- By definition of `heckeOpInt`, we can rewrite the left-hand side of the equation.
  have h_lhs : heckeOpInt k m coeffs n = List.sum (List.map (fun d => (Int.ofNat (d ^ (k - 1))) * coeffOfArray coeffs (m * n / (d * d))) (heckeDivisors (Nat.gcd m n))) := by
    unfold heckeOpInt;
    induction ( heckeDivisors ( Nat.gcd m n ) ) using List.reverseRecOn <;> aesop;
  rw [ h_lhs, ← List.sum_toFinset ];
  · rw [ heckeDivisors_toFinset ];
    simp +decide [ HeckeRelations.heckeOp ];
    simp +decide only [pow_two];
  · exact heckeDivisors_nodup _

end HeckeFFI