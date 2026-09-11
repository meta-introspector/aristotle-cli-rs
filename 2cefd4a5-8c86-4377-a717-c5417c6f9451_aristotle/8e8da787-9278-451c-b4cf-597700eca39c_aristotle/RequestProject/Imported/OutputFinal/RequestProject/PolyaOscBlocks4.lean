/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.
-/
import RequestProject.Imported.OutputFinal.RequestProject.PolyaOscBlocks3

/-!
# Oscillatory blocks, part 4

Signed integral brackets for the blocks of group 4.
-/

set_option maxHeartbeats 1000000

noncomputable section

open MeasureTheory Set Real

namespace ConnesConsani.WeilPositivity

/-- Signed integral bracket for block 42: the `q`-range `[1.345, 1.362]`. -/
theorem oscBlock42 : errIntBracket (vBP 1.345) (vBP 1.362) (-0.00197692) (-0.00110062) 0.00197692 := by
  refine errIntBracket.mono
    (((((((errPiece_taylor (q0 := 1.345) (q1 := 1.348) (Lo := (-0.09499499)) (Hi := (-0.04231024)) (M := 0.09499499)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num)).add
    (errPiece_taylor (q0 := 1.348) (q1 := 1.35) (Lo := (-0.09564444)) (Hi := (-0.05262056)) (M := 0.09564444)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.35) (q1 := 1.352) (Lo := (-0.09971587)) (Hi := (-0.05695203)) (M := 0.09971587)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.352) (q1 := 1.355) (Lo := (-0.1090217)) (Hi := (-0.05768953)) (M := 0.1090217)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.355) (q1 := 1.358) (Lo := (-0.11453227)) (Hi := (-0.06377264)) (M := 0.11453227)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.358) (q1 := 1.36) (Lo := (-0.11465889)) (Hi := (-0.07291484)) (M := 0.11465889)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.36) (q1 := 1.362) (Lo := (-0.11805189)) (Hi := (-0.07655595)) (M := 0.11805189)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num)))
    (by norm_num) (by norm_num) (by norm_num)

/-- Signed integral bracket for block 43: the `q`-range `[1.362, 1.376]`. -/
theorem oscBlock43 : errIntBracket (vBP 1.362) (vBP 1.376) (-0.001966) (-0.00130937) 0.001966 := by
  refine errIntBracket.mono
    ((((((errPiece_taylor (q0 := 1.362) (q1 := 1.364) (Lo := (-0.12130546)) (Hi := (-0.08005413)) (M := 0.12130546)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num)).add
    (errPiece_taylor (q0 := 1.364) (q1 := 1.366) (Lo := (-0.12441874)) (Hi := (-0.08340807)) (M := 0.12441874)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.366) (q1 := 1.369) (Lo := (-0.13207853)) (Hi := (-0.08335287)) (M := 0.13207853)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.369) (q1 := 1.372) (Lo := (-0.13612606)) (Hi := (-0.08792983)) (M := 0.13612606)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.372) (q1 := 1.374) (Lo := (-0.13545666)) (Hi := (-0.09535959)) (M := 0.13545666)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.374) (q1 := 1.376) (Lo := (-0.13786075)) (Hi := (-0.09797708)) (M := 0.13786075)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num)))
    (by norm_num) (by norm_num) (by norm_num)

/-- Signed integral bracket for block 44: the `q`-range `[1.376, 1.39]`. -/
theorem oscBlock44 : errIntBracket (vBP 1.376) (vBP 1.39) (-0.00215585) (-0.00153865) 0.00215585 := by
  refine errIntBracket.mono
    ((((((errPiece_taylor (q0 := 1.376) (q1 := 1.378) (Lo := (-0.14012264)) (Hi := (-0.10044514)) (M := 0.14012264)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num)).add
    (errPiece_taylor (q0 := 1.378) (q1 := 1.38) (Lo := (-0.14224261)) (Hi := (-0.10276335)) (M := 0.14224261)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.38) (q1 := 1.383) (Lo := (-0.14823953)) (Hi := (-0.1018422)) (M := 0.14823953)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.383) (q1 := 1.386) (Lo := (-0.15080422)) (Hi := (-0.10484722)) (M := 0.15080422)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.386) (q1 := 1.388) (Lo := (-0.14931532)) (Hi := (-0.11053405)) (M := 0.14931532)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.388) (q1 := 1.39) (Lo := (-0.15073637)) (Hi := (-0.11210136)) (M := 0.15073637)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num)))
    (by norm_num) (by norm_num) (by norm_num)

