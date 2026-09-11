import Mathlib

/-!
# Ogg's Observation: Monster Group Primes

Andrew Ogg observed in 1975 that the primes p for which the modular curve X₀(p)⁺
(the quotient of X₀(p) by the Atkin-Lehner involution w_p) has genus zero are exactly:

  {2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71}

He noted that these are precisely the prime divisors of the order of the Monster group,
the largest sporadic simple group. This mysterious coincidence, which Ogg called
"a bizarre connection", was later explained by Borcherds' proof of the Monstrous
Moonshine conjecture (for which he received the Fields Medal in 1998).

In this file we verify that the prime factorization of the Monster group order
|𝕄| = 2⁴⁶ · 3²⁰ · 5⁹ · 7⁶ · 11² · 13³ · 17 · 19 · 23 · 29 · 31 · 41 · 47 · 59 · 71
yields exactly these 15 primes.
-/

open scoped BigOperators Nat

/-- The order of the Monster group, the largest sporadic simple group. -/
def monsterGroupOrder : ℕ :=
  2 ^ 46 * 3 ^ 20 * 5 ^ 9 * 7 ^ 6 * 11 ^ 2 * 13 ^ 3 *
  17 * 19 * 23 * 29 * 31 * 41 * 47 * 59 * 71

/-- The set of Ogg primes: primes dividing the order of the Monster group,
equivalently the primes p for which X₀(p)⁺ has genus zero. -/
def oggPrimes : Finset ℕ := {2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71}

/-- The order of the Monster group equals 808017424794512875886459904961710757005754368000000000. -/
theorem monsterGroupOrder_val :
    monsterGroupOrder = 808017424794512875886459904961710757005754368000000000 := by
  native_decide

/-- The prime factors of the Monster group order are exactly the Ogg primes. -/
theorem monsterGroupOrder_primeFactors :
    monsterGroupOrder.primeFactors = oggPrimes := by
  native_decide

/-- There are exactly 15 Ogg primes. -/
theorem oggPrimes_card : oggPrimes.card = 15 := by native_decide

/-- Every Ogg prime is prime. -/
theorem oggPrimes_all_prime : ∀ p ∈ oggPrimes, Nat.Prime p := by decide

/-- The sum of the Ogg primes is 378. -/
theorem oggPrimes_sum : oggPrimes.sum id = 378 := by native_decide

/-- The Monster group order is positive. -/
theorem monsterGroupOrder_pos : 0 < monsterGroupOrder := by native_decide

/-- A prime divides the Monster group order if and only if it is an Ogg prime. -/
theorem prime_dvd_monsterGroupOrder_iff {p : ℕ} (hp : p.Prime) :
    p ∣ monsterGroupOrder ↔ p ∈ oggPrimes := by
  constructor
  · intro hdvd
    have : p ∈ monsterGroupOrder.primeFactors :=
      Nat.mem_primeFactors.mpr ⟨hp, hdvd, monsterGroupOrder_pos.ne'⟩
    rwa [monsterGroupOrder_primeFactors] at this
  · intro hmem
    have : p ∈ monsterGroupOrder.primeFactors := by
      rwa [monsterGroupOrder_primeFactors]
    exact (Nat.mem_primeFactors.mp this).2.1

/-- Every Ogg prime divides the Monster group order. -/
theorem oggPrime_dvd_monsterGroupOrder {p : ℕ} (hp : p ∈ oggPrimes) :
    p ∣ monsterGroupOrder :=
  (prime_dvd_monsterGroupOrder_iff (oggPrimes_all_prime p hp)).mpr hp

/-- The Ogg primes, listed in increasing order. -/
def oggPrimesList : List ℕ := [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71]

/-- The list of Ogg primes converts to the correct Finset. -/
theorem oggPrimesList_toFinset : oggPrimesList.toFinset = oggPrimes := by native_decide

/-- The list of Ogg primes is pairwise strictly increasing. -/
theorem oggPrimesList_pairwise : oggPrimesList.Pairwise (· < ·) := by decide

/-- The list of Ogg primes has no duplicates. -/
theorem oggPrimesList_nodup : oggPrimesList.Nodup := by decide

/-!
## Deriving the Ogg primes from supersingular j-invariant counts

