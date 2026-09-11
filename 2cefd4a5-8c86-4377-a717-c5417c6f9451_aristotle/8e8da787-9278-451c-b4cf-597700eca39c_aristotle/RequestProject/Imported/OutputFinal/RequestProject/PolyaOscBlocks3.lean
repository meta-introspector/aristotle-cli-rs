/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.
-/
import RequestProject.Imported.OutputFinal.RequestProject.PolyaOscBlocks2

/-!
# Oscillatory blocks, part 3

Signed integral brackets for the blocks of group 3.
-/

set_option maxHeartbeats 1000000

noncomputable section

open MeasureTheory Set Real

namespace ConnesConsani.WeilPositivity

/-- Signed integral bracket for block 25: the `q`-range `[1.173, 1.18]`. -/
theorem oscBlock25 : errIntBracket (vBP 1.173) (vBP 1.18) 0.00355404 0.00389782 0.00389782 := by
  refine errIntBracket.mono
    ((((((((((((((errPiece_taylor (q0 := 1.173) (q1 := 1.1735) (Lo := 0.35133772) (Hi := 0.38535032) (M := 0.38535032)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num)).add
    (errPiece_taylor (q0 := 1.1735) (q1 := 1.174) (Lo := 0.35140697) (Hi := 0.38541576) (M := 0.38541576)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.174) (q1 := 1.1745) (Lo := 0.35146031) (Hi := 0.38546524) (M := 0.38546524)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.1745) (q1 := 1.175) (Lo := 0.3514978) (Hi := 0.38549882) (M := 0.38549882)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.175) (q1 := 1.1755) (Lo := 0.3515195) (Hi := 0.38551657) (M := 0.38551657)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.1755) (q1 := 1.176) (Lo := 0.35152547) (Hi := 0.38551853) (M := 0.38551853)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.176) (q1 := 1.1765) (Lo := 0.35151575) (Hi := 0.38550476) (M := 0.38550476)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.1765) (q1 := 1.177) (Lo := 0.35149042) (Hi := 0.38547533) (M := 0.38547533)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.177) (q1 := 1.1775) (Lo := 0.35144952) (Hi := 0.38543028) (M := 0.38543028)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.1775) (q1 := 1.178) (Lo := 0.35139312) (Hi := 0.38536969) (M := 0.38536969)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.178) (q1 := 1.1785) (Lo := 0.35132128) (Hi := 0.3852936) (M := 0.3852936)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.1785) (q1 := 1.179) (Lo := 0.35123405) (Hi := 0.38520208) (M := 0.38520208)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.179) (q1 := 1.1795) (Lo := 0.35113149) (Hi := 0.38509518) (M := 0.38509518)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.1795) (q1 := 1.18) (Lo := 0.35101367) (Hi := 0.38497297) (M := 0.38497297)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num)))
    (by norm_num) (by norm_num) (by norm_num)

/-- Signed integral bracket for block 26: the `q`-range `[1.18, 1.187]`. -/
theorem oscBlock26 : errIntBracket (vBP 1.18) (vBP 1.187) 0.00349368 0.00383277 0.00383277 := by
  refine errIntBracket.mono
    ((((((((((((((errPiece_taylor (q0 := 1.18) (q1 := 1.1805) (Lo := 0.35088064) (Hi := 0.3848355) (M := 0.3848355)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num)).add
    (errPiece_taylor (q0 := 1.1805) (q1 := 1.181) (Lo := 0.35073246) (Hi := 0.38468283) (M := 0.38468283)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.181) (q1 := 1.1815) (Lo := 0.3505692) (Hi := 0.38451503) (M := 0.38451503)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.1815) (q1 := 1.182) (Lo := 0.35039091) (Hi := 0.38433215) (M := 0.38433215)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.182) (q1 := 1.1825) (Lo := 0.35019766) (Hi := 0.38413425) (M := 0.38413425)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.1825) (q1 := 1.183) (Lo := 0.3499895) (Hi := 0.3839214) (M := 0.3839214)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.183) (q1 := 1.1835) (Lo := 0.34976651) (Hi := 0.38369366) (M := 0.38369366)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.1835) (q1 := 1.184) (Lo := 0.34952873) (Hi := 0.38345109) (M := 0.38345109)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.184) (q1 := 1.1845) (Lo := 0.34927623) (Hi := 0.38319374) (M := 0.38319374)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.1845) (q1 := 1.185) (Lo := 0.34900908) (Hi := 0.38292169) (M := 0.38292169)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.185) (q1 := 1.1855) (Lo := 0.34872733) (Hi := 0.38263499) (M := 0.38263499)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.1855) (q1 := 1.186) (Lo := 0.34843105) (Hi := 0.3823337) (M := 0.3823337)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.186) (q1 := 1.1865) (Lo := 0.3481203) (Hi := 0.3820179) (M := 0.3820179)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.1865) (q1 := 1.187) (Lo := 0.34779515) (Hi := 0.38168764) (M := 0.38168764)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num)))
    (by norm_num) (by norm_num) (by norm_num)

