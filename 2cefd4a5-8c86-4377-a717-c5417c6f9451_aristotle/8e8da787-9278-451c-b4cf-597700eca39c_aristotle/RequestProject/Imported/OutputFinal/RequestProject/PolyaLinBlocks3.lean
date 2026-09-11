/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.
-/
import RequestProject.Imported.OutputFinal.RequestProject.PolyaLinVbp1
import RequestProject.Imported.OutputFinal.RequestProject.PolyaLinVbp2
import RequestProject.Imported.OutputFinal.RequestProject.PolyaLinVbp3
import RequestProject.Imported.OutputFinal.RequestProject.PolyaLinVbp4
import RequestProject.Imported.OutputFinal.RequestProject.PolyaLinPieces1
import RequestProject.Imported.OutputFinal.RequestProject.PolyaLinPieces2
import RequestProject.Imported.OutputFinal.RequestProject.PolyaLinPieces3
import RequestProject.Imported.OutputFinal.RequestProject.PolyaLinPieces4
import RequestProject.Imported.OutputFinal.RequestProject.PolyaLinPieces5
import RequestProject.Imported.OutputFinal.RequestProject.PolyaLinPieces6
import RequestProject.Imported.OutputFinal.RequestProject.PolyaLinPieces7
import RequestProject.Imported.OutputFinal.RequestProject.PolyaLinPieces8

/-!
# The block data: integral, first moment and absolute integral of `err` (part 3)

Each block groups consecutive pieces of the partition; the base point `vBP qm` is a
breakpoint near the middle of the block.
-/

set_option maxHeartbeats 1000000

noncomputable section

open MeasureTheory Set Real

namespace ConnesConsani.WeilPositivity

theorem blkLin8 : errBlockLin (vBP 1.195) (vBP 1.222) (vBP 1.208) 0.012578841 0.0131443379 (-0.0000016584) 0.0000047748 0.0131443379 := by
  have h0 := errBlockLin_of_piece (q0 := 1.195) (q1 := 1.196) (m := vBP 1.208)
    (Lo := 0.3597074) (Hi := 0.3751566) (Klo := (-0.000029117855)) (Khi := (-0.000029106144))
    (by norm_num) (by norm_num) (by norm_num) errPt326
    vbpP326.1 vbpP326.2 vbpP327.1 vbpP327.2 vbpP339.1 vbpP339.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h1 := errBlockLin_of_piece (q0 := 1.196) (q1 := 1.197) (m := vBP 1.208)
    (Lo := 0.35861813) (Hi := 0.37405915) (Klo := (-0.00002673337)) (Khi := (-0.000026719996))
    (by norm_num) (by norm_num) (by norm_num) errPt327
    vbpP327.1 vbpP327.2 vbpP328.1 vbpP328.2 vbpP339.1 vbpP339.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h2 := errBlockLin_of_piece (q0 := 1.197) (q1 := 1.198) (m := vBP 1.208)
    (Lo := 0.3574743) (Hi := 0.37290668) (Klo := (-0.000024358194)) (Khi := (-0.000024346502))
    (by norm_num) (by norm_num) (by norm_num) errPt328
    vbpP328.1 vbpP328.2 vbpP329.1 vbpP329.2 vbpP339.1 vbpP339.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h3 := errBlockLin_of_piece (q0 := 1.198) (q1 := 1.199) (m := vBP 1.208)
    (Lo := 0.35627645) (Hi := 0.37169972) (Klo := (-0.000021992297)) (Khi := (-0.000021980615))
    (by norm_num) (by norm_num) (by norm_num) errPt329
    vbpP329.1 vbpP329.2 vbpP330.1 vbpP330.2 vbpP339.1 vbpP339.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h4 := errBlockLin_of_piece (q0 := 1.199) (q1 := 1.2) (m := vBP 1.208)
    (Lo := 0.35502509) (Hi := 0.37043878) (Klo := (-0.000019637315)) (Khi := (-0.000019625642))
    (by norm_num) (by norm_num) (by norm_num) errPt330
    vbpP330.1 vbpP330.2 vbpP331.1 vbpP331.2 vbpP339.1 vbpP339.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h5 := errBlockLin_of_piece (q0 := 1.2) (q1 := 1.201) (m := vBP 1.208)
    (Lo := 0.35372077) (Hi := 0.3691244) (Klo := (-0.000017291545)) (Khi := (-0.000017279883))
    (by norm_num) (by norm_num) (by norm_num) errPt331
    vbpP331.1 vbpP331.2 vbpP332.1 vbpP332.2 vbpP339.1 vbpP339.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h6 := errBlockLin_of_piece (q0 := 1.201) (q1 := 1.202) (m := vBP 1.208)
    (Lo := 0.35236401) (Hi := 0.36775711) (Klo := (-0.000014956623)) (Khi := (-0.000014944969))
    (by norm_num) (by norm_num) (by norm_num) errPt332
    vbpP332.1 vbpP332.2 vbpP333.1 vbpP333.2 vbpP339.1 vbpP339.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h7 := errBlockLin_of_piece (q0 := 1.202) (q1 := 1.203) (m := vBP 1.208)
    (Lo := 0.35095536) (Hi := 0.36633746) (Klo := (-0.000012629185)) (Khi := (-0.000012617542))
    (by norm_num) (by norm_num) (by norm_num) errPt333
    vbpP333.1 vbpP333.2 vbpP334.1 vbpP334.2 vbpP339.1 vbpP339.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h8 := errBlockLin_of_piece (q0 := 1.203) (q1 := 1.204) (m := vBP 1.208)
    (Lo := 0.34949535) (Hi := 0.36486597) (Klo := (-0.00001031253)) (Khi := (-0.000010300896))
    (by norm_num) (by norm_num) (by norm_num) errPt334
    vbpP334.1 vbpP334.2 vbpP335.1 vbpP335.2 vbpP339.1 vbpP339.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h9 := errBlockLin_of_piece (q0 := 1.204) (q1 := 1.205) (m := vBP 1.208)
    (Lo := 0.34798455) (Hi := 0.3633432) (Klo := (-0.000008006622)) (Khi := (-0.000007994998))
    (by norm_num) (by norm_num) (by norm_num) errPt335
    vbpP335.1 vbpP335.2 vbpP336.1 vbpP336.2 vbpP339.1 vbpP339.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h10 := errBlockLin_of_piece (q0 := 1.205) (q1 := 1.206) (m := vBP 1.208)
    (Lo := 0.3464235) (Hi := 0.3617697) (Klo := (-0.000005708109)) (Khi := (-0.000005696494))
    (by norm_num) (by norm_num) (by norm_num) errPt336
    vbpP336.1 vbpP336.2 vbpP337.1 vbpP337.2 vbpP339.1 vbpP339.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h11 := errBlockLin_of_piece (q0 := 1.206) (q1 := 1.207) (m := vBP 1.208)
    (Lo := 0.34481276) (Hi := 0.36014602) (Klo := (-0.000003420278)) (Khi := (-0.000003408674))
    (by norm_num) (by norm_num) (by norm_num) errPt337
    vbpP337.1 vbpP337.2 vbpP338.1 vbpP338.2 vbpP339.1 vbpP339.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h12 := errBlockLin_of_piece (q0 := 1.207) (q1 := 1.208) (m := vBP 1.208)
    (Lo := 0.34315288) (Hi := 0.35847271) (Klo := (-0.000001143098)) (Khi := (-0.000001129846))
    (by norm_num) (by norm_num) (by norm_num) errPt338
    vbpP338.1 vbpP338.2 vbpP339.1 vbpP339.2 vbpP339.1 vbpP339.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h13 := errBlockLin_of_piece (q0 := 1.208) (q1 := 1.209) (m := vBP 1.208)
    (Lo := 0.34144443) (Hi := 0.35675035) (Klo := 0.000001126778) (Khi := 0.000001140018)
    (by norm_num) (by norm_num) (by norm_num) errPt339
    vbpP339.1 vbpP339.2 vbpP340.1 vbpP340.2 vbpP339.1 vbpP339.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h14 := errBlockLin_of_piece (q0 := 1.209) (q1 := 1.21) (m := vBP 1.208)
    (Lo := 0.33968799) (Hi := 0.35497949) (Klo := 0.000003386067) (Khi := 0.000003399296)
    (by norm_num) (by norm_num) (by norm_num) errPt340
    vbpP340.1 vbpP340.2 vbpP341.1 vbpP341.2 vbpP339.1 vbpP339.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h15 := errBlockLin_of_piece (q0 := 1.21) (q1 := 1.211) (m := vBP 1.208)
    (Lo := 0.33788411) (Hi := 0.3531607) (Klo := 0.000005636456) (Khi := 0.000005649675)
    (by norm_num) (by norm_num) (by norm_num) errPt341
    vbpP341.1 vbpP341.2 vbpP342.1 vbpP342.2 vbpP339.1 vbpP339.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h16 := errBlockLin_of_piece (q0 := 1.211) (q1 := 1.212) (m := vBP 1.208)
    (Lo := 0.33603337) (Hi := 0.35129456) (Klo := 0.000007877974) (Khi := 0.000007891182)
    (by norm_num) (by norm_num) (by norm_num) errPt342
    vbpP342.1 vbpP342.2 vbpP343.1 vbpP343.2 vbpP339.1 vbpP339.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h17 := errBlockLin_of_piece (q0 := 1.212) (q1 := 1.213) (m := vBP 1.208)
    (Lo := 0.33413636) (Hi := 0.34938164) (Klo := 0.000010109003) (Khi := 0.0000101222)
    (by norm_num) (by norm_num) (by norm_num) errPt343
    vbpP343.1 vbpP343.2 vbpP344.1 vbpP344.2 vbpP339.1 vbpP339.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h18 := errBlockLin_of_piece (q0 := 1.213) (q1 := 1.214) (m := vBP 1.208)
    (Lo := 0.33219365) (Hi := 0.34742252) (Klo := 0.000012332871) (Khi := 0.000012346057)
    (by norm_num) (by norm_num) (by norm_num) errPt344
    vbpP344.1 vbpP344.2 vbpP345.1 vbpP345.2 vbpP339.1 vbpP339.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h19 := errBlockLin_of_piece (q0 := 1.214) (q1 := 1.215) (m := vBP 1.208)
    (Lo := 0.33020583) (Hi := 0.3454178) (Klo := 0.000014546309) (Khi := 0.000014557838)
    (by norm_num) (by norm_num) (by norm_num) errPt345
    vbpP345.1 vbpP345.2 vbpP346.1 vbpP346.2 vbpP339.1 vbpP339.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h20 := errBlockLin_of_piece (q0 := 1.215) (q1 := 1.216) (m := vBP 1.208)
    (Lo := 0.32817348) (Hi := 0.34336804) (Klo := 0.000016750999) (Khi := 0.000016762517)
    (by norm_num) (by norm_num) (by norm_num) errPt346
    vbpP346.1 vbpP346.2 vbpP347.1 vbpP347.2 vbpP339.1 vbpP339.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h21 := errBlockLin_of_piece (q0 := 1.216) (q1 := 1.217) (m := vBP 1.208)
    (Lo := 0.3260972) (Hi := 0.34127385) (Klo := 0.000018945322) (Khi := 0.000018958475)
    (by norm_num) (by norm_num) (by norm_num) errPt347
    vbpP347.1 vbpP347.2 vbpP348.1 vbpP348.2 vbpP339.1 vbpP339.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h22 := errBlockLin_of_piece (q0 := 1.217) (q1 := 1.218) (m := vBP 1.208)
    (Lo := 0.32397759) (Hi := 0.33913582) (Klo := 0.000021130956) (Khi := 0.000021144099)
    (by norm_num) (by norm_num) (by norm_num) errPt348
    vbpP348.1 vbpP348.2 vbpP349.1 vbpP349.2 vbpP339.1 vbpP339.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h23 := errBlockLin_of_piece (q0 := 1.218) (q1 := 1.219) (m := vBP 1.208)
    (Lo := 0.32181525) (Hi := 0.33695454) (Klo := 0.000023309571) (Khi := 0.000023322703)
    (by norm_num) (by norm_num) (by norm_num) errPt349
    vbpP349.1 vbpP349.2 vbpP350.1 vbpP350.2 vbpP339.1 vbpP339.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h24 := errBlockLin_of_piece (q0 := 1.219) (q1 := 1.22) (m := vBP 1.208)
    (Lo := 0.31961076) (Hi := 0.33473062) (Klo := 0.000025477911) (Khi := 0.000025491032)
    (by norm_num) (by norm_num) (by norm_num) errPt350
    vbpP350.1 vbpP350.2 vbpP351.1 vbpP351.2 vbpP339.1 vbpP339.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h25 := errBlockLin_of_piece (q0 := 1.22) (q1 := 1.221) (m := vBP 1.208)
    (Lo := 0.31736475) (Hi := 0.33246466) (Klo := 0.000027636009) (Khi := 0.000027649119)
    (by norm_num) (by norm_num) (by norm_num) errPt351
    vbpP351.1 vbpP351.2 vbpP352.1 vbpP352.2 vbpP339.1 vbpP339.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h26 := errBlockLin_of_piece (q0 := 1.221) (q1 := 1.222) (m := vBP 1.208)
    (Lo := 0.31507782) (Hi := 0.33015726) (Klo := 0.000029785535) (Khi := 0.000029800272)
    (by norm_num) (by norm_num) (by norm_num) errPt352
    vbpP352.1 vbpP352.2 vbpP353.1 vbpP353.2 vbpP339.1 vbpP339.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  exact ((((((((((((((((((((((((((h0.add h1).add h2).add h3).add h4).add h5).add h6).add h7).add h8).add h9).add h10).add h11).add h12).add h13).add h14).add h15).add h16).add h17).add h18).add h19).add h20).add h21).add h22).add h23).add h24).add h25).add h26).mono (by norm_num) (by norm_num) (by norm_num [mn4])
    (by norm_num [mx4]) (by norm_num)

