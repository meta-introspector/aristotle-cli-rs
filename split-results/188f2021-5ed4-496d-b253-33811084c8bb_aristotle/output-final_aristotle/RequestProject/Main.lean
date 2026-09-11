import RequestProject.SuperBundle
import RequestProject.Automation
import RequestProject.GaugeTransformation
import RequestProject.GaugeChart
import RequestProject.AltSplittings
import RequestProject.AsymptoticProfiles
import RequestProject.CliffordBlades
import RequestProject.CliffordFinrank

/-!
# The Čech cohomology computation behind the genus-zero supermoduli space

This file formalizes the central, fully self-contained computation from

  N. Ott and A. A. Voronov,
  *The supermoduli space of genus zero super Riemann surfaces with Ramond punctures*
  (arXiv:1910.05655),

namely the Čech cohomology computation of **Lemma 4.3** / **Lemma 7.9**, which determines
the dimension `(0 | n_R/2 - 2)` of the space of first-order deformations of the weighted
projective superspace `WP^{1|1}(1,1 | 1 - n_R/2)`, the supercurve underlying a genus-zero
super Riemann surface with `n_R` Ramond punctures (Remark 4.4).

## Architecture

The elementary pure-mathematics content has been factored into two reusable, supergeometry-free
modules:

* `RequestProject.LaurentCohomology` — the classical Čech computation of `H⁰`/`H¹` of the
  Serre twisting sheaves `O(d)` on `ℙ¹` over an arbitrary field `K`, modelled on Laurent
  polynomials `K[z, z⁻¹] ≅ (ℤ →₀ K)`.  The key output is
  `finrank_cechH1 : dim H¹(O(d)) = (-d - 1).toNat = max(0, -d-1)` (and dually
  `finrank_cechH0 : dim H⁰(O(d)) = max(0, d+1)`).
* `RequestProject.SuperBundle` — a small framework for split super vector bundles on `ℙ¹`
  given by diagonal transition data on `𝔾ₘ` (two lists of integer twists, even and odd),
  computing their cohomology super-dimensions via the Laurent engine above.

The present file is the **dictionary** between that linear algebra and the physics paper.

## Mathematical content

The full statements of the paper (super Riemann surfaces, supermoduli *superstacks*,
Deligne–Mumford superstacks, …) are not available in Mathlib and are out of scope here.
What *is* fully formalizable is the elementary computational heart of the paper, the
"straightforward Čech cohomology computation".

Over the standard two-chart cover `{U = Spec k[z|ζ], V = Spec k[w|χ]}` of `WP`, the Čech
differential on the super tangent bundle `T_X` decouples (component by component on the four
local generators `∂/∂z`, `ζ ∂/∂z`, `∂/∂ζ`, `ζ ∂/∂ζ`) into line-bundle computations:

* the even part `∂/∂z`  is `H¹(O(2)) = 0`;
* the even part `ζ ∂/∂ζ` is `H¹(O(1)) = 0`;
* the odd part `∂/∂ζ`   is `H¹(O(m))`,   of dimension `max(0, -m-1)`;
* the odd part `ζ ∂/∂z`  is `H¹(O(2-m))`, of dimension `max(0,  m-3)`.

Hence the super tangent bundle is the split super vector bundle with diagonal transition data
`even = [2, 1]`, `odd = [m, 2-m]` (`WPtangent` below), and (Lemma 4.3)

  `dim H¹(X, T_X) = ( 0 | max(0,-m-1) + max(0,m-3) )`,

which for `m = 1 - n_R/2` (`n_R ≥ 4` even) gives the odd dimension `n_R/2 - 2`
(Remark 4.4 / Lemma 7.9).
-/

open LaurentCohomology SuperBundleP1 Polynomial Matrix

namespace SuperRiemannGenusZero

variable (K : Type*) [Field K]

/-- The **super tangent bundle** `T_X` of `X = WP^{1|1}(1,1 | m)`, presented as split
super vector bundle transition data on `𝔾ₘ`.  Its diagonal cocycle has even part
`diag(z², z)` (the generators `∂/∂z` and `ζ ∂/∂ζ`) and odd part `diag(zᵐ, z^{2-m})`
(the generators `∂/∂ζ` and `ζ ∂/∂z`). -/
def WPtangent (m : ℤ) : SplitSuperBundle := ⟨[2, 1], [m, 2 - m]⟩

