/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.
-/
import RequestProject.Imported.OutputFinal.RequestProject.PolyaOscLin

/-!
# Sharpened pointwise brackets on the pieces of the partition (part 7)
-/

set_option maxHeartbeats 1000000

noncomputable section

open MeasureTheory Set Real

namespace ConnesConsani.WeilPositivity

theorem errPt420 : errPtBracket 1.331 1.336 (-0.06438461) (-0.01262708) :=
  errPiece_sharp_taylor
    (C0 := 0.135057761) (C1 := 0.217505481) (S0 := (-0.990837727)) (S1 := (-0.976059099))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket3 (u0 := 0.021561) (u1 := 0.034896) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt421 : errPtBracket 1.336 1.34 (-0.07105739) (-0.03073683) :=
  errPiece_sharp_taylor
    (C0 := 0.21750548) (C1 := 0.282609337) (S0 := (-0.9760591)) (S1 := (-0.959235092))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket3 (u0 := 0.034896) (u1 := 0.0456) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt422 : errPtBracket 1.34 1.345 (-0.0870134) (-0.03803994) :=
  errPiece_sharp_taylor
    (C0 := 0.282609336) (C1 := 0.362421772) (S0 := (-0.959235093)) (S1 := (-0.932014194))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket3 (u0 := 0.0456) (u1 := 0.059025) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt423 : errPtBracket 1.345 1.348 (-0.08686965) (-0.05816597) :=
  errPiece_sharp_taylor
    (C0 := 0.362421771) (C1 := 0.409245388) (S0 := (-0.932014196)) (S1 := (-0.91242436))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket3 (u0 := 0.059025) (u1 := 0.067104) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt424 : errPtBracket 1.348 1.35 (-0.08789711) (-0.06900355) :=
  errPiece_sharp_taylor
    (C0 := 0.409245386) (C1 := 0.439939171) (S0 := (-0.912424361)) (S1 := (-0.898027575))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket3 (u0 := 0.067104) (u1 := 0.0725) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt425 : errPtBracket 1.35 1.352 (-0.09233774) (-0.07368344) :=
  errPiece_sharp_taylor
    (C0 := 0.439939169) (C1 := 0.470171662) (S0 := (-0.898027577)) (S1 := (-0.882574987))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket3 (u0 := 0.0725) (u1 := 0.077904) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt426 : errPtBracket 1.352 1.355 (-0.10218342) (-0.07476776) :=
  errPiece_sharp_taylor
    (C0 := 0.47017166) (C1 := 0.514574228) (S0 := (-0.882574989)) (S1 := (-0.857445837))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket3 (u0 := 0.077904) (u1 := 0.086025) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt427 : errPtBracket 1.355 1.358 (-0.10822264) (-0.08135441) :=
  errPiece_sharp_taylor
    (C0 := 0.514574226) (C1 := 0.557731203) (S0 := (-0.857445839)) (S1 := (-0.830021629))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket3 (u0 := 0.086025) (u1 := 0.094164) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt428 : errPtBracket 1.358 1.36 (-0.10869567) (-0.09098268) :=
  errPiece_sharp_taylor
    (C0 := 0.557731201) (C1 := 0.585750117) (S0 := (-0.830021632)) (S1 := (-0.810491703))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket3 (u0 := 0.094164) (u1 := 0.0996) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt429 : errPtBracket 1.36 1.362 (-0.11242482) (-0.09494148) :=
  errPiece_sharp_taylor
    (C0 := 0.585750115) (C1 := 0.613125478) (S0 := (-0.810491707)) (S1 := (-0.789985537))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket3 (u0 := 0.0996) (u1 := 0.105044) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt430 : errPtBracket 1.362 1.364 (-0.11600671) (-0.09874996) :=
  errPiece_sharp_taylor
    (C0 := 0.613125476) (C1 := 0.639822165) (S0 := (-0.789985543)) (S1 := (-0.768522997))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket3 (u0 := 0.105044) (u1 := 0.110496) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt431 : errPtBracket 1.364 1.366 (-0.11944006) (-0.10240641) :=
  errPiece_sharp_taylor
    (C0 := 0.639822163) (C1 := 0.66580562) (S0 := (-0.768523006)) (S1 := (-0.746125242))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket3 (u0 := 0.110496) (u1 := 0.115956) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt432 : errPtBracket 1.366 1.369 (-0.12756152) (-0.10264804) :=
  errPiece_sharp_taylor
    (C0 := 0.665805618) (C1 := 0.703369397) (S0 := (-0.746125255)) (S1 := (-0.710824517))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket3 (u0 := 0.115956) (u1 := 0.124161) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt433 : errPtBracket 1.369 1.372 (-0.13205232) (-0.10765005) :=
  errPiece_sharp_taylor
    (C0 := 0.703369393) (C1 := 0.739140378) (S0 := (-0.710824542)) (S1 := (-0.673551413))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket3 (u0 := 0.124161) (u1 := 0.132384) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt434 : errPtBracket 1.372 1.374 (-0.13166818) (-0.11548222) :=
  errPiece_sharp_taylor
    (C0 := 0.739140373) (C1 := 0.761938155) (S0 := (-0.673551459)) (S1 := (-0.647649794))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket3 (u0 := 0.132384) (u1 := 0.137876) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt435 : errPtBracket 1.374 1.376 (-0.13434546) (-0.11835749) :=
  errPiece_sharp_taylor
    (C0 := 0.761938147) (C1 := 0.783859957) (S0 := (-0.647649862)) (S1 := (-0.620937662))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket3 (u0 := 0.137876) (u1 := 0.143376) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt436 : errPtBracket 1.376 1.378 (-0.1368701) (-0.12107328) :=
  errPiece_sharp_taylor
    (C0 := 0.783859947) (C1 := 0.804875581) (S0 := (-0.620937761)) (S1 := (-0.593443609))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket3 (u0 := 0.143376) (u1 := 0.148884) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt437 : errPtBracket 1.378 1.38 (-0.13924204) (-0.12362886) :=
  errPiece_sharp_taylor
    (C0 := 0.804875567) (C1 := 0.824955716) (S0 := (-0.593443753)) (S1 := (-0.565197394))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket3 (u0 := 0.148884) (u1 := 0.1544) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt438 : errPtBracket 1.38 1.383 (-0.14559459) (-0.12293589) :=
  errPiece_sharp_taylor
    (C0 := 0.824955696) (C1 := 0.853260074) (S0 := (-0.5651976)) (S1 := (-0.521485664))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket3 (u0 := 0.1544) (u1 := 0.162689) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt439 : errPtBracket 1.383 1.386 (-0.14849049) (-0.12625996) :=
  errPiece_sharp_taylor
    (C0 := 0.85326004) (C1 := 0.879304396) (S0 := (-0.52148601)) (S1 := (-0.476260297))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket3 (u0 := 0.162689) (u1 := 0.170996) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt440 : errPtBracket 1.386 1.388 (-0.14720873) (-0.13223884) :=
  errPiece_sharp_taylor
    (C0 := 0.879304339) (C1 := 0.895368876) (S0 := (-0.476260865)) (S1 := (-0.445325397))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket3 (u0 := 0.170996) (u1 := 0.176544) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt441 : errPtBracket 1.388 1.39 (-0.14882335) (-0.13398694) :=
  errPiece_sharp_taylor
    (C0 := 0.895368796) (C1 := 0.910366261) (S0 := (-0.445326177)) (S1 := (-0.413803651))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket3 (u0 := 0.176544) (u1 := 0.1821) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt442 : errPtBracket 1.39 1.392 (-0.15028917) (-0.13557324) :=
  errPiece_sharp_taylor
    (C0 := 0.910366149) (C1 := 0.924273528) (S0 := (-0.413804714)) (S1 := (-0.381731209))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket3 (u0 := 0.1821) (u1 := 0.187664) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt443 : errPtBracket 1.392 1.394 (-0.15160758) (-0.13699795) :=
  errPiece_sharp_taylor
    (C0 := 0.924273373) (C1 := 0.937068851) (S0 := (-0.381732643)) (S1 := (-0.349145167))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket3 (u0 := 0.187664) (u1 := 0.193236) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt444 : errPtBracket 1.394 1.397 (-0.15624074) (-0.13532693) :=
  errPiece_sharp_taylor
    (C0 := 0.937068637) (C1 := 0.954132249) (S0 := (-0.349147088)) (S1 := (-0.299386486))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket3 (u0 := 0.193236) (u1 := 0.201609) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt445 : errPtBracket 1.397 1.4 (-0.15759378) (-0.13695124) :=
  errPiece_sharp_taylor
    (C0 := 0.95413191) (C1 := 0.968583685) (S0 := (-0.299389421)) (S1 := (-0.248689829))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket3 (u0 := 0.201609) (u1 := 0.21) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt446 : errPtBracket 1.4 1.402 (-0.15544295) (-0.14108999) :=
  errPiece_sharp_taylor
    (C0 := 0.968583154) (C1 := 0.976738294) (S0 := (-0.248694239)) (S1 := (-0.214437952))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket3 (u0 := 0.21) (u1 := 0.215604) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt447 : errPtBracket 1.402 1.404 (-0.15605328) (-0.1417147) :=
  errPiece_sharp_taylor
    (C0 := 0.976737586) (C1 := 0.983691152) (S0 := (-0.214443691)) (S1 := (-0.179870788))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket3 (u0 := 0.215604) (u1 := 0.221216) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt448 : errPtBracket 1.404 1.406 (-0.15652951) (-0.1421819) :=
  errPiece_sharp_taylor
    (C0 := 0.983690214) (C1 := 0.989428418) (S0 := (-0.179878208)) (S1 := (-0.145030261))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket3 (u0 := 0.221216) (u1 := 0.226836) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt449 : errPtBracket 1.406 1.408 (-0.15687475) (-0.1424927) :=
  errPiece_sharp_taylor
    (C0 := 0.989427182) (C1 := 0.993937704) (S0 := (-0.145039796)) (S1 := (-0.109958941))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket3 (u0 := 0.226836) (u1 := 0.232464) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt450 : errPtBracket 1.408 1.411 (-0.15994837) (-0.13984804) :=
  errPiece_sharp_taylor
    (C0 := 0.993936086) (C1 := 0.998375734) (S0 := (-0.109971123)) (S1 := (-0.057013806))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket3 (u0 := 0.232464) (u1 := 0.240921) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt451 : errPtBracket 1.411 1.414 (-0.15992701) (-0.13982) :=
  errPiece_sharp_taylor
    (C0 := 0.998373338) (C1 := 0.999996249) (S0 := (-0.057031219)) (S1 := (-0.003794582))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket3 (u0 := 0.240921) (u1 := 0.249396) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt452 : errPtBracket 1.414 1.416 (-0.15762364) (-0.1191471) :=
  errPiece_crude_taylor (by norm_num) (by norm_num)
    (by norm_num [taylorQup, siDivPart, Finset.sum_range_succ])
    (by norm_num [taylorQ, siDivPart, Finset.sum_range_succ])

