import Mathlib

/-!
# Moonshine combinatorics: supersingular primes, the Oggorial, FRACTRAN blades and Cl(15)

This file integrates the *machine-verifiable* combinatorial and arithmetic skeleton of the
"moonshine" discussion attached to the project (FRACTRAN templates as graded spaces, the
`Cl(15)` blade hypercube on the 15 supersingular primes, the "Oggorial", and the irrep-161
"hub").

We deliberately formalize only what can be proved with certainty.  The deeper *conjectural*
claims of the discussion — that the path-counting generating functions are mock modular
forms of weight `1/2` or `3/2`, that there is a genuine "fractional umbral moonshine"
module structure, or that intertwining operators of a vertex algebra are literally encoded
by FRACTRAN fractions — are **not** established mathematics and are therefore not asserted
as theorems here.  What *is* solid, and is proved below, is:

* the 15 supersingular (Ogg) primes, their primality, and their product (the **Oggorial**);
* the `Cl(15)` graded dimensions: the binomial row `C(15,k)` and `∑_k C(15,k) = 2¹⁵`;
* the **blade hypercube** `Finset (Fin 15)`, with the Oggorial as the grade-15 pseudoscalar,
  the squarefree integer encoding of a blade, and the FRACTRAN "remove a prime" step;
* the **confluence theorem** `removeStep_comm`: removing two primes in either order gives the
  same blade — this is the elementary, provable core of the claimed "FRACTRAN ↔ associative
  OPE" correspondence (it is just commutativity of `Finset.erase`);
* the **irrep-161 "hub"** arithmetic: its supersingular support is everything except
  `{11, 23}`, it sits at grade `13` (Hamming distance `2` from the Oggorial), and its
  squarefree value is exactly `Oggorial / 253` with `253 = 11·23`;
* the **CRT orbifold datum** `(8 mod 47, 20 mod 59, 58 mod 71)` from the attached sheaf
  metadata: `47, 59, 71` are pairwise coprime with product `196883`, and the triple is
  realized by the unique residue `116427 < 196883`.
-/

open scoped BigOperators

namespace Moonshine

/-! ## The 15 supersingular primes and the Oggorial -/

/-- The 15 supersingular (Ogg) primes, in increasing order. -/
def ssPrimes : List ℕ := [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71]

theorem ssPrimes_length : ssPrimes.length = 15 := rfl

/-- Every entry of `ssPrimes` is prime. -/
theorem ssPrimes_all_prime : ∀ p ∈ ssPrimes, Nat.Prime p := by decide

theorem ssPrimes_nodup : ssPrimes.Nodup := by decide

/-- The **Oggorial**: the product of the 15 supersingular primes. -/
theorem ssPrimes_prod : ssPrimes.prod = 1618964990108856390 := by norm_num [ssPrimes]

/-! ## The `Cl(15)` graded dimensions -/

/-- The graded dimensions of the Clifford algebra `Cl(15)` are the binomial row `C(15,k)`. -/
theorem clifford_grades :
    (List.range 16).map (Nat.choose 15)
      = [1, 15, 105, 455, 1365, 3003, 5005, 6435, 6435, 5005, 3003, 1365, 455, 105, 15, 1] := by
  decide

/-- The total dimension of `Cl(15)` is `∑_k C(15,k) = 2¹⁵ = 32768`. -/
theorem clifford_total : ∑ k ∈ Finset.range 16, Nat.choose 15 k = 32768 := by
  have h := Nat.sum_range_choose 15
  norm_num at h ⊢
  rw [h]

/-- The two half-spinor representations of `Cl(15)` each have dimension `2¹⁴ = 16384`. -/
theorem clifford_half_spinor : (2 : ℕ) ^ 14 = 16384 := by norm_num

/-! ## The blade hypercube on the supersingular primes -/

/-- A `Cl(15)` blade: a subset of the 15 supersingular primes (a vertex of the hypercube). -/
abbrev Blade := Finset (Fin 15)

/-- The Oggorial as the grade-15 pseudoscalar: all 15 primes present. -/
def oggorial : Blade := Finset.univ

/-- The grade of a blade is its number of primes (its Hamming weight). -/
def grade (b : Blade) : ℕ := b.card

theorem oggorial_grade : grade oggorial = 15 := by decide

/-- The supersingular prime attached to a hypercube coordinate. -/
def ssVal (i : Fin 15) : ℕ := ssPrimes.getD i.1 1

/-- The squarefree integer encoding of a blade: the product of its supersingular primes. -/
def bladeToNat (b : Blade) : ℕ := ∏ i ∈ b, ssVal i

/-- The Oggorial pseudoscalar encodes to the Oggorial integer. -/
theorem bladeToNat_oggorial : bladeToNat oggorial = 1618964990108856390 := by decide

/-! ## FRACTRAN "remove a prime" steps and confluence -/

/-- A FRACTRAN-style descent step: remove a prime from a blade if it is present
(this is multiplication by the fraction `1/p`), otherwise the rule does not fire. -/
def removeStep (b : Blade) (p : Fin 15) : Option Blade :=
  if p ∈ b then some (b.erase p) else none

/-
**Confluence.** Removing two primes from a blade gives the same result in either
order. This is the elementary, provable core of the claimed "FRACTRAN ↔ associative OPE"
correspondence: it is exactly commutativity of `Finset.erase`.
-/
theorem removeStep_comm (b : Blade) (p q : Fin 15) :
    (removeStep b p >>= fun b' => removeStep b' q)
      = (removeStep b q >>= fun b' => removeStep b' p) := by
  unfold removeStep;
  aesop

/-! ## The irrep-161 "hub" -/

/-- The supersingular support of Monster irrep #161: all primes except `11` (index `4`)
and `23` (index `8`). -/
def irrep161Support : Blade := Finset.univ \ {4, 8}

/-- Irrep 161 sits at grade `13`: Hamming distance `2` from the full Oggorial. -/
theorem irrep161_grade : grade irrep161Support = 13 := by decide

/-- The two primes missing from the irrep-161 hub are `11` and `23` (indices `4` and `8`). -/
theorem irrep161_missing : oggorial \ irrep161Support = {4, 8} := by decide

/-- `253 = 11 · 23`, the product of the two primes missing at the hub. -/
theorem two_five_three : ssVal 4 * ssVal 8 = 253 := by decide

/-- The squarefree value of the irrep-161 hub is exactly `Oggorial / 253`:
`bladeToNat(hub) · 253 = Oggorial`. -/
theorem irrep161_value : bladeToNat irrep161Support * 253 = bladeToNat oggorial := by decide

/-! ## The CRT orbifold datum `(8 mod 47, 20 mod 59, 58 mod 71)` -/

/-- The three largest supersingular primes are pairwise coprime. -/
theorem ss_top_coprime :
    Nat.Coprime 47 59 ∧ Nat.Coprime 59 71 ∧ Nat.Coprime 47 71 := by decide

/-- Their product is the smallest faithful Monster dimension, `196883`. -/
theorem ss_top_prod : 47 * 59 * 71 = 196883 := by norm_num

/-- The sheaf metadata orbifold triple `(8 mod 47, 20 mod 59, 58 mod 71)` is realized by
the unique residue `116427 < 196883` (Chinese Remainder Theorem). -/
theorem orbifold_crt :
    116427 < 196883 ∧ 116427 % 47 = 8 ∧ 116427 % 59 = 20 ∧ 116427 % 71 = 58 := by
  decide

end Moonshine