import Split.HMul_hMul
import Split.Prod_mk
import Split.instMulNat
import Split.instOfNatNat
import Split.ZMod
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Nat
import Split.instAddNat
import Split.Eq_refl
import Split.Prod
import Split.OfNat_ofNat
import Split.FractranCRTMerger_embedAddress
import Split.Eq
import Split.instHMul
import Split.ZMod_val

-- FractranCRTMerger.embedAddress.eq_1 from environment
-- theorem FractranCRTMerger.embedAddress.eq_1 : forall (a47 : ZMod (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47))) (a59 : ZMod (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59))) (a71 : ZMod (OfNat.ofNat.{0} Nat 71 (instOfNatNat 71))), Eq.{1} Nat (FractranCRTMerger.embedAddress (Prod.mk.{0, 0} (ZMod (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47))) (Prod.{0, 0} (ZMod (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59))) (ZMod (OfNat.ofNat.{0} Nat 71 (instOfNatNat 71)))) a47 (Prod.mk.{0, 0} (ZMod (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59))) (ZMod (OfNat.ofNat.{0} Nat 71 (instOfNatNat 71))) a59 a71))) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (ZMod.val (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47)) a47) (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47)) (ZMod.val (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59)) a59))) (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47)) (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59))) (ZMod.val (OfNat.ofNat.{0} Nat 71 (instOfNatNat 71)) a71)))

-- Stub: this file represents the declaration `FractranCRTMerger.embedAddress.eq_1`.
-- In a full split, the body would be extracted from the environment.
