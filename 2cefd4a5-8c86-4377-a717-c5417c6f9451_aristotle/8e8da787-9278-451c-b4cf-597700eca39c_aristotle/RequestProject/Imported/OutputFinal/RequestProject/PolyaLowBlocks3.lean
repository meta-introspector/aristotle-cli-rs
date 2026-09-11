/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.
-/
import RequestProject.Imported.OutputFinal.RequestProject.PolyaLowBlocks2

/-!
# The block data for the low-frequency bands (part 3)

Blocks of the extended partition `q ∈ [1,5]`, grouped so that the phase `tv`
varies by at most `0.25` across a block for `t ≤ 1.8`; long blocks are assembled
from sub-blocks of at most 30 pieces.
-/

set_option maxHeartbeats 4000000

noncomputable section

open MeasureTheory Set Real

namespace ConnesConsani.WeilPositivity

theorem blkLo4_0 : errBlockLin (vBP 1.312) (vBP 1.4) (vBP 1.358) (-0.0093080268) (-0.0061121769) (-0.000211074) (-0.0000877764) 0.0095704678 := by
  have h0 := errBlockLin_of_piece (q0 := 1.312) (q1 := 1.317) (m := vBP 1.358)
    (Lo := (-0.00934377)) (Hi := 0.0480906) (Klo := (-0.000377183249)) (Khi := (-0.000376553372))
    (by norm_num) (by norm_num) (by norm_num) errPt416
    vbpP416.1 vbpP416.2 vbpP417.1 vbpP417.2 vbpP428.1 vbpP428.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h1 := errBlockLin_of_piece (q0 := 1.317) (q1 := 1.322) (m := vBP 1.358)
    (Lo := (-0.02465815)) (Hi := 0.03130892) (Klo := (-0.000330732243)) (Khi := (-0.0003300805))
    (by norm_num) (by norm_num) (by norm_num) errPt417
    vbpP417.1 vbpP417.2 vbpP418.1 vbpP418.2 vbpP428.1 vbpP428.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h2 := errBlockLin_of_piece (q0 := 1.322) (q1 := 1.326) (m := vBP 1.358)
    (Lo := (-0.04506155)) (Hi := 0.02271074) (Klo := (-0.000231782516)) (Khi := (-0.000231110324))
    (by norm_num) (by norm_num) (by norm_num) errPt418
    vbpP418.1 vbpP418.2 vbpP419.1 vbpP419.2 vbpP428.1 vbpP428.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h3 := errBlockLin_of_piece (q0 := 1.326) (q1 := 1.331) (m := vBP 1.358)
    (Lo := (-0.05078406)) (Hi := 0.00249367) (Klo := (-0.000249262819)) (Khi := (-0.00024856582))
    (by norm_num) (by norm_num) (by norm_num) errPt419
    vbpP419.1 vbpP419.2 vbpP420.1 vbpP420.2 vbpP428.1 vbpP428.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h4 := errBlockLin_of_piece (q0 := 1.331) (q1 := 1.336) (m := vBP 1.358)
    (Lo := (-0.06438461)) (Hi := (-0.01262708)) (Klo := (-0.000205163382)) (Khi := (-0.000204433007))
    (by norm_num) (by norm_num) (by norm_num) errPt420
    vbpP420.1 vbpP420.2 vbpP421.1 vbpP421.2 vbpP428.1 vbpP428.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h5 := errBlockLin_of_piece (q0 := 1.336) (q1 := 1.34) (m := vBP 1.358)
    (Lo := (-0.07105739)) (Hi := (-0.03073683)) (Klo := (-0.000133000796)) (Khi := (-0.000132238484))
    (by norm_num) (by norm_num) (by norm_num) errPt421
    vbpP421.1 vbpP421.2 vbpP422.1 vbpP422.2 vbpP428.1 vbpP428.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h6 := errBlockLin_of_piece (q0 := 1.34) (q1 := 1.345) (m := vBP 1.358)
    (Lo := (-0.0870134)) (Hi := (-0.03803994)) (Klo := (-0.000127816557)) (Khi := (-0.000127019574))
    (by norm_num) (by norm_num) (by norm_num) errPt422
    vbpP422.1 vbpP422.2 vbpP423.1 vbpP423.2 vbpP428.1 vbpP428.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h7 := errBlockLin_of_piece (q0 := 1.345) (q1 := 1.348) (m := vBP 1.358)
    (Lo := (-0.08686965)) (Hi := (-0.05816597)) (Klo := (-0.000056710489)) (Khi := (-0.000055878717))
    (by norm_num) (by norm_num) (by norm_num) errPt423
    vbpP423.1 vbpP423.2 vbpP424.1 vbpP424.2 vbpP428.1 vbpP428.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h8 := errBlockLin_of_piece (q0 := 1.348) (q1 := 1.35) (m := vBP 1.358)
    (Lo := (-0.08789711)) (Hi := (-0.06900355)) (Klo := (-0.00002966068)) (Khi := (-0.000028805237))
    (by norm_num) (by norm_num) (by norm_num) errPt424
    vbpP424.1 vbpP424.2 vbpP425.1 vbpP425.2 vbpP428.1 vbpP428.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h9 := errBlockLin_of_piece (q0 := 1.35) (q1 := 1.352) (m := vBP 1.358)
    (Lo := (-0.09233774)) (Hi := (-0.07368344)) (Klo := (-0.000023091318)) (Khi := (-0.000022214937))
    (by norm_num) (by norm_num) (by norm_num) errPt425
    vbpP425.1 vbpP425.2 vbpP426.1 vbpP426.2 vbpP428.1 vbpP428.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h10 := errBlockLin_of_piece (q0 := 1.352) (q1 := 1.355) (m := vBP 1.358)
    (Lo := (-0.10218342)) (Hi := (-0.07476776)) (Klo := (-0.000022200184)) (Khi := (-0.000021295879))
    (by norm_num) (by norm_num) (by norm_num) errPt426
    vbpP426.1 vbpP426.2 vbpP427.1 vbpP427.2 vbpP428.1 vbpP428.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h11 := errBlockLin_of_piece (q0 := 1.355) (q1 := 1.358) (m := vBP 1.358)
    (Lo := (-0.10822264)) (Hi := (-0.08135441)) (Klo := (-0.000007681907)) (Khi := (-0.000006744217))
    (by norm_num) (by norm_num) (by norm_num) errPt427
    vbpP427.1 vbpP427.2 vbpP428.1 vbpP428.2 vbpP428.1 vbpP428.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h12 := errBlockLin_of_piece (q0 := 1.358) (q1 := 1.36) (m := vBP 1.358)
    (Lo := (-0.10869567)) (Hi := (-0.09098268)) (Klo := 0.000002702737) (Khi := 0.000003671087)
    (by norm_num) (by norm_num) (by norm_num) errPt428
    vbpP428.1 vbpP428.2 vbpP429.1 vbpP429.2 vbpP428.1 vbpP428.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h13 := errBlockLin_of_piece (q0 := 1.36) (q1 := 1.362) (m := vBP 1.358)
    (Lo := (-0.11242482)) (Hi := (-0.09494148)) (Klo := 0.000009031817) (Khi := 0.000010026665)
    (by norm_num) (by norm_num) (by norm_num) errPt429
    vbpP429.1 vbpP429.2 vbpP430.1 vbpP430.2 vbpP428.1 vbpP428.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h14 := errBlockLin_of_piece (q0 := 1.362) (q1 := 1.364) (m := vBP 1.358)
    (Lo := (-0.11600671)) (Hi := (-0.09874996)) (Klo := 0.000015313976) (Khi := 0.000016335244)
    (by norm_num) (by norm_num) (by norm_num) errPt430
    vbpP430.1 vbpP430.2 vbpP431.1 vbpP431.2 vbpP428.1 vbpP428.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h15 := errBlockLin_of_piece (q0 := 1.364) (q1 := 1.366) (m := vBP 1.358)
    (Lo := (-0.11944006)) (Hi := (-0.10240641)) (Klo := 0.000021549488) (Khi := 0.000022598563)
    (by norm_num) (by norm_num) (by norm_num) errPt431
    vbpP431.1 vbpP431.2 vbpP432.1 vbpP432.2 vbpP428.1 vbpP428.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h16 := errBlockLin_of_piece (q0 := 1.366) (q1 := 1.369) (m := vBP 1.358)
    (Lo := (-0.12756152)) (Hi := (-0.10264804)) (Klo := 0.000044185287) (Khi := 0.000045271917)
    (by norm_num) (by norm_num) (by norm_num) errPt432
    vbpP432.1 vbpP432.2 vbpP433.1 vbpP433.2 vbpP428.1 vbpP428.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h17 := errBlockLin_of_piece (q0 := 1.369) (q1 := 1.372) (m := vBP 1.358)
    (Lo := (-0.13205232)) (Hi := (-0.10765005)) (Klo := 0.000057964604) (Khi := 0.00005909993)
    (by norm_num) (by norm_num) (by norm_num) errPt433
    vbpP433.1 vbpP433.2 vbpP434.1 vbpP434.2 vbpP428.1 vbpP428.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h18 := errBlockLin_of_piece (q0 := 1.372) (q1 := 1.374) (m := vBP 1.358)
    (Lo := (-0.13166818)) (Hi := (-0.11548222)) (Klo := 0.00004602756) (Khi := 0.00004720599)
    (by norm_num) (by norm_num) (by norm_num) errPt434
    vbpP434.1 vbpP434.2 vbpP435.1 vbpP435.2 vbpP428.1 vbpP428.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h19 := errBlockLin_of_piece (q0 := 1.374) (q1 := 1.376) (m := vBP 1.358)
    (Lo := (-0.13434546)) (Hi := (-0.11835749)) (Klo := 0.000052033878) (Khi := 0.000053248412)
    (by norm_num) (by norm_num) (by norm_num) errPt435
    vbpP435.1 vbpP435.2 vbpP436.1 vbpP436.2 vbpP428.1 vbpP428.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h20 := errBlockLin_of_piece (q0 := 1.376) (q1 := 1.378) (m := vBP 1.358)
    (Lo := (-0.1368701)) (Hi := (-0.12107328)) (Klo := 0.000057993698) (Khi := 0.000059245682)
    (by norm_num) (by norm_num) (by norm_num) errPt436
    vbpP436.1 vbpP436.2 vbpP437.1 vbpP437.2 vbpP428.1 vbpP428.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h21 := errBlockLin_of_piece (q0 := 1.378) (q1 := 1.38) (m := vBP 1.358)
    (Lo := (-0.13924204)) (Hi := (-0.12362886)) (Klo := 0.000063911636) (Khi := 0.000065200964)
    (by norm_num) (by norm_num) (by norm_num) errPt437
    vbpP437.1 vbpP437.2 vbpP438.1 vbpP438.2 vbpP428.1 vbpP428.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h22 := errBlockLin_of_piece (q0 := 1.38) (q1 := 1.383) (m := vBP 1.358)
    (Lo := (-0.14559459)) (Hi := (-0.12293589)) (Klo := 0.000107199126) (Khi := 0.000108539662)
    (by norm_num) (by norm_num) (by norm_num) errPt438
    vbpP438.1 vbpP438.2 vbpP439.1 vbpP439.2 vbpP428.1 vbpP428.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h23 := errBlockLin_of_piece (q0 := 1.383) (q1 := 1.386) (m := vBP 1.358)
    (Lo := (-0.14849049)) (Hi := (-0.12625996)) (Klo := 0.000120277585) (Khi := 0.000121685999)
    (by norm_num) (by norm_num) (by norm_num) errPt439
    vbpP439.1 vbpP439.2 vbpP440.1 vbpP440.2 vbpP428.1 vbpP428.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h24 := errBlockLin_of_piece (q0 := 1.386) (q1 := 1.388) (m := vBP 1.358)
    (Lo := (-0.14720873)) (Hi := (-0.13223884)) (Klo := 0.00008713628) (Khi := 0.000088601298)
    (by norm_num) (by norm_num) (by norm_num) errPt440
    vbpP440.1 vbpP440.2 vbpP441.1 vbpP441.2 vbpP428.1 vbpP428.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h25 := errBlockLin_of_piece (q0 := 1.388) (q1 := 1.39) (m := vBP 1.358)
    (Lo := (-0.14882335)) (Hi := (-0.13398694)) (Klo := 0.000092834099) (Khi := 0.0000943474)
    (by norm_num) (by norm_num) (by norm_num) errPt441
    vbpP441.1 vbpP441.2 vbpP442.1 vbpP442.2 vbpP428.1 vbpP428.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h26 := errBlockLin_of_piece (q0 := 1.39) (q1 := 1.392) (m := vBP 1.358)
    (Lo := (-0.15028917)) (Hi := (-0.13557324)) (Klo := 0.000098488642) (Khi := 0.000100052967)
    (by norm_num) (by norm_num) (by norm_num) errPt442
    vbpP442.1 vbpP442.2 vbpP443.1 vbpP443.2 vbpP428.1 vbpP428.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h27 := errBlockLin_of_piece (q0 := 1.392) (q1 := 1.394) (m := vBP 1.358)
    (Lo := (-0.15160758)) (Hi := (-0.13699795)) (Klo := 0.000104101595) (Khi := 0.000105718231)
    (by norm_num) (by norm_num) (by norm_num) errPt443
    vbpP443.1 vbpP443.2 vbpP444.1 vbpP444.2 vbpP428.1 vbpP428.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h28 := errBlockLin_of_piece (q0 := 1.394) (q1 := 1.397) (m := vBP 1.358)
    (Lo := (-0.15624074)) (Hi := (-0.13532693)) (Klo := 0.000167004054) (Khi := 0.00016869086)
    (by norm_num) (by norm_num) (by norm_num) errPt444
    vbpP444.1 vbpP444.2 vbpP445.1 vbpP445.2 vbpP428.1 vbpP428.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h29 := errBlockLin_of_piece (q0 := 1.397) (q1 := 1.4) (m := vBP 1.358)
    (Lo := (-0.15759378)) (Hi := (-0.13695124)) (Klo := 0.000179416469) (Khi := 0.000181191181)
    (by norm_num) (by norm_num) (by norm_num) errPt445
    vbpP445.1 vbpP445.2 vbpP446.1 vbpP446.2 vbpP428.1 vbpP428.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  exact (((((((((((((((((((((((((((((h0.add h1).add h2).add h3).add h4).add h5).add h6).add h7).add h8).add h9).add h10).add h11).add h12).add h13).add h14).add h15).add h16).add h17).add h18).add h19).add h20).add h21).add h22).add h23).add h24).add h25).add h26).add h27).add h28).add h29).mono (by norm_num) (by norm_num) (by norm_num [mn4])
    (by norm_num [mx4]) (by norm_num)

