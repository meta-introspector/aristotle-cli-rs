import Split.Eq_propIntro
import Split.ContentAddressing_Multihash
import Split.String
import Split.Lean_injEq_helper
import Split.ContentAddressing_ContentRecord
import Split.ContentAddressing_ContentRecord_mk_inj
import Split.ContentAddressing_CID
import Split.List
import Split.And
import Split.Eq_ndrec
import Split.Eq_refl
import Split.ContentAddressing_ContentRecord_mk
import Split.Eq

-- ContentAddressing.ContentRecord.mk.injEq from environment
-- theorem ContentAddressing.ContentRecord.mk.injEq : forall (payload : String) (hashes : List.{0} ContentAddressing.Multihash) (cids : List.{0} ContentAddressing.CID) (payload_1 : String) (hashes_1 : List.{0} ContentAddressing.Multihash) (cids_1 : List.{0} ContentAddressing.CID), Eq.{1} Prop (Eq.{1} ContentAddressing.ContentRecord (ContentAddressing.ContentRecord.mk payload hashes cids) (ContentAddressing.ContentRecord.mk payload_1 hashes_1 cids_1)) (And (Eq.{1} String payload payload_1) (And (Eq.{1} (List.{0} ContentAddressing.Multihash) hashes hashes_1) (Eq.{1} (List.{0} ContentAddressing.CID) cids cids_1)))

-- Stub: this file represents the declaration `ContentAddressing.ContentRecord.mk.injEq`.
-- In a full split, the body would be extracted from the environment.
