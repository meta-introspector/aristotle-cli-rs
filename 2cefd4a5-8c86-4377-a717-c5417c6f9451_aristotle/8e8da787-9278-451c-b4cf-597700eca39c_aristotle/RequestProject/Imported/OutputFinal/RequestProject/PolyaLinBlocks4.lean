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
# The block data: integral, first moment and absolute integral of `err` (part 4)

Each block groups consecutive pieces of the partition; the base point `vBP qm` is a
breakpoint near the middle of the block.
-/

set_option maxHeartbeats 1000000

noncomputable section

open MeasureTheory Set Real

namespace ConnesConsani.WeilPositivity

theorem blkLin17 : errBlockLin (vBP 1.45) (vBP 1.481) (vBP 1.464) (-0.0034391763) (-0.0026256319) (-0.0000096167) 0.0000110489 0.0034391763 := by
  have h0 := errBlockLin_of_piece (q0 := 1.45) (q1 := 1.453) (m := vBP 1.464)
    (Lo := (-0.14413656)) (Hi := (-0.11040144)) (Klo := (-0.000053514367)) (Khi := (-0.000044168292))
    (by norm_num) (by norm_num) (by norm_num) errPt468
    vbpP468.1 vbpP468.2 vbpP469.1 vbpP469.2 vbpP474.1 vbpP474.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h1 := errBlockLin_of_piece (q0 := 1.453) (q1 := 1.456) (m := vBP 1.464)
    (Lo := (-0.14270636)) (Hi := (-0.10619963)) (Klo := (-0.000041719798)) (Khi := (-0.0000321345))
    (by norm_num) (by norm_num) (by norm_num) errPt469
    vbpP469.1 vbpP469.2 vbpP470.1 vbpP470.2 vbpP474.1 vbpP474.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h2 := errBlockLin_of_piece (q0 := 1.456) (q1 := 1.458) (m := vBP 1.464)
    (Lo := (-0.13927452)) (Hi := (-0.10436678)) (Klo := (-0.000022956301)) (Khi := (-0.000013163633))
    (by norm_num) (by norm_num) (by norm_num) errPt470
    vbpP470.1 vbpP470.2 vbpP471.1 vbpP471.2 vbpP474.1 vbpP474.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h3 := errBlockLin_of_piece (q0 := 1.458) (q1 := 1.46) (m := vBP 1.464)
    (Lo := (-0.1385142)) (Hi := (-0.10127307)) (Klo := (-0.000017838528)) (Khi := (-0.000007872858))
    (by norm_num) (by norm_num) (by norm_num) errPt471
    vbpP471.1 vbpP471.2 vbpP472.1 vbpP472.2 vbpP474.1 vbpP474.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h4 := errBlockLin_of_piece (q0 := 1.46) (q1 := 1.462) (m := vBP 1.464)
    (Lo := (-0.13786397)) (Hi := (-0.09807873)) (Klo := (-0.000012758296)) (Khi := (-0.00000261325))
    (by norm_num) (by norm_num) (by norm_num) errPt472
    vbpP472.1 vbpP472.2 vbpP473.1 vbpP473.2 vbpP474.1 vbpP474.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h5 := errBlockLin_of_piece (q0 := 1.462) (q1 := 1.464) (m := vBP 1.464)
    (Lo := (-0.13734223)) (Hi := (-0.09478547)) (Klo := (-0.000007716767)) (Khi := 0.000002613996)
    (by norm_num) (by norm_num) (by norm_num) errPt473
    vbpP473.1 vbpP473.2 vbpP474.1 vbpP474.2 vbpP474.1 vbpP474.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h6 := errBlockLin_of_piece (q0 := 1.464) (q1 := 1.467) (m := vBP 1.464)
    (Lo := (-0.13937337)) (Hi := (-0.08881036)) (Klo := 0.000000435918) (Khi := 0.000011009633)
    (by norm_num) (by norm_num) (by norm_num) errPt474
    vbpP474.1 vbpP474.2 vbpP475.1 vbpP475.2 vbpP474.1 vbpP474.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h7 := errBlockLin_of_piece (q0 := 1.467) (q1 := 1.47) (m := vBP 1.464)
    (Lo := (-0.10209594)) (Hi := (-0.08750518)) (Klo := 0.000011640885) (Khi := 0.000022518493)
    (by norm_num) (by norm_num) (by norm_num) errPt475
    vbpP475.1 vbpP475.2 vbpP476.1 vbpP476.2 vbpP474.1 vbpP474.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h8 := errBlockLin_of_piece (q0 := 1.47) (q1 := 1.472) (m := vBP 1.464)
    (Lo := (-0.09600711)) (Hi := (-0.08550822)) (Klo := 0.000012067766) (Khi := 0.000023208415)
    (by norm_num) (by norm_num) (by norm_num) errPt476
    vbpP476.1 vbpP476.2 vbpP477.1 vbpP477.2 vbpP474.1 vbpP474.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h9 := errBlockLin_of_piece (q0 := 1.472) (q1 := 1.476) (m := vBP 1.464)
    (Lo := (-0.09486348)) (Hi := (-0.07676016)) (Klo := 0.000044390744) (Khi := 0.00005586669)
    (by norm_num) (by norm_num) (by norm_num) errPt477
    vbpP477.1 vbpP477.2 vbpP478.1 vbpP478.2 vbpP474.1 vbpP474.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h10 := errBlockLin_of_piece (q0 := 1.476) (q1 := 1.478) (m := vBP 1.464)
    (Lo := (-0.08582092)) (Hi := (-0.07575107)) (Klo := 0.000026511423) (Khi := 0.000038333957)
    (by norm_num) (by norm_num) (by norm_num) errPt478
    vbpP478.1 vbpP478.2 vbpP479.1 vbpP479.2 vbpP474.1 vbpP474.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h11 := errBlockLin_of_piece (q0 := 1.478) (q1 := 1.481) (m := vBP 1.464)
    (Lo := (-0.08342354)) (Hi := (-0.06966698)) (Klo := 0.000051675476) (Khi := 0.000063803708)
    (by norm_num) (by norm_num) (by norm_num) errPt479
    vbpP479.1 vbpP479.2 vbpP480.1 vbpP480.2 vbpP474.1 vbpP474.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  exact (((((((((((h0.add h1).add h2).add h3).add h4).add h5).add h6).add h7).add h8).add h9).add h10).add h11).mono (by norm_num) (by norm_num) (by norm_num [mn4])
    (by norm_num [mx4]) (by norm_num)

