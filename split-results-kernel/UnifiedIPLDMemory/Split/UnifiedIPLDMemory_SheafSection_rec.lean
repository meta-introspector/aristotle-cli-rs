import Split.UnifiedIPLDMemory_DASLType
import Split.FiberedUniverse_S_ss
import Split.UnifiedIPLDMemory_IPLDCodec
import Split.String
import Split.Nat
import Split.Bool
import Split.UnifiedIPLDMemory_SheafSection_mk
import Split.UnifiedIPLDMemory_SheafSection
import Split.UnifiedIPLDMemory_BottClass

-- UnifiedIPLDMemory.SheafSection.rec from environment
-- recursor UnifiedIPLDMemory.SheafSection.rec : forall {motive : UnifiedIPLDMemory.SheafSection -> Sort.{u}}, (forall (cid : String) (shard : FiberedUniverse.S_ss) (encoding : UnifiedIPLDMemory.IPLDCodec) (bottClass : UnifiedIPLDMemory.BottClass) (heckeIndex : Nat) (eigenspace : String) (daslType : UnifiedIPLDMemory.DASLType) (isPrime : Bool) (daslAddr : Nat), motive (UnifiedIPLDMemory.SheafSection.mk cid shard encoding bottClass heckeIndex eigenspace daslType isPrime daslAddr)) -> (forall (t : UnifiedIPLDMemory.SheafSection), motive t)

-- Stub: this file represents the declaration `UnifiedIPLDMemory.SheafSection.rec`.
-- In a full split, the body would be extracted from the environment.
