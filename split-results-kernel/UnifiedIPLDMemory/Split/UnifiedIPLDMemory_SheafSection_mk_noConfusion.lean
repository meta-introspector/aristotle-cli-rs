import Split.UnifiedIPLDMemory_DASLType
import Split.FiberedUniverse_S_ss
import Split.UnifiedIPLDMemory_IPLDCodec
import Split.String
import Split.id
import Split.UnifiedIPLDMemory_SheafSection_noConfusion
import Split.Nat
import Split.Bool
import Split.UnifiedIPLDMemory_SheafSection_mk
import Split.Eq
import Split.UnifiedIPLDMemory_SheafSection
import Split.UnifiedIPLDMemory_BottClass

-- UnifiedIPLDMemory.SheafSection.mk.noConfusion from environment
-- def UnifiedIPLDMemory.SheafSection.mk.noConfusion : forall {P : Sort.{u}} {cid : String} {shard : FiberedUniverse.S_ss} {encoding : UnifiedIPLDMemory.IPLDCodec} {bottClass : UnifiedIPLDMemory.BottClass} {heckeIndex : Nat} {eigenspace : String} {daslType : UnifiedIPLDMemory.DASLType} {isPrime : Bool} {daslAddr : Nat} {cid' : String} {shard' : FiberedUniverse.S_ss} {encoding' : UnifiedIPLDMemory.IPLDCodec} {bottClass' : UnifiedIPLDMemory.BottClass} {heckeIndex' : Nat} {eigenspace' : String} {daslType' : UnifiedIPLDMemory.DASLType} {isPrime' : Bool} {daslAddr' : Nat}, (Eq.{1} UnifiedIPLDMemory.SheafSection (UnifiedIPLDMemory.SheafSection.mk cid shard encoding bottClass heckeIndex eigenspace daslType isPrime daslAddr) (UnifiedIPLDMemory.SheafSection.mk cid' shard' encoding' bottClass' heckeIndex' eigenspace' daslType' isPrime' daslAddr')) -> ((Eq.{1} String cid cid') -> (Eq.{1} FiberedUniverse.S_ss shard shard') -> (Eq.{1} UnifiedIPLDMemory.IPLDCodec encoding encoding') -> (Eq.{1} UnifiedIPLDMemory.BottClass bottClass bottClass') -> (Eq.{1} Nat heckeIndex heckeIndex') -> (Eq.{1} String eigenspace eigenspace') -> (Eq.{1} UnifiedIPLDMemory.DASLType daslType daslType') -> (Eq.{1} Bool isPrime isPrime') -> (Eq.{1} Nat daslAddr daslAddr') -> P) -> P
-- (definition body omitted)

-- Stub: this file represents the declaration `UnifiedIPLDMemory.SheafSection.mk.noConfusion`.
-- In a full split, the body would be extracted from the environment.