theorem blkLin18 : errBlockLin (vBP 1.481) (vBP 1.512) (vBP 1.495) (-0.001644081) (-0.0009411491) (-0.000005534) 0.0000103627 0.001644081 := by
  have h0 := errBlockLin_of_piece (q0 := 1.481) (q1 := 1.484) (m := vBP 1.495)
    (Lo := (-0.07815323)) (Hi := (-0.06465445)) (Klo := (-0.000054160296)) (Khi := (-0.000037521028))
    (by norm_num) (by norm_num) (by norm_num) errPt480
    vbpP480.1 vbpP480.2 vbpP481.1 vbpP481.2 vbpP485.1 vbpP485.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h1 := errBlockLin_of_piece (q0 := 1.484) (q1 := 1.486) (m := vBP 1.495)
    (Lo := (-0.07180671)) (Hi := (-0.06235995)) (Klo := (-0.000032823977)) (Khi := (-0.000015862448))
    (by norm_num) (by norm_num) (by norm_num) errPt481
    vbpP481.1 vbpP481.2 vbpP482.1 vbpP482.2 vbpP485.1 vbpP485.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h2 := errBlockLin_of_piece (q0 := 1.486) (q1 := 1.49) (m := vBP 1.495)
    (Lo := (-0.07028319)) (Hi := (-0.05349167)) (Klo := (-0.000042601173)) (Khi := (-0.000025229235))
    (by norm_num) (by norm_num) (by norm_num) errPt482
    vbpP482.1 vbpP482.2 vbpP483.1 vbpP483.2 vbpP485.1 vbpP485.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h3 := errBlockLin_of_piece (q0 := 1.49) (q1 := 1.492) (m := vBP 1.495)
    (Lo := (-0.06113491)) (Hi := (-0.05218708)) (Klo := (-0.000018535069)) (Khi := (-0.000000737715))
    (by norm_num) (by norm_num) (by norm_num) errPt483
    vbpP483.1 vbpP483.2 vbpP484.1 vbpP484.2 vbpP485.1 vbpP485.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h4 := errBlockLin_of_piece (q0 := 1.492) (q1 := 1.495) (m := vBP 1.495)
    (Lo := (-0.05855112)) (Hi := (-0.04609248)) (Klo := (-0.000014481468)) (Khi := 0.000003689045)
    (by norm_num) (by norm_num) (by norm_num) errPt484
    vbpP484.1 vbpP484.2 vbpP485.1 vbpP485.2 vbpP485.1 vbpP485.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h5 := errBlockLin_of_piece (q0 := 1.495) (q1 := 1.498) (m := vBP 1.495)
    (Lo := (-0.05319823)) (Hi := (-0.0410461)) (Klo := (-0.000003939884)) (Khi := 0.000014696697)
    (by norm_num) (by norm_num) (by norm_num) errPt485
    vbpP485.1 vbpP485.2 vbpP486.1 vbpP486.2 vbpP485.1 vbpP485.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h6 := errBlockLin_of_piece (q0 := 1.498) (q1 := 1.5) (m := vBP 1.495)
    (Lo := (-0.12794335)) (Hi := 0.06442604) (Klo := (-0.000000002418)) (Khi := 0.0000190395)
    (by norm_num) (by norm_num) (by norm_num) errPt486
    vbpP486.1 vbpP486.2 vbpP487.1 vbpP487.2 vbpP485.1 vbpP485.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h7 := errBlockLin_of_piece (q0 := 1.5) (q1 := 1.504) (m := vBP 1.495)
    (Lo := (-0.04529238)) (Hi := (-0.02984821)) (Klo := 0.000023356609) (Khi := 0.000042910079)
    (by norm_num) (by norm_num) (by norm_num) errPt487
    vbpP487.1 vbpP487.2 vbpP488.1 vbpP488.2 vbpP485.1 vbpP485.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h8 := errBlockLin_of_piece (q0 := 1.504) (q1 := 1.508) (m := vBP 1.495)
    (Lo := (-0.03856657)) (Hi := (-0.02308371)) (Klo := 0.000041588273) (Khi := 0.000061853392)
    (by norm_num) (by norm_num) (by norm_num) errPt488
    vbpP488.1 vbpP488.2 vbpP489.1 vbpP489.2 vbpP485.1 vbpP485.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h9 := errBlockLin_of_piece (q0 := 1.508) (q1 := 1.512) (m := vBP 1.495)
    (Lo := (-0.0319501)) (Hi := (-0.01647995)) (Klo := 0.000059549934) (Khi := 0.000080573257)
    (by norm_num) (by norm_num) (by norm_num) errPt489
    vbpP489.1 vbpP489.2 vbpP490.1 vbpP490.2 vbpP485.1 vbpP485.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  exact (((((((((h0.add h1).add h2).add h3).add h4).add h5).add h6).add h7).add h8).add h9).mono (by norm_num) (by norm_num) (by norm_num [mn4])
    (by norm_num [mx4]) (by norm_num)

