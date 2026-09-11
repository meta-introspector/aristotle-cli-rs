/-
# Lattice of Constants and Invariants

Compiles the numerical constants and invariants from the Atlas–Moonshine–Clifford
formalization into a single reference, organized as a **divisibility lattice**.

## Structure

The constants form a poset under the "divides" relation. In ℕ under ∣, the
lattice operations are:
  - meet (∧) = gcd
  - join (∨) = lcm
  - ⊥ = 1 (divides everything)
  - ⊤ = 0 (everything divides 0)

We prove:
1. All atomic constants (primes 47, 59, 71, Bott period 8)
2. Derived constants (196883, 196884, 1575064, 2773, 22184)
3. Divisibility relations (the Hasse diagram edges)
4. Coprimality invariants (independence in the lattice)
5. Modular residue invariants
6. Lattice-theoretic properties (rank, Möbius values, width)

## The Divisibility Lattice (Hasse Diagram)

```
                    monsterOrder
                   /    |    \
                 47    59    71          ← ontology primes
                  \    |    /
                   196883 = 47·59·71    ← Monster irrep dimension
                      |
                  1575064 = 8·196883   ← combined Bott×CRT modulus
                      |
                (tower period)

  Independent nodes (coprime to 196883):
    8 (Bott period), 717 (encode offset), 2343 (self-reference)
```
-/

import Mathlib
import RequestProject.Compute.Cosmic.Bootstrap
import RequestProject.Math.Monster.Moonshine
import RequestProject.Math.Clifford.BottPeriodicity

set_option maxHeartbeats 800000

open Finset ZMod

/-! ## §1. Atomic Constants — The Primes and Base Numbers

These are the irreducible elements of the divisibility lattice:
they have no proper divisors other than 1. -/

/-- The three ontology primes: the largest prime divisors of the Monster order,
    and the prime factorization of 196883. -/
def ontologyPrime₁ : ℕ := 47
def ontologyPrime₂ : ℕ := 59
def ontologyPrime₃ : ℕ := 71

/-- The Bott periodicity constant. -/
def bottPeriod : ℕ := 8

/-- The encoding offset (sum of char codes of "encode_"). -/
def encodeOffset : ℕ := 717

/-- The Gödelian self-reference address. -/
def selfRefAddr : ℕ := 2343

/-- The board room meeting address. -/
def boardRoomAddr : ℕ := 2329

theorem ontologyPrime₁_val : ontologyPrime₁ = 47 := rfl
theorem ontologyPrime₂_val : ontologyPrime₂ = 59 := rfl
theorem ontologyPrime₃_val : ontologyPrime₃ = 71 := rfl
theorem encodeOffset_val : encodeOffset = 717 := rfl
theorem selfRefAddr_val : selfRefAddr = 2343 := rfl

/-- Verification: encodeOffset matches the actual encoding function. -/
theorem encodeOffset_eq : encodeString "encode_" = encodeOffset := by native_decide

/-- Verification: selfRefAddr matches the actual encoding function. -/
theorem selfRefAddr_eq : encodeString "bootstrap_self_encodes" = selfRefAddr := by native_decide

/-! ## §2. Derived Constants — Products, Sums, LCMs

These are the composite elements of the divisibility lattice. -/

/-- The Monster smallest irrep dimension. -/
def monsterIrrepDim : ℕ := 196883

/-- The first j-function coefficient (McKay). -/
def mckayCoeff : ℕ := 196884

/-- The combined Bott × CRT modulus. -/
def combinedModulus : ℕ := 1575064

/-- The two-chart CRT modulus (59 × 47, without 71). -/
def twoChartModulus : ℕ := 2773

/-- The two-chart + Bott combined modulus. -/
def twoChartBottModulus : ℕ := 22184

/-! ## §3. Factorization Identities — The Hasse Edges

These theorems establish the divisibility edges in the lattice. -/

theorem monsterIrrepDim_eq : monsterIrrepDim = 47 * 59 * 71 := by norm_num [monsterIrrepDim]