theorem blkLo4_1 : errBlockLin (vBP 1.4) (vBP 1.406) (vBP 1.358) (-0.0009510723) (-0.000863612) (-0.0000624575) (-0.0000559002) 0.0009510723 := by
  have h0 := errBlockLin_of_piece (q0 := 1.4) (q1 := 1.402) (m := vBP 1.358)
    (Lo := (-0.15544295)) (Hi := (-0.14108999)) (Klo := 0.000126130802) (Khi := 0.000127980889)
    (by norm_num) (by norm_num) (by norm_num) errPt446
    vbpP446.1 vbpP446.2 vbpP447.1 vbpP447.2 vbpP428.1 vbpP428.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h1 := errBlockLin_of_piece (q0 := 1.402) (q1 := 1.404) (m := vBP 1.358)
    (Lo := (-0.15605328)) (Hi := (-0.1417147)) (Klo := 0.000131533649) (Khi := 0.000133448095)
    (by norm_num) (by norm_num) (by norm_num) errPt447
    vbpP447.1 vbpP447.2 vbpP448.1 vbpP448.2 vbpP428.1 vbpP428.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h2 := errBlockLin_of_piece (q0 := 1.404) (q1 := 1.406) (m := vBP 1.358)
    (Lo := (-0.15652951)) (Hi := (-0.1421819)) (Klo := 0.000136896321) (Khi := 0.000138879216)
    (by norm_num) (by norm_num) (by norm_num) errPt448
    vbpP448.1 vbpP448.2 vbpP449.1 vbpP449.2 vbpP428.1 vbpP428.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  exact ((h0.add h1).add h2).mono (by norm_num) (by norm_num) (by norm_num [mn4])
    (by norm_num [mx4]) (by norm_num)

theorem blkLo4 : errBlockLin (vBP 1.312) (vBP 1.406) (vBP 1.358) (-0.0102590991) (-0.0069757889) (-0.0002735315) (-0.0001436766) 0.0105215401 :=
  errBlockLin.mono (errBlockLin.add blkLo4_0 blkLo4_1) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
    (by norm_num)

