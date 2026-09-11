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
import RequestProject.Imported.OutputFinal.RequestProject.PolyaLowVbp1
import RequestProject.Imported.OutputFinal.RequestProject.PolyaLowVbp2
import RequestProject.Imported.OutputFinal.RequestProject.PolyaLowPieces1
import RequestProject.Imported.OutputFinal.RequestProject.PolyaLowPieces2
import RequestProject.Imported.OutputFinal.RequestProject.PolyaLowPieces3
import RequestProject.Imported.OutputFinal.RequestProject.PolyaLowPieces4

/-!
# The block data for the low-frequency bands (part 1)

Blocks of the extended partition `q ∈ [1,5]`, grouped so that the phase `tv`
varies by at most `0.25` across a block for `t ≤ 1.8`; long blocks are assembled
from sub-blocks of at most 30 pieces.
-/

set_option maxHeartbeats 4000000

noncomputable section

open MeasureTheory Set Real

namespace ConnesConsani.WeilPositivity

theorem blkLo0_0 : errBlockLin (vBP 1) (vBP 1.0075) (vBP 1.034) (-0.012210361) (-0.0121509304) 0.0007237568 0.0007274819 0.012210361 := by
  have h0 := errBlockLin_of_piece (q0 := 1) (q1 := 1.0002) (m := vBP 1.034)
    (Lo := (-0.87266839)) (Hi := (-0.86954584)) (Klo := (-0.000026666488)) (Khi := (-0.000026660488))
    (by norm_num) (by norm_num) (by norm_num) errPt0
    vbpP0.1 vbpP0.2 vbpP1.1 vbpP1.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h1 := errBlockLin_of_piece (q0 := 1.0002) (q1 := 1.0005) (m := vBP 1.034)
    (Lo := (-0.86971703)) (Hi := (-0.86511506)) (Klo := (-0.000039677895)) (Khi := (-0.000039669896))
    (by norm_num) (by norm_num) (by norm_num) errPt1
    vbpP1.1 vbpP1.2 vbpP2.1 vbpP2.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h2 := errBlockLin_of_piece (q0 := 1.0005) (q1 := 1.0008) (m := vBP 1.034)
    (Lo := (-0.86529372)) (Hi := (-0.8606937)) (Klo := (-0.000039294396)) (Khi := (-0.0000392864))
    (by norm_num) (by norm_num) (by norm_num) errPt2
    vbpP2.1 vbpP2.2 vbpP3.1 vbpP3.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h3 := errBlockLin_of_piece (q0 := 1.0008) (q1 := 1.001) (m := vBP 1.034)
    (Lo := (-0.86087378)) (Hi := (-0.85775465)) (Klo := (-0.000025984712)) (Khi := (-0.000025976718))
    (by norm_num) (by norm_num) (by norm_num) errPt3
    vbpP3.1 vbpP3.2 vbpP4.1 vbpP4.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h4 := errBlockLin_of_piece (q0 := 1.001) (q1 := 1.0012) (m := vBP 1.034)
    (Lo := (-0.85793438)) (Hi := (-0.8548161)) (Klo := (-0.00002581652)) (Khi := (-0.000025808528))
    (by norm_num) (by norm_num) (by norm_num) errPt4
    vbpP4.1 vbpP4.2 vbpP5.1 vbpP5.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h5 := errBlockLin_of_piece (q0 := 1.0012) (q1 := 1.0015) (m := vBP 1.034)
    (Lo := (-0.85500507)) (Hi := (-0.85040953)) (Klo := (-0.000038402902)) (Khi := (-0.000038394912))
    (by norm_num) (by norm_num) (by norm_num) errPt5
    vbpP5.1 vbpP5.2 vbpP6.1 vbpP6.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h6 := errBlockLin_of_piece (q0 := 1.0015) (q1 := 1.0018) (m := vBP 1.034)
    (Lo := (-0.85060952)) (Hi := (-0.84601589)) (Klo := (-0.00003802055)) (Khi := (-0.000038012562))
    (by norm_num) (by norm_num) (by norm_num) errPt6
    vbpP6.1 vbpP6.2 vbpP7.1 vbpP7.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h7 := errBlockLin_of_piece (q0 := 1.0018) (q1 := 1.002) (m := vBP 1.034)
    (Lo := (-0.8462138)) (Hi := (-0.84309886)) (Klo := (-0.000025138777)) (Khi := (-0.000025130791))
    (by norm_num) (by norm_num) (by norm_num) errPt7
    vbpP7.1 vbpP7.2 vbpP8.1 vbpP8.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h8 := errBlockLin_of_piece (q0 := 1.002) (q1 := 1.0022) (m := vBP 1.034)
    (Lo := (-0.84329289)) (Hi := (-0.84017878)) (Klo := (-0.000024969096)) (Khi := (-0.000024961111))
    (by norm_num) (by norm_num) (by norm_num) errPt8
    vbpP8.1 vbpP8.2 vbpP9.1 vbpP9.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h9 := errBlockLin_of_piece (q0 := 1.0022) (q1 := 1.0025) (m := vBP 1.034)
    (Lo := (-0.84038562)) (Hi := (-0.83579636)) (Klo := (-0.000037133717)) (Khi := (-0.000037125735))
    (by norm_num) (by norm_num) (by norm_num) errPt9
    vbpP9.1 vbpP9.2 vbpP10.1 vbpP10.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h10 := errBlockLin_of_piece (q0 := 1.0025) (q1 := 1.0028) (m := vBP 1.034)
    (Lo := (-0.83601781)) (Hi := (-0.8314304)) (Klo := (-0.0000367545)) (Khi := (-0.00003674652))
    (by norm_num) (by norm_num) (by norm_num) errPt10
    vbpP10.1 vbpP10.2 vbpP11.1 vbpP11.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h11 := errBlockLin_of_piece (q0 := 1.0028) (q1 := 1.003) (m := vBP 1.034)
    (Lo := (-0.83164623)) (Hi := (-0.82853539)) (Klo := (-0.000024293378)) (Khi := (-0.000024285401))
    (by norm_num) (by norm_num) (by norm_num) errPt11
    vbpP11.1 vbpP11.2 vbpP12.1 vbpP12.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h12 := errBlockLin_of_piece (q0 := 1.003) (q1 := 1.0032) (m := vBP 1.034)
    (Lo := (-0.82874379)) (Hi := (-0.82563376)) (Klo := (-0.000024126197)) (Khi := (-0.000024118221))
    (by norm_num) (by norm_num) (by norm_num) errPt12
    vbpP12.1 vbpP12.2 vbpP13.1 vbpP13.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h13 := errBlockLin_of_piece (q0 := 1.0032) (q1 := 1.0035) (m := vBP 1.034)
    (Lo := (-0.82585856)) (Hi := (-0.82127542)) (Klo := (-0.000035872311)) (Khi := (-0.000035864337))
    (by norm_num) (by norm_num) (by norm_num) errPt13
    vbpP13.1 vbpP13.2 vbpP14.1 vbpP14.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h14 := errBlockLin_of_piece (q0 := 1.0035) (q1 := 1.0038) (m := vBP 1.034)
    (Lo := (-0.82151844)) (Hi := (-0.81693711)) (Klo := (-0.000035494226)) (Khi := (-0.000035486254))
    (by norm_num) (by norm_num) (by norm_num) errPt14
    vbpP14.1 vbpP14.2 vbpP15.1 vbpP15.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h15 := errBlockLin_of_piece (q0 := 1.0038) (q1 := 1.004) (m := vBP 1.034)
    (Lo := (-0.81717095)) (Hi := (-0.81406411)) (Klo := (-0.000023454487)) (Khi := (-0.000023446517))
    (by norm_num) (by norm_num) (by norm_num) errPt15
    vbpP15.1 vbpP15.2 vbpP16.1 vbpP16.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h16 := errBlockLin_of_piece (q0 := 1.004) (q1 := 1.0042) (m := vBP 1.034)
    (Lo := (-0.81428695)) (Hi := (-0.8111809)) (Klo := (-0.000023287806)) (Khi := (-0.000023279837))
    (by norm_num) (by norm_num) (by norm_num) errPt16
    vbpP16.1 vbpP16.2 vbpP17.1 vbpP17.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h17 := errBlockLin_of_piece (q0 := 1.0042) (q1 := 1.0045) (m := vBP 1.034)
    (Lo := (-0.81142376)) (Hi := (-0.80684659)) (Klo := (-0.00003461467)) (Khi := (-0.000034606704))
    (by norm_num) (by norm_num) (by norm_num) errPt17
    vbpP17.1 vbpP17.2 vbpP18.1 vbpP18.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h18 := errBlockLin_of_piece (q0 := 1.0045) (q1 := 1.0048) (m := vBP 1.034)
    (Lo := (-0.80711129)) (Hi := (-0.80253588)) (Klo := (-0.000034239702)) (Khi := (-0.000034231739))
    (by norm_num) (by norm_num) (by norm_num) errPt18
    vbpP18.1 vbpP18.2 vbpP19.1 vbpP19.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h19 := errBlockLin_of_piece (q0 := 1.0048) (q1 := 1.005) (m := vBP 1.034)
    (Lo := (-0.80278782)) (Hi := (-0.79968489)) (Klo := (-0.000022620088)) (Khi := (-0.000022612126))
    (by norm_num) (by norm_num) (by norm_num) errPt19
    vbpP19.1 vbpP19.2 vbpP20.1 vbpP20.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h20 := errBlockLin_of_piece (q0 := 1.005) (q1 := 1.0052) (m := vBP 1.034)
    (Lo := (-0.79992225)) (Hi := (-0.79682009)) (Klo := (-0.000022451915)) (Khi := (-0.000022443955))
    (by norm_num) (by norm_num) (by norm_num) errPt20
    vbpP20.1 vbpP20.2 vbpP21.1 vbpP21.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h21 := errBlockLin_of_piece (q0 := 1.0052) (q1 := 1.0055) (m := vBP 1.034)
    (Lo := (-0.79708109)) (Hi := (-0.79250974)) (Klo := (-0.000033364757)) (Khi := (-0.000033356799))
    (by norm_num) (by norm_num) (by norm_num) errPt21
    vbpP21.1 vbpP21.2 vbpP22.1 vbpP22.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h22 := errBlockLin_of_piece (q0 := 1.0055) (q1 := 1.0058) (m := vBP 1.034)
    (Lo := (-0.79279624)) (Hi := (-0.7882266)) (Klo := (-0.000032990908)) (Khi := (-0.000032982952))
    (by norm_num) (by norm_num) (by norm_num) errPt22
    vbpP22.1 vbpP22.2 vbpP23.1 vbpP23.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h23 := errBlockLin_of_piece (q0 := 1.0058) (q1 := 1.006) (m := vBP 1.034)
    (Lo := (-0.78849674)) (Hi := (-0.78539763)) (Klo := (-0.000021788177)) (Khi := (-0.000021780223))
    (by norm_num) (by norm_num) (by norm_num) errPt23
    vbpP23.1 vbpP23.2 vbpP24.1 vbpP24.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h24 := errBlockLin_of_piece (q0 := 1.006) (q1 := 1.0062) (m := vBP 1.034)
    (Lo := (-0.78564956)) (Hi := (-0.78255119)) (Klo := (-0.00002162249)) (Khi := (-0.000021614537))
    (by norm_num) (by norm_num) (by norm_num) errPt24
    vbpP24.1 vbpP24.2 vbpP25.1 vbpP25.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h25 := errBlockLin_of_piece (q0 := 1.0062) (q1 := 1.0065) (m := vBP 1.034)
    (Lo := (-0.78283044)) (Hi := (-0.77826475)) (Klo := (-0.000032120554)) (Khi := (-0.000032112604))
    (by norm_num) (by norm_num) (by norm_num) errPt25
    vbpP25.1 vbpP25.2 vbpP26.1 vbpP26.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h26 := errBlockLin_of_piece (q0 := 1.0065) (q1 := 1.0068) (m := vBP 1.034)
    (Lo := (-0.77857317)) (Hi := (-0.77400915)) (Klo := (-0.000031747818)) (Khi := (-0.00003173987))
    (by norm_num) (by norm_num) (by norm_num) errPt26
    vbpP26.1 vbpP26.2 vbpP27.1 vbpP27.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h27 := errBlockLin_of_piece (q0 := 1.0068) (q1 := 1.007) (m := vBP 1.034)
    (Lo := (-0.77429758)) (Hi := (-0.77120219)) (Klo := (-0.000020960728)) (Khi := (-0.000020952782))
    (by norm_num) (by norm_num) (by norm_num) errPt27
    vbpP27.1 vbpP27.2 vbpP28.1 vbpP28.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h28 := errBlockLin_of_piece (q0 := 1.007) (q1 := 1.0072) (m := vBP 1.034)
    (Lo := (-0.77146877)) (Hi := (-0.76837411)) (Klo := (-0.000020795534)) (Khi := (-0.00002078759))
    (by norm_num) (by norm_num) (by norm_num) errPt28
    vbpP28.1 vbpP28.2 vbpP29.1 vbpP29.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h29 := errBlockLin_of_piece (q0 := 1.0072) (q1 := 1.0075) (m := vBP 1.034)
    (Lo := (-0.76867169)) (Hi := (-0.76411151)) (Klo := (-0.00003088204)) (Khi := (-0.000030874097))
    (by norm_num) (by norm_num) (by norm_num) errPt29
    vbpP29.1 vbpP29.2 vbpP30.1 vbpP30.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  exact (((((((((((((((((((((((((((((h0.add h1).add h2).add h3).add h4).add h5).add h6).add h7).add h8).add h9).add h10).add h11).add h12).add h13).add h14).add h15).add h16).add h17).add h18).add h19).add h20).add h21).add h22).add h23).add h24).add h25).add h26).add h27).add h28).add h29).mono (by norm_num) (by norm_num) (by norm_num [mn4])
    (by norm_num [mx4]) (by norm_num)

