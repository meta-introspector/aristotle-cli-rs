/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.
-/
import RequestProject.Imported.OutputFinal.RequestProject.PolyaOscLin

/-!
# Sharpened pointwise brackets on the pieces of the partition (part 5)
-/

set_option maxHeartbeats 1000000

noncomputable section

open MeasureTheory Set Real

namespace ConnesConsani.WeilPositivity

theorem errPt280 : errPtBracket 1.1715 1.172 0.37214886 0.37995543 :=
  errPiece_sharp_taylor
    (C0 := (-0.700787758)) (C1 := (-0.695516751)) (S0 := 0.713369834) (S1 := 0.718509901)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.12241225) (u1 := 0.123584) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt281 : errPtBracket 1.172 1.1725 0.37233206 0.38013928 :=
  errPiece_sharp_taylor
    (C0 := (-0.706023002)) (C1 := (-0.700787755)) (S0 := 0.708188903) (S1 := 0.713369858)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.123584) (u1 := 0.12475625) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt282 : errPtBracket 1.1725 1.173 0.37249874 0.38030658 :=
  errPiece_sharp_taylor
    (C0 := (-0.711222153)) (C1 := (-0.706022998)) (S0 := 0.702967319) (S1 := 0.708188929)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.12475625) (u1 := 0.125929) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt283 : errPtBracket 1.173 1.1735 0.37264897 0.38045738 :=
  errPiece_sharp_taylor
    (C0 := (-0.716384878)) (C1 := (-0.711222149)) (S0 := 0.697705317) (S1 := 0.702967348)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.125929) (u1 := 0.12710225) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt284 : errPtBracket 1.1735 1.174 0.3727828 0.38059172 :=
  errPiece_sharp_taylor
    (C0 := (-0.721510849)) (C1 := (-0.716384874)) (S0 := 0.692403132) (S1 := 0.697705348)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.12710225) (u1 := 0.128276) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt285 : errPtBracket 1.174 1.1745 0.37290028 0.38070966 :=
  errPiece_sharp_taylor
    (C0 := (-0.726599737)) (C1 := (-0.721510845)) (S0 := 0.687061006) (S1 := 0.692403166)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.128276) (u1 := 0.12945025) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt286 : errPtBracket 1.1745 1.175 0.37300145 0.38081125 :=
  errPiece_sharp_taylor
    (C0 := (-0.731651214)) (C1 := (-0.726599732)) (S0 := 0.681679181) (S1 := 0.687061043)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.12945025) (u1 := 0.130625) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt287 : errPtBracket 1.175 1.1755 0.37308639 0.38089654 :=
  errPiece_sharp_taylor
    (C0 := (-0.736664953)) (C1 := (-0.731651209)) (S0 := 0.676257903) (S1 := 0.681679221)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.130625) (u1 := 0.13180025) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt288 : errPtBracket 1.1755 1.176 0.37315513 0.38096559 :=
  errPiece_sharp_taylor
    (C0 := (-0.741640632)) (C1 := (-0.736664948)) (S0 := 0.67079742) (S1 := 0.676257947)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.13180025) (u1 := 0.132976) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt289 : errPtBracket 1.176 1.1765 0.37320773 0.38101845 :=
  errPiece_sharp_taylor
    (C0 := (-0.746577925)) (C1 := (-0.741640626)) (S0 := 0.665297983) (S1 := 0.670797468)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.132976) (u1 := 0.13415225) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt290 : errPtBracket 1.1765 1.177 0.37324425 0.38105517 :=
  errPiece_sharp_taylor
    (C0 := (-0.751476514)) (C1 := (-0.74657792)) (S0 := 0.659759847) (S1 := 0.665298035)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.13415225) (u1 := 0.135329) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt291 : errPtBracket 1.177 1.1775 0.37326474 0.38107582 :=
  errPiece_sharp_taylor
    (C0 := (-0.756336076)) (C1 := (-0.751476508)) (S0 := 0.654183267) (S1 := 0.659759903)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.135329) (u1 := 0.13650625) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt292 : errPtBracket 1.1775 1.178 0.37326925 0.38108043 :=
  errPiece_sharp_taylor
    (C0 := (-0.761156294)) (C1 := (-0.756336069)) (S0 := 0.648568503) (S1 := 0.654183328)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.13650625) (u1 := 0.137684) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt293 : errPtBracket 1.178 1.1785 0.37325784 0.38106907 :=
  errPiece_sharp_taylor
    (C0 := (-0.765936851)) (C1 := (-0.761156287)) (S0 := 0.642915818) (S1 := 0.64856857)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.137684) (u1 := 0.13886225) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt294 : errPtBracket 1.1785 1.179 0.37323056 0.3810418 :=
  errPiece_sharp_taylor
    (C0 := (-0.770677431)) (C1 := (-0.765936843)) (S0 := 0.637225475) (S1 := 0.64291589)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.13886225) (u1 := 0.140041) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt295 : errPtBracket 1.179 1.1795 0.37318748 0.38099866 :=
  errPiece_sharp_taylor
    (C0 := (-0.775377722)) (C1 := (-0.770677423)) (S0 := 0.631497742) (S1 := 0.637225554)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.140041) (u1 := 0.14122025) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt296 : errPtBracket 1.1795 1.18 0.37312864 0.38093971 :=
  errPiece_sharp_taylor
    (C0 := (-0.78003741)) (C1 := (-0.775377713)) (S0 := 0.62573289) (S1 := 0.631497828)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.14122025) (u1 := 0.1424) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt297 : errPtBracket 1.18 1.1805 0.3730541 0.38086501 :=
  errPiece_sharp_taylor
    (C0 := (-0.784656186)) (C1 := (-0.780037401)) (S0 := 0.619931192) (S1 := 0.625732983)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.1424) (u1 := 0.14358025) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt298 : errPtBracket 1.1805 1.181 0.37296392 0.38077461 :=
  errPiece_sharp_taylor
    (C0 := (-0.78923374)) (C1 := (-0.784656176)) (S0 := 0.614092922) (S1 := 0.619931292)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.14358025) (u1 := 0.144761) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt299 : errPtBracket 1.181 1.1815 0.37285815 0.38066857 :=
  errPiece_sharp_taylor
    (C0 := (-0.793769767)) (C1 := (-0.78923373)) (S0 := 0.608218359) (S1 := 0.614093031)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.144761) (u1 := 0.14594225) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt300 : errPtBracket 1.1815 1.182 0.37273686 0.38054695 :=
  errPiece_sharp_taylor
    (C0 := (-0.79826396)) (C1 := (-0.793769755)) (S0 := 0.602307784) (S1 := 0.608218477)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.14594225) (u1 := 0.147124) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt301 : errPtBracket 1.182 1.1825 0.37260009 0.3804098 :=
  errPiece_sharp_taylor
    (C0 := (-0.802716016)) (C1 := (-0.798263948)) (S0 := 0.59636148) (S1 := 0.602307911)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.147124) (u1 := 0.14830625) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt302 : errPtBracket 1.1825 1.183 0.37244791 0.38025718 :=
  errPiece_sharp_taylor
    (C0 := (-0.807125634)) (C1 := (-0.802716003)) (S0 := 0.590379733) (S1 := 0.596361618)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.14830625) (u1 := 0.149489) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt303 : errPtBracket 1.183 1.1835 0.37228036 0.38008915 :=
  errPiece_sharp_taylor
    (C0 := (-0.811492514)) (C1 := (-0.80712562)) (S0 := 0.584362833) (S1 := 0.590379883)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.149489) (u1 := 0.15067225) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt304 : errPtBracket 1.1835 1.184 0.37209752 0.37990577 :=
  errPiece_sharp_taylor
    (C0 := (-0.815816357)) (C1 := (-0.811492498)) (S0 := 0.578311071) (S1 := 0.584362995)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.15067225) (u1 := 0.151856) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt305 : errPtBracket 1.184 1.1845 0.37189944 0.37970709 :=
  errPiece_sharp_taylor
    (C0 := (-0.820096867)) (C1 := (-0.81581634)) (S0 := 0.572224741) (S1 := 0.578311246)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.151856) (u1 := 0.15304025) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt306 : errPtBracket 1.1845 1.185 0.37168618 0.37949317 :=
  errPiece_sharp_taylor
    (C0 := (-0.82433375)) (C1 := (-0.820096849)) (S0 := 0.566104139) (S1 := 0.572224929)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.15304025) (u1 := 0.154225) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt307 : errPtBracket 1.185 1.1855 0.37145779 0.37926406 :=
  errPiece_sharp_taylor
    (C0 := (-0.828526714)) (C1 := (-0.824333731)) (S0 := 0.559949564) (S1 := 0.566104342)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.154225) (u1 := 0.15541025) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt308 : errPtBracket 1.1855 1.186 0.37121433 0.37901984 :=
  errPiece_sharp_taylor
    (C0 := (-0.832675468)) (C1 := (-0.828526693)) (S0 := 0.553761319) (S1 := 0.559949784)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.15541025) (u1 := 0.156596) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt309 : errPtBracket 1.186 1.1865 0.37095587 0.37876056 :=
  errPiece_sharp_taylor
    (C0 := (-0.836779723)) (C1 := (-0.832675445)) (S0 := 0.547539708) (S1 := 0.553761556)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.156596) (u1 := 0.15778225) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt310 : errPtBracket 1.1865 1.187 0.37068246 0.37848627 :=
  errPiece_sharp_taylor
    (C0 := (-0.840839193)) (C1 := (-0.836779698)) (S0 := 0.541285037) (S1 := 0.547539963)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.15778225) (u1 := 0.158969) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt311 : errPtBracket 1.187 1.1875 0.37039417 0.37819704 :=
  errPiece_sharp_taylor
    (C0 := (-0.844853593)) (C1 := (-0.840839166)) (S0 := 0.534997617) (S1 := 0.541285312)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.158969) (u1 := 0.16015625) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt312 : errPtBracket 1.1875 1.188 0.37009105 0.37789292 :=
  errPiece_sharp_taylor
    (C0 := (-0.84882264)) (C1 := (-0.844853564)) (S0 := 0.528677759) (S1 := 0.534997913)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.16015625) (u1 := 0.161344) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt313 : errPtBracket 1.188 1.1885 0.36977316 0.37757398 :=
  errPiece_sharp_taylor
    (C0 := (-0.852746054)) (C1 := (-0.848822609)) (S0 := 0.522325778) (S1 := 0.528678077)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.161344) (u1 := 0.16253225) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt314 : errPtBracket 1.1885 1.189 0.36944057 0.37724028 :=
  errPiece_sharp_taylor
    (C0 := (-0.856623557)) (C1 := (-0.852746021)) (S0 := 0.51594199) (S1 := 0.52232612)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.16253225) (u1 := 0.163721) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt315 : errPtBracket 1.189 1.1895 0.36909333 0.37689187 :=
  errPiece_sharp_taylor
    (C0 := (-0.860454871)) (C1 := (-0.856623521)) (S0 := 0.509526717) (S1 := 0.515942359)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.163721) (u1 := 0.16491025) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt316 : errPtBracket 1.1895 1.19 0.36873151 0.37652883 :=
  errPiece_sharp_taylor
    (C0 := (-0.864239723)) (C1 := (-0.860454832)) (S0 := 0.503080279) (S1 := 0.509527112)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.16491025) (u1 := 0.1661) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt317 : errPtBracket 1.19 1.1905 0.36835517 0.3761512 :=
  errPiece_sharp_taylor
    (C0 := (-0.86797784)) (C1 := (-0.864239681)) (S0 := 0.496603001) (S1 := 0.503080704)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.1661) (u1 := 0.16729025) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt318 : errPtBracket 1.1905 1.191 0.36796437 0.37575905 :=
  errPiece_sharp_taylor
    (C0 := (-0.871668952)) (C1 := (-0.867977795)) (S0 := 0.49009521) (S1 := 0.496603457)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.16729025) (u1 := 0.168481) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt319 : errPtBracket 1.191 1.1915 0.36755917 0.37535245 :=
  errPiece_sharp_taylor
    (C0 := (-0.875312792)) (C1 := (-0.871668904)) (S0 := 0.483557237) (S1 := 0.4900957)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.168481) (u1 := 0.16967225) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt320 : errPtBracket 1.1915 1.192 0.36713963 0.37493145 :=
  errPiece_sharp_taylor
    (C0 := (-0.878909092)) (C1 := (-0.875312739)) (S0 := 0.476989411) (S1 := 0.483557762)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.16967225) (u1 := 0.170864) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt321 : errPtBracket 1.192 1.1925 0.36670582 0.37449612 :=
  errPiece_sharp_taylor
    (C0 := (-0.882457591)) (C1 := (-0.878909036)) (S0 := 0.470392069) (S1 := 0.476989974)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.170864) (u1 := 0.17205625) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt322 : errPtBracket 1.1925 1.193 0.3662578 0.37404652 :=
  errPiece_sharp_taylor
    (C0 := (-0.885958027)) (C1 := (-0.88245753)) (S0 := 0.463765547) (S1 := 0.470392672)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.17205625) (u1 := 0.173249) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt323 : errPtBracket 1.193 1.1935 0.36579563 0.37358271 :=
  errPiece_sharp_taylor
    (C0 := (-0.88941014)) (C1 := (-0.885957961)) (S0 := 0.457110183) (S1 := 0.463766193)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.173249) (u1 := 0.17444225) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt324 : errPtBracket 1.1935 1.194 0.36531938 0.37310476 :=
  errPiece_sharp_taylor
    (C0 := (-0.892813673)) (C1 := (-0.889410069)) (S0 := 0.45042632) (S1 := 0.457110875)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.17444225) (u1 := 0.175636) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt325 : errPtBracket 1.194 1.195 0.36074159 0.37619851 :=
  errPiece_sharp_taylor
    (C0 := (-0.899473988)) (C1 := (-0.892813598)) (S0 := 0.436974474) (S1 := 0.450427061)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.175636) (u1 := 0.178025) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt326 : errPtBracket 1.195 1.196 0.3597074 0.3751566 :=
  errPiece_sharp_taylor
    (C0 := (-0.905936964)) (C1 := (-0.899473901)) (S0 := 0.423412788) (S1 := 0.436975322)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.178025) (u1 := 0.180416) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt327 : errPtBracket 1.196 1.197 0.35861813 0.37405915 :=
  errPiece_sharp_taylor
    (C0 := (-0.91220063)) (C1 := (-0.905936863)) (S0 := 0.409744079) (S1 := 0.423413756)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.180416) (u1 := 0.182809) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt328 : errPtBracket 1.197 1.198 0.3574743 0.37290668 :=
  errPiece_sharp_taylor
    (C0 := (-0.918263056)) (C1 := (-0.912200513)) (S0 := 0.395971201) (S1 := 0.409745183)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.182809) (u1 := 0.185204) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt329 : errPtBracket 1.198 1.199 0.35627645 0.37169972 :=
  errPiece_sharp_taylor
    (C0 := (-0.92412235)) (C1 := (-0.918262922)) (S0 := 0.382097044) (S1 := 0.395972458)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.185204) (u1 := 0.187601) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt330 : errPtBracket 1.199 1.2 0.35502509 0.37043878 :=
  errPiece_sharp_taylor
    (C0 := (-0.929776661)) (C1 := (-0.924122196)) (S0 := 0.368124534) (S1 := 0.382098474)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.187601) (u1 := 0.19) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt331 : errPtBracket 1.2 1.201 0.35372077 0.3691244 :=
  errPiece_sharp_taylor
    (C0 := (-0.935224177)) (C1 := (-0.929776483)) (S0 := 0.354056633) (S1 := 0.368126157)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.19) (u1 := 0.192401) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt332 : errPtBracket 1.201 1.202 0.35236401 0.36775711 :=
  errPiece_sharp_taylor
    (C0 := (-0.940463128)) (C1 := (-0.935223973)) (S0 := 0.339896337) (S1 := 0.354058473)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.192401) (u1 := 0.194804) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt333 : errPtBracket 1.202 1.203 0.35095536 0.36633746 :=
  errPiece_sharp_taylor
    (C0 := (-0.945491788)) (C1 := (-0.940462895)) (S0 := 0.325646677) (S1 := 0.33989842)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.194804) (u1 := 0.197209) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt334 : errPtBracket 1.203 1.204 0.34949535 0.36486597 :=
  errPiece_sharp_taylor
    (C0 := (-0.95030847)) (C1 := (-0.945491521)) (S0 := 0.311310715) (S1 := 0.325649031)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.197209) (u1 := 0.199616) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt335 : errPtBracket 1.204 1.205 0.34798455 0.3633432 :=
  errPiece_sharp_taylor
    (C0 := (-0.954911535)) (C1 := (-0.950308166)) (S0 := 0.296891551) (S1 := 0.311313373)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.199616) (u1 := 0.202025) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt336 : errPtBracket 1.205 1.206 0.3464235 0.3617697 :=
  errPiece_sharp_taylor
    (C0 := (-0.959299383)) (C1 := (-0.954911188)) (S0 := 0.282392313) (S1 := 0.296894547)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.202025) (u1 := 0.204436) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt337 : errPtBracket 1.206 1.207 0.34481276 0.36014602 :=
  errPiece_sharp_taylor
    (C0 := (-0.963470462)) (C1 := (-0.959298988)) (S0 := 0.267816163) (S1 := 0.282395686)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.204436) (u1 := 0.206849) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt338 : errPtBracket 1.207 1.208 0.34315288 0.35847271 :=
  errPiece_sharp_taylor
    (C0 := (-0.967423265)) (C1 := (-0.963470013)) (S0 := 0.253166295) (S1 := 0.267819956)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.206849) (u1 := 0.209264) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt339 : errPtBracket 1.208 1.209 0.34144443 0.35675035 :=
  errPiece_sharp_taylor
    (C0 := (-0.971156329)) (C1 := (-0.967422754)) (S0 := 0.238445933) (S1 := 0.253170554)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.209264) (u1 := 0.211681) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt340 : errPtBracket 1.209 1.21 0.33968799 0.35497949 :=
  errPiece_sharp_taylor
    (C0 := (-0.974668241)) (C1 := (-0.971155751)) (S0 := 0.22365833) (S1 := 0.23845071)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.211681) (u1 := 0.2141) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt341 : errPtBracket 1.21 1.211 0.33788411 0.3531607 :=
  errPiece_sharp_taylor
    (C0 := (-0.977957632)) (C1 := (-0.974667586)) (S0 := 0.20880677) (S1 := 0.223663681)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.2141) (u1 := 0.216521) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt342 : errPtBracket 1.211 1.212 0.33603337 0.35129456 :=
  errPiece_sharp_taylor
    (C0 := (-0.981023182)) (C1 := (-0.97795689)) (S0 := 0.193894565) (S1 := 0.208812757)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.216521) (u1 := 0.218944) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt343 : errPtBracket 1.212 1.213 0.33413636 0.34938164 :=
  errPiece_sharp_taylor
    (C0 := (-0.983863619)) (C1 := (-0.981022344)) (S0 := 0.178925056) (S1 := 0.193901257)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.218944) (u1 := 0.221369) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt344 : errPtBracket 1.213 1.214 0.33219365 0.34742252 :=
  errPiece_sharp_taylor
    (C0 := (-0.986477722)) (C1 := (-0.983862674)) (S0 := 0.163901611) (S1 := 0.178932527)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.221369) (u1 := 0.223796) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt345 : errPtBracket 1.214 1.215 0.33020583 0.3454178 :=
  errPiece_sharp_taylor
    (C0 := (-0.988864317)) (C1 := (-0.986476656)) (S0 := 0.148827624) (S1 := 0.163909943)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.223796) (u1 := 0.226225) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt346 : errPtBracket 1.215 1.216 0.32817348 0.34336804 :=
  errPiece_sharp_taylor
    (C0 := (-0.991022282)) (C1 := (-0.988863117)) (S0 := 0.133706517) (S1 := 0.148836905)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.226225) (u1 := 0.228656) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt347 : errPtBracket 1.216 1.217 0.3260972 0.34127385 :=
  errPiece_sharp_taylor
    (C0 := (-0.992950544)) (C1 := (-0.991020932)) (S0 := 0.118541736) (S1 := 0.133716845)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.228656) (u1 := 0.231089) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt348 : errPtBracket 1.217 1.218 0.32397759 0.33913582 :=
  errPiece_sharp_taylor
    (C0 := (-0.994648084)) (C1 := (-0.992949028)) (S0 := 0.103336751) (S1 := 0.118553216)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.231089) (u1 := 0.233524) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt349 : errPtBracket 1.218 1.219 0.32181525 0.33695454 :=
  errPiece_sharp_taylor
    (C0 := (-0.996113932)) (C1 := (-0.994646382)) (S0 := 0.088095057) (S1 := 0.103349499)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.233524) (u1 := 0.235961) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

end ConnesConsani.WeilPositivity