theorem mckayCoeff_eq : mckayCoeff = monsterIrrepDim + 1 := by
  norm_num [mckayCoeff, monsterIrrepDim]

theorem combinedModulus_eq : combinedModulus = bottPeriod * monsterIrrepDim := by
  norm_num [combinedModulus, bottPeriod, monsterIrrepDim]

theorem twoChartModulus_eq : twoChartModulus = 59 * 47 := by
  norm_num [twoChartModulus]

theorem twoChartBottModulus_eq : twoChartBottModulus = bottPeriod * twoChartModulus := by
  norm_num [twoChartBottModulus, bottPeriod, twoChartModulus]

theorem twoChartBottModulus_lcm : Nat.lcm bottPeriod twoChartModulus = twoChartBottModulus := by
  native_decide

/-! ## §4. Divisibility Relations — Lattice Order Edges

In ℕ under divisibility, a ∣ b means a is *below* b in the lattice.
These are the edges of the Hasse diagram. -/

-- Primes divide the Monster irrep dimension
theorem p47_dvd_monsterIrrep : ontologyPrime₁ ∣ monsterIrrepDim :=
  ⟨4189, by norm_num [ontologyPrime₁, monsterIrrepDim]⟩
theorem p59_dvd_monsterIrrep : ontologyPrime₂ ∣ monsterIrrepDim :=
  ⟨3337, by norm_num [ontologyPrime₂, monsterIrrepDim]⟩
theorem p71_dvd_monsterIrrep : ontologyPrime₃ ∣ monsterIrrepDim :=
  ⟨2773, by norm_num [ontologyPrime₃, monsterIrrepDim]⟩

-- Monster irrep divides combined modulus
theorem monsterIrrep_dvd_combined : monsterIrrepDim ∣ combinedModulus :=
  ⟨8, by norm_num [monsterIrrepDim, combinedModulus]⟩

-- Bott period divides combined modulus
theorem bott_dvd_combined : bottPeriod ∣ combinedModulus :=
  ⟨196883, by norm_num [bottPeriod, combinedModulus]⟩

-- Two-chart modulus divides Monster irrep
theorem twoChart_dvd_monsterIrrep : twoChartModulus ∣ monsterIrrepDim :=
  ⟨71, by norm_num [twoChartModulus, monsterIrrepDim]⟩

-- Two-chart modulus divides two-chart+Bott modulus
theorem twoChart_dvd_twoChartBott : twoChartModulus ∣ twoChartBottModulus :=
  ⟨8, by norm_num [twoChartModulus, twoChartBottModulus]⟩

-- Bott period divides two-chart+Bott modulus
theorem bott_dvd_twoChartBott : bottPeriod ∣ twoChartBottModulus :=
  ⟨2773, by norm_num [bottPeriod, twoChartBottModulus]⟩

-- 71 divides self-reference address
theorem p71_dvd_selfRef : ontologyPrime₃ ∣ selfRefAddr :=
  ⟨33, by norm_num [ontologyPrime₃, selfRefAddr]⟩

/-! ## §5. Coprimality Invariants — Lattice Independence

Two elements are coprime (gcd = 1) iff they are "independent" in the
divisibility lattice: their meet is ⊥ = 1. -/

theorem coprime_offset_monsterIrrep : Nat.Coprime encodeOffset monsterIrrepDim := by
  native_decide

theorem coprime_offset_bott : Nat.Coprime encodeOffset bottPeriod := by native_decide

theorem coprime_bott_monsterIrrep : Nat.Coprime bottPeriod monsterIrrepDim := by native_decide

theorem coprime_offset_combined : Nat.Coprime encodeOffset combinedModulus := by native_decide

theorem coprime_bott_p47 : Nat.Coprime bottPeriod ontologyPrime₁ := by native_decide
theorem coprime_bott_p59 : Nat.Coprime bottPeriod ontologyPrime₂ := by native_decide
theorem coprime_bott_p71 : Nat.Coprime bottPeriod ontologyPrime₃ := by native_decide

