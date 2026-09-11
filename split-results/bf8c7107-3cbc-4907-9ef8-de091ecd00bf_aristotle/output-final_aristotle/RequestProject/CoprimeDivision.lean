import Mathlib

/-!
# The coprime-division lemma, abstracted beyond the Monster Walk

The Factor-Shadow experiment (`RequestProject.MonsterFactorShadow`) relied on one genuinely
general arithmetic fact, isolated there as `coprime_removed_dvd_partial`:

> if an integer `L` divides a product `|G| = P · R` and is coprime to the "removed" factor
> `R`, then `L` already divides the "surviving" factor `P`.

This module states that fact in full generality, free of any Monster-specific data, so it
can be reused for **any** factor-structured walk or CRT-style encoding in which a quantity
is split into a "removed product" `R` and a "surviving / partial part" `P` with
`|whole| = P · R`.

* `Nat.dvd_of_coprime_removed` — the pure-`ℕ` statement: `L ∣ P · R → Nat.Coprime L R →
  L ∣ P`.  (Together with `L ∣ P · R ↔ L ∣ whole` when `whole = P · R`.)
* `dvd_partial_of_coprime_removed` — the same packaged for a "whole = partial · removed"
  decomposition: `whole = P * R → L ∣ whole → Nat.Coprime L R → L ∣ P`.
* `Fintype.dvd_of_card_eq_mul_of_coprime` — the finite-group flavour requested: for a finite
  group `G` with `Fintype.card G = P · R`, any `L ∣ |G|` coprime to `R` divides `P`.  (This
  is purely a statement about `Nat`-valued orders; the group structure plays no role beyond
  supplying the order, which is why the underlying lemma is the `ℕ` one.)

The point of the abstraction: *coprimality to the removed product is exactly the design
condition that lets a divisor survive intact into the partial part.*  Whenever a walk or
encoding fails to enforce that coprimality, divisors can be trapped by the removed factors
(as happens for every Monster-smooth leading-digit shadow).
-/

namespace CoprimeDivision

/-- **Pure-`ℕ` coprime division.** If `L` divides the product `P * R` and is coprime to the
right factor `R`, then `L` divides the left factor `P`.  This is the engine behind every
"survives into the partial part" statement. -/
theorem Nat.dvd_of_coprime_removed {L P R : ℕ} (hdvd : L ∣ P * R)
    (hcop : Nat.Coprime L R) : L ∣ P :=
  hcop.dvd_of_dvd_mul_right hdvd

/-- **Whole = partial · removed.** If a whole quantity factors as `whole = P * R` and `L`
divides the whole while being coprime to the removed factor `R`, then `L` divides the
partial part `P`. -/
theorem dvd_partial_of_coprime_removed {whole P R L : ℕ} (hsplit : whole = P * R)
    (hL : L ∣ whole) (hcop : Nat.Coprime L R) : L ∣ P := by
  rw [hsplit] at hL
  exact hcop.dvd_of_dvd_mul_right hL

/-- **Finite-group flavour.** For a finite group `G` whose order factors as
`Fintype.card G = P * R`, any `L` dividing `|G|` that is coprime to the removed factor `R`
divides the partial part `P`.

(Only the *order* `|G|` matters here; the group structure is incidental.  The hypothesis is
exactly the one requested: a finite group with `|G| = P·R`, a divisor `L ∣ |G|` with
`gcd(L,R) = 1`.) -/
theorem Fintype.dvd_of_card_eq_mul_of_coprime {G : Type*} [Group G] [Fintype G]
    {P R L : ℕ} (hcard : Fintype.card G = P * R) (hL : L ∣ Fintype.card G)
    (hcop : Nat.Coprime L R) : L ∣ P :=
  dvd_partial_of_coprime_removed hcard hL hcop

end CoprimeDivision
