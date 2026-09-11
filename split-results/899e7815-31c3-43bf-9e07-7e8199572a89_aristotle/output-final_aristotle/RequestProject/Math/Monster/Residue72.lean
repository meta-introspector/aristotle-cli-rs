/-
# Residue72.lean — The Walk Step as a Residue Map over Z/72Z

## The Shift

The SSP-prime story (`MonsterWalkZKP`, `HexWalk`, `Atropos`) is a sparse
landmark reading. Here we make the ambient arithmetic total:

  `proj : Fin 72 → Fin 72`,   `proj b = 8080 % b`   (with `proj 0 = proj 1 = 0`)

This is a *function on the full modulus space*. The SSP primes are 15
distinguished points inside this 72-element domain, not the domain itself.

## The Core Theorem (divisor characterization of fibers)

The fiber of a residue value `r` under `proj` is exactly:

  `fiber(r) = { b ∈ [2,71] | b ∣ (n − r) ∧ b > r }`

Because `n mod b = r  ↔  b ∣ (n − r)  ∧  b > r` (for `0 ≤ r < b ≤ 71`).

So the whole residue landscape is determined by the divisor structure of
`n − r` for each `r`. The primes are just the *squarefree single-divisor*
cases.

## File location
`RequestProject/Math/Monster/Residue72.lean`
-/

import Mathlib
import RequestProject.MonsterConstants
import RequestProject.Math.Monster.MonsterWalkZKP
import RequestProject.Math.Monster.HexWalk
import RequestProject.Math.Monster.Atropos

set_option maxHeartbeats 800000

namespace Residue72

open MonsterConstants MonsterWalkZKP HexWalk

/-! ## §1. The Projection Map -/

/-- The residue projection: `proj b = walk_step % b`, with `proj 0 = proj 1 = 0`. -/
def proj (b : Fin 72) : Fin 72 :=
  if h : b.val ≤ 1 then ⟨0, by omega⟩
  else ⟨walk_step % b.val, (Nat.mod_lt _ (by omega)).trans b.isLt⟩

/-- The list of bases `[2, 3, …, 71]`. -/
def bases : List ℕ := (List.range 70).map (· + 2)

/-- The full projection table as a list (index = base, value = residue). -/
def projTable : List ℕ :=
  [0, 0, 0, 1, 0, 0, 4, 2, 0, 7, 0, 6, 4, 7, 2, 10, 0, 5, 16, 5, 0, 16, 6, 7,
   16, 5, 20, 7, 16, 18, 10, 20, 16, 28, 22, 30, 16, 14, 24, 7, 0, 3, 16, 39,
   28, 25, 30, 43, 16, 44, 30, 22, 20, 24, 34, 50, 16, 43, 18, 56, 40, 28, 20,
   16, 16, 20, 28, 40, 56, 7, 30, 57]

theorem projTable_length : projTable.length = 72 := by native_decide

/-- proj agrees with the explicit table. -/
theorem proj_eq_table (b : Fin 72) : (proj b).val = projTable[b.val]! := by
  fin_cases b <;> simp [proj, projTable, walk_step]

/-- proj is well-defined: output is always strictly less than 72. -/
theorem proj_lt_72 (b : Fin 72) : (proj b).val < 72 := (proj b).isLt

/-- For b ≥ 2: proj b = walk_step % b. -/
theorem proj_spec (b : Fin 72) (hb : 2 ≤ b.val) :
    (proj b).val = walk_step % b.val := by
  have h : ¬ b.val ≤ 1 := by omega
  simp [proj, h]

/-! ## §2. The Image — 26 Reachable Residues -/

/-- The image of proj (over bases 2..71). -/
def imageSet : Finset ℕ :=
  {0, 1, 2, 3, 4, 5, 6, 7, 10, 14, 16, 18, 20, 22, 24, 25, 28, 30, 34, 39, 40,
   43, 44, 50, 56, 57}

/-- The image has exactly 26 elements. -/
theorem image_card : imageSet.card = 26 := by native_decide

/-- The map is not surjective: only 26 of 72 residues are reachable. -/
theorem proj_not_surjective : imageSet.card < 72 := by native_decide

/-- A residue r is in the image iff some base b ∈ [2,71] achieves it. -/
theorem image_spec (r : ℕ) (hr : r < 72) :
    r ∈ imageSet ↔ ∃ b : Fin 72, 2 ≤ b.val ∧ (proj b).val = r := by
  interval_cases r <;> native_decide

/-! ## §3. The Divisor Characterization of Fibers

The fundamental theorem: `n mod b = r  ↔  b ∣ (n - r)  ∧  b > r`. -/

