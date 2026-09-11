/-
# MonsterScale — The Monster Group Order and Prime Universe at Scale

Formalizes the Monster group order |𝕄| and the prime universe at Monster scale:
1. The Monster group order M = 2⁴⁶·3²⁰·5⁹·7⁶·11²·13³·17·19·23·29·31·41·47·59·71
2. The 15 "Monster primes" (= supersingular primes = prime divisors of M)
3. Prime universe primeUniverse(B) for arbitrary bound B
4. Partition into Monster-relevant vs Monster-irrelevant primes
5. The MonsterExp exponent vector — divisor universe of M (~212M divisors)
6. 2-adic stratification: 47 groups indexed by v₂
7. Overlapping interval blocks with primes as multi-block bridge points
8. Connection to GateScan's S₉ sequence

Key structural insight (the "200 MB blocks" idea):
The ~212 million divisors of M organize into 47 "v₂-layers".
Slicing the divisor spectrum into overlapping intervals, primes
naturally sit in the overlaps — they become "bridge points" between
adjacent blocks.  Each prime gets a block membership profile
  blocks(p) := { i | p ∈ Iᵢ }
and primes in multiple blocks are structural bridges.

From: "The Calculus of Myth: Formalizing the Hero's Journey
       through Quasifibration Narrative Vectors"
-/
import Mathlib
import RequestProject.Bridge.GateScan

set_option maxHeartbeats 1600000
set_option maxRecDepth 1000

open OntologyPrimes GateScan

namespace MonsterScale

-- ============================================================
-- §1  The Monster Group Order
-- ============================================================

/-- The order of the Monster group, the largest sporadic simple group.
    |𝕄| = 2⁴⁶·3²⁰·5⁹·7⁶·11²·13³·17·19·23·29·31·41·47·59·71
    ≈ 8.08 × 10⁵³ -/
def monsterOrder : ℕ :=
  2^46 * 3^20 * 5^9 * 7^6 * 11^2 * 13^3 * 17 * 19 * 23 * 29 * 31 * 41 * 47 * 59 * 71

/-- The odd part of the Monster order (remove all factors of 2). -/
def monsterOddPart : ℕ :=
  3^20 * 5^9 * 7^6 * 11^2 * 13^3 * 17 * 19 * 23 * 29 * 31 * 41 * 47 * 59 * 71

theorem monsterOrder_eq : monsterOrder = 2^46 * monsterOddPart := by
  native_decide

/-- The "radical": product of distinct prime factors (~6.1 × 10¹⁷). -/
def monsterRadical : ℕ := 2 * 3 * 5 * 7 * 11 * 13 * 17 * 19 * 23 * 29 * 31 * 41 * 47 * 59 * 71

theorem monsterRadical_value : monsterRadical = 1618964990108856390 := by
  native_decide

-- ============================================================
-- §2  The 15 Monster Primes
-- ============================================================

/-- The complete list of primes dividing |𝕄|. These are exactly the
    15 supersingular primes. -/
def monsterPrimeList : List ℕ :=
  [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71]

/-- A prime is "Monster-relevant" if it divides |𝕄|. -/
def isMonsterPrime (p : ℕ) : Prop := Nat.Prime p ∧ p ∣ monsterOrder

instance (p : ℕ) : Decidable (isMonsterPrime p) :=
  inferInstanceAs (Decidable (Nat.Prime p ∧ p ∣ monsterOrder))

-- ============================================================
-- §3  Forward Direction: Each Listed Prime Divides |𝕄|
-- ============================================================

/-- Every prime in monsterPrimeList is prime and divides monsterOrder. -/
theorem monsterPrime_of_mem :
    ∀ p ∈ monsterPrimeList, isMonsterPrime p := by native_decide

-- ============================================================
-- §4  Reverse Direction: Prime Divisors of |𝕄| Are in the List
-- ============================================================

