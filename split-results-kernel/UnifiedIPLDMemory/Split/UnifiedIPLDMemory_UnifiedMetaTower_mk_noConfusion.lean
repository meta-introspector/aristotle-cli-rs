import Split.UnifiedIPLDMemory_metaTickN
import Split.UnifiedIPLDMemory_UnifiedMetaTower
import Split.id
import Split.UnifiedIPLDMemory_UnifiedMemoryState
import Split.UnifiedIPLDMemory_UnifiedMetaTower_mk
import Split.Nat
import Split.Eq
import Split.UnifiedIPLDMemory_UnifiedMetaTower_noConfusion

-- UnifiedIPLDMemory.UnifiedMetaTower.mk.noConfusion from environment
-- def UnifiedIPLDMemory.UnifiedMetaTower.mk.noConfusion : forall {P : Sort.{u}} {base : UnifiedIPLDMemory.UnifiedMemoryState} {seq : Nat -> UnifiedIPLDMemory.UnifiedMemoryState} {compat : forall (n : Nat), Eq.{1} UnifiedIPLDMemory.UnifiedMemoryState (seq n) (UnifiedIPLDMemory.metaTickN n base)} {base' : UnifiedIPLDMemory.UnifiedMemoryState} {seq' : Nat -> UnifiedIPLDMemory.UnifiedMemoryState} {compat' : forall (n : Nat), Eq.{1} UnifiedIPLDMemory.UnifiedMemoryState (seq' n) (UnifiedIPLDMemory.metaTickN n base')}, (Eq.{1} UnifiedIPLDMemory.UnifiedMetaTower (UnifiedIPLDMemory.UnifiedMetaTower.mk base seq compat) (UnifiedIPLDMemory.UnifiedMetaTower.mk base' seq' compat')) -> ((Eq.{1} UnifiedIPLDMemory.UnifiedMemoryState base base') -> (Eq.{1} (Nat -> UnifiedIPLDMemory.UnifiedMemoryState) seq seq') -> P) -> P
-- (definition body omitted)

-- Stub: this file represents the declaration `UnifiedIPLDMemory.UnifiedMetaTower.mk.noConfusion`.
-- In a full split, the body would be extracted from the environment.
