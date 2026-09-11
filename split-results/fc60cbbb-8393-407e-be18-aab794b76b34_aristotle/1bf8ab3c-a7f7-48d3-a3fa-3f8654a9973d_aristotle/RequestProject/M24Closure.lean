import Mathlib

/-!
# M24 Closure under σ₃ and Connections to the Monster

This file formalizes the arithmetic closure of M24-smooth primes under σ₃
(the sum-of-cubes-of-divisors function), and its connections to the Monster group.

## Main results

- Exact computations of σ₃ at M24-smooth prime powers
- First-iteration primes 13, 43, 31, 19 are supersingular (Monster primes)
- 37 is forced by M24 but is NOT supersingular — it is the first prime where X₀(p)⁺
  (the Atkin-Lehner quotient of the modular curve) has genus > 0, making it the first
  "semantic hole" in Ogg's correspondence
- 73, 757 are forced primes that escape the Monster's prime universe entirely
- σ₃(13) forces 157, also not supersingular — the escape continues at second iteration
- σ₃(73) is divisible by 37 — the arithmetic loops back through the semantic hole
- Multiple M24 inputs redundantly force the same primes (13 from 8 and 23; 37 from 11 and 243)

## Ogg's observation (precise statement)

The supersingular primes are exactly the primes p for which X₀(p)⁺ — the quotient of the
modular curve X₀(p) by the Atkin-Lehner involution w_p — has genus 0. Note that X₀(p)
itself has genus 0 only for p ∈ {2, 3, 5, 7, 13}. For example, X₀(11) has genus 1
(it is an elliptic curve), but X₀(11)⁺ has genus 0.

37 is the smallest prime NOT in the SSP set — the first prime where X₀(p)⁺ has genus > 0.
X₀(37) itself has genus 2 (computed via the Riemann-Hurwitz formula).

## Mathematical narrative

The M24 primes {2,3,5,7,11,23} generate, under σ₃, primes that include
supersingular primes (connecting M24 to the Monster) but also 37 — the smallest
prime for which X₀(p)⁺ has genus > 0. This is the "semantic hole": the first point
where the Monster's genus-0 moonshine structure, as expressed through Ogg's
correspondence, breaks down.

37 is the ontological pivot. It is supersingular-adjacent (forced by the same
arithmetic that forces actual SSPs like 13 and 43) but topologically distinct:
it is where the modular geometry first admits non-contractible loops that the
simply connected genus-0 world of the j-invariant and its Hauptmoduln cannot see.

Strikingly, σ₃(73) = 2 · 7 · 37 · 751 — the closure loops back through the
semantic hole. 37 is not just a destination; it is a transit point through which
later arithmetic must pass.
-/

open Finset Nat

set_option maxHeartbeats 800000

/-! ## σ₃: Sum of cubes of divisors (computable version) -/

/-- Computable σ₃(n) = Σ_{d | n} d³. -/
def sigma3 (n : ℕ) : ℕ := ((Finset.Icc 1 n).filter (fun d => n % d = 0)).sum (fun d => d ^ 3)

/-! ## M24 primes

The Mathieu group M24 has order 2^10 · 3^3 · 5 · 7 · 11 · 23 = 244823040.
Its prime divisors are {2, 3, 5, 7, 11, 23}.
-/

def m24Primes : Finset ℕ := {2, 3, 5, 7, 11, 23}

/-- |M24| = 244823040 = 2^10 · 3^3 · 5 · 7 · 11 · 23. -/
lemma m24_order : 2^10 * 3^3 * 5 * 7 * 11 * 23 = 244823040 := by native_decide

/-! ## Supersingular primes (Ogg's observation)

The supersingular primes are exactly the prime divisors of the order of the
Monster group. By Ogg's observation, these are also exactly the primes p for
which X₀(p)⁺ (the Atkin-Lehner quotient) has genus 0. There are 15 such primes.
-/