/-- Signed integral bracket for block 45: the `q`-range `[1.39, 1.404]`. -/
theorem oscBlock45 : errIntBracket (vBP 1.39) (vBP 1.404) (-0.00224032) (-0.00165324) 0.00224032 := by
  refine errIntBracket.mono
    ((((((errPiece_taylor (q0 := 1.39) (q1 := 1.392) (Lo := (-0.15202112)) (Hi := (-0.11351905)) (M := 0.15202112)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num)).add
    (errPiece_taylor (q0 := 1.392) (q1 := 1.394) (Lo := (-0.1531712)) (Hi := (-0.11478757)) (M := 0.1531712)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.394) (q1 := 1.397) (Lo := (-0.15757723)) (Hi := (-0.11297223)) (M := 0.15757723)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.397) (q1 := 1.4) (Lo := (-0.15873194)) (Hi := (-0.1144056)) (M := 0.15873194)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.4) (q1 := 1.402) (Lo := (-0.15646489)) (Hi := (-0.11838361)) (M := 0.15646489)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.402) (q1 := 1.404) (Lo := (-0.15697364)) (Hi := (-0.11891752)) (M := 0.15697364)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num)))
    (by norm_num) (by norm_num) (by norm_num)

/-- Signed integral bracket for block 46: the `q`-range `[1.404, 1.418]`. -/
theorem oscBlock46 : errIntBracket (vBP 1.404) (vBP 1.418) (-0.0022337) (-0.00166196) 0.0022337 := by
  refine errIntBracket.mono
    ((((((errPiece_taylor (q0 := 1.404) (q1 := 1.406) (Lo := (-0.15736215)) (Hi := (-0.11930755)) (M := 0.15736215)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num)).add
    (errPiece_taylor (q0 := 1.406) (q1 := 1.408) (Lo := (-0.15763365)) (Hi := (-0.11955495)) (M := 0.15763365)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.408) (q1 := 1.411) (Lo := (-0.16062393)) (Hi := (-0.11686047)) (M := 0.16062393)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.411) (q1 := 1.414) (Lo := (-0.16055041)) (Hi := (-0.11678455)) (M := 0.16055041)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.414) (q1 := 1.416) (Lo := (-0.15762364)) (Hi := (-0.1191471)) (M := 0.15762364)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.416) (q1 := 1.418) (Lo := (-0.15736813)) (Hi := (-0.11870378)) (M := 0.15736813)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num)))
    (by norm_num) (by norm_num) (by norm_num)

/-- Signed integral bracket for block 47: the `q`-range `[1.418, 1.432]`. -/
theorem oscBlock47 : errIntBracket (vBP 1.418) (vBP 1.432) (-0.00215703) (-0.00157674) 0.00215703 := by
  refine errIntBracket.mono
    ((((((errPiece_taylor (q0 := 1.418) (q1 := 1.42) (Lo := (-0.15702085)) (Hi := (-0.1181274)) (M := 0.15702085)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num)).add
    (errPiece_taylor (q0 := 1.42) (q1 := 1.422) (Lo := (-0.15658709)) (Hi := (-0.11741986)) (M := 0.15658709)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.422) (q1 := 1.425) (Lo := (-0.15846232)) (Hi := (-0.11389936)) (M := 0.15846232)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.425) (q1 := 1.428) (Lo := (-0.15747677)) (Hi := (-0.11242929)) (M := 0.15747677)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.428) (q1 := 1.43) (Lo := (-0.15410509)) (Hi := (-0.11331806)) (M := 0.15410509)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.43) (q1 := 1.432) (Lo := (-0.15333062)) (Hi := (-0.11198517)) (M := 0.15333062)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num)))
    (by norm_num) (by norm_num) (by norm_num)