theorem blkLo5_0 : errBlockLin (vBP 1.406) (vBP 1.478) (vBP 1.453) (-0.009835797) (-0.0081291364) 0.0001479246 0.0002183538 0.009835797 := by
  have h0 := errBlockLin_of_piece (q0 := 1.406) (q1 := 1.408) (m := vBP 1.453)
    (Lo := (-0.15687475)) (Hi := (-0.1424927)) (Klo := (-0.000132975428)) (Khi := (-0.000127036574))
    (by norm_num) (by norm_num) (by norm_num) errPt449
    vbpP449.1 vbpP449.2 vbpP450.1 vbpP450.2 vbpP469.1 vbpP469.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h1 := errBlockLin_of_piece (q0 := 1.408) (q1 := 1.411) (m := vBP 1.453)
    (Lo := (-0.15994837)) (Hi := (-0.13984804)) (Klo := (-0.000186608884)) (Khi := (-0.000180585526))
    (by norm_num) (by norm_num) (by norm_num) errPt450
    vbpP450.1 vbpP450.2 vbpP451.1 vbpP451.2 vbpP469.1 vbpP469.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h2 := errBlockLin_of_piece (q0 := 1.411) (q1 := 1.414) (m := vBP 1.453)
    (Lo := (-0.15992701)) (Hi := (-0.13982)) (Klo := (-0.000173095065)) (Khi := (-0.00016696415))
    (by norm_num) (by norm_num) (by norm_num) errPt451
    vbpP451.1 vbpP451.2 vbpP452.1 vbpP452.2 vbpP469.1 vbpP469.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h3 := errBlockLin_of_piece (q0 := 1.414) (q1 := 1.416) (m := vBP 1.453)
    (Lo := (-0.15762364)) (Hi := (-0.1191471)) (Klo := (-0.000108998784)) (Khi := (-0.000102772662))
    (by norm_num) (by norm_num) (by norm_num) errPt452
    vbpP452.1 vbpP452.2 vbpP453.1 vbpP453.2 vbpP469.1 vbpP469.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h4 := errBlockLin_of_piece (q0 := 1.416) (q1 := 1.418) (m := vBP 1.453)
    (Lo := (-0.1567856)) (Hi := (-0.14172795)) (Klo := (-0.00010311322)) (Khi := (-0.000096806967))
    (by norm_num) (by norm_num) (by norm_num) errPt453
    vbpP453.1 vbpP453.2 vbpP454.1 vbpP454.2 vbpP469.1 vbpP469.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h5 := errBlockLin_of_piece (q0 := 1.418) (q1 := 1.42) (m := vBP 1.453)
    (Lo := (-0.15644116)) (Hi := (-0.14111566)) (Klo := (-0.000097268075)) (Khi := (-0.000090879097))
    (by norm_num) (by norm_num) (by norm_num) errPt454
    vbpP454.1 vbpP454.2 vbpP455.1 vbpP455.2 vbpP469.1 vbpP469.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h6 := errBlockLin_of_piece (q0 := 1.42) (q1 := 1.422) (m := vBP 1.453)
    (Lo := (-0.15599584)) (Hi := (-0.14035792)) (Klo := (-0.000091467343)) (Khi := (-0.000084991652))
    (by norm_num) (by norm_num) (by norm_num) errPt455
    vbpP455.1 vbpP455.2 vbpP456.1 vbpP456.2 vbpP469.1 vbpP469.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h7 := errBlockLin_of_piece (q0 := 1.422) (q1 := 1.425) (m := vBP 1.453)
    (Lo := (-0.1578555)) (Hi := (-0.13673664)) (Klo := (-0.000124767874)) (Khi := (-0.00011817715))
    (by norm_num) (by norm_num) (by norm_num) errPt456
    vbpP456.1 vbpP456.2 vbpP457.1 vbpP457.2 vbpP469.1 vbpP469.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h8 := errBlockLin_of_piece (q0 := 1.425) (q1 := 1.428) (m := vBP 1.453)
    (Lo := (-0.15680391)) (Hi := (-0.13513265)) (Klo := (-0.000111914501)) (Khi := (-0.000105180613))
    (by norm_num) (by norm_num) (by norm_num) errPt457
    vbpP457.1 vbpP457.2 vbpP458.1 vbpP458.2 vbpP469.1 vbpP469.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h9 := errBlockLin_of_piece (q0 := 1.428) (q1 := 1.43) (m := vBP 1.453)
    (Lo := (-0.15332385)) (Hi := (-0.13591306)) (Klo := (-0.000068678497)) (Khi := (-0.000061820589))
    (by norm_num) (by norm_num) (by norm_num) errPt458
    vbpP458.1 vbpP458.2 vbpP459.1 vbpP459.2 vbpP469.1 vbpP469.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h10 := errBlockLin_of_piece (q0 := 1.43) (q1 := 1.432) (m := vBP 1.453)
    (Lo := (-0.15246618)) (Hi := (-0.13445916)) (Klo := (-0.000063085057)) (Khi := (-0.000056122131))
    (by norm_num) (by norm_num) (by norm_num) errPt459
    vbpP459.1 vbpP459.2 vbpP460.1 vbpP460.2 vbpP469.1 vbpP469.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h11 := errBlockLin_of_piece (q0 := 1.432) (q1 := 1.434) (m := vBP 1.453)
    (Lo := (-0.15154733)) (Hi := (-0.13287271)) (Klo := (-0.000057531833)) (Khi := (-0.000050459993))
    (by norm_num) (by norm_num) (by norm_num) errPt460
    vbpP460.1 vbpP460.2 vbpP461.1 vbpP461.2 vbpP469.1 vbpP469.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h12 := errBlockLin_of_piece (q0 := 1.434) (q1 := 1.436) (m := vBP 1.453)
    (Lo := (-0.15057546)) (Hi := (-0.13115606)) (Klo := (-0.000052019994)) (Khi := (-0.000044835365))
    (by norm_num) (by norm_num) (by norm_num) errPt461
    vbpP461.1 vbpP461.2 vbpP462.1 vbpP462.2 vbpP469.1 vbpP469.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h13 := errBlockLin_of_piece (q0 := 1.436) (q1 := 1.439) (m := vBP 1.453)
    (Lo := (-0.1516834)) (Hi := (-0.12664439)) (Klo := (-0.000065949181)) (Khi := (-0.00005861571))
    (by norm_num) (by norm_num) (by norm_num) errPt462
    vbpP462.1 vbpP462.2 vbpP463.1 vbpP463.2 vbpP469.1 vbpP469.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h14 := errBlockLin_of_piece (q0 := 1.439) (q1 := 1.442) (m := vBP 1.453)
    (Lo := (-0.15006518)) (Hi := (-0.12365332)) (Klo := (-0.000053728267)) (Khi := (-0.000046207366))
    (by norm_num) (by norm_num) (by norm_num) errPt463
    vbpP463.1 vbpP463.2 vbpP464.1 vbpP464.2 vbpP469.1 vbpP469.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h15 := errBlockLin_of_piece (q0 := 1.442) (q1 := 1.444) (m := vBP 1.453)
    (Lo := (-0.14633879)) (Hi := (-0.12303561)) (Klo := (-0.000030373685)) (Khi := (-0.000022689739))
    (by norm_num) (by norm_num) (by norm_num) errPt464
    vbpP464.1 vbpP464.2 vbpP465.1 vbpP465.2 vbpP469.1 vbpP469.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h16 := errBlockLin_of_piece (q0 := 1.444) (q1 := 1.446) (m := vBP 1.453)
    (Lo := (-0.14524249)) (Hi := (-0.12070415)) (Klo := (-0.000025062659)) (Khi := (-0.000017241253))
    (by norm_num) (by norm_num) (by norm_num) errPt465
    vbpP465.1 vbpP465.2 vbpP466.1 vbpP466.2 vbpP469.1 vbpP469.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h17 := errBlockLin_of_piece (q0 := 1.446) (q1 := 1.448) (m := vBP 1.453)
    (Lo := (-0.14415354)) (Hi := (-0.11825699)) (Klo := (-0.000019790312)) (Khi := (-0.000011827678))
    (by norm_num) (by norm_num) (by norm_num) errPt466
    vbpP466.1 vbpP466.2 vbpP467.1 vbpP467.2 vbpP469.1 vbpP469.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h18 := errBlockLin_of_piece (q0 := 1.448) (q1 := 1.45) (m := vBP 1.453)
    (Lo := (-0.14308419)) (Hi := (-0.11569651)) (Klo := (-0.00001455643)) (Khi := (-0.000006447441))
    (by norm_num) (by norm_num) (by norm_num) errPt467
    vbpP467.1 vbpP467.2 vbpP468.1 vbpP468.2 vbpP469.1 vbpP469.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h19 := errBlockLin_of_piece (q0 := 1.45) (q1 := 1.453) (m := vBP 1.453)
    (Lo := (-0.14413656)) (Hi := (-0.11040144)) (Klo := (-0.000010034992)) (Khi := (-0.000001733355))
    (by norm_num) (by norm_num) (by norm_num) errPt468
    vbpP468.1 vbpP468.2 vbpP469.1 vbpP469.2 vbpP469.1 vbpP469.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h20 := errBlockLin_of_piece (q0 := 1.453) (q1 := 1.456) (m := vBP 1.453)
    (Lo := (-0.14270636)) (Hi := (-0.10619963)) (Klo := 0.000001581479) (Khi := 0.000010124494)
    (by norm_num) (by norm_num) (by norm_num) errPt469
    vbpP469.1 vbpP469.2 vbpP470.1 vbpP470.2 vbpP469.1 vbpP469.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h21 := errBlockLin_of_piece (q0 := 1.456) (q1 := 1.458) (m := vBP 1.453)
    (Lo := (-0.13927452)) (Hi := (-0.10436678)) (Klo := 0.000005986231) (Khi := 0.000014738405)
    (by norm_num) (by norm_num) (by norm_num) errPt470
    vbpP470.1 vbpP470.2 vbpP471.1 vbpP471.2 vbpP469.1 vbpP469.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h22 := errBlockLin_of_piece (q0 := 1.458) (q1 := 1.46) (m := vBP 1.453)
    (Lo := (-0.1385142)) (Hi := (-0.10127307)) (Klo := 0.000011025422) (Khi := 0.000019952023)
    (by norm_num) (by norm_num) (by norm_num) errPt471
    vbpP471.1 vbpP471.2 vbpP472.1 vbpP472.2 vbpP469.1 vbpP469.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h23 := errBlockLin_of_piece (q0 := 1.46) (q1 := 1.462) (m := vBP 1.453)
    (Lo := (-0.13786397)) (Hi := (-0.09807873)) (Klo := 0.000016027393) (Khi := 0.000025134792)
    (by norm_num) (by norm_num) (by norm_num) errPt472
    vbpP472.1 vbpP472.2 vbpP473.1 vbpP473.2 vbpP469.1 vbpP469.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h24 := errBlockLin_of_piece (q0 := 1.462) (q1 := 1.464) (m := vBP 1.453)
    (Lo := (-0.13734223)) (Hi := (-0.09478547)) (Klo := 0.00002099098) (Khi := 0.000030285516)
    (by norm_num) (by norm_num) (by norm_num) errPt473
    vbpP473.1 vbpP473.2 vbpP474.1 vbpP474.2 vbpP469.1 vbpP469.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h25 := errBlockLin_of_piece (q0 := 1.464) (q1 := 1.467) (m := vBP 1.453)
    (Lo := (-0.13937337)) (Hi := (-0.08881036)) (Klo := 0.00004309348) (Khi := 0.000052632735)
    (by norm_num) (by norm_num) (by norm_num) errPt474
    vbpP474.1 vbpP474.2 vbpP475.1 vbpP475.2 vbpP469.1 vbpP469.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h26 := errBlockLin_of_piece (q0 := 1.467) (q1 := 1.47) (m := vBP 1.453)
    (Lo := (-0.10209594)) (Hi := (-0.08750518)) (Klo := 0.000054125389) (Khi := 0.00006397065)
    (by norm_num) (by norm_num) (by norm_num) errPt475
    vbpP475.1 vbpP475.2 vbpP476.1 vbpP476.2 vbpP469.1 vbpP469.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h27 := errBlockLin_of_piece (q0 := 1.47) (q1 := 1.472) (m := vBP 1.453)
    (Lo := (-0.09600711)) (Hi := (-0.08550822)) (Klo := 0.000040466912) (Khi := 0.000050576969)
    (by norm_num) (by norm_num) (by norm_num) errPt476
    vbpP476.1 vbpP476.2 vbpP477.1 vbpP477.2 vbpP469.1 vbpP469.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h28 := errBlockLin_of_piece (q0 := 1.472) (q1 := 1.476) (m := vBP 1.453)
    (Lo := (-0.09486348)) (Hi := (-0.07676016)) (Klo := 0.000100445994) (Khi := 0.000110893444)
    (by norm_num) (by norm_num) (by norm_num) errPt477
    vbpP477.1 vbpP477.2 vbpP478.1 vbpP478.2 vbpP469.1 vbpP469.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h29 := errBlockLin_of_piece (q0 := 1.476) (q1 := 1.478) (m := vBP 1.453)
    (Lo := (-0.08582092)) (Hi := (-0.07575107)) (Klo := 0.000054682391) (Khi := 0.00006547852)
    (by norm_num) (by norm_num) (by norm_num) errPt478
    vbpP478.1 vbpP478.2 vbpP479.1 vbpP479.2 vbpP469.1 vbpP469.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  exact (((((((((((((((((((((((((((((h0.add h1).add h2).add h3).add h4).add h5).add h6).add h7).add h8).add h9).add h10).add h11).add h12).add h13).add h14).add h15).add h16).add h17).add h18).add h19).add h20).add h21).add h22).add h23).add h24).add h25).add h26).add h27).add h28).add h29).mono (by norm_num) (by norm_num) (by norm_num [mn4])
    (by norm_num [mx4]) (by norm_num)

theorem blkLo5_1 : errBlockLin (vBP 1.478) (vBP 1.504) (vBP 1.453) (-0.0016246154) (-0.000992867) (-0.0000863248) (-0.0000431248) 0.0016246154 := by
  have h0 := errBlockLin_of_piece (q0 := 1.478) (q1 := 1.481) (m := vBP 1.453)
    (Lo := (-0.08342354)) (Hi := (-0.06966698)) (Klo := 0.000093534397) (Khi := 0.000104637958)
    (by norm_num) (by norm_num) (by norm_num) errPt479
    vbpP479.1 vbpP479.2 vbpP480.1 vbpP480.2 vbpP469.1 vbpP469.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h1 := errBlockLin_of_piece (q0 := 1.481) (q1 := 1.484) (m := vBP 1.453)
    (Lo := (-0.07815323)) (Hi := (-0.06465445)) (Klo := 0.000104001954) (Khi := 0.000115490458)
    (by norm_num) (by norm_num) (by norm_num) errPt480
    vbpP480.1 vbpP480.2 vbpP481.1 vbpP481.2 vbpP469.1 vbpP469.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h2 := errBlockLin_of_piece (q0 := 1.484) (q1 := 1.486) (m := vBP 1.453)
    (Lo := (-0.07180671)) (Hi := (-0.06235995)) (Klo := 0.000073122641) (Khi := 0.00008494208)
    (by norm_num) (by norm_num) (by norm_num) errPt481
    vbpP481.1 vbpP481.2 vbpP482.1 vbpP482.2 vbpP469.1 vbpP469.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h3 := errBlockLin_of_piece (q0 := 1.486) (q1 := 1.49) (m := vBP 1.453)
    (Lo := (-0.07028319)) (Hi := (-0.05349167)) (Klo := 0.000165883282) (Khi := 0.00017812349)
    (by norm_num) (by norm_num) (by norm_num) errPt482
    vbpP482.1 vbpP482.2 vbpP483.1 vbpP483.2 vbpP469.1 vbpP469.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h4 := errBlockLin_of_piece (q0 := 1.49) (q1 := 1.492) (m := vBP 1.453)
    (Lo := (-0.06113491)) (Hi := (-0.05218708)) (Klo := 0.00008657088) (Khi := 0.000099246836)
    (by norm_num) (by norm_num) (by norm_num) errPt483
    vbpP483.1 vbpP483.2 vbpP484.1 vbpP484.2 vbpP469.1 vbpP469.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h5 := errBlockLin_of_piece (q0 := 1.492) (q1 := 1.495) (m := vBP 1.453)
    (Lo := (-0.05855112)) (Hi := (-0.04609248)) (Klo := 0.00014137838) (Khi := 0.000154436065)
    (by norm_num) (by norm_num) (by norm_num) errPt484
    vbpP484.1 vbpP484.2 vbpP485.1 vbpP485.2 vbpP469.1 vbpP469.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h6 := errBlockLin_of_piece (q0 := 1.495) (q1 := 1.498) (m := vBP 1.453)
    (Lo := (-0.05319823)) (Hi := (-0.0410461)) (Klo := 0.000151300806) (Khi := 0.000164834809)
    (by norm_num) (by norm_num) (by norm_num) errPt485
    vbpP485.1 vbpP485.2 vbpP486.1 vbpP486.2 vbpP469.1 vbpP469.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h7 := errBlockLin_of_piece (q0 := 1.498) (q1 := 1.5) (m := vBP 1.453)
    (Lo := (-0.12794335)) (Hi := 0.06442604) (Klo := 0.000103998239) (Khi := 0.000117946092)
    (by norm_num) (by norm_num) (by norm_num) errPt486
    vbpP486.1 vbpP486.2 vbpP487.1 vbpP487.2 vbpP469.1 vbpP469.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h8 := errBlockLin_of_piece (q0 := 1.5) (q1 := 1.504) (m := vBP 1.453)
    (Lo := (-0.04529238)) (Hi := (-0.02984821)) (Klo := 0.000227996336) (Khi := 0.000242465908)
    (by norm_num) (by norm_num) (by norm_num) errPt487
    vbpP487.1 vbpP487.2 vbpP488.1 vbpP488.2 vbpP469.1 vbpP469.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  exact ((((((((h0.add h1).add h2).add h3).add h4).add h5).add h6).add h7).add h8).mono (by norm_num) (by norm_num) (by norm_num [mn4])
    (by norm_num [mx4]) (by norm_num)

