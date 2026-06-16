import Split.PadicEntropyDAG_PartitionKey_mk
import Split.id
import Split.PadicEntropyDAG_PartitionKey_noConfusion
import Split.Nat
import Split.Prod
import Split.Eq
import Split.PadicEntropyDAG_PartitionKey

-- PadicEntropyDAG.PartitionKey.mk.noConfusion from environment
-- def PadicEntropyDAG.PartitionKey.mk.noConfusion : forall {P : Sort.{u}} {stage1 : Prod.{0, 0} Nat (Prod.{0, 0} Nat Nat)} {stage2 : Prod.{0, 0} Nat (Prod.{0, 0} Nat Nat)} {stage3 : Nat} {irrep : Nat} {stage1' : Prod.{0, 0} Nat (Prod.{0, 0} Nat Nat)} {stage2' : Prod.{0, 0} Nat (Prod.{0, 0} Nat Nat)} {stage3' : Nat} {irrep' : Nat}, (Eq.{1} PadicEntropyDAG.PartitionKey (PadicEntropyDAG.PartitionKey.mk stage1 stage2 stage3 irrep) (PadicEntropyDAG.PartitionKey.mk stage1' stage2' stage3' irrep')) -> ((Eq.{1} (Prod.{0, 0} Nat (Prod.{0, 0} Nat Nat)) stage1 stage1') -> (Eq.{1} (Prod.{0, 0} Nat (Prod.{0, 0} Nat Nat)) stage2 stage2') -> (Eq.{1} Nat stage3 stage3') -> (Eq.{1} Nat irrep irrep') -> P) -> P
-- (definition body omitted)

-- Stub: this file represents the declaration `PadicEntropyDAG.PartitionKey.mk.noConfusion`.
-- In a full split, the body would be extracted from the environment.