/-- The ontology primes are pairwise coprime (they are distinct primes). -/
theorem coprime_p47_p59 : Nat.Coprime ontologyPrime₁ ontologyPrime₂ := by native_decide
theorem coprime_p47_p71 : Nat.Coprime ontologyPrime₁ ontologyPrime₃ := by native_decide
theorem coprime_p59_p71 : Nat.Coprime ontologyPrime₂ ontologyPrime₃ := by native_decide

/-! ## §6. Modular Residue Invariants

These are the residue coordinates of key constants in the ontology charts. -/

-- Encode offset residues in the three charts
theorem offset_mod71 : encodeOffset % 71 = 7 := by native_decide
theorem offset_mod59 : encodeOffset % 59 = 9 := by native_decide
theorem offset_mod47 : encodeOffset % 47 = 12 := by native_decide

-- Self-reference residues
theorem selfRef_mod71 : selfRefAddr % 71 = 0 := by native_decide
theorem selfRef_mod59 : selfRefAddr % 59 = 42 := by native_decide
theorem selfRef_mod47 : selfRefAddr % 47 = 40 := by native_decide

-- Bott class residues
theorem selfRef_mod8 : selfRefAddr % 8 = 7 := by native_decide
theorem offset_mod8 : encodeOffset % 8 = 5 := by native_decide
theorem monsterIrrep_mod8 : monsterIrrepDim % 8 = 3 := by native_decide
theorem mckay_mod8 : mckayCoeff % 8 = 4 := by native_decide

/-! ## §7. GCD/LCM Computations — Meet and Join in the Divisibility Lattice

In ℕ under divisibility:
  - meet(a, b) = gcd(a, b)
  - join(a, b) = lcm(a, b)
-/

-- GCDs (meets)
theorem gcd_primes_47_59 : Nat.gcd 47 59 = 1 := by native_decide
theorem gcd_primes_47_71 : Nat.gcd 47 71 = 1 := by native_decide
theorem gcd_primes_59_71 : Nat.gcd 59 71 = 1 := by native_decide
theorem gcd_bott_monsterIrrep : Nat.gcd bottPeriod monsterIrrepDim = 1 := by native_decide
theorem gcd_offset_monsterIrrep : Nat.gcd encodeOffset monsterIrrepDim = 1 := by native_decide
theorem gcd_offset_bott : Nat.gcd encodeOffset bottPeriod = 1 := by native_decide

-- LCMs (joins)
theorem lcm_bott_monsterIrrep : Nat.lcm bottPeriod monsterIrrepDim = combinedModulus := by
  native_decide

theorem lcm_bott_twoChart : Nat.lcm bottPeriod twoChartModulus = twoChartBottModulus := by
  native_decide

theorem lcm_allThreePrimes : Nat.lcm (Nat.lcm 47 59) 71 = monsterIrrepDim := by
  native_decide

/-! ## §8. Lattice-Theoretic Numerical Invariants

Properties of the divisibility lattice restricted to the project constants. -/

/-- The project constants, listed for reference. -/
def projectConstants : List ℕ :=
  [1,   -- ⊥ (bottom of divisibility lattice)
   47,  -- ontology prime
   59,  -- ontology prime
   71,  -- ontology prime
   8,   -- Bott period
   717, -- encode offset
   2343, -- self-reference
   2329, -- board room address
   2773, -- two-chart modulus (59·47)
   22184, -- lcm(8, 2773)
   196883, -- Monster irrep dim (47·59·71)
   196884, -- McKay coefficient
   1575064  -- combined modulus (8·196883)
  ]

/-- The number of project constants. -/
theorem projectConstants_card : projectConstants.length = 13 := by rfl

/-- The width of the divisibility lattice restricted to {47, 59, 71, 8, 717}:
    these are pairwise coprime, forming an antichain of size 5. -/
