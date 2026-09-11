/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.
-/
import RequestProject.Imported.OutputFinal.RequestProject.PolyaOscLin

/-!
# Sharpened pointwise brackets on the pieces of the partition (part 8)
-/

set_option maxHeartbeats 1000000

noncomputable section

open MeasureTheory Set Real

namespace ConnesConsani.WeilPositivity

theorem errPt490 : errPtBracket 1.512 1.516 (-0.0254757) (-0.01006886) :=
  errPiece_sharp_asymp
    (C0 := (-0.298577093)) (C1 := (-0.225152399)) (S0 := 0.954385519) (S1 := 0.974323559)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.036144) (u1 := 0.048256) (j := (2:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPt491 : errPtBracket 1.516 1.52 (-0.01917497) (-0.00388098) :=
  errPiece_sharp_asymp
    (C0 := (-0.370460171)) (C1 := (-0.298577091)) (S0 := 0.928848352) (S1 := 0.95438552)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.048256) (u1 := 0.0604) (j := (2:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPt492 : errPtBracket 1.52 1.524 (-0.01307821) 0.00205466 :=
  errPiece_sharp_asymp
    (C0 := (-0.440367948)) (C1 := (-0.37046017)) (S0 := 0.897817392) (S1 := 0.928848353)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.0604) (u1 := 0.072576) (j := (2:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPt493 : errPtBracket 1.524 1.528 (-0.00721432) 0.00771071 :=
  errPiece_sharp_asymp
    (C0 := (-0.507872776)) (C1 := (-0.440367947)) (S0 := 0.861432088) (S1 := 0.897817394)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.072576) (u1 := 0.084784) (j := (2:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPt494 : errPtBracket 1.528 1.531 (-0.00065904) 0.0107685 :=
  errPiece_sharp_asymp
    (C0 := (-0.556672068)) (C1 := (-0.507872775)) (S0 := 0.830732333) (S1 := 0.86143209)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.084784) (u1 := 0.093961) (j := (2:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPt495 : errPtBracket 1.531 1.534 0.00335699 0.01463125 :=
  errPiece_sharp_asymp
    (C0 := (-0.603711233)) (C1 := (-0.556672066)) (S0 := 0.797203078) (S1 := 0.830732336)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.093961) (u1 := 0.103156) (j := (2:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPt496 : errPtBracket 1.534 1.538 0.00625137 0.02046451 :=
  errPiece_sharp_asymp
    (C0 := (-0.663401901)) (C1 := (-0.603711231)) (S0 := 0.748263268) (S1 := 0.797203083)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.103156) (u1 := 0.115444) (j := (2:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPt497 : errPtBracket 1.538 1.542 0.01109638 0.02495344 :=
  errPiece_sharp_asymp
    (C0 := (-0.719279665)) (C1 := (-0.663401899)) (S0 := 0.694720639) (S1 := 0.748263281)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.115444) (u1 := 0.127764) (j := (2:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPt498 : errPtBracket 1.542 1.546 0.01559968 0.02906351 :=
  errPiece_sharp_asymp
    (C0 := (-0.770977631)) (C1 := (-0.719279661)) (S0 := 0.636862231) (S1 := 0.694720672)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.127764) (u1 := 0.140116) (j := (2:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPt499 : errPtBracket 1.546 1.55 0.01974254 0.03277861 :=
  errPiece_sharp_asymp
    (C0 := (-0.818149734)) (C1 := (-0.770977623)) (S0 := 0.57500525) (S1 := 0.63686231)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.140116) (u1 := 0.1525) (j := (2:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPt500 : errPtBracket 1.55 1.554 0.02350838 0.03608499 :=
  errPiece_sharp_asymp
    (C0 := (-0.860473279)) (C1 := (-0.818149716)) (S0 := 0.50949563) (S1 := 0.575005432)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.1525) (u1 := 0.164916) (j := (2:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPt501 : errPtBracket 1.554 1.558 0.02688293 0.0389713 :=
  errPiece_sharp_asymp
    (C0 := (-0.897651397)) (C1 := (-0.86047324)) (S0 := 0.440706377) (S1 := 0.509496025)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.164916) (u1 := 0.177364) (j := (2:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPt502 : errPtBracket 1.558 1.562 0.02985426 0.04142869 :=
  errPiece_sharp_asymp
    (C0 := (-0.929415385)) (C1 := (-0.897651312)) (S0 := 0.369035703) (S1 := 0.440707194)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.177364) (u1 := 0.189844) (j := (2:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPt503 : errPtBracket 1.562 1.566 0.03241283 0.0434508 :=
  errPiece_sharp_asymp
    (C0 := (-0.955526931)) (C1 := (-0.92941521)) (S0 := 0.294904948) (S1 := 0.369037313)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.189844) (u1 := 0.202356) (j := (2:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPt504 : errPtBracket 1.566 1.57 0.03455157 0.04503385 :=
  errPiece_sharp_asymp
    (C0 := (-0.97578018)) (C1 := (-0.955526578)) (S0 := 0.218756308) (S1 := 0.294907993)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.202356) (u1 := 0.2149) (j := (2:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPt505 : errPtBracket 1.57 1.574 0.0362659 0.04617657 :=
  errPiece_sharp_asymp
    (C0 := (-0.990003657)) (C1 := (-0.975779497)) (S0 := 0.141050371) (S1 := 0.218761862)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.2149) (u1 := 0.227476) (j := (2:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPt506 : errPtBracket 1.574 1.578 0.03755372 0.04688031 :=
  errPiece_sharp_asymp
    (C0 := (-0.998062003)) (C1 := (-0.990002382)) (S0 := 0.062263477) (S1 := 0.141060178)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.227476) (u1 := 0.240084) (j := (2:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPt507 : errPtBracket 1.578 1.582 (-0.09975825) 0.05360076 :=
  errPiece_crude_asymp (by norm_num) (by norm_num) (by norm_num)
    (by norm_num) (by norm_num)

theorem errPt508 : errPtBracket 1.582 1.586 0.03855347 0.04733864 :=
  errPiece_sharp_asymp
    (C0 := (-0.999853536)) (C1 := (-0.995324728)) (S0 := (-0.096585119)) (S1 := (-0.017114561))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket2 (u0 := 0.002724) (u1 := 0.015396) (j := (2:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPt509 : errPtBracket 1.586 1.59 0.03813363 0.04720994 :=
  errPiece_sharp_asymp
    (C0 := (-0.995324729)) (C1 := (-0.984454169)) (S0 := (-0.175641645)) (S1 := (-0.096585118))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket2 (u0 := 0.015396) (u1 := 0.0281) (j := (2:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPt510 : errPtBracket 1.59 1.594 0.03731587 0.04665981 :=
  errPiece_sharp_asymp
    (C0 := (-0.98445417)) (C1 := (-0.9672635)) (S0 := (-0.253774152)) (S1 := (-0.175641644))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket2 (u0 := 0.0281) (u1 := 0.040836) (j := (2:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPt511 : errPtBracket 1.594 1.598 0.03611284 0.04569944 :=
  errPiece_sharp_asymp
    (C0 := (-0.967263501)) (C1 := (-0.943815718)) (S0 := (-0.330472224)) (S1 := (-0.25377415))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket2 (u0 := 0.040836) (u1 := 0.053604) (j := (2:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPt512 : errPtBracket 1.598 1.602 0.03453943 0.04434238 :=
  errPiece_sharp_asymp
    (C0 := (-0.943815719)) (C1 := (-0.914215484)) (S0 := (-0.40522839)) (S1 := (-0.330472222))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket2 (u0 := 0.053604) (u1 := 0.066404) (j := (2:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPt513 : errPtBracket 1.602 1.606 0.03261269 0.04260445 :=
  errPiece_sharp_asymp
    (C0 := (-0.914215485)) (C1 := (-0.878609162)) (S0 := (-0.477541558)) (S1 := (-0.405228389))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket2 (u0 := 0.066404) (u1 := 0.079236) (j := (2:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPt514 : errPtBracket 1.606 1.61 0.03035167 0.04050367 :=
  errPiece_sharp_asymp
    (C0 := (-0.878609164)) (C1 := (-0.837184564)) (S0 := (-0.546920474)) (S1 := (-0.477541557))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket2 (u0 := 0.079236) (u1 := 0.0921) (j := (2:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPt515 : errPtBracket 1.61 1.614 0.02777738 0.03806012 :=
  errPiece_sharp_asymp
    (C0 := (-0.837184567)) (C1 := (-0.790170415)) (S0 := (-0.612887196)) (S1 := (-0.546920472))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket2 (u0 := 0.0921) (u1 := 0.104996) (j := (2:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPt516 : errPtBracket 1.614 1.618 0.02491261 0.03529583 :=
  errPiece_sharp_asymp
    (C0 := (-0.790170421)) (C1 := (-0.737835519)) (S0 := (-0.674980554)) (S1 := (-0.612887194))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket2 (u0 := 0.104996) (u1 := 0.117924) (j := (2:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPt517 : errPtBracket 1.618 1.625 0.01690981 0.03455809 :=
  errPiece_sharp_asymp
    (C0 := (-0.737835534)) (C1 := (-0.634393283)) (S0 := (-0.773010461)) (S1 := (-0.674980551))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket2 (u0 := 0.117924) (u1 := 0.140625) (j := (2:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPt518 : errPtBracket 1.625 1.632 0.0106877 0.02847315 :=
  errPiece_sharp_asymp
    (C0 := (-0.634393365)) (C1 := (-0.517539642)) (S0 := (-0.855659263)) (S1 := (-0.773010452))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket2 (u0 := 0.140625) (u1 := 0.163424) (j := (2:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPt519 : errPtBracket 1.632 1.64 0.00221826 0.02241038 :=
  errPiece_sharp_asymp
    (C0 := (-0.517540003)) (C1 := (-0.370460153)) (S0 := (-0.928848523)) (S1 := (-0.855659227))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket2 (u0 := 0.163424) (u1 := 0.1896) (j := (2:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPt520 : errPtBracket 1.64 1.648 (-0.0059219) 0.01400873 :=
  errPiece_sharp_asymp
    (C0 := (-0.370461742)) (C1 := (-0.212596464)) (S0 := (-0.977140776)) (S1 := (-0.92884835))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket2 (u0 := 0.1896) (u1 := 0.215904) (j := (2:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPt521 : errPtBracket 1.648 1.656 (-0.01425155) 0.00517469 :=
  errPiece_sharp_asymp
    (C0 := (-0.212602284)) (C1 := (-0.048135403)) (S0 := (-0.998843322)) (S1 := (-0.977140057))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket2 (u0 := 0.215904) (u1 := 0.242336) (j := (2:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPt522 : errPtBracket 1.656 1.664 (-0.08045654) 0.04923049 :=
  errPiece_crude_asymp (by norm_num) (by norm_num) (by norm_num)
    (by norm_num) (by norm_num)

theorem errPt523 : errPtBracket 1.664 1.672 (-0.03104535) (-0.01242835) :=
  errPiece_sharp_asymp
    (C0 := 0.118448334) (C1 := 0.282512903) (S0 := (-0.992960217)) (S1 := (-0.959263498))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket3 (u0 := 0.018896) (u1 := 0.045584) (j := (2:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPt524 : errPtBracket 1.672 1.68 (-0.03878546) (-0.02066807) :=
  errPiece_sharp_asymp
    (C0 := 0.282512902) (C1 := 0.439374836) (S0 := (-0.959263499)) (S1 := (-0.89830382))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket3 (u0 := 0.045584) (u1 := 0.0724) (j := (2:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPt525 : errPtBracket 1.68 1.688 (-0.04572764) (-0.02836616) :=
  errPiece_sharp_asymp
    (C0 := 0.439374835) (C1 := 0.584445688) (S0 := (-0.898303821)) (S1 := (-0.81143283))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket3 (u0 := 0.0724) (u1 := 0.099344) (j := (2:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPt526 : errPtBracket 1.688 1.696 (-0.05167426) (-0.03530547) :=
  errPiece_sharp_asymp
    (C0 := 0.584445686) (C1 := 0.713369837) (S0 := (-0.811432834)) (S1 := (-0.700787755))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket3 (u0 := 0.099344) (u1 := 0.126416) (j := (2:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPt527 : errPtBracket 1.696 1.704 (-0.05645772) (-0.04129216) :=
  errPiece_sharp_asymp
    (C0 := 0.713369833) (C1 := 0.822161545) (S0 := (-0.700787785)) (S1 := (-0.569254266))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket3 (u0 := 0.126416) (u1 := 0.153616) (j := (2:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPt528 : errPtBracket 1.704 1.712 (-0.05994501) (-0.04616102) :=
  errPiece_sharp_asymp
    (C0 := 0.822161526) (C1 := 0.90733666) (S0 := (-0.569254462)) (S1 := (-0.420404998))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket3 (u0 := 0.153616) (u1 := 0.180944) (j := (2:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPt529 : errPtBracket 1.712 1.719 (-0.06125387) (-0.05036574) :=
  errPiece_sharp_asymp
    (C0 := 0.907336556) (C1 := 0.960225693) (S0 := (-0.420405995)) (S1 := (-0.279226368))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket3 (u0 := 0.180944) (u1 := 0.204961) (j := (2:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPt530 : errPtBracket 1.719 1.726 (-0.0620739) (-0.05242296) :=
  errPiece_sharp_asymp
    (C0 := 0.960225287) (C1 := 0.991371701) (S0 := (-0.279229828)) (S1 := (-0.131090809))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket3 (u0 := 0.204961) (u1 := 0.229076) (j := (2:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPt531 : errPtBracket 1.726 1.734 (-0.06566806) 0.04482764 :=
  errPiece_crude_asymp (by norm_num) (by norm_num) (by norm_num)
    (by norm_num) (by norm_num)

theorem errPt532 : errPtBracket 1.734 1.742 (-0.06145731) (-0.05160082) :=
  errPiece_sharp_asymp
    (C0 := 0.976510695) (C1 := 0.999099168) (S0 := 0.042436452) (S1 := 0.215468933)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.006756) (u1 := 0.034564) (j := (3:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPt533 : errPtBracket 1.742 1.75 (-0.05961616) (-0.04862936) :=
  errPiece_sharp_asymp
    (C0 := 0.923879532) (C1 := 0.976510696) (S0 := 0.215468932) (S1 := 0.382683433)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.034564) (u1 := 0.0625) (j := (3:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPt534 : errPtBracket 1.75 1.758 (-0.05640428) (-0.04441821) :=
  errPiece_sharp_asymp
    (C0 := 0.842423809) (C1 := 0.923879533) (S0 := 0.382683431) (S1 := 0.538815484)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.0625) (u1 := 0.090564) (j := (3:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPt535 : errPtBracket 1.758 1.766 (-0.05192519) (-0.03910361) :=
  errPiece_sharp_asymp
    (C0 := 0.734296918) (C1 := 0.842423812) (S0 := 0.538815482) (S1 := 0.67882843)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.090564) (u1 := 0.118756) (j := (3:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPt536 : errPtBracket 1.766 1.774 (-0.04632004) (-0.03285466) :=
  errPiece_sharp_asymp
    (C0 := 0.602548507) (C1 := 0.734296934) (S0 := 0.678828427) (S1 := 0.798082272)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.118756) (u1 := 0.147076) (j := (3:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPt537 : errPtBracket 1.774 1.781 (-0.0393683) (-0.0271897) :=
  errPiece_sharp_asymp
    (C0 := 0.470920112) (C1 := 0.602548634) (S0 := 0.79808226) (S1 := 0.882175916)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.147076) (u1 := 0.171961) (j := (3:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPt538 : errPtBracket 1.781 1.788 (-0.03302408) (-0.02067705) :=
  errPiece_sharp_asymp
    (C0 := 0.32722051) (C1 := 0.470920712) (S0 := 0.882175855) (S1 := 0.944948257)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.171961) (u1 := 0.196944) (j := (3:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPt539 : errPtBracket 1.788 1.796 (-0.02662301) (-0.01253445) :=
  errPiece_sharp_asymp
    (C0 := 0.152610375) (C1 := 0.327222833) (S0 := 0.944947995) (S1 := 0.988287561)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.196944) (u1 := 0.225616) (j := (3:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPt540 : errPtBracket 1.796 1.804 (-0.05422954) 0.04156782 :=
  errPiece_crude_asymp (by norm_num) (by norm_num) (by norm_num)
    (by norm_num) (by norm_num)

theorem errPt541 : errPtBracket 1.804 1.812 (-0.01047563) 0.0032406 :=
  errPiece_sharp_asymp
    (C0 := (-0.207977247)) (C1 := (-0.027742986)) (S0 := 0.978133664) (S1 := 0.99961509)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.004416) (u1 := 0.033344) (j := (3:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPt542 : errPtBracket 1.812 1.828 (-0.00549331) 0.02076284 :=
  errPiece_sharp_asymp
    (C0 := (-0.544203348)) (C1 := (-0.207977246)) (S0 := 0.838953345) (S1 := 0.978133665)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.033344) (u1 := 0.091584) (j := (3:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPt543 : errPtBracket 1.828 1.844 0.00866909 0.03193799 :=
  errPiece_sharp_asymp
    (C0 := (-0.810256108)) (C1 := (-0.544203347)) (S0 := 0.586075985) (S1 := 0.838953348)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.091584) (u1 := 0.150336) (j := (3:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPt544 : errPtBracket 1.844 1.86 0.01970747 0.03845241 :=
  errPiece_sharp_asymp
    (C0 := (-0.96795559)) (C1 := (-0.810256092)) (S0 := 0.251123357) (S1 := 0.586076143)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.150336) (u1 := 0.2096) (j := (3:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPt545 : errPtBracket 1.86 1.875 (-0.04798372) 0.04151855 :=
  errPiece_crude_asymp (by norm_num) (by norm_num) (by norm_num)
    (by norm_num) (by norm_num)

theorem errPt546 : errPtBracket 1.875 1.89 0.02493904 0.03955152 :=
  errPiece_sharp_asymp
    (C0 := (-0.995184727)) (C1 := (-0.899130426)) (S0 := (-0.437680794)) (S1 := (-0.09801714))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket2 (u0 := 0.015625) (u1 := 0.0721) (j := (3:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPt547 : errPtBracket 1.89 1.906 0.01728014 0.03647198 :=
  errPiece_sharp_asymp
    (C0 := (-0.899130427)) (C1 := (-0.671449541)) (S0 := (-0.74105028)) (S1 := (-0.437680792))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket2 (u0 := 0.0721) (u1 := 0.132836) (j := (3:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPt548 : errPtBracket 1.906 1.922 0.00681142 0.02833408 :=
  errPiece_sharp_asymp
    (C0 := (-0.671449589)) (C1 := (-0.3441474)) (S0 := (-0.938915846)) (S1 := (-0.741050275))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket2 (u0 := 0.132836) (u1 := 0.194084) (j := (3:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPt549 : errPtBracket 1.922 1.938 (-0.04152394) 0.03939957 :=
  errPiece_crude_asymp (by norm_num) (by norm_num) (by norm_num)
    (by norm_num) (by norm_num)

theorem errPt550 : errPtBracket 1.938 1.954 (-0.01724731) 0.00411447 :=
  errPiece_sharp_asymp
    (C0 := 0.036710684) (C1 := 0.415038802) (S0 := (-0.999325936)) (S1 := (-0.909803711))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket3 (u0 := 0.005844) (u1 := 0.068116) (j := (3:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPt551 : errPtBracket 1.954 1.969 (-0.02627227) (-0.00814788) :=
  errPiece_sharp_asymp
    (C0 := 0.4150388) (C1 := 0.715765383) (S0 := (-0.909803712)) (S1 := (-0.698340833))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket3 (u0 := 0.068116) (u1 := 0.126961) (j := (3:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPt552 : errPtBracket 1.969 1.984 (-0.03229306) (-0.01741387) :=
  errPiece_sharp_asymp
    (C0 := 0.715765379) (C1 := 0.92086032) (S0 := (-0.698340864)) (S1 := (-0.389892958))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket3 (u0 := 0.126961) (u1 := 0.186256) (j := (3:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPt553 : errPtBracket 1.984 2 (-0.03603123) 0.0372091 :=
  errPiece_crude_asymp (by norm_num) (by norm_num) (by norm_num)
    (by norm_num) (by norm_num)

theorem errPt554 : errPtBracket 2 2.016 (-0.03383742) (-0.02294906) :=
  errPiece_sharp_asymp
    (C0 := 0.919601134) (C1 := 1) (S0 := 0) (S1 := 0.392853349)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0) (u1 := 0.064256) (j := (4:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPt555 : errPtBracket 2.016 2.031 (-0.03052252) (-0.01670641) :=
  errPiece_sharp_asymp
    (C0 := 0.707280032) (C1 := 0.919601135) (S0 := 0.392853348) (S1 := 0.70693349)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.064256) (u1 := 0.124961) (j := (4:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPt556 : errPtBracket 2.031 2.046 (-0.02360573) (-0.00739109) :=
  errPiece_sharp_asymp
    (C0 := 0.390702838) (C1 := 0.707280058) (S0 := 0.706933486) (S1 := 0.920516995)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.124961) (u1 := 0.186116) (j := (4:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPt557 : errPtBracket 2.046 2.062 (-0.03152619) 0.03521241 :=
  errPiece_crude_asymp (by norm_num) (by norm_num) (by norm_num)
    (by norm_num) (by norm_num)

theorem errPt558 : errPtBracket 2.062 2.078 (-0.00202886) 0.01591523 :=
  errPiece_sharp_asymp
    (C0 := (-0.414855867)) (C1 := (-0.011585934)) (S0 := 0.909887141) (S1 := 0.999932881)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.001844) (u1 := 0.068084) (j := (4:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPt559 : errPtBracket 2.078 2.094 0.0093369 0.0253853 :=
  errPiece_sharp_asymp
    (C0 := (-0.749429233)) (C1 := (-0.414855865)) (S0 := 0.662084459) (S1 := 0.909887142)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.068084) (u1 := 0.134836) (j := (4:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

end ConnesConsani.WeilPositivity