theorem blkLo5 : errBlockLin (vBP 1.406) (vBP 1.504) (vBP 1.453) (-0.0114604124) (-0.0091220034) 0.0000615998 0.000175229 0.0114604124 :=
  errBlockLin.mono (errBlockLin.add blkLo5_0 blkLo5_1) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
    (by norm_num)

theorem blkLo6_0 : errBlockLin (vBP 1.504) (vBP 1.61) (vBP 1.558) 0.0008907159 0.0024048364 0.0000125102 0.0001088931 0.0031823034 := by
  have h0 := errBlockLin_of_piece (q0 := 1.504) (q1 := 1.508) (m := vBP 1.558)
    (Lo := (-0.03856657)) (Hi := (-0.02308371)) (Klo := (-0.0002582395)) (Khi := (-0.000220696794))
    (by norm_num) (by norm_num) (by norm_num) errPt488
    vbpP488.1 vbpP488.2 vbpP489.1 vbpP489.2 vbpP502.1 vbpP502.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h1 := errBlockLin_of_piece (q0 := 1.508) (q1 := 1.512) (m := vBP 1.558)
    (Lo := (-0.0319501)) (Hi := (-0.01647995)) (Klo := (-0.000238714272)) (Khi := (-0.000200459131))
    (by norm_num) (by norm_num) (by norm_num) errPt489
    vbpP489.1 vbpP489.2 vbpP490.1 vbpP490.2 vbpP502.1 vbpP502.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h2 := errBlockLin_of_piece (q0 := 1.512) (q1 := 1.516) (m := vBP 1.558)
    (Lo := (-0.0254757)) (Hi := (-0.01006886)) (Klo := (-0.000219468583)) (Khi := (-0.000180454565))
    (by norm_num) (by norm_num) (by norm_num) errPt490
    vbpP490.1 vbpP490.2 vbpP491.1 vbpP491.2 vbpP502.1 vbpP502.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h3 := errBlockLin_of_piece (q0 := 1.516) (q1 := 1.52) (m := vBP 1.558)
    (Lo := (-0.01917497)) (Hi := (-0.00388098)) (Klo := (-0.000200495595)) (Khi := (-0.000160676642))
    (by norm_num) (by norm_num) (by norm_num) errPt491
    vbpP491.1 vbpP491.2 vbpP492.1 vbpP492.2 vbpP502.1 vbpP502.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h4 := errBlockLin_of_piece (q0 := 1.52) (q1 := 1.524) (m := vBP 1.558)
    (Lo := (-0.01307821)) (Hi := 0.00205466) (Klo := (-0.000181800387)) (Khi := (-0.000141124226))
    (by norm_num) (by norm_num) (by norm_num) errPt492
    vbpP492.1 vbpP492.2 vbpP493.1 vbpP493.2 vbpP502.1 vbpP502.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h5 := errBlockLin_of_piece (q0 := 1.524) (q1 := 1.528) (m := vBP 1.558)
    (Lo := (-0.00721432)) (Hi := 0.00771071) (Klo := (-0.000163373577)) (Khi := (-0.000121787033))
    (by norm_num) (by norm_num) (by norm_num) errPt493
    vbpP493.1 vbpP493.2 vbpP494.1 vbpP494.2 vbpP502.1 vbpP502.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h6 := errBlockLin_of_piece (q0 := 1.528) (q1 := 1.531) (m := vBP 1.558)
    (Lo := (-0.00065904)) (Hi := 0.0107685) (Klo := (-0.000115904364)) (Khi := (-0.000073479096))
    (by norm_num) (by norm_num) (by norm_num) errPt494
    vbpP494.1 vbpP494.2 vbpP495.1 vbpP495.2 vbpP502.1 vbpP502.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h7 := errBlockLin_of_piece (q0 := 1.531) (q1 := 1.534) (m := vBP 1.558)
    (Lo := 0.00335699) (Hi := 0.01463125) (Klo := (-0.000105898345)) (Khi := (-0.000062718296))
    (by norm_num) (by norm_num) (by norm_num) errPt495
    vbpP495.1 vbpP495.2 vbpP496.1 vbpP496.2 vbpP502.1 vbpP502.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h8 := errBlockLin_of_piece (q0 := 1.534) (q1 := 1.538) (m := vBP 1.558)
    (Lo := 0.00625137) (Hi := 0.02046451) (Klo := (-0.000118485663)) (Khi := (-0.000074378296))
    (by norm_num) (by norm_num) (by norm_num) errPt496
    vbpP496.1 vbpP496.2 vbpP497.1 vbpP497.2 vbpP502.1 vbpP502.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h9 := errBlockLin_of_piece (q0 := 1.538) (q1 := 1.542) (m := vBP 1.558)
    (Lo := 0.01109638) (Hi := 0.02495344) (Klo := (-0.000100995011)) (Khi := (-0.000055772377))
    (by norm_num) (by norm_num) (by norm_num) errPt497
    vbpP497.1 vbpP497.2 vbpP498.1 vbpP498.2 vbpP502.1 vbpP502.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h10 := errBlockLin_of_piece (q0 := 1.542) (q1 := 1.546) (m := vBP 1.558)
    (Lo := 0.01559968) (Hi := 0.02906351) (Klo := (-0.000083767088)) (Khi := (-0.000037366317))
    (by norm_num) (by norm_num) (by norm_num) errPt498
    vbpP498.1 vbpP498.2 vbpP499.1 vbpP499.2 vbpP502.1 vbpP502.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h11 := errBlockLin_of_piece (q0 := 1.546) (q1 := 1.55) (m := vBP 1.558)
    (Lo := 0.01974254) (Hi := 0.03277861) (Klo := (-0.000066800556)) (Khi := (-0.000019155386))
    (by norm_num) (by norm_num) (by norm_num) errPt499
    vbpP499.1 vbpP499.2 vbpP500.1 vbpP500.2 vbpP502.1 vbpP502.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h12 := errBlockLin_of_piece (q0 := 1.55) (q1 := 1.554) (m := vBP 1.558)
    (Lo := 0.02350838) (Hi := 0.03608499) (Klo := (-0.000050091524)) (Khi := (-0.000001132341))
    (by norm_num) (by norm_num) (by norm_num) errPt500
    vbpP500.1 vbpP500.2 vbpP501.1 vbpP501.2 vbpP502.1 vbpP502.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h13 := errBlockLin_of_piece (q0 := 1.554) (q1 := 1.558) (m := vBP 1.558)
    (Lo := 0.02688293) (Hi := 0.0389713) (Klo := (-0.000033641291)) (Khi := 0.000016703556)
    (by norm_num) (by norm_num) (by norm_num) errPt501
    vbpP501.1 vbpP501.2 vbpP502.1 vbpP502.2 vbpP502.1 vbpP502.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h14 := errBlockLin_of_piece (q0 := 1.558) (q1 := 1.562) (m := vBP 1.558)
    (Lo := 0.02985426) (Hi := 0.04142869) (Klo := (-0.000017447296)) (Khi := 0.000034358154)
    (by norm_num) (by norm_num) (by norm_num) errPt502
    vbpP502.1 vbpP502.2 vbpP503.1 vbpP503.2 vbpP502.1 vbpP502.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h15 := errBlockLin_of_piece (q0 := 1.562) (q1 := 1.566) (m := vBP 1.558)
    (Lo := 0.03241283) (Hi := 0.0434508) (Klo := (-0.0000015083)) (Khi := 0.000051837238)
    (by norm_num) (by norm_num) (by norm_num) errPt503
    vbpP503.1 vbpP503.2 vbpP504.1 vbpP504.2 vbpP502.1 vbpP502.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h16 := errBlockLin_of_piece (q0 := 1.566) (q1 := 1.57) (m := vBP 1.558)
    (Lo := 0.03455157) (Hi := 0.04503385) (Klo := 0.00001417692) (Khi := 0.000069143972)
    (by norm_num) (by norm_num) (by norm_num) errPt504
    vbpP504.1 vbpP504.2 vbpP505.1 vbpP505.2 vbpP502.1 vbpP502.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h17 := errBlockLin_of_piece (q0 := 1.57) (q1 := 1.574) (m := vBP 1.558)
    (Lo := 0.0362659) (Hi := 0.04617657) (Klo := 0.000029609567) (Khi := 0.000086282756)
    (by norm_num) (by norm_num) (by norm_num) errPt505
    vbpP505.1 vbpP505.2 vbpP506.1 vbpP506.2 vbpP502.1 vbpP502.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h18 := errBlockLin_of_piece (q0 := 1.574) (q1 := 1.578) (m := vBP 1.558)
    (Lo := 0.03755372) (Hi := 0.04688031) (Klo := 0.000044790827) (Khi := 0.000103259203)
    (by norm_num) (by norm_num) (by norm_num) errPt506
    vbpP506.1 vbpP506.2 vbpP507.1 vbpP507.2 vbpP502.1 vbpP502.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h19 := errBlockLin_of_piece (q0 := 1.578) (q1 := 1.582) (m := vBP 1.558)
    (Lo := (-0.09975825)) (Hi := 0.05360076) (Klo := 0.000059721861) (Khi := 0.000120076336)
    (by norm_num) (by norm_num) (by norm_num) errPt507
    vbpP507.1 vbpP507.2 vbpP508.1 vbpP508.2 vbpP502.1 vbpP502.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h20 := errBlockLin_of_piece (q0 := 1.582) (q1 := 1.586) (m := vBP 1.558)
    (Lo := 0.03855347) (Hi := 0.04733864) (Klo := 0.000074403819) (Khi := 0.000136738397)
    (by norm_num) (by norm_num) (by norm_num) errPt508
    vbpP508.1 vbpP508.2 vbpP509.1 vbpP509.2 vbpP502.1 vbpP502.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h21 := errBlockLin_of_piece (q0 := 1.586) (q1 := 1.59) (m := vBP 1.558)
    (Lo := 0.03813363) (Hi := 0.04720994) (Klo := 0.000088837826) (Khi := 0.000153250845)
    (by norm_num) (by norm_num) (by norm_num) errPt509
    vbpP509.1 vbpP509.2 vbpP510.1 vbpP510.2 vbpP502.1 vbpP502.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h22 := errBlockLin_of_piece (q0 := 1.59) (q1 := 1.594) (m := vBP 1.558)
    (Lo := 0.03731587) (Hi := 0.04665981) (Klo := 0.000103023738) (Khi := 0.000169616558)
    (by norm_num) (by norm_num) (by norm_num) errPt510
    vbpP510.1 vbpP510.2 vbpP511.1 vbpP511.2 vbpP502.1 vbpP502.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h23 := errBlockLin_of_piece (q0 := 1.594) (q1 := 1.598) (m := vBP 1.558)
    (Lo := 0.03611284) (Hi := 0.04569944) (Klo := 0.000116963908) (Khi := 0.000185843395)
    (by norm_num) (by norm_num) (by norm_num) errPt511
    vbpP511.1 vbpP511.2 vbpP512.1 vbpP512.2 vbpP502.1 vbpP502.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h24 := errBlockLin_of_piece (q0 := 1.598) (q1 := 1.602) (m := vBP 1.558)
    (Lo := 0.03453943) (Hi := 0.04434238) (Klo := 0.000130655661) (Khi := 0.00020193163)
    (by norm_num) (by norm_num) (by norm_num) errPt512
    vbpP512.1 vbpP512.2 vbpP513.1 vbpP513.2 vbpP502.1 vbpP502.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h25 := errBlockLin_of_piece (q0 := 1.602) (q1 := 1.606) (m := vBP 1.558)
    (Lo := 0.03261269) (Hi := 0.04260445) (Klo := 0.00014410258) (Khi := 0.000217887764)
    (by norm_num) (by norm_num) (by norm_num) errPt513
    vbpP513.1 vbpP513.2 vbpP514.1 vbpP514.2 vbpP502.1 vbpP502.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h26 := errBlockLin_of_piece (q0 := 1.606) (q1 := 1.61) (m := vBP 1.558)
    (Lo := 0.03035167) (Hi := 0.04050367) (Klo := 0.000157305712) (Khi := 0.000233716978)
    (by norm_num) (by norm_num) (by norm_num) errPt514
    vbpP514.1 vbpP514.2 vbpP515.1 vbpP515.2 vbpP502.1 vbpP502.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  exact ((((((((((((((((((((((((((h0.add h1).add h2).add h3).add h4).add h5).add h6).add h7).add h8).add h9).add h10).add h11).add h12).add h13).add h14).add h15).add h16).add h17).add h18).add h19).add h20).add h21).add h22).add h23).add h24).add h25).add h26).mono (by norm_num) (by norm_num) (by norm_num [mn4])
    (by norm_num [mx4]) (by norm_num)