theorem blkLo0_1 : errBlockLin (vBP 1.0075) (vBP 1.015) (vBP 1.034) (-0.0104787127) (-0.0104206778) 0.0004656916 0.0004684451 0.0104787127 := by
  have h0 := errBlockLin_of_piece (q0 := 1.0075) (q1 := 1.0078) (m := vBP 1.034)
    (Lo := (-0.76444197)) (Hi := (-0.75988341)) (Klo := (-0.000030512395)) (Khi := (-0.000030504455))
    (by norm_num) (by norm_num) (by norm_num) errPt30
    vbpP30.1 vbpP30.2 vbpP31.1 vbpP31.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h1 := errBlockLin_of_piece (q0 := 1.0078) (q1 := 1.008) (m := vBP 1.034)
    (Lo := (-0.76019022)) (Hi := (-0.75709846)) (Klo := (-0.000020137725)) (Khi := (-0.000020129786))
    (by norm_num) (by norm_num) (by norm_num) errPt31
    vbpP31.1 vbpP31.2 vbpP32.1 vbpP32.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h2 := errBlockLin_of_piece (q0 := 1.008) (q1 := 1.0082) (m := vBP 1.034)
    (Lo := (-0.75737975)) (Hi := (-0.75428871)) (Klo := (-0.000019973021)) (Khi := (-0.000019965084))
    (by norm_num) (by norm_num) (by norm_num) errPt32
    vbpP32.1 vbpP32.2 vbpP33.1 vbpP33.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h3 := errBlockLin_of_piece (q0 := 1.0082) (q1 := 1.0085) (m := vBP 1.034)
    (Lo := (-0.75460472)) (Hi := (-0.7500499)) (Klo := (-0.00002964919)) (Khi := (-0.000029641256))
    (by norm_num) (by norm_num) (by norm_num) errPt33
    vbpP33.1 vbpP33.2 vbpP34.1 vbpP34.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h4 := errBlockLin_of_piece (q0 := 1.0085) (q1 := 1.0088) (m := vBP 1.034)
    (Lo := (-0.75040251)) (Hi := (-0.74584927)) (Klo := (-0.000029282628)) (Khi := (-0.000029274696))
    (by norm_num) (by norm_num) (by norm_num) errPt34
    vbpP34.1 vbpP34.2 vbpP35.1 vbpP35.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h5 := errBlockLin_of_piece (q0 := 1.0088) (q1 := 1.009) (m := vBP 1.034)
    (Lo := (-0.74617455)) (Hi := (-0.74308634)) (Klo := (-0.000019317167)) (Khi := (-0.000019309236))
    (by norm_num) (by norm_num) (by norm_num) errPt35
    vbpP35.1 vbpP35.2 vbpP36.1 vbpP36.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h6 := errBlockLin_of_piece (q0 := 1.009) (q1 := 1.0092) (m := vBP 1.034)
    (Lo := (-0.74338241)) (Hi := (-0.74029489)) (Klo := (-0.000019154933)) (Khi := (-0.000019147004))
    (by norm_num) (by norm_num) (by norm_num) errPt36
    vbpP36.1 vbpP36.2 vbpP37.1 vbpP37.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h7 := errBlockLin_of_piece (q0 := 1.0092) (q1 := 1.0095) (m := vBP 1.034)
    (Lo := (-0.74062941)) (Hi := (-0.73607982)) (Klo := (-0.000028423965)) (Khi := (-0.000028416038))
    (by norm_num) (by norm_num) (by norm_num) errPt37
    vbpP37.1 vbpP37.2 vbpP38.1 vbpP38.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h8 := errBlockLin_of_piece (q0 := 1.0095) (q1 := 1.0098) (m := vBP 1.034)
    (Lo := (-0.73645468)) (Hi := (-0.73190662)) (Klo := (-0.000028056512)) (Khi := (-0.000028048588))
    (by norm_num) (by norm_num) (by norm_num) errPt38
    vbpP38.1 vbpP38.2 vbpP39.1 vbpP39.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h9 := errBlockLin_of_piece (q0 := 1.0098) (q1 := 1.01) (m := vBP 1.034)
    (Lo := (-0.73225046)) (Hi := (-0.7291657)) (Klo := (-0.000018503004)) (Khi := (-0.000018495081))
    (by norm_num) (by norm_num) (by norm_num) errPt39
    vbpP39.1 vbpP39.2 vbpP40.1 vbpP40.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h10 := errBlockLin_of_piece (q0 := 1.01) (q1 := 1.0102) (m := vBP 1.034)
    (Lo := (-0.72947662)) (Hi := (-0.72639255)) (Klo := (-0.000018341253)) (Khi := (-0.000018333332))
    (by norm_num) (by norm_num) (by norm_num) errPt40
    vbpP40.1 vbpP40.2 vbpP41.1 vbpP41.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h11 := errBlockLin_of_piece (q0 := 1.0102) (q1 := 1.0105) (m := vBP 1.034)
    (Lo := (-0.72674567)) (Hi := (-0.72220115)) (Klo := (-0.000027202375)) (Khi := (-0.000027194456))
    (by norm_num) (by norm_num) (by norm_num) errPt41
    vbpP41.1 vbpP41.2 vbpP42.1 vbpP42.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h12 := errBlockLin_of_piece (q0 := 1.0105) (q1 := 1.0108) (m := vBP 1.034)
    (Lo := (-0.72259838)) (Hi := (-0.71805536)) (Klo := (-0.000026839968)) (Khi := (-0.000026832052))
    (by norm_num) (by norm_num) (by norm_num) errPt42
    vbpP42.1 vbpP42.2 vbpP43.1 vbpP43.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h13 := errBlockLin_of_piece (q0 := 1.0108) (q1 := 1.011) (m := vBP 1.034)
    (Lo := (-0.71841784)) (Hi := (-0.71533645)) (Klo := (-0.000017691256)) (Khi := (-0.000017683341))
    (by norm_num) (by norm_num) (by norm_num) errPt43
    vbpP43.1 vbpP43.2 vbpP44.1 vbpP44.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h14 := errBlockLin_of_piece (q0 := 1.011) (q1 := 1.0112) (m := vBP 1.034)
    (Lo := (-0.71566228)) (Hi := (-0.71258156)) (Klo := (-0.000017528008)) (Khi := (-0.000017520095))
    (by norm_num) (by norm_num) (by norm_num) errPt44
    vbpP44.1 vbpP44.2 vbpP45.1 vbpP45.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h15 := errBlockLin_of_piece (q0 := 1.0112) (q1 := 1.0115) (m := vBP 1.034)
    (Lo := (-0.71295337)) (Hi := (-0.70841378)) (Klo := (-0.000025990337)) (Khi := (-0.000025982426))
    (by norm_num) (by norm_num) (by norm_num) errPt45
    vbpP45.1 vbpP45.2 vbpP46.1 vbpP46.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h16 := errBlockLin_of_piece (q0 := 1.0115) (q1 := 1.0118) (m := vBP 1.034)
    (Lo := (-0.7088335)) (Hi := (-0.70429536)) (Klo := (-0.000025625054)) (Khi := (-0.000025617145))
    (by norm_num) (by norm_num) (by norm_num) errPt46
    vbpP46.1 vbpP46.2 vbpP47.1 vbpP47.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h17 := errBlockLin_of_piece (q0 := 1.0118) (q1 := 1.012) (m := vBP 1.034)
    (Lo := (-0.70467658)) (Hi := (-0.70159848)) (Klo := (-0.000016883889)) (Khi := (-0.000016875982))
    (by norm_num) (by norm_num) (by norm_num) errPt47
    vbpP47.1 vbpP47.2 vbpP48.1 vbpP48.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h18 := errBlockLin_of_piece (q0 := 1.012) (q1 := 1.0122) (m := vBP 1.034)
    (Lo := (-0.70193928)) (Hi := (-0.69886183)) (Klo := (-0.000016723098)) (Khi := (-0.000016715193))
    (by norm_num) (by norm_num) (by norm_num) errPt48
    vbpP48.1 vbpP48.2 vbpP49.1 vbpP49.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h19 := errBlockLin_of_piece (q0 := 1.0122) (q1 := 1.0125) (m := vBP 1.034)
    (Lo := (-0.69925242)) (Hi := (-0.69471762)) (Klo := (-0.000024779915)) (Khi := (-0.000024772011))
    (by norm_num) (by norm_num) (by norm_num) errPt49
    vbpP49.1 vbpP49.2 vbpP50.1 vbpP50.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h20 := errBlockLin_of_piece (q0 := 1.0125) (q1 := 1.0128) (m := vBP 1.034)
    (Lo := (-0.69515993)) (Hi := (-0.69062655)) (Klo := (-0.000024419659)) (Khi := (-0.000024411758))
    (by norm_num) (by norm_num) (by norm_num) errPt50
    vbpP50.1 vbpP50.2 vbpP51.1 vbpP51.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h21 := errBlockLin_of_piece (q0 := 1.0128) (q1 := 1.013) (m := vBP 1.034)
    (Lo := (-0.69102659)) (Hi := (-0.68795169)) (Klo := (-0.000016080886)) (Khi := (-0.000016072987))
    (by norm_num) (by norm_num) (by norm_num) errPt51
    vbpP51.1 vbpP51.2 vbpP52.1 vbpP52.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h22 := errBlockLin_of_piece (q0 := 1.013) (q1 := 1.0132) (m := vBP 1.034)
    (Lo := (-0.68830753)) (Hi := (-0.68523326)) (Klo := (-0.000015920571)) (Khi := (-0.000015912673))
    (by norm_num) (by norm_num) (by norm_num) errPt52
    vbpP52.1 vbpP52.2 vbpP53.1 vbpP53.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h23 := errBlockLin_of_piece (q0 := 1.0132) (q1 := 1.0135) (m := vBP 1.034)
    (Lo := (-0.68564272)) (Hi := (-0.68111257)) (Klo := (-0.000023577018)) (Khi := (-0.000023569123))
    (by norm_num) (by norm_num) (by norm_num) errPt53
    vbpP53.1 vbpP53.2 vbpP54.1 vbpP54.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h24 := errBlockLin_of_piece (q0 := 1.0135) (q1 := 1.0138) (m := vBP 1.034)
    (Lo := (-0.68157758)) (Hi := (-0.6770488)) (Klo := (-0.000023219803)) (Khi := (-0.00002321191))
    (by norm_num) (by norm_num) (by norm_num) errPt54
    vbpP54.1 vbpP54.2 vbpP55.1 vbpP55.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h25 := errBlockLin_of_piece (q0 := 1.0138) (q1 := 1.014) (m := vBP 1.034)
    (Lo := (-0.67746776)) (Hi := (-0.67439597)) (Klo := (-0.000015280258)) (Khi := (-0.000015272366))
    (by norm_num) (by norm_num) (by norm_num) errPt55
    vbpP55.1 vbpP55.2 vbpP56.1 vbpP56.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h26 := errBlockLin_of_piece (q0 := 1.014) (q1 := 1.0142) (m := vBP 1.034)
    (Lo := (-0.67476692)) (Hi := (-0.67169575)) (Klo := (-0.000015120416)) (Khi := (-0.000015112526))
    (by norm_num) (by norm_num) (by norm_num) errPt56
    vbpP56.1 vbpP56.2 vbpP57.1 vbpP57.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h27 := errBlockLin_of_piece (q0 := 1.0142) (q1 := 1.0145) (m := vBP 1.034)
    (Lo := (-0.67212416)) (Hi := (-0.66759852)) (Klo := (-0.00002238162)) (Khi := (-0.000022373732))
    (by norm_num) (by norm_num) (by norm_num) errPt57
    vbpP57.1 vbpP57.2 vbpP58.1 vbpP58.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h28 := errBlockLin_of_piece (q0 := 1.0145) (q1 := 1.0148) (m := vBP 1.034)
    (Lo := (-0.66808635)) (Hi := (-0.66356204)) (Klo := (-0.000022023493)) (Khi := (-0.000022015607))
    (by norm_num) (by norm_num) (by norm_num) errPt58
    vbpP58.1 vbpP58.2 vbpP59.1 vbpP59.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h29 := errBlockLin_of_piece (q0 := 1.0148) (q1 := 1.015) (m := vBP 1.034)
    (Lo := (-0.66399999)) (Hi := (-0.66093124)) (Klo := (-0.000014483964)) (Khi := (-0.00001447608))
    (by norm_num) (by norm_num) (by norm_num) errPt59
    vbpP59.1 vbpP59.2 vbpP60.1 vbpP60.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  exact (((((((((((((((((((((((((((((h0.add h1).add h2).add h3).add h4).add h5).add h6).add h7).add h8).add h9).add h10).add h11).add h12).add h13).add h14).add h15).add h16).add h17).add h18).add h19).add h20).add h21).add h22).add h23).add h24).add h25).add h26).add h27).add h28).add h29).mono (by norm_num) (by norm_num) (by norm_num [mn4])
    (by norm_num [mx4]) (by norm_num)

