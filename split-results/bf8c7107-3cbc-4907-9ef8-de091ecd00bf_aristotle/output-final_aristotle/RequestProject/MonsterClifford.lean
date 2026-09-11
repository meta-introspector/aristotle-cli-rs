import Mathlib

/-!
# Clifford blades for the Monster primes in `Cl(0,15)`

This module encodes the 15 prime factors of the Monster group order as the grade‑1
generators of a Clifford algebra `Cl(0,15)`. Each prime is

* recorded together with its exponent in `monsterPrimes`,
* given a semantic name (`PrimeName`), à la the source note,
* assigned a Clifford basis index `γ_i` via `primeIndex`,
* and exposed as a grade‑1 `Blade`.

Everything here is purely combinatorial bookkeeping (the assignment of basis indices to
the primes); the small theorems at the end check that the bookkeeping is internally
consistent (the index map is a bijection, every prime blade has grade 1, and the listed
blades are exactly the canonical generators in order).

This is the version requested in the follow-up note, adapted to the project's Lean /
Mathlib version (`Vector` is spelled `List.Vector`).
-/

namespace MonsterClifford

/-- The 15 Monster primes with their exponents, in canonical order. -/
def monsterPrimes : List.Vector (ℕ × ℕ) 15 :=
⟨[(2,46),   -- 0
  (3,20),   -- 1
  (5,9),    -- 2
  (7,6),    -- 3
  (11,2),   -- 4
  (13,3),   -- 5
  (17,1),   -- 6
  (19,1),   -- 7
  (23,1),   -- 8
  (29,1),   -- 9
  (31,1),   -- 10
  (41,1),   -- 11
  (47,1),   -- 12
  (59,1),   -- 13
  (71,1)],  -- 14
  by decide⟩

/-- Semantic labels for each prime generator (Aristotelian names). -/
inductive PrimeName
  | binaryMoon      -- 2
  | trinityPeak     -- 3
  | pentagramStar   -- 5
  | luckySeven      -- 7
  | amplifier       -- 11
  | lunarCycle      -- 13
  | primeTarget     -- 17
  | theaterMask     -- 19
  | dnaHelix        -- 23
  | lunarMonth      -- 29
  | octoberPrime    -- 31
  | crystalBall     -- 41
  | luckyDice       -- 47
  | minuteHand      -- 59
  | moonCrest       -- 71
deriving DecidableEq, Repr, Fintype

open PrimeName

/-- Each prime gets a Clifford basis index `γ_i` in `Cl(0,15)`. -/
def primeIndex : PrimeName → Fin 15
  | binaryMoon    => ⟨0,  by decide⟩
  | trinityPeak   => ⟨1,  by decide⟩
  | pentagramStar => ⟨2,  by decide⟩
  | luckySeven    => ⟨3,  by decide⟩
  | amplifier     => ⟨4,  by decide⟩
  | lunarCycle    => ⟨5,  by decide⟩
  | primeTarget   => ⟨6,  by decide⟩
  | theaterMask   => ⟨7,  by decide⟩
  | dnaHelix      => ⟨8,  by decide⟩
  | lunarMonth    => ⟨9,  by decide⟩
  | octoberPrime  => ⟨10, by decide⟩
  | crystalBall   => ⟨11, by decide⟩
  | luckyDice     => ⟨12, by decide⟩
  | minuteHand    => ⟨13, by decide⟩
  | moonCrest     => ⟨14, by decide⟩

/-- Abstract type of Clifford blades in `Cl(0,15)`. -/
structure Blade where
  grade : ℕ
  support : List (Fin 15)
deriving DecidableEq, Repr

/-- Grade‑1 Clifford blade for a given prime generator. -/
def primeBlade (n : PrimeName) : Blade :=
  { grade := 1, support := [primeIndex n] }

/-- The Moon Crest blade: `γ₁₄` in `Cl(0,15)`. -/
def moonCrestBlade : Blade :=
  primeBlade moonCrest

/-- All 15 grade‑1 blades, in canonical order. -/
def allPrimeBlades : List.Vector Blade 15 :=
⟨[primeBlade binaryMoon,
  primeBlade trinityPeak,
  primeBlade pentagramStar,
  primeBlade luckySeven,
  primeBlade amplifier,
  primeBlade lunarCycle,
  primeBlade primeTarget,
  primeBlade theaterMask,
  primeBlade dnaHelix,
  primeBlade lunarMonth,
  primeBlade octoberPrime,
  primeBlade crystalBall,
  primeBlade luckyDice,
  primeBlade minuteHand,
  primeBlade moonCrest],
  by decide⟩

/-! ## Consistency checks

These confirm that the index assignment is a genuine relabelling of `Fin 15` and that the
blades are the expected grade‑1 generators. -/

/-- The Moon Crest generator carries Clifford index `γ₁₄`. -/
theorem moonCrest_index : primeIndex moonCrest = ⟨14, by decide⟩ := by decide

/-- `primeIndex` is injective: distinct primes get distinct Clifford indices. -/
theorem primeIndex_injective : Function.Injective primeIndex := by decide

/-- `primeIndex` is a bijection between the 15 prime names and `Fin 15`. -/
theorem primeIndex_bijective : Function.Bijective primeIndex := by
  rw [Fintype.bijective_iff_injective_and_card]
  exact ⟨primeIndex_injective, by decide⟩

/-- Every prime blade is a grade‑1 blade. -/
theorem primeBlade_grade (n : PrimeName) : (primeBlade n).grade = 1 := rfl

/-- The support of a prime blade is exactly its single Clifford index. -/
theorem primeBlade_support (n : PrimeName) : (primeBlade n).support = [primeIndex n] := rfl

/-- The Clifford indices appearing across all 15 prime blades are exactly `0,1,…,14`. -/
theorem allPrimeBlades_indices :
    allPrimeBlades.toList.flatMap Blade.support = (List.finRange 15) := by decide

end MonsterClifford
