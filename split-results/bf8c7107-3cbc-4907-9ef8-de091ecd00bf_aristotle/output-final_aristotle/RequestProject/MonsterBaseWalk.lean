import Mathlib
import RequestProject.MonsterWalk
import RequestProject.MonsterFactorShadow
import RequestProject.MonsterBaseShadow

/-!
# The full base-`B` Monster Walk and the mutation of the factor-shadow story

`RequestProject.MonsterBaseShadow` answered a *static* question: for a fixed digit count it
exhibited single base-`B` shadows that survive into the partial part.  This module carries
out the requested next step — **turning the base-`B` framework into a full base-`B` walk** —
and studies how the factor-shadow story mutates from base to base.

## The walk algorithm

Removals are always subsets of the **fifteen whole prime-power blocks** of `|𝕄|`
(`MonsterWalk.monsterPrimes`); you remove `p^e` entirely or not at all.  This all-or-nothing
granularity is what makes preserving leading digits nontrivial (you can never divide by an
exact power of the base).

Fix a base `B`.  Reading `|𝕄|` big-endianly in base `B`, the walk is the deterministic greedy
process:

* at the current position `p`, over all *nonempty* removal subsets `S` compute the length of
  the matching prefix between the base-`B` digits of `|𝕄| / ∏S` and the base-`B` digits of
  `|𝕄|` starting at `p`;