theorem blkLin19 : errBlockLin (vBP 1.512) (vBP 1.546) (vBP 1.528) (-0.0001075699) 0.0003010664 0.0000015096 0.0000099855 0.0005432351 := by
  have h0 := errBlockLin_of_piece (q0 := 1.512) (q1 := 1.516) (m := vBP 1.528)
    (Lo := (-0.0254757)) (Hi := (-0.01006886)) (Klo := (-0.000078703338)) (Khi := (-0.00004978445))
    (by norm_num) (by norm_num) (by norm_num) errPt490
    vbpP490.1 vbpP490.2 vbpP491.1 vbpP491.2 vbpP494.1 vbpP494.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h1 := errBlockLin_of_piece (q0 := 1.516) (q1 := 1.52) (m := vBP 1.528)
    (Lo := (-0.01917497)) (Hi := (-0.00388098)) (Klo := (-0.000060457954)) (Khi := (-0.00003070753))
    (by norm_num) (by norm_num) (by norm_num) errPt491
    vbpP491.1 vbpP491.2 vbpP492.1 vbpP492.2 vbpP494.1 vbpP494.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h2 := errBlockLin_of_piece (q0 := 1.52) (q1 := 1.524) (m := vBP 1.528)
    (Lo := (-0.01307821)) (Hi := 0.00205466) (Klo := (-0.000042484657)) (Khi := (-0.000011850562))
    (by norm_num) (by norm_num) (by norm_num) errPt492
    vbpP492.1 vbpP492.2 vbpP493.1 vbpP493.2 vbpP494.1 vbpP494.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h3 := errBlockLin_of_piece (q0 := 1.524) (q1 := 1.528) (m := vBP 1.528)
    (Lo := (-0.00721432)) (Hi := 0.00771071) (Klo := (-0.000024774121)) (Khi := 0.000006796678)
    (by norm_num) (by norm_num) (by norm_num) errPt493
    vbpP493.1 vbpP493.2 vbpP494.1 vbpP494.2 vbpP494.1 vbpP494.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h4 := errBlockLin_of_piece (q0 := 1.528) (q1 := 1.531) (m := vBP 1.528)
    (Lo := (-0.00065904)) (Hi := 0.0107685) (Klo := (-0.00001117237)) (Khi := 0.000021260079)
    (by norm_num) (by norm_num) (by norm_num) errPt494
    vbpP494.1 vbpP494.2 vbpP495.1 vbpP495.2 vbpP494.1 vbpP494.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h5 := errBlockLin_of_piece (q0 := 1.531) (q1 := 1.534) (m := vBP 1.528)
    (Lo := 0.00335699) (Hi := 0.01463125) (Klo := (-0.000001566232)) (Khi := 0.000031640561)
    (by norm_num) (by norm_num) (by norm_num) errPt495
    vbpP495.1 vbpP495.2 vbpP496.1 vbpP496.2 vbpP494.1 vbpP494.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h6 := errBlockLin_of_piece (q0 := 1.534) (q1 := 1.538) (m := vBP 1.528)
    (Lo := 0.00625137) (Hi := 0.02046451) (Klo := 0.000018347375) (Khi := 0.000052504204)
    (by norm_num) (by norm_num) (by norm_num) errPt496
    vbpP496.1 vbpP496.2 vbpP497.1 vbpP497.2 vbpP494.1 vbpP494.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h7 := errBlockLin_of_piece (q0 := 1.538) (q1 := 1.542) (m := vBP 1.528)
    (Lo := 0.01109638) (Hi := 0.02495344) (Klo := 0.000035141017) (Khi := 0.000070438959)
    (by norm_num) (by norm_num) (by norm_num) errPt497
    vbpP497.1 vbpP497.2 vbpP498.1 vbpP498.2 vbpP494.1 vbpP494.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h8 := errBlockLin_of_piece (q0 := 1.542) (q1 := 1.546) (m := vBP 1.528)
    (Lo := 0.01559968) (Hi := 0.02906351) (Klo := 0.000051677307) (Khi := 0.000088179098)
    (by norm_num) (by norm_num) (by norm_num) errPt498
    vbpP498.1 vbpP498.2 vbpP499.1 vbpP499.2 vbpP494.1 vbpP494.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  exact ((((((((h0.add h1).add h2).add h3).add h4).add h5).add h6).add h7).add h8).mono (by norm_num) (by norm_num) (by norm_num [mn4])
    (by norm_num [mx4]) (by norm_num)

theorem blkLin20 : errBlockLin (vBP 1.546) (vBP 1.578) (vBP 1.562) 0.0007877505 0.0010833654 (-0.0000081935) 0.0000109912 0.0010833654 := by
  have h0 := errBlockLin_of_piece (q0 := 1.546) (q1 := 1.55) (m := vBP 1.562)
    (Lo := 0.01974254) (Hi := 0.03277861) (Klo := (-0.000084743897)) (Khi := (-0.000035452729))
    (by norm_num) (by norm_num) (by norm_num) errPt499
    vbpP499.1 vbpP499.2 vbpP500.1 vbpP500.2 vbpP503.1 vbpP503.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h1 := errBlockLin_of_piece (q0 := 1.55) (q1 := 1.554) (m := vBP 1.562)
    (Lo := 0.02350838) (Hi := 0.03608499) (Klo := (-0.000067944608)) (Khi := (-0.00001734367))
    (by norm_num) (by norm_num) (by norm_num) errPt500
    vbpP500.1 vbpP500.2 vbpP501.1 vbpP501.2 vbpP503.1 vbpP503.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h2 := errBlockLin_of_piece (q0 := 1.554) (q1 := 1.558) (m := vBP 1.562)
    (Lo := 0.02688293) (Hi := 0.0389713) (Klo := (-0.000051404808)) (Khi := 0.000000577573)
    (by norm_num) (by norm_num) (by norm_num) errPt501
    vbpP501.1 vbpP501.2 vbpP502.1 vbpP502.2 vbpP503.1 vbpP503.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h3 := errBlockLin_of_piece (q0 := 1.558) (q1 := 1.562) (m := vBP 1.562)
    (Lo := 0.02985426) (Hi := 0.04142869) (Klo := (-0.000035121929)) (Khi := 0.000018316857)
    (by norm_num) (by norm_num) (by norm_num) errPt502
    vbpP502.1 vbpP502.2 vbpP503.1 vbpP503.2 vbpP503.1 vbpP503.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h4 := errBlockLin_of_piece (q0 := 1.562) (q1 := 1.566) (m := vBP 1.562)
    (Lo := 0.03241283) (Hi := 0.0434508) (Klo := (-0.000019094725)) (Khi := 0.000035879972)
    (by norm_num) (by norm_num) (by norm_num) errPt503
    vbpP503.1 vbpP503.2 vbpP504.1 vbpP504.2 vbpP503.1 vbpP503.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h5 := errBlockLin_of_piece (q0 := 1.566) (q1 := 1.57) (m := vBP 1.562)
    (Lo := 0.03455157) (Hi := 0.04503385) (Klo := (-0.000003321965)) (Khi := 0.00005327009)
    (by norm_num) (by norm_num) (by norm_num) errPt504
    vbpP504.1 vbpP504.2 vbpP505.1 vbpP505.2 vbpP503.1 vbpP503.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h6 := errBlockLin_of_piece (q0 := 1.57) (q1 := 1.574) (m := vBP 1.562)
    (Lo := 0.0362659) (Hi := 0.04617657) (Klo := 0.00001219756) (Khi := 0.000070491617)
    (by norm_num) (by norm_num) (by norm_num) errPt505
    vbpP505.1 vbpP505.2 vbpP506.1 vbpP506.2 vbpP503.1 vbpP503.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h7 := errBlockLin_of_piece (q0 := 1.574) (q1 := 1.578) (m := vBP 1.562)
    (Lo := 0.03755372) (Hi := 0.04688031) (Klo := 0.000027465042) (Khi := 0.000087550172)
    (by norm_num) (by norm_num) (by norm_num) errPt506
    vbpP506.1 vbpP506.2 vbpP507.1 vbpP507.2 vbpP503.1 vbpP503.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  exact (((((((h0.add h1).add h2).add h3).add h4).add h5).add h6).add h7).mono (by norm_num) (by norm_num) (by norm_num [mn4])
    (by norm_num [mx4]) (by norm_num)

