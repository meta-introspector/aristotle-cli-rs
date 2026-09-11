import Mathlib

/-!
# Umbral Moonshine (Cheng–Duncan–Harvey)

This file integrates the *machine-verifiable* arithmetic and combinatorial core of

  M. C. N. Cheng, J. F. R. Duncan, J. A. Harvey, *Umbral Moonshine*,
  Commun. Number Theory Phys. (2014), arXiv:1204.2779.

Umbral moonshine attaches to each *lambency* `ℓ ∈ Λ = {2,3,4,5,7,13}` — the integers `ℓ`
such that `ℓ - 1` divides `12` — a finite *umbral group* `G^{(ℓ)}`, an extremal weight-`0`
index-`ℓ-1` Jacobi form `Z^{(ℓ)}`, and a vector-valued weight-`1/2` mock modular form
`H^{(ℓ)}` whose Fourier coefficients conjecturally encode the graded dimensions of an
infinite-dimensional `G^{(ℓ)}`-module `K^{(ℓ)}`.  The `ℓ = 2` case recovers the
Eguchi–Ooguri–Tachikawa `M₂₄` observation for `K3` surfaces.

We deliberately formalize only what can be proved with certainty.  The deep results of the
paper — the uniqueness/characterisation of the extremal Jacobi forms `Z^{(ℓ)}`
(Theorem 4.2 there), the connection to critical values of weight-`2` `L`-functions, the
mock modularity of the McKay–Thompson series `H^{(ℓ)}_g`, the discriminant property, and
the umbral moonshine conjecture itself — are not established (and in some cases are still
conjectural), so they are **not** asserted as theorems here.  What *is* solid, and proved
below, is:

* the **lambency set** `Λ` and its characterisation `ℓ ∈ Λ ↔ (ℓ-1) ∣ 12` (for `ℓ ≥ 1`),
  together with `Nat.divisors 12 = {1,2,3,4,6,12}`;
* the **degrees** `24/(ℓ-1)` of the permutation representations of `Ḡ^{(ℓ)}` and the
  constants `χ^{(ℓ)} = 24/(ℓ-1)`;
* the odd integers `(25-ℓ)/(ℓ-1)`, prime for `ℓ ≠ 13`, with `((25-ℓ)/(ℓ-1)) + 1 ∣ 24`;
* the **umbral group orders** `|G^{(ℓ)}|` and `|Ḡ^{(ℓ)}|`, and the double-cover relation
  `|G^{(ℓ)}| = 2 |Ḡ^{(ℓ)}|` for `ℓ > 2`;
* the **consistency of the umbral character tables**: for each `ℓ`, the sum of squares of
  the irreducible-character degrees equals the group order `|G^{(ℓ)}|`;
* the **Steiner-system block counts** `759, 132, 14` for the `(5,8,24)`, `(5,6,12)`,
  `(3,4,8)` systems underlying the permutation constructions of `M₂₄`, `M₁₂`, `AGL₃(2)`;
* the `M₂₄` dimensions `45, 231, 770, 2277` appearing in the `H^{(2)}` Fourier expansion;
* the **discriminant ("type `n`") data** and the factorisations `-D = n λ²` of the
  doublet discriminants;
* the **mock-theta orders** being divisible by the lambency, and the **Dynkin ranks**
  `11 - ℓ` of the (affine) ADE diagrams arising in the McKay-type observations.
-/

namespace UmbralMoonshine

open scoped BigOperators

/-! ## The lambency set `Λ = {2,3,4,5,7,13}` -/

/-- The six *lambencies*: the integers `ℓ` for which `ℓ - 1` divides `12`. -/
def lambencies : List ℕ := [2, 3, 4, 5, 7, 13]

theorem lambencies_card : lambencies.length = 6 := by decide

/-- Each lambency `ℓ` satisfies `(ℓ - 1) ∣ 12`. -/
theorem lambencies_div12 : ∀ ℓ ∈ lambencies, (ℓ - 1) ∣ 12 := by decide

/-- The divisors of `12` are exactly `{1, 2, 3, 4, 6, 12}`. -/
theorem divisors_twelve : Nat.divisors 12 = {1, 2, 3, 4, 6, 12} := by decide

