import RequestProject.AsymptoticProfiles
import Mathlib

/-!
# Clifford-blade even/odd asymptotics

Where `RequestProject.AsymptoticProfiles` studies the residue-class profile of the gauge chart
graded by `Ω(n) mod k` and shows it equidistributes, this module formalises the *second* research
direction: **slicing a graded algebra by the parity of its blade degree** and analysing the
even/odd profile as the dimension scales.

## Mathematical model

The Clifford algebra `CliffordAlgebra Q` of a quadratic form `Q` on an `n`-dimensional space
carries a canonical `ℤ/2`-grading `CliffordAlgebra.evenOdd Q : ZMod 2 → Submodule R _`, whose
degree-`0` part is the even subalgebra `CliffordAlgebra.even Q`.  As a *module* it is isomorphic
to the exterior algebra (`CliffordAlgebra.equivExterior`), whose canonical basis is the family of
**blades** `e_S = ∏_{i ∈ S} e_i` indexed by subsets `S ⊆ Fin n`.  The *blade degree* of `e_S` is
the cardinality `|S|`, and the even/odd subalgebra split is exactly the split of blades into those
of even vs. odd cardinality.

We therefore model the blade set directly and combinatorially as `Blade n := Finset (Fin n)`,
graded by the parity of `Finset.card`, and study the even/odd profile.

## Main results

* `blades_card` — there are `2 ^ n` basis blades in dimension `n`.
* `evenBlades_card` / `oddBlades_card` — for `n ≥ 1` the even-degree and odd-degree blades each
  number exactly `2 ^ (n - 1)`.
* `even_eq_odd_card` — hence the even and odd Clifford-blade sectors are **exactly balanced** in
  every positive dimension (a stronger, finite-`n` analogue of equidistribution: there is no
  asymmetry).
* `evenFraction_eq_half` — the fraction of even-degree blades is exactly `1/2` for `n ≥ 1`.
* `evenBlade_balance` / `oddBlade_balance` — the even- and odd-blade fractions each tend to `1/2`
  as the dimension `n → ∞`, in the same `Filter.Tendsto` style as the residue-class profiles.
-/

open Filter Topology

namespace CliffordBlades

/-- A **basis blade** of the Clifford/exterior algebra of an `n`-dimensional space, identified with
the subset `S ⊆ Fin n` of generators it multiplies: `e_S = ∏_{i ∈ S} e_i`.  Its *blade degree* is
`S.card`. -/
abbrev Blade (n : ℕ) := Finset (Fin n)

/-- All `2 ^ n` basis blades in dimension `n`. -/
def blades (n : ℕ) : Finset (Blade n) := Finset.univ

/-- The **even** Clifford-blade sector: blades of even degree (the even subalgebra). -/
def evenBlades (n : ℕ) : Finset (Blade n) := Finset.univ.filter (fun s => Even s.card)

/-- The **odd** Clifford-blade sector: blades of odd degree. -/
def oddBlades (n : ℕ) : Finset (Blade n) := Finset.univ.filter (fun s => Odd s.card)

/-- There are exactly `2 ^ n` basis blades in dimension `n`. -/
theorem blades_card (n : ℕ) : (blades n).card = 2 ^ n := by
  simp [blades]

/-- The even and odd sectors partition the blades: their cardinalities sum to `2 ^ n`. -/
theorem even_add_odd_card (n : ℕ) :
    (evenBlades n).card + (oddBlades n).card = 2 ^ n := by
  convert Finset.card_add_card_compl (Finset.univ.filter fun s : Finset (Fin n) => Even s.card)
  · ext; simp [oddBlades]
  · norm_num [Fintype.card_finset]

