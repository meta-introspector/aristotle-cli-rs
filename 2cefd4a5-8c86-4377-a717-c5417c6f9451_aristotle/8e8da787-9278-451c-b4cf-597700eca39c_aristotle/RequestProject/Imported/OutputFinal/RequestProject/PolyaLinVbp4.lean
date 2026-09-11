/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.
-/
import RequestProject.Imported.OutputFinal.RequestProject.PolyaOscLin

/-!
# Rational brackets for the breakpoints `vBP q = 2 log q` (part 4)

Each bracket comes from the logarithmic series `vBP_bracket 12`.
-/

set_option maxHeartbeats 1000000

noncomputable section

open MeasureTheory Set Real

namespace ConnesConsani.WeilPositivity

theorem vbpP423 : (0.592787965:ℝ) ≤ vBP 1.345 ∧ vBP 1.345 ≤ 0.592788078 := by
  have h := vBP_bracket 12 (q := 1.345) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP424 : (0.597243959:ℝ) ≤ vBP 1.348 ∧ vBP 1.348 ≤ 0.597244082 := by
  have h := vBP_bracket 12 (q := 1.348) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP425 : (0.600209115:ℝ) ≤ vBP 1.35 ∧ vBP 1.35 ≤ 0.600209245 := by
  have h := vBP_bracket 12 (q := 1.35) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP426 : (0.603169881:ℝ) ≤ vBP 1.352 ∧ vBP 1.352 ≤ 0.603170019 := by
  have h := vBP_bracket 12 (q := 1.352) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP427 : (0.607602828:ℝ) ≤ vBP 1.355 ∧ vBP 1.355 ≤ 0.607602978 := by
  have h := vBP_bracket 12 (q := 1.355) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP428 : (0.612025971:ℝ) ≤ vBP 1.358 ∧ vBP 1.358 ≤ 0.612026133 := by
  have h := vBP_bracket 12 (q := 1.358) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP429 : (0.614969307:ℝ) ≤ vBP 1.36 ∧ vBP 1.36 ≤ 0.614969479 := by
  have h := vBP_bracket 12 (q := 1.36) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP430 : (0.617908318:ℝ) ≤ vBP 1.362 ∧ vBP 1.362 ≤ 0.617908499 := by
  have h := vBP_bracket 12 (q := 1.362) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP431 : (0.620843016:ℝ) ≤ vBP 1.364 ∧ vBP 1.364 ≤ 0.620843207 := by
  have h := vBP_bracket 12 (q := 1.364) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP432 : (0.623773414:ℝ) ≤ vBP 1.366 ∧ vBP 1.366 ≤ 0.623773615 := by
  have h := vBP_bracket 12 (q := 1.366) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP433 : (0.628160975:ℝ) ≤ vBP 1.369 ∧ vBP 1.369 ≤ 0.628161193 := by
  have h := vBP_bracket 12 (q := 1.369) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP434 : (0.632538932:ℝ) ≤ vBP 1.372 ∧ vBP 1.372 ≤ 0.632539168 := by
  have h := vBP_bracket 12 (q := 1.372) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP435 : (0.635452254:ℝ) ≤ vBP 1.374 ∧ vBP 1.374 ≤ 0.635452503 := by
  have h := vBP_bracket 12 (q := 1.374) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP436 : (0.638361338:ℝ) ≤ vBP 1.376 ∧ vBP 1.376 ≤ 0.6383616 := by
  have h := vBP_bracket 12 (q := 1.376) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP437 : (0.641266197:ℝ) ≤ vBP 1.378 ∧ vBP 1.378 ≤ 0.641266473 := by
  have h := vBP_bracket 12 (q := 1.378) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP438 : (0.644166843:ℝ) ≤ vBP 1.38 ∧ vBP 1.38 ≤ 0.644167132 := by
  have h := vBP_bracket 12 (q := 1.38) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP439 : (0.648509937:ℝ) ≤ vBP 1.383 ∧ vBP 1.383 ≤ 0.64851025 := by
  have h := vBP_bracket 12 (q := 1.383) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP440 : (0.65284362:ℝ) ≤ vBP 1.386 ∧ vBP 1.386 ≤ 0.652843958 := by
  have h := vBP_bracket 12 (q := 1.386) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP441 : (0.655727534:ℝ) ≤ vBP 1.388 ∧ vBP 1.388 ≤ 0.655727888 := by
  have h := vBP_bracket 12 (q := 1.388) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP442 : (0.658607294:ℝ) ≤ vBP 1.39 ∧ vBP 1.39 ≤ 0.658607667 := by
  have h := vBP_bracket 12 (q := 1.39) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP443 : (0.661482914:ℝ) ≤ vBP 1.392 ∧ vBP 1.392 ≤ 0.661483305 := by
  have h := vBP_bracket 12 (q := 1.392) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP444 : (0.664354404:ℝ) ≤ vBP 1.394 ∧ vBP 1.394 ≤ 0.664354815 := by
  have h := vBP_bracket 12 (q := 1.394) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP445 : (0.668653923:ℝ) ≤ vBP 1.397 ∧ vBP 1.397 ≤ 0.668654365 := by
  have h := vBP_bracket 12 (q := 1.397) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP446 : (0.672944218:ℝ) ≤ vBP 1.4 ∧ vBP 1.4 ≤ 0.672944693 := by
  have h := vBP_bracket 12 (q := 1.4) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP447 : (0.67579931:ℝ) ≤ vBP 1.402 ∧ vBP 1.402 ≤ 0.675799807 := by
  have h := vBP_bracket 12 (q := 1.402) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP448 : (0.678650331:ℝ) ≤ vBP 1.404 ∧ vBP 1.404 ≤ 0.678650853 := by
  have h := vBP_bracket 12 (q := 1.404) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP449 : (0.681497293:ℝ) ≤ vBP 1.406 ∧ vBP 1.406 ≤ 0.68149784 := by
  have h := vBP_bracket 12 (q := 1.406) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP450 : (0.684340208:ℝ) ≤ vBP 1.408 ∧ vBP 1.408 ≤ 0.684340781 := by
  have h := vBP_bracket 12 (q := 1.408) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP451 : (0.688597016:ℝ) ≤ vBP 1.411 ∧ vBP 1.411 ≤ 0.68859763 := by
  have h := vBP_bracket 12 (q := 1.411) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP452 : (0.692844781:ℝ) ≤ vBP 1.414 ∧ vBP 1.414 ≤ 0.692845439 := by
  have h := vBP_bracket 12 (q := 1.414) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP453 : (0.69567162:ℝ) ≤ vBP 1.416 ∧ vBP 1.416 ≤ 0.695672309 := by
  have h := vBP_bracket 12 (q := 1.416) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP454 : (0.698494469:ℝ) ≤ vBP 1.418 ∧ vBP 1.418 ≤ 0.69849519 := by
  have h := vBP_bracket 12 (q := 1.418) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP455 : (0.701313338:ℝ) ≤ vBP 1.42 ∧ vBP 1.42 ≤ 0.701314092 := by
  have h := vBP_bracket 12 (q := 1.42) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP456 : (0.704128239:ℝ) ≤ vBP 1.422 ∧ vBP 1.422 ≤ 0.704129028 := by
  have h := vBP_bracket 12 (q := 1.422) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP457 : (0.708343174:ℝ) ≤ vBP 1.425 ∧ vBP 1.425 ≤ 0.708344018 := by
  have h := vBP_bracket 12 (q := 1.425) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP458 : (0.712549244:ℝ) ≤ vBP 1.428 ∧ vBP 1.428 ≤ 0.712550145 := by
  have h := vBP_bracket 12 (q := 1.428) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP459 : (0.715348383:ℝ) ≤ vBP 1.43 ∧ vBP 1.43 ≤ 0.715349324 := by
  have h := vBP_bracket 12 (q := 1.43) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP460 : (0.718143609:ℝ) ≤ vBP 1.432 ∧ vBP 1.432 ≤ 0.718144592 := by
  have h := vBP_bracket 12 (q := 1.432) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP461 : (0.720934933:ℝ) ≤ vBP 1.434 ∧ vBP 1.434 ≤ 0.720935959 := by
  have h := vBP_bracket 12 (q := 1.434) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP462 : (0.723722366:ℝ) ≤ vBP 1.436 ∧ vBP 1.436 ≤ 0.723723437 := by
  have h := vBP_bracket 12 (q := 1.436) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP463 : (0.727896242:ℝ) ≤ vBP 1.439 ∧ vBP 1.439 ≤ 0.727897384 := by
  have h := vBP_bracket 12 (q := 1.439) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP464 : (0.732061424:ℝ) ≤ vBP 1.442 ∧ vBP 1.442 ≤ 0.732062641 := by
  have h := vBP_bracket 12 (q := 1.442) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP465 : (0.734833399:ℝ) ≤ vBP 1.444 ∧ vBP 1.444 ≤ 0.734834668 := by
  have h := vBP_bracket 12 (q := 1.444) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP466 : (0.737601536:ℝ) ≤ vBP 1.446 ∧ vBP 1.446 ≤ 0.73760286 := by
  have h := vBP_bracket 12 (q := 1.446) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP467 : (0.740365847:ℝ) ≤ vBP 1.448 ∧ vBP 1.448 ≤ 0.740367226 := by
  have h := vBP_bracket 12 (q := 1.448) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP468 : (0.74312634:ℝ) ≤ vBP 1.45 ∧ vBP 1.45 ≤ 0.743127778 := by
  have h := vBP_bracket 12 (q := 1.45) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP469 : (0.747259948:ℝ) ≤ vBP 1.453 ∧ vBP 1.453 ≤ 0.747261477 := by
  have h := vBP_bracket 12 (q := 1.453) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP470 : (0.751385026:ℝ) ≤ vBP 1.456 ∧ vBP 1.456 ≤ 0.751386652 := by
  have h := vBP_bracket 12 (q := 1.456) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP471 : (0.754130358:ℝ) ≤ vBP 1.458 ∧ vBP 1.458 ≤ 0.75413205 := by
  have h := vBP_bracket 12 (q := 1.458) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP472 : (0.756871925:ℝ) ≤ vBP 1.46 ∧ vBP 1.46 ≤ 0.756873687 := by
  have h := vBP_bracket 12 (q := 1.46) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP473 : (0.759609738:ℝ) ≤ vBP 1.462 ∧ vBP 1.462 ≤ 0.759611571 := by
  have h := vBP_bracket 12 (q := 1.462) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP474 : (0.762343806:ℝ) ≤ vBP 1.464 ∧ vBP 1.464 ≤ 0.762345714 := by
  have h := vBP_bracket 12 (q := 1.464) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP475 : (0.766437911:ℝ) ≤ vBP 1.467 ∧ vBP 1.467 ≤ 0.766439935 := by
  have h := vBP_bracket 12 (q := 1.467) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP476 : (0.770523648:ℝ) ≤ vBP 1.47 ∧ vBP 1.47 ≤ 0.770525795 := by
  have h := vBP_bracket 12 (q := 1.47) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP477 : (0.773242842:ℝ) ≤ vBP 1.472 ∧ vBP 1.472 ≤ 0.773245073 := by
  have h := vBP_bracket 12 (q := 1.472) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP478 : (0.778670157:ℝ) ≤ vBP 1.476 ∧ vBP 1.476 ≤ 0.778672568 := by
  have h := vBP_bracket 12 (q := 1.476) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP479 : (0.7813783:ℝ) ≤ vBP 1.478 ∧ vBP 1.478 ≤ 0.781380804 := by
  have h := vBP_bracket 12 (q := 1.478) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP480 : (0.785433646:ℝ) ≤ vBP 1.481 ∧ vBP 1.481 ≤ 0.785436298 := by
  have h := vBP_bracket 12 (q := 1.481) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP481 : (0.789480782:ℝ) ≤ vBP 1.484 ∧ vBP 1.484 ≤ 0.789483588 := by
  have h := vBP_bracket 12 (q := 1.484) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP482 : (0.792174328:ℝ) ≤ vBP 1.486 ∧ vBP 1.486 ≤ 0.79217724 := by
  have h := vBP_bracket 12 (q := 1.486) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP483 : (0.797550555:ℝ) ≤ vBP 1.49 ∧ vBP 1.49 ≤ 0.797553692 := by
  have h := vBP_bracket 12 (q := 1.49) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP484 : (0.800233255:ℝ) ≤ vBP 1.492 ∧ vBP 1.492 ≤ 0.80023651 := by
  have h := vBP_bracket 12 (q := 1.492) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP485 : (0.804250567:ℝ) ≤ vBP 1.495 ∧ vBP 1.495 ≤ 0.804254005 := by
  have h := vBP_bracket 12 (q := 1.495) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP486 : (0.80825982:ℝ) ≤ vBP 1.498 ∧ vBP 1.498 ≤ 0.808263451 := by
  have h := vBP_bracket 12 (q := 1.498) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP487 : (0.810928194:ℝ) ≤ vBP 1.5 ∧ vBP 1.5 ≤ 0.810931959 := by
  have h := vBP_bracket 12 (q := 1.5) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP488 : (0.816254279:ℝ) ≤ vBP 1.504 ∧ vBP 1.504 ≤ 0.816258323 := by
  have h := vBP_bracket 12 (q := 1.504) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP489 : (0.821566208:ℝ) ≤ vBP 1.508 ∧ vBP 1.508 ≤ 0.821570548 := by
  have h := vBP_bracket 12 (q := 1.508) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP490 : (0.826864054:ℝ) ≤ vBP 1.512 ∧ vBP 1.512 ≤ 0.826868711 := by
  have h := vBP_bracket 12 (q := 1.512) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP491 : (0.832147894:ℝ) ≤ vBP 1.516 ∧ vBP 1.516 ≤ 0.832152885 := by
  have h := vBP_bracket 12 (q := 1.516) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP492 : (0.837417798:ℝ) ≤ vBP 1.52 ∧ vBP 1.52 ≤ 0.837423144 := by
  have h := vBP_bracket 12 (q := 1.52) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP493 : (0.842673841:ℝ) ≤ vBP 1.524 ∧ vBP 1.524 ≤ 0.842679564 := by
  have h := vBP_bracket 12 (q := 1.524) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP494 : (0.847916093:ℝ) ≤ vBP 1.528 ∧ vBP 1.528 ≤ 0.847922215 := by
  have h := vBP_bracket 12 (q := 1.528) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP495 : (0.851838776:ℝ) ≤ vBP 1.531 ∧ vBP 1.531 ≤ 0.851845213 := by
  have h := vBP_bracket 12 (q := 1.531) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP496 : (0.855753773:ℝ) ≤ vBP 1.534 ∧ vBP 1.534 ≤ 0.855760537 := by
  have h := vBP_bracket 12 (q := 1.534) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP497 : (0.860961862:ℝ) ≤ vBP 1.538 ∧ vBP 1.538 ≤ 0.860969087 := by
  have h := vBP_bracket 12 (q := 1.538) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP498 : (0.866156409:ℝ) ≤ vBP 1.542 ∧ vBP 1.542 ≤ 0.86616412 := by
  have h := vBP_bracket 12 (q := 1.542) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP499 : (0.871337483:ℝ) ≤ vBP 1.546 ∧ vBP 1.546 ≤ 0.871345708 := by
  have h := vBP_bracket 12 (q := 1.546) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP500 : (0.876505154:ℝ) ≤ vBP 1.55 ∧ vBP 1.55 ≤ 0.876513921 := by
  have h := vBP_bracket 12 (q := 1.55) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP501 : (0.881659488:ℝ) ≤ vBP 1.554 ∧ vBP 1.554 ≤ 0.881668828 := by
  have h := vBP_bracket 12 (q := 1.554) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP502 : (0.886800555:ℝ) ≤ vBP 1.558 ∧ vBP 1.558 ≤ 0.886810498 := by
  have h := vBP_bracket 12 (q := 1.558) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP503 : (0.891928421:ℝ) ≤ vBP 1.562 ∧ vBP 1.562 ≤ 0.891939001 := by
  have h := vBP_bracket 12 (q := 1.562) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP504 : (0.897043153:ℝ) ≤ vBP 1.566 ∧ vBP 1.566 ≤ 0.897054404 := by
  have h := vBP_bracket 12 (q := 1.566) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP505 : (0.902144817:ℝ) ≤ vBP 1.57 ∧ vBP 1.57 ≤ 0.902156775 := by
  have h := vBP_bracket 12 (q := 1.57) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP506 : (0.907233479:ℝ) ≤ vBP 1.574 ∧ vBP 1.574 ≤ 0.907246181 := by
  have h := vBP_bracket 12 (q := 1.574) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP507 : (0.912309203:ℝ) ≤ vBP 1.578 ∧ vBP 1.578 ≤ 0.912322689 := by
  have h := vBP_bracket 12 (q := 1.578) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP508 : (0.917372055:ℝ) ≤ vBP 1.582 ∧ vBP 1.582 ≤ 0.917386364 := by
  have h := vBP_bracket 12 (q := 1.582) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP509 : (0.922422098:ℝ) ≤ vBP 1.586 ∧ vBP 1.586 ≤ 0.922437273 := by
  have h := vBP_bracket 12 (q := 1.586) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP510 : (0.927459396:ℝ) ≤ vBP 1.59 ∧ vBP 1.59 ≤ 0.92747548 := by
  have h := vBP_bracket 12 (q := 1.59) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP511 : (0.932484012:ℝ) ≤ vBP 1.594 ∧ vBP 1.594 ≤ 0.932501051 := by
  have h := vBP_bracket 12 (q := 1.594) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP512 : (0.937496007:ℝ) ≤ vBP 1.598 ∧ vBP 1.598 ≤ 0.937514049 := by
  have h := vBP_bracket 12 (q := 1.598) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP513 : (0.942495445:ℝ) ≤ vBP 1.602 ∧ vBP 1.602 ≤ 0.942514539 := by
  have h := vBP_bracket 12 (q := 1.602) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP514 : (0.947482387:ℝ) ≤ vBP 1.606 ∧ vBP 1.606 ≤ 0.947502584 := by
  have h := vBP_bracket 12 (q := 1.606) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP515 : (0.952456893:ℝ) ≤ vBP 1.61 ∧ vBP 1.61 ≤ 0.952478246 := by
  have h := vBP_bracket 12 (q := 1.61) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP516 : (0.957419025:ℝ) ≤ vBP 1.614 ∧ vBP 1.614 ≤ 0.957441589 := by
  have h := vBP_bracket 12 (q := 1.614) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP517 : (0.962368841:ℝ) ≤ vBP 1.618 ∧ vBP 1.618 ≤ 0.962392675 := by
  have h := vBP_bracket 12 (q := 1.618) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP518 : (0.971001566:ℝ) ≤ vBP 1.625 ∧ vBP 1.625 ≤ 0.971027765 := by
  have h := vBP_bracket 12 (q := 1.625) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP519 : (0.979597074:ℝ) ≤ vBP 1.632 ∧ vBP 1.632 ≤ 0.979625832 := by
  have h := vBP_bracket 12 (q := 1.632) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP520 : (0.989375339:ℝ) ≤ vBP 1.64 ∧ vBP 1.64 ≤ 0.989407275 := by
  have h := vBP_bracket 12 (q := 1.64) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP521 : (0.999105857:ℝ) ≤ vBP 1.648 ∧ vBP 1.648 ≤ 0.999141262 := by
  have h := vBP_bracket 12 (q := 1.648) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP522 : (1.008789079:ℝ) ≤ vBP 1.656 ∧ vBP 1.656 ≤ 1.008828261 := by
  have h := vBP_bracket 12 (q := 1.656) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP523 : (1.018425446:ℝ) ≤ vBP 1.664 ∧ vBP 1.664 ≤ 1.018468739 := by
  have h := vBP_bracket 12 (q := 1.664) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP524 : (1.028015395:ℝ) ≤ vBP 1.672 ∧ vBP 1.672 ≤ 1.028063152 := by
  have h := vBP_bracket 12 (q := 1.672) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP525 : (1.037559355:ℝ) ≤ vBP 1.68 ∧ vBP 1.68 ≤ 1.037611953 := by
  have h := vBP_bracket 12 (q := 1.68) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP526 : (1.047057747:ℝ) ≤ vBP 1.688 ∧ vBP 1.688 ≤ 1.047115589 := by
  have h := vBP_bracket 12 (q := 1.688) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP527 : (1.056510986:ℝ) ≤ vBP 1.696 ∧ vBP 1.696 ≤ 1.056574501 := by
  have h := vBP_bracket 12 (q := 1.696) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP528 : (1.06591948:ℝ) ≤ vBP 1.704 ∧ vBP 1.704 ≤ 1.065989123 := by
  have h := vBP_bracket 12 (q := 1.704) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP529 : (1.075283632:ℝ) ≤ vBP 1.712 ∧ vBP 1.712 ≤ 1.075359886 := by
  have h := vBP_bracket 12 (q := 1.712) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP530 : (1.083441202:ℝ) ≤ vBP 1.719 ∧ vBP 1.719 ≤ 1.083523659 := by
  have h := vBP_bracket 12 (q := 1.719) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP531 : (1.091565385:ℝ) ≤ vBP 1.726 ∧ vBP 1.726 ≤ 1.091654459 := by
  have h := vBP_bracket 12 (q := 1.726) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP532 : (1.100809614:ℝ) ≤ vBP 1.734 ∧ vBP 1.734 ≤ 1.100906783 := by
  have h := vBP_bracket 12 (q := 1.734) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP533 : (1.110010952:ℝ) ≤ vBP 1.742 ∧ vBP 1.742 ≤ 1.110116813 := by
  have h := vBP_bracket 12 (q := 1.742) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP534 : (1.119169769:ℝ) ≤ vBP 1.75 ∧ vBP 1.75 ≤ 1.119284956 := by
  have h := vBP_bracket 12 (q := 1.75) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP535 : (1.128286431:ℝ) ≤ vBP 1.758 ∧ vBP 1.758 ≤ 1.128411612 := by
  have h := vBP_bracket 12 (q := 1.758) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP536 : (1.1373613:ℝ) ≤ vBP 1.766 ∧ vBP 1.766 ≤ 1.137497178 := by
  have h := vBP_bracket 12 (q := 1.766) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP537 : (1.146394728:ℝ) ≤ vBP 1.774 ∧ vBP 1.774 ≤ 1.146542045 := by
  have h := vBP_bracket 12 (q := 1.774) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP538 : (1.154265259:ℝ) ≤ vBP 1.781 ∧ vBP 1.781 ≤ 1.154423223 := by
  have h := vBP_bracket 12 (q := 1.781) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP539 : (1.162104559:ℝ) ≤ vBP 1.788 ∧ vBP 1.788 ≤ 1.162273795 := by
  have h := vBP_bracket 12 (q := 1.788) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP540 : (1.171025808:ℝ) ≤ vBP 1.796 ∧ vBP 1.796 ≤ 1.171208726 := by
  have h := vBP_bracket 12 (q := 1.796) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP541 : (1.179906896:ℝ) ≤ vBP 1.804 ∧ vBP 1.804 ≤ 1.180104389 := by
  have h := vBP_bracket 12 (q := 1.804) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP542 : (1.18874815:ℝ) ≤ vBP 1.812 ∧ vBP 1.812 ≤ 1.188961156 := by
  have h := vBP_bracket 12 (q := 1.812) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP543 : (1.20631244:ℝ) ≤ vBP 1.828 ∧ vBP 1.828 ≤ 1.206559466 := by
  have h := vBP_bracket 12 (q := 1.828) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP544 : (1.223721196:ℝ) ≤ vBP 1.844 ∧ vBP 1.844 ≤ 1.224006549 := by
  have h := vBP_bracket 12 (q := 1.844) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP545 : (1.240976851:ℝ) ≤ vBP 1.86 ∧ vBP 1.86 ≤ 1.241305238 := by
  have h := vBP_bracket 12 (q := 1.86) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP546 : (1.257017075:ℝ) ≤ vBP 1.875 ∧ vBP 1.875 ≤ 1.257390455 := by
  have h := vBP_bracket 12 (q := 1.875) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP547 : (1.272926687:ℝ) ≤ vBP 1.89 ∧ vBP 1.89 ≤ 1.27334993 := by
  have h := vBP_bracket 12 (q := 1.89) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP548 : (1.289755025:ℝ) ≤ vBP 1.906 ∧ vBP 1.906 ≤ 1.290237253 := by
  have h := vBP_bracket 12 (q := 1.906) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP549 : (1.306438961:ℝ) ≤ vBP 1.922 ∧ vBP 1.922 ≤ 1.306986635 := by
  have h := vBP_bracket 12 (q := 1.922) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP550 : (1.322980561:ℝ) ≤ vBP 1.938 ∧ vBP 1.938 ≤ 1.323600648 := by
  have h := vBP_bracket 12 (q := 1.938) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP551 : (1.339381823:ℝ) ≤ vBP 1.954 ∧ vBP 1.954 ≤ 1.340081817 := by
  have h := vBP_bracket 12 (q := 1.954) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP552 : (1.354632265:ℝ) ≤ vBP 1.969 ∧ vBP 1.969 ≤ 1.355414471 := by
  have h := vBP_bracket 12 (q := 1.969) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP553 : (1.369762595:ℝ) ≤ vBP 1.984 ∧ vBP 1.984 ≤ 1.370634556 := by
  have h := vBP_bracket 12 (q := 1.984) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP554 : (1.385770899:ℝ) ≤ vBP 2 ∧ vBP 2 ≤ 1.386747463 := by
  have h := vBP_bracket 12 (q := 2) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP555 : (1.401645979:ℝ) ≤ vBP 2.016 ∧ vBP 2.016 ≤ 1.402736898 := by
  have h := vBP_bracket 12 (q := 2.016) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP556 : (1.416409372:ℝ) ≤ vBP 2.031 ∧ vBP 2.031 ≤ 1.417616918 := by
  have h := vBP_bracket 12 (q := 2.031) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP557 : (1.431058495:ℝ) ≤ vBP 2.046 ∧ vBP 2.046 ≤ 1.432392338 := by
  have h := vBP_bracket 12 (q := 2.046) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP558 : (1.446559738:ℝ) ≤ vBP 2.062 ∧ vBP 2.062 ≤ 1.448039579 := by
  have h := vBP_bracket 12 (q := 2.062) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP559 : (1.461933964:ℝ) ≤ vBP 2.078 ∧ vBP 2.078 ≤ 1.463572129 := by
  have h := vBP_bracket 12 (q := 2.078) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

theorem vbpP560 : (1.477182639:ℝ) ≤ vBP 2.094 ∧ vBP 2.094 ≤ 1.478992167 := by
  have h := vBP_bracket 12 (q := 2.094) (by norm_num)
  norm_num [Finset.sum_range_succ, abs_le] at h
  constructor <;> linarith [h.1, h.2]

end ConnesConsani.WeilPositivity
