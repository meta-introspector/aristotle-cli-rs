import Split.UnifiedIPLDMemory_HexLatticePos_mk
import Split.UnifiedIPLDMemory_HexLatticePos
import Split.instOfNatNat
import Split.Int
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Nat
import Split.SizeOf_sizeOf
import Split.instAddNat
import Split.Eq_refl
import Split.OfNat_ofNat
import Split.Eq

-- UnifiedIPLDMemory.HexLatticePos.mk.sizeOf_spec from environment
-- theorem UnifiedIPLDMemory.HexLatticePos.mk.sizeOf_spec : forall (m : Int) (n : Int), Eq.{1} Nat (SizeOf.sizeOf.{1} UnifiedIPLDMemory.HexLatticePos UnifiedIPLDMemory.HexLatticePos._sizeOf_inst (UnifiedIPLDMemory.HexLatticePos.mk m n)) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)) (SizeOf.sizeOf.{1} Int Int._sizeOf_inst m)) (SizeOf.sizeOf.{1} Int Int._sizeOf_inst n))

-- Stub: this file represents the declaration `UnifiedIPLDMemory.HexLatticePos.mk.sizeOf_spec`.
-- In a full split, the body would be extracted from the environment.