* take the subset giving the **longest** match (capped at `cap = 10`, matching the original
  note's `num_digits ∈ 1..10`; ties broken by the smallest bitmask), record the step
  `(p, d, S)`, and advance `p` by `d`;
* stop when no nonempty removal preserves even one leading digit (the base-`B` analogue of
  hitting a leading zero).

This is `monsterWalkBase B cap`.  `walk_*_steps_valid` certify (by `native_decide`) that every
recorded step genuinely preserves its `d` leading base-`B` digits.

## How the factor-shadow story mutates

For each step let `R = ∏S` be the removed product, `P = |𝕄| / R` the partial part, and `L` the
**base-`B` shadow** (the `d` preserved leading base-`B` digits of `|𝕄| / R` read as an integer).
The decimal experiment found `L ∤ P` for *every* step, with every dividing shadow sharing a
prime with `R`.  The full walk shows this is **base 10 specific**:

* `base10_walk_no_shadow_survives` — in base 10 **no** walk step has its shadow divide the
  partial part (`L ∤ P` throughout), and
  `base10_walk_dividing_shadows_share_prime` — every dividing shadow has `gcd(L,R) > 1`: the
  decimal obstruction persists for the full greedy walk, not just the published table.
* `base2_walk_shadow_survives` / `base16_walk_shadow_survives` — in base 2 and base 16 the
  full walk **does** contain a step whose shadow is `> 1`, divides `|𝕄|`, is *coprime* to its
  removed product, and *divides the partial part*.  So under a change of base the factor-shadow
  obstruction genuinely dissolves: coprime shadows survive the walk.

All computational claims are kernel-checked by `native_decide`.
-/

namespace MonsterBaseWalk

open MonsterWalk

/-- Big-endian base-`B` digits of `n` (most significant first). -/
def beDigits (B n : ℕ) : List ℕ := (Nat.digits B n).reverse

/-- Decode a bitmask `m` into the list of removed prime-power indices (bits set in `m`). -/
def maskIdx (m : ℕ) : List ℕ := (List.range 15).filter (fun i => m.testBit i)

/-- Product of the prime-power blocks selected by the bitmask `m`. -/
def prodMask (m : ℕ) : ℕ := removedProduct (maskIdx m)

/-- Length of the longest common prefix of two digit lists. -/
def lcp (xs ys : List ℕ) : ℕ :=
  (List.zip xs ys |>.takeWhile (fun p => p.1 == p.2)).length

/-- Matching length at position `p` for removal bitmask `m`: how many leading base-`B`
digits of `|𝕄| / ∏m` agree with the base-`B` digits of `|𝕄|` starting at position `p`. -/
def matchLen (B p m : ℕ) : ℕ :=
  lcp (beDigits B (monsterOrder / prodMask m)) ((beDigits B monsterOrder).drop p)

/-- Greedy choice at position `p`: the `(d, m)` with the longest match (capped at `cap`),
ties broken by the smallest bitmask `m`. Ranges over nonempty masks `1 ≤ m < 2¹⁵`. -/
def bestAt (B cap p : ℕ) : ℕ × ℕ :=
  (List.range' 1 (2 ^ 15 - 1)).foldl
    (fun acc m => let ml := min (matchLen B p m) cap; if ml > acc.1 then (ml, m) else acc)
    (0, 0)

/-- Structurally-recursive walk driver (recursion on `fuel`). -/
def walkAux (B cap total : ℕ) : ℕ → ℕ → List (ℕ × ℕ × ℕ) → List (ℕ × ℕ × ℕ)
  | 0, _, acc => acc.reverse
  | Nat.succ fuel, p, acc =>
      if total ≤ p then acc.reverse
      else
        let dm := bestAt B cap p
        if dm.1 = 0 then acc.reverse
        else walkAux B cap total fuel (p + dm.1) ((p, dm.1, dm.2) :: acc)

/-- The full base-`B` Monster Walk: a list of steps `(position, digits, removal-bitmask)`. -/
def monsterWalkBase (B cap : ℕ) : List (ℕ × ℕ × ℕ) :=
  walkAux B cap (beDigits B monsterOrder).length 100 0 []

/-- The base-`B` shadow of a step `(p, d, m)`: the `d` leading base-`B` digits of
`|𝕄| / ∏m` read back as an integer. -/
def shadowVal (B d m : ℕ) : ℕ :=
  let q := monsterOrder / prodMask m
  q / B ^ ((beDigits B q).length - d)

/-! ## The recorded walks -/

/-- The greedy base-10 walk covers 46 of the 54 decimal digits in 12 steps. -/
theorem base10_walk_eq :
    monsterWalkBase 10 10 =
      [(0, 4, 11992), (4, 4, 1062), (8, 3, 1300), (11, 4, 28255), (15, 4, 1414),
       (19, 4, 23459), (23, 4, 7515), (27, 4, 2957), (31, 4, 962), (35, 4, 1425),
       (39, 3, 143), (42, 4, 8593)] := by native_decide

/-- The greedy base-2 walk: three 10-bit steps before stalling on a leading-`0` bit. -/
theorem base2_walk_eq :
    monsterWalkBase 2 10 = [(0, 10, 1), (10, 10, 752), (20, 10, 744)] := by native_decide

/-- The greedy base-16 walk covers 37 of the 45 hexadecimal digits in 10 steps. -/
theorem base16_walk_eq :
    monsterWalkBase 16 10 =
      [(0, 3, 3214), (3, 4, 29932), (7, 4, 1089), (11, 3, 174), (14, 4, 17279),
       (18, 4, 783), (22, 3, 294), (25, 4, 27004), (29, 3, 826), (32, 5, 5944)] := by
  native_decide

/-! ## Validity: every recorded step preserves its leading base-`B` digits -/

/-- A step `(p, d, m)` is *valid* in base `B` if the `d` leading base-`B` digits of
`|𝕄| / ∏m` equal the base-`B` digits of `|𝕄|` at positions `[p, p+d)`. -/
def stepValid (B : ℕ) (s : ℕ × ℕ × ℕ) : Bool :=
  let p := s.1; let d := s.2.1; let m := s.2.2
  ((beDigits B (monsterOrder / prodMask m)).take d) ==
    (((beDigits B monsterOrder).drop p).take d)

theorem base10_walk_steps_valid : (monsterWalkBase 10 10).all (stepValid 10) = true := by
  native_decide

theorem base2_walk_steps_valid : (monsterWalkBase 2 10).all (stepValid 2) = true := by
  native_decide

theorem base16_walk_steps_valid : (monsterWalkBase 16 10).all (stepValid 16) = true := by
  native_decide

/-! ## Coverage -/

/-- Total number of base-`B` digits covered by a walk. -/
def coverage (w : List (ℕ × ℕ × ℕ)) : ℕ := (w.map (fun s => s.2.1)).sum

theorem base10_walk_coverage : coverage (monsterWalkBase 10 10) = 46 := by native_decide
theorem base2_walk_coverage  : coverage (monsterWalkBase 2 10)  = 30 := by native_decide
theorem base16_walk_coverage : coverage (monsterWalkBase 16 10) = 37 := by native_decide

/-! ## The factor-shadow story and its base-dependence -/

/-- A step's shadow `> 1` divides the partial part `P = |𝕄| / R`. -/
def shadowDividesPartial (B : ℕ) (s : ℕ × ℕ × ℕ) : Bool :=
  let d := s.2.1; let m := s.2.2
  let R := prodMask m
  let L := shadowVal B d m
  decide (1 < L) && decide (L ∣ monsterOrder / R)

/-- A step's shadow genuinely *survives*: it is `> 1`, divides `|𝕄|`, is coprime to its
removed product `R`, and divides the partial part `P`. -/
def shadowSurvivesCoprime (B : ℕ) (s : ℕ × ℕ × ℕ) : Bool :=
  let d := s.2.1; let m := s.2.2
  let R := prodMask m
  let L := shadowVal B d m
  decide (1 < L) && decide (L ∣ monsterOrder) && (Nat.gcd L R == 1) &&
    decide (L ∣ monsterOrder / R)

/-- **Base 10: the obstruction persists for the full greedy walk.** No step of the base-10
walk has its shadow divide the partial part — exactly the decimal phenomenon of
`MonsterFactorShadow`, now confirmed for the entire greedy walk rather than the published
table. -/
theorem base10_walk_no_shadow_survives :
    (monsterWalkBase 10 10).all (fun s => ! shadowDividesPartial 10 s) = true := by
  native_decide

/-- **The mechanism in base 10.** Every base-10 walk shadow that divides `|𝕄|` shares a prime
with its own removed product (`gcd(L,R) > 1`); this is precisely why it cannot divide the
partial part. -/
theorem base10_walk_dividing_shadows_share_prime :
    (monsterWalkBase 10 10).all (fun s =>
      let d := s.2.1; let m := s.2.2; let R := prodMask m; let L := shadowVal 10 d m
      (! decide (L ∣ monsterOrder)) || decide (1 < Nat.gcd L R)) = true := by
  native_decide

/-- **Base 2: the obstruction dissolves.** The full base-2 walk contains a step whose shadow
is `> 1`, divides `|𝕄|`, is coprime to its removed product, and divides the partial part — a
genuinely surviving coprime shadow, impossible in base 10. -/
theorem base2_walk_shadow_survives :
    (monsterWalkBase 2 10).any (shadowSurvivesCoprime 2) = true := by native_decide

/-- **Base 16: the obstruction dissolves.** Likewise the full base-16 walk contains a
genuinely surviving coprime shadow. -/
theorem base16_walk_shadow_survives :
    (monsterWalkBase 16 10).any (shadowSurvivesCoprime 16) = true := by native_decide

/-! ## Summary -/

/-- **The factor-shadow story is base-dependent.**
1. Every step of every recorded walk genuinely preserves its leading base-`B` digits.
2. In base 10 no walk shadow survives into the partial part (and each dividing shadow shares a
   prime with its removed product).
3. In bases 2 and 16 the full walk *does* contain a coprime shadow that survives into the
   partial part. -/
theorem base_walk_factor_shadow_summary :
    (monsterWalkBase 10 10).all (stepValid 10) = true ∧
    (monsterWalkBase 2 10).all (stepValid 2) = true ∧
    (monsterWalkBase 16 10).all (stepValid 16) = true ∧
    (monsterWalkBase 10 10).all (fun s => ! shadowDividesPartial 10 s) = true ∧
    (monsterWalkBase 2 10).any (shadowSurvivesCoprime 2) = true ∧
    (monsterWalkBase 16 10).any (shadowSurvivesCoprime 16) = true :=
  ⟨base10_walk_steps_valid, base2_walk_steps_valid, base16_walk_steps_valid,
   base10_walk_no_shadow_survives, base2_walk_shadow_survives, base16_walk_shadow_survives⟩

end MonsterBaseWalk