theorem blkLin9 : errBlockLin (vBP 1.222) (vBP 1.25) (vBP 1.236) 0.0101199431 0.0106962613 (-0.0000163489) (-0.0000093791) 0.0106962613 := by
  have h0 := errBlockLin_of_piece (q0 := 1.222) (q1 := 1.223) (m := vBP 1.236)
    (Lo := 0.31275058) (Hi := 0.32780905) (Klo := (-0.00002940444)) (Khi := (-0.000029383171))
    (by norm_num) (by norm_num) (by norm_num) errPt353
    vbpP353.1 vbpP353.2 vbpP354.1 vbpP354.2 vbpP367.1 vbpP367.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h1 := errBlockLin_of_piece (q0 := 1.223) (q1 := 1.224) (m := vBP 1.236)
    (Lo := 0.31038364) (Hi := 0.32542062) (Klo := (-0.000027171762)) (Khi := (-0.000027152145))
    (by norm_num) (by norm_num) (by norm_num) errPt354
    vbpP354.1 vbpP354.2 vbpP355.1 vbpP355.2 vbpP367.1 vbpP367.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h2 := errBlockLin_of_piece (q0 := 1.224) (q1 := 1.225) (m := vBP 1.236)
    (Lo := 0.2829811) (Hi := 0.32376595) (Klo := (-0.000024947816)) (Khi := (-0.000024928215))
    (by norm_num) (by norm_num) (by norm_num) errPt355
    vbpP355.1 vbpP355.2 vbpP356.1 vbpP356.2 vbpP367.1 vbpP367.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h3 := errBlockLin_of_piece (q0 := 1.225) (q1 := 1.226) (m := vBP 1.236)
    (Lo := 0.30553093) (Hi := 0.32052814) (Klo := (-0.000022732574)) (Khi := (-0.000022712989))
    (by norm_num) (by norm_num) (by norm_num) errPt356
    vbpP356.1 vbpP356.2 vbpP357.1 vbpP357.2 vbpP367.1 vbpP367.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h4 := errBlockLin_of_piece (q0 := 1.226) (q1 := 1.227) (m := vBP 1.236)
    (Lo := 0.30304545) (Hi := 0.318026) (Klo := (-0.000020527639)) (Khi := (-0.00002050644))
    (by norm_num) (by norm_num) (by norm_num) errPt357
    vbpP357.1 vbpP357.2 vbpP358.1 vbpP358.2 vbpP367.1 vbpP367.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h5 := errBlockLin_of_piece (q0 := 1.227) (q1 := 1.228) (m := vBP 1.236)
    (Lo := 0.30052277) (Hi := 0.31548614) (Klo := (-0.000018331349)) (Khi := (-0.000018308538))
    (by norm_num) (by norm_num) (by norm_num) errPt358
    vbpP358.1 vbpP358.2 vbpP359.1 vbpP359.2 vbpP367.1 vbpP367.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h6 := errBlockLin_of_piece (q0 := 1.228) (q1 := 1.229) (m := vBP 1.236)
    (Lo := 0.29796349) (Hi := 0.31290918) (Klo := (-0.000016142048)) (Khi := (-0.000016120882))
    (by norm_num) (by norm_num) (by norm_num) errPt359
    vbpP359.1 vbpP359.2 vbpP360.1 vbpP360.2 vbpP367.1 vbpP367.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h7 := errBlockLin_of_piece (q0 := 1.229) (q1 := 1.23) (m := vBP 1.236)
    (Lo := 0.29536827) (Hi := 0.31029575) (Klo := (-0.000013962963)) (Khi := (-0.000013941816))
    (by norm_num) (by norm_num) (by norm_num) errPt360
    vbpP360.1 vbpP360.2 vbpP361.1 vbpP361.2 vbpP367.1 vbpP367.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h8 := errBlockLin_of_piece (q0 := 1.23) (q1 := 1.231) (m := vBP 1.236)
    (Lo := 0.29273774) (Hi := 0.3076465) (Klo := (-0.000011794064)) (Khi := (-0.000011771308))
    (by norm_num) (by norm_num) (by norm_num) errPt361
    vbpP361.1 vbpP361.2 vbpP362.1 vbpP362.2 vbpP367.1 vbpP367.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h9 := errBlockLin_of_piece (q0 := 1.231) (q1 := 1.232) (m := vBP 1.236)
    (Lo := 0.29007253) (Hi := 0.30496205) (Klo := (-0.00000963207)) (Khi := (-0.000009609333))
    (by norm_num) (by norm_num) (by norm_num) errPt362
    vbpP362.1 vbpP362.2 vbpP363.1 vbpP363.2 vbpP367.1 vbpP367.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h10 := errBlockLin_of_piece (q0 := 1.232) (q1 := 1.233) (m := vBP 1.236)
    (Lo := 0.28737328) (Hi := 0.30224304) (Klo := (-0.000007478581)) (Khi := (-0.000007455862))
    (by norm_num) (by norm_num) (by norm_num) errPt363
    vbpP363.1 vbpP363.2 vbpP364.1 vbpP364.2 vbpP367.1 vbpP367.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h11 := errBlockLin_of_piece (q0 := 1.233) (q1 := 1.234) (m := vBP 1.236)
    (Lo := 0.28464063) (Hi := 0.29949011) (Klo := (-0.000005333568)) (Khi := (-0.000005310867))
    (by norm_num) (by norm_num) (by norm_num) errPt364
    vbpP364.1 vbpP364.2 vbpP365.1 vbpP365.2 vbpP367.1 vbpP367.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h12 := errBlockLin_of_piece (q0 := 1.234) (q1 := 1.235) (m := vBP 1.236)
    (Lo := 0.28187524) (Hi := 0.29670391) (Klo := (-0.000003200243)) (Khi := (-0.000003177561))
    (by norm_num) (by norm_num) (by norm_num) errPt365
    vbpP365.1 vbpP365.2 vbpP366.1 vbpP366.2 vbpP367.1 vbpP367.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h13 := errBlockLin_of_piece (q0 := 1.235) (q1 := 1.236) (m := vBP 1.236)
    (Lo := 0.27907774) (Hi := 0.29388507) (Klo := (-0.000001072097)) (Khi := (-0.000001047815))
    (by norm_num) (by norm_num) (by norm_num) errPt366
    vbpP366.1 vbpP366.2 vbpP367.1 vbpP367.2 vbpP367.1 vbpP367.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h14 := errBlockLin_of_piece (q0 := 1.236) (q1 := 1.237) (m := vBP 1.236)
    (Lo := 0.27624878) (Hi := 0.29103426) (Klo := 0.000001046037) (Khi := 0.000001070301)
    (by norm_num) (by norm_num) (by norm_num) errPt367
    vbpP367.1 vbpP367.2 vbpP368.1 vbpP368.2 vbpP367.1 vbpP367.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h15 := errBlockLin_of_piece (q0 := 1.237) (q1 := 1.238) (m := vBP 1.236)
    (Lo := 0.27338902) (Hi := 0.28815212) (Klo := 0.000003155808) (Khi := 0.000003178435)
    (by norm_num) (by norm_num) (by norm_num) errPt368
    vbpP368.1 vbpP368.2 vbpP369.1 vbpP369.2 vbpP367.1 vbpP367.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h16 := errBlockLin_of_piece (q0 := 1.238) (q1 := 1.239) (m := vBP 1.236)
    (Lo := 0.27049911) (Hi := 0.28523929) (Klo := 0.000005257242) (Khi := 0.000005281465)
    (by norm_num) (by norm_num) (by norm_num) errPt369
    vbpP369.1 vbpP369.2 vbpP370.1 vbpP370.2 vbpP367.1 vbpP367.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h17 := errBlockLin_of_piece (q0 := 1.239) (q1 := 1.24) (m := vBP 1.236)
    (Lo := 0.2675797) (Hi := 0.28229644) (Klo := 0.000007348752) (Khi := 0.00000737457)
    (by norm_num) (by norm_num) (by norm_num) errPt370
    vbpP370.1 vbpP370.2 vbpP371.1 vbpP371.2 vbpP367.1 vbpP367.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h18 := errBlockLin_of_piece (q0 := 1.24) (q1 := 1.241) (m := vBP 1.236)
    (Lo := 0.26463145) (Hi := 0.27932422) (Klo := 0.000009433595) (Khi := 0.000009459392)
    (by norm_num) (by norm_num) (by norm_num) errPt371
    vbpP371.1 vbpP371.2 vbpP372.1 vbpP372.2 vbpP367.1 vbpP367.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h19 := errBlockLin_of_piece (q0 := 1.241) (q1 := 1.242) (m := vBP 1.236)
    (Lo := 0.26165502) (Hi := 0.27632329) (Klo := 0.000011508571) (Khi := 0.000011534347)
    (by norm_num) (by norm_num) (by norm_num) errPt372
    vbpP372.1 vbpP372.2 vbpP373.1 vbpP373.2 vbpP367.1 vbpP367.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h20 := errBlockLin_of_piece (q0 := 1.242) (q1 := 1.243) (m := vBP 1.236)
    (Lo := 0.25865107) (Hi := 0.27329431) (Klo := 0.00001357693) (Khi := 0.000013602685)
    (by norm_num) (by norm_num) (by norm_num) errPt373
    vbpP373.1 vbpP373.2 vbpP374.1 vbpP374.2 vbpP367.1 vbpP367.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h21 := errBlockLin_of_piece (q0 := 1.243) (q1 := 1.244) (m := vBP 1.236)
    (Lo := 0.25562026) (Hi := 0.27023793) (Klo := 0.000015635477) (Khi := 0.00001566282)
    (by norm_num) (by norm_num) (by norm_num) errPt374
    vbpP374.1 vbpP374.2 vbpP375.1 vbpP375.2 vbpP367.1 vbpP367.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h22 := errBlockLin_of_piece (q0 := 1.244) (q1 := 1.245) (m := vBP 1.236)
    (Lo := 0.25256326) (Hi := 0.26715483) (Klo := 0.00001768585) (Khi := 0.000017713172)
    (by norm_num) (by norm_num) (by norm_num) errPt375
    vbpP375.1 vbpP375.2 vbpP376.1 vbpP376.2 vbpP367.1 vbpP367.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h23 := errBlockLin_of_piece (q0 := 1.245) (q1 := 1.246) (m := vBP 1.236)
    (Lo := 0.24948073) (Hi := 0.26404567) (Klo := 0.000019729683) (Khi := 0.000019756982)
    (by norm_num) (by norm_num) (by norm_num) errPt376
    vbpP376.1 vbpP376.2 vbpP377.1 vbpP377.2 vbpP367.1 vbpP367.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h24 := errBlockLin_of_piece (q0 := 1.246) (q1 := 1.247) (m := vBP 1.236)
    (Lo := 0.24637334) (Hi := 0.26091112) (Klo := 0.000021762182) (Khi := 0.000021791064)
    (by norm_num) (by norm_num) (by norm_num) errPt377
    vbpP377.1 vbpP377.2 vbpP378.1 vbpP378.2 vbpP367.1 vbpP367.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h25 := errBlockLin_of_piece (q0 := 1.247) (q1 := 1.248) (m := vBP 1.236)
    (Lo := 0.24324175) (Hi := 0.25775183) (Klo := 0.000023789795) (Khi := 0.000023818654)
    (by norm_num) (by norm_num) (by norm_num) errPt378
    vbpP378.1 vbpP378.2 vbpP379.1 vbpP379.2 vbpP367.1 vbpP367.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h26 := errBlockLin_of_piece (q0 := 1.248) (q1 := 1.249) (m := vBP 1.236)
    (Lo := 0.24008664) (Hi := 0.25456849) (Klo := 0.000025806133) (Khi := 0.000025834968)
    (by norm_num) (by norm_num) (by norm_num) errPt379
    vbpP379.1 vbpP379.2 vbpP380.1 vbpP380.2 vbpP367.1 vbpP367.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h27 := errBlockLin_of_piece (q0 := 1.249) (q1 := 1.25) (m := vBP 1.236)
    (Lo := 0.23690868) (Hi := 0.25136176) (Klo := 0.000027817632) (Khi := 0.000027846444)
    (by norm_num) (by norm_num) (by norm_num) errPt380
    vbpP380.1 vbpP380.2 vbpP381.1 vbpP381.2 vbpP367.1 vbpP367.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  exact (((((((((((((((((((((((((((h0.add h1).add h2).add h3).add h4).add h5).add h6).add h7).add h8).add h9).add h10).add h11).add h12).add h13).add h14).add h15).add h16).add h17).add h18).add h19).add h20).add h21).add h22).add h23).add h24).add h25).add h26).add h27).mono (by norm_num) (by norm_num) (by norm_num [mn4])
    (by norm_num [mx4]) (by norm_num)

