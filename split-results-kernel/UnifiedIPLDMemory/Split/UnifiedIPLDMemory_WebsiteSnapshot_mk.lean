import Split.Membership_mem
import Split.UnifiedIPLDMemory_WebTile
import Split.UnifiedIPLDMemory_WebsiteSnapshot
import Split.List
import Split.List_instMembership
import Split.Nat
import Split.Eq
import Split.List_length

-- UnifiedIPLDMemory.WebsiteSnapshot.mk from environment
-- constructor UnifiedIPLDMemory.WebsiteSnapshot.mk : forall (root : UnifiedIPLDMemory.WebTile) (tiles : List.{0} UnifiedIPLDMemory.WebTile) (tileCount : Nat), (Eq.{1} Nat tileCount (List.length.{0} UnifiedIPLDMemory.WebTile tiles)) -> (Membership.mem.{0, 0} UnifiedIPLDMemory.WebTile (List.{0} UnifiedIPLDMemory.WebTile) (List.instMembership.{0} UnifiedIPLDMemory.WebTile) tiles root) -> UnifiedIPLDMemory.WebsiteSnapshot

-- Stub: this file represents the declaration `UnifiedIPLDMemory.WebsiteSnapshot.mk`.
-- In a full split, the body would be extracted from the environment.
