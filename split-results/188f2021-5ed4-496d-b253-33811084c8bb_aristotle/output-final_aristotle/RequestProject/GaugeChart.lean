import RequestProject.SuperBundle
import RequestProject.GaugeTransformation
import RequestProject.Automation

/-!
# Feeding an arithmetic "gauge chart" into the super-bundle framework

This file plugs a concrete numeric table — a *gauge chart* — into the split-super-bundle /
gauge-transformation machinery of `RequestProject.SuperBundle`,
`RequestProject.GaugeTransformation` and `RequestProject.Automation`.

## The chart

Each row of the chart records, for a fixed list of primes
`primes = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71]`, the `p`-adic valuations
`vₚ` of an underlying integer
```
n  =  ∏ₚ  p ^ vₚ ,
```
together with the **row exponent sum**
```
row_exponent_sum  =  ∑ₚ vₚ  =  Ω(n)
```
(the number of prime factors of `n` counted with multiplicity).  The data is stored in
`GaugeRow` and the full table in `chart`.

`chart_checksum` verifies — for every one of the `194` rows — that the stored
`row_exponent_sum` really is the sum of the stored valuations.  Besides being a genuine
arithmetic statement about the table, this is a faithful transcription guard: any single-cell
typo in a valuation or in the stated sum would make the checksum fail.

## From the chart to a super bundle

In the Laurent chart `K[z, z⁻¹]` each row contributes a diagonal transition factor `z^w`
with `w = row_exponent_sum` (so the chart as a whole gives the diagonal transition matrix
`chartDiagonal = diag(z^{w₀}, …, z^{w_{N-1}})`, an instance of `diagTwist`).

To split the rows into the **even** (bosonic) and **odd** (fermionic) parts of a
`SplitSuperBundle`, we use the parity of `Ω(n) = row_exponent_sum`: rows with an even
exponent sum become even twists, rows with an odd exponent sum become odd twists
(`chartBundle`).  This is the `ℤ/2`-grading by parity of the number of prime factors —
exactly the Liouville-function grading `λ(n) = (-1)^{Ω(n)}`.

Since every twist degree `w = Ω(n) ≥ 0`, the resulting super bundle has no first cohomology
(`A001379_sdimH1`) and global sections of super-dimension
```
sdim H⁰  =  ( ∑_{Ω even} (Ω+1)  |  ∑_{Ω odd} (Ω+1) )  =  (2761 | 2670)
```
(`A001379_sdimH0`, lifted to genuine module dimensions in `A001379_H0_finrank`).

Finally `chartBundle_clash_splits` shows the gauge / clash-of-trivializations theorem
`clash_gaugeEquiv_diagonal` applies verbatim to the chart-derived bundle: any `U`-regular
odd clash between its even and odd parts can be gauged away.
-/

open SuperBundleP1 Polynomial Matrix

set_option maxRecDepth 100000

namespace GaugeChart

/-- The fixed list of primes whose `p`-adic valuations index the columns of the chart. -/
def primes : List ℕ := [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71]

/-- A single row of the gauge chart: a row index, the fifteen `p`-adic valuations
`v₂, v₃, …, v₇₁` of the underlying integer `n = ∏ p^{vₚ}`, and the stored exponent sum
`row_exponent_sum = Ω(n)`. -/
structure GaugeRow where
  (index : ℕ)
  (v2 v3 v5 v7 v11 v13 v17 v19 v23 v29 v31 v41 v47 v59 v71 : ℕ)
  (rowExponentSum : ℕ)

/-- The fifteen valuations of a row, in the same order as `primes`. -/
def GaugeRow.exponents (r : GaugeRow) : List ℕ :=
  [r.v2, r.v3, r.v5, r.v7, r.v11, r.v13, r.v17, r.v19,
   r.v23, r.v29, r.v31, r.v41, r.v47, r.v59, r.v71]

