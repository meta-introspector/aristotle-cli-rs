import Split.ContentAddressing_Multihash
import Split.String
import Split.ContentAddressing_ContentRecord
import Split.ContentAddressing_CID
import Split.List
import Split.And
import Split.And_intro
import Split.ContentAddressing_ContentRecord_mk
import Split.Eq
import Split.ContentAddressing_ContentRecord_mk_noConfusion

-- ContentAddressing.ContentRecord.mk.inj from environment
-- theorem ContentAddressing.ContentRecord.mk.inj : forall {payload : String} {hashes : List.{0} ContentAddressing.Multihash} {cids : List.{0} ContentAddressing.CID} {payload_1 : String} {hashes_1 : List.{0} ContentAddressing.Multihash} {cids_1 : List.{0} ContentAddressing.CID}, (Eq.{1} ContentAddressing.ContentRecord (ContentAddressing.ContentRecord.mk payload hashes cids) (ContentAddressing.ContentRecord.mk payload_1 hashes_1 cids_1)) -> (And (Eq.{1} String payload payload_1) (And (Eq.{1} (List.{0} ContentAddressing.Multihash) hashes hashes_1) (Eq.{1} (List.{0} ContentAddressing.CID) cids cids_1)))

-- Stub: this file represents the declaration `ContentAddressing.ContentRecord.mk.inj`.
-- In a full split, the body would be extracted from the environment.
