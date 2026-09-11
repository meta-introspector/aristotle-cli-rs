/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.
-/
import RequestProject.Imported.OutputFinal.RequestProject.PolyaOscLin

/-!
# Sharpened pointwise brackets on the pieces of the partition (part 2)
-/

set_option maxHeartbeats 1000000

noncomputable section

open MeasureTheory Set Real

namespace ConnesConsani.WeilPositivity

theorem errPt70 : errPtBracket 1.0175 1.0178 (-0.62815838) (-0.62364666) :=
  errPiece_sharp_taylor
    (C0 := 0.974643923) (C1 := 0.975495199) (S0 := 0.22002072) (S1 := 0.223761531)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.03530625) (u1 := 0.03591684) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt71 : errPtBracket 1.0178 1.018 (-0.62414212) (-0.62108198) :=
  errPiece_sharp_taylor
    (C0 := 0.974068294) (C1 := 0.974643924) (S0 := 0.22376153) (S1 := 0.226254191)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.03591684) (u1 := 0.036324) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt72 : errPtBracket 1.018 1.0182 (-0.62151397) (-0.61845438) :=
  errPiece_sharp_taylor
    (C0 := 0.973486174) (C1 := 0.974068295) (S0 := 0.226254189) (S1 := 0.228745858)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.036324) (u1 := 0.03673124) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt73 : errPtBracket 1.0182 1.0185 (-0.61895945) (-0.61445051) :=
  errPiece_sharp_taylor
    (C0 := 0.972600827) (C1 := 0.973486175) (S0 := 0.228745857) (S1 := 0.232481464)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.03673124) (u1 := 0.03734225) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt74 : errPtBracket 1.0185 1.0188 (-0.61503066) (-0.61052288) :=
  errPiece_sharp_taylor
    (C0 := 0.971700877) (C1 := 0.972600828) (S0 := 0.232481462) (S1 := 0.236214741)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.03734225) (u1 := 0.03795344) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt75 : errPtBracket 1.0188 1.019 (-0.61103767) (-0.60798024) :=
  errPiece_sharp_taylor
    (C0 := 0.971092799) (C1 := 0.971700879) (S0 := 0.23621474) (S1 := 0.238702272)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.03795344) (u1 := 0.038361) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt76 : errPtBracket 1.019 1.0192 (-0.60842765) (-0.60537076) :=
  errPiece_sharp_taylor
    (C0 := 0.970478232) (C1 := 0.9710928) (S0 := 0.23870227) (S1 := 0.241188724)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.038361) (u1 := 0.03876864) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt77 : errPtBracket 1.0192 1.0195 (-0.6058952) (-0.6013901) :=
  errPiece_sharp_taylor
    (C0 := 0.969544214) (C1 := 0.970478233) (S0 := 0.241188723) (S1 := 0.244916345)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.03876864) (u1 := 0.03938025) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt78 : errPtBracket 1.0195 1.0198 (-0.6019936) (-0.59748962) :=
  errPiece_sharp_taylor
    (C0 := 0.968595597) (C1 := 0.969544215) (S0 := 0.244916344) (S1 := 0.248641445)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.03938025) (u1 := 0.03999204) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt79 : errPtBracket 1.0198 1.02 (-0.59802382) (-0.59496903) :=
  errPiece_sharp_taylor
    (C0 := 0.967955076) (C1 := 0.968595599) (S0 := 0.248641443) (S1 := 0.251123415)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.03999204) (u1 := 0.0404) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt80 : errPtBracket 1.02 1.0202 (-0.59543192) (-0.59237764) :=
  errPiece_sharp_taylor
    (C0 := 0.967308068) (C1 := 0.967955077) (S0 := 0.251123413) (S1 := 0.253604221)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.0404) (u1 := 0.04080804) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt81 : errPtBracket 1.0202 1.0205 (-0.59292155) (-0.58842015) :=
  errPiece_sharp_taylor
    (C0 := 0.966325393) (C1 := 0.967308069) (S0 := 0.25360422) (S1 := 0.257323211)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.04080804) (u1 := 0.04142025) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt82 : errPtBracket 1.0205 1.0208 (-0.5890471) (-0.5845468) :=
  errPiece_sharp_taylor
    (C0 := 0.965328124) (C1 := 0.966325394) (S0 := 0.25732321) (S1 := 0.261039485)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.04142025) (u1 := 0.04203264) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt83 : errPtBracket 1.0208 1.021 (-0.5851005) (-0.58204826) :=
  errPiece_sharp_taylor
    (C0 := 0.964655171) (C1 := 0.965328125) (S0 := 0.261039484) (S1 := 0.263515463)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.04203264) (u1 := 0.042441) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt84 : errPtBracket 1.021 1.0212 (-0.58252669) (-0.57947495) :=
  errPiece_sharp_taylor
    (C0 := 0.963975735) (C1 := 0.964655173) (S0 := 0.263515462) (S1 := 0.265990192)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.042441) (u1 := 0.04284944) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt85 : errPtBracket 1.0212 1.0215 (-0.5800384) (-0.57554059) :=
  errPiece_sharp_taylor
    (C0 := 0.962944423) (C1 := 0.963975736) (S0 := 0.26599019) (S1 := 0.269699902)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.04284944) (u1 := 0.04346225) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt86 : errPtBracket 1.0215 1.0218 (-0.57619109) (-0.57169433) :=
  errPiece_sharp_taylor
    (C0 := 0.961898526) (C1 := 0.962944424) (S0 := 0.2696999) (S1 := 0.273406701)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.04346225) (u1 := 0.04407524) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt87 : errPtBracket 1.0218 1.022 (-0.57226762) (-0.56921786) :=
  errPiece_sharp_taylor
    (C0 := 0.96119316) (C1 := 0.961898528) (S0 := 0.2734067) (S1 := 0.275876255)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.04407524) (u1 := 0.044484) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt88 : errPtBracket 1.022 1.0222 (-0.56971189) (-0.56666261) :=
  errPiece_sharp_taylor
    (C0 := 0.960481314) (C1 := 0.961193161) (S0 := 0.275876254) (S1 := 0.278344472)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.044484) (u1 := 0.04489284) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt89 : errPtBracket 1.0222 1.0225 (-0.56724568) (-0.56275132) :=
  errPiece_sharp_taylor
    (C0 := 0.959401396) (C1 := 0.960481315) (S0 := 0.27834447) (S1 := 0.282044252)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.04489284) (u1 := 0.04550625) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt90 : errPtBracket 1.0225 1.0228 (-0.56342548) (-0.55893214) :=
  errPiece_sharp_taylor
    (C0 := 0.958306904) (C1 := 0.959401397) (S0 := 0.282044251) (S1 := 0.285740927)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.04550625) (u1 := 0.04611984) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt91 : errPtBracket 1.0228 1.023 (-0.55952509) (-0.55647774) :=
  errPiece_sharp_taylor
    (C0 := 0.957569147) (C1 := 0.958306905) (S0 := 0.285740926) (S1 := 0.288203622)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.04611984) (u1 := 0.046529) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt92 : errPtBracket 1.023 1.0232 (-0.55698742) (-0.55394054) :=
  errPiece_sharp_taylor
    (C0 := 0.956824915) (C1 := 0.957569148) (S0 := 0.288203621) (S1 := 0.290664894)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.046529) (u1 := 0.04693824) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt93 : errPtBracket 1.0232 1.0235 (-0.55454331) (-0.55005228) :=
  errPiece_sharp_taylor
    (C0 := 0.95569643) (C1 := 0.956824917) (S0 := 0.290664892) (S1 := 0.294354093)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.04693824) (u1 := 0.04755225) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt94 : errPtBracket 1.0235 1.024 (-0.55093368) (-0.54355524) :=
  errPiece_sharp_taylor
    (C0 := 0.953783266) (C1 := 0.955696432) (S0 := 0.294354092) (S1 := 0.300495394)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.04755225) (u1 := 0.048576) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt95 : errPtBracket 1.024 1.0245 (-0.54463393) (-0.537258) :=
  errPiece_sharp_taylor
    (C0 := 0.951829674) (C1 := 0.953783267) (S0 := 0.300495392) (S1 := 0.306627251)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.048576) (u1 := 0.04960025) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt96 : errPtBracket 1.0245 1.025 (-0.53835676) (-0.53098327) :=
  errPiece_sharp_taylor
    (C0 := 0.949835679) (C1 := 0.951829675) (S0 := 0.306627249) (S1 := 0.312749393)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.04960025) (u1 := 0.050625) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt97 : errPtBracket 1.025 1.0255 (-0.53210213) (-0.52473103) :=
  errPiece_sharp_taylor
    (C0 := 0.947801305) (C1 := 0.94983568) (S0 := 0.312749391) (S1 := 0.318861547)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.050625) (u1 := 0.05165025) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt98 : errPtBracket 1.0255 1.026 (-0.52587005) (-0.51850128) :=
  errPiece_sharp_taylor
    (C0 := 0.945726579) (C1 := 0.947801306) (S0 := 0.318861545) (S1 := 0.32496344)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.05165025) (u1 := 0.052676) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt99 : errPtBracket 1.026 1.0265 (-0.5196605) (-0.51229402) :=
  errPiece_sharp_taylor
    (C0 := 0.94361153) (C1 := 0.94572658) (S0 := 0.324963439) (S1 := 0.3310548)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.052676) (u1 := 0.05370225) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt100 : errPtBracket 1.0265 1.027 (-0.51347347) (-0.50610922) :=
  errPiece_sharp_taylor
    (C0 := 0.941456188) (C1 := 0.943611531) (S0 := 0.331054798) (S1 := 0.337135352)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.05370225) (u1 := 0.054729) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt101 : errPtBracket 1.027 1.0275 (-0.50730896) (-0.49994688) :=
  errPiece_sharp_taylor
    (C0 := 0.939260586) (C1 := 0.941456189) (S0 := 0.337135351) (S1 := 0.343204824)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.054729) (u1 := 0.05575625) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt102 : errPtBracket 1.0275 1.028 (-0.50116696) (-0.493807) :=
  errPiece_sharp_taylor
    (C0 := 0.937024757) (C1 := 0.939260587) (S0 := 0.343204823) (S1 := 0.349262943)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.05575625) (u1 := 0.056784) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt103 : errPtBracket 1.028 1.0285 (-0.49504745) (-0.48768956) :=
  errPiece_sharp_taylor
    (C0 := 0.934748739) (C1 := 0.937024759) (S0 := 0.349262941) (S1 := 0.355309434)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.056784) (u1 := 0.05781225) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt104 : errPtBracket 1.0285 1.029 (-0.48895043) (-0.48159456) :=
  errPiece_sharp_taylor
    (C0 := 0.932432569) (C1 := 0.934748741) (S0 := 0.355309432) (S1 := 0.361344023)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.05781225) (u1 := 0.058841) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt105 : errPtBracket 1.029 1.0295 (-0.48287589) (-0.47552198) :=
  errPiece_sharp_taylor
    (C0 := 0.930076287) (C1 := 0.932432571) (S0 := 0.361344021) (S1 := 0.367366437)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.058841) (u1 := 0.05987025) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt106 : errPtBracket 1.0295 1.03 (-0.47682382) (-0.46947182) :=
  errPiece_sharp_taylor
    (C0 := 0.927679935) (C1 := 0.930076289) (S0 := 0.367366435) (S1 := 0.373376402)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.05987025) (u1 := 0.0609) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt107 : errPtBracket 1.03 1.0305 (-0.47079421) (-0.46344408) :=
  errPiece_sharp_taylor
    (C0 := 0.925243556) (C1 := 0.927679936) (S0 := 0.3733764) (S1 := 0.379373643)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.0609) (u1 := 0.06193025) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt108 : errPtBracket 1.0305 1.031 (-0.46478706) (-0.45743873) :=
  errPiece_sharp_taylor
    (C0 := 0.922767197) (C1 := 0.925243558) (S0 := 0.379373641) (S1 := 0.385357886)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.06193025) (u1 := 0.062961) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt109 : errPtBracket 1.031 1.0315 (-0.45880235) (-0.45145578) :=
  errPiece_sharp_taylor
    (C0 := 0.920250904) (C1 := 0.922767198) (S0 := 0.385357884) (S1 := 0.391328857)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.062961) (u1 := 0.06399225) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt110 : errPtBracket 1.0315 1.032 (-0.45284007) (-0.44549522) :=
  errPiece_sharp_taylor
    (C0 := 0.917694726) (C1 := 0.920250905) (S0 := 0.391328855) (S1 := 0.397286281)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.06399225) (u1 := 0.065024) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt111 : errPtBracket 1.032 1.0325 (-0.44690023) (-0.43955703) :=
  errPiece_sharp_taylor
    (C0 := 0.915098716) (C1 := 0.917694727) (S0 := 0.397286279) (S1 := 0.403229884)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.065024) (u1 := 0.06605625) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt112 : errPtBracket 1.0325 1.033 (-0.4409828) (-0.43364122) :=
  errPiece_sharp_taylor
    (C0 := 0.912462926) (C1 := 0.915098717) (S0 := 0.403229883) (S1 := 0.409159392)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.06605625) (u1 := 0.067089) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt113 : errPtBracket 1.033 1.0335 (-0.43508779) (-0.42774776) :=
  errPiece_sharp_taylor
    (C0 := 0.909787412) (C1 := 0.912462927) (S0 := 0.40915939) (S1 := 0.415074529)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.067089) (u1 := 0.06812225) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt114 : errPtBracket 1.0335 1.034 (-0.42921518) (-0.42187666) :=
  errPiece_sharp_taylor
    (C0 := 0.90707223) (C1 := 0.909787413) (S0 := 0.415074528) (S1 := 0.420975022)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.06812225) (u1 := 0.069156) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt115 : errPtBracket 1.034 1.0345 (-0.42336497) (-0.41602791) :=
  errPiece_sharp_taylor
    (C0 := 0.904317439) (C1 := 0.907072231) (S0 := 0.420975021) (S1 := 0.426860596)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.069156) (u1 := 0.07019025) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt116 : errPtBracket 1.0345 1.035 (-0.41753714) (-0.4102015) :=
  errPiece_sharp_taylor
    (C0 := 0.901523101) (C1 := 0.904317441) (S0 := 0.426860595) (S1 := 0.432730977)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.07019025) (u1 := 0.071225) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt117 : errPtBracket 1.035 1.0355 (-0.4117317) (-0.40439742) :=
  errPiece_sharp_taylor
    (C0 := 0.898689278) (C1 := 0.901523102) (S0 := 0.432730975) (S1 := 0.438585889)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.071225) (u1 := 0.07226025) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt118 : errPtBracket 1.0355 1.036 (-0.40594862) (-0.39861566) :=
  errPiece_sharp_taylor
    (C0 := 0.895816034) (C1 := 0.898689279) (S0 := 0.438585887) (S1 := 0.444425059)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.07226025) (u1 := 0.073296) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt119 : errPtBracket 1.036 1.0365 (-0.40018792) (-0.39285622) :=
  errPiece_sharp_taylor
    (C0 := 0.892903437) (C1 := 0.895816036) (S0 := 0.444425057) (S1 := 0.450248211)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.073296) (u1 := 0.07433225) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt120 : errPtBracket 1.0365 1.037 (-0.39444956) (-0.38711909) :=
  errPiece_sharp_taylor
    (C0 := 0.889951555) (C1 := 0.892903438) (S0 := 0.45024821) (S1 := 0.456055073)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.07433225) (u1 := 0.075369) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt121 : errPtBracket 1.037 1.0375 (-0.38873356) (-0.38140427) :=
  errPiece_sharp_taylor
    (C0 := 0.886960458) (C1 := 0.889951556) (S0 := 0.456055071) (S1 := 0.461845369)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.075369) (u1 := 0.07640625) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt122 : errPtBracket 1.0375 1.038 (-0.3830399) (-0.37571173) :=
  errPiece_sharp_taylor
    (C0 := 0.88393022) (C1 := 0.88696046) (S0 := 0.461845367) (S1 := 0.467618826)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.07640625) (u1 := 0.077444) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt123 : errPtBracket 1.038 1.0385 (-0.37736857) (-0.37004149) :=
  errPiece_sharp_taylor
    (C0 := 0.880860914) (C1 := 0.883930221) (S0 := 0.467618824) (S1 := 0.473375169)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.077444) (u1 := 0.07848225) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt124 : errPtBracket 1.0385 1.039 (-0.37171957) (-0.36439352) :=
  errPiece_sharp_taylor
    (C0 := 0.877752616) (C1 := 0.880860915) (S0 := 0.473375167) (S1 := 0.479114124)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.07848225) (u1 := 0.079521) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt125 : errPtBracket 1.039 1.0395 (-0.36609289) (-0.35876783) :=
  errPiece_sharp_taylor
    (C0 := 0.874605406) (C1 := 0.877752618) (S0 := 0.479114123) (S1 := 0.484835419)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.079521) (u1 := 0.08056025) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt126 : errPtBracket 1.0395 1.04 (-0.36048851) (-0.35316441) :=
  errPiece_sharp_taylor
    (C0 := 0.871419363) (C1 := 0.874605408) (S0 := 0.484835417) (S1 := 0.490538778)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.08056025) (u1 := 0.0816) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt127 : errPtBracket 1.04 1.0405 (-0.35490645) (-0.34758324) :=
  errPiece_sharp_taylor
    (C0 := 0.86819457) (C1 := 0.871419365) (S0 := 0.490538776) (S1 := 0.496223929)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.0816) (u1 := 0.08264025) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt128 : errPtBracket 1.0405 1.041 (-0.34934668) (-0.34202433) :=
  errPiece_sharp_taylor
    (C0 := 0.864931111) (C1 := 0.868194572) (S0 := 0.496223928) (S1 := 0.501890599)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.08264025) (u1 := 0.083681) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt129 : errPtBracket 1.041 1.0415 (-0.3438092) (-0.33648766) :=
  errPiece_sharp_taylor
    (C0 := 0.861629071) (C1 := 0.864931113) (S0 := 0.501890597) (S1 := 0.507538514)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.083681) (u1 := 0.08472225) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt130 : errPtBracket 1.0415 1.042 (-0.338294) (-0.33097324) :=
  errPiece_sharp_taylor
    (C0 := 0.85828854) (C1 := 0.861629073) (S0 := 0.507538512) (S1 := 0.513167402)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.08472225) (u1 := 0.085764) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt131 : errPtBracket 1.042 1.0425 (-0.33280108) (-0.32548104) :=
  errPiece_sharp_taylor
    (C0 := 0.854909606) (C1 := 0.858288542) (S0 := 0.5131674) (S1 := 0.518776989)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.085764) (u1 := 0.08680625) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt132 : errPtBracket 1.0425 1.043 (-0.32733042) (-0.32001107) :=
  errPiece_sharp_taylor
    (C0 := 0.851492363) (C1 := 0.854909609) (S0 := 0.518776987) (S1 := 0.524367004)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.08680625) (u1 := 0.087849) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt133 : errPtBracket 1.043 1.0435 (-0.32188203) (-0.31456331) :=
  errPiece_sharp_taylor
    (C0 := 0.848036904) (C1 := 0.851492365) (S0 := 0.524367002) (S1 := 0.529937174)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.087849) (u1 := 0.08889225) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt134 : errPtBracket 1.0435 1.044 (-0.31645589) (-0.30913777) :=
  errPiece_sharp_taylor
    (C0 := 0.844543325) (C1 := 0.848036907) (S0 := 0.529937173) (S1 := 0.535487228)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.08889225) (u1 := 0.089936) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt135 : errPtBracket 1.044 1.0445 (-0.311052) (-0.30373443) :=
  errPiece_sharp_taylor
    (C0 := 0.841011724) (C1 := 0.844543328) (S0 := 0.535487226) (S1 := 0.541016893)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.089936) (u1 := 0.09098025) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt136 : errPtBracket 1.0445 1.045 (-0.30567035) (-0.29835329) :=
  errPiece_sharp_taylor
    (C0 := 0.837442202) (C1 := 0.841011727) (S0 := 0.541016892) (S1 := 0.546525899)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.09098025) (u1 := 0.092025) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt137 : errPtBracket 1.045 1.0455 (-0.30031093) (-0.29299434) :=
  errPiece_sharp_taylor
    (C0 := 0.833834859) (C1 := 0.837442204) (S0 := 0.546525898) (S1 := 0.552013975)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.092025) (u1 := 0.09307025) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt138 : errPtBracket 1.0455 1.046 (-0.29497373) (-0.28765758) :=
  errPiece_sharp_taylor
    (C0 := 0.830189799) (C1 := 0.833834861) (S0 := 0.552013973) (S1 := 0.557480849)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.09307025) (u1 := 0.094116) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt139 : errPtBracket 1.046 1.0465 (-0.28965876) (-0.28234299) :=
  errPiece_sharp_taylor
    (C0 := 0.82650713) (C1 := 0.830189802) (S0 := 0.557480847) (S1 := 0.562926251)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.094116) (u1 := 0.09516225) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

end ConnesConsani.WeilPositivity