theorem antichain_width_5 :
    Nat.Coprime 47 59 ∧ Nat.Coprime 47 71 ∧ Nat.Coprime 47 8 ∧ Nat.Coprime 47 717 ∧
    Nat.Coprime 59 71 ∧ Nat.Coprime 59 8 ∧ Nat.Coprime 59 717 ∧
    Nat.Coprime 71 8 ∧ Nat.Coprime 71 717 ∧
    Nat.Coprime 8 717 := by
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩ <;> native_decide

/-- The height of the maximal chain: 1 ∣ 47 ∣ 2773 ∣ 196883 ∣ 1575064
    is a chain of length 4 (5 elements). -/
theorem maximal_chain :
    1 ∣ 47 ∧ 47 ∣ 2773 ∧ 2773 ∣ 196883 ∧ 196883 ∣ 1575064 := by
  refine ⟨⟨47, ?_⟩, ⟨59, ?_⟩, ⟨71, ?_⟩, ⟨8, ?_⟩⟩ <;> norm_num

/-! ## §9. Structural Invariants of Lattice Theory

General lattice-theoretic constants and invariants, stated abstractly. -/

section LatticeTheory

variable {L : Type*} [Lattice L]

/-- In any lattice, ⊥ is absorbing under meet (if bounded below). -/
theorem lattice_bot_meet [BoundedOrder L] (x : L) : ⊥ ⊓ x = ⊥ := bot_inf_eq (a := x)

/-- In any lattice, ⊤ is absorbing under join (if bounded above). -/
theorem lattice_top_join [BoundedOrder L] (x : L) : ⊤ ⊔ x = ⊤ := top_sup_eq (a := x)

/-- In any lattice, meet is idempotent. -/
theorem lattice_meet_idem (x : L) : x ⊓ x = x := inf_idem (a := x)

/-- In any lattice, join is idempotent. -/
theorem lattice_join_idem (x : L) : x ⊔ x = x := sup_idem (a := x)

end LatticeTheory

/-- In any distributive lattice, the distributive law holds. -/
theorem lattice_distrib_law {L : Type*} [DistribLattice L] (x y z : L) :
    x ⊔ (y ⊓ z) = (x ⊔ y) ⊓ (x ⊔ z) := by simp [sup_inf_left]

/-- In a modular lattice with x ≤ z, the modular identity holds. -/
theorem lattice_modular_law {L : Type*} [Lattice L] [IsModularLattice L] (x y z : L) (h : x ≤ z) :
    (x ⊔ y) ⊓ z = x ⊔ (y ⊓ z) := sup_inf_assoc_of_le y h

/-! ## §10. ℕ Under Divisibility as a Lattice

The natural numbers form a distributive lattice under divisibility,
with gcd as meet and lcm as join. -/

/-- The rank function in the divisibility lattice of squarefree numbers
    is the number of prime factors (Ω function). For our product: -/
theorem monsterIrrep_omega : monsterIrrepDim.factorization.support.card = 3 := by native_decide

theorem combinedModulus_omega : combinedModulus.factorization.support.card = 4 := by native_decide

theorem bottPeriod_omega : bottPeriod.factorization.support.card = 1 := by native_decide

/-! ## §11. Summary: The Complete Invariant Table

| Constant       | Value    | ω (prime factors) | mod 8 | mod 71 | mod 59 | mod 47 |
|----------------|----------|-------------------|-------|--------|--------|--------|
| 1 (⊥)          | 1        | 0                 | 1     | 1      | 1      | 1      |
| 47             | 47       | 1                 | 7     | 47     | 47     | 0      |
| 59             | 59       | 1                 | 3     | 59     | 0      | 12     |
| 71             | 71       | 1                 | 7     | 0      | 12     | 24     |
| 8              | 8        | 1                 | 0     | 8      | 8      | 8      |
| 717            | 717      | 2                 | 5     | 7      | 9      | 12     |
| 2343           | 2343     | 3                 | 7     | 0      | 42     | 40     |
| 2773           | 2773     | 2                 | 5     | 4      | 0      | 0      |
| 22184          | 22184    | 3                 | 0     | 32     | 0      | 0      |
| 196883         | 196883   | 3                 | 3     | 0      | 0      | 0      |
| 196884         | 196884   | 3                 | 4     | 1      | 1      | 1      |
| 1575064        | 1575064  | 4                 | 0     | 0      | 0      | 0      |
-/