/-- The **even** part of `H¹(X, T_X)` for `X = WP^{1|1}(1,1 | m)`.
It is assembled from the two even local generators `∂/∂z` (giving `H¹(O(2))`) and
`ζ ∂/∂ζ` (giving `H¹(O(1))`). -/
abbrev WP_evenH1 (m : ℤ) := H1even K (WPtangent m)

/-- The **odd** part of `H¹(X, T_X)` for `X = WP^{1|1}(1,1 | m)`.
It is assembled from the two odd local generators `∂/∂ζ` (giving `H¹(O(m))`) and
`ζ ∂/∂z` (giving `H¹(O(2-m))`). -/
abbrev WP_oddH1 (m : ℤ) := H1odd K (WPtangent m)

/-- The even part of `H¹(X, T_X)` vanishes: `WP^{1|1}(1,1|m)` has no even (bosonic)
first-order deformations (Lemma 4.3). -/
theorem finrank_WP_evenH1 (m : ℤ) : Module.finrank K (WP_evenH1 K m) = 0 := by
  rw [finrank_H1even]
  show (List.map (fun d => (-d - 1).toNat) [2, 1]).sum = 0
  decide

/-- **Lemma 4.3 (odd part).** The odd part of `H¹(X, T_X)` for `X = WP^{1|1}(1,1|m)` has
dimension `max(0,-m-1) + max(0,m-3)`. -/
theorem finrank_WP_oddH1 (m : ℤ) :
    Module.finrank K (WP_oddH1 K m) = (-m - 1).toNat + (m - 3).toNat := by
  rw [finrank_H1odd]
  show (List.map (fun d => (-d - 1).toNat) [m, 2 - m]).sum = (-m - 1).toNat + (m - 3).toNat
  simp only [List.map_cons, List.map_nil, List.sum_cons, List.sum_nil, add_zero]
  congr 1
  omega

/-- **Lemma 4.3 (piecewise form).** The dimension of the odd part of `H¹(X, T_X)`:
`-m-1` for `m < -1`, `0` for `-1 ≤ m ≤ 3`, and `m-3` for `m > 3`.  In particular
`WP^{1|1}(1,1|m)` is *not* rigid for `m < -1` or `m > 3`. -/
theorem finrank_WP_oddH1_piecewise (m : ℤ) :
    Module.finrank K (WP_oddH1 K m)
      = if m < -1 then (-m - 1).toNat else if m ≤ 3 then 0 else (m - 3).toNat := by
  rw [finrank_WP_oddH1]; grind

/-- **Lemma 4.3 (super-dimension form).** The super-dimension of `H¹(X, T_X)` is
`(0 | max(0,-m-1) + max(0,m-3))`. -/
theorem sdim_WP_H1 (m : ℤ) :
    sdimH1 (WPtangent m) = (0, (-m - 1).toNat + (m - 3).toNat) := by
  rw [sdimH1]
  show ((List.map (fun d => (-d - 1).toNat) [2, 1]).sum,
        (List.map (fun d => (-d - 1).toNat) [m, 2 - m]).sum)
      = (0, (-m - 1).toNat + (m - 3).toNat)
  refine Prod.ext ?_ ?_
  · change (List.map (fun d => (-d - 1).toNat) [2, 1]).sum = 0
    decide
  · change (List.map (fun d => (-d - 1).toNat) [m, 2 - m]).sum = (-m - 1).toNat + (m - 3).toNat
    simp only [List.map_cons, List.map_nil, List.sum_cons, List.sum_nil, add_zero]
    congr 1
    omega

