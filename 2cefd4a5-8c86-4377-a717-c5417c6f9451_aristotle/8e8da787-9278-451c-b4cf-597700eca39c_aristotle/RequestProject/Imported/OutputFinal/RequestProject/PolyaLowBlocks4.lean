/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.
-/
import RequestProject.Imported.OutputFinal.RequestProject.PolyaLowBlocks3

/-!
# The block data for the low-frequency bands (part 4)

Blocks of the extended partition `q ∈ [1,5]`, grouped so that the phase `tv`
varies by at most `0.25` across a block for `t ≤ 1.8`; long blocks are assembled
from sub-blocks of at most 30 pieces.
-/

set_option maxHeartbeats 4000000

noncomputable section

open MeasureTheory Set Real

namespace ConnesConsani.WeilPositivity

theorem blkLo17_0 : errBlockLin (vBP 2.9580404) (vBP 3.1622782) (vBP 3.0413818) (-0.0002252667) 0.0004336401 (-0.0000292735) 0.0000436681 0.0005401538 := by
  have h0 := errBlockLin_of_piece (q0 := 2.9580404) (q1 := 2.9999995) (m := vBP 3.0413818)
    (Lo := (-0.01011576)) (Hi := 0.00606068) (Klo := (-0.000613940672)) (Khi := (-0.000172121398))
    (by norm_num) (by norm_num) (by norm_num) errPtT36
    vbpT35.1 vbpT35.2 vbpT36.1 vbpT36.2 vbpT39.1 vbpT39.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h1 := errBlockLin_of_piece (q0 := 2.9999995) (q1 := 3.0000005) (m := vBP 3.0413818)
    (Lo := (-0.00814552)) (Hi := 0.01571807) (Klo := (-0.000208941645)) (Khi := 0.000208929023)
    (by norm_num) (by norm_num) (by norm_num) errPtT37
    vbpT36.1 vbpT36.2 vbpT37.1 vbpT37.2 vbpT39.1 vbpT39.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h2 := errBlockLin_of_piece (q0 := 3.0000005) (q1 := 3.0413807) (m := vBP 3.0413818)
    (Lo := (-0.00995047)) (Hi := 0.00561101) (Klo := (-0.000342159687)) (Khi := 0.000093769885)
    (by norm_num) (by norm_num) (by norm_num) errPtT38
    vbpT37.1 vbpT37.2 vbpT38.1 vbpT38.2 vbpT39.1 vbpT39.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h3 := errBlockLin_of_piece (q0 := 3.0413807) (q1 := 3.0413818) (m := vBP 3.0413818)
    (Lo := (-0.00789453)) (Hi := 0.01526799) (Klo := (-0.000226993998)) (Khi := 0.000226994466)
    (by norm_num) (by norm_num) (by norm_num) errPtT39
    vbpT38.1 vbpT38.2 vbpT39.1 vbpT39.2 vbpT39.1 vbpT39.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h4 := errBlockLin_of_piece (q0 := 3.0413818) (q1 := 3.0822065) (m := vBP 3.0413818)
    (Lo := 0.00173336) (Hi := 0.01675853) (Klo := (-0.000099950549)) (Khi := 0.000330932642)
    (by norm_num) (by norm_num) (by norm_num) errPtT40
    vbpT39.1 vbpT39.2 vbpT40.1 vbpT40.2 vbpT39.1 vbpT39.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h5 := errBlockLin_of_piece (q0 := 3.0822065) (q1 := 3.0822076) (m := vBP 3.0413818)
    (Lo := (-0.0076627)) (Hi := 0.01483992) (Klo := (-0.000203882934)) (Khi := 0.000203895642)
    (by norm_num) (by norm_num) (by norm_num) errPtT41
    vbpT40.1 vbpT40.2 vbpT41.1 vbpT41.2 vbpT39.1 vbpT39.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h6 := errBlockLin_of_piece (q0 := 3.0822076) (q1 := 3.1224984) (m := vBP 3.0413818)
    (Lo := 0.00193877) (Hi := 0.01643183) (Klo := 0.000119925602) (Khi := 0.000544290552)
    (by norm_num) (by norm_num) (by norm_num) errPtT42
    vbpT41.1 vbpT41.2 vbpT42.1 vbpT42.2 vbpT39.1 vbpT39.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h7 := errBlockLin_of_piece (q0 := 3.1224984) (q1 := 3.1224995) (m := vBP 3.0413818)
    (Lo := (-0.00744786)) (Hi := 0.01443246) (Klo := (-0.000220463736)) (Khi := 0.000220487575)
    (by norm_num) (by norm_num) (by norm_num) errPtT43
    vbpT42.1 vbpT42.2 vbpT43.1 vbpT43.2 vbpT39.1 vbpT39.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h8 := errBlockLin_of_piece (q0 := 3.1224995) (q1 := 3.1622771) (m := vBP 3.0413818)
    (Lo := (-0.00877179)) (Hi := 0.00519649) (Klo := 0.00031613419) (Khi := 0.00073498237)
    (by norm_num) (by norm_num) (by norm_num) errPtT44
    vbpT43.1 vbpT43.2 vbpT44.1 vbpT44.2 vbpT39.1 vbpT39.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h9 := errBlockLin_of_piece (q0 := 3.1622771) (q1 := 3.1622782) (m := vBP 3.0413818)
    (Lo := (-0.00724813)) (Hi := 0.01404429) (Klo := (-0.000198355246)) (Khi := 0.000198389804)
    (by norm_num) (by norm_num) (by norm_num) errPtT45
    vbpT44.1 vbpT44.2 vbpT45.1 vbpT45.2 vbpT39.1 vbpT39.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  exact (((((((((h0.add h1).add h2).add h3).add h4).add h5).add h6).add h7).add h8).add h9).mono (by norm_num) (by norm_num) (by norm_num [mn4])
    (by norm_num [mx4]) (by norm_num)

theorem blkLo17 : errBlockLin (vBP 2.9580404) (vBP 3.1622782) (vBP 3.0413818) (-0.0002252667) 0.0004336401 (-0.0000292735) 0.0000436681 0.0005401538 :=
  errBlockLin.mono blkLo17_0 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
    (by norm_num)

