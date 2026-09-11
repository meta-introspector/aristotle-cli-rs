/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.
-/
import RequestProject.Imported.OutputFinal.RequestProject.PolyaLowBlocks1

/-!
# The block data for the low-frequency bands (part 2)

Blocks of the extended partition `q ∈ [1,5]`, grouped so that the phase `tv`
varies by at most `0.25` across a block for `t ≤ 1.8`; long blocks are assembled
from sub-blocks of at most 30 pieces.
-/

set_option maxHeartbeats 4000000

noncomputable section

open MeasureTheory Set Real

namespace ConnesConsani.WeilPositivity

theorem blkLo2_0 : errBlockLin (vBP 1.1455) (vBP 1.1605) (vBP 1.1855) 0.0079472447 0.0081220837 (-0.0004509283) (-0.0004410879) 0.0081220837 := by
  have h0 := errBlockLin_of_piece (q0 := 1.1455) (q1 := 1.146) (m := vBP 1.1855)
    (Lo := 0.33868441) (Hi := 0.34639615) (Klo := (-0.000051965894)) (Khi := (-0.00005195542))
    (by norm_num) (by norm_num) (by norm_num) errPt228
    vbpP228.1 vbpP228.2 vbpP229.1 vbpP229.2 vbpP308.1 vbpP308.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h1 := errBlockLin_of_piece (q0 := 1.146) (q1 := 1.1465) (m := vBP 1.1855)
    (Lo := 0.33979049) (Hi := 0.34750502) (Klo := (-0.000051255939)) (Khi := (-0.000051245469))
    (by norm_num) (by norm_num) (by norm_num) errPt229
    vbpP229.1 vbpP229.2 vbpP230.1 vbpP230.2 vbpP308.1 vbpP308.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h2 := errBlockLin_of_piece (q0 := 1.1465) (q1 := 1.147) (m := vBP 1.1855)
    (Lo := 0.34087774) (Hi := 0.34859504) (Klo := (-0.000050548656)) (Khi := (-0.000050538191))
    (by norm_num) (by norm_num) (by norm_num) errPt230
    vbpP230.1 vbpP230.2 vbpP231.1 vbpP231.2 vbpP308.1 vbpP308.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h3 := errBlockLin_of_piece (q0 := 1.147) (q1 := 1.1475) (m := vBP 1.1855)
    (Lo := 0.34194623) (Hi := 0.34966625) (Klo := (-0.000049840555)) (Khi := (-0.000049830094))
    (by norm_num) (by norm_num) (by norm_num) errPt231
    vbpP231.1 vbpP231.2 vbpP232.1 vbpP232.2 vbpP308.1 vbpP308.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h4 := errBlockLin_of_piece (q0 := 1.1475) (q1 := 1.148) (m := vBP 1.1855)
    (Lo := 0.34299597) (Hi := 0.35071869) (Klo := (-0.000049136864)) (Khi := (-0.000049126407))
    (by norm_num) (by norm_num) (by norm_num) errPt232
    vbpP232.1 vbpP232.2 vbpP233.1 vbpP233.2 vbpP308.1 vbpP308.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h5 := errBlockLin_of_piece (q0 := 1.148) (q1 := 1.1485) (m := vBP 1.1855)
    (Lo := 0.344027) (Hi := 0.35175239) (Klo := (-0.000048434091)) (Khi := (-0.000048423639))
    (by norm_num) (by norm_num) (by norm_num) errPt233
    vbpP233.1 vbpP233.2 vbpP234.1 vbpP234.2 vbpP308.1 vbpP308.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h6 := errBlockLin_of_piece (q0 := 1.1485) (q1 := 1.149) (m := vBP 1.1855)
    (Lo := 0.34503938) (Hi := 0.35276739) (Klo := (-0.000047730495)) (Khi := (-0.000047720048))
    (by norm_num) (by norm_num) (by norm_num) errPt234
    vbpP234.1 vbpP234.2 vbpP235.1 vbpP235.2 vbpP308.1 vbpP308.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h7 := errBlockLin_of_piece (q0 := 1.149) (q1 := 1.1495) (m := vBP 1.1855)
    (Lo := 0.34603312) (Hi := 0.35376374) (Klo := (-0.000047031298)) (Khi := (-0.000047020855))
    (by norm_num) (by norm_num) (by norm_num) errPt235
    vbpP235.1 vbpP235.2 vbpP236.1 vbpP236.2 vbpP308.1 vbpP308.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h8 := errBlockLin_of_piece (q0 := 1.1495) (q1 := 1.15) (m := vBP 1.1855)
    (Lo := 0.34700828) (Hi := 0.35474146) (Klo := (-0.000046331273)) (Khi := (-0.000046320835))
    (by norm_num) (by norm_num) (by norm_num) errPt236
    vbpP236.1 vbpP236.2 vbpP237.1 vbpP237.2 vbpP308.1 vbpP308.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h9 := errBlockLin_of_piece (q0 := 1.15) (q1 := 1.1505) (m := vBP 1.1855)
    (Lo := 0.34796489) (Hi := 0.35570059) (Klo := (-0.000045633899)) (Khi := (-0.000045623465))
    (by norm_num) (by norm_num) (by norm_num) errPt237
    vbpP237.1 vbpP237.2 vbpP238.1 vbpP238.2 vbpP308.1 vbpP308.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h10 := errBlockLin_of_piece (q0 := 1.1505) (q1 := 1.151) (m := vBP 1.1855)
    (Lo := 0.34890299) (Hi := 0.35664118) (Klo := (-0.000044939171)) (Khi := (-0.000044928742))
    (by norm_num) (by norm_num) (by norm_num) errPt238
    vbpP238.1 vbpP238.2 vbpP239.1 vbpP239.2 vbpP308.1 vbpP308.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h11 := errBlockLin_of_piece (q0 := 1.151) (q1 := 1.1515) (m := vBP 1.1855)
    (Lo := 0.34982262) (Hi := 0.35756327) (Klo := (-0.000044243612)) (Khi := (-0.000044233188))
    (by norm_num) (by norm_num) (by norm_num) errPt239
    vbpP239.1 vbpP239.2 vbpP240.1 vbpP240.2 vbpP308.1 vbpP308.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h12 := errBlockLin_of_piece (q0 := 1.1515) (q1 := 1.152) (m := vBP 1.1855)
    (Lo := 0.35072381) (Hi := 0.35846688) (Klo := (-0.000043550694)) (Khi := (-0.000043540275))
    (by norm_num) (by norm_num) (by norm_num) errPt240
    vbpP240.1 vbpP240.2 vbpP241.1 vbpP241.2 vbpP308.1 vbpP308.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h13 := errBlockLin_of_piece (q0 := 1.152) (q1 := 1.1525) (m := vBP 1.1855)
    (Lo := 0.35160662) (Hi := 0.35935207) (Klo := (-0.000042858679)) (Khi := (-0.000042848263))
    (by norm_num) (by norm_num) (by norm_num) errPt241
    vbpP241.1 vbpP241.2 vbpP242.1 vbpP242.2 vbpP308.1 vbpP308.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h14 := errBlockLin_of_piece (q0 := 1.1525) (q1 := 1.153) (m := vBP 1.1855)
    (Lo := 0.35247108) (Hi := 0.36021888) (Klo := (-0.000042169298)) (Khi := (-0.000042158887))
    (by norm_num) (by norm_num) (by norm_num) errPt242
    vbpP242.1 vbpP242.2 vbpP243.1 vbpP243.2 vbpP308.1 vbpP308.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h15 := errBlockLin_of_piece (q0 := 1.153) (q1 := 1.1535) (m := vBP 1.1855)
    (Lo := 0.35331722) (Hi := 0.36106733) (Klo := (-0.000041480814)) (Khi := (-0.000041470407))
    (by norm_num) (by norm_num) (by norm_num) errPt243
    vbpP243.1 vbpP243.2 vbpP244.1 vbpP244.2 vbpP308.1 vbpP308.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h16 := errBlockLin_of_piece (q0 := 1.1535) (q1 := 1.154) (m := vBP 1.1855)
    (Lo := 0.3541451) (Hi := 0.36189748) (Klo := (-0.000040793224)) (Khi := (-0.000040782822))
    (by norm_num) (by norm_num) (by norm_num) errPt244
    vbpP244.1 vbpP244.2 vbpP245.1 vbpP245.2 vbpP308.1 vbpP308.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h17 := errBlockLin_of_piece (q0 := 1.154) (q1 := 1.1545) (m := vBP 1.1855)
    (Lo := 0.35495475) (Hi := 0.36270937) (Klo := (-0.000040106528)) (Khi := (-0.000040096131))
    (by norm_num) (by norm_num) (by norm_num) errPt245
    vbpP245.1 vbpP245.2 vbpP246.1 vbpP246.2 vbpP308.1 vbpP308.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h18 := errBlockLin_of_piece (q0 := 1.1545) (q1 := 1.155) (m := vBP 1.1855)
    (Lo := 0.35574621) (Hi := 0.36350303) (Klo := (-0.000039422455)) (Khi := (-0.000039412063))
    (by norm_num) (by norm_num) (by norm_num) errPt246
    vbpP246.1 vbpP246.2 vbpP247.1 vbpP247.2 vbpP308.1 vbpP308.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h19 := errBlockLin_of_piece (q0 := 1.155) (q1 := 1.1555) (m := vBP 1.1855)
    (Lo := 0.35651953) (Hi := 0.3642785) (Klo := (-0.000038741002)) (Khi := (-0.000038730613))
    (by norm_num) (by norm_num) (by norm_num) errPt247
    vbpP247.1 vbpP247.2 vbpP248.1 vbpP248.2 vbpP308.1 vbpP308.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h20 := errBlockLin_of_piece (q0 := 1.1555) (q1 := 1.156) (m := vBP 1.1855)
    (Lo := 0.35727474) (Hi := 0.36503583) (Klo := (-0.000038058702)) (Khi := (-0.000038048318))
    (by norm_num) (by norm_num) (by norm_num) errPt248
    vbpP248.1 vbpP248.2 vbpP249.1 vbpP249.2 vbpP308.1 vbpP308.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h21 := errBlockLin_of_piece (q0 := 1.156) (q1 := 1.1565) (m := vBP 1.1855)
    (Lo := 0.35801189) (Hi := 0.36577507) (Klo := (-0.000037379017)) (Khi := (-0.000037368637))
    (by norm_num) (by norm_num) (by norm_num) errPt249
    vbpP249.1 vbpP249.2 vbpP250.1 vbpP250.2 vbpP308.1 vbpP308.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h22 := errBlockLin_of_piece (q0 := 1.1565) (q1 := 1.157) (m := vBP 1.1855)
    (Lo := 0.35873102) (Hi := 0.36649624) (Klo := (-0.000036700212)) (Khi := (-0.000036689838))
    (by norm_num) (by norm_num) (by norm_num) errPt250
    vbpP250.1 vbpP250.2 vbpP251.1 vbpP251.2 vbpP308.1 vbpP308.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h23 := errBlockLin_of_piece (q0 := 1.157) (q1 := 1.1575) (m := vBP 1.1855)
    (Lo := 0.35943218) (Hi := 0.3671994) (Klo := (-0.000036022288)) (Khi := (-0.000036011918))
    (by norm_num) (by norm_num) (by norm_num) errPt251
    vbpP251.1 vbpP251.2 vbpP252.1 vbpP252.2 vbpP308.1 vbpP308.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h24 := errBlockLin_of_piece (q0 := 1.1575) (q1 := 1.158) (m := vBP 1.1855)
    (Lo := 0.36011541) (Hi := 0.36788459) (Klo := (-0.000035348696)) (Khi := (-0.00003533833))
    (by norm_num) (by norm_num) (by norm_num) errPt252
    vbpP252.1 vbpP252.2 vbpP253.1 vbpP253.2 vbpP308.1 vbpP308.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h25 := errBlockLin_of_piece (q0 := 1.158) (q1 := 1.1585) (m := vBP 1.1855)
    (Lo := 0.36078074) (Hi := 0.36855185) (Klo := (-0.000034672523)) (Khi := (-0.000034662162))
    (by norm_num) (by norm_num) (by norm_num) errPt253
    vbpP253.1 vbpP253.2 vbpP254.1 vbpP254.2 vbpP308.1 vbpP308.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h26 := errBlockLin_of_piece (q0 := 1.1585) (q1 := 1.159) (m := vBP 1.1855)
    (Lo := 0.36142823) (Hi := 0.36920122) (Klo := (-0.000034000677)) (Khi := (-0.00003399032))
    (by norm_num) (by norm_num) (by norm_num) errPt254
    vbpP254.1 vbpP254.2 vbpP255.1 vbpP255.2 vbpP308.1 vbpP308.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h27 := errBlockLin_of_piece (q0 := 1.159) (q1 := 1.1595) (m := vBP 1.1855)
    (Lo := 0.36205792) (Hi := 0.36983275) (Klo := (-0.0000333297)) (Khi := (-0.000033319347))
    (by norm_num) (by norm_num) (by norm_num) errPt255
    vbpP255.1 vbpP255.2 vbpP256.1 vbpP256.2 vbpP308.1 vbpP308.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h28 := errBlockLin_of_piece (q0 := 1.1595) (q1 := 1.16) (m := vBP 1.1855)
    (Lo := 0.36266985) (Hi := 0.37044648) (Klo := (-0.00003265959)) (Khi := (-0.000032649242))
    (by norm_num) (by norm_num) (by norm_num) errPt256
    vbpP256.1 vbpP256.2 vbpP257.1 vbpP257.2 vbpP308.1 vbpP308.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h29 := errBlockLin_of_piece (q0 := 1.16) (q1 := 1.1605) (m := vBP 1.1855)
    (Lo := 0.36326407) (Hi := 0.37104246) (Klo := (-0.000031990347)) (Khi := (-0.000031980003))
    (by norm_num) (by norm_num) (by norm_num) errPt257
    vbpP257.1 vbpP257.2 vbpP258.1 vbpP258.2 vbpP308.1 vbpP308.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  exact (((((((((((((((((((((((((((((h0.add h1).add h2).add h3).add h4).add h5).add h6).add h7).add h8).add h9).add h10).add h11).add h12).add h13).add h14).add h15).add h16).add h17).add h18).add h19).add h20).add h21).add h22).add h23).add h24).add h25).add h26).add h27).add h28).add h29).mono (by norm_num) (by norm_num) (by norm_num [mn4])
    (by norm_num [mx4]) (by norm_num)

