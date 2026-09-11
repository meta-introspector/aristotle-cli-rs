/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.
-/
import RequestProject.Imported.OutputFinal.RequestProject.PolyaOscBlocks1

/-!
# Oscillatory blocks, part 2

Signed integral brackets for the blocks of group 2.
-/

set_option maxHeartbeats 1000000

noncomputable section

open MeasureTheory Set Real

namespace ConnesConsani.WeilPositivity

/-- Signed integral bracket for block 10: the `q`-range `[1.048, 1.055]`. -/
theorem oscBlock10 : errIntBracket (vBP 1.048) (vBP 1.055) (-0.003065) (-0.00254007) 0.003065 := by
  refine errIntBracket.mono
    (((((((errPiece_taylor (q0 := 1.048) (q1 := 1.049) (Lo := (-0.27235644)) (Hi := (-0.2308891)) (M := 0.27235644)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num)).add
    (errPiece_taylor (q0 := 1.049) (q1 := 1.05) (Lo := (-0.26207972)) (Hi := (-0.22061697)) (M := 0.26207972)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.05) (q1 := 1.051) (Lo := (-0.25189371)) (Hi := (-0.21043524)) (M := 0.25189371)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.051) (q1 := 1.052) (Lo := (-0.24179835)) (Hi := (-0.20034384)) (M := 0.24179835)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.052) (q1 := 1.053) (Lo := (-0.23179357)) (Hi := (-0.19034271)) (M := 0.23179357)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.053) (q1 := 1.054) (Lo := (-0.22187929)) (Hi := (-0.18043178)) (M := 0.22187929)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.054) (q1 := 1.055) (Lo := (-0.21205546)) (Hi := (-0.17061099)) (M := 0.21205546)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num)))
    (by norm_num) (by norm_num) (by norm_num)

/-- Signed integral bracket for block 11: the `q`-range `[1.055, 1.064]`. -/
theorem oscBlock11 : errIntBracket (vBP 1.055) (vBP 1.064) (-0.00266646) (-0.00195145) 0.00266646 := by
  refine errIntBracket.mono
    ((((((((errPiece_taylor (q0 := 1.055) (q1 := 1.056) (Lo := (-0.202322)) (Hi := (-0.16088027)) (M := 0.202322)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num)).add
    (errPiece_taylor (q0 := 1.056) (q1 := 1.057) (Lo := (-0.19267883)) (Hi := (-0.15123957)) (M := 0.19267883)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.057) (q1 := 1.058) (Lo := (-0.1831259)) (Hi := (-0.14168882)) (M := 0.1831259)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.058) (q1 := 1.059) (Lo := (-0.17366313)) (Hi := (-0.13222794)) (M := 0.17366313)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.059) (q1 := 1.06) (Lo := (-0.16429044)) (Hi := (-0.12285687)) (M := 0.16429044)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.06) (q1 := 1.061) (Lo := (-0.15500776)) (Hi := (-0.11357555)) (M := 0.15500776)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.061) (q1 := 1.062) (Lo := (-0.14581502)) (Hi := (-0.1043839)) (M := 0.14581502)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.062) (q1 := 1.064) (Lo := (-0.13935959)) (Hi := (-0.08363956)) (M := 0.13935959)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num)))
    (by norm_num) (by norm_num) (by norm_num)

/-- Signed integral bracket for block 12: the `q`-range `[1.064, 1.078]`. -/
theorem oscBlock12 : errIntBracket (vBP 1.064) (vBP 1.078) (-0.00186022) (-0.00025024) 0.00186022 := by
  refine errIntBracket.mono
    ((((((errPiece_taylor (q0 := 1.064) (q1 := 1.066) (Lo := (-0.12151719)) (Hi := (-0.06578849)) (M := 0.12151719)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num)).add
    (errPiece_taylor (q0 := 1.066) (q1 := 1.068) (Lo := (-0.1040337)) (Hi := (-0.04829424)) (M := 0.1040337)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.068) (q1 := 1.069) (Lo := (-0.0839776)) (Hi := (-0.04254719)) (M := 0.0839776)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.069) (q1 := 1.072) (Lo := (-0.08150032)) (Hi := (-0.01140659)) (M := 0.08150032)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.072) (q1 := 1.074) (Lo := (-0.05372985)) (Hi := 0.00205347) (M := 0.05372985)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.074) (q1 := 1.078) (Lo := (-0.04423539)) (Hi := 0.04031507) (M := 0.04423539)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num)))
    (by norm_num) (by norm_num) (by norm_num)