/-- **Remark 4.4 / Lemma 7.9.** For `m = 1 - n_R/2` (here `p = n_R/2 ≥ 2`), the supercurve
`WP^{1|1}(1,1 | 1 - n_R/2)` underlying a genus-zero super Riemann surface with `n_R` Ramond
punctures has first-order deformation space of dimension `(0 | n_R/2 - 2)`: the even part
vanishes and the odd part has dimension `n_R/2 - 2`. -/
theorem WP_deformation_superdim (p : ℕ) (hp : 2 ≤ p) :
    Module.finrank K (WP_evenH1 K (1 - (p : ℤ))) = 0
      ∧ Module.finrank K (WP_oddH1 K (1 - (p : ℤ))) = p - 2 := by
  rw [finrank_WP_evenH1, finrank_WP_oddH1]
  omega

/-! ### Automation demo: `compute_sdim`

The super-dimension of `H¹(X, T_X)` can be obtained mechanically from the twist lists by the
`compute_sdim` tactic (file `RequestProject.Automation`): after unfolding the bundle
definition so the `.even`/`.odd` projections reduce, the tactic evaluates the sums of
`Int.toNat`s and closes the goal with `omega`. -/

/-- **Lemma 4.3 (super-dimension form), via the `compute_sdim` tactic.**  Identical content
to `sdim_WP_H1`, but proved automatically from the twist lists of `WPtangent m`. -/
theorem sdim_WP_H1_auto (m : ℤ) :
    sdimH1 (WPtangent m) = (0, (-m - 1).toNat + (m - 3).toNat) := by
  unfold WPtangent; compute_sdim

/-- The `H⁰` super-dimension of the super tangent bundle, computed automatically. -/
theorem sdim_WP_H0_auto (m : ℤ) :
    sdimH0 (WPtangent m) = (5, (m + 1).toNat + (3 - m).toNat) := by
  unfold WPtangent; compute_sdim

/-! ### Gauge demo: a clash on the super tangent bundle is removable

The gauge / clash-of-trivializations framework (file `RequestProject.GaugeTransformation`)
applies verbatim to the super tangent bundle.  Its split transition supermatrix is
`transitionMatrix K (WPtangent m) = diag(z², z) ⊕ diag(zᵐ, z^{2-m})`, and any off-diagonal
`U`-regular clash between the even and odd parts can be gauged away. -/

/-- **Gauge demo.**  Adding any `U`-regular clash block to the super tangent bundle's
transition supermatrix yields a transition matrix gauge equivalent to the split one: the
super tangent bundle does not acquire new moduli from such a clash. -/
theorem WPtangent_clash_splits (m : ℤ)
    (M : Matrix (Fin (WPtangent m).even.length) (Fin (WPtangent m).odd.length)
      (Polynomial K)) :
    GaugeEquiv K
      (clashMatrix K (WPtangent m) ((M.map (ringHomU K)) * diagTwist K (WPtangent m).odd))
      (transitionMatrix K (WPtangent m)) :=
  clash_gaugeEquiv_diagonal K (WPtangent m) M

/-! ### Gauge-chart demo: feeding the arithmetic chart through the pipeline

The file `RequestProject.GaugeChart` plugs a concrete numeric *gauge chart* (a table of
`p`-adic valuations of integers, with row exponent sums `Ω(n)`) into the same machinery.
The rows are split into the even/odd parts of a `SplitSuperBundle` by the parity of `Ω(n)`
(the Liouville grading), each row contributing the line bundle `O(Ω(n))`.  We re-export the
resulting end-to-end facts here: the chart's super-dimensions and the gauge-triviality of a
clash on the chart-derived bundle. -/

/-- **Gauge-chart demo (super-dimension).** The split super bundle built from the full gauge
chart by the Liouville parity grading has `H⁰` super-dimension `(2761 | 2670)` and vanishing
`H¹`, as genuine module dimensions over any field `K`. -/
theorem chart_superdim :
    (Module.finrank K (H0even K GaugeChart.A001379bundle),
        Module.finrank K (H0odd K GaugeChart.A001379bundle)) = (2761, 2670)
      ∧ (Module.finrank K (H1even K GaugeChart.A001379bundle),
        Module.finrank K (H1odd K GaugeChart.A001379bundle)) = (0, 0) :=
  ⟨GaugeChart.A001379_H0_finrank K, GaugeChart.A001379_H1_finrank K⟩

