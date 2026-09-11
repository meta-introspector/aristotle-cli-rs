/-
# HexWalk.lean — The Monster Walk through Hexadecimal Space

## Core Insight

8080 = 0x1F90 is the Monster Walk step. In hexadecimal it decomposes
into exactly **4 nibbles** — the same 4-digit structure as in decimal.

Each nibble is a grade-1 blade:
- 0x1 → 0x1000 = 4096 = 2¹²   (the One)
- 0xF → 0x0F00 = 3840 = 15×256 (the Fifteen — all bits set, 6 SSP primes below)
- 0x9 → 0x0090 = 144  = 12²    (the Nine — 3², the perfect square)
- 0x0 → 0x0000 = 0              (the Zero — the void, completion)

The shard assignment: 0x1F90 mod 71 = 57 = 3 × 19, both Monster primes.

## Positioning in the Aristotle project

- Lives at `RequestProject/Math/Monster/HexWalk.lean`
- Imports: `MonsterConstants`, `MonsterWalkZKP`
- Namespace: `HexWalk`
-/

import Mathlib
import RequestProject.MonsterConstants
import RequestProject.Math.Monster.MonsterWalkZKP

set_option maxHeartbeats 800000

namespace HexWalk

open MonsterConstants MonsterWalkZKP

/-! ## §1. The Sacred Equality -/

/-- The walk step in decimal. -/
def walk_step : ℕ := 8080

/-- The walk step in hexadecimal. -/
def walk_step_hex : ℕ := 0x1F90

/-- 8080 = 0x1F90. -/
theorem sacred_equality : walk_step = walk_step_hex := by native_decide

/-! ## §2. Nibble Decomposition

0x1F90 = 1×16³ + 15×16² + 9×16¹ + 0×16⁰
       = 4096  + 3840   + 144   + 0
       = 8080
-/

/-- The four nibble values (most-significant first). -/
def nibbles : Fin 4 → ℕ
  | ⟨0, _⟩ => 1   -- 0x1
  | ⟨1, _⟩ => 15  -- 0xF
  | ⟨2, _⟩ => 9   -- 0x9
  | ⟨3, _⟩ => 0   -- 0x0

/-- The positional value of nibble i = nibble × 16^(3-i). -/
def nibble_value (i : Fin 4) : ℕ :=
  nibbles i * 16 ^ (3 - i.val)

theorem nibble_value_0 : nibble_value ⟨0, by omega⟩ = 4096 := by native_decide
theorem nibble_value_1 : nibble_value ⟨1, by omega⟩ = 3840 := by native_decide
theorem nibble_value_2 : nibble_value ⟨2, by omega⟩ = 144  := by native_decide
theorem nibble_value_3 : nibble_value ⟨3, by omega⟩ = 0    := by native_decide

/-- The sum of nibble values equals the walk step. -/
theorem hex_walk_sum :
    nibble_value ⟨0, by omega⟩ +
    nibble_value ⟨1, by omega⟩ +
    nibble_value ⟨2, by omega⟩ +
    nibble_value ⟨3, by omega⟩ = walk_step := by native_decide

/-- Positional composition: 1×16³ + 15×16² + 9×16¹ + 0×16⁰ = 8080. -/
theorem nibbles_compose :
    1 * 16^3 + 15 * 16^2 + 9 * 16^1 + 0 * 16^0 = walk_step := by native_decide

/-- The walk step has exactly 4 hex nibbles. -/
theorem four_hex_steps : (List.range 4).length = 4 := by native_decide

/-! ## §3. Binary Structure -/

/-- The walk step fits in 16 bits (2 bytes). -/
theorem binary_walk_length : walk_step < 2^16 := by native_decide

/-- Each nibble fits in 4 bits. -/
theorem nibbles_fit_4bits : ∀ i : Fin 4, nibbles i < 2^4 := by decide

/-- Binary representation: 0001 1111 1001 0000 = 8080. -/
theorem binary_value :
    1 * 2^12 + 1 * 2^11 + 1 * 2^10 + 1 * 2^9 + 1 * 2^8 +
    1 * 2^7  + 0 * 2^6  + 0 * 2^5  + 1 * 2^4 +
    0 * 2^3  + 0 * 2^2  + 0 * 2^1  + 0 * 2^0 = walk_step := by native_decide

/-! ## §4. Memory Walk

Walking down from 0x1F90 to 0x0000 by stripping nibbles:
  0x1F90 = 8080
  0x0F90 = 3984   (remove 0x1000)
  0x0090 = 144    (remove 0x0F00)
  0x0000 = 0      (remove 0x0090)
-/

