/-
# GroupValuationSpectrum.lean — The Trailing-Zero / Valuation Spectrum of *Any* Finite Group

## What this file proves

The `MonsterDigitWalk` development showed, for the specific number
`N = |M|`, that the number of **trailing zero digits** of `N` in a prime base `p`
equals the `p`-adic valuation `v_p(N) = N.factorization p`, and that sweeping `p`
over the supersingular primes reads off the exponent vector of the Monster
factorization.

This file makes the conceptual point precise: **none of that is special to the
Monster.** It is a generic property of *every finite group* `G`. Writing
`|G| = Nat.card G`, the same trailing-zeros theorem applied to `|G|` gives a
universal "p-adic depth profile", and a single prime `p` carries nonzero depth
("fuel") exactly when it divides the group order — equivalently when `G` has an
element of order `p` (Cauchy) and a nontrivial Sylow `p`-subgroup.

The Monster is then literally just one instance of the general statement.

## The unified equivalence

For a finite group `G` and a prime `p`, the following are all equivalent:

1. `p ∣ |G|`                                    (the prime divides the order)
2. `0 < trailingZeros p |G|`                    (the base-`p` digit walk has a trailing zero)
3. `0 < (|G|).factorization p`                  (the `p`-adic valuation is positive)
4. `∃ x : G, orderOf x = p`                     (Cauchy: `G` has an element of order `p`)
5. `Nontrivial (P : Sylow p G)` for `P`         (the Sylow `p`-subgroup is nontrivial)

In the "fuel" reading: a base-`p` trailing zero is one unit of `p`-adic fuel, and
all five statements say the same thing — the prime-`p` register of `|G|` is
non-empty. The Monster's exponent vector `[46, 20, 9, …, 1]` is just the fuel
profile of this generic mechanism applied to `|M|`.

## File location
`RequestProject/Math/Monster/GroupValuationSpectrum.lean`
-/

import Mathlib
import RequestProject.Math.Monster.MonsterDigitWalk

namespace GroupValuationSpectrum

open MonsterDigitWalk

/-! ## §1. Trailing zeros of `|G|` are its p-adic valuation

The single general theorem `MonsterDigitWalk.trailingZeros_eq_factorization`
(proved by strong induction, no `native_decide`) specializes immediately to the
order of any finite group. -/

variable (G : Type*) [Group G] [Finite G]

/-- **The valuation spectrum of a finite group.** For any prime `p`, the number
    of trailing zero digits of `|G|` in base `p` equals the `p`-adic valuation
    `v_p(|G|)`. This is the generic form of `monster_trailingZeros_eq_factorization`:
    it holds for every finite group, the Monster being one instance. -/
theorem groupTrailingZeros_eq_valuation (p : ℕ) (hp : p.Prime) :
    trailingZeros p (Nat.card G) = (Nat.card G).factorization p :=
  trailingZeros_eq_factorization p (Nat.card G) hp Nat.card_pos

/-! ## §2. "Fuel" ⇔ divisibility ⇔ positive valuation -/

/-- Positive `p`-adic valuation of `|G|` is the same as `p` dividing `|G|`.
    (For a prime `p`, `v_p(n) ≥ 1` exactly when `p ∣ n`, and `0 < |G|`.) -/
