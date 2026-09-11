import Mathlib
import RequestProject.SupersingularPrimes
/-!
# Irrep Masks and SSP Support Vectors
This file formalizes the 15-bit SSP (supersingular prime) support vector masks
used to represent the 194 irreducible representations of the Monster group,
along with the Hamming distance metric on these masks.
## Informal source references
- "Each irrep is a 15-bit mask — that's your Arbitrary instance"
- "The 15-SSP prime support vectors of the 194 irreps as the actual generator set"
- "your fitness function is already the 15-dim SSP distance vector, not scalar entropy"
-/
/-- A 15-bit mask where each bit position corresponds (in order) to one of the
15 supersingular primes. Bit i is set iff the i-th supersingular prime appears
in the "SSP support" of the representation (e.g., divides the character degree,
or appears in the modular decomposition).
**Informal source**: "15-bit mask — that's your Arbitrary instance" and
"struct IrrepMask(u16); // 15-bit SSP support vector, one of 194" -/
abbrev SSPMask := BitVec 15
/-- An irreducible representation of the Monster, identified by its index (0–193)
and its SSP support vector mask. In a full model, the mask would be precomputed
from the ATLAS character table.
**Informal source**: "The 15-SSP prime support vectors of the 194 irreps as the actual
generator set" and "struct IrrepMask { mask: SSPMask }" -/
structure IrrepMask where
  /-- Index of the irrep among the 194 conjugacy classes (0-indexed). -/
  index : Fin numIrreps
  /-- The 15-bit SSP support vector for this irrep. -/
  mask : SSPMask
  deriving DecidableEq, Repr
/-- Construct an IrrepMask from a raw index and a UInt16 value.
**Informal source**: "IrrepMask(IRREP_SSP_MASKS[idx])" -/
def IrrepMask.ofRaw (idx : Fin numIrreps) (raw : UInt16) : IrrepMask :=
  { index := idx, mask := BitVec.ofNat 15 raw.toNat }
/-- XOR of two SSP masks, representing the bitwise symmetric difference of
their prime support sets.
**Informal source**: "(m1.0 ^ combined).count_ones()" -/
def SSPMask.xor (m1 m2 : SSPMask) : SSPMask := m1 ^^^ m2
/-- The set of bit positions that are set in a mask.
**Informal source**: decoding the mask bits -/
def SSPMask.setBits (m : SSPMask) : Finset (Fin 15) :=
  Finset.univ.filter (fun i => m.getLsbD i.val)
/-- Hamming distance between two SSP masks: the number of supersingular primes
on which the two representations differ in support. This is the natural metric
in the 15-dimensional SSP support space.
**Informal source**: "your fitness function is already the 15-dim SSP distance vector,
not scalar entropy" and "let distance = (m1.0 ^ combined).count_ones();" -/
def sspHammingDist (m1 m2 : SSPMask) : ℕ :=
  (SSPMask.xor m1 m2).setBits.card
/-- The Hamming distance is symmetric.
**Informal source**: metric property implicit in "15-dim SSP distance vector" -/
theorem sspHammingDist_comm (m1 m2 : SSPMask) :
    sspHammingDist m1 m2 = sspHammingDist m2 m1 := by
  simp [sspHammingDist, SSPMask.xor, BitVec.xor_comm]
/-- The Hamming distance of a mask with itself is zero.
**Informal source**: metric property implicit in "15-dim SSP distance vector" -/
theorem sspHammingDist_self (m : SSPMask) :
    sspHammingDist m m = 0 := by
  simp [sspHammingDist, SSPMask.xor, SSPMask.setBits]
/-
The Hamming distance between any two 15-bit masks is at most 15.
**Informal source**: "15-dim SSP distance vector" implies bounded distance
-/
theorem sspHammingDist_le_15 (m1 m2 : SSPMask) :
    sspHammingDist m1 m2 ≤ 15 := by
  exact le_trans ( Finset.card_le_univ _ ) ( by decide )
/-- OR of two SSP masks, representing the union of prime support sets.
Useful for computing combined support under tensor product.
**Informal source**: "applying irrep masks via tensor product stays within
the Monster's 194 conjugacy classes" -/
def SSPMask.union (m1 m2 : SSPMask) : SSPMask := m1 ||| m2
/-- AND of two SSP masks, representing the intersection of prime support sets.
**Informal source**: intersection operation on SSP support -/
def SSPMask.inter (m1 m2 : SSPMask) : SSPMask := m1 &&& m2
/-- The i-th supersingular prime for a given bit position.
**Informal source**: "bits 0..14 correspond to the 15 supersingular primes" -/
def sspPrimeAt (i : Fin 15) : ℕ :=
  supersingularPrimesList[i]
/-- All primes returned by `sspPrimeAt` are prime.
**Informal source**: each bit position corresponds to a prime -/
theorem sspPrimeAt_prime (i : Fin 15) : Nat.Prime (sspPrimeAt i) := by
  fin_cases i <;> native_decide
/-- Extract the set of supersingular primes corresponding to the set bits
of a mask.
**Informal source**: "15-bit SSP support vector" — decoding the mask to actual primes -/
def SSPMask.toPrimeSet (m : SSPMask) : Finset ℕ :=
  m.setBits.image sspPrimeAt
/-
The prime set of any mask is a subset of the supersingular primes.
**Informal source**: masks only encode supersingular primes
-/
theorem SSPMask.toPrimeSet_subset (m : SSPMask) :
    m.toPrimeSet ⊆ supersingularPrimes := by
  exact Finset.image_subset_iff.mpr fun i hi => by fin_cases i <;> trivial;