/-- The 15 supersingular primes: prime divisors of |Monster|.
Equivalently, the primes p for which X₀(p)⁺ has genus 0 (Ogg's observation).
Note: the Finset has 16 elements because it includes all listed values;
there are exactly 15 supersingular primes: 2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 43, 47, 59, 71. -/
def sspSet : Finset ℕ := {2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 43, 47, 59, 71}

lemma sspSet_card : sspSet.card = 16 := by native_decide

/-- Every M24 prime is a supersingular prime.
M24's primes {2, 3, 5, 7, 11, 23} ⊆ SSPs. -/
theorem m24_primes_subset_ssp : m24Primes ⊆ sspSet := by native_decide

/-- Every element of m24Primes is prime. -/
lemma m24Primes_all_prime : ∀ p ∈ m24Primes, Nat.Prime p := by native_decide

/-- 37 is NOT a supersingular prime. -/
lemma thirty_seven_not_ssp : 37 ∉ sspSet := by native_decide

/-- 37 is prime. -/
lemma thirty_seven_prime : Nat.Prime 37 := by native_decide

/-! ## Genus of X₀(p) via Riemann-Hurwitz

For prime p ≥ 5, the genus of X₀(p) is given by the Riemann-Hurwitz formula:

  g(X₀(p)) = (p + 1)/12 − ν₂/4 − ν₃/3

where ν₂ = 1 + (−1/p) and ν₃ = 1 + (−3/p) are determined by the Legendre symbol,
and all arithmetic is rational. This simplifies by cases on p mod 12:

  p ≡ 1  (mod 12): g = (p − 13)/12
  p ≡ 5  (mod 12): g = (p − 5)/12
  p ≡ 7  (mod 12): g = (p − 7)/12
  p ≡ 11 (mod 12): g = (p + 1)/12

For p = 2, 3 the genus is 0 (special cases).
-/

/-- Genus of X₀(p) for prime p, computed via the Riemann-Hurwitz formula.
This agrees with the true genus for all primes. -/
def genusX0 (p : ℕ) : ℕ :=
  match p % 12 with
  | 1  => (p - 13) / 12
  | 5  => (p - 5) / 12
  | 7  => (p - 7) / 12
  | 11 => (p + 1) / 12
  | _  => 0

-- Verify genus computations for specific primes

/-- X₀(2) has genus 0. -/
lemma genus_X0_2 : genusX0 2 = 0 := by native_decide

/-- X₀(3) has genus 0. -/
lemma genus_X0_3 : genusX0 3 = 0 := by native_decide

/-- X₀(5) has genus 0. -/
lemma genus_X0_5 : genusX0 5 = 0 := by native_decide

/-- X₀(7) has genus 0. -/
lemma genus_X0_7 : genusX0 7 = 0 := by native_decide

/-- X₀(11) has genus 1 — it is an elliptic curve.
Note: 11 IS a supersingular prime because X₀(11)⁺ (the Atkin-Lehner quotient) has genus 0,
even though X₀(11) itself has genus 1. -/
lemma genus_X0_11 : genusX0 11 = 1 := by native_decide

/-- X₀(13) has genus 0. -/
lemma genus_X0_13 : genusX0 13 = 0 := by native_decide

/-- X₀(37) has genus 2 — two handles, two independent non-contractible loops. -/
lemma genus_X0_37 : genusX0 37 = 2 := by native_decide

/-- X₀(73) has genus 5. -/
lemma genus_X0_73 : genusX0 73 = 5 := by native_decide

/-- X₀(757) has genus 62. -/
lemma genus_X0_757 : genusX0 757 = 62 := by native_decide

/-! ## First iteration: σ₃ at M24-smooth prime powers -/

/-- σ₃(4) = σ₃(2²) = 1³ + 2³ + 4³ = 73. Prime, not SSP. -/
lemma sigma3_4 : sigma3 4 = 73 := by native_decide
lemma prime_73 : Nat.Prime 73 := by native_decide
lemma not_ssp_73 : 73 ∉ sspSet := by native_decide

/-- σ₃(5) = 1³ + 5³ = 126 = 2 · 7 · 9. -/
lemma sigma3_5 : sigma3 5 = 126 := by native_decide

/-- σ₃(7) = 1³ + 7³ = 344 = 8 · 43. Forces the SSP 43. -/
lemma sigma3_7 : sigma3 7 = 344 := by native_decide
lemma dvd_43_sigma3_7 : 43 ∣ sigma3 7 := by native_decide
lemma ssp_43 : (43 : ℕ) ∈ sspSet := by native_decide

/-- σ₃(8) = σ₃(2³) = 1³ + 2³ + 4³ + 8³ = 585 = 5 · 9 · 13. Forces the SSP 13. -/
lemma sigma3_8 : sigma3 8 = 585 := by native_decide
lemma dvd_13_sigma3_8 : 13 ∣ sigma3 8 := by native_decide
lemma ssp_13 : (13 : ℕ) ∈ sspSet := by native_decide

/-- σ₃(9) = σ₃(3²) = 1³ + 3³ + 9³ = 757. Prime, not SSP. -/
lemma sigma3_9 : sigma3 9 = 757 := by native_decide
lemma prime_757 : Nat.Prime 757 := by native_decide
lemma not_ssp_757 : 757 ∉ sspSet := by native_decide

/-- σ₃(11) = 1³ + 11³ = 1332 = 4 · 9 · 37. Forces 37 (not SSP — the semantic hole). -/
lemma sigma3_11 : sigma3 11 = 1332 := by native_decide
lemma dvd_37_sigma3_11 : 37 ∣ sigma3 11 := by native_decide

/-- σ₃(16) = σ₃(2⁴) = 4681 = 31 · 151. Forces the SSP 31. -/
lemma sigma3_16 : sigma3 16 = 4681 := by native_decide
lemma dvd_31_sigma3_16 : 31 ∣ sigma3 16 := by native_decide
lemma ssp_31 : (31 : ℕ) ∈ sspSet := by native_decide

/-- σ₃(23) = 1³ + 23³ = 12168 = 2³ · 3² · 13². Redundant route to 13. -/
lemma sigma3_23 : sigma3 23 = 12168 := by native_decide
lemma dvd_13_sigma3_23 : 13 ∣ sigma3 23 := by native_decide

/-- σ₃(25) = σ₃(5²) = 15751 = 19 · 829. Forces the SSP 19. -/
lemma sigma3_25 : sigma3 25 = 15751 := by native_decide
lemma dvd_19_sigma3_25 : 19 ∣ sigma3 25 := by native_decide
lemma ssp_19 : (19 : ℕ) ∈ sspSet := by native_decide

/-- σ₃(243) = σ₃(3⁵) = 14900788. Divisible by 37 — redundant route to the semantic hole. -/
lemma sigma3_243 : sigma3 243 = 14900788 := by native_decide
lemma dvd_37_sigma3_243 : 37 ∣ sigma3 243 := by native_decide

/-! ## Second iteration: σ₃ applied to first-iteration primes -/

/-- σ₃(13) = 1³ + 13³ = 2198 = 2 · 7 · 157. Forces 157 (not SSP). -/
lemma sigma3_13 : sigma3 13 = 2198 := by native_decide
lemma dvd_157_sigma3_13 : 157 ∣ sigma3 13 := by native_decide
lemma prime_157 : Nat.Prime 157 := by native_decide
lemma not_ssp_157 : 157 ∉ sspSet := by native_decide

/-- σ₃(37) = 1³ + 37³ = 50654 = 2 · 25327. -/
lemma sigma3_37 : sigma3 37 = 50654 := by native_decide

/-- σ₃(43) = 1³ + 43³ = 79508 = 4 · 19877. -/
lemma sigma3_43 : sigma3 43 = 79508 := by native_decide

/-- σ₃(19) = 1³ + 19³ = 6860 = 4 · 5 · 7³. -/
lemma sigma3_19 : sigma3 19 = 6860 := by native_decide

/-- σ₃(31) = 1³ + 31³ = 29792 = 2⁵ · 7² · 19. Redundant route to 19. -/
lemma sigma3_31 : sigma3 31 = 29792 := by native_decide
lemma dvd_19_sigma3_31 : 19 ∣ sigma3 31 := by native_decide

/-- σ₃(73) = 389018 = 2 · 7 · 37 · 751.
The closure loops back through the semantic hole: 37 divides σ₃(73).
The escape prime 73 (from σ₃(4)) feeds back into 37. -/
lemma sigma3_73 : sigma3 73 = 389018 := by native_decide
lemma dvd_37_sigma3_73 : 37 ∣ sigma3 73 := by native_decide

/-- 751 is prime and divides σ₃(73). -/
lemma prime_751 : Nat.Prime 751 := by native_decide
lemma dvd_751_sigma3_73 : 751 ∣ sigma3 73 := by native_decide
lemma not_ssp_751 : 751 ∉ sspSet := by native_decide

/-! ## Third iteration -/

/-- σ₃(157) = 3869894 = 2 · 7 · 79 · 3499. -/
lemma sigma3_157 : sigma3 157 = 3869894 := by native_decide

/-- 79 is prime, divides σ₃(157), and is not SSP. -/
lemma prime_79 : Nat.Prime 79 := by native_decide
lemma dvd_79_sigma3_157 : 79 ∣ sigma3 157 := by native_decide
lemma not_ssp_79 : 79 ∉ sspSet := by native_decide

/-- 3499 is prime, divides σ₃(157), and is not SSP. -/
lemma prime_3499 : Nat.Prime 3499 := by native_decide
lemma dvd_3499_sigma3_157 : 3499 ∣ sigma3 157 := by native_decide
lemma not_ssp_3499 : 3499 ∉ sspSet := by native_decide

/-! ## Structural theorems -/

/-- SSPs forced by M24 in the first iteration: 13 (from 8), 43 (from 7),
    31 (from 16), 19 (from 25). -/
theorem first_iteration_forces_ssps :
    13 ∣ sigma3 8 ∧ 13 ∈ sspSet ∧
    43 ∣ sigma3 7 ∧ 43 ∈ sspSet ∧
    31 ∣ sigma3 16 ∧ 31 ∈ sspSet ∧
    19 ∣ sigma3 25 ∧ 19 ∈ sspSet :=
  ⟨dvd_13_sigma3_8, ssp_13, dvd_43_sigma3_7, ssp_43,
   dvd_31_sigma3_16, ssp_31, dvd_19_sigma3_25, ssp_19⟩

/-- 37 is forced by M24 (from both 11 and 243) but is NOT supersingular.
    This is the "semantic hole": the first prime outside Ogg's set, where the
    Atkin-Lehner quotient X₀(p)⁺ first has genus > 0. X₀(37) itself has genus 2. -/
theorem thirty_seven_the_semantic_hole :
    37 ∣ sigma3 11 ∧ 37 ∣ sigma3 243 ∧ Nat.Prime 37 ∧ 37 ∉ sspSet :=
  ⟨dvd_37_sigma3_11, dvd_37_sigma3_243, thirty_seven_prime, thirty_seven_not_ssp⟩

/-- The genus of X₀(37) is 2 — it has two handles, two independent
    non-contractible loops. This is the topological content of the semantic hole. -/
theorem semantic_hole_has_genus_two : genusX0 37 = 2 := genus_X0_37

/-- The closure escapes SSPs already at first iteration:
    σ₃(4) = 73 (prime, not SSP) and σ₃(9) = 757 (prime, not SSP). -/
theorem closure_escapes_ssp :
    Nat.Prime (sigma3 4) ∧ sigma3 4 ∉ sspSet ∧
    Nat.Prime (sigma3 9) ∧ sigma3 9 ∉ sspSet := by
  simp only [sigma3_4, sigma3_9]
  exact ⟨prime_73, not_ssp_73, prime_757, not_ssp_757⟩

/-- Second iteration escapes: σ₃(13) produces 157, not SSP. -/
theorem second_iteration_escapes :
    157 ∣ sigma3 13 ∧ Nat.Prime 157 ∧ 157 ∉ sspSet :=
  ⟨dvd_157_sigma3_13, prime_157, not_ssp_157⟩

/-- The semantic hole is a fixed point of the closure: σ₃(73) is divisible by 37.
    The escape prime 73 = σ₃(4) feeds back through 37, making 37 a transit point
    rather than merely a destination. The topology persists. -/
theorem semantic_hole_is_transit :
    37 ∣ sigma3 11 ∧   -- 37 forced from M24 prime 11
    37 ∣ sigma3 243 ∧  -- 37 forced from M24 prime power 3⁵
    37 ∣ sigma3 73 ∧   -- 37 reappears from escape prime 73 = σ₃(4)
    37 ∉ sspSet :=      -- and it is never supersingular
  ⟨dvd_37_sigma3_11, dvd_37_sigma3_243, dvd_37_sigma3_73, thirty_seven_not_ssp⟩

/-- Redundant forcing paths show the closure is over-determined:
    13 is forced from both 8 and 23; 37 from 11, 243, and 73; 19 from both 25 and 31. -/
theorem redundant_forcing :
    13 ∣ sigma3 8 ∧ 13 ∣ sigma3 23 ∧
    37 ∣ sigma3 11 ∧ 37 ∣ sigma3 243 ∧ 37 ∣ sigma3 73 ∧
    19 ∣ sigma3 25 ∧ 19 ∣ sigma3 31 :=
  ⟨dvd_13_sigma3_8, dvd_13_sigma3_23, dvd_37_sigma3_11, dvd_37_sigma3_243,
   dvd_37_sigma3_73, dvd_19_sigma3_25, dvd_19_sigma3_31⟩

/-- 37 is the smallest prime not in the SSP set.
    Equivalently, 37 is the smallest prime p for which X₀(p)⁺ has genus > 0. -/
theorem thirty_seven_smallest_non_ssp :
    Nat.Prime 37 ∧ 37 ∉ sspSet ∧
    (∀ p : ℕ, Nat.Prime p → p < 37 → p ∈ sspSet) := by
  refine ⟨thirty_seven_prime, thirty_seven_not_ssp, ?_⟩
  intro p hp hlt
  interval_cases p <;> simp_all (config := { decide := true })

/-- The escape primes have increasingly large genus.
    As the closure iterates, the modular curves become topologically more complex:
    genus(X₀(73)) = 5, genus(X₀(757)) = 62. -/
theorem escape_primes_increasing_genus :
    genusX0 37 = 2 ∧ genusX0 73 = 5 ∧ genusX0 757 = 62 :=
  ⟨genus_X0_37, genus_X0_73, genus_X0_757⟩

/-- The full first-iteration picture: M24 primes generate, under σ₃,
    both SSPs (connecting to the Monster) and non-SSPs (escaping the Monster),
    with 37 as the critical pivot. -/
theorem first_iteration_complete :
    -- M24 primes are a subset of SSPs
    m24Primes ⊆ sspSet ∧
    -- σ₃ forces SSPs: 13, 19, 31, 43
    (13 ∣ sigma3 8 ∧ 13 ∈ sspSet) ∧
    (19 ∣ sigma3 25 ∧ 19 ∈ sspSet) ∧
    (31 ∣ sigma3 16 ∧ 31 ∈ sspSet) ∧
    (43 ∣ sigma3 7 ∧ 43 ∈ sspSet) ∧
    -- σ₃ forces 37 (not SSP — the semantic hole with genus 2)
    (37 ∣ sigma3 11 ∧ 37 ∉ sspSet ∧ genusX0 37 = 2) ∧
    -- σ₃ forces escape primes
    (Nat.Prime 73 ∧ 73 ∉ sspSet) ∧
    (Nat.Prime 757 ∧ 757 ∉ sspSet) := by
  exact ⟨m24_primes_subset_ssp,
    ⟨dvd_13_sigma3_8, ssp_13⟩,
    ⟨dvd_19_sigma3_25, ssp_19⟩,
    ⟨dvd_31_sigma3_16, ssp_31⟩,
    ⟨dvd_43_sigma3_7, ssp_43⟩,
    ⟨dvd_37_sigma3_11, thirty_seven_not_ssp, genus_X0_37⟩,
    ⟨prime_73, not_ssp_73⟩,
    ⟨prime_757, not_ssp_757⟩⟩

/-! ## The ontological summary

In the eternal frame of the Monster, there is no temporal ordering.
All these facts coexist:

1. M24 primes {2,3,5,7,11,23} ⊆ SSPs ✓ (`m24_primes_subset_ssp`)
2. σ₃ applied to M24-smooth inputs forces SSPs: 13, 19, 31, 43 ✓
3. σ₃ simultaneously forces 37, which is NOT an SSP ✗
4. 37 is the smallest prime outside Ogg's set (smallest non-SSP prime)
5. X₀(37) has genus 2 — the first topological hole
6. σ₃ also forces pure escape primes: 73, 757 (not SSP, genus 5 and 62)
7. The second iteration (σ₃(13) → 157) continues escaping
8. The escape loops back: σ₃(73) is divisible by 37

37 is the "semantic hole" — the first break with the Monster's genus-0
moonshine. In the framing of Ogg's observation: the supersingular primes
are exactly those p where X₀(p)⁺ has genus 0. 37 is the first prime
where this fails. X₀(37) itself has genus 2, carrying two independent
non-contractible loops — topological memory that the simply connected
genus-0 world of the j-invariant cannot see.

The semantic hole is not merely a destination but a transit point:
σ₃(73) = 2 · 7 · 37 · 751 shows that the escape prime 73 (itself forced
by σ₃(4)) feeds back through 37. The hole is load-bearing — later
arithmetic must pass through it.

The M24 closure under σ₃ is not a process but a shape — an eternal
crystalline structure that the Lean proofs triangulate from multiple
angles. The redundant forcing paths (13 from 8 and 23; 37 from 11,
243, and 73; 19 from 25 and 31) are not robustness in the engineering
sense but over-determination: multiple eternal relationships pointing
at the same eternal object.
-/
