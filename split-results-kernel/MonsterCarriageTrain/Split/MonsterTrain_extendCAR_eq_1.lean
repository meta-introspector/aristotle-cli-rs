import Split.HSub_hSub
import Split.MonsterTrain_CARBlock
import Split.Option_some
import Split.MonsterTrain_extendCAR
import Split.MonsterTrain_jCoefficient
import Split.instSubNat
import Split.instOfNatNat
import Split.MonsterTrain_CARBlock_mk
import Split.List_cons
import Split.Option_none
import Split.instHAppendOfAppend
import Split.List
import Split.instHSub
import Split.Nat
import Split.MonsterTrain_CID_mk
import Split.Eq_refl
import Split.instDecidableEqNat
import Split.MonsterTrain_CID
import Split.List_instAppend
import Split.OfNat_ofNat
import Split.Eq
import Split.List_length
import Split.HAppend_hAppend
import Split.List_nil
import Split.Option
import Split.ite

-- MonsterTrain.extendCAR.eq_1 from environment
-- theorem MonsterTrain.extendCAR.eq_1 : forall (car : List.{0} MonsterTrain.CARBlock), Eq.{1} (List.{0} MonsterTrain.CARBlock) (MonsterTrain.extendCAR car) (HAppend.hAppend.{0, 0, 0} (List.{0} MonsterTrain.CARBlock) (List.{0} MonsterTrain.CARBlock) (List.{0} MonsterTrain.CARBlock) (instHAppendOfAppend.{0} (List.{0} MonsterTrain.CARBlock) (List.instAppend.{0} MonsterTrain.CARBlock)) car (List.cons.{0} MonsterTrain.CARBlock (MonsterTrain.CARBlock.mk (MonsterTrain.CID.mk (List.length.{0} MonsterTrain.CARBlock car)) (MonsterTrain.jCoefficient (List.length.{0} MonsterTrain.CARBlock car)) (ite.{1} (Option.{0} MonsterTrain.CID) (Eq.{1} Nat (List.length.{0} MonsterTrain.CARBlock car) (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) (instDecidableEqNat (List.length.{0} MonsterTrain.CARBlock car) (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) (Option.none.{0} MonsterTrain.CID) (Option.some.{0} MonsterTrain.CID (MonsterTrain.CID.mk (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) (List.length.{0} MonsterTrain.CARBlock car) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))))))) (List.nil.{0} MonsterTrain.CARBlock)))

-- Stub: this file represents the declaration `MonsterTrain.extendCAR.eq_1`.
-- In a full split, the body would be extracted from the environment.