theorem blkLo6 : errBlockLin (vBP 1.504) (vBP 1.61) (vBP 1.558) 0.0008907159 0.0024048364 0.0000125102 0.0001088931 0.0031823034 :=
  errBlockLin.mono blkLo6_0 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
    (by norm_num)

theorem blkLo7_0 : errBlockLin (vBP 1.61) (vBP 1.719) (vBP 1.664) (-0.0021432161) (-0.0001752298) (-0.0001700977) (-0.0000141422) 0.0032062382 := by
  have h0 := errBlockLin_of_piece (q0 := 1.61) (q1 := 1.614) (m := vBP 1.664)
    (Lo := 0.02777738) (Hi := 0.03806012) (Klo := (-0.000276393417)) (Khi := (-0.000114480639))
    (by norm_num) (by norm_num) (by norm_num) errPt515
    vbpP515.1 vbpP515.2 vbpP516.1 vbpP516.2 vbpP523.1 vbpP523.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h1 := errBlockLin_of_piece (q0 := 1.614) (q1 := 1.618) (m := vBP 1.664)
    (Lo := 0.02491261) (Hi := 0.03529583) (Klo := (-0.000261574678)) (Khi := (-0.000096992212))
    (by norm_num) (by norm_num) (by norm_num) errPt516
    vbpP516.1 vbpP516.2 vbpP517.1 vbpP517.2 vbpP523.1 vbpP523.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h2 := errBlockLin_of_piece (q0 := 1.618) (q1 := 1.625) (m := vBP 1.664)
    (Lo := 0.01690981) (Hi := 0.03455809) (Klo := (-0.000359712004)) (Khi := (-0.000191208109))
    (by norm_num) (by norm_num) (by norm_num) errPt517
    vbpP517.1 vbpP517.2 vbpP518.1 vbpP518.2 vbpP523.1 vbpP523.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h3 := errBlockLin_of_piece (q0 := 1.625) (q1 := 1.632) (m := vBP 1.664)
    (Lo := 0.0106877) (Hi := 0.02847315) (Klo := (-0.00031452005)) (Khi := (-0.00014069364))
    (by norm_num) (by norm_num) (by norm_num) errPt518
    vbpP518.1 vbpP518.2 vbpP519.1 vbpP519.2 vbpP523.1 vbpP523.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h4 := errBlockLin_of_piece (q0 := 1.632) (q1 := 1.64) (m := vBP 1.664)
    (Lo := 0.00221826) (Hi := 0.02241038) (Klo := (-0.000292829036)) (Khi := (-0.000112788558))
    (by norm_num) (by norm_num) (by norm_num) errPt519
    vbpP519.1 vbpP519.2 vbpP520.1 vbpP520.2 vbpP523.1 vbpP523.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h5 := errBlockLin_of_piece (q0 := 1.64) (q1 := 1.648) (m := vBP 1.664)
    (Lo := (-0.0059219)) (Hi := 0.01400873) (Klo := (-0.000236695951)) (Khi := (-0.000049445986))
    (by norm_num) (by norm_num) (by norm_num) errPt520
    vbpP520.1 vbpP520.2 vbpP521.1 vbpP521.2 vbpP523.1 vbpP523.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h6 := errBlockLin_of_piece (q0 := 1.648) (q1 := 1.656) (m := vBP 1.664)
    (Lo := (-0.01425155)) (Hi := 0.00517469) (Klo := (-0.000182311243)) (Khi := 0.000012803528)
    (by norm_num) (by norm_num) (by norm_num) errPt521
    vbpP521.1 vbpP521.2 vbpP522.1 vbpP522.2 vbpP523.1 vbpP523.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h7 := errBlockLin_of_piece (q0 := 1.656) (q1 := 1.664) (m := vBP 1.664)
    (Lo := (-0.08045654)) (Hi := 0.04923049) (Klo := (-0.000129662132)) (Khi := 0.000074015068)
    (by norm_num) (by norm_num) (by norm_num) errPt522
    vbpP522.1 vbpP522.2 vbpP523.1 vbpP523.2 vbpP523.1 vbpP523.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h8 := errBlockLin_of_piece (q0 := 1.664) (q1 := 1.672) (m := vBP 1.664)
    (Lo := (-0.03104535)) (Hi := (-0.01242835)) (Klo := (-0.000078735077)) (Khi := 0.000134246119)
    (by norm_num) (by norm_num) (by norm_num) errPt523
    vbpP523.1 vbpP523.2 vbpP524.1 vbpP524.2 vbpP523.1 vbpP523.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h9 := errBlockLin_of_piece (q0 := 1.672) (q1 := 1.68) (m := vBP 1.664)
    (Lo := (-0.03878546)) (Hi := (-0.02066807)) (Klo := (-0.000029518131)) (Khi := 0.000193549306)
    (by norm_num) (by norm_num) (by norm_num) errPt524
    vbpP524.1 vbpP524.2 vbpP525.1 vbpP525.2 vbpP523.1 vbpP523.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h10 := errBlockLin_of_piece (q0 := 1.68) (q1 := 1.688) (m := vBP 1.664)
    (Lo := (-0.04572764)) (Hi := (-0.02836616)) (Klo := 0.000017997889) (Khi := 0.000251982042)
    (by norm_num) (by norm_num) (by norm_num) errPt525
    vbpP525.1 vbpP525.2 vbpP526.1 vbpP526.2 vbpP523.1 vbpP523.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h11 := errBlockLin_of_piece (q0 := 1.688) (q1 := 1.696) (m := vBP 1.664)
    (Lo := (-0.05167426)) (Hi := (-0.03530547)) (Klo := 0.000063819474) (Khi := 0.000309600505)
    (by norm_num) (by norm_num) (by norm_num) errPt526
    vbpP526.1 vbpP526.2 vbpP527.1 vbpP527.2 vbpP523.1 vbpP523.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h12 := errBlockLin_of_piece (q0 := 1.696) (q1 := 1.704) (m := vBP 1.664)
    (Lo := (-0.05645772)) (Hi := (-0.04129216)) (Klo := 0.00010795402) (Khi := 0.000366460842)
    (by norm_num) (by norm_num) (by norm_num) errPt527
    vbpP527.1 vbpP527.2 vbpP528.1 vbpP528.2 vbpP523.1 vbpP523.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h13 := errBlockLin_of_piece (q0 := 1.704) (q1 := 1.712) (m := vBP 1.664)
    (Lo := (-0.05994501)) (Hi := (-0.04616102)) (Klo := 0.000150403964) (Khi := 0.000422615666)
    (by norm_num) (by norm_num) (by norm_num) errPt528
    vbpP528.1 vbpP528.2 vbpP529.1 vbpP529.2 vbpP523.1 vbpP523.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h14 := errBlockLin_of_piece (q0 := 1.712) (q1 := 1.719) (m := vBP 1.664)
    (Lo := (-0.06125387)) (Hi := (-0.05036574)) (Klo := 0.000147241394) (Khi := 0.000433205097)
    (by norm_num) (by norm_num) (by norm_num) errPt529
    vbpP529.1 vbpP529.2 vbpP530.1 vbpP530.2 vbpP523.1 vbpP523.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  exact ((((((((((((((h0.add h1).add h2).add h3).add h4).add h5).add h6).add h7).add h8).add h9).add h10).add h11).add h12).add h13).add h14).mono (by norm_num) (by norm_num) (by norm_num [mn4])
    (by norm_num [mx4]) (by norm_num)

theorem blkLo7 : errBlockLin (vBP 1.61) (vBP 1.719) (vBP 1.664) (-0.0021432161) (-0.0001752298) (-0.0001700977) (-0.0000141422) 0.0032062382 :=
  errBlockLin.mono blkLo7_0 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
    (by norm_num)