/-- The full gauge chart (`194` rows). -/
def chart : List GaugeRow := [
⟨192, 46,2,0,0,2,0,1,0,1,0,0,1,1,1,1, 56⟩,
⟨174, 42,2,1,4,0,2,0,0,1,1,0,1,0,1,0, 55⟩,
⟨180, 44,0,0,6,0,0,1,0,1,0,0,1,0,1,1, 55⟩,
⟨101, 46,0,0,0,2,3,0,0,1,0,1,0,1,0,0, 54⟩,
⟨102, 46,0,0,0,2,3,0,0,1,0,1,0,1,0,0, 54⟩,
⟨139, 42,0,7,0,1,0,0,0,1,0,0,1,0,1,1, 54⟩,
⟨122, 43,0,0,0,2,2,0,1,1,1,0,1,0,1,0, 52⟩,
⟨123, 43,0,0,0,2,2,0,1,1,1,0,1,0,1,0, 52⟩,
⟨124, 43,0,0,0,2,2,0,1,1,1,0,1,0,1,0, 52⟩,
⟨132, 42,0,0,4,1,0,0,0,1,0,1,1,1,1,0, 52⟩,
⟨171, 42,0,0,0,0,2,0,0,1,1,1,1,1,1,1, 51⟩,
⟨147, 32,0,9,0,0,0,0,1,0,1,0,1,1,1,1, 47⟩,
⟨168, 18,19,0,0,0,3,0,0,0,1,1,1,0,1,1, 45⟩,
⟨158, 32,0,1,0,0,3,1,1,1,1,1,0,1,1,1, 44⟩,
⟨80, 31,1,0,3,2,0,1,1,0,1,1,1,1,0,0, 43⟩,
⟨81, 31,1,0,3,2,0,1,1,0,1,1,1,1,0,0, 43⟩,
⟨144, 28,1,0,1,1,2,1,0,1,1,1,1,1,1,1, 41⟩,
⟨96, 18,3,8,1,1,0,1,1,0,1,0,0,1,1,1, 37⟩,
⟨118, 18,0,8,5,0,0,0,1,1,0,1,1,0,1,1, 37⟩,
⟨136, 21,0,0,6,1,3,1,1,0,1,0,1,0,1,1, 37⟩,
⟨157, 20,0,2,5,0,3,1,0,1,1,1,1,0,1,1, 37⟩,
⟨145, 18,3,2,1,2,3,0,1,1,1,0,1,1,1,1, 36⟩,
⟨125, 20,2,0,0,2,3,1,0,1,1,1,1,1,1,1, 35⟩,
⟨134, 18,0,0,6,1,3,1,1,1,1,1,1,1,0,0, 35⟩,
⟨135, 18,0,0,6,1,3,1,1,1,1,1,1,1,0,0, 35⟩,
⟨156, 18,0,0,6,1,3,1,1,0,1,0,1,1,1,1, 35⟩,
⟨160, 0,17,7,4,2,2,0,0,0,0,1,0,0,1,1, 35⟩,
⟨172, 12,6,2,5,0,3,1,1,1,0,1,0,1,1,1, 35⟩,
⟨175, 0,20,0,6,2,0,1,0,0,1,1,1,0,1,1, 34⟩,
⟨186, 2,19,0,4,0,3,0,0,0,1,1,1,1,1,1, 34⟩,
⟨77, 6,17,0,4,0,0,0,0,1,0,1,1,1,1,1, 33⟩,
⟨104, 1,19,0,4,2,3,1,0,1,1,0,1,0,0,0, 33⟩,
⟨105, 1,19,0,4,2,3,1,0,1,1,0,1,0,0,0, 33⟩,
⟨111, 18,0,0,6,0,0,1,1,1,1,1,1,1,1,1, 33⟩,
⟨121, 0,19,5,1,2,0,0,1,1,1,0,1,1,0,1, 33⟩,
⟨141, 16,1,0,4,2,2,1,1,0,1,1,1,1,1,1, 33⟩,
⟨151, 1,19,1,1,2,3,0,1,0,1,1,1,1,1,0, 33⟩,
⟨161, 12,1,9,1,0,2,1,1,0,1,1,1,1,1,1, 33⟩,
⟨162, 1,19,0,4,2,0,0,1,1,1,0,1,1,1,1, 33⟩,
⟨163, 2,19,0,0,2,3,1,0,1,1,1,1,0,1,1, 33⟩,
⟨177, 0,17,7,0,1,2,0,0,0,1,1,1,1,1,1, 33⟩,
⟨188, 0,17,7,1,0,0,1,0,1,1,1,1,1,1,1, 33⟩,
⟨40, 18,0,0,6,1,3,1,1,0,1,0,1,0,0,0, 32⟩,
⟨41, 18,0,0,6,1,3,1,1,0,1,0,1,0,0,0, 32⟩,
⟨45, 18,1,2,5,1,0,0,0,0,1,1,0,1,1,1, 32⟩,
⟨58, 17,0,5,0,2,3,1,1,0,0,1,0,0,1,1, 32⟩,
⟨59, 17,0,5,0,2,3,1,1,0,0,1,0,0,1,1, 32⟩,
⟨70, 0,18,9,0,0,0,0,1,1,0,1,0,0,1,1, 32⟩,
⟨71, 0,18,9,0,0,0,0,1,1,0,1,0,0,1,1, 32⟩,
⟨130, 1,17,2,5,0,0,0,1,1,1,1,0,1,1,1, 32⟩,
⟨140, 1,17,1,5,1,0,0,1,1,1,1,1,0,1,1, 32⟩,
⟨159, 0,19,0,1,2,3,1,1,1,1,0,1,1,0,1, 32⟩,
⟨167, 0,18,0,5,0,2,1,1,0,0,1,1,1,1,1, 32⟩,
⟨49, 19,1,1,1,2,0,0,1,0,1,1,1,1,1,1, 31⟩,
⟨63, 16,3,2,0,1,2,1,0,0,1,1,1,1,1,1, 31⟩,
⟨120, 13,0,2,5,2,3,0,0,1,1,0,1,1,1,1, 31⟩,
⟨152, 0,19,0,0,2,3,0,1,0,1,1,1,1,1,1, 31⟩,
⟨185, 0,18,0,1,2,2,0,1,1,1,1,1,1,1,1, 31⟩,
⟨65, 3,17,0,1,1,2,1,0,1,1,1,0,0,1,1, 30⟩,
⟨100, 0,19,0,0,2,3,0,1,0,1,1,1,1,1,0, 30⟩,
⟨106, 0,19,0,0,2,3,1,0,1,1,0,0,1,1,1, 30⟩,
⟨107, 0,19,0,0,2,3,1,0,1,1,0,0,1,1,1, 30⟩,
⟨129, 9,1,8,1,1,3,0,1,1,1,1,0,1,1,1, 30⟩,
⟨142, 0,17,1,0,2,2,1,1,1,0,1,1,1,1,1, 30⟩,
⟨150, 3,6,7,5,1,2,0,1,0,1,1,1,0,1,1, 30⟩,
⟨154, 4,7,7,1,1,3,0,1,1,0,1,1,1,1,1, 30⟩,
⟨181, 0,12,5,3,2,0,1,1,0,1,1,1,1,1,1, 30⟩,
⟨193, 0,12,7,0,0,3,1,0,1,1,1,1,1,1,1, 30⟩,
⟨42, 18,0,0,0,1,3,1,1,1,0,0,1,1,1,1, 29⟩,
⟨112, 4,12,0,1,2,3,0,1,0,1,1,1,1,1,1, 29⟩,
⟨115, 7,9,0,0,1,3,1,1,1,1,1,1,1,1,1, 29⟩,
⟨153, 10,1,0,5,2,3,0,1,1,1,1,1,1,1,1, 29⟩,
⟨169, 6,0,9,4,2,0,0,1,1,1,1,1,1,1,1, 29⟩,
⟨173, 0,12,0,6,0,3,1,1,1,1,1,1,1,0,1, 29⟩,
⟨191, 1,6,8,6,0,0,0,1,1,1,1,1,1,1,1, 29⟩,
⟨76, 0,17,2,0,0,2,0,0,1,1,1,1,1,1,1, 28⟩,
⟨95, 10,1,2,5,0,3,0,1,0,1,1,1,1,1,1, 28⟩,
⟨97, 11,2,0,3,1,3,1,0,1,1,1,1,1,1,1, 28⟩,
⟨98, 0,13,0,6,1,1,1,1,1,1,1,0,1,0,1, 28⟩,
⟨99, 0,13,0,6,1,1,1,1,1,1,1,0,1,0,1, 28⟩,
⟨119, 3,6,8,1,1,1,1,1,1,0,1,1,1,1,1, 28⟩,
⟨155, 2,2,9,4,2,3,0,1,1,1,1,1,0,0,1, 28⟩,
⟨170, 0,12,2,1,1,3,1,1,1,1,1,1,1,1,1, 28⟩,
⟨187, 7,2,1,4,2,3,1,1,1,1,1,1,1,1,1, 28⟩,
⟨25, 0,19,0,0,2,3,1,0,1,1,0,0,0,0,0, 27⟩,
⟨26, 0,19,0,0,2,3,1,0,1,1,0,0,0,0,0, 27⟩,
⟨166, 3,1,7,5,2,1,1,1,1,1,0,1,1,1,1, 27⟩,
⟨182, 2,0,9,6,0,3,1,1,0,0,1,1,1,1,1, 27⟩,
⟨43, 1,12,0,6,0,1,1,1,1,1,1,0,0,1,0, 26⟩,
⟨44, 1,12,0,6,0,1,1,1,1,1,1,0,0,1,0, 26⟩,
⟨60, 12,1,0,1,2,2,0,1,1,1,1,1,1,1,1, 26⟩,
⟨67, 1,12,2,1,0,3,1,0,1,1,1,1,0,1,1, 26⟩,
⟨91, 0,9,7,1,1,0,1,1,0,1,1,1,1,1,1, 26⟩,
⟨117, 3,6,0,6,1,2,1,0,1,1,1,1,1,1,1, 26⟩,
⟨126, 0,2,9,6,2,0,1,1,1,1,0,1,1,0,1, 26⟩,
⟨127, 1,0,9,6,2,2,1,1,0,1,1,0,1,1,0, 26⟩,
⟨128, 1,0,9,6,2,2,1,1,0,1,1,0,1,1,0, 26⟩,
⟨133, 3,0,8,6,1,0,1,1,0,1,1,1,1,1,1, 26⟩,
⟨137, 0,2,9,6,1,2,1,1,0,0,0,1,1,1,1, 26⟩,
⟨148, 2,4,1,6,2,3,1,1,1,1,1,1,1,1,0, 26⟩,
⟨149, 2,2,9,1,2,1,1,1,1,1,1,1,1,1,1, 26⟩,
⟨183, 2,0,7,5,2,3,1,0,0,1,1,1,1,1,1, 26⟩,
⟨184, 0,0,9,6,2,2,1,1,1,1,0,1,0,1,1, 26⟩,
⟨189, 1,0,8,6,1,3,1,0,1,1,0,1,1,1,1, 26⟩,
⟨190, 1,2,9,1,2,3,0,1,1,1,1,1,1,1,1, 26⟩,
⟨56, 5,7,1,1,1,3,1,1,0,1,1,1,1,0,1, 25⟩,
⟨64, 6,3,0,6,1,3,1,1,0,0,0,1,1,1,1, 25⟩,
⟨78, 4,3,7,0,2,2,0,0,1,1,1,1,1,1,1, 25⟩,
⟨82, 1,1,9,6,2,0,1,1,0,1,1,0,1,0,1, 25⟩,
⟨83, 1,1,9,6,2,0,1,1,0,1,1,0,1,0,1, 25⟩,
⟨84, 2,0,9,6,2,0,1,1,0,0,1,1,0,1,1, 25⟩,
⟨85, 2,0,9,6,2,0,1,1,0,0,1,1,0,1,1, 25⟩,
⟨90, 1,3,8,4,0,3,0,0,1,1,1,1,1,1,0, 25⟩,
⟨94, 6,1,2,5,1,2,1,1,0,1,1,1,1,1,1, 25⟩,
⟨110, 2,0,9,4,1,3,0,1,1,0,0,1,1,1,1, 25⟩,
⟨143, 2,0,7,4,2,3,0,1,0,1,1,1,1,1,1, 25⟩,
⟨176, 0,0,9,3,2,3,1,1,1,1,1,1,1,1,0, 25⟩,
⟨48, 5,0,8,4,1,0,0,0,1,1,1,1,1,1,0, 24⟩,
⟨66, 2,3,7,4,1,0,1,0,1,0,1,1,1,1,1, 24⟩,
⟨109, 0,6,3,2,2,3,1,1,1,1,1,1,0,1,1, 24⟩,
⟨113, 0,3,9,0,1,3,1,1,1,1,0,1,1,1,1, 24⟩,
⟨164, 1,2,3,4,2,3,1,1,1,1,1,1,1,1,1, 24⟩,
⟨165, 0,1,9,0,2,3,1,1,1,1,1,1,1,1,1, 24⟩,
⟨178, 0,4,0,6,2,3,1,1,1,1,1,1,1,1,1, 24⟩,
⟨179, 0,4,0,6,2,3,1,1,1,1,1,1,1,1,1, 24⟩,
⟨62, 3,0,7,5,0,2,0,0,1,1,1,0,1,1,1, 23⟩,
⟨87, 3,2,0,6,2,3,1,0,1,0,1,1,1,1,1, 23⟩,
⟨88, 1,0,8,6,0,0,1,0,1,1,1,1,1,1,1, 23⟩,
⟨89, 1,0,8,6,0,0,1,0,1,1,1,1,1,1,1, 23⟩,
⟨92, 1,1,8,4,0,0,1,1,1,1,1,1,1,1,1, 23⟩,
⟨93, 3,1,1,6,2,2,1,1,1,1,1,1,0,1,1, 23⟩,
⟨103, 0,3,7,1,2,3,0,0,1,1,1,1,1,1,1, 23⟩,
⟨114, 3,2,0,4,2,3,1,1,1,1,1,1,1,1,1, 23⟩,
⟨116, 2,1,2,6,1,2,1,1,1,1,1,1,1,1,1, 23⟩,
⟨131, 2,0,2,6,2,3,1,0,1,1,1,1,1,1,1, 23⟩,
⟨138, 1,0,5,4,2,3,0,1,1,1,1,1,1,1,1, 23⟩,
⟨146, 2,0,1,6,2,3,1,1,1,1,1,1,1,1,1, 23⟩,
⟨14, 12,0,0,4,1,2,0,0,0,0,1,0,0,1,1, 22⟩,
⟨36, 1,3,8,4,1,0,0,0,0,1,0,1,1,1,1, 22⟩,
⟨54, 0,0,9,6,2,0,1,1,0,0,0,0,1,1,1, 22⟩,
⟨55, 0,0,9,6,2,0,1,1,0,0,0,0,1,1,1, 22⟩,
⟨69, 2,0,9,0,1,2,1,0,1,1,1,1,1,1,1, 22⟩,
⟨73, 0,0,9,1,2,3,1,1,1,1,1,1,0,0,1, 22⟩,
⟨74, 0,0,9,1,2,3,1,1,1,1,1,1,0,0,1, 22⟩,
⟨75, 3,0,3,5,0,3,1,1,0,1,1,1,1,1,1, 22⟩,
⟨79, 2,1,2,5,2,3,0,1,1,0,1,1,1,1,1, 22⟩,
⟨108, 3,0,0,6,2,2,1,1,1,1,1,1,1,1,1, 22⟩,
⟨35, 3,0,8,1,0,3,1,1,0,1,0,1,0,1,1, 21⟩,
⟨52, 0,1,9,0,2,3,0,1,1,1,1,1,0,1,0, 21⟩,
⟨53, 0,1,9,0,2,3,0,1,1,1,1,1,0,1,0, 21⟩,
⟨61, 0,6,0,5,0,2,0,1,1,1,1,1,1,1,1, 21⟩,
⟨68, 3,0,2,3,2,3,1,1,1,1,0,1,1,1,1, 21⟩,
⟨72, 0,3,1,6,0,3,1,1,1,1,0,1,1,1,1, 21⟩,
⟨86, 0,0,5,6,1,0,1,1,1,1,1,1,1,1,1, 21⟩,
⟨27, 0,6,7,0,1,0,0,0,1,0,1,1,1,1,1, 20⟩,
⟨28, 7,0,2,0,1,3,0,1,1,0,1,1,1,1,1, 20⟩,
⟨50, 2,2,0,6,2,0,1,1,0,1,1,1,1,1,1, 20⟩,
⟨51, 2,2,0,5,2,2,0,1,1,0,1,1,1,1,1, 20⟩,
⟨15, 0,0,9,6,2,0,1,1,0,0,0,0,0,0,0, 19⟩,
⟨16, 0,0,9,6,2,0,1,1,0,0,0,0,0,0,0, 19⟩,
⟨29, 0,3,7,0,1,2,1,0,1,1,0,0,1,1,1, 19⟩,
⟨30, 0,1,7,5,0,0,0,0,0,1,1,1,1,1,1, 19⟩,
⟨38, 2,0,0,6,2,3,1,0,1,0,1,1,1,1,0, 19⟩,
⟨39, 2,0,0,6,2,3,1,0,1,0,1,1,1,1,0, 19⟩,
⟨57, 0,0,7,1,1,2,1,1,0,1,1,1,1,1,1, 19⟩,
⟨23, 3,2,0,4,1,0,1,1,1,1,1,0,1,1,1, 18⟩,
⟨33, 4,0,2,0,0,3,1,1,1,1,1,1,1,1,1, 18⟩,
⟨37, 1,0,2,4,1,3,0,1,1,1,1,1,1,0,1, 18⟩,
⟨46, 1,0,0,5,2,3,0,1,1,1,1,0,1,1,1, 18⟩,
⟨47, 1,0,0,5,2,3,0,1,1,1,1,0,1,1,1, 18⟩,
⟨20, 2,0,7,0,0,2,0,1,0,0,1,1,1,1,1, 17⟩,
⟨19, 1,1,2,5,1,0,0,1,1,1,0,1,0,1,1, 16⟩,
⟨31, 0,0,1,5,0,3,0,0,1,1,1,1,1,1,1, 16⟩,
⟨32, 0,2,1,1,1,2,1,1,1,1,1,1,1,1,1, 16⟩,
⟨34, 0,2,1,0,2,2,1,1,1,1,1,1,1,1,1, 16⟩,
⟨18, 0,0,2,5,1,2,1,0,1,0,1,0,0,1,1, 15⟩,
⟨22, 1,0,2,1,1,3,1,1,0,1,1,1,1,0,1, 15⟩,
⟨24, 0,0,3,1,2,2,0,0,1,1,1,1,1,1,1, 15⟩,
⟨8, 0,6,0,1,0,2,1,1,0,0,1,0,0,1,1, 14⟩,
⟨17, 3,0,0,1,0,3,1,0,0,1,1,1,1,1,1, 14⟩,
⟨21, 0,0,0,5,0,2,0,1,1,1,0,1,1,1,1, 14⟩,
⟨9, 0,0,2,4,0,0,1,0,0,1,1,1,1,0,1, 12⟩,
⟨10, 0,3,0,1,1,0,1,0,1,1,0,1,1,1,1, 12⟩,
⟨12, 0,0,0,4,1,2,0,0,0,1,0,1,1,1,1, 12⟩,
⟨13, 1,0,2,1,0,0,0,1,1,1,1,1,1,1,1, 12⟩,
⟨7, 1,1,0,1,1,2,0,1,1,0,0,1,1,1,0, 11⟩,
⟨11, 0,1,0,0,1,2,1,0,1,1,1,1,1,1,0, 11⟩,
⟨4, 2,0,0,1,1,0,0,0,1,1,1,1,0,0,1, 9⟩,
⟨6, 1,1,0,0,1,0,0,1,0,1,0,1,1,1,1, 9⟩,
⟨3, 1,0,0,0,0,2,0,0,0,1,1,0,1,1,0, 7⟩,
⟨5, 0,0,0,0,0,2,0,0,1,1,0,1,0,1,1, 7⟩,
⟨2, 2,0,0,0,0,0,0,0,0,0,1,1,0,1,1, 6⟩,
⟨1, 0,0,0,0,0,0,0,0,0,0,0,0,1,1,1, 3⟩,
⟨0, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0⟩
]

