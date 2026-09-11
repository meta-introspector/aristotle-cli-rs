/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.
-/
import RequestProject.Imported.OutputFinal.RequestProject.PolyaOscLin

/-!
# Sharpened pointwise brackets on the pieces of the partition (part 6)
-/

set_option maxHeartbeats 1000000

noncomputable section

open MeasureTheory Set Real

namespace ConnesConsani.WeilPositivity

theorem errPt350 : errPtBracket 1.219 1.22 0.31961076 0.33473062 :=
  errPiece_sharp_taylor
    (C0 := (-0.997347172)) (C1 := (-0.996112025)) (S0 := 0.072820172) (S1 := 0.0881092)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.235961) (u1 := 0.2384) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt351 : errPtBracket 1.22 1.221 0.31736475 0.33246466 :=
  errPiece_sharp_taylor
    (C0 := (-0.998346941)) (C1 := (-0.997345037)) (S0 := 0.057515637) (S1 := 0.072835847)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.2384) (u1 := 0.240841) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt352 : errPtBracket 1.221 1.222 0.31507782 0.33015726 :=
  errPiece_sharp_taylor
    (C0 := (-0.99911243)) (C1 := (-0.998344553)) (S0 := 0.042185014) (S1 := 0.057532992)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.240841) (u1 := 0.243284) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt353 : errPtBracket 1.222 1.223 0.31275058 0.32780905 :=
  errPiece_sharp_taylor
    (C0 := (-0.999642883)) (C1 := (-0.999109762)) (S0 := 0.026831884) (S1 := 0.042204211)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.243284) (u1 := 0.245729) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt354 : errPtBracket 1.223 1.224 0.31038364 0.32542062 :=
  errPiece_sharp_taylor
    (C0 := (-0.999937599)) (C1 := (-0.999639904)) (S0 := 0.011459852) (S1 := 0.026853101)
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket1 (u0 := 0.245729) (u1 := 0.248176) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt355 : errPtBracket 1.224 1.225 0.2829811 0.32376595 :=
  errPiece_crude_taylor (by norm_num) (by norm_num)
    (by norm_num [taylorQup, siDivPart, Finset.sum_range_succ])
    (by norm_num [taylorQ, siDivPart, Finset.sum_range_succ])

