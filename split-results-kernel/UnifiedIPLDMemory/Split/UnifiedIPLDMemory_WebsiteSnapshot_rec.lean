import Split.Membership_mem
import Split.UnifiedIPLDMemory_WebTile
import Split.UnifiedIPLDMemory_WebsiteSnapshot_mk
import Split.UnifiedIPLDMemory_WebsiteSnapshot
import Split.List
import Split.List_instMembership
import Split.Nat
import Split.Eq
import Split.List_length

-- UnifiedIPLDMemory.WebsiteSnapshot.rec from environment
-- recursor UnifiedIPLDMemory.WebsiteSnapshot.rec : forall {motive : UnifiedIPLDMemory.WebsiteSnapshot -> Sort.{u}}, (forall (root : UnifiedIPLDMemory.WebTile) (tiles : List.{0} UnifiedIPLDMemory.WebTile) (tileCount : Nat) (count_consistent : Eq.{1} Nat tileCount (List.length.{0} UnifiedIPLDMemory.WebTile tiles)) (root_in_tiles : Membership.mem.{0, 0} UnifiedIPLDMemory.WebTile (List.{0} UnifiedIPLDMemory.WebTile) (List.instMembership.{0} UnifiedIPLDMemory.WebTile) tiles root), motive (UnifiedIPLDMemory.WebsiteSnapshot.mk root tiles tileCount count_consistent root_in_tiles)) -> (forall (t : UnifiedIPLDMemory.WebsiteSnapshot), motive t)

-- Stub: this file represents the declaration `UnifiedIPLDMemory.WebsiteSnapshot.rec`.
-- In a full split, the body would be extracted from the environment.