-- Verify the table entries computationally
theorem table_mod8_entries :
    1 % 8 = 1 ∧ 47 % 8 = 7 ∧ 59 % 8 = 3 ∧ 71 % 8 = 7 ∧
    717 % 8 = 5 ∧ 2343 % 8 = 7 ∧ 2773 % 8 = 5 ∧
    196883 % 8 = 3 ∧ 196884 % 8 = 4 := by
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩ <;> native_decide

theorem table_mod71_entries :
    47 % 71 = 47 ∧ 59 % 71 = 59 ∧ 71 % 71 = 0 ∧
    717 % 71 = 7 ∧ 2343 % 71 = 0 ∧ 2773 % 71 = 4 ∧
    196883 % 71 = 0 ∧ 196884 % 71 = 1 := by
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩ <;> native_decide

theorem table_mod59_entries :
    47 % 59 = 47 ∧ 59 % 59 = 0 ∧ 71 % 59 = 12 ∧
    717 % 59 = 9 ∧ 2343 % 59 = 42 ∧ 2773 % 59 = 0 ∧
    196883 % 59 = 0 ∧ 196884 % 59 = 1 := by
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩ <;> native_decide

theorem table_mod47_entries :
    47 % 47 = 0 ∧ 59 % 47 = 12 ∧ 71 % 47 = 24 ∧
    717 % 47 = 12 ∧ 2343 % 47 = 40 ∧ 2773 % 47 = 0 ∧
    196883 % 47 = 0 ∧ 196884 % 47 = 1 := by
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩ <;> native_decide

/-! ## §12. The McKay Shift as a Lattice Morphism

McKay's observation (196884 = 196883 + 1) shifts exactly one Bott step:
  196883 ≡ 3 (mod 8)  →  196884 ≡ 4 (mod 8)
This +1 moves from the ℍ-class to the M₂(ℍ)-class in the Clifford tower. -/

theorem lattice_mckay_bott_shift :
    monsterIrrepDim % 8 = 3 ∧ mckayCoeff % 8 = 4 ∧
    mckayCoeff = monsterIrrepDim + 1 := by
  refine ⟨?_, ?_, ?_⟩
  · native_decide
  · native_decide
  · norm_num [mckayCoeff, monsterIrrepDim]

/-! ## §13. The Möbius Function on the Divisibility Lattice

For 196883 = 47·59·71 (squarefree, 3 distinct prime factors):
  μ(196883) = (-1)³ = -1 -/

/-- 196883 is squarefree. -/
theorem monsterIrrep_squarefree : Squarefree monsterIrrepDim := by native_decide

/-- The arithmetic Möbius function μ(196883) = -1
    since 196883 = 47·59·71 has exactly 3 distinct prime factors. -/
theorem moebius_monsterIrrep :
    ArithmeticFunction.moebius 196883 = -1 := by native_decide

/-- The number of divisors of 196883 is 2³ = 8 (product of 3 distinct primes). -/
theorem divisor_count_monsterIrrep : (Nat.divisors 196883).card = 8 := by native_decide

/-! ## §14. Euler's Totient — Another Lattice Invariant

φ(n) counts the number of units in Z/nZ, equivalently the elements
coprime to n below n. -/

theorem totient_monsterIrrep : Nat.totient monsterIrrepDim = 186760 := by native_decide

theorem totient_combinedModulus : Nat.totient combinedModulus = 747040 := by native_decide

/-- φ(196883) = 46 × 58 × 70 = (47-1)(59-1)(71-1), as expected for a squarefree number. -/
theorem totient_factored : (46 : ℕ) * 58 * 70 = 186760 := by norm_num