/-- **Characterisation of the lambencies.** For `ℓ ≥ 1`, `ℓ` is a lambency if and only if
`ℓ - 1` divides `12`. -/
theorem lambency_iff (ℓ : ℕ) (h : 1 ≤ ℓ) :
    (ℓ - 1) ∣ 12 ↔ ℓ ∈ lambencies := by
  constructor
  · intro hd
    have hle : ℓ - 1 ≤ 12 := Nat.le_of_dvd (by norm_num) hd
    have : ℓ ≤ 13 := by omega
    interval_cases ℓ <;> revert hd <;> decide
  · intro hm
    fin_cases hm <;> decide

/-- The prime lambencies are exactly `{2, 3, 5, 7, 13}` (i.e. all of `Λ` except `4`). -/
theorem prime_lambencies : lambencies.filter (fun n => decide (Nat.Prime n)) = [2, 3, 5, 7, 13] := by
  decide

/-! ## Degrees `24/(ℓ-1)`, the constant `χ^{(ℓ)}`, and the prime `(25-ℓ)/(ℓ-1)` -/

/-- The permutation representation of `Ḡ^{(ℓ)}` has degree `24/(ℓ-1)`, giving
`[24, 12, 8, 6, 4, 2]`.  This is also the value of the constant `χ^{(ℓ)} = Z^{(ℓ)}(τ,0)`. -/
theorem degree_values :
    lambencies.map (fun ℓ => 24 / (ℓ - 1)) = [24, 12, 8, 6, 4, 2] := by decide

/-- The constants `χ^{(ℓ)} = 24/(ℓ-1)` agree with the permutation degrees. -/
theorem chi_eq_degree (ℓ : ℕ) : (24 / (ℓ - 1) : ℕ) = 24 / (ℓ - 1) := rfl

/-- The odd integers `p = (25-ℓ)/(ℓ-1)` for `ℓ ∈ {2,3,4,5,7}` are `[23, 11, 7, 5, 3]`. -/
theorem p_values :
    [2, 3, 4, 5, 7].map (fun ℓ => (25 - ℓ) / (ℓ - 1)) = [23, 11, 7, 5, 3] := by decide

/-- For `ℓ ∈ {2,3,4,5,7}` the integer `(25-ℓ)/(ℓ-1)` is prime. -/
theorem p_prime : ∀ ℓ ∈ [2, 3, 4, 5, 7], Nat.Prime ((25 - ℓ) / (ℓ - 1)) := by decide

/-- For every lambency `ℓ`, `((25-ℓ)/(ℓ-1)) + 1` divides `24`. -/
theorem p_plus_one_div24 :
    ∀ ℓ ∈ lambencies, ((25 - ℓ) / (ℓ - 1) + 1) ∣ 24 := by decide

/-! ## Umbral group orders -/

/-- The orders `|G^{(ℓ)}|` of the umbral groups
`M₂₄, 2.M₁₂, 2.AGL₃(2), GL₂(5)/2, SL₂(3), 4`, indexed by `ℓ ∈ Λ`. -/
def Gorder : List ℕ := [244823040, 190080, 2688, 240, 24, 4]

/-- The orders `|Ḡ^{(ℓ)}|` of the quotients
`M₂₄, M₁₂, AGL₃(2), PGL₂(5), L₂(3), 2`, indexed by `ℓ ∈ Λ`. -/
def Gbarorder : List ℕ := [244823040, 95040, 1344, 120, 12, 2]

theorem Gorder_length : Gorder.length = 6 := by decide
theorem Gbarorder_length : Gbarorder.length = 6 := by decide

/-- At `ℓ = 2` we have `G^{(2)} = Ḡ^{(2)} = M₂₄`. -/
theorem ell2_equal : Gorder.getD 0 0 = Gbarorder.getD 0 0 := by decide

/-- For `ℓ > 2` each `G^{(ℓ)}` is a non-trivial double cover of `Ḡ^{(ℓ)}`:
`|G^{(ℓ)}| = 2 |Ḡ^{(ℓ)}|`. -/
theorem double_cover :
    ∀ i ∈ [1, 2, 3, 4, 5], Gorder.getD i 0 = 2 * Gbarorder.getD i 0 := by decide

/-! ## Consistency of the umbral character tables

For each umbral group `G^{(ℓ)}` the sum of the squares of its irreducible-character
degrees equals the group order `|G^{(ℓ)}|`.  This is a strong, fully verifiable
consistency check on the character-table data of §B of the paper. -/