/-- Helper: if p is prime and p divides q^e * n where q is prime,
    then p = q or p ∣ n. -/
theorem prime_dvd_prime_pow_mul {p q : ℕ} {e n : ℕ}
    (hp : Nat.Prime p) (hq : Nat.Prime q) (h : p ∣ q ^ e * n) :
    p = q ∨ p ∣ n := by
  rcases hp.dvd_mul.mp h with h1 | h2
  · left
    have h3 := hp.prime.dvd_of_dvd_pow h1
    exact (hq.eq_one_or_self_of_dvd p h3).resolve_left hp.one_lt.ne'
  · exact Or.inr h2

/-
Every prime divisor of monsterOrder is in monsterPrimeList.
-/
theorem mem_of_monsterPrime {p : ℕ} (h : isMonsterPrime p) :
    p ∈ monsterPrimeList := by
  have h_div : p ∣ monsterOrder := h.right;
  have h_prime_factors : p ∈ Nat.primeFactorsList monsterOrder := by
    simp +zetaDelta at *;
    exact ⟨ h.1, h_div, by native_decide ⟩;
  norm_num [ Nat.primeFactorsList ] at h_prime_factors;
  have h_prime_factors : p ∈ Nat.primeFactorsList (2^46 * 3^20 * 5^9 * 7^6 * 11^2 * 13^3 * 17 * 19 * 23 * 29 * 31 * 41 * 47 * 59 * 71) := by
    exact Nat.mem_primeFactorsList h_prime_factors.2.2 |>.2 ⟨ h_prime_factors.1, h_prime_factors.2.1 ⟩;
  norm_num [ Nat.primeFactorsList ] at h_prime_factors;
  rcases h_prime_factors with ( rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl ) <;> trivial

/-- **The complete characterization**: Monster primes ↔ list membership. -/
theorem monsterPrime_iff (p : ℕ) :
    isMonsterPrime p ↔ p ∈ monsterPrimeList :=
  ⟨mem_of_monsterPrime, fun hmem => monsterPrime_of_mem p hmem⟩

-- ============================================================
-- §5  Connection to S₉: Monster Primes = Supersingular Primes
-- ============================================================

theorem monsterPrimes_eq_supersingular : monsterPrimeList = GateScan.sspList := rfl
theorem monsterPrimes_eq_ontology : monsterPrimeList = OntologyPrimes.supersingularPrimes := rfl

-- ============================================================
-- §6  Prime Universe and Partition
-- ============================================================

def primeUniverse (B : ℕ) : Set ℕ := {p | Nat.Prime p ∧ p < B}

def monsterRelevantPrime (p : ℕ) : Prop := Nat.Prime p ∧ p ∣ monsterOrder
def monsterIrrelevantPrime (p : ℕ) : Prop := Nat.Prime p ∧ ¬ p ∣ monsterOrder

/-- **Partition theorem**: every prime is either Monster-relevant or -irrelevant. -/
theorem prime_partition_monster (B : ℕ) :
    ∀ {p}, Nat.Prime p → p < B →
      monsterRelevantPrime p ∨ monsterIrrelevantPrime p := by
  intro p hp _hB
  by_cases h : p ∣ monsterOrder
  · exact Or.inl ⟨hp, h⟩
  · exact Or.inr ⟨hp, h⟩

theorem largest_monster_prime : ∀ p ∈ monsterPrimeList, p ≤ 71 := by decide

-- ============================================================
-- §7  Concrete Bounds
-- ============================================================

theorem monsterRelevant_below_512 :
    ((List.range 512).filter (fun p => Nat.Prime p && (p ∣ monsterOrder))).length = 15 := by
  native_decide

theorem monsterIrrelevant_below_512 :
    ((List.range 512).filter (fun p => Nat.Prime p && !(p ∣ monsterOrder))).length = 82 := by
  native_decide

-- ============================================================
-- §8  The Monster Exponent Vector
-- ============================================================