theorem blkLo2_1 : errBlockLin (vBP 1.1605) (vBP 1.1755) (vBP 1.1855) 0.0081277859 0.0082992803 (-0.0002470292) (-0.0002417984) 0.0082992803 := by
  have h0 := errBlockLin_of_piece (q0 := 1.1605) (q1 := 1.161) (m := vBP 1.1855)
    (Lo := 0.36384062) (Hi := 0.37162072) (Klo := (-0.00003132369)) (Khi := (-0.000031313351))
    (by norm_num) (by norm_num) (by norm_num) errPt258
    vbpP258.1 vbpP258.2 vbpP259.1 vbpP259.2 vbpP308.1 vbpP308.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h1 := errBlockLin_of_piece (q0 := 1.161) (q1 := 1.1615) (m := vBP 1.1855)
    (Lo := 0.36439954) (Hi := 0.37218132) (Klo := (-0.000030657895)) (Khi := (-0.000030647561))
    (by norm_num) (by norm_num) (by norm_num) errPt259
    vbpP259.1 vbpP259.2 vbpP260.1 vbpP260.2 vbpP308.1 vbpP308.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h2 := errBlockLin_of_piece (q0 := 1.1615) (q1 := 1.162) (m := vBP 1.1855)
    (Lo := 0.36494089) (Hi := 0.3727243) (Klo := (-0.000029992959)) (Khi := (-0.000029982629))
    (by norm_num) (by norm_num) (by norm_num) errPt260
    vbpP260.1 vbpP260.2 vbpP261.1 vbpP261.2 vbpP308.1 vbpP308.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h3 := errBlockLin_of_piece (q0 := 1.162) (q1 := 1.1625) (m := vBP 1.1855)
    (Lo := 0.36546471) (Hi := 0.3732497) (Klo := (-0.000029330602)) (Khi := (-0.000029320276))
    (by norm_num) (by norm_num) (by norm_num) errPt261
    vbpP261.1 vbpP261.2 vbpP262.1 vbpP262.2 vbpP308.1 vbpP308.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h4 := errBlockLin_of_piece (q0 := 1.1625) (q1 := 1.163) (m := vBP 1.1855)
    (Lo := 0.36597104) (Hi := 0.37375757) (Klo := (-0.000028670819)) (Khi := (-0.000028660497))
    (by norm_num) (by norm_num) (by norm_num) errPt262
    vbpP262.1 vbpP262.2 vbpP263.1 vbpP263.2 vbpP308.1 vbpP308.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h5 := errBlockLin_of_piece (q0 := 1.163) (q1 := 1.1635) (m := vBP 1.1855)
    (Lo := 0.36645993) (Hi := 0.37424796) (Klo := (-0.000028008448)) (Khi := (-0.000027998131))
    (by norm_num) (by norm_num) (by norm_num) errPt263
    vbpP263.1 vbpP263.2 vbpP264.1 vbpP264.2 vbpP308.1 vbpP308.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h6 := errBlockLin_of_piece (q0 := 1.1635) (q1 := 1.164) (m := vBP 1.1855)
    (Lo := 0.36693142) (Hi := 0.37472092) (Klo := (-0.000027350368)) (Khi := (-0.000027340055))
    (by norm_num) (by norm_num) (by norm_num) errPt264
    vbpP264.1 vbpP264.2 vbpP265.1 vbpP265.2 vbpP308.1 vbpP308.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h7 := errBlockLin_of_piece (q0 := 1.164) (q1 := 1.1645) (m := vBP 1.1855)
    (Lo := 0.36738557) (Hi := 0.37517648) (Klo := (-0.000026693135)) (Khi := (-0.000026682827))
    (by norm_num) (by norm_num) (by norm_num) errPt265
    vbpP265.1 vbpP265.2 vbpP266.1 vbpP266.2 vbpP308.1 vbpP308.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h8 := errBlockLin_of_piece (q0 := 1.1645) (q1 := 1.165) (m := vBP 1.1855)
    (Lo := 0.36782242) (Hi := 0.37561469) (Klo := (-0.000026038465)) (Khi := (-0.000026028161))
    (by norm_num) (by norm_num) (by norm_num) errPt266
    vbpP266.1 vbpP266.2 vbpP267.1 vbpP267.2 vbpP308.1 vbpP308.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h9 := errBlockLin_of_piece (q0 := 1.165) (q1 := 1.1655) (m := vBP 1.1855)
    (Lo := 0.36824202) (Hi := 0.37603561) (Klo := (-0.000025382921)) (Khi := (-0.000025370906))
    (by norm_num) (by norm_num) (by norm_num) errPt267
    vbpP267.1 vbpP267.2 vbpP268.1 vbpP268.2 vbpP308.1 vbpP308.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h10 := errBlockLin_of_piece (q0 := 1.1655) (q1 := 1.166) (m := vBP 1.1855)
    (Lo := 0.36864441) (Hi := 0.37643928) (Klo := (-0.000024729937)) (Khi := (-0.000024717926))
    (by norm_num) (by norm_num) (by norm_num) errPt268
    vbpP268.1 vbpP268.2 vbpP269.1 vbpP269.2 vbpP308.1 vbpP308.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h11 := errBlockLin_of_piece (q0 := 1.166) (q1 := 1.1665) (m := vBP 1.1855)
    (Lo := 0.36902964) (Hi := 0.37682575) (Klo := (-0.000024077792)) (Khi := (-0.000024067501))
    (by norm_num) (by norm_num) (by norm_num) errPt269
    vbpP269.1 vbpP269.2 vbpP270.1 vbpP270.2 vbpP308.1 vbpP308.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h12 := errBlockLin_of_piece (q0 := 1.1665) (q1 := 1.167) (m := vBP 1.1855)
    (Lo := 0.36939777) (Hi := 0.37719506) (Klo := (-0.000023428199)) (Khi := (-0.000023417913))
    (by norm_num) (by norm_num) (by norm_num) errPt270
    vbpP270.1 vbpP270.2 vbpP271.1 vbpP271.2 vbpP308.1 vbpP308.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h13 := errBlockLin_of_piece (q0 := 1.167) (q1 := 1.1675) (m := vBP 1.1855)
    (Lo := 0.36974883) (Hi := 0.37754727) (Klo := (-0.00002277944)) (Khi := (-0.000022769159))
    (by norm_num) (by norm_num) (by norm_num) errPt271
    vbpP271.1 vbpP271.2 vbpP272.1 vbpP272.2 vbpP308.1 vbpP308.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h14 := errBlockLin_of_piece (q0 := 1.1675) (q1 := 1.168) (m := vBP 1.1855)
    (Lo := 0.37008289) (Hi := 0.37788242) (Klo := (-0.000022129802)) (Khi := (-0.000022119525))
    (by norm_num) (by norm_num) (by norm_num) errPt272
    vbpP272.1 vbpP272.2 vbpP273.1 vbpP273.2 vbpP308.1 vbpP308.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h15 := errBlockLin_of_piece (q0 := 1.168) (q1 := 1.1685) (m := vBP 1.1855)
    (Lo := 0.37039998) (Hi := 0.37820055) (Klo := (-0.000021486133)) (Khi := (-0.000021474149))
    (by norm_num) (by norm_num) (by norm_num) errPt273
    vbpP273.1 vbpP273.2 vbpP274.1 vbpP274.2 vbpP308.1 vbpP308.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h16 := errBlockLin_of_piece (q0 := 1.1685) (q1 := 1.169) (m := vBP 1.1855)
    (Lo := 0.37070016) (Hi := 0.37850173) (Klo := (-0.00002084158)) (Khi := (-0.000020827889))
    (by norm_num) (by norm_num) (by norm_num) errPt274
    vbpP274.1 vbpP274.2 vbpP275.1 vbpP275.2 vbpP308.1 vbpP308.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h17 := errBlockLin_of_piece (q0 := 1.169) (q1 := 1.1695) (m := vBP 1.1855)
    (Lo := 0.37098347) (Hi := 0.378786) (Klo := (-0.000020197854)) (Khi := (-0.000020185879))
    (by norm_num) (by norm_num) (by norm_num) errPt275
    vbpP275.1 vbpP275.2 vbpP276.1 vbpP276.2 vbpP308.1 vbpP308.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h18 := errBlockLin_of_piece (q0 := 1.1695) (q1 := 1.17) (m := vBP 1.1855)
    (Lo := 0.37124998) (Hi := 0.37905341) (Klo := (-0.000019553242)) (Khi := (-0.000019542983))
    (by norm_num) (by norm_num) (by norm_num) errPt276
    vbpP276.1 vbpP276.2 vbpP277.1 vbpP277.2 vbpP308.1 vbpP308.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h19 := errBlockLin_of_piece (q0 := 1.17) (q1 := 1.1705) (m := vBP 1.1855)
    (Lo := 0.37149972) (Hi := 0.379304) (Klo := (-0.000018912874)) (Khi := (-0.000018902619))
    (by norm_num) (by norm_num) (by norm_num) errPt277
    vbpP277.1 vbpP277.2 vbpP278.1 vbpP278.2 vbpP308.1 vbpP308.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h20 := errBlockLin_of_piece (q0 := 1.1705) (q1 := 1.171) (m := vBP 1.1855)
    (Lo := 0.37173274) (Hi := 0.37953784) (Klo := (-0.000018275035)) (Khi := (-0.000018264784))
    (by norm_num) (by norm_num) (by norm_num) errPt278
    vbpP278.1 vbpP278.2 vbpP279.1 vbpP279.2 vbpP308.1 vbpP308.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h21 := errBlockLin_of_piece (q0 := 1.171) (q1 := 1.1715) (m := vBP 1.1855)
    (Lo := 0.37194911) (Hi := 0.37975496) (Klo := (-0.000017634597)) (Khi := (-0.000017624351))
    (by norm_num) (by norm_num) (by norm_num) errPt279
    vbpP279.1 vbpP279.2 vbpP280.1 vbpP280.2 vbpP308.1 vbpP308.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h22 := errBlockLin_of_piece (q0 := 1.1715) (q1 := 1.172) (m := vBP 1.1855)
    (Lo := 0.37214886) (Hi := 0.37995543) (Klo := (-0.000017000099)) (Khi := (-0.000016989857))
    (by norm_num) (by norm_num) (by norm_num) errPt280
    vbpP280.1 vbpP280.2 vbpP281.1 vbpP281.2 vbpP308.1 vbpP308.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h23 := errBlockLin_of_piece (q0 := 1.172) (q1 := 1.1725) (m := vBP 1.1855)
    (Lo := 0.37233206) (Hi := 0.38013928) (Klo := (-0.000016363001)) (Khi := (-0.000016352763))
    (by norm_num) (by norm_num) (by norm_num) errPt281
    vbpP281.1 vbpP281.2 vbpP282.1 vbpP282.2 vbpP308.1 vbpP308.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h24 := errBlockLin_of_piece (q0 := 1.1725) (q1 := 1.173) (m := vBP 1.1855)
    (Lo := 0.37249874) (Hi := 0.38030658) (Klo := (-0.000015730127)) (Khi := (-0.000015719894))
    (by norm_num) (by norm_num) (by norm_num) errPt282
    vbpP282.1 vbpP282.2 vbpP283.1 vbpP283.2 vbpP308.1 vbpP308.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h25 := errBlockLin_of_piece (q0 := 1.173) (q1 := 1.1735) (m := vBP 1.1855)
    (Lo := 0.37264897) (Hi := 0.38045738) (Klo := (-0.000015096359)) (Khi := (-0.00001508613))
    (by norm_num) (by norm_num) (by norm_num) errPt283
    vbpP283.1 vbpP283.2 vbpP284.1 vbpP284.2 vbpP308.1 vbpP308.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h26 := errBlockLin_of_piece (q0 := 1.1735) (q1 := 1.174) (m := vBP 1.1855)
    (Lo := 0.3727828) (Hi := 0.38059172) (Klo := (-0.000014465103)) (Khi := (-0.000014454879))
    (by norm_num) (by norm_num) (by norm_num) errPt284
    vbpP284.1 vbpP284.2 vbpP285.1 vbpP285.2 vbpP308.1 vbpP308.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h27 := errBlockLin_of_piece (q0 := 1.174) (q1 := 1.1745) (m := vBP 1.1855)
    (Lo := 0.37290028) (Hi := 0.38070966) (Klo := (-0.000013836357)) (Khi := (-0.000013826137))
    (by norm_num) (by norm_num) (by norm_num) errPt285
    vbpP285.1 vbpP285.2 vbpP286.1 vbpP286.2 vbpP308.1 vbpP308.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h28 := errBlockLin_of_piece (q0 := 1.1745) (q1 := 1.175) (m := vBP 1.1855)
    (Lo := 0.37300145) (Hi := 0.38081125) (Klo := (-0.000013206711)) (Khi := (-0.000013196495))
    (by norm_num) (by norm_num) (by norm_num) errPt286
    vbpP286.1 vbpP286.2 vbpP287.1 vbpP287.2 vbpP308.1 vbpP308.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h29 := errBlockLin_of_piece (q0 := 1.175) (q1 := 1.1755) (m := vBP 1.1855)
    (Lo := 0.37308639) (Hi := 0.38089654) (Klo := (-0.00001257957)) (Khi := (-0.000012567657))
    (by norm_num) (by norm_num) (by norm_num) errPt287
    vbpP287.1 vbpP287.2 vbpP288.1 vbpP288.2 vbpP308.1 vbpP308.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  exact (((((((((((((((((((((((((((((h0.add h1).add h2).add h3).add h4).add h5).add h6).add h7).add h8).add h9).add h10).add h11).add h12).add h13).add h14).add h15).add h16).add h17).add h18).add h19).add h20).add h21).add h22).add h23).add h24).add h25).add h26).add h27).add h28).add h29).mono (by norm_num) (by norm_num) (by norm_num [mn4])
    (by norm_num [mx4]) (by norm_num)