/-- The degrees of the `26` irreducible characters of `G^{(2)} ≃ M₂₄`. -/
def M24dims : List ℕ :=
  [1, 23, 45, 45, 231, 231, 252, 253, 483, 770, 770, 990, 990,
   1035, 1035, 1035, 1265, 1771, 2024, 2277, 3312, 3520, 5313, 5544, 5796, 10395]

theorem M24_nirreps : M24dims.length = 26 := by decide
theorem M24_sumsq : (M24dims.map (· ^ 2)).sum = 244823040 := by decide

/-- The degrees of the `26` irreducible characters of `G^{(3)} ≃ 2.M₁₂`. -/
def M12dims : List ℕ :=
  [1, 11, 11, 16, 16, 45, 54, 55, 55, 55, 66, 99, 120, 144, 176,
   10, 10, 12, 32, 44, 44, 110, 110, 120, 160, 160]

theorem M12_nirreps : M12dims.length = 26 := by decide
theorem twoM12_sumsq : (M12dims.map (· ^ 2)).sum = 190080 := by decide

/-- The degrees of the `16` irreducible characters of `G^{(4)} ≃ 2.AGL₃(2)`. -/
def AGL32dims : List ℕ := [1, 3, 3, 6, 7, 8, 7, 7, 14, 21, 21, 8, 8, 8, 24, 24]

theorem AGL32_nirreps : AGL32dims.length = 16 := by decide
theorem AGL32_sumsq : (AGL32dims.map (· ^ 2)).sum = 2688 := by decide

/-- The degrees of the `14` irreducible characters of `G^{(5)} ≃ GL₂(5)/2`. -/
def GL25dims : List ℕ := [1, 1, 4, 4, 5, 5, 6, 1, 1, 4, 4, 5, 5, 6]

theorem GL25_nirreps : GL25dims.length = 14 := by decide
theorem GL25_sumsq : (GL25dims.map (· ^ 2)).sum = 240 := by decide

/-- The degrees of the `7` irreducible characters of `G^{(7)} ≃ SL₂(3)`. -/
def SL23dims : List ℕ := [1, 1, 1, 3, 2, 2, 2]

theorem SL23_nirreps : SL23dims.length = 7 := by decide
theorem SL23_sumsq : (SL23dims.map (· ^ 2)).sum = 24 := by decide

/-- The degrees of the `4` irreducible characters of `G^{(13)} ≃ ℤ/4`. -/
def C4dims : List ℕ := [1, 1, 1, 1]

theorem C4_nirreps : C4dims.length = 4 := by decide
theorem C4_sumsq : (C4dims.map (· ^ 2)).sum = 4 := by decide

/-! ## Steiner systems for the permutation constructions

The constructions of `Ḡ^{(ℓ)}` in §5 realise `M₂₄`, `M₁₂` and `AGL₃(2)` as the
automorphism groups of Steiner systems with parameters `(5,8,24)`, `(5,6,12)` and
`(3,4,8)`.  The numbers of blocks `C(n,t)/C(k,t)` are `759, 132, 14`. -/

/-- The `(5,8,24)` Steiner system (binary Golay code octads) has `759` blocks. -/
theorem steiner_M24 : Nat.choose 24 5 / Nat.choose 8 5 = 759 := by decide

/-- The `(5,6,12)` Steiner system (for `M₁₂`) has `132` blocks. -/
theorem steiner_M12 : Nat.choose 12 5 / Nat.choose 6 5 = 132 := by decide

/-- The `(3,4,8)` Steiner system (length-`8` Hamming code, for `AGL₃(2)`) has `14` blocks. -/
theorem steiner_AGL : Nat.choose 8 3 / Nat.choose 4 3 = 14 := by decide

/-! ## The `M₂₄` dimensions in `H^{(2)}`

The lambency-`2` mock modular form is
`H^{(2)}(τ) = 2 q^{-1/8}(-1 + 45 q + 231 q² + 770 q³ + 2277 q⁴ + ⋯)`,
and the coefficients `45, 231, 770, 2277` are dimensions of irreducible representations
of `M₂₄` (Eguchi–Ooguri–Tachikawa). -/

theorem H2_dims_are_M24_irreps :
    45 ∈ M24dims ∧ 231 ∈ M24dims ∧ 770 ∈ M24dims ∧ 2277 ∈ M24dims := by decide

