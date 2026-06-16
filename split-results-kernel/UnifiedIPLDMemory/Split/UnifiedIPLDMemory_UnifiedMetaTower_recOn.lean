import Split.UnifiedIPLDMemory_metaTickN
import Split.UnifiedIPLDMemory_UnifiedMetaTower
import Split.UnifiedIPLDMemory_UnifiedMemoryState
import Split.UnifiedIPLDMemory_UnifiedMetaTower_mk
import Split.Nat
import Split.Eq
import Split.UnifiedIPLDMemory_UnifiedMetaTower_rec

-- UnifiedIPLDMemory.UnifiedMetaTower.recOn from environment
-- def UnifiedIPLDMemory.UnifiedMetaTower.recOn : forall {motive : UnifiedIPLDMemory.UnifiedMetaTower -> Sort.{u}} (t : UnifiedIPLDMemory.UnifiedMetaTower), (forall (base : UnifiedIPLDMemory.UnifiedMemoryState) (seq : Nat -> UnifiedIPLDMemory.UnifiedMemoryState) (compat : forall (n : Nat), Eq.{1} UnifiedIPLDMemory.UnifiedMemoryState (seq n) (UnifiedIPLDMemory.metaTickN n base)), motive (UnifiedIPLDMemory.UnifiedMetaTower.mk base seq compat)) -> (motive t)
-- (definition body omitted)

-- Stub: this file represents the declaration `UnifiedIPLDMemory.UnifiedMetaTower.recOn`.
-- In a full split, the body would be extracted from the environment.
