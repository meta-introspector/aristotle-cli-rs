import Split.instSizeOfDefault
import Split.Membership_mem
import Split.UnifiedIPLDMemory_WebTile
import Split.UnifiedIPLDMemory_WebsiteSnapshot_mk
import Split.instOfNatNat
import Split.UnifiedIPLDMemory_WebsiteSnapshot
import Split.List
import Split.instHAdd
import Split.List_instMembership
import Split.HAdd_hAdd
import Split.Nat
import Split.SizeOf_sizeOf
import Split.instAddNat
import Split.Eq_refl
import Split.instSizeOfNat
import Split.OfNat_ofNat
import Split.Eq
import Split.List_length

-- UnifiedIPLDMemory.WebsiteSnapshot.mk.sizeOf_spec from environment
-- theorem UnifiedIPLDMemory.WebsiteSnapshot.mk.sizeOf_spec : forall (root : UnifiedIPLDMemory.WebTile) (tiles : List.{0} UnifiedIPLDMemory.WebTile) (tileCount : Nat) (count_consistent : Eq.{1} Nat tileCount (List.length.{0} UnifiedIPLDMemory.WebTile tiles)) (root_in_tiles : Membership.mem.{0, 0} UnifiedIPLDMemory.WebTile (List.{0} UnifiedIPLDMemory.WebTile) (List.instMembership.{0} UnifiedIPLDMemory.WebTile) tiles root), Eq.{1} Nat (SizeOf.sizeOf.{1} UnifiedIPLDMemory.WebsiteSnapshot UnifiedIPLDMemory.WebsiteSnapshot._sizeOf_inst (UnifiedIPLDMemory.WebsiteSnapshot.mk root tiles tileCount count_consistent root_in_tiles)) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)) (SizeOf.sizeOf.{1} UnifiedIPLDMemory.WebTile UnifiedIPLDMemory.WebTile._sizeOf_inst root)) (SizeOf.sizeOf.{1} (List.{0} UnifiedIPLDMemory.WebTile) (List._sizeOf_inst.{0} UnifiedIPLDMemory.WebTile UnifiedIPLDMemory.WebTile._sizeOf_inst) tiles)) (SizeOf.sizeOf.{1} Nat instSizeOfNat tileCount)) (SizeOf.sizeOf.{0} (Eq.{1} Nat tileCount (List.length.{0} UnifiedIPLDMemory.WebTile tiles)) (instSizeOfDefault.{0} (Eq.{1} Nat tileCount (List.length.{0} UnifiedIPLDMemory.WebTile tiles))) count_consistent)) (SizeOf.sizeOf.{0} (Membership.mem.{0, 0} UnifiedIPLDMemory.WebTile (List.{0} UnifiedIPLDMemory.WebTile) (List.instMembership.{0} UnifiedIPLDMemory.WebTile) tiles root) (instSizeOfDefault.{0} (Membership.mem.{0, 0} UnifiedIPLDMemory.WebTile (List.{0} UnifiedIPLDMemory.WebTile) (List.instMembership.{0} UnifiedIPLDMemory.WebTile) tiles root)) root_in_tiles))

-- Stub: this file represents the declaration `UnifiedIPLDMemory.WebsiteSnapshot.mk.sizeOf_spec`.
-- In a full split, the body would be extracted from the environment.
