/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.
-/
import RequestProject.Imported.OutputFinal.RequestProject.PolyaOscLin

/-!
# Sharpened pointwise brackets on the pieces of the partition (part 3)
-/

set_option maxHeartbeats 1000000

noncomputable section

open MeasureTheory Set Real

namespace ConnesConsani.WeilPositivity

theorem errPt140 : errPtBracket 1.0465 1.047 (-0.284366) (-0.27705058) :=
  errPiece_sharp_taylor
    (C0 := 0.822786958) (C1 := 0.826507133) (S0 := 0.562926249) (S1 := 0.568349912)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.09516225) (u1 := 0.096209) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt141 : errPtBracket 1.047 1.048 (-0.28006376) (-0.26557236) :=
  errPiece_sharp_taylor
    (C0 := 0.815234547) (C1 := 0.822786961) (S0 := 0.56834991) (S1 := 0.57913093)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.096209) (u1 := 0.098304) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt142 : errPtBracket 1.048 1.049 (-0.26961169) (-0.25512015) :=
  errPiece_sharp_taylor
    (C0 := 0.807533469) (C1 := 0.81523455) (S0 := 0.579130928) (S1 := 0.58982175)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.098304) (u1 := 0.100401) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt143 : errPtBracket 1.049 1.05 (-0.25924842) (-0.24475642) :=
  errPiece_sharp_taylor
    (C0 := 0.799684658) (C1 := 0.807533473) (S0 := 0.589821748) (S1 := 0.600420226)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.100401) (u1 := 0.1025) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt144 : errPtBracket 1.05 1.051 (-0.24897392) (-0.23448112) :=
  errPiece_sharp_taylor
    (C0 := 0.791689079) (C1 := 0.799684663) (S0 := 0.600420224) (S1 := 0.610924219)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.1025) (u1 := 0.104601) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt145 : errPtBracket 1.051 1.052 (-0.23878811) (-0.22429419) :=
  errPiece_sharp_taylor
    (C0 := 0.783547731) (C1 := 0.791689085) (S0 := 0.610924217) (S1 := 0.621331597)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.104601) (u1 := 0.106704) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt146 : errPtBracket 1.052 1.053 (-0.22869095) (-0.21419559) :=
  errPiece_sharp_taylor
    (C0 := 0.775261642) (C1 := 0.783547738) (S0 := 0.621331595) (S1 := 0.631640236)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.106704) (u1 := 0.108809) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt147 : errPtBracket 1.053 1.054 (-0.21868238) (-0.20418527) :=
  errPiece_sharp_taylor
    (C0 := 0.766831872) (C1 := 0.77526165) (S0 := 0.631640233) (S1 := 0.641848019)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.108809) (u1 := 0.110916) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt148 : errPtBracket 1.054 1.055 (-0.20876234) (-0.19426317) :=
  errPiece_sharp_taylor
    (C0 := 0.758259515) (C1 := 0.766831881) (S0 := 0.641848017) (S1 := 0.651952842)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.110916) (u1 := 0.113025) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt149 : errPtBracket 1.055 1.056 (-0.19893078) (-0.18442925) :=
  errPiece_sharp_taylor
    (C0 := 0.749545695) (C1 := 0.758259526) (S0 := 0.651952839) (S1 := 0.661952605)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.113025) (u1 := 0.115136) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt150 : errPtBracket 1.056 1.057 (-0.18918763) (-0.17468345) :=
  errPiece_sharp_taylor
    (C0 := 0.740691568) (C1 := 0.749545708) (S0 := 0.661952602) (S1 := 0.671845222)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.115136) (u1 := 0.117249) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt151 : errPtBracket 1.057 1.058 (-0.17953285) (-0.16502572) :=
  errPiece_sharp_taylor
    (C0 := 0.731698322) (C1 := 0.740691583) (S0 := 0.671845219) (S1 := 0.681628614)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.117249) (u1 := 0.119364) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt152 : errPtBracket 1.058 1.059 (-0.16996637) (-0.15545602) :=
  errPiece_sharp_taylor
    (C0 := 0.722567175) (C1 := 0.731698339) (S0 := 0.681628611) (S1 := 0.691300715)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.119364) (u1 := 0.121481) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt153 : errPtBracket 1.059 1.06 (-0.16048813) (-0.14597428) :=
  errPiece_sharp_taylor
    (C0 := 0.713299379) (C1 := 0.722567195) (S0 := 0.691300712) (S1 := 0.700859471)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.121481) (u1 := 0.1236) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt154 : errPtBracket 1.06 1.061 (-0.15109809) (-0.13658045) :=
  errPiece_sharp_taylor
    (C0 := 0.703896217) (C1 := 0.713299403) (S0 := 0.700859467) (S1 := 0.710302836)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.1236) (u1 := 0.125721) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt155 : errPtBracket 1.061 1.062 (-0.14179618) (-0.12727449) :=
  errPiece_sharp_taylor
    (C0 := 0.694359002) (C1 := 0.703896245) (S0 := 0.710302832) (S1 := 0.719628779)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.125721) (u1 := 0.127844) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt156 : errPtBracket 1.062 1.064 (-0.13523835) (-0.1063019) :=
  errPiece_sharp_taylor
    (C0 := 0.674887827) (C1 := 0.694359035) (S0 := 0.719628775) (S1 := 0.737920338)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.127844) (u1 := 0.132096) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt157 : errPtBracket 1.064 1.066 (-0.11716846) (-0.08821002) :=
  errPiece_sharp_taylor
    (C0 := 0.654896993) (C1 := 0.674887872) (S0 := 0.737920333) (S1 := 0.755718158)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.132096) (u1 := 0.136356) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt158 : errPtBracket 1.066 1.068 (-0.09945051) (-0.07046808) :=
  errPiece_sharp_taylor
    (C0 := 0.63439814) (C1 := 0.654897054) (S0 := 0.755718152) (S1 := 0.773006474)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.136356) (u1 := 0.140624) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt159 : errPtBracket 1.068 1.069 (-0.07914534) (-0.06458829) :=
  errPiece_sharp_taylor
    (C0 := 0.623961978) (C1 := 0.634398222) (S0 := 0.773006466) (S1 := 0.781454708)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.140624) (u1 := 0.142761) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt160 : errPtBracket 1.069 1.072 (-0.07656024) (-0.03307158) :=
  errPiece_sharp_taylor
    (C0 := 0.591925401) (C1 := 0.623962073) (S0 := 0.781454699) (S1 := 0.805992766)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.142761) (u1 := 0.149184) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt161 : errPtBracket 1.072 1.074 (-0.04840298) (-0.01933743) :=
  errPiece_sharp_taylor
    (C0 := 0.569977257) (C1 := 0.591925548) (S0 := 0.805992752) (S1 := 0.821660485)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.149184) (u1 := 0.153476) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt162 : errPtBracket 1.074 1.078 (-0.03866122) 0.01946293 :=
  errPiece_sharp_taylor
    (C0 := 0.524725409) (C1 := 0.569977451) (S0 := 0.821660466) (S1 := 0.851271575)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.153476) (u1 := 0.162084) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt163 : errPtBracket 1.078 1.08 (-0.00050288) 0.02866055 :=
  errPiece_sharp_taylor
    (C0 := 0.501450333) (C1 := 0.524725742) (S0 := 0.851271543) (S1 := 0.865186472)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.162084) (u1 := 0.1664) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt164 : errPtBracket 1.08 1.083 0.01121346 0.05497906 :=
  errPiece_sharp_taylor
    (C0 := 0.465768348) (C1 := 0.501450765) (S0 := 0.865186429) (S1 := 0.884906747)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.1664) (u1 := 0.172889) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt165 : errPtBracket 1.083 1.086 0.03332355 0.07717559 :=
  errPiece_sharp_taylor
    (C0 := 0.429210066) (C1 := 0.465768981) (S0 := 0.884906683) (S1 := 0.903204783)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.172889) (u1 := 0.179396) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt166 : errPtBracket 1.086 1.088 0.05849752 0.08781008 :=
  errPiece_sharp_taylor
    (C0 := 0.404378063) (C1 := 0.429210981) (S0 := 0.903204688) (S1 := 0.914592037)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.179396) (u1 := 0.183744) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt167 : errPtBracket 1.088 1.09 0.07238334 0.10173589 :=
  errPiece_sharp_taylor
    (C0 := 0.379197761) (C1 := 0.404379224) (S0 := 0.914591914) (S1 := 0.925315803)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.183744) (u1 := 0.1881) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt168 : errPtBracket 1.09 1.092 0.085925 0.11531843 :=
  errPiece_sharp_taylor
    (C0 := 0.353686406) (C1 := 0.379199229) (S0 := 0.925315644) (S1 := 0.935364254)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.1881) (u1 := 0.192464) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt169 : errPtBracket 1.092 1.094 0.09912334 0.12855845 :=
  errPiece_sharp_taylor
    (C0 := 0.327861661) (C1 := 0.353688252) (S0 := 0.93536405) (S1 := 0.944725992)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.192464) (u1 := 0.196836) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt170 : errPtBracket 1.094 1.095 0.11616738 0.13093618 :=
  errPiece_sharp_taylor
    (C0 := 0.314837401) (C1 := 0.327863971) (S0 := 0.944725731) (S1 := 0.949145902)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.196836) (u1 := 0.199025) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt171 : errPtBracket 1.095 1.096 0.12251549 0.13729409 :=
  errPiece_sharp_taylor
    (C0 := 0.301741602) (C1 := 0.314839981) (S0 := 0.949145607) (S1 := 0.953390061)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.199025) (u1 := 0.201216) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt172 : errPtBracket 1.096 1.097 0.1287783 0.14356678 :=
  errPiece_sharp_taylor
    (C0 := 0.288576588) (C1 := 0.30174448) (S0 := 0.953389729) (S1 := 0.957457172)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.201216) (u1 := 0.203409) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt173 : errPtBracket 1.097 1.098 0.13495594 0.14975437 :=
  errPiece_sharp_taylor
    (C0 := 0.275344703) (C1 := 0.288579795) (S0 := 0.957456798) (S1 := 0.961345967)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.203409) (u1 := 0.205604) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt174 : errPtBracket 1.098 1.099 0.14104853 0.15585697 :=
  errPiece_sharp_taylor
    (C0 := 0.262048319) (C1 := 0.275348274) (S0 := 0.961345546) (S1 := 0.965055207)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.205604) (u1 := 0.207801) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt175 : errPtBracket 1.099 1.1 0.14705619 0.16187468 :=
  errPiece_sharp_taylor
    (C0 := 0.248689829) (C1 := 0.262052289) (S0 := 0.965054734) (S1 := 0.968583685)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.207801) (u1 := 0.21) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt176 : errPtBracket 1.1 1.101 0.15297904 0.16780764 :=
  errPiece_sharp_taylor
    (C0 := 0.235271649) (C1 := 0.248694239) (S0 := 0.968583154) (S1 := 0.971930224)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.21) (u1 := 0.212201) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt177 : errPtBracket 1.101 1.102 0.15881722 0.17365596 :=
  errPiece_sharp_taylor
    (C0 := 0.22179622) (C1 := 0.235276544) (S0 := 0.97192963) (S1 := 0.97509368)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.212201) (u1 := 0.214404) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt178 : errPtBracket 1.102 1.103 0.16457084 0.17941977 :=
  errPiece_sharp_taylor
    (C0 := 0.208266005) (C1 := 0.221801648) (S0 := 0.975093014) (S1 := 0.978072939)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.214404) (u1 := 0.216609) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt179 : errPtBracket 1.103 1.104 0.17024004 0.18509918 :=
  errPiece_sharp_taylor
    (C0 := 0.194683488) (C1 := 0.208272017) (S0 := 0.978072194) (S1 := 0.98086692)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.216609) (u1 := 0.218816) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt180 : errPtBracket 1.104 1.105 0.17582496 0.19069435 :=
  errPiece_sharp_taylor
    (C0 := 0.181051175) (C1 := 0.194690141) (S0 := 0.980866087) (S1 := 0.983474574)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.218816) (u1 := 0.221025) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt181 : errPtBracket 1.105 1.106 0.18132573 0.19620538 :=
  errPiece_sharp_taylor
    (C0 := 0.167371594) (C1 := 0.181058531) (S0 := 0.983473644) (S1 := 0.985894886)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.221025) (u1 := 0.223236) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt182 : errPtBracket 1.106 1.107 0.1867425 0.20163243 :=
  errPiece_sharp_taylor
    (C0 := 0.153647293) (C1 := 0.167379719) (S0 := 0.985893849) (S1 := 0.988126875)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.223236) (u1 := 0.225449) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt183 : errPtBracket 1.107 1.108 0.19207541 0.20697563 :=
  errPiece_sharp_taylor
    (C0 := 0.139880842) (C1 := 0.153656261) (S0 := 0.988125719) (S1 := 0.990169592)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.225449) (u1 := 0.227664) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt184 : errPtBracket 1.108 1.109 0.19732461 0.21223512 :=
  errPiece_sharp_taylor
    (C0 := 0.12607483) (C1 := 0.139890731) (S0 := 0.990168305) (S1 := 0.992022124)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.227664) (u1 := 0.229881) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt185 : errPtBracket 1.109 1.11 0.20249025 0.21741104 :=
  errPiece_sharp_taylor
    (C0 := 0.112231866) (C1 := 0.126085725) (S0 := 0.992020693) (S1 := 0.993683593)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.229881) (u1 := 0.2321) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt186 : errPtBracket 1.11 1.111 0.20757248 0.22250355 :=
  errPiece_sharp_taylor
    (C0 := 0.098354578) (C1 := 0.112243859) (S0 := 0.993682002) (S1 := 0.995153154)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.2321) (u1 := 0.234321) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt187 : errPtBracket 1.111 1.112 0.21257145 0.22751279 :=
  errPiece_sharp_taylor
    (C0 := 0.084445612) (C1 := 0.098367768) (S0 := 0.995151388) (S1 := 0.996430001)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.234321) (u1 := 0.236544) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt188 : errPtBracket 1.112 1.113 0.21748734 0.23243893 :=
  errPiece_sharp_taylor
    (C0 := 0.070507634) (C1 := 0.084460108) (S0 := 0.996428042) (S1 := 0.997513361)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.236544) (u1 := 0.238769) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt189 : errPtBracket 1.113 1.114 0.2223203 0.23728211 :=
  errPiece_sharp_taylor
    (C0 := 0.056543326) (C1 := 0.070523553) (S0 := 0.997511189) (S1 := 0.998402499)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.238769) (u1 := 0.240996) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt190 : errPtBracket 1.114 1.115 0.22707049 0.2420425 :=
  errPiece_sharp_taylor
    (C0 := 0.04255539) (C1 := 0.056560793) (S0 := 0.998400094) (S1 := 0.999096716)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.240996) (u1 := 0.243225) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt191 : errPtBracket 1.115 1.116 0.2317381 0.24672026 :=
  errPiece_sharp_taylor
    (C0 := 0.028546541) (C1 := 0.042574541) (S0 := 0.999094055) (S1 := 0.999595351)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.243225) (u1 := 0.245456) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt192 : errPtBracket 1.116 1.117 0.23632328 0.25131557 :=
  errPiece_sharp_taylor
    (C0 := 0.014519514) (C1 := 0.028567523) (S0 := 0.999592409) (S1 := 0.99989778)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.245456) (u1 := 0.247689) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt193 : errPtBracket 1.117 1.118 0.24082623 0.25582859 :=
  errPiece_sharp_taylor
    (C0 := 0.000477058) (C1 := 0.014542484) (S0 := 0.99989453) (S1 := 1.000003417)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket0 (u0 := 0.247689) (u1 := 0.249924) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt194 : errPtBracket 1.118 1.119 0.23272678 0.27435385 :=
  errPiece_crude_taylor (by norm_num) (by norm_num)
    (by norm_num [taylorQup, siDivPart, Finset.sum_range_succ])
    (by norm_num [taylorQ, siDivPart, Finset.sum_range_succ])

