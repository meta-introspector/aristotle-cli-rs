import Split.ContentAddressing_CID_mk
import Split.ContentAddressing_Multihash
import Split.ContentAddressing_CIDVersion
import Split.ContentAddressing_CID
import Split.And
import Split.ContentAddressing_Multicodec
import Split.And_intro
import Split.ContentAddressing_CID_mk_noConfusion
import Split.Eq

-- ContentAddressing.CID.mk.inj from environment
-- theorem ContentAddressing.CID.mk.inj : forall {version : ContentAddressing.CIDVersion} {contentCodec : ContentAddressing.Multicodec} {hash : ContentAddressing.Multihash} {version_1 : ContentAddressing.CIDVersion} {contentCodec_1 : ContentAddressing.Multicodec} {hash_1 : ContentAddressing.Multihash}, (Eq.{1} ContentAddressing.CID (ContentAddressing.CID.mk version contentCodec hash) (ContentAddressing.CID.mk version_1 contentCodec_1 hash_1)) -> (And (Eq.{1} ContentAddressing.CIDVersion version version_1) (And (Eq.{1} ContentAddressing.Multicodec contentCodec contentCodec_1) (Eq.{1} ContentAddressing.Multihash hash hash_1)))

-- Stub: this file represents the declaration `ContentAddressing.CID.mk.inj`.
-- In a full split, the body would be extracted from the environment.
