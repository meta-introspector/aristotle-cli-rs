/-
# MonsterDigitWalk.lean — The Digit-Preservation Sequence of the Monster Order

## The Construction

The original Hex Walk recorded that `8080 = 0x1F90` is **preserved in 4 hex
digits** (4 nibbles). The natural generalization, requested here, is to run
the *same* "how many digits survive in this base?" measurement over **every
base `b ∈ [2, 71]`** — the full span of bases up to the largest supersingular
("Monster") prime — applied to the **entire Monster group order**

  N = |M| = 808017424794512875886459904961710757005754368000000000.

For each base `b` the *digit-preservation count* is the number of base-`b`
digits of `N`, i.e. `(Nat.digits b N).length`. Sweeping `b` from `2` to `71`
produces a new length-70 sequence

  `monsterDigitWalk = [180, 113, 90, 78, … , 31, 30, 30, …, 30]`

— the number of digits the Monster order is "preserved in" across every base.

## Key facts (all computed and verified)

```
  Number of bases swept (2..71):          70
  Digits in base 2  (most preserved):     180   (binary, the maximum)
  Digits in base 71 (least preserved):    30    (base-71, the minimum)
  The sequence is monotonically non-increasing in the base.
  Sum of the whole sequence:              2948   (= total Monster hairs)
  Digit count in base 16 (the Hex Walk):  45     (matches monster_hex_nibble_count)
```

The digit counts in the 15 supersingular bases form the subsequence

  `[180, 113, 78, 64, 52, 49, 44, 43, 40, 37, 37, 34, 33, 31, 30]`.

## File location
`RequestProject/Math/Monster/MonsterDigitWalk.lean`
-/

import Mathlib
import RequestProject.MonsterConstants
import RequestProject.Math.Monster.MonsterHairs

set_option maxHeartbeats 1600000

namespace MonsterDigitWalk

open MonsterConstants MonsterWalkZKP MonsterHairs

/-! ## §1. The Digit-Preservation Sequence -/

/-- The digit-preservation count of `N` in base `b`: the number of base-`b`
    digits the Monster order is "preserved in". -/
def digitsPreserved (b : ℕ) : ℕ := (Nat.digits b MONSTER_ORDER).length

/-- The Digit Walk: how many digits the Monster order is preserved in, swept
    over every base `b ∈ [2, 71]` (little end = base 2, big end = base 71). -/
def monsterDigitWalk : List ℕ := bases.map digitsPreserved

/-- The explicit digit-preservation sequence across all 70 bases. -/
theorem monsterDigitWalk_eq :
    monsterDigitWalk =
      [180, 113, 90, 78, 70, 64, 60, 57, 54, 52, 50, 49, 48, 46, 45, 44, 43, 43, 42, 41,
       41, 40, 40, 39, 39, 38, 38, 37, 37, 37, 36, 36, 36, 35, 35, 35, 35, 34, 34, 34,
       34, 34, 33, 33, 33, 33, 33, 32, 32, 32, 32, 32, 32, 31, 31, 31, 31, 31, 31, 31,
       31, 30, 30, 30, 30, 30, 30, 30, 30, 30] := by native_decide

/-- One digit-preservation count for each of the 70 bases `2..71`. -/
theorem monsterDigitWalk_length : monsterDigitWalk.length = 70 := by native_decide

/-! ## §2. Extremes of the Sequence -/

/-- Binary preserves the most digits: `N` has 180 binary digits. -/
theorem digits_base2_max : digitsPreserved 2 = 180 := by native_decide

/-- Base 71 (the Monster prime) preserves the fewest digits: `N` has 30. -/
theorem digits_base71_min : digitsPreserved 71 = 30 := by native_decide

/-- Across all swept bases, base 2 attains the maximum digit count (180). -/
theorem digits_base2_is_max :
    monsterDigitWalk.all (fun d => d ≤ 180) = true := by native_decide

/-- Across all swept bases, base 71 attains the minimum digit count (30). -/
theorem digits_base71_is_min :
    monsterDigitWalk.all (fun d => 30 ≤ d) = true := by native_decide

/-! ## §3. Monotonicity — Larger Bases Preserve Fewer Digits -/

/-- The digit-preservation sequence is monotonically non-increasing in the
    base: a larger base never preserves *more* digits. -/
theorem monsterDigitWalk_antitone :
    (List.range 69).all (fun i => monsterDigitWalk[i + 1]! ≤ monsterDigitWalk[i]!) = true := by
  native_decide



