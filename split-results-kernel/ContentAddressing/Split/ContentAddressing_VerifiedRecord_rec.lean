import Split.ContentAddressing_VerifiedRecord_mk
import Split.ContentAddressing_ContentRecord
import Split.Bool_true
import Split.List
import Split.ContentAddressing_acceptRecord
import Split.ContentAddressing_HashFunction
import Split.Bool
import Split.Prod
import Split.Eq
import Split.ContentAddressing_VerifiedRecord
import Split.ContentAddressing_MultihashCodec
import Split.ContentAddressing_ContentRecord_hashesConsistent

-- ContentAddressing.VerifiedRecord.rec from environment
-- recursor ContentAddressing.VerifiedRecord.rec : forall {motive : ContentAddressing.VerifiedRecord -> Sort.{u}}, (forall (record : ContentAddressing.ContentRecord) (hashFns : List.{0} (Prod.{0, 0} ContentAddressing.MultihashCodec ContentAddressing.HashFunction)) (consistent : ContentAddressing.ContentRecord.hashesConsistent record hashFns) (accepted : Eq.{1} Bool (ContentAddressing.acceptRecord record) Bool.true), motive (ContentAddressing.VerifiedRecord.mk record hashFns consistent accepted)) -> (forall (t : ContentAddressing.VerifiedRecord), motive t)

-- Stub: this file represents the declaration `ContentAddressing.VerifiedRecord.rec`.
-- In a full split, the body would be extracted from the environment.