theorem blkLo18_0 : errBlockLin (vBP 3.1622782) (vBP 3.3541025) (vBP 3.2403709) (-0.0001466912) 0.0003137585 (-0.0000276875) 0.0000258024 0.00038992 := by
  have h0 := errBlockLin_of_piece (q0 := 3.1622782) (q1 := 3.2015616) (m := vBP 3.2403709)
    (Lo := (-0.00866808)) (Hi := 0.00483795) (Klo := (-0.000467807558)) (Khi := (-0.00009767535))
    (by norm_num) (by norm_num) (by norm_num) errPtT46
    vbpT45.1 vbpT45.2 vbpT46.1 vbpT46.2 vbpT49.1 vbpT49.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h1 := errBlockLin_of_piece (q0 := 3.2015616) (q1 := 3.2015627) (m := vBP 3.2403709)
    (Lo := (-0.00706192)) (Hi := 0.01367418) (Klo := (-0.000192784086)) (Khi := 0.000192773322)
    (by norm_num) (by norm_num) (by norm_num) errPtT47
    vbpT46.1 vbpT46.2 vbpT47.1 vbpT47.2 vbpT49.1 vbpT49.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h2 := errBlockLin_of_piece (q0 := 3.2015627) (q1 := 3.2403698) (m := vBP 3.2403709)
    (Lo := 0.00175222) (Hi := 0.01485011) (Klo := (-0.000273064119)) (Khi := 0.000091744612)
    (by norm_num) (by norm_num) (by norm_num) errPtT48
    vbpT47.1 vbpT47.2 vbpT48.1 vbpT48.2 vbpT49.1 vbpT49.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h3 := errBlockLin_of_piece (q0 := 3.2403698) (q1 := 3.2403709) (m := vBP 3.2403709)
    (Lo := (-0.00688781)) (Hi := 0.01332102) (Klo := (-0.00017202976)) (Khi := 0.000172029679)
    (by norm_num) (by norm_num) (by norm_num) errPtT49
    vbpT48.1 vbpT48.2 vbpT49.1 vbpT49.2 vbpT49.1 vbpT49.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h4 := errBlockLin_of_piece (q0 := 3.2403709) (q1 := 3.2787187) (m := vBP 3.2403709)
    (Lo := 0.00189781) (Hi := 0.01458851) (Klo := (-0.000094055186)) (Khi := 0.000264065491)
    (by norm_num) (by norm_num) (by norm_num) errPtT50
    vbpT49.1 vbpT49.2 vbpT50.1 vbpT50.2 vbpT49.1 vbpT49.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h5 := errBlockLin_of_piece (q0 := 3.2787187) (q1 := 3.2787198) (m := vBP 3.2403709)
    (Lo := (-0.00672461)) (Hi := 0.01298376) (Klo := (-0.000186086755)) (Khi := 0.000186095768)
    (by norm_num) (by norm_num) (by norm_num) errPtT51
    vbpT50.1 vbpT50.2 vbpT51.1 vbpT51.2 vbpT49.1 vbpT49.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h6 := errBlockLin_of_piece (q0 := 3.2787198) (q1 := 3.3166242) (m := vBP 3.2403709)
    (Lo := (-0.00778216)) (Hi := 0.00450448) (Klo := 0.000050203501) (Khi := 0.0004383728)
    (by norm_num) (by norm_num) (by norm_num) errPtT52
    vbpT51.1 vbpT51.2 vbpT52.1 vbpT52.2 vbpT49.1 vbpT49.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h7 := errBlockLin_of_piece (q0 := 3.3166242) (q1 := 3.3166253) (m := vBP 3.2403709)
    (Lo := (-0.00657124)) (Hi := 0.01266143) (Klo := (-0.000202068834)) (Khi := 0.00020208723)
    (by norm_num) (by norm_num) (by norm_num) errPtT53
    vbpT52.1 vbpT52.2 vbpT53.1 vbpT53.2 vbpT49.1 vbpT49.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h8 := errBlockLin_of_piece (q0 := 3.3166253) (q1 := 3.3541014) (m := vBP 3.2403709)
    (Lo := (-0.00771396)) (Hi := 0.00421296) (Klo := 0.000197965579) (Khi := 0.000579316933)
    (by norm_num) (by norm_num) (by norm_num) errPtT54
    vbpT53.1 vbpT53.2 vbpT54.1 vbpT54.2 vbpT49.1 vbpT49.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h9 := errBlockLin_of_piece (q0 := 3.3541014) (q1 := 3.3541025) (m := vBP 3.2403709)
    (Lo := (-0.00642678)) (Hi := 0.01235314) (Klo := (-0.000179259585)) (Khi := 0.000179286465)
    (by norm_num) (by norm_num) (by norm_num) errPtT55
    vbpT54.1 vbpT54.2 vbpT55.1 vbpT55.2 vbpT49.1 vbpT49.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  exact (((((((((h0.add h1).add h2).add h3).add h4).add h5).add h6).add h7).add h8).add h9).mono (by norm_num) (by norm_num) (by norm_num [mn4])
    (by norm_num [mx4]) (by norm_num)

theorem blkLo18 : errBlockLin (vBP 3.1622782) (vBP 3.3541025) (vBP 3.2403709) (-0.0001466912) 0.0003137585 (-0.0000276875) 0.0000258024 0.00038992 :=
  errBlockLin.mono blkLo18_0 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
    (by norm_num)

theorem blkLo19_0 : errBlockLin (vBP 3.3541025) (vBP 3.5707148) (vBP 3.4641011) (-0.0000430228) 0.0003504664 (-0.0000294665) 0.0000265157 0.0003886761 := by
  have h0 := errBlockLin_of_piece (q0 := 3.3541025) (q1 := 3.3911644) (m := vBP 3.4641011)
    (Lo := 0.00169902) (Hi := 0.01330517) (Klo := (-0.000560600257)) (Khi := (-0.000137111827))
    (by norm_num) (by norm_num) (by norm_num) errPtT56
    vbpT55.1 vbpT55.2 vbpT56.1 vbpT56.2 vbpT60.1 vbpT60.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h1 := errBlockLin_of_piece (q0 := 3.3911644) (q1 := 3.3911655) (m := vBP 3.4641011)
    (Lo := (-0.00629041)) (Hi := 0.01205806) (Klo := (-0.000218842237)) (Khi := 0.000218826242)
    (by norm_num) (by norm_num) (by norm_num) errPtT57
    vbpT56.1 vbpT56.2 vbpT57.1 vbpT57.2 vbpT60.1 vbpT60.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h2 := errBlockLin_of_piece (q0 := 3.3911655) (q1 := 3.4278268) (m := vBP 3.4641011)
    (Lo := 0.00180706) (Hi := 0.01309185) (Klo := (-0.000409121557)) (Khi := 0.00000698837)
    (by norm_num) (by norm_num) (by norm_num) errPtT58
    vbpT57.1 vbpT57.2 vbpT58.1 vbpT58.2 vbpT60.1 vbpT60.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h3 := errBlockLin_of_piece (q0 := 3.4278268) (q1 := 3.4278279) (m := vBP 3.4641011)
    (Lo := (-0.00616141)) (Hi := 0.01177542) (Klo := (-0.000197279452)) (Khi := 0.000197271342)
    (by norm_num) (by norm_num) (by norm_num) errPtT59
    vbpT58.1 vbpT58.2 vbpT59.1 vbpT59.2 vbpT60.1 vbpT60.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h4 := errBlockLin_of_piece (q0 := 3.4278279) (q1 := 3.4641011) (m := vBP 3.4641011)
    (Lo := (-0.00702242)) (Hi := 0.00394204) (Klo := (-0.000267884583)) (Khi := 0.000139460864)
    (by norm_num) (by norm_num) (by norm_num) errPtT60
    vbpT59.1 vbpT59.2 vbpT60.1 vbpT60.2 vbpT60.1 vbpT60.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h5 := errBlockLin_of_piece (q0 := 3.4641011) (q1 := 3.4641022) (m := vBP 3.4641011)
    (Lo := (-0.00603914)) (Hi := 0.0115045) (Klo := (-0.000210070577)) (Khi := 0.000210070098)
    (by norm_num) (by norm_num) (by norm_num) errPtT61
    vbpT60.1 vbpT60.2 vbpT61.1 vbpT61.2 vbpT60.1 vbpT60.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h6 := errBlockLin_of_piece (q0 := 3.4641022) (q1 := 3.4999995) (m := vBP 3.4641011)
    (Lo := (-0.00697567)) (Hi := 0.00370116) (Klo := (-0.000139380785)) (Khi := 0.000260694978)
    (by norm_num) (by norm_num) (by norm_num) errPtT62
    vbpT61.1 vbpT61.2 vbpT62.1 vbpT62.2 vbpT60.1 vbpT60.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h7 := errBlockLin_of_piece (q0 := 3.4999995) (q1 := 3.5000005) (m := vBP 3.4641011)
    (Lo := (-0.00592304)) (Hi := 0.01124463) (Klo := (-0.000190002103)) (Khi := 0.000190008755)
    (by norm_num) (by norm_num) (by norm_num) errPtT63
    vbpT62.1 vbpT62.2 vbpT63.1 vbpT63.2 vbpT60.1 vbpT60.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h8 := errBlockLin_of_piece (q0 := 3.5000005) (q1 := 3.5355334) (m := vBP 3.4641011)
    (Lo := 0.00161352) (Hi := 0.01203162) (Klo := (-0.000019252059)) (Khi := 0.000372290404)
    (by norm_num) (by norm_num) (by norm_num) errPtT64
    vbpT63.1 vbpT63.2 vbpT64.1 vbpT64.2 vbpT60.1 vbpT60.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h9 := errBlockLin_of_piece (q0 := 3.5355334) (q1 := 3.5355345) (m := vBP 3.4641011)
    (Lo := (-0.00581261)) (Hi := 0.0109952) (Klo := (-0.000201529982)) (Khi := 0.000201544073)
    (by norm_num) (by norm_num) (by norm_num) errPtT65
    vbpT64.1 vbpT64.2 vbpT65.1 vbpT65.2 vbpT60.1 vbpT60.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h10 := errBlockLin_of_piece (q0 := 3.5355345) (q1 := 3.5707137) (m := vBP 3.4641011)
    (Lo := 0.00169684) (Hi := 0.01185497) (Klo := 0.000090119863) (Khi := 0.000474567915)
    (by norm_num) (by norm_num) (by norm_num) errPtT66
    vbpT65.1 vbpT65.2 vbpT66.1 vbpT66.2 vbpT60.1 vbpT60.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h11 := errBlockLin_of_piece (q0 := 3.5707137) (q1 := 3.5707148) (m := vBP 3.4641011)
    (Lo := (-0.00570739)) (Hi := 0.01075563) (Klo := (-0.000182900215)) (Khi := 0.000182921274)
    (by norm_num) (by norm_num) (by norm_num) errPtT67
    vbpT66.1 vbpT66.2 vbpT67.1 vbpT67.2 vbpT60.1 vbpT60.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  exact (((((((((((h0.add h1).add h2).add h3).add h4).add h5).add h6).add h7).add h8).add h9).add h10).add h11).mono (by norm_num) (by norm_num) (by norm_num [mn4])
    (by norm_num [mx4]) (by norm_num)

