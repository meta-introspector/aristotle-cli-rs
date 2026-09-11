import RequestProject.GaugeChart

/-!
# Alternative splitting rules for the gauge chart

`RequestProject.GaugeChart` splits the `194` rows of the arithmetic gauge chart into the
even (bosonic) and odd (fermionic) parts of a `SplitSuperBundle` by the **Liouville parity**
of the row exponent sum `Ω(n)` (rows with `Ω(n)` even are bosonic, rows with `Ω(n)` odd are
fermionic).  The resulting `H⁰` super-dimension is `(2761 | 2670)`.

This file swaps that single predicate out for a whole family of *alternative splitting rules*
and records how the super-dimension vector scales with the rule.  Because every twist degree
is `Ω(n) ≥ 0`, the first cohomology always vanishes (`*_sdimH1` below), and the `H⁰`
super-dimension is the pair
```
( ∑_{rows ∈ bosonic part} (Ω(n) + 1) ,  ∑_{rows ∈ fermionic part} (Ω(n) + 1) ).
```
Only the *partition* of the rows changes; the **total** `bosonic + fermionic = 5431` is a
conserved quantity, invariant under every splitting rule (`chart_total_invariant`).

## The rules

* **Modular congruence (CRT residue classes).**  Grade by the residue of `Ω(n)` modulo a fixed
  integer `k`:
  - `splitLiouville` (`k = 2`, residue `0`) — the original Liouville parity: `(2761 | 2670)`.
  - `splitMod3` (`k = 3`, residue `0`): `(1711 | 3720)`.
  - `splitMod5` (`k = 5`, residue `0`): `(1129 | 4302)`.
  - `splitCRT6` — bosonic iff `Ω(n) ≡ 0 (mod 2)` **and** `Ω(n) ≡ 0 (mod 3)`, i.e. (by CRT,
    `ℤ/6 ≅ ℤ/2 × ℤ/3`) iff `Ω(n) ≡ 0 (mod 6)`: `(867 | 4564)`.

  The finer-grained `residue profile` `resClassProfile k` records the `H⁰` dimension of
  *each* residue class `0, 1, …, k-1` as a length-`k` vector; the CRT decomposition
  `ℤ/6 ≅ ℤ/2 × ℤ/3` is visible as `resClassProfile`-refinement identities
  (`crt_mod2_from_mod6`, `crt_mod3_from_mod6`).

* **Prime-support conditions.**  Grade by arithmetic support data of `n = ∏ₚ p^{vₚ}`:
  - `splitDvd2` — bosonic iff `2 ∣ n` (i.e. `v₂ > 0`): `(3891 | 1540)`.
  - `splitSquarefree` — bosonic iff `n` is squarefree (all `vₚ ≤ 1`): `(15 | 5416)`.
  - `splitOmegaParity` — bosonic iff the number of *distinct* prime factors `ω(n)` is even:
    `(2714 | 2717)`.
-/

open SuperBundleP1

set_option maxRecDepth 100000

namespace GaugeChart

/-! ### A generic predicate-driven splitting -/

/-- The number of *distinct* prime factors `ω(n)` of the integer `n = ∏ₚ p^{vₚ}` underlying a
row: the count of nonzero `p`-adic valuations. -/
def GaugeRow.omegaCount (r : GaugeRow) : ℕ :=
  (r.exponents.filter (fun v => decide (0 < v))).length

/-- The generic chart→bundle pipeline driven by an arbitrary boolean splitting rule `split`:
rows on which `split` is `true` become even (bosonic) twists, the rest become odd (fermionic)
twists, each row `r` contributing the line bundle `O(Ω(n)) = O(r.rowExponentSum)`.

Taking `split = splitLiouville` reproduces `GaugeChart.chartBundle` (the Liouville parity
grading). -/
def chartBundleBy (split : GaugeRow → Bool) (rows : List GaugeRow) : SplitSuperBundle where
  even := (rows.filter split).map GaugeRow.twist
  odd := (rows.filter (fun r => !split r)).map GaugeRow.twist

