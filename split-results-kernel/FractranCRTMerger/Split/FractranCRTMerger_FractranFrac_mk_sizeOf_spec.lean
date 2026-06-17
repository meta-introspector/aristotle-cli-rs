import Split.FractranCRTMerger_FractranFrac
import Split.Ne
import Split.instOfNatNat
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Nat
import Split.SizeOf_sizeOf
import Split.instAddNat
import Split.FractranCRTMerger_FractranFrac_mk
import Split.Eq_refl
import Split.instSizeOfNat
import Split.OfNat_ofNat
import Split.Eq

-- FractranCRTMerger.FractranFrac.mk.sizeOf_spec from environment
-- theorem FractranCRTMerger.FractranFrac.mk.sizeOf_spec : forall (num : Nat) (den : Nat) (den_pos : Ne.{1} Nat den (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))), Eq.{1} Nat (SizeOf.sizeOf.{1} FractranCRTMerger.FractranFrac FractranCRTMerger.FractranFrac._sizeOf_inst (FractranCRTMerger.FractranFrac.mk num den den_pos)) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)) (SizeOf.sizeOf.{1} Nat instSizeOfNat num)) (SizeOf.sizeOf.{1} Nat instSizeOfNat den))

-- Stub: this file represents the declaration `FractranCRTMerger.FractranFrac.mk.sizeOf_spec`.
-- In a full split, the body would be extracted from the environment.
