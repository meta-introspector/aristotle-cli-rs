import Split.ContentAddressing_MultihashCodec_asciiSum
import Split.ContentAddressing_MultihashCodec_blake2b_256
import Split.ContentAddressing_MultihashCodec_sha3_256
import Split.ContentAddressing_MultihashCodec_identity
import Split.ContentAddressing_MultihashCodec_sha2_256
import Split.ContentAddressing_MultihashCodec

-- ContentAddressing.MultihashCodec.rec from environment
-- recursor ContentAddressing.MultihashCodec.rec : forall {motive : ContentAddressing.MultihashCodec -> Sort.{u}}, (motive ContentAddressing.MultihashCodec.identity) -> (motive ContentAddressing.MultihashCodec.sha2_256) -> (motive ContentAddressing.MultihashCodec.sha3_256) -> (motive ContentAddressing.MultihashCodec.blake2b_256) -> (motive ContentAddressing.MultihashCodec.asciiSum) -> (forall (t : ContentAddressing.MultihashCodec), motive t)

-- Stub: this file represents the declaration `ContentAddressing.MultihashCodec.rec`.
-- In a full split, the body would be extracted from the environment.