theorem errPt356 : errPtBracket 1.225 1.226 0.30553093 0.32052814 :=
  errPiece_sharp_taylor
    (C0 := (-0.99999229)) (C1 := (-0.999813237)) (S0 := (-0.019325875)) (S1 := (-0.00392698))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket2 (u0 := 0.000625) (u1 := 0.003076) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt357 : errPtBracket 1.226 1.227 0.30304545 0.318026 :=
  errPiece_sharp_taylor
    (C0 := (-0.999813238)) (C1 := (-0.999396636)) (S0 := (-0.034732745)) (S1 := (-0.019325874))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket2 (u0 := 0.003076) (u1 := 0.005529) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt358 : errPtBracket 1.227 1.228 0.30052277 0.31548614 :=
  errPiece_sharp_taylor
    (C0 := (-0.999396637)) (C1 := (-0.998742002)) (S0 := (-0.050143914)) (S1 := (-0.034732744))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket2 (u0 := 0.005529) (u1 := 0.007984) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt359 : errPtBracket 1.228 1.229 0.29796349 0.31290918 :=
  errPiece_sharp_taylor
    (C0 := (-0.998742003)) (C1 := (-0.997848912)) (S0 := (-0.065555692)) (S1 := (-0.050143913))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket2 (u0 := 0.007984) (u1 := 0.010441) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt360 : errPtBracket 1.229 1.23 0.29536827 0.31029575 :=
  errPiece_sharp_taylor
    (C0 := (-0.997848913)) (C1 := (-0.996716996)) (S0 := (-0.080964372)) (S1 := (-0.065555691))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket2 (u0 := 0.010441) (u1 := 0.0129) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt361 : errPtBracket 1.23 1.231 0.29273774 0.3076465 :=
  errPiece_sharp_taylor
    (C0 := (-0.996716997)) (C1 := (-0.995345944)) (S0 := (-0.096366233)) (S1 := (-0.080964371))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket2 (u0 := 0.0129) (u1 := 0.015361) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt362 : errPtBracket 1.231 1.232 0.29007253 0.30496205 :=
  errPiece_sharp_taylor
    (C0 := (-0.995345945)) (C1 := (-0.993735504)) (S0 := (-0.111757541)) (S1 := (-0.096366232))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket2 (u0 := 0.015361) (u1 := 0.017824) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt363 : errPtBracket 1.232 1.233 0.28737328 0.30224304 :=
  errPiece_sharp_taylor
    (C0 := (-0.993735505)) (C1 := (-0.99188548)) (S0 := (-0.127134549)) (S1 := (-0.11175754))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket2 (u0 := 0.017824) (u1 := 0.020289) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt364 : errPtBracket 1.233 1.234 0.28464063 0.29949011 :=
  errPiece_sharp_taylor
    (C0 := (-0.991885481)) (C1 := (-0.989795738)) (S0 := (-0.142493498)) (S1 := (-0.127134547))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket2 (u0 := 0.020289) (u1 := 0.022756) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt365 : errPtBracket 1.234 1.235 0.28187524 0.29670391 :=
  errPiece_sharp_taylor
    (C0 := (-0.989795739)) (C1 := (-0.987466199)) (S0 := (-0.15783062)) (S1 := (-0.142493497))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket2 (u0 := 0.022756) (u1 := 0.025225) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt366 : errPtBracket 1.235 1.236 0.27907774 0.29388507 :=
  errPiece_sharp_taylor
    (C0 := (-0.9874662)) (C1 := (-0.984896847)) (S0 := (-0.173142137)) (S1 := (-0.157830619))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket2 (u0 := 0.025225) (u1 := 0.027696) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt367 : errPtBracket 1.236 1.237 0.27624878 0.29103426 :=
  errPiece_sharp_taylor
    (C0 := (-0.984896848)) (C1 := (-0.982087724)) (S0 := (-0.188424259)) (S1 := (-0.173142135))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket2 (u0 := 0.027696) (u1 := 0.030169) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt368 : errPtBracket 1.237 1.238 0.27338902 0.28815212 :=
  errPiece_sharp_taylor
    (C0 := (-0.982087725)) (C1 := (-0.979038932)) (S0 := (-0.203673193)) (S1 := (-0.188424258))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket2 (u0 := 0.030169) (u1 := 0.032644) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt369 : errPtBracket 1.238 1.239 0.27049911 0.28523929 :=
  errPiece_sharp_taylor
    (C0 := (-0.979038933)) (C1 := (-0.975750633)) (S0 := (-0.218885135)) (S1 := (-0.203673191))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket2 (u0 := 0.032644) (u1 := 0.035121) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt370 : errPtBracket 1.239 1.24 0.2675797 0.28229644 :=
  errPiece_sharp_taylor
    (C0 := (-0.975750634)) (C1 := (-0.97222305)) (S0 := (-0.234056276)) (S1 := (-0.218885133))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket2 (u0 := 0.035121) (u1 := 0.0376) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt371 : errPtBracket 1.24 1.241 0.26463145 0.27932422 :=
  errPiece_sharp_taylor
    (C0 := (-0.972223051)) (C1 := (-0.968456467)) (S0 := (-0.249182804)) (S1 := (-0.234056275))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket2 (u0 := 0.0376) (u1 := 0.040081) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt372 : errPtBracket 1.241 1.242 0.26165502 0.27632329 :=
  errPiece_sharp_taylor
    (C0 := (-0.968456469)) (C1 := (-0.96445123)) (S0 := (-0.264260901)) (S1 := (-0.249182803))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket2 (u0 := 0.040081) (u1 := 0.042564) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt373 : errPtBracket 1.242 1.243 0.25865107 0.27329431 :=
  errPiece_sharp_taylor
    (C0 := (-0.964451231)) (C1 := (-0.960207745)) (S0 := (-0.279286745)) (S1 := (-0.264260899))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket2 (u0 := 0.042564) (u1 := 0.045049) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt374 : errPtBracket 1.243 1.244 0.25562026 0.27023793 :=
  errPiece_sharp_taylor
    (C0 := (-0.960207746)) (C1 := (-0.955726479)) (S0 := (-0.294256514)) (S1 := (-0.279286743))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket2 (u0 := 0.045049) (u1 := 0.047536) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt375 : errPtBracket 1.244 1.245 0.25256326 0.26715483 :=
  errPiece_sharp_taylor
    (C0 := (-0.955726481)) (C1 := (-0.951007964)) (S0 := (-0.309166383)) (S1 := (-0.294256512))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket2 (u0 := 0.047536) (u1 := 0.050025) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt376 : errPtBracket 1.245 1.246 0.24948073 0.26404567 :=
  errPiece_sharp_taylor
    (C0 := (-0.951007965)) (C1 := (-0.94605279)) (S0 := (-0.324012528)) (S1 := (-0.309166381))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket2 (u0 := 0.050025) (u1 := 0.052516) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt377 : errPtBracket 1.246 1.247 0.24637334 0.26091112 :=
  errPiece_sharp_taylor
    (C0 := (-0.946052791)) (C1 := (-0.940861612)) (S0 := (-0.338791126)) (S1 := (-0.324012527))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket2 (u0 := 0.052516) (u1 := 0.055009) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt378 : errPtBracket 1.247 1.248 0.24324175 0.25775183 :=
  errPiece_sharp_taylor
    (C0 := (-0.940861613)) (C1 := (-0.935435146)) (S0 := (-0.353498355)) (S1 := (-0.338791124))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket2 (u0 := 0.055009) (u1 := 0.057504) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt379 : errPtBracket 1.248 1.249 0.24008664 0.25456849 :=
  errPiece_sharp_taylor
    (C0 := (-0.935435147)) (C1 := (-0.929774172)) (S0 := (-0.368130395)) (S1 := (-0.353498353))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket2 (u0 := 0.057504) (u1 := 0.060001) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt380 : errPtBracket 1.249 1.25 0.23690868 0.25136176 :=
  errPiece_sharp_taylor
    (C0 := (-0.929774174)) (C1 := (-0.923879532)) (S0 := (-0.382683433)) (S1 := (-0.368130394))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket2 (u0 := 0.060001) (u1 := 0.0625) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt381 : errPtBracket 1.25 1.251 0.23370853 0.24813231 :=
  errPiece_sharp_taylor
    (C0 := (-0.923879533)) (C1 := (-0.91775213)) (S0 := (-0.397153658)) (S1 := (-0.382683431))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket2 (u0 := 0.0625) (u1 := 0.065001) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt382 : errPtBracket 1.251 1.252 0.23048688 0.24488082 :=
  errPiece_sharp_taylor
    (C0 := (-0.917752131)) (C1 := (-0.911392933)) (S0 := (-0.411537265)) (S1 := (-0.397153656))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket2 (u0 := 0.065001) (u1 := 0.067504) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt383 : errPtBracket 1.252 1.253 0.22724439 0.24160797 :=
  errPiece_sharp_taylor
    (C0 := (-0.911392935)) (C1 := (-0.904802973)) (S0 := (-0.425830458)) (S1 := (-0.411537264))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket2 (u0 := 0.067504) (u1 := 0.070009) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt384 : errPtBracket 1.253 1.254 0.22398174 0.23831442 :=
  errPiece_sharp_taylor
    (C0 := (-0.904802975)) (C1 := (-0.897983343)) (S0 := (-0.440029448)) (S1 := (-0.425830457))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket2 (u0 := 0.070009) (u1 := 0.072516) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt385 : errPtBracket 1.254 1.255 0.2206996 0.23500085 :=
  errPiece_sharp_taylor
    (C0 := (-0.897983345)) (C1 := (-0.8909352)) (S0 := (-0.454130454)) (S1 := (-0.440029446))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket2 (u0 := 0.072516) (u1 := 0.075025) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt386 : errPtBracket 1.255 1.256 0.21739866 0.23166794 :=
  errPiece_sharp_taylor
    (C0 := (-0.890935201)) (C1 := (-0.883659764)) (S0 := (-0.468129706)) (S1 := (-0.454130452))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket2 (u0 := 0.075025) (u1 := 0.077536) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt387 : errPtBracket 1.256 1.257 0.21407958 0.22831637 :=
  errPiece_sharp_taylor
    (C0 := (-0.883659765)) (C1 := (-0.876158317)) (S0 := (-0.482023446)) (S1 := (-0.468129704))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket2 (u0 := 0.077536) (u1 := 0.080049) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt388 : errPtBracket 1.257 1.258 0.21074305 0.22494681 :=
  errPiece_sharp_taylor
    (C0 := (-0.876158319)) (C1 := (-0.868432208)) (S0 := (-0.495807927)) (S1 := (-0.482023444))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket2 (u0 := 0.080049) (u1 := 0.082564) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt389 : errPtBracket 1.258 1.259 0.20738974 0.22155995 :=
  errPiece_sharp_taylor
    (C0 := (-0.86843221)) (C1 := (-0.860482844)) (S0 := (-0.509479415)) (S1 := (-0.495807925))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket2 (u0 := 0.082564) (u1 := 0.085081) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt390 : errPtBracket 1.259 1.26 0.20402033 0.21815646 :=
  errPiece_sharp_taylor
    (C0 := (-0.860482846)) (C1 := (-0.8523117)) (S0 := (-0.523034192)) (S1 := (-0.509479413))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket2 (u0 := 0.085081) (u1 := 0.0876) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt391 : errPtBracket 1.26 1.261 0.2006355 0.21473702 :=
  errPiece_sharp_taylor
    (C0 := (-0.852311702)) (C1 := (-0.84392031)) (S0 := (-0.536468554)) (S1 := (-0.52303419))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket2 (u0 := 0.0876) (u1 := 0.090121) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt392 : errPtBracket 1.261 1.262 0.19723593 0.21130231 :=
  errPiece_sharp_taylor
    (C0 := (-0.843920313)) (C1 := (-0.835310275)) (S0 := (-0.549778815)) (S1 := (-0.536468552))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket2 (u0 := 0.090121) (u1 := 0.092644) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt393 : errPtBracket 1.262 1.263 0.19382229 0.20785301 :=
  errPiece_sharp_taylor
    (C0 := (-0.835310277)) (C1 := (-0.826483255)) (S0 := (-0.562961304)) (S1 := (-0.549778813))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket2 (u0 := 0.092644) (u1 := 0.095169) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt394 : errPtBracket 1.263 1.264 0.19039527 0.20438981 :=
  errPiece_sharp_taylor
    (C0 := (-0.826483258)) (C1 := (-0.817440975)) (S0 := (-0.576012372)) (S1 := (-0.562961302))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket2 (u0 := 0.095169) (u1 := 0.097696) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt395 : errPtBracket 1.264 1.266 0.17832247 0.20611127 :=
  errPiece_sharp_taylor
    (C0 := (-0.817440979)) (C1 := (-0.798717851)) (S0 := (-0.601705738)) (S1 := (-0.57601237))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket2 (u0 := 0.097696) (u1 := 0.102756) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt396 : errPtBracket 1.266 1.268 0.1714338 0.19907318 :=
  errPiece_sharp_taylor
    (C0 := (-0.798717856)) (C1 := (-0.779155951)) (S0 := (-0.626830124)) (S1 := (-0.601705736))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket2 (u0 := 0.102756) (u1 := 0.107824) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt397 : errPtBracket 1.268 1.27 0.16450479 0.19199067 :=
  errPiece_sharp_taylor
    (C0 := (-0.779155959)) (C1 := (-0.758771324)) (S0 := (-0.651357105)) (S1 := (-0.626830121))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket2 (u0 := 0.107824) (u1 := 0.1129) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt398 : errPtBracket 1.27 1.272 0.15754085 0.18486919 :=
  errPiece_sharp_taylor
    (C0 := (-0.758771335)) (C1 := (-0.737581005)) (S0 := (-0.675258663)) (S1 := (-0.651357103))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket2 (u0 := 0.1129) (u1 := 0.117984) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt399 : errPtBracket 1.272 1.274 0.15054735 0.17771415 :=
  errPiece_sharp_taylor
    (C0 := (-0.73758102)) (C1 := (-0.715603011)) (S0 := (-0.698507217)) (S1 := (-0.675258661))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket2 (u0 := 0.117984) (u1 := 0.123076) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt400 : errPtBracket 1.274 1.275 0.15200832 0.16557083 :=
  errPiece_sharp_taylor
    (C0 := (-0.715603034)) (C1 := (-0.704324533)) (S0 := (-0.709878126)) (S1 := (-0.698507214))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket2 (u0 := 0.123076) (u1 := 0.125625) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt401 : errPtBracket 1.275 1.276 0.14847346 0.16199366 :=
  errPiece_sharp_taylor
    (C0 := (-0.704324561)) (C1 := (-0.692856334)) (S0 := (-0.721075657)) (S1 := (-0.709878123))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket2 (u0 := 0.125625) (u1 := 0.128176) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt402 : errPtBracket 1.276 1.278 0.1364932 0.16332506 :=
  errPiece_sharp_taylor
    (C0 := (-0.692856368)) (C1 := (-0.669360926)) (S0 := (-0.742937383)) (S1 := (-0.721075653))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket2 (u0 := 0.128176) (u1 := 0.133284) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt403 : errPtBracket 1.278 1.28 0.12944324 0.15610178 :=
  errPiece_sharp_taylor
    (C0 := (-0.669360975)) (C1 := (-0.645137692)) (S0 := (-0.764066336)) (S1 := (-0.742937378))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket2 (u0 := 0.133284) (u1 := 0.1384) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt404 : errPtBracket 1.28 1.282 0.12238512 0.1488665 :=
  errPiece_sharp_taylor
    (C0 := (-0.645137762)) (C1 := (-0.620208473)) (S0 := (-0.784437035)) (S1 := (-0.764066329))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket2 (u0 := 0.1384) (u1 := 0.143524) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt405 : errPtBracket 1.282 1.284 0.11532411 0.14162455 :=
  errPiece_sharp_taylor
    (C0 := (-0.620208573)) (C1 := (-0.594596037)) (S0 := (-0.804024608)) (S1 := (-0.784437025))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket2 (u0 := 0.143524) (u1 := 0.148656) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt406 : errPtBracket 1.284 1.286 0.10826546 0.13438123 :=
  errPiece_sharp_taylor
    (C0 := (-0.594596179)) (C1 := (-0.56832406)) (S0 := (-0.822804831)) (S1 := (-0.804024594))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket2 (u0 := 0.148656) (u1 := 0.153796) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt407 : errPtBracket 1.286 1.289 0.09303484 0.13181931 :=
  errPiece_sharp_taylor
    (C0 := (-0.568324258)) (C1 := (-0.527733436)) (S0 := (-0.84941007)) (S1 := (-0.822804812))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket2 (u0 := 0.153796) (u1 := 0.161521) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt408 : errPtBracket 1.289 1.292 0.08256303 0.12091297 :=
  errPiece_sharp_taylor
    (C0 := (-0.527733758)) (C1 := (-0.485800917)) (S0 := (-0.874069534)) (S1 := (-0.849410039))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket2 (u0 := 0.161521) (u1 := 0.169264) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt409 : errPtBracket 1.292 1.294 0.08015829 0.10549926 :=
  errPiece_sharp_taylor
    (C0 := (-0.48580143)) (C1 := (-0.45714511)) (S0 := (-0.889392188)) (S1 := (-0.874069483))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket2 (u0 := 0.169264) (u1 := 0.174436) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt410 : errPtBracket 1.294 1.296 0.07318892 0.0983275 :=
  errPiece_sharp_taylor
    (C0 := (-0.457145802)) (C1 := (-0.427961156)) (S0 := (-0.903797218)) (S1 := (-0.889392118))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket2 (u0 := 0.174436) (u1 := 0.179616) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt411 : errPtBracket 1.296 1.298 0.06625256 0.09118544 :=
  errPiece_sharp_taylor
    (C0 := (-0.427962082)) (C1 := (-0.398277795)) (S0 := (-0.91726497)) (S1 := (-0.903797122))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket2 (u0 := 0.179616) (u1 := 0.184804) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt412 : errPtBracket 1.298 1.3 0.05935417 0.0840781 :=
  errPiece_sharp_taylor
    (C0 := (-0.398279025)) (C1 := (-0.368124534)) (S0 := (-0.929776661)) (S1 := (-0.917264838))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket2 (u0 := 0.184804) (u1 := 0.19) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt413 : errPtBracket 1.3 1.303 0.04472926 0.08138752 :=
  errPiece_sharp_taylor
    (C0 := (-0.368126157)) (C1 := (-0.322079951)) (S0 := (-0.946712734)) (S1 := (-0.929776483))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket2 (u0 := 0.19) (u1 := 0.197809) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt414 : errPtBracket 1.303 1.308 0.01943908 0.07941416 :=
  errPiece_sharp_taylor
    (C0 := (-0.322082378)) (C1 := (-0.243428067)) (S0 := (-0.969919486)) (S1 := (-0.946712459))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket2 (u0 := 0.197809) (u1 := 0.210864) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt415 : errPtBracket 1.308 1.312 0.01066612 0.05765437 :=
  errPiece_sharp_taylor
    (C0 := (-0.243432662)) (C1 := (-0.179079599)) (S0 := (-0.983835501)) (S1 := (-0.969918931))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket2 (u0 := 0.210864) (u1 := 0.221344) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt416 : errPtBracket 1.312 1.317 (-0.00934377) 0.0480906 :=
  errPiece_sharp_taylor
    (C0 := (-0.179087062)) (C1 := (-0.097304064)) (S0 := (-0.995256434)) (S1 := (-0.983834556))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket2 (u0 := 0.221344) (u1 := 0.234489) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt417 : errPtBracket 1.317 1.322 (-0.02465815) 0.03130892 :=
  errPiece_sharp_taylor
    (C0 := (-0.097317349)) (C1 := (-0.014550927)) (S0 := (-0.999897323)) (S1 := (-0.995254654))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket2 (u0 := 0.234489) (u1 := 0.247684) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