theorem blkLo2_2 : errBlockLin (vBP 1.1755) (vBP 1.1905) (vBP 1.1855) 0.0079704257 0.0081377866 (-0.0000354224) (-0.0000341176) 0.0081377866 := by
  have h0 := errBlockLin_of_piece (q0 := 1.1755) (q1 := 1.176) (m := vBP 1.1855)
    (Lo := 0.37315513) (Hi := 0.38096559) (Klo := (-0.00001195323)) (Khi := (-0.000011941321))
    (by norm_num) (by norm_num) (by norm_num) errPt288
    vbpP288.1 vbpP288.2 vbpP289.1 vbpP289.2 vbpP308.1 vbpP308.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h1 := errBlockLin_of_piece (q0 := 1.176) (q1 := 1.1765) (m := vBP 1.1855)
    (Lo := 0.37320773) (Hi := 0.38101845) (Klo := (-0.000011329388)) (Khi := (-0.000011319185))
    (by norm_num) (by norm_num) (by norm_num) errPt289
    vbpP289.1 vbpP289.2 vbpP290.1 vbpP290.2 vbpP308.1 vbpP308.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h2 := errBlockLin_of_piece (q0 := 1.1765) (q1 := 1.177) (m := vBP 1.1855)
    (Lo := 0.37324425) (Hi := 0.38105517) (Klo := (-0.000010704641)) (Khi := (-0.000010694442))
    (by norm_num) (by norm_num) (by norm_num) errPt290
    vbpP290.1 vbpP290.2 vbpP291.1 vbpP291.2 vbpP308.1 vbpP308.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h3 := errBlockLin_of_piece (q0 := 1.177) (q1 := 1.1775) (m := vBP 1.1855)
    (Lo := 0.37326474) (Hi := 0.38107582) (Klo := (-0.000010082389)) (Khi := (-0.000010072194))
    (by norm_num) (by norm_num) (by norm_num) errPt291
    vbpP291.1 vbpP291.2 vbpP292.1 vbpP292.2 vbpP308.1 vbpP308.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h4 := errBlockLin_of_piece (q0 := 1.1775) (q1 := 1.178) (m := vBP 1.1855)
    (Lo := 0.37326925) (Hi := 0.38108043) (Klo := (-0.000009462626)) (Khi := (-0.000009452436))
    (by norm_num) (by norm_num) (by norm_num) errPt292
    vbpP292.1 vbpP292.2 vbpP293.1 vbpP293.2 vbpP308.1 vbpP308.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h5 := errBlockLin_of_piece (q0 := 1.178) (q1 := 1.1785) (m := vBP 1.1855)
    (Lo := 0.37325784) (Hi := 0.38106907) (Klo := (-0.000008841956)) (Khi := (-0.00000883177))
    (by norm_num) (by norm_num) (by norm_num) errPt293
    vbpP293.1 vbpP293.2 vbpP294.1 vbpP294.2 vbpP308.1 vbpP308.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h6 := errBlockLin_of_piece (q0 := 1.1785) (q1 := 1.179) (m := vBP 1.1855)
    (Lo := 0.37323056) (Hi := 0.3810418) (Klo := (-0.000008225468)) (Khi := (-0.000008215287))
    (by norm_num) (by norm_num) (by norm_num) errPt294
    vbpP294.1 vbpP294.2 vbpP295.1 vbpP295.2 vbpP308.1 vbpP308.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h7 := errBlockLin_of_piece (q0 := 1.179) (q1 := 1.1795) (m := vBP 1.1855)
    (Lo := 0.37318748) (Hi := 0.38099866) (Klo := (-0.000007606373)) (Khi := (-0.000007596196))
    (by norm_num) (by norm_num) (by norm_num) errPt295
    vbpP295.1 vbpP295.2 vbpP296.1 vbpP296.2 vbpP308.1 vbpP308.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h8 := errBlockLin_of_piece (q0 := 1.1795) (q1 := 1.18) (m := vBP 1.1855)
    (Lo := 0.37312864) (Hi := 0.38093971) (Klo := (-0.000006993149)) (Khi := (-0.000006981281))
    (by norm_num) (by norm_num) (by norm_num) errPt296
    vbpP296.1 vbpP296.2 vbpP297.1 vbpP297.2 vbpP308.1 vbpP308.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h9 := errBlockLin_of_piece (q0 := 1.18) (q1 := 1.1805) (m := vBP 1.1855)
    (Lo := 0.3730541) (Hi := 0.38086501) (Klo := (-0.000006379011)) (Khi := (-0.000006367148))
    (by norm_num) (by norm_num) (by norm_num) errPt297
    vbpP297.1 vbpP297.2 vbpP298.1 vbpP298.2 vbpP308.1 vbpP308.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h10 := errBlockLin_of_piece (q0 := 1.1805) (q1 := 1.181) (m := vBP 1.1855)
    (Lo := 0.37296392) (Hi := 0.38077461) (Klo := (-0.000005763959)) (Khi := (-0.000005753795))
    (by norm_num) (by norm_num) (by norm_num) errPt298
    vbpP298.1 vbpP298.2 vbpP299.1 vbpP299.2 vbpP308.1 vbpP308.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h11 := errBlockLin_of_piece (q0 := 1.181) (q1 := 1.1815) (m := vBP 1.1855)
    (Lo := 0.37285815) (Hi := 0.38066857) (Klo := (-0.000005153073)) (Khi := (-0.000005142914))
    (by norm_num) (by norm_num) (by norm_num) errPt299
    vbpP299.1 vbpP299.2 vbpP300.1 vbpP300.2 vbpP308.1 vbpP308.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h12 := errBlockLin_of_piece (q0 := 1.1815) (q1 := 1.182) (m := vBP 1.1855)
    (Lo := 0.37273686) (Hi := 0.38054695) (Klo := (-0.000004542963)) (Khi := (-0.000004531115))
    (by norm_num) (by norm_num) (by norm_num) errPt300
    vbpP300.1 vbpP300.2 vbpP301.1 vbpP301.2 vbpP308.1 vbpP308.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h13 := errBlockLin_of_piece (q0 := 1.182) (q1 := 1.1825) (m := vBP 1.1855)
    (Lo := 0.37260009) (Hi := 0.3804098) (Klo := (-0.000003933627)) (Khi := (-0.000003921784))
    (by norm_num) (by norm_num) (by norm_num) errPt301
    vbpP301.1 vbpP301.2 vbpP302.1 vbpP302.2 vbpP308.1 vbpP308.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h14 := errBlockLin_of_piece (q0 := 1.1825) (q1 := 1.183) (m := vBP 1.1855)
    (Lo := 0.37244791) (Hi := 0.38025718) (Klo := (-0.000003326754)) (Khi := (-0.000003314916))
    (by norm_num) (by norm_num) (by norm_num) errPt302
    vbpP302.1 vbpP302.2 vbpP303.1 vbpP303.2 vbpP308.1 vbpP308.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h15 := errBlockLin_of_piece (q0 := 1.183) (q1 := 1.1835) (m := vBP 1.1855)
    (Lo := 0.37228036) (Hi := 0.38008915) (Klo := (-0.00000272065)) (Khi := (-0.000002707127))
    (by norm_num) (by norm_num) (by norm_num) errPt303
    vbpP303.1 vbpP303.2 vbpP304.1 vbpP304.2 vbpP308.1 vbpP308.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h16 := errBlockLin_of_piece (q0 := 1.1835) (q1 := 1.184) (m := vBP 1.1855)
    (Lo := 0.37209752) (Hi := 0.37990577) (Klo := (-0.000002113626)) (Khi := (-0.000002101798))
    (by norm_num) (by norm_num) (by norm_num) errPt304
    vbpP304.1 vbpP304.2 vbpP305.1 vbpP305.2 vbpP308.1 vbpP308.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h17 := errBlockLin_of_piece (q0 := 1.184) (q1 := 1.1845) (m := vBP 1.1855)
    (Lo := 0.37189944) (Hi := 0.37970709) (Klo := (-0.000001510746)) (Khi := (-0.000001500612))
    (by norm_num) (by norm_num) (by norm_num) errPt305
    vbpP305.1 vbpP305.2 vbpP306.1 vbpP306.2 vbpP308.1 vbpP308.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h18 := errBlockLin_of_piece (q0 := 1.1845) (q1 := 1.185) (m := vBP 1.1855)
    (Lo := 0.37168618) (Hi := 0.37949317) (Klo := (-0.000000906942)) (Khi := (-0.000000896812))
    (by norm_num) (by norm_num) (by norm_num) errPt306
    vbpP306.1 vbpP306.2 vbpP307.1 vbpP307.2 vbpP308.1 vbpP308.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h19 := errBlockLin_of_piece (q0 := 1.185) (q1 := 1.1855) (m := vBP 1.1855)
    (Lo := 0.37145779) (Hi := 0.37926406) (Klo := (-0.000000305588)) (Khi := (-0.000000293776))
    (by norm_num) (by norm_num) (by norm_num) errPt307
    vbpP307.1 vbpP307.2 vbpP308.1 vbpP308.2 vbpP308.1 vbpP308.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h20 := errBlockLin_of_piece (q0 := 1.1855) (q1 := 1.186) (m := vBP 1.1855)
    (Lo := 0.37121433) (Hi := 0.37901984) (Klo := 0.000000293318) (Khi := 0.000000305126)
    (by norm_num) (by norm_num) (by norm_num) errPt308
    vbpP308.1 vbpP308.2 vbpP309.1 vbpP309.2 vbpP308.1 vbpP308.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h21 := errBlockLin_of_piece (q0 := 1.186) (q1 := 1.1865) (m := vBP 1.1855)
    (Lo := 0.37095587) (Hi := 0.37876056) (Klo := 0.000000894838) (Khi := 0.000000904955)
    (by norm_num) (by norm_num) (by norm_num) errPt309
    vbpP309.1 vbpP309.2 vbpP310.1 vbpP310.2 vbpP308.1 vbpP308.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h22 := errBlockLin_of_piece (q0 := 1.1865) (q1 := 1.187) (m := vBP 1.1855)
    (Lo := 0.37068246) (Hi := 0.37848627) (Klo := 0.000001490544) (Khi := 0.000001500656)
    (by norm_num) (by norm_num) (by norm_num) errPt310
    vbpP310.1 vbpP310.2 vbpP311.1 vbpP311.2 vbpP308.1 vbpP308.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h23 := errBlockLin_of_piece (q0 := 1.187) (q1 := 1.1875) (m := vBP 1.1855)
    (Lo := 0.37039417) (Hi := 0.37819704) (Klo := 0.000002088865) (Khi := 0.000002098974)
    (by norm_num) (by norm_num) (by norm_num) errPt311
    vbpP311.1 vbpP311.2 vbpP312.1 vbpP312.2 vbpP308.1 vbpP308.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h24 := errBlockLin_of_piece (q0 := 1.1875) (q1 := 1.188) (m := vBP 1.1855)
    (Lo := 0.37009105) (Hi := 0.37789292) (Klo := 0.000002683065) (Khi := 0.000002693169)
    (by norm_num) (by norm_num) (by norm_num) errPt312
    vbpP312.1 vbpP312.2 vbpP313.1 vbpP313.2 vbpP308.1 vbpP308.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h25 := errBlockLin_of_piece (q0 := 1.188) (q1 := 1.1885) (m := vBP 1.1855)
    (Lo := 0.36977316) (Hi := 0.37757398) (Klo := 0.000003276514) (Khi := 0.000003286614)
    (by norm_num) (by norm_num) (by norm_num) errPt313
    vbpP313.1 vbpP313.2 vbpP314.1 vbpP314.2 vbpP308.1 vbpP308.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h26 := errBlockLin_of_piece (q0 := 1.1885) (q1 := 1.189) (m := vBP 1.1855)
    (Lo := 0.36944057) (Hi := 0.37724028) (Klo := 0.000003869214) (Khi := 0.00000387931)
    (by norm_num) (by norm_num) (by norm_num) errPt314
    vbpP314.1 vbpP314.2 vbpP315.1 vbpP315.2 vbpP308.1 vbpP308.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h27 := errBlockLin_of_piece (q0 := 1.189) (q1 := 1.1895) (m := vBP 1.1855)
    (Lo := 0.36909333) (Hi := 0.37689187) (Klo := 0.000004461167) (Khi := 0.000004471259)
    (by norm_num) (by norm_num) (by norm_num) errPt315
    vbpP315.1 vbpP315.2 vbpP316.1 vbpP316.2 vbpP308.1 vbpP308.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h28 := errBlockLin_of_piece (q0 := 1.1895) (q1 := 1.19) (m := vBP 1.1855)
    (Lo := 0.36873151) (Hi := 0.37652883) (Klo := 0.000005050694) (Khi := 0.000005060781)
    (by norm_num) (by norm_num) (by norm_num) errPt316
    vbpP316.1 vbpP316.2 vbpP317.1 vbpP317.2 vbpP308.1 vbpP308.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h29 := errBlockLin_of_piece (q0 := 1.19) (q1 := 1.1905) (m := vBP 1.1855)
    (Lo := 0.36835517) (Hi := 0.3761512) (Klo := 0.000005641157) (Khi := 0.00000565124)
    (by norm_num) (by norm_num) (by norm_num) errPt317
    vbpP317.1 vbpP317.2 vbpP318.1 vbpP318.2 vbpP308.1 vbpP308.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  exact (((((((((((((((((((((((((((((h0.add h1).add h2).add h3).add h4).add h5).add h6).add h7).add h8).add h9).add h10).add h11).add h12).add h13).add h14).add h15).add h16).add h17).add h18).add h19).add h20).add h21).add h22).add h23).add h24).add h25).add h26).add h27).add h28).add h29).mono (by norm_num) (by norm_num) (by norm_num [mn4])
    (by norm_num [mx4]) (by norm_num)