/-- The fiber of residue r = { b ∈ [2,71] | b ∣ (walk_step - r) ∧ b > r }. -/
theorem fiber_is_divisors (r : ℕ) (hr : r < walk_step) :
    ∀ b : Fin 72, 2 ≤ b.val →
    ((proj b).val = r ↔ (b.val ∣ (walk_step - r) ∧ r < b.val)) := by
  intro b hb
  rw [proj_spec b hb]
  have hbpos : 0 < b.val := by omega
  constructor
  · intro h
    refine ⟨?_, ?_⟩
    · have := Nat.dvd_sub_mod (n := b.val) walk_step
      rwa [h] at this
    · rw [← h]; exact Nat.mod_lt _ hbpos
  · intro ⟨hdvd, hlt⟩
    obtain ⟨c, hc⟩ := hdvd
    have hn : walk_step = b.val * c + r := by omega
    rw [hn, Nat.mul_add_mod, Nat.mod_eq_of_lt hlt]

/-- Verified: fiber of 0 = divisors of walk_step in [2,71]. -/
theorem fiber_zero :
    bases.filter (fun b => walk_step % b == 0) =
    [2, 4, 5, 8, 10, 16, 20, 40] := by native_decide

/-- Verified: fiber of 16 (Bott attractor). -/
theorem fiber_sixteen :
    bases.filter (fun b => walk_step % b == 16) =
    [18, 21, 24, 28, 32, 36, 42, 48, 56, 63, 64] := by native_decide

/-- Verified: fiber of 7 (Earth/Spoke merge). -/
theorem fiber_seven :
    bases.filter (fun b => walk_step % b == 7) =
    [9, 13, 23, 27, 39, 69] := by native_decide

/-- Verified: fiber of 57 (hex shard). -/
theorem fiber_fiftyseven :
    bases.filter (fun b => walk_step % b == 57) =
    [71] := by native_decide

/-- Fiber of 16 is the largest: 11 elements. -/
theorem fiber_sixteen_is_largest :
    ∀ r ∈ imageSet,
    (bases.filter (fun b => walk_step % b == 16)).length ≥
    (bases.filter (fun b => walk_step % b == r)).length := by
  intro r hr
  fin_cases hr <;> native_decide

/-- The n−r factorization for fiber 16: 8080 − 16 = 8064. -/
theorem fiber_sixteen_nminusr : walk_step - 16 = 8064 := by native_decide

/-- 8064 = 2⁷ × 3² × 7. -/
theorem eight_sixty_four_factors : (8064 : ℕ) = 2^7 * 3^2 * 7 := by native_decide

/-- For fiber 5: 8080 − 5 = 8075 = 5² × 17 × 19.
    This explains why SSP primes 17 and 19 share residue 5. -/
theorem fiber_five_factorization : walk_step - 5 = 5^2 * 17 * 19 := by native_decide

-- The original document claimed 8080 − 7 = 8073 = 3² × 13 × 23.
-- This is FALSE: 3² × 13 × 23 = 2691, not 8073.  The correct factorization is
-- 8073 = 3³ × 13 × 23 (= 27 × 299).  Corrected below.
/- ORIGINAL (FALSE):
theorem fiber_seven_factorization : walk_step - 7 = 3^2 * 13 * 23 := by native_decide
-/
/-- For fiber 7: 8080 − 7 = 8073 = 3³ × 13 × 23 (corrected: 3³, not 3²).
    This explains the Earth/Spoke merge: 13 (Earth) and 23 (Spoke) collide. -/
theorem fiber_seven_factorization : walk_step - 7 = 3^3 * 13 * 23 := by native_decide

/-! ## §4. SSP Primes as Distinguished Fibers -/

/-- The 15 SSP residues (values n mod p for each SSP prime p). -/
def sspResidues : List ℕ :=
  SSP_list.map (fun p => walk_step % p)

/-- The SSP residues, computed. -/
theorem ssp_residues_value :
    sspResidues = [0, 1, 0, 2, 6, 7, 5, 5, 7, 18, 20, 3, 43, 56, 57] := by
  native_decide

/-- There are only 12 distinct SSP residues (17 and 19 collide at 5;
    13 and 23 collide at 7; 2 and 5 collide at 0). -/
theorem ssp_distinct_residues :
    sspResidues.toFinset.card = 12 := by native_decide

/-- All SSP residues are in the image of proj. -/
theorem ssp_residues_in_image :
    ∀ r ∈ sspResidues, r ∈ imageSet := by native_decide

/-- The SSP primes are a subfamily of the full 72-base domain. -/
theorem ssp_as_subfamily :
    SSP_list.all (fun p => p < 72) = true := by native_decide

