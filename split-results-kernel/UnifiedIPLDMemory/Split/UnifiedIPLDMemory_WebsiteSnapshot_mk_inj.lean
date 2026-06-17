import Split.UnifiedIPLDMemory_WebsiteSnapshot_mk_noConfusion
import Split.Membership_mem
import Split.UnifiedIPLDMemory_WebTile
import Split.UnifiedIPLDMemory_WebsiteSnapshot_mk
import Split.UnifiedIPLDMemory_WebsiteSnapshot
import Split.List
import Split.And
import Split.List_instMembership
import Split.Nat
import Split.And_intro
import Split.Eq
import Split.List_length

-- UnifiedIPLDMemory.WebsiteSnapshot.mk.inj from environment
-- theorem UnifiedIPLDMemory.WebsiteSnapshot.mk.inj : forall {root : UnifiedIPLDMemory.WebTile} {tiles : List.{0} UnifiedIPLDMemory.WebTile} {tileCount : Nat} {count_consistent : Eq.{1} Nat tileCount (List.length.{0} UnifiedIPLDMemory.WebTile tiles)} {root_in_tiles : Membership.mem.{0, 0} UnifiedIPLDMemory.WebTile (List.{0} UnifiedIPLDMemory.WebTile) (List.instMembership.{0} UnifiedIPLDMemory.WebTile) tiles root} {root_1 : UnifiedIPLDMemory.WebTile} {tiles_1 : List.{0} UnifiedIPLDMemory.WebTile} {tileCount_1 : Nat} {count_consistent_1 : Eq.{1} Nat tileCount_1 (List.length.{0} UnifiedIPLDMemory.WebTile tiles_1)} {root_in_tiles_1 : Membership.mem.{0, 0} UnifiedIPLDMemory.WebTile (List.{0} UnifiedIPLDMemory.WebTile) (List.instMembership.{0} UnifiedIPLDMemory.WebTile) tiles_1 root_1}, (Eq.{1} UnifiedIPLDMemory.WebsiteSnapshot (UnifiedIPLDMemory.WebsiteSnapshot.mk root tiles tileCount count_consistent root_in_tiles) (UnifiedIPLDMemory.WebsiteSnapshot.mk root_1 tiles_1 tileCount_1 count_consistent_1 root_in_tiles_1)) -> (And (Eq.{1} UnifiedIPLDMemory.WebTile root root_1) (And (Eq.{1} (List.{0} UnifiedIPLDMemory.WebTile) tiles tiles_1) (Eq.{1} Nat tileCount tileCount_1)))

-- Stub: this file represents the declaration `UnifiedIPLDMemory.WebsiteSnapshot.mk.inj`.
-- In a full split, the body would be extracted from the environment.
