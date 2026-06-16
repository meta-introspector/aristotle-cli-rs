import Split.ContentAddressing_Multihash
import Split.String
import Split.ContentAddressing_ContentRecord
import Split.ContentAddressing_CID
import Split.List
import Split.ContentAddressing_ContentRecord_mk
import Split.ContentAddressing_ContentRecord_rec

-- ContentAddressing.ContentRecord.casesOn from environment
-- def ContentAddressing.ContentRecord.casesOn : forall {motive : ContentAddressing.ContentRecord -> Sort.{u}} (t : ContentAddressing.ContentRecord), (forall (payload : String) (hashes : List.{0} ContentAddressing.Multihash) (cids : List.{0} ContentAddressing.CID), motive (ContentAddressing.ContentRecord.mk payload hashes cids)) -> (motive t)
-- (definition body omitted)

-- Stub: this file represents the declaration `ContentAddressing.ContentRecord.casesOn`.
-- In a full split, the body would be extracted from the environment.