/-- Signed integral bracket for block 13: the `q`-range `[1.078, 1.09]`. -/
theorem oscBlock13 : errIntBracket (vBP 1.078) (vBP 1.09) 0.00052905 0.00181854 0.00181854 := by
  refine errIntBracket.mono
    (((((errPiece_taylor (q0 := 1.078) (q1 := 1.08) (Lo := (-0.00663053)) (Hi := 0.04921224) (M := 0.04921224)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num)).add
    (errPiece_taylor (q0 := 1.08) (q1 := 1.083) (Lo := 0.00481294) (Hi := 0.07509968) (M := 0.07509968)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.083) (q1 := 1.086) (Lo := 0.02649388) (Hi := 0.09684526) (M := 0.09684526)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.086) (q1 := 1.088) (Lo := 0.05122171) (Hi := 0.10716382) (M := 0.10716382)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.088) (q1 := 1.09) (Lo := 0.06480744) (Hi := 0.12077737) (M := 0.12077737)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num)))
    (by norm_num) (by norm_num) (by norm_num)

/-- Signed integral bracket for block 14: the `q`-range `[1.09, 1.1]`. -/
theorem oscBlock14 : errIntBracket (vBP 1.09) (vBP 1.1) 0.00179141 0.00258123 0.00258123 := by
  refine errIntBracket.mono
    ((((((((errPiece_taylor (q0 := 1.09) (q1 := 1.092) (Lo := 0.07804421) (Hi := 0.13404297) (M := 0.13404297)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num)).add
    (errPiece_taylor (q0 := 1.092) (q1 := 1.094) (Lo := 0.09093307) (Hi := 0.14696159) (M := 0.14696159)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.094) (q1 := 1.095) (Lo := 0.10765942) (Hi := 0.14916695) (M := 0.14916695)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.095) (q1 := 1.096) (Lo := 0.11384921) (Hi := 0.15536137) (M := 0.15536137)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.096) (q1 := 1.097) (Lo := 0.11995271) (Hi := 0.16146958) (M := 0.16146958)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.097) (q1 := 1.098) (Lo := 0.12597007) (Hi := 0.16749171) (M := 0.16749171)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.098) (q1 := 1.099) (Lo := 0.13190143) (Hi := 0.1734279) (M := 0.1734279)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.099) (q1 := 1.1) (Lo := 0.13774695) (Hi := 0.17927831) (M := 0.17927831)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num)))
    (by norm_num) (by norm_num) (by norm_num)

/-- Signed integral bracket for block 15: the `q`-range `[1.1, 1.109]`. -/
theorem oscBlock15 : errIntBracket (vBP 1.1) (vBP 1.109) 0.00243971 0.00305289 0.00305289 := by
  refine errIntBracket.mono
    (((((((((errPiece_taylor (q0 := 1.1) (q1 := 1.101) (Lo := 0.14350679) (Hi := 0.18504308) (M := 0.18504308)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num)).add
    (errPiece_taylor (q0 := 1.101) (q1 := 1.102) (Lo := 0.14918109) (Hi := 0.19072237) (M := 0.19072237)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.102) (q1 := 1.103) (Lo := 0.15477003) (Hi := 0.19631632) (M := 0.19631632)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.103) (q1 := 1.104) (Lo := 0.16027376) (Hi := 0.2018251) (M := 0.2018251)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.104) (q1 := 1.105) (Lo := 0.16569246) (Hi := 0.20724887) (M := 0.20724887)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.105) (q1 := 1.106) (Lo := 0.17102628) (Hi := 0.21258779) (M := 0.21258779)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.106) (q1 := 1.107) (Lo := 0.17627542) (Hi := 0.21784204) (M := 0.21784204)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.107) (q1 := 1.108) (Lo := 0.18144003) (Hi := 0.22301177) (M := 0.22301177)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.108) (q1 := 1.109) (Lo := 0.18652032) (Hi := 0.22809718) (M := 0.22809718)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num)))
    (by norm_num) (by norm_num) (by norm_num)

