import Split.Eq_propIntro
import Split.UnifiedIPLDMemory_BlockPacking_mk
import Split.Lean_injEq_helper
import Split.UnifiedIPLDMemory_IPLDBlock
import Split.HEq_homo_ndrec
import Split.LE_le
import Split.instLENat
import Split.UnifiedIPLDMemory_IPLDDAG_blocks
import Split.And
import Split.Nat
import Split.Eq_ndrec
import Split.UnifiedIPLDMemory_IPLDDAG
import Split.Eq_refl
import Split.HEq
import Split.UnifiedIPLDMemory_BlockPacking
import Split.Fin
import Split.Eq
import Split.List_length
import Split.UnifiedIPLDMemory_BlockPacking_mk_inj
import Split.UnifiedIPLDMemory_IPLDDAG_blockCount

-- UnifiedIPLDMemory.BlockPacking.mk.injEq from environment
-- theorem UnifiedIPLDMemory.BlockPacking.mk.injEq : forall {dag : UnifiedIPLDMemory.IPLDDAG} (unitCount : Nat) (assignment : (Fin (List.length.{0} UnifiedIPLDMemory.IPLDBlock (UnifiedIPLDMemory.IPLDDAG.blocks dag))) -> (Fin unitCount)) (packing_efficiency : LE.le.{0} Nat instLENat unitCount (UnifiedIPLDMemory.IPLDDAG.blockCount dag)) (unitCount_1 : Nat) (assignment_1 : (Fin (List.length.{0} UnifiedIPLDMemory.IPLDBlock (UnifiedIPLDMemory.IPLDDAG.blocks dag))) -> (Fin unitCount_1)) (packing_efficiency_1 : LE.le.{0} Nat instLENat unitCount_1 (UnifiedIPLDMemory.IPLDDAG.blockCount dag)), Eq.{1} Prop (Eq.{1} (UnifiedIPLDMemory.BlockPacking dag) (UnifiedIPLDMemory.BlockPacking.mk dag unitCount assignment packing_efficiency) (UnifiedIPLDMemory.BlockPacking.mk dag unitCount_1 assignment_1 packing_efficiency_1)) (And (Eq.{1} Nat unitCount unitCount_1) (HEq.{1} ((Fin (List.length.{0} UnifiedIPLDMemory.IPLDBlock (UnifiedIPLDMemory.IPLDDAG.blocks dag))) -> (Fin unitCount)) assignment ((Fin (List.length.{0} UnifiedIPLDMemory.IPLDBlock (UnifiedIPLDMemory.IPLDDAG.blocks dag))) -> (Fin unitCount_1)) assignment_1))

-- Stub: this file represents the declaration `UnifiedIPLDMemory.BlockPacking.mk.injEq`.
-- In a full split, the body would be extracted from the environment.