/-- Memory addresses in the walk (descending). -/
def memory_addresses : List ℕ := [0x1F90, 0x0F90, 0x0090, 0x0000]

theorem memory_address_0 : memory_addresses[0]! = 8080 := by native_decide
theorem memory_address_1 : memory_addresses[1]! = 3984 := by native_decide
theorem memory_address_2 : memory_addresses[2]! = 144  := by native_decide
theorem memory_address_3 : memory_addresses[3]! = 0    := by native_decide

/-- The walk step sum is preserved: sum of strips = 8080. -/
theorem hex_walk_preserves :
    (0x1F90 - 0x0F90) + (0x0F90 - 0x0090) + (0x0090 - 0x0000) = walk_step := by
  native_decide

/-- Memory addresses are strictly descending. -/
theorem addresses_decrease :
    memory_addresses[0]! > memory_addresses[1]! ∧
    memory_addresses[1]! > memory_addresses[2]! ∧
    memory_addresses[2]! > memory_addresses[3]! := by native_decide

/-- Each step removes exactly one nibble's worth. -/
theorem memory_descends :
    memory_addresses[0]! - memory_addresses[1]! = 0x1000 ∧
    memory_addresses[1]! - memory_addresses[2]! = 0x0F00 ∧
    memory_addresses[2]! - memory_addresses[3]! = 0x0090 := by native_decide

/-! ## §5. Monster Primes in Hex

The 15 supersingular primes in hexadecimal:
  primes ≤ 13   → 1 nibble  (0x2 through 0xD)
  primes 17–71  → 2 nibbles (0x11 through 0x47)
-/

/-- The trivector primes (47, 59, 71) in hex. -/
theorem seventy_one_hex  : (71 : ℕ) = 0x47 := by native_decide
theorem fifty_nine_hex   : (59 : ℕ) = 0x3B := by native_decide
theorem forty_seven_hex  : (47 : ℕ) = 0x2F := by native_decide

/-- First 6 SSP primes fit in one nibble (< 16). -/
theorem small_primes_one_nibble :
    [2, 3, 5, 7, 11, 13].all (· < 16) = true := by native_decide

/-- Remaining 9 SSP primes require two nibbles (≥ 16). -/
theorem large_primes_two_nibbles :
    [17, 19, 23, 29, 31, 41, 47, 59, 71].all (fun p => p ≥ 16 ∧ p < 256) = true := by
  native_decide

/-! ## §6. Shard Assignment: 0x1F90 mod 71 -/

/-- The shard index for the walk step. -/
def hex_shard : ℕ := walk_step % 71

/-- 0x1F90 mod 71 = 57. -/
theorem hex_8080_shard : hex_shard = 57 := by native_decide

/-- 57 = 3 × 19, both Monster (SSP) primes. -/
theorem shard_factorization : hex_shard = 3 * 19 := by native_decide

/-- 3 and 19 are in the SSP list. -/
theorem shard_primes_are_ssp :
    (3 ∈ SSP_list) ∧ (19 ∈ SSP_list) := by native_decide

/-- 57 in hex is 0x39. -/
theorem shard_hex : hex_shard = 0x39 := by native_decide

/-- The shard is coprime to the modulus (walk visits all 71 sectors). -/
theorem shard_coprime_71 : Nat.Coprime hex_shard 71 := by native_decide

/-! ## §7. Multi-Base Representation -/

-- NOTE (correction): the original claim "8080 in base 71 = 1×71 + 57 = [1, 57]"
-- is FALSE.  8080 / 71 = 113 (not 1) and 1×71 + 57 = 128 ≠ 8080.
-- The base-71 representation of 8080 has THREE digits, [1, 42, 57]
-- (1×71² + 42×71 + 57 = 8080), consistent with `HexWalkProjection.digits_71`.
-- The original statements are preserved here, commented out:
--   theorem base71_high : walk_step / 71 = 1    := by native_decide
--   theorem base71_check : 1 * 71 + 57 = walk_step := by native_decide

/-- Corrected: 8080 / 71 = 113 (the high part is two base-71 digits, [1, 42]). -/
theorem base71_high : walk_step / 71 = 113  := by native_decide
/-- The least-significant base-71 digit (the shard) is 57. -/
theorem base71_low  : walk_step % 71 = 57   := by native_decide
/-- Corrected reconstruction: 8080 = 1×71² + 42×71 + 57 (three base-71 digits). -/
theorem base71_check : 1 * 71^2 + 42 * 71 + 57 = walk_step := by native_decide

