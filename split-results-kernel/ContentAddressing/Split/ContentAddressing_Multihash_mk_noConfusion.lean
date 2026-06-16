import Split.ContentAddressing_Multihash_noConfusion
import Split.ContentAddressing_Multihash
import Split.id
import Split.Nat
import Split.Eq
import Split.ContentAddressing_Multihash_mk
import Split.ContentAddressing_MultihashCodec

-- ContentAddressing.Multihash.mk.noConfusion from environment
-- def ContentAddressing.Multihash.mk.noConfusion : forall {P : Sort.{u}} {codec : ContentAddressing.MultihashCodec} {digestSize : Nat} {digest : Nat} {codec' : ContentAddressing.MultihashCodec} {digestSize' : Nat} {digest' : Nat}, (Eq.{1} ContentAddressing.Multihash (ContentAddressing.Multihash.mk codec digestSize digest) (ContentAddressing.Multihash.mk codec' digestSize' digest')) -> ((Eq.{1} ContentAddressing.MultihashCodec codec codec') -> (Eq.{1} Nat digestSize digestSize') -> (Eq.{1} Nat digest digest') -> P) -> P
-- (definition body omitted)

-- Stub: this file represents the declaration `ContentAddressing.Multihash.mk.noConfusion`.
-- In a full split, the body would be extracted from the environment.