/-- Signed integral bracket for block 48: the `q`-range `[1.432, 1.446]`. -/
theorem oscBlock48 : errIntBracket (vBP 1.432) (vBP 1.446) (-0.00203955) (-0.00141153) 0.00203955 := by
  refine errIntBracket.mono
    ((((((errPiece_taylor (q0 := 1.432) (q1 := 1.434) (Lo := (-0.15250911)) (Hi := (-0.11053363)) (M := 0.15250911)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num)).add
    (errPiece_taylor (q0 := 1.434) (q1 := 1.436) (Lo := (-0.15164858)) (Hi := (-0.10896568)) (M := 0.15164858)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.436) (q1 := 1.439) (Lo := (-0.15287227)) (Hi := (-0.10470061)) (M := 0.15287227)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.439) (q1 := 1.442) (Lo := (-0.15146786)) (Hi := (-0.10198793)) (M := 0.15146786)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.442) (q1 := 1.444) (Lo := (-0.14799455)) (Hi := (-0.10157452)) (M := 0.14799455)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.444) (q1 := 1.446) (Lo := (-0.14707732)) (Hi := (-0.09945804)) (M := 0.14707732)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num)))
    (by norm_num) (by norm_num) (by norm_num)

/-- Signed integral bracket for block 49: the `q`-range `[1.446, 1.462]`. -/
theorem oscBlock49 : errIntBracket (vBP 1.446) (vBP 1.462) (-0.00218663) (-0.00132878) 0.00218663 := by
  refine errIntBracket.mono
    (((((((errPiece_taylor (q0 := 1.446) (q1 := 1.448) (Lo := (-0.14618038)) (Hi := (-0.09723845)) (M := 0.14618038)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num)).add
    (errPiece_taylor (q0 := 1.448) (q1 := 1.45) (Lo := (-0.14531574)) (Hi := (-0.09491789)) (M := 0.14531574)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.45) (q1 := 1.453) (Lo := (-0.14657726)) (Hi := (-0.09000202)) (M := 0.14657726)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.453) (q1 := 1.456) (Lo := (-0.14549587)) (Hi := (-0.0862084)) (M := 0.14549587)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.456) (q1 := 1.458) (Lo := (-0.14244637)) (Hi := (-0.08466545)) (M := 0.14244637)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.458) (q1 := 1.46) (Lo := (-0.14194996)) (Hi := (-0.08186886)) (M := 0.14194996)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_taylor (q0 := 1.46) (q1 := 1.462) (Lo := (-0.14157449)) (Hi := (-0.07898205)) (M := 0.14157449)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num)))
    (by norm_num) (by norm_num) (by norm_num)

/-- Signed integral bracket for block 50: the `q`-range `[1.462, 1.478]`. -/
theorem oscBlock50 : errIntBracket (vBP 1.462) (vBP 1.478) (-0.00209905) 0.00039459 0.00209905 := by
  refine errIntBracket.mono
    ((((((errPiece_taylor (q0 := 1.462) (q1 := 1.464) (Lo := (-0.14133798)) (Hi := (-0.07600635)) (M := 0.14133798)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num)).add
    (errPiece_taylor (q0 := 1.464) (q1 := 1.467) (Lo := (-0.14365848)) (Hi := (-0.07052054)) (M := 0.14365848)
      (by norm_num) (by norm_num) (by norm_num [taylorQup_eq]) (by norm_num [taylorQ_eq]) (by norm_num) (by norm_num))).add
    (errPiece_asymp (q0 := 1.467) (q1 := 1.47) (Lo := (-0.1432413)) (Hi := 0.07345163) (M := 0.1432413)
      (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num))).add
    (errPiece_asymp (q0 := 1.47) (q1 := 1.472) (Lo := (-0.14078848)) (Hi := 0.07138846) (M := 0.14078848)
      (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num))).add
    (errPiece_asymp (q0 := 1.472) (q1 := 1.476) (Lo := (-0.14174317)) (Hi := 0.0731781) (M := 0.14174317)
      (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num))).add
    (errPiece_asymp (q0 := 1.476) (q1 := 1.478) (Lo := (-0.13790617)) (Hi := 0.06973564) (M := 0.13790617)
      (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)))
    (by norm_num) (by norm_num) (by norm_num)

