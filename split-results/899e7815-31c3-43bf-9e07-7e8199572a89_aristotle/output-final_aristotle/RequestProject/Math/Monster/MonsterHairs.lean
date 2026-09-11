/-
# MonsterHairs.lean — The Full Spectral Projection of the Monster Order

## The Construction

Everything so far probed the small walk step `8080`. Here we apply the same
machinery to the **Monster group order itself**:

  N = |M| = 808017424794512875886459904961710757005754368000000000
          = 2⁴⁶ · 3²⁰ · 5⁹ · 7⁶ · 11² · 13³ · 17 · 19 · 23 · 29 · 31 · 41 · 47 · 59 · 71

For every base `b ∈ [2, 71]` we expand `N` in base `b` and collect **all of
its digits**. The full multiset of digits across all bases is the
**Monster hair spectrum** — each digit is a microscopic "hair"/quasi-fiber
of the global group order.

## Key facts (all computed and verified)

```
  Decimal length of N:                 54 digits
  Total number of hairs (all bases):   2948
  Sum of all hairs:                    37484
  Number of zero-hairs:                639

  Bases b ∈ [2,71] that divide N:      65
  Bases that do NOT divide N:          {37, 43, 53, 61, 67}
        ↳ these are exactly the NON-supersingular primes ≤ 71
  All 15 supersingular primes divide N.

  N mod 71 = 0,  N mod 72 = 0.
```

