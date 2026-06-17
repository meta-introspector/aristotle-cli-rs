import Split.UnifiedIPLDMemory_NormalizationMap
import Split.UnifiedIPLDMemory_IPLDDAG_root
import Split.UnifiedIPLDMemory_IPLDBlock
import Split.Membership_mem
import Split.UnifiedIPLDMemory_IPLDCID
import Split.LE_le
import Split.instLENat
import Split.UnifiedIPLDMemory_IPLDDAG_blocks
import Split.List
import Split.List_instMembership
import Split.Nat
import Split.UnifiedIPLDMemory_IPLDDAG
import Split.Eq
import Split.UnifiedIPLDMemory_IPLDDAG_blockCount

-- UnifiedIPLDMemory.NormalizationMap.mk from environment
-- constructor UnifiedIPLDMemory.NormalizationMap.mk : forall {original : UnifiedIPLDMemory.IPLDDAG} {normalized : UnifiedIPLDMemory.IPLDDAG}, (forall (b : UnifiedIPLDMemory.IPLDBlock), (Membership.mem.{0, 0} UnifiedIPLDMemory.IPLDBlock (List.{0} UnifiedIPLDMemory.IPLDBlock) (List.instMembership.{0} UnifiedIPLDMemory.IPLDBlock) (UnifiedIPLDMemory.IPLDDAG.blocks normalized) b) -> (Membership.mem.{0, 0} UnifiedIPLDMemory.IPLDBlock (List.{0} UnifiedIPLDMemory.IPLDBlock) (List.instMembership.{0} UnifiedIPLDMemory.IPLDBlock) (UnifiedIPLDMemory.IPLDDAG.blocks original) b)) -> (LE.le.{0} Nat instLENat (UnifiedIPLDMemory.IPLDDAG.blockCount normalized) (UnifiedIPLDMemory.IPLDDAG.blockCount original)) -> (Eq.{1} UnifiedIPLDMemory.IPLDCID (UnifiedIPLDMemory.IPLDDAG.root normalized) (UnifiedIPLDMemory.IPLDDAG.root original)) -> (UnifiedIPLDMemory.NormalizationMap original normalized)

-- Stub: this file represents the declaration `UnifiedIPLDMemory.NormalizationMap.mk`.
-- In a full split, the body would be extracted from the environment.
