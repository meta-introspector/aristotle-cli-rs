import Split.ContentAddressing_MultihashCodec_asciiSum
import Split.ContentAddressing_MultihashCodec_blake2b_256
import Split.ContentAddressing_MultihashCodec_sha3_256
import Split.ContentAddressing_MultihashCodec_identity
import Split.ContentAddressing_MultihashCodec_rec
import Split.ContentAddressing_MultihashCodec_sha2_256
import Split.ContentAddressing_MultihashCodec

-- ContentAddressing.MultihashCodec.recOn from environment
-- def ContentAddressing.MultihashCodec.recOn : forall {motive : ContentAddressing.MultihashCodec -> Sort.{u}} (t : ContentAddressing.MultihashCodec), (motive ContentAddressing.MultihashCodec.identity) -> (motive ContentAddressing.MultihashCodec.sha2_256) -> (motive ContentAddressing.MultihashCodec.sha3_256) -> (motive ContentAddressing.MultihashCodec.blake2b_256) -> (motive ContentAddressing.MultihashCodec.asciiSum) -> (motive t)
-- (definition body omitted)

-- Stub: this file represents the declaration `ContentAddressing.MultihashCodec.recOn`.
-- In a full split, the body would be extracted from the environment.