theorem blkLo8_0 : errBlockLin (vBP 1.719) (vBP 1.828) (vBP 1.774) (-0.002904324) (-0.0009887057) (-0.0001521832) 0.0002602606 0.0030518407 := by
  have h0 := errBlockLin_of_piece (q0 := 1.719) (q1 := 1.726) (m := vBP 1.774)
    (Lo := (-0.0620739)) (Hi := (-0.05242296)) (Klo := (-0.000548388441)) (Khi := (-0.000007136215))
    (by norm_num) (by norm_num) (by norm_num) errPt530
    vbpP530.1 vbpP530.2 vbpP531.1 vbpP531.2 vbpP537.1 vbpP537.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h1 := errBlockLin_of_piece (q0 := 1.726) (q1 := 1.734) (m := vBP 1.774)
    (Lo := (-0.06566806)) (Hi := 0.04482764) (Klo := (-0.0005461858)) (Khi := 0.000009722703)
    (by norm_num) (by norm_num) (by norm_num) errPt531
    vbpP531.1 vbpP531.2 vbpP532.1 vbpP532.2 vbpP537.1 vbpP537.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h2 := errBlockLin_of_piece (q0 := 1.734) (q1 := 1.742) (m := vBP 1.774)
    (Lo := (-0.06145731)) (Hi := (-0.05160082)) (Klo := (-0.000503200124)) (Khi := 0.000069465735)
    (by norm_num) (by norm_num) (by norm_num) errPt532
    vbpP532.1 vbpP532.2 vbpP533.1 vbpP533.2 vbpP537.1 vbpP537.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h3 := errBlockLin_of_piece (q0 := 1.742) (q1 := 1.75) (m := vBP 1.774)
    (Lo := (-0.05961616)) (Hi := (-0.04862936)) (Klo := (-0.000461991095)) (Khi := 0.000128688563)
    (by norm_num) (by norm_num) (by norm_num) errPt533
    vbpP533.1 vbpP533.2 vbpP534.1 vbpP534.2 vbpP537.1 vbpP537.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h4 := errBlockLin_of_piece (q0 := 1.75) (q1 := 1.758) (m := vBP 1.774)
    (Lo := (-0.05640428)) (Hi := (-0.04441821)) (Klo := (-0.000422563438)) (Khi := 0.000187450236)
    (by norm_num) (by norm_num) (by norm_num) errPt534
    vbpP534.1 vbpP534.2 vbpP535.1 vbpP535.2 vbpP537.1 vbpP537.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h5 := errBlockLin_of_piece (q0 := 1.758) (q1 := 1.766) (m := vBP 1.774)
    (Lo := (-0.05192519)) (Hi := (-0.03910361)) (Klo := (-0.000384923041)) (Khi := 0.000245805201)
    (by norm_num) (by norm_num) (by norm_num) errPt535
    vbpP535.1 vbpP535.2 vbpP536.1 vbpP536.2 vbpP537.1 vbpP537.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h6 := errBlockLin_of_piece (q0 := 1.766) (q1 := 1.774) (m := vBP 1.774)
    (Lo := (-0.04632004)) (Hi := (-0.03285466)) (Klo := (-0.000349073539)) (Khi := 0.000303814711)
    (by norm_num) (by norm_num) (by norm_num) errPt536
    vbpP536.1 vbpP536.2 vbpP537.1 vbpP537.2 vbpP537.1 vbpP537.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h7 := errBlockLin_of_piece (q0 := 1.774) (q1 := 1.781) (m := vBP 1.774)
    (Lo := (-0.0393683)) (Hi := (-0.0271897)) (Klo := (-0.000319621881)) (Khi := 0.000355366993)
    (by norm_num) (by norm_num) (by norm_num) errPt537
    vbpP537.1 vbpP537.2 vbpP538.1 vbpP538.2 vbpP537.1 vbpP537.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h8 := errBlockLin_of_piece (q0 := 1.781) (q1 := 1.788) (m := vBP 1.774)
    (Lo := (-0.03302408)) (Hi := (-0.02067705)) (Klo := (-0.000296135881)) (Khi := 0.000400770014)
    (by norm_num) (by norm_num) (by norm_num) errPt538
    vbpP538.1 vbpP538.2 vbpP539.1 vbpP539.2 vbpP537.1 vbpP537.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h9 := errBlockLin_of_piece (q0 := 1.788) (q1 := 1.796) (m := vBP 1.774)
    (Lo := (-0.02662301)) (Hi := (-0.01253445)) (Klo := (-0.000259807577)) (Khi := 0.000462023543)
    (by norm_num) (by norm_num) (by norm_num) errPt539
    vbpP539.1 vbpP539.2 vbpP540.1 vbpP540.2 vbpP537.1 vbpP537.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h10 := errBlockLin_of_piece (q0 := 1.796) (q1 := 1.804) (m := vBP 1.774)
    (Lo := (-0.05422954)) (Hi := 0.04156782) (Klo := (-0.000230768241)) (Khi := 0.000519249476)
    (by norm_num) (by norm_num) (by norm_num) errPt540
    vbpP540.1 vbpP540.2 vbpP541.1 vbpP541.2 vbpP537.1 vbpP537.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h11 := errBlockLin_of_piece (q0 := 1.804) (q1 := 1.812) (m := vBP 1.774)
    (Lo := (-0.01047563)) (Hi := 0.0032406) (Klo := (-0.00020357392)) (Khi := 0.000576406314)
    (by norm_num) (by norm_num) (by norm_num) errPt541
    vbpP541.1 vbpP541.2 vbpP542.1 vbpP542.2 vbpP537.1 vbpP537.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h12 := errBlockLin_of_piece (q0 := 1.812) (q1 := 1.828) (m := vBP 1.774)
    (Lo := (-0.00549331)) (Hi := 0.02076284) (Klo := 0.000081063445) (Khi := 0.000910218435)
    (by norm_num) (by norm_num) (by norm_num) errPt542
    vbpP542.1 vbpP542.2 vbpP543.1 vbpP543.2 vbpP537.1 vbpP537.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  exact ((((((((((((h0.add h1).add h2).add h3).add h4).add h5).add h6).add h7).add h8).add h9).add h10).add h11).add h12).mono (by norm_num) (by norm_num) (by norm_num [mn4])
    (by norm_num [mx4]) (by norm_num)

theorem blkLo8 : errBlockLin (vBP 1.719) (vBP 1.828) (vBP 1.774) (-0.002904324) (-0.0009887057) (-0.0001521832) 0.0002602606 0.0030518407 :=
  errBlockLin.mono blkLo8_0 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
    (by norm_num)

theorem blkLo9_0 : errBlockLin (vBP 1.828) (vBP 1.954) (vBP 1.89) (-0.0002249488) 0.0022986655 (-0.0003048243) 0.0002403361 0.0024835066 := by
  have h0 := errBlockLin_of_piece (q0 := 1.828) (q1 := 1.844) (m := vBP 1.89)
    (Lo := 0.00866909) (Hi := 0.03193799) (Klo := (-0.001300046574)) (Khi := 0.000201831612)
    (by norm_num) (by norm_num) (by norm_num) errPt543
    vbpP543.1 vbpP543.2 vbpP544.1 vbpP544.2 vbpP547.1 vbpP547.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h1 := errBlockLin_of_piece (q0 := 1.844) (q1 := 1.86) (m := vBP 1.89)
    (Lo := 0.01970747) (Hi := 0.03845241) (Klo := (-0.001165939685)) (Khi := 0.000410806916)
    (by norm_num) (by norm_num) (by norm_num) errPt544
    vbpP544.1 vbpP544.2 vbpP545.1 vbpP545.2 vbpP547.1 vbpP547.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h2 := errBlockLin_of_piece (q0 := 1.86) (q1 := 1.875) (m := vBP 1.89)
    (Lo := (-0.04798372)) (Hi := 0.04151855) (Klo := (-0.001033480491)) (Khi := 0.000624455011)
    (by norm_num) (by norm_num) (by norm_num) errPt545
    vbpP545.1 vbpP545.2 vbpP546.1 vbpP546.2 vbpP547.1 vbpP547.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h3 := errBlockLin_of_piece (q0 := 1.875) (q1 := 1.89) (m := vBP 1.89)
    (Lo := 0.02493904) (Hi := 0.03955152) (Klo := (-0.00093837126)) (Khi := 0.000807112322)
    (by norm_num) (by norm_num) (by norm_num) errPt546
    vbpP546.1 vbpP546.2 vbpP547.1 vbpP547.2 vbpP547.1 vbpP547.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h4 := errBlockLin_of_piece (q0 := 1.89) (q1 := 1.906) (m := vBP 1.89)
    (Lo := 0.01728014) (Hi := 0.03647198) (Klo := (-0.000845933976)) (Khi := 0.000999945374)
    (by norm_num) (by norm_num) (by norm_num) errPt547
    vbpP547.1 vbpP547.2 vbpP548.1 vbpP548.2 vbpP547.1 vbpP547.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h5 := errBlockLin_of_piece (q0 := 1.906) (q1 := 1.922) (m := vBP 1.89)
    (Lo := 0.00681142) (Hi := 0.02833408) (Klo := (-0.000757598983)) (Khi := 0.001202847444)
    (by norm_num) (by norm_num) (by norm_num) errPt548
    vbpP548.1 vbpP548.2 vbpP549.1 vbpP549.2 vbpP547.1 vbpP547.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h6 := errBlockLin_of_piece (q0 := 1.922) (q1 := 1.938) (m := vBP 1.89)
    (Lo := (-0.04152394)) (Hi := 0.03939957) (Klo := (-0.000681270781)) (Khi := 0.001405756625)
    (by norm_num) (by norm_num) (by norm_num) errPt549
    vbpP549.1 vbpP549.2 vbpP550.1 vbpP550.2 vbpP547.1 vbpP547.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h7 := errBlockLin_of_piece (q0 := 1.938) (q1 := 1.954) (m := vBP 1.89)
    (Lo := (-0.01724731)) (Hi := 0.00411447) (Klo := (-0.000617076647)) (Khi := 0.001609310932)
    (by norm_num) (by norm_num) (by norm_num) errPt550
    vbpP550.1 vbpP550.2 vbpP551.1 vbpP551.2 vbpP547.1 vbpP547.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  exact (((((((h0.add h1).add h2).add h3).add h4).add h5).add h6).add h7).mono (by norm_num) (by norm_num) (by norm_num [mn4])
    (by norm_num [mx4]) (by norm_num)

theorem blkLo9 : errBlockLin (vBP 1.828) (vBP 1.954) (vBP 1.89) (-0.0002249488) 0.0022986655 (-0.0003048243) 0.0002403361 0.0024835066 :=
  errBlockLin.mono blkLo9_0 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
    (by norm_num)

theorem blkLo10_0 : errBlockLin (vBP 1.954) (vBP 2.078) (vBP 2.016) (-0.0016603113) 0.0001308536 (-0.0004908601) 0.0005454243 0.0018014764 := by
  have h0 := errBlockLin_of_piece (q0 := 1.954) (q1 := 1.969) (m := vBP 2.016)
    (Lo := (-0.02627227)) (Hi := (-0.00814788)) (Klo := (-0.002292325333)) (Khi := 0.001443363904)
    (by norm_num) (by norm_num) (by norm_num) errPt551
    vbpP551.1 vbpP551.2 vbpP552.1 vbpP552.2 vbpP555.1 vbpP555.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h1 := errBlockLin_of_piece (q0 := 1.969) (q1 := 1.984) (m := vBP 2.016)
    (Lo := (-0.03229306)) (Hi := (-0.01741387)) (Klo := (-0.002241446036)) (Khi := 0.001639879184)
    (by norm_num) (by norm_num) (by norm_num) errPt552
    vbpP552.1 vbpP552.2 vbpP553.1 vbpP553.2 vbpP555.1 vbpP555.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h2 := errBlockLin_of_piece (q0 := 1.984) (q1 := 2) (m := vBP 2.016)
    (Lo := (-0.03603123)) (Hi := 0.0372091) (Klo := (-0.002212676541)) (Khi := 0.001833516138)
    (by norm_num) (by norm_num) (by norm_num) errPt553
    vbpP553.1 vbpP553.2 vbpP554.1 vbpP554.2 vbpP555.1 vbpP555.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h3 := errBlockLin_of_piece (q0 := 2) (q1 := 2.016) (m := vBP 2.016)
    (Lo := (-0.03383742)) (Hi := (-0.02294906)) (Klo := (-0.00217524404)) (Khi := 0.002056760786)
    (by norm_num) (by norm_num) (by norm_num) errPt554
    vbpP554.1 vbpP554.2 vbpP555.1 vbpP555.2 vbpP555.1 vbpP555.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h4 := errBlockLin_of_piece (q0 := 2.016) (q1 := 2.031) (m := vBP 2.016)
    (Lo := (-0.03052252)) (Hi := (-0.01670641)) (Klo := (-0.002155610612)) (Khi := 0.002272293785)
    (by norm_num) (by norm_num) (by norm_num) errPt555
    vbpP555.1 vbpP555.2 vbpP556.1 vbpP556.2 vbpP555.1 vbpP555.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h5 := errBlockLin_of_piece (q0 := 2.031) (q1 := 2.046) (m := vBP 2.016)
    (Lo := (-0.02360573)) (Hi := (-0.00739109)) (Klo := (-0.00215235373)) (Khi := 0.002481275175)
    (by norm_num) (by norm_num) (by norm_num) errPt556
    vbpP556.1 vbpP556.2 vbpP557.1 vbpP557.2 vbpP555.1 vbpP555.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h6 := errBlockLin_of_piece (q0 := 2.046) (q1 := 2.062) (m := vBP 2.016)
    (Lo := (-0.03152619)) (Hi := 0.03521241) (Klo := (-0.00214379295)) (Khi := 0.002719916043)
    (by norm_num) (by norm_num) (by norm_num) errPt557
    vbpP557.1 vbpP557.2 vbpP558.1 vbpP558.2 vbpP555.1 vbpP555.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h7 := errBlockLin_of_piece (q0 := 2.062) (q1 := 2.078) (m := vBP 2.016)
    (Lo := (-0.00202886)) (Hi := 0.01591523) (Klo := (-0.002160110576)) (Khi := 0.002959996933)
    (by norm_num) (by norm_num) (by norm_num) errPt558
    vbpP558.1 vbpP558.2 vbpP559.1 vbpP559.2 vbpP555.1 vbpP555.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  exact (((((((h0.add h1).add h2).add h3).add h4).add h5).add h6).add h7).mono (by norm_num) (by norm_num) (by norm_num [mn4])
    (by norm_num [mx4]) (by norm_num)