/-- The chart has `194` rows. -/
theorem chart_length : chart.length = 194 := by decide

/-- **Checksum / transcription guard.**  For every row of the chart the stored
`rowExponentSum` equals the sum of the fifteen stored `p`-adic valuations,
`Ω(n) = ∑ₚ vₚ`. -/
theorem chart_checksum : ∀ r ∈ chart, r.exponents.sum = r.rowExponentSum := by decide

/-! ### From the chart to a `SplitSuperBundle` -/

/-- The Laurent twist of a row: its `row_exponent_sum`, as an integer.  In the Laurent chart
`K[z, z⁻¹]` this row contributes the diagonal transition factor `z^{rowExponentSum}`. -/
def GaugeRow.twist (r : GaugeRow) : ℤ := (r.rowExponentSum : ℤ)

/-- The `SplitSuperBundle` built from a list of chart rows by the **parity grading**: rows
whose exponent sum `Ω(n)` is even become even (bosonic) twists, rows with odd `Ω(n)` become
odd (fermionic) twists, each contributing the line bundle `O(Ω(n))`.  This is the grading by
the Liouville function `λ(n) = (-1)^{Ω(n)}`. -/
def chartBundle (rows : List GaugeRow) : SplitSuperBundle where
  even := (rows.filter (fun r => Even r.rowExponentSum)).map GaugeRow.twist
  odd := (rows.filter (fun r => ¬ Even r.rowExponentSum)).map GaugeRow.twist

