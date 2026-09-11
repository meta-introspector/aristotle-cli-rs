import Mathlib
import RequestProject.MonsterWalk
import RequestProject.MonsterWalkFactors
import RequestProject.MonsterFactorShadow
import RequestProject.CoprimeDivision
import RequestProject.MonsterSmoothClosure
import RequestProject.MonsterBaseShadow

/-!
# The canonical Monster-Walk toolkit

This module collects the *core* Monster-Walk API in one place and re-exports it under the
`MonsterWalkCore` namespace, so the Factor-Shadow results sit alongside the original walk
data as a single canonical toolkit.

## Conjecture status (canonical record)

The original Factor-Shadow conjecture — *"the leading-digit shadow `Lᵢ` divides the partial
part `Pᵢ` for the smooth groups"* — is **refuted**.  In fact

> `Lᵢ ∤ Pᵢ` for **all ten** Monster-Walk groups,

including the four whose shadow divides the whole Monster order
(`MonsterFactorShadow.shadow_never_divides_partial`).

## The structural mechanism (conceptual note)

Shadows that divide `|𝕄|` are exactly the Monster-smooth shadows, and **they are never
coprime to their own removed product**: `gcd(Lᵢ, Rᵢ) > 1`
(`MonsterFactorShadow.smooth_shadow_gcd_removed_gt_one`).  A smooth shadow encodes, among its
prime factors, primes that the walk *itself removed*; those primes are precisely what is
divided away when passing from `|𝕄| = Pᵢ · Rᵢ` to the partial part `Pᵢ`.  Hence a smooth
shadow cannot fully survive into `Pᵢ`.  Coprimality to the removed product is the *only*
thing that would let a divisor survive (`MonsterFactorShadow.coprime_removed_dvd_partial`,
generalized in `CoprimeDivision`), and in base 10 it never holds.

This is base-specific: in other bases genuinely coprime shadows do survive
(`MonsterBaseShadow.obstruction_not_systematic`).

## Design constraint (Direction 5)

> **Factor-shadow walks tend to entangle "removed" and "surviving" primes.**  Any
> architecture that wants a clean separation — CRT slots, Clifford blades, moonshine grading
> pieces — must enforce *coprimality between the removed product and the surviving shadow at
> design time*; it does not arise for free from a digit-driven walk.

See `FactorShadowNotes.md` for the extended CRT / Clifford / moonshine discussion.

## Re-exported names

* core walk data: `monsterOrder`, `monsterWalkGroups`, `removedProduct`, `removals_divide`;
* factor-shadow integers: `shadow`, `removedProd`, `partialPart`;
* factor-shadow lemmas: `monster_eq_partial_mul_removed`, `shadow_never_divides_partial`,
  `coprime_removed_dvd_partial`, `smooth_shadow_not_coprime_removed`,
  `smooth_shadow_gcd_removed_gt_one`, `smooth_shadow_gcd_split`;
* generalizations: `dvd_partial_of_coprime_removed`, `coprime_baseShadow_survives`,
  smoothness closure lemmas (`SmoothOver.mul`, `SmoothOver.lcm`, `SmoothOver.of_dvd`, …).
-/

namespace MonsterWalkCore

-- Core Monster-Walk data and the basic divisibility fact.
export MonsterWalk (monsterOrder monsterWalkGroups removedProduct removals_divide Group)

-- The Monster-smoothness predicate and the divisibility characterization.
export MonsterWalkFactors (MonsterSmooth monsterPrimeFs factor_iff_monsterSmooth)

-- The factor-shadow integers and the canonical Factor-Shadow lemmas.
export MonsterFactorShadow
  (shadow removedProd partialPart
   monster_eq_partial_mul_removed shadow_never_divides_partial
   coprime_removed_dvd_partial smooth_shadow_not_coprime_removed
   smooth_shadow_gcd_removed_gt_one smooth_shadow_gcd_split factor_shadow_summary)

-- The general coprime-division lemma (Direction 2).
export CoprimeDivision (dvd_partial_of_coprime_removed Fintype.dvd_of_card_eq_mul_of_coprime)

-- Monster-smoothness closure (Direction 4).
export MonsterSmoothClosure
  (SmoothOver monsterSmooth_iff_smoothOver shadow_gcd_split_components_smooth)

-- Base-`B` factor-shadow walks (Direction 3).
export MonsterBaseShadow (baseShadow coprime_baseShadow_survives obstruction_not_systematic)

/-- **The canonical toolkit, bundled.**  The headline facts of the Factor-Shadow story,
promoted to the core API:

1. `|𝕄| = Pᵢ · Rᵢ` for every walk group;
2. the leading-digit shadow never divides the partial part (all ten groups);
3. every dividing shadow shares a prime with its removed product (the obstruction);
4. but coprimality to the removed product *would* suffice — and in other bases it does occur,
   so the obstruction is base-specific. -/
theorem monsterWalk_toolkit :
    (∀ g ∈ MonsterWalk.monsterWalkGroups,
        MonsterFactorShadow.partialPart g * MonsterFactorShadow.removedProd g
          = MonsterWalk.monsterOrder) ∧
    (∀ g ∈ MonsterWalk.monsterWalkGroups,
        ¬ (MonsterFactorShadow.shadow g ∣ MonsterFactorShadow.partialPart g)) ∧
    (∀ g ∈ MonsterWalk.monsterWalkGroups, MonsterFactorShadow.shadow g ∣ MonsterWalk.monsterOrder →
        ¬ Nat.Coprime (MonsterFactorShadow.shadow g) (MonsterFactorShadow.removedProd g)) ∧
    (∃ (B d : ℕ) (g : MonsterWalk.Group), g ∈ MonsterWalk.monsterWalkGroups ∧
        1 < MonsterBaseShadow.baseShadow B d ∧
        MonsterBaseShadow.baseShadow B d ∣ MonsterWalk.monsterOrder ∧
        Nat.Coprime (MonsterBaseShadow.baseShadow B d) (MonsterFactorShadow.removedProd g) ∧
        MonsterBaseShadow.baseShadow B d ∣ MonsterFactorShadow.partialPart g) :=
  ⟨MonsterFactorShadow.monster_eq_partial_mul_removed,
   MonsterFactorShadow.shadow_never_divides_partial,
   MonsterFactorShadow.smooth_shadow_not_coprime_removed,
   MonsterBaseShadow.obstruction_not_systematic⟩

end MonsterWalkCore
