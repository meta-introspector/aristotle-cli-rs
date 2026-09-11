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
# The block data: integral, first moment and absolute integral of `err` (part 1)

Each block groups consecutive pieces of the partition; the base point `vBP qm` is a
breakpoint near the middle of the block.
-/

set_option maxHeartbeats 1000000

noncomputable section

open MeasureTheory Set Real

namespace ConnesConsani.WeilPositivity

theorem blkLin0 : errBlockLin (vBP 1) (vBP 1.0228) (vBP 1.0112) (-0.0318831461) (-0.0317063333) 0.0000453887 0.0000478975 0.0318831461 := by
  have h0 := errBlockLin_of_piece (q0 := 1) (q1 := 1.0002) (m := vBP 1.0112)
    (Lo := (-0.87266839)) (Hi := (-0.86954584)) (Klo := (-0.00000883243)) (Khi := (-0.000008826429))
    (by norm_num) (by norm_num) (by norm_num) errPt0
    vbpP0.1 vbpP0.2 vbpP1.1 vbpP1.2 vbpP45.1 vbpP45.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h1 := errBlockLin_of_piece (q0 := 1.0002) (q1 := 1.0005) (m := vBP 1.0112)
    (Lo := (-0.86971703)) (Hi := (-0.86511506)) (Klo := (-0.000012940175)) (Khi := (-0.000012932177))
    (by norm_num) (by norm_num) (by norm_num) errPt1
    vbpP1.1 vbpP1.2 vbpP2.1 vbpP2.2 vbpP45.1 vbpP45.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h2 := errBlockLin_of_piece (q0 := 1.0005) (q1 := 1.0008) (m := vBP 1.0112)
    (Lo := (-0.86529372)) (Hi := (-0.8606937)) (Klo := (-0.000012572706)) (Khi := (-0.000012564711))
    (by norm_num) (by norm_num) (by norm_num) errPt2
    vbpP2.1 vbpP2.2 vbpP3.1 vbpP3.2 vbpP45.1 vbpP45.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h3 := errBlockLin_of_piece (q0 := 1.0008) (q1 := 1.001) (m := vBP 1.0112)
    (Lo := (-0.86087378)) (Hi := (-0.85775465)) (Klo := (-0.00000817915)) (Khi := (-0.000008171156))
    (by norm_num) (by norm_num) (by norm_num) errPt3
    vbpP3.1 vbpP3.2 vbpP4.1 vbpP4.2 vbpP45.1 vbpP45.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h4 := errBlockLin_of_piece (q0 := 1.001) (q1 := 1.0012) (m := vBP 1.0112)
    (Lo := (-0.85793438)) (Hi := (-0.8548161)) (Klo := (-0.000008018073)) (Khi := (-0.000008010081))
    (by norm_num) (by norm_num) (by norm_num) errPt4
    vbpP4.1 vbpP4.2 vbpP5.1 vbpP5.2 vbpP45.1 vbpP45.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h5 := errBlockLin_of_piece (q0 := 1.0012) (q1 := 1.0015) (m := vBP 1.0112)
    (Lo := (-0.85500507)) (Hi := (-0.85040953)) (Klo := (-0.000011718559)) (Khi := (-0.000011710569))
    (by norm_num) (by norm_num) (by norm_num) errPt5
    vbpP5.1 vbpP5.2 vbpP6.1 vbpP6.2 vbpP45.1 vbpP45.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h6 := errBlockLin_of_piece (q0 := 1.0015) (q1 := 1.0018) (m := vBP 1.0112)
    (Lo := (-0.85060952)) (Hi := (-0.84601589)) (Klo := (-0.000011352189)) (Khi := (-0.000011344201))
    (by norm_num) (by norm_num) (by norm_num) errPt6
    vbpP6.1 vbpP6.2 vbpP7.1 vbpP7.2 vbpP45.1 vbpP45.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h7 := errBlockLin_of_piece (q0 := 1.0018) (q1 := 1.002) (m := vBP 1.0112)
    (Lo := (-0.8462138)) (Hi := (-0.84309886)) (Klo := (-0.000007368742)) (Khi := (-0.000007360756))
    (by norm_num) (by norm_num) (by norm_num) errPt7
    vbpP7.1 vbpP7.2 vbpP8.1 vbpP8.2 vbpP45.1 vbpP45.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h8 := errBlockLin_of_piece (q0 := 1.002) (q1 := 1.0022) (m := vBP 1.0112)
    (Lo := (-0.84329289)) (Hi := (-0.84017878)) (Klo := (-0.000007206153)) (Khi := (-0.000007198168))
    (by norm_num) (by norm_num) (by norm_num) errPt8
    vbpP8.1 vbpP8.2 vbpP9.1 vbpP9.2 vbpP45.1 vbpP45.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h9 := errBlockLin_of_piece (q0 := 1.0022) (q1 := 1.0025) (m := vBP 1.0112)
    (Lo := (-0.84038562)) (Hi := (-0.83579636)) (Klo := (-0.000010502592)) (Khi := (-0.00001049461))
    (by norm_num) (by norm_num) (by norm_num) errPt9
    vbpP9.1 vbpP9.2 vbpP10.1 vbpP10.2 vbpP45.1 vbpP45.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h10 := errBlockLin_of_piece (q0 := 1.0025) (q1 := 1.0028) (m := vBP 1.0112)
    (Lo := (-0.83601781)) (Hi := (-0.8314304)) (Klo := (-0.000010139309)) (Khi := (-0.000010131329))
    (by norm_num) (by norm_num) (by norm_num) errPt10
    vbpP10.1 vbpP10.2 vbpP11.1 vbpP11.2 vbpP45.1 vbpP45.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h11 := errBlockLin_of_piece (q0 := 1.0028) (q1 := 1.003) (m := vBP 1.0112)
    (Lo := (-0.83164623)) (Hi := (-0.82853539)) (Klo := (-0.000006558763)) (Khi := (-0.000006550785))
    (by norm_num) (by norm_num) (by norm_num) errPt11
    vbpP11.1 vbpP11.2 vbpP12.1 vbpP12.2 vbpP45.1 vbpP45.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h12 := errBlockLin_of_piece (q0 := 1.003) (q1 := 1.0032) (m := vBP 1.0112)
    (Lo := (-0.82874379)) (Hi := (-0.82563376)) (Klo := (-0.000006398652)) (Khi := (-0.000006390676))
    (by norm_num) (by norm_num) (by norm_num) errPt12
    vbpP12.1 vbpP12.2 vbpP13.1 vbpP13.2 vbpP45.1 vbpP45.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h13 := errBlockLin_of_piece (q0 := 1.0032) (q1 := 1.0035) (m := vBP 1.0112)
    (Lo := (-0.82585856)) (Hi := (-0.82127542)) (Klo := (-0.000009294243)) (Khi := (-0.000009286269))
    (by norm_num) (by norm_num) (by norm_num) errPt13
    vbpP13.1 vbpP13.2 vbpP14.1 vbpP14.2 vbpP45.1 vbpP45.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h14 := errBlockLin_of_piece (q0 := 1.0035) (q1 := 1.0038) (m := vBP 1.0112)
    (Lo := (-0.82151844)) (Hi := (-0.81693711)) (Klo := (-0.000008932044)) (Khi := (-0.000008924072))
    (by norm_num) (by norm_num) (by norm_num) errPt14
    vbpP14.1 vbpP14.2 vbpP15.1 vbpP15.2 vbpP45.1 vbpP45.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h15 := errBlockLin_of_piece (q0 := 1.0038) (q1 := 1.004) (m := vBP 1.0112)
    (Lo := (-0.81717095)) (Hi := (-0.81406411)) (Klo := (-0.000005755185)) (Khi := (-0.000005747215))
    (by norm_num) (by norm_num) (by norm_num) errPt15
    vbpP15.1 vbpP15.2 vbpP16.1 vbpP16.2 vbpP45.1 vbpP45.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h16 := errBlockLin_of_piece (q0 := 1.004) (q1 := 1.0042) (m := vBP 1.0112)
    (Lo := (-0.81428695)) (Hi := (-0.8111809)) (Klo := (-0.000005595554)) (Khi := (-0.000005587585))
    (by norm_num) (by norm_num) (by norm_num) errPt16
    vbpP16.1 vbpP16.2 vbpP17.1 vbpP17.2 vbpP45.1 vbpP45.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h17 := errBlockLin_of_piece (q0 := 1.0042) (q1 := 1.0045) (m := vBP 1.0112)
    (Lo := (-0.81142376)) (Hi := (-0.80684659)) (Klo := (-0.000008089502)) (Khi := (-0.000008081536))
    (by norm_num) (by norm_num) (by norm_num) errPt17
    vbpP17.1 vbpP17.2 vbpP18.1 vbpP18.2 vbpP45.1 vbpP45.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h18 := errBlockLin_of_piece (q0 := 1.0045) (q1 := 1.0048) (m := vBP 1.0112)
    (Lo := (-0.80711129)) (Hi := (-0.80253588)) (Klo := (-0.000007730373)) (Khi := (-0.000007722409))
    (by norm_num) (by norm_num) (by norm_num) errPt18
    vbpP18.1 vbpP18.2 vbpP19.1 vbpP19.2 vbpP45.1 vbpP45.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h19 := errBlockLin_of_piece (q0 := 1.0048) (q1 := 1.005) (m := vBP 1.0112)
    (Lo := (-0.80278782)) (Hi := (-0.79968489)) (Klo := (-0.000004955994)) (Khi := (-0.000004948032))
    (by norm_num) (by norm_num) (by norm_num) errPt19
    vbpP19.1 vbpP19.2 vbpP20.1 vbpP20.2 vbpP45.1 vbpP45.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h20 := errBlockLin_of_piece (q0 := 1.005) (q1 := 1.0052) (m := vBP 1.0112)
    (Lo := (-0.79992225)) (Hi := (-0.79682009)) (Klo := (-0.000004794851)) (Khi := (-0.00000478689))
    (by norm_num) (by norm_num) (by norm_num) errPt20
    vbpP20.1 vbpP20.2 vbpP21.1 vbpP21.2 vbpP45.1 vbpP45.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h21 := errBlockLin_of_piece (q0 := 1.0052) (q1 := 1.0055) (m := vBP 1.0112)
    (Lo := (-0.79708109)) (Hi := (-0.79250974)) (Klo := (-0.000006892331)) (Khi := (-0.000006884372))
    (by norm_num) (by norm_num) (by norm_num) errPt21
    vbpP21.1 vbpP21.2 vbpP22.1 vbpP22.2 vbpP45.1 vbpP45.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h22 := errBlockLin_of_piece (q0 := 1.0055) (q1 := 1.0058) (m := vBP 1.0112)
    (Lo := (-0.79279624)) (Hi := (-0.7882266)) (Klo := (-0.000006534273)) (Khi := (-0.000006526317))
    (by norm_num) (by norm_num) (by norm_num) errPt22
    vbpP22.1 vbpP22.2 vbpP23.1 vbpP23.2 vbpP45.1 vbpP45.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h23 := errBlockLin_of_piece (q0 := 1.0058) (q1 := 1.006) (m := vBP 1.0112)
    (Lo := (-0.78849674)) (Hi := (-0.78539763)) (Klo := (-0.000004159187)) (Khi := (-0.000004151233))
    (by norm_num) (by norm_num) (by norm_num) errPt23
    vbpP23.1 vbpP23.2 vbpP24.1 vbpP24.2 vbpP45.1 vbpP45.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h24 := errBlockLin_of_piece (q0 := 1.006) (q1 := 1.0062) (m := vBP 1.0112)
    (Lo := (-0.78564956)) (Hi := (-0.78255119)) (Klo := (-0.000004000508)) (Khi := (-0.000003992555))
    (by norm_num) (by norm_num) (by norm_num) errPt24
    vbpP24.1 vbpP24.2 vbpP25.1 vbpP25.2 vbpP45.1 vbpP45.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h25 := errBlockLin_of_piece (q0 := 1.0062) (q1 := 1.0065) (m := vBP 1.0112)
    (Lo := (-0.78283044)) (Hi := (-0.77826475)) (Klo := (-0.000005700713)) (Khi := (-0.000005692762))
    (by norm_num) (by norm_num) (by norm_num) errPt25
    vbpP25.1 vbpP25.2 vbpP26.1 vbpP26.2 vbpP45.1 vbpP45.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h26 := errBlockLin_of_piece (q0 := 1.0065) (q1 := 1.0068) (m := vBP 1.0112)
    (Lo := (-0.77857317)) (Hi := (-0.77400915)) (Klo := (-0.000005343721)) (Khi := (-0.000005335773))
    (by norm_num) (by norm_num) (by norm_num) errPt26
    vbpP26.1 vbpP26.2 vbpP27.1 vbpP27.2 vbpP45.1 vbpP45.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h27 := errBlockLin_of_piece (q0 := 1.0068) (q1 := 1.007) (m := vBP 1.0112)
    (Lo := (-0.77429758)) (Hi := (-0.77120219)) (Klo := (-0.000003366737)) (Khi := (-0.000003358791))
    (by norm_num) (by norm_num) (by norm_num) errPt27
    vbpP27.1 vbpP27.2 vbpP28.1 vbpP28.2 vbpP45.1 vbpP45.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h28 := errBlockLin_of_piece (q0 := 1.007) (q1 := 1.0072) (m := vBP 1.0112)
    (Lo := (-0.77146877)) (Hi := (-0.76837411)) (Klo := (-0.00000320853)) (Khi := (-0.000003200586))
    (by norm_num) (by norm_num) (by norm_num) errPt28
    vbpP28.1 vbpP28.2 vbpP29.1 vbpP29.2 vbpP45.1 vbpP45.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h29 := errBlockLin_of_piece (q0 := 1.0072) (q1 := 1.0075) (m := vBP 1.0112)
    (Lo := (-0.76867169)) (Hi := (-0.76411151)) (Klo := (-0.000004514627)) (Khi := (-0.000004506684))
    (by norm_num) (by norm_num) (by norm_num) errPt29
    vbpP29.1 vbpP29.2 vbpP30.1 vbpP30.2 vbpP45.1 vbpP45.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h30 := errBlockLin_of_piece (q0 := 1.0075) (q1 := 1.0078) (m := vBP 1.0112)
    (Lo := (-0.76444197)) (Hi := (-0.75988341)) (Klo := (-0.00000416068)) (Khi := (-0.000004152739))
    (by norm_num) (by norm_num) (by norm_num) errPt30
    vbpP30.1 vbpP30.2 vbpP31.1 vbpP31.2 vbpP45.1 vbpP45.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h31 := errBlockLin_of_piece (q0 := 1.0078) (q1 := 1.008) (m := vBP 1.0112)
    (Lo := (-0.76019022)) (Hi := (-0.75709846)) (Klo := (-0.000002578628)) (Khi := (-0.00000257069))
    (by norm_num) (by norm_num) (by norm_num) errPt31
    vbpP31.1 vbpP31.2 vbpP32.1 vbpP32.2 vbpP45.1 vbpP45.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h32 := errBlockLin_of_piece (q0 := 1.008) (q1 := 1.0082) (m := vBP 1.0112)
    (Lo := (-0.75737975)) (Hi := (-0.75428871)) (Klo := (-0.000002420891)) (Khi := (-0.000002412955))
    (by norm_num) (by norm_num) (by norm_num) errPt32
    vbpP32.1 vbpP32.2 vbpP33.1 vbpP33.2 vbpP45.1 vbpP45.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h33 := errBlockLin_of_piece (q0 := 1.0082) (q1 := 1.0085) (m := vBP 1.0112)
    (Lo := (-0.75460472)) (Hi := (-0.7500499)) (Klo := (-0.000003334049)) (Khi := (-0.000003326114))
    (by norm_num) (by norm_num) (by norm_num) errPt33
    vbpP33.1 vbpP33.2 vbpP34.1 vbpP34.2 vbpP45.1 vbpP45.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h34 := errBlockLin_of_piece (q0 := 1.0085) (q1 := 1.0088) (m := vBP 1.0112)
    (Lo := (-0.75040251)) (Hi := (-0.74584927)) (Klo := (-0.000002983138)) (Khi := (-0.000002975205))
    (by norm_num) (by norm_num) (by norm_num) errPt34
    vbpP34.1 vbpP34.2 vbpP35.1 vbpP35.2 vbpP45.1 vbpP45.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h35 := errBlockLin_of_piece (q0 := 1.0088) (q1 := 1.009) (m := vBP 1.0112)
    (Lo := (-0.74617455)) (Hi := (-0.74308634)) (Klo := (-0.000001792862)) (Khi := (-0.000001784931))
    (by norm_num) (by norm_num) (by norm_num) errPt35
    vbpP35.1 vbpP35.2 vbpP36.1 vbpP36.2 vbpP45.1 vbpP45.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h36 := errBlockLin_of_piece (q0 := 1.009) (q1 := 1.0092) (m := vBP 1.0112)
    (Lo := (-0.74338241)) (Hi := (-0.74029489)) (Klo := (-0.000001637574)) (Khi := (-0.000001629645))
    (by norm_num) (by norm_num) (by norm_num) errPt36
    vbpP36.1 vbpP36.2 vbpP37.1 vbpP37.2 vbpP45.1 vbpP45.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h37 := errBlockLin_of_piece (q0 := 1.0092) (q1 := 1.0095) (m := vBP 1.0112)
    (Lo := (-0.74062941)) (Hi := (-0.73607982)) (Klo := (-0.00000216094)) (Khi := (-0.000002153013))
    (by norm_num) (by norm_num) (by norm_num) errPt37
    vbpP37.1 vbpP37.2 vbpP38.1 vbpP38.2 vbpP45.1 vbpP45.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h38 := errBlockLin_of_piece (q0 := 1.0095) (q1 := 1.0098) (m := vBP 1.0112)
    (Lo := (-0.73645468)) (Hi := (-0.73190662)) (Klo := (-0.000001809093)) (Khi := (-0.000001801168))
    (by norm_num) (by norm_num) (by norm_num) errPt38
    vbpP38.1 vbpP38.2 vbpP39.1 vbpP39.2 vbpP45.1 vbpP45.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h39 := errBlockLin_of_piece (q0 := 1.0098) (q1 := 1.01) (m := vBP 1.0112)
    (Lo := (-0.73225046)) (Hi := (-0.7291657)) (Klo := (-0.000001013387)) (Khi := (-0.000001005464))
    (by norm_num) (by norm_num) (by norm_num) errPt39
    vbpP39.1 vbpP39.2 vbpP40.1 vbpP40.2 vbpP45.1 vbpP45.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h40 := errBlockLin_of_piece (q0 := 1.01) (q1 := 1.0102) (m := vBP 1.0112)
    (Lo := (-0.72947662)) (Hi := (-0.72639255)) (Klo := (-0.000000858561)) (Khi := (-0.00000085064))
    (by norm_num) (by norm_num) (by norm_num) errPt40
    vbpP40.1 vbpP40.2 vbpP41.1 vbpP41.2 vbpP45.1 vbpP45.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h41 := errBlockLin_of_piece (q0 := 1.0102) (q1 := 1.0105) (m := vBP 1.0112)
    (Lo := (-0.72674567)) (Hi := (-0.72220115)) (Klo := (-0.000000991312)) (Khi := (-0.000000983393))
    (by norm_num) (by norm_num) (by norm_num) errPt41
    vbpP41.1 vbpP41.2 vbpP42.1 vbpP42.2 vbpP45.1 vbpP45.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h42 := errBlockLin_of_piece (q0 := 1.0105) (q1 := 1.0108) (m := vBP 1.0112)
    (Lo := (-0.72259838)) (Hi := (-0.71805536)) (Klo := (-0.000000644465)) (Khi := (-0.000000636548))
    (by norm_num) (by norm_num) (by norm_num) errPt42
    vbpP42.1 vbpP42.2 vbpP43.1 vbpP43.2 vbpP45.1 vbpP45.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h43 := errBlockLin_of_piece (q0 := 1.0108) (q1 := 1.011) (m := vBP 1.0112)
    (Lo := (-0.71841784)) (Hi := (-0.71533645)) (Klo := (-0.000000236224)) (Khi := (-0.000000228309))
    (by norm_num) (by norm_num) (by norm_num) errPt43
    vbpP43.1 vbpP43.2 vbpP44.1 vbpP44.2 vbpP45.1 vbpP45.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h44 := errBlockLin_of_piece (q0 := 1.011) (q1 := 1.0112) (m := vBP 1.0112)
    (Lo := (-0.71566228)) (Hi := (-0.71258156)) (Klo := (-0.000000079881)) (Khi := (-0.000000071968))
    (by norm_num) (by norm_num) (by norm_num) errPt44
    vbpP44.1 vbpP44.2 vbpP45.1 vbpP45.2 vbpP45.1 vbpP45.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h45 := errBlockLin_of_piece (q0 := 1.0112) (q1 := 1.0115) (m := vBP 1.0112)
    (Lo := (-0.71295337)) (Hi := (-0.70841378)) (Klo := 0.000000168917) (Khi := 0.000000176828)
    (by norm_num) (by norm_num) (by norm_num) errPt45
    vbpP45.1 vbpP45.2 vbpP46.1 vbpP46.2 vbpP45.1 vbpP45.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h46 := errBlockLin_of_piece (q0 := 1.0115) (q1 := 1.0118) (m := vBP 1.0112)
    (Lo := (-0.7088335)) (Hi := (-0.70429536)) (Klo := 0.000000518687) (Khi := 0.000000526596)
    (by norm_num) (by norm_num) (by norm_num) errPt46
    vbpP46.1 vbpP46.2 vbpP47.1 vbpP47.2 vbpP45.1 vbpP45.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h47 := errBlockLin_of_piece (q0 := 1.0118) (q1 := 1.012) (m := vBP 1.0112)
    (Lo := (-0.70467658)) (Hi := (-0.70159848)) (Klo := 0.000000536661) (Khi := 0.000000544567)
    (by norm_num) (by norm_num) (by norm_num) errPt47
    vbpP47.1 vbpP47.2 vbpP48.1 vbpP48.2 vbpP45.1 vbpP45.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h48 := errBlockLin_of_piece (q0 := 1.012) (q1 := 1.0122) (m := vBP 1.0112)
    (Lo := (-0.70193928)) (Hi := (-0.69886183)) (Klo := 0.000000690567) (Khi := 0.000000698473)
    (by norm_num) (by norm_num) (by norm_num) errPt48
    vbpP48.1 vbpP48.2 vbpP49.1 vbpP49.2 vbpP45.1 vbpP45.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h49 := errBlockLin_of_piece (q0 := 1.0122) (q1 := 1.0125) (m := vBP 1.0112)
    (Lo := (-0.69925242)) (Hi := (-0.69471762)) (Klo := 0.000001327684) (Khi := 0.000001335588)
    (by norm_num) (by norm_num) (by norm_num) errPt49
    vbpP49.1 vbpP49.2 vbpP50.1 vbpP50.2 vbpP45.1 vbpP45.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h50 := errBlockLin_of_piece (q0 := 1.0125) (q1 := 1.0128) (m := vBP 1.0112)
    (Lo := (-0.69515993)) (Hi := (-0.69062655)) (Klo := 0.000001672473) (Khi := 0.000001680374)
    (by norm_num) (by norm_num) (by norm_num) errPt50
    vbpP50.1 vbpP50.2 vbpP51.1 vbpP51.2 vbpP45.1 vbpP45.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h51 := errBlockLin_of_piece (q0 := 1.0128) (q1 := 1.013) (m := vBP 1.0112)
    (Lo := (-0.69102659)) (Hi := (-0.68795169)) (Klo := 0.000001305283) (Khi := 0.000001313182)
    (by norm_num) (by norm_num) (by norm_num) errPt51
    vbpP51.1 vbpP51.2 vbpP52.1 vbpP52.2 vbpP45.1 vbpP45.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h52 := errBlockLin_of_piece (q0 := 1.013) (q1 := 1.0132) (m := vBP 1.0112)
    (Lo := (-0.68830753)) (Hi := (-0.68523326)) (Klo := 0.000001458735) (Khi := 0.000001466632)
    (by norm_num) (by norm_num) (by norm_num) errPt52
    vbpP52.1 vbpP52.2 vbpP53.1 vbpP53.2 vbpP45.1 vbpP45.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h53 := errBlockLin_of_piece (q0 := 1.0132) (q1 := 1.0135) (m := vBP 1.0112)
    (Lo := (-0.68564272)) (Hi := (-0.68111257)) (Klo := 0.000002479079) (Khi := 0.000002486975)
    (by norm_num) (by norm_num) (by norm_num) errPt53
    vbpP53.1 vbpP53.2 vbpP54.1 vbpP54.2 vbpP45.1 vbpP45.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h54 := errBlockLin_of_piece (q0 := 1.0135) (q1 := 1.0138) (m := vBP 1.0112)
    (Lo := (-0.68157758)) (Hi := (-0.6770488)) (Klo := 0.000002820874) (Khi := 0.000002828767)
    (by norm_num) (by norm_num) (by norm_num) errPt54
    vbpP54.1 vbpP54.2 vbpP55.1 vbpP55.2 vbpP45.1 vbpP45.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h55 := errBlockLin_of_piece (q0 := 1.0138) (q1 := 1.014) (m := vBP 1.0112)
    (Lo := (-0.67746776)) (Hi := (-0.67439597)) (Klo := 0.000002071633) (Khi := 0.000002079524)
    (by norm_num) (by norm_num) (by norm_num) errPt55
    vbpP55.1 vbpP55.2 vbpP56.1 vbpP56.2 vbpP45.1 vbpP45.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h56 := errBlockLin_of_piece (q0 := 1.014) (q1 := 1.0142) (m := vBP 1.0112)
    (Lo := (-0.67476692)) (Hi := (-0.67169575)) (Klo := 0.000002224631) (Khi := 0.000002232521)
    (by norm_num) (by norm_num) (by norm_num) errPt56
    vbpP56.1 vbpP56.2 vbpP57.1 vbpP57.2 vbpP45.1 vbpP45.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h57 := errBlockLin_of_piece (q0 := 1.0142) (q1 := 1.0145) (m := vBP 1.0112)
    (Lo := (-0.67212416)) (Hi := (-0.66759852)) (Klo := 0.000003623128) (Khi := 0.000003631015)
    (by norm_num) (by norm_num) (by norm_num) errPt57
    vbpP57.1 vbpP57.2 vbpP58.1 vbpP58.2 vbpP45.1 vbpP45.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h58 := errBlockLin_of_piece (q0 := 1.0145) (q1 := 1.0148) (m := vBP 1.0112)
    (Lo := (-0.66808635)) (Hi := (-0.66356204)) (Klo := 0.00000396588) (Khi := 0.000003973765)
    (by norm_num) (by norm_num) (by norm_num) errPt58
    vbpP58.1 vbpP58.2 vbpP59.1 vbpP59.2 vbpP45.1 vbpP45.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h59 := errBlockLin_of_piece (q0 := 1.0148) (q1 := 1.015) (m := vBP 1.0112)
    (Lo := (-0.66399999)) (Hi := (-0.66093124)) (Klo := 0.000002833749) (Khi := 0.000002841633)
    (by norm_num) (by norm_num) (by norm_num) errPt59
    vbpP59.1 vbpP59.2 vbpP60.1 vbpP60.2 vbpP45.1 vbpP45.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h60 := errBlockLin_of_piece (q0 := 1.015) (q1 := 1.0152) (m := vBP 1.0112)
    (Lo := (-0.66131735)) (Hi := (-0.6582492)) (Klo := 0.000002984326) (Khi := 0.000002992208)
    (by norm_num) (by norm_num) (by norm_num) errPt60
    vbpP60.1 vbpP60.2 vbpP61.1 vbpP61.2 vbpP45.1 vbpP45.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h61 := errBlockLin_of_piece (q0 := 1.0152) (q1 := 1.0155) (m := vBP 1.0112)
    (Lo := (-0.65869665)) (Hi := (-0.65417538)) (Klo := 0.000004761828) (Khi := 0.000004769708)
    (by norm_num) (by norm_num) (by norm_num) errPt61
    vbpP61.1 vbpP61.2 vbpP62.1 vbpP62.2 vbpP45.1 vbpP45.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h62 := errBlockLin_of_piece (q0 := 1.0155) (q1 := 1.0158) (m := vBP 1.0112)
    (Lo := (-0.65468613)) (Hi := (-0.65016615)) (Klo := 0.000005105539) (Khi := 0.000005113417)
    (by norm_num) (by norm_num) (by norm_num) errPt62
    vbpP62.1 vbpP62.2 vbpP63.1 vbpP63.2 vbpP45.1 vbpP45.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h63 := errBlockLin_of_piece (q0 := 1.0158) (q1 := 1.016) (m := vBP 1.0112)
    (Lo := (-0.65062319)) (Hi := (-0.64755739)) (Klo := 0.000003589681) (Khi := 0.000003597556)
    (by norm_num) (by norm_num) (by norm_num) errPt63
    vbpP63.1 vbpP63.2 vbpP64.1 vbpP64.2 vbpP45.1 vbpP45.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h64 := errBlockLin_of_piece (q0 := 1.016) (q1 := 1.0162) (m := vBP 1.0112)
    (Lo := (-0.64795873)) (Hi := (-0.64489352)) (Klo := 0.00000374178) (Khi := 0.000003749654)
    (by norm_num) (by norm_num) (by norm_num) errPt64
    vbpP64.1 vbpP64.2 vbpP65.1 vbpP65.2 vbpP45.1 vbpP45.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h65 := errBlockLin_of_piece (q0 := 1.0162) (q1 := 1.0165) (m := vBP 1.0112)
    (Lo := (-0.64536009)) (Hi := (-0.64084306)) (Klo := 0.000005897168) (Khi := 0.000005905041)
    (by norm_num) (by norm_num) (by norm_num) errPt65
    vbpP65.1 vbpP65.2 vbpP66.1 vbpP66.2 vbpP45.1 vbpP45.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h66 := errBlockLin_of_piece (q0 := 1.0165) (q1 := 1.0168) (m := vBP 1.0112)
    (Lo := (-0.64137684)) (Hi := (-0.63686106)) (Klo := 0.000006237905) (Khi := 0.000006245774)
    (by norm_num) (by norm_num) (by norm_num) errPt66
    vbpP66.1 vbpP66.2 vbpP67.1 vbpP67.2 vbpP45.1 vbpP45.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h67 := errBlockLin_of_piece (q0 := 1.0168) (q1 := 1.017) (m := vBP 1.0112)
    (Lo := (-0.63733726)) (Hi := (-0.63427433)) (Klo := 0.000004343382) (Khi := 0.00000435125)
    (by norm_num) (by norm_num) (by norm_num) errPt67
    vbpP67.1 vbpP67.2 vbpP68.1 vbpP68.2 vbpP45.1 vbpP45.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h68 := errBlockLin_of_piece (q0 := 1.017) (q1 := 1.0172) (m := vBP 1.0112)
    (Lo := (-0.63469097)) (Hi := (-0.63162861)) (Klo := 0.000004495035) (Khi := 0.000004502901)
    (by norm_num) (by norm_num) (by norm_num) errPt68
    vbpP68.1 vbpP68.2 vbpP69.1 vbpP69.2 vbpP45.1 vbpP45.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h69 := errBlockLin_of_piece (q0 := 1.0172) (q1 := 1.0175) (m := vBP 1.0112)
    (Lo := (-0.63211439)) (Hi := (-0.62760146)) (Klo := 0.000007027199) (Khi := 0.000007035063)
    (by norm_num) (by norm_num) (by norm_num) errPt69
    vbpP69.1 vbpP69.2 vbpP70.1 vbpP70.2 vbpP45.1 vbpP45.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h70 := errBlockLin_of_piece (q0 := 1.0175) (q1 := 1.0178) (m := vBP 1.0112)
    (Lo := (-0.62815838)) (Hi := (-0.62364666)) (Klo := 0.000007363004) (Khi := 0.000007370866)
    (by norm_num) (by norm_num) (by norm_num) errPt70
    vbpP70.1 vbpP70.2 vbpP71.1 vbpP71.2 vbpP45.1 vbpP45.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h71 := errBlockLin_of_piece (q0 := 1.0178) (q1 := 1.018) (m := vBP 1.0112)
    (Lo := (-0.62414212)) (Hi := (-0.62108198)) (Klo := 0.000005094863) (Khi := 0.000005102723)
    (by norm_num) (by norm_num) (by norm_num) errPt71
    vbpP71.1 vbpP71.2 vbpP72.1 vbpP72.2 vbpP45.1 vbpP45.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h72 := errBlockLin_of_piece (q0 := 1.018) (q1 := 1.0182) (m := vBP 1.0112)
    (Lo := (-0.62151397)) (Hi := (-0.61845438)) (Klo := 0.000005246072) (Khi := 0.000005253931)
    (by norm_num) (by norm_num) (by norm_num) errPt72
    vbpP72.1 vbpP72.2 vbpP73.1 vbpP73.2 vbpP45.1 vbpP45.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h73 := errBlockLin_of_piece (q0 := 1.0182) (q1 := 1.0185) (m := vBP 1.0112)
    (Lo := (-0.61895945)) (Hi := (-0.61445051)) (Klo := 0.000008148013) (Khi := 0.000008155869)
    (by norm_num) (by norm_num) (by norm_num) errPt73
    vbpP73.1 vbpP73.2 vbpP74.1 vbpP74.2 vbpP45.1 vbpP45.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h74 := errBlockLin_of_piece (q0 := 1.0185) (q1 := 1.0188) (m := vBP 1.0112)
    (Lo := (-0.61503066)) (Hi := (-0.61052288)) (Klo := 0.000008484791) (Khi := 0.000008492646)
    (by norm_num) (by norm_num) (by norm_num) errPt74
    vbpP74.1 vbpP74.2 vbpP75.1 vbpP75.2 vbpP45.1 vbpP45.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h75 := errBlockLin_of_piece (q0 := 1.0188) (q1 := 1.019) (m := vBP 1.0112)
    (Lo := (-0.61103767)) (Hi := (-0.60798024)) (Klo := 0.000005842171) (Khi := 0.000005850024)
    (by norm_num) (by norm_num) (by norm_num) errPt75
    vbpP75.1 vbpP75.2 vbpP76.1 vbpP76.2 vbpP45.1 vbpP45.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h76 := errBlockLin_of_piece (q0 := 1.019) (q1 := 1.0192) (m := vBP 1.0112)
    (Lo := (-0.60842765)) (Hi := (-0.60537076)) (Klo := 0.000005990976) (Khi := 0.000005998827)
    (by norm_num) (by norm_num) (by norm_num) errPt76
    vbpP76.1 vbpP76.2 vbpP77.1 vbpP77.2 vbpP45.1 vbpP45.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h77 := errBlockLin_of_piece (q0 := 1.0192) (q1 := 1.0195) (m := vBP 1.0112)
    (Lo := (-0.6058952)) (Hi := (-0.6013901)) (Klo := 0.000009265529) (Khi := 0.000009273378)
    (by norm_num) (by norm_num) (by norm_num) errPt77
    vbpP77.1 vbpP77.2 vbpP78.1 vbpP78.2 vbpP45.1 vbpP45.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h78 := errBlockLin_of_piece (q0 := 1.0195) (q1 := 1.0198) (m := vBP 1.0112)
    (Lo := (-0.6019936)) (Hi := (-0.59748962)) (Klo := 0.000009601319) (Khi := 0.000009609166)
    (by norm_num) (by norm_num) (by norm_num) errPt78
    vbpP78.1 vbpP78.2 vbpP79.1 vbpP79.2 vbpP45.1 vbpP45.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h79 := errBlockLin_of_piece (q0 := 1.0198) (q1 := 1.02) (m := vBP 1.0112)
    (Lo := (-0.59802382)) (Hi := (-0.59496903)) (Klo := 0.000006585323) (Khi := 0.000006593168)
    (by norm_num) (by norm_num) (by norm_num) errPt79
    vbpP79.1 vbpP79.2 vbpP80.1 vbpP80.2 vbpP45.1 vbpP45.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h80 := errBlockLin_of_piece (q0 := 1.02) (q1 := 1.0202) (m := vBP 1.0112)
    (Lo := (-0.59543192)) (Hi := (-0.59237764)) (Klo := 0.00000673173) (Khi := 0.000006739574)
    (by norm_num) (by norm_num) (by norm_num) errPt80
    vbpP80.1 vbpP80.2 vbpP81.1 vbpP81.2 vbpP45.1 vbpP45.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h81 := errBlockLin_of_piece (q0 := 1.0202) (q1 := 1.0205) (m := vBP 1.0112)
    (Lo := (-0.59292155)) (Hi := (-0.58842015)) (Klo := 0.000010379761) (Khi := 0.000010387603)
    (by norm_num) (by norm_num) (by norm_num) errPt81
    vbpP81.1 vbpP81.2 vbpP82.1 vbpP82.2 vbpP45.1 vbpP45.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h82 := errBlockLin_of_piece (q0 := 1.0205) (q1 := 1.0208) (m := vBP 1.0112)
    (Lo := (-0.5890471)) (Hi := (-0.5845468)) (Klo := 0.00001071065) (Khi := 0.000010718489)
    (by norm_num) (by norm_num) (by norm_num) errPt82
    vbpP82.1 vbpP82.2 vbpP83.1 vbpP83.2 vbpP45.1 vbpP45.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h83 := errBlockLin_of_piece (q0 := 1.0208) (q1 := 1.021) (m := vBP 1.0112)
    (Lo := (-0.5851005)) (Hi := (-0.58204826)) (Klo := 0.000007324333) (Khi := 0.000007332171)
    (by norm_num) (by norm_num) (by norm_num) errPt83
    vbpP83.1 vbpP83.2 vbpP84.1 vbpP84.2 vbpP45.1 vbpP45.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h84 := errBlockLin_of_piece (q0 := 1.021) (q1 := 1.0212) (m := vBP 1.0112)
    (Lo := (-0.58252669)) (Hi := (-0.57947495)) (Klo := 0.000007472267) (Khi := 0.000007480102)
    (by norm_num) (by norm_num) (by norm_num) errPt84
    vbpP84.1 vbpP84.2 vbpP85.1 vbpP85.2 vbpP45.1 vbpP45.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h85 := errBlockLin_of_piece (q0 := 1.0212) (q1 := 1.0215) (m := vBP 1.0112)
    (Lo := (-0.5800384)) (Hi := (-0.57554059)) (Klo := 0.000011484851) (Khi := 0.000011492685)
    (by norm_num) (by norm_num) (by norm_num) errPt85
    vbpP85.1 vbpP85.2 vbpP86.1 vbpP86.2 vbpP45.1 vbpP45.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h86 := errBlockLin_of_piece (q0 := 1.0215) (q1 := 1.0218) (m := vBP 1.0112)
    (Lo := (-0.57619109)) (Hi := (-0.57169433)) (Klo := 0.000011816724) (Khi := 0.000011824556)
    (by norm_num) (by norm_num) (by norm_num) errPt86
    vbpP86.1 vbpP86.2 vbpP87.1 vbpP87.2 vbpP45.1 vbpP45.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h87 := errBlockLin_of_piece (q0 := 1.0218) (q1 := 1.022) (m := vBP 1.0112)
    (Lo := (-0.57226762)) (Hi := (-0.56921786)) (Klo := 0.000008059219) (Khi := 0.000008067048)
    (by norm_num) (by norm_num) (by norm_num) errPt87
    vbpP87.1 vbpP87.2 vbpP88.1 vbpP88.2 vbpP45.1 vbpP45.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h88 := errBlockLin_of_piece (q0 := 1.022) (q1 := 1.0222) (m := vBP 1.0112)
    (Lo := (-0.56971189)) (Hi := (-0.56666261)) (Klo := 0.00000820672) (Khi := 0.000008214548)
    (by norm_num) (by norm_num) (by norm_num) errPt88
    vbpP88.1 vbpP88.2 vbpP89.1 vbpP89.2 vbpP45.1 vbpP45.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h89 := errBlockLin_of_piece (q0 := 1.0222) (q1 := 1.0225) (m := vBP 1.0112)
    (Lo := (-0.56724568)) (Hi := (-0.56275132)) (Klo := 0.0000125867) (Khi := 0.000012594526)
    (by norm_num) (by norm_num) (by norm_num) errPt89
    vbpP89.1 vbpP89.2 vbpP90.1 vbpP90.2 vbpP45.1 vbpP45.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h90 := errBlockLin_of_piece (q0 := 1.0225) (q1 := 1.0228) (m := vBP 1.0112)
    (Lo := (-0.56342548)) (Hi := (-0.55893214)) (Klo := 0.000012915647) (Khi := 0.000012923471)
    (by norm_num) (by norm_num) (by norm_num) errPt90
    vbpP90.1 vbpP90.2 vbpP91.1 vbpP91.2 vbpP45.1 vbpP45.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  exact ((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((h0.add h1).add h2).add h3).add h4).add h5).add h6).add h7).add h8).add h9).add h10).add h11).add h12).add h13).add h14).add h15).add h16).add h17).add h18).add h19).add h20).add h21).add h22).add h23).add h24).add h25).add h26).add h27).add h28).add h29).add h30).add h31).add h32).add h33).add h34).add h35).add h36).add h37).add h38).add h39).add h40).add h41).add h42).add h43).add h44).add h45).add h46).add h47).add h48).add h49).add h50).add h51).add h52).add h53).add h54).add h55).add h56).add h57).add h58).add h59).add h60).add h61).add h62).add h63).add h64).add h65).add h66).add h67).add h68).add h69).add h70).add h71).add h72).add h73).add h74).add h75).add h76).add h77).add h78).add h79).add h80).add h81).add h82).add h83).add h84).add h85).add h86).add h87).add h88).add h89).add h90).mono (by norm_num) (by norm_num) (by norm_num [mn4])
    (by norm_num [mx4]) (by norm_num)