/-- Signed integral bracket for block 51: the `q`-range `[1.478, 1.495]`. -/
theorem oscBlock51 : errIntBracket (vBP 1.478) (vBP 1.495) (-0.00207223) 0.00105538 0.00207223 := by
  refine errIntBracket.mono
    ((((((errPiece_asymp (q0 := 1.478) (q1 := 1.481) (Lo := (-0.13790266)) (Hi := 0.07035769) (M := 0.13790266)
      (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)).add
    (errPiece_asymp (q0 := 1.481) (q1 := 1.484) (Lo := (-0.13648972)) (Hi := 0.06956896) (M := 0.13648972)
      (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num))).add
    (errPiece_asymp (q0 := 1.484) (q1 := 1.486) (Lo := (-0.13417585)) (Hi := 0.06767546) (M := 0.13417585)
      (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num))).add
    (errPiece_asymp (q0 := 1.486) (q1 := 1.49) (Lo := (-0.13508223)) (Hi := 0.06941787) (M := 0.13508223)
      (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num))).add
    (errPiece_asymp (q0 := 1.49) (q1 := 1.492) (Lo := (-0.13145981)) (Hi := 0.06623024) (M := 0.13145981)
      (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num))).add
    (errPiece_asymp (q0 := 1.492) (q1 := 1.495) (Lo := (-0.13146003)) (Hi := 0.06686091) (M := 0.13146003)
      (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)))
    (by norm_num) (by norm_num) (by norm_num)

/-- Signed integral bracket for block 52: the `q`-range `[1.495, 1.512]`. -/
theorem oscBlock52 : errIntBracket (vBP 1.495) (vBP 1.512) (-0.00192131) 0.0009826 0.00192131 := by
  refine errIntBracket.mono
    (((((errPiece_asymp (q0 := 1.495) (q1 := 1.498) (Lo := (-0.13012833)) (Hi := 0.06616946) (M := 0.13012833)
      (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)).add
    (errPiece_asymp (q0 := 1.498) (q1 := 1.5) (Lo := (-0.12794335)) (Hi := 0.06442604) (M := 0.12794335)
      (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num))).add
    (errPiece_asymp (q0 := 1.5) (q1 := 1.504) (Lo := (-0.12880547)) (Hi := 0.06611826) (M := 0.12880547)
      (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num))).add
    (errPiece_asymp (q0 := 1.504) (q1 := 1.508) (Lo := (-0.1270789)) (Hi := 0.06525066) (M := 0.1270789)
      (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num))).add
    (errPiece_asymp (q0 := 1.508) (q1 := 1.512) (Lo := (-0.12538094)) (Hi := 0.06441386) (M := 0.12538094)
      (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)))
    (by norm_num) (by norm_num) (by norm_num)

/-- Signed integral bracket for block 53: the `q`-range `[1.512, 1.531]`. -/
theorem oscBlock53 : errIntBracket (vBP 1.512) (vBP 1.531) (-0.00197876) 0.00101835 0.00197876 := by
  refine errIntBracket.mono
    (((((errPiece_asymp (q0 := 1.512) (q1 := 1.516) (Lo := (-0.123711)) (Hi := 0.06360655) (M := 0.123711)
      (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)).add
    (errPiece_asymp (q0 := 1.516) (q1 := 1.52) (Lo := (-0.12206856)) (Hi := 0.06282747) (M := 0.12206856)
      (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num))).add
    (errPiece_asymp (q0 := 1.52) (q1 := 1.524) (Lo := (-0.12045306)) (Hi := 0.06207545) (M := 0.12045306)
      (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num))).add
    (errPiece_asymp (q0 := 1.524) (q1 := 1.528) (Lo := (-0.11886399)) (Hi := 0.06134932) (M := 0.11886399)
      (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num))).add
    (errPiece_asymp (q0 := 1.528) (q1 := 1.531) (Lo := (-0.11652679)) (Hi := 0.0596892) (M := 0.11652679)
      (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)))
    (by norm_num) (by norm_num) (by norm_num)

/-- Signed integral bracket for block 54: the `q`-range `[1.531, 1.55]`. -/
theorem oscBlock54 : errIntBracket (vBP 1.531) (vBP 1.55) (-0.0018127) 0.00094122 0.0018127 := by
  refine errIntBracket.mono
    (((((errPiece_asymp (q0 := 1.531) (q1 := 1.534) (Lo := (-0.11537957)) (Hi := 0.05918893) (M := 0.11537957)
      (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)).add
    (errPiece_asymp (q0 := 1.534) (q1 := 1.538) (Lo := (-0.11500361)) (Hi := 0.05964032) (M := 0.11500361)
      (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num))).add
    (errPiece_asymp (q0 := 1.538) (q1 := 1.542) (Lo := (-0.11350309)) (Hi := 0.0589966) (M := 0.11350309)
      (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num))).add
    (errPiece_asymp (q0 := 1.542) (q1 := 1.546) (Lo := (-0.11202679)) (Hi := 0.05837426) (M := 0.11202679)
      (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num))).add
    (errPiece_asymp (q0 := 1.546) (q1 := 1.55) (Lo := (-0.11057426)) (Hi := 0.0577724) (M := 0.11057426)
      (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)))
    (by norm_num) (by norm_num) (by norm_num)