/-- Signed integral bracket for block 16: the `q`-range `[1.109, 1.117]`. -/
theorem oscBlock16 : errIntBracket (vBP 1.109) (vBP 1.117) 0.00268761 0.00322493 0.00322493 := by
  refine errIntBracket.mono
    ((((((((errPiece_taylor (q0 := 1.109) (q1 := 1.11) (Lo := 0.19151644) (Hi := 0.23309843) (M := 0.23309843)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num)).add
    (errPiece_taylor (q0 := 1.11) (q1 := 1.111) (Lo := 0.19642861) (Hi := 0.23801571) (M := 0.23801571)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.111) (q1 := 1.112) (Lo := 0.201257) (Hi := 0.2428492) (M := 0.2428492)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.112) (q1 := 1.113) (Lo := 0.20600181) (Hi := 0.24759909) (M := 0.24759909)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.113) (q1 := 1.114) (Lo := 0.21066323) (Hi := 0.25226557) (M := 0.25226557)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.114) (q1 := 1.115) (Lo := 0.21524148) (Hi := 0.25684885) (M := 0.25684885)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.115) (q1 := 1.116) (Lo := 0.21973674) (Hi := 0.26134911) (M := 0.26134911)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.116) (q1 := 1.117) (Lo := 0.22414924) (Hi := 0.26576655) (M := 0.26576655)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num)))
    (by norm_num) (by norm_num) (by norm_num)

/-- Signed integral bracket for block 17: the `q`-range `[1.117, 1.124]`. -/
theorem oscBlock17 : errIntBracket (vBP 1.117) (vBP 1.124) 0.00268494 0.00314923 0.00314923 := by
  refine errIntBracket.mono
    (((((((errPiece_taylor (q0 := 1.117) (q1 := 1.118) (Lo := 0.22847918) (Hi := 0.2701014) (M := 0.2701014)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num)).add
    (errPiece_taylor (q0 := 1.118) (q1 := 1.119) (Lo := 0.23272678) (Hi := 0.27435385) (M := 0.27435385)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.119) (q1 := 1.12) (Lo := 0.23689226) (Hi := 0.27852412) (M := 0.27852412)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.12) (q1 := 1.121) (Lo := 0.24097584) (Hi := 0.28261244) (M := 0.28261244)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.121) (q1 := 1.122) (Lo := 0.24497776) (Hi := 0.28661901) (M := 0.28661901)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.122) (q1 := 1.123) (Lo := 0.24889823) (Hi := 0.29054406) (M := 0.29054406)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.123) (q1 := 1.124) (Lo := 0.25273749) (Hi := 0.29438783) (M := 0.29438783)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num)))
    (by norm_num) (by norm_num) (by norm_num)

/-- Signed integral bracket for block 18: the `q`-range `[1.124, 1.131]`. -/
theorem oscBlock18 : errIntBracket (vBP 1.124) (vBP 1.131) 0.00294155 0.00340044 0.00340044 := by
  refine errIntBracket.mono
    (((((((errPiece_taylor (q0 := 1.124) (q1 := 1.125) (Lo := 0.25649579) (Hi := 0.29815055) (M := 0.29815055)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num)).add
    (errPiece_taylor (q0 := 1.125) (q1 := 1.126) (Lo := 0.26017337) (Hi := 0.30183245) (M := 0.30183245)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.126) (q1 := 1.127) (Lo := 0.26377046) (Hi := 0.30543377) (M := 0.30543377)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.127) (q1 := 1.128) (Lo := 0.26728734) (Hi := 0.30895477) (M := 0.30895477)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.128) (q1 := 1.129) (Lo := 0.27072423) (Hi := 0.31239568) (M := 0.31239568)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.129) (q1 := 1.13) (Lo := 0.27408142) (Hi := 0.31575677) (M := 0.31575677)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.13) (q1 := 1.131) (Lo := 0.27735915) (Hi := 0.31903828) (M := 0.31903828)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num)))
    (by norm_num) (by norm_num) (by norm_num)

