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
# The block data: integral, first moment and absolute integral of `err` (part 2)

Each block groups consecutive pieces of the partition; the base point `vBP qm` is a
breakpoint near the middle of the block.
-/

set_option maxHeartbeats 1000000

noncomputable section

open MeasureTheory Set Real

namespace ConnesConsani.WeilPositivity

theorem blkLin3 : errBlockLin (vBP 1.069) (vBP 1.092) (vBP 1.08) 0.0001205682 0.0016963009 0.0000167863 0.0000327053 0.0026383094 := by
  have h0 := errBlockLin_of_piece (q0 := 1.069) (q1 := 1.072) (m := vBP 1.08)
    (Lo := (-0.07656024)) (Hi := (-0.03307158)) (Klo := (-0.000092538368)) (Khi := (-0.000092530894))
    (by norm_num) (by norm_num) (by norm_num) errPt160
    vbpP160.1 vbpP160.2 vbpP161.1 vbpP161.2 vbpP164.1 vbpP164.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h1 := errBlockLin_of_piece (q0 := 1.072) (q1 := 1.074) (m := vBP 1.08)
    (Lo := (-0.04840298)) (Hi := (-0.01933743)) (Klo := (-0.000045192133)) (Khi := (-0.000045184677))
    (by norm_num) (by norm_num) (by norm_num) errPt161
    vbpP161.1 vbpP161.2 vbpP162.1 vbpP162.2 vbpP164.1 vbpP164.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h2 := errBlockLin_of_piece (q0 := 1.074) (q1 := 1.078) (m := vBP 1.08)
    (Lo := (-0.03866122)) (Hi := 0.01946293) (Klo := (-0.000051320917)) (Khi := (-0.000051313481))
    (by norm_num) (by norm_num) (by norm_num) errPt162
    vbpP162.1 vbpP162.2 vbpP163.1 vbpP163.2 vbpP164.1 vbpP164.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h3 := errBlockLin_of_piece (q0 := 1.078) (q1 := 1.08) (m := vBP 1.08)
    (Lo := (-0.00050288)) (Hi := 0.02866055) (Klo := (-0.000006375315)) (Khi := (-0.0000063679))
    (by norm_num) (by norm_num) (by norm_num) errPt163
    vbpP163.1 vbpP163.2 vbpP164.1 vbpP164.2 vbpP164.1 vbpP164.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h4 := errBlockLin_of_piece (q0 := 1.08) (q1 := 1.083) (m := vBP 1.08)
    (Lo := 0.01121346) (Hi := 0.05497906) (Klo := 0.000014218934) (Khi := 0.000014226332)
    (by norm_num) (by norm_num) (by norm_num) errPt164
    vbpP164.1 vbpP164.2 vbpP165.1 vbpP165.2 vbpP164.1 vbpP164.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h5 := errBlockLin_of_piece (q0 := 1.083) (q1 := 1.086) (m := vBP 1.08)
    (Lo := 0.03332355) (Hi := 0.07717559) (Klo := 0.000042403717) (Khi := 0.000042411095)
    (by norm_num) (by norm_num) (by norm_num) errPt165
    vbpP165.1 vbpP165.2 vbpP166.1 vbpP166.2 vbpP164.1 vbpP164.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h6 := errBlockLin_of_piece (q0 := 1.086) (q1 := 1.088) (m := vBP 1.08)
    (Lo := 0.05849752) (Hi := 0.08781008) (Klo := 0.000043735426) (Khi := 0.000043742786)
    (by norm_num) (by norm_num) (by norm_num) errPt166
    vbpP166.1 vbpP166.2 vbpP167.1 vbpP167.2 vbpP164.1 vbpP164.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h7 := errBlockLin_of_piece (q0 := 1.088) (q1 := 1.09) (m := vBP 1.08)
    (Lo := 0.07238334) (Hi := 0.10173589) (Klo := 0.000055973087) (Khi := 0.000055980434)
    (by norm_num) (by norm_num) (by norm_num) errPt167
    vbpP167.1 vbpP167.2 vbpP168.1 vbpP168.2 vbpP164.1 vbpP164.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h8 := errBlockLin_of_piece (q0 := 1.09) (q1 := 1.092) (m := vBP 1.08)
    (Lo := 0.085925) (Hi := 0.11531843) (Klo := 0.000068101384) (Khi := 0.000068108718)
    (by norm_num) (by norm_num) (by norm_num) errPt168
    vbpP168.1 vbpP168.2 vbpP169.1 vbpP169.2 vbpP164.1 vbpP164.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  exact ((((((((h0.add h1).add h2).add h3).add h4).add h5).add h6).add h7).add h8).mono (by norm_num) (by norm_num) (by norm_num [mn4])
    (by norm_num [mx4]) (by norm_num)

