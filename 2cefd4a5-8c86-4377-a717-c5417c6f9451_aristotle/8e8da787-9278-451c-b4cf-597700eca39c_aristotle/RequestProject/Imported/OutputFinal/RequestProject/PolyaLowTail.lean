/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.
-/
import RequestProject.Imported.OutputFinal.RequestProject.PolyaPartition3
import RequestProject.Imported.OutputFinal.RequestProject.PolyaOscLin

/-!
# The unresolved tail of the extended partition

Beyond `q = 5` the absolute-value estimate is retained, but with the sharp
Si-asymptotics it costs only `0.0022` instead of the `0.013709` of the cut at
`q = 2.094`.
-/

set_option maxHeartbeats 4000000

noncomputable section

open MeasureTheory Set Real

namespace ConnesConsani.WeilPositivity

theorem errPtC0 : errPtBracket 5 5.5 (-0.00689449) 0.00852521 :=
  errPiece_sharp_asymp (C0 := (-1)) (C1 := 1) (S0 := (-1)) (S1 := 1)
    (by norm_num) (by norm_num)
    (fun r _ _ => ⟨neg_one_le_cos _, cos_le_one _, neg_one_le_sin _, sin_le_one _⟩)
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])
theorem errPtC1 : errPtBracket 5.5 6 (-0.00550198) 0.00669551 :=
  errPiece_sharp_asymp (C0 := (-1)) (C1 := 1) (S0 := (-1)) (S1 := 1)
    (by norm_num) (by norm_num)
    (fun r _ _ => ⟨neg_one_le_cos _, cos_le_one _, neg_one_le_sin _, sin_le_one _⟩)
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])
theorem errPtC2 : errPtBracket 6 7 (-0.00619047) 0.00700339 :=
  errPiece_sharp_asymp (C0 := (-1)) (C1 := 1) (S0 := (-1)) (S1 := 1)
    (by norm_num) (by norm_num)
    (fun r _ _ => ⟨neg_one_le_cos _, cos_le_one _, neg_one_le_sin _, sin_le_one _⟩)
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])
theorem errPtC3 : errPtBracket 7 9 (-0.00594384) 0.00636846 :=
  errPiece_sharp_asymp (C0 := (-1)) (C1 := 1) (S0 := (-1)) (S1 := 1)
    (by norm_num) (by norm_num)
    (fun r _ _ => ⟨neg_one_le_cos _, cos_le_one _, neg_one_le_sin _, sin_le_one _⟩)
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])
theorem errPtC4 : errPtBracket 9 13.5 (-0.00462418) 0.00477492 :=
  errPiece_sharp_asymp (C0 := (-1)) (C1 := 1) (S0 := (-1)) (S1 := 1)
    (by norm_num) (by norm_num)
    (fun r _ _ => ⟨neg_one_le_cos _, cos_le_one _, neg_one_le_sin _, sin_le_one _⟩)
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])
/-- The `L¹` mass of the model error beyond the extended cut `q = 5`.  The pieces
up to `q = 13.5` use the sharp Si-asymptotics with the trivial bounds `|cos|,|sin| ≤ 1`,
and beyond `13.5` the crude tail estimate is enough. -/
theorem integral_Ioi_abs_errFun_tail_five :
    (∫ v in Ioi (vBP 5), |errFun v|) ≤ 0.0022 := by
  have e0 := (errIntBracket_of_pointwise (q0 := 5) (q1 := 5.5) (M := 0.00852521)
    (by norm_num) (by norm_num) errPtC0 (by norm_num) (by norm_num)).2.2
  have e1 := (errIntBracket_of_pointwise (q0 := 5.5) (q1 := 6) (M := 0.00669551)
    (by norm_num) (by norm_num) errPtC1 (by norm_num) (by norm_num)).2.2
  have e2 := (errIntBracket_of_pointwise (q0 := 6) (q1 := 7) (M := 0.00700339)
    (by norm_num) (by norm_num) errPtC2 (by norm_num) (by norm_num)).2.2
  have e3 := (errIntBracket_of_pointwise (q0 := 7) (q1 := 9) (M := 0.00636846)
    (by norm_num) (by norm_num) errPtC3 (by norm_num) (by norm_num)).2.2
  have e4 := (errIntBracket_of_pointwise (q0 := 9) (q1 := 13.5) (M := 0.00477492)
    (by norm_num) (by norm_num) errPtC4 (by norm_num) (by norm_num)).2.2
  have et := integral_tail_le (q0 := 13.5) (M := 0.00336)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have s0 := integral_Ioi_abs_errFun_split (a := vBP 5) (b := vBP 5.5)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s1 := integral_Ioi_abs_errFun_split (a := vBP 5.5) (b := vBP 6)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s2 := integral_Ioi_abs_errFun_split (a := vBP 6) (b := vBP 7)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s3 := integral_Ioi_abs_errFun_split (a := vBP 7) (b := vBP 9)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  have s4 := integral_Ioi_abs_errFun_split (a := vBP 9) (b := vBP 13.5)
    (vBP_nonneg (by norm_num)) (vBP_mono (by norm_num) (by norm_num))
  rw [s0, s1, s2, s3, s4]
  norm_num at e0 e1 e2 e3 e4 et ⊢
  linarith

end ConnesConsani.WeilPositivity
