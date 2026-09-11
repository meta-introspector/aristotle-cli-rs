import Mathlib
import RequestProject.Compute.Cosmic.Crankmining

/-!
# HubGeometry — Generalized Arithmetic Attractors and Monster Alignment

This module abstracts the 1729 story into a general theory of "arithmetic attractors"
in products of finite rings, and defines Monster alignment as a first-class predicate.
-/

set_option maxHeartbeats 4000000

open Crankmining
open CosmicSynthesis
open DA51PrefixClassification PadicEntropyDAG BottMoonshineExperiment
open FiberedUniverse GradedFiberedUniverse CelestialShell Gearbox UnifiedIPLDMemory

namespace HubGeometry

/-! ## §1. Ogg Prime Predicate -/

/-- The set of Ogg's 15 supersingular primes. -/
def oggPrimeList : List ℕ := [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71]

/-- Decidable predicate: is n an Ogg prime? -/
def isOggPrime (n : ℕ) : Bool :=
  n ∈ oggPrimeList

/-- An integer is **Monster-aligned** if every prime factor divides the Monster order,
    i.e., every prime factor is an Ogg prime. -/
def MonsterAligned (n : ℕ) : Prop :=
  ∀ p : ℕ, Nat.Prime p → p ∣ n → p ∈ oggPrimeList

/-- 1729 is Monster-aligned: all its prime factors (7, 13, 19) are Ogg primes. -/
theorem taxicab_monster_aligned : MonsterAligned 1729 := by
  intro p hp hdvd
  have hle : p ≤ 1729 := Nat.le_of_dvd (by omega) hdvd
  have hge : p ≥ 2 := hp.two_le
  have h1729 : (1729 : ℕ) = 7 * 13 * 19 := by norm_num
  rw [h1729] at hdvd
  rw [show (7 : ℕ) * 13 * 19 = 91 * 19 from by norm_num] at hdvd
  rcases hp.dvd_mul.mp hdvd with h91 | h19
  · rw [show (91 : ℕ) = 7 * 13 from by norm_num] at h91
    rcases hp.dvd_mul.mp h91 with h7 | h13
    · have := (Nat.dvd_prime (by decide : Nat.Prime 7)).mp h7
      rcases this with rfl | rfl
      · exact absurd hp (by decide)
      · simp [oggPrimeList]
    · have := (Nat.dvd_prime (by decide : Nat.Prime 13)).mp h13
      rcases this with rfl | rfl
      · exact absurd hp (by decide)
      · simp [oggPrimeList]
  · have := (Nat.dvd_prime (by decide : Nat.Prime 19)).mp h19
    rcases this with rfl | rfl
    · exact absurd hp (by decide)
    · simp [oggPrimeList]

/-- 1 is (vacuously) Monster-aligned. -/
theorem one_monster_aligned : MonsterAligned 1 := by
  intro p hp hdvd
  have := hp.two_le
  have := Nat.le_of_dvd (by omega) hdvd
  omega

/-! ## §2. Generalized Arithmetic Attractor -/

/-- A **CubeDecomposition** witnesses n = a³ + b³ with a ≤ b. -/
structure CubeDecomposition (n : ℕ) where
  a : ℕ
  b : ℕ
  a_le_b : a ≤ b
  sum_eq : a ^ 3 + b ^ 3 = n

/-- An **ArithmeticAttractor** is a natural number with at least two distinct
    cube decompositions, whose prime factors are all Ogg primes, and which
    projects to a distinguished (non-Hub) point in S_ss. -/
structure ArithmeticAttractor where
  /-- The attractor value. -/
  value : ℕ
  /-- First cube decomposition. -/
  decomp1 : CubeDecomposition value
  /-- Second cube decomposition. -/
  decomp2 : CubeDecomposition value
  /-- The decompositions are distinct. -/
  distinct : (decomp1.a, decomp1.b) ≠ (decomp2.a, decomp2.b)
  /-- All prime factors are Ogg primes (Monster-aligned). -/
  aligned : MonsterAligned value
  /-- The S_ss projection. -/
  coord : S_ss
  /-- coord is the natural projection. -/
  coordSpec : coord = ((value : ZMod 71), (value : ZMod 59), (value : ZMod 47))
  /-- The projection is not the Hub. -/
  notHub : coord ≠ theHub

/-- 1729 as the canonical arithmetic attractor. -/
def taxicab1729 : ArithmeticAttractor where
  value := 1729
  decomp1 := ⟨9, 10, by omega, by norm_num⟩
  decomp2 := ⟨1, 12, by omega, by norm_num⟩
  distinct := by decide
  aligned := taxicab_monster_aligned
  coord := ((1729 : ZMod 71), (1729 : ZMod 59), (1729 : ZMod 47))
  coordSpec := rfl
  notHub := by
    simp only [theHub]
    intro h
    have h1 := congr_arg Prod.fst h
    simp at h1
    revert h1; native_decide

/-! ## §3. Hub–Attractor Separation Invariants -/

/-- The Hub–attractor separation distance. -/
def hubAttractorDist (att : ArithmeticAttractor) : ℕ :=
  hubDistance att.coord

/-- The taxicab attractor's distance from the Hub is positive. -/
theorem taxicab_hub_dist_pos : hubAttractorDist taxicab1729 > 0 := by
  native_decide

/-! ## §4. Monster Alignment as a General Pattern -/

/-- A **MonsterDivisor** witnesses that n divides the Monster group order. -/
structure MonsterDivisor (n : ℕ) where
  /-- Proof that n divides |M|. -/
  divides : n ∣ (2^46 * 3^20 * 5^9 * 7^6 * 11^2 * 13^3 * 17 * 19 * 23 * 29 * 31 * 41 * 47 * 59 * 71)

/-- 1729 divides the Monster group order. -/
def taxicab_divides_monster : MonsterDivisor 1729 :=
  ⟨by native_decide⟩

/-- Each Ogg prime divides the Monster group order. -/
theorem ogg_primes_divide_monster :
    ∀ p ∈ oggPrimeList,
      p ∣ (2^46 * 3^20 * 5^9 * 7^6 * 11^2 * 13^3 * 17 * 19 * 23 * 29 * 31 * 41 * 47 * 59 * 71) := by
  native_decide

/-- Bott class of an arithmetic attractor. -/
def ArithmeticAttractor.bottClass (att : ArithmeticAttractor) : Fin 8 :=
  ⟨att.value % 8, Nat.mod_lt _ (by omega)⟩

/-- 1729 has Bott class 1. -/
theorem taxicab_bott : taxicab1729.bottClass = ⟨1, by omega⟩ := by
  simp [ArithmeticAttractor.bottClass, taxicab1729]

end HubGeometry
