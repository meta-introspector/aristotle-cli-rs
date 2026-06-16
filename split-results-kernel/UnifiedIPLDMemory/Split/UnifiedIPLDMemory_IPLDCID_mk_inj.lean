import Split.UnifiedIPLDMemory_IPLDCID_mk
import Split.UnifiedIPLDMemory_IPLDCodec
import Split.UnifiedIPLDMemory_IPLDCID
import Split.And
import Split.Nat
import Split.And_intro
import Split.Eq
import Split.UnifiedIPLDMemory_IPLDCID_mk_noConfusion

-- UnifiedIPLDMemory.IPLDCID.mk.inj from environment
-- theorem UnifiedIPLDMemory.IPLDCID.mk.inj : forall {version : Nat} {codec : UnifiedIPLDMemory.IPLDCodec} {digest : Nat} {version_1 : Nat} {codec_1 : UnifiedIPLDMemory.IPLDCodec} {digest_1 : Nat}, (Eq.{1} UnifiedIPLDMemory.IPLDCID (UnifiedIPLDMemory.IPLDCID.mk version codec digest) (UnifiedIPLDMemory.IPLDCID.mk version_1 codec_1 digest_1)) -> (And (Eq.{1} Nat version version_1) (And (Eq.{1} UnifiedIPLDMemory.IPLDCodec codec codec_1) (Eq.{1} Nat digest digest_1)))

-- Stub: this file represents the declaration `UnifiedIPLDMemory.IPLDCID.mk.inj`.
-- In a full split, the body would be extracted from the environment.