theorem blkLin1 : errBlockLin (vBP 1.0228) (vBP 1.046) (vBP 1.0345) (-0.0184141102) (-0.0181006865) 0.0000494123 0.0000530336 0.0184141102 := by
  have h0 := errBlockLin_of_piece (q0 := 1.0228) (q1 := 1.023) (m := vBP 1.0345)
    (Lo := (-0.55952509)) (Hi := (-0.55647774)) (Klo := (-0.000008625573)) (Khi := (-0.000008617751))
    (by norm_num) (by norm_num) (by norm_num) errPt91
    vbpP91.1 vbpP91.2 vbpP92.1 vbpP92.2 vbpP116.1 vbpP116.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h1 := errBlockLin_of_piece (q0 := 1.023) (q1 := 1.0232) (m := vBP 1.0345)
    (Lo := (-0.55698742)) (Hi := (-0.55394054)) (Klo := (-0.000008473648)) (Khi := (-0.000008465828))
    (by norm_num) (by norm_num) (by norm_num) errPt92
    vbpP92.1 vbpP92.2 vbpP93.1 vbpP93.2 vbpP116.1 vbpP116.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h2 := errBlockLin_of_piece (q0 := 1.0232) (q1 := 1.0235) (m := vBP 1.0345)
    (Lo := (-0.55454331)) (Hi := (-0.55005228)) (Klo := (-0.000012421899)) (Khi := (-0.000012414081))
    (by norm_num) (by norm_num) (by norm_num) errPt93
    vbpP93.1 vbpP93.2 vbpP94.1 vbpP94.2 vbpP116.1 vbpP116.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h3 := errBlockLin_of_piece (q0 := 1.0235) (q1 := 1.024) (m := vBP 1.0345)
    (Lo := (-0.55093368)) (Hi := (-0.54355524)) (Klo := (-0.000019937644)) (Khi := (-0.000019929828))
    (by norm_num) (by norm_num) (by norm_num) errPt94
    vbpP94.1 vbpP94.2 vbpP95.1 vbpP95.2 vbpP116.1 vbpP116.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h4 := errBlockLin_of_piece (q0 := 1.024) (q1 := 1.0245) (m := vBP 1.0345)
    (Lo := (-0.54463393)) (Hi := (-0.537258)) (Klo := (-0.000018986999)) (Khi := (-0.000018979187))
    (by norm_num) (by norm_num) (by norm_num) errPt95
    vbpP95.1 vbpP95.2 vbpP96.1 vbpP96.2 vbpP116.1 vbpP116.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h5 := errBlockLin_of_piece (q0 := 1.0245) (q1 := 1.025) (m := vBP 1.0345)
    (Lo := (-0.53835676)) (Hi := (-0.53098327)) (Klo := (-0.000018039696)) (Khi := (-0.000018031888))
    (by norm_num) (by norm_num) (by norm_num) errPt96
    vbpP96.1 vbpP96.2 vbpP97.1 vbpP97.2 vbpP116.1 vbpP116.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h6 := errBlockLin_of_piece (q0 := 1.025) (q1 := 1.0255) (m := vBP 1.0345)
    (Lo := (-0.53210213)) (Hi := (-0.52473103)) (Klo := (-0.000017093779)) (Khi := (-0.000017085975))
    (by norm_num) (by norm_num) (by norm_num) errPt97
    vbpP97.1 vbpP97.2 vbpP98.1 vbpP98.2 vbpP116.1 vbpP116.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h7 := errBlockLin_of_piece (q0 := 1.0255) (q1 := 1.026) (m := vBP 1.0345)
    (Lo := (-0.52587005)) (Hi := (-0.51850128)) (Klo := (-0.000016149245)) (Khi := (-0.000016141445))
    (by norm_num) (by norm_num) (by norm_num) errPt98
    vbpP98.1 vbpP98.2 vbpP99.1 vbpP99.2 vbpP116.1 vbpP116.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h8 := errBlockLin_of_piece (q0 := 1.026) (q1 := 1.0265) (m := vBP 1.0345)
    (Lo := (-0.5196605)) (Hi := (-0.51229402)) (Klo := (-0.00001520804)) (Khi := (-0.000015200244))
    (by norm_num) (by norm_num) (by norm_num) errPt99
    vbpP99.1 vbpP99.2 vbpP100.1 vbpP100.2 vbpP116.1 vbpP116.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h9 := errBlockLin_of_piece (q0 := 1.0265) (q1 := 1.027) (m := vBP 1.0345)
    (Lo := (-0.51347347)) (Hi := (-0.50610922)) (Klo := (-0.000014270157)) (Khi := (-0.000014262364))
    (by norm_num) (by norm_num) (by norm_num) errPt100
    vbpP100.1 vbpP100.2 vbpP101.1 vbpP101.2 vbpP116.1 vbpP116.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h10 := errBlockLin_of_piece (q0 := 1.027) (q1 := 1.0275) (m := vBP 1.0345)
    (Lo := (-0.50730896)) (Hi := (-0.49994688)) (Klo := (-0.000013333643)) (Khi := (-0.000013325854))
    (by norm_num) (by norm_num) (by norm_num) errPt101
    vbpP101.1 vbpP101.2 vbpP102.1 vbpP102.2 vbpP116.1 vbpP116.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h11 := errBlockLin_of_piece (q0 := 1.0275) (q1 := 1.028) (m := vBP 1.0345)
    (Lo := (-0.50116696)) (Hi := (-0.493807)) (Klo := (-0.000012400441)) (Khi := (-0.000012392656))
    (by norm_num) (by norm_num) (by norm_num) errPt102
    vbpP102.1 vbpP102.2 vbpP103.1 vbpP103.2 vbpP116.1 vbpP116.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h12 := errBlockLin_of_piece (q0 := 1.028) (q1 := 1.0285) (m := vBP 1.0345)
    (Lo := (-0.49504745)) (Hi := (-0.48768956)) (Klo := (-0.000011466655)) (Khi := (-0.000011458874))
    (by norm_num) (by norm_num) (by norm_num) errPt103
    vbpP103.1 vbpP103.2 vbpP104.1 vbpP104.2 vbpP116.1 vbpP116.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h13 := errBlockLin_of_piece (q0 := 1.0285) (q1 := 1.029) (m := vBP 1.0345)
    (Lo := (-0.48895043)) (Hi := (-0.48159456)) (Klo := (-0.000010536174)) (Khi := (-0.000010528397))
    (by norm_num) (by norm_num) (by norm_num) errPt104
    vbpP104.1 vbpP104.2 vbpP105.1 vbpP105.2 vbpP116.1 vbpP116.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h14 := errBlockLin_of_piece (q0 := 1.029) (q1 := 1.0295) (m := vBP 1.0345)
    (Lo := (-0.48287589)) (Hi := (-0.47552198)) (Klo := (-0.000009608992)) (Khi := (-0.000009601218))
    (by norm_num) (by norm_num) (by norm_num) errPt105
    vbpP105.1 vbpP105.2 vbpP106.1 vbpP106.2 vbpP116.1 vbpP116.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h15 := errBlockLin_of_piece (q0 := 1.0295) (q1 := 1.03) (m := vBP 1.0345)
    (Lo := (-0.47682382)) (Hi := (-0.46947182)) (Klo := (-0.000008685102)) (Khi := (-0.000008677332))
    (by norm_num) (by norm_num) (by norm_num) errPt106
    vbpP106.1 vbpP106.2 vbpP107.1 vbpP107.2 vbpP116.1 vbpP116.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h16 := errBlockLin_of_piece (q0 := 1.03) (q1 := 1.0305) (m := vBP 1.0345)
    (Lo := (-0.47079421)) (Hi := (-0.46344408)) (Klo := (-0.000007760615)) (Khi := (-0.000007752849))
    (by norm_num) (by norm_num) (by norm_num) errPt107
    vbpP107.1 vbpP107.2 vbpP108.1 vbpP108.2 vbpP116.1 vbpP116.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h17 := errBlockLin_of_piece (q0 := 1.0305) (q1 := 1.031) (m := vBP 1.0345)
    (Lo := (-0.46478706)) (Hi := (-0.45743873)) (Klo := (-0.000006841354)) (Khi := (-0.000006833591))
    (by norm_num) (by norm_num) (by norm_num) errPt108
    vbpP108.1 vbpP108.2 vbpP109.1 vbpP109.2 vbpP116.1 vbpP116.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h18 := errBlockLin_of_piece (q0 := 1.031) (q1 := 1.0315) (m := vBP 1.0345)
    (Lo := (-0.45880235)) (Hi := (-0.45145578)) (Klo := (-0.00000592149)) (Khi := (-0.000005913731))
    (by norm_num) (by norm_num) (by norm_num) errPt109
    vbpP109.1 vbpP109.2 vbpP110.1 vbpP110.2 vbpP116.1 vbpP116.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h19 := errBlockLin_of_piece (q0 := 1.0315) (q1 := 1.032) (m := vBP 1.0345)
    (Lo := (-0.45284007)) (Hi := (-0.44549522)) (Klo := (-0.000005004901)) (Khi := (-0.000004997147))
    (by norm_num) (by norm_num) (by norm_num) errPt110
    vbpP110.1 vbpP110.2 vbpP111.1 vbpP111.2 vbpP116.1 vbpP116.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h20 := errBlockLin_of_piece (q0 := 1.032) (q1 := 1.0325) (m := vBP 1.0345)
    (Lo := (-0.44690023)) (Hi := (-0.43955703)) (Klo := (-0.000004089644)) (Khi := (-0.000004081893))
    (by norm_num) (by norm_num) (by norm_num) errPt111
    vbpP111.1 vbpP111.2 vbpP112.1 vbpP112.2 vbpP116.1 vbpP116.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h21 := errBlockLin_of_piece (q0 := 1.0325) (q1 := 1.033) (m := vBP 1.0345)
    (Lo := (-0.4409828)) (Hi := (-0.43364122)) (Klo := (-0.000003179588)) (Khi := (-0.000003171841))
    (by norm_num) (by norm_num) (by norm_num) errPt112
    vbpP112.1 vbpP112.2 vbpP113.1 vbpP113.2 vbpP116.1 vbpP116.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h22 := errBlockLin_of_piece (q0 := 1.033) (q1 := 1.0335) (m := vBP 1.0345)
    (Lo := (-0.43508779)) (Hi := (-0.42774776)) (Klo := (-0.000002268918)) (Khi := (-0.000002261175))
    (by norm_num) (by norm_num) (by norm_num) errPt113
    vbpP113.1 vbpP113.2 vbpP114.1 vbpP114.2 vbpP116.1 vbpP116.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h23 := errBlockLin_of_piece (q0 := 1.0335) (q1 := 1.034) (m := vBP 1.0345)
    (Lo := (-0.42921518)) (Hi := (-0.42187666)) (Klo := (-0.000001361503)) (Khi := (-0.000001353763))
    (by norm_num) (by norm_num) (by norm_num) errPt114
    vbpP114.1 vbpP114.2 vbpP115.1 vbpP115.2 vbpP116.1 vbpP116.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h24 := errBlockLin_of_piece (q0 := 1.034) (q1 := 1.0345) (m := vBP 1.0345)
    (Lo := (-0.42336497)) (Hi := (-0.41602791)) (Klo := (-0.000000455404)) (Khi := (-0.000000447668))
    (by norm_num) (by norm_num) (by norm_num) errPt115
    vbpP115.1 vbpP115.2 vbpP116.1 vbpP116.2 vbpP116.1 vbpP116.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h25 := errBlockLin_of_piece (q0 := 1.0345) (q1 := 1.035) (m := vBP 1.0345)
    (Lo := (-0.41753714)) (Hi := (-0.4102015)) (Klo := 0.000000447449) (Khi := 0.000000455182)
    (by norm_num) (by norm_num) (by norm_num) errPt116
    vbpP116.1 vbpP116.2 vbpP117.1 vbpP117.2 vbpP116.1 vbpP116.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h26 := errBlockLin_of_piece (q0 := 1.035) (q1 := 1.0355) (m := vBP 1.0345)
    (Lo := (-0.4117317)) (Hi := (-0.40439742)) (Klo := 0.000001348995) (Khi := 0.000001356724)
    (by norm_num) (by norm_num) (by norm_num) errPt117
    vbpP117.1 vbpP117.2 vbpP118.1 vbpP118.2 vbpP116.1 vbpP116.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h27 := errBlockLin_of_piece (q0 := 1.0355) (q1 := 1.036) (m := vBP 1.0345)
    (Lo := (-0.40594862)) (Hi := (-0.39861566)) (Klo := 0.000002247305) (Khi := 0.00000225503)
    (by norm_num) (by norm_num) (by norm_num) errPt118
    vbpP118.1 vbpP118.2 vbpP119.1 vbpP119.2 vbpP116.1 vbpP116.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h28 := errBlockLin_of_piece (q0 := 1.036) (q1 := 1.0365) (m := vBP 1.0345)
    (Lo := (-0.40018792)) (Hi := (-0.39285622)) (Klo := 0.000003144315) (Khi := 0.000003152036)
    (by norm_num) (by norm_num) (by norm_num) errPt119
    vbpP119.1 vbpP119.2 vbpP120.1 vbpP120.2 vbpP116.1 vbpP116.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h29 := errBlockLin_of_piece (q0 := 1.0365) (q1 := 1.037) (m := vBP 1.0345)
    (Lo := (-0.39444956)) (Hi := (-0.38711909)) (Klo := 0.000004038099) (Khi := 0.000004045816)
    (by norm_num) (by norm_num) (by norm_num) errPt120
    vbpP120.1 vbpP120.2 vbpP121.1 vbpP121.2 vbpP116.1 vbpP116.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h30 := errBlockLin_of_piece (q0 := 1.037) (q1 := 1.0375) (m := vBP 1.0345)
    (Lo := (-0.38873356)) (Hi := (-0.38140427)) (Klo := 0.00000493059) (Khi := 0.000004938304)
    (by norm_num) (by norm_num) (by norm_num) errPt121
    vbpP121.1 vbpP121.2 vbpP122.1 vbpP122.2 vbpP116.1 vbpP116.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h31 := errBlockLin_of_piece (q0 := 1.0375) (q1 := 1.038) (m := vBP 1.0345)
    (Lo := (-0.3830399)) (Hi := (-0.37571173)) (Klo := 0.000005821792) (Khi := 0.000005829502)
    (by norm_num) (by norm_num) (by norm_num) errPt122
    vbpP122.1 vbpP122.2 vbpP123.1 vbpP123.2 vbpP116.1 vbpP116.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h32 := errBlockLin_of_piece (q0 := 1.038) (q1 := 1.0385) (m := vBP 1.0345)
    (Lo := (-0.37736857)) (Hi := (-0.37004149)) (Klo := 0.000006709781) (Khi := 0.000006717487)
    (by norm_num) (by norm_num) (by norm_num) errPt123
    vbpP123.1 vbpP123.2 vbpP124.1 vbpP124.2 vbpP116.1 vbpP116.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h33 := errBlockLin_of_piece (q0 := 1.0385) (q1 := 1.039) (m := vBP 1.0345)
    (Lo := (-0.37171957)) (Hi := (-0.36439352)) (Klo := 0.000007594563) (Khi := 0.000007602265)
    (by norm_num) (by norm_num) (by norm_num) errPt124
    vbpP124.1 vbpP124.2 vbpP125.1 vbpP125.2 vbpP116.1 vbpP116.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h34 := errBlockLin_of_piece (q0 := 1.039) (q1 := 1.0395) (m := vBP 1.0345)
    (Lo := (-0.36609289)) (Hi := (-0.35876783)) (Klo := 0.000008479992) (Khi := 0.000008487691)
    (by norm_num) (by norm_num) (by norm_num) errPt125
    vbpP125.1 vbpP125.2 vbpP126.1 vbpP126.2 vbpP116.1 vbpP116.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h35 := errBlockLin_of_piece (q0 := 1.0395) (q1 := 1.04) (m := vBP 1.0345)
    (Lo := (-0.36048851)) (Hi := (-0.35316441)) (Klo := 0.000009360298) (Khi := 0.000009367993)
    (by norm_num) (by norm_num) (by norm_num) errPt126
    vbpP126.1 vbpP126.2 vbpP127.1 vbpP127.2 vbpP116.1 vbpP116.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h36 := errBlockLin_of_piece (q0 := 1.04) (q1 := 1.0405) (m := vBP 1.0345)
    (Lo := (-0.35490645)) (Hi := (-0.34758324)) (Klo := 0.000010241256) (Khi := 0.000010248948)
    (by norm_num) (by norm_num) (by norm_num) errPt127
    vbpP127.1 vbpP127.2 vbpP128.1 vbpP128.2 vbpP116.1 vbpP116.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h37 := errBlockLin_of_piece (q0 := 1.0405) (q1 := 1.041) (m := vBP 1.0345)
    (Lo := (-0.34934668)) (Hi := (-0.34202433)) (Klo := 0.000011117104) (Khi := 0.000011124791)
    (by norm_num) (by norm_num) (by norm_num) errPt128
    vbpP128.1 vbpP128.2 vbpP129.1 vbpP129.2 vbpP116.1 vbpP116.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h38 := errBlockLin_of_piece (q0 := 1.041) (q1 := 1.0415) (m := vBP 1.0345)
    (Lo := (-0.3438092)) (Hi := (-0.33648766)) (Klo := 0.00001199361) (Khi := 0.000012001294)
    (by norm_num) (by norm_num) (by norm_num) errPt129
    vbpP129.1 vbpP129.2 vbpP130.1 vbpP130.2 vbpP116.1 vbpP116.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h39 := errBlockLin_of_piece (q0 := 1.0415) (q1 := 1.042) (m := vBP 1.0345)
    (Lo := (-0.338294)) (Hi := (-0.33097324)) (Klo := 0.000012866934) (Khi := 0.000012874615)
    (by norm_num) (by norm_num) (by norm_num) errPt130
    vbpP130.1 vbpP130.2 vbpP131.1 vbpP131.2 vbpP116.1 vbpP116.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h40 := errBlockLin_of_piece (q0 := 1.042) (q1 := 1.0425) (m := vBP 1.0345)
    (Lo := (-0.33280108)) (Hi := (-0.32548104)) (Klo := 0.000013737084) (Khi := 0.000013744761)
    (by norm_num) (by norm_num) (by norm_num) errPt131
    vbpP131.1 vbpP131.2 vbpP132.1 vbpP132.2 vbpP116.1 vbpP116.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h41 := errBlockLin_of_piece (q0 := 1.0425) (q1 := 1.043) (m := vBP 1.0345)
    (Lo := (-0.32733042)) (Hi := (-0.32001107)) (Klo := 0.000014605983) (Khi := 0.000014613656)
    (by norm_num) (by norm_num) (by norm_num) errPt132
    vbpP132.1 vbpP132.2 vbpP133.1 vbpP133.2 vbpP116.1 vbpP116.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h42 := errBlockLin_of_piece (q0 := 1.043) (q1 := 1.0435) (m := vBP 1.0345)
    (Lo := (-0.32188203)) (Hi := (-0.31456331)) (Klo := 0.000015473632) (Khi := 0.000015481301)
    (by norm_num) (by norm_num) (by norm_num) errPt133
    vbpP133.1 vbpP133.2 vbpP134.1 vbpP134.2 vbpP116.1 vbpP116.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h43 := errBlockLin_of_piece (q0 := 1.0435) (q1 := 1.044) (m := vBP 1.0345)
    (Lo := (-0.31645589)) (Hi := (-0.30913777)) (Klo := 0.000016340035) (Khi := 0.0000163477)
    (by norm_num) (by norm_num) (by norm_num) errPt134
    vbpP134.1 vbpP134.2 vbpP135.1 vbpP135.2 vbpP116.1 vbpP116.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h44 := errBlockLin_of_piece (q0 := 1.044) (q1 := 1.0445) (m := vBP 1.0345)
    (Lo := (-0.311052)) (Hi := (-0.30373443)) (Klo := 0.000017199449) (Khi := 0.000017207111)
    (by norm_num) (by norm_num) (by norm_num) errPt135
    vbpP135.1 vbpP135.2 vbpP136.1 vbpP136.2 vbpP116.1 vbpP116.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h45 := errBlockLin_of_piece (q0 := 1.0445) (q1 := 1.045) (m := vBP 1.0345)
    (Lo := (-0.30567035)) (Hi := (-0.29835329)) (Klo := 0.000018063371) (Khi := 0.000018071029)
    (by norm_num) (by norm_num) (by norm_num) errPt136
    vbpP136.1 vbpP136.2 vbpP137.1 vbpP137.2 vbpP116.1 vbpP116.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h46 := errBlockLin_of_piece (q0 := 1.045) (q1 := 1.0455) (m := vBP 1.0345)
    (Lo := (-0.30031093)) (Hi := (-0.29299434)) (Klo := 0.000018920315) (Khi := 0.000018927969)
    (by norm_num) (by norm_num) (by norm_num) errPt137
    vbpP137.1 vbpP137.2 vbpP138.1 vbpP138.2 vbpP116.1 vbpP116.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h47 := errBlockLin_of_piece (q0 := 1.0455) (q1 := 1.046) (m := vBP 1.0345)
    (Lo := (-0.29497373)) (Hi := (-0.28765758)) (Klo := 0.00001977603) (Khi := 0.000019783681)
    (by norm_num) (by norm_num) (by norm_num) errPt138
    vbpP138.1 vbpP138.2 vbpP139.1 vbpP139.2 vbpP116.1 vbpP116.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  exact (((((((((((((((((((((((((((((((((((((((((((((((h0.add h1).add h2).add h3).add h4).add h5).add h6).add h7).add h8).add h9).add h10).add h11).add h12).add h13).add h14).add h15).add h16).add h17).add h18).add h19).add h20).add h21).add h22).add h23).add h24).add h25).add h26).add h27).add h28).add h29).add h30).add h31).add h32).add h33).add h34).add h35).add h36).add h37).add h38).add h39).add h40).add h41).add h42).add h43).add h44).add h45).add h46).add h47).mono (by norm_num) (by norm_num) (by norm_num [mn4])
    (by norm_num [mx4]) (by norm_num)

