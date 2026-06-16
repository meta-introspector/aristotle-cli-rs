import Split.FractranCRTMerger_FractranFrac
import Split.String
import Split.id
import Split.instOfNatNat
import Split.FractranCRTMerger_FractranObject_noConfusion
import Split.ZMod
import Split.List
import Split.FractranCRTMerger_FractranObject_mk
import Split.Nat
import Split.FractranCRTMerger_FractranObject
import Split.Prod
import Split.OfNat_ofNat
import Split.Eq

-- FractranCRTMerger.FractranObject.mk.noConfusion from environment
-- def FractranCRTMerger.FractranObject.mk.noConfusion : forall {P : Sort.{u}} {name : String} {cardinality : Nat} {program : List.{0} FractranCRTMerger.FractranFrac} {address : Prod.{0, 0} (ZMod (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47))) (Prod.{0, 0} (ZMod (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59))) (ZMod (OfNat.ofNat.{0} Nat 71 (instOfNatNat 71))))} {name' : String} {cardinality' : Nat} {program' : List.{0} FractranCRTMerger.FractranFrac} {address' : Prod.{0, 0} (ZMod (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47))) (Prod.{0, 0} (ZMod (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59))) (ZMod (OfNat.ofNat.{0} Nat 71 (instOfNatNat 71))))}, (Eq.{1} FractranCRTMerger.FractranObject (FractranCRTMerger.FractranObject.mk name cardinality program address) (FractranCRTMerger.FractranObject.mk name' cardinality' program' address')) -> ((Eq.{1} String name name') -> (Eq.{1} Nat cardinality cardinality') -> (Eq.{1} (List.{0} FractranCRTMerger.FractranFrac) program program') -> (Eq.{1} (Prod.{0, 0} (ZMod (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47))) (Prod.{0, 0} (ZMod (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59))) (ZMod (OfNat.ofNat.{0} Nat 71 (instOfNatNat 71))))) address address') -> P) -> P
-- (definition body omitted)

-- Stub: this file represents the declaration `FractranCRTMerger.FractranObject.mk.noConfusion`.
-- In a full split, the body would be extracted from the environment.