/-- **Conservation of the total super-dimension.**  For *every* boolean splitting rule the
bosonic and fermionic `H⁰` super-dimensions of the chart bundle sum to the same constant
`5431 = ∑_{all rows} (Ω(n) + 1)`.  Changing the splitting rule only redistributes this total
between the bosonic and fermionic sectors. -/
theorem chart_total_invariant (split : GaugeRow → Bool) :
    (sdimH0 (chartBundleBy split chart)).1 + (sdimH0 (chartBundleBy split chart)).2 = 5431 := by
  have h_filter : ∀ (l : List GaugeRow) (p : GaugeRow → Bool),
      List.sum (List.map (fun r => (r.twist + 1).toNat) (List.filter p l))
        + List.sum (List.map (fun r => (r.twist + 1).toNat) (List.filter (fun r => !p r) l))
        = List.sum (List.map (fun r => (r.twist + 1).toNat) l) := by
    intro l p
    induction l <;> simp_all +decide [List.filter_cons]
    grind
  unfold sdimH0 chartBundleBy
  aesop

/-! ### Modular congruence (CRT residue) rules -/

/-- Liouville parity (`k = 2`): bosonic iff `Ω(n) ≡ 0 (mod 2)`. -/
def splitLiouville (r : GaugeRow) : Bool := r.rowExponentSum % 2 == 0
/-- Modular rule `k = 3`: bosonic iff `Ω(n) ≡ 0 (mod 3)`. -/
def splitMod3 (r : GaugeRow) : Bool := r.rowExponentSum % 3 == 0
/-- Modular rule `k = 5`: bosonic iff `Ω(n) ≡ 0 (mod 5)`. -/
def splitMod5 (r : GaugeRow) : Bool := r.rowExponentSum % 5 == 0
/-- CRT rule: bosonic iff `Ω(n) ≡ 0 (mod 2)` **and** `Ω(n) ≡ 0 (mod 3)`, equivalently
`Ω(n) ≡ 0 (mod 6)` by `ℤ/6 ≅ ℤ/2 × ℤ/3`. -/
def splitCRT6 (r : GaugeRow) : Bool :=
  (r.rowExponentSum % 2 == 0) && (r.rowExponentSum % 3 == 0)

theorem splitLiouville_sdimH0 :
    sdimH0 (chartBundleBy splitLiouville chart) = (2761, 2670) := by decide
theorem splitMod3_sdimH0 :
    sdimH0 (chartBundleBy splitMod3 chart) = (1711, 3720) := by decide
theorem splitMod5_sdimH0 :
    sdimH0 (chartBundleBy splitMod5 chart) = (1129, 4302) := by decide
theorem splitCRT6_sdimH0 :
    sdimH0 (chartBundleBy splitCRT6 chart) = (867, 4564) := by decide

theorem splitMod3_sdimH1 : sdimH1 (chartBundleBy splitMod3 chart) = (0, 0) := by decide
theorem splitMod5_sdimH1 : sdimH1 (chartBundleBy splitMod5 chart) = (0, 0) := by decide
theorem splitCRT6_sdimH1 : sdimH1 (chartBundleBy splitCRT6 chart) = (0, 0) := by decide

/-- The Liouville parity bundle of this file agrees with the original `chartBundle` /
`A001379bundle` super-dimension `(2761 | 2670)`. -/
theorem splitLiouville_matches_A001379 :
    sdimH0 (chartBundleBy splitLiouville chart) = sdimH0 A001379bundle := by decide

/-! ### Residue-class profiles and the CRT decomposition -/

/-- The total `H⁰` dimension `∑ (Ω(n) + 1)` of the rows whose exponent sum lies in the
residue class `res` modulo `k`. -/
def resClassDim (k res : ℕ) (rows : List GaugeRow) : ℕ :=
  ((rows.filter (fun r => r.rowExponentSum % k == res)).map (fun r => (r.twist + 1).toNat)).sum

/-- The residue profile modulo `k`: the length-`k` vector of `H⁰` dimensions, one per residue
class `0, 1, …, k-1`. -/
def resClassProfile (k : ℕ) (rows : List GaugeRow) : List ℕ :=
  (List.range k).map (fun res => resClassDim k res rows)