theorem factorization_pos_iff_dvd (p : ℕ) (hp : p.Prime) :
    0 < (Nat.card G).factorization p ↔ p ∣ Nat.card G :=
  (hp.dvd_iff_one_le_factorization Nat.card_pos.ne').symm

/-- A prime carries nonzero `p`-adic fuel for `|G|` (a trailing zero in base `p`)
    iff it divides the group order. Trailing zeros equal the valuation
    (`groupTrailingZeros_eq_valuation`), and a positive valuation means
    divisibility (`factorization_pos_iff_dvd`). -/
theorem trailingZeros_pos_iff_dvd (p : ℕ) (hp : p.Prime) :
    0 < trailingZeros p (Nat.card G) ↔ p ∣ Nat.card G := by
  rw [groupTrailingZeros_eq_valuation G p hp]
  exact factorization_pos_iff_dvd G p hp

/-! ## §3. The Cauchy / Sylow bridge

Divisibility of `|G|` by `p` is, by Cauchy's theorem, the existence of an element
of order `p`; and the Sylow `p`-subgroup is nontrivial exactly in that case. -/

/-- **Cauchy in spectrum form.** `p` divides `|G|` iff `G` has an element of order
    `p`. -/
theorem dvd_card_iff_exists_orderOf (p : ℕ) [Fact p.Prime] :
    p ∣ Nat.card G ↔ ∃ x : G, orderOf x = p := by
  constructor;
  · haveI := Fintype.ofFinite G;
    convert exists_prime_orderOf_dvd_card p using 1;
    rw [ Nat.card_eq_fintype_card ];
  · rintro ⟨ x, rfl ⟩ ; exact orderOf_dvd_natCard x

/-- The Sylow `p`-subgroup of `G` has order `p ^ v_p(|G|)`, so it is nontrivial
    iff `p` divides `|G|`. -/
theorem sylow_nontrivial_iff_dvd (p : ℕ) [Fact p.Prime] (P : Sylow p G) :
    Nontrivial (P : Set G) ↔ p ∣ Nat.card G := by
  have hp : p.Prime := Fact.out
  -- The Sylow `p`-subgroup has order `p ^ v_p(|G|)`, ...
  have hcard : Nat.card (P : Set G) = p ^ (Nat.card G).factorization p :=
    P.card_eq_multiplicity
  -- ... so it is nontrivial iff that exponent (the valuation) is positive,
  -- which is exactly `p ∣ |G|`.
  rw [← Finite.one_lt_card_iff_nontrivial, hcard, ← factorization_pos_iff_dvd G p hp]
  constructor
  · intro h
    by_contra hk
    push_neg at hk
    interval_cases ((Nat.card G).factorization p)
    simp at h
  · intro h
    exact Nat.one_lt_pow h.ne' hp.one_lt

/-! ## §4. The unified five-way equivalence -/

/-- **The generic finite-group fuel equivalence.** For a finite group `G` and a
    prime `p`, having a base-`p` trailing zero, positive `p`-adic valuation,
    divisibility of `|G|`, an element of order `p`, and a nontrivial Sylow
    `p`-subgroup are all equivalent. -/
theorem group_fuel_equivalence (p : ℕ) (hp : p.Prime) [Fact p.Prime] (P : Sylow p G) :
    (0 < trailingZeros p (Nat.card G) ↔ p ∣ Nat.card G) ∧
    (0 < (Nat.card G).factorization p ↔ p ∣ Nat.card G) ∧
    (p ∣ Nat.card G ↔ ∃ x : G, orderOf x = p) ∧
    (Nontrivial (P : Set G) ↔ p ∣ Nat.card G) :=
  ⟨trailingZeros_pos_iff_dvd G p hp, factorization_pos_iff_dvd G p hp,
   dvd_card_iff_exists_orderOf G p, sylow_nontrivial_iff_dvd G p P⟩

/-! ## §5. The Monster as one instance

The Monster-specific facts in `MonsterDigitWalk` are exactly the specialization
of `groupTrailingZeros_eq_valuation` to a group of order `|M| = MONSTER_ORDER`.
We record the numeric shadow of that specialization here: for any prime `p`, the
trailing-zero count of `MONSTER_ORDER` is its valuation — the same statement as
the generic theorem, now read on the literal Monster order. -/

/-- The generic spectrum theorem, read on the Monster order: the trailing zeros
    of `|M|` in any prime base equal its `p`-adic valuation. (Identical content to
    `monster_trailingZeros_eq_factorization`, exhibited as the group instance.) -/
theorem monster_is_an_instance (p : ℕ) (hp : p.Prime) :
    trailingZeros p MonsterHairs.MONSTER_ORDER
      = MonsterHairs.MONSTER_ORDER.factorization p :=
  monster_trailingZeros_eq_factorization p hp

end GroupValuationSpectrum