import Split.ContentAddressing_CID_mk
import Split.ContentAddressing_Multihash
import Split.id
import Split.ContentAddressing_CIDVersion
import Split.ContentAddressing_CID
import Split.ContentAddressing_CID_noConfusion
import Split.ContentAddressing_Multicodec
import Split.Eq

-- ContentAddressing.CID.mk.noConfusion from environment
-- def ContentAddressing.CID.mk.noConfusion : forall {P : Sort.{u}} {version : ContentAddressing.CIDVersion} {contentCodec : ContentAddressing.Multicodec} {hash : ContentAddressing.Multihash} {version' : ContentAddressing.CIDVersion} {contentCodec' : ContentAddressing.Multicodec} {hash' : ContentAddressing.Multihash}, (Eq.{1} ContentAddressing.CID (ContentAddressing.CID.mk version contentCodec hash) (ContentAddressing.CID.mk version' contentCodec' hash')) -> ((Eq.{1} ContentAddressing.CIDVersion version version') -> (Eq.{1} ContentAddressing.Multicodec contentCodec contentCodec') -> (Eq.{1} ContentAddressing.Multihash hash hash') -> P) -> P
-- (definition body omitted)

-- Stub: this file represents the declaration `ContentAddressing.CID.mk.noConfusion`.
-- In a full split, the body would be extracted from the environment.