theorem resClassProfile_mod2 : resClassProfile 2 chart = [2761, 2670] := by decide
theorem resClassProfile_mod3 : resClassProfile 3 chart = [1711, 1821, 1899] := by decide
theorem resClassProfile_mod4 : resClassProfile 4 chart = [1380, 1362, 1381, 1308] := by decide
theorem resClassProfile_mod6 :
    resClassProfile 6 chart = [867, 980, 1053, 844, 841, 846] := by decide

/-- **CRT refinement `ℤ/6 → ℤ/2`.**  The bosonic (`Ω ≡ 0 mod 2`) sector is the union of the
mod-`6` residue classes `0, 2, 4`; its dimension is the sum of theirs. -/
theorem crt_mod2_from_mod6 :
    resClassDim 2 0 chart
      = resClassDim 6 0 chart + resClassDim 6 2 chart + resClassDim 6 4 chart := by decide

/-- **CRT refinement `ℤ/6 → ℤ/3`.**  The `Ω ≡ 0 mod 3` sector is the union of the mod-`6`
residue classes `0, 3`; its dimension is the sum of theirs. -/
theorem crt_mod3_from_mod6 :
    resClassDim 3 0 chart = resClassDim 6 0 chart + resClassDim 6 3 chart := by decide

/-- Every residue profile sums to the conserved total `5431`. -/
theorem resClassProfile_mod6_sum : (resClassProfile 6 chart).sum = 5431 := by decide

/-! ### Prime-support rules -/

/-- Prime-support rule: bosonic iff `2 ∣ n`, i.e. the `2`-adic valuation is positive. -/
def splitDvd2 (r : GaugeRow) : Bool := r.v2 != 0
/-- Prime-support rule: bosonic iff `n` is squarefree, i.e. every `p`-adic valuation is `≤ 1`. -/
def splitSquarefree (r : GaugeRow) : Bool := r.exponents.all (fun v => v ≤ 1)
/-- Prime-support rule: bosonic iff the number of *distinct* prime factors `ω(n)` is even. -/
def splitOmegaParity (r : GaugeRow) : Bool := r.omegaCount % 2 == 0

theorem splitDvd2_sdimH0 :
    sdimH0 (chartBundleBy splitDvd2 chart) = (3891, 1540) := by decide
theorem splitSquarefree_sdimH0 :
    sdimH0 (chartBundleBy splitSquarefree chart) = (15, 5416) := by decide
theorem splitOmegaParity_sdimH0 :
    sdimH0 (chartBundleBy splitOmegaParity chart) = (2714, 2717) := by decide

theorem splitDvd2_sdimH1 : sdimH1 (chartBundleBy splitDvd2 chart) = (0, 0) := by decide
theorem splitSquarefree_sdimH1 : sdimH1 (chartBundleBy splitSquarefree chart) = (0, 0) := by decide
theorem splitOmegaParity_sdimH1 :
    sdimH1 (chartBundleBy splitOmegaParity chart) = (0, 0) := by decide

/-! ### Genuine module dimensions

Each numeric super-dimension above is the genuine pair of module dimensions over any field
`K`, via `sdimH0_eq`. -/

theorem splitMod3_H0_finrank (K : Type*) [Field K] :
    (Module.finrank K (H0even K (chartBundleBy splitMod3 chart)),
        Module.finrank K (H0odd K (chartBundleBy splitMod3 chart))) = (1711, 3720) :=
  (sdimH0_eq K _).trans splitMod3_sdimH0

theorem splitDvd2_H0_finrank (K : Type*) [Field K] :
    (Module.finrank K (H0even K (chartBundleBy splitDvd2 chart)),
        Module.finrank K (H0odd K (chartBundleBy splitDvd2 chart))) = (3891, 1540) :=
  (sdimH0_eq K _).trans splitDvd2_sdimH0

theorem splitSquarefree_H0_finrank (K : Type*) [Field K] :
    (Module.finrank K (H0even K (chartBundleBy splitSquarefree chart)),
        Module.finrank K (H0odd K (chartBundleBy splitSquarefree chart))) = (15, 5416) :=
  (sdimH0_eq K _).trans splitSquarefree_sdimH0

end GaugeChart