/-- An exponent vector for a divisor of |𝕄|.
    There are 47 × 21 × 10 × 7 × 3 × 4 × 2⁸ = 212,244,480 such vectors. -/
structure MonsterExp where
  e2  : Fin 47
  e3  : Fin 21
  e5  : Fin 10
  e7  : Fin 7
  e11 : Fin 3
  e13 : Fin 4
  e17 : Fin 2
  e19 : Fin 2
  e23 : Fin 2
  e29 : Fin 2
  e31 : Fin 2
  e41 : Fin 2
  e47 : Fin 2
  e59 : Fin 2
  e71 : Fin 2
  deriving DecidableEq, Repr

/-- Convert an exponent vector to the corresponding divisor. -/
def MonsterExp.toNat (e : MonsterExp) : ℕ :=
  2^e.e2.val * 3^e.e3.val * 5^e.e5.val * 7^e.e7.val *
  11^e.e11.val * 13^e.e13.val * 17^e.e17.val * 19^e.e19.val *
  23^e.e23.val * 29^e.e29.val * 31^e.e31.val * 41^e.e41.val *
  47^e.e47.val * 59^e.e59.val * 71^e.e71.val

/-
Every MonsterExp gives a divisor of monsterOrder.
-/
theorem MonsterExp.toNat_dvd (e : MonsterExp) : e.toNat ∣ monsterOrder := by
  exact dvd_trans ( Nat.mul_dvd_mul ( Nat.mul_dvd_mul ( Nat.mul_dvd_mul ( Nat.mul_dvd_mul ( Nat.mul_dvd_mul ( Nat.mul_dvd_mul ( Nat.mul_dvd_mul ( Nat.mul_dvd_mul ( Nat.mul_dvd_mul ( Nat.mul_dvd_mul ( Nat.mul_dvd_mul ( Nat.mul_dvd_mul ( Nat.mul_dvd_mul ( Nat.mul_dvd_mul ( pow_dvd_pow _ <| Fin.is_le _ ) <| pow_dvd_pow _ <| Fin.is_le _ ) <| pow_dvd_pow _ <| Fin.is_le _ ) <| pow_dvd_pow _ <| Fin.is_le _ ) <| pow_dvd_pow _ <| Fin.is_le _ ) <| pow_dvd_pow _ <| Fin.is_le _ ) <| pow_dvd_pow _ <| Fin.is_le _ ) <| pow_dvd_pow _ <| Fin.is_le _ ) <| pow_dvd_pow _ <| Fin.is_le _ ) <| pow_dvd_pow _ <| Fin.is_le _ ) <| pow_dvd_pow _ <| Fin.is_le _ ) <| pow_dvd_pow _ <| Fin.is_le _ ) <| pow_dvd_pow _ <| Fin.is_le _ ) <| pow_dvd_pow _ <| Fin.is_le _ ) <| pow_dvd_pow _ <| Fin.is_le _ ) <| by decide;

def MonsterExp.one : MonsterExp where
  e2 := 0; e3 := 0; e5 := 0; e7 := 0; e11 := 0; e13 := 0; e17 := 0
  e19 := 0; e23 := 0; e29 := 0; e31 := 0; e41 := 0; e47 := 0; e59 := 0; e71 := 0

theorem MonsterExp.one_toNat : MonsterExp.one.toNat = 1 := by
  simp [MonsterExp.one, MonsterExp.toNat]

def MonsterExp.max : MonsterExp where
  e2 := ⟨46, by omega⟩; e3 := ⟨20, by omega⟩; e5 := ⟨9, by omega⟩
  e7 := ⟨6, by omega⟩; e11 := ⟨2, by omega⟩; e13 := ⟨3, by omega⟩
  e17 := ⟨1, by omega⟩; e19 := ⟨1, by omega⟩; e23 := ⟨1, by omega⟩
  e29 := ⟨1, by omega⟩; e31 := ⟨1, by omega⟩; e41 := ⟨1, by omega⟩
  e47 := ⟨1, by omega⟩; e59 := ⟨1, by omega⟩; e71 := ⟨1, by omega⟩