/-- Signed integral bracket for block 55: the `q`-range `[1.55, 1.57]`. -/
theorem oscBlock55 : errIntBracket (vBP 1.55) (vBP 1.57) (-0.00174878) 0.0009222 0.00174878 := by
  refine errIntBracket.mono
    (((((errPiece_asymp (q0 := 1.55) (q1 := 1.554) (Lo := (-0.10914506)) (Hi := 0.05719018) (M := 0.10914506)
      (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)).add
    (errPiece_asymp (q0 := 1.554) (q1 := 1.558) (Lo := (-0.10773874)) (Hi := 0.0566268) (M := 0.10773874)
      (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num))).add
    (errPiece_asymp (q0 := 1.558) (q1 := 1.562) (Lo := (-0.10635488)) (Hi := 0.05608146) (M := 0.10635488)
      (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num))).add
    (errPiece_asymp (q0 := 1.562) (q1 := 1.566) (Lo := (-0.10499307)) (Hi := 0.05555344) (M := 0.10499307)
      (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num))).add
    (errPiece_asymp (q0 := 1.566) (q1 := 1.57) (Lo := (-0.10365289)) (Hi := 0.05504203) (M := 0.10365289)
      (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)))
    (by norm_num) (by norm_num) (by norm_num)

/-- Signed integral bracket for block 56: the `q`-range `[1.57, 1.59]`. -/
theorem oscBlock56 : errIntBracket (vBP 1.57) (vBP 1.59) (-0.00159903) 0.00085919 0.00159903 := by
  refine errIntBracket.mono
    (((((errPiece_asymp (q0 := 1.57) (q1 := 1.574) (Lo := (-0.10233395)) (Hi := 0.05454653) (M := 0.10233395)
      (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)).add
    (errPiece_asymp (q0 := 1.574) (q1 := 1.578) (Lo := (-0.10103586)) (Hi := 0.05406632) (M := 0.10103586)
      (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num))).add
    (errPiece_asymp (q0 := 1.578) (q1 := 1.582) (Lo := (-0.09975825)) (Hi := 0.05360076) (M := 0.09975825)
      (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num))).add
    (errPiece_asymp (q0 := 1.582) (q1 := 1.586) (Lo := (-0.09850072)) (Hi := 0.05314926) (M := 0.09850072)
      (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num))).add
    (errPiece_asymp (q0 := 1.586) (q1 := 1.59) (Lo := (-0.09726294)) (Hi := 0.05271126) (M := 0.09726294)
      (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)))
    (by norm_num) (by norm_num) (by norm_num)

/-- Signed integral bracket for block 57: the `q`-range `[1.59, 1.61]`. -/
theorem oscBlock57 : errIntBracket (vBP 1.59) (vBP 1.61) (-0.00146404) 0.00080454 0.00146404 := by
  refine errIntBracket.mono
    (((((errPiece_asymp (q0 := 1.59) (q1 := 1.594) (Lo := (-0.09604453)) (Hi := 0.0522862) (M := 0.09604453)
      (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)).add
    (errPiece_asymp (q0 := 1.594) (q1 := 1.598) (Lo := (-0.09484515)) (Hi := 0.05187357) (M := 0.09484515)
      (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num))).add
    (errPiece_asymp (q0 := 1.598) (q1 := 1.602) (Lo := (-0.09366446)) (Hi := 0.05147286) (M := 0.09366446)
      (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num))).add
    (errPiece_asymp (q0 := 1.602) (q1 := 1.606) (Lo := (-0.09250212)) (Hi := 0.05108361) (M := 0.09250212)
      (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num))).add
    (errPiece_asymp (q0 := 1.606) (q1 := 1.61) (Lo := (-0.09135781)) (Hi := 0.05070535) (M := 0.09135781)
      (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)))
    (by norm_num) (by norm_num) (by norm_num)

