import Split.FractranCRTMerger_FractranFrac
import Split.id
import Split.Ne
import Split.instOfNatNat
import Split.Nat
import Split.FractranCRTMerger_FractranFrac_mk
import Split.FractranCRTMerger_FractranFrac_noConfusion
import Split.OfNat_ofNat
import Split.Eq

-- FractranCRTMerger.FractranFrac.mk.noConfusion from environment
-- def FractranCRTMerger.FractranFrac.mk.noConfusion : forall {P : Sort.{u}} {num : Nat} {den : Nat} {den_pos : Ne.{1} Nat den (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))} {num' : Nat} {den' : Nat} {den_pos' : Ne.{1} Nat den' (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))}, (Eq.{1} FractranCRTMerger.FractranFrac (FractranCRTMerger.FractranFrac.mk num den den_pos) (FractranCRTMerger.FractranFrac.mk num' den' den_pos')) -> ((Eq.{1} Nat num num') -> (Eq.{1} Nat den den') -> P) -> P
-- (definition body omitted)

-- Stub: this file represents the declaration `FractranCRTMerger.FractranFrac.mk.noConfusion`.
-- In a full split, the body would be extracted from the environment.
