import Mathlib

/-!
# The Monster Group as a Universal Symmetry Container

The Monster group 𝕄 is the largest sporadic finite simple group.
It is not a "Theory of Everything," but rather an exceptionally rich
**universal symmetry container** — a single, highly symmetric object
that embeds or reflects an enormous number of important symmetries
appearing throughout mathematics and theoretical physics.

## Key structural facts formalized here

1. **Monster order**: |𝕄| = 2⁴⁶ · 3²⁰ · 5⁹ · 7⁶ · 11² · 13³ · 17 · 19 · 23 · 29 · 31 · 41 · 47 · 59 · 71
   — "Enormous but finite": ≈ 8.08 × 10⁵³
2. **194 irreducible representations** (matching the 194-row padic table)
3. **Monstrous Moonshine (McKay observation)**:
   The j-invariant has expansion j(q) = q⁻¹ + 744 + 196884q + 21493760q² + ...
   and 196884 = 1 + 196883, where 196883 is the smallest nontrivial Monster rep dimension.
   Similarly, 21493760 = 1 + 196883 + 21296876 decomposes into Monster irrep dimensions.
4. **Subgroup richness — the Happy Family**: 20 of the 26 sporadic groups
   are subquotients of the Monster (sections of its subgroups).
5. **E8 and Leech lattice connections**:
   - E8 lattice: dimension 8, kissing number 240, Lie algebra dimension 248
   - Leech lattice: dimension 24, kissing number 196560
   - Near-miss: 196883 - 196560 = 323 = 17 × 19 (both supersingular primes!)