theorem MonsterExp.max_toNat : MonsterExp.max.toNat = monsterOrder := by
  simp [MonsterExp.max, MonsterExp.toNat, monsterOrder]

-- ============================================================
-- §9  Divisor Count
-- ============================================================

def monsterDivisorCount : ℕ := 47 * 21 * 10 * 7 * 3 * 4 * 2^8

theorem monsterDivisorCount_value : monsterDivisorCount = 212244480 := by
  unfold monsterDivisorCount; norm_num

-- ============================================================
-- §10  2-Adic Stratification: 47 Layers
-- ============================================================

def MonsterExp.v2 (e : MonsterExp) : Fin 47 := e.e2

/-- The odd part of a MonsterExp as a natural number. -/
def MonsterExp.oddPart (e : MonsterExp) : ℕ :=
  3^e.e3.val * 5^e.e5.val * 7^e.e7.val *
  11^e.e11.val * 13^e.e13.val * 17^e.e17.val * 19^e.e19.val *
  23^e.e23.val * 29^e.e29.val * 31^e.e31.val * 41^e.e41.val *
  47^e.e47.val * 59^e.e59.val * 71^e.e71.val

theorem MonsterExp.toNat_eq_v2_mul_odd (e : MonsterExp) :
    e.toNat = 2^e.v2.val * e.oddPart := by
  simp only [MonsterExp.toNat, MonsterExp.v2, MonsterExp.oddPart]; ring

/-- Number of odd divisors of |𝕄| = 21 × 10 × 7 × 3 × 4 × 2⁸ = 4,515,840. -/
def oddDivisorCount : ℕ := 21 * 10 * 7 * 3 * 4 * 2^8

theorem oddDivisorCount_value : oddDivisorCount = 4515840 := by
  unfold oddDivisorCount; norm_num

theorem v2_layer_size : monsterDivisorCount = 47 * oddDivisorCount := by
  unfold monsterDivisorCount oddDivisorCount; norm_num

-- ============================================================
-- §11  Overlapping Interval Blocks
-- ============================================================

/-- An interval block [lo, hi]. -/
structure IntervalBlock where
  lo : ℕ
  hi : ℕ
  valid : lo ≤ hi

def IntervalBlock.contains (I : IntervalBlock) (p : ℕ) : Bool := I.lo ≤ p && p ≤ I.hi

/-- The block membership profile: which block indices contain p. -/
def blocksForValue (p : ℕ) (blocks : List IntervalBlock) : List ℕ :=
  (List.range blocks.length).filter (fun i =>
    match blocks[i]? with
    | some I => I.contains p
    | none => false)

/-- A number is a k-bridge if it lies in exactly k blocks. -/
def isKBridge (p : ℕ) (blocks : List IntervalBlock) (k : ℕ) : Prop :=
  (blocksForValue p blocks).length = k

/-- A number is a boundary marker between blocks i and i+1
    if it lies in both but not deeper. -/
def isBoundaryMarker (p : ℕ) (blocks : List IntervalBlock) (i : ℕ) : Bool :=
  match blocks[i]?, blocks[i+1]? with
  | some I, some J => I.contains p && J.contains p
  | _, _ => false

-- ============================================================
-- §12  The 46 v₂-Scaled Blocks
-- ============================================================

/-- v₂-scaled block i covers [2^i, 2^(i+1) · monsterOddPart].
    Adjacent blocks overlap because block i's upper end (2^(i+1) · oddPart)
    far exceeds block (i+1)'s lower end (2^(i+1)). -/
def v2BlockBounds (i : ℕ) : ℕ × ℕ := (2^i, 2^(i + 1) * monsterOddPart)