theorem blkLin4 : errBlockLin (vBP 1.092) (vBP 1.117) (vBP 1.104) 0.0070716641 0.0077303211 0.0000225886 0.0000305109 0.0077303211 := by
  have h0 := errBlockLin_of_piece (q0 := 1.092) (q1 := 1.094) (m := vBP 1.104)
    (Lo := 0.09912334) (Hi := 0.12855845) (Klo := (-0.000067065017)) (Khi := (-0.000067057697))
    (by norm_num) (by norm_num) (by norm_num) errPt169
    vbpP169.1 vbpP169.2 vbpP170.1 vbpP170.2 vbpP180.1 vbpP180.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h1 := errBlockLin_of_piece (q0 := 1.094) (q1 := 1.095) (m := vBP 1.104)
    (Lo := 0.11616738) (Hi := 0.13093618) (Klo := (-0.00002886256)) (Khi := (-0.00002885525))
    (by norm_num) (by norm_num) (by norm_num) errPt170
    vbpP170.1 vbpP170.2 vbpP171.1 vbpP171.2 vbpP180.1 vbpP180.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h2 := errBlockLin_of_piece (q0 := 1.095) (q1 := 1.096) (m := vBP 1.104)
    (Lo := 0.12251549) (Hi := 0.13729409) (Klo := (-0.000025766099)) (Khi := (-0.000025758795))
    (by norm_num) (by norm_num) (by norm_num) errPt171
    vbpP171.1 vbpP171.2 vbpP172.1 vbpP172.2 vbpP180.1 vbpP180.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h3 := errBlockLin_of_piece (q0 := 1.096) (q1 := 1.097) (m := vBP 1.104)
    (Lo := 0.1287783) (Hi := 0.14356678) (Klo := (-0.000022681752)) (Khi := (-0.000022674455))
    (by norm_num) (by norm_num) (by norm_num) errPt172
    vbpP172.1 vbpP172.2 vbpP173.1 vbpP173.2 vbpP180.1 vbpP180.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h4 := errBlockLin_of_piece (q0 := 1.097) (q1 := 1.098) (m := vBP 1.104)
    (Lo := 0.13495594) (Hi := 0.14975437) (Klo := (-0.00001961494)) (Khi := (-0.000019607649))
    (by norm_num) (by norm_num) (by norm_num) errPt173
    vbpP173.1 vbpP173.2 vbpP174.1 vbpP174.2 vbpP180.1 vbpP180.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h5 := errBlockLin_of_piece (q0 := 1.098) (q1 := 1.099) (m := vBP 1.104)
    (Lo := 0.14104853) (Hi := 0.15585697) (Klo := (-0.000016558319)) (Khi := (-0.000016551035))
    (by norm_num) (by norm_num) (by norm_num) errPt174
    vbpP174.1 vbpP174.2 vbpP175.1 vbpP175.2 vbpP180.1 vbpP180.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h6 := errBlockLin_of_piece (q0 := 1.099) (q1 := 1.1) (m := vBP 1.104)
    (Lo := 0.14705619) (Hi := 0.16187468) (Klo := (-0.000013519125)) (Khi := (-0.000013511848))
    (by norm_num) (by norm_num) (by norm_num) errPt175
    vbpP175.1 vbpP175.2 vbpP176.1 vbpP176.2 vbpP180.1 vbpP180.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h7 := errBlockLin_of_piece (q0 := 1.1) (q1 := 1.101) (m := vBP 1.104)
    (Lo := 0.15297904) (Hi := 0.16780764) (Klo := (-0.000010491846)) (Khi := (-0.000010484576))
    (by norm_num) (by norm_num) (by norm_num) errPt176
    vbpP176.1 vbpP176.2 vbpP177.1 vbpP177.2 vbpP180.1 vbpP180.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h8 := errBlockLin_of_piece (q0 := 1.101) (q1 := 1.102) (m := vBP 1.104)
    (Lo := 0.15881722) (Hi := 0.17365596) (Klo := (-0.000007478252)) (Khi := (-0.000007470989))
    (by norm_num) (by norm_num) (by norm_num) errPt177
    vbpP177.1 vbpP177.2 vbpP178.1 vbpP178.2 vbpP180.1 vbpP180.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h9 := errBlockLin_of_piece (q0 := 1.102) (q1 := 1.103) (m := vBP 1.104)
    (Lo := 0.16457084) (Hi := 0.17941977) (Klo := (-0.000004478295)) (Khi := (-0.000004471038))
    (by norm_num) (by norm_num) (by norm_num) errPt178
    vbpP178.1 vbpP178.2 vbpP179.1 vbpP179.2 vbpP180.1 vbpP180.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h10 := errBlockLin_of_piece (q0 := 1.103) (q1 := 1.104) (m := vBP 1.104)
    (Lo := 0.17024004) (Hi := 0.18509918) (Klo := (-0.000001491925)) (Khi := (-0.000001484674))
    (by norm_num) (by norm_num) (by norm_num) errPt179
    vbpP179.1 vbpP179.2 vbpP180.1 vbpP180.2 vbpP180.1 vbpP180.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h11 := errBlockLin_of_piece (q0 := 1.104) (q1 := 1.105) (m := vBP 1.104)
    (Lo := 0.17582496) (Hi := 0.19069435) (Klo := 0.000001480908) (Khi := 0.000001488152)
    (by norm_num) (by norm_num) (by norm_num) errPt180
    vbpP180.1 vbpP180.2 vbpP181.1 vbpP181.2 vbpP180.1 vbpP180.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h12 := errBlockLin_of_piece (q0 := 1.105) (q1 := 1.106) (m := vBP 1.104)
    (Lo := 0.18132573) (Hi := 0.19620538) (Klo := 0.000004438444) (Khi := 0.000004445681)
    (by norm_num) (by norm_num) (by norm_num) errPt181
    vbpP181.1 vbpP181.2 vbpP182.1 vbpP182.2 vbpP180.1 vbpP180.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h13 := errBlockLin_of_piece (q0 := 1.106) (q1 := 1.107) (m := vBP 1.104)
    (Lo := 0.1867425) (Hi := 0.20163243) (Klo := 0.000007386158) (Khi := 0.000007393389)
    (by norm_num) (by norm_num) (by norm_num) errPt182
    vbpP182.1 vbpP182.2 vbpP183.1 vbpP183.2 vbpP180.1 vbpP180.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h14 := errBlockLin_of_piece (q0 := 1.107) (q1 := 1.108) (m := vBP 1.104)
    (Lo := 0.19207541) (Hi := 0.20697563) (Klo := 0.000010318671) (Khi := 0.000010325895)
    (by norm_num) (by norm_num) (by norm_num) errPt183
    vbpP183.1 vbpP183.2 vbpP184.1 vbpP184.2 vbpP180.1 vbpP180.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h15 := errBlockLin_of_piece (q0 := 1.108) (q1 := 1.109) (m := vBP 1.104)
    (Lo := 0.19732461) (Hi := 0.21223512) (Klo := 0.00001323784) (Khi := 0.000013245058)
    (by norm_num) (by norm_num) (by norm_num) errPt184
    vbpP184.1 vbpP184.2 vbpP185.1 vbpP185.2 vbpP180.1 vbpP180.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h16 := errBlockLin_of_piece (q0 := 1.109) (q1 := 1.11) (m := vBP 1.104)
    (Lo := 0.20249025) (Hi := 0.21741104) (Klo := 0.000016143715) (Khi := 0.000016150926)
    (by norm_num) (by norm_num) (by norm_num) errPt185
    vbpP185.1 vbpP185.2 vbpP186.1 vbpP186.2 vbpP180.1 vbpP180.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h17 := errBlockLin_of_piece (q0 := 1.11) (q1 := 1.111) (m := vBP 1.104)
    (Lo := 0.20757248) (Hi := 0.22250355) (Klo := 0.000019036342) (Khi := 0.000019043547)
    (by norm_num) (by norm_num) (by norm_num) errPt186
    vbpP186.1 vbpP186.2 vbpP187.1 vbpP187.2 vbpP180.1 vbpP180.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h18 := errBlockLin_of_piece (q0 := 1.111) (q1 := 1.112) (m := vBP 1.104)
    (Lo := 0.21257145) (Hi := 0.22751279) (Klo := 0.000021917568) (Khi := 0.000021924767)
    (by norm_num) (by norm_num) (by norm_num) errPt187
    vbpP187.1 vbpP187.2 vbpP188.1 vbpP188.2 vbpP180.1 vbpP180.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h19 := errBlockLin_of_piece (q0 := 1.112) (q1 := 1.113) (m := vBP 1.104)
    (Lo := 0.21748734) (Hi := 0.23243893) (Klo := 0.000024783841) (Khi := 0.000024791033)
    (by norm_num) (by norm_num) (by norm_num) errPt188
    vbpP188.1 vbpP188.2 vbpP189.1 vbpP189.2 vbpP180.1 vbpP180.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h20 := errBlockLin_of_piece (q0 := 1.113) (q1 := 1.114) (m := vBP 1.104)
    (Lo := 0.2223203) (Hi := 0.23728211) (Klo := 0.000027637009) (Khi := 0.000027644194)
    (by norm_num) (by norm_num) (by norm_num) errPt189
    vbpP189.1 vbpP189.2 vbpP190.1 vbpP190.2 vbpP180.1 vbpP180.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h21 := errBlockLin_of_piece (q0 := 1.114) (q1 := 1.115) (m := vBP 1.104)
    (Lo := 0.22707049) (Hi := 0.2420425) (Klo := 0.000030480706) (Khi := 0.000030487885)
    (by norm_num) (by norm_num) (by norm_num) errPt190
    vbpP190.1 vbpP190.2 vbpP191.1 vbpP191.2 vbpP180.1 vbpP180.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h22 := errBlockLin_of_piece (q0 := 1.115) (q1 := 1.116) (m := vBP 1.104)
    (Lo := 0.2317381) (Hi := 0.24672026) (Klo := 0.000033307798) (Khi := 0.000033314971)
    (by norm_num) (by norm_num) (by norm_num) errPt191
    vbpP191.1 vbpP191.2 vbpP192.1 vbpP192.2 vbpP180.1 vbpP180.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h23 := errBlockLin_of_piece (q0 := 1.116) (q1 := 1.117) (m := vBP 1.104)
    (Lo := 0.23632328) (Hi := 0.25131557) (Klo := 0.000036121926) (Khi := 0.000036129092)
    (by norm_num) (by norm_num) (by norm_num) errPt192
    vbpP192.1 vbpP192.2 vbpP193.1 vbpP193.2 vbpP180.1 vbpP180.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  exact (((((((((((((((((((((((h0.add h1).add h2).add h3).add h4).add h5).add h6).add h7).add h8).add h9).add h10).add h11).add h12).add h13).add h14).add h15).add h16).add h17).add h18).add h19).add h20).add h21).add h22).add h23).mono (by norm_num) (by norm_num) (by norm_num [mn4])
    (by norm_num [mx4]) (by norm_num)