theorem blkLin21 : errBlockLin (vBP 1.578) (vBP 1.614) (vBP 1.594) 0.0005441883 0.0012768234 (-0.000016379) 0.0000295002 0.0014247406 := by
  have h0 := errBlockLin_of_piece (q0 := 1.578) (q1 := 1.582) (m := vBP 1.594)
    (Lo := (-0.09975825)) (Hi := 0.05360076) (Klo := (-0.000095669912)) (Khi := (-0.000017350851))
    (by norm_num) (by norm_num) (by norm_num) errPt507
    vbpP507.1 vbpP507.2 vbpP508.1 vbpP508.2 vbpP511.1 vbpP511.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h1 := errBlockLin_of_piece (q0 := 1.582) (q1 := 1.586) (m := vBP 1.594)
    (Lo := 0.03855347) (Hi := 0.04733864) (Klo := (-0.000080226762)) (Khi := 0.000000027037)
    (by norm_num) (by norm_num) (by norm_num) errPt508
    vbpP508.1 vbpP508.2 vbpP509.1 vbpP509.2 vbpP511.1 vbpP511.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h2 := errBlockLin_of_piece (q0 := 1.586) (q1 := 1.59) (m := vBP 1.594)
    (Lo := 0.03813363) (Hi := 0.04720994) (Klo := (-0.000065037251)) (Khi := 0.000017249852)
    (by norm_num) (by norm_num) (by norm_num) errPt509
    vbpP509.1 vbpP509.2 vbpP510.1 vbpP510.2 vbpP511.1 vbpP511.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h3 := errBlockLin_of_piece (q0 := 1.59) (q1 := 1.594) (m := vBP 1.594)
    (Lo := 0.03731587) (Hi := 0.04665981) (Klo := (-0.000050101466)) (Khi := 0.000034320528)
    (by norm_num) (by norm_num) (by norm_num) errPt510
    vbpP510.1 vbpP510.2 vbpP511.1 vbpP511.2 vbpP511.1 vbpP511.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h4 := errBlockLin_of_piece (q0 := 1.594) (q1 := 1.598) (m := vBP 1.594)
    (Lo := 0.03611284) (Hi := 0.04569944) (Klo := (-0.000035416998)) (Khi := 0.000051246978)
    (by norm_num) (by norm_num) (by norm_num) errPt511
    vbpP511.1 vbpP511.2 vbpP512.1 vbpP512.2 vbpP511.1 vbpP511.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h5 := errBlockLin_of_piece (q0 := 1.598) (q1 := 1.602) (m := vBP 1.594)
    (Lo := 0.03453943) (Hi := 0.04434238) (Klo := (-0.000020986466)) (Khi := 0.00006802953)
    (by norm_num) (by norm_num) (by norm_num) errPt512
    vbpP512.1 vbpP512.2 vbpP513.1 vbpP513.2 vbpP511.1 vbpP511.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h6 := errBlockLin_of_piece (q0 := 1.602) (q1 := 1.606) (m := vBP 1.594)
    (Lo := 0.03261269) (Hi := 0.04260445) (Klo := (-0.000006806234)) (Khi := 0.000084674738)
    (by norm_num) (by norm_num) (by norm_num) errPt513
    vbpP513.1 vbpP513.2 vbpP514.1 vbpP514.2 vbpP511.1 vbpP511.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h7 := errBlockLin_of_piece (q0 := 1.606) (q1 := 1.61) (m := vBP 1.594)
    (Lo := 0.03035167) (Hi := 0.04050367) (Klo := 0.0000071248) (Khi := 0.000101187835)
    (by norm_num) (by norm_num) (by norm_num) errPt514
    vbpP514.1 vbpP514.2 vbpP515.1 vbpP515.2 vbpP511.1 vbpP511.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h8 := errBlockLin_of_piece (q0 := 1.61) (q1 := 1.614) (m := vBP 1.594)
    (Lo := 0.02777738) (Hi := 0.03806012) (Klo := 0.000020804003) (Khi := 0.000117570279)
    (by norm_num) (by norm_num) (by norm_num) errPt515
    vbpP515.1 vbpP515.2 vbpP516.1 vbpP516.2 vbpP511.1 vbpP511.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  exact ((((((((h0.add h1).add h2).add h3).add h4).add h5).add h6).add h7).add h8).mono (by norm_num) (by norm_num) (by norm_num [mn4])
    (by norm_num [mx4]) (by norm_num)