/-- Signed integral bracket for block 19: the `q`-range `[1.131, 1.138]`. -/
theorem oscBlock19 : errIntBracket (vBP 1.131) (vBP 1.138) 0.00314903 0.00360255 0.00360255 := by
  refine errIntBracket.mono
    (((((((errPiece_taylor (q0 := 1.131) (q1 := 1.132) (Lo := 0.2805577) (Hi := 0.32224048) (M := 0.32224048)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num)).add
    (errPiece_taylor (q0 := 1.132) (q1 := 1.133) (Lo := 0.28367733) (Hi := 0.32536364) (M := 0.32536364)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.133) (q1 := 1.134) (Lo := 0.28671833) (Hi := 0.32840803) (M := 0.32840803)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.134) (q1 := 1.135) (Lo := 0.28968096) (Hi := 0.33137391) (M := 0.33137391)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.135) (q1 := 1.136) (Lo := 0.29256552) (Hi := 0.33426156) (M := 0.33426156)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.136) (q1 := 1.137) (Lo := 0.29537229) (Hi := 0.33707128) (M := 0.33707128)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.137) (q1 := 1.138) (Lo := 0.29810156) (Hi := 0.33980334) (M := 0.33980334)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num)))
    (by norm_num) (by norm_num) (by norm_num)

/-- Signed integral bracket for block 20: the `q`-range `[1.138, 1.145]`. -/
theorem oscBlock20 : errIntBracket (vBP 1.138) (vBP 1.145) 0.0033448 0.00372358 0.00372358 := by
  refine errIntBracket.mono
    (((((((((((((errPiece_taylor (q0 := 1.138) (q1 := 1.139) (Lo := 0.30075363) (Hi := 0.34245803) (M := 0.34245803)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num)).add
    (errPiece_taylor (q0 := 1.139) (q1 := 1.1395) (Lo := 0.30645655) (Hi := 0.34063519) (M := 0.34063519)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.1395) (q1 := 1.14) (Lo := 0.30772619) (Hi := 0.34190349) (M := 0.34190349)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.14) (q1 := 1.1405) (Lo := 0.3089767) (Hi := 0.34315264) (M := 0.34315264)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.1405) (q1 := 1.141) (Lo := 0.31020811) (Hi := 0.34438265) (M := 0.34438265)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.141) (q1 := 1.1415) (Lo := 0.31142045) (Hi := 0.34559357) (M := 0.34559357)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.1415) (q1 := 1.142) (Lo := 0.31261377) (Hi := 0.34678545) (M := 0.34678545)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.142) (q1 := 1.1425) (Lo := 0.31378811) (Hi := 0.34795831) (M := 0.34795831)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.1425) (q1 := 1.143) (Lo := 0.3149435) (Hi := 0.3491122) (M := 0.3491122)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.143) (q1 := 1.1435) (Lo := 0.31607998) (Hi := 0.35024716) (M := 0.35024716)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.1435) (q1 := 1.144) (Lo := 0.3171976) (Hi := 0.35136322) (M := 0.35136322)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.144) (q1 := 1.1445) (Lo := 0.3182964) (Hi := 0.35246043) (M := 0.35246043)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.1445) (q1 := 1.145) (Lo := 0.31937641) (Hi := 0.35353883) (M := 0.35353883)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num)))
    (by norm_num) (by norm_num) (by norm_num)

