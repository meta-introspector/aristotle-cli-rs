import Split.MonsterTrain_CARBlock
import Split.id
import Split.MonsterTrain_CARBlock_mk
import Split.Nat
import Split.MonsterTrain_CARBlock_noConfusion
import Split.MonsterTrain_CID
import Split.Eq
import Split.Option

-- MonsterTrain.CARBlock.mk.noConfusion from environment
-- def MonsterTrain.CARBlock.mk.noConfusion : forall {P : Sort.{u}} {cid : MonsterTrain.CID} {payload : Nat} {parent : Option.{0} MonsterTrain.CID} {cid' : MonsterTrain.CID} {payload' : Nat} {parent' : Option.{0} MonsterTrain.CID}, (Eq.{1} MonsterTrain.CARBlock (MonsterTrain.CARBlock.mk cid payload parent) (MonsterTrain.CARBlock.mk cid' payload' parent')) -> ((Eq.{1} MonsterTrain.CID cid cid') -> (Eq.{1} Nat payload payload') -> (Eq.{1} (Option.{0} MonsterTrain.CID) parent parent') -> P) -> P
-- (definition body omitted)

-- Stub: this file represents the declaration `MonsterTrain.CARBlock.mk.noConfusion`.
-- In a full split, the body would be extracted from the environment.