theorem errPt195 : errPtBracket 1.119 1.12 0.24958434 0.2646125 :=
  errPiece_sharp_taylor
    (C0 := (-0.027642494)) (C1 := (-0.013577546)) (S0 := 0.999617873) (S1 := 0.999907821)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.002161) (u1 := 0.0044) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt196 : errPtBracket 1.12 1.121 0.25383959 0.26888182 :=
  errPiece_sharp_taylor
    (C0 := (-0.041714527)) (C1 := (-0.027642493)) (S0 := 0.99912957) (S1 := 0.999617874)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.0044) (u1 := 0.006641) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt197 : errPtBracket 1.121 1.122 0.25801334 0.27306955 :=
  errPiece_sharp_taylor
    (C0 := (-0.055790836)) (C1 := (-0.041714526)) (S0 := 0.998442478) (S1 := 0.999129571)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.006641) (u1 := 0.008884) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt198 : errPtBracket 1.122 1.123 0.26210581 0.27717591 :=
  errPiece_sharp_taylor
    (C0 := (-0.069868599)) (C1 := (-0.055790835)) (S0 := 0.997556203) (S1 := 0.998442479)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.008884) (u1 := 0.011129) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt199 : errPtBracket 1.123 1.124 0.26611718 0.28120107 :=
  errPiece_sharp_taylor
    (C0 := (-0.083944983)) (C1 := (-0.069868598)) (S0 := 0.99647039) (S1 := 0.997556204)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.011129) (u1 := 0.013376) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt200 : errPtBracket 1.124 1.125 0.27004766 0.28514523 :=
  errPiece_sharp_taylor
    (C0 := (-0.098017141)) (C1 := (-0.083944982)) (S0 := 0.995184726) (S1 := 0.996470391)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.013376) (u1 := 0.015625) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt201 : errPtBracket 1.125 1.126 0.27389745 0.2890086 :=
  errPiece_sharp_taylor
    (C0 := (-0.112082214)) (C1 := (-0.09801714)) (S0 := 0.993698937) (S1 := 0.995184727)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.015625) (u1 := 0.017876) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt202 : errPtBracket 1.126 1.127 0.27766676 0.29279138 :=
  errPiece_sharp_taylor
    (C0 := (-0.126137332)) (C1 := (-0.112082213)) (S0 := 0.992012788) (S1 := 0.993698938)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.017876) (u1 := 0.020129) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt203 : errPtBracket 1.127 1.128 0.28135581 0.29649378 :=
  errPiece_sharp_taylor
    (C0 := (-0.140179617)) (C1 := (-0.126137331)) (S0 := 0.99012609) (S1 := 0.992012789)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.020129) (u1 := 0.022384) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt204 : errPtBracket 1.128 1.129 0.28496482 0.300116 :=
  errPiece_sharp_taylor
    (C0 := (-0.154206177)) (C1 := (-0.140179616)) (S0 := 0.988038691) (S1 := 0.990126091)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.022384) (u1 := 0.024641) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt205 : errPtBracket 1.129 1.13 0.28849401 0.30365827 :=
  errPiece_sharp_taylor
    (C0 := (-0.168214113)) (C1 := (-0.154206176)) (S0 := 0.985750481) (S1 := 0.988038692)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.024641) (u1 := 0.0269) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt206 : errPtBracket 1.13 1.131 0.2919436 0.3071208 :=
  errPiece_sharp_taylor
    (C0 := (-0.182200517)) (C1 := (-0.168214112)) (S0 := 0.983261395) (S1 := 0.985750482)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.0269) (u1 := 0.029161) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt207 : errPtBracket 1.131 1.132 0.29531382 0.31050382 :=
  errPiece_sharp_taylor
    (C0 := (-0.196162473)) (C1 := (-0.182200516)) (S0 := 0.980571407) (S1 := 0.983261396)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.029161) (u1 := 0.031424) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt208 : errPtBracket 1.132 1.133 0.29860491 0.31380755 :=
  errPiece_sharp_taylor
    (C0 := (-0.210097056)) (C1 := (-0.196162472)) (S0 := 0.977680534) (S1 := 0.980571408)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.031424) (u1 := 0.033689) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt209 : errPtBracket 1.133 1.134 0.3018171 0.31703223 :=
  errPiece_sharp_taylor
    (C0 := (-0.224001335)) (C1 := (-0.210097055)) (S0 := 0.974588837) (S1 := 0.977680535)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.033689) (u1 := 0.035956) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

end ConnesConsani.WeilPositivity