/-- Signed integral bracket for block 21: the `q`-range `[1.145, 1.152]`. -/
theorem oscBlock21 : errIntBracket (vBP 1.145) (vBP 1.152) 0.00346772 0.00383018 0.00383018 := by
  refine errIntBracket.mono
    ((((((((((((((errPiece_taylor (q0 := 1.145) (q1 := 1.1455) (Lo := 0.32043767) (Hi := 0.35459846) (M := 0.35459846)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num)).add
    (errPiece_taylor (q0 := 1.1455) (q1 := 1.146) (Lo := 0.32148024) (Hi := 0.35563935) (M := 0.35563935)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.146) (q1 := 1.1465) (Lo := 0.32250414) (Hi := 0.35666155) (M := 0.35666155)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.1465) (q1 := 1.147) (Lo := 0.32350943) (Hi := 0.3576651) (M := 0.3576651)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.147) (q1 := 1.1475) (Lo := 0.32449613) (Hi := 0.35865004) (M := 0.35865004)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.1475) (q1 := 1.148) (Lo := 0.3254643) (Hi := 0.35961642) (M := 0.35961642)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.148) (q1 := 1.1485) (Lo := 0.32641398) (Hi := 0.36056428) (M := 0.36056428)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.1485) (q1 := 1.149) (Lo := 0.32734521) (Hi := 0.36149365) (M := 0.36149365)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.149) (q1 := 1.1495) (Lo := 0.32825803) (Hi := 0.36240458) (M := 0.36240458)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.1495) (q1 := 1.15) (Lo := 0.32915248) (Hi := 0.36329712) (M := 0.36329712)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.15) (q1 := 1.1505) (Lo := 0.33002862) (Hi := 0.3641713) (M := 0.3641713)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.1505) (q1 := 1.151) (Lo := 0.33088648) (Hi := 0.36502717) (M := 0.36502717)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.151) (q1 := 1.1515) (Lo := 0.33172611) (Hi := 0.36586478) (M := 0.36586478)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.1515) (q1 := 1.152) (Lo := 0.33254754) (Hi := 0.36668417) (M := 0.36668417)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num)))
    (by norm_num) (by norm_num) (by norm_num)

/-- Signed integral bracket for block 22: the `q`-range `[1.152, 1.159]`. -/
theorem oscBlock22 : errIntBracket (vBP 1.152) (vBP 1.159) 0.0035439 0.00390167 0.00390167 := by
  refine errIntBracket.mono
    ((((((((((((((errPiece_taylor (q0 := 1.152) (q1 := 1.1525) (Lo := 0.33335084) (Hi := 0.36748538) (M := 0.36748538)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num)).add
    (errPiece_taylor (q0 := 1.1525) (q1 := 1.153) (Lo := 0.33413603) (Hi := 0.36826846) (M := 0.36826846)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.153) (q1 := 1.1535) (Lo := 0.33490318) (Hi := 0.36903345) (M := 0.36903345)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.1535) (q1 := 1.154) (Lo := 0.33565231) (Hi := 0.36978039) (M := 0.36978039)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.154) (q1 := 1.1545) (Lo := 0.33638348) (Hi := 0.37050934) (M := 0.37050934)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.1545) (q1 := 1.155) (Lo := 0.33709674) (Hi := 0.37122034) (M := 0.37122034)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.155) (q1 := 1.1555) (Lo := 0.33779212) (Hi := 0.37191344) (M := 0.37191344)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.1555) (q1 := 1.156) (Lo := 0.33846968) (Hi := 0.37258867) (M := 0.37258867)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.156) (q1 := 1.1565) (Lo := 0.33912947) (Hi := 0.37324609) (M := 0.37324609)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.1565) (q1 := 1.157) (Lo := 0.33977153) (Hi := 0.37388574) (M := 0.37388574)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.157) (q1 := 1.1575) (Lo := 0.3403959) (Hi := 0.37450768) (M := 0.37450768)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.1575) (q1 := 1.158) (Lo := 0.34100264) (Hi := 0.37511195) (M := 0.37511195)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.158) (q1 := 1.1585) (Lo := 0.34159179) (Hi := 0.37569859) (M := 0.37569859)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.1585) (q1 := 1.159) (Lo := 0.34216341) (Hi := 0.37626765) (M := 0.37626765)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num)))
    (by norm_num) (by norm_num) (by norm_num)

