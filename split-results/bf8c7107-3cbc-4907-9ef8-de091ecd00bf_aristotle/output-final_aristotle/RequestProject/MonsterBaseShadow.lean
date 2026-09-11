import Mathlib
import RequestProject.MonsterWalk
import RequestProject.MonsterFactorShadow
import RequestProject.CoprimeDivision

/-!
# Base-`B` factor-shadow walks: does the obstruction survive a change of base?

The decimal Factor-Shadow experiment (`RequestProject.MonsterFactorShadow`) found a clean
*negative* phenomenon: every Monster-smooth leading-digit shadow `L` shares a prime with its
own removed product `R`, so `gcd(L,R) > 1` and `L ∤ P` (the partial part).  The natural
follow-up (Direction 1 of the request): **is this obstruction an artefact of base 10, or is
it systematic across bases?**

This module sets up the general base-`B` version and answers the question.

## The base-`B` construction

Fix a base `B` and a digit count `d`.  The **base-`B` shadow** of `|𝕄|` is its leading `d`
base-`B` digits read as a base-`B` integer:

`baseShadow B d = |𝕄| / B ^ (L − d)`,  where `L` is the number of base-`B` digits of `|𝕄|`.

The removed product `Rᵢ`, partial part `Pᵢ`, and the splitting `|𝕄| = Pᵢ · Rᵢ` are intrinsic
to the prime-power removal sets and so are **base-independent** (reused verbatim from
`MonsterFactorShadow`).  Only the *shadow* depends on the base.

## The survival criterion is base-independent

* `coprime_baseShadow_survives` — for **any** base `B`, digit count `d`, and walk group `g`,
  if the base-`B` shadow divides `|𝕄|` and is coprime to the removed product `Rᵢ`, then it
  divides the partial part `Pᵢ`.  (Immediate from `CoprimeDivision`.)

## The obstruction is **not** systematic: coprime shadows can survive

In base 10 the dividing shadows happened never to be coprime to their removals.  In other
bases they can be — so genuinely coprime shadows *do* survive:

* `base2_shadow_survives` — in base 2 the leading-4-bit shadow is `8 = 2³`; for group `G₂`
  (which removes none of the prime `2`) it is coprime to the removed product and divides `P`.
* `base17_shadow_survives` — a *nontrivial* example: in base 17 the leading-2-digit shadow of
  `|𝕄|` is `169 = 13²`; for group `G₁` (which removes none of the prime `13`) it is coprime
  to the removed product and divides `P`.
* `obstruction_not_systematic` — hence there exist `(B, d, g)` with a shadow that genuinely
  survives into the partial part: the decimal "never coprime" phenomenon is base-specific.

All computational claims are `native_decide`-checked; the survival implication is the general
`CoprimeDivision` lemma.
-/

namespace MonsterBaseShadow

open MonsterWalk MonsterFactorShadow

/-- The **base-`B` shadow** of `|𝕄|`: its leading `d` base-`B` digits read as a base-`B`
integer, i.e. `|𝕄| / B ^ (L − d)` with `L` the number of base-`B` digits. -/
def baseShadow (B d : ℕ) : ℕ :=
  monsterOrder / B ^ ((Nat.digits B monsterOrder).length - d)

/-! ## The survival criterion (base-independent) -/

/-- **Base-independent survival criterion.** For any base `B`, digit count `d`, and walk
group `g`: if the base-`B` shadow divides `|𝕄|` and is coprime to the removed product `Rᵢ`,
then it divides the partial part `Pᵢ`.  This is the same coprime-division mechanism as in the
decimal case; only the value of the shadow changes with the base. -/
theorem coprime_baseShadow_survives (B d : ℕ) (g : Group) (hg : g ∈ monsterWalkGroups)
    (hdvd : baseShadow B d ∣ monsterOrder)
    (hcop : Nat.Coprime (baseShadow B d) (removedProd g)) :
    baseShadow B d ∣ partialPart g :=
  CoprimeDivision.dvd_partial_of_coprime_removed
    (monster_eq_partial_mul_removed g hg).symm hdvd hcop

/-! ## The obstruction is not systematic: coprime shadows can survive -/

/-- In base 2 the leading-4-bit shadow of `|𝕄|` is `8 = 2³`. -/
theorem base2_shadow_eq : baseShadow 2 4 = 8 := by native_decide

/-- **Base-2 survival.** The base-2 leading-4-bit shadow `8` is coprime to the removed
product of group `G₂` (which removes none of the prime `2`) and divides its partial part —
a genuinely coprime shadow that survives. -/
theorem base2_shadow_survives :
    ∃ g ∈ monsterWalkGroups,
      1 < baseShadow 2 4 ∧ baseShadow 2 4 ∣ monsterOrder ∧
      Nat.Coprime (baseShadow 2 4) (removedProd g) ∧
      baseShadow 2 4 ∣ partialPart g := by
  refine ⟨monsterWalkGroups[1], by decide, ?_, ?_, ?_, ?_⟩ <;> native_decide

/-- In base 17 the leading-2-digit shadow of `|𝕄|` is `169 = 13²`. -/
theorem base17_shadow_eq : baseShadow 17 2 = 169 := by native_decide

/-- **Base-17 survival (nontrivial).** The base-17 leading-2-digit shadow `169 = 13²` is
coprime to the removed product of group `G₁` (which removes none of the prime `13`) and
divides its partial part.  Unlike every decimal shadow, this Monster-smooth divisor genuinely
survives into the partial part. -/
theorem base17_shadow_survives :
    ∃ g ∈ monsterWalkGroups,
      1 < baseShadow 17 2 ∧ baseShadow 17 2 ∣ monsterOrder ∧
      Nat.Coprime (baseShadow 17 2) (removedProd g) ∧
      baseShadow 17 2 ∣ partialPart g := by
  refine ⟨monsterWalkGroups[0], by decide, ?_, ?_, ?_, ?_⟩ <;> native_decide

/-- **The decimal obstruction is base-specific.** There exist a base `B`, a digit count `d`,
and a walk group `g` such that the base-`B` shadow is `> 1`, divides `|𝕄|`, is *coprime* to
the removed product, and *divides the partial part* — exactly the situation that never occurs
in base 10.  So the "shadows are never coprime to their removals" phenomenon does **not**
generalize: in other bases genuinely coprime shadows survive. -/
theorem obstruction_not_systematic :
    ∃ (B d : ℕ) (g : Group), g ∈ monsterWalkGroups ∧
      1 < baseShadow B d ∧ baseShadow B d ∣ monsterOrder ∧
      Nat.Coprime (baseShadow B d) (removedProd g) ∧
      baseShadow B d ∣ partialPart g := by
  obtain ⟨g, hg, h1, h2, h3, h4⟩ := base17_shadow_survives
  exact ⟨17, 2, g, hg, h1, h2, h3, h4⟩

end MonsterBaseShadow
