/-
Copyright (c) 2026. Released under Apache 2.0 license.
-/
import RequestProject.Imported.OutputFinal3.Field1951

/-!
# The discriminant of `f₁₉₅₁`, computed in Lean

This file proves

  `ArtinA5Even.poly1951_discr : poly1951.discr = disc1951`

i.e. that the recorded integer `disc1951 = 268684727248076769842884` really is the discriminant
of the Doud–Moore quintic, as defined by `Polynomial.discr` (the signed determinant of the
`9 × 9` Sylvester matrix of `f` and `f'`).

The determinant itself is never expanded.  Instead the Euclidean algorithm is run on `f` and
`f'` in the form of a *pseudo-remainder sequence*: at each step an identity

  `C (lc ^ k) * A = C c * S + B * q`

with explicit integer polynomials is checked by `ring`, and the resultant lemmas
`Polynomial.resultant_C_mul_left`, `Polynomial.resultant_add_mul_left`,
`Polynomial.resultant_add_left_deg` and `Polynomial.resultant_comm` turn it into a relation
between `Res(A, B)` and `Res(B, S)` with `deg S < deg B`.  Four steps bring the degree down to
`0`, where the resultant is a power of a constant.

Everything is checked by the kernel; no numerical oracle is trusted.
-/

namespace ArtinA5Even

open Polynomial

/-! ## One step of the pseudo-remainder sequence -/

/-- One step of the Euclidean algorithm for resultants over `ℤ`.