theorem errPt418 : errPtBracket 1.322 1.326 (-0.04506155) 0.02271074 :=
  errPiece_crude_taylor (by norm_num) (by norm_num)
    (by norm_num [taylorQup, siDivPart, Finset.sum_range_succ])
    (by norm_num [taylorQ, siDivPart, Finset.sum_range_succ])

theorem errPt419 : errPtBracket 1.326 1.331 (-0.05078406) 0.00249367 :=
  errPiece_sharp_taylor
    (C0 := 0.05197621) (C1 := 0.135057763) (S0 := (-0.998648324)) (S1 := (-0.990837726))
    (by norm_num) (by norm_num)
    (fun r hr0 hr1 => trigBracket3 (u0 := 0.008276) (u1 := 0.021561) (j := (1:ℤ))
      (by norm_num) (by norm_num)
      (by push_cast; linarith) (by push_cast; linarith)
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP])
      (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]) (by norm_num [cosLoP, cosHiP, sinLoP, sinHiP]))
    (by norm_num) (by norm_num) (by norm_num [siLoSharp])
    (by norm_num [aLoSharp, siLoSharp, taylorQ, siDivPart, Finset.sum_range_succ])
    (by norm_num [aHiSharp, siHiSharp, taylorQup, siDivPart, Finset.sum_range_succ])

end ConnesConsani.WeilPositivity
