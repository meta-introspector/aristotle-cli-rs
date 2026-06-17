import Split.UnifiedIPLDMemory_NormalizationMap
import Split.UnifiedIPLDMemory_IPLDDAG_root
import Split.UnifiedIPLDMemory_IPLDBlock
import Split.Membership_mem
import Split.UnifiedIPLDMemory_IPLDCID
import Split.LE_le
import Split.instLENat
import Split.UnifiedIPLDMemory_NormalizationMap_mk
import Split.UnifiedIPLDMemory_IPLDDAG_blocks
import Split.List
import Split.List_instMembership
import Split.Nat
import Split.UnifiedIPLDMemory_IPLDDAG
import Split.UnifiedIPLDMemory_NormalizationMap_rec
import Split.Eq
import Split.UnifiedIPLDMemory_IPLDDAG_blockCount

-- UnifiedIPLDMemory.NormalizationMap.recOn from environment
-- def UnifiedIPLDMemory.NormalizationMap.recOn : forall {original : UnifiedIPLDMemory.IPLDDAG} {normalized : UnifiedIPLDMemory.IPLDDAG} {motive : (UnifiedIPLDMemory.NormalizationMap original normalized) -> Sort.{u}} (t : UnifiedIPLDMemory.NormalizationMap original normalized), (forall (block_map : forall (b : UnifiedIPLDMemory.IPLDBlock), (Membership.mem.{0, 0} UnifiedIPLDMemory.IPLDBlock (List.{0} UnifiedIPLDMemory.IPLDBlock) (List.instMembership.{0} UnifiedIPLDMemory.IPLDBlock) (UnifiedIPLDMemory.IPLDDAG.blocks normalized) b) -> (Membership.mem.{0, 0} UnifiedIPLDMemory.IPLDBlock (List.{0} UnifiedIPLDMemory.IPLDBlock) (List.instMembership.{0} UnifiedIPLDMemory.IPLDBlock) (UnifiedIPLDMemory.IPLDDAG.blocks original) b)) (size_reduction : LE.le.{0} Nat instLENat (UnifiedIPLDMemory.IPLDDAG.blockCount normalized) (UnifiedIPLDMemory.IPLDDAG.blockCount original)) (root_preserved : Eq.{1} UnifiedIPLDMemory.IPLDCID (UnifiedIPLDMemory.IPLDDAG.root normalized) (UnifiedIPLDMemory.IPLDDAG.root original)), motive (UnifiedIPLDMemory.NormalizationMap.mk original normalized block_map size_reduction root_preserved)) -> (motive t)
-- (definition body omitted)

-- Stub: this file represents the declaration `UnifiedIPLDMemory.NormalizationMap.recOn`.
-- In a full split, the body would be extracted from the environment.