theorem blkLo0_2 : errBlockLin (vBP 1.015) (vBP 1.0225) (vBP 1.034) (-0.0088708261) (-0.0088140564) 0.0002637891 0.0002656219 0.0088708261 := by
  have h0 := errBlockLin_of_piece (q0 := 1.015) (q1 := 1.0152) (m := vBP 1.034)
    (Lo := (-0.66131735)) (Hi := (-0.6582492)) (Klo := (-0.000014326563)) (Khi := (-0.000014318681))
    (by norm_num) (by norm_num) (by norm_num) errPt60
    vbpP60.1 vbpP60.2 vbpP61.1 vbpP61.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h1 := errBlockLin_of_piece (q0 := 1.0152) (q1 := 1.0155) (m := vBP 1.034)
    (Lo := (-0.65869665)) (Hi := (-0.65417538)) (Klo := (-0.000021191722)) (Khi := (-0.000021183842))
    (by norm_num) (by norm_num) (by norm_num) errPt61
    vbpP61.1 vbpP61.2 vbpP62.1 vbpP62.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h2 := errBlockLin_of_piece (q0 := 1.0155) (q1 := 1.0158) (m := vBP 1.034)
    (Lo := (-0.65468613)) (Hi := (-0.65016615)) (Klo := (-0.000020832681)) (Khi := (-0.000020824803))
    (by norm_num) (by norm_num) (by norm_num) errPt62
    vbpP62.1 vbpP62.2 vbpP63.1 vbpP63.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h3 := errBlockLin_of_piece (q0 := 1.0158) (q1 := 1.016) (m := vBP 1.034)
    (Lo := (-0.65062319)) (Hi := (-0.64755739)) (Klo := (-0.000013693956)) (Khi := (-0.00001368608))
    (by norm_num) (by norm_num) (by norm_num) errPt63
    vbpP63.1 vbpP63.2 vbpP64.1 vbpP64.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h4 := errBlockLin_of_piece (q0 := 1.016) (q1 := 1.0162) (m := vBP 1.034)
    (Lo := (-0.64795873)) (Hi := (-0.64489352)) (Klo := (-0.000013535054)) (Khi := (-0.000013527179))
    (by norm_num) (by norm_num) (by norm_num) errPt64
    vbpP64.1 vbpP64.2 vbpP65.1 vbpP65.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h5 := errBlockLin_of_piece (q0 := 1.0162) (q1 := 1.0165) (m := vBP 1.034)
    (Lo := (-0.64536009)) (Hi := (-0.64084306)) (Klo := (-0.000020005334)) (Khi := (-0.000019997462))
    (by norm_num) (by norm_num) (by norm_num) errPt65
    vbpP65.1 vbpP65.2 vbpP66.1 vbpP66.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h6 := errBlockLin_of_piece (q0 := 1.0165) (q1 := 1.0168) (m := vBP 1.034)
    (Lo := (-0.64137684)) (Hi := (-0.63686106)) (Klo := (-0.000019649314)) (Khi := (-0.000019641444))
    (by norm_num) (by norm_num) (by norm_num) errPt66
    vbpP66.1 vbpP66.2 vbpP67.1 vbpP67.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h7 := errBlockLin_of_piece (q0 := 1.0168) (q1 := 1.017) (m := vBP 1.034)
    (Lo := (-0.63733726)) (Hi := (-0.63427433)) (Klo := (-0.000012906279)) (Khi := (-0.000012898411))
    (by norm_num) (by norm_num) (by norm_num) errPt67
    vbpP67.1 vbpP67.2 vbpP68.1 vbpP68.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h8 := errBlockLin_of_piece (q0 := 1.017) (q1 := 1.0172) (m := vBP 1.034)
    (Lo := (-0.63469097)) (Hi := (-0.63162861)) (Klo := (-0.000012747842)) (Khi := (-0.000012739976))
    (by norm_num) (by norm_num) (by norm_num) errPt68
    vbpP68.1 vbpP68.2 vbpP69.1 vbpP69.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h9 := errBlockLin_of_piece (q0 := 1.0172) (q1 := 1.0175) (m := vBP 1.034)
    (Lo := (-0.63211439)) (Hi := (-0.62760146)) (Klo := (-0.000018824407)) (Khi := (-0.000018816543))
    (by norm_num) (by norm_num) (by norm_num) errPt69
    vbpP69.1 vbpP69.2 vbpP70.1 vbpP70.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h10 := errBlockLin_of_piece (q0 := 1.0175) (q1 := 1.0178) (m := vBP 1.034)
    (Lo := (-0.62815838)) (Hi := (-0.62364666)) (Klo := (-0.000018473363)) (Khi := (-0.0000184655))
    (by norm_num) (by norm_num) (by norm_num) errPt70
    vbpP70.1 vbpP70.2 vbpP71.1 vbpP71.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h11 := errBlockLin_of_piece (q0 := 1.0178) (q1 := 1.018) (m := vBP 1.034)
    (Lo := (-0.62414212)) (Hi := (-0.62108198)) (Klo := (-0.000012120922)) (Khi := (-0.000012113062))
    (by norm_num) (by norm_num) (by norm_num) errPt71
    vbpP71.1 vbpP71.2 vbpP72.1 vbpP72.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h12 := errBlockLin_of_piece (q0 := 1.018) (q1 := 1.0182) (m := vBP 1.034)
    (Lo := (-0.62151397)) (Hi := (-0.61845438)) (Klo := (-0.000011962949)) (Khi := (-0.000011955091))
    (by norm_num) (by norm_num) (by norm_num) errPt72
    vbpP72.1 vbpP72.2 vbpP73.1 vbpP73.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h13 := errBlockLin_of_piece (q0 := 1.0182) (q1 := 1.0185) (m := vBP 1.034)
    (Lo := (-0.61895945)) (Hi := (-0.61445051)) (Klo := (-0.000017652847)) (Khi := (-0.00001764499))
    (by norm_num) (by norm_num) (by norm_num) errPt73
    vbpP73.1 vbpP73.2 vbpP74.1 vbpP74.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h14 := errBlockLin_of_piece (q0 := 1.0185) (q1 := 1.0188) (m := vBP 1.034)
    (Lo := (-0.61503066)) (Hi := (-0.61052288)) (Klo := (-0.000017300874)) (Khi := (-0.000017293019))
    (by norm_num) (by norm_num) (by norm_num) errPt74
    vbpP74.1 vbpP74.2 vbpP75.1 vbpP75.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h15 := errBlockLin_of_piece (q0 := 1.0188) (q1 := 1.019) (m := vBP 1.034)
    (Lo := (-0.61103767)) (Hi := (-0.60798024)) (Klo := (-0.000011339837)) (Khi := (-0.000011331985))
    (by norm_num) (by norm_num) (by norm_num) errPt75
    vbpP75.1 vbpP75.2 vbpP76.1 vbpP76.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h16 := errBlockLin_of_piece (q0 := 1.019) (q1 := 1.0192) (m := vBP 1.034)
    (Lo := (-0.60842765)) (Hi := (-0.60537076)) (Klo := (-0.000011184289)) (Khi := (-0.000011176438))
    (by norm_num) (by norm_num) (by norm_num) errPt76
    vbpP76.1 vbpP76.2 vbpP77.1 vbpP77.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h17 := errBlockLin_of_piece (q0 := 1.0192) (q1 := 1.0195) (m := vBP 1.034)
    (Lo := (-0.6058952)) (Hi := (-0.6013901)) (Klo := (-0.000016484734)) (Khi := (-0.000016476885))
    (by norm_num) (by norm_num) (by norm_num) errPt77
    vbpP77.1 vbpP77.2 vbpP78.1 vbpP78.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h18 := errBlockLin_of_piece (q0 := 1.0195) (q1 := 1.0198) (m := vBP 1.034)
    (Lo := (-0.6019936)) (Hi := (-0.59748962)) (Klo := (-0.000016133793)) (Khi := (-0.000016125946))
    (by norm_num) (by norm_num) (by norm_num) errPt78
    vbpP78.1 vbpP78.2 vbpP79.1 vbpP79.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h19 := errBlockLin_of_piece (q0 := 1.0198) (q1 := 1.02) (m := vBP 1.034)
    (Lo := (-0.59802382)) (Hi := (-0.59496903)) (Klo := (-0.000010563009)) (Khi := (-0.000010555164))
    (by norm_num) (by norm_num) (by norm_num) errPt79
    vbpP79.1 vbpP79.2 vbpP80.1 vbpP80.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h20 := errBlockLin_of_piece (q0 := 1.02) (q1 := 1.0202) (m := vBP 1.034)
    (Lo := (-0.59543192)) (Hi := (-0.59237764)) (Klo := (-0.000010409877)) (Khi := (-0.000010402034))
    (by norm_num) (by norm_num) (by norm_num) errPt80
    vbpP80.1 vbpP80.2 vbpP81.1 vbpP81.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h21 := errBlockLin_of_piece (q0 := 1.0202) (q1 := 1.0205) (m := vBP 1.034)
    (Lo := (-0.59292155)) (Hi := (-0.58842015)) (Klo := (-0.000015320052)) (Khi := (-0.000015312211))
    (by norm_num) (by norm_num) (by norm_num) errPt81
    vbpP81.1 vbpP81.2 vbpP82.1 vbpP82.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h22 := errBlockLin_of_piece (q0 := 1.0205) (q1 := 1.0208) (m := vBP 1.034)
    (Lo := (-0.5890471)) (Hi := (-0.5845468)) (Klo := (-0.000014974058)) (Khi := (-0.000014966219))
    (by norm_num) (by norm_num) (by norm_num) errPt82
    vbpP82.1 vbpP82.2 vbpP83.1 vbpP83.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h23 := errBlockLin_of_piece (q0 := 1.0208) (q1 := 1.021) (m := vBP 1.034)
    (Lo := (-0.5851005)) (Hi := (-0.58204826)) (Klo := (-0.00000979042)) (Khi := (-0.000009782582))
    (by norm_num) (by norm_num) (by norm_num) errPt83
    vbpP83.1 vbpP83.2 vbpP84.1 vbpP84.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h24 := errBlockLin_of_piece (q0 := 1.021) (q1 := 1.0212) (m := vBP 1.034)
    (Lo := (-0.58252669)) (Hi := (-0.57947495)) (Klo := (-0.000009635783)) (Khi := (-0.000009627947))
    (by norm_num) (by norm_num) (by norm_num) errPt84
    vbpP84.1 vbpP84.2 vbpP85.1 vbpP85.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h25 := errBlockLin_of_piece (q0 := 1.0212) (q1 := 1.0215) (m := vBP 1.034)
    (Lo := (-0.5800384)) (Hi := (-0.57554059)) (Klo := (-0.000014164662)) (Khi := (-0.000014156828))
    (by norm_num) (by norm_num) (by norm_num) errPt85
    vbpP85.1 vbpP85.2 vbpP86.1 vbpP86.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h26 := errBlockLin_of_piece (q0 := 1.0215) (q1 := 1.0218) (m := vBP 1.034)
    (Lo := (-0.57619109)) (Hi := (-0.57169433)) (Klo := (-0.000013817727)) (Khi := (-0.000013809896))
    (by norm_num) (by norm_num) (by norm_num) errPt86
    vbpP86.1 vbpP86.2 vbpP87.1 vbpP87.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h27 := errBlockLin_of_piece (q0 := 1.0218) (q1 := 1.022) (m := vBP 1.034)
    (Lo := (-0.57226762)) (Hi := (-0.56921786)) (Klo := (-0.000009022055)) (Khi := (-0.000009014225))
    (by norm_num) (by norm_num) (by norm_num) errPt87
    vbpP87.1 vbpP87.2 vbpP88.1 vbpP88.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h28 := errBlockLin_of_piece (q0 := 1.022) (q1 := 1.0222) (m := vBP 1.034)
    (Lo := (-0.56971189)) (Hi := (-0.56666261)) (Klo := (-0.00000886787)) (Khi := (-0.000008860042))
    (by norm_num) (by norm_num) (by norm_num) errPt88
    vbpP88.1 vbpP88.2 vbpP89.1 vbpP89.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h29 := errBlockLin_of_piece (q0 := 1.0222) (q1 := 1.0225) (m := vBP 1.034)
    (Lo := (-0.56724568)) (Hi := (-0.56275132)) (Klo := (-0.00001301266)) (Khi := (-0.000013004834))
    (by norm_num) (by norm_num) (by norm_num) errPt89
    vbpP89.1 vbpP89.2 vbpP90.1 vbpP90.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  exact (((((((((((((((((((((((((((((h0.add h1).add h2).add h3).add h4).add h5).add h6).add h7).add h8).add h9).add h10).add h11).add h12).add h13).add h14).add h15).add h16).add h17).add h18).add h19).add h20).add h21).add h22).add h23).add h24).add h25).add h26).add h27).add h28).add h29).mono (by norm_num) (by norm_num) (by norm_num [mn4])
    (by norm_num [mx4]) (by norm_num)

