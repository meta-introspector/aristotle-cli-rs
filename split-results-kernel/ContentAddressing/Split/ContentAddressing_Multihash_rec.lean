import Split.ContentAddressing_Multihash
import Split.Nat
import Split.ContentAddressing_Multihash_mk
import Split.ContentAddressing_MultihashCodec

-- ContentAddressing.Multihash.rec from environment
-- recursor ContentAddressing.Multihash.rec : forall {motive : ContentAddressing.Multihash -> Sort.{u}}, (forall (codec : ContentAddressing.MultihashCodec) (digestSize : Nat) (digest : Nat), motive (ContentAddressing.Multihash.mk codec digestSize digest)) -> (forall (t : ContentAddressing.Multihash), motive t)

-- Stub: this file represents the declaration `ContentAddressing.Multihash.rec`.
-- In a full split, the body would be extracted from the environment.