/-- The split super bundle attached to the full chart. -/
def A001379bundle : SplitSuperBundle := chartBundle chart

/-- **Super-dimension of `H⁰`.**  Since every twist degree is `Ω(n) ≥ 0`, the chart bundle has
`H⁰` super-dimension `(∑_{Ω even} (Ω+1) | ∑_{Ω odd} (Ω+1)) = (2761 | 2670)`. -/
theorem A001379_sdimH0 : sdimH0 A001379bundle = (2761, 2670) := by decide

/-- **Super-dimension of `H¹`.**  Every twist degree is `Ω(n) ≥ 0 > -1`, so the chart bundle
has no first cohomology: `sdim H¹ = (0 | 0)`. -/
theorem A001379_sdimH1 : sdimH1 A001379bundle = (0, 0) := by decide

/-- The genuine module dimensions of the even/odd parts of `H⁰` of the chart bundle agree with
the numeric super-dimension `(2761 | 2670)`. -/
theorem A001379_H0_finrank (K : Type*) [Field K] :
    (Module.finrank K (H0even K A001379bundle), Module.finrank K (H0odd K A001379bundle))
      = (2761, 2670) :=
  (sdimH0_eq K A001379bundle).trans A001379_sdimH0

/-- The genuine module dimensions of the even/odd parts of `H¹` of the chart bundle vanish. -/
theorem A001379_H1_finrank (K : Type*) [Field K] :
    (Module.finrank K (H1even K A001379bundle), Module.finrank K (H1odd K A001379bundle))
      = (0, 0) :=
  (sdimH1_eq K A001379bundle).trans A001379_sdimH1

