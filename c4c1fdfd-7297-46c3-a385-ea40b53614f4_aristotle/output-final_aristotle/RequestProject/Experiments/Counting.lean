/-
Original to this repository (not part of the upstream ZetaZeros development).
-/

import RequestProject.Experiments.ErrorFunction

/-! # Experiment track: zero-counting model problems

The downstream layer of this repository only ever uses the zero-counting function `N(T)` through
its asymptotics. This file formalises the machinery that turns *combinatorial* information about
a zero sequence into that asymptotic statement, with no complex analysis involved. It is the
foundation an experiment on synthetic zero-counting models is scored against.

* `isEquivalent_of_sub_bounded` — a counting function that differs from a comparison function by
  a bounded amount is asymptotically equivalent to it, as soon as the comparison function grows.
* `isEquivalent_nat_floor` — the step model `T ↦ ⌊M T⌋₊` is equivalent to `M`.
* `isEquivalent_nat_floor_rvmMain` — in particular the synthetic count `⌊(T/2π) log T⌋₊`
  satisfies the Riemann–von Mangoldt shape.
* `isEquivalent_of_sample_points` — the general asymptotic inversion: if the `n`-th zero is at
  height `g n`, the counting function is monotone with `N (g n) = n`, and the comparison function
  satisfies `M (g n) ∼ n`, then `N ∼ M`. This is what a submission working with an explicit
  synthetic zero sequence such as `γ_n ∼ 2π n / log n` has to feed into.
* `isEquivalent_rvmMain_of_sample_points` — the same conclusion phrased against the
  Riemann–von Mangoldt main term.
-/

open Filter Topology Asymptotics

namespace ZetaZeros.Experiments

/-- A counting function differing from a growing comparison function by a bounded amount is
asymptotically equivalent to it. -/
theorem isEquivalent_of_sub_bounded {N M : ℝ → ℝ} {C : ℝ}
    (hb : ∀ᶠ T in atTop, |N T - M T| ≤ C) (hM : Tendsto M atTop atTop) :
    Asymptotics.IsEquivalent atTop N M := by
  rw [Asymptotics.IsEquivalent, Asymptotics.isLittleO_iff]
  intro c hc
  filter_upwards [hb, hM.eventually_ge_atTop (C / c), hM.eventually_ge_atTop 0] with T h1 h2 h3
  have hnorm : ‖M T‖ = M T := by rw [Real.norm_eq_abs, abs_of_nonneg h3]
  have hCc : C ≤ c * M T := by
    rw [div_le_iff₀ hc] at h2
    nlinarith
  simpa [Pi.sub_apply, Real.norm_eq_abs, hnorm] using h1.trans hCc

/-- The step model `T ↦ ⌊M T⌋₊` is asymptotically equivalent to `M`. -/
theorem isEquivalent_nat_floor {M : ℝ → ℝ} (hM : Tendsto M atTop atTop) :
    Asymptotics.IsEquivalent atTop (fun T => (⌊M T⌋₊ : ℝ)) M := by
  refine isEquivalent_of_sub_bounded (C := 1) ?_ hM
  filter_upwards [hM.eventually_ge_atTop 0] with T hT
  have h1 : (⌊M T⌋₊ : ℝ) ≤ M T := Nat.floor_le hT
  have h2 : M T - 1 < (⌊M T⌋₊ : ℝ) := Nat.sub_one_lt_floor (M T)
  rw [abs_le]
  constructor <;> linarith

/-- The synthetic counting function `⌊(T/2π) log T⌋₊` satisfies the Riemann–von Mangoldt
shape. -/
theorem isEquivalent_nat_floor_rvmMain :
    Asymptotics.IsEquivalent atTop (fun T => (⌊rvmMain T⌋₊ : ℝ)) rvmMain :=
  isEquivalent_nat_floor tendsto_rvmMain_atTop

/-- The Riemann–von Mangoldt main term is increasing from height `1` on. -/
lemma monotoneOn_rvmMain : MonotoneOn rvmMain (Set.Ici (1 : ℝ)) := by
  intro x hx y hy hxy
  simp only [Set.mem_Ici] at hx hy
  have hpi : (0 : ℝ) < 2 * Real.pi := by positivity
  have hlogx : 0 ≤ Real.log x := Real.log_nonneg hx
  have hlogxy : Real.log x ≤ Real.log y := Real.log_le_log (by linarith) hxy
  have hxdiv : x / (2 * Real.pi) ≤ y / (2 * Real.pi) := by gcongr
  have hx0 : 0 ≤ x / (2 * Real.pi) := by positivity
  exact mul_le_mul hxdiv hlogxy hlogx (le_trans hx0 hxdiv)

/-- **Asymptotic inversion.** Suppose the zeros of a synthetic model sit at heights
`g 0 ≤ g 1 ≤ …` tending to infinity, the counting function `N` is monotone and counts exactly `n`
zeros up to height `g n`, and the comparison function `M` is monotone with `M (g n) ∼ n`. Then
`N ∼ M`.

