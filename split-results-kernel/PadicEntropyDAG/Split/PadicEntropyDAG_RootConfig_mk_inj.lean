import Split.String
import Split.PadicEntropyDAG_RootConfig_mk_noConfusion
import Split.Float
import Split.And
import Split.PadicEntropyDAG_RootConfig
import Split.And_intro
import Split.Eq
import Split.PadicEntropyDAG_RootConfig_mk

-- PadicEntropyDAG.RootConfig.mk.inj from environment
-- theorem PadicEntropyDAG.RootConfig.mk.inj : forall {id : String} {type : String} {bitsMax : Float} {tritsMax : Float} {id_1 : String} {type_1 : String} {bitsMax_1 : Float} {tritsMax_1 : Float}, (Eq.{1} PadicEntropyDAG.RootConfig (PadicEntropyDAG.RootConfig.mk id type bitsMax tritsMax) (PadicEntropyDAG.RootConfig.mk id_1 type_1 bitsMax_1 tritsMax_1)) -> (And (Eq.{1} String id id_1) (And (Eq.{1} String type type_1) (And (Eq.{1} Float bitsMax bitsMax_1) (Eq.{1} Float tritsMax tritsMax_1))))

-- Stub: this file represents the declaration `PadicEntropyDAG.RootConfig.mk.inj`.
-- In a full split, the body would be extracted from the environment.
