import Split.ContentAddressing_CID_mk
import Split.ContentAddressing_Multihash
import Split.ContentAddressing_CIDVersion
import Split.ContentAddressing_CID
import Split.ContentAddressing_Multicodec

-- ContentAddressing.CID.rec from environment
-- recursor ContentAddressing.CID.rec : forall {motive : ContentAddressing.CID -> Sort.{u}}, (forall (version : ContentAddressing.CIDVersion) (contentCodec : ContentAddressing.Multicodec) (hash : ContentAddressing.Multihash), motive (ContentAddressing.CID.mk version contentCodec hash)) -> (forall (t : ContentAddressing.CID), motive t)

-- Stub: this file represents the declaration `ContentAddressing.CID.rec`.
-- In a full split, the body would be extracted from the environment.
