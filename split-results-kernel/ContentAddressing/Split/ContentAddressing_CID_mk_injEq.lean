import Split.ContentAddressing_CID_mk
import Split.Eq_propIntro
import Split.ContentAddressing_Multihash
import Split.Lean_injEq_helper
import Split.ContentAddressing_CIDVersion
import Split.ContentAddressing_CID_mk_inj
import Split.ContentAddressing_CID
import Split.And
import Split.ContentAddressing_Multicodec
import Split.Eq_ndrec
import Split.Eq_refl
import Split.Eq

-- ContentAddressing.CID.mk.injEq from environment
-- theorem ContentAddressing.CID.mk.injEq : forall (version : ContentAddressing.CIDVersion) (contentCodec : ContentAddressing.Multicodec) (hash : ContentAddressing.Multihash) (version_1 : ContentAddressing.CIDVersion) (contentCodec_1 : ContentAddressing.Multicodec) (hash_1 : ContentAddressing.Multihash), Eq.{1} Prop (Eq.{1} ContentAddressing.CID (ContentAddressing.CID.mk version contentCodec hash) (ContentAddressing.CID.mk version_1 contentCodec_1 hash_1)) (And (Eq.{1} ContentAddressing.CIDVersion version version_1) (And (Eq.{1} ContentAddressing.Multicodec contentCodec contentCodec_1) (Eq.{1} ContentAddressing.Multihash hash hash_1)))

-- Stub: this file represents the declaration `ContentAddressing.CID.mk.injEq`.
-- In a full split, the body would be extracted from the environment.