/-! ### The chart as a diagonal transition matrix and its gauge theory -/

/-- The diagonal transition matrix `diag(z^{w₀}, …, z^{w_{N-1}})` read off the chart, with
one factor `z^{w}` per row (`w = rowExponentSum`).  This is the matrix incarnation
`transitionMatrixFromGaugeChart` of the chart, an instance of `diagTwist`. -/
noncomputable def chartDiagonal (K : Type*) [Field K] (rows : List GaugeRow) :
    Matrix (Fin (rows.map GaugeRow.twist).length) (Fin (rows.map GaugeRow.twist).length)
      (LaurentPolynomial K) :=
  diagTwist K (rows.map GaugeRow.twist)

/-- **The clash on the chart bundle is gauge-trivial.**  Any `U`-regular odd clash block
between the even and odd parts of the chart-derived super bundle can be gauged away: the
clashed transition supermatrix is gauge equivalent to the split (block-diagonal) one.  This is
`clash_gaugeEquiv_diagonal` instantiated at `chartBundle`. -/
theorem chartBundle_clash_splits (K : Type*) [Field K] (rows : List GaugeRow)
    (M : Matrix (Fin (chartBundle rows).even.length) (Fin (chartBundle rows).odd.length)
      (Polynomial K)) :
    GaugeEquiv K
      (clashMatrix K (chartBundle rows)
        ((M.map (ringHomU K)) * diagTwist K (chartBundle rows).odd))
      (transitionMatrix K (chartBundle rows)) :=
  clash_gaugeEquiv_diagonal K (chartBundle rows) M

end GaugeChart
