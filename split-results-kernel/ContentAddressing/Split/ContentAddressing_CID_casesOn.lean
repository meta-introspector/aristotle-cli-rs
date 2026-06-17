import Split.ContentAddressing_CID_mk
import Split.ContentAddressing_Multihash
import Split.ContentAddressing_CID_rec
import Split.ContentAddressing_CIDVersion
import Split.ContentAddressing_CID
import Split.ContentAddressing_Multicodec

-- ContentAddressing.CID.casesOn from environment
-- def ContentAddressing.CID.casesOn : forall {motive : ContentAddressing.CID -> Sort.{u}} (t : ContentAddressing.CID), (forall (version : ContentAddressing.CIDVersion) (contentCodec : ContentAddressing.Multicodec) (hash : ContentAddressing.Multihash), motive (ContentAddressing.CID.mk version contentCodec hash)) -> (motive t)
-- (definition body omitted)

-- Stub: this file represents the declaration `ContentAddressing.CID.casesOn`.
-- In a full split, the body would be extracted from the environment.