The cleanest theorem (Ogg's observation in residue form):
**a prime `p ≤ 71` divides `|M|` iff `p` is supersingular.**

## File location
`RequestProject/Math/Monster/MonsterHairs.lean`
-/

import Mathlib
import RequestProject.MonsterConstants
import RequestProject.Math.Monster.MonsterWalkZKP
import RequestProject.Math.Monster.HexWalk
import RequestProject.Math.Monster.Atropos
import RequestProject.Math.Monster.Residue72

set_option maxHeartbeats 1600000

namespace MonsterHairs

open MonsterConstants MonsterWalkZKP Residue72

/-! ## §1. The Monster Order and its Factorization -/

/-- The order of the Monster sporadic simple group. -/
def MONSTER_ORDER : ℕ := 808017424794512875886459904961710757005754368000000000

/-- The prime factorization of the Monster order over the 15 supersingular primes. -/
theorem monster_factorization :
    MONSTER_ORDER =
      2^46 * 3^20 * 5^9 * 7^6 * 11^2 * 13^3 * 17 * 19 * 23 * 29 * 31 * 41 * 47 * 59 * 71 := by
  native_decide

/-- The Monster order has 54 decimal digits. -/
theorem monster_decimal_length : (Nat.digits 10 MONSTER_ORDER).length = 54 := by native_decide

/-- All 15 supersingular primes divide the Monster order. -/
theorem ssp_primes_divide_monster :
    SSP_list.all (fun p => MONSTER_ORDER % p == 0) = true := by native_decide

/-! ## §2. The Hair Spectrum -/

/-- The list of bases `[2, 3, …, 71]`. -/
def bases : List ℕ := (List.range 70).map (· + 2)

/-- The base-`b` digit expansion of `N` (little-endian) is one "thread" of hairs. -/
def hairsInBase (b : ℕ) : List ℕ := Nat.digits b MONSTER_ORDER

/-- The full Monster hair spectrum: every digit of `N` across every base 2..71. -/
def monsterHairs : List ℕ := (bases.map hairsInBase).flatten

/-- The total number of hairs across all bases. -/
theorem total_hairs : monsterHairs.length = 2948 := by native_decide

/-- The sum of all hairs. -/
theorem hair_sum : monsterHairs.sum = 37484 := by native_decide

/-- The number of zero-hairs (Atropos cuts) across all bases. -/
theorem zero_hairs : (monsterHairs.filter (· == 0)).length = 639 := by native_decide

/-- Every hair is a valid digit: at most the largest base minus one (< 71). -/
theorem hairs_bounded : monsterHairs.all (fun d => d < 71) = true := by native_decide

/-! ## §3. Quasi-fibers of the Hair Spectrum -/

/-- The quasi-fiber of a residue value `r`: all hairs equal to `r`. -/
def quasiFiber (r : ℕ) : List ℕ := monsterHairs.filter (· == r)

/-- The zero quasi-fiber has 639 elements (the most common hair). -/
theorem quasiFiber_zero_card : (quasiFiber 0).length = 639 := by native_decide

/-- The quasi-fiber of 1 has 224 elements. -/
theorem quasiFiber_one_card : (quasiFiber 1).length = 224 := by native_decide

/-- Zero is the dominant hair: its quasi-fiber is the largest. -/
theorem zero_is_dominant_hair :
    ∀ r : ℕ, r < 71 → (quasiFiber r).length ≤ (quasiFiber 0).length := by
  intro r hr
  interval_cases r <;> native_decide

/-! ## §4. The Divisor Structure of the Bases — Ogg's Observation -/

/-- Exactly 65 of the 70 bases in [2,71] divide the Monster order. -/
theorem dividing_bases_count :
    (bases.filter (fun b => MONSTER_ORDER % b == 0)).length = 65 := by native_decide

/-- The 5 bases that do NOT divide the Monster order are {37, 43, 53, 61, 67}. -/
theorem nondividing_bases :
    bases.filter (fun b => MONSTER_ORDER % b != 0) = [37, 43, 53, 61, 67] := by native_decide

/-- Those 5 non-dividing bases are exactly the non-supersingular primes ≤ 71:
    each is prime and none lies in `SSP_list`. -/
theorem nondividers_are_non_ssp :
    ∀ p ∈ [37, 43, 53, 61, 67], Nat.Prime p ∧ p ∉ SSP_list := by
  intro p hp
  fin_cases hp <;> exact ⟨by norm_num, by decide⟩

/-- **Ogg's observation, residue form.** A prime `p ≤ 71` divides `|M|`
    if and only if `p` is one of the 15 supersingular primes. -/
theorem prime_divides_monster_iff_ssp (p : ℕ) (hp : p.Prime) (hb : p ≤ 71) :
    p ∣ MONSTER_ORDER ↔ p ∈ SSP_list := by
  have hp2 : 2 ≤ p := hp.two_le
  interval_cases p <;> revert hp <;> native_decide

/-! ## §5. The Monster Shard — N over the Trivector Prime -/

/-- The Monster order is divisible by 71 (its shard is 0). -/
theorem monster_shard_71 : MONSTER_ORDER % 71 = 0 := by native_decide

/-- The Monster order is divisible by 72 (= 8 × 9). -/
theorem monster_shard_72 : MONSTER_ORDER % 72 = 0 := by native_decide

/-- The Monster order projects to 0 in every supersingular `Z/pZ`. -/
theorem monster_all_ssp_residues_zero :
    SSP_list.map (fun p => MONSTER_ORDER % p) = List.replicate 15 0 := by native_decide

/-! ## §7. The Hex Walk of the Full Monster Order

The original development walked `8080 = 0x1F90` through its four hex nibbles,
reconstructing the value by place value `Σ dᵢ · 16ⁱ`. Here we run exactly that
**Hex Walk** on the entire Monster order `N` instead of the small step `8080`. -/

/-- The hex (base-16) nibbles of the Monster order, little-endian. -/
def monsterHexNibbles : List ℕ := Nat.digits 16 MONSTER_ORDER

/-- The Monster order is a 45-nibble hex walk. -/
theorem monster_hex_nibble_count : monsterHexNibbles.length = 45 := by native_decide

/-- The sum of all hex nibbles of the Monster order is 240. -/
theorem monster_hex_nibble_sum : monsterHexNibbles.sum = 240 := by native_decide

/-- Every hex nibble of the Monster order is a valid hex digit (`< 16`). -/
theorem monster_hex_nibbles_valid : monsterHexNibbles.all (fun d => d < 16) = true := by
  native_decide

/-- **The Hex Walk of the Monster order.** Reconstructing `N` by place value
    `Σ dᵢ · 16ⁱ` over its hex nibbles returns the Monster order exactly —
    the same nibble-walk that recovered `8080 = 0x1F90`, now for all of `|M|`. -/
theorem monster_hex_walk_reconstruction :
    (monsterHexNibbles.zipIdx.map (fun p => p.1 * 16 ^ p.2)).sum = MONSTER_ORDER := by
  native_decide

/-- Horner form of the same Hex Walk: folding the nibbles back rebuilds `N`. -/
theorem monster_hex_walk_horner :
    monsterHexNibbles.foldr (fun d acc => acc * 16 + d) 0 = MONSTER_ORDER := by
  native_decide

/-! ## §8. Grand Summary -/

/-- The full spectral projection of the Monster order: everything at once. -/
theorem monster_hair_spectrum :
    -- factorization over the supersingular primes
    MONSTER_ORDER =
      2^46 * 3^20 * 5^9 * 7^6 * 11^2 * 13^3 * 17 * 19 * 23 * 29 * 31 * 41 *
        47 * 59 * 71 ∧
    -- 54 decimal digits
    (Nat.digits 10 MONSTER_ORDER).length = 54 ∧
    -- 2948 hairs in total
    monsterHairs.length = 2948 ∧
    -- 639 zero-hairs
    (monsterHairs.filter (· == 0)).length = 639 ∧
    -- 65 dividing bases
    (bases.filter (fun b => MONSTER_ORDER % b == 0)).length = 65 ∧
    -- the 5 non-dividing bases are the non-supersingular primes ≤ 71
    bases.filter (fun b => MONSTER_ORDER % b != 0) = [37, 43, 53, 61, 67] ∧
    -- all supersingular primes divide N
    SSP_list.all (fun p => MONSTER_ORDER % p == 0) = true ∧
    -- the Monster shard is 0
    MONSTER_ORDER % 71 = 0 ∧
    -- the full Hex Walk reconstructs the Monster order from its 45 nibbles
    monsterHexNibbles.length = 45 ∧
    (monsterHexNibbles.zipIdx.map (fun p => p.1 * 16 ^ p.2)).sum = MONSTER_ORDER := by
  refine ⟨by native_decide, by native_decide, by native_decide, by native_decide,
          by native_decide, by native_decide, by native_decide, by native_decide,
          by native_decide, by native_decide⟩

end MonsterHairs