theorem blkLin10 : errBlockLin (vBP 1.25) (vBP 1.278) (vBP 1.264) 0.0065110613 0.0072034721 (-0.0000176663) (-0.0000100205) 0.0072034721 := by
  have h0 := errBlockLin_of_piece (q0 := 1.25) (q1 := 1.251) (m := vBP 1.264)
    (Lo := 0.23370853) (Hi := 0.24813231) (Klo := (-0.000027487444)) (Khi := (-0.00002744586))
    (by norm_num) (by norm_num) (by norm_num) errPt381
    vbpP381.1 vbpP381.2 vbpP382.1 vbpP382.2 vbpP395.1 vbpP395.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h1 := errBlockLin_of_piece (q0 := 1.251) (q1 := 1.252) (m := vBP 1.264)
    (Lo := 0.23048688) (Hi := 0.24488082) (Klo := (-0.000025403615)) (Khi := (-0.000025360466))
    (by norm_num) (by norm_num) (by norm_num) errPt382
    vbpP382.1 vbpP382.2 vbpP383.1 vbpP383.2 vbpP395.1 vbpP395.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h2 := errBlockLin_of_piece (q0 := 1.252) (q1 := 1.253) (m := vBP 1.264)
    (Lo := 0.22724439) (Hi := 0.24160797) (Klo := (-0.000023326372)) (Khi := (-0.000023283257))
    (by norm_num) (by norm_num) (by norm_num) errPt383
    vbpP383.1 vbpP383.2 vbpP384.1 vbpP384.2 vbpP395.1 vbpP395.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h3 := errBlockLin_of_piece (q0 := 1.253) (q1 := 1.254) (m := vBP 1.264)
    (Lo := 0.22398174) (Hi := 0.23831442) (Klo := (-0.000021257288)) (Khi := (-0.000021214208))
    (by norm_num) (by norm_num) (by norm_num) errPt384
    vbpP384.1 vbpP384.2 vbpP385.1 vbpP385.2 vbpP395.1 vbpP395.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h4 := errBlockLin_of_piece (q0 := 1.254) (q1 := 1.255) (m := vBP 1.264)
    (Lo := 0.2206996) (Hi := 0.23500085) (Klo := (-0.000019197932)) (Khi := (-0.000019153291))
    (by norm_num) (by norm_num) (by norm_num) errPt385
    vbpP385.1 vbpP385.2 vbpP386.1 vbpP386.2 vbpP395.1 vbpP395.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h5 := errBlockLin_of_piece (q0 := 1.255) (q1 := 1.256) (m := vBP 1.264)
    (Lo := 0.21739866) (Hi := 0.23166794) (Klo := (-0.000017145086)) (Khi := (-0.000017100482))
    (by norm_num) (by norm_num) (by norm_num) errPt386
    vbpP386.1 vbpP386.2 vbpP387.1 vbpP387.2 vbpP395.1 vbpP395.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h6 := errBlockLin_of_piece (q0 := 1.256) (q1 := 1.257) (m := vBP 1.264)
    (Lo := 0.21407958) (Hi := 0.22831637) (Klo := (-0.000015100323)) (Khi := (-0.000015055754))
    (by norm_num) (by norm_num) (by norm_num) errPt387
    vbpP387.1 vbpP387.2 vbpP388.1 vbpP388.2 vbpP395.1 vbpP395.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h7 := errBlockLin_of_piece (q0 := 1.257) (q1 := 1.258) (m := vBP 1.264)
    (Lo := 0.21074305) (Hi := 0.22494681) (Klo := (-0.000013065205)) (Khi := (-0.000013019081))
    (by norm_num) (by norm_num) (by norm_num) errPt388
    vbpP388.1 vbpP388.2 vbpP389.1 vbpP389.2 vbpP395.1 vbpP395.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h8 := errBlockLin_of_piece (q0 := 1.258) (q1 := 1.259) (m := vBP 1.264)
    (Lo := 0.20738974) (Hi := 0.22155995) (Klo := (-0.000011036526)) (Khi := (-0.000010988849))
    (by norm_num) (by norm_num) (by norm_num) errPt389
    vbpP389.1 vbpP389.2 vbpP390.1 vbpP390.2 vbpP395.1 vbpP395.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h9 := errBlockLin_of_piece (q0 := 1.259) (q1 := 1.26) (m := vBP 1.264)
    (Lo := 0.20402033) (Hi := 0.21815646) (Klo := (-0.000009017439)) (Khi := (-0.0000089698))
    (by norm_num) (by norm_num) (by norm_num) errPt390
    vbpP390.1 vbpP390.2 vbpP391.1 vbpP391.2 vbpP395.1 vbpP395.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h10 := errBlockLin_of_piece (q0 := 1.26) (q1 := 1.261) (m := vBP 1.264)
    (Lo := 0.2006355) (Hi := 0.21473702) (Klo := (-0.000007004742)) (Khi := (-0.000006957141))
    (by norm_num) (by norm_num) (by norm_num) errPt391
    vbpP391.1 vbpP391.2 vbpP392.1 vbpP392.2 vbpP395.1 vbpP395.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h11 := errBlockLin_of_piece (q0 := 1.261) (q1 := 1.262) (m := vBP 1.264)
    (Lo := 0.19723593) (Hi := 0.21130231) (Klo := (-0.000005001584)) (Khi := (-0.000004952436))
    (by norm_num) (by norm_num) (by norm_num) errPt392
    vbpP392.1 vbpP392.2 vbpP393.1 vbpP393.2 vbpP395.1 vbpP395.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h12 := errBlockLin_of_piece (q0 := 1.262) (q1 := 1.263) (m := vBP 1.264)
    (Lo := 0.19382229) (Hi := 0.20785301) (Klo := (-0.000003004769)) (Khi := (-0.000002954075))
    (by norm_num) (by norm_num) (by norm_num) errPt393
    vbpP393.1 vbpP393.2 vbpP394.1 vbpP394.2 vbpP395.1 vbpP395.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h13 := errBlockLin_of_piece (q0 := 1.263) (q1 := 1.264) (m := vBP 1.264)
    (Lo := 0.19039527) (Hi := 0.20438981) (Klo := (-0.000001017439)) (Khi := (-0.000000966785))
    (by norm_num) (by norm_num) (by norm_num) errPt394
    vbpP394.1 vbpP394.2 vbpP395.1 vbpP395.2 vbpP395.1 vbpP395.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h14 := errBlockLin_of_piece (q0 := 1.264) (q1 := 1.266) (m := vBP 1.264)
    (Lo := 0.17832247) (Hi := 0.20611127) (Klo := 0.00000392409) (Khi := 0.000003976264)
    (by norm_num) (by norm_num) (by norm_num) errPt395
    vbpP395.1 vbpP395.2 vbpP396.1 vbpP396.2 vbpP395.1 vbpP395.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h15 := errBlockLin_of_piece (q0 := 1.266) (q1 := 1.268) (m := vBP 1.264)
    (Lo := 0.1714338) (Hi := 0.19907318) (Klo := 0.000011785486) (Khi := 0.000011839157)
    (by norm_num) (by norm_num) (by norm_num) errPt396
    vbpP396.1 vbpP396.2 vbpP397.1 vbpP397.2 vbpP395.1 vbpP395.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h16 := errBlockLin_of_piece (q0 := 1.268) (q1 := 1.27) (m := vBP 1.264)
    (Lo := 0.16450479) (Hi := 0.19199067) (Klo := 0.000019581395) (Khi := 0.000019638131)
    (by norm_num) (by norm_num) (by norm_num) errPt397
    vbpP397.1 vbpP397.2 vbpP398.1 vbpP398.2 vbpP395.1 vbpP395.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h17 := errBlockLin_of_piece (q0 := 1.27) (q1 := 1.272) (m := vBP 1.264)
    (Lo := 0.15754085) (Hi := 0.18486919) (Klo := 0.000027316941) (Khi := 0.000027376737)
    (by norm_num) (by norm_num) (by norm_num) errPt398
    vbpP398.1 vbpP398.2 vbpP399.1 vbpP399.2 vbpP395.1 vbpP395.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h18 := errBlockLin_of_piece (q0 := 1.272) (q1 := 1.274) (m := vBP 1.264)
    (Lo := 0.15054735) (Hi := 0.17771415) (Klo := 0.000034992508) (Khi := 0.000035053781)
    (by norm_num) (by norm_num) (by norm_num) errPt399
    vbpP399.1 vbpP399.2 vbpP400.1 vbpP400.2 vbpP395.1 vbpP395.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h19 := errBlockLin_of_piece (q0 := 1.274) (q1 := 1.275) (m := vBP 1.264)
    (Lo := 0.15200832) (Hi := 0.16557083) (Klo := 0.000020339767) (Khi := 0.000020402538)
    (by norm_num) (by norm_num) (by norm_num) errPt400
    vbpP400.1 vbpP400.2 vbpP401.1 vbpP401.2 vbpP395.1 vbpP395.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h20 := errBlockLin_of_piece (q0 := 1.275) (q1 := 1.276) (m := vBP 1.264)
    (Lo := 0.14847346) (Hi := 0.16199366) (Klo := 0.000022235762) (Khi := 0.000022300051)
    (by norm_num) (by norm_num) (by norm_num) errPt401
    vbpP401.1 vbpP401.2 vbpP402.1 vbpP402.2 vbpP395.1 vbpP395.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h21 := errBlockLin_of_piece (q0 := 1.276) (q1 := 1.278) (m := vBP 1.264)
    (Lo := 0.1364932) (Hi := 0.16332506) (Klo := 0.000050162072) (Khi := 0.000050227852)
    (by norm_num) (by norm_num) (by norm_num) errPt402
    vbpP402.1 vbpP402.2 vbpP403.1 vbpP403.2 vbpP395.1 vbpP395.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  exact (((((((((((((((((((((h0.add h1).add h2).add h3).add h4).add h5).add h6).add h7).add h8).add h9).add h10).add h11).add h12).add h13).add h14).add h15).add h16).add h17).add h18).add h19).add h20).add h21).mono (by norm_num) (by norm_num) (by norm_num [mn4])
    (by norm_num [mx4]) (by norm_num)

