import Split.String
import Split.Float
import Split.id
import Split.PadicEntropyDAG_RootConfig
import Split.Eq
import Split.PadicEntropyDAG_RootConfig_mk
import Split.PadicEntropyDAG_RootConfig_noConfusion

-- PadicEntropyDAG.RootConfig.mk.noConfusion from environment
-- def PadicEntropyDAG.RootConfig.mk.noConfusion : forall {P : Sort.{u}} {id : String} {type : String} {bitsMax : Float} {tritsMax : Float} {id' : String} {type' : String} {bitsMax' : Float} {tritsMax' : Float}, (Eq.{1} PadicEntropyDAG.RootConfig (PadicEntropyDAG.RootConfig.mk id type bitsMax tritsMax) (PadicEntropyDAG.RootConfig.mk id' type' bitsMax' tritsMax')) -> ((Eq.{1} String id id') -> (Eq.{1} String type type') -> (Eq.{1} Float bitsMax bitsMax') -> (Eq.{1} Float tritsMax tritsMax') -> P) -> P
-- (definition body omitted)

-- Stub: this file represents the declaration `PadicEntropyDAG.RootConfig.mk.noConfusion`.
-- In a full split, the body would be extracted from the environment.