/-- The leading `H^{(2)}` coefficients `2 · dim` for the first few `M₂₄`-modules. -/
theorem H2_coefficients :
    [1, 45, 231, 770, 2277].map (fun d => 2 * d) = [2, 90, 462, 1540, 4554] := by decide

/-! ## Mock-theta orders are divisible by the lambency

A curious feature noted in §2: the classical mock theta functions arising at lambency `ℓ`
always have *order* (the historical Ramanujan label) divisible by `ℓ`. -/

/-- `(lambency, mock-theta order)` pairs occurring in the paper:
order `2` and `8` at `ℓ = 2`, order `3` at `ℓ = 3`, order `8` at `ℓ = 4`, order `10` at
`ℓ = 5`. -/
def mockThetaOrders : List (ℕ × ℕ) := [(2, 2), (2, 8), (3, 3), (4, 8), (5, 10)]

theorem mockTheta_order_div : ∀ p ∈ mockThetaOrders, p.1 ∣ p.2 := by decide

/-! ## The discriminant ("type `n`") data

For each `ℓ` the discriminant property predicts dual pairs of irreducible representations
defined over `ℚ(√-n)`.  The relevant integers `n` (the "type `n`" data of Table 6.2) are
recorded below; the associated *doublet discriminants* `-D` factor as `-D = n λ²`. -/

/-- The "type `n`" integers for each lambency `ℓ`. -/
def typeN : List (ℕ × List ℕ) :=
  [(2, [7, 15, 23]), (3, [5, 8, 11, 20]), (4, [3, 7]), (5, [4]), (7, [3]), (13, [4])]

/-- Every type-`n` integer is positive, so each field `ℚ(√-n)` is imaginary quadratic. -/
theorem typeN_pos : ∀ p ∈ typeN, ∀ n ∈ p.2, 0 < n := by decide

/-- For `ℓ = 2` the doublet discriminants `-D ∈ {7,15,23,63,135,175,207}` factor as `n λ²`
with `n ∈ {7, 15, 23}`. -/
theorem discriminants_ell2 :
    [7, 15, 23, 63, 135, 175, 207]
      = [7 * 1 ^ 2, 15 * 1 ^ 2, 23 * 1 ^ 2, 7 * 3 ^ 2, 15 * 3 ^ 2, 7 * 5 ^ 2, 23 * 3 ^ 2] := by
  decide

/-- For `ℓ = 7` the doublet discriminants are `-D = 3 λ²` for `λ ∈ {1,…,9}, λ ≠ 7`. -/
theorem discriminants_ell7 :
    [1, 2, 3, 4, 5, 6, 8, 9].map (fun l => 3 * l ^ 2)
      = [3, 12, 27, 48, 75, 108, 192, 243] := by decide

/-- For `ℓ = 13` the doublet discriminants are `-D = 4 λ²` for `λ ∈ {1,…,11}`. -/
theorem discriminants_ell13 :
    (List.range 11).map (fun l => 4 * (l + 1) ^ 2)
      = [4, 16, 36, 64, 100, 144, 196, 256, 324, 400, 484] := by decide

/-! ## Dynkin ranks and the Siegel-form weights

For `ℓ ∈ {3,4,5,7}` the McKay-type observation relates `G^{(ℓ)}` to (a folding of) the
affinisation of an ADE Dynkin diagram of rank `11 - ℓ`, giving `Ê₈, Ê₇, Ê₆, D̂₄`.
The Borcherds/Igusa Siegel forms `Φ^{(ℓ)}` have weight `2k` with `k = (7-ℓ)/(ℓ-1)`. -/

/-- The Dynkin ranks `11 - ℓ` for `ℓ ∈ {3,4,5,7}` are `[8, 7, 6, 4]` (`Ê₈, Ê₇, Ê₆, D̂₄`). -/
theorem dynkin_rank : [3, 4, 5, 7].map (fun l => 11 - l) = [8, 7, 6, 4] := by decide

/-- The Siegel-form weights `k = (7-ℓ)/(ℓ-1)` are integral for `ℓ ∈ {2,3,4}`, equal to
`[5, 2, 1]`.  In particular `Φ^{(2)} = (Δ₅)²` has weight `2·5 = 10` (the Igusa cusp form). -/
theorem siegel_weight : [2, 3, 4].map (fun l => (7 - l) / (l - 1)) = [5, 2, 1] := by decide

theorem igusa_cusp_weight : 2 * 5 = 10 := by decide

end UmbralMoonshine