theorem blkLo2_3 : errBlockLin (vBP 1.1905) (vBP 1.217) (vBP 1.1855) 0.0127413302 0.0132651908 0.0003810263 0.0003977309 0.0132651908 := by
  have h0 := errBlockLin_of_piece (q0 := 1.1905) (q1 := 1.191) (m := vBP 1.1855)
    (Lo := 0.36796437) (Hi := 0.37575905) (Klo := 0.000006227519) (Khi := 0.000006237597)
    (by norm_num) (by norm_num) (by norm_num) errPt318
    vbpP318.1 vbpP318.2 vbpP319.1 vbpP319.2 vbpP308.1 vbpP308.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h1 := errBlockLin_of_piece (q0 := 1.191) (q1 := 1.1915) (m := vBP 1.1855)
    (Lo := 0.36755917) (Hi := 0.37535245) (Klo := 0.000006813142) (Khi := 0.000006824895)
    (by norm_num) (by norm_num) (by norm_num) errPt319
    vbpP319.1 vbpP319.2 vbpP320.1 vbpP320.2 vbpP308.1 vbpP308.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h2 := errBlockLin_of_piece (q0 := 1.1915) (q1 := 1.192) (m := vBP 1.1855)
    (Lo := 0.36713963) (Hi := 0.37493145) (Klo := 0.000007398027) (Khi := 0.000007409776)
    (by norm_num) (by norm_num) (by norm_num) errPt320
    vbpP320.1 vbpP320.2 vbpP321.1 vbpP321.2 vbpP308.1 vbpP308.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h3 := errBlockLin_of_piece (q0 := 1.192) (q1 := 1.1925) (m := vBP 1.1855)
    (Lo := 0.36670582) (Hi := 0.37449612) (Klo := 0.000007983855) (Khi := 0.000007993921)
    (by norm_num) (by norm_num) (by norm_num) errPt321
    vbpP321.1 vbpP321.2 vbpP322.1 vbpP322.2 vbpP308.1 vbpP308.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h4 := errBlockLin_of_piece (q0 := 1.1925) (q1 := 1.193) (m := vBP 1.1855)
    (Lo := 0.3662578) (Hi := 0.37404652) (Klo := 0.000008565593) (Khi := 0.000008575655)
    (by norm_num) (by norm_num) (by norm_num) errPt322
    vbpP322.1 vbpP322.2 vbpP323.1 vbpP323.2 vbpP308.1 vbpP308.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h5 := errBlockLin_of_piece (q0 := 1.193) (q1 := 1.1935) (m := vBP 1.1855)
    (Lo := 0.36579563) (Hi := 0.37358271) (Klo := 0.000009148276) (Khi := 0.000009158333)
    (by norm_num) (by norm_num) (by norm_num) errPt323
    vbpP323.1 vbpP323.2 vbpP324.1 vbpP324.2 vbpP308.1 vbpP308.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h6 := errBlockLin_of_piece (q0 := 1.1935) (q1 := 1.194) (m := vBP 1.1855)
    (Lo := 0.36531938) (Hi := 0.37310476) (Klo := 0.000009726876) (Khi := 0.000009738605)
    (by norm_num) (by norm_num) (by norm_num) errPt324
    vbpP324.1 vbpP324.2 vbpP325.1 vbpP325.2 vbpP308.1 vbpP308.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h7 := errBlockLin_of_piece (q0 := 1.194) (q1 := 1.195) (m := vBP 1.1855)
    (Lo := 0.36074159) (Hi := 0.37619851) (Klo := 0.000021196693) (Khi := 0.000021208415)
    (by norm_num) (by norm_num) (by norm_num) errPt325
    vbpP325.1 vbpP325.2 vbpP326.1 vbpP326.2 vbpP308.1 vbpP308.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h8 := errBlockLin_of_piece (q0 := 1.195) (q1 := 1.196) (m := vBP 1.1855)
    (Lo := 0.3597074) (Hi := 0.3751566) (Klo := 0.00002350238) (Khi := 0.000023514091)
    (by norm_num) (by norm_num) (by norm_num) errPt326
    vbpP326.1 vbpP326.2 vbpP327.1 vbpP327.2 vbpP308.1 vbpP308.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h9 := errBlockLin_of_piece (q0 := 1.196) (q1 := 1.197) (m := vBP 1.1855)
    (Lo := 0.35861813) (Hi := 0.37405915) (Klo := 0.000025798945) (Khi := 0.000025812318)
    (by norm_num) (by norm_num) (by norm_num) errPt327
    vbpP327.1 vbpP327.2 vbpP328.1 vbpP328.2 vbpP308.1 vbpP308.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h10 := errBlockLin_of_piece (q0 := 1.197) (q1 := 1.198) (m := vBP 1.1855)
    (Lo := 0.3574743) (Hi := 0.37290668) (Klo := 0.00002808642) (Khi := 0.000028098113)
    (by norm_num) (by norm_num) (by norm_num) errPt328
    vbpP328.1 vbpP328.2 vbpP329.1 vbpP329.2 vbpP308.1 vbpP308.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h11 := errBlockLin_of_piece (q0 := 1.198) (q1 := 1.199) (m := vBP 1.1855)
    (Lo := 0.35627645) (Hi := 0.37169972) (Klo := 0.000030364837) (Khi := 0.000030376519)
    (by norm_num) (by norm_num) (by norm_num) errPt329
    vbpP329.1 vbpP329.2 vbpP330.1 vbpP330.2 vbpP308.1 vbpP308.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h12 := errBlockLin_of_piece (q0 := 1.199) (q1 := 1.2) (m := vBP 1.1855)
    (Lo := 0.35502509) (Hi := 0.37043878) (Klo := 0.000032632557) (Khi := 0.00003264423)
    (by norm_num) (by norm_num) (by norm_num) errPt330
    vbpP330.1 vbpP330.2 vbpP331.1 vbpP331.2 vbpP308.1 vbpP308.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h13 := errBlockLin_of_piece (q0 := 1.2) (q1 := 1.201) (m := vBP 1.1855)
    (Lo := 0.35372077) (Hi := 0.3691244) (Klo := 0.000034891283) (Khi := 0.000034902945)
    (by norm_num) (by norm_num) (by norm_num) errPt331
    vbpP331.1 vbpP331.2 vbpP332.1 vbpP332.2 vbpP308.1 vbpP308.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h14 := errBlockLin_of_piece (q0 := 1.201) (q1 := 1.202) (m := vBP 1.1855)
    (Lo := 0.35236401) (Hi := 0.36775711) (Klo := 0.000037139379) (Khi := 0.000037151032)
    (by norm_num) (by norm_num) (by norm_num) errPt332
    vbpP332.1 vbpP332.2 vbpP333.1 vbpP333.2 vbpP308.1 vbpP308.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h15 := errBlockLin_of_piece (q0 := 1.202) (q1 := 1.203) (m := vBP 1.1855)
    (Lo := 0.35095536) (Hi := 0.36633746) (Klo := 0.000039380207) (Khi := 0.000039391849)
    (by norm_num) (by norm_num) (by norm_num) errPt333
    vbpP333.1 vbpP333.2 vbpP334.1 vbpP334.2 vbpP308.1 vbpP308.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h16 := errBlockLin_of_piece (q0 := 1.203) (q1 := 1.204) (m := vBP 1.1855)
    (Lo := 0.34949535) (Hi := 0.36486597) (Klo := 0.000041610467) (Khi := 0.000041622101)
    (by norm_num) (by norm_num) (by norm_num) errPt334
    vbpP334.1 vbpP334.2 vbpP335.1 vbpP335.2 vbpP308.1 vbpP308.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h17 := errBlockLin_of_piece (q0 := 1.204) (q1 := 1.205) (m := vBP 1.1855)
    (Lo := 0.34798455) (Hi := 0.3633432) (Klo := 0.000043830196) (Khi := 0.00004384182)
    (by norm_num) (by norm_num) (by norm_num) errPt335
    vbpP335.1 vbpP335.2 vbpP336.1 vbpP336.2 vbpP308.1 vbpP308.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h18 := errBlockLin_of_piece (q0 := 1.205) (q1 := 1.206) (m := vBP 1.1855)
    (Lo := 0.3464235) (Hi := 0.3617697) (Klo := 0.000046042744) (Khi := 0.000046054359)
    (by norm_num) (by norm_num) (by norm_num) errPt336
    vbpP336.1 vbpP336.2 vbpP337.1 vbpP337.2 vbpP308.1 vbpP308.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h19 := errBlockLin_of_piece (q0 := 1.206) (q1 := 1.207) (m := vBP 1.1855)
    (Lo := 0.34481276) (Hi := 0.36014602) (Klo := 0.000048244823) (Khi := 0.000048256428)
    (by norm_num) (by norm_num) (by norm_num) errPt337
    vbpP337.1 vbpP337.2 vbpP338.1 vbpP338.2 vbpP308.1 vbpP308.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h20 := errBlockLin_of_piece (q0 := 1.207) (q1 := 1.208) (m := vBP 1.1855)
    (Lo := 0.34315288) (Hi := 0.35847271) (Klo := 0.000050436466) (Khi := 0.000050449717)
    (by norm_num) (by norm_num) (by norm_num) errPt338
    vbpP338.1 vbpP338.2 vbpP339.1 vbpP339.2 vbpP308.1 vbpP308.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h21 := errBlockLin_of_piece (q0 := 1.208) (q1 := 1.209) (m := vBP 1.1855)
    (Lo := 0.34144443) (Hi := 0.35675035) (Klo := 0.000052621015) (Khi := 0.000052634256)
    (by norm_num) (by norm_num) (by norm_num) errPt339
    vbpP339.1 vbpP339.2 vbpP340.1 vbpP340.2 vbpP308.1 vbpP308.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h22 := errBlockLin_of_piece (q0 := 1.209) (q1 := 1.21) (m := vBP 1.1855)
    (Lo := 0.33968799) (Hi := 0.35497949) (Klo := 0.00005479519) (Khi := 0.000054808419)
    (by norm_num) (by norm_num) (by norm_num) errPt340
    vbpP340.1 vbpP340.2 vbpP341.1 vbpP341.2 vbpP308.1 vbpP308.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h23 := errBlockLin_of_piece (q0 := 1.21) (q1 := 1.211) (m := vBP 1.1855)
    (Lo := 0.33788411) (Hi := 0.3531607) (Klo := 0.000056960675) (Khi := 0.000056973894)
    (by norm_num) (by norm_num) (by norm_num) errPt341
    vbpP341.1 vbpP341.2 vbpP342.1 vbpP342.2 vbpP308.1 vbpP308.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h24 := errBlockLin_of_piece (q0 := 1.211) (q1 := 1.212) (m := vBP 1.1855)
    (Lo := 0.33603337) (Hi := 0.35129456) (Klo := 0.000059117501) (Khi := 0.000059130708)
    (by norm_num) (by norm_num) (by norm_num) errPt342
    vbpP342.1 vbpP342.2 vbpP343.1 vbpP343.2 vbpP308.1 vbpP308.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h25 := errBlockLin_of_piece (q0 := 1.212) (q1 := 1.213) (m := vBP 1.1855)
    (Lo := 0.33413636) (Hi := 0.34938164) (Klo := 0.000061264045) (Khi := 0.000061277242)
    (by norm_num) (by norm_num) (by norm_num) errPt343
    vbpP343.1 vbpP343.2 vbpP344.1 vbpP344.2 vbpP308.1 vbpP308.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h26 := errBlockLin_of_piece (q0 := 1.213) (q1 := 1.214) (m := vBP 1.1855)
    (Lo := 0.33219365) (Hi := 0.34742252) (Klo := 0.000063403637) (Khi := 0.000063416823)
    (by norm_num) (by norm_num) (by norm_num) errPt344
    vbpP344.1 vbpP344.2 vbpP345.1 vbpP345.2 vbpP308.1 vbpP308.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h27 := errBlockLin_of_piece (q0 := 1.214) (q1 := 1.215) (m := vBP 1.1855)
    (Lo := 0.33020583) (Hi := 0.3454178) (Klo := 0.000065533009) (Khi := 0.000065544538)
    (by norm_num) (by norm_num) (by norm_num) errPt345
    vbpP345.1 vbpP345.2 vbpP346.1 vbpP346.2 vbpP308.1 vbpP308.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h28 := errBlockLin_of_piece (q0 := 1.215) (q1 := 1.216) (m := vBP 1.1855)
    (Lo := 0.32817348) (Hi := 0.34336804) (Klo := 0.000067653839) (Khi := 0.000067665357)
    (by norm_num) (by norm_num) (by norm_num) errPt346
    vbpP346.1 vbpP346.2 vbpP347.1 vbpP347.2 vbpP308.1 vbpP308.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h29 := errBlockLin_of_piece (q0 := 1.216) (q1 := 1.217) (m := vBP 1.1855)
    (Lo := 0.3260972) (Hi := 0.34127385) (Klo := 0.000069764509) (Khi := 0.000069777662)
    (by norm_num) (by norm_num) (by norm_num) errPt347
    vbpP347.1 vbpP347.2 vbpP348.1 vbpP348.2 vbpP308.1 vbpP308.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  exact (((((((((((((((((((((((((((((h0.add h1).add h2).add h3).add h4).add h5).add h6).add h7).add h8).add h9).add h10).add h11).add h12).add h13).add h14).add h15).add h16).add h17).add h18).add h19).add h20).add h21).add h22).add h23).add h24).add h25).add h26).add h27).add h28).add h29).mono (by norm_num) (by norm_num) (by norm_num [mn4])
    (by norm_num [mx4]) (by norm_num)

