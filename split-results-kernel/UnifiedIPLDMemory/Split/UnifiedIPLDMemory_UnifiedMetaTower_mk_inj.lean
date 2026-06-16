import Split.UnifiedIPLDMemory_metaTickN
import Split.UnifiedIPLDMemory_UnifiedMetaTower
import Split.UnifiedIPLDMemory_UnifiedMetaTower_mk_noConfusion
import Split.UnifiedIPLDMemory_UnifiedMemoryState
import Split.UnifiedIPLDMemory_UnifiedMetaTower_mk
import Split.And
import Split.Nat
import Split.And_intro
import Split.Eq

-- UnifiedIPLDMemory.UnifiedMetaTower.mk.inj from environment
-- theorem UnifiedIPLDMemory.UnifiedMetaTower.mk.inj : forall {base : UnifiedIPLDMemory.UnifiedMemoryState} {seq : Nat -> UnifiedIPLDMemory.UnifiedMemoryState} {compat : forall (n : Nat), Eq.{1} UnifiedIPLDMemory.UnifiedMemoryState (seq n) (UnifiedIPLDMemory.metaTickN n base)} {base_1 : UnifiedIPLDMemory.UnifiedMemoryState} {seq_1 : Nat -> UnifiedIPLDMemory.UnifiedMemoryState} {compat_1 : forall (n : Nat), Eq.{1} UnifiedIPLDMemory.UnifiedMemoryState (seq_1 n) (UnifiedIPLDMemory.metaTickN n base_1)}, (Eq.{1} UnifiedIPLDMemory.UnifiedMetaTower (UnifiedIPLDMemory.UnifiedMetaTower.mk base seq compat) (UnifiedIPLDMemory.UnifiedMetaTower.mk base_1 seq_1 compat_1)) -> (And (Eq.{1} UnifiedIPLDMemory.UnifiedMemoryState base base_1) (Eq.{1} (Nat -> UnifiedIPLDMemory.UnifiedMemoryState) seq seq_1))

-- Stub: this file represents the declaration `UnifiedIPLDMemory.UnifiedMetaTower.mk.inj`.
-- In a full split, the body would be extracted from the environment.