theorem blkLo0_3 : errBlockLin (vBP 1.0225) (vBP 1.0365) (vBP 1.034) (-0.0127035276) (-0.0125158462) 0.0001201771 0.0001220263 0.0127035276 := by
  have h0 := errBlockLin_of_piece (q0 := 1.0225) (q1 := 1.0228) (m := vBP 1.034)
    (Lo := (-0.56342548)) (Hi := (-0.55893214)) (Klo := (-0.000012668696)) (Khi := (-0.000012660872))
    (by norm_num) (by norm_num) (by norm_num) errPt90
    vbpP90.1 vbpP90.2 vbpP91.1 vbpP91.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h1 := errBlockLin_of_piece (q0 := 1.0228) (q1 := 1.023) (m := vBP 1.034)
    (Lo := (-0.55952509)) (Hi := (-0.55647774)) (Klo := (-0.000008255942)) (Khi := (-0.00000824812))
    (by norm_num) (by norm_num) (by norm_num) errPt91
    vbpP91.1 vbpP91.2 vbpP92.1 vbpP92.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h2 := errBlockLin_of_piece (q0 := 1.023) (q1 := 1.0232) (m := vBP 1.034)
    (Lo := (-0.55698742)) (Hi := (-0.55394054)) (Klo := (-0.000008104162)) (Khi := (-0.000008096341))
    (by norm_num) (by norm_num) (by norm_num) errPt92
    vbpP92.1 vbpP92.2 vbpP93.1 vbpP93.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h3 := errBlockLin_of_piece (q0 := 1.0232) (q1 := 1.0235) (m := vBP 1.034)
    (Lo := (-0.55454331)) (Hi := (-0.55005228)) (Klo := (-0.000011867941)) (Khi := (-0.000011860122))
    (by norm_num) (by norm_num) (by norm_num) errPt93
    vbpP93.1 vbpP93.2 vbpP94.1 vbpP94.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h4 := errBlockLin_of_piece (q0 := 1.0235) (q1 := 1.024) (m := vBP 1.034)
    (Lo := (-0.55093368)) (Hi := (-0.54355524)) (Klo := (-0.000019015101)) (Khi := (-0.000019007285))
    (by norm_num) (by norm_num) (by norm_num) errPt94
    vbpP94.1 vbpP94.2 vbpP95.1 vbpP95.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h5 := errBlockLin_of_piece (q0 := 1.024) (q1 := 1.0245) (m := vBP 1.034)
    (Lo := (-0.54463393)) (Hi := (-0.537258)) (Klo := (-0.000018065356)) (Khi := (-0.000018057545))
    (by norm_num) (by norm_num) (by norm_num) errPt95
    vbpP95.1 vbpP95.2 vbpP96.1 vbpP96.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h6 := errBlockLin_of_piece (q0 := 1.0245) (q1 := 1.025) (m := vBP 1.034)
    (Lo := (-0.53835676)) (Hi := (-0.53098327)) (Klo := (-0.000017118953)) (Khi := (-0.000017111145))
    (by norm_num) (by norm_num) (by norm_num) errPt96
    vbpP96.1 vbpP96.2 vbpP97.1 vbpP97.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h7 := errBlockLin_of_piece (q0 := 1.025) (q1 := 1.0255) (m := vBP 1.034)
    (Lo := (-0.53210213)) (Hi := (-0.52473103)) (Klo := (-0.000016173934)) (Khi := (-0.00001616613))
    (by norm_num) (by norm_num) (by norm_num) errPt97
    vbpP97.1 vbpP97.2 vbpP98.1 vbpP98.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h8 := errBlockLin_of_piece (q0 := 1.0255) (q1 := 1.026) (m := vBP 1.034)
    (Lo := (-0.52587005)) (Hi := (-0.51850128)) (Klo := (-0.000015230297)) (Khi := (-0.000015222496))
    (by norm_num) (by norm_num) (by norm_num) errPt98
    vbpP98.1 vbpP98.2 vbpP99.1 vbpP99.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h9 := errBlockLin_of_piece (q0 := 1.026) (q1 := 1.0265) (m := vBP 1.034)
    (Lo := (-0.5196605)) (Hi := (-0.51229402)) (Klo := (-0.000014289986)) (Khi := (-0.00001428219))
    (by norm_num) (by norm_num) (by norm_num) errPt99
    vbpP99.1 vbpP99.2 vbpP100.1 vbpP100.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h10 := errBlockLin_of_piece (q0 := 1.0265) (q1 := 1.027) (m := vBP 1.034)
    (Lo := (-0.51347347)) (Hi := (-0.50610922)) (Klo := (-0.000013352997)) (Khi := (-0.000013345205))
    (by norm_num) (by norm_num) (by norm_num) errPt100
    vbpP100.1 vbpP100.2 vbpP101.1 vbpP101.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h11 := errBlockLin_of_piece (q0 := 1.027) (q1 := 1.0275) (m := vBP 1.034)
    (Lo := (-0.50730896)) (Hi := (-0.49994688)) (Klo := (-0.000012417376)) (Khi := (-0.000012409587))
    (by norm_num) (by norm_num) (by norm_num) errPt101
    vbpP101.1 vbpP101.2 vbpP102.1 vbpP102.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h12 := errBlockLin_of_piece (q0 := 1.0275) (q1 := 1.028) (m := vBP 1.034)
    (Lo := (-0.50116696)) (Hi := (-0.493807)) (Klo := (-0.000011485065)) (Khi := (-0.00001147728))
    (by norm_num) (by norm_num) (by norm_num) errPt102
    vbpP102.1 vbpP102.2 vbpP103.1 vbpP103.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h13 := errBlockLin_of_piece (q0 := 1.028) (q1 := 1.0285) (m := vBP 1.034)
    (Lo := (-0.49504745)) (Hi := (-0.48768956)) (Klo := (-0.000010552169)) (Khi := (-0.000010544388))
    (by norm_num) (by norm_num) (by norm_num) errPt103
    vbpP103.1 vbpP103.2 vbpP104.1 vbpP104.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h14 := errBlockLin_of_piece (q0 := 1.0285) (q1 := 1.029) (m := vBP 1.034)
    (Lo := (-0.48895043)) (Hi := (-0.48159456)) (Klo := (-0.000009622577)) (Khi := (-0.0000096148))
    (by norm_num) (by norm_num) (by norm_num) errPt104
    vbpP104.1 vbpP104.2 vbpP105.1 vbpP105.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h15 := errBlockLin_of_piece (q0 := 1.029) (q1 := 1.0295) (m := vBP 1.034)
    (Lo := (-0.48287589)) (Hi := (-0.47552198)) (Klo := (-0.000008696282)) (Khi := (-0.000008688509))
    (by norm_num) (by norm_num) (by norm_num) errPt105
    vbpP105.1 vbpP105.2 vbpP106.1 vbpP106.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h16 := errBlockLin_of_piece (q0 := 1.0295) (q1 := 1.03) (m := vBP 1.034)
    (Lo := (-0.47682382)) (Hi := (-0.46947182)) (Klo := (-0.000007773278)) (Khi := (-0.000007765508))
    (by norm_num) (by norm_num) (by norm_num) errPt106
    vbpP106.1 vbpP106.2 vbpP107.1 vbpP107.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h17 := errBlockLin_of_piece (q0 := 1.03) (q1 := 1.0305) (m := vBP 1.034)
    (Lo := (-0.47079421)) (Hi := (-0.46344408)) (Klo := (-0.000006849677)) (Khi := (-0.000006841911))
    (by norm_num) (by norm_num) (by norm_num) errPt107
    vbpP107.1 vbpP107.2 vbpP108.1 vbpP108.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h18 := errBlockLin_of_piece (q0 := 1.0305) (q1 := 1.031) (m := vBP 1.034)
    (Lo := (-0.46478706)) (Hi := (-0.45743873)) (Klo := (-0.000005931299)) (Khi := (-0.000005923536))
    (by norm_num) (by norm_num) (by norm_num) errPt108
    vbpP108.1 vbpP108.2 vbpP109.1 vbpP109.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h19 := errBlockLin_of_piece (q0 := 1.031) (q1 := 1.0315) (m := vBP 1.034)
    (Lo := (-0.45880235)) (Hi := (-0.45145578)) (Klo := (-0.000005012317)) (Khi := (-0.000005004559))
    (by norm_num) (by norm_num) (by norm_num) errPt109
    vbpP109.1 vbpP109.2 vbpP110.1 vbpP110.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h20 := errBlockLin_of_piece (q0 := 1.0315) (q1 := 1.032) (m := vBP 1.034)
    (Lo := (-0.45284007)) (Hi := (-0.44549522)) (Klo := (-0.000004096609)) (Khi := (-0.000004088855))
    (by norm_num) (by norm_num) (by norm_num) errPt110
    vbpP110.1 vbpP110.2 vbpP111.1 vbpP111.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h21 := errBlockLin_of_piece (q0 := 1.032) (q1 := 1.0325) (m := vBP 1.034)
    (Lo := (-0.44690023)) (Hi := (-0.43955703)) (Klo := (-0.000003182232)) (Khi := (-0.000003174481))
    (by norm_num) (by norm_num) (by norm_num) errPt111
    vbpP111.1 vbpP111.2 vbpP112.1 vbpP112.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h22 := errBlockLin_of_piece (q0 := 1.0325) (q1 := 1.033) (m := vBP 1.034)
    (Lo := (-0.4409828)) (Hi := (-0.43364122)) (Klo := (-0.000002273055)) (Khi := (-0.000002265307))
    (by norm_num) (by norm_num) (by norm_num) errPt112
    vbpP112.1 vbpP112.2 vbpP113.1 vbpP113.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h23 := errBlockLin_of_piece (q0 := 1.033) (q1 := 1.0335) (m := vBP 1.034)
    (Lo := (-0.43508779)) (Hi := (-0.42774776)) (Klo := (-0.000001363262)) (Khi := (-0.000001355518))
    (by norm_num) (by norm_num) (by norm_num) errPt113
    vbpP113.1 vbpP113.2 vbpP114.1 vbpP114.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h24 := errBlockLin_of_piece (q0 := 1.0335) (q1 := 1.034) (m := vBP 1.034)
    (Lo := (-0.42921518)) (Hi := (-0.42187666)) (Klo := (-0.000000456723)) (Khi := (-0.000000448983))
    (by norm_num) (by norm_num) (by norm_num) errPt114
    vbpP114.1 vbpP114.2 vbpP115.1 vbpP115.2 vbpP115.1 vbpP115.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h25 := errBlockLin_of_piece (q0 := 1.034) (q1 := 1.0345) (m := vBP 1.034)
    (Lo := (-0.42336497)) (Hi := (-0.41602791)) (Klo := 0.000000448502) (Khi := 0.000000456238)
    (by norm_num) (by norm_num) (by norm_num) errPt115
    vbpP115.1 vbpP115.2 vbpP116.1 vbpP116.2 vbpP115.1 vbpP115.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h26 := errBlockLin_of_piece (q0 := 1.0345) (q1 := 1.035) (m := vBP 1.034)
    (Lo := (-0.41753714)) (Hi := (-0.4102015)) (Klo := 0.000001350482) (Khi := 0.000001358215)
    (by norm_num) (by norm_num) (by norm_num) errPt116
    vbpP116.1 vbpP116.2 vbpP117.1 vbpP117.2 vbpP115.1 vbpP115.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h27 := errBlockLin_of_piece (q0 := 1.035) (q1 := 1.0355) (m := vBP 1.034)
    (Lo := (-0.4117317)) (Hi := (-0.40439742)) (Klo := 0.000002251156) (Khi := 0.000002258885)
    (by norm_num) (by norm_num) (by norm_num) errPt117
    vbpP117.1 vbpP117.2 vbpP118.1 vbpP118.2 vbpP115.1 vbpP115.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h28 := errBlockLin_of_piece (q0 := 1.0355) (q1 := 1.036) (m := vBP 1.034)
    (Lo := (-0.40594862)) (Hi := (-0.39861566)) (Klo := 0.000003148595) (Khi := 0.00000315632)
    (by norm_num) (by norm_num) (by norm_num) errPt118
    vbpP118.1 vbpP118.2 vbpP119.1 vbpP119.2 vbpP115.1 vbpP115.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h29 := errBlockLin_of_piece (q0 := 1.036) (q1 := 1.0365) (m := vBP 1.034)
    (Lo := (-0.40018792)) (Hi := (-0.39285622)) (Klo := 0.000004044735) (Khi := 0.000004052457)
    (by norm_num) (by norm_num) (by norm_num) errPt119
    vbpP119.1 vbpP119.2 vbpP120.1 vbpP120.2 vbpP115.1 vbpP115.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  exact (((((((((((((((((((((((((((((h0.add h1).add h2).add h3).add h4).add h5).add h6).add h7).add h8).add h9).add h10).add h11).add h12).add h13).add h14).add h15).add h16).add h17).add h18).add h19).add h20).add h21).add h22).add h23).add h24).add h25).add h26).add h27).add h28).add h29).mono (by norm_num) (by norm_num) (by norm_num [mn4])
    (by norm_num [mx4]) (by norm_num)

