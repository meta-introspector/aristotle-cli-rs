import Mathlib
import RequestProject.MonsterWalk
import RequestProject.MonsterWalkFactors

/-!
# Factor-Shadow experiment: does the leading-digit shadow divide the *partial part*?

For each Monster-Walk group `Gᵢ` (see `RequestProject.MonsterWalk`) there are three
naturally associated integers:

* the **removed-factor product** `Rᵢ = removedProduct g.removed`;
* the **partial part** `Pᵢ = |𝕄| / Rᵢ` — the value of the Monster order *after* removing
  that group's factors (so `|𝕄| = Pᵢ · Rᵢ`);
* the **leading-digit shadow** `Lᵢ = g.sequence.toNat!` — the preserved leading digits at
  that walk step read as an integer.

An earlier module (`RequestProject.MonsterWalkFactors`) established the weaker fact:

> `Lᵢ ∣ |𝕄|` **iff** `Lᵢ` is Monster-smooth — true for exactly four groups
> (`G₄, G₅, G₈, G₉`, shadows `451, 2875, 496, 1710`).

Here we test the **stronger** condition: *does the shadow divide the partial part,*
`Lᵢ ∣ Pᵢ`?  One might guess this holds for the four smooth groups (where `Lᵢ ∣ |𝕄|`).

**It does not.**  The headline result is entirely negative:

* `shadow_never_divides_partial`: for **every** one of the ten walk groups, `Lᵢ ∤ Pᵢ` —
  including the four whose shadow divides the whole Monster.

The reason is structural and is made precise here:

* `monster_eq_partial_mul_removed`: `|𝕄| = Pᵢ · Rᵢ` for every group.
* `coprime_removed_dvd_partial` (a genuine, non-`decide` lemma): *if* a shadow divides
  `|𝕄|` **and** is coprime to the removed product `Rᵢ`, then it divides `Pᵢ`.  So
  coprimality to the removals is *sufficient* for the shadow to survive into the partial
  part.
* `smooth_shadow_not_coprime_removed`: but **every** shadow that divides `|𝕄|` *shares a
  prime factor* with its own removed product (`¬ Coprime Lᵢ Rᵢ`, equivalently
  `gcd(Lᵢ, Rᵢ) > 1`).  The smooth shadow is built partly from primes the walk *removed*,
  so it cannot survive the removal.
* `smooth_shadow_gcd_split`: for each dividing shadow, `Lᵢ = gcd(Lᵢ, Rᵢ) · gcd(Lᵢ, Pᵢ)`
  with the first factor `> 1` — an explicit split of the shadow into a "removed" part and
  a "surviving" part.

All computational claims are checked by the kernel-backed `native_decide`; the one
general implication is proved from `Nat.Coprime.dvd_of_dvd_mul_right`.
-/

namespace MonsterFactorShadow

open MonsterWalk MonsterWalkFactors

/-- The leading-digit shadow of a group: its preserved leading digits read as an integer. -/
def shadow (g : Group) : Nat := g.sequence.toNat!

/-- The removed-factor product `Rᵢ` of a group. -/
def removedProd (g : Group) : Nat := removedProduct g.removed

/-- The partial part `Pᵢ = |𝕄| / Rᵢ` of a group. -/
def partialPart (g : Group) : Nat := monsterOrder / removedProduct g.removed

/-! ## `|𝕄| = Pᵢ · Rᵢ` -/

/-- For every walk group the removed-factor product divides the Monster order. -/
theorem removedProd_dvd (g : Group) (hg : g ∈ monsterWalkGroups) :
    removedProd g ∣ monsterOrder :=
  Nat.dvd_of_mod_eq_zero (MonsterWalk.removals_divide g hg)

/-- **The Monster factors as partial part times removed product:** `|𝕄| = Pᵢ · Rᵢ`. -/
theorem monster_eq_partial_mul_removed (g : Group) (hg : g ∈ monsterWalkGroups) :
    partialPart g * removedProd g = monsterOrder :=
  Nat.div_mul_cancel (removedProd_dvd g hg)