theorem blkLo10 : errBlockLin (vBP 1.954) (vBP 2.078) (vBP 2.016) (-0.0016603113) 0.0001308536 (-0.0004908601) 0.0005454243 0.0018014764 :=
  errBlockLin.mono blkLo10_0 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
    (by norm_num)

theorem blkLo11_0 : errBlockLin (vBP 2.078) (vBP 2.17945) (vBP 2.1213209) 0.0001013092 0.0016272625 (-0.0001219831) 0.000127266 0.0016272625 := by
  have h0 := errBlockLin_of_piece (q0 := 2.078) (q1 := 2.094) (m := vBP 2.1213209)
    (Lo := 0.0093369) (Hi := 0.0253853) (Klo := (-0.002053981552)) (Khi := 0.001570527949)
    (by norm_num) (by norm_num) (by norm_num) errPt559
    vbpP559.1 vbpP559.2 vbpP560.1 vbpP560.2 vbpT1.1 vbpT1.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h1 := errBlockLin_of_piece (q0 := 2.094) (q1 := 2.1213198) (m := vBP 2.1213209)
    (Lo := 0.01634089) (Hi := 0.03477555) (Klo := (-0.001318126325)) (Khi := 0.000883538345)
    (by norm_num) (by norm_num) (by norm_num) errPtT0
    vbpP560.1 vbpP560.2 vbpT0.1 vbpT0.2 vbpT1.1 vbpT1.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h2 := errBlockLin_of_piece (q0 := 2.1213198) (q1 := 2.1213209) (m := vBP 2.1213209)
    (Lo := (-0.02444891)) (Hi := 0.03004311) (Klo := (-0.00031421177)) (Khi := 0.000314210996)
    (by norm_num) (by norm_num) (by norm_num) errPtT1
    vbpT0.1 vbpT0.2 vbpT1.1 vbpT1.2 vbpT1.1 vbpT1.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h3 := errBlockLin_of_piece (q0 := 2.1213209) (q1 := 2.1794489) (m := vBP 2.1213209)
    (Lo := (-0.0066944)) (Hi := 0.04027702) (Klo := 0.000378823718) (Khi := 0.00097273831)
    (by norm_num) (by norm_num) (by norm_num) errPtT2
    vbpT1.1 vbpT1.2 vbpT2.1 vbpT2.2 vbpT1.1 vbpT1.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h4 := errBlockLin_of_piece (q0 := 2.1794489) (q1 := 2.17945) (m := vBP 2.1213209)
    (Lo := (-0.02191697)) (Hi := 0.02878939) (Klo := (-0.00027967823)) (Khi := 0.000279728184)
    (by norm_num) (by norm_num) (by norm_num) errPtT3
    vbpT2.1 vbpT2.2 vbpT3.1 vbpT3.2 vbpT1.1 vbpT1.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  exact ((((h0.add h1).add h2).add h3).add h4).mono (by norm_num) (by norm_num) (by norm_num [mn4])
    (by norm_num [mx4]) (by norm_num)

theorem blkLo11 : errBlockLin (vBP 2.078) (vBP 2.17945) (vBP 2.1213209) 0.0001013092 0.0016272625 (-0.0001219831) 0.000127266 0.0016272625 :=
  errBlockLin.mono blkLo11_0 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
    (by norm_num)

theorem blkLo12_0 : errBlockLin (vBP 2.17945) (vBP 2.2912884) (vBP 2.2360674) (-0.0012548488) 0.000556165 (-0.0000432829) 0.0000447176 0.0012548557 := by
  have h0 := errBlockLin_of_piece (q0 := 2.17945) (q1 := 2.2360674) (m := vBP 2.2360674)
    (Lo := (-0.02903058)) (Hi := 0.01318421) (Klo := (-0.000817965856)) (Khi := (-0.000380331656))
    (by norm_num) (by norm_num) (by norm_num) errPtT4
    vbpT3.1 vbpT3.2 vbpT4.1 vbpT4.2 vbpT4.1 vbpT4.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h1 := errBlockLin_of_piece (q0 := 2.2360674) (q1 := 2.2360685) (m := vBP 2.2360674)
    (Lo := (-0.0198288)) (Hi := 0.02760956) (Klo := (-0.000205451834)) (Khi := 0.000205452496)
    (by norm_num) (by norm_num) (by norm_num) errPtT5
    vbpT4.1 vbpT4.2 vbpT5.1 vbpT5.2 vbpT4.1 vbpT4.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h2 := errBlockLin_of_piece (q0 := 2.2360685) (q1 := 2.2912873) (m := vBP 2.2360674)
    (Lo := (-0.02692149)) (Hi := 0.01158897) (Klo := 0.000297918737) (Khi := 0.000751878765)
    (by norm_num) (by norm_num) (by norm_num) errPtT6
    vbpT5.1 vbpT5.2 vbpT6.1 vbpT6.2 vbpT4.1 vbpT4.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h3 := errBlockLin_of_piece (q0 := 2.2912873) (q1 := 2.2912884) (m := vBP 2.2360674)
    (Lo := (-0.01808818)) (Hi := 0.02649843) (Klo := (-0.000248487696)) (Khi := 0.00024852799)
    (by norm_num) (by norm_num) (by norm_num) errPtT7
    vbpT6.1 vbpT6.2 vbpT7.1 vbpT7.2 vbpT4.1 vbpT4.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  exact (((h0.add h1).add h2).add h3).mono (by norm_num) (by norm_num) (by norm_num [mn4])
    (by norm_num [mx4]) (by norm_num)

theorem blkLo12 : errBlockLin (vBP 2.17945) (vBP 2.2912884) (vBP 2.2360674) (-0.0012548488) 0.000556165 (-0.0000432829) 0.0000447176 0.0012548557 :=
  errBlockLin.mono blkLo12_0 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
    (by norm_num)

theorem blkLo13_0 : errBlockLin (vBP 2.2912884) (vBP 2.4494903) (vBP 2.3452084) (-0.0004359698) 0.0014276941 (-0.0000713224) 0.0000569779 0.0015925791 := by
  have h0 := errBlockLin_of_piece (q0 := 2.2912884) (q1 := 2.3452073) (m := vBP 2.3452084)
    (Lo := (-0.00301801)) (Hi := 0.03256511) (Klo := (-0.000723322964)) (Khi := (-0.000215505644))
    (by norm_num) (by norm_num) (by norm_num) errPtT8
    vbpT7.1 vbpT7.2 vbpT8.1 vbpT8.2 vbpT9.1 vbpT9.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h1 := errBlockLin_of_piece (q0 := 2.3452073) (q1 := 2.3452084) (m := vBP 2.3452084)
    (Lo := (-0.01662296)) (Hi := 0.02545179) (Klo := (-0.000237840682)) (Khi := 0.000237840824)
    (by norm_num) (by norm_num) (by norm_num) errPtT9
    vbpT8.1 vbpT8.2 vbpT9.1 vbpT9.2 vbpT9.1 vbpT9.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h2 := errBlockLin_of_piece (q0 := 2.3452084) (q1 := 2.3979152) (m := vBP 2.3452084)
    (Lo := (-0.00140188)) (Hi := 0.03147096) (Klo := 0.000156895566) (Khi := 0.000675493501)
    (by norm_num) (by norm_num) (by norm_num) errPtT10
    vbpT9.1 vbpT9.2 vbpT10.1 vbpT10.2 vbpT9.1 vbpT9.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h3 := errBlockLin_of_piece (q0 := 2.3979152) (q1 := 2.3979163) (m := vBP 2.3452084)
    (Lo := (-0.01537828)) (Hi := 0.02446582) (Klo := (-0.00028073976)) (Khi := 0.000280773713)
    (by norm_num) (by norm_num) (by norm_num) errPtT11
    vbpT10.1 vbpT10.2 vbpT11.1 vbpT11.2 vbpT9.1 vbpT9.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h4 := errBlockLin_of_piece (q0 := 2.3979163) (q1 := 2.4494892) (m := vBP 2.3452084)
    (Lo := (-0.01988005)) (Hi := 0.01049062) (Klo := 0.000889170413) (Khi := 0.00141501207)
    (by norm_num) (by norm_num) (by norm_num) errPtT12
    vbpT11.1 vbpT11.2 vbpT12.1 vbpT12.2 vbpT9.1 vbpT9.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h5 := errBlockLin_of_piece (q0 := 2.4494892) (q1 := 2.4494903) (m := vBP 2.3452084)
    (Lo := (-0.01431197)) (Hi := 0.02353691) (Klo := (-0.000245053306)) (Khi := 0.000245116536)
    (by norm_num) (by norm_num) (by norm_num) errPtT13
    vbpT12.1 vbpT12.2 vbpT13.1 vbpT13.2 vbpT9.1 vbpT9.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  exact (((((h0.add h1).add h2).add h3).add h4).add h5).mono (by norm_num) (by norm_num) (by norm_num [mn4])
    (by norm_num [mx4]) (by norm_num)

theorem blkLo13 : errBlockLin (vBP 2.2912884) (vBP 2.4494903) (vBP 2.3452084) (-0.0004359698) 0.0014276941 (-0.0000713224) 0.0000569779 0.0015925791 :=
  errBlockLin.mono blkLo13_0 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
    (by norm_num)