theorem blkLo19 : errBlockLin (vBP 3.3541025) (vBP 3.5707148) (vBP 3.4641011) (-0.0000430228) 0.0003504664 (-0.0000294665) 0.0000265157 0.0003886761 :=
  errBlockLin.mono blkLo19_0 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
    (by norm_num)

theorem blkLo20_0 : errBlockLin (vBP 3.5707148) (vBP 3.8078871) (vBP 3.6742352) (-0.0001026836) 0.0002207655 (-0.000022898) 0.0000279927 0.0002807712 := by
  have h0 := errBlockLin_of_piece (q0 := 3.5707148) (q1 := 3.6055507) (m := vBP 3.6742352)
    (Lo := (-0.0064193)) (Hi := 0.00347892) (Klo := (-0.000431824761)) (Khi := (-0.000081583826))
    (by norm_num) (by norm_num) (by norm_num) errPtT68
    vbpT67.1 vbpT67.2 vbpT68.1 vbpT68.2 vbpT73.1 vbpT73.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h1 := errBlockLin_of_piece (q0 := 3.6055507) (q1 := 3.6055518) (m := vBP 3.6742352)
    (Lo := (-0.00560698)) (Hi := 0.01052538) (Klo := (-0.000180380931)) (Khi := 0.000180368346)
    (by norm_num) (by norm_num) (by norm_num) errPtT69
    vbpT68.1 vbpT68.2 vbpT69.1 vbpT69.2 vbpT73.1 vbpT73.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h2 := errBlockLin_of_piece (q0 := 3.6055518) (q1 := 3.6400544) (m := vBP 3.6742352)
    (Lo := (-0.00638598)) (Hi := 0.00327704) (Klo := (-0.000334476284)) (Khi := 0.000037958644)
    (by norm_num) (by norm_num) (by norm_num) errPtT70
    vbpT69.1 vbpT69.2 vbpT70.1 vbpT70.2 vbpT73.1 vbpT73.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h3 := errBlockLin_of_piece (q0 := 3.6400544) (q1 := 3.6400555) (m := vBP 3.6742352)
    (Lo := (-0.00551102)) (Hi := 0.01030395) (Klo := (-0.000192063179)) (Khi := 0.000192057397)
    (by norm_num) (by norm_num) (by norm_num) errPtT71
    vbpT70.1 vbpT70.2 vbpT71.1 vbpT71.2 vbpT73.1 vbpT73.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h4 := errBlockLin_of_piece (q0 := 3.6400555) (q1 := 3.6742341) (m := vBP 3.6742352)
    (Lo := 0.00151579) (Hi := 0.01096572) (Klo := (-0.0002304937)) (Khi := 0.00013426813)
    (by norm_num) (by norm_num) (by norm_num) errPtT72
    vbpT71.1 vbpT71.2 vbpT72.1 vbpT72.2 vbpT73.1 vbpT73.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h5 := errBlockLin_of_piece (q0 := 3.6742341) (q1 := 3.6742352) (m := vBP 3.6742352)
    (Lo := (-0.00541918)) (Hi := 0.01009088) (Klo := (-0.000172701674)) (Khi := 0.000172701961)
    (by norm_num) (by norm_num) (by norm_num) errPtT73
    vbpT72.1 vbpT72.2 vbpT73.1 vbpT73.2 vbpT73.1 vbpT73.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h6 := errBlockLin_of_piece (q0 := 3.6742352) (q1 := 3.7080987) (m := vBP 3.6742352)
    (Lo := 0.00158212) (Hi := 0.01081752) (Klo := (-0.00013225396)) (Khi := 0.000223636864)
    (by norm_num) (by norm_num) (by norm_num) errPtT74
    vbpT73.1 vbpT73.2 vbpT74.1 vbpT74.2 vbpT73.1 vbpT73.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h7 := errBlockLin_of_piece (q0 := 3.7080987) (q1 := 3.7080998) (m := vBP 3.6742352)
    (Lo := (-0.00533117)) (Hi := 0.00988572) (Klo := (-0.000183186177)) (Khi := 0.000183191828)
    (by norm_num) (by norm_num) (by norm_num) errPtT75
    vbpT74.1 vbpT74.2 vbpT75.1 vbpT75.2 vbpT73.1 vbpT73.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h8 := errBlockLin_of_piece (q0 := 3.7080998) (q1 := 3.7416568) (m := vBP 3.6742352)
    (Lo := (-0.00592729)) (Hi := 0.00309312) (Klo := (-0.000042247187)) (Khi := 0.000306313719)
    (by norm_num) (by norm_num) (by norm_num) errPtT76
    vbpT75.1 vbpT75.2 vbpT76.1 vbpT76.2 vbpT73.1 vbpT73.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h9 := errBlockLin_of_piece (q0 := 3.7416568) (q1 := 3.7416579) (m := vBP 3.6742352)
    (Lo := (-0.00524673)) (Hi := 0.00968807) (Klo := (-0.00016536647)) (Khi := 0.000165377873)
    (by norm_num) (by norm_num) (by norm_num) errPtT77
    vbpT76.1 vbpT76.2 vbpT77.1 vbpT77.2 vbpT73.1 vbpT73.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h10 := errBlockLin_of_piece (q0 := 3.7416579) (q1 := 3.7749167) (m := vBP 3.6742352)
    (Lo := (-0.00590268)) (Hi := 0.00292189) (Klo := 0.000042944073) (Khi := 0.00038309836)
    (by norm_num) (by norm_num) (by norm_num) errPtT78
    vbpT77.1 vbpT77.2 vbpT78.1 vbpT78.2 vbpT73.1 vbpT73.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h11 := errBlockLin_of_piece (q0 := 3.7749167) (q1 := 3.7749178) (m := vBP 3.6742352)
    (Lo := (-0.00516561)) (Hi := 0.00949755) (Klo := (-0.000174773342)) (Khi := 0.000174789818)
    (by norm_num) (by norm_num) (by norm_num) errPtT79
    vbpT78.1 vbpT78.2 vbpT79.1 vbpT79.2 vbpT73.1 vbpT73.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h12 := errBlockLin_of_piece (q0 := 3.7749178) (q1 := 3.807886) (m := vBP 3.6742352)
    (Lo := 0.00141601) (Hi := 0.01006202) (Klo := 0.000108027006) (Khi := 0.000467947507)
    (by norm_num) (by norm_num) (by norm_num) errPtT80
    vbpT79.1 vbpT79.2 vbpT80.1 vbpT80.2 vbpT73.1 vbpT73.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h13 := errBlockLin_of_piece (q0 := 3.807886) (q1 := 3.8078871) (m := vBP 3.6742352)
    (Lo := (-0.00508759)) (Hi := 0.0093138) (Klo := (-0.00018512821)) (Khi := 0.000185149629)
    (by norm_num) (by norm_num) (by norm_num) errPtT81
    vbpT80.1 vbpT80.2 vbpT81.1 vbpT81.2 vbpT73.1 vbpT73.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  exact (((((((((((((h0.add h1).add h2).add h3).add h4).add h5).add h6).add h7).add h8).add h9).add h10).add h11).add h12).add h13).mono (by norm_num) (by norm_num) (by norm_num [mn4])
    (by norm_num [mx4]) (by norm_num)

theorem blkLo20 : errBlockLin (vBP 3.5707148) (vBP 3.8078871) (vBP 3.6742352) (-0.0001026836) 0.0002207655 (-0.000022898) 0.0000279927 0.0002807712 :=
  errBlockLin.mono blkLo20_0 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
    (by norm_num)