/-! ## The headline: the shadow never divides the partial part -/

/-- **Factor-Shadow result.**  For **every** one of the ten Monster-Walk groups, the
leading-digit shadow does **not** divide the partial part `Pᵢ = |𝕄| / Rᵢ` — even for the
four groups whose shadow divides the whole Monster order. -/
theorem shadow_never_divides_partial :
    ∀ g ∈ monsterWalkGroups, ¬ (shadow g ∣ partialPart g) := by
  native_decide

/-! ## The structural explanation -/

/-- **Sufficient condition (general lemma).**  If a group's shadow divides the Monster
order *and* is coprime to its removed-factor product, then the shadow divides the partial
part.  Hence the only way a shadow can fail to divide `Pᵢ` (given it divides `|𝕄|`) is by
*sharing a prime* with the removed factors. -/
theorem coprime_removed_dvd_partial (g : Group) (hg : g ∈ monsterWalkGroups)
    (hL : shadow g ∣ monsterOrder)
    (hcop : Nat.Coprime (shadow g) (removedProd g)) :
    shadow g ∣ partialPart g := by
  have hPR : partialPart g * removedProd g = monsterOrder :=
    monster_eq_partial_mul_removed g hg
  rw [← hPR] at hL
  exact hcop.dvd_of_dvd_mul_right hL

/-- **The obstruction.**  Every shadow that divides `|𝕄|` *shares a prime factor* with its
own removed-factor product: it is **not** coprime to `Rᵢ`.  (Equivalently
`gcd(Lᵢ, Rᵢ) > 1`.)  This is exactly why such a shadow fails to divide the partial part:
part of the shadow is built from primes the walk removed. -/
theorem smooth_shadow_not_coprime_removed :
    ∀ g ∈ monsterWalkGroups, shadow g ∣ monsterOrder →
      ¬ Nat.Coprime (shadow g) (removedProd g) := by
  native_decide

/-- The same obstruction phrased via `gcd`: every dividing shadow has `gcd(Lᵢ, Rᵢ) > 1`. -/
theorem smooth_shadow_gcd_removed_gt_one :
    ∀ g ∈ monsterWalkGroups, shadow g ∣ monsterOrder →
      1 < Nat.gcd (shadow g) (removedProd g) := by
  native_decide

/-- **Explicit split.**  For each group whose shadow divides `|𝕄|`, the shadow factors as
`Lᵢ = gcd(Lᵢ, Rᵢ) · gcd(Lᵢ, Pᵢ)`: a "removed" part (the gcd with `Rᵢ`, which is `> 1`) and
a "surviving" part (the gcd with `Pᵢ`).  The nontrivial removed part is precisely the
obstruction to `Lᵢ ∣ Pᵢ`. -/
theorem smooth_shadow_gcd_split :
    ∀ g ∈ monsterWalkGroups, shadow g ∣ monsterOrder →
      shadow g = Nat.gcd (shadow g) (removedProd g) * Nat.gcd (shadow g) (partialPart g) := by
  native_decide

/-! ## Summary -/

/-- **Summary of the Factor-Shadow experiment.**
1. `|𝕄| = Pᵢ · Rᵢ` for every walk group;
2. the leading-digit shadow **never** divides the partial part `Pᵢ` (all ten groups);
3. coprimality of the shadow to the removed product *would* suffice for it to divide `Pᵢ`;
4. but every shadow dividing `|𝕄|` shares a prime with its removed product, so this never
   happens. -/
theorem factor_shadow_summary :
    (∀ g ∈ monsterWalkGroups, partialPart g * removedProd g = monsterOrder) ∧
    (∀ g ∈ monsterWalkGroups, ¬ (shadow g ∣ partialPart g)) ∧
    (∀ g ∈ monsterWalkGroups, shadow g ∣ monsterOrder →
      ¬ Nat.Coprime (shadow g) (removedProd g)) :=
  ⟨monster_eq_partial_mul_removed, shadow_never_divides_partial,
    smooth_shadow_not_coprime_removed⟩

end MonsterFactorShadow