theorem blkLin11 : errBlockLin (vBP 1.278) (vBP 1.303) (vBP 1.289) 0.002614576 0.0035183687 (-0.000006198) 0.0000024769 0.0035183687 := by
  have h0 := errBlockLin_of_piece (q0 := 1.278) (q1 := 1.28) (m := vBP 1.289)
    (Lo := 0.12944324) (Hi := 0.15610178) (Klo := (-0.00003814357)) (Khi := (-0.000038037238))
    (by norm_num) (by norm_num) (by norm_num) errPt403
    vbpP403.1 vbpP403.2 vbpP404.1 vbpP404.2 vbpP408.1 vbpP408.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h1 := errBlockLin_of_piece (q0 := 1.28) (q1 := 1.282) (m := vBP 1.289)
    (Lo := 0.12238512) (Hi := 0.1488665) (Klo := (-0.000030408418)) (Khi := (-0.000030299127))
    (by norm_num) (by norm_num) (by norm_num) errPt404
    vbpP404.1 vbpP404.2 vbpP405.1 vbpP405.2 vbpP408.1 vbpP408.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h2 := errBlockLin_of_piece (q0 := 1.282) (q1 := 1.284) (m := vBP 1.289)
    (Lo := 0.11532411) (Hi := 0.14162455) (Klo := (-0.000022732775)) (Khi := (-0.000022622097))
    (by norm_num) (by norm_num) (by norm_num) errPt405
    vbpP405.1 vbpP405.2 vbpP406.1 vbpP406.2 vbpP408.1 vbpP408.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h3 := errBlockLin_of_piece (q0 := 1.284) (q1 := 1.286) (m := vBP 1.289)
    (Lo := 0.10826546) (Hi := 0.13438123) (Klo := (-0.000015117831)) (Khi := (-0.000015002657))
    (by norm_num) (by norm_num) (by norm_num) errPt406
    vbpP406.1 vbpP406.2 vbpP407.1 vbpP407.2 vbpP408.1 vbpP408.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h4 := errBlockLin_of_piece (q0 := 1.286) (q1 := 1.289) (m := vBP 1.289)
    (Lo := 0.09303484) (Hi := 0.13181931) (Klo := (-0.000008497377)) (Khi := (-0.000008376214))
    (by norm_num) (by norm_num) (by norm_num) errPt407
    vbpP407.1 vbpP407.2 vbpP408.1 vbpP408.2 vbpP408.1 vbpP408.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h5 := errBlockLin_of_piece (q0 := 1.289) (q1 := 1.292) (m := vBP 1.289)
    (Lo := 0.08256303) (Hi := 0.12091297) (Klo := 0.000008308194) (Khi := 0.000008435274)
    (by norm_num) (by norm_num) (by norm_num) errPt408
    vbpP408.1 vbpP408.2 vbpP409.1 vbpP409.2 vbpP408.1 vbpP408.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h6 := errBlockLin_of_piece (q0 := 1.292) (q1 := 1.294) (m := vBP 1.289)
    (Lo := 0.08015829) (Hi := 0.10549926) (Klo := 0.000014757891) (Khi := 0.000014889368)
    (by norm_num) (by norm_num) (by norm_num) errPt409
    vbpP409.1 vbpP409.2 vbpP410.1 vbpP410.2 vbpP408.1 vbpP408.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h7 := errBlockLin_of_piece (q0 := 1.294) (q1 := 1.296) (m := vBP 1.289)
    (Lo := 0.07318892) (Hi := 0.0983275) (Klo := 0.000022084153) (Khi := 0.000022218516)
    (by norm_num) (by norm_num) (by norm_num) errPt410
    vbpP410.1 vbpP410.2 vbpP411.1 vbpP411.2 vbpP408.1 vbpP408.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h8 := errBlockLin_of_piece (q0 := 1.296) (q1 := 1.298) (m := vBP 1.289)
    (Lo := 0.06625256) (Hi := 0.09118544) (Klo := 0.000029351894) (Khi := 0.000029492215)
    (by norm_num) (by norm_num) (by norm_num) errPt411
    vbpP411.1 vbpP411.2 vbpP412.1 vbpP412.2 vbpP408.1 vbpP408.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h9 := errBlockLin_of_piece (q0 := 1.298) (q1 := 1.3) (m := vBP 1.289)
    (Lo := 0.05935417) (Hi := 0.0840781) (Klo := 0.000036563008) (Khi := 0.000036709274)
    (by norm_num) (by norm_num) (by norm_num) errPt412
    vbpP412.1 vbpP412.2 vbpP413.1 vbpP413.2 vbpP408.1 vbpP408.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h10 := errBlockLin_of_piece (q0 := 1.3) (q1 := 1.303) (m := vBP 1.289)
    (Lo := 0.04472926) (Hi := 0.08138752) (Klo := 0.000068283925) (Khi := 0.000068437588)
    (by norm_num) (by norm_num) (by norm_num) errPt413
    vbpP413.1 vbpP413.2 vbpP414.1 vbpP414.2 vbpP408.1 vbpP408.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  exact ((((((((((h0.add h1).add h2).add h3).add h4).add h5).add h6).add h7).add h8).add h9).add h10).mono (by norm_num) (by norm_num) (by norm_num [mn4])
    (by norm_num [mx4]) (by norm_num)