theorem blkLin22 : errBlockLin (vBP 1.614) (vBP 1.648) (vBP 1.632) 0.0002009819 0.0006593494 (-0.0000135987) 0.0000059815 0.0006593494 := by
  have h0 := errBlockLin_of_piece (q0 := 1.614) (q1 := 1.618) (m := vBP 1.632)
    (Lo := 0.02491261) (Hi := 0.03529583) (Klo := (-0.000124615532)) (Khi := 0.000003989156)
    (by norm_num) (by norm_num) (by norm_num) errPt516
    vbpP516.1 vbpP516.2 vbpP517.1 vbpP517.2 vbpP519.1 vbpP519.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h1 := errBlockLin_of_piece (q0 := 1.618) (q1 := 1.625) (m := vBP 1.632)
    (Lo := 0.01690981) (Hi := 0.03455809) (Klo := (-0.000134995465)) (Khi := (-0.000002347427))
    (by norm_num) (by norm_num) (by norm_num) errPt517
    vbpP517.1 vbpP517.2 vbpP518.1 vbpP518.2 vbpP519.1 vbpP519.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h2 := errBlockLin_of_piece (q0 := 1.625) (q1 := 1.632) (m := vBP 1.632)
    (Lo := 0.0106877) (Hi := 0.02847315) (Klo := (-0.000091654497)) (Khi := 0.000046470183)
    (by norm_num) (by norm_num) (by norm_num) errPt518
    vbpP518.1 vbpP518.2 vbpP519.1 vbpP519.2 vbpP519.1 vbpP519.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h3 := errBlockLin_of_piece (q0 := 1.632) (q1 := 1.64) (m := vBP 1.632)
    (Lo := 0.00221826) (Hi := 0.02241038) (Klo := (-0.000042900491)) (Khi := 0.000101601878)
    (by norm_num) (by norm_num) (by norm_num) errPt519
    vbpP519.1 vbpP519.2 vbpP520.1 vbpP520.2 vbpP519.1 vbpP519.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h4 := errBlockLin_of_piece (q0 := 1.64) (q1 := 1.648) (m := vBP 1.632)
    (Lo := (-0.0059219)) (Hi := 0.01400873) (Klo := 0.00001089215) (Khi := 0.000162776942)
    (by norm_num) (by norm_num) (by norm_num) errPt520
    vbpP520.1 vbpP520.2 vbpP521.1 vbpP521.2 vbpP519.1 vbpP519.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  exact ((((h0.add h1).add h2).add h3).add h4).mono (by norm_num) (by norm_num) (by norm_num [mn4])
    (by norm_num [mx4]) (by norm_num)

theorem blkLin23 : errBlockLin (vBP 1.648) (vBP 1.68) (vBP 1.664) (-0.0009501764) 0.0001269897 (-0.0000190014) 0.0000166197 0.0009501764 := by
  have h0 := errBlockLin_of_piece (q0 := 1.648) (q1 := 1.656) (m := vBP 1.664)
    (Lo := (-0.01425155)) (Hi := 0.00517469) (Klo := (-0.000182311243)) (Khi := 0.000012803528)
    (by norm_num) (by norm_num) (by norm_num) errPt521
    vbpP521.1 vbpP521.2 vbpP522.1 vbpP522.2 vbpP523.1 vbpP523.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h1 := errBlockLin_of_piece (q0 := 1.656) (q1 := 1.664) (m := vBP 1.664)
    (Lo := (-0.08045654)) (Hi := 0.04923049) (Klo := (-0.000129662132)) (Khi := 0.000074015068)
    (by norm_num) (by norm_num) (by norm_num) errPt522
    vbpP522.1 vbpP522.2 vbpP523.1 vbpP523.2 vbpP523.1 vbpP523.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h2 := errBlockLin_of_piece (q0 := 1.664) (q1 := 1.672) (m := vBP 1.664)
    (Lo := (-0.03104535)) (Hi := (-0.01242835)) (Klo := (-0.000078735077)) (Khi := 0.000134246119)
    (by norm_num) (by norm_num) (by norm_num) errPt523
    vbpP523.1 vbpP523.2 vbpP524.1 vbpP524.2 vbpP523.1 vbpP523.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h3 := errBlockLin_of_piece (q0 := 1.672) (q1 := 1.68) (m := vBP 1.664)
    (Lo := (-0.03878546)) (Hi := (-0.02066807)) (Klo := (-0.000029518131)) (Khi := 0.000193549306)
    (by norm_num) (by norm_num) (by norm_num) errPt524
    vbpP524.1 vbpP524.2 vbpP525.1 vbpP525.2 vbpP523.1 vbpP523.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  exact (((h0.add h1).add h2).add h3).mono (by norm_num) (by norm_num) (by norm_num [mn4])
    (by norm_num [mx4]) (by norm_num)

theorem blkLin24 : errBlockLin (vBP 1.68) (vBP 1.712) (vBP 1.696) (-0.0011881437) (-0.0008391444) (-0.0000333771) 0.0000311276 0.0011881437 := by
  have h0 := errBlockLin_of_piece (q0 := 1.68) (q1 := 1.688) (m := vBP 1.696)
    (Lo := (-0.04572764)) (Hi := (-0.02836616)) (Klo := (-0.000220957098)) (Khi := 0.000061060579)
    (by norm_num) (by norm_num) (by norm_num) errPt525
    vbpP525.1 vbpP525.2 vbpP526.1 vbpP526.2 vbpP527.1 vbpP527.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h1 := errBlockLin_of_piece (q0 := 1.688) (q1 := 1.696) (m := vBP 1.696)
    (Lo := (-0.05167426)) (Hi := (-0.03530547)) (Klo := (-0.000172994238)) (Khi := 0.000120593206)
    (by norm_num) (by norm_num) (by norm_num) errPt526
    vbpP526.1 vbpP526.2 vbpP527.1 vbpP527.2 vbpP527.1 vbpP527.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h2 := errBlockLin_of_piece (q0 := 1.696) (q1 := 1.704) (m := vBP 1.696)
    (Lo := (-0.05645772)) (Hi := (-0.04129216)) (Klo := (-0.000126748046)) (Khi := 0.000179340216)
    (by norm_num) (by norm_num) (by norm_num) errPt527
    vbpP527.1 vbpP527.2 vbpP528.1 vbpP528.2 vbpP527.1 vbpP527.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h3 := errBlockLin_of_piece (q0 := 1.704) (q1 := 1.712) (m := vBP 1.696)
    (Lo := (-0.05994501)) (Hi := (-0.04616102)) (Klo := (-0.000082215535)) (Khi := 0.00023735474)
    (by norm_num) (by norm_num) (by norm_num) errPt528
    vbpP528.1 vbpP528.2 vbpP529.1 vbpP529.2 vbpP527.1 vbpP527.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  exact (((h0.add h1).add h2).add h3).mono (by norm_num) (by norm_num) (by norm_num [mn4])
    (by norm_num [mx4]) (by norm_num)