theorem blkLo0_4 : errBlockLin (vBP 1.0365) (vBP 1.056) (vBP 1.034) (-0.0104524192) (-0.0100747569) (-0.0002224561) (-0.0002123626) 0.0104524192 := by
  have h0 := errBlockLin_of_piece (q0 := 1.0365) (q1 := 1.037) (m := vBP 1.034)
    (Lo := (-0.39444956)) (Hi := (-0.38711909)) (Klo := 0.000004937651) (Khi := 0.000004945368)
    (by norm_num) (by norm_num) (by norm_num) errPt120
    vbpP120.1 vbpP120.2 vbpP121.1 vbpP121.2 vbpP115.1 vbpP115.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h1 := errBlockLin_of_piece (q0 := 1.037) (q1 := 1.0375) (m := vBP 1.034)
    (Lo := (-0.38873356)) (Hi := (-0.38140427)) (Klo := 0.000005829275) (Khi := 0.000005836989)
    (by norm_num) (by norm_num) (by norm_num) errPt121
    vbpP121.1 vbpP121.2 vbpP122.1 vbpP122.2 vbpP115.1 vbpP115.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h2 := errBlockLin_of_piece (q0 := 1.0375) (q1 := 1.038) (m := vBP 1.034)
    (Lo := (-0.3830399)) (Hi := (-0.37571173)) (Klo := 0.000006719611) (Khi := 0.000006727321)
    (by norm_num) (by norm_num) (by norm_num) errPt122
    vbpP122.1 vbpP122.2 vbpP123.1 vbpP123.2 vbpP115.1 vbpP115.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h3 := errBlockLin_of_piece (q0 := 1.038) (q1 := 1.0385) (m := vBP 1.034)
    (Lo := (-0.37736857)) (Hi := (-0.37004149)) (Klo := 0.000007606736) (Khi := 0.000007614442)
    (by norm_num) (by norm_num) (by norm_num) errPt123
    vbpP123.1 vbpP123.2 vbpP124.1 vbpP124.2 vbpP115.1 vbpP115.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h4 := errBlockLin_of_piece (q0 := 1.0385) (q1 := 1.039) (m := vBP 1.034)
    (Lo := (-0.37171957)) (Hi := (-0.36439352)) (Klo := 0.000008490654) (Khi := 0.000008498357)
    (by norm_num) (by norm_num) (by norm_num) errPt124
    vbpP124.1 vbpP124.2 vbpP125.1 vbpP125.2 vbpP115.1 vbpP115.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h5 := errBlockLin_of_piece (q0 := 1.039) (q1 := 1.0395) (m := vBP 1.034)
    (Lo := (-0.36609289)) (Hi := (-0.35876783)) (Klo := 0.000009375221) (Khi := 0.00000938292)
    (by norm_num) (by norm_num) (by norm_num) errPt125
    vbpP125.1 vbpP125.2 vbpP126.1 vbpP126.2 vbpP115.1 vbpP115.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h6 := errBlockLin_of_piece (q0 := 1.0395) (q1 := 1.04) (m := vBP 1.034)
    (Lo := (-0.36048851)) (Hi := (-0.35316441)) (Klo := 0.000010254666) (Khi := 0.000010262361)
    (by norm_num) (by norm_num) (by norm_num) errPt126
    vbpP126.1 vbpP126.2 vbpP127.1 vbpP127.2 vbpP115.1 vbpP115.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h7 := errBlockLin_of_piece (q0 := 1.04) (q1 := 1.0405) (m := vBP 1.034)
    (Lo := (-0.35490645)) (Hi := (-0.34758324)) (Klo := 0.000011134766) (Khi := 0.000011142457)
    (by norm_num) (by norm_num) (by norm_num) errPt127
    vbpP127.1 vbpP127.2 vbpP128.1 vbpP128.2 vbpP115.1 vbpP115.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h8 := errBlockLin_of_piece (q0 := 1.0405) (q1 := 1.041) (m := vBP 1.034)
    (Lo := (-0.34934668)) (Hi := (-0.34202433)) (Klo := 0.000012009754) (Khi := 0.000012017442)
    (by norm_num) (by norm_num) (by norm_num) errPt128
    vbpP128.1 vbpP128.2 vbpP129.1 vbpP129.2 vbpP115.1 vbpP115.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h9 := errBlockLin_of_piece (q0 := 1.041) (q1 := 1.0415) (m := vBP 1.034)
    (Lo := (-0.3438092)) (Hi := (-0.33648766)) (Klo := 0.000012885403) (Khi := 0.000012893087)
    (by norm_num) (by norm_num) (by norm_num) errPt129
    vbpP129.1 vbpP129.2 vbpP130.1 vbpP130.2 vbpP115.1 vbpP115.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h10 := errBlockLin_of_piece (q0 := 1.0415) (q1 := 1.042) (m := vBP 1.034)
    (Lo := (-0.338294)) (Hi := (-0.33097324)) (Klo := 0.000013757872) (Khi := 0.000013765553)
    (by norm_num) (by norm_num) (by norm_num) errPt130
    vbpP130.1 vbpP130.2 vbpP131.1 vbpP131.2 vbpP115.1 vbpP115.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h11 := errBlockLin_of_piece (q0 := 1.042) (q1 := 1.0425) (m := vBP 1.034)
    (Lo := (-0.33280108)) (Hi := (-0.32548104)) (Klo := 0.000014627167) (Khi := 0.000014634844)
    (by norm_num) (by norm_num) (by norm_num) errPt131
    vbpP131.1 vbpP131.2 vbpP132.1 vbpP132.2 vbpP115.1 vbpP115.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h12 := errBlockLin_of_piece (q0 := 1.0425) (q1 := 1.043) (m := vBP 1.034)
    (Lo := (-0.32733042)) (Hi := (-0.32001107)) (Klo := 0.000015495212) (Khi := 0.000015502885)
    (by norm_num) (by norm_num) (by norm_num) errPt132
    vbpP132.1 vbpP132.2 vbpP133.1 vbpP133.2 vbpP115.1 vbpP115.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h13 := errBlockLin_of_piece (q0 := 1.043) (q1 := 1.0435) (m := vBP 1.034)
    (Lo := (-0.32188203)) (Hi := (-0.31456331)) (Klo := 0.000016362009) (Khi := 0.000016369679)
    (by norm_num) (by norm_num) (by norm_num) errPt133
    vbpP133.1 vbpP133.2 vbpP134.1 vbpP134.2 vbpP115.1 vbpP115.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h14 := errBlockLin_of_piece (q0 := 1.0435) (q1 := 1.044) (m := vBP 1.034)
    (Lo := (-0.31645589)) (Hi := (-0.30913777)) (Klo := 0.000017227561) (Khi := 0.000017235227)
    (by norm_num) (by norm_num) (by norm_num) errPt134
    vbpP134.1 vbpP134.2 vbpP135.1 vbpP135.2 vbpP115.1 vbpP115.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h15 := errBlockLin_of_piece (q0 := 1.044) (q1 := 1.0445) (m := vBP 1.034)
    (Lo := (-0.311052)) (Hi := (-0.30373443)) (Klo := 0.000018086126) (Khi := 0.000018093788)
    (by norm_num) (by norm_num) (by norm_num) errPt135
    vbpP135.1 vbpP135.2 vbpP136.1 vbpP136.2 vbpP115.1 vbpP115.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h16 := errBlockLin_of_piece (q0 := 1.0445) (q1 := 1.045) (m := vBP 1.034)
    (Lo := (-0.30567035)) (Hi := (-0.29835329)) (Klo := 0.000018949199) (Khi := 0.000018956858)
    (by norm_num) (by norm_num) (by norm_num) errPt136
    vbpP136.1 vbpP136.2 vbpP137.1 vbpP137.2 vbpP115.1 vbpP115.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h17 := errBlockLin_of_piece (q0 := 1.045) (q1 := 1.0455) (m := vBP 1.034)
    (Lo := (-0.30031093)) (Hi := (-0.29299434)) (Klo := 0.000019805296) (Khi := 0.000019812951)
    (by norm_num) (by norm_num) (by norm_num) errPt137
    vbpP137.1 vbpP137.2 vbpP138.1 vbpP138.2 vbpP115.1 vbpP115.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h18 := errBlockLin_of_piece (q0 := 1.0455) (q1 := 1.046) (m := vBP 1.034)
    (Lo := (-0.29497373)) (Hi := (-0.28765758)) (Klo := 0.000020660165) (Khi := 0.000020667816)
    (by norm_num) (by norm_num) (by norm_num) errPt138
    vbpP138.1 vbpP138.2 vbpP139.1 vbpP139.2 vbpP115.1 vbpP115.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h19 := errBlockLin_of_piece (q0 := 1.046) (q1 := 1.0465) (m := vBP 1.034)
    (Lo := (-0.28965876)) (Hi := (-0.28234299)) (Klo := 0.000021515719) (Khi := 0.000021523367)
    (by norm_num) (by norm_num) (by norm_num) errPt139
    vbpP139.1 vbpP139.2 vbpP140.1 vbpP140.2 vbpP115.1 vbpP115.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h20 := errBlockLin_of_piece (q0 := 1.0465) (q1 := 1.047) (m := vBP 1.034)
    (Lo := (-0.284366)) (Hi := (-0.27705058)) (Klo := 0.000022366228) (Khi := 0.000022373871)
    (by norm_num) (by norm_num) (by norm_num) errPt140
    vbpP140.1 vbpP140.2 vbpP141.1 vbpP141.2 vbpP115.1 vbpP115.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h21 := errBlockLin_of_piece (q0 := 1.047) (q1 := 1.048) (m := vBP 1.034)
    (Lo := (-0.28006376)) (Hi := (-0.26557236)) (Klo := 0.000047282931) (Khi := 0.000047290569)
    (by norm_num) (by norm_num) (by norm_num) errPt141
    vbpP141.1 vbpP141.2 vbpP142.1 vbpP142.2 vbpP115.1 vbpP115.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h22 := errBlockLin_of_piece (q0 := 1.048) (q1 := 1.049) (m := vBP 1.034)
    (Lo := (-0.26961169)) (Hi := (-0.25512015)) (Klo := 0.000050664656) (Khi := 0.000050672287)
    (by norm_num) (by norm_num) (by norm_num) errPt142
    vbpP142.1 vbpP142.2 vbpP143.1 vbpP143.2 vbpP115.1 vbpP115.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h23 := errBlockLin_of_piece (q0 := 1.049) (q1 := 1.05) (m := vBP 1.034)
    (Lo := (-0.25924842)) (Hi := (-0.24475642)) (Klo := 0.000054029101) (Khi := 0.000054036725)
    (by norm_num) (by norm_num) (by norm_num) errPt143
    vbpP143.1 vbpP143.2 vbpP144.1 vbpP144.2 vbpP115.1 vbpP115.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h24 := errBlockLin_of_piece (q0 := 1.05) (q1 := 1.051) (m := vBP 1.034)
    (Lo := (-0.24897392)) (Hi := (-0.23448112)) (Klo := 0.000057380136) (Khi := 0.000057387753)
    (by norm_num) (by norm_num) (by norm_num) errPt144
    vbpP144.1 vbpP144.2 vbpP145.1 vbpP145.2 vbpP115.1 vbpP115.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h25 := errBlockLin_of_piece (q0 := 1.051) (q1 := 1.052) (m := vBP 1.034)
    (Lo := (-0.23878811)) (Hi := (-0.22429419)) (Klo := 0.00006071211) (Khi := 0.000060719719)
    (by norm_num) (by norm_num) (by norm_num) errPt145
    vbpP145.1 vbpP145.2 vbpP146.1 vbpP146.2 vbpP115.1 vbpP115.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h26 := errBlockLin_of_piece (q0 := 1.052) (q1 := 1.053) (m := vBP 1.034)
    (Lo := (-0.22869095)) (Hi := (-0.21419559)) (Klo := 0.000064028892) (Khi := 0.000064036494)
    (by norm_num) (by norm_num) (by norm_num) errPt146
    vbpP146.1 vbpP146.2 vbpP147.1 vbpP147.2 vbpP115.1 vbpP115.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h27 := errBlockLin_of_piece (q0 := 1.053) (q1 := 1.054) (m := vBP 1.034)
    (Lo := (-0.21868238)) (Hi := (-0.20418527)) (Klo := 0.000067330541) (Khi := 0.000067338136)
    (by norm_num) (by norm_num) (by norm_num) errPt147
    vbpP147.1 vbpP147.2 vbpP148.1 vbpP148.2 vbpP115.1 vbpP115.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h28 := errBlockLin_of_piece (q0 := 1.054) (q1 := 1.055) (m := vBP 1.034)
    (Lo := (-0.20876234)) (Hi := (-0.19426317)) (Klo := 0.000070617115) (Khi := 0.000070624703)
    (by norm_num) (by norm_num) (by norm_num) errPt148
    vbpP148.1 vbpP148.2 vbpP149.1 vbpP149.2 vbpP115.1 vbpP115.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h29 := errBlockLin_of_piece (q0 := 1.055) (q1 := 1.056) (m := vBP 1.034)
    (Lo := (-0.19893078)) (Hi := (-0.18442925)) (Klo := 0.000073884882) (Khi := 0.000073892462)
    (by norm_num) (by norm_num) (by norm_num) errPt149
    vbpP149.1 vbpP149.2 vbpP150.1 vbpP150.2 vbpP115.1 vbpP115.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  exact (((((((((((((((((((((((((((((h0.add h1).add h2).add h3).add h4).add h5).add h6).add h7).add h8).add h9).add h10).add h11).add h12).add h13).add h14).add h15).add h16).add h17).add h18).add h19).add h20).add h21).add h22).add h23).add h24).add h25).add h26).add h27).add h28).add h29).mono (by norm_num) (by norm_num) (by norm_num [mn4])
    (by norm_num [mx4]) (by norm_num)

