import Split.ContentAddressing_VerifiedRecord_mk
import Split.ContentAddressing_VerifiedRecord_mk_noConfusion
import Split.ContentAddressing_ContentRecord
import Split.Bool_true
import Split.List
import Split.And
import Split.ContentAddressing_acceptRecord
import Split.ContentAddressing_HashFunction
import Split.And_intro
import Split.Bool
import Split.Prod
import Split.Eq
import Split.ContentAddressing_VerifiedRecord
import Split.ContentAddressing_MultihashCodec
import Split.ContentAddressing_ContentRecord_hashesConsistent

-- ContentAddressing.VerifiedRecord.mk.inj from environment
-- theorem ContentAddressing.VerifiedRecord.mk.inj : forall {record : ContentAddressing.ContentRecord} {hashFns : List.{0} (Prod.{0, 0} ContentAddressing.MultihashCodec ContentAddressing.HashFunction)} {consistent : ContentAddressing.ContentRecord.hashesConsistent record hashFns} {accepted : Eq.{1} Bool (ContentAddressing.acceptRecord record) Bool.true} {record_1 : ContentAddressing.ContentRecord} {hashFns_1 : List.{0} (Prod.{0, 0} ContentAddressing.MultihashCodec ContentAddressing.HashFunction)} {consistent_1 : ContentAddressing.ContentRecord.hashesConsistent record_1 hashFns_1} {accepted_1 : Eq.{1} Bool (ContentAddressing.acceptRecord record_1) Bool.true}, (Eq.{1} ContentAddressing.VerifiedRecord (ContentAddressing.VerifiedRecord.mk record hashFns consistent accepted) (ContentAddressing.VerifiedRecord.mk record_1 hashFns_1 consistent_1 accepted_1)) -> (And (Eq.{1} ContentAddressing.ContentRecord record record_1) (Eq.{1} (List.{0} (Prod.{0, 0} ContentAddressing.MultihashCodec ContentAddressing.HashFunction)) hashFns hashFns_1))

-- Stub: this file represents the declaration `ContentAddressing.VerifiedRecord.mk.inj`.
-- In a full split, the body would be extracted from the environment.