theorem blkLin5 : errBlockLin (vBP 1.117) (vBP 1.1425) (vBP 1.13) 0.011465132 0.0120726427 0.0000021045 0.0000091028 0.0120726427 := by
  have h0 := errBlockLin_of_piece (q0 := 1.117) (q1 := 1.118) (m := vBP 1.13)
    (Lo := 0.24082623) (Hi := 0.25582859) (Klo := (-0.000035633098)) (Khi := (-0.000035625938))
    (by norm_num) (by norm_num) (by norm_num) errPt193
    vbpP193.1 vbpP193.2 vbpP194.1 vbpP194.2 vbpP206.1 vbpP206.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h1 := errBlockLin_of_piece (q0 := 1.118) (q1 := 1.119) (m := vBP 1.13)
    (Lo := 0.23272678) (Hi := 0.27435385) (Klo := (-0.000032709718)) (Khi := (-0.000032702564))
    (by norm_num) (by norm_num) (by norm_num) errPt194
    vbpP194.1 vbpP194.2 vbpP195.1 vbpP195.2 vbpP206.1 vbpP206.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h2 := errBlockLin_of_piece (q0 := 1.119) (q1 := 1.12) (m := vBP 1.13)
    (Lo := 0.24958434) (Hi := 0.2646125) (Klo := (-0.000029799525)) (Khi := (-0.000029792378))
    (by norm_num) (by norm_num) (by norm_num) errPt195
    vbpP195.1 vbpP195.2 vbpP196.1 vbpP196.2 vbpP206.1 vbpP206.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h3 := errBlockLin_of_piece (q0 := 1.12) (q1 := 1.121) (m := vBP 1.13)
    (Lo := 0.25383959) (Hi := 0.26888182) (Klo := (-0.000026902473)) (Khi := (-0.000026895332))
    (by norm_num) (by norm_num) (by norm_num) errPt196
    vbpP196.1 vbpP196.2 vbpP197.1 vbpP197.2 vbpP206.1 vbpP206.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h4 := errBlockLin_of_piece (q0 := 1.121) (q1 := 1.122) (m := vBP 1.13)
    (Lo := 0.25801334) (Hi := 0.27306955) (Klo := (-0.000024016732)) (Khi := (-0.000024009598))
    (by norm_num) (by norm_num) (by norm_num) errPt197
    vbpP197.1 vbpP197.2 vbpP198.1 vbpP198.2 vbpP206.1 vbpP206.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h5 := errBlockLin_of_piece (q0 := 1.122) (q1 := 1.123) (m := vBP 1.13)
    (Lo := 0.26210581) (Hi := 0.27717591) (Klo := (-0.000021144043)) (Khi := (-0.000021136915))
    (by norm_num) (by norm_num) (by norm_num) errPt198
    vbpP198.1 vbpP198.2 vbpP199.1 vbpP199.2 vbpP206.1 vbpP206.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h6 := errBlockLin_of_piece (q0 := 1.123) (q1 := 1.124) (m := vBP 1.13)
    (Lo := 0.26611718) (Hi := 0.28120107) (Klo := (-0.000018284359)) (Khi := (-0.000018277237))
    (by norm_num) (by norm_num) (by norm_num) errPt199
    vbpP199.1 vbpP199.2 vbpP200.1 vbpP200.2 vbpP206.1 vbpP206.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h7 := errBlockLin_of_piece (q0 := 1.124) (q1 := 1.125) (m := vBP 1.13)
    (Lo := 0.27004766) (Hi := 0.28514523) (Klo := (-0.000015439412)) (Khi := (-0.000015432297))
    (by norm_num) (by norm_num) (by norm_num) errPt200
    vbpP200.1 vbpP200.2 vbpP201.1 vbpP201.2 vbpP206.1 vbpP206.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h8 := errBlockLin_of_piece (q0 := 1.125) (q1 := 1.126) (m := vBP 1.13)
    (Lo := 0.27389745) (Hi := 0.2890086) (Klo := (-0.000012603821)) (Khi := (-0.000012596712))
    (by norm_num) (by norm_num) (by norm_num) errPt201
    vbpP201.1 vbpP201.2 vbpP202.1 vbpP202.2 vbpP206.1 vbpP206.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h9 := errBlockLin_of_piece (q0 := 1.126) (q1 := 1.127) (m := vBP 1.13)
    (Lo := 0.27766676) (Hi := 0.29279138) (Klo := (-0.000009782877)) (Khi := (-0.000009775774))
    (by norm_num) (by norm_num) (by norm_num) errPt202
    vbpP202.1 vbpP202.2 vbpP203.1 vbpP203.2 vbpP206.1 vbpP206.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h10 := errBlockLin_of_piece (q0 := 1.127) (q1 := 1.128) (m := vBP 1.13)
    (Lo := 0.28135581) (Hi := 0.29649378) (Klo := (-0.000006972982)) (Khi := (-0.000006965885))
    (by norm_num) (by norm_num) (by norm_num) errPt203
    vbpP203.1 vbpP203.2 vbpP204.1 vbpP204.2 vbpP206.1 vbpP206.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h11 := errBlockLin_of_piece (q0 := 1.128) (q1 := 1.129) (m := vBP 1.13)
    (Lo := 0.28496482) (Hi := 0.300116) (Klo := (-0.000004175867)) (Khi := (-0.000004168777))
    (by norm_num) (by norm_num) (by norm_num) errPt204
    vbpP204.1 vbpP204.2 vbpP205.1 vbpP205.2 vbpP206.1 vbpP206.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h12 := errBlockLin_of_piece (q0 := 1.129) (q1 := 1.13) (m := vBP 1.13)
    (Lo := 0.28849401) (Hi := 0.30365827) (Klo := (-0.000001391488)) (Khi := (-0.000001384404))
    (by norm_num) (by norm_num) (by norm_num) errPt205
    vbpP205.1 vbpP205.2 vbpP206.1 vbpP206.2 vbpP206.1 vbpP206.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h13 := errBlockLin_of_piece (q0 := 1.13) (q1 := 1.131) (m := vBP 1.13)
    (Lo := 0.2919436) (Hi := 0.3071208) (Klo := 0.0000013802) (Khi := 0.000001387278)
    (by norm_num) (by norm_num) (by norm_num) errPt206
    vbpP206.1 vbpP206.2 vbpP207.1 vbpP207.2 vbpP206.1 vbpP206.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h14 := errBlockLin_of_piece (q0 := 1.131) (q1 := 1.132) (m := vBP 1.13)
    (Lo := 0.29531382) (Hi := 0.31050382) (Klo := 0.00000414101) (Khi := 0.000004148081)
    (by norm_num) (by norm_num) (by norm_num) errPt207
    vbpP207.1 vbpP207.2 vbpP208.1 vbpP208.2 vbpP206.1 vbpP206.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h15 := errBlockLin_of_piece (q0 := 1.132) (q1 := 1.133) (m := vBP 1.13)
    (Lo := 0.29860491) (Hi := 0.31380755) (Klo := 0.000006887448) (Khi := 0.000006894513)
    (by norm_num) (by norm_num) (by norm_num) errPt208
    vbpP208.1 vbpP208.2 vbpP209.1 vbpP209.2 vbpP206.1 vbpP206.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h16 := errBlockLin_of_piece (q0 := 1.133) (q1 := 1.134) (m := vBP 1.13)
    (Lo := 0.3018171) (Hi := 0.31703223) (Klo := 0.000009624856) (Khi := 0.000009631915)
    (by norm_num) (by norm_num) (by norm_num) errPt209
    vbpP209.1 vbpP209.2 vbpP210.1 vbpP210.2 vbpP206.1 vbpP206.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h17 := errBlockLin_of_piece (q0 := 1.134) (q1 := 1.135) (m := vBP 1.13)
    (Lo := 0.30495064) (Hi := 0.32017809) (Klo := 0.000012347981) (Khi := 0.000012355034)
    (by norm_num) (by norm_num) (by norm_num) errPt210
    vbpP210.1 vbpP210.2 vbpP211.1 vbpP211.2 vbpP206.1 vbpP206.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h18 := errBlockLin_of_piece (q0 := 1.135) (q1 := 1.136) (m := vBP 1.13)
    (Lo := 0.30800577) (Hi := 0.32324537) (Klo := 0.000015058633) (Khi := 0.00001506568)
    (by norm_num) (by norm_num) (by norm_num) errPt211
    vbpP211.1 vbpP211.2 vbpP212.1 vbpP212.2 vbpP206.1 vbpP206.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h19 := errBlockLin_of_piece (q0 := 1.136) (q1 := 1.137) (m := vBP 1.13)
    (Lo := 0.31098274) (Hi := 0.32623432) (Klo := 0.000017758615) (Khi := 0.000017765655)
    (by norm_num) (by norm_num) (by norm_num) errPt212
    vbpP212.1 vbpP212.2 vbpP213.1 vbpP213.2 vbpP206.1 vbpP206.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h20 := errBlockLin_of_piece (q0 := 1.137) (q1 := 1.138) (m := vBP 1.13)
    (Lo := 0.31388181) (Hi := 0.32914518) (Klo := 0.000020446207) (Khi := 0.000020453241)
    (by norm_num) (by norm_num) (by norm_num) errPt213
    vbpP213.1 vbpP213.2 vbpP214.1 vbpP214.2 vbpP206.1 vbpP206.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h21 := errBlockLin_of_piece (q0 := 1.138) (q1 := 1.139) (m := vBP 1.13)
    (Lo := 0.31670323) (Hi := 0.33197821) (Klo := 0.000023123208) (Khi := 0.000023130235)
    (by norm_num) (by norm_num) (by norm_num) errPt214
    vbpP214.1 vbpP214.2 vbpP215.1 vbpP215.2 vbpP206.1 vbpP206.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h22 := errBlockLin_of_piece (q0 := 1.139) (q1 := 1.1395) (m := vBP 1.13)
    (Lo := 0.32257683) (Hi := 0.33024948) (Klo := 0.00001255823) (Khi := 0.000012565253)
    (by norm_num) (by norm_num) (by norm_num) errPt215
    vbpP215.1 vbpP215.2 vbpP216.1 vbpP216.2 vbpP206.1 vbpP206.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h23 := errBlockLin_of_piece (q0 := 1.1395) (q1 := 1.14) (m := vBP 1.13)
    (Lo := 0.32393076) (Hi := 0.3316066) (Klo := 0.000013224405) (Khi := 0.000013231425)
    (by norm_num) (by norm_num) (by norm_num) errPt216
    vbpP216.1 vbpP216.2 vbpP217.1 vbpP217.2 vbpP206.1 vbpP206.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h24 := errBlockLin_of_piece (q0 := 1.14) (q1 := 1.1405) (m := vBP 1.13)
    (Lo := 0.32526542) (Hi := 0.33294441) (Klo := 0.000013886197) (Khi := 0.000013893214)
    (by norm_num) (by norm_num) (by norm_num) errPt217
    vbpP217.1 vbpP217.2 vbpP218.1 vbpP218.2 vbpP206.1 vbpP206.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h25 := errBlockLin_of_piece (q0 := 1.1405) (q1 := 1.141) (m := vBP 1.13)
    (Lo := 0.32658084) (Hi := 0.33426295) (Klo := 0.000014548872) (Khi := 0.000014555886)
    (by norm_num) (by norm_num) (by norm_num) errPt218
    vbpP218.1 vbpP218.2 vbpP219.1 vbpP219.2 vbpP206.1 vbpP206.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h26 := errBlockLin_of_piece (q0 := 1.141) (q1 := 1.1415) (m := vBP 1.13)
    (Lo := 0.32787705) (Hi := 0.33556226) (Klo := 0.000015208924) (Khi := 0.000015215935)
    (by norm_num) (by norm_num) (by norm_num) errPt219
    vbpP219.1 vbpP219.2 vbpP220.1 vbpP220.2 vbpP206.1 vbpP206.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h27 := errBlockLin_of_piece (q0 := 1.1415) (q1 := 1.142) (m := vBP 1.13)
    (Lo := 0.32915409) (Hi := 0.33684237) (Klo := 0.000015866358) (Khi := 0.000015873366)
    (by norm_num) (by norm_num) (by norm_num) errPt220
    vbpP220.1 vbpP220.2 vbpP221.1 vbpP221.2 vbpP206.1 vbpP206.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h28 := errBlockLin_of_piece (q0 := 1.142) (q1 := 1.1425) (m := vBP 1.13)
    (Lo := 0.330412) (Hi := 0.33810331) (Klo := 0.000016524679) (Khi := 0.000016531684)
    (by norm_num) (by norm_num) (by norm_num) errPt221
    vbpP221.1 vbpP221.2 vbpP222.1 vbpP222.2 vbpP206.1 vbpP206.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  exact ((((((((((((((((((((((((((((h0.add h1).add h2).add h3).add h4).add h5).add h6).add h7).add h8).add h9).add h10).add h11).add h12).add h13).add h14).add h15).add h16).add h17).add h18).add h19).add h20).add h21).add h22).add h23).add h24).add h25).add h26).add h27).add h28).mono (by norm_num) (by norm_num) (by norm_num [mn4])
    (by norm_num [mx4]) (by norm_num)