theorem blkLo14_0 : errBlockLin (vBP 2.4494903) (vBP 2.5980768) (vBP 2.5000005) (-0.0003038251) 0.000945629 (-0.0000195152) 0.0000671076 0.001102028 := by
  have h0 := errBlockLin_of_piece (q0 := 2.4494903) (q1 := 2.4999995) (m := vBP 2.5000005)
    (Lo := (-0.01890865)) (Hi := 0.00942776) (Klo := (-0.000563143126)) (Khi := (-0.000113850077))
    (by norm_num) (by norm_num) (by norm_num) errPtT14
    vbpT13.1 vbpT13.2 vbpT14.1 vbpT14.2 vbpT15.1 vbpT15.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h1 := errBlockLin_of_piece (q0 := 2.4999995) (q1 := 2.5000005) (m := vBP 2.5000005)
    (Lo := (-0.01339124)) (Hi := 0.02266158) (Klo := (-0.000210596001)) (Khi := 0.0002105968)
    (by norm_num) (by norm_num) (by norm_num) errPtT15
    vbpT14.1 vbpT14.2 vbpT15.1 vbpT15.2 vbpT15.1 vbpT15.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h2 := errBlockLin_of_piece (q0 := 2.5000005) (q1 := 2.5495092) (m := vBP 2.5000005)
    (Lo := (-0.00014045)) (Hi := 0.02652667) (Klo := 0.000077627871) (Khi := 0.000531217281)
    (by norm_num) (by norm_num) (by norm_num) errPtT16
    vbpT15.1 vbpT15.2 vbpT16.1 vbpT16.2 vbpT15.1 vbpT15.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h3 := errBlockLin_of_piece (q0 := 2.5495092) (q1 := 2.5495103) (m := vBP 2.5000005)
    (Lo := (-0.01259036)) (Hi := 0.02183651) (Klo := (-0.000242980179)) (Khi := 0.000243006588)
    (by norm_num) (by norm_num) (by norm_num) errPtT17
    vbpT16.1 vbpT16.2 vbpT17.1 vbpT17.2 vbpT15.1 vbpT15.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h4 := errBlockLin_of_piece (q0 := 2.5495103) (q1 := 2.5980757) (m := vBP 2.5000005)
    (Lo := 0.00070178) (Hi := 0.02577695) (Klo := 0.000622194672) (Khi := 0.001078415062)
    (by norm_num) (by norm_num) (by norm_num) errPtT18
    vbpT17.1 vbpT17.2 vbpT18.1 vbpT18.2 vbpT15.1 vbpT15.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h5 := errBlockLin_of_piece (q0 := 2.5980757) (q1 := 2.5980768) (m := vBP 2.5000005)
    (Lo := (-0.01188889)) (Hi := 0.02105843) (Klo := (-0.000213201315)) (Khi := 0.000213251913)
    (by norm_num) (by norm_num) (by norm_num) errPtT19
    vbpT18.1 vbpT18.2 vbpT19.1 vbpT19.2 vbpT15.1 vbpT15.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  exact (((((h0.add h1).add h2).add h3).add h4).add h5).mono (by norm_num) (by norm_num) (by norm_num [mn4])
    (by norm_num [mx4]) (by norm_num)

theorem blkLo14 : errBlockLin (vBP 2.4494903) (vBP 2.5980768) (vBP 2.5000005) (-0.0003038251) 0.000945629 (-0.0000195152) 0.0000671076 0.001102028 :=
  errBlockLin.mono blkLo14_0 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
    (by norm_num)

theorem blkLo15_0 : errBlockLin (vBP 2.5980768) (vBP 2.7838827) (vBP 2.6925819) (-0.0003664201) 0.000758601 (-0.0000298763) 0.0000671047 0.0009349093 := by
  have h0 := errBlockLin_of_piece (q0 := 2.5980768) (q1 := 2.6457508) (m := vBP 2.6925819)
    (Lo := (-0.01497986)) (Hi := 0.00858432) (Klo := (-0.000986470522)) (Khi := (-0.000491595027))
    (by norm_num) (by norm_num) (by norm_num) errPtT20
    vbpT19.1 vbpT19.2 vbpT20.1 vbpT20.2 vbpT22.1 vbpT22.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h1 := errBlockLin_of_piece (q0 := 2.6457508) (q1 := 2.6457519) (m := vBP 2.6925819)
    (Lo := (-0.01127054)) (Hi := 0.02032429) (Klo := (-0.000262826715)) (Khi := 0.000262804691)
    (by norm_num) (by norm_num) (by norm_num) errPtT21
    vbpT20.1 vbpT20.2 vbpT21.1 vbpT21.2 vbpT22.1 vbpT22.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h2 := errBlockLin_of_piece (q0 := 2.6457519) (q1 := 2.6925819) (m := vBP 2.6925819)
    (Lo := (-0.01448098)) (Hi := 0.00781838) (Klo := (-0.000479340508)) (Khi := 0.000015354074)
    (by norm_num) (by norm_num) (by norm_num) errPtT22
    vbpT21.1 vbpT21.2 vbpT22.1 vbpT22.2 vbpT22.1 vbpT22.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h3 := errBlockLin_of_piece (q0 := 2.6925819) (q1 := 2.692583) (m := vBP 2.6925819)
    (Lo := (-0.01072214)) (Hi := 0.01963118) (Klo := (-0.000231879207)) (Khi := 0.000231879295)
    (by norm_num) (by norm_num) (by norm_num) errPtT23
    vbpT22.1 vbpT22.2 vbpT23.1 vbpT23.2 vbpT22.1 vbpT22.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h4 := errBlockLin_of_piece (q0 := 2.692583) (q1 := 2.7386122) (m := vBP 2.6925819)
    (Lo := 0.00106647) (Hi := 0.02230021) (Klo := (-0.000009038505)) (Khi := 0.000430135487)
    (by norm_num) (by norm_num) (by norm_num) errPtT24
    vbpT23.1 vbpT23.2 vbpT24.1 vbpT24.2 vbpT22.1 vbpT22.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h5 := errBlockLin_of_piece (q0 := 2.7386122) (q1 := 2.7386133) (m := vBP 2.6925819)
    (Lo := (-0.010233)) (Hi := 0.01897633) (Klo := (-0.000207284551)) (Khi := 0.000207304187)
    (by norm_num) (by norm_num) (by norm_num) errPtT25
    vbpT24.1 vbpT24.2 vbpT25.1 vbpT25.2 vbpT22.1 vbpT22.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h6 := errBlockLin_of_piece (q0 := 2.7386133) (q1 := 2.7838816) (m := vBP 2.6925819)
    (Lo := 0.00155374) (Hi := 0.02175207) (Klo := 0.000378655915) (Khi := 0.000815841132)
    (by norm_num) (by norm_num) (by norm_num) errPtT26
    vbpT25.1 vbpT25.2 vbpT26.1 vbpT26.2 vbpT22.1 vbpT22.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h7 := errBlockLin_of_piece (q0 := 2.7838816) (q1 := 2.7838827) (m := vBP 2.6925819)
    (Lo := (-0.00979439)) (Hi := 0.01835717) (Klo := (-0.000229872077)) (Khi := 0.0002299096)
    (by norm_num) (by norm_num) (by norm_num) errPtT27
    vbpT26.1 vbpT26.2 vbpT27.1 vbpT27.2 vbpT22.1 vbpT22.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  exact (((((((h0.add h1).add h2).add h3).add h4).add h5).add h6).add h7).mono (by norm_num) (by norm_num) (by norm_num [mn4])
    (by norm_num [mx4]) (by norm_num)

theorem blkLo15 : errBlockLin (vBP 2.5980768) (vBP 2.7838827) (vBP 2.6925819) (-0.0003664201) 0.000758601 (-0.0000298763) 0.0000671047 0.0009349093 :=
  errBlockLin.mono blkLo15_0 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
    (by norm_num)

theorem blkLo16_0 : errBlockLin (vBP 2.7838827) (vBP 2.9580404) (vBP 2.8722808) (-0.0002286396) 0.0005349007 (-0.000024033) 0.0000483705 0.0006460352 := by
  have h0 := errBlockLin_of_piece (q0 := 2.7838827) (q1 := 2.8284266) (m := vBP 2.8722808)
    (Lo := (-0.01203893)) (Hi := 0.00715885) (Klo := (-0.000755484763)) (Khi := (-0.000301904914))
    (by norm_num) (by norm_num) (by norm_num) errPtT28
    vbpT27.1 vbpT27.2 vbpT28.1 vbpT28.2 vbpT30.1 vbpT30.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h1 := errBlockLin_of_piece (q0 := 2.8284266) (q1 := 2.8284277) (m := vBP 2.8722808)
    (Lo := (-0.00939909)) (Hi := 0.0177713) (Klo := (-0.000214379324)) (Khi := 0.000214362849)
    (by norm_num) (by norm_num) (by norm_num) errPtT29
    vbpT28.1 vbpT28.2 vbpT29.1 vbpT29.2 vbpT30.1 vbpT30.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h2 := errBlockLin_of_piece (q0 := 2.8284277) (q1 := 2.8722808) (m := vBP 2.8722808)
    (Lo := (-0.01176092)) (Hi := 0.00658113) (Klo := (-0.000390984641)) (Khi := 0.000058820564)
    (by norm_num) (by norm_num) (by norm_num) errPtT30
    vbpT29.1 vbpT29.2 vbpT30.1 vbpT30.2 vbpT30.1 vbpT30.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h3 := errBlockLin_of_piece (q0 := 2.8722808) (q1 := 2.8722819) (m := vBP 2.8722808)
    (Lo := (-0.00904115)) (Hi := 0.01721647) (Klo := (-0.000235433802)) (Khi := 0.000235434417)
    (by norm_num) (by norm_num) (by norm_num) errPtT31
    vbpT30.1 vbpT30.2 vbpT31.1 vbpT31.2 vbpT30.1 vbpT30.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h4 := errBlockLin_of_piece (q0 := 2.8722819) (q1 := 2.9154754) (m := vBP 2.8722808)
    (Lo := 0.00156188) (Hi := 0.01916882) (Klo := (-0.000070008416)) (Khi := 0.000376329509)
    (by norm_num) (by norm_num) (by norm_num) errPtT32
    vbpT31.1 vbpT31.2 vbpT32.1 vbpT32.2 vbpT30.1 vbpT30.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h5 := errBlockLin_of_piece (q0 := 2.9154754) (q1 := 2.9154765) (m := vBP 2.8722808)
    (Lo := (-0.00871558)) (Hi := 0.01669059) (Klo := (-0.000210896024)) (Khi := 0.000210911607)
    (by norm_num) (by norm_num) (by norm_num) errPtT33
    vbpT32.1 vbpT32.2 vbpT33.1 vbpT33.2 vbpT30.1 vbpT30.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h6 := errBlockLin_of_piece (q0 := 2.9154765) (q1 := 2.9580393) (m := vBP 2.8722808)
    (Lo := 0.0018679) (Hi := 0.01875166) (Klo := 0.000217088669) (Khi := 0.000658485331)
    (by norm_num) (by norm_num) (by norm_num) errPtT34
    vbpT33.1 vbpT33.2 vbpT34.1 vbpT34.2 vbpT30.1 vbpT30.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h7 := errBlockLin_of_piece (q0 := 2.9580393) (q1 := 2.9580404) (m := vBP 2.8722808)
    (Lo := (-0.00841821)) (Hi := 0.01619172) (Klo := (-0.000230477885)) (Khi := 0.000230507792)
    (by norm_num) (by norm_num) (by norm_num) errPtT35
    vbpT34.1 vbpT34.2 vbpT35.1 vbpT35.2 vbpT30.1 vbpT30.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  exact (((((((h0.add h1).add h2).add h3).add h4).add h5).add h6).add h7).mono (by norm_num) (by norm_num) (by norm_num [mn4])
    (by norm_num [mx4]) (by norm_num)

theorem blkLo16 : errBlockLin (vBP 2.7838827) (vBP 2.9580404) (vBP 2.8722808) (-0.0002286396) 0.0005349007 (-0.000024033) 0.0000483705 0.0006460352 :=
  errBlockLin.mono blkLo16_0 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
    (by norm_num)

end ConnesConsani.WeilPositivity