/-- Signed integral bracket for block 27: the `q`-range `[1.187, 1.194]`. -/
theorem oscBlock27 : errIntBracket (vBP 1.187) (vBP 1.194) 0.00340593 0.00374034 0.00374034 := by
  refine errIntBracket.mono
    ((((((((((((((errPiece_taylor (q0 := 1.187) (q1 := 1.1875) (Lo := 0.34745565) (Hi := 0.38134298) (M := 0.38134298)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num)).add
    (errPiece_taylor (q0 := 1.1875) (q1 := 1.188) (Lo := 0.34710188) (Hi := 0.38098399) (M := 0.38098399)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.188) (q1 := 1.1885) (Lo := 0.34673389) (Hi := 0.38061073) (M := 0.38061073)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.1885) (q1 := 1.189) (Lo := 0.34635175) (Hi := 0.38022327) (M := 0.38022327)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.189) (q1 := 1.1895) (Lo := 0.34595553) (Hi := 0.37982167) (M := 0.37982167)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.1895) (q1 := 1.19) (Lo := 0.34554529) (Hi := 0.379406) (M := 0.379406)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.19) (q1 := 1.1905) (Lo := 0.34512109) (Hi := 0.37897631) (M := 0.37897631)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.1905) (q1 := 1.191) (Lo := 0.34468299) (Hi := 0.37853268) (M := 0.37853268)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.191) (q1 := 1.1915) (Lo := 0.34423108) (Hi := 0.37807517) (M := 0.37807517)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.1915) (q1 := 1.192) (Lo := 0.3437654) (Hi := 0.37760384) (M := 0.37760384)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.192) (q1 := 1.1925) (Lo := 0.34328603) (Hi := 0.37711876) (M := 0.37711876)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.1925) (q1 := 1.193) (Lo := 0.34279303) (Hi := 0.37662) (M := 0.37662)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.193) (q1 := 1.1935) (Lo := 0.34228647) (Hi := 0.37610762) (M := 0.37610762)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.1935) (q1 := 1.194) (Lo := 0.34176641) (Hi := 0.37558169) (M := 0.37558169)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num)))
    (by norm_num) (by norm_num) (by norm_num)

/-- Signed integral bracket for block 28: the `q`-range `[1.194, 1.201]`. -/
theorem oscBlock28 : errIntBracket (vBP 1.194) (vBP 1.201) 0.00325635 0.0036604 0.0036604 := by
  refine errIntBracket.mono
    (((((((errPiece_taylor (q0 := 1.194) (q1 := 1.195) (Lo := 0.3371508) (Hi := 0.37858266) (M := 0.37858266)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num)).add
    (errPiece_taylor (q0 := 1.195) (q1 := 1.196) (Lo := 0.33603201) (Hi := 0.37744895) (M := 0.37744895)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.196) (q1 := 1.197) (Lo := 0.33486056) (Hi := 0.37626214) (M := 0.37626214)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.197) (q1 := 1.198) (Lo := 0.33363698) (Hi := 0.37502277) (M := 0.37502277)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.198) (q1 := 1.199) (Lo := 0.33236182) (Hi := 0.37373139) (M := 0.37373139)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.199) (q1 := 1.2) (Lo := 0.33103564) (Hi := 0.37238855) (M := 0.37238855)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.2) (q1 := 1.201) (Lo := 0.32965899) (Hi := 0.37099479) (M := 0.37099479)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num)))
    (by norm_num) (by norm_num) (by norm_num)

