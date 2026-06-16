import Split.Membership_mem
import Split.UnifiedIPLDMemory_WebTile
import Split.UnifiedIPLDMemory_WebsiteSnapshot_mk
import Split.UnifiedIPLDMemory_WebsiteSnapshot
import Split.List
import Split.List_instMembership
import Split.Nat
import Split.UnifiedIPLDMemory_WebsiteSnapshot_rec
import Split.Eq
import Split.List_length

-- UnifiedIPLDMemory.WebsiteSnapshot.casesOn from environment
-- def UnifiedIPLDMemory.WebsiteSnapshot.casesOn : forall {motive : UnifiedIPLDMemory.WebsiteSnapshot -> Sort.{u}} (t : UnifiedIPLDMemory.WebsiteSnapshot), (forall (root : UnifiedIPLDMemory.WebTile) (tiles : List.{0} UnifiedIPLDMemory.WebTile) (tileCount : Nat) (count_consistent : Eq.{1} Nat tileCount (List.length.{0} UnifiedIPLDMemory.WebTile tiles)) (root_in_tiles : Membership.mem.{0, 0} UnifiedIPLDMemory.WebTile (List.{0} UnifiedIPLDMemory.WebTile) (List.instMembership.{0} UnifiedIPLDMemory.WebTile) tiles root), motive (UnifiedIPLDMemory.WebsiteSnapshot.mk root tiles tileCount count_consistent root_in_tiles)) -> (motive t)
-- (definition body omitted)

-- Stub: this file represents the declaration `UnifiedIPLDMemory.WebsiteSnapshot.casesOn`.
-- In a full split, the body would be extracted from the environment.