theorem blkLo2_4 : errBlockLin (vBP 1.217) (vBP 1.227) (vBP 1.1855) 0.0041693427 0.0044055403 0.0002521689 0.0002666687 0.0044055403 := by
  have h0 := errBlockLin_of_piece (q0 := 1.217) (q1 := 1.218) (m := vBP 1.1855)
    (Lo := 0.32397759) (Hi := 0.33913582) (Klo := 0.000071866696) (Khi := 0.000071879839)
    (by norm_num) (by norm_num) (by norm_num) errPt348
    vbpP348.1 vbpP348.2 vbpP349.1 vbpP349.2 vbpP308.1 vbpP308.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h1 := errBlockLin_of_piece (q0 := 1.218) (q1 := 1.219) (m := vBP 1.1855)
    (Lo := 0.32181525) (Hi := 0.33695454) (Klo := 0.00007396207) (Khi := 0.000073975202)
    (by norm_num) (by norm_num) (by norm_num) errPt349
    vbpP349.1 vbpP349.2 vbpP350.1 vbpP350.2 vbpP308.1 vbpP308.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h2 := errBlockLin_of_piece (q0 := 1.219) (q1 := 1.22) (m := vBP 1.1855)
    (Lo := 0.31961076) (Hi := 0.33473062) (Klo := 0.000076047372) (Khi := 0.000076060494)
    (by norm_num) (by norm_num) (by norm_num) errPt350
    vbpP350.1 vbpP350.2 vbpP351.1 vbpP351.2 vbpP308.1 vbpP308.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h3 := errBlockLin_of_piece (q0 := 1.22) (q1 := 1.221) (m := vBP 1.1855)
    (Lo := 0.31736475) (Hi := 0.33246466) (Klo := 0.000078122637) (Khi := 0.000078135748)
    (by norm_num) (by norm_num) (by norm_num) errPt351
    vbpP351.1 vbpP351.2 vbpP352.1 vbpP352.2 vbpP308.1 vbpP308.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h4 := errBlockLin_of_piece (q0 := 1.221) (q1 := 1.222) (m := vBP 1.1855)
    (Lo := 0.31507782) (Hi := 0.33015726) (Klo := 0.000080189535) (Khi := 0.000080204271)
    (by norm_num) (by norm_num) (by norm_num) errPt352
    vbpP352.1 vbpP352.2 vbpP353.1 vbpP353.2 vbpP308.1 vbpP308.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h5 := errBlockLin_of_piece (q0 := 1.222) (q1 := 1.223) (m := vBP 1.1855)
    (Lo := 0.31275058) (Hi := 0.32780905) (Klo := 0.000082249725) (Khi := 0.00008226445)
    (by norm_num) (by norm_num) (by norm_num) errPt353
    vbpP353.1 vbpP353.2 vbpP354.1 vbpP354.2 vbpP308.1 vbpP308.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h6 := errBlockLin_of_piece (q0 := 1.223) (q1 := 1.224) (m := vBP 1.1855)
    (Lo := 0.31038364) (Hi := 0.32542062) (Klo := 0.000084299965) (Khi := 0.000084313043)
    (by norm_num) (by norm_num) (by norm_num) errPt354
    vbpP354.1 vbpP354.2 vbpP355.1 vbpP355.2 vbpP308.1 vbpP308.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h7 := errBlockLin_of_piece (q0 := 1.224) (q1 := 1.225) (m := vBP 1.1855)
    (Lo := 0.2829811) (Hi := 0.32376595) (Klo := 0.000086341919) (Khi := 0.000086354986)
    (by norm_num) (by norm_num) (by norm_num) errPt355
    vbpP355.1 vbpP355.2 vbpP356.1 vbpP356.2 vbpP308.1 vbpP308.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h8 := errBlockLin_of_piece (q0 := 1.225) (q1 := 1.226) (m := vBP 1.1855)
    (Lo := 0.30553093) (Hi := 0.32052814) (Klo := 0.000088375614) (Khi := 0.00008838867)
    (by norm_num) (by norm_num) (by norm_num) errPt356
    vbpP356.1 vbpP356.2 vbpP357.1 vbpP357.2 vbpP308.1 vbpP308.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h9 := errBlockLin_of_piece (q0 := 1.226) (q1 := 1.227) (m := vBP 1.1855)
    (Lo := 0.30304545) (Hi := 0.318026) (Klo := 0.000090399446) (Khi := 0.000090414122)
    (by norm_num) (by norm_num) (by norm_num) errPt357
    vbpP357.1 vbpP357.2 vbpP358.1 vbpP358.2 vbpP308.1 vbpP308.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  exact (((((((((h0.add h1).add h2).add h3).add h4).add h5).add h6).add h7).add h8).add h9).mono (by norm_num) (by norm_num) (by norm_num [mn4])
    (by norm_num [mx4]) (by norm_num)