/-- **Gauge-chart demo (clash).** Any `U`-regular odd clash between the even and odd parts of
the chart-derived super bundle can be gauged away. -/
theorem chart_clash_splits
    (M : Matrix (Fin (GaugeChart.chartBundle GaugeChart.chart).even.length)
      (Fin (GaugeChart.chartBundle GaugeChart.chart).odd.length) (Polynomial K)) :
    GaugeEquiv K
      (clashMatrix K (GaugeChart.chartBundle GaugeChart.chart)
        ((M.map (ringHomU K)) * diagTwist K (GaugeChart.chartBundle GaugeChart.chart).odd))
      (transitionMatrix K (GaugeChart.chartBundle GaugeChart.chart)) :=
  GaugeChart.chartBundle_clash_splits K GaugeChart.chart M

/-! ### Alternative splitting rules: how the super-dimension vector scales

The file `RequestProject.AltSplittings` swaps the Liouville-parity predicate of the gauge
chart for a family of alternative splitting rules — modular congruence (CRT residue) classes
of `Ω(n)` and prime-support conditions on `n = ∏ₚ p^{vₚ}` — feeding each through the same
`chartBundleBy` pipeline.  Every twist degree is `Ω(n) ≥ 0`, so `H¹` always vanishes; only the
partition of the chart's `H⁰` super-dimension changes, while the total `5431` is conserved.
We collect the resulting super-dimension vectors here. -/

/-- **Alternative splitting rules — `H⁰` super-dimension vectors.**  Compared with the
Liouville parity grading `(2761 | 2670)`, the chart's `H⁰` super-dimension under the
alternative rules is: mod-`3` `(1711 | 3720)`, mod-`5` `(1129 | 4302)`, CRT mod-`6`
`(867 | 4564)`, `2 ∣ n` `(3891 | 1540)`, squarefree `(15 | 5416)`, and `ω(n)`-parity
`(2714 | 2717)`. -/
theorem chart_alt_superdims :
    sdimH0 (GaugeChart.chartBundleBy GaugeChart.splitLiouville GaugeChart.chart) = (2761, 2670)
      ∧ sdimH0 (GaugeChart.chartBundleBy GaugeChart.splitMod3 GaugeChart.chart) = (1711, 3720)
      ∧ sdimH0 (GaugeChart.chartBundleBy GaugeChart.splitMod5 GaugeChart.chart) = (1129, 4302)
      ∧ sdimH0 (GaugeChart.chartBundleBy GaugeChart.splitCRT6 GaugeChart.chart) = (867, 4564)
      ∧ sdimH0 (GaugeChart.chartBundleBy GaugeChart.splitDvd2 GaugeChart.chart) = (3891, 1540)
      ∧ sdimH0 (GaugeChart.chartBundleBy GaugeChart.splitSquarefree GaugeChart.chart) = (15, 5416)
      ∧ sdimH0 (GaugeChart.chartBundleBy GaugeChart.splitOmegaParity GaugeChart.chart)
          = (2714, 2717) :=
  ⟨GaugeChart.splitLiouville_sdimH0, GaugeChart.splitMod3_sdimH0, GaugeChart.splitMod5_sdimH0,
    GaugeChart.splitCRT6_sdimH0, GaugeChart.splitDvd2_sdimH0, GaugeChart.splitSquarefree_sdimH0,
    GaugeChart.splitOmegaParity_sdimH0⟩

/-- **Conservation law.**  No matter which boolean splitting rule grades the chart, the bosonic
and fermionic `H⁰` super-dimensions sum to the conserved total `5431`. -/
theorem chart_alt_total (split : GaugeChart.GaugeRow → Bool) :
    (sdimH0 (GaugeChart.chartBundleBy split GaugeChart.chart)).1
      + (sdimH0 (GaugeChart.chartBundleBy split GaugeChart.chart)).2 = 5431 :=
  GaugeChart.chart_total_invariant split

/-! ### Asymptotic limits of the profiles as the chart scales

The file `RequestProject.AsymptoticProfiles` studies what happens to the gauge-chart profiles
when the (otherwise fixed `194`-row) chart is allowed to *scale*: it feeds the same
`resClassDim` / `chartBundleBy` profile machinery the complete chart `idealChart N` realising
every twist `Ω = 0, 1, …, N-1` once, and lets `N → ∞`.  The residue-class profile then
**equidistributes** — each residue class modulo `k` carries an asymptotic fraction `1/k` of
the total `H⁰` dimension — so the Liouville-parity bosonic/fermionic split tends to a perfect
balance `(½ | ½)` (consistent with the near-balanced `(2761 | 2670)` of the real chart). -/