If `C (lc ^ k) * A = C c * S + B * q` with `deg B ≤ n`, `B.coeff n = lc`, `deg q + n ≤ m` and
`deg S ≤ d ≤ m`, then the resultant `Res(A, B, m, n)` is determined by `Res(B, S, n, d)`. -/
theorem resultant_step {A B S q : ℤ[X]} {m n d k : ℕ} {lc c : ℤ}
    (hBdeg : B.natDegree ≤ n) (hBlc : B.coeff n = lc)
    (hq : q.natDegree + n ≤ m) (hSdeg : S.natDegree ≤ d) (hdm : d ≤ m)
    (heq : C (lc ^ k) * A = C c * S + B * q) :
    (lc ^ k) ^ n * A.resultant B m n
      = c ^ n * ((-1) ^ (n * (m - d)) * lc ^ (m - d) * ((-1) ^ (d * n) * B.resultant S n d)) := by
  have h0 : (lc ^ k) ^ n * A.resultant B m n = (C (lc ^ k) * A).resultant B m n :=
    (resultant_C_mul_left _ _ _ _ _).symm
  rw [h0, heq, resultant_add_mul_left _ _ _ _ _ hq hBdeg, resultant_C_mul_left]
  congr 1
  have hmd : m = d + (m - d) := (Nat.add_sub_cancel' hdm).symm
  rw [show S.resultant B m n = S.resultant B (d + (m - d)) n by rw [← hmd],
    resultant_add_left_deg _ _ _ _ _ hSdeg, hBlc, resultant_comm]

/-! ## The pseudo-remainder sequence of `f₁₉₅₁` -/

/-- The derivative of `f₁₉₅₁`. -/
theorem poly1951_derivative :
    derivative poly1951 = 5 * X ^ 4 - 4 * X ^ 3 - 2340 * X ^ 2 - 3590 * X + 3106 := by
  unfold poly1951
  simp only [derivative_add, derivative_sub, derivative_mul, derivative_pow, derivative_X,
    derivative_ofNat, Nat.cast_ofNat, C_ofNat, mul_one, Nat.add_one_sub_one]
  ring

/-- First remainder of the pseudo-remainder sequence: `-4X³ - 15X² + 30X + 6`. -/
noncomputable def prs1951a : ℤ[X] := -4 * X ^ 3 - 15 * X ^ 2 + 30 * X + 6

/-- Second remainder: `-1419X² - 2402X + 1966`. -/
noncomputable def prs1951b : ℤ[X] := -1419 * X ^ 2 - 2402 * X + 1966

/-- Third remainder: `2415499X - 339863`. -/
noncomputable def prs1951c : ℤ[X] := 2415499 * X - 339863

theorem prs1951a_natDegree : prs1951a.natDegree ≤ 3 := by unfold prs1951a; compute_degree
theorem prs1951b_natDegree : prs1951b.natDegree ≤ 2 := by unfold prs1951b; compute_degree
theorem prs1951c_natDegree : prs1951c.natDegree ≤ 1 := by unfold prs1951c; compute_degree

theorem prs1951a_coeff : prs1951a.coeff 3 = -4 := by
  unfold prs1951a; simp [coeff_ofNat_mul, coeff_X]
theorem prs1951b_coeff : prs1951b.coeff 2 = -1419 := by
  unfold prs1951b; simp [coeff_ofNat_mul, coeff_X]
theorem prs1951c_coeff : prs1951c.coeff 1 = 2415499 := by
  unfold prs1951c; simp [coeff_ofNat_mul, coeff_X]

theorem deriv1951_natDegree : (derivative poly1951).natDegree ≤ 4 := by
  rw [poly1951_derivative]; compute_degree
theorem deriv1951_coeff : (derivative poly1951).coeff 4 = 5 := by
  rw [poly1951_derivative]; simp [coeff_ofNat_mul, coeff_X]

/-! ## The four reduction steps -/

theorem prs1951_step1 :
    C ((5 : ℤ) ^ 2) * poly1951
      = C (1951 : ℤ) * prs1951a + derivative poly1951 * (5 * X - 1) := by
  rw [poly1951_derivative]
  unfold poly1951 prs1951a
  simp only [map_ofNat, map_pow]
  ring

theorem prs1951_step2 :
    C ((-4 : ℤ) ^ 2) * derivative poly1951
      = C (25 : ℤ) * prs1951b + prs1951a * (-20 * X + 91) := by
  rw [poly1951_derivative]
  unfold prs1951a prs1951b
  simp only [map_ofNat]
  norm_num
  ring

theorem prs1951_step3 :
    C ((-1419 : ℤ) ^ 2) * prs1951a
      = C (32 : ℤ) * prs1951c + prs1951b * (5676 * X + 11677) := by
  unfold prs1951a prs1951b prs1951c
  simp only [map_ofNat]
  norm_num
  ring

theorem prs1951_step4 :
    C ((2415499 : ℤ) ^ 2) * prs1951b
      = C (9335094155760681 : ℤ) * C 1
        + prs1951c * (-3427593081 * X - 6284294195) := by
  unfold prs1951b prs1951c
  simp only [map_ofNat, C_1, mul_one]
  norm_num
  ring

/-! ## Running the sequence -/

theorem resultant_prs1951c_one : prs1951c.resultant (C 1) 1 0 = 1 := by
  rw [resultant_C_zero_right]
  norm_num

theorem resultant_step4 : prs1951b.resultant prs1951c 2 1 = 9335094155760681 := by
  have h := resultant_step (A := prs1951b) (B := prs1951c) (S := C 1)
    (q := -3427593081 * X - 6284294195) (m := 2) (n := 1) (d := 0) (k := 2)
    (lc := 2415499) (c := 9335094155760681) prs1951c_natDegree prs1951c_coeff
    (by have : (-3427593081 * X - 6284294195 : ℤ[X]).natDegree ≤ 1 := by compute_degree
        omega)
    (by simp) (by norm_num) prs1951_step4
  rw [resultant_prs1951c_one] at h
  norm_num at h
  linarith

theorem resultant_step3 : prs1951a.resultant prs1951b 3 2 = 4747378607104 := by
  have h := resultant_step (A := prs1951a) (B := prs1951b) (S := prs1951c)
    (q := 5676 * X + 11677) (m := 3) (n := 2) (d := 1) (k := 2)
    (lc := -1419) (c := 32) prs1951b_natDegree prs1951b_coeff
    (by have : (5676 * X + 11677 : ℤ[X]).natDegree ≤ 1 := by compute_degree
        omega)
    prs1951c_natDegree (by norm_num) prs1951_step3
  rw [resultant_step4] at h
  norm_num at h
  linarith

theorem resultant_step2 :
    (derivative poly1951).resultant prs1951a 4 3 = 289756995062500 := by
  have h := resultant_step (A := derivative poly1951) (B := prs1951a) (S := prs1951b)
    (q := -20 * X + 91) (m := 4) (n := 3) (d := 2) (k := 2)
    (lc := -4) (c := 25) prs1951a_natDegree prs1951a_coeff
    (by have : (-20 * X + 91 : ℤ[X]).natDegree ≤ 1 := by compute_degree
        omega)
    prs1951b_natDegree (by norm_num) prs1951_step2
  rw [resultant_step3] at h
  norm_num at h
  linarith

theorem resultant_step1 :
    poly1951.resultant (derivative poly1951) 5 4 = disc1951 := by
  have h := resultant_step (A := poly1951) (B := derivative poly1951) (S := prs1951a)
    (q := 5 * X - 1) (m := 5) (n := 4) (d := 3) (k := 2)
    (lc := 5) (c := 1951) deriv1951_natDegree deriv1951_coeff
    (by have : (5 * X - 1 : ℤ[X]).natDegree ≤ 1 := by compute_degree
        omega)
    prs1951a_natDegree (by norm_num) prs1951_step1
  rw [resultant_step2] at h
  unfold disc1951
  norm_num at h
  linarith

/-- **The discriminant of `f₁₉₅₁`.**  `Polynomial.discr poly1951 = disc1951`, proved by running
the Euclidean algorithm on `f₁₉₅₁` and `f₁₉₅₁'` inside Lean. -/
theorem poly1951_discr : poly1951.discr = disc1951 := by
  have h := resultant_deriv (f := poly1951)
    (by rw [degree_eq_natDegree poly1951_monic.ne_zero, poly1951_natDegree]; norm_num)
  rw [poly1951_natDegree, poly1951_monic.leadingCoeff] at h
  norm_num at h
  rw [← h, resultant_step1]

end ArtinA5Even
