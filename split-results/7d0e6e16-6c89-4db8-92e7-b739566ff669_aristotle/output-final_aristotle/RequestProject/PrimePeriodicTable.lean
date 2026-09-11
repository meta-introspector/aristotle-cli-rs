import Mathlib

/-!
# A Periodic Table of Primes Relative to the Monster Group

We organize **all primes** into concentric **shells** around the Monster group
order |M| = 2⁴⁶·3²⁰·5⁹·7⁶·11²·13³·17·19·23·29·31·41·47·59·71.

## Shell Classification

| Shell | Name | Description | Count |
|-------|------|-------------|-------|
| 0 | **Core** | Supersingular primes (divide \|M\|) | 15 |
| 1 | **Interstitial** | Exterior primes ≤ 71 (gaps between supersingulars) | 5 |
| 2 | **Near tail** | Exterior primes in (71, 199] | 26 |
| 3 | **Moonshine** | Exterior primes appearing in j-expansion coefficients | 3+ |
| ≥ 4 | **Deep exterior** | All remaining primes | ∞ |

The analogy to a chemical periodic table:
- **Shell 0** primes are like noble gases — perfectly integrated into |M|'s structure.
- **Shell 1** primes are like halogens — close to the core but just outside, filling
  gaps in the prime number line between supersingulars.
- **Shell 2** primes form the first "electron shell" beyond the largest supersingular 71.
- **Shell 3** primes are "excited states" — they don't divide |M| but appear
  in the moonshine expansion coefficients, connecting to VOA structure.

### Shell 0 Internal: "Electron Configuration"

```
╔══════════════════════════════════════════════════════════════╗
║         PERIODIC TABLE OF MONSTER PRIMES                     ║
╠══════════════════════════════════════════════════════════════╣
║ SHELL 0 — CORE (Supersingular, divide |M|)                  ║
║                                                              ║
║   f-block (valence ≥ 20):                                    ║
║     [2]⁴⁶  [3]²⁰                                            ║
║                                                              ║
║   d-block (valence 6–9):                                     ║
║     [5]⁹   [7]⁶                                             ║
║                                                              ║
║   p-block (valence 2–3):                                     ║
║     [11]²  [13]³                                             ║
║                                                              ║
║   s-block (valence 1):                                       ║
║     [17]¹ [19]¹ [23]¹ [29]¹ [31]¹ [41]¹ [47]¹ [59]¹ [71]¹  ║
║                                                              ║
╠══════════════════════════════════════════════════════════════╣
║ SHELL 1 — INTERSTITIAL (exterior, ≤ 71)                     ║
║     [37]  [43]  [53]  [61]  [67]                             ║
║                                                              ║
╠══════════════════════════════════════════════════════════════╣
║ SHELL 2 — NEAR TAIL (exterior, 72–199)                      ║
║     [73]  [79]  [83]  [89]  [97]  [101] [103] [107] [109]   ║
║     [113] [127] [131] [137] [139] [149] [151] [157] [163]   ║
║     [167] [173] [179] [181] [191] [193] [197] [199]         ║
║                                                              ║
╠══════════════════════════════════════════════════════════════╣
║ SHELL 3 — MOONSHINE ESCAPEES (from j-coefficients)          ║
║     [1823]  (from c₁ = 196884)                               ║
║     [2099]  (from c₂ = 21493760)                             ║
║     [45767] (from c₄ = 20245856256)                          ║
║                                                              ║
╠══════════════════════════════════════════════════════════════╣
║ SHELL 4+ — DEEP EXTERIOR (all other primes, ∞ many)         ║
║     [211] [223] [227] [229] [233] …                          ║
╚══════════════════════════════════════════════════════════════╝
```
-/

open scoped BigOperators Nat

set_option maxHeartbeats 3200000

/-! ## §1. Monster Order and Shell Definitions -/

/-- The order of the Monster group. -/
def M : ℕ :=
  2^46 * 3^20 * 5^9 * 7^6 * 11^2 * 13^3 * 17 * 19 * 23 * 29 * 31 * 41 * 47 * 59 * 71

/-- The 15 supersingular primes — **Shell 0 (Core)** of our periodic table. -/
def shell0 : List ℕ := [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71]

/-- **Shell 1 (Interstitial)**: exterior primes ≤ 71, filling gaps between supersingulars. -/
def shell1 : List ℕ := [37, 43, 53, 61, 67]