theorem blkLo21_0 : errBlockLin (vBP 3.8078871) (vBP 4.0620198) (vBP 3.9370034) (-0.0000655387) 0.0001947916 (-0.0000241893) 0.0000230779 0.0002403346 := by
  have h0 := errBlockLin_of_piece (q0 := 3.8078871) (q1 := 3.8405723) (m := vBP 3.9370034)
    (Lo := 0.00147026) (Hi := 0.00993626) (Klo := (-0.000442864489)) (Khi := (-0.000077523474))
    (by norm_num) (by norm_num) (by norm_num) errPtT82
    vbpT81.1 vbpT81.2 vbpT82.1 vbpT82.2 vbpT88.1 vbpT88.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h1 := errBlockLin_of_piece (q0 := 3.8405723) (q1 := 3.8405734) (m := vBP 3.9370034)
    (Lo := (-0.00501248)) (Hi := 0.00913648) (Klo := (-0.000173500875)) (Khi := 0.000173485904)
    (by norm_num) (by norm_num) (by norm_num) errPtT83
    vbpT82.1 vbpT82.2 vbpT83.1 vbpT83.2 vbpT88.1 vbpT88.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h2 := errBlockLin_of_piece (q0 := 3.8405734) (q1 := 3.8729828) (m := vBP 3.9370034)
    (Lo := (-0.00551691)) (Hi := 0.00276838) (Klo := (-0.000357529086)) (Khi := (-0.000001327448))
    (by norm_num) (by norm_num) (by norm_num) errPtT84
    vbpT83.1 vbpT83.2 vbpT84.1 vbpT84.2 vbpT88.1 vbpT88.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h3 := errBlockLin_of_piece (q0 := 3.8729828) (q1 := 3.8729839) (m := vBP 3.9370034)
    (Lo := (-0.00494009)) (Hi := 0.00896527) (Klo := (-0.000182713038)) (Khi := 0.000182703458)
    (by norm_num) (by norm_num) (by norm_num) errPtT85
    vbpT84.1 vbpT84.2 vbpT85.1 vbpT85.2 vbpT88.1 vbpT88.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h4 := errBlockLin_of_piece (q0 := 3.8729839) (q1 := 3.9051243) (m := vBP 3.9370034)
    (Lo := (-0.00549811)) (Hi := 0.0026216) (Klo := (-0.000278802031)) (Khi := 0.000069812307)
    (by norm_num) (by norm_num) (by norm_num) errPtT86
    vbpT85.1 vbpT85.2 vbpT86.1 vbpT86.2 vbpT88.1 vbpT88.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h5 := errBlockLin_of_piece (q0 := 3.9051243) (q1 := 3.9051254) (m := vBP 3.9370034)
    (Lo := (-0.00487026)) (Hi := 0.00879989) (Klo := (-0.000165908764)) (Khi := 0.000165903932)
    (by norm_num) (by norm_num) (by norm_num) errPtT87
    vbpT86.1 vbpT86.2 vbpT87.1 vbpT87.2 vbpT88.1 vbpT88.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h6 := errBlockLin_of_piece (q0 := 3.9051254) (q1 := 3.9370034) (m := vBP 3.9370034)
    (Lo := 0.00131929) (Hi := 0.00928722) (Klo := (-0.000203674221)) (Khi := 0.000136385118)
    (by norm_num) (by norm_num) (by norm_num) errPtT88
    vbpT87.1 vbpT87.2 vbpT88.1 vbpT88.2 vbpT88.1 vbpT88.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h7 := errBlockLin_of_piece (q0 := 3.9370034) (q1 := 3.9370045) (m := vBP 3.9370034)
    (Lo := (-0.00480284)) (Hi := 0.00864006) (Klo := (-0.000174152835)) (Khi := 0.000174153141)
    (by norm_num) (by norm_num) (by norm_num) errPtT89
    vbpT88.1 vbpT88.2 vbpT89.1 vbpT89.2 vbpT88.1 vbpT88.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h8 := errBlockLin_of_piece (q0 := 3.9370045) (q1 := 3.9686264) (m := vBP 3.9370034)
    (Lo := 0.00136469) (Hi := 0.00917942) (Klo := (-0.000146193813)) (Khi := 0.000211123031)
    (by norm_num) (by norm_num) (by norm_num) errPtT90
    vbpT89.1 vbpT89.2 vbpT90.1 vbpT90.2 vbpT88.1 vbpT88.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h9 := errBlockLin_of_piece (q0 := 3.9686264) (q1 := 3.9686275) (m := vBP 3.9370034)
    (Lo := (-0.00473768)) (Hi := 0.00848551) (Klo := (-0.000183161694)) (Khi := 0.000183166011)
    (by norm_num) (by norm_num) (by norm_num) errPtT91
    vbpT90.1 vbpT90.2 vbpT91.1 vbpT91.2 vbpT88.1 vbpT88.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h10 := errBlockLin_of_piece (q0 := 3.9686275) (q1 := 3.9999995) (m := vBP 3.9370034)
    (Lo := (-0.00516827)) (Hi := 0.00249248) (Klo := (-0.000080547871)) (Khi := 0.000268774229)
    (by norm_num) (by norm_num) (by norm_num) errPtT92
    vbpT91.1 vbpT91.2 vbpT92.1 vbpT92.2 vbpT88.1 vbpT88.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h11 := errBlockLin_of_piece (q0 := 3.9999995) (q1 := 4.0000005) (m := vBP 3.9370034)
    (Lo := (-0.00467466)) (Hi := 0.008336) (Klo := (-0.000166154032)) (Khi := 0.000166162469)
    (by norm_num) (by norm_num) (by norm_num) errPtT93
    vbpT92.1 vbpT92.2 vbpT93.1 vbpT93.2 vbpT88.1 vbpT88.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h12 := errBlockLin_of_piece (q0 := 4.0000005) (q1 := 4.0311283) (m := vBP 3.9370034)
    (Lo := (-0.00515345)) (Hi := 0.00236547) (Klo := (-0.00001760292)) (Khi := 0.000322765347)
    (by norm_num) (by norm_num) (by norm_num) errPtT94
    vbpT93.1 vbpT93.2 vbpT94.1 vbpT94.2 vbpT88.1 vbpT88.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h13 := errBlockLin_of_piece (q0 := 4.0311283) (q1 := 4.0311294) (m := vBP 3.9370034)
    (Lo := (-0.00461365)) (Hi := 0.00819131) (Klo := (-0.000174203488)) (Khi := 0.000174216038)
    (by norm_num) (by norm_num) (by norm_num) errPtT95
    vbpT94.1 vbpT94.2 vbpT95.1 vbpT95.2 vbpT88.1 vbpT88.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h14 := errBlockLin_of_piece (q0 := 4.0311294) (q1 := 4.0620187) (m := vBP 3.9370034)
    (Lo := 0.00122808) (Hi := 0.00861641) (Klo := 0.00004040317) (Khi := 0.00037331085)
    (by norm_num) (by norm_num) (by norm_num) errPtT96
    vbpT95.1 vbpT95.2 vbpT96.1 vbpT96.2 vbpT88.1 vbpT88.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h15 := errBlockLin_of_piece (q0 := 4.0620187) (q1 := 4.0620198) (m := vBP 3.9370034)
    (Lo := (-0.00455456)) (Hi := 0.0080512) (Klo := (-0.000158689779)) (Khi := 0.000158706059)
    (by norm_num) (by norm_num) (by norm_num) errPtT97
    vbpT96.1 vbpT96.2 vbpT97.1 vbpT97.2 vbpT88.1 vbpT88.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  exact (((((((((((((((h0.add h1).add h2).add h3).add h4).add h5).add h6).add h7).add h8).add h9).add h10).add h11).add h12).add h13).add h14).add h15).mono (by norm_num) (by norm_num) (by norm_num [mn4])
    (by norm_num [mx4]) (by norm_num)

theorem blkLo21 : errBlockLin (vBP 3.8078871) (vBP 4.0620198) (vBP 3.9370034) (-0.0000655387) 0.0001947916 (-0.0000241893) 0.0000230779 0.0002403346 :=
  errBlockLin.mono blkLo21_0 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
    (by norm_num)