/-- **Equidistribution of the residue-class profile as the chart scales.**  For every modulus
`k ≥ 1` and residue `r < k`, the fraction of the total `H⁰` dimension carried by residue class
`r` of `Ω(n)` tends to `1/k`. -/
theorem chart_profile_equidistributes (k r : ℕ) (hk : 0 < k) (hr : r < k) :
    Filter.Tendsto (fun M : ℕ =>
        (GaugeChart.resClassDim k r (AsymptoticProfiles.idealChart (k * M)) : ℝ)
          / (AsymptoticProfiles.idealTotalDim (k * M) : ℝ))
      Filter.atTop (nhds (1 / (k : ℝ))) :=
  AsymptoticProfiles.residue_profile_equidistributes k r hk hr

/-- **Liouville balance as the chart scales.**  The bosonic and fermionic sectors of the
Liouville-parity super-dimension each tend to half of the total. -/
theorem chart_liouville_balances :
    Filter.Tendsto (fun M : ℕ =>
        ((sdimH0 (GaugeChart.chartBundleBy GaugeChart.splitLiouville
            (AsymptoticProfiles.idealChart (2 * M)))).1 : ℝ)
          / (AsymptoticProfiles.idealTotalDim (2 * M) : ℝ)) Filter.atTop (nhds (1 / 2))
      ∧ Filter.Tendsto (fun M : ℕ =>
        ((sdimH0 (GaugeChart.chartBundleBy GaugeChart.splitLiouville
            (AsymptoticProfiles.idealChart (2 * M)))).2 : ℝ)
          / (AsymptoticProfiles.idealTotalDim (2 * M) : ℝ)) Filter.atTop (nhds (1 / 2)) :=
  ⟨AsymptoticProfiles.liouville_bosonic_balance, AsymptoticProfiles.liouville_fermionic_balance⟩

/-! ### Higher-moment asymptotics: the residue-class profile concentrates

Equidistribution (`chart_profile_equidistributes`) places each residue class fraction at the
uniform value `1/k` in the limit.  The file `RequestProject.AsymptoticProfiles` strengthens
this to a second-order statement: the *variance* of the residue-class contributions about the
uniform value vanishes, and more generally every higher central moment vanishes, while the
second moment of the profile tends to `1/k` — the moments of a uniform distribution on
`ℤ/kℤ`.  So as the chart scales, the profile does not merely centre on uniformity, it
concentrates on it. -/

/-- **Vanishing variance of the residue-class profile as the chart scales.**  The sum over all
residue classes modulo `k` of the squared deviation of each class's `H⁰`-dimension fraction
from the uniform value `1/k` tends to `0`. -/
theorem chart_profile_variance_vanishes (k : ℕ) (hk : 0 < k) :
    Filter.Tendsto (fun M : ℕ =>
        ∑ r ∈ Finset.range k,
          (AsymptoticProfiles.resFraction k r M - 1 / (k : ℝ)) ^ 2)
      Filter.atTop (nhds 0) :=
  AsymptoticProfiles.residue_profile_variance_vanishes k hk

/-- **Higher central moments of the residue-class profile vanish.**  For every exponent
`p ≥ 1`, the sum over all residue classes of the `p`-th power of the absolute deviation from
`1/k` tends to `0`; the variance is the case `p = 2`. -/
theorem chart_profile_central_moments_vanish (k p : ℕ) (hk : 0 < k) (hp : 1 ≤ p) :
    Filter.Tendsto (fun M : ℕ =>
        ∑ r ∈ Finset.range k,
          |AsymptoticProfiles.resFraction k r M - 1 / (k : ℝ)| ^ p)
      Filter.atTop (nhds 0) :=
  AsymptoticProfiles.residue_profile_central_moment_vanishes k p hk hp

