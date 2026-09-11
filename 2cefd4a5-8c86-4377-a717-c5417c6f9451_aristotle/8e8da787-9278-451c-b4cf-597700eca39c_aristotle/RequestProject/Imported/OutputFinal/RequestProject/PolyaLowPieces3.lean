/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.
-/
import RequestProject.Imported.OutputFinal.RequestProject.PolyaOscLin

/-!
# Pointwise brackets on the pieces of the extended partition (part 3)

The `q`-range `[2.094, 5]` is cut at the quadrant boundaries of `2πq²`, so that
the oscillating part of the Si-asymptotics is resolved and the bracket is
narrow; the short pieces straddling a boundary use the crude bracket.
-/

set_option maxHeartbeats 4000000

noncomputable section

open MeasureTheory Set Real

namespace ConnesConsani.WeilPositivity

theorem errPtT84 : errPtBracket 3.8405734 3.8729828 (-0.00551691) 0.00276838 :=
  errPiece_sharp_asymp
    (C0 := 0.000025389) (C1 := 1.000003542) (S0 := (-1)) (S1 := (-0.000026118))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket3 (u0 := 0.00000404078756) (u1 := 0.24999576909584) (j := (14:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPtT85 : errPtBracket 3.8729828 3.8729839 (-0.00494009) 0.00896527 :=
  errPiece_crude_asymp (by norm_num) (by norm_num) (by norm_num)
    (by norm_num) (by norm_num)

theorem errPtT86 : errPtBracket 3.8729839 3.9051243 (-0.00549811) 0.0026216 :=
  errPiece_sharp_asymp
    (C0 := 0.000025933) (C1 := 1) (S0 := 0.000026952) (S1 := 1.000003542)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.00000428965921) (u1 := 0.24999579845049) (j := (15:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPtT87 : errPtBracket 3.9051243 3.9051254 (-0.00487026) 0.00879989 :=
  errPiece_crude_asymp (by norm_num) (by norm_num) (by norm_num)
    (by norm_num) (by norm_num)

theorem errPtT88 : errPtBracket 3.9051254 3.9370034 0.00131929 0.00928722 :=
  errPiece_sharp_asymp
    (C0 := (-1.000003542)) (C1 := (-0.000027581)) (S0 := 0.000026102) (S1 := 1)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.00000438972516) (u1 := 0.24999577161156) (j := (15:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPtT89 : errPtBracket 3.9370034 3.9370045 (-0.00480284) 0.00864006 :=
  errPiece_crude_asymp (by norm_num) (by norm_num) (by norm_num)
    (by norm_num) (by norm_num)

theorem errPtT90 : errPtBracket 3.9370045 3.9686264 0.00136469 0.00917942 :=
  errPiece_sharp_asymp
    (C0 := (-1)) (C1 := (-0.000027791)) (S0 := (-1.000003542)) (S1 := (-0.000027853))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket2 (u0 := 0.00000443302025) (u1 := 0.24999550277696) (j := (15:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPtT91 : errPtBracket 3.9686264 3.9686275 (-0.00473768) 0.00848551 :=
  errPiece_crude_asymp (by norm_num) (by norm_num) (by norm_num)
    (by norm_num) (by norm_num)

theorem errPtT92 : errPtBracket 3.9686275 3.9999995 (-0.00516827) 0.00249248 :=
  errPiece_sharp_asymp
    (C0 := 0.000026601) (C1 := 1.000003542) (S0 := (-1)) (S1 := (-0.000024667))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket3 (u0 := 0.00000423375625) (u1 := 0.24999600000025) (j := (15:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPtT93 : errPtBracket 3.9999995 4.0000005 (-0.00467466) 0.008336 :=
  errPiece_crude_asymp (by norm_num) (by norm_num) (by norm_num)
    (by norm_num) (by norm_num)

theorem errPtT94 : errPtBracket 4.0000005 4.0311283 (-0.00515345) 0.00236547 :=
  errPiece_sharp_asymp
    (C0 := 0.000028619) (C1 := 1) (S0 := 0.000025132) (S1 := 1.000003542)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.00000400000025) (u1 := 0.24999537106089) (j := (16:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPtT95 : errPtBracket 4.0311283 4.0311294 (-0.00461365) 0.00819131 :=
  errPiece_crude_asymp (by norm_num) (by norm_num) (by norm_num)
    (by norm_num) (by norm_num)

theorem errPtT96 : errPtBracket 4.0311294 4.0620187 0.00122808 0.00861641 :=
  errPiece_sharp_asymp
    (C0 := (-1.000003542)) (C1 := (-0.000026637)) (S0 := 0.000025175) (S1 := 1)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.00000423954436) (u1 := 0.24999591914969) (j := (16:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPtT97 : errPtBracket 4.0620187 4.0620198 (-0.00455456) 0.0080512 :=
  errPiece_crude_asymp (by norm_num) (by norm_num) (by norm_num)
    (by norm_num) (by norm_num)

theorem errPtT98 : errPtBracket 4.0620198 4.0926758 0.00126681 0.00852317 :=
  errPiece_sharp_asymp
    (C0 := (-1)) (C1 := (-0.000029669)) (S0 := (-1.000003542)) (S1 := (-0.000030508))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket2 (u0 := 0.00000485559204) (u1 := 0.24999520390564) (j := (16:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPtT99 : errPtBracket 4.0926758 4.0926769 (-0.00449727) 0.00791548 :=
  errPiece_crude_asymp (by norm_num) (by norm_num) (by norm_num)
    (by norm_num) (by norm_num)

theorem errPtT100 : errPtBracket 4.0926769 4.1231051 (-0.00486752) 0.00225611 :=
  errPiece_sharp_asymp
    (C0 := 0.000026438) (C1 := 1.000003542) (S0 := (-1)) (S1 := (-0.000026768))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket3 (u0 := 0.00000420779361) (u1 := 0.24999566564601) (j := (16:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPtT101 : errPtBracket 4.1231051 4.1231062 (-0.0044417) 0.00778395 :=
  errPiece_crude_asymp (by norm_num) (by norm_num) (by norm_num)
    (by norm_num) (by norm_num)

theorem errPtT102 : errPtBracket 4.1231062 4.1533114 (-0.0048555) 0.00214531 :=
  errPiece_sharp_asymp
    (C0 := 0.000027272) (C1 := 1) (S0 := 0.00002976) (S1 := 1.000003542)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.00000473647844) (u1 := 0.24999558536996) (j := (17:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPtT103 : errPtBracket 4.1533114 4.1533125 (-0.00438776) 0.00765644 :=
  errPiece_crude_asymp (by norm_num) (by norm_num) (by norm_num)
    (by norm_num) (by norm_num)

theorem errPtT104 : errPtBracket 4.1533125 4.1832996 0.00114337 0.00803058 :=
  errPiece_sharp_asymp
    (C0 := (-1.000003542)) (C1 := (-0.000029673)) (S0 := 0.000027536) (S1 := 1)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.00000472265625) (u1 := 0.24999554336016) (j := (17:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPtT105 : errPtBracket 4.1832996 4.1833007 (-0.00433536) 0.00753276 :=
  errPiece_crude_asymp (by norm_num) (by norm_num) (by norm_num)
    (by norm_num) (by norm_num)

theorem errPtT106 : errPtBracket 4.1833007 4.2130743 0.00117691 0.0079493 :=
  errPiece_sharp_asymp
    (C0 := (-1)) (C1 := (-0.00003059)) (S0 := (-1.000003542)) (S1 := (-0.000029823))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket2 (u0 := 0.00000474662049) (u1 := 0.24999505732049) (j := (17:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPtT107 : errPtBracket 4.2130743 4.2130754 (-0.00428444) 0.00741275 :=
  errPiece_crude_asymp (by norm_num) (by norm_num) (by norm_num)
    (by norm_num) (by norm_num)

theorem errPtT108 : errPtBracket 4.2130754 4.2426401 (-0.00460475) 0.00205205 :=
  errPiece_sharp_asymp
    (C0 := 0.000027181) (C1 := 1.000003542) (S0 := (-1)) (S1 := (-0.000030836))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket3 (u0 := 0.00000432608516) (u1 := 0.24999501812801) (j := (17:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPtT109 : errPtBracket 4.2426401 4.2426412 (-0.00423492) 0.00729627 :=
  errPiece_crude_asymp (by norm_num) (by norm_num) (by norm_num)
    (by norm_num) (by norm_num)

theorem errPtT110 : errPtBracket 4.2426412 4.2720013 (-0.00459474) 0.00195466 :=
  errPiece_sharp_asymp
    (C0 := 0.000030276) (C1 := 1) (S0 := 0.000027344) (S1 := 1.000003542)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.00000435193744) (u1 := 0.24999510720169) (j := (18:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPtT111 : errPtBracket 4.2720013 4.2720024 (-0.00418673) 0.00718316 :=
  errPiece_crude_asymp (by norm_num) (by norm_num) (by norm_num)
    (by norm_num) (by norm_num)

theorem errPtT112 : errPtBracket 4.2720024 4.3011621 0.00106533 0.00751504 :=
  errPiece_sharp_asymp
    (C0 := (-1.000003542)) (C1 := (-0.000028309)) (S0 := 0.000028371) (S1 := 1)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.00000450560576) (u1 := 0.24999541047641) (j := (18:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPtT113 : errPtBracket 4.3011621 4.3011632 (-0.00413982) 0.00707328 :=
  errPiece_crude_asymp (by norm_num) (by norm_num) (by norm_num)
    (by norm_num) (by norm_num)

theorem errPtT114 : errPtBracket 4.3011632 4.3301265 0.00109478 0.00744367 :=
  errPiece_sharp_asymp
    (C0 := (-1)) (C1 := (-0.000027771)) (S0 := (-1.000003542)) (S1 := (-0.000030618))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket2 (u0 := 0.00000487303424) (u1 := 0.24999550600225) (j := (18:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPtT115 : errPtBracket 4.3301265 4.3301276 (-0.00409413) 0.00696652 :=
  errPiece_crude_asymp (by norm_num) (by norm_num) (by norm_num)
    (by norm_num) (by norm_num)

theorem errPtT116 : errPtBracket 4.3301276 4.3588984 (-0.00437265) 0.00187465 :=
  errPiece_sharp_asymp
    (C0 := 0.000031618) (C1 := 1.000003542) (S0 := (-1)) (S1 := (-0.000029307))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket3 (u0 := 0.00000503228176) (u1 := 0.24999526152256) (j := (18:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPtT117 : errPtBracket 4.3588984 4.3588995 (-0.00404961) 0.00686273 :=
  errPiece_crude_asymp (by norm_num) (by norm_num) (by norm_num)
    (by norm_num) (by norm_num)

theorem errPtT118 : errPtBracket 4.3588995 4.3874816 (-0.00436413) 0.00178849 :=
  errPiece_sharp_asymp
    (C0 := 0.000032267) (C1 := 1) (S0 := 0.00003048) (S1 := 1.000003542)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.00000485110025) (u1 := 0.24999479033856) (j := (19:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPtT119 : errPtBracket 4.3874816 4.3874827 (-0.00400621) 0.0067618 :=
  errPiece_crude_asymp (by norm_num) (by norm_num) (by norm_num)
    (by norm_num) (by norm_num)

theorem errPtT120 : errPtBracket 4.3874827 4.4158799 0.0009938 0.00705822 :=
  errPiece_sharp_asymp
    (C0 := (-1.000003542)) (C1 := (-0.000027914)) (S0 := 0.00002912) (S1 := 1)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.00000444279929) (u1 := 0.24999529122401) (j := (19:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPtT121 : errPtBracket 4.4158799 4.415881 (-0.00396387) 0.00666362 :=
  errPiece_crude_asymp (by norm_num) (by norm_num) (by norm_num)
    (by norm_num) (by norm_num)

theorem errPtT122 : errPtBracket 4.415881 4.4440967 0.00101996 0.00699515 :=
  errPiece_sharp_asymp
    (C0 := (-1)) (C1 := (-0.000027941)) (S0 := (-1.000003542)) (S1 := (-0.000031454))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket2 (u0 := 0.000005006161) (u1 := 0.24999547895089) (j := (19:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPtT123 : errPtBracket 4.4440967 4.4440978 (-0.00392256) 0.00656809 :=
  errPiece_crude_asymp (by norm_num) (by norm_num) (by norm_num)
    (by norm_num) (by norm_num)

theorem errPtT124 : errPtBracket 4.4440978 4.4721354 (-0.00416575) 0.00171948 :=
  errPiece_sharp_asymp
    (C0 := 0.000033024) (C1 := 1.000003542) (S0 := (-1)) (S1 := (-0.000030724))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket3 (u0 := 0.00000525596484) (u1 := 0.24999503593316) (j := (19:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPtT125 : errPtBracket 4.4721354 4.4721365 (-0.00388223) 0.0064751 :=
  errPiece_crude_asymp (by norm_num) (by norm_num) (by norm_num)
    (by norm_num) (by norm_num)

end ConnesConsani.WeilPositivity