theorem blkLo0_5 : errBlockLin (vBP 1.056) (vBP 1.069) (vBP 1.034) (-0.0031497883) (-0.0026626143) (-0.0001659343) (-0.0001387346) 0.0031497883 := by
  have h0 := errBlockLin_of_piece (q0 := 1.056) (q1 := 1.057) (m := vBP 1.034)
    (Lo := (-0.18918763)) (Hi := (-0.17468345)) (Klo := 0.00007713959) (Khi := 0.000077147163)
    (by norm_num) (by norm_num) (by norm_num) errPt150
    vbpP150.1 vbpP150.2 vbpP151.1 vbpP151.2 vbpP115.1 vbpP115.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h1 := errBlockLin_of_piece (q0 := 1.057) (q1 := 1.058) (m := vBP 1.034)
    (Lo := (-0.17953285)) (Hi := (-0.16502572)) (Klo := 0.000080377508) (Khi := 0.000080385074)
    (by norm_num) (by norm_num) (by norm_num) errPt151
    vbpP151.1 vbpP151.2 vbpP152.1 vbpP152.2 vbpP115.1 vbpP115.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h2 := errBlockLin_of_piece (q0 := 1.058) (q1 := 1.059) (m := vBP 1.034)
    (Lo := (-0.16996637)) (Hi := (-0.15545602)) (Klo := 0.000083598699) (Khi := 0.000083606258)
    (by norm_num) (by norm_num) (by norm_num) errPt152
    vbpP152.1 vbpP152.2 vbpP153.1 vbpP153.2 vbpP115.1 vbpP115.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h3 := errBlockLin_of_piece (q0 := 1.059) (q1 := 1.06) (m := vBP 1.034)
    (Lo := (-0.16048813)) (Hi := (-0.14597428)) (Klo := 0.000086807) (Khi := 0.000086814551)
    (by norm_num) (by norm_num) (by norm_num) errPt153
    vbpP153.1 vbpP153.2 vbpP154.1 vbpP154.2 vbpP115.1 vbpP115.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h4 := errBlockLin_of_piece (q0 := 1.06) (q1 := 1.061) (m := vBP 1.034)
    (Lo := (-0.15109809)) (Hi := (-0.13658045)) (Klo := 0.000089998689) (Khi := 0.000090006233)
    (by norm_num) (by norm_num) (by norm_num) errPt154
    vbpP154.1 vbpP154.2 vbpP155.1 vbpP155.2 vbpP115.1 vbpP115.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h5 := errBlockLin_of_piece (q0 := 1.061) (q1 := 1.062) (m := vBP 1.034)
    (Lo := (-0.14179618)) (Hi := (-0.12727449)) (Klo := 0.000093175712) (Khi := 0.00009318325)
    (by norm_num) (by norm_num) (by norm_num) errPt155
    vbpP155.1 vbpP155.2 vbpP156.1 vbpP156.2 vbpP115.1 vbpP115.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h6 := errBlockLin_of_piece (q0 := 1.062) (q1 := 1.064) (m := vBP 1.034)
    (Lo := (-0.13523835)) (Hi := (-0.1063019)) (Klo := 0.000195822232) (Khi := 0.000195829759)
    (by norm_num) (by norm_num) (by norm_num) errPt156
    vbpP156.1 vbpP156.2 vbpP157.1 vbpP157.2 vbpP115.1 vbpP115.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h7 := errBlockLin_of_piece (q0 := 1.064) (q1 := 1.066) (m := vBP 1.034)
    (Lo := (-0.11716846)) (Hi := (-0.08821002)) (Klo := 0.000208344468) (Khi := 0.00020835198)
    (by norm_num) (by norm_num) (by norm_num) errPt157
    vbpP157.1 vbpP157.2 vbpP158.1 vbpP158.2 vbpP115.1 vbpP115.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h8 := errBlockLin_of_piece (q0 := 1.066) (q1 := 1.068) (m := vBP 1.034)
    (Lo := (-0.09945051)) (Hi := (-0.07046808)) (Klo := 0.000220747665) (Khi := 0.000220755163)
    (by norm_num) (by norm_num) (by norm_num) errPt158
    vbpP158.1 vbpP158.2 vbpP159.1 vbpP159.2 vbpP115.1 vbpP115.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h9 := errBlockLin_of_piece (q0 := 1.068) (q1 := 1.069) (m := vBP 1.034)
    (Lo := (-0.07914534)) (Hi := (-0.06458829)) (Klo := 0.000114986437) (Khi := 0.000114993925)
    (by norm_num) (by norm_num) (by norm_num) errPt159
    vbpP159.1 vbpP159.2 vbpP160.1 vbpP160.2 vbpP115.1 vbpP115.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  exact (((((((((h0.add h1).add h2).add h3).add h4).add h5).add h6).add h7).add h8).add h9).mono (by norm_num) (by norm_num) (by norm_num [mn4])
    (by norm_num [mx4]) (by norm_num)

theorem blkLo0 : errBlockLin (vBP 1) (vBP 1.069) (vBP 1.034) (-0.0578656349) (-0.056638882) 0.0011850242 0.001232478 0.0578656349 :=
  errBlockLin.mono (errBlockLin.add (errBlockLin.add (errBlockLin.add (errBlockLin.add (errBlockLin.add blkLo0_0 blkLo0_1) blkLo0_2) blkLo0_3) blkLo0_4) blkLo0_5) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
    (by norm_num)