theorem blkLo22_0 : errBlockLin (vBP 4.0620198) (vBP 4.3301276) (vBP 4.1833007) (-0.0000454251) 0.0001618494 (-0.0000204152) 0.0000225065 0.0001978257 := by
  have h0 := errBlockLin_of_piece (q0 := 4.0620198) (q1 := 4.0926758) (m := vBP 4.1833007)
    (Lo := 0.00126681) (Hi := 0.00852317) (Klo := (-0.000352800456)) (Khi := (-0.000025630955))
    (by norm_num) (by norm_num) (by norm_num) errPtT98
    vbpT97.1 vbpT97.2 vbpT98.1 vbpT98.2 vbpT105.1 vbpT105.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h1 := errBlockLin_of_piece (q0 := 4.0926758) (q1 := 4.0926769) (m := vBP 4.1833007)
    (Lo := (-0.00449727)) (Hi := 0.00791548) (Klo := (-0.000167184111)) (Khi := 0.00016717216)
    (by norm_num) (by norm_num) (by norm_num) errPtT99
    vbpT98.1 vbpT98.2 vbpT99.1 vbpT99.2 vbpT105.1 vbpT105.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h2 := errBlockLin_of_piece (q0 := 4.0926769) (q1 := 4.1231051) (m := vBP 4.1833007)
    (Lo := (-0.00486752)) (Hi := 0.00225611) (Klo := (-0.000302266768)) (Khi := 0.000039893061)
    (by norm_num) (by norm_num) (by norm_num) errPtT100
    vbpT99.1 vbpT99.2 vbpT100.1 vbpT100.2 vbpT105.1 vbpT105.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h3 := errBlockLin_of_piece (q0 := 4.1231051) (q1 := 4.1231062) (m := vBP 4.1833007)
    (Lo := (-0.0044417)) (Hi := 0.00778395) (Klo := (-0.000174985163)) (Khi := 0.000174978221)
    (by norm_num) (by norm_num) (by norm_num) errPtT101
    vbpT100.1 vbpT100.2 vbpT101.1 vbpT101.2 vbpT105.1 vbpT105.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h4 := errBlockLin_of_piece (q0 := 4.1231062) (q1 := 4.1533114) (m := vBP 4.1833007)
    (Lo := (-0.0048555)) (Hi := 0.00214531) (Klo := (-0.000243937187)) (Khi := 0.000090487379)
    (by norm_num) (by norm_num) (by norm_num) errPtT102
    vbpT101.1 vbpT101.2 vbpT102.1 vbpT102.2 vbpT105.1 vbpT105.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h5 := errBlockLin_of_piece (q0 := 4.1533114) (q1 := 4.1533125) (m := vBP 4.1833007)
    (Lo := (-0.00438776)) (Hi := 0.00765644) (Klo := (-0.000159444857)) (Khi := 0.000159441377)
    (by norm_num) (by norm_num) (by norm_num) errPtT103
    vbpT102.1 vbpT102.2 vbpT103.1 vbpT103.2 vbpT105.1 vbpT105.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h6 := errBlockLin_of_piece (q0 := 4.1533125) (q1 := 4.1832996) (m := vBP 4.1833007)
    (Lo := 0.00114337) (Hi := 0.00803058) (Klo := (-0.000187701487)) (Khi := 0.000138153072)
    (by norm_num) (by norm_num) (by norm_num) errPtT104
    vbpT103.1 vbpT103.2 vbpT104.1 vbpT104.2 vbpT105.1 vbpT105.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h7 := errBlockLin_of_piece (q0 := 4.1832996) (q1 := 4.1833007) (m := vBP 4.1833007)
    (Lo := (-0.00433536)) (Hi := 0.00753276) (Klo := (-0.000166411249)) (Khi := 0.000166411153)
    (by norm_num) (by norm_num) (by norm_num) errPtT105
    vbpT104.1 vbpT104.2 vbpT105.1 vbpT105.2 vbpT105.1 vbpT105.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h8 := errBlockLin_of_piece (q0 := 4.1833007) (q1 := 4.2130743) (m := vBP 4.1833007)
    (Lo := 0.00117691) (Hi := 0.0079493) (Klo := (-0.000146148473)) (Khi := 0.000194207895)
    (by norm_num) (by norm_num) (by norm_num) errPtT106
    vbpT105.1 vbpT105.2 vbpT106.1 vbpT106.2 vbpT105.1 vbpT105.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h9 := errBlockLin_of_piece (q0 := 4.2130743) (q1 := 4.2130754) (m := vBP 4.1833007)
    (Lo := (-0.00428444)) (Hi := 0.00741275) (Klo := (-0.00017394332)) (Khi := 0.000173947011)
    (by norm_num) (by norm_num) (by norm_num) errPtT107
    vbpT106.1 vbpT106.2 vbpT107.1 vbpT107.2 vbpT105.1 vbpT105.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h10 := errBlockLin_of_piece (q0 := 4.2130754) (q1 := 4.2426401) (m := vBP 4.1833007)
    (Lo := (-0.00460475)) (Hi := 0.00205205) (Klo := (-0.000096368633)) (Khi := 0.000236069332)
    (by norm_num) (by norm_num) (by norm_num) errPtT108
    vbpT107.1 vbpT107.2 vbpT108.1 vbpT108.2 vbpT105.1 vbpT105.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h11 := errBlockLin_of_piece (q0 := 4.2426401) (q1 := 4.2426412) (m := vBP 4.1833007)
    (Lo := (-0.00423492)) (Hi := 0.00729627) (Klo := (-0.000158489573)) (Khi := 0.000158496501)
    (by norm_num) (by norm_num) (by norm_num) errPtT109
    vbpT108.1 vbpT108.2 vbpT109.1 vbpT109.2 vbpT105.1 vbpT105.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h12 := errBlockLin_of_piece (q0 := 4.2426412) (q1 := 4.2720013) (m := vBP 4.1833007)
    (Lo := (-0.00459474)) (Hi := 0.00195466) (Klo := (-0.000048183924)) (Khi := 0.000275525102)
    (by norm_num) (by norm_num) (by norm_num) errPtT110
    vbpT109.1 vbpT109.2 vbpT110.1 vbpT110.2 vbpT105.1 vbpT105.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h13 := errBlockLin_of_piece (q0 := 4.2720013) (q1 := 4.2720024) (m := vBP 4.1833007)
    (Lo := (-0.00418673)) (Hi := 0.00718316) (Klo := (-0.000165211171)) (Khi := 0.000165220803)
    (by norm_num) (by norm_num) (by norm_num) errPtT111
    vbpT110.1 vbpT110.2 vbpT111.1 vbpT111.2 vbpT105.1 vbpT105.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h14 := errBlockLin_of_piece (q0 := 4.2720024) (q1 := 4.3011621) (m := vBP 4.1833007)
    (Lo := 0.00106533) (Hi := 0.00751504) (Klo := (-0.000013989446)) (Khi := 0.000323685262)
    (by norm_num) (by norm_num) (by norm_num) errPtT112
    vbpT111.1 vbpT111.2 vbpT112.1 vbpT112.2 vbpT105.1 vbpT105.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h15 := errBlockLin_of_piece (q0 := 4.3011621) (q1 := 4.3011632) (m := vBP 4.1833007)
    (Lo := (-0.00413982)) (Hi := 0.00707328) (Klo := (-0.000172452116)) (Khi := 0.000172464858)
    (by norm_num) (by norm_num) (by norm_num) errPtT113
    vbpT112.1 vbpT112.2 vbpT113.1 vbpT113.2 vbpT105.1 vbpT105.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h16 := errBlockLin_of_piece (q0 := 4.3011632) (q1 := 4.3301265) (m := vBP 4.1833007)
    (Lo := 0.00109478) (Hi := 0.00744367) (Klo := 0.000028692891) (Khi := 0.000358331984)
    (by norm_num) (by norm_num) (by norm_num) errPtT114
    vbpT113.1 vbpT113.2 vbpT114.1 vbpT114.2 vbpT105.1 vbpT105.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h17 := errBlockLin_of_piece (q0 := 4.3301265) (q1 := 4.3301276) (m := vBP 4.1833007)
    (Lo := (-0.00409413)) (Hi := 0.00696652) (Klo := (-0.000157172481)) (Khi := 0.000157188735)
    (by norm_num) (by norm_num) (by norm_num) errPtT115
    vbpT114.1 vbpT114.2 vbpT115.1 vbpT115.2 vbpT105.1 vbpT105.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  exact (((((((((((((((((h0.add h1).add h2).add h3).add h4).add h5).add h6).add h7).add h8).add h9).add h10).add h11).add h12).add h13).add h14).add h15).add h16).add h17).mono (by norm_num) (by norm_num) (by norm_num [mn4])
    (by norm_num [mx4]) (by norm_num)

theorem blkLo22 : errBlockLin (vBP 4.0620198) (vBP 4.3301276) (vBP 4.1833007) (-0.0000454251) 0.0001618494 (-0.0000204152) 0.0000225065 0.0001978257 :=
  errBlockLin.mono blkLo22_0 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
    (by norm_num)