theorem blkLo2 : errBlockLin (vBP 1.1455) (vBP 1.227) (vBP 1.1855) 0.0409561292 0.0422298817 (-0.0001001847) (-0.0000526043) 0.0422298817 :=
  errBlockLin.mono (errBlockLin.add (errBlockLin.add (errBlockLin.add (errBlockLin.add blkLo2_0 blkLo2_1) blkLo2_2) blkLo2_3) blkLo2_4) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
    (by norm_num)

theorem blkLo3_0 : errBlockLin (vBP 1.227) (vBP 1.257) (vBP 1.268) 0.0100950242 0.0106645083 (-0.0004587954) (-0.0004346057) 0.0106645083 := by
  have h0 := errBlockLin_of_piece (q0 := 1.227) (q1 := 1.228) (m := vBP 1.268)
    (Lo := 0.30052277) (Hi := 0.31548614) (Klo := (-0.000086195199)) (Khi := (-0.000086156094))
    (by norm_num) (by norm_num) (by norm_num) errPt358
    vbpP358.1 vbpP358.2 vbpP359.1 vbpP359.2 vbpP397.1 vbpP397.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h1 := errBlockLin_of_piece (q0 := 1.228) (q1 := 1.229) (m := vBP 1.268)
    (Lo := 0.29796349) (Hi := 0.31290918) (Klo := (-0.000083895466)) (Khi := (-0.000083858021))
    (by norm_num) (by norm_num) (by norm_num) errPt359
    vbpP359.1 vbpP359.2 vbpP360.1 vbpP360.2 vbpP397.1 vbpP397.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h2 := errBlockLin_of_piece (q0 := 1.229) (q1 := 1.23) (m := vBP 1.268)
    (Lo := 0.29536827) (Hi := 0.31029575) (Klo := (-0.00008160622)) (Khi := (-0.000081568806))
    (by norm_num) (by norm_num) (by norm_num) errPt360
    vbpP360.1 vbpP360.2 vbpP361.1 vbpP361.2 vbpP397.1 vbpP397.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h3 := errBlockLin_of_piece (q0 := 1.23) (q1 := 1.231) (m := vBP 1.268)
    (Lo := 0.29273774) (Hi := 0.3076465) (Klo := (-0.000079327428)) (Khi := (-0.000079288419))
    (by norm_num) (by norm_num) (by norm_num) errPt361
    vbpP361.1 vbpP361.2 vbpP362.1 vbpP362.2 vbpP397.1 vbpP397.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h4 := errBlockLin_of_piece (q0 := 1.231) (q1 := 1.232) (m := vBP 1.268)
    (Lo := 0.29007253) (Hi := 0.30496205) (Klo := (-0.000077055809)) (Khi := (-0.000077016831))
    (by norm_num) (by norm_num) (by norm_num) errPt362
    vbpP362.1 vbpP362.2 vbpP363.1 vbpP363.2 vbpP397.1 vbpP397.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h5 := errBlockLin_of_piece (q0 := 1.232) (q1 := 1.233) (m := vBP 1.268)
    (Lo := 0.28737328) (Hi := 0.30224304) (Klo := (-0.00007479296)) (Khi := (-0.000074754014))
    (by norm_num) (by norm_num) (by norm_num) errPt363
    vbpP363.1 vbpP363.2 vbpP364.1 vbpP364.2 vbpP397.1 vbpP397.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h6 := errBlockLin_of_piece (q0 := 1.233) (q1 := 1.234) (m := vBP 1.268)
    (Lo := 0.28464063) (Hi := 0.29949011) (Klo := (-0.000072538854)) (Khi := (-0.00007249994))
    (by norm_num) (by norm_num) (by norm_num) errPt364
    vbpP364.1 vbpP364.2 vbpP365.1 vbpP365.2 vbpP397.1 vbpP397.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h7 := errBlockLin_of_piece (q0 := 1.234) (q1 := 1.235) (m := vBP 1.268)
    (Lo := 0.28187524) (Hi := 0.29670391) (Klo := (-0.000070296702)) (Khi := (-0.000070257819))
    (by norm_num) (by norm_num) (by norm_num) errPt365
    vbpP365.1 vbpP365.2 vbpP366.1 vbpP366.2 vbpP397.1 vbpP397.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h8 := errBlockLin_of_piece (q0 := 1.235) (q1 := 1.236) (m := vBP 1.268)
    (Lo := 0.27907774) (Hi := 0.29388507) (Klo := (-0.000068059992)) (Khi := (-0.000068019522))
    (by norm_num) (by norm_num) (by norm_num) errPt366
    vbpP366.1 vbpP366.2 vbpP367.1 vbpP367.2 vbpP397.1 vbpP397.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h9 := errBlockLin_of_piece (q0 := 1.236) (q1 := 1.237) (m := vBP 1.268)
    (Lo := 0.27624878) (Hi := 0.29103426) (Klo := (-0.000065833558)) (Khi := (-0.000065793119))
    (by norm_num) (by norm_num) (by norm_num) errPt367
    vbpP367.1 vbpP367.2 vbpP368.1 vbpP368.2 vbpP397.1 vbpP397.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h10 := errBlockLin_of_piece (q0 := 1.237) (q1 := 1.238) (m := vBP 1.268)
    (Lo := 0.27338902) (Hi := 0.28815212) (Klo := (-0.000063615748)) (Khi := (-0.000063576959))
    (by norm_num) (by norm_num) (by norm_num) errPt368
    vbpP368.1 vbpP368.2 vbpP369.1 vbpP369.2 vbpP397.1 vbpP397.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h11 := errBlockLin_of_piece (q0 := 1.238) (q1 := 1.239) (m := vBP 1.268)
    (Lo := 0.27049911) (Hi := 0.28523929) (Klo := (-0.000061406538)) (Khi := (-0.000061366166))
    (by norm_num) (by norm_num) (by norm_num) errPt369
    vbpP369.1 vbpP369.2 vbpP370.1 vbpP370.2 vbpP397.1 vbpP397.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h12 := errBlockLin_of_piece (q0 := 1.239) (q1 := 1.24) (m := vBP 1.268)
    (Lo := 0.2675797) (Hi := 0.28229644) (Klo := (-0.000059207512)) (Khi := (-0.000059165558))
    (by norm_num) (by norm_num) (by norm_num) errPt370
    vbpP370.1 vbpP370.2 vbpP371.1 vbpP371.2 vbpP397.1 vbpP397.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h13 := errBlockLin_of_piece (q0 := 1.24) (q1 := 1.241) (m := vBP 1.268)
    (Lo := 0.26463145) (Hi := 0.27932422) (Klo := (-0.000057015413)) (Khi := (-0.000056973494))
    (by norm_num) (by norm_num) (by norm_num) errPt371
    vbpP371.1 vbpP371.2 vbpP372.1 vbpP372.2 vbpP397.1 vbpP397.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h14 := errBlockLin_of_piece (q0 := 1.241) (q1 := 1.242) (m := vBP 1.268)
    (Lo := 0.26165502) (Hi := 0.27632329) (Klo := (-0.000054833441)) (Khi := (-0.000054791555))
    (by norm_num) (by norm_num) (by norm_num) errPt372
    vbpP372.1 vbpP372.2 vbpP373.1 vbpP373.2 vbpP397.1 vbpP397.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h15 := errBlockLin_of_piece (q0 := 1.242) (q1 := 1.243) (m := vBP 1.268)
    (Lo := 0.25865107) (Hi := 0.27329431) (Klo := (-0.000052658344)) (Khi := (-0.000052616491))
    (by norm_num) (by norm_num) (by norm_num) errPt373
    vbpP373.1 vbpP373.2 vbpP374.1 vbpP374.2 vbpP397.1 vbpP397.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h16 := errBlockLin_of_piece (q0 := 1.243) (q1 := 1.244) (m := vBP 1.268)
    (Lo := 0.25562026) (Hi := 0.27023793) (Klo := (-0.000050493315)) (Khi := (-0.000050449889))
    (by norm_num) (by norm_num) (by norm_num) errPt374
    vbpP374.1 vbpP374.2 vbpP375.1 vbpP375.2 vbpP397.1 vbpP397.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h17 := errBlockLin_of_piece (q0 := 1.244) (q1 := 1.245) (m := vBP 1.268)
    (Lo := 0.25256326) (Hi := 0.26715483) (Klo := (-0.000048336717)) (Khi := (-0.000048293325))
    (by norm_num) (by norm_num) (by norm_num) errPt375
    vbpP375.1 vbpP375.2 vbpP376.1 vbpP376.2 vbpP397.1 vbpP397.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h18 := errBlockLin_of_piece (q0 := 1.245) (q1 := 1.246) (m := vBP 1.268)
    (Lo := 0.24948073) (Hi := 0.26404567) (Klo := (-0.000046186916)) (Khi := (-0.000046143559))
    (by norm_num) (by norm_num) (by norm_num) errPt376
    vbpP376.1 vbpP376.2 vbpP377.1 vbpP377.2 vbpP397.1 vbpP397.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h19 := errBlockLin_of_piece (q0 := 1.246) (q1 := 1.247) (m := vBP 1.268)
    (Lo := 0.24637334) (Hi := 0.26091112) (Klo := (-0.000044048703)) (Khi := (-0.000044003776))
    (by norm_num) (by norm_num) (by norm_num) errPt377
    vbpP377.1 vbpP377.2 vbpP378.1 vbpP378.2 vbpP397.1 vbpP397.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h20 := errBlockLin_of_piece (q0 := 1.247) (q1 := 1.248) (m := vBP 1.268)
    (Lo := 0.24324175) (Hi := 0.25775183) (Klo := (-0.00004191563)) (Khi := (-0.000041870739))
    (by norm_num) (by norm_num) (by norm_num) errPt378
    vbpP378.1 vbpP378.2 vbpP379.1 vbpP379.2 vbpP397.1 vbpP397.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h21 := errBlockLin_of_piece (q0 := 1.248) (q1 := 1.249) (m := vBP 1.268)
    (Lo := 0.24008664) (Hi := 0.25456849) (Klo := (-0.000039794086)) (Khi := (-0.000039749231))
    (by norm_num) (by norm_num) (by norm_num) errPt379
    vbpP379.1 vbpP379.2 vbpP380.1 vbpP380.2 vbpP397.1 vbpP397.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h22 := errBlockLin_of_piece (q0 := 1.249) (q1 := 1.25) (m := vBP 1.268)
    (Lo := 0.23690868) (Hi := 0.25136176) (Klo := (-0.000037677633)) (Khi := (-0.000037632814))
    (by norm_num) (by norm_num) (by norm_num) errPt380
    vbpP380.1 vbpP380.2 vbpP381.1 vbpP381.2 vbpP397.1 vbpP397.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h23 := errBlockLin_of_piece (q0 := 1.25) (q1 := 1.251) (m := vBP 1.268)
    (Lo := 0.23370853) (Hi := 0.24813231) (Klo := (-0.000035571052)) (Khi := (-0.000035526269))
    (by norm_num) (by norm_num) (by norm_num) errPt381
    vbpP381.1 vbpP381.2 vbpP382.1 vbpP382.2 vbpP397.1 vbpP397.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h24 := errBlockLin_of_piece (q0 := 1.251) (q1 := 1.252) (m := vBP 1.268)
    (Lo := 0.23048688) (Hi := 0.24488082) (Klo := (-0.000033474311)) (Khi := (-0.000033427966))
    (by norm_num) (by norm_num) (by norm_num) errPt382
    vbpP382.1 vbpP382.2 vbpP383.1 vbpP383.2 vbpP397.1 vbpP397.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h25 := errBlockLin_of_piece (q0 := 1.252) (q1 := 1.253) (m := vBP 1.268)
    (Lo := 0.22724439) (Hi := 0.24160797) (Klo := (-0.000031384188)) (Khi := (-0.000031337879))
    (by norm_num) (by norm_num) (by norm_num) errPt383
    vbpP383.1 vbpP383.2 vbpP384.1 vbpP384.2 vbpP397.1 vbpP397.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h26 := errBlockLin_of_piece (q0 := 1.253) (q1 := 1.254) (m := vBP 1.268)
    (Lo := 0.22398174) (Hi := 0.23831442) (Klo := (-0.000029302253)) (Khi := (-0.000029255982))
    (by norm_num) (by norm_num) (by norm_num) errPt384
    vbpP384.1 vbpP384.2 vbpP385.1 vbpP385.2 vbpP397.1 vbpP397.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h27 := errBlockLin_of_piece (q0 := 1.254) (q1 := 1.255) (m := vBP 1.268)
    (Lo := 0.2206996) (Hi := 0.23500085) (Klo := (-0.000027230077)) (Khi := (-0.000027182248))
    (by norm_num) (by norm_num) (by norm_num) errPt385
    vbpP385.1 vbpP385.2 vbpP386.1 vbpP386.2 vbpP397.1 vbpP397.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h28 := errBlockLin_of_piece (q0 := 1.255) (q1 := 1.256) (m := vBP 1.268)
    (Lo := 0.21739866) (Hi := 0.23166794) (Klo := (-0.000025164443)) (Khi := (-0.000025116653))
    (by norm_num) (by norm_num) (by norm_num) errPt386
    vbpP386.1 vbpP386.2 vbpP387.1 vbpP387.2 vbpP397.1 vbpP397.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h29 := errBlockLin_of_piece (q0 := 1.256) (q1 := 1.257) (m := vBP 1.268)
    (Lo := 0.21407958) (Hi := 0.22831637) (Klo := (-0.000023106921)) (Khi := (-0.000023059169))
    (by norm_num) (by norm_num) (by norm_num) errPt387
    vbpP387.1 vbpP387.2 vbpP388.1 vbpP388.2 vbpP397.1 vbpP397.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  exact (((((((((((((((((((((((((((((h0.add h1).add h2).add h3).add h4).add h5).add h6).add h7).add h8).add h9).add h10).add h11).add h12).add h13).add h14).add h15).add h16).add h17).add h18).add h19).add h20).add h21).add h22).add h23).add h24).add h25).add h26).add h27).add h28).add h29).mono (by norm_num) (by norm_num) (by norm_num [mn4])
    (by norm_num [mx4]) (by norm_num)

