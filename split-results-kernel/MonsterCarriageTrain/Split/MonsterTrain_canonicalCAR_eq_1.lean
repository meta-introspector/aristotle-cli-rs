import Split.HSub_hSub
import Split.List_ofFn
import Split.MonsterTrain_CARBlock
import Split.Option_some
import Split.MonsterTrain_jCoefficient
import Split.instSubNat
import Split.instOfNatNat
import Split.MonsterTrain_CARBlock_mk
import Split.Fin_val
import Split.Option_none
import Split.List
import Split.instHSub
import Split.Nat
import Split.MonsterTrain_CID_mk
import Split.Eq_refl
import Split.instDecidableEqNat
import Split.MonsterTrain_CID
import Split.OfNat_ofNat
import Split.Fin
import Split.Eq
import Split.MonsterTrain_canonicalCAR
import Split.Option
import Split.ite

-- MonsterTrain.canonicalCAR.eq_1 from environment
-- theorem MonsterTrain.canonicalCAR.eq_1 : forall (depth : Nat), Eq.{1} (List.{0} MonsterTrain.CARBlock) (MonsterTrain.canonicalCAR depth) (List.ofFn.{0} MonsterTrain.CARBlock depth (fun (i : Fin depth) => MonsterTrain.CARBlock.mk (MonsterTrain.CID.mk (Fin.val depth i)) (MonsterTrain.jCoefficient (Fin.val depth i)) (ite.{1} (Option.{0} MonsterTrain.CID) (Eq.{1} Nat (Fin.val depth i) (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) (instDecidableEqNat (Fin.val depth i) (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) (Option.none.{0} MonsterTrain.CID) (Option.some.{0} MonsterTrain.CID (MonsterTrain.CID.mk (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) (Fin.val depth i) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))))))))

-- Stub: this file represents the declaration `MonsterTrain.canonicalCAR.eq_1`.
-- In a full split, the body would be extracted from the environment.
