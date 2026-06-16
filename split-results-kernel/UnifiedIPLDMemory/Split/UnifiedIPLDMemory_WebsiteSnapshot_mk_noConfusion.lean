import Split.UnifiedIPLDMemory_WebsiteSnapshot_noConfusion
import Split.Membership_mem
import Split.id
import Split.UnifiedIPLDMemory_WebTile
import Split.UnifiedIPLDMemory_WebsiteSnapshot_mk
import Split.UnifiedIPLDMemory_WebsiteSnapshot
import Split.List
import Split.List_instMembership
import Split.Nat
import Split.Eq
import Split.List_length

-- UnifiedIPLDMemory.WebsiteSnapshot.mk.noConfusion from environment
-- def UnifiedIPLDMemory.WebsiteSnapshot.mk.noConfusion : forall {P : Sort.{u}} {root : UnifiedIPLDMemory.WebTile} {tiles : List.{0} UnifiedIPLDMemory.WebTile} {tileCount : Nat} {count_consistent : Eq.{1} Nat tileCount (List.length.{0} UnifiedIPLDMemory.WebTile tiles)} {root_in_tiles : Membership.mem.{0, 0} UnifiedIPLDMemory.WebTile (List.{0} UnifiedIPLDMemory.WebTile) (List.instMembership.{0} UnifiedIPLDMemory.WebTile) tiles root} {root' : UnifiedIPLDMemory.WebTile} {tiles' : List.{0} UnifiedIPLDMemory.WebTile} {tileCount' : Nat} {count_consistent' : Eq.{1} Nat tileCount' (List.length.{0} UnifiedIPLDMemory.WebTile tiles')} {root_in_tiles' : Membership.mem.{0, 0} UnifiedIPLDMemory.WebTile (List.{0} UnifiedIPLDMemory.WebTile) (List.instMembership.{0} UnifiedIPLDMemory.WebTile) tiles' root'}, (Eq.{1} UnifiedIPLDMemory.WebsiteSnapshot (UnifiedIPLDMemory.WebsiteSnapshot.mk root tiles tileCount count_consistent root_in_tiles) (UnifiedIPLDMemory.WebsiteSnapshot.mk root' tiles' tileCount' count_consistent' root_in_tiles')) -> ((Eq.{1} UnifiedIPLDMemory.WebTile root root') -> (Eq.{1} (List.{0} UnifiedIPLDMemory.WebTile) tiles tiles') -> (Eq.{1} Nat tileCount tileCount') -> P) -> P
-- (definition body omitted)

-- Stub: this file represents the declaration `UnifiedIPLDMemory.WebsiteSnapshot.mk.noConfusion`.
-- In a full split, the body would be extracted from the environment.