theorem blkLin25 : errBlockLin (vBP 1.712) (vBP 1.75) (vBP 1.734) (-0.0015737863) (-0.0007758663) (-0.0000626029) 0.0000743348 0.0015737863 := by
  have h0 := errBlockLin_of_piece (q0 := 1.712) (q1 := 1.719) (m := vBP 1.734)
    (Lo := (-0.06125387)) (Hi := (-0.05036574)) (Klo := (-0.000307613105)) (Khi := 0.000103972806)
    (by norm_num) (by norm_num) (by norm_num) errPt529
    vbpP529.1 vbpP529.2 vbpP530.1 vbpP530.2 vbpP532.1 vbpP532.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h1 := errBlockLin_of_piece (q0 := 1.719) (q1 := 1.726) (m := vBP 1.734)
    (Lo := (-0.0620739)) (Hi := (-0.05242296)) (Klo := (-0.000274945862)) (Khi := 0.000149851892)
    (by norm_num) (by norm_num) (by norm_num) errPt530
    vbpP530.1 vbpP530.2 vbpP531.1 vbpP531.2 vbpP532.1 vbpP532.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h2 := errBlockLin_of_piece (q0 := 1.726) (q1 := 1.734) (m := vBP 1.734)
    (Lo := (-0.06566806)) (Hi := 0.04482764) (Klo := (-0.000244378216)) (Khi := 0.000195580534)
    (by norm_num) (by norm_num) (by norm_num) errPt531
    vbpP531.1 vbpP531.2 vbpP532.1 vbpP532.2 vbpP532.1 vbpP532.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h3 := errBlockLin_of_piece (q0 := 1.734) (q1 := 1.742) (m := vBP 1.734)
    (Lo := (-0.06145731)) (Hi := (-0.05160082)) (Klo := (-0.000203898967)) (Khi := 0.000253350861)
    (by norm_num) (by norm_num) (by norm_num) errPt532
    vbpP532.1 vbpP532.2 vbpP533.1 vbpP533.2 vbpP532.1 vbpP532.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h4 := errBlockLin_of_piece (q0 := 1.742) (q1 := 1.75) (m := vBP 1.734)
    (Lo := (-0.05961616)) (Hi := (-0.04862936)) (Klo := (-0.000165163205)) (Khi := 0.000310629253)
    (by norm_num) (by norm_num) (by norm_num) errPt533
    vbpP533.1 vbpP533.2 vbpP534.1 vbpP534.2 vbpP532.1 vbpP532.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  exact ((((h0.add h1).add h2).add h3).add h4).mono (by norm_num) (by norm_num) (by norm_num [mn4])
    (by norm_num [mx4]) (by norm_num)

theorem blkLin26 : errBlockLin (vBP 1.75) (vBP 1.788) (vBP 1.766) (-0.0011171372) (-0.0008117076) (-0.0000717938) 0.0000693166 0.0011171372 := by
  have h0 := errBlockLin_of_piece (q0 := 1.75) (q1 := 1.758) (m := vBP 1.766)
    (Lo := (-0.05640428)) (Hi := (-0.04441821)) (Klo := (-0.00036251001)) (Khi := 0.000221416869)
    (by norm_num) (by norm_num) (by norm_num) errPt534
    vbpP534.1 vbpP534.2 vbpP535.1 vbpP535.2 vbpP536.1 vbpP536.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h1 := errBlockLin_of_piece (q0 := 1.758) (q1 := 1.766) (m := vBP 1.766)
    (Lo := (-0.05192519)) (Hi := (-0.03910361)) (Klo := (-0.000325354746)) (Khi := 0.000279405144)
    (by norm_num) (by norm_num) (by norm_num) errPt535
    vbpP535.1 vbpP535.2 vbpP536.1 vbpP536.2 vbpP536.1 vbpP536.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h2 := errBlockLin_of_piece (q0 := 1.766) (q1 := 1.774) (m := vBP 1.766)
    (Lo := (-0.04632004)) (Hi := (-0.03285466)) (Klo := (-0.00028998408)) (Khi := 0.00033705319)
    (by norm_num) (by norm_num) (by norm_num) errPt536
    vbpP536.1 vbpP536.2 vbpP537.1 vbpP537.2 vbpP536.1 vbpP536.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h3 := errBlockLin_of_piece (q0 := 1.774) (q1 := 1.781) (m := vBP 1.766)
    (Lo := (-0.0393683)) (Hi := (-0.0271897)) (Klo := (-0.000266697676)) (Khi := 0.000382549327)
    (by norm_num) (by norm_num) (by norm_num) errPt537
    vbpP537.1 vbpP537.2 vbpP538.1 vbpP538.2 vbpP536.1 vbpP536.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h4 := errBlockLin_of_piece (q0 := 1.781) (q1 := 1.788) (m := vBP 1.766)
    (Lo := (-0.03302408)) (Hi := (-0.02067705)) (Klo := (-0.000243575781)) (Khi := 0.00042768922)
    (by norm_num) (by norm_num) (by norm_num) errPt538
    vbpP538.1 vbpP538.2 vbpP539.1 vbpP539.2 vbpP536.1 vbpP536.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  exact ((((h0.add h1).add h2).add h3).add h4).mono (by norm_num) (by norm_num) (by norm_num [mn4])
    (by norm_num [mx4]) (by norm_num)