/-- Signed integral bracket for block 58: the `q`-range `[1.61, 1.632]`. -/
theorem oscBlock58 : errIntBracket (vBP 1.61) (vBP 1.632) (-0.00149216) 0.00085338 0.00149216 := by
  refine errIntBracket.mono
    ((((errPiece_asymp (q0 := 1.61) (q1 := 1.614) (Lo := (-0.0902312)) (Hi := 0.05033763) (M := 0.0902312)
      (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)).add
    (errPiece_asymp (q0 := 1.614) (q1 := 1.618) (Lo := (-0.089122)) (Hi := 0.04998006) (M := 0.089122)
      (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num))).add
    (errPiece_asymp (q0 := 1.618) (q1 := 1.625) (Lo := (-0.08972484)) (Hi := 0.05173991) (M := 0.08972484)
      (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num))).add
    (errPiece_asymp (q0 := 1.625) (q1 := 1.632) (Lo := (-0.08781655)) (Hi := 0.05110622) (M := 0.08781655)
      (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)))
    (by norm_num) (by norm_num) (by norm_num)

/-- Signed integral bracket for block 59: the `q`-range `[1.632, 1.656]`. -/
theorem oscBlock59 : errIntBracket (vBP 1.632) (vBP 1.656) (-0.00149999) 0.00089702 0.00149999 := by
  refine errIntBracket.mono
    (((errPiece_asymp (q0 := 1.632) (q1 := 1.64) (Lo := (-0.08649626)) (Hi := 0.05116779) (M := 0.08649626)
      (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)).add
    (errPiece_asymp (q0 := 1.64) (q1 := 1.648) (Lo := (-0.08442093)) (Hi := 0.05049069) (M := 0.08442093)
      (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num))).add
    (errPiece_asymp (q0 := 1.648) (q1 := 1.656) (Lo := (-0.08240842)) (Hi := 0.04984571) (M := 0.08240842)
      (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)))
    (by norm_num) (by norm_num) (by norm_num)

/-- Signed integral bracket for block 60: the `q`-range `[1.656, 1.68]`. -/
theorem oscBlock60 : errIntBracket (vBP 1.656) (vBP 1.68) (-0.00135601) 0.00083946 0.00135601 := by
  refine errIntBracket.mono
    (((errPiece_asymp (q0 := 1.656) (q1 := 1.664) (Lo := (-0.08045654)) (Hi := 0.04923049) (M := 0.08045654)
      (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)).add
    (errPiece_asymp (q0 := 1.664) (q1 := 1.672) (Lo := (-0.07856321)) (Hi := 0.04864284) (M := 0.07856321)
      (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num))).add
    (errPiece_asymp (q0 := 1.672) (q1 := 1.68) (Lo := (-0.07672643)) (Hi := 0.04808073) (M := 0.07672643)
      (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)))
    (by norm_num) (by norm_num) (by norm_num)

/-- Signed integral bracket for block 61: the `q`-range `[1.68, 1.704]`. -/
theorem oscBlock61 : errIntBracket (vBP 1.68) (vBP 1.704) (-0.00122808) 0.00078867 0.00122808 := by
  refine errIntBracket.mono
    (((errPiece_asymp (q0 := 1.68) (q1 := 1.688) (Lo := (-0.07494426)) (Hi := 0.04754231) (M := 0.07494426)
      (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)).add
    (errPiece_asymp (q0 := 1.688) (q1 := 1.696) (Lo := (-0.07321487)) (Hi := 0.04702587) (M := 0.07321487)
      (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num))).add
    (errPiece_asymp (q0 := 1.696) (q1 := 1.704) (Lo := (-0.07153646)) (Hi := 0.04652981) (M := 0.07153646)
      (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)))
    (by norm_num) (by norm_num) (by norm_num)

/-- Signed integral bracket for block 62: the `q`-range `[1.704, 1.734]`. -/
theorem oscBlock62 : errIntBracket (vBP 1.704) (vBP 1.734) (-0.00137159) 0.00091755 0.00137159 := by
  refine errIntBracket.mono
    ((((errPiece_asymp (q0 := 1.704) (q1 := 1.712) (Lo := (-0.06990733)) (Hi := 0.0460527) (M := 0.06990733)
      (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)).add
    (errPiece_asymp (q0 := 1.712) (q1 := 1.719) (Lo := (-0.06790224)) (Hi := 0.04507222) (M := 0.06790224)
      (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num))).add
    (errPiece_asymp (q0 := 1.719) (q1 := 1.726) (Lo := (-0.06656449)) (Hi := 0.04469434) (M := 0.06656449)
      (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num))).add
    (errPiece_asymp (q0 := 1.726) (q1 := 1.734) (Lo := (-0.06566806)) (Hi := 0.04482764) (M := 0.06566806)
      (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)))
    (by norm_num) (by norm_num) (by norm_num)