/-- Signed integral bracket for block 23: the `q`-range `[1.159, 1.166]`. -/
theorem oscBlock23 : errIntBracket (vBP 1.159) (vBP 1.166) 0.00358187 0.00393497 0.00393497 := by
  refine errIntBracket.mono
    ((((((((((((((errPiece_taylor (q0 := 1.159) (q1 := 1.1595) (Lo := 0.34271753) (Hi := 0.37681919) (M := 0.37681919)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num)).add
    (errPiece_taylor (q0 := 1.1595) (q1 := 1.16) (Lo := 0.34325422) (Hi := 0.37735325) (M := 0.37735325)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.16) (q1 := 1.1605) (Lo := 0.34377351) (Hi := 0.37786987) (M := 0.37786987)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.1605) (q1 := 1.161) (Lo := 0.34427546) (Hi := 0.37836912) (M := 0.37836912)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.161) (q1 := 1.1615) (Lo := 0.34476011) (Hi := 0.37885103) (M := 0.37885103)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.1615) (q1 := 1.162) (Lo := 0.34522753) (Hi := 0.37931567) (M := 0.37931567)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.162) (q1 := 1.1625) (Lo := 0.34567775) (Hi := 0.37976306) (M := 0.37976306)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.1625) (q1 := 1.163) (Lo := 0.34611082) (Hi := 0.38019328) (M := 0.38019328)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.163) (q1 := 1.1635) (Lo := 0.34652681) (Hi := 0.38060636) (M := 0.38060636)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.1635) (q1 := 1.164) (Lo := 0.34692575) (Hi := 0.38100237) (M := 0.38100237)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.164) (q1 := 1.1645) (Lo := 0.34730771) (Hi := 0.38138134) (M := 0.38138134)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.1645) (q1 := 1.165) (Lo := 0.34767273) (Hi := 0.38174333) (M := 0.38174333)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.165) (q1 := 1.1655) (Lo := 0.34802086) (Hi := 0.38208839) (M := 0.38208839)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.1655) (q1 := 1.166) (Lo := 0.34835215) (Hi := 0.38241658) (M := 0.38241658)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num)))
    (by norm_num) (by norm_num) (by norm_num)

/-- Signed integral bracket for block 24: the `q`-range `[1.166, 1.173]`. -/
theorem oscBlock24 : errIntBracket (vBP 1.166) (vBP 1.173) 0.00358434 0.00393278 0.00393278 := by
  refine errIntBracket.mono
    ((((((((((((((errPiece_taylor (q0 := 1.166) (q1 := 1.1665) (Lo := 0.34866667) (Hi := 0.38272795) (M := 0.38272795)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num)).add
    (errPiece_taylor (q0 := 1.1665) (q1 := 1.167) (Lo := 0.34896445) (Hi := 0.38302254) (M := 0.38302254)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.167) (q1 := 1.1675) (Lo := 0.34924556) (Hi := 0.38330041) (M := 0.38330041)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.1675) (q1 := 1.168) (Lo := 0.34951004) (Hi := 0.38356162) (M := 0.38356162)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.168) (q1 := 1.1685) (Lo := 0.34975796) (Hi := 0.38380621) (M := 0.38380621)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.1685) (q1 := 1.169) (Lo := 0.34998936) (Hi := 0.38403425) (M := 0.38403425)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.169) (q1 := 1.1695) (Lo := 0.35020429) (Hi := 0.38424578) (M := 0.38424578)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.1695) (q1 := 1.17) (Lo := 0.35040282) (Hi := 0.38444085) (M := 0.38444085)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.17) (q1 := 1.1705) (Lo := 0.350585) (Hi := 0.38461953) (M := 0.38461953)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.1705) (q1 := 1.171) (Lo := 0.35075088) (Hi := 0.38478187) (M := 0.38478187)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.171) (q1 := 1.1715) (Lo := 0.35090051) (Hi := 0.38492791) (M := 0.38492791)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.1715) (q1 := 1.172) (Lo := 0.35103395) (Hi := 0.38505773) (M := 0.38505773)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.172) (q1 := 1.1725) (Lo := 0.35115127) (Hi := 0.38517136) (M := 0.38517136)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.1725) (q1 := 1.173) (Lo := 0.3512525) (Hi := 0.38526887) (M := 0.38526887)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num)))
    (by norm_num) (by norm_num) (by norm_num)

end ConnesConsani.WeilPositivity
