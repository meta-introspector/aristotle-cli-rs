import Split.PadicEntropyDAG_PartitionKey_mk
import Split.And
import Split.Nat
import Split.And_intro
import Split.Prod
import Split.Eq
import Split.PadicEntropyDAG_PartitionKey
import Split.PadicEntropyDAG_PartitionKey_mk_noConfusion

-- PadicEntropyDAG.PartitionKey.mk.inj from environment
-- theorem PadicEntropyDAG.PartitionKey.mk.inj : forall {stage1 : Prod.{0, 0} Nat (Prod.{0, 0} Nat Nat)} {stage2 : Prod.{0, 0} Nat (Prod.{0, 0} Nat Nat)} {stage3 : Nat} {irrep : Nat} {stage1_1 : Prod.{0, 0} Nat (Prod.{0, 0} Nat Nat)} {stage2_1 : Prod.{0, 0} Nat (Prod.{0, 0} Nat Nat)} {stage3_1 : Nat} {irrep_1 : Nat}, (Eq.{1} PadicEntropyDAG.PartitionKey (PadicEntropyDAG.PartitionKey.mk stage1 stage2 stage3 irrep) (PadicEntropyDAG.PartitionKey.mk stage1_1 stage2_1 stage3_1 irrep_1)) -> (And (Eq.{1} (Prod.{0, 0} Nat (Prod.{0, 0} Nat Nat)) stage1 stage1_1) (And (Eq.{1} (Prod.{0, 0} Nat (Prod.{0, 0} Nat Nat)) stage2 stage2_1) (And (Eq.{1} Nat stage3 stage3_1) (Eq.{1} Nat irrep irrep_1))))

-- Stub: this file represents the declaration `PadicEntropyDAG.PartitionKey.mk.inj`.
-- In a full split, the body would be extracted from the environment.