theorem blkLin12 : errBlockLin (vBP 1.303) (vBP 1.331) (vBP 1.317) (-0.0005253119) 0.0013106435 (-0.0000198636) (-0.0000002863) 0.0016862599 := by
  have h0 := errBlockLin_of_piece (q0 := 1.303) (q1 := 1.308) (m := vBP 1.317)
    (Lo := 0.01943908) (Hi := 0.07941416) (Klo := (-0.00010308172)) (Khi := (-0.000102825892))
    (by norm_num) (by norm_num) (by norm_num) errPt414
    vbpP414.1 vbpP414.2 vbpP415.1 vbpP415.2 vbpP417.1 vbpP417.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h1 := errBlockLin_of_piece (q0 := 1.308) (q1 := 1.312) (m := vBP 1.317)
    (Lo := 0.01066612) (Hi := 0.05765437) (Klo := (-0.000049840023)) (Khi := (-0.000049571329))
    (by norm_num) (by norm_num) (by norm_num) errPt415
    vbpP415.1 vbpP415.2 vbpP416.1 vbpP416.2 vbpP417.1 vbpP417.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h2 := errBlockLin_of_piece (q0 := 1.312) (q1 := 1.317) (m := vBP 1.317)
    (Lo := (-0.00934377)) (Hi := 0.0480906) (Klo := (-0.000022169798)) (Khi := (-0.000021883779))
    (by norm_num) (by norm_num) (by norm_num) errPt416
    vbpP416.1 vbpP416.2 vbpP417.1 vbpP417.2 vbpP417.1 vbpP417.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h3 := errBlockLin_of_piece (q0 := 1.317) (q1 := 1.322) (m := vBP 1.317)
    (Lo := (-0.02465815)) (Hi := 0.03130892) (Klo := 0.00002159643) (Khi := 0.000021905617)
    (by norm_num) (by norm_num) (by norm_num) errPt417
    vbpP417.1 vbpP417.2 vbpP418.1 vbpP418.2 vbpP417.1 vbpP417.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h4 := errBlockLin_of_piece (q0 := 1.322) (q1 := 1.326) (m := vBP 1.317)
    (Lo := (-0.04506155)) (Hi := 0.02271074) (Klo := 0.000048201929) (Khi := 0.00004853273)
    (by norm_num) (by norm_num) (by norm_num) errPt418
    vbpP418.1 vbpP418.2 vbpP419.1 vbpP419.2 vbpP417.1 vbpP417.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h5 := errBlockLin_of_piece (q0 := 1.326) (q1 := 1.331) (m := vBP 1.317)
    (Lo := (-0.05078406)) (Hi := 0.00249367) (Klo := 0.000098309418) (Khi := 0.000098666182)
    (by norm_num) (by norm_num) (by norm_num) errPt419
    vbpP419.1 vbpP419.2 vbpP420.1 vbpP420.2 vbpP417.1 vbpP417.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  exact (((((h0.add h1).add h2).add h3).add h4).add h5).mono (by norm_num) (by norm_num) (by norm_num [mn4])
    (by norm_num [mx4]) (by norm_num)