/-- Signed integral bracket for block 29: the `q`-range `[1.201, 1.208]`. -/
theorem oscBlock29 : errIntBracket (vBP 1.201) (vBP 1.208) 0.00312242 0.0035206 0.0035206 := by
  refine errIntBracket.mono
    (((((((errPiece_taylor (q0 := 1.201) (q1 := 1.202) (Lo := 0.32823244) (Hi := 0.36955068) (M := 0.36955068)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num)).add
    (errPiece_taylor (q0 := 1.202) (q1 := 1.203) (Lo := 0.32675653) (Hi := 0.36805677) (M := 0.36805677)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.203) (q1 := 1.204) (Lo := 0.32523185) (Hi := 0.36651363) (M := 0.36651363)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.204) (q1 := 1.205) (Lo := 0.32365895) (Hi := 0.36492182) (M := 0.36492182)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.205) (q1 := 1.206) (Lo := 0.32203842) (Hi := 0.36328191) (M := 0.36328191)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.206) (q1 := 1.207) (Lo := 0.32037082) (Hi := 0.36159447) (M := 0.36159447)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.207) (q1 := 1.208) (Lo := 0.31865674) (Hi := 0.35986009) (M := 0.35986009)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num)))
    (by norm_num) (by norm_num) (by norm_num)

/-- Signed integral bracket for block 30: the `q`-range `[1.208, 1.215]`. -/
theorem oscBlock30 : errIntBracket (vBP 1.208) (vBP 1.215) 0.0029691 0.00336131 0.00336131 := by
  refine errIntBracket.mono
    (((((((errPiece_taylor (q0 := 1.208) (q1 := 1.209) (Lo := 0.31689675) (Hi := 0.35807934) (M := 0.35807934)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num)).add
    (errPiece_taylor (q0 := 1.209) (q1 := 1.21) (Lo := 0.31509145) (Hi := 0.3562528) (M := 0.3562528)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.21) (q1 := 1.211) (Lo := 0.31324143) (Hi := 0.35438106) (M := 0.35438106)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.211) (q1 := 1.212) (Lo := 0.31134726) (Hi := 0.35246471) (M := 0.35246471)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.212) (q1 := 1.213) (Lo := 0.30940956) (Hi := 0.35050434) (M := 0.35050434)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.213) (q1 := 1.214) (Lo := 0.30742891) (Hi := 0.34850055) (M := 0.34850055)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.214) (q1 := 1.215) (Lo := 0.30540591) (Hi := 0.34645393) (M := 0.34645393)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num)))
    (by norm_num) (by norm_num) (by norm_num)

/-- Signed integral bracket for block 31: the `q`-range `[1.215, 1.223]`. -/
theorem oscBlock31 : errIntBracket (vBP 1.215) (vBP 1.223) 0.00318409 0.00362486 0.00362486 := by
  refine errIntBracket.mono
    ((((((((errPiece_taylor (q0 := 1.215) (q1 := 1.216) (Lo := 0.30334118) (Hi := 0.34436509) (M := 0.34436509)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num)).add
    (errPiece_taylor (q0 := 1.216) (q1 := 1.217) (Lo := 0.30123531) (Hi := 0.34223463) (M := 0.34223463)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.217) (q1 := 1.218) (Lo := 0.29908892) (Hi := 0.34006315) (M := 0.34006315)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.218) (q1 := 1.219) (Lo := 0.29690261) (Hi := 0.33785127) (M := 0.33785127)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.219) (q1 := 1.22) (Lo := 0.294677) (Hi := 0.3355996) (M := 0.3355996)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.22) (q1 := 1.221) (Lo := 0.2924127) (Hi := 0.33330875) (M := 0.33330875)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.221) (q1 := 1.222) (Lo := 0.29011034) (Hi := 0.33097934) (M := 0.33097934)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.222) (q1 := 1.223) (Lo := 0.28777054) (Hi := 0.32861199) (M := 0.32861199)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num)))
    (by norm_num) (by norm_num) (by norm_num)

