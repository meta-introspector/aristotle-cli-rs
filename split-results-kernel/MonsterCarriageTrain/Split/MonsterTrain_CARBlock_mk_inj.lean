import Split.MonsterTrain_CARBlock
import Split.MonsterTrain_CARBlock_mk
import Split.And
import Split.Nat
import Split.And_intro
import Split.MonsterTrain_CARBlock_mk_noConfusion
import Split.MonsterTrain_CID
import Split.Eq
import Split.Option

-- MonsterTrain.CARBlock.mk.inj from environment
-- theorem MonsterTrain.CARBlock.mk.inj : forall {cid : MonsterTrain.CID} {payload : Nat} {parent : Option.{0} MonsterTrain.CID} {cid_1 : MonsterTrain.CID} {payload_1 : Nat} {parent_1 : Option.{0} MonsterTrain.CID}, (Eq.{1} MonsterTrain.CARBlock (MonsterTrain.CARBlock.mk cid payload parent) (MonsterTrain.CARBlock.mk cid_1 payload_1 parent_1)) -> (And (Eq.{1} MonsterTrain.CID cid cid_1) (And (Eq.{1} Nat payload payload_1) (Eq.{1} (Option.{0} MonsterTrain.CID) parent parent_1)))

-- Stub: this file represents the declaration `MonsterTrain.CARBlock.mk.inj`.
-- In a full split, the body would be extracted from the environment.
