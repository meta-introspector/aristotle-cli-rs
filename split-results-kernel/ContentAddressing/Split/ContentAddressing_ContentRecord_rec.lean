import Split.ContentAddressing_Multihash
import Split.String
import Split.ContentAddressing_ContentRecord
import Split.ContentAddressing_CID
import Split.List
import Split.ContentAddressing_ContentRecord_mk

-- ContentAddressing.ContentRecord.rec from environment
-- recursor ContentAddressing.ContentRecord.rec : forall {motive : ContentAddressing.ContentRecord -> Sort.{u}}, (forall (payload : String) (hashes : List.{0} ContentAddressing.Multihash) (cids : List.{0} ContentAddressing.CID), motive (ContentAddressing.ContentRecord.mk payload hashes cids)) -> (forall (t : ContentAddressing.ContentRecord), motive t)

-- Stub: this file represents the declaration `ContentAddressing.ContentRecord.rec`.
-- In a full split, the body would be extracted from the environment.
