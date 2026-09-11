/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.
-/
import RequestProject.Imported.OutputFinal.RequestProject.PolyaOscLin

/-!
# Pointwise brackets on the pieces of the extended partition (part 1)

The `q`-range `[2.094, 5]` is cut at the quadrant boundaries of `2πq²`, so that
the oscillating part of the Si-asymptotics is resolved and the bracket is
narrow; the short pieces straddling a boundary use the crude bracket.
-/

set_option maxHeartbeats 4000000

noncomputable section

open MeasureTheory Set Real

namespace ConnesConsani.WeilPositivity

theorem errPtT0 : errPtBracket 2.094 2.1213198 0.01634089 0.03477555 :=
  errPiece_sharp_asymp
    (C0 := (-1.000003543)) (C1 := (-0.749429227)) (S0 := 0.000014024) (S1 := 0.662084514)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.134836) (u1 := 0.24999769387204) (j := (4:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPtT1 : errPtBracket 2.1213198 2.1213209 (-0.02444891) 0.03004311 :=
  errPiece_crude_asymp (by norm_num) (by norm_num) (by norm_num)
    (by norm_num) (by norm_num)

theorem errPtT2 : errPtBracket 2.1213209 2.1794489 (-0.0066944) 0.04027702 :=
  errPiece_sharp_asymp
    (C0 := (-1)) (C1 := (-0.000015194)) (S0 := (-1.000003543)) (S1 := (-0.000014833))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket2 (u0 := 0.00000236077681) (u1 := 0.24999750771121) (j := (4:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPtT3 : errPtBracket 2.1794489 2.17945 (-0.02191697) 0.02878939 :=
  errPiece_crude_asymp (by norm_num) (by norm_num) (by norm_num)
    (by norm_num) (by norm_num)

theorem errPtT4 : errPtBracket 2.17945 2.2360674 (-0.02903058) 0.01318421 :=
  errPiece_sharp_asymp
    (C0 := 0.000014467) (C1 := 1.000003543) (S0 := (-1)) (S1 := (-0.000015761))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket3 (u0 := 0.0000023025) (u1 := 0.24999741734276) (j := (4:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPtT5 : errPtBracket 2.2360674 2.2360685 (-0.0198288) 0.02760956 :=
  errPiece_crude_asymp (by norm_num) (by norm_num) (by norm_num)
    (by norm_num) (by norm_num)

theorem errPtT6 : errPtBracket 2.2360685 2.2912873 (-0.02692149) 0.01158897 :=
  errPiece_sharp_asymp
    (C0 := 0.000015298) (C1 := 1) (S0 := 0.000014681) (S1 := 1.000003543)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.00000233669225) (u1 := 0.24999749114129) (j := (5:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPtT7 : errPtBracket 2.2912873 2.2912884 (-0.01808818) 0.02649843 :=
  errPiece_crude_asymp (by norm_num) (by norm_num) (by norm_num)
    (by norm_num) (by norm_num)

theorem errPtT8 : errPtBracket 2.2912884 2.3452073 (-0.00301801) 0.03256511 :=
  errPiece_sharp_asymp
    (C0 := (-1.000003543)) (C1 := (-0.000015908)) (S0 := 0.000016625) (S1 := 1)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.00000253197456) (u1 := 0.24999727997329) (j := (5:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPtT9 : errPtBracket 2.3452073 2.3452084 (-0.01662296) 0.02545179 :=
  errPiece_crude_asymp (by norm_num) (by norm_num) (by norm_num)
    (by norm_num) (by norm_num)

theorem errPtT10 : errPtBracket 2.3452084 2.3979152 (-0.00140188) 0.03147096 :=
  errPiece_sharp_asymp
    (C0 := (-1)) (C1 := (-0.000016459)) (S0 := (-1.000003543)) (S1 := (-0.000015327))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket2 (u0 := 0.00000243943056) (u1 := 0.24999730639104) (j := (5:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPtT11 : errPtBracket 2.3979152 2.3979163 (-0.01537828) 0.02446582 :=
  errPiece_crude_asymp (by norm_num) (by norm_num) (by norm_num)
    (by norm_num) (by norm_num)

theorem errPtT12 : errPtBracket 2.3979163 2.4494892 (-0.01988005) 0.01049062 :=
  errPiece_sharp_asymp
    (C0 := 0.000016221) (C1 := 1.000003543) (S0 := (-1)) (S1 := (-0.000016242))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket3 (u0 := 0.00000258180569) (u1 := 0.24999734091664) (j := (5:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPtT13 : errPtBracket 2.4494892 2.4494903 (-0.01431197) 0.02353691 :=
  errPiece_crude_asymp (by norm_num) (by norm_num) (by norm_num)
    (by norm_num) (by norm_num)

theorem errPtT14 : errPtBracket 2.4494903 2.4999995 (-0.01890865) 0.00942776 :=
  errPiece_sharp_asymp
    (C0 := 0.000015242) (C1 := 1) (S0 := 0.000017151) (S1 := 1.000003543)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.00000272979409) (u1 := 0.24999750000025) (j := (6:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPtT15 : errPtBracket 2.4999995 2.5000005 (-0.01339124) 0.02266158 :=
  errPiece_crude_asymp (by norm_num) (by norm_num) (by norm_num)
    (by norm_num) (by norm_num)

theorem errPtT16 : errPtBracket 2.5000005 2.5495092 (-0.00014045) 0.02652667 :=
  errPiece_sharp_asymp
    (C0 := (-1.000003542)) (C1 := (-0.000015707)) (S0 := 0.000017373) (S1 := 1)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.00000250000025) (u1 := 0.24999716088464) (j := (6:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPtT17 : errPtBracket 2.5495092 2.5495103 (-0.01259036) 0.02183651 :=
  errPiece_crude_asymp (by norm_num) (by norm_num) (by norm_num)
    (by norm_num) (by norm_num)

theorem errPtT18 : errPtBracket 2.5495103 2.5980757 0.00070178 0.02577695 :=
  errPiece_sharp_asymp
    (C0 := (-1)) (C1 := (-0.000016229)) (S0 := (-1.000003543)) (S1 := (-0.000017403))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket2 (u0 := 0.00000276980609) (u1 := 0.24999734293049) (j := (6:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPtT19 : errPtBracket 2.5980757 2.5980768 (-0.01188889) 0.02105843 :=
  errPiece_crude_asymp (by norm_num) (by norm_num) (by norm_num)
    (by norm_num) (by norm_num)

theorem errPtT20 : errPtBracket 2.5980768 2.6457508 (-0.01497986) 0.00858432 :=
  errPiece_sharp_asymp
    (C0 := 0.000019218) (C1 := 1.000003543) (S0 := (-1)) (S1 := (-0.000016526))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket3 (u0 := 0.00000305869824) (u1 := 0.24999729570064) (j := (6:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPtT21 : errPtBracket 2.6457508 2.6457519 (-0.01127054) 0.02032429 :=
  errPiece_crude_asymp (by norm_num) (by norm_num) (by norm_num)
    (by norm_num) (by norm_num)

theorem errPtT22 : errPtBracket 2.6457519 2.6925819 (-0.01448098) 0.00781838 :=
  errPiece_sharp_asymp
    (C0 := 0.000016573) (C1 := 1) (S0 := 0.00001958) (S1 := 1.000003543)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.00000311635361) (u1 := 0.24999728820761) (j := (7:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPtT23 : errPtBracket 2.6925819 2.692583 (-0.01072214) 0.01963118 :=
  errPiece_crude_asymp (by norm_num) (by norm_num) (by norm_num)
    (by norm_num) (by norm_num)

theorem errPtT24 : errPtBracket 2.692583 2.7386122 0.00106647 0.02230021 :=
  errPiece_sharp_asymp
    (C0 := (-1.000003542)) (C1 := (-0.00002018)) (S0 := 0.000019753) (S1 := 1)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.000003211889) (u1 := 0.24999678198884) (j := (7:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPtT25 : errPtBracket 2.7386122 2.7386133 (-0.010233) 0.01897633 :=
  errPiece_crude_asymp (by norm_num) (by norm_num) (by norm_num)
    (by norm_num) (by norm_num)

theorem errPtT26 : errPtBracket 2.7386133 2.7838816 0.00155374 0.02175207 :=
  errPiece_sharp_asymp
    (C0 := (-1)) (C1 := (-0.000019874)) (S0 := (-1.000003542)) (S1 := (-0.000017636))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket2 (u0 := 0.00000280693689) (u1 := 0.24999676281856) (j := (7:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPtT27 : errPtBracket 2.7838816 2.7838827 (-0.00979439) 0.01835717 :=
  errPiece_crude_asymp (by norm_num) (by norm_num) (by norm_num)
    (by norm_num) (by norm_num)

theorem errPtT28 : errPtBracket 2.7838827 2.8284266 (-0.01203893) 0.00715885 :=
  errPiece_sharp_asymp
    (C0 := 0.000018141) (C1 := 1.000003542) (S0 := (-1)) (S1 := (-0.000018185))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket3 (u0 := 0.00000288735929) (u1 := 0.24999703158756) (j := (7:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPtT29 : errPtBracket 2.8284266 2.8284277 (-0.00939909) 0.0177713 :=
  errPiece_crude_asymp (by norm_num) (by norm_num) (by norm_num)
    (by norm_num) (by norm_num)

theorem errPtT30 : errPtBracket 2.8284277 2.8722808 (-0.01176092) 0.00658113 :=
  errPiece_sharp_asymp
    (C0 := 0.000018421) (C1 := 1) (S0 := 0.000020446) (S1 := 1.000003542)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.00000325412729) (u1 := 0.24999699404864) (j := (8:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPtT31 : errPtBracket 2.8722808 2.8722819 (-0.00904115) 0.01721647 :=
  errPiece_crude_asymp (by norm_num) (by norm_num) (by norm_num)
    (by norm_num) (by norm_num)

theorem errPtT32 : errPtBracket 2.8722819 2.9154754 0.00156188 0.01916882 :=
  errPiece_sharp_asymp
    (C0 := (-1.000003542)) (C1 := (-0.000020816)) (S0 := 0.00001959) (S1 := 1)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.00000331306761) (u1 := 0.24999680800516) (j := (8:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPtT33 : errPtBracket 2.9154754 2.9154765 (-0.00871558) 0.01669059 :=
  errPiece_crude_asymp (by norm_num) (by norm_num) (by norm_num)
    (by norm_num) (by norm_num)

theorem errPtT34 : errPtBracket 2.9154765 2.9580393 0.0018679 0.01875166 :=
  errPiece_sharp_asymp
    (C0 := (-1)) (C1 := (-0.000021523)) (S0 := (-1.000003542)) (S1 := (-0.000020244))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket2 (u0 := 0.00000322205225) (u1 := 0.24999650034449) (j := (8:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPtT35 : errPtBracket 2.9580393 2.9580404 (-0.00841821) 0.01619172 :=
  errPiece_crude_asymp (by norm_num) (by norm_num) (by norm_num)
    (by norm_num) (by norm_num)

theorem errPtT36 : errPtBracket 2.9580404 2.9999995 (-0.01011576) 0.00606068 :=
  errPiece_sharp_asymp
    (C0 := 0.0000189) (C1 := 1.000003542) (S0 := (-1)) (S1 := (-0.000018384))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket3 (u0 := 0.00000300803216) (u1 := 0.24999700000025) (j := (8:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPtT37 : errPtBracket 2.9999995 3.0000005 (-0.00814552) 0.01571807 :=
  errPiece_crude_asymp (by norm_num) (by norm_num) (by norm_num)
    (by norm_num) (by norm_num)

theorem errPtT38 : errPtBracket 3.0000005 3.0413807 (-0.00995047) 0.00561101 :=
  errPiece_sharp_asymp
    (C0 := 0.000021134) (C1 := 1) (S0 := 0.000018849) (S1 := 1.000003542)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.00000300000025) (u1 := 0.24999656233249) (j := (9:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPtT39 : errPtBracket 3.0413807 3.0413818 (-0.00789453) 0.01526799 :=
  errPiece_crude_asymp (by norm_num) (by norm_num) (by norm_num)
    (by norm_num) (by norm_num)

theorem errPtT40 : errPtBracket 3.0413818 3.0822065 0.00173336 0.01675853 :=
  errPiece_sharp_asymp
    (C0 := (-1.000003542)) (C1 := (-0.000020441)) (S0 := 0.000018958) (S1 := 1)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.00000325337124) (u1 := 0.24999690864225) (j := (9:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPtT41 : errPtBracket 3.0822065 3.0822076 (-0.0076627) 0.01483992 :=
  errPiece_crude_asymp (by norm_num) (by norm_num) (by norm_num)
    (by norm_num) (by norm_num)

end ConnesConsani.WeilPositivity
