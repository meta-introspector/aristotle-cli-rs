import Split.UnifiedIPLDMemory_TaggedBlock
import Split.UnifiedIPLDMemory_IPLDBlock_cid
import Split.instOfNatNat
import Split.UnifiedIPLDMemory_anomalyFlag
import Split.Nat
import Split.UnifiedIPLDMemory_IPLDCID_digest
import Split.Eq_refl
import Split.instDecidableEqNat
import Split.UnifiedIPLDMemory_TaggedBlock_block
import Split.OfNat_ofNat
import Split.Eq
import Split.ite

-- UnifiedIPLDMemory.anomalyFlag.eq_1 from environment
-- theorem UnifiedIPLDMemory.anomalyFlag.eq_1 : forall (tb : UnifiedIPLDMemory.TaggedBlock), Eq.{1} Nat (UnifiedIPLDMemory.anomalyFlag tb) (ite.{1} Nat (Eq.{1} Nat (UnifiedIPLDMemory.IPLDCID.digest (UnifiedIPLDMemory.IPLDBlock.cid (UnifiedIPLDMemory.TaggedBlock.block tb))) (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) (instDecidableEqNat (UnifiedIPLDMemory.IPLDCID.digest (UnifiedIPLDMemory.IPLDBlock.cid (UnifiedIPLDMemory.TaggedBlock.block tb))) (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)) (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)))

-- Stub: this file represents the declaration `UnifiedIPLDMemory.anomalyFlag.eq_1`.
-- In a full split, the body would be extracted from the environment.
