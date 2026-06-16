import Split.ContentAddressing_Multihash
import Split.String
import Split.ContentAddressing_ContentRecord_noConfusion
import Split.id
import Split.ContentAddressing_ContentRecord
import Split.ContentAddressing_CID
import Split.List
import Split.ContentAddressing_ContentRecord_mk
import Split.Eq

-- ContentAddressing.ContentRecord.mk.noConfusion from environment
-- def ContentAddressing.ContentRecord.mk.noConfusion : forall {P : Sort.{u}} {payload : String} {hashes : List.{0} ContentAddressing.Multihash} {cids : List.{0} ContentAddressing.CID} {payload' : String} {hashes' : List.{0} ContentAddressing.Multihash} {cids' : List.{0} ContentAddressing.CID}, (Eq.{1} ContentAddressing.ContentRecord (ContentAddressing.ContentRecord.mk payload hashes cids) (ContentAddressing.ContentRecord.mk payload' hashes' cids')) -> ((Eq.{1} String payload payload') -> (Eq.{1} (List.{0} ContentAddressing.Multihash) hashes hashes') -> (Eq.{1} (List.{0} ContentAddressing.CID) cids cids') -> P) -> P
-- (definition body omitted)

-- Stub: this file represents the declaration `ContentAddressing.ContentRecord.mk.noConfusion`.
-- In a full split, the body would be extracted from the environment.
