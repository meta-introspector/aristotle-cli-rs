/-
# Mock Theta Functions and Appell-Lerch Sums

Formalization of key definitions from Zwegers' thesis "Mock Theta Functions" (2002),
arXiv:0807.4834.

## Main Definitions

* `ramanujanF` : Ramanujan's third-order mock theta function f(q)
* `ramanujanPhi` : Ramanujan's third-order mock theta function φ(q)
* `ramanujanPsi` : Ramanujan's third-order mock theta function ψ(q)
* `ramanujanChi` : Ramanujan's third-order mock theta function χ(q)
* `appellLerchSum` : The Appell-Lerch sum, central to Zwegers' work

## References

* S. Ramanujan, "The Lost Notebook and Other Unpublished Papers", 1988.
* S.P. Zwegers, "Mock Theta Functions", PhD thesis, Universiteit Utrecht, 2002.
  arXiv:0807.4834
* G.E. Andrews, "Mock theta functions", Proc. Sympos. Pure Math., 1986.
-/

import Mathlib
import RequestProject.QPochhammer

open Finset BigOperators Complex

/-!
## Ramanujan's Third-Order Mock Theta Functions

These are the original mock theta functions from Ramanujan's last letter to Hardy (1920).
Zwegers' thesis (Chapter 1) shows how these connect to Appell-Lerch sums.

The four third-order mock theta functions are:
- `f(q) = ∑_{n≥0} q^{n²} / ((-q;q)_n)²`
- `φ(q) = ∑_{n≥0} q^{n²} / (-q²;q²)_n`
- `ψ(q) = ∑_{n≥1} q^{n²} / (q;q²)_n`
- `χ(q) = ∑_{n≥0} q^{n²}·(-q;q)_n / (-q³;q³)_n`

where `(a;q)_n` is the q-Pochhammer symbol.
-/

/-- The `n`-th term of Ramanujan's third-order mock theta function `f(q)`:
`f_n(q) = q^{n²} / ((-q;q)_n)²`. -/
noncomputable def ramanujanF_term (q : ℂ) (n : ℕ) : ℂ :=
  q ^ (n ^ 2 : ℕ) / (qPochhammer (-q) q n) ^ 2

/-- Ramanujan's third-order mock theta function `f(q) = ∑_{n≥0} q^{n²} / ((-q;q)_n)²`.
This is the most studied of Ramanujan's mock theta functions and appears
prominently in Zwegers' thesis (Section 1.1). -/
noncomputable def ramanujanF (q : ℂ) : ℂ :=
  ∑' n, ramanujanF_term q n

/-- The `n`-th term of Ramanujan's third-order mock theta function `φ(q)`:
`φ_n(q) = q^{n²} / (-q²;q²)_n`. -/
noncomputable def ramanujanPhi_term (q : ℂ) (n : ℕ) : ℂ :=
  q ^ (n ^ 2 : ℕ) / qPochhammer (-(q ^ 2)) (q ^ 2) n

/-- Ramanujan's third-order mock theta function `φ(q) = ∑_{n≥0} q^{n²} / (-q²;q²)_n`. -/
noncomputable def ramanujanPhi (q : ℂ) : ℂ :=
  ∑' n, ramanujanPhi_term q n

/-- The `n`-th term of Ramanujan's third-order mock theta function `ψ(q)`:
`ψ_n(q) = q^{n²} / (q;q²)_n` for `n ≥ 1`. -/
noncomputable def ramanujanPsi_term (q : ℂ) (n : ℕ) : ℂ :=
  q ^ (n ^ 2 : ℕ) / qPochhammer q (q ^ 2) n

/-- Ramanujan's third-order mock theta function `ψ(q) = ∑_{n≥1} q^{n²} / (q;q²)_n`. -/
noncomputable def ramanujanPsi (q : ℂ) : ℂ :=
  ∑' n, ramanujanPsi_term q (n + 1)

