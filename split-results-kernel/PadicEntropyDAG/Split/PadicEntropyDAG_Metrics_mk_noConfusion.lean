import Split.PadicEntropyDAG_Metrics
import Split.PadicEntropyDAG_Metrics_noConfusion
import Split.Float
import Split.id
import Split.PadicEntropyDAG_Metrics_mk
import Split.Nat
import Split.Eq

-- PadicEntropyDAG.Metrics.mk.noConfusion from environment
-- def PadicEntropyDAG.Metrics.mk.noConfusion : forall {P : Sort.{u}} {sum : Nat} {logsum : Float} {bits : Float} {trits : Float} {sum' : Nat} {logsum' : Float} {bits' : Float} {trits' : Float}, (Eq.{1} PadicEntropyDAG.Metrics (PadicEntropyDAG.Metrics.mk sum logsum bits trits) (PadicEntropyDAG.Metrics.mk sum' logsum' bits' trits')) -> ((Eq.{1} Nat sum sum') -> (Eq.{1} Float logsum logsum') -> (Eq.{1} Float bits bits') -> (Eq.{1} Float trits trits') -> P) -> P
-- (definition body omitted)

-- Stub: this file represents the declaration `PadicEntropyDAG.Metrics.mk.noConfusion`.
-- In a full split, the body would be extracted from the environment.