/-- Adjacent v₂-blocks always overlap: the upper end of block i
    exceeds the lower end of block i+1 since monsterOddPart > 1. -/
theorem v2_blocks_overlap (i : ℕ) (_hi : i < 45) :
    (v2BlockBounds i).2 ≥ (v2BlockBounds (i + 1)).1 := by
  simp only [v2BlockBounds]
  -- Need: 2^(i+1) * monsterOddPart ≥ 2^(i+1)
  -- i.e. monsterOddPart ≥ 1
  apply Nat.le_mul_of_pos_right (2 ^ (i + 1))
  unfold monsterOddPart; positivity

-- ============================================================
-- §13  Prime Threading Through Fiber Chains
-- ============================================================

/-- A prime p "threads" a fiber chain with odd part d at position k
    if 2^k · d < p < 2^(k+1) · d. -/
def threadsChainAt (p d : ℕ) (k : Fin 46) : Prop :=
  2^k.val * d < p ∧ p < 2^(k.val + 1) * d

/-- Two chains "overlap on" a prime if p threads both. -/
def chainsOverlapOn (p d1 d2 : ℕ) : Prop :=
  d1 ≠ d2 ∧
  (∃ k1 : Fin 46, threadsChainAt p d1 k1) ∧
  (∃ k2 : Fin 46, threadsChainAt p d2 k2)

/-- Prime 3 threads the d=1 chain at k=1: 2 < 3 < 4. -/
theorem prime3_threads_unit : threadsChainAt 3 1 ⟨1, by omega⟩ := by
  unfold threadsChainAt; norm_num

/-- Prime 5 threads the d=1 chain at k=2: 4 < 5 < 8. -/
theorem prime5_threads_unit : threadsChainAt 5 1 ⟨2, by omega⟩ := by
  unfold threadsChainAt; norm_num

/-- Prime 43 threads d=1 at k=5: 32 < 43 < 64. -/
theorem prime43_threads_unit : threadsChainAt 43 1 ⟨5, by omega⟩ := by
  unfold threadsChainAt; norm_num

/-- Prime 43 also threads d=3 at k=3: 24 < 43 < 48. -/
theorem prime43_threads_3 : threadsChainAt 43 3 ⟨3, by omega⟩ := by
  unfold threadsChainAt; norm_num

/-- Chains d=1 and d=3 overlap on prime 43. -/
theorem chains_overlap_on_43 : chainsOverlapOn 43 1 3 :=
  ⟨by omega, ⟨⟨5, by omega⟩, prime43_threads_unit⟩, ⟨⟨3, by omega⟩, prime43_threads_3⟩⟩

-- ============================================================
-- §14  The 2D Prime Index
-- ============================================================

/-- For each prime p, its block profile records which v₂-blocks contain it.
    Small primes have wide profiles (fit in many low blocks).
    Large primes fit only in high blocks. -/
def computeBlockProfile (p : ℕ) (numBlocks : ℕ := 46) : List ℕ :=
  (List.range numBlocks).filter (fun i =>
    2^i ≤ p && p ≤ 2^(i + 1) * monsterOddPart)

/-- Fiber chains: fixing the odd part, vary the 2-adic exponent 0..46. -/
def fiberChain (d : ℕ) : List ℕ := (List.range 47).map (fun k => 2^k * d)

theorem fiberChain_length (d : ℕ) : (fiberChain d).length = 47 := by
  simp [fiberChain]

theorem fiber_count_times_chain_length :
    oddDivisorCount * 47 = monsterDivisorCount := by
  unfold oddDivisorCount monsterDivisorCount; norm_num

-- ============================================================
-- §15  The Monster-Scale Gate Universe
-- ============================================================

/-- A "Monster-scale gate" is a prime not dividing |𝕄|. -/
def isMonsterGate (p : ℕ) : Prop := monsterIrrelevantPrime p

/-- The 12 non-ontology SSPs {2,...,41} divide |𝕄| but NOT 196883.
    They are GateScan gate primes but NOT Monster gates. -/
