import Mathlib

/-!
# Rotations in the shader-golf dialect

The formal counterpart of the matrix layer of `web/js/shader.js`: the `mat2`,
`mat3` and `mat4` values, the two rotations shader golf is written with, and
the row-vector product `v * M` that GLSL — and therefore the dialect — means by
`p *= rotate3D(…)`.

A shader such as

```
for(float i,e,g;i++<1e2;){
  vec3 p=vec3((FC.xy-r*.5)/r.y*g,g-4.3);
  p.zy*=rotate2D(t*.2);
  for(int j;j++<7;)
    p*=rotate3D(1.57,vec3(1,1.5*smoothstep(-1.,1.,sin(t*.4))-.5,0)),
    p=abs(p+p)-2.;
  …}
```

is a march that alternates *turning* space with *folding* it, so what the
picture rests on is that the turns are rigid — they move no point nearer to or
further from the eye — and that the fold stays inside the box it folds.  That
is what is proved here.

* `rot2` is the matrix `rotate2D` builds, written as usual with its columns
  `(cos a, sin a)` and `(-sin a, cos a)`.  It is orthogonal, has determinant
  one, composes by adding angles, and is the identity at angle zero.
* `rot3 a u` is the matrix `rotate3D(a, u)` builds — Rodrigues' rotation about
  `u`, entry for entry.  For a unit axis it is orthogonal and fixes the axis.
* Both preserve the dot product, hence every length and angle: `rot2_dotProduct`
  and `rot3_dotProduct`.
* `vecMul_rot2` states the convention: the dialect's `v *= rotate2D(a)` is the
  row vector times the matrix, which turns `v` by `-a`.
* `fold` is the kaleidoscope's fold `x ↦ |2x| - 2`; `abs_fold_le` says it keeps
  the box `[-2, 2]`, so the marched point cannot escape however many times the
  loop folds it.

`tests/node/test_kaleido.mjs` checks the shipped JavaScript against the same
statements, and compares the dialect's evaluation of the shader above with an
independent transcription of it.
-/

namespace Hesper.Rotate

open Matrix Real

/-! ## The plane rotation `rotate2D` -/

/-- `rotate2D a`: the matrix with columns `(cos a, sin a)` and `(-sin a, cos a)`,
which is how `web/js/shader.js` fills its column-major `mat2`. -/
noncomputable def rot2 (a : ℝ) : Matrix (Fin 2) (Fin 2) ℝ :=
  !![cos a, -sin a; sin a, cos a]

@[simp] theorem rot2_zero : rot2 0 = 1 := by
  ext i j
  fin_cases i <;> fin_cases j <;> simp [rot2]

/-- Turning by `a` and then by `b` is turning by `a + b`. -/
theorem rot2_mul (a b : ℝ) : rot2 a * rot2 b = rot2 (a + b) := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [rot2, Matrix.mul_apply, Fin.sum_univ_two, cos_add, sin_add] <;> ring

/-- `rotate2D` is orthogonal. -/
theorem rot2_transpose_mul (a : ℝ) : (rot2 a)ᵀ * rot2 a = 1 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [rot2, Matrix.mul_apply, Fin.sum_univ_two] <;>
    linarith [sin_sq_add_cos_sq a]

/-- A plane rotation has determinant one: it turns, and does not reflect. -/
theorem rot2_det (a : ℝ) : (rot2 a).det = 1 := by
  have pyth : sin a ^ 2 + cos a ^ 2 = 1 := sin_sq_add_cos_sq a
  simp [rot2, Matrix.det_fin_two_of]
  linear_combination pyth

/-! ## Rodrigues' rotation `rotate3D` -/

/-- `rotate3D a u`: Rodrigues' rotation by `a` about `u`, entry for entry the
matrix `web/js/shader.js` builds (its `m` array is this matrix by columns).  The
runtime normalises the axis first; the statements below therefore assume `u` is
a unit vector. -/
noncomputable def rot3 (a : ℝ) (u : Fin 3 → ℝ) : Matrix (Fin 3) (Fin 3) ℝ :=
  !![u 0 * u 0 * (1 - cos a) + cos a,
     u 0 * u 1 * (1 - cos a) - u 2 * sin a,
     u 0 * u 2 * (1 - cos a) + u 1 * sin a;
     u 1 * u 0 * (1 - cos a) + u 2 * sin a,
     u 1 * u 1 * (1 - cos a) + cos a,
     u 1 * u 2 * (1 - cos a) - u 0 * sin a;
     u 2 * u 0 * (1 - cos a) - u 1 * sin a,
     u 2 * u 1 * (1 - cos a) + u 0 * sin a,
     u 2 * u 2 * (1 - cos a) + cos a]

@[simp] theorem rot3_zero (u : Fin 3 → ℝ) : rot3 0 u = 1 := by
  ext i j
  fin_cases i <;> fin_cases j <;> simp [rot3]

