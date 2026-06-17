import Split.UnifiedIPLDMemory_IPLDCID_mk
import Split.Eq_propIntro
import Split.UnifiedIPLDMemory_IPLDCodec
import Split.Lean_injEq_helper
import Split.UnifiedIPLDMemory_IPLDCID
import Split.UnifiedIPLDMemory_IPLDCID_mk_inj
import Split.And
import Split.Nat
import Split.Eq_ndrec
import Split.Eq_refl
import Split.Eq

-- UnifiedIPLDMemory.IPLDCID.mk.injEq from environment
-- theorem UnifiedIPLDMemory.IPLDCID.mk.injEq : forall (version : Nat) (codec : UnifiedIPLDMemory.IPLDCodec) (digest : Nat) (version_1 : Nat) (codec_1 : UnifiedIPLDMemory.IPLDCodec) (digest_1 : Nat), Eq.{1} Prop (Eq.{1} UnifiedIPLDMemory.IPLDCID (UnifiedIPLDMemory.IPLDCID.mk version codec digest) (UnifiedIPLDMemory.IPLDCID.mk version_1 codec_1 digest_1)) (And (Eq.{1} Nat version version_1) (And (Eq.{1} UnifiedIPLDMemory.IPLDCodec codec codec_1) (Eq.{1} Nat digest digest_1)))

-- Stub: this file represents the declaration `UnifiedIPLDMemory.IPLDCID.mk.injEq`.
-- In a full split, the body would be extracted from the environment.
