import Split.UnifiedIPLDMemory_SheafSection_mk_inj
import Split.UnifiedIPLDMemory_DASLType
import Split.Eq_propIntro
import Split.FiberedUniverse_S_ss
import Split.UnifiedIPLDMemory_IPLDCodec
import Split.String
import Split.Lean_injEq_helper
import Split.And
import Split.Nat
import Split.Bool
import Split.Eq_ndrec
import Split.UnifiedIPLDMemory_SheafSection_mk
import Split.Eq_refl
import Split.Eq
import Split.UnifiedIPLDMemory_SheafSection
import Split.UnifiedIPLDMemory_BottClass

-- UnifiedIPLDMemory.SheafSection.mk.injEq from environment
-- theorem UnifiedIPLDMemory.SheafSection.mk.injEq : forall (cid : String) (shard : FiberedUniverse.S_ss) (encoding : UnifiedIPLDMemory.IPLDCodec) (bottClass : UnifiedIPLDMemory.BottClass) (heckeIndex : Nat) (eigenspace : String) (daslType : UnifiedIPLDMemory.DASLType) (isPrime : Bool) (daslAddr : Nat) (cid_1 : String) (shard_1 : FiberedUniverse.S_ss) (encoding_1 : UnifiedIPLDMemory.IPLDCodec) (bottClass_1 : UnifiedIPLDMemory.BottClass) (heckeIndex_1 : Nat) (eigenspace_1 : String) (daslType_1 : UnifiedIPLDMemory.DASLType) (isPrime_1 : Bool) (daslAddr_1 : Nat), Eq.{1} Prop (Eq.{1} UnifiedIPLDMemory.SheafSection (UnifiedIPLDMemory.SheafSection.mk cid shard encoding bottClass heckeIndex eigenspace daslType isPrime daslAddr) (UnifiedIPLDMemory.SheafSection.mk cid_1 shard_1 encoding_1 bottClass_1 heckeIndex_1 eigenspace_1 daslType_1 isPrime_1 daslAddr_1)) (And (Eq.{1} String cid cid_1) (And (Eq.{1} FiberedUniverse.S_ss shard shard_1) (And (Eq.{1} UnifiedIPLDMemory.IPLDCodec encoding encoding_1) (And (Eq.{1} UnifiedIPLDMemory.BottClass bottClass bottClass_1) (And (Eq.{1} Nat heckeIndex heckeIndex_1) (And (Eq.{1} String eigenspace eigenspace_1) (And (Eq.{1} UnifiedIPLDMemory.DASLType daslType daslType_1) (And (Eq.{1} Bool isPrime isPrime_1) (Eq.{1} Nat daslAddr daslAddr_1)))))))))

-- Stub: this file represents the declaration `UnifiedIPLDMemory.SheafSection.mk.injEq`.
-- In a full split, the body would be extracted from the environment.
