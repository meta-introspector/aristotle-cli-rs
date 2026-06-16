import Split.UnifiedIPLDMemory_metaTickN
import Split.UnifiedIPLDMemory_UnifiedMetaTower
import Split.UnifiedIPLDMemory_UnifiedMemoryState
import Split.UnifiedIPLDMemory_UnifiedMetaTower_mk
import Split.Nat
import Split.Eq

-- UnifiedIPLDMemory.UnifiedMetaTower.rec from environment
-- recursor UnifiedIPLDMemory.UnifiedMetaTower.rec : forall {motive : UnifiedIPLDMemory.UnifiedMetaTower -> Sort.{u}}, (forall (base : UnifiedIPLDMemory.UnifiedMemoryState) (seq : Nat -> UnifiedIPLDMemory.UnifiedMemoryState) (compat : forall (n : Nat), Eq.{1} UnifiedIPLDMemory.UnifiedMemoryState (seq n) (UnifiedIPLDMemory.metaTickN n base)), motive (UnifiedIPLDMemory.UnifiedMetaTower.mk base seq compat)) -> (forall (t : UnifiedIPLDMemory.UnifiedMetaTower), motive t)

-- Stub: this file represents the declaration `UnifiedIPLDMemory.UnifiedMetaTower.rec`.
-- In a full split, the body would be extracted from the environment.