/-- Signed integral bracket for block 63: the `q`-range `[1.734, 1.766]`. -/
theorem oscBlock63 : errIntBracket (vBP 1.734) (vBP 1.766) (-0.00129873) 0.00091586 0.00129873 := by
  refine errIntBracket.mono
    ((((errPiece_asymp (q0 := 1.734) (q1 := 1.742) (Lo := (-0.06420953)) (Hi := 0.04441037) (M := 0.06420953)
      (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)).add
    (errPiece_asymp (q0 := 1.742) (q1 := 1.75) (Lo := (-0.06279298)) (Hi := 0.0440065) (M := 0.06279298)
      (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num))).add
    (errPiece_asymp (q0 := 1.75) (q1 := 1.758) (Lo := (-0.06141702)) (Hi := 0.04361511) (M := 0.06141702)
      (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num))).add
    (errPiece_asymp (q0 := 1.758) (q1 := 1.766) (Lo := (-0.06008035)) (Hi := 0.04323535) (M := 0.06008035)
      (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)))
    (by norm_num) (by norm_num) (by norm_num)

/-- Signed integral bracket for block 64: the `q`-range `[1.766, 1.796]`. -/
theorem oscBlock64 : errIntBracket (vBP 1.766) (vBP 1.796) (-0.00107612) 0.00079779 0.00107612 := by
  refine errIntBracket.mono
    ((((errPiece_asymp (q0 := 1.766) (q1 := 1.774) (Lo := (-0.05878167)) (Hi := 0.04286644) (M := 0.05878167)
      (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)).add
    (errPiece_asymp (q0 := 1.774) (q1 := 1.781) (Lo := (-0.05716187)) (Hi := 0.04207277) (M := 0.05716187)
      (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num))).add
    (errPiece_asymp (q0 := 1.781) (q1 := 1.788) (Lo := (-0.05609341)) (Hi := 0.04177512) (M := 0.05609341)
      (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num))).add
    (errPiece_asymp (q0 := 1.788) (q1 := 1.796) (Lo := (-0.05539634)) (Hi := 0.04190211) (M := 0.05539634)
      (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)))
    (by norm_num) (by norm_num) (by norm_num)

/-- Signed integral bracket for block 65: the `q`-range `[1.796, 1.828]`. -/
theorem oscBlock65 : errIntBracket (vBP 1.796) (vBP 1.828) (-0.00105478) 0.00083234 0.00105478 := by
  refine errIntBracket.mono
    (((errPiece_asymp (q0 := 1.796) (q1 := 1.804) (Lo := (-0.05422954)) (Hi := 0.04156782) (M := 0.05422954)
      (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)).add
    (errPiece_asymp (q0 := 1.804) (q1 := 1.812) (Lo := (-0.05309528)) (Hi := 0.04124138) (M := 0.05309528)
      (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num))).add
    (errPiece_asymp (q0 := 1.812) (q1 := 1.828) (Lo := (-0.05455931)) (Hi := 0.04401276) (M := 0.05455931)
      (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)))
    (by norm_num) (by norm_num) (by norm_num)

/-- Signed integral bracket for block 66: the `q`-range `[1.828, 1.86]`. -/
theorem oscBlock66 : errIntBracket (vBP 1.828) (vBP 1.86) (-0.00096574) 0.00080765 0.00096574 := by
  refine errIntBracket.mono
    ((errPiece_asymp (q0 := 1.828) (q1 := 1.844) (Lo := (-0.05234436)) (Hi := 0.04326313) (M := 0.05234436)
      (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)).add
    (errPiece_asymp (q0 := 1.844) (q1 := 1.86) (Lo := (-0.05024928)) (Hi := 0.04254499) (M := 0.05024928)
      (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)))
    (by norm_num) (by norm_num) (by norm_num)

/-- Signed integral bracket for block 67: the `q`-range `[1.86, 1.89]`. -/
theorem oscBlock67 : errIntBracket (vBP 1.86) (vBP 1.89) (-0.00080414) 0.00070346 0.00080414 := by
  refine errIntBracket.mono
    ((errPiece_asymp (q0 := 1.86) (q1 := 1.875) (Lo := (-0.04798372)) (Hi := 0.04151855) (M := 0.04798372)
      (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)).add
    (errPiece_asymp (q0 := 1.875) (q1 := 1.89) (Lo := (-0.04623077)) (Hi := 0.04090768) (M := 0.04623077)
      (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)))
    (by norm_num) (by norm_num) (by norm_num)