theorem errPt453 : errPtBracket 1.416 1.418 (-0.1567856) (-0.14172795) :=
  errPiece_sharp_taylor
    (C0 := 0.997730767) (C1 := 0.999495447) (S0 := 0.031762441) (S1 := 0.067329904)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.005056) (u1 := 0.010724) (j := (2:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt454 : errPtBracket 1.418 1.42 (-0.15644116) (-0.14111566) :=
  errPiece_sharp_taylor
    (C0 := 0.994695638) (C1 := 0.997730768) (S0 := 0.067329903) (S1 := 0.10286198)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.010724) (u1 := 0.0164) (j := (2:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt455 : errPtBracket 1.42 1.422 (-0.15599584) (-0.14035792) :=
  errPiece_sharp_taylor
    (C0 := 0.990388563) (C1 := 0.994695639) (S0 := 0.102861979) (S1 := 0.138313025)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.0164) (u1 := 0.022084) (j := (2:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt456 : errPtBracket 1.422 1.425 (-0.1578555) (-0.13673664) :=
  errPiece_sharp_taylor
    (C0 := 0.981543833) (C1 := 0.990388564) (S0 := 0.138313024) (S1 := 0.191237293)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.022084) (u1 := 0.030625) (j := (2:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt457 : errPtBracket 1.425 1.428 (-0.15680391) (-0.13513265) :=
  errPiece_sharp_taylor
    (C0 := 0.969845477) (C1 := 0.981543834) (S0 := 0.191237292) (S1 := 0.243720638)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.030625) (u1 := 0.039184) (j := (2:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt458 : errPtBracket 1.428 1.43 (-0.15332385) (-0.13591306) :=
  errPiece_sharp_taylor
    (C0 := 0.960468791) (C1 := 0.969845478) (S0 := 0.243720637) (S1 := 0.278387681)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.039184) (u1 := 0.0449) (j := (2:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt459 : errPtBracket 1.43 1.432 (-0.15246618) (-0.13445916) :=
  errPiece_sharp_taylor
    (C0 := 0.949837644) (C1 := 0.960468792) (S0 := 0.27838768) (S1 := 0.312743425)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.0449) (u1 := 0.050624) (j := (2:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt460 : errPtBracket 1.432 1.434 (-0.15154733) (-0.13287271) :=
  errPiece_sharp_taylor
    (C0 := 0.937960607) (C1 := 0.949837645) (S0 := 0.312743423) (S1 := 0.346741833)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.050624) (u1 := 0.056356) (j := (2:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt461 : errPtBracket 1.434 1.436 (-0.15057546) (-0.13115606) :=
  errPiece_sharp_taylor
    (C0 := 0.924847961) (C1 := 0.937960608) (S0 := 0.346741831) (S1 := 0.38033702)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.056356) (u1 := 0.062096) (j := (2:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt462 : errPtBracket 1.436 1.439 (-0.1516834) (-0.12664439) :=
  errPiece_sharp_taylor
    (C0 := 0.902888918) (C1 := 0.924847962) (S0 := 0.380337019) (S1 := 0.429873936)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.062096) (u1 := 0.070721) (j := (2:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt463 : errPtBracket 1.439 1.442 (-0.15006518) (-0.12365332) :=
  errPiece_sharp_taylor
    (C0 := 0.878224816) (C1 := 0.90288892) (S0 := 0.429873934) (S1 := 0.478248023)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.070721) (u1 := 0.079364) (j := (2:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt464 : errPtBracket 1.442 1.444 (-0.14633879) (-0.12303561) :=
  errPiece_sharp_taylor
    (C0 := 0.86030673) (C1 := 0.878224818) (S0 := 0.478248022) (S1 := 0.509776746)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.079364) (u1 := 0.085136) (j := (2:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt465 : errPtBracket 1.444 1.446 (-0.14524249) (-0.12070415) :=
  errPiece_sharp_taylor
    (C0 := 0.841230062) (C1 := 0.860306732) (S0 := 0.509776744) (S1 := 0.540677337)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.085136) (u1 := 0.090916) (j := (2:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt466 : errPtBracket 1.446 1.448 (-0.14415354) (-0.11825699) :=
  errPiece_sharp_taylor
    (C0 := 0.821015312) (C1 := 0.841230064) (S0 := 0.540677336) (S1 := 0.570906172)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.090916) (u1 := 0.096704) (j := (2:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt467 : errPtBracket 1.448 1.45 (-0.14308419) (-0.11569651) :=
  errPiece_sharp_taylor
    (C0 := 0.799684658) (C1 := 0.821015316) (S0 := 0.57090617) (S1 := 0.600420226)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.096704) (u1 := 0.1025) (j := (2:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt468 : errPtBracket 1.45 1.453 (-0.14413656) (-0.11040144) :=
  errPiece_sharp_taylor
    (C0 := 0.765648948) (C1 := 0.799684663) (S0 := 0.600420224) (S1 := 0.643258648)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.1025) (u1 := 0.111209) (j := (2:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt469 : errPtBracket 1.453 1.456 (-0.14270636) (-0.10619963) :=
  errPiece_sharp_taylor
    (C0 := 0.72924384) (C1 := 0.765648958) (S0 := 0.643258646) (S1 := 0.684253917)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.111209) (u1 := 0.119936) (j := (2:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt470 : errPtBracket 1.456 1.458 (-0.13927452) (-0.10436678) :=
  errPiece_sharp_taylor
    (C0 := 0.703704284) (C1 := 0.729243858) (S0 := 0.684253914) (S1 := 0.710492986)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.119936) (u1 := 0.125764) (j := (2:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt471 : errPtBracket 1.458 1.46 (-0.1385142) (-0.10127307) :=
  errPiece_sharp_taylor
    (C0 := 0.677184245) (C1 := 0.703704312) (S0 := 0.710492983) (S1 := 0.735813497)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.125764) (u1 := 0.1316) (j := (2:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt472 : errPtBracket 1.46 1.462 (-0.13786397) (-0.09807873) :=
  errPiece_sharp_taylor
    (C0 := 0.649715562) (C1 := 0.677184288) (S0 := 0.735813492) (S1 := 0.760177411)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.1316) (u1 := 0.137444) (j := (2:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt473 : errPtBracket 1.462 1.464 (-0.13734223) (-0.09478547) :=
  errPiece_sharp_taylor
    (C0 := 0.621331595) (C1 := 0.649715628) (S0 := 0.760177404) (S1 := 0.78354774)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.137444) (u1 := 0.143296) (j := (2:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt474 : errPtBracket 1.464 1.467 (-0.13937337) (-0.08881036) :=
  errPiece_sharp_taylor
    (C0 := 0.577116111) (C1 := 0.621331693) (S0 := 0.783547731) (S1 := 0.81666212)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.143296) (u1 := 0.152089) (j := (2:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt475 : errPtBracket 1.467 1.47 (-0.10209594) (-0.08750518) :=
  errPiece_sharp_asymp
    (C0 := 0.531043688) (C1 := 0.577116289) (S0 := 0.816662103) (S1 := 0.847344468)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.152089) (u1 := 0.1609) (j := (2:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPt476 : errPtBracket 1.47 1.472 (-0.09600711) (-0.08550822) :=
  errPiece_sharp_asymp
    (C0 := 0.499361402) (C1 := 0.531043998) (S0 := 0.847344437) (S1 := 0.866393824)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.1609) (u1 := 0.166784) (j := (2:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPt477 : errPtBracket 1.472 1.476 (-0.09486348) (-0.07676016) :=
  errPiece_sharp_asymp
    (C0 := 0.433857851) (C1 := 0.499361845) (S0 := 0.866393781) (S1 := 0.900981419)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.166784) (u1 := 0.178576) (j := (2:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPt478 : errPtBracket 1.476 1.478 (-0.08582092) (-0.07575107) :=
  errPiece_sharp_asymp
    (C0 := 0.400121259) (C1 := 0.433858725) (S0 := 0.900981328) (S1 := 0.916462329)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.178576) (u1 := 0.184484) (j := (2:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPt479 : errPtBracket 1.478 1.481 (-0.08342354) (-0.06966698) :=
  errPiece_sharp_asymp
    (C0 := 0.348409087) (C1 := 0.400122468) (S0 := 0.9164622) (S1 := 0.937342781)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.184484) (u1 := 0.193361) (j := (2:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPt480 : errPtBracket 1.481 1.484 (-0.07815323) (-0.06465445) :=
  errPiece_sharp_asymp
    (C0 := 0.295505265) (C1 := 0.348411021) (S0 := 0.937342566) (S1 := 0.955341446)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.193361) (u1 := 0.202256) (j := (2:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPt481 : errPtBracket 1.484 1.486 (-0.07180671) (-0.06235995) :=
  errPiece_sharp_asymp
    (C0 := 0.259652384) (C1 := 0.295508295) (S0 := 0.955341095) (S1 := 0.96570261)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.202256) (u1 := 0.208196) (j := (2:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPt482 : errPtBracket 1.486 1.49 (-0.07028319) (-0.05349167) :=
  errPiece_sharp_asymp
    (C0 := 0.186763986) (C1 := 0.259656431) (S0 := 0.965702128) (S1 := 0.982405668)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.208196) (u1 := 0.2201) (j := (2:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPt483 : errPtBracket 1.49 1.492 (-0.06113491) (-0.05218708) :=
  errPiece_sharp_asymp
    (C0 := 0.149827876) (C1 := 0.18677104) (S0 := 0.98240478) (S1 := 0.988713249)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.2201) (u1 := 0.226064) (j := (2:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPt484 : errPtBracket 1.492 1.495 (-0.05855112) (-0.04609248) :=
  errPiece_sharp_asymp
    (C0 := 0.093951707) (C1 := 0.149837091) (S0 := 0.988712058) (S1 := 0.995578534)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.226064) (u1 := 0.235025) (j := (2:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPt485 : errPtBracket 1.495 1.498 (-0.05319823) (-0.0410461) :=
  errPiece_sharp_asymp
    (C0 := 0.037664719) (C1 := 0.093965299) (S0 := 0.995576709) (S1 := 0.999293134)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.235025) (u1 := 0.244004) (j := (2:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPt486 : errPtBracket 1.498 1.5 (-0.12794335) 0.06442604 :=
  errPiece_crude_asymp (by norm_num) (by norm_num) (by norm_num)
    (by norm_num) (by norm_num)

theorem errPt487 : errPtBracket 1.5 1.504 (-0.04529238) (-0.02984821) :=
  errPiece_sharp_asymp
    (C0 := (-0.075427051)) (C1 := 0) (S0 := 0.997151322) (S1 := 1)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0) (u1 := 0.012016) (j := (2:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPt488 : errPtBracket 1.504 1.508 (-0.03856657) (-0.02308371) :=
  errPiece_sharp_asymp
    (C0 := (-0.150623138)) (C1 := (-0.07542705)) (S0 := 0.988591255) (S1 := 0.997151323)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.012016) (u1 := 0.024064) (j := (2:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

theorem errPt489 : errPtBracket 1.508 1.512 (-0.0319501) (-0.01647995) :=
  errPiece_sharp_asymp
    (C0 := (-0.225152401)) (C1 := (-0.150623137)) (S0 := 0.974323558) (S1 := 0.988591256)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.024064) (u1 := 0.036144) (j := (2:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, bLoSharp, siLoSharp])
    (by norm_num [aHiSharp, bHiSharp, siHiSharp])

end ConnesConsani.WeilPositivity
