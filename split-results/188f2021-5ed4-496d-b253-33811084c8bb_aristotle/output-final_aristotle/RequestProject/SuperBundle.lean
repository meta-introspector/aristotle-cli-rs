import RequestProject.LaurentCohomology

/-!
# A computational framework for split super vector bundles on `ℙ¹`

Building on the Laurent-polynomial cohomology engine `LaurentCohomology`, this file packages
the Čech computation into a small, reusable framework for **split** super vector bundles on
`ℙ¹` given by *diagonal* transition data (cocycles) on `𝔾ₘ`.

A super vector bundle on `ℙ¹` is, after Birkhoff–Grothendieck, a direct sum of line bundles
`O(d)`, split into an even (bosonic) part and an odd (fermionic) part.  A diagonal cocycle on
the overlap `𝔾ₘ = Spec K[z, z⁻¹]` is therefore recorded by two lists of integers: the degrees
of the even summands and the degrees of the odd summands.  Concretely the transition
super-matrix is `diag(z^{e₁}, …, z^{eₐ} ∣ z^{o₁}, …, z^{o_b})`.

Given such data the framework computes the super-vector-space cohomology
`H⁰`, `H¹` of the bundle as products of the line-bundle cohomologies from
`LaurentCohomology`, and reads off the **super-dimensions**
`sdim Hⁱ = (even part ∣ odd part)`.

This is exactly the structure used in `RequestProject.Main` for the super tangent bundle
`T_X` of the weighted projective superspace `X = WP^{1∣1}(1,1 ∣ m)`, whose diagonal cocycle
is `even = [2, 1]`, `odd = [m, 2 - m]`.

## Main definitions and results

* `SplitSuperBundle` : the transition data (two integer lists `even`, `odd`).
* `H0even`, `H0odd`, `H1even`, `H1odd` : the four super-vector-space cohomology pieces.
* `finrank_H0even`, …, `finrank_H1odd` : their dimensions as explicit `List.sum`s.
* `sdimH0`, `sdimH1`, `sdimH0_eq`, `sdimH1_eq` : the numeric (super-)dimensions, and the
  theorems certifying that they equal the actual module dimensions.
-/

open LaurentCohomology

namespace SuperBundleP1

/-- A split super vector bundle on `ℙ¹` described by **diagonal transition data** on `𝔾ₘ`:
`even` lists the degrees of the even line-bundle summands `O(eᵢ)` and `odd` lists the
degrees of the odd summands `O(oⱼ)`, i.e. the transition cocycle is the diagonal
super-matrix `diag(z^{eᵢ} ∣ z^{oⱼ})`. -/
structure SplitSuperBundle where
  /-- Degrees of the even (bosonic) line-bundle summands. -/
  even : List ℤ
  /-- Degrees of the odd (fermionic) line-bundle summands. -/
  odd : List ℤ

variable (K : Type*) [Field K]

/-- `H⁰` of a list of line bundles: the product of the `cechH0`s of the summands. -/
abbrev H0list (l : List ℤ) : Type _ := (i : Fin l.length) → cechH0 K l[i]

/-- `H¹` of a list of line bundles: the product of the `cechH1`s of the summands. -/
abbrev H1list (l : List ℤ) : Type _ := (i : Fin l.length) → cechH1 K l[i]

/-- Dimension of `H⁰` of a list of line bundles: `∑ max(0, dᵢ + 1)`. -/
theorem finrank_H0list (l : List ℤ) :
    Module.finrank K (H0list K l) = (l.map (fun d => (d + 1).toNat)).sum := by
  rw [Module.finrank_pi_fintype]
  simp only [finrank_cechH0]
  exact Fin.sum_univ_fun_getElem l (fun d => (d + 1).toNat)

/-- Dimension of `H¹` of a list of line bundles: `∑ max(0, -dᵢ - 1)`. -/
theorem finrank_H1list (l : List ℤ) :
    Module.finrank K (H1list K l) = (l.map (fun d => (-d - 1).toNat)).sum := by
  rw [Module.finrank_pi_fintype]
  simp only [finrank_cechH1]
  exact Fin.sum_univ_fun_getElem l (fun d => (-d - 1).toNat)

variable (E : SplitSuperBundle)

/-- The even part of `H⁰(X, E)`. -/
abbrev H0even : Type _ := H0list K E.even
/-- The odd part of `H⁰(X, E)`. -/
abbrev H0odd : Type _ := H0list K E.odd
/-- The even part of `H¹(X, E)`. -/
abbrev H1even : Type _ := H1list K E.even
/-- The odd part of `H¹(X, E)`. -/
abbrev H1odd : Type _ := H1list K E.odd

theorem finrank_H0even :
    Module.finrank K (H0even K E) = (E.even.map (fun d => (d + 1).toNat)).sum :=
  finrank_H0list K E.even
theorem finrank_H0odd :
    Module.finrank K (H0odd K E) = (E.odd.map (fun d => (d + 1).toNat)).sum :=
  finrank_H0list K E.odd
theorem finrank_H1even :
    Module.finrank K (H1even K E) = (E.even.map (fun d => (-d - 1).toNat)).sum :=
  finrank_H1list K E.even
theorem finrank_H1odd :
    Module.finrank K (H1odd K E) = (E.odd.map (fun d => (-d - 1).toNat)).sum :=
  finrank_H1list K E.odd

/-- Numeric super-dimension `(even ∣ odd)` of `H⁰(X, E)`. -/
def sdimH0 : ℕ × ℕ :=
  ((E.even.map (fun d => (d + 1).toNat)).sum, (E.odd.map (fun d => (d + 1).toNat)).sum)

/-- Numeric super-dimension `(even ∣ odd)` of `H¹(X, E)`. -/
def sdimH1 : ℕ × ℕ :=
  ((E.even.map (fun d => (-d - 1).toNat)).sum, (E.odd.map (fun d => (-d - 1).toNat)).sum)

/-- The numeric super-dimension `sdimH0` is the genuine pair of module dimensions. -/
theorem sdimH0_eq :
    (Module.finrank K (H0even K E), Module.finrank K (H0odd K E)) = sdimH0 E := by
  rw [finrank_H0even, finrank_H0odd, sdimH0]

/-- The numeric super-dimension `sdimH1` is the genuine pair of module dimensions. -/
theorem sdimH1_eq :
    (Module.finrank K (H1even K E), Module.finrank K (H1odd K E)) = sdimH1 E := by
  rw [finrank_H1even, finrank_H1odd, sdimH1]

end SuperBundleP1
