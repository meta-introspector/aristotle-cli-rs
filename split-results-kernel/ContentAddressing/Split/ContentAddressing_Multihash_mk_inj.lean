import Split.ContentAddressing_Multihash
import Split.ContentAddressing_Multihash_mk_noConfusion
import Split.And
import Split.Nat
import Split.And_intro
import Split.Eq
import Split.ContentAddressing_Multihash_mk
import Split.ContentAddressing_MultihashCodec

-- ContentAddressing.Multihash.mk.inj from environment
-- theorem ContentAddressing.Multihash.mk.inj : forall {codec : ContentAddressing.MultihashCodec} {digestSize : Nat} {digest : Nat} {codec_1 : ContentAddressing.MultihashCodec} {digestSize_1 : Nat} {digest_1 : Nat}, (Eq.{1} ContentAddressing.Multihash (ContentAddressing.Multihash.mk codec digestSize digest) (ContentAddressing.Multihash.mk codec_1 digestSize_1 digest_1)) -> (And (Eq.{1} ContentAddressing.MultihashCodec codec codec_1) (And (Eq.{1} Nat digestSize digestSize_1) (Eq.{1} Nat digest digest_1)))

-- Stub: this file represents the declaration `ContentAddressing.Multihash.mk.inj`.
-- In a full split, the body would be extracted from the environment.