theorem blkLin27 : errBlockLin (vBP 1.788) (vBP 1.828) (vBP 1.804) (-0.0005047954) 0.0003592701 (-0.0000426324) 0.0000551257 0.0006523121 := by
  have h0 := errBlockLin_of_piece (q0 := 1.788) (q1 := 1.796) (m := vBP 1.804)
    (Lo := (-0.02662301)) (Hi := (-0.01253445)) (Klo := (-0.000482906783)) (Khi := 0.000350924894)
    (by norm_num) (by norm_num) (by norm_num) errPt539
    vbpP539.1 vbpP539.2 vbpP540.1 vbpP540.2 vbpP541.1 vbpP541.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h1 := errBlockLin_of_piece (q0 := 1.796) (q1 := 1.804) (m := vBP 1.804)
    (Lo := (-0.05422954)) (Hi := 0.04156782) (Klo := (-0.000452136525)) (Khi := 0.000409383965)
    (by norm_num) (by norm_num) (by norm_num) errPt540
    vbpP540.1 vbpP540.2 vbpP541.1 vbpP541.2 vbpP541.1 vbpP541.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h2 := errBlockLin_of_piece (q0 := 1.804) (q1 := 1.812) (m := vBP 1.804)
    (Lo := (-0.01047563)) (Hi := 0.0032406) (Klo := (-0.000423233113)) (Khi := 0.000467756514)
    (by norm_num) (by norm_num) (by norm_num) errPt541
    vbpP541.1 vbpP541.2 vbpP542.1 vbpP542.2 vbpP541.1 vbpP541.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h3 := errBlockLin_of_piece (q0 := 1.812) (q1 := 1.828) (m := vBP 1.804)
    (Lo := (-0.00549331)) (Hi := 0.02076284) (Klo := (-0.000298074672)) (Khi := 0.000641359372)
    (by norm_num) (by norm_num) (by norm_num) errPt542
    vbpP542.1 vbpP542.2 vbpP543.1 vbpP543.2 vbpP541.1 vbpP541.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  exact (((h0.add h1).add h2).add h3).mono (by norm_num) (by norm_num) (by norm_num [mn4])
    (by norm_num [mx4]) (by norm_num)

theorem blkLin28 : errBlockLin (vBP 1.828) (vBP 1.86) (vBP 1.844) 0.0002661658 0.0006619504 (-0.0000432135) 0.0000443365 0.0006619504 := by
  have h0 := errBlockLin_of_piece (q0 := 1.828) (q1 := 1.844) (m := vBP 1.844)
    (Lo := 0.00866909) (Hi := 0.03193799) (Klo := (-0.000682064417)) (Khi := 0.000519394123)
    (by norm_num) (by norm_num) (by norm_num) errPt543
    vbpP543.1 vbpP543.2 vbpP544.1 vbpP544.2 vbpP544.1 vbpP544.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h1 := errBlockLin_of_piece (q0 := 1.844) (q1 := 1.86) (m := vBP 1.844)
    (Lo := 0.01970747) (Hi := 0.03845241) (Klo := (-0.000557302981)) (Khi := 0.000721619488)
    (by norm_num) (by norm_num) (by norm_num) errPt544
    vbpP544.1 vbpP544.2 vbpP545.1 vbpP545.2 vbpP544.1 vbpP544.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  exact (h0.add h1).mono (by norm_num) (by norm_num) (by norm_num [mn4])
    (by norm_num [mx4]) (by norm_num)

theorem blkLin29 : errBlockLin (vBP 1.86) (vBP 1.89) (vBP 1.875) (-0.0002016391) 0.0006919765 (-0.0000646839) 0.0000756132 0.0007475909 := by
  have h0 := errBlockLin_of_piece (q0 := 1.86) (q1 := 1.875) (m := vBP 1.875)
    (Lo := (-0.04798372)) (Hi := 0.04151855) (Klo := (-0.000843007484)) (Khi := 0.000708124689)
    (by norm_num) (by norm_num) (by norm_num) errPt545
    vbpP545.1 vbpP545.2 vbpP546.1 vbpP546.2 vbpP546.1 vbpP546.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h1 := errBlockLin_of_piece (q0 := 1.875) (q1 := 1.89) (m := vBP 1.875)
    (Lo := 0.02493904) (Hi := 0.03955152) (Klo := (-0.000750499514)) (Khi := 0.000889031789)
    (by norm_num) (by norm_num) (by norm_num) errPt546
    vbpP546.1 vbpP546.2 vbpP547.1 vbpP547.2 vbpP546.1 vbpP546.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  exact (h0.add h1).mono (by norm_num) (by norm_num) (by norm_num [mn4])
    (by norm_num [mx4]) (by norm_num)

theorem blkLin30 : errBlockLin (vBP 1.89) (vBP 1.922) (vBP 1.906) 0.0002130007 0.0005714892 (-0.0000659662) 0.0000649309 0.0005714892 := by
  have h0 := errBlockLin_of_piece (q0 := 1.89) (q1 := 1.906) (m := vBP 1.906)
    (Lo := 0.01728014) (Hi := 0.03647198) (Klo := (-0.001057840024)) (Khi := 0.000912351333)
    (by norm_num) (by norm_num) (by norm_num) errPt547
    vbpP547.1 vbpP547.2 vbpP548.1 vbpP548.2 vbpP548.1 vbpP548.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h1 := errBlockLin_of_piece (q0 := 1.906) (q1 := 1.922) (m := vBP 1.906)
    (Lo := 0.00681142) (Hi := 0.02833408) (Klo := (-0.000966492186)) (Khi := 0.001117227032)
    (by norm_num) (by norm_num) (by norm_num) errPt548
    vbpP548.1 vbpP548.2 vbpP549.1 vbpP549.2 vbpP548.1 vbpP548.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  exact (h0.add h1).mono (by norm_num) (by norm_num) (by norm_num [mn4])
    (by norm_num [mx4]) (by norm_num)

theorem blkLin31 : errBlockLin (vBP 1.922) (vBP 1.954) (vBP 1.938) (-0.0005024763) 0.0003732495 (-0.0000757906) 0.000076092 0.0005024763 := by
  have h0 := errBlockLin_of_piece (q0 := 1.922) (q1 := 1.938) (m := vBP 1.938)
    (Lo := (-0.04152394)) (Hi := 0.03939957) (Klo := (-0.001316115191)) (Khi := 0.001178886065)
    (by norm_num) (by norm_num) (by norm_num) errPt549
    vbpP549.1 vbpP549.2 vbpP550.1 vbpP550.2 vbpP550.1 vbpP550.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h1 := errBlockLin_of_piece (q0 := 1.938) (q1 := 1.954) (m := vBP 1.938)
    (Lo := (-0.01724731)) (Hi := 0.00411447) (Klo := (-0.001243187812)) (Khi := 0.001387819143)
    (by norm_num) (by norm_num) (by norm_num) errPt550
    vbpP550.1 vbpP550.2 vbpP551.1 vbpP551.2 vbpP550.1 vbpP550.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  exact (h0.add h1).mono (by norm_num) (by norm_num) (by norm_num [mn4])
    (by norm_num [mx4]) (by norm_num)