/-! ## §4. The Sum — Total Digits Across All Bases -/

/-- The total number of digits of `N` summed across all bases `2..71` equals
    `2948` — exactly the total number of Monster "hairs". -/
theorem monsterDigitWalk_sum : monsterDigitWalk.sum = 2948 := by native_decide

/-- The digit-preservation sum is precisely the total hair count, because the
    hairs are exactly the digits collected over all bases. -/
theorem digit_walk_sum_is_hair_count :
    monsterDigitWalk.sum = monsterHairs.length := by native_decide

/-! ## §5. The Hex Walk as the Base-16 Slice -/

/-- The base-16 entry of the Digit Walk is the original Hex Walk's nibble
    count: `N` is preserved in 45 hex nibbles. -/
theorem digits_base16_hex : digitsPreserved 16 = 45 := by native_decide

/-- The base-16 digit count agrees with `monster_hex_nibble_count`. -/
theorem digit_walk_base16_is_hex_walk :
    digitsPreserved 16 = monsterHexNibbles.length := by native_decide

/-! ## §6. The Supersingular Sub-Sequence

Restricting the Digit Walk to the 15 supersingular ("Monster") bases gives a
canonical strictly relevant subsequence: how many digits `N` is preserved in,
base by base, over exactly the primes that divide `|M|`. -/

/-- The digit-preservation counts over the 15 supersingular bases. -/
def sspDigitWalk : List ℕ := SSP_list.map digitsPreserved

/-- The explicit supersingular digit-preservation subsequence. -/
theorem sspDigitWalk_eq :
    sspDigitWalk = [180, 113, 78, 64, 52, 49, 44, 43, 40, 37, 37, 34, 33, 31, 30] := by
  native_decide

/-- There are 15 entries, one per supersingular prime. -/
theorem sspDigitWalk_length : sspDigitWalk.length = 15 := by native_decide

/-- The supersingular digit-preservation sequence is also non-increasing. -/
theorem sspDigitWalk_antitone :
    (List.range 14).all (fun i => sspDigitWalk[i + 1]! ≤ sspDigitWalk[i]!) = true := by
  native_decide

/-! ## §7. The Divisor-Base Sub-Sequence

The 65 bases in `[2, 71]` that actually **divide** `|M|` carry their own
digit-preservation subsequence — the "sequence of divisors" view of the walk.
A base divides `N` exactly when its trailing base-`b` digit (`N mod b`) is `0`. -/

/-- The bases in `[2, 71]` that divide the Monster order. -/
def divisorBases : List ℕ := bases.filter (fun b => MONSTER_ORDER % b == 0)

/-- The digit-preservation counts over the divisor bases. -/
def divisorDigitWalk : List ℕ := divisorBases.map digitsPreserved

/-- There are 65 divisor bases (the 5 non-supersingular primes are excluded). -/
theorem divisorBases_length : divisorBases.length = 65 := by native_decide

/-- One digit-preservation count per divisor base. -/
theorem divisorDigitWalk_length : divisorDigitWalk.length = 65 := by native_decide

/-- The divisor digit-preservation sequence is monotonically non-increasing. -/
theorem divisorDigitWalk_antitone :
    (List.range 64).all (fun i => divisorDigitWalk[i + 1]! ≤ divisorDigitWalk[i]!) = true := by
  native_decide

/-- A base divides `|M|` iff its trailing base-`b` digit vanishes (`N mod b = 0`):
    the divisor bases are exactly the bases whose Digit Walk ends in a zero. -/
