import Split.UnifiedIPLDMemory_IPLDDAG_noConfusion
import Split.UnifiedIPLDMemory_IPLDBlock
import Split.UnifiedIPLDMemory_IPLDCID
import Split.id
import Split.List
import Split.Nat
import Split.UnifiedIPLDMemory_IPLDDAG
import Split.Eq
import Split.List_length
import Split.UnifiedIPLDMemory_IPLDDAG_mk

-- UnifiedIPLDMemory.IPLDDAG.mk.noConfusion from environment
-- def UnifiedIPLDMemory.IPLDDAG.mk.noConfusion : forall {P : Sort.{u}} {root : UnifiedIPLDMemory.IPLDCID} {blocks : List.{0} UnifiedIPLDMemory.IPLDBlock} {blockCount : Nat} {totalLinks : Nat} {count_consistent : Eq.{1} Nat blockCount (List.length.{0} UnifiedIPLDMemory.IPLDBlock blocks)} {root' : UnifiedIPLDMemory.IPLDCID} {blocks' : List.{0} UnifiedIPLDMemory.IPLDBlock} {blockCount' : Nat} {totalLinks' : Nat} {count_consistent' : Eq.{1} Nat blockCount' (List.length.{0} UnifiedIPLDMemory.IPLDBlock blocks')}, (Eq.{1} UnifiedIPLDMemory.IPLDDAG (UnifiedIPLDMemory.IPLDDAG.mk root blocks blockCount totalLinks count_consistent) (UnifiedIPLDMemory.IPLDDAG.mk root' blocks' blockCount' totalLinks' count_consistent')) -> ((Eq.{1} UnifiedIPLDMemory.IPLDCID root root') -> (Eq.{1} (List.{0} UnifiedIPLDMemory.IPLDBlock) blocks blocks') -> (Eq.{1} Nat blockCount blockCount') -> (Eq.{1} Nat totalLinks totalLinks') -> P) -> P
-- (definition body omitted)

-- Stub: this file represents the declaration `UnifiedIPLDMemory.IPLDDAG.mk.noConfusion`.
-- In a full split, the body would be extracted from the environment.