theorem blkLo23_0 : errBlockLin (vBP 4.3301276) (vBP 4.6368098) (vBP 4.4721365) (-0.0000572021) 0.000120904 (-0.0000189506) 0.0000208467 0.0001626994 := by
  have h0 := errBlockLin_of_piece (q0 := 4.3301276) (q1 := 4.3588984) (m := vBP 4.4721365)
    (Lo := (-0.00437265)) (Hi := 0.00187465) (Klo := (-0.000329148852)) (Khi := (-0.000023868069))
    (by norm_num) (by norm_num) (by norm_num) errPtT116
    vbpT115.1 vbpT115.2 vbpT116.1 vbpT116.2 vbpT125.1 vbpT125.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h1 := errBlockLin_of_piece (q0 := 4.3588984) (q1 := 4.3588995) (m := vBP 4.4721365)
    (Lo := (-0.00404961)) (Hi := 0.00686273) (Klo := (-0.000155902321)) (Khi := 0.000155890639)
    (by norm_num) (by norm_num) (by norm_num) errPtT117
    vbpT116.1 vbpT116.2 vbpT117.1 vbpT117.2 vbpT125.1 vbpT125.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h2 := errBlockLin_of_piece (q0 := 4.3588995) (q1 := 4.3874816) (m := vBP 4.4721365)
    (Lo := (-0.00436413)) (Hi := 0.00178849) (Klo := (-0.000282947925)) (Khi := 0.000015035743)
    (by norm_num) (by norm_num) (by norm_num) errPtT118
    vbpT117.1 vbpT117.2 vbpT118.1 vbpT118.2 vbpT125.1 vbpT125.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h3 := errBlockLin_of_piece (q0 := 4.3874816) (q1 := 4.3874827) (m := vBP 4.4721365)
    (Lo := (-0.00400621)) (Hi := 0.0067618) (Klo := (-0.00014209159)) (Khi := 0.000142082787)
    (by norm_num) (by norm_num) (by norm_num) errPtT119
    vbpT118.1 vbpT118.2 vbpT119.1 vbpT119.2 vbpT125.1 vbpT125.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h4 := errBlockLin_of_piece (q0 := 4.3874827) (q1 := 4.4158799) (m := vBP 4.4721365)
    (Lo := 0.0009938) (Hi := 0.00705822) (Klo := (-0.000238075414)) (Khi := 0.000051915011)
    (by norm_num) (by norm_num) (by norm_num) errPtT120
    vbpT119.1 vbpT119.2 vbpT120.1 vbpT120.2 vbpT125.1 vbpT125.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h5 := errBlockLin_of_piece (q0 := 4.4158799) (q1 := 4.415881) (m := vBP 4.4721365)
    (Lo := (-0.00396387)) (Hi := 0.00666362) (Klo := (-0.000147906226)) (Khi := 0.000147900243)
    (by norm_num) (by norm_num) (by norm_num) errPtT121
    vbpT120.1 vbpT120.2 vbpT121.1 vbpT121.2 vbpT125.1 vbpT125.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h6 := errBlockLin_of_piece (q0 := 4.415881) (q1 := 4.4440967) (m := vBP 4.4721365)
    (Lo := 0.00101996) (Hi := 0.00699515) (Klo := (-0.000205453603)) (Khi := 0.000096587351)
    (by norm_num) (by norm_num) (by norm_num) errPtT122
    vbpT121.1 vbpT121.2 vbpT122.1 vbpT122.2 vbpT125.1 vbpT125.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h7 := errBlockLin_of_piece (q0 := 4.4440967) (q1 := 4.4440978) (m := vBP 4.4721365)
    (Lo := (-0.00392256)) (Hi := 0.00656809) (Klo := (-0.000154139325)) (Khi := 0.000154136558)
    (by norm_num) (by norm_num) (by norm_num) errPtT123
    vbpT122.1 vbpT122.2 vbpT123.1 vbpT123.2 vbpT125.1 vbpT125.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h8 := errBlockLin_of_piece (q0 := 4.4440978) (q1 := 4.4721354) (m := vBP 4.4721365)
    (Lo := (-0.00416575)) (Hi := 0.00171948) (Klo := (-0.000165263842)) (Khi := 0.000129440937)
    (by norm_num) (by norm_num) (by norm_num) errPtT124
    vbpT123.1 vbpT123.2 vbpT124.1 vbpT124.2 vbpT125.1 vbpT125.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h9 := errBlockLin_of_piece (q0 := 4.4721354) (q1 := 4.4721365) (m := vBP 4.4721365)
    (Lo := (-0.00388223)) (Hi := 0.0064751) (Klo := (-0.000140566418)) (Khi := 0.00014056636)
    (by norm_num) (by norm_num) (by norm_num) errPtT125
    vbpT124.1 vbpT124.2 vbpT125.1 vbpT125.2 vbpT125.1 vbpT125.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h10 := errBlockLin_of_piece (q0 := 4.4721365) (q1 := 4.4999995) (m := vBP 4.4721365)
    (Lo := (-0.00415833)) (Hi := 0.00164282) (Klo := (-0.000126104573)) (Khi := 0.000160596037)
    (by norm_num) (by norm_num) (by norm_num) errPtT126
    vbpT125.1 vbpT125.2 vbpT126.1 vbpT126.2 vbpT125.1 vbpT125.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h11 := errBlockLin_of_piece (q0 := 4.4999995) (q1 := 4.5000005) (m := vBP 4.4721365)
    (Lo := (-0.00384284)) (Hi := 0.00638455) (Klo := (-0.000146132798)) (Khi := 0.000146135647)
    (by norm_num) (by norm_num) (by norm_num) errPtT127
    vbpT126.1 vbpT126.2 vbpT127.1 vbpT127.2 vbpT125.1 vbpT125.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h12 := errBlockLin_of_piece (q0 := 4.5000005) (q1 := 4.527692) (m := vBP 4.4721365)
    (Lo := 0.0009284) (Hi := 0.00665093) (Klo := (-0.000098615674)) (Khi := 0.000199605292)
    (by norm_num) (by norm_num) (by norm_num) errPtT128
    vbpT127.1 vbpT127.2 vbpT128.1 vbpT128.2 vbpT125.1 vbpT125.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h13 := errBlockLin_of_piece (q0 := 4.527692) (q1 := 4.5276931) (m := vBP 4.4721365)
    (Lo := (-0.00380437)) (Hi := 0.00629636) (Klo := (-0.000152084135)) (Khi := 0.000152089346)
    (by norm_num) (by norm_num) (by norm_num) errPtT129
    vbpT128.1 vbpT128.2 vbpT129.1 vbpT129.2 vbpT125.1 vbpT125.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h14 := errBlockLin_of_piece (q0 := 4.5276931) (q1 := 4.5552162) (m := vBP 4.4721365)
    (Lo := 0.00095188) (Hi := 0.00659486) (Klo := (-0.000063523982)) (Khi := 0.00022736669)
    (by norm_num) (by norm_num) (by norm_num) errPtT130
    vbpT129.1 vbpT129.2 vbpT130.1 vbpT130.2 vbpT125.1 vbpT125.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h15 := errBlockLin_of_piece (q0 := 4.5552162) (q1 := 4.5552173) (m := vBP 4.4721365)
    (Lo := (-0.00376677)) (Hi := 0.00621043) (Klo := (-0.000138800486)) (Khi := 0.00013880782)
    (by norm_num) (by norm_num) (by norm_num) errPtT131
    vbpT130.1 vbpT130.2 vbpT131.1 vbpT131.2 vbpT125.1 vbpT125.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h16 := errBlockLin_of_piece (q0 := 4.5552173) (q1 := 4.5825751) (m := vBP 4.4721365)
    (Lo := (-0.00397983)) (Hi := 0.00158299) (Klo := (-0.000029226384)) (Khi := 0.000253697378)
    (by norm_num) (by norm_num) (by norm_num) errPtT132
    vbpT131.1 vbpT131.2 vbpT132.1 vbpT132.2 vbpT125.1 vbpT125.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h17 := errBlockLin_of_piece (q0 := 4.5825751) (q1 := 4.5825762) (m := vBP 4.4721365)
    (Lo := (-0.00373)) (Hi := 0.00612669) (Klo := (-0.000144114679)) (Khi := 0.000144124535)
    (by norm_num) (by norm_num) (by norm_num) errPtT133
    vbpT132.1 vbpT132.2 vbpT133.1 vbpT133.2 vbpT125.1 vbpT125.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h18 := errBlockLin_of_piece (q0 := 4.5825762) (q1 := 4.6097717) (m := vBP 4.4721365)
    (Lo := (-0.00397326)) (Hi := 0.00151434) (Klo := (-0.000006046454)) (Khi := 0.00028786125)
    (by norm_num) (by norm_num) (by norm_num) errPtT134
    vbpT133.1 vbpT133.2 vbpT134.1 vbpT134.2 vbpT125.1 vbpT125.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h19 := errBlockLin_of_piece (q0 := 4.6097717) (q1 := 4.6097728) (m := vBP 4.4721365)
    (Lo := (-0.00369405)) (Hi := 0.00604506) (Klo := (-0.000149781928)) (Khi := 0.000149794261)
    (by norm_num) (by norm_num) (by norm_num) errPtT135
    vbpT134.1 vbpT134.2 vbpT135.1 vbpT135.2 vbpT125.1 vbpT125.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h20 := errBlockLin_of_piece (q0 := 4.6097728) (q1 := 4.6368087) (m := vBP 4.4721365)
    (Lo := 0.00086866) (Hi := 0.00628575) (Klo := 0.000024695782) (Khi := 0.000311319568)
    (by norm_num) (by norm_num) (by norm_num) errPtT136
    vbpT135.1 vbpT135.2 vbpT136.1 vbpT136.2 vbpT125.1 vbpT125.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h21 := errBlockLin_of_piece (q0 := 4.6368087) (q1 := 4.6368098) (m := vBP 4.4721365)
    (Lo := (-0.00365887)) (Hi := 0.00596545) (Klo := (-0.000136828307)) (Khi := 0.000136843077)
    (by norm_num) (by norm_num) (by norm_num) errPtT137
    vbpT136.1 vbpT136.2 vbpT137.1 vbpT137.2 vbpT125.1 vbpT125.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  exact (((((((((((((((((((((h0.add h1).add h2).add h3).add h4).add h5).add h6).add h7).add h8).add h9).add h10).add h11).add h12).add h13).add h14).add h15).add h16).add h17).add h18).add h19).add h20).add h21).mono (by norm_num) (by norm_num) (by norm_num [mn4])
    (by norm_num [mx4]) (by norm_num)