theorem blkLin2 : errBlockLin (vBP 1.046) (vBP 1.069) (vBP 1.057) (-0.0075683785) (-0.0068318625) 0.0000232008 0.0000317702 0.0075683785 := by
  have h0 := errBlockLin_of_piece (q0 := 1.046) (q1 := 1.0465) (m := vBP 1.057)
    (Lo := (-0.28965876)) (Hi := (-0.28234299)) (Klo := (-0.000018680054)) (Khi := (-0.000018672407))
    (by norm_num) (by norm_num) (by norm_num) errPt139
    vbpP139.1 vbpP139.2 vbpP140.1 vbpP140.2 vbpP151.1 vbpP151.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h1 := errBlockLin_of_piece (q0 := 1.0465) (q1 := 1.047) (m := vBP 1.057)
    (Lo := (-0.284366)) (Hi := (-0.27705058)) (Klo := (-0.000017791154)) (Khi := (-0.00001778351))
    (by norm_num) (by norm_num) (by norm_num) errPt140
    vbpP140.1 vbpP140.2 vbpP141.1 vbpP141.2 vbpP151.1 vbpP151.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h2 := errBlockLin_of_piece (q0 := 1.047) (q1 := 1.048) (m := vBP 1.057)
    (Lo := (-0.28006376)) (Hi := (-0.26557236)) (Klo := (-0.000032916879)) (Khi := (-0.00003290924))
    (by norm_num) (by norm_num) (by norm_num) errPt141
    vbpP141.1 vbpP141.2 vbpP142.1 vbpP142.2 vbpP151.1 vbpP151.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h3 := errBlockLin_of_piece (q0 := 1.048) (q1 := 1.049) (m := vBP 1.057)
    (Lo := (-0.26961169)) (Hi := (-0.25512015)) (Klo := (-0.000029382246)) (Khi := (-0.000029374615))
    (by norm_num) (by norm_num) (by norm_num) errPt142
    vbpP142.1 vbpP142.2 vbpP143.1 vbpP143.2 vbpP151.1 vbpP151.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h4 := errBlockLin_of_piece (q0 := 1.049) (q1 := 1.05) (m := vBP 1.057)
    (Lo := (-0.25924842)) (Hi := (-0.24475642)) (Klo := (-0.000025865331)) (Khi := (-0.000025857707))
    (by norm_num) (by norm_num) (by norm_num) errPt143
    vbpP143.1 vbpP143.2 vbpP144.1 vbpP144.2 vbpP151.1 vbpP151.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h5 := errBlockLin_of_piece (q0 := 1.05) (q1 := 1.051) (m := vBP 1.057)
    (Lo := (-0.24897392)) (Hi := (-0.23448112)) (Klo := (-0.00002236226)) (Khi := (-0.000022354644))
    (by norm_num) (by norm_num) (by norm_num) errPt144
    vbpP144.1 vbpP144.2 vbpP145.1 vbpP145.2 vbpP151.1 vbpP151.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h6 := errBlockLin_of_piece (q0 := 1.051) (q1 := 1.052) (m := vBP 1.057)
    (Lo := (-0.23878811)) (Hi := (-0.22429419)) (Klo := (-0.000018878686)) (Khi := (-0.000018871076))
    (by norm_num) (by norm_num) (by norm_num) errPt145
    vbpP145.1 vbpP145.2 vbpP146.1 vbpP146.2 vbpP151.1 vbpP151.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h7 := errBlockLin_of_piece (q0 := 1.052) (q1 := 1.053) (m := vBP 1.057)
    (Lo := (-0.22869095)) (Hi := (-0.21419559)) (Klo := (-0.000015410734)) (Khi := (-0.000015403132))
    (by norm_num) (by norm_num) (by norm_num) errPt146
    vbpP146.1 vbpP146.2 vbpP147.1 vbpP147.2 vbpP151.1 vbpP151.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h8 := errBlockLin_of_piece (q0 := 1.053) (q1 := 1.054) (m := vBP 1.057)
    (Lo := (-0.21868238)) (Hi := (-0.20418527)) (Klo := (-0.000011958345)) (Khi := (-0.00001195075))
    (by norm_num) (by norm_num) (by norm_num) errPt147
    vbpP147.1 vbpP147.2 vbpP148.1 vbpP148.2 vbpP151.1 vbpP151.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h9 := errBlockLin_of_piece (q0 := 1.054) (q1 := 1.055) (m := vBP 1.057)
    (Lo := (-0.20876234)) (Hi := (-0.19426317)) (Klo := (-0.000008521461)) (Khi := (-0.000008513873))
    (by norm_num) (by norm_num) (by norm_num) errPt148
    vbpP148.1 vbpP148.2 vbpP149.1 vbpP149.2 vbpP151.1 vbpP151.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h10 := errBlockLin_of_piece (q0 := 1.055) (q1 := 1.056) (m := vBP 1.057)
    (Lo := (-0.19893078)) (Hi := (-0.18442925)) (Klo := (-0.00000510381)) (Khi := (-0.00000509623))
    (by norm_num) (by norm_num) (by norm_num) errPt149
    vbpP149.1 vbpP149.2 vbpP150.1 vbpP150.2 vbpP151.1 vbpP151.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h11 := errBlockLin_of_piece (q0 := 1.056) (q1 := 1.057) (m := vBP 1.057)
    (Lo := (-0.18918763)) (Hi := (-0.17468345)) (Klo := (-0.000001699644)) (Khi := (-0.00000169207))
    (by norm_num) (by norm_num) (by norm_num) errPt150
    vbpP150.1 vbpP150.2 vbpP151.1 vbpP151.2 vbpP151.1 vbpP151.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h12 := errBlockLin_of_piece (q0 := 1.057) (q1 := 1.058) (m := vBP 1.057)
    (Lo := (-0.17953285)) (Hi := (-0.16502572)) (Klo := 0.000001687309) (Khi := 0.000001694875)
    (by norm_num) (by norm_num) (by norm_num) errPt151
    vbpP151.1 vbpP151.2 vbpP152.1 vbpP152.2 vbpP151.1 vbpP151.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h13 := errBlockLin_of_piece (q0 := 1.058) (q1 := 1.059) (m := vBP 1.057)
    (Lo := (-0.16996637)) (Hi := (-0.15545602)) (Klo := 0.000005057112) (Khi := 0.000005064671)
    (by norm_num) (by norm_num) (by norm_num) errPt152
    vbpP152.1 vbpP152.2 vbpP153.1 vbpP153.2 vbpP151.1 vbpP151.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h14 := errBlockLin_of_piece (q0 := 1.059) (q1 := 1.06) (m := vBP 1.057)
    (Lo := (-0.16048813)) (Hi := (-0.14597428)) (Klo := 0.000008413604) (Khi := 0.000008421156)
    (by norm_num) (by norm_num) (by norm_num) errPt153
    vbpP153.1 vbpP153.2 vbpP154.1 vbpP154.2 vbpP151.1 vbpP151.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h15 := errBlockLin_of_piece (q0 := 1.06) (q1 := 1.061) (m := vBP 1.057)
    (Lo := (-0.15109809)) (Hi := (-0.13658045)) (Klo := 0.000011753066) (Khi := 0.000011760611)
    (by norm_num) (by norm_num) (by norm_num) errPt154
    vbpP154.1 vbpP154.2 vbpP155.1 vbpP155.2 vbpP151.1 vbpP151.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h16 := errBlockLin_of_piece (q0 := 1.061) (q1 := 1.062) (m := vBP 1.057)
    (Lo := (-0.14179618)) (Hi := (-0.12727449)) (Klo := 0.000015077445) (Khi := 0.000015084982)
    (by norm_num) (by norm_num) (by norm_num) errPt155
    vbpP155.1 vbpP155.2 vbpP156.1 vbpP156.2 vbpP151.1 vbpP151.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h17 := errBlockLin_of_piece (q0 := 1.062) (q1 := 1.064) (m := vBP 1.057)
    (Lo := (-0.13523835)) (Hi := (-0.1063019)) (Klo := 0.0000400661) (Khi := 0.000040073627)
    (by norm_num) (by norm_num) (by norm_num) errPt156
    vbpP156.1 vbpP156.2 vbpP157.1 vbpP157.2 vbpP151.1 vbpP151.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h18 := errBlockLin_of_piece (q0 := 1.064) (q1 := 1.066) (m := vBP 1.057)
    (Lo := (-0.11716846)) (Hi := (-0.08821002)) (Klo := 0.000053172787) (Khi := 0.0000531803)
    (by norm_num) (by norm_num) (by norm_num) errPt157
    vbpP157.1 vbpP157.2 vbpP158.1 vbpP158.2 vbpP151.1 vbpP151.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h19 := errBlockLin_of_piece (q0 := 1.066) (q1 := 1.068) (m := vBP 1.057)
    (Lo := (-0.09945051)) (Hi := (-0.07046808)) (Klo := 0.000066157152) (Khi := 0.00006616465)
    (by norm_num) (by norm_num) (by norm_num) errPt158
    vbpP158.1 vbpP158.2 vbpP159.1 vbpP159.2 vbpP151.1 vbpP151.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h20 := errBlockLin_of_piece (q0 := 1.068) (q1 := 1.069) (m := vBP 1.057)
    (Lo := (-0.07914534)) (Hi := (-0.06458829)) (Klo := 0.000037908099) (Khi := 0.000037915587)
    (by norm_num) (by norm_num) (by norm_num) errPt159
    vbpP159.1 vbpP159.2 vbpP160.1 vbpP160.2 vbpP151.1 vbpP151.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  exact ((((((((((((((((((((h0.add h1).add h2).add h3).add h4).add h5).add h6).add h7).add h8).add h9).add h10).add h11).add h12).add h13).add h14).add h15).add h16).add h17).add h18).add h19).add h20).mono (by norm_num) (by norm_num) (by norm_num [mn4])
    (by norm_num [mx4]) (by norm_num)

end ConnesConsani.WeilPositivity