/-- Signed integral bracket for block 32: the `q`-range `[1.223, 1.231]`. -/
theorem oscBlock32 : errIntBracket (vBP 1.223) (vBP 1.231) 0.00294094 0.0033736 0.0033736 := by
  refine errIntBracket.mono
    ((((((((errPiece_taylor (q0 := 1.223) (q1 := 1.224) (Lo := 0.28539391) (Hi := 0.32620732) (M := 0.32620732)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num)).add
    (errPiece_taylor (q0 := 1.224) (q1 := 1.225) (Lo := 0.2829811) (Hi := 0.32376595) (M := 0.32376595)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.225) (q1 := 1.226) (Lo := 0.28053271) (Hi := 0.32128852) (M := 0.32128852)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.226) (q1 := 1.227) (Lo := 0.27804939) (Hi := 0.31877565) (M := 0.31877565)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.227) (q1 := 1.228) (Lo := 0.27553177) (Hi := 0.31622797) (M := 0.31622797)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.228) (q1 := 1.229) (Lo := 0.27298048) (Hi := 0.31364612) (M := 0.31364612)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.229) (q1 := 1.23) (Lo := 0.27039615) (Hi := 0.31103073) (M := 0.31103073)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.23) (q1 := 1.231) (Lo := 0.26777943) (Hi := 0.30838244) (M := 0.30838244)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num)))
    (by norm_num) (by norm_num) (by norm_num)

/-- Signed integral bracket for block 33: the `q`-range `[1.231, 1.239]`. -/
theorem oscBlock33 : errIntBracket (vBP 1.231) (vBP 1.239) 0.002681 0.00310538 0.00310538 := by
  refine errIntBracket.mono
    ((((((((errPiece_taylor (q0 := 1.231) (q1 := 1.232) (Lo := 0.26513096) (Hi := 0.30570189) (M := 0.30570189)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num)).add
    (errPiece_taylor (q0 := 1.232) (q1 := 1.233) (Lo := 0.26245138) (Hi := 0.30298971) (M := 0.30298971)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.233) (q1 := 1.234) (Lo := 0.25974132) (Hi := 0.30024656) (M := 0.30024656)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.234) (q1 := 1.235) (Lo := 0.25700145) (Hi := 0.29747307) (M := 0.29747307)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.235) (q1 := 1.236) (Lo := 0.2542324) (Hi := 0.29466989) (M := 0.29466989)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.236) (q1 := 1.237) (Lo := 0.25143482) (Hi := 0.29183768) (M := 0.29183768)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.237) (q1 := 1.238) (Lo := 0.24860936) (Hi := 0.28897707) (M := 0.28897707)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.238) (q1 := 1.239) (Lo := 0.24575667) (Hi := 0.28608872) (M := 0.28608872)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num)))
    (by norm_num) (by norm_num) (by norm_num)

/-- Signed integral bracket for block 34: the `q`-range `[1.239, 1.248]`. -/
theorem oscBlock34 : errIntBracket (vBP 1.239) (vBP 1.248) 0.00268977 0.0031571 0.0031571 := by
  refine errIntBracket.mono
    (((((((((errPiece_taylor (q0 := 1.239) (q1 := 1.24) (Lo := 0.2428774) (Hi := 0.28317329) (M := 0.28317329)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num)).add
    (errPiece_taylor (q0 := 1.24) (q1 := 1.241) (Lo := 0.23997222) (Hi := 0.28023142) (M := 0.28023142)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.241) (q1 := 1.242) (Lo := 0.23704176) (Hi := 0.27726376) (M := 0.27726376)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.242) (q1 := 1.243) (Lo := 0.2340867) (Hi := 0.27427098) (M := 0.27427098)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.243) (q1 := 1.244) (Lo := 0.23110767) (Hi := 0.27125373) (M := 0.27125373)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.244) (q1 := 1.245) (Lo := 0.22810535) (Hi := 0.26821267) (M := 0.26821267)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.245) (q1 := 1.246) (Lo := 0.22508038) (Hi := 0.26514845) (M := 0.26514845)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.246) (q1 := 1.247) (Lo := 0.22203343) (Hi := 0.26206174) (M := 0.26206174)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.247) (q1 := 1.248) (Lo := 0.21896516) (Hi := 0.25895319) (M := 0.25895319)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num)))
    (by norm_num) (by norm_num) (by norm_num)