This is the step that converts information about the *location of the `n`-th zero* into
information about the *number of zeros below `T`*. -/
theorem isEquivalent_of_sample_points {N M : ℝ → ℝ} {g : ℕ → ℝ} {A : ℝ}
    (hN : MonotoneOn N (Set.Ici A)) (hM : MonotoneOn M (Set.Ici A))
    (hg : Monotone g) (hgA : ∀ n, A ≤ g n) (hgtop : Tendsto g atTop atTop)
    (hNg : ∀ n, N (g n) = n) (hMg : Tendsto (fun n : ℕ => M (g n) / n) atTop (𝓝 1)) :
    Asymptotics.IsEquivalent atTop N M := by
  have key : ∀ ε : ℝ, 0 < ε → ε ≤ 1 → ∀ᶠ T in atTop, ‖N T - M T‖ ≤ ε * ‖M T‖ := by
    intro ε hε hε1
    obtain ⟨n₀, hn₀⟩ := Metric.tendsto_atTop.1 hMg (ε / 8) (by positivity)
    obtain ⟨n₁, hn₁⟩ := exists_nat_gt (3 / ε)
    set m := max (max n₀ n₁) 1 with hm
    filter_upwards [eventually_ge_atTop (g m)] with T hT
    have hTA : T ∈ Set.Ici A := Set.mem_Ici.2 (le_trans (hgA m) hT)
    -- the least index whose height exceeds `T`
    have hex : ∃ k, T < g k := (hgtop.eventually_gt_atTop T).exists
    have hkspec : T < g (Nat.find hex) := Nat.find_spec hex
    have hkpos : m < Nat.find hex := by
      by_contra hcon
      push_neg at hcon
      exact absurd (le_trans (hg hcon) hT) (not_le.2 hkspec)
    obtain ⟨n, hn⟩ : ∃ n, Nat.find hex = n + 1 := ⟨Nat.find hex - 1, by omega⟩
    rw [hn] at hkspec
    have hgn : g n ≤ T := not_lt.1 (Nat.find_min hex (by omega))
    have hnm : m ≤ n := by omega
    have hnn₀ : n₀ ≤ n := le_trans (le_trans (le_max_left _ _) (le_max_left _ _)) hnm
    have hn1 : 1 ≤ n := le_trans (le_max_right _ _) hnm
    have hnn₁ : n₁ ≤ n := le_trans (le_trans (le_max_right _ _) (le_max_left _ _)) hnm
    -- bounds on `N T`
    have hNlow : (n : ℝ) ≤ N T := by
      rw [← hNg n]
      exact hN (Set.mem_Ici.2 (hgA n)) hTA hgn
    have hNhigh : N T ≤ (n : ℝ) + 1 := by
      have := hN hTA (Set.mem_Ici.2 (hgA (n + 1))) hkspec.le
      rw [hNg (n + 1)] at this
      push_cast at this
      linarith
    -- bounds on `M T`
    have hnR : (0 : ℝ) < n := by exact_mod_cast hn1
    have hMn : |M (g n) / n - 1| ≤ ε / 8 := by
      simpa [Real.dist_eq] using (hn₀ n hnn₀).le
    have hMn1 : |M (g (n + 1)) / ((n + 1 : ℕ) : ℝ) - 1| ≤ ε / 8 := by
      simpa [Real.dist_eq] using (hn₀ (n + 1) (by omega)).le
    rw [abs_le] at hMn hMn1
    have hMlow : (n : ℝ) * (1 - ε / 8) ≤ M T := by
      have h1 : (n : ℝ) * (1 - ε / 8) ≤ M (g n) := by
        have h2 : 1 - ε / 8 ≤ M (g n) / n := by linarith [hMn.1]
        rw [le_div_iff₀ hnR] at h2
        linarith
      exact h1.trans (hM (Set.mem_Ici.2 (hgA n)) hTA hgn)
    have hMhigh : M T ≤ ((n : ℝ) + 1) * (1 + ε / 8) := by
      have h1 : M (g (n + 1)) ≤ ((n : ℝ) + 1) * (1 + ε / 8) := by
        have hpos : (0 : ℝ) < ((n + 1 : ℕ) : ℝ) := by positivity
        have h2 : M (g (n + 1)) / ((n + 1 : ℕ) : ℝ) ≤ 1 + ε / 8 := by linarith [hMn1.2]
        rw [div_le_iff₀ hpos] at h2
        push_cast at h2 ⊢
        linarith
      exact (hM hTA (Set.mem_Ici.2 (hgA (n + 1))) hkspec.le).trans h1
    have hnbig : 3 / ε < (n : ℝ) := lt_of_lt_of_le hn₁ (by exact_mod_cast hnn₁)
    have hn3 : 3 ≤ ε * n := by
      rw [div_lt_iff₀ hε] at hnbig
      nlinarith
    have hMpos : 0 < M T := by nlinarith
    have hnormM : ‖M T‖ = M T := by rw [Real.norm_eq_abs, abs_of_pos hMpos]
    rw [Real.norm_eq_abs, hnormM, abs_le]
    constructor <;> nlinarith
  rw [Asymptotics.IsEquivalent, Asymptotics.isLittleO_iff]
  intro c hc
  filter_upwards [key (min c 1) (lt_min hc one_pos) (min_le_right _ _)] with T hT
  exact hT.trans (mul_le_mul_of_nonneg_right (min_le_left _ _) (norm_nonneg _))

/-- The inversion theorem, phrased against the Riemann–von Mangoldt main term: a synthetic model
whose `n`-th zero sits at height `g n`, with `(g n / 2π) log (g n) ∼ n`, has counting function
`N(T) ∼ (T/2π) log T`. -/
theorem isEquivalent_rvmMain_of_sample_points {N : ℝ → ℝ} {g : ℕ → ℝ}
    (hN : MonotoneOn N (Set.Ici 1)) (hg : Monotone g) (hg1 : ∀ n, 1 ≤ g n)
    (hgtop : Tendsto g atTop atTop) (hNg : ∀ n, N (g n) = n)
    (hMg : Tendsto (fun n : ℕ => rvmMain (g n) / n) atTop (𝓝 1)) :
    Asymptotics.IsEquivalent atTop N rvmMain :=
  isEquivalent_of_sample_points hN monotoneOn_rvmMain hg hg1 hgtop hNg hMg

end ZetaZeros.Experiments