Rather than listing the Ogg primes, we derive them computationally. For each prime p,
we compute:
- `numSupersingular p`: the total number of supersingular j-invariants in characteristic p
  (i.e., over 𝔽_{p²}), using the Deuring mass formula
- `numSupersingularFp p`: the number of those j-invariants that lie in 𝔽_p, computed from
  class numbers of imaginary quadratic fields via the Atkin-Lehner fixed-point formula

A prime p is an Ogg prime iff `numSupersingular p = numSupersingularFp p`, i.e., every
supersingular j-invariant in characteristic p already lies in 𝔽_p.
-/

/-- The class number h(D) for a negative discriminant D, computed by counting
    primitive reduced binary quadratic forms ax² + bxy + cy² with discriminant D = b² - 4ac.
    A form is reduced if |b| ≤ a ≤ c, with b ≥ 0 when |b| = a or a = c.
    A form is primitive if gcd(a, b, c) = 1. -/
def classNumberNeg (D : Int) : Nat :=
  if D ≥ 0 then 0
  else
    let absD := D.natAbs
    let aBound := Nat.sqrt (absD / 3) + 1
    (List.range aBound).foldl (fun count ha =>
      let a := ha + 1
      (List.range (2 * a + 1)).foldl (fun count hb =>
        let b : Int := (hb : Int) - (a : Int)
        let num := b * b - D
        if num % (4 * (a : Int)) == 0 then
          let cVal := (num / (4 * (a : Int))).toNat
          if a ≤ cVal then
            if b ≥ 0 || (b.natAbs ≠ a ∧ a ≠ cVal) then
              if Nat.gcd (Nat.gcd a b.natAbs) cVal == 1 then
                count + 1
              else count
            else count
          else count
        else count
      ) count
    ) 0

/-- Total number of supersingular j-invariants in characteristic p (over 𝔽_{p²}).
    By the Deuring mass formula: ∑_j 1/w_j = (p-1)/12, where w_j = |Aut(E_j)|/2.
    This gives n = (p - 1 + 8δ₀ + 6δ₁) / 12 where δ₀ = [p ≡ 2 mod 3] (j = 0 is SS)
    and δ₁ = [p ≡ 3 mod 4] (j = 1728 is SS). -/
def numSupersingular (p : Nat) : Nat :=
  if p ≤ 3 then 1
  else (p - 1 + (if p % 3 == 2 then 8 else 0) + (if p % 4 == 3 then 6 else 0)) / 12

/-- Number of supersingular j-invariants lying in 𝔽_p.
    Equals r/2 where r is the number of fixed points of the Atkin-Lehner involution w_p.
    By the theory of optimal embeddings into quaternion orders:
    r = h(-4p) if p ≡ 1 mod 4, and r = h(-p) + h(-4p) if p ≡ 3 mod 4. -/
def numSupersingularFp (p : Nat) : Nat :=
  if p ≤ 3 then 1
  else
    let r := if p % 4 == 1 then
        classNumberNeg (-(4 * (p : Int)))
      else
        classNumberNeg (-(p : Int)) + classNumberNeg (-(4 * (p : Int)))
    r / 2

/-- A prime p is an Ogg prime iff all supersingular j-invariants in characteristic p
    already lie in 𝔽_p (not just in 𝔽_{p²}). -/
def isOggPrime (p : Nat) : Bool :=
  p.Prime && (numSupersingular p == numSupersingularFp p)

/-- **Derivation of the Ogg primes.** The primes p < 100 for which every supersingular
    j-invariant in characteristic p lies in 𝔽_p are exactly the 15 Ogg primes.
    This is proved by computing `numSupersingular p` (via the Deuring mass formula) and
    `numSupersingularFp p` (via class numbers of imaginary quadratic fields) for each prime,
    and checking that they agree. -/
theorem oggPrimes_derived :
    (Finset.range 100).filter (fun p => isOggPrime p) = oggPrimes := by
  native_decide

/-- Beyond the Ogg primes, no prime p with 71 < p < 100 satisfies the supersingular
    condition, confirming that 71 is the largest Ogg prime in this range. -/
theorem no_oggPrime_between_71_and_100 :
    ∀ p ∈ Finset.range 100, 71 < p → Nat.Prime p → numSupersingular p ≠ numSupersingularFp p := by
  native_decide
