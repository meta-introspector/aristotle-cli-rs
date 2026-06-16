import Split.FractranCRTMerger_FractranFrac
import Split.Eq_propIntro
import Split.String
import Split.Lean_injEq_helper
import Split.instOfNatNat
import Split.ZMod
import Split.List
import Split.And
import Split.FractranCRTMerger_FractranObject_mk_inj
import Split.FractranCRTMerger_FractranObject_mk
import Split.Nat
import Split.Eq_ndrec
import Split.Eq_refl
import Split.FractranCRTMerger_FractranObject
import Split.Prod
import Split.OfNat_ofNat
import Split.Eq

-- FractranCRTMerger.FractranObject.mk.injEq from environment
-- theorem FractranCRTMerger.FractranObject.mk.injEq : forall (name : String) (cardinality : Nat) (program : List.{0} FractranCRTMerger.FractranFrac) (address : Prod.{0, 0} (ZMod (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47))) (Prod.{0, 0} (ZMod (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59))) (ZMod (OfNat.ofNat.{0} Nat 71 (instOfNatNat 71))))) (name_1 : String) (cardinality_1 : Nat) (program_1 : List.{0} FractranCRTMerger.FractranFrac) (address_1 : Prod.{0, 0} (ZMod (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47))) (Prod.{0, 0} (ZMod (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59))) (ZMod (OfNat.ofNat.{0} Nat 71 (instOfNatNat 71))))), Eq.{1} Prop (Eq.{1} FractranCRTMerger.FractranObject (FractranCRTMerger.FractranObject.mk name cardinality program address) (FractranCRTMerger.FractranObject.mk name_1 cardinality_1 program_1 address_1)) (And (Eq.{1} String name name_1) (And (Eq.{1} Nat cardinality cardinality_1) (And (Eq.{1} (List.{0} FractranCRTMerger.FractranFrac) program program_1) (Eq.{1} (Prod.{0, 0} (ZMod (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47))) (Prod.{0, 0} (ZMod (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59))) (ZMod (OfNat.ofNat.{0} Nat 71 (instOfNatNat 71))))) address address_1))))

-- Stub: this file represents the declaration `FractranCRTMerger.FractranObject.mk.injEq`.
-- In a full split, the body would be extracted from the environment.