/-- The Ogg/SSP primes as elements of Fin 72. -/
def sspFin : List (Fin 72) :=
  [⟨2,by omega⟩, ⟨3,by omega⟩, ⟨5,by omega⟩, ⟨7,by omega⟩,
   ⟨11,by omega⟩, ⟨13,by omega⟩, ⟨17,by omega⟩, ⟨19,by omega⟩,
   ⟨23,by omega⟩, ⟨29,by omega⟩, ⟨31,by omega⟩, ⟨41,by omega⟩,
   ⟨47,by omega⟩, ⟨59,by omega⟩, ⟨71,by omega⟩]

/-- The SSP Fin list has length 15. -/
theorem sspFin_length : sspFin.length = 15 := by native_decide

/-! ## §5. Isolated, Shared, and Dominant Fibers Among SSP Primes -/

/-- Three SSP primes have singleton fibers (isolated in the full residue landscape):
    p=3 (residue 1), p=41 (residue 3), p=71 (residue 57). -/
theorem isolated_ssp_primes :
    -- p=3: only base giving residue 1
    bases.filter (fun b => walk_step % b == 1) = [3] ∧
    -- p=41: only base giving residue 3
    bases.filter (fun b => walk_step % b == 3) = [41] ∧
    -- p=71: only base giving residue 57
    bases.filter (fun b => walk_step % b == 57) = [71] := by
  native_decide

/-- The three isolated SSP primes are 3, 41, 71. -/
theorem isolated_are_3_41_71 :
    SSP_list.filter (fun p =>
      (bases.filter (fun b => walk_step % b == walk_step % p)).length == 1) =
    [3, 41, 71] := by native_decide

/-- SSP primes 17 and 19 share residue 5 because 5² × 17 × 19 = 8075 = n − 5. -/
theorem earth_collision_17_19 :
    walk_step % 17 = walk_step % 19 ∧
    walk_step % 17 = 5 ∧
    walk_step - 5 = 5^2 * 17 * 19 := by native_decide

/-- SSP primes 13 (Earth) and 23 (Spoke) share residue 7
    because 3³ × 13 × 23 = 8073 = n − 7.
    This is the unique cross-stratum collision. -/
theorem cross_stratum_collision_13_23 :
    walk_step % 13 = walk_step % 23 ∧
    walk_step % 13 = 7 ∧
    walk_step - 7 = 3^3 * 13 * 23 := by native_decide

/-- SSP primes 2 and 5 collide at residue 0 — both divide walk_step. -/
theorem divisor_collision_2_5 :
    walk_step % 2 = 0 ∧ walk_step % 5 = 0 ∧
    2 ∣ walk_step ∧ 5 ∣ walk_step := by
  norm_num [walk_step]

/-! ## §6. The Dominant Fiber: Residue 16 as Bott Attractor -/

/-- Residue 16 has the largest fiber (11 bases). -/
theorem residue_16_dominant :
    (bases.filter (fun b => walk_step % b == 16)).length = 11 := by
  native_decide

/-- 8080 = 16 × 505, so 16 divides 8080 and 16 is the leading factor. -/
theorem walk_step_divisible_16 : 16 ∣ walk_step ∧ walk_step / 16 = 505 := by
  norm_num [walk_step]

/-- 505 = 5 × 101. -/
theorem five_o_five_factors : (505 : ℕ) = 5 * 101 := by native_decide

/-- The 11 bases in the Bott fiber are all non-prime (none in SSP_list). -/
theorem bott_fiber_no_ssp :
    (bases.filter (fun b => walk_step % b == 16)).all
      (fun b => !(SSP_list.contains b)) = true := by native_decide

/-- The Bott fiber is determined by divisors of 8064 = 2⁷ × 3² × 7 above 16. -/
theorem bott_fiber_from_divisors :
    bases.filter (fun b => walk_step % b == 16) =
    bases.filter (fun b => b > 16 ∧ 8064 % b == 0) := by
  native_decide

/-! ## §7. Surjectivity Obstruction -/

/-- The "dark" residues: values in [0,71] not achieved by any base in [2,71]. -/
def darkResidues : List ℕ :=
  (List.range 72).filter (fun r => bases.all (fun b => walk_step % b ≠ r))

/-- There are 46 dark residues. -/
theorem dark_residue_count : darkResidues.length = 46 := by native_decide

/-- No dark residue is an SSP prime residue. -/
theorem dark_residues_avoid_ssp :
    darkResidues.all (fun r => !(sspResidues.contains r)) = true := by native_decide

