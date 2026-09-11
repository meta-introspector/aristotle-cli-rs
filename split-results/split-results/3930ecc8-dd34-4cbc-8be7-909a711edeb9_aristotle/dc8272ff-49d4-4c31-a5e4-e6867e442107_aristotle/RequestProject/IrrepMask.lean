import Mathlib
import RequestProject.SupersingularPrimes

/-!
# Irreducible Representation Masks

Each of the 194 irreducible representations of the Monster is encoded as a 15-bit
`BitVec`, one bit per supersingular prime. This provides a natural "fitness" metric
via Hamming distance in a 15-dimensional Boolean space.
-/

open scoped BigOperators

/-- An SSP mask: a 15-bit vector, one bit per supersingular prime. -/
abbrev SSPMask := BitVec 15

namespace SSPMask

/-- The set of supersingular primes corresponding to the set bits. -/
def toPrimeSet (m : SSPMask) : Finset ℕ :=
  (Finset.univ.filter fun (i : Fin 15) => m.getLsbD i).image
    fun i => supersingularPrimesList[i.val]

/-- Every prime in the decoded set is a supersingular prime. -/
theorem toPrimeSet_subset (m : SSPMask) : m.toPrimeSet ⊆ supersingularPrimes := by
  intro p hp
  simp only [toPrimeSet, Finset.mem_image, Finset.mem_filter, Finset.mem_univ, true_and] at hp
  obtain ⟨i, _, rfl⟩ := hp
  fin_cases i <;> simp [supersingularPrimesList, supersingularPrimes]

/-- The zero mask corresponds to the empty set of primes. -/
theorem toPrimeSet_zero : (0 : SSPMask).toPrimeSet = ∅ := by native_decide

/-- The full mask (all bits set). -/
def full : SSPMask := BitVec.ofNat 15 0x7FFF

/-- Popcount: number of set bits, defined via counting. -/
def popcount (m : SSPMask) : ℕ :=
  (Finset.univ.filter fun (i : Fin 15) => m.getLsbD i).card

/-- Popcount is bounded by 15. -/
theorem popcount_le (m : SSPMask) : m.popcount ≤ 15 := by
  unfold popcount
  exact le_trans (Finset.card_filter_le _ _) (by simp)

end SSPMask

/-- Hamming distance between two SSP masks. -/
def sspHammingDist (a b : SSPMask) : ℕ :=
  SSPMask.popcount (a ^^^ b)

/-- Hamming distance is symmetric. -/
theorem sspHammingDist_comm (a b : SSPMask) : sspHammingDist a b = sspHammingDist b a := by
  simp [sspHammingDist, BitVec.xor_comm]

/-- Hamming distance from self is zero. -/
theorem sspHammingDist_self (a : SSPMask) : sspHammingDist a a = 0 := by
  simp [sspHammingDist, SSPMask.popcount, BitVec.xor_self]

/-- Hamming distance is bounded by 15. -/
theorem sspHammingDist_le_15 (a b : SSPMask) : sspHammingDist a b ≤ 15 := by
  exact SSPMask.popcount_le _