/-- Signed integral bracket for block 68: the `q`-range `[1.89, 1.922]`. -/
theorem oscBlock68 : errIntBracket (vBP 1.89) (vBP 1.922) (-0.00077499) 0.00071035 0.00077499 := by
  refine errIntBracket.mono
    ((errPiece_asymp (q0 := 1.89) (q1 := 1.906) (Lo := (-0.0448285)) (Hi := 0.04062766) (M := 0.0448285)
      (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)).add
    (errPiece_asymp (q0 := 1.906) (q1 := 1.922) (Lo := (-0.04313216)) (Hi := 0.04000409) (M := 0.04313216)
      (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)))
    (by norm_num) (by norm_num) (by norm_num)

/-- Signed integral bracket for block 69: the `q`-range `[1.922, 1.969]`. -/
theorem oscBlock69 : errIntBracket (vBP 1.922) (vBP 1.969) (-0.00099355) 0.00096258 0.00099355 := by
  refine errIntBracket.mono
    (((errPiece_asymp (q0 := 1.922) (q1 := 1.938) (Lo := (-0.04152394)) (Hi := 0.03939957) (M := 0.04152394)
      (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)).add
    (errPiece_asymp (q0 := 1.938) (q1 := 1.954) (Lo := (-0.03999855)) (Hi := 0.03881245) (M := 0.03999855)
      (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num))).add
    (errPiece_asymp (q0 := 1.954) (q1 := 1.969) (Lo := (-0.03832249)) (Hi := 0.03797598) (M := 0.03832249)
      (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)))
    (by norm_num) (by norm_num) (by norm_num)

/-- Signed integral bracket for block 70: the `q`-range `[1.969, 2.016]`. -/
theorem oscBlock70 : errIntBracket (vBP 1.969) (vBP 2.016) (-0.00085108) 0.00087887 0.00087887 := by
  refine errIntBracket.mono
    (((errPiece_asymp (q0 := 1.969) (q1 := 1.984) (Lo := (-0.03703941)) (Hi := 0.03746334) (M := 0.03746334)
      (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)).add
    (errPiece_asymp (q0 := 1.984) (q1 := 2) (Lo := (-0.03603123)) (Hi := 0.0372091) (M := 0.0372091)
      (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num))).add
    (errPiece_asymp (q0 := 2) (q1 := 2.016) (Lo := (-0.03478312)) (Hi := 0.03667736) (M := 0.03667736)
      (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)))
    (by norm_num) (by norm_num) (by norm_num)

/-- Signed integral bracket for block 71: the `q`-range `[2.016, 2.062]`. -/
theorem oscBlock71 : errIntBracket (vBP 2.016) (vBP 2.062) (-0.00071732) 0.00078633 0.00078633 := by
  refine errIntBracket.mono
    (((errPiece_asymp (q0 := 2.016) (q1 := 2.031) (Lo := (-0.03339617)) (Hi := 0.03592856) (M := 0.03592856)
      (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)).add
    (errPiece_asymp (q0 := 2.031) (q1 := 2.046) (Lo := (-0.0323428)) (Hi := 0.03545915) (M := 0.03545915)
      (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num))).add
    (errPiece_asymp (q0 := 2.046) (q1 := 2.062) (Lo := (-0.03152619)) (Hi := 0.03521241) (M := 0.03521241)
      (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)))
    (by norm_num) (by norm_num) (by norm_num)

/-- Signed integral bracket for block 72: the `q`-range `[2.062, 2.094]`. -/
theorem oscBlock72 : errIntBracket (vBP 2.062) (vBP 2.094) (-0.00044486) 0.00051115 0.00051115 := by
  refine errIntBracket.mono
    ((errPiece_asymp (q0 := 2.062) (q1 := 2.078) (Lo := (-0.03049808)) (Hi := 0.03472297) (M := 0.03472297)
      (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)).add
    (errPiece_asymp (q0 := 2.078) (q1 := 2.094) (Lo := (-0.02951911)) (Hi := 0.034243) (M := 0.034243)
      (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)))
    (by norm_num) (by norm_num) (by norm_num)

end ConnesConsani.WeilPositivity