theorem blkLin13 : errBlockLin (vBP 1.331) (vBP 1.36) (vBP 1.345) (-0.0027684072) (-0.0016322717) (-0.000015495) (-0.0000028762) 0.0027684072 := by
  have h0 := errBlockLin_of_piece (q0 := 1.331) (q1 := 1.336) (m := vBP 1.345)
    (Lo := (-0.06438461)) (Hi := (-0.01262708)) (Klo := (-0.000096902638)) (Khi := (-0.000096319244))
    (by norm_num) (by norm_num) (by norm_num) errPt420
    vbpP420.1 vbpP420.2 vbpP421.1 vbpP421.2 vbpP423.1 vbpP423.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h1 := errBlockLin_of_piece (q0 := 1.336) (q1 := 1.34) (m := vBP 1.345)
    (Lo := (-0.07105739)) (Hi := (-0.03073683)) (Klo := (-0.000046959054)) (Khi := (-0.000046343229))
    (by norm_num) (by norm_num) (by norm_num) errPt421
    vbpP421.1 vbpP421.2 vbpP422.1 vbpP422.2 vbpP423.1 vbpP423.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h2 := errBlockLin_of_piece (q0 := 1.34) (q1 := 1.345) (m := vBP 1.345)
    (Lo := (-0.0870134)) (Hi := (-0.03803994)) (Klo := (-0.000021002003)) (Khi := (-0.000020351018))
    (by norm_num) (by norm_num) (by norm_num) errPt422
    vbpP422.1 vbpP422.2 vbpP423.1 vbpP423.2 vbpP423.1 vbpP423.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h3 := errBlockLin_of_piece (q0 := 1.345) (q1 := 1.348) (m := vBP 1.345)
    (Lo := (-0.08686965)) (Hi := (-0.05816597)) (Klo := 0.000007027137) (Khi := 0.000007713346)
    (by norm_num) (by norm_num) (by norm_num) errPt423
    vbpP423.1 vbpP423.2 vbpP424.1 vbpP424.2 vbpP423.1 vbpP423.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h4 := errBlockLin_of_piece (q0 := 1.348) (q1 := 1.35) (m := vBP 1.345)
    (Lo := (-0.08789711)) (Hi := (-0.06900355)) (Klo := 0.000012697999) (Khi := 0.000013408149)
    (by norm_num) (by norm_num) (by norm_num) errPt424
    vbpP424.1 vbpP424.2 vbpP425.1 vbpP425.2 vbpP423.1 vbpP423.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h5 := errBlockLin_of_piece (q0 := 1.35) (q1 := 1.352) (m := vBP 1.345)
    (Lo := (-0.09233774)) (Hi := (-0.07368344)) (Klo := 0.000019142147) (Khi := 0.00001987345)
    (by norm_num) (by norm_num) (by norm_num) errPt425
    vbpP425.1 vbpP425.2 vbpP426.1 vbpP426.2 vbpP423.1 vbpP423.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h6 := errBlockLin_of_piece (q0 := 1.352) (q1 := 1.355) (m := vBP 1.345)
    (Lo := (-0.10218342)) (Hi := (-0.07476776)) (Klo := 0.000040880247) (Khi := 0.000041639742)
    (by norm_num) (by norm_num) (by norm_num) errPt426
    vbpP426.1 vbpP426.2 vbpP427.1 vbpP427.2 vbpP423.1 vbpP423.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h7 := errBlockLin_of_piece (q0 := 1.355) (q1 := 1.358) (m := vBP 1.345)
    (Lo := (-0.10822264)) (Hi := (-0.08135441)) (Klo := 0.000055119977) (Khi := 0.000055913178)
    (by norm_num) (by norm_num) (by norm_num) errPt427
    vbpP427.1 vbpP427.2 vbpP428.1 vbpP428.2 vbpP423.1 vbpP423.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h8 := errBlockLin_of_piece (q0 := 1.358) (q1 := 1.36) (m := vBP 1.345)
    (Lo := (-0.10869567)) (Hi := (-0.09098268)) (Klo := 0.00004444086) (Khi := 0.000045264986)
    (by norm_num) (by norm_num) (by norm_num) errPt428
    vbpP428.1 vbpP428.2 vbpP429.1 vbpP429.2 vbpP423.1 vbpP423.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  exact ((((((((h0.add h1).add h2).add h3).add h4).add h5).add h6).add h7).add h8).mono (by norm_num) (by norm_num) (by norm_num [mn4])
    (by norm_num [mx4]) (by norm_num)