/-- **Balance of the Clifford-blade parities.**  In every positive dimension the even-degree and
odd-degree blades are equinumerous: toggling the generator `0` (symmetric difference with `{0}`)
is an involution exchanging the even and odd sectors. -/
theorem even_eq_odd_card (n : ℕ) (hn : 0 < n) :
    (evenBlades n).card = (oddBlades n).card := by
  -- Toggling membership of the generator `0` flips the blade-degree parity.
  set toggle0 : Blade n → Blade n :=
    fun s => if (⟨0, hn⟩ : Fin n) ∈ s then s.erase ⟨0, hn⟩ else insert ⟨0, hn⟩ s
  have h_toggle_bij :
      Finset.image toggle0 (evenBlades n) = oddBlades n ∧
        Finset.image toggle0 (oddBlades n) = evenBlades n := by
    constructor <;> ext s <;> simp +decide [toggle0]
    · constructor <;> intro h
      · rcases h with ⟨a, ha, rfl⟩; split_ifs <;> simp_all +decide [evenBlades, oddBlades]
        rcases k : Finset.card a with (_ | _ | k) <;> simp_all +decide [parity_simps]
      · exact ⟨toggle0 s, by simp_all +decide [evenBlades, oddBlades]; grind +revert⟩
    · constructor <;> intro h
      · rcases h with ⟨a, ha, rfl⟩; simp_all +decide [evenBlades, oddBlades]
        grind +suggestions
      · refine ⟨toggle0 s, ?_⟩
        unfold toggle0; split_ifs <;> simp_all +decide [evenBlades, oddBlades]
        cases k : Finset.card s <;> simp_all +decide [parity_simps]
  grind

/-- For `n ≥ 1` the even-degree blades number exactly `2 ^ (n - 1)`. -/
theorem evenBlades_card (n : ℕ) (hn : 0 < n) :
    (evenBlades n).card = 2 ^ (n - 1) := by
  have h₁ := even_add_odd_card n
  have h₂ := even_eq_odd_card n hn
  rcases n with _ | m
  · omega
  · norm_num [pow_succ'] at *; omega

/-- For `n ≥ 1` the odd-degree blades number exactly `2 ^ (n - 1)`. -/
theorem oddBlades_card (n : ℕ) (hn : 0 < n) :
    (oddBlades n).card = 2 ^ (n - 1) := by
  rw [← evenBlades_card n hn, even_eq_odd_card n hn]

/-- The fraction of even-degree blades among all `2 ^ n` blades in dimension `n`. -/
noncomputable def evenFraction (n : ℕ) : ℝ := (evenBlades n).card / (2 ^ n : ℝ)

/-- The fraction of odd-degree blades among all `2 ^ n` blades in dimension `n`. -/
noncomputable def oddFraction (n : ℕ) : ℝ := (oddBlades n).card / (2 ^ n : ℝ)

/-- For `n ≥ 1` the even-blade fraction is exactly `1/2`. -/
theorem evenFraction_eq_half (n : ℕ) (hn : 0 < n) : evenFraction n = 1 / 2 := by
  unfold evenFraction
  rw [evenBlades_card n hn, show n = (n - 1) + 1 by omega, pow_succ]
  have h : (2 : ℝ) ^ (n - 1) ≠ 0 := by positivity
  push_cast
  field_simp

/-- For `n ≥ 1` the odd-blade fraction is exactly `1/2`. -/
theorem oddFraction_eq_half (n : ℕ) (hn : 0 < n) : oddFraction n = 1 / 2 := by
  rw [show oddFraction n = evenFraction n by
        unfold oddFraction evenFraction; rw [even_eq_odd_card n hn]]
  exact evenFraction_eq_half n hn

/-- **Even Clifford-blade balance.**  As the dimension scales, the fraction of even-degree blades
tends to `1/2`. -/
theorem evenBlade_balance :
    Tendsto (fun n : ℕ => evenFraction n) atTop (𝓝 (1 / 2)) :=
  tendsto_const_nhds.congr'
    (by filter_upwards [Filter.eventually_gt_atTop 0] with n hn using (evenFraction_eq_half n hn).symm)

/-- **Odd Clifford-blade balance.**  As the dimension scales, the fraction of odd-degree blades
tends to `1/2`. -/
theorem oddBlade_balance :
    Tendsto (fun n : ℕ => oddFraction n) atTop (𝓝 (1 / 2)) :=
  tendsto_const_nhds.congr'
    (by filter_upwards [Filter.eventually_gt_atTop 0] with n hn using (oddFraction_eq_half n hn).symm)

end CliffordBlades