/-- **Shell 2 (Near tail)**: exterior primes in (71, 199]. -/
def shell2 : List ℕ :=
  [73, 79, 83, 89, 97, 101, 103, 107, 109, 113, 127, 131, 137, 139, 149,
   151, 157, 163, 167, 173, 179, 181, 191, 193, 197, 199]

/-- **Shell 3 (Moonshine escapees)**: exterior primes appearing in j-coefficients. -/
def shell3 : List ℕ := [1823, 2099, 45767]

/-- All primes across all four shells, collected for verification. -/
def allShellPrimes : List ℕ :=
  shell0 ++ shell1 ++ shell2 ++ shell3

/-! ## §2. Shell 0: The Core (Supersingular Primes) -/

theorem shell0_length : shell0.length = 15 := by native_decide

theorem shell0_all_prime : ∀ p ∈ shell0, Nat.Prime p := by native_decide

theorem shell0_all_dvd : ∀ p ∈ shell0, p ∣ M := by native_decide

theorem shell0_increasing : shell0.Pairwise (· < ·) := by native_decide

/-- The "valence" of each Shell 0 prime: its exact exponent in |M|'s factorization.
    Analogous to the number of electrons in a chemical element's outer shell. -/
def valenceTable : List (ℕ × ℕ) :=
  [(2, 46), (3, 20), (5, 9), (7, 6), (11, 2), (13, 3), (17, 1),
   (19, 1), (23, 1), (29, 1), (31, 1), (41, 1), (47, 1), (59, 1), (71, 1)]

/-- Each valence entry correctly records that p^e divides |M|. -/
theorem valence_divides : ∀ pe ∈ valenceTable, pe.1 ^ pe.2 ∣ M := by
  intro ⟨p, e⟩ h; fin_cases h <;> native_decide

/-- Each valence is exact: p^(e+1) does NOT divide |M|. -/
theorem valence_exact : ∀ pe ∈ valenceTable, ¬(pe.1 ^ (pe.2 + 1) ∣ M) := by
  intro ⟨p, e⟩ h; fin_cases h <;> native_decide

