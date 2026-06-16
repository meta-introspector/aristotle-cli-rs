import Split.PadicEntropyDAG_Metrics_mk_noConfusion
import Split.PadicEntropyDAG_Metrics
import Split.Float
import Split.PadicEntropyDAG_Metrics_mk
import Split.And
import Split.Nat
import Split.And_intro
import Split.Eq

-- PadicEntropyDAG.Metrics.mk.inj from environment
-- theorem PadicEntropyDAG.Metrics.mk.inj : forall {sum : Nat} {logsum : Float} {bits : Float} {trits : Float} {sum_1 : Nat} {logsum_1 : Float} {bits_1 : Float} {trits_1 : Float}, (Eq.{1} PadicEntropyDAG.Metrics (PadicEntropyDAG.Metrics.mk sum logsum bits trits) (PadicEntropyDAG.Metrics.mk sum_1 logsum_1 bits_1 trits_1)) -> (And (Eq.{1} Nat sum sum_1) (And (Eq.{1} Float logsum logsum_1) (And (Eq.{1} Float bits bits_1) (Eq.{1} Float trits trits_1))))

-- Stub: this file represents the declaration `PadicEntropyDAG.Metrics.mk.inj`.
-- In a full split, the body would be extracted from the environment.