theorem blkLo1_0 : errBlockLin (vBP 1.069) (vBP 1.114) (vBP 1.107) 0.0060749872 0.0082371354 (-0.000094547) (-0.0000082619) 0.0091791438 := by
  have h0 := errBlockLin_of_piece (q0 := 1.069) (q1 := 1.072) (m := vBP 1.107)
    (Lo := (-0.07656024)) (Hi := (-0.03307158)) (Klo := (-0.000351106976)) (Khi := (-0.000351099501))
    (by norm_num) (by norm_num) (by norm_num) errPt160
    vbpP160.1 vbpP160.2 vbpP161.1 vbpP161.2 vbpP183.1 vbpP183.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h1 := errBlockLin_of_piece (q0 := 1.072) (q1 := 1.074) (m := vBP 1.107)
    (Lo := (-0.04840298)) (Hi := (-0.01933743)) (Klo := (-0.000216768695)) (Khi := (-0.000216761239))
    (by norm_num) (by norm_num) (by norm_num) errPt161
    vbpP161.1 vbpP161.2 vbpP162.1 vbpP162.2 vbpP183.1 vbpP183.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h2 := errBlockLin_of_piece (q0 := 1.074) (q1 := 1.078) (m := vBP 1.107)
    (Lo := (-0.03866122)) (Hi := 0.01946293) (Klo := (-0.000392564098)) (Khi := (-0.000392556662))
    (by norm_num) (by norm_num) (by norm_num) errPt162
    vbpP162.1 vbpP162.2 vbpP163.1 vbpP163.2 vbpP183.1 vbpP183.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h3 := errBlockLin_of_piece (q0 := 1.078) (q1 := 1.08) (m := vBP 1.107)
    (Lo := (-0.00050288)) (Hi := 0.02866055) (Klo := (-0.000176049008)) (Khi := (-0.000176041592))
    (by norm_num) (by norm_num) (by norm_num) errPt163
    vbpP163.1 vbpP163.2 vbpP164.1 vbpP164.2 vbpP183.1 vbpP183.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h4 := errBlockLin_of_piece (q0 := 1.08) (q1 := 1.083) (m := vBP 1.107)
    (Lo := 0.01121346) (Hi := 0.05497906) (Klo := (-0.00023911658)) (Khi := (-0.000239109182))
    (by norm_num) (by norm_num) (by norm_num) errPt164
    vbpP164.1 vbpP164.2 vbpP165.1 vbpP165.2 vbpP183.1 vbpP183.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h5 := errBlockLin_of_piece (q0 := 1.083) (q1 := 1.086) (m := vBP 1.107)
    (Lo := 0.03332355) (Hi := 0.07717559) (Klo := (-0.000209532152)) (Khi := (-0.000209524775))
    (by norm_num) (by norm_num) (by norm_num) errPt165
    vbpP165.1 vbpP165.2 vbpP166.1 vbpP166.2 vbpP183.1 vbpP183.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h6 := errBlockLin_of_piece (q0 := 1.086) (q1 := 1.088) (m := vBP 1.107)
    (Lo := 0.05849752) (Hi := 0.08781008) (Klo := (-0.000123449959)) (Khi := (-0.000123442598))
    (by norm_num) (by norm_num) (by norm_num) errPt166
    vbpP166.1 vbpP166.2 vbpP167.1 vbpP167.2 vbpP183.1 vbpP183.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h7 := errBlockLin_of_piece (q0 := 1.088) (q1 := 1.09) (m := vBP 1.107)
    (Lo := 0.07238334) (Hi := 0.10173589) (Klo := (-0.000110598773)) (Khi := (-0.000110591426))
    (by norm_num) (by norm_num) (by norm_num) errPt167
    vbpP167.1 vbpP167.2 vbpP168.1 vbpP168.2 vbpP183.1 vbpP183.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h8 := errBlockLin_of_piece (q0 := 1.09) (q1 := 1.092) (m := vBP 1.107)
    (Lo := 0.085925) (Hi := 0.11531843) (Klo := (-0.000097860322)) (Khi := (-0.000097852989))
    (by norm_num) (by norm_num) (by norm_num) errPt168
    vbpP168.1 vbpP168.2 vbpP169.1 vbpP169.2 vbpP183.1 vbpP183.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h9 := errBlockLin_of_piece (q0 := 1.092) (q1 := 1.094) (m := vBP 1.107)
    (Lo := 0.09912334) (Hi := 0.12855845) (Klo := (-0.000085237439)) (Khi := (-0.000085230119))
    (by norm_num) (by norm_num) (by norm_num) errPt169
    vbpP169.1 vbpP169.2 vbpP170.1 vbpP170.2 vbpP183.1 vbpP183.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h10 := errBlockLin_of_piece (q0 := 1.094) (q1 := 1.095) (m := vBP 1.107)
    (Lo := 0.11616738) (Hi := 0.13093618) (Klo := (-0.000037923878)) (Khi := (-0.000037916567))
    (by norm_num) (by norm_num) (by norm_num) errPt170
    vbpP170.1 vbpP170.2 vbpP171.1 vbpP171.2 vbpP183.1 vbpP183.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h11 := errBlockLin_of_piece (q0 := 1.095) (q1 := 1.096) (m := vBP 1.107)
    (Lo := 0.12251549) (Hi := 0.13729409) (Klo := (-0.000034810881)) (Khi := (-0.000034803577))
    (by norm_num) (by norm_num) (by norm_num) errPt171
    vbpP171.1 vbpP171.2 vbpP172.1 vbpP172.2 vbpP183.1 vbpP183.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h12 := errBlockLin_of_piece (q0 := 1.096) (q1 := 1.097) (m := vBP 1.107)
    (Lo := 0.1287783) (Hi := 0.14356678) (Klo := (-0.000031710044)) (Khi := (-0.000031702747))
    (by norm_num) (by norm_num) (by norm_num) errPt172
    vbpP172.1 vbpP172.2 vbpP173.1 vbpP173.2 vbpP183.1 vbpP183.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h13 := errBlockLin_of_piece (q0 := 1.097) (q1 := 1.098) (m := vBP 1.107)
    (Lo := 0.13495594) (Hi := 0.14975437) (Klo := (-0.000028626787)) (Khi := (-0.000028619497))
    (by norm_num) (by norm_num) (by norm_num) errPt173
    vbpP173.1 vbpP173.2 vbpP174.1 vbpP174.2 vbpP183.1 vbpP183.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h14 := errBlockLin_of_piece (q0 := 1.098) (q1 := 1.099) (m := vBP 1.107)
    (Lo := 0.14104853) (Hi := 0.15585697) (Klo := (-0.000025553766)) (Khi := (-0.000025546482))
    (by norm_num) (by norm_num) (by norm_num) errPt174
    vbpP174.1 vbpP174.2 vbpP175.1 vbpP175.2 vbpP183.1 vbpP183.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h15 := errBlockLin_of_piece (q0 := 1.099) (q1 := 1.1) (m := vBP 1.107)
    (Lo := 0.14705619) (Hi := 0.16187468) (Klo := (-0.000022498217)) (Khi := (-0.00002249094))
    (by norm_num) (by norm_num) (by norm_num) errPt175
    vbpP175.1 vbpP175.2 vbpP176.1 vbpP176.2 vbpP183.1 vbpP183.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h16 := errBlockLin_of_piece (q0 := 1.1) (q1 := 1.101) (m := vBP 1.107)
    (Lo := 0.15297904) (Hi := 0.16780764) (Klo := (-0.000019454627)) (Khi := (-0.000019447356))
    (by norm_num) (by norm_num) (by norm_num) errPt176
    vbpP176.1 vbpP176.2 vbpP177.1 vbpP177.2 vbpP183.1 vbpP183.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h17 := errBlockLin_of_piece (q0 := 1.101) (q1 := 1.102) (m := vBP 1.107)
    (Lo := 0.15881722) (Hi := 0.17365596) (Klo := (-0.000016424767)) (Khi := (-0.000016417503))
    (by norm_num) (by norm_num) (by norm_num) errPt177
    vbpP177.1 vbpP177.2 vbpP178.1 vbpP178.2 vbpP183.1 vbpP183.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h18 := errBlockLin_of_piece (q0 := 1.102) (q1 := 1.103) (m := vBP 1.107)
    (Lo := 0.16457084) (Hi := 0.17941977) (Klo := (-0.000013408588)) (Khi := (-0.00001340133))
    (by norm_num) (by norm_num) (by norm_num) errPt178
    vbpP178.1 vbpP178.2 vbpP179.1 vbpP179.2 vbpP183.1 vbpP183.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h19 := errBlockLin_of_piece (q0 := 1.103) (q1 := 1.104) (m := vBP 1.107)
    (Lo := 0.17024004) (Hi := 0.18509918) (Klo := (-0.000010406039)) (Khi := (-0.000010398788))
    (by norm_num) (by norm_num) (by norm_num) errPt179
    vbpP179.1 vbpP179.2 vbpP180.1 vbpP180.2 vbpP183.1 vbpP183.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h20 := errBlockLin_of_piece (q0 := 1.104) (q1 := 1.105) (m := vBP 1.107)
    (Lo := 0.17582496) (Hi := 0.19069435) (Klo := (-0.000007417072)) (Khi := (-0.000007409828))
    (by norm_num) (by norm_num) (by norm_num) errPt180
    vbpP180.1 vbpP180.2 vbpP181.1 vbpP181.2 vbpP183.1 vbpP183.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h21 := errBlockLin_of_piece (q0 := 1.105) (q1 := 1.106) (m := vBP 1.107)
    (Lo := 0.18132573) (Hi := 0.19620538) (Klo := (-0.000004443446)) (Khi := (-0.000004436208))
    (by norm_num) (by norm_num) (by norm_num) errPt181
    vbpP181.1 vbpP181.2 vbpP182.1 vbpP182.2 vbpP183.1 vbpP183.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h22 := errBlockLin_of_piece (q0 := 1.106) (q1 := 1.107) (m := vBP 1.107)
    (Lo := 0.1867425) (Hi := 0.20163243) (Klo := (-0.000001479685)) (Khi := (-0.000001472454))
    (by norm_num) (by norm_num) (by norm_num) errPt182
    vbpP182.1 vbpP182.2 vbpP183.1 vbpP183.2 vbpP183.1 vbpP183.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h23 := errBlockLin_of_piece (q0 := 1.107) (q1 := 1.108) (m := vBP 1.107)
    (Lo := 0.19207541) (Hi := 0.20697563) (Klo := 0.000001468831) (Khi := 0.000001476055)
    (by norm_num) (by norm_num) (by norm_num) errPt183
    vbpP183.1 vbpP183.2 vbpP184.1 vbpP184.2 vbpP183.1 vbpP183.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h24 := errBlockLin_of_piece (q0 := 1.108) (q1 := 1.109) (m := vBP 1.107)
    (Lo := 0.19732461) (Hi := 0.21223512) (Klo := 0.000004403961) (Khi := 0.000004411178)
    (by norm_num) (by norm_num) (by norm_num) errPt184
    vbpP184.1 vbpP184.2 vbpP185.1 vbpP185.2 vbpP183.1 vbpP183.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h25 := errBlockLin_of_piece (q0 := 1.109) (q1 := 1.11) (m := vBP 1.107)
    (Lo := 0.20249025) (Hi := 0.21741104) (Klo := 0.000007325752) (Khi := 0.000007332963)
    (by norm_num) (by norm_num) (by norm_num) errPt185
    vbpP185.1 vbpP185.2 vbpP186.1 vbpP186.2 vbpP183.1 vbpP183.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h26 := errBlockLin_of_piece (q0 := 1.11) (q1 := 1.111) (m := vBP 1.107)
    (Lo := 0.20757248) (Hi := 0.22250355) (Klo := 0.000010234253) (Khi := 0.000010241458)
    (by norm_num) (by norm_num) (by norm_num) errPt186
    vbpP186.1 vbpP186.2 vbpP187.1 vbpP187.2 vbpP183.1 vbpP183.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h27 := errBlockLin_of_piece (q0 := 1.111) (q1 := 1.112) (m := vBP 1.107)
    (Lo := 0.21257145) (Hi := 0.22751279) (Klo := 0.000013131311) (Khi := 0.000013138509)
    (by norm_num) (by norm_num) (by norm_num) errPt187
    vbpP187.1 vbpP187.2 vbpP188.1 vbpP188.2 vbpP183.1 vbpP183.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h28 := errBlockLin_of_piece (q0 := 1.112) (q1 := 1.113) (m := vBP 1.107)
    (Lo := 0.21748734) (Hi := 0.23243893) (Klo := 0.000016013372) (Khi := 0.000016020564)
    (by norm_num) (by norm_num) (by norm_num) errPt188
    vbpP188.1 vbpP188.2 vbpP189.1 vbpP189.2 vbpP183.1 vbpP183.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h29 := errBlockLin_of_piece (q0 := 1.113) (q1 := 1.114) (m := vBP 1.107)
    (Lo := 0.2223203) (Hi := 0.23728211) (Klo := 0.000018882285) (Khi := 0.000018889471)
    (by norm_num) (by norm_num) (by norm_num) errPt189
    vbpP189.1 vbpP189.2 vbpP190.1 vbpP190.2 vbpP183.1 vbpP183.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  exact (((((((((((((((((((((((((((((h0.add h1).add h2).add h3).add h4).add h5).add h6).add h7).add h8).add h9).add h10).add h11).add h12).add h13).add h14).add h15).add h16).add h17).add h18).add h19).add h20).add h21).add h22).add h23).add h24).add h25).add h26).add h27).add h28).add h29).mono (by norm_num) (by norm_num) (by norm_num [mn4])
    (by norm_num [mx4]) (by norm_num)