theorem blkLin32 : errBlockLin (vBP 1.954) (vBP 1.984) (vBP 1.969) (-0.0004528511) (-0.0001972625) (-0.0000938795) 0.0000928898 0.0004528511 := by
  have h0 := errBlockLin_of_piece (q0 := 1.954) (q1 := 1.969) (m := vBP 1.969)
    (Lo := (-0.02627227)) (Hi := (-0.00814788)) (Klo := (-0.001609759063)) (Khi := 0.001496376233)
    (by norm_num) (by norm_num) (by norm_num) errPt551
    vbpP551.1 vbpP551.2 vbpP552.1 vbpP552.2 vbpP552.1 vbpP552.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h1 := errBlockLin_of_piece (q0 := 1.969) (q1 := 1.984) (m := vBP 1.969)
    (Lo := (-0.03229306)) (Hi := (-0.01741387)) (Klo := (-0.001566830062)) (Khi := 0.001689719149)
    (by norm_num) (by norm_num) (by norm_num) errPt552
    vbpP552.1 vbpP552.2 vbpP553.1 vbpP553.2 vbpP552.1 vbpP552.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  exact (h0.add h1).mono (by norm_num) (by norm_num) (by norm_num [mn4])
    (by norm_num [mx4]) (by norm_num)

theorem blkLin33 : errBlockLin (vBP 1.984) (vBP 2.016) (vBP 2) (-0.0005591254) 0.000117938 (-0.0001432987) 0.0001364309 0.0005686244 := by
  have h0 := errBlockLin_of_piece (q0 := 1.984) (q1 := 2) (m := vBP 2)
    (Lo := (-0.03603123)) (Hi := 0.0372091) (Klo := (-0.001969374484)) (Khi := 0.001847185976)
    (by norm_num) (by norm_num) (by norm_num) errPt553
    vbpP553.1 vbpP553.2 vbpP554.1 vbpP554.2 vbpP554.1 vbpP554.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h1 := errBlockLin_of_piece (q0 := 2) (q1 := 2.016) (m := vBP 2)
    (Lo := (-0.03383742)) (Hi := (-0.02294906)) (Klo := (-0.001934896342)) (Khi := 0.002069306064)
    (by norm_num) (by norm_num) (by norm_num) errPt554
    vbpP554.1 vbpP554.2 vbpP555.1 vbpP555.2 vbpP554.1 vbpP554.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  exact (h0.add h1).mono (by norm_num) (by norm_num) (by norm_num [mn4])
    (by norm_num [mx4]) (by norm_num)

theorem blkLin34 : errBlockLin (vBP 2.016) (vBP 2.046) (vBP 2.031) (-0.0003940568) (-0.0001757661) (-0.0001283075) 0.0001286628 0.0003940568 := by
  have h0 := errBlockLin_of_piece (q0 := 2.016) (q1 := 2.031) (m := vBP 2.031)
    (Lo := (-0.03052252)) (Hi := (-0.01670641)) (Klo := (-0.002379482039)) (Khi := 0.00227897062)
    (by norm_num) (by norm_num) (by norm_num) errPt555
    vbpP555.1 vbpP555.2 vbpP556.1 vbpP556.2 vbpP556.1 vbpP556.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h1 := errBlockLin_of_piece (q0 := 2.031) (q1 := 2.046) (m := vBP 2.031)
    (Lo := (-0.02360573)) (Hi := (-0.00739109)) (Klo := (-0.002373784571)) (Khi := 0.002488696095)
    (by norm_num) (by norm_num) (by norm_num) errPt556
    vbpP556.1 vbpP556.2 vbpP557.1 vbpP557.2 vbpP556.1 vbpP556.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  exact (h0.add h1).mono (by norm_num) (by norm_num) (by norm_num [mn4])
    (by norm_num [mx4]) (by norm_num)

theorem blkLin35 : errBlockLin (vBP 2.046) (vBP 2.078) (vBP 2.062) (-0.0002542782) 0.0003859443 (-0.0001465917) 0.0001447902 0.0003859443 := by
  have h0 := errBlockLin_of_piece (q0 := 2.046) (q1 := 2.062) (m := vBP 2.062)
    (Lo := (-0.03152619)) (Hi := 0.03521241) (Klo := (-0.002864641801)) (Khi := 0.002756473034)
    (by norm_num) (by norm_num) (by norm_num) errPt557
    vbpP557.1 vbpP557.2 vbpP558.1 vbpP558.2 vbpP558.1 vbpP558.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h1 := errBlockLin_of_piece (q0 := 2.062) (q1 := 2.078) (m := vBP 2.062)
    (Lo := (-0.00202886)) (Hi := 0.01591523) (Klo := (-0.002872763317)) (Khi := 0.002998895514)
    (by norm_num) (by norm_num) (by norm_num) errPt558
    vbpP558.1 vbpP558.2 vbpP559.1 vbpP559.2 vbpP558.1 vbpP558.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  exact (h0.add h1).mono (by norm_num) (by norm_num) (by norm_num [mn4])
    (by norm_num [mx4]) (by norm_num)

theorem blkLin36 : errBlockLin (vBP 2.078) (vBP 2.094) (vBP 2.078) 0.0000686642 0.0001866853 (-0.0000802428) 0.0000833979 0.0001866853 := by
  have h0 := errBlockLin_of_piece (q0 := 2.078) (q1 := 2.094) (m := vBP 2.078)
    (Lo := 0.0093369) (Hi := 0.0253853) (Klo := (-0.003160992241)) (Khi := 0.003285282636)
    (by norm_num) (by norm_num) (by norm_num) errPt559
    vbpP559.1 vbpP559.2 vbpP560.1 vbpP560.2 vbpP559.1 vbpP559.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  exact h0.mono (by norm_num) (by norm_num) (by norm_num [mn4])
    (by norm_num [mx4]) (by norm_num)

end ConnesConsani.WeilPositivity