/-- About a unit axis, `rotate3D` is orthogonal. -/
theorem rot3_transpose_mul (a : ℝ) (u : Fin 3 → ℝ)
    (hu : u 0 ^ 2 + u 1 ^ 2 + u 2 ^ 2 = 1) : (rot3 a u)ᵀ * rot3 a u = 1 := by
  have pyth : sin a ^ 2 + cos a ^ 2 = 1 := sin_sq_add_cos_sq a
  ext i j
  fin_cases i <;> fin_cases j <;> simp [rot3, Matrix.mul_apply, Fin.sum_univ_three]
  · linear_combination (1 - u 0 * u 0) * pyth + (sin a ^ 2 + u 0 * u 0 * (1 - cos a) ^ 2) * hu
  · linear_combination (-(u 0 * u 1)) * pyth + (u 0 * u 1 * (1 - cos a) ^ 2) * hu
  · linear_combination (-(u 0 * u 2)) * pyth + (u 0 * u 2 * (1 - cos a) ^ 2) * hu
  · linear_combination (-(u 1 * u 0)) * pyth + (u 1 * u 0 * (1 - cos a) ^ 2) * hu
  · linear_combination (1 - u 1 * u 1) * pyth + (sin a ^ 2 + u 1 * u 1 * (1 - cos a) ^ 2) * hu
  · linear_combination (-(u 1 * u 2)) * pyth + (u 1 * u 2 * (1 - cos a) ^ 2) * hu
  · linear_combination (-(u 2 * u 0)) * pyth + (u 2 * u 0 * (1 - cos a) ^ 2) * hu
  · linear_combination (-(u 2 * u 1)) * pyth + (u 2 * u 1 * (1 - cos a) ^ 2) * hu
  · linear_combination (1 - u 2 * u 2) * pyth + (sin a ^ 2 + u 2 * u 2 * (1 - cos a) ^ 2) * hu

/-- A rotation fixes its axis. -/
theorem rot3_axis (a : ℝ) (u : Fin 3 → ℝ) (hu : u 0 ^ 2 + u 1 ^ 2 + u 2 ^ 2 = 1) :
    rot3 a u *ᵥ u = u := by
  funext i
  fin_cases i <;> simp [rot3, Matrix.mulVec, dotProduct, Fin.sum_univ_three]
  · linear_combination ((1 - cos a) * u 0) * hu
  · linear_combination ((1 - cos a) * u 1) * hu
  · linear_combination ((1 - cos a) * u 2) * hu

/-! ## What the rotations preserve -/

/-- An orthogonal matrix preserves the dot product, hence every length and
angle: this is the sense in which a step of the march is rigid. -/
theorem dotProduct_mulVec_of_orthogonal {n : Type*} [Fintype n] [DecidableEq n]
    {M : Matrix n n ℝ} (h : Mᵀ * M = 1) (v w : n → ℝ) :
    (M *ᵥ v) ⬝ᵥ (M *ᵥ w) = v ⬝ᵥ w := by
  rw [dotProduct_mulVec, ← mulVec_transpose, mulVec_mulVec, h, one_mulVec]

theorem rot2_dotProduct (a : ℝ) (v w : Fin 2 → ℝ) :
    (rot2 a *ᵥ v) ⬝ᵥ (rot2 a *ᵥ w) = v ⬝ᵥ w :=
  dotProduct_mulVec_of_orthogonal (rot2_transpose_mul a) v w

theorem rot3_dotProduct (a : ℝ) (u : Fin 3 → ℝ) (hu : u 0 ^ 2 + u 1 ^ 2 + u 2 ^ 2 = 1)
    (v w : Fin 3 → ℝ) : (rot3 a u *ᵥ v) ⬝ᵥ (rot3 a u *ᵥ w) = v ⬝ᵥ w :=
  dotProduct_mulVec_of_orthogonal (rot3_transpose_mul a u hu) v w

/-- The dialect's `v *= rotate2D(a)` is GLSL's row-vector product, so it turns
`v` by `-a`. -/
theorem vecMul_rot2 (a : ℝ) (v : Fin 2 → ℝ) : v ᵥ* rot2 a = rot2 (-a) *ᵥ v := by
  funext i
  fin_cases i <;> simp [rot2, vecMul, mulVec, dotProduct, Fin.sum_univ_two] <;> ring

/-! ## The fold -/

/-- The kaleidoscope's fold, `p = abs(p+p) - 2` written one lane at a time. -/
def fold (x : ℝ) : ℝ := |2 * x| - 2

/-- The fold keeps the box `[-2, 2]`: however many times the inner loop folds
the marched point, it stays in the region the distance estimate was written
for. -/
theorem abs_fold_le {x : ℝ} (hx : |x| ≤ 2) : |fold x| ≤ 2 := by
  have h : |2 * x| = 2 * |x| := by rw [abs_mul]; norm_num
  rw [fold, h, abs_le]
  constructor <;> [linarith [abs_nonneg x]; linarith]

end Hesper.Rotate