theorem blkLo23 : errBlockLin (vBP 4.3301276) (vBP 4.6368098) (vBP 4.4721365) (-0.0000572021) 0.000120904 (-0.0000189506) 0.0000208467 0.0001626994 :=
  errBlockLin.mono blkLo23_0 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
    (by norm_num)

theorem blkLo24_0 : errBlockLin (vBP 4.6368098) (vBP 4.949748) (vBP 4.795831) (-0.0000390278) 0.0000974523 (-0.0000178538) 0.0000173104 0.0001292308 := by
  have h0 := errBlockLin_of_piece (q0 := 4.6368098) (q1 := 4.663689) (m := vBP 4.795831)
    (Lo := 0.00088986) (Hi := 0.00623563) (Klo := (-0.000293985138)) (Khi := (-0.000012503874))
    (by norm_num) (by norm_num) (by norm_num) errPtT138
    vbpT137.1 vbpT137.2 vbpT138.1 vbpT138.2 vbpT148.1 vbpT148.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h1 := errBlockLin_of_piece (q0 := 4.663689) (q1 := 4.6636901) (m := vBP 4.795831)
    (Lo := (-0.00362445)) (Hi := 0.00588781) (Klo := (-0.000143273453)) (Khi := 0.000143262345)
    (by norm_num) (by norm_num) (by norm_num) errPtT139
    vbpT138.1 vbpT138.2 vbpT139.1 vbpT139.2 vbpT148.1 vbpT148.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h2 := errBlockLin_of_piece (q0 := 4.6636901) (q1 := 4.6904152) (m := vBP 4.795831)
    (Lo := (-0.0038116)) (Hi := 0.00146222) (Klo := (-0.000268490107)) (Khi := 0.000023423679)
    (by norm_num) (by norm_num) (by norm_num) errPtT140
    vbpT139.1 vbpT139.2 vbpT140.1 vbpT140.2 vbpT148.1 vbpT148.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h3 := errBlockLin_of_piece (q0 := 4.6904152) (q1 := 4.6904163) (m := vBP 4.795831)
    (Lo := (-0.00359075)) (Hi := 0.00581205) (Klo := (-0.0001486501)) (Khi := 0.000148641671)
    (by norm_num) (by norm_num) (by norm_num) errPtT141
    vbpT140.1 vbpT140.2 vbpT141.1 vbpT141.2 vbpT148.1 vbpT148.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h4 := errBlockLin_of_piece (q0 := 4.6904163) (q1 := 4.71699) (m := vBP 4.795831)
    (Lo := (-0.0038057)) (Hi := 0.00140048) (Klo := (-0.000235697454)) (Khi := 0.000048997252)
    (by norm_num) (by norm_num) (by norm_num) errPtT142
    vbpT141.1 vbpT141.2 vbpT142.1 vbpT142.2 vbpT148.1 vbpT148.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h5 := errBlockLin_of_piece (q0 := 4.71699) (q1 := 4.7169911) (m := vBP 4.795831)
    (Lo := (-0.00355775)) (Hi := 0.00573811) (Klo := (-0.000136051718)) (Khi := 0.0001360455)
    (by norm_num) (by norm_num) (by norm_num) errPtT143
    vbpT142.1 vbpT142.2 vbpT143.1 vbpT143.2 vbpT148.1 vbpT148.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h6 := errBlockLin_of_piece (q0 := 4.7169911) (q1 := 4.7434159) (m := vBP 4.795831)
    (Lo := 0.00081405) (Hi := 0.00595665) (Klo := (-0.000203520469)) (Khi := 0.000073380627)
    (by norm_num) (by norm_num) (by norm_num) errPtT144
    vbpT143.1 vbpT143.2 vbpT144.1 vbpT144.2 vbpT148.1 vbpT148.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h7 := errBlockLin_of_piece (q0 := 4.7434159) (q1 := 4.743417) (m := vBP 4.795831)
    (Lo := (-0.00352542)) (Hi := 0.00566593) (Klo := (-0.00014085472)) (Khi := 0.000140850254)
    (by norm_num) (by norm_num) (by norm_num) errPtT145
    vbpT144.1 vbpT144.2 vbpT145.1 vbpT145.2 vbpT148.1 vbpT148.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h8 := errBlockLin_of_piece (q0 := 4.743417) (q1 := 4.7696955) (m := vBP 4.795831)
    (Lo := 0.00083336) (Hi := 0.00591164) (Klo := (-0.000181581213)) (Khi := 0.000105224391)
    (by norm_num) (by norm_num) (by norm_num) errPtT146
    vbpT145.1 vbpT145.2 vbpT146.1 vbpT146.2 vbpT148.1 vbpT148.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h9 := errBlockLin_of_piece (q0 := 4.7696955) (q1 := 4.7696966) (m := vBP 4.795831)
    (Lo := (-0.00349375)) (Hi := 0.00559545) (Klo := (-0.00014595407)) (Khi := 0.000145952162)
    (by norm_num) (by norm_num) (by norm_num) errPtT147
    vbpT146.1 vbpT146.2 vbpT147.1 vbpT147.2 vbpT148.1 vbpT148.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h10 := errBlockLin_of_piece (q0 := 4.7696966) (q1 := 4.795831) (m := vBP 4.795831)
    (Lo := (-0.00365848)) (Hi := 0.00135489) (Klo := (-0.00015246705)) (Khi := 0.000127228878)
    (by norm_num) (by norm_num) (by norm_num) errPtT148
    vbpT147.1 vbpT147.2 vbpT148.1 vbpT148.2 vbpT148.1 vbpT148.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h11 := errBlockLin_of_piece (q0 := 4.795831) (q1 := 4.7958321) (m := vBP 4.795831)
    (Lo := (-0.00346271)) (Hi := 0.00552662) (Klo := (-0.000133742925)) (Khi := 0.000133743118)
    (by norm_num) (by norm_num) (by norm_num) errPtT149
    vbpT148.1 vbpT148.2 vbpT149.1 vbpT149.2 vbpT148.1 vbpT148.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h12 := errBlockLin_of_piece (q0 := 4.7958321) (q1 := 4.8218248) (m := vBP 4.795831)
    (Lo := (-0.0036531)) (Hi := 0.00129909) (Klo := (-0.000123831412)) (Khi := 0.000148212142)
    (by norm_num) (by norm_num) (by norm_num) errPtT150
    vbpT149.1 vbpT149.2 vbpT150.1 vbpT150.2 vbpT148.1 vbpT148.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h13 := errBlockLin_of_piece (q0 := 4.8218248) (q1 := 4.8218259) (m := vBP 4.795831)
    (Lo := (-0.00343228)) (Hi := 0.00545938) (Klo := (-0.000138299607)) (Khi := 0.000138301453)
    (by norm_num) (by norm_num) (by norm_num) errPtT151
    vbpT150.1 vbpT150.2 vbpT151.1 vbpT151.2 vbpT148.1 vbpT148.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h14 := errBlockLin_of_piece (q0 := 4.8218259) (q1 := 4.8476793) (m := vBP 4.795831)
    (Lo := 0.00076412) (Hi := 0.00565869) (Klo := (-0.000104929879)) (Khi := 0.000176500774)
    (by norm_num) (by norm_num) (by norm_num) errPtT152
    vbpT151.1 vbpT151.2 vbpT152.1 vbpT152.2 vbpT148.1 vbpT148.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h15 := errBlockLin_of_piece (q0 := 4.8476793) (q1 := 4.8476804) (m := vBP 4.795831)
    (Lo := (-0.00340244)) (Hi := 0.00539367) (Klo := (-0.000143127973)) (Khi := 0.000143131856)
    (by norm_num) (by norm_num) (by norm_num) errPtT153
    vbpT152.1 vbpT152.2 vbpT153.1 vbpT153.2 vbpT148.1 vbpT148.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h16 := errBlockLin_of_piece (q0 := 4.8476804) (q1 := 4.8733966) (m := vBP 4.795831)
    (Lo := 0.00078184) (Hi := 0.00561807) (Klo := (-0.000079013141)) (Khi := 0.000195442002)
    (by norm_num) (by norm_num) (by norm_num) errPtT154
    vbpT153.1 vbpT153.2 vbpT154.1 vbpT154.2 vbpT148.1 vbpT148.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h17 := errBlockLin_of_piece (q0 := 4.8733966) (q1 := 4.8733977) (m := vBP 4.795831)
    (Lo := (-0.00337317)) (Hi := 0.00532944) (Klo := (-0.000131322491)) (Khi := 0.000131328379)
    (by norm_num) (by norm_num) (by norm_num) errPtT155
    vbpT154.1 vbpT154.2 vbpT155.1 vbpT155.2 vbpT148.1 vbpT148.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h18 := errBlockLin_of_piece (q0 := 4.8733977) (q1 := 4.8989789) (m := vBP 4.795831)
    (Lo := (-0.00351834)) (Hi := 0.00125908) (Klo := (-0.000053463859)) (Khi := 0.000213503911)
    (by norm_num) (by norm_num) (by norm_num) errPtT156
    vbpT155.1 vbpT155.2 vbpT156.1 vbpT156.2 vbpT148.1 vbpT148.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h19 := errBlockLin_of_piece (q0 := 4.8989789) (q1 := 4.89898) (m := vBP 4.795831)
    (Lo := (-0.00334445)) (Hi := 0.00526665) (Klo := (-0.000135638198)) (Khi := 0.00013564606)
    (by norm_num) (by norm_num) (by norm_num) errPtT157
    vbpT156.1 vbpT156.2 vbpT157.1 vbpT157.2 vbpT148.1 vbpT148.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h20 := errBlockLin_of_piece (q0 := 4.89898) (q1 := 4.9244284) (m := vBP 4.795831)
    (Lo := (-0.0035134)) (Hi := 0.00120844) (Klo := (-0.000037165282)) (Khi := 0.000238685186)
    (by norm_num) (by norm_num) (by norm_num) errPtT158
    vbpT157.1 vbpT157.2 vbpT158.1 vbpT158.2 vbpT148.1 vbpT148.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h21 := errBlockLin_of_piece (q0 := 4.9244284) (q1 := 4.9244295) (m := vBP 4.795831)
    (Lo := (-0.00331628)) (Hi := 0.00520526) (Klo := (-0.000140203638)) (Khi := 0.000140213039)
    (by norm_num) (by norm_num) (by norm_num) errPtT159
    vbpT158.1 vbpT158.2 vbpT159.1 vbpT159.2 vbpT148.1 vbpT148.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h22 := errBlockLin_of_piece (q0 := 4.9244295) (q1 := 4.9497469) (m := vBP 4.795831)
    (Lo := 0.00071844) (Hi := 0.00538776) (Klo := (-0.000021987176)) (Khi := 0.000263253614)
    (by norm_num) (by norm_num) (by norm_num) errPtT160
    vbpT159.1 vbpT159.2 vbpT160.1 vbpT160.2 vbpT148.1 vbpT148.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h23 := errBlockLin_of_piece (q0 := 4.9497469) (q1 := 4.949748) (m := vBP 4.795831)
    (Lo := (-0.00328862)) (Hi := 0.00514521) (Klo := (-0.000145026993)) (Khi := 0.000145037908)
    (by norm_num) (by norm_num) (by norm_num) errPtT161
    vbpT160.1 vbpT160.2 vbpT161.1 vbpT161.2 vbpT148.1 vbpT148.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  exact (((((((((((((((((((((((h0.add h1).add h2).add h3).add h4).add h5).add h6).add h7).add h8).add h9).add h10).add h11).add h12).add h13).add h14).add h15).add h16).add h17).add h18).add h19).add h20).add h21).add h22).add h23).mono (by norm_num) (by norm_num) (by norm_num [mn4])
    (by norm_num [mx4]) (by norm_num)