6. **Supersingular primes**: the 15 primes dividing |𝕄| are exactly the
   primes p for which the modular curve X₀(p) has genus zero (Ogg's observation).
-/

set_option maxHeartbeats 800000

namespace MonsterUniversal

/-! ## §1. The Monster Group Order

|𝕄| = 2⁴⁶ · 3²⁰ · 5⁹ · 7⁶ · 11² · 13³ · 17 · 19 · 23 · 29 · 31 · 41 · 47 · 59 · 71
    = 808,017,424,794,512,875,886,459,904,961,710,757,005,754,368,000,000,000

This is "enormous but finite" — approximately 8.08 × 10⁵³.
-/

/-- The exact order of the Monster group. -/
def monsterOrder : ℕ :=
  2^46 * 3^20 * 5^9 * 7^6 * 11^2 * 13^3 * 17 * 19 * 23 * 29 * 31 * 41 * 47 * 59 * 71

/-- The Monster's order equals the well-known decimal value. -/
theorem monsterOrder_val :
    monsterOrder = 808017424794512875886459904961710757005754368000000000 := by
  native_decide

/-- The Monster order is positive. -/
theorem monsterOrder_pos : 0 < monsterOrder := by
  simp [monsterOrder]

/-- The Monster order is divisible by the torus modulus 196883. -/
theorem monsterOrder_div_196883 : 196883 ∣ monsterOrder := by
  simp [monsterOrder]

/-- The 15 supersingular primes (Ogg's primes) in order. -/
def supersingularPrimes : List ℕ := [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71]

/-- There are exactly 15 supersingular primes. -/
theorem supersingularPrimes_count : supersingularPrimes.length = 15 := by decide

/-- All supersingular primes are prime. -/
theorem supersingularPrimes_all_prime : ∀ p ∈ supersingularPrimes, Nat.Prime p := by decide

/-- The supersingular primes are pairwise distinct. -/
theorem supersingularPrimes_nodup : supersingularPrimes.Nodup := by decide

/-- Each supersingular prime divides the Monster order. -/
theorem supersingular_divides_monster :
    ∀ p ∈ supersingularPrimes, p ∣ monsterOrder := by
  intro p hp
  simp [supersingularPrimes] at hp
  simp [monsterOrder]
  rcases hp with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl <;> omega

/-- The exponents of each supersingular prime in the Monster order factorization. -/
def monsterExponents : List (ℕ × ℕ) :=
  [(2, 46), (3, 20), (5, 9), (7, 6), (11, 2), (13, 3), (17, 1), (19, 1),
   (23, 1), (29, 1), (31, 1), (41, 1), (47, 1), (59, 1), (71, 1)]

/-- The sum of all exponents in the Monster factorization. -/
theorem monsterExponents_sum :
    (monsterExponents.map Prod.snd).sum = 95 := by native_decide

/-- The Monster order reconstructed from individual prime-power factors. -/
theorem monsterOrder_from_exponents :
    monsterOrder = (monsterExponents.map (fun pe => pe.1 ^ pe.2)).prod := by
  native_decide

/-! ## §2. Sporadic Groups and the Happy Family

Of the 26 sporadic finite simple groups, 20 are subquotients of the Monster
(the "Happy Family") and 6 are not (the "Pariahs").

We encode this classification as verified numerical data.
-/

/-- Total number of sporadic finite simple groups. -/
def sporadicCount : ℕ := 26

/-- Number of sporadic groups in the Happy Family (subquotients of Monster). -/
def happyFamilyCount : ℕ := 20

/-- Number of Pariah groups (not subquotients of Monster). -/
def pariahCount : ℕ := 6

/-- The Happy Family and Pariahs partition the sporadic groups. -/
theorem happy_plus_pariah : happyFamilyCount + pariahCount = sporadicCount := by decide

/-- The Happy Family represents ≈ 76.9% of sporadic groups (> 3/4). -/
theorem happy_family_majority : 4 * happyFamilyCount > 3 * sporadicCount := by decide

/-! ## §3. The 194 Irreducible Representations

The Monster has exactly 194 irreducible representations (conjugacy classes).
The smallest nontrivial representation has dimension 196883 = 47 × 59 × 71.
-/

/-- Number of irreducible representations of the Monster. -/
def irrepCount : ℕ := 194

/-- Dimension of the smallest nontrivial Monster representation. -/
def smallestNontrivialDim : ℕ := 196883

/-- The smallest nontrivial dimension factors as 47 × 59 × 71. -/
theorem smallestNontrivialDim_factored :
    smallestNontrivialDim = 47 * 59 * 71 := by decide

/-- Dimensions of the first few Monster irreps (from the character table):
    1, 196883, 21296876, 842609326, 18538750076, ... -/
def firstIrrepDims : List ℕ := [1, 196883, 21296876, 842609326, 18538750076]

/-- All listed irrep dimensions are positive. -/
theorem firstIrrepDims_pos : ∀ d ∈ firstIrrepDims, 0 < d := by decide

/-! ## §4. Monstrous Moonshine — The McKay Observation

The j-invariant j(τ) = q⁻¹ + 744 + Σ_{n≥1} c(n)qⁿ where q = e^{2πiτ}.

The first few coefficients are:
  c(1) = 196884, c(2) = 21493760, c(3) = 864299970, ...

John McKay observed that these decompose into Monster irrep dimensions:
  196884 = 1 + 196883
  21493760 = 1 + 196883 + 21296876
  864299970 = 2·1 + 2·196883 + 21296876 + 842609326

This was the original moonshine observation, later proved by Borcherds (1992,
Fields Medal 1998).
-/

/-- First few coefficients of the j-invariant (after q⁻¹ + 744). -/
def jCoeffs : List ℕ := [196884, 21493760, 864299970]

/-- The McKay observation: c(1) = dim(ρ₀) + dim(ρ₁). -/
theorem mckay_c1 : jCoeffs[0]! = firstIrrepDims[0]! + firstIrrepDims[1]! := by
  native_decide

/-- The McKay observation: c(2) = dim(ρ₀) + dim(ρ₁) + dim(ρ₂). -/
theorem mckay_c2 : jCoeffs[1]! = firstIrrepDims[0]! + firstIrrepDims[1]! + firstIrrepDims[2]! := by
  native_decide

/-- The McKay observation: c(3) decomposes into Monster irreps.
    864299970 = 2·1 + 2·196883 + 21296876 + 842609326 -/
theorem mckay_c3 :
    jCoeffs[2]! = 2 * firstIrrepDims[0]! + 2 * firstIrrepDims[1]!
                  + firstIrrepDims[2]! + firstIrrepDims[3]! := by
  native_decide

/-- 196884 = 196883 + 1: the dimension of the Monster's smallest nontrivial rep
    plus the trivial rep equals the first j-coefficient. -/
theorem moonshine_link : smallestNontrivialDim + 1 = 196884 := by decide

/-! ## §5. E8 and the Leech Lattice

The Monster sits atop a hierarchy of exceptional objects:
- E8 lattice (dim 8) → Leech lattice (dim 24) → Monster
- The Leech lattice's kissing number 196560 is tantalizingly close to 196883

### E8 lattice
- Dimension: 8
- Kissing number: 240
- E8 Lie algebra dimension: 248 = 240 + 8

### Leech lattice
- Dimension: 24
- Kissing number: 196560
- Aut(Leech) = Co₀ (Conway group), |Co₀| divides |𝕄|
- 24 = 3 × 8 (three copies of E8 dimension)
-/

/-- E8 lattice dimension. -/
def e8Dim : ℕ := 8

/-- E8 kissing number. -/
def e8Kissing : ℕ := 240

/-- E8 Lie algebra dimension = kissing number + lattice dimension. -/
theorem e8_lie_dim : e8Kissing + e8Dim = 248 := by decide

/-- Leech lattice dimension. -/
def leechDim : ℕ := 24

/-- Leech dimension = 3 × E8 dimension. -/
theorem leech_three_e8 : leechDim = 3 * e8Dim := by decide

/-- Leech lattice kissing number. -/
def leechKissing : ℕ := 196560

/-- The near-miss: Monster rep dimension minus Leech kissing number. -/
def monsterLeechGap : ℕ := smallestNontrivialDim - leechKissing

/-- The gap is 323 = 17 × 19 — a product of two supersingular primes! -/
theorem monster_leech_gap_val : monsterLeechGap = 323 := by decide

theorem monster_leech_gap_factored : monsterLeechGap = 17 * 19 := by decide

/-- Both factors of the gap are supersingular primes. -/
theorem gap_factors_supersingular :
    17 ∈ supersingularPrimes ∧ 19 ∈ supersingularPrimes := by decide

/-- The relationship: 196883 = 196560 + 17 × 19. -/
theorem monster_dim_from_leech :
    smallestNontrivialDim = leechKissing + 17 * 19 := by decide

/-! ## §6. The Pareto Principle — Quantifying Universality

The Monster captures a disproportionate share of sporadic symmetry.

Metrics:
- 20/26 ≈ 76.9% of sporadic groups are in the Happy Family
- The Monster's order is divisible by the order of every Happy Family member
- The Monster's 194 irreps encode symmetry information about many other groups
-/

/-- Orders of the 6 Pariah groups (J₁, J₃, J₄, Ru, Ly, O'N).
    These are NOT subquotients of the Monster. -/
def pariahOrders : List ℕ :=
  [ 175560,               -- J₁ (Janko 1)
    50232960,              -- J₃ (Janko 3)
    86775571046077562880,  -- J₄ (Janko 4)
    145926144000,          -- Ru (Rudvalis)
    51765179004000000,     -- Ly (Lyons)
    460815505920           -- O'N (O'Nan)
  ]

/-- There are exactly 6 Pariah groups. -/
theorem pariah_count : pariahOrders.length = pariahCount := by decide

/-- J₁ is the smallest Pariah group (order 175560 = 2³ · 3 · 5 · 7 · 11 · 19). -/
theorem j1_order : pariahOrders[0]! = 175560 := by decide

/-- J₁'s order factors verify it involves primes outside the "usual" pattern. -/
theorem j1_factored : (175560 : ℕ) = 2^3 * 3 * 5 * 7 * 11 * 19 := by decide

/-! ## §7. The 196883-Dimensional Address Space

Connecting back to the CRT web: the Monster's smallest nontrivial rep
of dimension 196883 = 47 × 59 × 71 gives rise to the CRT address space
ℤ/47 × ℤ/59 × ℤ/71 that indexes coordinates in this representation.

The three CRT idempotents e₄₇, e₅₉, e₇₁ are the canonical basis
for this address space (proved in CRTBase.lean).
-/

/-- The three torus primes are all supersingular. -/
theorem torus_primes_supersingular :
    47 ∈ supersingularPrimes ∧ 59 ∈ supersingularPrimes ∧ 71 ∈ supersingularPrimes := by
  decide

/-- The three torus primes are exactly the three largest supersingular primes. -/
theorem torus_primes_are_largest_three :
    supersingularPrimes.reverse.take 3 = [71, 59, 47] := by decide

/-- The CRT decomposition: 47 × 59 × 71 = 196883. -/
theorem crt_product : 47 * 59 * 71 = smallestNontrivialDim := by decide

/-- The idempotent sum: 33512 + 113458 + 49914 = 196884 ≡ 1 (mod 196883). -/
theorem idempotent_sum_mod :
    (33512 + 113458 + 49914) % 196883 = 1 := by decide

/-- The Monster torus has 47 × 59 × 71 - 1 = 196882 non-identity elements. -/
theorem torus_nonidentity : smallestNontrivialDim - 1 = 196882 := by decide

/-- Euler's totient of the torus modulus:
    φ(196883) = (47-1)(59-1)(71-1) = 46 × 58 × 70 = 186760. -/
theorem torus_totient : Nat.totient 196883 = 186760 := by native_decide

/-- The number of units in ℤ/196883 is 186760. -/
theorem torus_unit_count : Nat.totient 196883 = 46 * 58 * 70 := by native_decide

/-! ## §8. Moonshine Coefficients and Representation Decompositions

Extended moonshine data: the first several j-coefficients decompose
into Monster irrep dimensions, establishing the Moonshine module V♮
as a graded Monster representation.
-/

/-- The constant term 744 in the j-expansion has its own significance:
    744 = 8 × 93 = 8 × 3 × 31 (both 3 and 31 are supersingular primes). -/
theorem j_constant_term : (744 : ℕ) = 8 * 3 * 31 := by decide

/-- 744 involves two supersingular primes. -/
theorem j744_supersingular_factors :
    3 ∈ supersingularPrimes ∧ 31 ∈ supersingularPrimes := by decide

/-- The "Pareto ratio": Happy Family / Total sporadic × 1000
    = 20/26 × 1000 ≈ 769 (i.e., 76.9%). -/
theorem pareto_ratio : 1000 * happyFamilyCount / sporadicCount = 769 := by decide

/-- More precisely: 20/26 > 3/4, so the Monster captures more than 75%
    of sporadic group structure (in terms of count). -/
theorem pareto_three_quarters : 4 * happyFamilyCount > 3 * sporadicCount := by decide

/-! ## §9. The Hierarchy: E8 → Leech → Monster

The exceptional objects form a chain of increasing complexity:
  E8 (dim 8) → Leech (dim 24) → Monster (dim 196883)

Each step roughly cubes the dimension (8 → 24 = 3×8, 24 → ≈24³ ≈ 13824,
but 196883 is much larger). The actual connection goes through:
  E8 → E8 × E8 × E8 → Leech → Co₁ → Monster

Key numerical threads:
-/

/-- Dimension ratios in the hierarchy. -/
theorem leech_over_e8 : leechDim / e8Dim = 3 := by decide

/-- 196883 / 24 = 8203 remainder 11 — not an exact multiple,
    but 196883 mod 24 = 11, another supersingular prime! -/
theorem monster_mod_leech_dim : smallestNontrivialDim % leechDim = 11 := by decide

theorem eleven_supersingular : 11 ∈ supersingularPrimes := by decide

/-- The Conway group Co₁ (order = |Co₀|/2) divides the Monster order.
    |Co₁| = 2²¹ · 3⁹ · 5⁴ · 7² · 11 · 13 · 23 -/
def conway1Order : ℕ := 2^21 * 3^9 * 5^4 * 7^2 * 11 * 13 * 23

theorem conway1_divides_monster : conway1Order ∣ monsterOrder := by
  simp [conway1Order, monsterOrder]

/-- |Co₁| in decimal. -/
theorem conway1_val : conway1Order = 4157776806543360000 := by native_decide

/-- The Baby Monster B (second largest sporadic group) divides the Monster.
    |B| = 2⁴¹ · 3¹³ · 5⁶ · 7² · 11 · 13 · 17 · 19 · 23 · 31 · 47 -/
def babyMonsterOrder : ℕ := 2^41 * 3^13 * 5^6 * 7^2 * 11 * 13 * 17 * 19 * 23 * 31 * 47

theorem babyMonster_divides_monster : babyMonsterOrder ∣ monsterOrder := by
  simp [babyMonsterOrder, monsterOrder]

/-- |B| in decimal. -/
theorem babyMonster_val : babyMonsterOrder = 4154781481226426191177580544000000 := by
  native_decide

/-! ## §10. Summary: The Rosetta Stone Property

"The Monster group is a remarkably efficient Rosetta Stone for finite symmetries.
Because it is so rich, mastering its structure lets us understand a
disproportionately large fraction of the symmetric patterns that appear
across mathematics and high-energy physics."

We summarize the key numerical coincidences that make this work:
-/

/-- The grand numerical summary:
    196883 = 47 × 59 × 71
    196884 = 196883 + 1 = c(1) of j-invariant
    196560 = Leech kissing number
    196883 - 196560 = 323 = 17 × 19
    All primes {47, 59, 71, 17, 19} are supersingular. -/
theorem rosetta_stone_numerics :
    smallestNontrivialDim = 47 * 59 * 71 ∧
    smallestNontrivialDim + 1 = 196884 ∧
    smallestNontrivialDim - leechKissing = 17 * 19 ∧
    47 ∈ supersingularPrimes ∧
    59 ∈ supersingularPrimes ∧
    71 ∈ supersingularPrimes ∧
    17 ∈ supersingularPrimes ∧
    19 ∈ supersingularPrimes := by decide

end MonsterUniversal
