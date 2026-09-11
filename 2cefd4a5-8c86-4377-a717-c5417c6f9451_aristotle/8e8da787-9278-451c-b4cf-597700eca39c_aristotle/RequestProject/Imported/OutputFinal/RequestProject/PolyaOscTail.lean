/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.
-/
import RequestProject.Imported.OutputFinal.RequestProject.PolyaPartition3
import RequestProject.Imported.OutputFinal.RequestProject.PolyaOscBlocks4

/-!
# The unresolved tail of the model error

The oscillatory refinement is carried out on the `q`-range `[1, 2.094]`; beyond it the
absolute-value estimate is retained.
-/

set_option maxHeartbeats 1000000

noncomputable section

open MeasureTheory Set Real

namespace ConnesConsani.WeilPositivity

/-- The `L¹` mass of the model error beyond the cut `q = 2.094` (i.e. `v ≥ 2 log 2.094`).
This is the part of `∫|err|` that the oscillatory refinement does not resolve; it is bounded
by chunks 57–60 of the partition together with the `q ≥ 13.5` tail. -/
theorem integral_Ioi_abs_errFun_tail_cut :
    (∫ v in Ioi (vBP 2.094), |errFun v|) ≤ 0.013709 := by
  have et := integral_tail_le (q0 := 13.5) (M := 0.00336)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num)
  have c57 := integral_abs_errFun_chunk57
  have c58 := integral_abs_errFun_chunk58
  have c59 := integral_abs_errFun_chunk59
  have c60 := integral_abs_errFun_chunk60
  norm_num at et c57 c58 c59 c60 ⊢
  linarith

end ConnesConsani.WeilPositivity