/-- Signed integral bracket for block 35: the `q`-range `[1.248, 1.258]`. -/
theorem oscBlock35 : errIntBracket (vBP 1.248) (vBP 1.258) 0.00256957 0.00307603 0.00307603 := by
  refine errIntBracket.mono
    ((((((((((errPiece_taylor (q0 := 1.248) (q1 := 1.249) (Lo := 0.21587622) (Hi := 0.25582347) (M := 0.25582347)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num)).add
    (errPiece_taylor (q0 := 1.249) (q1 := 1.25) (Lo := 0.21276728) (Hi := 0.25267323) (M := 0.25267323)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.25) (q1 := 1.251) (Lo := 0.20963899) (Hi := 0.24950313) (M := 0.24950313)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.251) (q1 := 1.252) (Lo := 0.20649202) (Hi := 0.24631384) (M := 0.24631384)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.252) (q1 := 1.253) (Lo := 0.20332702) (Hi := 0.24310602) (M := 0.24310602)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.253) (q1 := 1.254) (Lo := 0.20014467) (Hi := 0.23988034) (M := 0.23988034)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.254) (q1 := 1.255) (Lo := 0.19694561) (Hi := 0.23663744) (M := 0.23663744)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.255) (q1 := 1.256) (Lo := 0.19373052) (Hi := 0.233378) (M := 0.233378)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.256) (q1 := 1.257) (Lo := 0.19050005) (Hi := 0.23010268) (M := 0.23010268)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.257) (q1 := 1.258) (Lo := 0.18725486) (Hi := 0.22681214) (M := 0.22681214)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num)))
    (by norm_num) (by norm_num) (by norm_num)

/-- Signed integral bracket for block 36: the `q`-range `[1.258, 1.268]`. -/
theorem oscBlock36 : errIntBracket (vBP 1.258) (vBP 1.268) 0.00208704 0.00264808 0.00264808 := by
  refine errIntBracket.mono
    ((((((((errPiece_taylor (q0 := 1.258) (q1 := 1.259) (Lo := 0.18399561) (Hi := 0.22350704) (M := 0.22350704)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num)).add
    (errPiece_taylor (q0 := 1.259) (q1 := 1.26) (Lo := 0.18072296) (Hi := 0.22018804) (M := 0.22018804)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.26) (q1 := 1.261) (Lo := 0.17743757) (Hi := 0.21685581) (M := 0.21685581)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.261) (q1 := 1.262) (Lo := 0.17414011) (Hi := 0.21351099) (M := 0.21351099)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.262) (q1 := 1.263) (Lo := 0.17083122) (Hi := 0.21015427) (M := 0.21015427)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.263) (q1 := 1.264) (Lo := 0.16751156) (Hi := 0.20678628) (M := 0.20678628)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.264) (q1 := 1.266) (Lo := 0.15567146) (Hi := 0.20859771) (M := 0.20859771)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.266) (q1 := 1.268) (Lo := 0.14901511) (Hi := 0.20176347) (M := 0.20176347)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num)))
    (by norm_num) (by norm_num) (by norm_num)

/-- Signed integral bracket for block 37: the `q`-range `[1.268, 1.28]`. -/
theorem oscBlock37 : errIntBracket (vBP 1.268) (vBP 1.28) 0.00187294 0.00261048 0.00261048 := by
  refine errIntBracket.mono
    (((((((errPiece_taylor (q0 := 1.268) (q1 := 1.27) (Lo := 0.14232841) (Hi := 0.19489508) (M := 0.19489508)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num)).add
    (errPiece_taylor (q0 := 1.27) (q1 := 1.272) (Lo := 0.13561656) (Hi := 0.18799777) (M := 0.18799777)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.272) (q1 := 1.274) (Lo := 0.12888473) (Hi := 0.18107675) (M := 0.18107675)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.274) (q1 := 1.275) (Lo := 0.13047179) (Hi := 0.16918304) (M := 0.16918304)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.275) (q1 := 1.276) (Lo := 0.12707381) (Hi := 0.16573102) (M := 0.16573102)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.276) (q1 := 1.278) (Lo := 0.11538168) (Hi := 0.16718433) (M := 0.16718433)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.278) (q1 := 1.28) (Lo := 0.10862066) (Hi := 0.16022322) (M := 0.16022322)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num)))
    (by norm_num) (by norm_num) (by norm_num)