theorem blkLo24 : errBlockLin (vBP 4.6368098) (vBP 4.949748) (vBP 4.795831) (-0.0000390278) 0.0000974523 (-0.0000178538) 0.0000173104 0.0001292308 :=
  errBlockLin.mono blkLo24_0 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
    (by norm_num)

theorem blkLo25_0 : errBlockLin (vBP 4.949748) (vBP 5) (vBP 4.9749366) (-0.0000053273) 0.0000133117 (-0.0000027331) 0.0000025517 0.0000177777 := by
  have h0 := errBlockLin_of_piece (q0 := 4.949748) (q1 := 4.9749366) (m := vBP 4.9749366)
    (Lo := 0.00073475) (Hi := 0.00535096) (Klo := (-0.000153464236)) (Khi := 0.000132445305)
    (by norm_num) (by norm_num) (by norm_num) errPtT162
    vbpT161.1 vbpT161.2 vbpT162.1 vbpT162.2 vbpT162.1 vbpT162.2
    (Or.inr (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h1 := errBlockLin_of_piece (q0 := 4.9749366) (q1 := 4.9749377) (m := vBP 4.9749366)
    (Lo := (-0.00326147)) (Hi := 0.00508646) (Klo := (-0.000136880437)) (Khi := 0.000136880611)
    (by norm_num) (by norm_num) (by norm_num) errPtT163
    vbpT162.1 vbpT162.2 vbpT163.1 vbpT163.2 vbpT162.1 vbpT162.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h2 := errBlockLin_of_piece (q0 := 4.9749377) (q1 := 4.9999995) (m := vBP 4.9749366)
    (Lo := (-0.0033895)) (Hi := 0.00117316) (Klo := (-0.000128864312)) (Khi := 0.000149189011)
    (by norm_num) (by norm_num) (by norm_num) errPtT164
    vbpT163.1 vbpT163.2 vbpT164.1 vbpT164.2 vbpT162.1 vbpT162.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  have h3 := errBlockLin_of_piece (q0 := 4.9999995) (q1 := 5) (m := vBP 4.9749366)
    (Lo := (-0.00323481)) (Hi := 0.00502897) (Klo := (-0.000141172406)) (Khi := 0.00014117321)
    (by norm_num) (by norm_num) (by norm_num) errPtT165
    vbpT164.1 vbpT164.2 vbpT165.1 vbpT165.2 vbpT162.1 vbpT162.2
    (Or.inl (vBP_mono (by norm_num) (by norm_num))) (by norm_num) (by norm_num)
  exact (((h0.add h1).add h2).add h3).mono (by norm_num) (by norm_num) (by norm_num [mn4])
    (by norm_num [mx4]) (by norm_num)

theorem blkLo25 : errBlockLin (vBP 4.949748) (vBP 5) (vBP 4.9749366) (-0.0000053273) 0.0000133117 (-0.0000027331) 0.0000025517 0.0000177777 :=
  errBlockLin.mono blkLo25_0 (by norm_num) (by norm_num) (by norm_num) (by norm_num)
    (by norm_num)

end ConnesConsani.WeilPositivity
