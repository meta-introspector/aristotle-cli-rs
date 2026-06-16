import Split.MonsterTrain_CARBlock
import Split.instOfNatNat
import Split.MonsterTrain_CARBlock_mk
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Nat
import Split.SizeOf_sizeOf
import Split.instAddNat
import Split.Eq_refl
import Split.instSizeOfNat
import Split.MonsterTrain_CID
import Split.OfNat_ofNat
import Split.Eq
import Split.Option

-- MonsterTrain.CARBlock.mk.sizeOf_spec from environment
-- theorem MonsterTrain.CARBlock.mk.sizeOf_spec : forall (cid : MonsterTrain.CID) (payload : Nat) (parent : Option.{0} MonsterTrain.CID), Eq.{1} Nat (SizeOf.sizeOf.{1} MonsterTrain.CARBlock MonsterTrain.CARBlock._sizeOf_inst (MonsterTrain.CARBlock.mk cid payload parent)) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)) (SizeOf.sizeOf.{1} MonsterTrain.CID MonsterTrain.CID._sizeOf_inst cid)) (SizeOf.sizeOf.{1} Nat instSizeOfNat payload)) (SizeOf.sizeOf.{1} (Option.{0} MonsterTrain.CID) (Option._sizeOf_inst.{0} MonsterTrain.CID MonsterTrain.CID._sizeOf_inst) parent))

-- Stub: this file represents the declaration `MonsterTrain.CARBlock.mk.sizeOf_spec`.
-- In a full split, the body would be extracted from the environment.
