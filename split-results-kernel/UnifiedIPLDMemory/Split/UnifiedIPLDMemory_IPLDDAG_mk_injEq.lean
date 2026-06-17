import Split.UnifiedIPLDMemory_IPLDDAG_mk_inj
import Split.Eq_propIntro
import Split.Lean_injEq_helper
import Split.UnifiedIPLDMemory_IPLDBlock
import Split.UnifiedIPLDMemory_IPLDCID
import Split.List
import Split.And
import Split.Nat
import Split.Eq_ndrec
import Split.UnifiedIPLDMemory_IPLDDAG
import Split.Eq_refl
import Split.Eq
import Split.List_length
import Split.UnifiedIPLDMemory_IPLDDAG_mk

-- UnifiedIPLDMemory.IPLDDAG.mk.injEq from environment
-- theorem UnifiedIPLDMemory.IPLDDAG.mk.injEq : forall (root : UnifiedIPLDMemory.IPLDCID) (blocks : List.{0} UnifiedIPLDMemory.IPLDBlock) (blockCount : Nat) (totalLinks : Nat) (count_consistent : Eq.{1} Nat blockCount (List.length.{0} UnifiedIPLDMemory.IPLDBlock blocks)) (root_1 : UnifiedIPLDMemory.IPLDCID) (blocks_1 : List.{0} UnifiedIPLDMemory.IPLDBlock) (blockCount_1 : Nat) (totalLinks_1 : Nat) (count_consistent_1 : Eq.{1} Nat blockCount_1 (List.length.{0} UnifiedIPLDMemory.IPLDBlock blocks_1)), Eq.{1} Prop (Eq.{1} UnifiedIPLDMemory.IPLDDAG (UnifiedIPLDMemory.IPLDDAG.mk root blocks blockCount totalLinks count_consistent) (UnifiedIPLDMemory.IPLDDAG.mk root_1 blocks_1 blockCount_1 totalLinks_1 count_consistent_1)) (And (Eq.{1} UnifiedIPLDMemory.IPLDCID root root_1) (And (Eq.{1} (List.{0} UnifiedIPLDMemory.IPLDBlock) blocks blocks_1) (And (Eq.{1} Nat blockCount blockCount_1) (Eq.{1} Nat totalLinks totalLinks_1))))

-- Stub: this file represents the declaration `UnifiedIPLDMemory.IPLDDAG.mk.injEq`.
-- In a full split, the body would be extracted from the environment.