theorem blkLin14 : errBlockLin (vBP 1.36) (vBP 1.39) (vBP 1.374) (-0.0042624683) (-0.0036560634) (-0.0000141033) (-0.0000051568) 0.0042624683 := by
  have h0 := errBlockLin_of_piece (q0 := 1.36) (q1 := 1.362) (m := vBP 1.374)
    (Lo := (-0.11242482)) (Hi := (-0.09494148)) (Klo := (-0.000041684107)) (Khi := (-0.000040433564))
    (by norm_num) (by norm_num) (by norm_num) errPt429
    vbpP429.1 vbpP429.2 vbpP430.1 vbpP430.2 vbpP435.1 vbpP435.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h1 := errBlockLin_of_piece (q0 := 1.362) (q1 := 1.364) (m := vBP 1.374)
    (Lo := (-0.11600671)) (Hi := (-0.09874996)) (Klo := (-0.000035253408)) (Khi := (-0.000033976821))
    (by norm_num) (by norm_num) (by norm_num) errPt430
    vbpP430.1 vbpP430.2 vbpP431.1 vbpP431.2 vbpP435.1 vbpP435.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h2 := errBlockLin_of_piece (q0 := 1.364) (q1 := 1.366) (m := vBP 1.374)
    (Lo := (-0.11944006)) (Hi := (-0.10240641)) (Klo := (-0.000028870009)) (Khi := (-0.000027565988))
    (by norm_num) (by norm_num) (by norm_num) errPt431
    vbpP431.1 vbpP431.2 vbpP432.1 vbpP432.2 vbpP435.1 vbpP435.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h3 := errBlockLin_of_piece (q0 := 1.366) (q1 := 1.369) (m := vBP 1.374)
    (Lo := (-0.12756152)) (Hi := (-0.10264804)) (Klo := (-0.000031104466)) (Khi := (-0.000029763357))
    (by norm_num) (by norm_num) (by norm_num) errPt432
    vbpP432.1 vbpP432.2 vbpP433.1 vbpP433.2 vbpP435.1 vbpP435.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h4 := errBlockLin_of_piece (q0 := 1.369) (q1 := 1.372) (m := vBP 1.374)
    (Lo := (-0.13205232)) (Hi := (-0.10765005)) (Klo := (-0.000016996171)) (Khi := (-0.000015606924))
    (by norm_num) (by norm_num) (by norm_num) errPt433
    vbpP433.1 vbpP433.2 vbpP434.1 vbpP434.2 vbpP435.1 vbpP435.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h5 := errBlockLin_of_piece (q0 := 1.372) (q1 := 1.374) (m := vBP 1.374)
    (Lo := (-0.13166818)) (Hi := (-0.11548222)) (Klo := (-0.000003806832)) (Khi := (-0.000002374943))
    (by norm_num) (by norm_num) (by norm_num) errPt434
    vbpP434.1 vbpP434.2 vbpP435.1 vbpP435.2 vbpP435.1 vbpP435.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h6 := errBlockLin_of_piece (q0 := 1.374) (q1 := 1.376) (m := vBP 1.374)
    (Lo := (-0.13434546)) (Hi := (-0.11835749)) (Klo := 0.000002344169) (Khi := 0.000003811794)
    (by norm_num) (by norm_num) (by norm_num) errPt435
    vbpP435.1 vbpP435.2 vbpP436.1 vbpP436.2 vbpP435.1 vbpP435.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h7 := errBlockLin_of_piece (q0 := 1.376) (q1 := 1.378) (m := vBP 1.374)
    (Lo := (-0.1368701)) (Hi := (-0.12107328)) (Klo := 0.000008448043) (Khi := 0.000009952751)
    (by norm_num) (by norm_num) (by norm_num) errPt436
    vbpP436.1 vbpP436.2 vbpP437.1 vbpP437.2 vbpP435.1 vbpP435.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h8 := errBlockLin_of_piece (q0 := 1.378) (q1 := 1.38) (m := vBP 1.374)
    (Lo := (-0.13924204)) (Hi := (-0.12362886)) (Klo := 0.000014509408) (Khi := 0.000016051093)
    (by norm_num) (by norm_num) (by norm_num) errPt437
    vbpP437.1 vbpP437.2 vbpP438.1 vbpP438.2 vbpP435.1 vbpP435.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h9 := errBlockLin_of_piece (q0 := 1.38) (q1 := 1.383) (m := vBP 1.374)
    (Lo := (-0.14559459)) (Hi := (-0.12293589)) (Klo := 0.000033426325) (Khi := 0.000035018762)
    (by norm_num) (by norm_num) (by norm_num) errPt438
    vbpP438.1 vbpP438.2 vbpP439.1 vbpP439.2 vbpP435.1 vbpP435.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h10 := errBlockLin_of_piece (q0 := 1.383) (q1 := 1.386) (m := vBP 1.374)
    (Lo := (-0.14849049)) (Hi := (-0.12625996)) (Klo := 0.000046823875) (Khi := 0.000048483644)
    (by norm_num) (by norm_num) (by norm_num) errPt439
    vbpP439.1 vbpP439.2 vbpP440.1 vbpP440.2 vbpP435.1 vbpP435.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h11 := errBlockLin_of_piece (q0 := 1.386) (q1 := 1.388) (m := vBP 1.374)
    (Lo := (-0.14720873)) (Hi := (-0.13223884)) (Klo := 0.000038301574) (Khi := 0.000040017493)
    (by norm_num) (by norm_num) (by norm_num) errPt440
    vbpP440.1 vbpP440.2 vbpP441.1 vbpP441.2 vbpP435.1 vbpP435.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h12 := errBlockLin_of_piece (q0 := 1.388) (q1 := 1.39) (m := vBP 1.374)
    (Lo := (-0.14882335)) (Hi := (-0.13398694)) (Klo := 0.000044139744) (Khi := 0.000045903585)
    (by norm_num) (by norm_num) (by norm_num) errPt441
    vbpP441.1 vbpP441.2 vbpP442.1 vbpP442.2 vbpP435.1 vbpP435.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  exact ((((((((((((h0.add h1).add h2).add h3).add h4).add h5).add h6).add h7).add h8).add h9).add h10).add h11).add h12).mono (by norm_num) (by norm_num) (by norm_num [mn4])
    (by norm_num [mx4]) (by norm_num)

theorem blkLin15 : errBlockLin (vBP 1.39) (vBP 1.42) (vBP 1.404) (-0.0047581252) (-0.0041948222) (-0.0000119566) 0.000000116 0.0047581252 := by
  have h0 := errBlockLin_of_piece (q0 := 1.39) (q1 := 1.392) (m := vBP 1.404)
    (Lo := (-0.15028917)) (Hi := (-0.13557324)) (Klo := (-0.000039762661)) (Khi := (-0.000037163108))
    (by norm_num) (by norm_num) (by norm_num) errPt442
    vbpP442.1 vbpP442.2 vbpP443.1 vbpP443.2 vbpP448.1 vbpP448.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h1 := errBlockLin_of_piece (q0 := 1.392) (q1 := 1.394) (m := vBP 1.404)
    (Lo := (-0.15160758)) (Hi := (-0.13699795)) (Klo := (-0.000033753746)) (Khi := (-0.000031103369))
    (by norm_num) (by norm_num) (by norm_num) errPt443
    vbpP443.1 vbpP443.2 vbpP444.1 vbpP444.2 vbpP448.1 vbpP448.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h2 := errBlockLin_of_piece (q0 := 1.394) (q1 := 1.397) (m := vBP 1.404)
    (Lo := (-0.15624074)) (Hi := (-0.13532693)) (Klo := (-0.000038782274)) (Khi := (-0.000036063579))
    (by norm_num) (by norm_num) (by norm_num) errPt444
    vbpP444.1 vbpP444.2 vbpP445.1 vbpP445.2 vbpP448.1 vbpP448.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h3 := errBlockLin_of_piece (q0 := 1.397) (q1 := 1.4) (m := vBP 1.404)
    (Lo := (-0.15759378)) (Hi := (-0.13695124)) (Klo := (-0.000025489022)) (Khi := (-0.000022684635))
    (by norm_num) (by norm_num) (by norm_num) errPt445
    vbpP445.1 vbpP445.2 vbpP446.1 vbpP446.2 vbpP448.1 vbpP448.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h4 := errBlockLin_of_piece (q0 := 1.4) (q1 := 1.402) (m := vBP 1.404)
    (Lo := (-0.15544295)) (Hi := (-0.14108999)) (Klo := (-0.000010157602)) (Khi := (-0.000007279678))
    (by norm_num) (by norm_num) (by norm_num) errPt446
    vbpP446.1 vbpP446.2 vbpP447.1 vbpP447.2 vbpP448.1 vbpP448.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h5 := errBlockLin_of_piece (q0 := 1.402) (q1 := 1.404) (m := vBP 1.404)
    (Lo := (-0.15605328)) (Hi := (-0.1417147)) (Klo := (-0.000004367201)) (Khi := (-0.000001426383))
    (by norm_num) (by norm_num) (by norm_num) errPt447
    vbpP447.1 vbpP447.2 vbpP448.1 vbpP448.2 vbpP448.1 vbpP448.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h6 := errBlockLin_of_piece (q0 := 1.404) (q1 := 1.406) (m := vBP 1.404)
    (Lo := (-0.15652951)) (Hi := (-0.1421819)) (Klo := 0.000001381373) (Khi := 0.000004389179)
    (by norm_num) (by norm_num) (by norm_num) errPt448
    vbpP448.1 vbpP448.2 vbpP449.1 vbpP449.2 vbpP448.1 vbpP448.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h7 := errBlockLin_of_piece (q0 := 1.406) (q1 := 1.408) (m := vBP 1.404)
    (Lo := (-0.15687475)) (Hi := (-0.1424927)) (Klo := 0.000007086936) (Khi := 0.000010162961)
    (by norm_num) (by norm_num) (by norm_num) errPt449
    vbpP449.1 vbpP449.2 vbpP450.1 vbpP450.2 vbpP448.1 vbpP448.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h8 := errBlockLin_of_piece (q0 := 1.408) (q1 := 1.411) (m := vBP 1.404)
    (Lo := (-0.15994837)) (Hi := (-0.13984804)) (Klo := 0.000022029541) (Khi := 0.000025195145)
    (by norm_num) (by norm_num) (by norm_num) errPt450
    vbpP450.1 vbpP450.2 vbpP451.1 vbpP451.2 vbpP448.1 vbpP448.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h9 := errBlockLin_of_piece (q0 := 1.411) (q1 := 1.414) (m := vBP 1.404)
    (Lo := (-0.15992701)) (Hi := (-0.13982)) (Klo := 0.000034661077) (Khi := 0.000037940308)
    (by norm_num) (by norm_num) (by norm_num) errPt451
    vbpP451.1 vbpP451.2 vbpP452.1 vbpP452.2 vbpP448.1 vbpP448.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h10 := errBlockLin_of_piece (q0 := 1.414) (q1 := 1.416) (m := vBP 1.404)
    (Lo := (-0.15762364)) (Hi := (-0.1191471)) (Klo := 0.00002949236) (Khi := 0.000032871837)
    (by norm_num) (by norm_num) (by norm_num) errPt452
    vbpP452.1 vbpP452.2 vbpP453.1 vbpP453.2 vbpP448.1 vbpP448.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h11 := errBlockLin_of_piece (q0 := 1.416) (q1 := 1.418) (m := vBP 1.404)
    (Lo := (-0.1567856)) (Hi := (-0.14172795)) (Klo := 0.000034989264) (Khi := 0.00003845289)
    (by norm_num) (by norm_num) (by norm_num) errPt453
    vbpP453.1 vbpP453.2 vbpP454.1 vbpP454.2 vbpP448.1 vbpP448.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h12 := errBlockLin_of_piece (q0 := 1.418) (q1 := 1.42) (m := vBP 1.404)
    (Lo := (-0.15644116)) (Hi := (-0.14111566)) (Klo := 0.000040447388) (Khi := 0.000043997746)
    (by norm_num) (by norm_num) (by norm_num) errPt454
    vbpP454.1 vbpP454.2 vbpP455.1 vbpP455.2 vbpP448.1 vbpP448.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  exact ((((((((((((h0.add h1).add h2).add h3).add h4).add h5).add h6).add h7).add h8).add h9).add h10).add h11).add h12).mono (by norm_num) (by norm_num) (by norm_num [mn4])
    (by norm_num [mx4]) (by norm_num)