theorem blkLin6 : errBlockLin (vBP 1.1425) (vBP 1.1685) (vBP 1.1555) 0.0138165357 0.014118611 0.0000010659 0.000004595 0.014118611 := by
  have h0 := errBlockLin_of_piece (q0 := 1.1425) (q1 := 1.143) (m := vBP 1.1555)
    (Lo := 0.3316508) (Hi := 0.33934512) (Klo := (-0.00001699666)) (Khi := (-0.000016989658))
    (by norm_num) (by norm_num) (by norm_num) errPt222
    vbpP222.1 vbpP222.2 vbpP223.1 vbpP223.2 vbpP248.1 vbpP248.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h1 := errBlockLin_of_piece (q0 := 1.143) (q1 := 1.1435) (m := vBP 1.1555)
    (Lo := 0.33287053) (Hi := 0.34056783) (Klo := (-0.000016311924)) (Khi := (-0.000016304926))
    (by norm_num) (by norm_num) (by norm_num) errPt223
    vbpP223.1 vbpP223.2 vbpP224.1 vbpP224.2 vbpP248.1 vbpP248.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h2 := errBlockLin_of_piece (q0 := 1.1435) (q1 := 1.144) (m := vBP 1.1555)
    (Lo := 0.33407123) (Hi := 0.34177148) (Klo := (-0.000015629835)) (Khi := (-0.00001562284))
    (by norm_num) (by norm_num) (by norm_num) errPt224
    vbpP224.1 vbpP224.2 vbpP225.1 vbpP225.2 vbpP248.1 vbpP248.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h3 := errBlockLin_of_piece (q0 := 1.144) (q1 := 1.1445) (m := vBP 1.1555)
    (Lo := 0.33525293) (Hi := 0.3429561) (Klo := (-0.00001494864)) (Khi := (-0.000014941647))
    (by norm_num) (by norm_num) (by norm_num) errPt225
    vbpP225.1 vbpP225.2 vbpP226.1 vbpP226.2 vbpP248.1 vbpP248.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h4 := errBlockLin_of_piece (q0 := 1.1445) (q1 := 1.145) (m := vBP 1.1555)
    (Lo := 0.33641567) (Hi := 0.34412173) (Klo := (-0.000014270084)) (Khi := (-0.000014263094))
    (by norm_num) (by norm_num) (by norm_num) errPt226
    vbpP226.1 vbpP226.2 vbpP227.1 vbpP227.2 vbpP248.1 vbpP248.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h5 := errBlockLin_of_piece (q0 := 1.145) (q1 := 1.1455) (m := vBP 1.1555)
    (Lo := 0.33755949) (Hi := 0.3452684) (Klo := (-0.000013588924)) (Khi := (-0.000013581938))
    (by norm_num) (by norm_num) (by norm_num) errPt227
    vbpP227.1 vbpP227.2 vbpP228.1 vbpP228.2 vbpP248.1 vbpP248.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h6 := errBlockLin_of_piece (q0 := 1.1455) (q1 := 1.146) (m := vBP 1.1555)
    (Lo := 0.33868441) (Hi := 0.34639615) (Klo := (-0.000012913891)) (Khi := (-0.000012906908))
    (by norm_num) (by norm_num) (by norm_num) errPt228
    vbpP228.1 vbpP228.2 vbpP229.1 vbpP229.2 vbpP248.1 vbpP248.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h7 := errBlockLin_of_piece (q0 := 1.146) (q1 := 1.1465) (m := vBP 1.1555)
    (Lo := 0.33979049) (Hi := 0.34750502) (Klo := (-0.000012237998)) (Khi := (-0.000012231017))
    (by norm_num) (by norm_num) (by norm_num) errPt229
    vbpP229.1 vbpP229.2 vbpP230.1 vbpP230.2 vbpP248.1 vbpP248.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h8 := errBlockLin_of_piece (q0 := 1.1465) (q1 := 1.147) (m := vBP 1.1555)
    (Lo := 0.34087774) (Hi := 0.34859504) (Klo := (-0.000011564732)) (Khi := (-0.000011557754))
    (by norm_num) (by norm_num) (by norm_num) errPt230
    vbpP230.1 vbpP230.2 vbpP231.1 vbpP231.2 vbpP248.1 vbpP248.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h9 := errBlockLin_of_piece (q0 := 1.147) (q1 := 1.1475) (m := vBP 1.1555)
    (Lo := 0.34194623) (Hi := 0.34966625) (Klo := (-0.000010890603)) (Khi := (-0.000010883628))
    (by norm_num) (by norm_num) (by norm_num) errPt231
    vbpP231.1 vbpP231.2 vbpP232.1 vbpP232.2 vbpP248.1 vbpP248.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h10 := errBlockLin_of_piece (q0 := 1.1475) (q1 := 1.148) (m := vBP 1.1555)
    (Lo := 0.34299597) (Hi := 0.35071869) (Klo := (-0.000010220839)) (Khi := (-0.000010213868))
    (by norm_num) (by norm_num) (by norm_num) errPt232
    vbpP232.1 vbpP232.2 vbpP233.1 vbpP233.2 vbpP248.1 vbpP248.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h11 := errBlockLin_of_piece (q0 := 1.148) (q1 := 1.1485) (m := vBP 1.1555)
    (Lo := 0.344027) (Hi := 0.35175239) (Klo := (-0.00000955195)) (Khi := (-0.000009544982))
    (by norm_num) (by norm_num) (by norm_num) errPt233
    vbpP233.1 vbpP233.2 vbpP234.1 vbpP234.2 vbpP248.1 vbpP248.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h12 := errBlockLin_of_piece (q0 := 1.1485) (q1 := 1.149) (m := vBP 1.1555)
    (Lo := 0.34503938) (Hi := 0.35276739) (Klo := (-0.000008882193)) (Khi := (-0.000008875228))
    (by norm_num) (by norm_num) (by norm_num) errPt234
    vbpP234.1 vbpP234.2 vbpP235.1 vbpP235.2 vbpP248.1 vbpP248.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h13 := errBlockLin_of_piece (q0 := 1.149) (q1 := 1.1495) (m := vBP 1.1555)
    (Lo := 0.34603312) (Hi := 0.35376374) (Klo := (-0.000008216791)) (Khi := (-0.000008209828))
    (by norm_num) (by norm_num) (by norm_num) errPt235
    vbpP235.1 vbpP235.2 vbpP236.1 vbpP236.2 vbpP248.1 vbpP248.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h14 := errBlockLin_of_piece (q0 := 1.1495) (q1 := 1.15) (m := vBP 1.1555)
    (Lo := 0.34700828) (Hi := 0.35474146) (Klo := (-0.000007550517)) (Khi := (-0.000007543558))
    (by norm_num) (by norm_num) (by norm_num) errPt236
    vbpP236.1 vbpP236.2 vbpP237.1 vbpP237.2 vbpP248.1 vbpP248.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h15 := errBlockLin_of_piece (q0 := 1.15) (q1 := 1.1505) (m := vBP 1.1555)
    (Lo := 0.34796489) (Hi := 0.35570059) (Klo := (-0.00000688685)) (Khi := (-0.000006879894))
    (by norm_num) (by norm_num) (by norm_num) errPt237
    vbpP237.1 vbpP237.2 vbpP238.1 vbpP238.2 vbpP248.1 vbpP248.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h16 := errBlockLin_of_piece (q0 := 1.1505) (q1 := 1.151) (m := vBP 1.1555)
    (Lo := 0.34890299) (Hi := 0.35664118) (Klo := (-0.000006225785)) (Khi := (-0.000006218832))
    (by norm_num) (by norm_num) (by norm_num) errPt238
    vbpP238.1 vbpP238.2 vbpP239.1 vbpP239.2 vbpP248.1 vbpP248.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h17 := errBlockLin_of_piece (q0 := 1.151) (q1 := 1.1515) (m := vBP 1.1555)
    (Lo := 0.34982262) (Hi := 0.35756327) (Klo := (-0.000005563845)) (Khi := (-0.000005556895))
    (by norm_num) (by norm_num) (by norm_num) errPt239
    vbpP239.1 vbpP239.2 vbpP240.1 vbpP240.2 vbpP248.1 vbpP248.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h18 := errBlockLin_of_piece (q0 := 1.1515) (q1 := 1.152) (m := vBP 1.1555)
    (Lo := 0.35072381) (Hi := 0.35846688) (Klo := (-0.000004904503)) (Khi := (-0.000004897556))
    (by norm_num) (by norm_num) (by norm_num) errPt240
    vbpP240.1 vbpP240.2 vbpP241.1 vbpP241.2 vbpP248.1 vbpP248.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h19 := errBlockLin_of_piece (q0 := 1.152) (q1 := 1.1525) (m := vBP 1.1555)
    (Lo := 0.35160662) (Hi := 0.35935207) (Klo := (-0.000004246019)) (Khi := (-0.000004239075))
    (by norm_num) (by norm_num) (by norm_num) errPt241
    vbpP241.1 vbpP241.2 vbpP242.1 vbpP242.2 vbpP248.1 vbpP248.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h20 := errBlockLin_of_piece (q0 := 1.1525) (q1 := 1.153) (m := vBP 1.1555)
    (Lo := 0.35247108) (Hi := 0.36021888) (Klo := (-0.000003590126)) (Khi := (-0.000003583185))
    (by norm_num) (by norm_num) (by norm_num) errPt242
    vbpP242.1 vbpP242.2 vbpP243.1 vbpP243.2 vbpP248.1 vbpP248.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h21 := errBlockLin_of_piece (q0 := 1.153) (q1 := 1.1535) (m := vBP 1.1555)
    (Lo := 0.35331722) (Hi := 0.36106733) (Klo := (-0.000002935087)) (Khi := (-0.000002928149))
    (by norm_num) (by norm_num) (by norm_num) errPt243
    vbpP243.1 vbpP243.2 vbpP244.1 vbpP244.2 vbpP248.1 vbpP248.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h22 := errBlockLin_of_piece (q0 := 1.1535) (q1 := 1.154) (m := vBP 1.1555)
    (Lo := 0.3541451) (Hi := 0.36189748) (Klo := (-0.000002280898)) (Khi := (-0.000002273963))
    (by norm_num) (by norm_num) (by norm_num) errPt244
    vbpP244.1 vbpP244.2 vbpP245.1 vbpP245.2 vbpP248.1 vbpP248.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h23 := errBlockLin_of_piece (q0 := 1.154) (q1 := 1.1545) (m := vBP 1.1555)
    (Lo := 0.35495475) (Hi := 0.36270937) (Klo := (-0.00000162756)) (Khi := (-0.000001620628))
    (by norm_num) (by norm_num) (by norm_num) errPt245
    vbpP245.1 vbpP245.2 vbpP246.1 vbpP246.2 vbpP248.1 vbpP248.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h24 := errBlockLin_of_piece (q0 := 1.1545) (q1 := 1.155) (m := vBP 1.1555)
    (Lo := 0.35574621) (Hi := 0.36350303) (Klo := (-0.000000976802)) (Khi := (-0.000000969873))
    (by norm_num) (by norm_num) (by norm_num) errPt246
    vbpP246.1 vbpP246.2 vbpP247.1 vbpP247.2 vbpP248.1 vbpP248.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h25 := errBlockLin_of_piece (q0 := 1.155) (q1 := 1.1555) (m := vBP 1.1555)
    (Lo := 0.35651953) (Hi := 0.3642785) (Klo := (-0.000000328619)) (Khi := (-0.000000321693))
    (by norm_num) (by norm_num) (by norm_num) errPt247
    vbpP247.1 vbpP247.2 vbpP248.1 vbpP248.2 vbpP248.1 vbpP248.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h26 := errBlockLin_of_piece (q0 := 1.1555) (q1 := 1.156) (m := vBP 1.1555)
    (Lo := 0.35727474) (Hi := 0.36503583) (Klo := 0.000000320453) (Khi := 0.000000327376)
    (by norm_num) (by norm_num) (by norm_num) errPt248
    vbpP248.1 vbpP248.2 vbpP249.1 vbpP249.2 vbpP248.1 vbpP248.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h27 := errBlockLin_of_piece (q0 := 1.156) (q1 := 1.1565) (m := vBP 1.1555)
    (Lo := 0.35801189) (Hi := 0.36577507) (Klo := 0.000000966953) (Khi := 0.000000973873)
    (by norm_num) (by norm_num) (by norm_num) errPt249
    vbpP249.1 vbpP249.2 vbpP250.1 vbpP250.2 vbpP248.1 vbpP248.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h28 := errBlockLin_of_piece (q0 := 1.1565) (q1 := 1.157) (m := vBP 1.1555)
    (Lo := 0.35873102) (Hi := 0.36649624) (Klo := 0.000001612616) (Khi := 0.000001619533)
    (by norm_num) (by norm_num) (by norm_num) errPt250
    vbpP250.1 vbpP250.2 vbpP251.1 vbpP251.2 vbpP248.1 vbpP248.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h29 := errBlockLin_of_piece (q0 := 1.157) (q1 := 1.1575) (m := vBP 1.1555)
    (Lo := 0.35943218) (Hi := 0.3671994) (Klo := 0.000002257441) (Khi := 0.000002264355)
    (by norm_num) (by norm_num) (by norm_num) errPt251
    vbpP251.1 vbpP251.2 vbpP252.1 vbpP252.2 vbpP248.1 vbpP248.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h30 := errBlockLin_of_piece (q0 := 1.1575) (q1 := 1.158) (m := vBP 1.1555)
    (Lo := 0.36011541) (Hi := 0.36788459) (Klo := 0.000002897977) (Khi := 0.000002904888)
    (by norm_num) (by norm_num) (by norm_num) errPt252
    vbpP252.1 vbpP252.2 vbpP253.1 vbpP253.2 vbpP248.1 vbpP248.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h31 := errBlockLin_of_piece (q0 := 1.158) (q1 := 1.1585) (m := vBP 1.1555)
    (Lo := 0.36078074) (Hi := 0.36855185) (Klo := 0.000003541137) (Khi := 0.000003548045)
    (by norm_num) (by norm_num) (by norm_num) errPt253
    vbpP253.1 vbpP253.2 vbpP254.1 vbpP254.2 vbpP248.1 vbpP248.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h32 := errBlockLin_of_piece (q0 := 1.1585) (q1 := 1.159) (m := vBP 1.1555)
    (Lo := 0.36142823) (Hi := 0.36920122) (Klo := 0.000004180013) (Khi := 0.000004186918)
    (by norm_num) (by norm_num) (by norm_num) errPt254
    vbpP254.1 vbpP254.2 vbpP255.1 vbpP255.2 vbpP248.1 vbpP248.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h33 := errBlockLin_of_piece (q0 := 1.159) (q1 := 1.1595) (m := vBP 1.1555)
    (Lo := 0.36205792) (Hi := 0.36983275) (Klo := 0.000004818062) (Khi := 0.000004824964)
    (by norm_num) (by norm_num) (by norm_num) errPt255
    vbpP255.1 vbpP255.2 vbpP256.1 vbpP256.2 vbpP248.1 vbpP248.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h34 := errBlockLin_of_piece (q0 := 1.1595) (q1 := 1.16) (m := vBP 1.1555)
    (Lo := 0.36266985) (Hi := 0.37044648) (Klo := 0.000005455286) (Khi := 0.000005462185)
    (by norm_num) (by norm_num) (by norm_num) errPt256
    vbpP256.1 vbpP256.2 vbpP257.1 vbpP257.2 vbpP248.1 vbpP248.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h35 := errBlockLin_of_piece (q0 := 1.16) (q1 := 1.1605) (m := vBP 1.1555)
    (Lo := 0.36326407) (Hi := 0.37104246) (Klo := 0.000006091687) (Khi := 0.000006098583)
    (by norm_num) (by norm_num) (by norm_num) errPt257
    vbpP257.1 vbpP257.2 vbpP258.1 vbpP258.2 vbpP248.1 vbpP248.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h36 := errBlockLin_of_piece (q0 := 1.1605) (q1 := 1.161) (m := vBP 1.1555)
    (Lo := 0.36384062) (Hi := 0.37162072) (Klo := 0.000006725543) (Khi := 0.000006732436)
    (by norm_num) (by norm_num) (by norm_num) errPt258
    vbpP258.1 vbpP258.2 vbpP259.1 vbpP259.2 vbpP248.1 vbpP248.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h37 := errBlockLin_of_piece (q0 := 1.161) (q1 := 1.1615) (m := vBP 1.1555)
    (Lo := 0.36439954) (Hi := 0.37218132) (Klo := 0.00000735858) (Khi := 0.00000736547)
    (by norm_num) (by norm_num) (by norm_num) errPt259
    vbpP259.1 vbpP259.2 vbpP260.1 vbpP260.2 vbpP248.1 vbpP248.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h38 := errBlockLin_of_piece (q0 := 1.1615) (q1 := 1.162) (m := vBP 1.1555)
    (Lo := 0.36494089) (Hi := 0.3727243) (Klo := 0.0000079908) (Khi := 0.000007997687)
    (by norm_num) (by norm_num) (by norm_num) errPt260
    vbpP260.1 vbpP260.2 vbpP261.1 vbpP261.2 vbpP248.1 vbpP248.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h39 := errBlockLin_of_piece (q0 := 1.162) (q1 := 1.1625) (m := vBP 1.1555)
    (Lo := 0.36546471) (Hi := 0.3732497) (Klo := 0.000008620484) (Khi := 0.000008627368)
    (by norm_num) (by norm_num) (by norm_num) errPt261
    vbpP261.1 vbpP261.2 vbpP262.1 vbpP262.2 vbpP248.1 vbpP248.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h40 := errBlockLin_of_piece (q0 := 1.1625) (q1 := 1.163) (m := vBP 1.1555)
    (Lo := 0.36597104) (Hi := 0.37375757) (Klo := 0.000009247636) (Khi := 0.000009254517)
    (by norm_num) (by norm_num) (by norm_num) errPt262
    vbpP262.1 vbpP262.2 vbpP263.1 vbpP263.2 vbpP248.1 vbpP248.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h41 := errBlockLin_of_piece (q0 := 1.163) (q1 := 1.1635) (m := vBP 1.1555)
    (Lo := 0.36645993) (Hi := 0.37424796) (Klo := 0.000009877417) (Khi := 0.000009884296)
    (by norm_num) (by norm_num) (by norm_num) errPt263
    vbpP263.1 vbpP263.2 vbpP264.1 vbpP264.2 vbpP248.1 vbpP248.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h42 := errBlockLin_of_piece (q0 := 1.1635) (q1 := 1.164) (m := vBP 1.1555)
    (Lo := 0.36693142) (Hi := 0.37472092) (Klo := 0.000010502951) (Khi := 0.000010509826)
    (by norm_num) (by norm_num) (by norm_num) errPt264
    vbpP264.1 vbpP264.2 vbpP265.1 vbpP265.2 vbpP248.1 vbpP248.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h43 := errBlockLin_of_piece (q0 := 1.164) (q1 := 1.1645) (m := vBP 1.1555)
    (Lo := 0.36738557) (Hi := 0.37517648) (Klo := 0.000011127678) (Khi := 0.000011134551)
    (by norm_num) (by norm_num) (by norm_num) errPt265
    vbpP265.1 vbpP265.2 vbpP266.1 vbpP266.2 vbpP248.1 vbpP248.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h44 := errBlockLin_of_piece (q0 := 1.1645) (q1 := 1.165) (m := vBP 1.1555)
    (Lo := 0.36782242) (Hi := 0.37561469) (Klo := 0.000011749885) (Khi := 0.000011756754)
    (by norm_num) (by norm_num) (by norm_num) errPt266
    vbpP266.1 vbpP266.2 vbpP267.1 vbpP267.2 vbpP248.1 vbpP248.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h45 := errBlockLin_of_piece (q0 := 1.165) (q1 := 1.1655) (m := vBP 1.1555)
    (Lo := 0.36824202) (Hi := 0.37603561) (Klo := 0.000012373007) (Khi := 0.000012381589)
    (by norm_num) (by norm_num) (by norm_num) errPt267
    vbpP267.1 vbpP267.2 vbpP268.1 vbpP268.2 vbpP248.1 vbpP248.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h46 := errBlockLin_of_piece (q0 := 1.1655) (q1 := 1.166) (m := vBP 1.1555)
    (Lo := 0.36864441) (Hi := 0.37643928) (Klo := 0.000012993611) (Khi := 0.00001300219)
    (by norm_num) (by norm_num) (by norm_num) errPt268
    vbpP268.1 vbpP268.2 vbpP269.1 vbpP269.2 vbpP248.1 vbpP248.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h47 := errBlockLin_of_piece (q0 := 1.166) (q1 := 1.1665) (m := vBP 1.1555)
    (Lo := 0.36902964) (Hi := 0.37682575) (Klo := 0.000013613418) (Khi := 0.000013620278)
    (by norm_num) (by norm_num) (by norm_num) errPt269
    vbpP269.1 vbpP269.2 vbpP270.1 vbpP270.2 vbpP248.1 vbpP248.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h48 := errBlockLin_of_piece (q0 := 1.1665) (q1 := 1.167) (m := vBP 1.1555)
    (Lo := 0.36939777) (Hi := 0.37719506) (Klo := 0.000014230714) (Khi := 0.000014237572)
    (by norm_num) (by norm_num) (by norm_num) errPt270
    vbpP270.1 vbpP270.2 vbpP271.1 vbpP271.2 vbpP248.1 vbpP248.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h49 := errBlockLin_of_piece (q0 := 1.167) (q1 := 1.1675) (m := vBP 1.1555)
    (Lo := 0.36974883) (Hi := 0.37754727) (Klo := 0.000014847217) (Khi := 0.000014854072)
    (by norm_num) (by norm_num) (by norm_num) errPt271
    vbpP271.1 vbpP271.2 vbpP272.1 vbpP272.2 vbpP248.1 vbpP248.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h50 := errBlockLin_of_piece (q0 := 1.1675) (q1 := 1.168) (m := vBP 1.1555)
    (Lo := 0.37008289) (Hi := 0.37788242) (Klo := 0.000015464641) (Khi := 0.000015471493)
    (by norm_num) (by norm_num) (by norm_num) errPt272
    vbpP272.1 vbpP272.2 vbpP273.1 vbpP273.2 vbpP248.1 vbpP248.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h51 := errBlockLin_of_piece (q0 := 1.168) (q1 := 1.1685) (m := vBP 1.1555)
    (Lo := 0.37039998) (Hi := 0.37820055) (Klo := 0.000016076138) (Khi := 0.000016084698)
    (by norm_num) (by norm_num) (by norm_num) errPt273
    vbpP273.1 vbpP273.2 vbpP274.1 vbpP274.2 vbpP248.1 vbpP248.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  exact (((((((((((((((((((((((((((((((((((((((((((((((((((h0.add h1).add h2).add h3).add h4).add h5).add h6).add h7).add h8).add h9).add h10).add h11).add h12).add h13).add h14).add h15).add h16).add h17).add h18).add h19).add h20).add h21).add h22).add h23).add h24).add h25).add h26).add h27).add h28).add h29).add h30).add h31).add h32).add h33).add h34).add h35).add h36).add h37).add h38).add h39).add h40).add h41).add h42).add h43).add h44).add h45).add h46).add h47).add h48).add h49).add h50).add h51).mono (by norm_num) (by norm_num) (by norm_num [mn4])
    (by norm_num [mx4]) (by norm_num)