/-- **Second moment of the residue-class profile as the chart scales.**  The sum over all
residue classes of the squared `H⁰`-dimension fraction tends to `1/k`, the second moment of a
uniform distribution on `ℤ/kℤ`. -/
theorem chart_profile_second_moment (k : ℕ) (hk : 0 < k) :
    Filter.Tendsto (fun M : ℕ =>
        ∑ r ∈ Finset.range k, (AsymptoticProfiles.resFraction k r M) ^ 2)
      Filter.atTop (nhds (1 / (k : ℝ))) :=
  AsymptoticProfiles.residue_profile_second_moment k hk

/-! ### Clifford-blade even/odd asymptotics

The file `RequestProject.CliffordBlades` formalises the second research direction: grading a
Clifford/exterior algebra by the **parity of its blade degree** (the even subalgebra vs. the
odd part) and analysing the even/odd profile as the dimension `n → ∞`.  In contrast with the
residue-class profile — which is only *asymptotically* uniform — the blade parities are
*exactly* balanced in every positive dimension. -/

/-- **Exact Clifford-blade balance.**  In every positive dimension `n` the even-degree and
odd-degree basis blades are equinumerous, each numbering `2 ^ (n - 1)` out of `2 ^ n`. -/
theorem chart_clifford_blade_balance (n : ℕ) (hn : 0 < n) :
    (CliffordBlades.evenBlades n).card = (CliffordBlades.oddBlades n).card
      ∧ (CliffordBlades.evenBlades n).card = 2 ^ (n - 1) :=
  ⟨CliffordBlades.even_eq_odd_card n hn, CliffordBlades.evenBlades_card n hn⟩

/-- **Asymptotic Clifford-blade balance.**  As the dimension scales, the fractions of
even-degree and odd-degree blades each tend to `1/2`. -/
theorem chart_clifford_blade_asymptotics :
    Filter.Tendsto (fun n : ℕ => CliffordBlades.evenFraction n) Filter.atTop (nhds (1 / 2))
      ∧ Filter.Tendsto (fun n : ℕ => CliffordBlades.oddFraction n) Filter.atTop (nhds (1 / 2)) :=
  ⟨CliffordBlades.evenBlade_balance, CliffordBlades.oddBlade_balance⟩

/-! ### Genuine `Module.finrank` of the Clifford algebra

Where `RequestProject.CliffordBlades` counts the basis blades combinatorially, the file
`RequestProject.CliffordFinrank` proves the matching identities for the **genuine** Clifford
algebra `CliffordAlgebra Q`: its `Module.finrank` equals the blade count `2 ^ n`, and the even
subalgebra has finrank `2 ^ (n - 1)`, computed signature-independently through
`CliffordAlgebra.equivExterior` and `CliffordAlgebra.equivEven`. -/

/-- **Genuine Clifford-algebra finrank.**  Over a field with `2` invertible, the Clifford algebra
of any quadratic form on a finite free module `M` has `Module.finrank` equal to `2 ^ finrank K M`,
independent of the signature of the form. -/
theorem chart_clifford_finrank
    {K M : Type*} [Field K] [AddCommGroup M] [Module K M] [Module.Finite K M] [Module.Free K M]
    [Invertible (2 : K)] (Q : QuadraticForm K M) :
    Module.finrank K (CliffordAlgebra Q) = 2 ^ Module.finrank K M :=
  CliffordFinrank.finrank_cliffordAlgebra Q

/-- **Genuine Clifford even-subalgebra finrank.**  The even subalgebra of an `n`-dimensional
Clifford algebra (here the "one-up" form on `M × K`) has `Module.finrank` equal to
`2 ^ finrank K M = 2 ^ (n - 1)`, matching the even-blade count. -/
theorem chart_clifford_even_finrank
    {K M : Type*} [Field K] [AddCommGroup M] [Module K M] [Module.Finite K M] [Module.Free K M]
    [Invertible (2 : K)] (Q₀ : QuadraticForm K M) :
    Module.finrank K (CliffordAlgebra.even (CliffordAlgebra.EquivEven.Q' Q₀)) =
      2 ^ Module.finrank K M :=
  CliffordFinrank.finrank_cliffordAlgebra_even Q₀

end SuperRiemannGenusZero