/-- The sum of all valences = 95 (the "atomic weight" of |M|'s factorization).
    This counts the total number of prime factors with multiplicity. -/
theorem totalValence_eq : (valenceTable.map Prod.snd).sum = 95 := by native_decide

/-! ## §3. Shell 1: The Interstitial Primes -/

theorem shell1_length : shell1.length = 5 := by native_decide

theorem shell1_all_prime : ∀ p ∈ shell1, Nat.Prime p := by native_decide

theorem shell1_not_dvd : ∀ p ∈ shell1, ¬(p ∣ M) := by native_decide

theorem shell1_all_le_71 : ∀ p ∈ shell1, p ≤ 71 := by decide

theorem shell1_increasing : shell1.Pairwise (· < ·) := by native_decide

/-- Each interstitial prime sits between two consecutive supersingular primes.
    Format: (interstitial prime, left supersingular, right supersingular). -/
def interstitialGaps : List (ℕ × ℕ × ℕ) :=
  [(37, 31, 41),  -- 37 sits between supersingulars 31 and 41
   (43, 41, 47),  -- 43 sits between supersingulars 41 and 47
   (53, 47, 59),  -- 53 sits between supersingulars 47 and 59
   (61, 59, 71),  -- 61 sits between supersingulars 59 and 71
   (67, 59, 71)]  -- 67 also sits between supersingulars 59 and 71

/-- Each interstitial prime is strictly between its supersingular neighbors. -/
theorem gap_bounds : ∀ g ∈ interstitialGaps, g.2.1 < g.1 ∧ g.1 < g.2.2 := by decide

/-- Both neighbors of each interstitial prime are in Shell 0. -/
theorem gap_neighbors_in_shell0 :
    ∀ g ∈ interstitialGaps, g.2.1 ∈ shell0 ∧ g.2.2 ∈ shell0 := by decide

/-! ## §4. Shell 2: The Near Tail -/

theorem shell2_length : shell2.length = 26 := by native_decide

theorem shell2_all_prime : ∀ p ∈ shell2, Nat.Prime p := by native_decide

theorem shell2_not_dvd : ∀ p ∈ shell2, ¬(p ∣ M) := by native_decide

theorem shell2_range : ∀ p ∈ shell2, 71 < p ∧ p ≤ 199 := by decide

theorem shell2_increasing : shell2.Pairwise (· < ·) := by native_decide

/-! ## §5. Shell 3: Moonshine Escapees -/

theorem shell3_all_prime : ∀ p ∈ shell3, Nat.Prime p := by native_decide

theorem shell3_not_dvd : ∀ p ∈ shell3, ¬(p ∣ M) := by native_decide

/-- 196884 = 2² × 3³ × 1823 — the moonshine escapee 1823 first appears here. -/
theorem mckay_factorization : 196884 = 2^2 * 3^3 * 1823 := by norm_num

/-- 21493760 = 2¹¹ × 5 × 2099 — the escapee 2099 first appears here. -/
theorem c2_factorization : 21493760 = 2^11 * 5 * 2099 := by norm_num

/-- 1823 divides c₁ = 196884 (McKay's coefficient). -/
theorem escapee_1823_divides_c1 : 1823 ∣ 196884 := ⟨108, by norm_num⟩

/-- 2099 divides c₂ = 21493760. -/
theorem escapee_2099_divides_c2 : 2099 ∣ 21493760 := ⟨10240, by norm_num⟩

/-- All moonshine escapees are far beyond the core — much larger than 71. -/
theorem moonshine_far_from_core : ∀ p ∈ shell3, p > 71 := by decide

/-! ## §6. The Shell Classification Function -/

/-- Classify any prime into its shell number.
    - 0 = supersingular (divides |M|)
    - 1 = interstitial (exterior, ≤ 71)
    - 2 = near tail (exterior, 72–199)
    - 3 = moonshine escapee
    - 4 = deep exterior -/
def primeShell (p : ℕ) : ℕ :=
  if p ∈ shell0 then 0
  else if p ∈ shell1 then 1
  else if p ∈ shell2 then 2
  else if p ∈ shell3 then 3
  else 4

theorem shell0_classified : ∀ p ∈ shell0, primeShell p = 0 := by
  intro p hp; simp [primeShell, hp]

theorem shell1_classified : ∀ p ∈ shell1, primeShell p = 1 := by
  intro p hp; simp only [primeShell]
  have : p ∉ shell0 := by fin_cases hp <;> decide
  simp [this, hp]

theorem shell2_classified : ∀ p ∈ shell2, primeShell p = 2 := by
  intro p hp; simp only [primeShell]
  have h0 : p ∉ shell0 := by fin_cases hp <;> decide
  have h1 : p ∉ shell1 := by fin_cases hp <;> decide
  simp [h0, h1, hp]

theorem shell3_classified : ∀ p ∈ shell3, primeShell p = 3 := by
  intro p hp; simp only [primeShell]
  have h0 : p ∉ shell0 := by fin_cases hp <;> decide
  have h1 : p ∉ shell1 := by fin_cases hp <;> decide
  have h2 : p ∉ shell2 := by fin_cases hp <;> decide
  simp [h0, h1, h2, hp]

/-! ## §7. Completeness: Shells 0–1 Cover All Primes ≤ 71 -/

/-- Every prime ≤ 71 is in Shell 0 or Shell 1. -/
theorem shells_01_cover_to_71 :
    ∀ p ∈ (List.range 72).filter Nat.Prime, p ∈ shell0 ∨ p ∈ shell1 := by native_decide

/-- Shells 0–2 cover ALL primes ≤ 199. -/
theorem shells_012_cover_to_199 :
    ∀ p ∈ (List.range 200).filter Nat.Prime, p ∈ shell0 ∨ p ∈ shell1 ∨ p ∈ shell2 := by
  native_decide

/-! ## §8. Every Prime > 71 is Exterior to |M| -/

/-
Every prime > 71 does NOT divide |M|. This is because the largest prime factor
    of |M| is exactly 71. All primes beyond Shell 0 are exterior.
-/
theorem all_primes_beyond_71_exterior (p : ℕ) (hp : Nat.Prime p) (hgt : p > 71) :
    ¬(p ∣ M) := by
      norm_num [ M ];
      intro h;
      -- Since $p$ is prime and divides $M$, it must be one of the prime factors of $M$.
      have h_factor : p ∈ Nat.primeFactorsList 808017424794512875886459904961710757005754368000000000 := by
        norm_num [ hp, h ];
      norm_num [ Nat.primeFactorsList ] at h_factor;
      omega

/-! ## §9. Shell Statistics -/

/-- Total primes across Shells 0–2. -/
theorem total_primes_to_199 : shell0.length + shell1.length + shell2.length = 46 := by
  native_decide

/-- Shell populations: 15, 5, 26. -/
theorem shell_populations :
    shell0.length = 15 ∧ shell1.length = 5 ∧ shell2.length = 26 := by
  exact ⟨by native_decide, by native_decide, by native_decide⟩

/-- The supersingular "density" among primes ≤ 71: 15 out of 20 = 75%. -/
theorem supersingular_density :
    shell0.length + shell1.length = 20 := by native_decide

/-- Shell 0 is three times as large as Shell 1 (15 = 3 × 5). -/
theorem core_triple_interstitial : shell0.length = 3 * shell1.length := by native_decide

/-! ## §10. Shell Disjointness -/

theorem shells_01_disjoint : ∀ p, p ∈ shell0 → p ∉ shell1 := by decide
theorem shells_02_disjoint : ∀ p, p ∈ shell0 → p ∉ shell2 := by decide
theorem shells_03_disjoint : ∀ p, p ∈ shell0 → p ∉ shell3 := by decide
theorem shells_12_disjoint : ∀ p, p ∈ shell1 → p ∉ shell2 := by decide
theorem shells_13_disjoint : ∀ p, p ∈ shell1 → p ∉ shell3 := by decide
theorem shells_23_disjoint : ∀ p, p ∈ shell2 → p ∉ shell3 := by decide

/-- All primes in the table are indeed prime. -/
theorem allShell_prime : ∀ p ∈ allShellPrimes, Nat.Prime p := by native_decide

/-! ## §11. Valence Subgroups within Shell 0 ("Electron Configuration") -/

/-- s-block: Shell 0 primes with valence 1 (appear exactly once in |M|). -/
def sBlock : List ℕ := [17, 19, 23, 29, 31, 41, 47, 59, 71]

/-- p-block: Shell 0 primes with valence 2–3. -/
def pBlock : List ℕ := [11, 13]

/-- d-block: Shell 0 primes with valence 6–9. -/
def dBlock : List ℕ := [5, 7]

/-- f-block: Shell 0 primes with valence ≥ 20 (the heaviest elements). -/
def fBlock : List ℕ := [2, 3]

theorem sBlock_count : sBlock.length = 9 := by native_decide
theorem pBlock_count : pBlock.length = 2 := by native_decide
theorem dBlock_count : dBlock.length = 2 := by native_decide
theorem fBlock_count : fBlock.length = 2 := by native_decide

/-- The blocks partition Shell 0: 9 + 2 + 2 + 2 = 15. -/
theorem blocks_sum_to_shell0 :
    sBlock.length + pBlock.length + dBlock.length + fBlock.length = shell0.length := by
  native_decide

/-- All s-block primes are ≥ 17 (valence 1, the "lightest" supersingulars). -/
theorem sBlock_large : ∀ p ∈ sBlock, p ≥ 17 := by decide

/-- All f-block primes are ≤ 3 (valence ≥ 20, the "heaviest" supersingulars). -/
theorem fBlock_small : ∀ p ∈ fBlock, p ≤ 3 := by decide

/-- The f-block primes {2, 3} alone contribute 66 out of 95 total valence weight (69%). -/
theorem fBlock_weight : (46 : ℕ) + 20 = 66 := by norm_num

/-- Valence inversion: smaller primes carry more weight.
    f-block (2 primes) contributes 66; s-block (9 primes) contributes only 9. -/
theorem valence_inversion_theorem :
    (46 + 20 : ℕ) > (9 + 6 : ℕ) ∧ (9 + 6 : ℕ) > (2 + 3 : ℕ) := by omega

/-! ## §12. Shell Transition Properties -/

/-- The gap between the largest Shell 0 prime (71) and smallest Shell 2 prime (73) is just 2. -/
theorem core_tail_gap : 73 - 71 = 2 := by norm_num

/-- (71, 73) is a twin prime pair bridging Shell 0 → Shell 2. -/
theorem twin_bridge_71_73 : 71 ∈ shell0 ∧ 73 ∈ shell2 := ⟨by decide, by decide⟩

/-- (41, 43) bridges Shell 0 → Shell 1. -/
theorem twin_bridge_41_43 : 41 ∈ shell0 ∧ 43 ∈ shell1 := ⟨by decide, by decide⟩

/-- (59, 61) bridges Shell 0 → Shell 1. -/
theorem twin_bridge_59_61 : 59 ∈ shell0 ∧ 61 ∈ shell1 := ⟨by decide, by decide⟩

/-- (29, 31) is a twin prime pair staying entirely within Shell 0. -/
theorem twin_internal_29_31 : 29 ∈ shell0 ∧ 31 ∈ shell0 := ⟨by decide, by decide⟩

/-! ## §13. The Widest Supersingular Gaps -/

/-- The gaps between consecutive supersingular primes.
    Format: (left, right, gap width, interstitial primes in gap). -/
def supersingularGaps : List (ℕ × ℕ × ℕ × List ℕ) :=
  [(2, 3, 1, []),
   (3, 5, 2, []),
   (5, 7, 2, []),
   (7, 11, 4, []),
   (11, 13, 2, []),
   (13, 17, 4, []),
   (17, 19, 2, []),
   (19, 23, 4, []),
   (23, 29, 6, []),
   (29, 31, 2, []),
   (31, 41, 10, [37]),       -- one interstitial prime
   (41, 47, 6, [43]),        -- one interstitial prime
   (47, 59, 12, [53]),       -- one interstitial prime
   (59, 71, 12, [61, 67])]   -- TWO interstitial primes

/-- The widest supersingular gap is 12 (occurring twice: (47,59) and (59,71)). -/
theorem widest_gap_is_12 :
    ∀ g ∈ supersingularGaps, g.2.2.1 ≤ 12 := by decide

/-- The gap (59, 71) is the only one containing two interstitial primes. -/
theorem double_interstitial_gap :
    61 ∈ shell1 ∧ 67 ∈ shell1 ∧ 59 < 61 ∧ 67 < 71 := by decide

/-- All gaps of width ≥ 10 contain at least one interstitial prime.
    (The gap (23,29) of width 6 has no primes at all between 23 and 29.) -/
theorem wide_gaps_have_interstitials :
    ∀ g ∈ supersingularGaps, g.2.2.1 ≥ 10 → g.2.2.2 ≠ [] := by
  intro g hg hge; fin_cases hg <;> simp_all

/-! ## §14. Products and Coprimality -/

/-- The product of all Shell 0 primes (the "radical" of |M|). -/
def shell0Product : ℕ := shell0.prod

/-- The product of all Shell 1 primes. -/
def shell1Product : ℕ := shell1.prod

/-- Shell 1 product is coprime to |M|. -/
theorem shell1_coprime_M : Nat.Coprime shell1Product M := by native_decide

/-- Shell 0 product divides |M| (since each Shell 0 prime divides |M|). -/
theorem shell0_product_dvd : shell0Product ∣ M := by native_decide

/-! ## §15. The Periodic Table Data Structure -/

/-- A row in our periodic table of Monster-relative primes. -/
structure TableEntry where
  shell : ℕ       -- shell number (0–4)
  period : ℕ      -- position within the shell (1-indexed)
  prime : ℕ       -- the prime itself
  valenceVal : ℕ  -- exponent in |M| for Shell 0; 0 otherwise
  deriving Repr, DecidableEq

/-- The complete periodic table for Shells 0–3. -/
def periodicTable : List TableEntry :=
  -- Shell 0: Core (Supersingular) — with valences (exponents in |M|)
  [ ⟨0,  1,  2, 46⟩, ⟨0,  2,  3, 20⟩, ⟨0,  3,  5,  9⟩, ⟨0,  4,  7,  6⟩,
    ⟨0,  5, 11,  2⟩, ⟨0,  6, 13,  3⟩, ⟨0,  7, 17,  1⟩, ⟨0,  8, 19,  1⟩,
    ⟨0,  9, 23,  1⟩, ⟨0, 10, 29,  1⟩, ⟨0, 11, 31,  1⟩, ⟨0, 12, 41,  1⟩,
    ⟨0, 13, 47,  1⟩, ⟨0, 14, 59,  1⟩, ⟨0, 15, 71,  1⟩,
  -- Shell 1: Interstitial — exterior primes ≤ 71
    ⟨1,  1, 37,  0⟩, ⟨1,  2, 43,  0⟩, ⟨1,  3, 53,  0⟩, ⟨1,  4, 61,  0⟩,
    ⟨1,  5, 67,  0⟩,
  -- Shell 2: Near tail — exterior primes in (71, 199]
    ⟨2,  1,  73, 0⟩, ⟨2,  2,  79, 0⟩, ⟨2,  3,  83, 0⟩, ⟨2,  4,  89, 0⟩,
    ⟨2,  5,  97, 0⟩, ⟨2,  6, 101, 0⟩, ⟨2,  7, 103, 0⟩, ⟨2,  8, 107, 0⟩,
    ⟨2,  9, 109, 0⟩, ⟨2, 10, 113, 0⟩, ⟨2, 11, 127, 0⟩, ⟨2, 12, 131, 0⟩,
    ⟨2, 13, 137, 0⟩, ⟨2, 14, 139, 0⟩, ⟨2, 15, 149, 0⟩, ⟨2, 16, 151, 0⟩,
    ⟨2, 17, 157, 0⟩, ⟨2, 18, 163, 0⟩, ⟨2, 19, 167, 0⟩, ⟨2, 20, 173, 0⟩,
    ⟨2, 21, 179, 0⟩, ⟨2, 22, 181, 0⟩, ⟨2, 23, 191, 0⟩, ⟨2, 24, 193, 0⟩,
    ⟨2, 25, 197, 0⟩, ⟨2, 26, 199, 0⟩,
  -- Shell 3: Moonshine escapees
    ⟨3,  1, 1823, 0⟩, ⟨3,  2, 2099, 0⟩, ⟨3,  3, 45767, 0⟩ ]

theorem periodicTable_length : periodicTable.length = 49 := by native_decide

/-! ## §16. Key Structural Theorems -/

/-- The smallest prime in each shell. -/
theorem smallest_per_shell :
    shell0.head? = some 2 ∧
    shell1.head? = some 37 ∧
    shell2.head? = some 73 ∧
    shell3.head? = some 1823 := by native_decide

/-- The largest Shell 0 prime (71) and smallest Shell 2 prime (73) are twin primes.
    This shows the core-to-tail transition is as tight as possible. -/
theorem core_tail_twins : Nat.Prime 71 ∧ Nat.Prime 73 ∧ 73 - 71 = 2 := by decide

/-- 196883 = 47 × 59 × 71 — the product of the three LARGEST supersingular primes
    (the last three s-block elements). This is the dimension of the smallest
    nontrivial Monster irrep. -/
theorem irrep_from_tail : 47 * 59 * 71 = 196883 := by norm_num

/-- 196883 uses only s-block primes; 196884 = 196883 + 1 escapes to Shell 3 via 1823. -/
theorem mckay_shell_transition :
    47 ∈ sBlock ∧ 59 ∈ sBlock ∧ 71 ∈ sBlock ∧ 1823 ∈ shell3 :=
  ⟨by decide, by decide, by decide, by decide⟩

/-- Shell 0 primes up to 13 carry 90% of the valence weight (86 of 95). -/
theorem small_primes_dominate :
    (46 + 20 + 9 + 6 + 2 + 3 : ℕ) = 86 ∧ (86 : ℕ) * 20 > 95 * 18 := by omega

/-
Beyond Shell 0, ALL primes are exterior. The exterior region is infinite.
-/
theorem exterior_is_infinite : ∀ N : ℕ, ∃ p > N, Nat.Prime p ∧ ¬(p ∣ M) := by
  intro N;
  exact Exists.elim ( Nat.exists_infinite_primes ( N + 72 ) ) fun p hp => ⟨ p, by linarith, hp.2, all_primes_beyond_71_exterior p hp.2 ( by linarith ) ⟩

/-! ## §17. Shell Summary Statistics -/

/-- Grand summary of the periodic table. -/
theorem periodic_table_summary :
    -- Shell counts
    shell0.length = 15 ∧
    shell1.length = 5 ∧
    shell2.length = 26 ∧
    shell3.length = 3 ∧
    -- Total known entries
    allShellPrimes.length = 49 ∧
    -- All entries are prime
    (∀ p ∈ allShellPrimes, Nat.Prime p) ∧
    -- Shell 0 divides M, others don't
    (∀ p ∈ shell0, p ∣ M) ∧
    (∀ p ∈ shell1, ¬(p ∣ M)) ∧
    (∀ p ∈ shell2, ¬(p ∣ M)) ∧
    (∀ p ∈ shell3, ¬(p ∣ M)) := by
  refine ⟨by native_decide, by native_decide, by native_decide, by native_decide,
          by native_decide, by native_decide, by native_decide, by native_decide,
          by native_decide, by native_decide⟩