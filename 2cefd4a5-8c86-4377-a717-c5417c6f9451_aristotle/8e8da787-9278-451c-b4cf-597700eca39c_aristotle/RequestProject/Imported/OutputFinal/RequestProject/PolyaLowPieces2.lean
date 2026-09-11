/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.
-/
import RequestProject.Imported.OutputFinal.RequestProject.PolyaOscLin

/-!
# Pointwise brackets on the pieces of the extended partition (part 2)

The `q`-range `[2.094, 5]` is cut at the quadrant boundaries of `2πq²`, so that
the oscillating part of the Si-asymptotics is resolved and the bracket is
narrow; the short pieces straddling a boundary use the crude bracket.
-/

set_option maxHeartbeats 4000000

noncomputable section

open MeasureTheory Set Real

namespace ConnesConsani.WeilPositivity

theorem errPtT42 : errPtBracket 3.0822076 3.1224984 0.00193877 0.01643183 :=
  errPiece_sharp_asymp
    (C0 := (-1)) (C1 := (-0.000023046)) (S0 := (-1.000003542)) (S1 := (-0.000023181))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket2 (u0 := 0.00000368949776) (u1 := 0.24999625800256) (j := (9:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPtT43 : errPtBracket 3.1224984 3.1224995 (-0.00744786) 0.01443246 :=
  errPiece_crude_asymp (by norm_num) (by norm_num) (by norm_num)
    (by norm_num) (by norm_num)

theorem errPtT44 : errPtBracket 3.1224995 3.1622771 (-0.00877179) 0.00519649 :=
  errPiece_sharp_asymp
    (C0 := 0.00001965) (C1 := 1.000003542) (S0 := (-1)) (S1 := (-0.000021794))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket3 (u0 := 0.00000312750025) (u1 := 0.24999645718441) (j := (9:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPtT45 : errPtBracket 3.1622771 3.1622782 (-0.00724813) 0.01404429 :=
  errPiece_crude_asymp (by norm_num) (by norm_num) (by norm_num)
    (by norm_num) (by norm_num)

theorem errPtT46 : errPtBracket 3.1622782 3.2015616 (-0.00866808) 0.00483795 :=
  errPiece_sharp_asymp
    (C0 := 0.000020403) (C1 := 1) (S0 := 0.000021452) (S1 := 1.000003542)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.00000341419524) (u1 := 0.24999667859456) (j := (10:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPtT47 : errPtBracket 3.2015616 3.2015627 (-0.00706192) 0.01367418 :=
  errPiece_crude_asymp (by norm_num) (by norm_num) (by norm_num)
    (by norm_num) (by norm_num)

theorem errPtT48 : errPtBracket 3.2015627 3.2403698 0.00175222 0.01485011 :=
  errPiece_sharp_asymp
    (C0 := (-1.000003542)) (C1 := (-0.000023386)) (S0 := 0.000021898) (S1 := 1)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.00000372203129) (u1 := 0.24999644075204) (j := (10:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPtT49 : errPtBracket 3.2403698 3.2403709 (-0.00688781) 0.01332102 :=
  errPiece_crude_asymp (by norm_num) (by norm_num) (by norm_num)
    (by norm_num) (by norm_num)

theorem errPtT50 : errPtBracket 3.2403709 3.2787187 0.00189781 0.01458851 :=
  errPiece_sharp_asymp
    (C0 := (-1)) (C1 := (-0.000022696)) (S0 := (-1.000003542)) (S1 := (-0.000022428))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket2 (u0 := 0.00000356956681) (u1 := 0.24999631372969) (j := (10:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPtT51 : errPtBracket 3.2787187 3.2787198 (-0.00672461) 0.01298376 :=
  errPiece_crude_asymp (by norm_num) (by norm_num) (by norm_num)
    (by norm_num) (by norm_num)

theorem errPtT52 : errPtBracket 3.2787198 3.3166242 (-0.00778216) 0.00450448 :=
  errPiece_sharp_asymp
    (C0 := 0.00002216) (C1 := 1.000003542) (S0 := (-1)) (S1 := (-0.000024139))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket3 (u0 := 0.00000352691204) (u1 := 0.24999608402564) (j := (10:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPtT53 : errPtBracket 3.3166242 3.3166253 (-0.00657124) 0.01266143 :=
  errPiece_crude_asymp (by norm_num) (by norm_num) (by norm_num)
    (by norm_num) (by norm_num)

theorem errPtT54 : errPtBracket 3.3166253 3.3541014 (-0.00771396) 0.00421296 :=
  errPiece_sharp_asymp
    (C0 := 0.000023401) (C1 := 1) (S0 := 0.00002124) (S1 := 1.000003542)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.00000338060009) (u1 := 0.24999620148196) (j := (11:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPtT55 : errPtBracket 3.3541014 3.3541025 (-0.00642678) 0.01235314 :=
  errPiece_crude_asymp (by norm_num) (by norm_num) (by norm_num)
    (by norm_num) (by norm_num)

theorem errPtT56 : errPtBracket 3.3541025 3.3911644 0.00169902 0.01330517 :=
  errPiece_sharp_asymp
    (C0 := (-1.000003542)) (C1 := (-0.000022496)) (S0 := 0.000024743) (S1 := 1)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.00000358050625) (u1 := 0.24999598782736) (j := (11:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPtT57 : errPtBracket 3.3911644 3.3911655 (-0.00629041) 0.01205806 :=
  errPiece_crude_asymp (by norm_num) (by norm_num) (by norm_num)
    (by norm_num) (by norm_num)

theorem errPtT58 : errPtBracket 3.3911655 3.4278268 0.00180706 0.01309185 :=
  errPiece_sharp_asymp
    (C0 := (-1)) (C1 := (-0.00002108)) (S0 := (-1.000003542)) (S1 := (-0.000021666))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket2 (u0 := 0.00000344839025) (u1 := 0.24999657079824) (j := (11:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPtT59 : errPtBracket 3.4278268 3.4278279 (-0.00616141) 0.01177542 :=
  errPiece_crude_asymp (by norm_num) (by norm_num) (by norm_num)
    (by norm_num) (by norm_num)

theorem errPtT60 : errPtBracket 3.4278279 3.4641011 (-0.00702242) 0.00394204 :=
  errPiece_sharp_asymp
    (C0 := 0.000025836) (C1 := 1.000003542) (S0 := (-1)) (S1 := (-0.000021959))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket3 (u0 := 0.00000411201841) (u1 := 0.24999643102121) (j := (11:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPtT61 : errPtBracket 3.4641011 3.4641022 (-0.00603914) 0.0115045 :=
  errPiece_crude_asymp (by norm_num) (by norm_num) (by norm_num)
    (by norm_num) (by norm_num)

theorem errPtT62 : errPtBracket 3.4641022 3.4999995 (-0.00697567) 0.00370116 :=
  errPiece_sharp_asymp
    (C0 := 0.000021525) (C1 := 1) (S0 := 0.000025459) (S1 := 1.000003542)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.00000405204484) (u1 := 0.24999650000025) (j := (12:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPtT63 : errPtBracket 3.4999995 3.5000005 (-0.00592304) 0.01124463 :=
  errPiece_crude_asymp (by norm_num) (by norm_num) (by norm_num)
    (by norm_num) (by norm_num)

theorem errPtT64 : errPtBracket 3.5000005 3.5355334 0.00161352 0.01203162 :=
  errPiece_sharp_asymp
    (C0 := (-1.000003542)) (C1 := (-0.000021991)) (S0 := 0.000022012) (S1 := 1)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.00000350000025) (u1 := 0.24999642251556) (j := (12:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPtT65 : errPtBracket 3.5355334 3.5355345 (-0.00581261) 0.0109952 :=
  errPiece_crude_asymp (by norm_num) (by norm_num) (by norm_num)
    (by norm_num) (by norm_num)

theorem errPtT66 : errPtBracket 3.5355345 3.5707137 0.00169684 0.01185497 :=
  errPiece_sharp_asymp
    (C0 := (-1)) (C1 := (-0.00002261)) (S0 := (-1.000003542)) (S1 := (-0.000026393))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket2 (u0 := 0.00000420069025) (u1 := 0.24999632736769) (j := (12:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPtT67 : errPtBracket 3.5707137 3.5707148 (-0.00570739) 0.01075563 :=
  errPiece_crude_asymp (by norm_num) (by norm_num) (by norm_num)
    (by norm_num) (by norm_num)

theorem errPtT68 : errPtBracket 3.5707148 3.6055507 (-0.0064193) 0.00347892 :=
  errPiece_sharp_asymp
    (C0 := 0.000026282) (C1 := 1.000003542) (S0 := (-1)) (S1 := (-0.000025608))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket3 (u0 := 0.00000418293904) (u1 := 0.24999585027049) (j := (12:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPtT69 : errPtBracket 3.6055507 3.6055518 (-0.00560698) 0.01052538 :=
  errPiece_crude_asymp (by norm_num) (by norm_num) (by norm_num)
    (by norm_num) (by norm_num)

theorem errPtT70 : errPtBracket 3.6055518 3.6400544 (-0.00638598) 0.00327704 :=
  errPiece_sharp_asymp
    (C0 := 0.000024447) (C1 := 1) (S0 := 0.000023766) (S1 := 1.000003542)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.00000378248324) (u1 := 0.24999603495936) (j := (13:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPtT71 : errPtBracket 3.6400544 3.6400555 (-0.00551102) 0.01030395 :=
  errPiece_crude_asymp (by norm_num) (by norm_num) (by norm_num)
    (by norm_num) (by norm_num)

theorem errPtT72 : errPtBracket 3.6400555 3.6742341 0.00151579 0.01096572 :=
  errPiece_sharp_asymp
    (C0 := (-1.000003542)) (C1 := (-0.000025403)) (S0 := 0.000023274) (S1 := 1)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.00000404308025) (u1 := 0.24999622160281) (j := (13:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPtT73 : errPtBracket 3.6742341 3.6742352 (-0.00541918) 0.01009088 :=
  errPiece_crude_asymp (by norm_num) (by norm_num) (by norm_num)
    (by norm_num) (by norm_num)

theorem errPtT74 : errPtBracket 3.6742352 3.7080987 0.00158212 0.01081752 :=
  errPiece_sharp_asymp
    (C0 := (-1)) (C1 := (-0.000024862)) (S0 := (-1.000003542)) (S1 := (-0.000027048))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket2 (u0 := 0.00000430491904) (u1 := 0.24999596894169) (j := (13:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPtT75 : errPtBracket 3.7080987 3.7080998 (-0.00533117) 0.00988572 :=
  errPiece_crude_asymp (by norm_num) (by norm_num) (by norm_num)
    (by norm_num) (by norm_num)

theorem errPtT76 : errPtBracket 3.7080998 3.7416568 (-0.00592729) 0.00309312 :=
  errPiece_sharp_asymp
    (C0 := 0.000025929) (C1 := 1.000003542) (S0 := (-1)) (S1 := (-0.000027124))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket3 (u0 := 0.00000412676004) (u1 := 0.24999560898624) (j := (13:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPtT77 : errPtBracket 3.7416568 3.7416579 (-0.00524673) 0.00968807 :=
  errPiece_crude_asymp (by norm_num) (by norm_num) (by norm_num)
    (by norm_num) (by norm_num)

theorem errPtT78 : errPtBracket 3.7416579 3.7749167 (-0.00590268) 0.00292189 :=
  errPiece_sharp_asymp
    (C0 := 0.000024089) (C1 := 1) (S0 := 0.000024131) (S1 := 1.000003542)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.00000384063241) (u1 := 0.24999609193889) (j := (14:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPtT79 : errPtBracket 3.7749167 3.7749178 (-0.00516561) 0.00949755 :=
  errPiece_crude_asymp (by norm_num) (by norm_num) (by norm_num)
    (by norm_num) (by norm_num)

theorem errPtT80 : errPtBracket 3.7749178 3.807886 0.00141601 0.01006202 :=
  errPiece_sharp_asymp
    (C0 := (-1.000003542)) (C1 := (-0.000027625)) (S0 := 0.000025993) (S1 := 1)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.00000439675684) (u1 := 0.249995788996) (j := (14:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPtT81 : errPtBracket 3.807886 3.8078871 (-0.00508759) 0.0093138 :=
  errPiece_crude_asymp (by norm_num) (by norm_num) (by norm_num)
    (by norm_num) (by norm_num)

theorem errPtT82 : errPtBracket 3.8078871 3.8405723 0.00147026 0.00993626 :=
  errPiece_sharp_asymp
    (C0 := (-1)) (C1 := (-0.000027233)) (S0 := (-1.000003542)) (S1 := (-0.000026177))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket2 (u0 := 0.00000416634641) (u1 := 0.24999559152729) (j := (14:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPtT83 : errPtBracket 3.8405723 3.8405734 (-0.00501248) 0.00913648 :=
  errPiece_crude_asymp (by norm_num) (by norm_num) (by norm_num)
    (by norm_num) (by norm_num)

end ConnesConsani.WeilPositivity