/-- The dark residues include all values r > 57 (since r < b ≤ 71 bounds what's achievable). -/
theorem dark_above_57 :
    ∀ r : ℕ, 58 ≤ r → r < 72 → r ∈ darkResidues := by
  intro r h1 h2
  interval_cases r <;> native_decide

/-- Obstruction: r is dark iff walk_step − r has no divisors in (r, 71]. -/
theorem dark_iff_no_divisors (r : ℕ) (hr : r < 72) (hrn : r < walk_step) :
    r ∈ darkResidues ↔
    bases.filter (fun b => b > r ∧ (walk_step - r) % b == 0) = [] := by
  interval_cases r <;> native_decide

/-! ## §8. All residues Covered (SSP corollary) -/

/-- Every SSP residue is covered — the SSP primes all have non-empty fibers. -/
theorem all_ssp_residues_covered :
    ∀ r ∈ sspResidues, ∃ b : Fin 72, 2 ≤ b.val ∧ (proj b).val = r := by
  intro r hr
  have h72 : r < 72 := by
    rw [ssp_residues_value] at hr; fin_cases hr <;> omega
  exact (image_spec r h72).mp (ssp_residues_in_image r hr)

/-- All 12 distinct SSP residue values are in the image of proj. -/
theorem ogg_primes_as_special_fibers :
    sspResidues.toFinset ⊆ imageSet := by native_decide

/-! ## §9. The Full Residue Map Table -/

/-- proj(2) = 0: walk_step is even. -/
theorem proj_2  : (proj ⟨2,  by omega⟩).val = 0  := by native_decide
/-- proj(3) = 1. -/
theorem proj_3  : (proj ⟨3,  by omega⟩).val = 1  := by native_decide
/-- proj(5) = 0: walk_step divisible by 5. -/
theorem proj_5  : (proj ⟨5,  by omega⟩).val = 0  := by native_decide
/-- proj(7) = 2. -/
theorem proj_7  : (proj ⟨7,  by omega⟩).val = 2  := by native_decide
/-- proj(11) = 6. -/
theorem proj_11 : (proj ⟨11, by omega⟩).val = 6  := by native_decide
/-- proj(13) = 7. -/
theorem proj_13 : (proj ⟨13, by omega⟩).val = 7  := by native_decide
/-- proj(17) = 5. -/
theorem proj_17 : (proj ⟨17, by omega⟩).val = 5  := by native_decide
/-- proj(19) = 5. -/
theorem proj_19 : (proj ⟨19, by omega⟩).val = 5  := by native_decide
/-- proj(23) = 7. -/
theorem proj_23 : (proj ⟨23, by omega⟩).val = 7  := by native_decide
/-- proj(29) = 18. -/
theorem proj_29 : (proj ⟨29, by omega⟩).val = 18 := by native_decide
/-- proj(31) = 20. -/
theorem proj_31 : (proj ⟨31, by omega⟩).val = 20 := by native_decide
/-- proj(41) = 3. -/
theorem proj_41 : (proj ⟨41, by omega⟩).val = 3  := by native_decide
/-- proj(47) = 43. -/
theorem proj_47 : (proj ⟨47, by omega⟩).val = 43 := by native_decide
/-- proj(59) = 56. -/
theorem proj_59 : (proj ⟨59, by omega⟩).val = 56 := by native_decide
/-- proj(71) = 57. -/
theorem proj_71 : (proj ⟨71, by omega⟩).val = 57 := by native_decide

/-- hex_walk_residue72_projection: the shard theorem is the restriction of proj to p=71. -/
theorem hex_walk_residue72_projection :
    (proj ⟨71, by omega⟩).val = HexWalk.hex_shard := by native_decide

/-! ## §10. Grand Theorem -/

/-- The residue map over Z/72Z: complete summary. -/
theorem all_72_residues_as_fibers :
    -- The image has exactly 26 values
    imageSet.card = 26 ∧
    -- The map is not surjective
    imageSet.card < 72 ∧
    -- Fiber of 0 = 8 divisors of n in [2,71]
    bases.filter (fun b => walk_step % b == 0) = [2, 4, 5, 8, 10, 16, 20, 40] ∧
    -- Dominant fiber: residue 16 has 11 bases
    (bases.filter (fun b => walk_step % b == 16)).length = 11 ∧
    -- No SSP residue is dark
    darkResidues.all (fun r => !(sspResidues.contains r)) = true ∧
    -- The three isolated SSP primes
    SSP_list.filter (fun p =>
      (bases.filter (fun b => walk_step % b == walk_step % p)).length == 1) = [3, 41, 71] ∧
    -- Cross-stratum collision: 13 and 23 share residue 7
    walk_step % 13 = walk_step % 23 ∧
    -- Earth collision: 17 and 19 share residue 5
    walk_step % 17 = walk_step % 19 ∧
    -- The hex shard is proj(71)
    (proj ⟨71, by omega⟩).val = HexWalk.hex_shard := by
  refine ⟨by native_decide, by native_decide, by native_decide, by native_decide,
          by native_decide, by native_decide, by native_decide, by native_decide,
          by native_decide⟩

end Residue72