theorem blkLin16 : errBlockLin (vBP 1.42) (vBP 1.45) (vBP 1.434) (-0.0044062979) (-0.0037630154) (-0.0000117968) 0.0000057474 0.0044062979 := by
  have h0 := errBlockLin_of_piece (q0 := 1.42) (q1 := 1.422) (m := vBP 1.434)
    (Lo := (-0.15599584)) (Hi := (-0.14035792)) (Klo := (-0.000038610529)) (Khi := (-0.000033550743))
    (by norm_num) (by norm_num) (by norm_num) errPt455
    vbpP455.1 vbpP455.2 vbpP456.1 vbpP456.2 vbpP461.1 vbpP461.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h1 := errBlockLin_of_piece (q0 := 1.422) (q1 := 1.425) (m := vBP 1.434)
    (Lo := (-0.1578555)) (Hi := (-0.13673664)) (Klo := (-0.00004611234)) (Khi := (-0.000040935035))
    (by norm_num) (by norm_num) (by norm_num) errPt456
    vbpP456.1 vbpP456.2 vbpP457.1 vbpP457.2 vbpP461.1 vbpP461.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h2 := errBlockLin_of_piece (q0 := 1.425) (q1 := 1.428) (m := vBP 1.434)
    (Lo := (-0.15680391)) (Hi := (-0.13513265)) (Klo := (-0.00003358797)) (Khi := (-0.000028264528))
    (by norm_num) (by norm_num) (by norm_num) errPt457
    vbpP457.1 vbpP457.2 vbpP458.1 vbpP458.2 vbpP461.1 vbpP461.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h3 := errBlockLin_of_piece (q0 := 1.428) (q1 := 1.43) (m := vBP 1.434)
    (Lo := (-0.15332385)) (Hi := (-0.13591306)) (Klo := (-0.000016407904)) (Khi := (-0.000010957975))
    (by norm_num) (by norm_num) (by norm_num) errPt458
    vbpP458.1 vbpP458.2 vbpP459.1 vbpP459.2 vbpP461.1 vbpP461.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h4 := errBlockLin_of_piece (q0 := 1.43) (q1 := 1.432) (m := vBP 1.434)
    (Lo := (-0.15246618)) (Hi := (-0.13445916)) (Klo := (-0.00001095949)) (Khi := (-0.000005402574))
    (by norm_num) (by norm_num) (by norm_num) errPt459
    vbpP459.1 vbpP459.2 vbpP460.1 vbpP460.2 vbpP461.1 vbpP461.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h5 := errBlockLin_of_piece (q0 := 1.432) (q1 := 1.434) (m := vBP 1.434)
    (Lo := (-0.15154733)) (Hi := (-0.13287271)) (Klo := (-0.000005550685)) (Khi := 0.000000117107)
    (by norm_num) (by norm_num) (by norm_num) errPt460
    vbpP460.1 vbpP460.2 vbpP461.1 vbpP461.2 vbpP461.1 vbpP461.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h6 := errBlockLin_of_piece (q0 := 1.434) (q1 := 1.436) (m := vBP 1.434)
    (Lo := (-0.15057546)) (Hi := (-0.13115606)) (Klo := (-0.000000182663)) (Khi := 0.000005599875)
    (by norm_num) (by norm_num) (by norm_num) errPt461
    vbpP461.1 vbpP461.2 vbpP462.1 vbpP462.2 vbpP461.1 vbpP461.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h7 := errBlockLin_of_piece (q0 := 1.436) (q1 := 1.439) (m := vBP 1.434)
    (Lo := (-0.1516834)) (Hi := (-0.12664439)) (Klo := 0.000011188554) (Khi := 0.000017122372)
    (by norm_num) (by norm_num) (by norm_num) errPt462
    vbpP462.1 vbpP462.2 vbpP463.1 vbpP463.2 vbpP461.1 vbpP461.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h8 := errBlockLin_of_piece (q0 := 1.439) (q1 := 1.442) (m := vBP 1.434)
    (Lo := (-0.15006518)) (Hi := (-0.12365332)) (Klo := 0.000023089961) (Khi := 0.000029214123)
    (by norm_num) (by norm_num) (by norm_num) errPt463
    vbpP463.1 vbpP463.2 vbpP464.1 vbpP464.2 vbpP461.1 vbpP461.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h9 := errBlockLin_of_piece (q0 := 1.442) (q1 := 1.444) (m := vBP 1.434)
    (Lo := (-0.14633879)) (Hi := (-0.12303561)) (Klo := 0.000020894331) (Khi := 0.000027183959)
    (by norm_num) (by norm_num) (by norm_num) errPt464
    vbpP464.1 vbpP464.2 vbpP465.1 vbpP465.2 vbpP461.1 vbpP461.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h10 := errBlockLin_of_piece (q0 := 1.444) (q1 := 1.446) (m := vBP 1.434)
    (Lo := (-0.14524249)) (Hi := (-0.12070415)) (Klo := 0.000026064501) (Khi := 0.000032493518)
    (by norm_num) (by norm_num) (by norm_num) errPt465
    vbpP465.1 vbpP465.2 vbpP466.1 vbpP466.2 vbpP461.1 vbpP461.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h11 := errBlockLin_of_piece (q0 := 1.446) (q1 := 1.448) (m := vBP 1.434)
    (Lo := (-0.14415354)) (Hi := (-0.11825699)) (Klo := 0.000031196573) (Khi := 0.000037768743)
    (by norm_num) (by norm_num) (by norm_num) errPt466
    vbpP466.1 vbpP466.2 vbpP467.1 vbpP467.2 vbpP461.1 vbpP461.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h12 := errBlockLin_of_piece (q0 := 1.448) (q1 := 1.45) (m := vBP 1.434)
    (Lo := (-0.14308419)) (Hi := (-0.11569651)) (Klo := 0.00003629076) (Khi := 0.000043011205)
    (by norm_num) (by norm_num) (by norm_num) errPt467
    vbpP467.1 vbpP467.2 vbpP468.1 vbpP468.2 vbpP461.1 vbpP461.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  exact ((((((((((((h0.add h1).add h2).add h3).add h4).add h5).add h6).add h7).add h8).add h9).add h10).add h11).add h12).mono (by norm_num) (by norm_num) (by norm_num [mn4])
    (by norm_num [mx4]) (by norm_num)

end ConnesConsani.WeilPositivity