theorem ssp_divide_monster :
    ∀ p ∈ ([2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41] : List ℕ),
      Nat.Prime p ∧ p ∣ monsterOrder := by native_decide

/-
Monster gates are coprime to 196883.
-/
theorem monsterGate_coprime_196883 (p : ℕ) (h : isMonsterGate p) :
    Nat.Coprime p 196883 := by
  obtain ⟨ hp₁, hp₂ ⟩ := h;
  exact hp₁.coprime_iff_not_dvd.mpr fun h => hp₂ <| dvd_trans h <| by native_decide;

-- ============================================================
-- §16  The Comparison Scale B = 8⁵³
-- ============================================================

def comparisonScale : ℕ := 8^53

theorem comparisonScale_eq : comparisonScale = 2^159 := by
  unfold comparisonScale; norm_num

/-- |𝕄| > 8⁵³. -/
theorem monster_gt_comparison : comparisonScale < monsterOrder := by native_decide

theorem monster_primes_below_comparison :
    ∀ p ∈ monsterPrimeList, p < comparisonScale := by decide

-- ============================================================
-- §17  Sequence Families at Monster Scale
-- ============================================================

def monsterRelevantBelow (B : ℕ) : List ℕ := monsterPrimeList.filter (· < B)

def monsterIrrelevantBelow (B : ℕ) : List ℕ :=
  ((List.range B).filter Nat.Prime).filter (fun p => !(p ∣ monsterOrder))

theorem S14_at_512 : (monsterRelevantBelow 512).length = 15 := by native_decide
theorem S15_at_512 : (monsterIrrelevantBelow 512).length = 82 := by native_decide

theorem S14_S15_partition_512 :
    (monsterRelevantBelow 512).length + (monsterIrrelevantBelow 512).length =
    ((List.range 512).filter Nat.Prime).length := by native_decide

-- ============================================================
-- §18  The Radical as a Primorial: 2¹⁵ = 32768 Divisors
-- ============================================================

/-- The radical of |𝕄| is a primorial — the product of 15 distinct primes,
    each with exponent 1.  Its divisor count is 2¹⁵ = 32768.
    These 32768 squarefree divisors form the "skeleton" of the full
    212-million-divisor lattice: every divisor of |𝕄| is a squarefree
    divisor times a prime-power "decoration". -/
def radicalDivisorCount : ℕ := 2^15

theorem radicalDivisorCount_value : radicalDivisorCount = 32768 := by norm_num [radicalDivisorCount]

/-- The radical is squarefree (product of distinct primes). -/
theorem monsterRadical_squarefree : Squarefree monsterRadical := by native_decide

/-- Smallest divisors of the radical (first 20, matching Python output). -/
def radicalDivisors : List ℕ :=
  let ps := monsterPrimeList
  ps.foldl (fun acc p => acc ++ (acc.map (· * p))) [1] |>.mergeSort (· ≤ ·)

theorem radicalDivisors_head :
    (radicalDivisors.take 20) =
      [1, 2, 3, 5, 6, 7, 10, 11, 13, 14, 15, 17, 19, 21, 22, 23, 26, 29, 30, 31] := by
  native_decide

theorem radicalDivisors_length : radicalDivisors.length = 32768 := by native_decide

-- ============================================================
-- §19  The MonsterScale Architecture
-- ============================================================

structure MonsterScaleArchitecture where
  order           : ℕ := monsterOrder
  primes          : List ℕ := monsterPrimeList
  numDivisors     : ℕ := monsterDivisorCount
  numLayers       : ℕ := 47
  oddDivsPerLayer : ℕ := oddDivisorCount
  largestPrime    : ℕ := 71
  numBlocks       : ℕ := 46

def architecture : MonsterScaleArchitecture := {}

#eval architecture.order
#eval architecture.numDivisors
#eval architecture.numLayers

end MonsterScale