theorem divisor_iff_trailing_zero (b : ℕ) (hb : 2 ≤ b) :
    MONSTER_ORDER % b = 0 ↔ (Nat.digits b MONSTER_ORDER).headD 0 = 0 := by
  rcases Nat.eq_zero_or_pos MONSTER_ORDER with h | h
  · simp [h]
  · rw [Nat.digits_def' hb h]
    simp

/-! ## §8. The Divisor Cascade — Trailing Zeros are the Factorization Exponents

In any *prime* base `p`, the number of trailing zero digits of `n` is exactly the
`p`-adic valuation `v_p(n) = n.factorization p` (the largest `k` with `pᵏ ∣ n`).
Sweeping `p` over the supersingular primes therefore reads off the **exponent
vector of the Monster factorization** straight from the trailing zeros of the
Digit Walk. This is the genuinely deductive core: it follows structurally from
`monster_factorization`, not from a brute numerical check. -/

/-- The number of trailing zero digits of `n` in base `b` (little-endian). -/
def trailingZeros (b n : ℕ) : ℕ := ((Nat.digits b n).takeWhile (· == 0)).length

/-- **Trailing zeros = p-adic valuation.** For a prime base `p` and `n > 0`, the
    number of trailing zero digits of `n` in base `p` equals `n.factorization p`.
    Proved structurally by strong induction on `n`, with no `native_decide`. -/
theorem trailingZeros_eq_factorization (p n : ℕ) (hp : p.Prime) (hn : 0 < n) :
    trailingZeros p n = n.factorization p := by
  induction' n using Nat.strong_induction_on with n ih
  by_cases h_div : p ∣ n
  · obtain ⟨ k, hk ⟩ := h_div
    unfold trailingZeros at *; simp_all +decide [ hp.ne_zero ]
    rcases p with ( _ | _ | p ) <;> rcases k with ( _ | _ | k ) <;> simp_all +decide
    ring
  · unfold trailingZeros; simp_all +decide [ Nat.factorization_eq_zero_of_not_dvd ]
    rcases p with ( _ | _ | p ) <;> rcases n with ( _ | _ | n ) <;> simp_all +decide [ Nat.div_eq_of_lt, Nat.mod_eq_of_lt ]
    rwa [ Nat.dvd_iff_mod_eq_zero ] at h_div

/-- The trailing-zero counts of `N` over the 15 supersingular bases are exactly
    the exponent vector of the Monster factorization. -/
theorem ssp_trailingZeros_eq_exponents :
    SSP_list.map (fun p => trailingZeros p MONSTER_ORDER) =
      [46, 20, 9, 6, 2, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1] := by native_decide

/-- Equivalently, in each supersingular base the trailing-zero count equals the
    factorization exponent — the divisor cascade reads off the exponent vector. -/
theorem ssp_trailingZeros_is_factorization :
    SSP_list.all (fun p => trailingZeros p MONSTER_ORDER == MONSTER_ORDER.factorization p)
      = true := by native_decide

/-- **Deductive Monster corollary.** For *any* prime `p`, the trailing-zero
    count of the Monster order in base `p` equals `v_p(|M|)` — obtained from the
    general structural theorem, with no numerical check on `N`. Combined with
    `monster_factorization`, this reads the exponent vector off the Digit Walk. -/
theorem monster_trailingZeros_eq_factorization (p : ℕ) (hp : p.Prime) :
    trailingZeros p MONSTER_ORDER = MONSTER_ORDER.factorization p :=
  trailingZeros_eq_factorization p MONSTER_ORDER hp (by unfold MONSTER_ORDER; norm_num)

/-! ## §9. Grand Summary -/

/-- The complete Digit-Preservation Walk of the Monster order across all bases. -/
theorem monster_digit_walk_spectrum :
    -- one digit-count per base 2..71
    monsterDigitWalk.length = 70 ∧
    -- the explicit sequence
    monsterDigitWalk =
      [180, 113, 90, 78, 70, 64, 60, 57, 54, 52, 50, 49, 48, 46, 45, 44, 43, 43, 42, 41,
       41, 40, 40, 39, 39, 38, 38, 37, 37, 37, 36, 36, 36, 35, 35, 35, 35, 34, 34, 34,
       34, 34, 33, 33, 33, 33, 33, 32, 32, 32, 32, 32, 32, 31, 31, 31, 31, 31, 31, 31,
       31, 30, 30, 30, 30, 30, 30, 30, 30, 30] ∧
    -- binary preserves the most (180), base 71 the fewest (30)
    digitsPreserved 2 = 180 ∧
    digitsPreserved 71 = 30 ∧
    -- total digits across all bases = total hairs
    monsterDigitWalk.sum = 2948 ∧
    -- the base-16 slice is the original Hex Walk (45 nibbles)
    digitsPreserved 16 = 45 ∧
    -- the supersingular subsequence
    sspDigitWalk = [180, 113, 78, 64, 52, 49, 44, 43, 40, 37, 37, 34, 33, 31, 30] ∧
    -- 65 of the 70 bases divide |M|
    divisorBases.length = 65 := by
  refine ⟨by native_decide, by native_decide, by native_decide, by native_decide,
          by native_decide, by native_decide, by native_decide, by native_decide⟩

end MonsterDigitWalk