theorem blkLo1_1 : errBlockLin (vBP 1.114) (vBP 1.1415) (vBP 1.107) 0.0120766389 0.0127445984 0.0004637384 0.000487163 0.0127445984 := by
  have h0 := errBlockLin_of_piece (q0 := 1.114) (q1 := 1.115) (m := vBP 1.107)
    (Lo := 0.22707049) (Hi := 0.2420425) (Klo := 0.000021741686) (Khi := 0.000021748865)
    (by norm_num) (by norm_num) (by norm_num) errPt190
    vbpP190.1 vbpP190.2 vbpP191.1 vbpP191.2 vbpP183.1 vbpP183.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h1 := errBlockLin_of_piece (q0 := 1.115) (q1 := 1.116) (m := vBP 1.107)
    (Lo := 0.2317381) (Hi := 0.24672026) (Klo := 0.000024584439) (Khi := 0.000024591612)
    (by norm_num) (by norm_num) (by norm_num) errPt191
    vbpP191.1 vbpP191.2 vbpP192.1 vbpP192.2 vbpP183.1 vbpP183.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h2 := errBlockLin_of_piece (q0 := 1.116) (q1 := 1.117) (m := vBP 1.107)
    (Lo := 0.23632328) (Hi := 0.25131557) (Klo := 0.000027414187) (Khi := 0.000027421353)
    (by norm_num) (by norm_num) (by norm_num) errPt192
    vbpP192.1 vbpP192.2 vbpP193.1 vbpP193.2 vbpP183.1 vbpP183.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h3 := errBlockLin_of_piece (q0 := 1.117) (q1 := 1.118) (m := vBP 1.107)
    (Lo := 0.24082623) (Hi := 0.25582859) (Klo := 0.000030234552) (Khi := 0.000030241711)
    (by norm_num) (by norm_num) (by norm_num) errPt193
    vbpP193.1 vbpP193.2 vbpP194.1 vbpP194.2 vbpP183.1 vbpP183.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h4 := errBlockLin_of_piece (q0 := 1.118) (q1 := 1.119) (m := vBP 1.107)
    (Lo := 0.23272678) (Hi := 0.27435385) (Klo := 0.000033040206) (Khi := 0.000033047359)
    (by norm_num) (by norm_num) (by norm_num) errPt194
    vbpP194.1 vbpP194.2 vbpP195.1 vbpP195.2 vbpP183.1 vbpP183.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h5 := errBlockLin_of_piece (q0 := 1.119) (q1 := 1.12) (m := vBP 1.107)
    (Lo := 0.24958434) (Hi := 0.2646125) (Klo := 0.000035832988) (Khi := 0.000035840135)
    (by norm_num) (by norm_num) (by norm_num) errPt195
    vbpP195.1 vbpP195.2 vbpP196.1 vbpP196.2 vbpP183.1 vbpP183.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h6 := errBlockLin_of_piece (q0 := 1.12) (q1 := 1.121) (m := vBP 1.107)
    (Lo := 0.25383959) (Hi := 0.26888182) (Klo := 0.000038612944) (Khi := 0.000038620085)
    (by norm_num) (by norm_num) (by norm_num) errPt196
    vbpP196.1 vbpP196.2 vbpP197.1 vbpP197.2 vbpP183.1 vbpP183.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h7 := errBlockLin_of_piece (q0 := 1.121) (q1 := 1.122) (m := vBP 1.107)
    (Lo := 0.25801334) (Hi := 0.27306955) (Klo := 0.000041381902) (Khi := 0.000041389036)
    (by norm_num) (by norm_num) (by norm_num) errPt197
    vbpP197.1 vbpP197.2 vbpP198.1 vbpP198.2 vbpP183.1 vbpP183.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h8 := errBlockLin_of_piece (q0 := 1.122) (q1 := 1.123) (m := vBP 1.107)
    (Lo := 0.26210581) (Hi := 0.27717591) (Klo := 0.000044138119) (Khi := 0.000044145247)
    (by norm_num) (by norm_num) (by norm_num) errPt198
    vbpP198.1 vbpP198.2 vbpP199.1 vbpP199.2 vbpP183.1 vbpP183.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h9 := errBlockLin_of_piece (q0 := 1.123) (q1 := 1.124) (m := vBP 1.107)
    (Lo := 0.26611718) (Hi := 0.28120107) (Klo := 0.000046881643) (Khi := 0.000046888764)
    (by norm_num) (by norm_num) (by norm_num) errPt199
    vbpP199.1 vbpP199.2 vbpP200.1 vbpP200.2 vbpP183.1 vbpP183.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h10 := errBlockLin_of_piece (q0 := 1.124) (q1 := 1.125) (m := vBP 1.107)
    (Lo := 0.27004766) (Hi := 0.28514523) (Klo := 0.000049610739) (Khi := 0.000049617854)
    (by norm_num) (by norm_num) (by norm_num) errPt200
    vbpP200.1 vbpP200.2 vbpP201.1 vbpP201.2 vbpP183.1 vbpP183.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h11 := errBlockLin_of_piece (q0 := 1.125) (q1 := 1.126) (m := vBP 1.107)
    (Lo := 0.27389745) (Hi := 0.2890086) (Klo := 0.000052330788) (Khi := 0.000052337897)
    (by norm_num) (by norm_num) (by norm_num) errPt201
    vbpP201.1 vbpP201.2 vbpP202.1 vbpP202.2 vbpP183.1 vbpP183.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h12 := errBlockLin_of_piece (q0 := 1.126) (q1 := 1.127) (m := vBP 1.107)
    (Lo := 0.27766676) (Hi := 0.29279138) (Klo := 0.000055036497) (Khi := 0.0000550436)
    (by norm_num) (by norm_num) (by norm_num) errPt202
    vbpP202.1 vbpP202.2 vbpP203.1 vbpP203.2 vbpP183.1 vbpP183.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h13 := errBlockLin_of_piece (q0 := 1.127) (q1 := 1.128) (m := vBP 1.107)
    (Lo := 0.28135581) (Hi := 0.29649378) (Klo := 0.000057731465) (Khi := 0.000057738561)
    (by norm_num) (by norm_num) (by norm_num) errPt203
    vbpP203.1 vbpP203.2 vbpP204.1 vbpP204.2 vbpP183.1 vbpP183.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h14 := errBlockLin_of_piece (q0 := 1.128) (q1 := 1.129) (m := vBP 1.107)
    (Lo := 0.28496482) (Hi := 0.300116) (Klo := 0.000060413957) (Khi := 0.000060421047)
    (by norm_num) (by norm_num) (by norm_num) errPt204
    vbpP204.1 vbpP204.2 vbpP205.1 vbpP205.2 vbpP183.1 vbpP183.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h15 := errBlockLin_of_piece (q0 := 1.129) (q1 := 1.13) (m := vBP 1.107)
    (Lo := 0.28849401) (Hi := 0.30365827) (Klo := 0.000063084018) (Khi := 0.000063091102)
    (by norm_num) (by norm_num) (by norm_num) errPt205
    vbpP205.1 vbpP205.2 vbpP206.1 vbpP206.2 vbpP183.1 vbpP183.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h16 := errBlockLin_of_piece (q0 := 1.13) (q1 := 1.131) (m := vBP 1.107)
    (Lo := 0.2919436) (Hi := 0.3071208) (Klo := 0.000065741691) (Khi := 0.000065748769)
    (by norm_num) (by norm_num) (by norm_num) errPt206
    vbpP206.1 vbpP206.2 vbpP207.1 vbpP207.2 vbpP183.1 vbpP183.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h17 := errBlockLin_of_piece (q0 := 1.131) (q1 := 1.132) (m := vBP 1.107)
    (Lo := 0.29531382) (Hi := 0.31050382) (Klo := 0.000068388787) (Khi := 0.000068395859)
    (by norm_num) (by norm_num) (by norm_num) errPt207
    vbpP207.1 vbpP207.2 vbpP208.1 vbpP208.2 vbpP183.1 vbpP183.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h18 := errBlockLin_of_piece (q0 := 1.132) (q1 := 1.133) (m := vBP 1.107)
    (Lo := 0.29860491) (Hi := 0.31380755) (Klo := 0.000071021814) (Khi := 0.000071028879)
    (by norm_num) (by norm_num) (by norm_num) errPt208
    vbpP208.1 vbpP208.2 vbpP209.1 vbpP209.2 vbpP183.1 vbpP183.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h19 := errBlockLin_of_piece (q0 := 1.133) (q1 := 1.134) (m := vBP 1.107)
    (Lo := 0.3018171) (Hi := 0.31703223) (Klo := 0.000073646111) (Khi := 0.00007365317)
    (by norm_num) (by norm_num) (by norm_num) errPt209
    vbpP209.1 vbpP209.2 vbpP210.1 vbpP210.2 vbpP183.1 vbpP183.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h20 := errBlockLin_of_piece (q0 := 1.134) (q1 := 1.135) (m := vBP 1.107)
    (Lo := 0.30495064) (Hi := 0.32017809) (Klo := 0.000076256423) (Khi := 0.000076263475)
    (by norm_num) (by norm_num) (by norm_num) errPt210
    vbpP210.1 vbpP210.2 vbpP211.1 vbpP211.2 vbpP183.1 vbpP183.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h21 := errBlockLin_of_piece (q0 := 1.135) (q1 := 1.136) (m := vBP 1.107)
    (Lo := 0.30800577) (Hi := 0.32324537) (Klo := 0.00007885456) (Khi := 0.000078861606)
    (by norm_num) (by norm_num) (by norm_num) errPt211
    vbpP211.1 vbpP211.2 vbpP212.1 vbpP212.2 vbpP183.1 vbpP183.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h22 := errBlockLin_of_piece (q0 := 1.136) (q1 := 1.137) (m := vBP 1.107)
    (Lo := 0.31098274) (Hi := 0.32623432) (Klo := 0.000081442324) (Khi := 0.000081449364)
    (by norm_num) (by norm_num) (by norm_num) errPt212
    vbpP212.1 vbpP212.2 vbpP213.1 vbpP213.2 vbpP183.1 vbpP183.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h23 := errBlockLin_of_piece (q0 := 1.137) (q1 := 1.138) (m := vBP 1.107)
    (Lo := 0.31388181) (Hi := 0.32914518) (Klo := 0.000084017993) (Khi := 0.000084025027)
    (by norm_num) (by norm_num) (by norm_num) errPt213
    vbpP213.1 vbpP213.2 vbpP214.1 vbpP214.2 vbpP183.1 vbpP183.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h24 := errBlockLin_of_piece (q0 := 1.138) (q1 := 1.139) (m := vBP 1.107)
    (Lo := 0.31670323) (Hi := 0.33197821) (Klo := 0.000086583367) (Khi := 0.000086590394)
    (by norm_num) (by norm_num) (by norm_num) errPt214
    vbpP214.1 vbpP214.2 vbpP215.1 vbpP215.2 vbpP183.1 vbpP183.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h25 := errBlockLin_of_piece (q0 := 1.139) (q1 := 1.1395) (m := vBP 1.107)
    (Lo := 0.32257683) (Hi := 0.33024948) (Klo := 0.000044246541) (Khi := 0.000044253564)
    (by norm_num) (by norm_num) (by norm_num) errPt215
    vbpP215.1 vbpP215.2 vbpP216.1 vbpP216.2 vbpP183.1 vbpP183.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h26 := errBlockLin_of_piece (q0 := 1.1395) (q1 := 1.14) (m := vBP 1.107)
    (Lo := 0.32393076) (Hi := 0.3316066) (Klo := 0.00004488492) (Khi := 0.00004489194)
    (by norm_num) (by norm_num) (by norm_num) errPt216
    vbpP216.1 vbpP216.2 vbpP217.1 vbpP217.2 vbpP183.1 vbpP183.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h27 := errBlockLin_of_piece (q0 := 1.14) (q1 := 1.1405) (m := vBP 1.107)
    (Lo := 0.32526542) (Hi := 0.33294441) (Klo := 0.000045518952) (Khi := 0.000045525969)
    (by norm_num) (by norm_num) (by norm_num) errPt217
    vbpP217.1 vbpP217.2 vbpP218.1 vbpP218.2 vbpP183.1 vbpP183.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h28 := errBlockLin_of_piece (q0 := 1.1405) (q1 := 1.141) (m := vBP 1.107)
    (Lo := 0.32658084) (Hi := 0.33426295) (Klo := 0.000046153903) (Khi := 0.000046160917)
    (by norm_num) (by norm_num) (by norm_num) errPt218
    vbpP218.1 vbpP218.2 vbpP219.1 vbpP219.2 vbpP183.1 vbpP183.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h29 := errBlockLin_of_piece (q0 := 1.141) (q1 := 1.1415) (m := vBP 1.107)
    (Lo := 0.32787705) (Hi := 0.33556226) (Klo := 0.000046786268) (Khi := 0.000046793278)
    (by norm_num) (by norm_num) (by norm_num) errPt219
    vbpP219.1 vbpP219.2 vbpP220.1 vbpP220.2 vbpP183.1 vbpP183.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  exact (((((((((((((((((((((((((((((h0.add h1).add h2).add h3).add h4).add h5).add h6).add h7).add h8).add h9).add h10).add h11).add h12).add h13).add h14).add h15).add h16).add h17).add h18).add h19).add h20).add h21).add h22).add h23).add h24).add h25).add h26).add h27).add h28).add h29).mono (by norm_num) (by norm_num) (by norm_num [mn4])
    (by norm_num [mx4]) (by norm_num)

theorem blkLo1_2 : errBlockLin (vBP 1.1415) (vBP 1.1455) (vBP 1.107) 0.0020398949 0.0020869966 0.0001323626 0.0001354374 0.0020869966 := by
  have h0 := errBlockLin_of_piece (q0 := 1.1415) (q1 := 1.142) (m := vBP 1.107)
    (Lo := 0.32915409) (Hi := 0.33684237) (Klo := 0.00004741605) (Khi := 0.000047423058)
    (by norm_num) (by norm_num) (by norm_num) errPt220
    vbpP220.1 vbpP220.2 vbpP221.1 vbpP221.2 vbpP183.1 vbpP183.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h1 := errBlockLin_of_piece (q0 := 1.142) (q1 := 1.1425) (m := vBP 1.107)
    (Lo := 0.330412) (Hi := 0.33810331) (Klo := 0.000048046757) (Khi := 0.000048053762)
    (by norm_num) (by norm_num) (by norm_num) errPt221
    vbpP221.1 vbpP221.2 vbpP222.1 vbpP222.2 vbpP183.1 vbpP183.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h2 := errBlockLin_of_piece (q0 := 1.1425) (q1 := 1.143) (m := vBP 1.107)
    (Lo := 0.3316508) (Hi := 0.33934512) (Klo := 0.000048674886) (Khi := 0.000048681888)
    (by norm_num) (by norm_num) (by norm_num) errPt222
    vbpP222.1 vbpP222.2 vbpP223.1 vbpP223.2 vbpP183.1 vbpP183.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h3 := errBlockLin_of_piece (q0 := 1.143) (q1 := 1.1435) (m := vBP 1.107)
    (Lo := 0.33287053) (Hi := 0.34056783) (Klo := 0.000049302191) (Khi := 0.00004930919)
    (by norm_num) (by norm_num) (by norm_num) errPt223
    vbpP223.1 vbpP223.2 vbpP224.1 vbpP224.2 vbpP183.1 vbpP183.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h4 := errBlockLin_of_piece (q0 := 1.1435) (q1 := 1.144) (m := vBP 1.107)
    (Lo := 0.33407123) (Hi := 0.34177148) (Klo := 0.000049926925) (Khi := 0.000049933921)
    (by norm_num) (by norm_num) (by norm_num) errPt224
    vbpP224.1 vbpP224.2 vbpP225.1 vbpP225.2 vbpP183.1 vbpP183.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h5 := errBlockLin_of_piece (q0 := 1.144) (q1 := 1.1445) (m := vBP 1.107)
    (Lo := 0.33525293) (Hi := 0.3429561) (Klo := 0.000050550841) (Khi := 0.000050557833)
    (by norm_num) (by norm_num) (by norm_num) errPt225
    vbpP225.1 vbpP225.2 vbpP226.1 vbpP226.2 vbpP183.1 vbpP183.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h6 := errBlockLin_of_piece (q0 := 1.1445) (q1 := 1.145) (m := vBP 1.107)
    (Lo := 0.33641567) (Hi := 0.34412173) (Klo := 0.000051172192) (Khi := 0.000051179182)
    (by norm_num) (by norm_num) (by norm_num) errPt226
    vbpP226.1 vbpP226.2 vbpP227.1 vbpP227.2 vbpP183.1 vbpP183.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h7 := errBlockLin_of_piece (q0 := 1.145) (q1 := 1.1455) (m := vBP 1.107)
    (Lo := 0.33755949) (Hi := 0.3452684) (Klo := 0.000051796222) (Khi := 0.000051803208)
    (by norm_num) (by norm_num) (by norm_num) errPt227
    vbpP227.1 vbpP227.2 vbpP228.1 vbpP228.2 vbpP183.1 vbpP183.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  exact (((((((h0.add h1).add h2).add h3).add h4).add h5).add h6).add h7).mono (by norm_num) (by norm_num) (by norm_num [mn4])
    (by norm_num [mx4]) (by norm_num)

theorem blkLo1 : errBlockLin (vBP 1.069) (vBP 1.1455) (vBP 1.107) 0.020191521 0.0230687304 0.000501554 0.0006143385 0.0240107388 :=
  errBlockLin.mono (errBlockLin.add (errBlockLin.add blkLo1_0 blkLo1_1) blkLo1_2) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
    (by norm_num)

end ConnesConsani.WeilPositivity