/-- The `n`-th term of Ramanujan's third-order mock theta function `χ(q)`:
`χ_n(q) = q^{n²} · (-q;q)_n / (-q³;q³)_n`. -/
noncomputable def ramanujanChi_term (q : ℂ) (n : ℕ) : ℂ :=
  q ^ (n ^ 2 : ℕ) * qPochhammer (-q) q n / qPochhammer (-(q ^ 3)) (q ^ 3) n

/-- Ramanujan's third-order mock theta function `χ(q) = ∑_{n≥0} q^{n²}·(-q;q)_n / (-q³;q³)_n`. -/
noncomputable def ramanujanChi (q : ℂ) : ℂ :=
  ∑' n, ramanujanChi_term q n

/-!
## Appell-Lerch Sums

The Appell-Lerch sum is the central object of Zwegers' thesis. It provides the
key link between Ramanujan's mock theta functions and the theory of modular forms.

Following Zwegers (Definition 1.3), for `u, v ∈ ℂ` and `τ` in the upper half-plane:

`μ(u, v; τ) = (e^{πiu} / ϑ(v;τ)) · ∑_{n ∈ ℤ} (-1)^n · e^{πi(n²+n)τ + 2πinv} / (1 - e^{2πinτ + 2πiu})`

The key insight of Zwegers is that while μ itself is not modular, it can be
"completed" to a function μ̂ that transforms as a (non-holomorphic) modular form.
-/

/-- The `n`-th term of the Appell-Lerch sum (for `n ∈ ℤ`).
This is `(-1)^n · e^{πi(n²+n)τ + 2πinv} / (1 - e^{2πinτ + 2πiu})`. -/
noncomputable def appellLerchTerm (u v tau : ℂ) (n : ℤ) : ℂ :=
  (-1) ^ n *
    Complex.exp (↑Real.pi * Complex.I * (↑(n ^ 2) + ↑n) * tau +
      2 * ↑Real.pi * Complex.I * ↑n * v) /
    (1 - Complex.exp (2 * ↑Real.pi * Complex.I * ↑n * tau +
      2 * ↑Real.pi * Complex.I * u))

/-- The Appell-Lerch sum `μ(u, v; τ)`, the central object of Zwegers' thesis.
Defined as `e^{πiu} · ∑_{n ∈ ℤ} appellLerchTerm u v τ n`.

This function is mock modular: it fails to be modular, but its failure is
controlled by a non-holomorphic correction term involving the error function.
Zwegers' key contribution is identifying this correction and showing that
the "completed" function μ̂ transforms as a true (non-holomorphic) modular form. -/
noncomputable def appellLerchSum (u v tau : ℂ) : ℂ :=
  Complex.exp (↑Real.pi * Complex.I * u) *
    ∑' n : ℤ, appellLerchTerm u v tau n

/-!
## Basic properties of mock theta function terms

We prove that the terms of the mock theta functions satisfy expected
algebraic identities using the q-Pochhammer recurrence.
-/

/-
The zeroth term of f(q) equals 1.
-/
@[simp]
theorem ramanujanF_term_zero (q : ℂ) : ramanujanF_term q 0 = 1 := by
  unfold ramanujanF_term;
  norm_num [ qPochhammer ]

/-
The first term of f(q) equals q/(1+q)².
-/
theorem ramanujanF_term_one (q : ℂ) :
    ramanujanF_term q 1 = q / (1 + q) ^ 2 := by
  unfold ramanujanF_term;
  -- By definition of qPochhammer, we have qPochhammer (-q) q 1 = 1 - (-q) * q^0 = 1 + q.
  simp [qPochhammer]

/-
The zeroth term of φ(q) equals 1.
-/
@[simp]
theorem ramanujanPhi_term_zero (q : ℂ) : ramanujanPhi_term q 0 = 1 := by
  unfold ramanujanPhi_term qPochhammer; norm_num;

/-
The zeroth term of χ(q) equals 1.
-/
@[simp]
theorem ramanujanChi_term_zero (q : ℂ) : ramanujanChi_term q 0 = 1 := by
  unfold ramanujanChi_term qPochhammer; norm_num;