/-- Signed integral bracket for block 38: the `q`-range `[1.28, 1.294]`. -/
theorem oscBlock38 : errIntBracket (vBP 1.28) (vBP 1.294) 0.00133656 0.0022862 0.0022862 := by
  refine errIntBracket.mono
    ((((((errPiece_taylor (q0 := 1.28) (q1 := 1.282) (Lo := 0.10186004) (Hi := 0.15325898) (M := 0.15325898)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num)).add
    (errPiece_taylor (q0 := 1.282) (q1 := 1.284) (Lo := 0.09510483) (Hi := 0.14629669) (M := 0.14629669)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.284) (q1 := 1.286) (Lo := 0.08836) (Hi := 0.13934136) (M := 0.13934136)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.286) (q1 := 1.289) (Lo := 0.07361939) (Hi := 0.13707236) (M := 0.13707236)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.289) (q1 := 1.292) (Lo := 0.06364815) (Hi := 0.12662522) (M := 0.12662522)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.292) (q1 := 1.294) (Lo := 0.06158204) (Hi := 0.1116887) (M := 0.1116887)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num)))
    (by norm_num) (by norm_num) (by norm_num)

/-- Signed integral bracket for block 39: the `q`-range `[1.294, 1.308]`. -/
theorem oscBlock39 : errIntBracket (vBP 1.294) (vBP 1.308) 0.00046376 0.00152768 0.00152768 := by
  refine errIntBracket.mono
    (((((errPiece_taylor (q0 := 1.294) (q1 := 1.296) (Lo := 0.05496184) (Hi := 0.10484201) (M := 0.10484201)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num)).add
    (errPiece_taylor (q0 := 1.296) (q1 := 1.298) (Lo := 0.04838075) (Hi := 0.09803145) (M := 0.09803145)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.298) (q1 := 1.3) (Lo := 0.04184334) (Hi := 0.0912617) (M := 0.0912617)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.3) (q1 := 1.303) (Lo := 0.02777087) (Hi := 0.08891493) (M := 0.08891493)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.303) (q1 := 1.308) (Lo := 0.00342128) (Hi := 0.08747042) (M := 0.08747042)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num)))
    (by norm_num) (by norm_num) (by norm_num)

/-- Signed integral bracket for block 40: the `q`-range `[1.308, 1.326]`. -/
theorem oscBlock40 : errIntBracket (vBP 1.308) (vBP 1.326) (-0.00058163) 0.00098954 0.00109154 := by
  refine errIntBracket.mono
    ((((errPiece_taylor (q0 := 1.308) (q1 := 1.312) (Lo := (-0.00458261)) (Hi := 0.06660983) (M := 0.06660983)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num)).add
    (errPiece_taylor (q0 := 1.312) (q1 := 1.317) (Lo := (-0.02361739)) (Hi := 0.05778836) (M := 0.05778836)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.317) (q1 := 1.322) (Lo := (-0.03794305)) (Hi := 0.04194716) (M := 0.04194716)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.322) (q1 := 1.326) (Lo := (-0.04506155)) (Hi := 0.02271074) (M := 0.04506155)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num)))
    (by norm_num) (by norm_num) (by norm_num)

/-- Signed integral bracket for block 41: the `q`-range `[1.326, 1.345]`. -/
theorem oscBlock41 : errIntBracket (vBP 1.326) (vBP 1.345) (-0.00166554) (-0.0001141) 0.00166554 := by
  refine errIntBracket.mono
    ((((errPiece_taylor (q0 := 1.326) (q1 := 1.331) (Lo := (-0.06225621)) (Hi := 0.01483871) (M := 0.06225621)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num)).add
    (errPiece_taylor (q0 := 1.331) (q1 := 1.336) (Lo := (-0.07485387)) (Hi := 0.00065953) (M := 0.07485387)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.336) (q1 := 1.34) (Lo := (-0.08072995)) (Hi := (-0.01652067)) (M := 0.08072995)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.34) (q1 := 1.345) (Lo := (-0.09571715)) (Hi := (-0.02308046)) (M := 0.09571715)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num)))
    (by norm_num) (by norm_num) (by norm_num)

end ConnesConsani.WeilPositivity