theorem blkLin7 : errBlockLin (vBP 1.1685) (vBP 1.195) (vBP 1.1815) 0.0140744511 0.0143814081 0.0000002603 0.0000039598 0.0143814081 := by
  have h0 := errBlockLin_of_piece (q0 := 1.1685) (q1 := 1.169) (m := vBP 1.1815)
    (Lo := 0.37070016) (Hi := 0.37850173) (Klo := (-0.000015891308)) (Khi := (-0.00001588104))
    (by norm_num) (by norm_num) (by norm_num) errPt274
    vbpP274.1 vbpP274.2 vbpP275.1 vbpP275.2 vbpP300.1 vbpP300.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h1 := errBlockLin_of_piece (q0 := 1.169) (q1 := 1.1695) (m := vBP 1.1815)
    (Lo := 0.37098347) (Hi := 0.378786) (Klo := (-0.000015251814)) (Khi := (-0.00001524326))
    (by norm_num) (by norm_num) (by norm_num) errPt275
    vbpP275.1 vbpP275.2 vbpP276.1 vbpP276.2 vbpP300.1 vbpP300.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h2 := errBlockLin_of_piece (q0 := 1.1695) (q1 := 1.17) (m := vBP 1.1815)
    (Lo := 0.37124998) (Hi := 0.37905341) (Klo := (-0.000014611429)) (Khi := (-0.000014604589))
    (by norm_num) (by norm_num) (by norm_num) errPt276
    vbpP276.1 vbpP276.2 vbpP277.1 vbpP277.2 vbpP300.1 vbpP300.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h3 := errBlockLin_of_piece (q0 := 1.17) (q1 := 1.1705) (m := vBP 1.1815)
    (Lo := 0.37149972) (Hi := 0.379304) (Klo := (-0.000013975282)) (Khi := (-0.000013968445))
    (by norm_num) (by norm_num) (by norm_num) errPt277
    vbpP277.1 vbpP277.2 vbpP278.1 vbpP278.2 vbpP300.1 vbpP300.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h4 := errBlockLin_of_piece (q0 := 1.1705) (q1 := 1.171) (m := vBP 1.1815)
    (Lo := 0.37173274) (Hi := 0.37953784) (Klo := (-0.000013341659)) (Khi := (-0.000013334824))
    (by norm_num) (by norm_num) (by norm_num) errPt278
    vbpP278.1 vbpP278.2 vbpP279.1 vbpP279.2 vbpP300.1 vbpP300.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h5 := errBlockLin_of_piece (q0 := 1.171) (q1 := 1.1715) (m := vBP 1.1815)
    (Lo := 0.37194911) (Hi := 0.37975496) (Klo := (-0.000012705432)) (Khi := (-0.0000126986))
    (by norm_num) (by norm_num) (by norm_num) errPt279
    vbpP279.1 vbpP279.2 vbpP280.1 vbpP280.2 vbpP300.1 vbpP300.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h6 := errBlockLin_of_piece (q0 := 1.1715) (q1 := 1.172) (m := vBP 1.1815)
    (Lo := 0.37214886) (Hi := 0.37995543) (Klo := (-0.000012075138)) (Khi := (-0.00001206831))
    (by norm_num) (by norm_num) (by norm_num) errPt280
    vbpP280.1 vbpP280.2 vbpP281.1 vbpP281.2 vbpP300.1 vbpP300.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h7 := errBlockLin_of_piece (q0 := 1.172) (q1 := 1.1725) (m := vBP 1.1815)
    (Lo := 0.37233206) (Hi := 0.38013928) (Klo := (-0.00001144224)) (Khi := (-0.000011435414))
    (by norm_num) (by norm_num) (by norm_num) errPt281
    vbpP281.1 vbpP281.2 vbpP282.1 vbpP282.2 vbpP300.1 vbpP300.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h8 := errBlockLin_of_piece (q0 := 1.1725) (q1 := 1.173) (m := vBP 1.1815)
    (Lo := 0.37249874) (Hi := 0.38030658) (Klo := (-0.000010813561)) (Khi := (-0.000010806738))
    (by norm_num) (by norm_num) (by norm_num) errPt282
    vbpP282.1 vbpP282.2 vbpP283.1 vbpP283.2 vbpP300.1 vbpP300.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h9 := errBlockLin_of_piece (q0 := 1.173) (q1 := 1.1735) (m := vBP 1.1815)
    (Lo := 0.37264897) (Hi := 0.38045738) (Klo := (-0.000010183981)) (Khi := (-0.000010177161))
    (by norm_num) (by norm_num) (by norm_num) errPt283
    vbpP283.1 vbpP283.2 vbpP284.1 vbpP284.2 vbpP300.1 vbpP300.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h10 := errBlockLin_of_piece (q0 := 1.1735) (q1 := 1.174) (m := vBP 1.1815)
    (Lo := 0.3727828) (Hi := 0.38059172) (Klo := (-0.000009556909)) (Khi := (-0.000009550092))
    (by norm_num) (by norm_num) (by norm_num) errPt284
    vbpP284.1 vbpP284.2 vbpP285.1 vbpP285.2 vbpP300.1 vbpP300.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h11 := errBlockLin_of_piece (q0 := 1.174) (q1 := 1.1745) (m := vBP 1.1815)
    (Lo := 0.37290028) (Hi := 0.38070966) (Klo := (-0.000008932341)) (Khi := (-0.000008925527))
    (by norm_num) (by norm_num) (by norm_num) errPt285
    vbpP285.1 vbpP285.2 vbpP286.1 vbpP286.2 vbpP300.1 vbpP300.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h12 := errBlockLin_of_piece (q0 := 1.1745) (q1 := 1.175) (m := vBP 1.1815)
    (Lo := 0.37300145) (Hi := 0.38081125) (Klo := (-0.000008306868)) (Khi := (-0.000008300057))
    (by norm_num) (by norm_num) (by norm_num) errPt286
    vbpP286.1 vbpP286.2 vbpP287.1 vbpP287.2 vbpP300.1 vbpP300.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h13 := errBlockLin_of_piece (q0 := 1.175) (q1 := 1.1755) (m := vBP 1.1815)
    (Lo := 0.37308639) (Hi := 0.38089654) (Klo := (-0.000007683895)) (Khi := (-0.000007675385))
    (by norm_num) (by norm_num) (by norm_num) errPt287
    vbpP287.1 vbpP287.2 vbpP288.1 vbpP288.2 vbpP300.1 vbpP300.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h14 := errBlockLin_of_piece (q0 := 1.1755) (q1 := 1.176) (m := vBP 1.1815)
    (Lo := 0.37315513) (Hi := 0.38096559) (Klo := (-0.000007061717)) (Khi := (-0.00000705321))
    (by norm_num) (by norm_num) (by norm_num) errPt288
    vbpP288.1 vbpP288.2 vbpP289.1 vbpP289.2 vbpP300.1 vbpP300.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h15 := errBlockLin_of_piece (q0 := 1.176) (q1 := 1.1765) (m := vBP 1.1815)
    (Lo := 0.37320773) (Hi := 0.38101845) (Klo := (-0.000006442031)) (Khi := (-0.000006435229))
    (by norm_num) (by norm_num) (by norm_num) errPt289
    vbpP289.1 vbpP289.2 vbpP290.1 vbpP290.2 vbpP300.1 vbpP300.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h16 := errBlockLin_of_piece (q0 := 1.1765) (q1 := 1.177) (m := vBP 1.1815)
    (Lo := 0.37324425) (Hi := 0.38105517) (Klo := (-0.000005821436)) (Khi := (-0.000005814637))
    (by norm_num) (by norm_num) (by norm_num) errPt290
    vbpP290.1 vbpP290.2 vbpP291.1 vbpP291.2 vbpP300.1 vbpP300.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h17 := errBlockLin_of_piece (q0 := 1.177) (q1 := 1.1775) (m := vBP 1.1815)
    (Lo := 0.37326474) (Hi := 0.38107582) (Klo := (-0.00000520333)) (Khi := (-0.000005196534))
    (by norm_num) (by norm_num) (by norm_num) errPt291
    vbpP291.1 vbpP291.2 vbpP292.1 vbpP292.2 vbpP300.1 vbpP300.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h18 := errBlockLin_of_piece (q0 := 1.1775) (q1 := 1.178) (m := vBP 1.1815)
    (Lo := 0.37326925) (Hi := 0.38108043) (Klo := (-0.000004587709)) (Khi := (-0.000004580916))
    (by norm_num) (by norm_num) (by norm_num) errPt292
    vbpP292.1 vbpP292.2 vbpP293.1 vbpP293.2 vbpP300.1 vbpP300.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h19 := errBlockLin_of_piece (q0 := 1.178) (q1 := 1.1785) (m := vBP 1.1815)
    (Lo := 0.37325784) (Hi := 0.38106907) (Klo := (-0.000003971175)) (Khi := (-0.000003964384))
    (by norm_num) (by norm_num) (by norm_num) errPt293
    vbpP293.1 vbpP293.2 vbpP294.1 vbpP294.2 vbpP300.1 vbpP300.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h20 := errBlockLin_of_piece (q0 := 1.1785) (q1 := 1.179) (m := vBP 1.1815)
    (Lo := 0.37323056) (Hi := 0.3810418) (Klo := (-0.000003358817)) (Khi := (-0.000003352029))
    (by norm_num) (by norm_num) (by norm_num) errPt294
    vbpP294.1 vbpP294.2 vbpP295.1 vbpP295.2 vbpP300.1 vbpP300.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h21 := errBlockLin_of_piece (q0 := 1.179) (q1 := 1.1795) (m := vBP 1.1815)
    (Lo := 0.37318748) (Hi := 0.38099866) (Klo := (-0.000002743847)) (Khi := (-0.000002737062))
    (by norm_num) (by norm_num) (by norm_num) errPt295
    vbpP295.1 vbpP295.2 vbpP296.1 vbpP296.2 vbpP300.1 vbpP300.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h22 := errBlockLin_of_piece (q0 := 1.1795) (q1 := 1.18) (m := vBP 1.1815)
    (Lo := 0.37312864) (Hi := 0.38093971) (Klo := (-0.000002134744)) (Khi := (-0.000002126267))
    (by norm_num) (by norm_num) (by norm_num) errPt296
    vbpP296.1 vbpP296.2 vbpP297.1 vbpP297.2 vbpP300.1 vbpP300.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h23 := errBlockLin_of_piece (q0 := 1.18) (q1 := 1.1805) (m := vBP 1.1815)
    (Lo := 0.3730541) (Hi := 0.38086501) (Klo := (-0.000001524721)) (Khi := (-0.000001516247))
    (by norm_num) (by norm_num) (by norm_num) errPt297
    vbpP297.1 vbpP297.2 vbpP298.1 vbpP298.2 vbpP300.1 vbpP300.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h24 := errBlockLin_of_piece (q0 := 1.1805) (q1 := 1.181) (m := vBP 1.1815)
    (Lo := 0.37296392) (Hi := 0.38077461) (Klo := (-0.000000913778)) (Khi := (-0.000000907002))
    (by norm_num) (by norm_num) (by norm_num) errPt298
    vbpP298.1 vbpP298.2 vbpP299.1 vbpP299.2 vbpP300.1 vbpP300.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h25 := errBlockLin_of_piece (q0 := 1.181) (q1 := 1.1815) (m := vBP 1.1815)
    (Lo := 0.37285815) (Hi := 0.38066857) (Klo := (-0.000000306997)) (Khi := (-0.000000300223))
    (by norm_num) (by norm_num) (by norm_num) errPt299
    vbpP299.1 vbpP299.2 vbpP300.1 vbpP300.2 vbpP300.1 vbpP300.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h26 := errBlockLin_of_piece (q0 := 1.1815) (q1 := 1.182) (m := vBP 1.1815)
    (Lo := 0.37273686) (Hi := 0.38054695) (Klo := 0.000000299014) (Khi := 0.000000307477)
    (by norm_num) (by norm_num) (by norm_num) errPt300
    vbpP300.1 vbpP300.2 vbpP301.1 vbpP301.2 vbpP300.1 vbpP300.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h27 := errBlockLin_of_piece (q0 := 1.182) (q1 := 1.1825) (m := vBP 1.1815)
    (Lo := 0.37260009) (Hi := 0.3804098) (Klo := 0.000000904256) (Khi := 0.000000912716)
    (by norm_num) (by norm_num) (by norm_num) errPt301
    vbpP301.1 vbpP301.2 vbpP302.1 vbpP302.2 vbpP300.1 vbpP300.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h28 := errBlockLin_of_piece (q0 := 1.1825) (q1 := 1.183) (m := vBP 1.1815)
    (Lo := 0.37244791) (Hi := 0.38025718) (Klo := 0.000001507041) (Khi := 0.000001515496)
    (by norm_num) (by norm_num) (by norm_num) errPt302
    vbpP302.1 vbpP302.2 vbpP303.1 vbpP303.2 vbpP300.1 vbpP300.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h29 := errBlockLin_of_piece (q0 := 1.183) (q1 := 1.1835) (m := vBP 1.1815)
    (Lo := 0.37228036) (Hi := 0.38008915) (Klo := 0.00000210906) (Khi := 0.000002119203)
    (by norm_num) (by norm_num) (by norm_num) errPt303
    vbpP303.1 vbpP303.2 vbpP304.1 vbpP304.2 vbpP300.1 vbpP300.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h30 := errBlockLin_of_piece (q0 := 1.1835) (q1 := 1.184) (m := vBP 1.1815)
    (Lo := 0.37209752) (Hi := 0.37990577) (Klo := 0.000002712007) (Khi := 0.000002720456)
    (by norm_num) (by norm_num) (by norm_num) errPt304
    vbpP304.1 vbpP304.2 vbpP305.1 vbpP305.2 vbpP300.1 vbpP300.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h31 := errBlockLin_of_piece (q0 := 1.184) (q1 := 1.1845) (m := vBP 1.1815)
    (Lo := 0.37189944) (Hi := 0.37970709) (Klo := 0.000003310813) (Khi := 0.000003317569)
    (by norm_num) (by norm_num) (by norm_num) errPt305
    vbpP305.1 vbpP305.2 vbpP306.1 vbpP306.2 vbpP300.1 vbpP300.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h32 := errBlockLin_of_piece (q0 := 1.1845) (q1 := 1.185) (m := vBP 1.1815)
    (Lo := 0.37168618) (Hi := 0.37949317) (Klo := 0.000003910549) (Khi := 0.000003917303)
    (by norm_num) (by norm_num) (by norm_num) errPt306
    vbpP306.1 vbpP306.2 vbpP307.1 vbpP307.2 vbpP300.1 vbpP300.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h33 := errBlockLin_of_piece (q0 := 1.185) (q1 := 1.1855) (m := vBP 1.1815)
    (Lo := 0.37145779) (Hi := 0.37926406) (Klo := 0.00000450784) (Khi := 0.000004516278)
    (by norm_num) (by norm_num) (by norm_num) errPt307
    vbpP307.1 vbpP307.2 vbpP308.1 vbpP308.2 vbpP300.1 vbpP300.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h34 := errBlockLin_of_piece (q0 := 1.1855) (q1 := 1.186) (m := vBP 1.1815)
    (Lo := 0.37121433) (Hi := 0.37901984) (Klo := 0.000005102688) (Khi := 0.000005111123)
    (by norm_num) (by norm_num) (by norm_num) errPt308
    vbpP308.1 vbpP308.2 vbpP309.1 vbpP309.2 vbpP300.1 vbpP300.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h35 := errBlockLin_of_piece (q0 := 1.186) (q1 := 1.1865) (m := vBP 1.1815)
    (Lo := 0.37095587) (Hi := 0.37876056) (Klo := 0.000005700156) (Khi := 0.000005706901)
    (by norm_num) (by norm_num) (by norm_num) errPt309
    vbpP309.1 vbpP309.2 vbpP310.1 vbpP310.2 vbpP300.1 vbpP300.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h36 := errBlockLin_of_piece (q0 := 1.1865) (q1 := 1.187) (m := vBP 1.1815)
    (Lo := 0.37068246) (Hi := 0.37848627) (Klo := 0.000006291814) (Khi := 0.000006298556)
    (by norm_num) (by norm_num) (by norm_num) errPt310
    vbpP310.1 vbpP310.2 vbpP311.1 vbpP311.2 vbpP300.1 vbpP300.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h37 := errBlockLin_of_piece (q0 := 1.187) (q1 := 1.1875) (m := vBP 1.1815)
    (Lo := 0.37039417) (Hi := 0.37819704) (Klo := 0.000006886093) (Khi := 0.000006892832)
    (by norm_num) (by norm_num) (by norm_num) errPt311
    vbpP311.1 vbpP311.2 vbpP312.1 vbpP312.2 vbpP300.1 vbpP300.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h38 := errBlockLin_of_piece (q0 := 1.1875) (q1 := 1.188) (m := vBP 1.1815)
    (Lo := 0.37009105) (Hi := 0.37789292) (Klo := 0.000007476255) (Khi := 0.000007482991)
    (by norm_num) (by norm_num) (by norm_num) errPt312
    vbpP312.1 vbpP312.2 vbpP313.1 vbpP313.2 vbpP300.1 vbpP300.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h39 := errBlockLin_of_piece (q0 := 1.188) (q1 := 1.1885) (m := vBP 1.1815)
    (Lo := 0.36977316) (Hi := 0.37757398) (Klo := 0.000008065672) (Khi := 0.000008072405)
    (by norm_num) (by norm_num) (by norm_num) errPt313
    vbpP313.1 vbpP313.2 vbpP314.1 vbpP314.2 vbpP300.1 vbpP300.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h40 := errBlockLin_of_piece (q0 := 1.1885) (q1 := 1.189) (m := vBP 1.1815)
    (Lo := 0.36944057) (Hi := 0.37724028) (Klo := 0.000008654345) (Khi := 0.000008661076)
    (by norm_num) (by norm_num) (by norm_num) errPt314
    vbpP314.1 vbpP314.2 vbpP315.1 vbpP315.2 vbpP300.1 vbpP300.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h41 := errBlockLin_of_piece (q0 := 1.189) (q1 := 1.1895) (m := vBP 1.1815)
    (Lo := 0.36909333) (Hi := 0.37689187) (Klo := 0.000009242276) (Khi := 0.000009249004)
    (by norm_num) (by norm_num) (by norm_num) errPt315
    vbpP315.1 vbpP315.2 vbpP316.1 vbpP316.2 vbpP300.1 vbpP300.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h42 := errBlockLin_of_piece (q0 := 1.1895) (q1 := 1.19) (m := vBP 1.1815)
    (Lo := 0.36873151) (Hi := 0.37652883) (Klo := 0.000009827785) (Khi := 0.00000983451)
    (by norm_num) (by norm_num) (by norm_num) errPt316
    vbpP316.1 vbpP316.2 vbpP317.1 vbpP317.2 vbpP300.1 vbpP300.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h43 := errBlockLin_of_piece (q0 := 1.19) (q1 := 1.1905) (m := vBP 1.1815)
    (Lo := 0.36835517) (Hi := 0.3761512) (Klo := 0.000010414237) (Khi := 0.000010420959)
    (by norm_num) (by norm_num) (by norm_num) errPt317
    vbpP317.1 vbpP317.2 vbpP318.1 vbpP318.2 vbpP300.1 vbpP300.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h44 := errBlockLin_of_piece (q0 := 1.1905) (q1 := 1.191) (m := vBP 1.1815)
    (Lo := 0.36796437) (Hi := 0.37575905) (Klo := 0.000010996591) (Khi := 0.000011003311)
    (by norm_num) (by norm_num) (by norm_num) errPt318
    vbpP318.1 vbpP318.2 vbpP319.1 vbpP319.2 vbpP300.1 vbpP300.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h45 := errBlockLin_of_piece (q0 := 1.191) (q1 := 1.1915) (m := vBP 1.1815)
    (Lo := 0.36755917) (Hi := 0.37535245) (Klo := 0.000011578213) (Khi := 0.000011586608)
    (by norm_num) (by norm_num) (by norm_num) errPt319
    vbpP319.1 vbpP319.2 vbpP320.1 vbpP320.2 vbpP300.1 vbpP300.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h46 := errBlockLin_of_piece (q0 := 1.1915) (q1 := 1.192) (m := vBP 1.1815)
    (Lo := 0.36713963) (Hi := 0.37493145) (Klo := 0.000012159101) (Khi := 0.000012167494)
    (by norm_num) (by norm_num) (by norm_num) errPt320
    vbpP320.1 vbpP320.2 vbpP321.1 vbpP321.2 vbpP300.1 vbpP300.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h47 := errBlockLin_of_piece (q0 := 1.192) (q1 := 1.1925) (m := vBP 1.1815)
    (Lo := 0.36670582) (Hi := 0.37449612) (Klo := 0.000012740937) (Khi := 0.000012747648)
    (by norm_num) (by norm_num) (by norm_num) errPt321
    vbpP321.1 vbpP321.2 vbpP322.1 vbpP322.2 vbpP300.1 vbpP300.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h48 := errBlockLin_of_piece (q0 := 1.1925) (q1 := 1.193) (m := vBP 1.1815)
    (Lo := 0.3662578) (Hi := 0.37404652) (Klo := 0.000013318688) (Khi := 0.000013325397)
    (by norm_num) (by norm_num) (by norm_num) errPt322
    vbpP322.1 vbpP322.2 vbpP323.1 vbpP323.2 vbpP300.1 vbpP300.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h49 := errBlockLin_of_piece (q0 := 1.193) (q1 := 1.1935) (m := vBP 1.1815)
    (Lo := 0.36579563) (Hi := 0.37358271) (Klo := 0.000013897389) (Khi := 0.000013904095)
    (by norm_num) (by norm_num) (by norm_num) errPt323
    vbpP323.1 vbpP323.2 vbpP324.1 vbpP324.2 vbpP300.1 vbpP300.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h50 := errBlockLin_of_piece (q0 := 1.1935) (q1 := 1.194) (m := vBP 1.1815)
    (Lo := 0.36531938) (Hi := 0.37310476) (Klo := 0.000014472013) (Khi := 0.000014480391)
    (by norm_num) (by norm_num) (by norm_num) errPt324
    vbpP324.1 vbpP324.2 vbpP325.1 vbpP325.2 vbpP300.1 vbpP300.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h51 := errBlockLin_of_piece (q0 := 1.194) (q1 := 1.195) (m := vBP 1.1815)
    (Lo := 0.36074159) (Hi := 0.37619851) (Klo := 0.000030673382) (Khi := 0.000030681755)
    (by norm_num) (by norm_num) (by norm_num) errPt325
    vbpP325.1 vbpP325.2 vbpP326.1 vbpP326.2 vbpP300.1 vbpP300.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  exact (((((((((((((((((((((((((((((((((((((((((((((((((((h0.add h1).add h2).add h3).add h4).add h5).add h6).add h7).add h8).add h9).add h10).add h11).add h12).add h13).add h14).add h15).add h16).add h17).add h18).add h19).add h20).add h21).add h22).add h23).add h24).add h25).add h26).add h27).add h28).add h29).add h30).add h31).add h32).add h33).add h34).add h35).add h36).add h37).add h38).add h39).add h40).add h41).add h42).add h43).add h44).add h45).add h46).add h47).add h48).add h49).add h50).add h51).mono (by norm_num) (by norm_num) (by norm_num [mn4])
    (by norm_num [mx4]) (by norm_num)

end ConnesConsani.WeilPositivity