theorem blkLo3_1 : errBlockLin (vBP 1.257) (vBP 1.312) (vBP 1.268) 0.0072938782 0.0093333304 0.0000809874 0.0001521671 0.0093333304 := by
  have h0 := errBlockLin_of_piece (q0 := 1.257) (q1 := 1.258) (m := vBP 1.268)
    (Lo := 0.21074305) (Hi := 0.22494681) (Klo := (-0.000021059076)) (Khi := (-0.000021009771))
    (by norm_num) (by norm_num) (by norm_num) errPt388
    vbpP388.1 vbpP388.2 vbpP389.1 vbpP389.2 vbpP397.1 vbpP397.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h1 := errBlockLin_of_piece (q0 := 1.258) (q1 := 1.259) (m := vBP 1.268)
    (Lo := 0.20738974) (Hi := 0.22155995) (Klo := (-0.000019017699)) (Khi := (-0.000018966844))
    (by norm_num) (by norm_num) (by norm_num) errPt389
    vbpP389.1 vbpP389.2 vbpP390.1 vbpP390.2 vbpP397.1 vbpP397.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h2 := errBlockLin_of_piece (q0 := 1.259) (q1 := 1.26) (m := vBP 1.268)
    (Lo := 0.20402033) (Hi := 0.21815646) (Klo := (-0.000016985946)) (Khi := (-0.000016935131))
    (by norm_num) (by norm_num) (by norm_num) errPt390
    vbpP390.1 vbpP390.2 vbpP391.1 vbpP391.2 vbpP397.1 vbpP397.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h3 := errBlockLin_of_piece (q0 := 1.26) (q1 := 1.261) (m := vBP 1.268)
    (Lo := 0.2006355) (Hi := 0.21473702) (Klo := (-0.000014960611)) (Khi := (-0.000014909837))
    (by norm_num) (by norm_num) (by norm_num) errPt391
    vbpP391.1 vbpP391.2 vbpP392.1 vbpP392.2 vbpP397.1 vbpP397.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h4 := errBlockLin_of_piece (q0 := 1.261) (q1 := 1.262) (m := vBP 1.268)
    (Lo := 0.19723593) (Hi := 0.21130231) (Klo := (-0.000012944846)) (Khi := (-0.000012892527))
    (by norm_num) (by norm_num) (by norm_num) errPt392
    vbpP392.1 vbpP392.2 vbpP393.1 vbpP393.2 vbpP397.1 vbpP397.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h5 := errBlockLin_of_piece (q0 := 1.262) (q1 := 1.263) (m := vBP 1.268)
    (Lo := 0.19382229) (Hi := 0.20785301) (Klo := (-0.000010935453)) (Khi := (-0.000010881591))
    (by norm_num) (by norm_num) (by norm_num) errPt393
    vbpP393.1 vbpP393.2 vbpP394.1 vbpP394.2 vbpP397.1 vbpP397.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h6 := errBlockLin_of_piece (q0 := 1.263) (q1 := 1.264) (m := vBP 1.268)
    (Lo := 0.19039527) (Hi := 0.20438981) (Klo := (-0.000008935577)) (Khi := (-0.000008881757))
    (by norm_num) (by norm_num) (by norm_num) errPt394
    vbpP394.1 vbpP394.2 vbpP395.1 vbpP395.2 vbpP397.1 vbpP397.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h7 := errBlockLin_of_piece (q0 := 1.264) (q1 := 1.266) (m := vBP 1.268)
    (Lo := 0.17832247) (Hi := 0.20611127) (Klo := (-0.000011873081)) (Khi := (-0.000011817745))
    (by norm_num) (by norm_num) (by norm_num) errPt395
    vbpP395.1 vbpP395.2 vbpP396.1 vbpP396.2 vbpP397.1 vbpP397.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h8 := errBlockLin_of_piece (q0 := 1.266) (q1 := 1.268) (m := vBP 1.268)
    (Lo := 0.1714338) (Hi := 0.19907318) (Klo := (-0.000003961854)) (Khi := (-0.000003905026))
    (by norm_num) (by norm_num) (by norm_num) errPt396
    vbpP396.1 vbpP396.2 vbpP397.1 vbpP397.2 vbpP397.1 vbpP397.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h9 := errBlockLin_of_piece (q0 := 1.268) (q1 := 1.27) (m := vBP 1.268)
    (Lo := 0.16450479) (Hi := 0.19199067) (Klo := 0.00000388365) (Khi := 0.000003943539)
    (by norm_num) (by norm_num) (by norm_num) errPt397
    vbpP397.1 vbpP397.2 vbpP398.1 vbpP398.2 vbpP397.1 vbpP397.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h10 := errBlockLin_of_piece (q0 := 1.27) (q1 := 1.272) (m := vBP 1.268)
    (Lo := 0.15754085) (Hi := 0.18486919) (Klo := 0.000011668558) (Khi := 0.000011731502)
    (by norm_num) (by norm_num) (by norm_num) errPt398
    vbpP398.1 vbpP398.2 vbpP399.1 vbpP399.2 vbpP397.1 vbpP397.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h11 := errBlockLin_of_piece (q0 := 1.272) (q1 := 1.274) (m := vBP 1.268)
    (Lo := 0.15054735) (Hi := 0.17771415) (Klo := 0.000019393254) (Khi := 0.000019457669)
    (by norm_num) (by norm_num) (by norm_num) errPt399
    vbpP399.1 vbpP399.2 vbpP400.1 vbpP400.2 vbpP397.1 vbpP397.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h12 := errBlockLin_of_piece (q0 := 1.274) (q1 := 1.275) (m := vBP 1.268)
    (Lo := 0.15200832) (Hi := 0.16557083) (Klo := 0.000012557707) (Khi := 0.000012623616)
    (by norm_num) (by norm_num) (by norm_num) errPt400
    vbpP400.1 vbpP400.2 vbpP401.1 vbpP401.2 vbpP397.1 vbpP397.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h13 := errBlockLin_of_piece (q0 := 1.275) (q1 := 1.276) (m := vBP 1.268)
    (Lo := 0.14847346) (Hi := 0.16199366) (Klo := 0.000014465898) (Khi := 0.000014533323)
    (by norm_num) (by norm_num) (by norm_num) errPt401
    vbpP401.1 vbpP401.2 vbpP402.1 vbpP402.2 vbpP397.1 vbpP397.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h14 := errBlockLin_of_piece (q0 := 1.276) (q1 := 1.278) (m := vBP 1.268)
    (Lo := 0.1364932) (Hi := 0.16332506) (Klo := 0.000034660384) (Khi := 0.000034729297)
    (by norm_num) (by norm_num) (by norm_num) errPt402
    vbpP402.1 vbpP402.2 vbpP403.1 vbpP403.2 vbpP397.1 vbpP397.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h15 := errBlockLin_of_piece (q0 := 1.278) (q1 := 1.28) (m := vBP 1.268)
    (Lo := 0.12944324) (Hi := 0.15610178) (Klo := 0.000042203579) (Khi := 0.000042275509)
    (by norm_num) (by norm_num) (by norm_num) errPt403
    vbpP403.1 vbpP403.2 vbpP404.1 vbpP404.2 vbpP397.1 vbpP397.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h16 := errBlockLin_of_piece (q0 := 1.28) (q1 := 1.282) (m := vBP 1.268)
    (Lo := 0.12238512) (Hi := 0.1488665) (Klo := 0.000049688065) (Khi := 0.000049763008)
    (by norm_num) (by norm_num) (by norm_num) errPt404
    vbpP404.1 vbpP404.2 vbpP405.1 vbpP405.2 vbpP397.1 vbpP397.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h17 := errBlockLin_of_piece (q0 := 1.282) (q1 := 1.284) (m := vBP 1.268)
    (Lo := 0.11532411) (Hi := 0.14162455) (Klo := 0.000057114212) (Khi := 0.000057190595)
    (by norm_num) (by norm_num) (by norm_num) errPt405
    vbpP405.1 vbpP405.2 vbpP406.1 vbpP406.2 vbpP397.1 vbpP397.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h18 := errBlockLin_of_piece (q0 := 1.284) (q1 := 1.286) (m := vBP 1.268)
    (Lo := 0.10826546) (Hi := 0.13438123) (Klo := 0.000064480826) (Khi := 0.000064561758)
    (by norm_num) (by norm_num) (by norm_num) errPt406
    vbpP406.1 vbpP406.2 vbpP407.1 vbpP407.2 vbpP397.1 vbpP397.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h19 := errBlockLin_of_piece (q0 := 1.286) (q1 := 1.289) (m := vBP 1.268)
    (Lo := 0.09303484) (Hi := 0.13181931) (Klo := 0.000110428972) (Khi := 0.00011051596)
    (by norm_num) (by norm_num) (by norm_num) errPt407
    vbpP407.1 vbpP407.2 vbpP408.1 vbpP408.2 vbpP397.1 vbpP397.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h20 := errBlockLin_of_piece (q0 := 1.289) (q1 := 1.292) (m := vBP 1.268)
    (Lo := 0.08256303) (Hi := 0.12091297) (Klo := 0.000126682293) (Khi := 0.000126775278)
    (by norm_num) (by norm_num) (by norm_num) errPt408
    vbpP408.1 vbpP408.2 vbpP409.1 vbpP409.2 vbpP397.1 vbpP397.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h21 := errBlockLin_of_piece (q0 := 1.292) (q1 := 1.294) (m := vBP 1.268)
    (Lo := 0.08015829) (Hi := 0.10549926) (Klo := 0.00009337472) (Khi := 0.000093472168)
    (by norm_num) (by norm_num) (by norm_num) errPt409
    vbpP409.1 vbpP409.2 vbpP410.1 vbpP410.2 vbpP397.1 vbpP397.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h22 := errBlockLin_of_piece (q0 := 1.294) (q1 := 1.296) (m := vBP 1.268)
    (Lo := 0.07318892) (Hi := 0.0983275) (Klo := 0.000100458364) (Khi := 0.00010055875)
    (by norm_num) (by norm_num) (by norm_num) errPt410
    vbpP410.1 vbpP410.2 vbpP411.1 vbpP411.2 vbpP397.1 vbpP397.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h23 := errBlockLin_of_piece (q0 := 1.296) (q1 := 1.298) (m := vBP 1.268)
    (Lo := 0.06625256) (Hi := 0.09118544) (Klo := 0.000107484608) (Khi := 0.000107591005)
    (by norm_num) (by norm_num) (by norm_num) errPt411
    vbpP411.1 vbpP411.2 vbpP412.1 vbpP412.2 vbpP397.1 vbpP397.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h24 := errBlockLin_of_piece (q0 := 1.298) (q1 := 1.3) (m := vBP 1.268)
    (Lo := 0.05935417) (Hi := 0.0840781) (Klo := 0.000114455339) (Khi := 0.000114567733)
    (by norm_num) (by norm_num) (by norm_num) errPt412
    vbpP412.1 vbpP412.2 vbpP413.1 vbpP413.2 vbpP397.1 vbpP397.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h25 := errBlockLin_of_piece (q0 := 1.3) (q1 := 1.303) (m := vBP 1.268)
    (Lo := 0.04472926) (Hi := 0.08138752) (Klo := 0.000184665675) (Khi := 0.000184785531)
    (by norm_num) (by norm_num) (by norm_num) errPt413
    vbpP413.1 vbpP413.2 vbpP414.1 vbpP414.2 vbpP397.1 vbpP397.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h26 := errBlockLin_of_piece (q0 := 1.303) (q1 := 1.308) (m := vBP 1.268)
    (Lo := 0.01943908) (Hi := 0.07941416) (Klo := 0.00034191334) (Khi := 0.000342046609)
    (by norm_num) (by norm_num) (by norm_num) errPt414
    vbpP414.1 vbpP414.2 vbpP415.1 vbpP415.2 vbpP397.1 vbpP397.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h27 := errBlockLin_of_piece (q0 := 1.308) (q1 := 1.312) (m := vBP 1.268)
    (Lo := 0.01066612) (Hi := 0.05765437) (Klo := 0.00030372636) (Khi := 0.000303872917)
    (by norm_num) (by norm_num) (by norm_num) errPt415
    vbpP415.1 vbpP415.2 vbpP416.1 vbpP416.2 vbpP397.1 vbpP397.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  exact (((((((((((((((((((((((((((h0.add h1).add h2).add h3).add h4).add h5).add h6).add h7).add h8).add h9).add h10).add h11).add h12).add h13).add h14).add h15).add h16).add h17).add h18).add h19).add h20).add h21).add h22).add h23).add h24).add h25).add h26).add h27).mono (by norm_num) (by norm_num) (by norm_num [mn4])
    (by norm_num [mx4]) (by norm_num)

theorem blkLo3 : errBlockLin (vBP 1.227) (vBP 1.312) (vBP 1.268) 0.0173889024 0.0199978387 (-0.000377808) (-0.0002824386) 0.0199978387 :=
  errBlockLin.mono (errBlockLin.add blkLo3_0 blkLo3_1) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
    (by norm_num)

end ConnesConsani.WeilPositivity