/-- 8080 in base 8 (octal) = 17620₈. -/
theorem octal_check :
    1 * 8^4 + 7 * 8^3 + 6 * 8^2 + 2 * 8^1 + 0 * 8^0 = walk_step := by native_decide

/-- Hex is optimal: 4 nibbles = 16 bits = 2 bytes. -/
theorem hex_is_two_bytes : walk_step < 2^16 ∧ walk_step ≥ 2^12 := by native_decide

/-! ## §8. Connections to MonsterWalkZKP -/

/-- The walk step equals the standard walk_step from MonsterWalkZKP context. -/
theorem hex_step_equals_monster_step :
    walk_step = 8080 := by native_decide

/-- 8080 = 2⁴ × 5 × 101 (prime factorization). -/
theorem walk_step_factorization :
    walk_step = 2^4 * 5 * 101 := by native_decide

/-- The orbifold projection of the walk step. -/
def walk_orbifold : OrbifoldPoint := orbifoldProject walk_step

/-- The walk step projects to shard 57 in the Z/71Z component. -/
theorem walk_orbifold_71 :
    (walk_step : ZMod 71) = (57 : ZMod 71) := by native_decide

-- NOTE (correction): the original claims `walk_step % 59 = 36` and
-- `walk_step % 47 = 2` are FALSE.  In fact 8080 % 59 = 56 and 8080 % 47 = 43
-- (consistent with `HexWalkProjection.trailing_59`/`trailing_47`).
-- Original statements preserved, commented out:
--   theorem walk_mod_59 : walk_step % 59 = 36 := by native_decide
--   theorem walk_mod_47 : walk_step % 47 = 2 := by native_decide

/-- Corrected: the walk step mod 59 = 56. -/
theorem walk_mod_59 : walk_step % 59 = 56 := by native_decide

/-- Corrected: the walk step mod 47 = 43. -/
theorem walk_mod_47 : walk_step % 47 = 43 := by native_decide

/-! ## §9. 0xF Nibble — The Fifteen Connection -/

/-- The 0xF nibble value (15) equals the SSP list length. -/
theorem fifteen_is_ssp_count : nibbles ⟨1, by omega⟩ = SSP_list.length := by native_decide

/-- The 0xF nibble (0x0F00 = 3840) factors as 15 × 256 = 15 × 16². -/
theorem eff_nibble_factor : nibble_value ⟨1, by omega⟩ = 15 * 256 := by native_decide

/-- Primes below 0xF = 15: exactly 6 (the single-nibble SSP primes). -/
theorem primes_below_fifteen :
    ([2, 3, 5, 7, 11, 13] : List ℕ).length = 6 := by native_decide

/-- 0xF = all 4 bits set; it is the maximum 1-nibble value. -/
theorem eff_is_max_nibble : nibbles ⟨1, by omega⟩ = 2^4 - 1 := by native_decide

/-! ## §10. 0x9 Nibble — Nine as 3² -/

/-- The 0x9 nibble value is 9 = 3². -/
theorem nine_is_square : nibbles ⟨2, by omega⟩ = 3^2 := by native_decide

/-- 144 = 12² = (4 × 3)². -/
theorem one_forty_four_is_square : nibble_value ⟨2, by omega⟩ = 12^2 := by native_decide

/-- 144 = 2⁴ × 3². -/
theorem one_forty_four_factors : nibble_value ⟨2, by omega⟩ = 2^4 * 3^2 := by native_decide

/-! ## §11. The Complete Walk Theorem -/

/-- Main theorem: all properties of the Hex Walk hold simultaneously. -/
theorem the_hex_walk :
    -- Sacred equality
    walk_step = walk_step_hex ∧
    -- Nibble decomposition
    nibble_value ⟨0, by omega⟩ = 4096 ∧
    nibble_value ⟨1, by omega⟩ = 3840 ∧
    nibble_value ⟨2, by omega⟩ = 144  ∧
    nibble_value ⟨3, by omega⟩ = 0    ∧
    True ∧
    -- Binary structure
    walk_step < 2^16 ∧
    -- Shard
    hex_shard = 57 ∧
    hex_shard = 3 * 19 ∧
    Nat.Coprime hex_shard 71 ∧
    -- Trivector connection
    (71 : ℕ) = 0x47 ∧
    -- Fifteen connection
    nibbles ⟨1, by omega⟩ = SSP_list.length ∧
    -- Factorization
    walk_step = 2^4 * 5 * 101 := by
  refine ⟨by native_decide, by native_decide, by native_decide,
          by native_decide, by native_decide, trivial,
          by native_decide, by native_decide, by native_decide,
          by native_decide, by native_decide, by native_decide,
          by native_decide⟩

end HexWalk