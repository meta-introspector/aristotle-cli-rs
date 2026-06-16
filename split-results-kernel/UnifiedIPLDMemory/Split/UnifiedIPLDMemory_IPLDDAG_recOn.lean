import Split.UnifiedIPLDMemory_IPLDBlock
import Split.UnifiedIPLDMemory_IPLDCID
import Split.List
import Split.Nat
import Split.UnifiedIPLDMemory_IPLDDAG_rec
import Split.UnifiedIPLDMemory_IPLDDAG
import Split.Eq
import Split.List_length
import Split.UnifiedIPLDMemory_IPLDDAG_mk

-- UnifiedIPLDMemory.IPLDDAG.recOn from environment
-- def UnifiedIPLDMemory.IPLDDAG.recOn : forall {motive : UnifiedIPLDMemory.IPLDDAG -> Sort.{u}} (t : UnifiedIPLDMemory.IPLDDAG), (forall (root : UnifiedIPLDMemory.IPLDCID) (blocks : List.{0} UnifiedIPLDMemory.IPLDBlock) (blockCount : Nat) (totalLinks : Nat) (count_consistent : Eq.{1} Nat blockCount (List.length.{0} UnifiedIPLDMemory.IPLDBlock blocks)), motive (UnifiedIPLDMemory.IPLDDAG.mk root blocks blockCount totalLinks count_consistent)) -> (motive t)
-- (definition body omitted)

-- Stub: this file represents the declaration `UnifiedIPLDMemory.IPLDDAG.recOn`.
-- In a full split, the body would be extracted from the environment.
