import Split.ContentAddressing_VerifiedRecord_mk
import Split.id
import Split.ContentAddressing_ContentRecord
import Split.Bool_true
import Split.List
import Split.ContentAddressing_VerifiedRecord_noConfusion
import Split.ContentAddressing_acceptRecord
import Split.ContentAddressing_HashFunction
import Split.Bool
import Split.Prod
import Split.Eq
import Split.ContentAddressing_VerifiedRecord
import Split.ContentAddressing_MultihashCodec
import Split.ContentAddressing_ContentRecord_hashesConsistent

-- ContentAddressing.VerifiedRecord.mk.noConfusion from environment
-- def ContentAddressing.VerifiedRecord.mk.noConfusion : forall {P : Sort.{u}} {record : ContentAddressing.ContentRecord} {hashFns : List.{0} (Prod.{0, 0} ContentAddressing.MultihashCodec ContentAddressing.HashFunction)} {consistent : ContentAddressing.ContentRecord.hashesConsistent record hashFns} {accepted : Eq.{1} Bool (ContentAddressing.acceptRecord record) Bool.true} {record' : ContentAddressing.ContentRecord} {hashFns' : List.{0} (Prod.{0, 0} ContentAddressing.MultihashCodec ContentAddressing.HashFunction)} {consistent' : ContentAddressing.ContentRecord.hashesConsistent record' hashFns'} {accepted' : Eq.{1} Bool (ContentAddressing.acceptRecord record') Bool.true}, (Eq.{1} ContentAddressing.VerifiedRecord (ContentAddressing.VerifiedRecord.mk record hashFns consistent accepted) (ContentAddressing.VerifiedRecord.mk record' hashFns' consistent' accepted')) -> ((Eq.{1} ContentAddressing.ContentRecord record record') -> (Eq.{1} (List.{0} (Prod.{0, 0} ContentAddressing.MultihashCodec ContentAddressing.HashFunction)) hashFns hashFns') -> P) -> P
-- (definition body omitted)

-- Stub: this file represents the declaration `ContentAddressing.VerifiedRecord.mk.noConfusion`.
-- In a full split, the body would be extracted from the environment.
