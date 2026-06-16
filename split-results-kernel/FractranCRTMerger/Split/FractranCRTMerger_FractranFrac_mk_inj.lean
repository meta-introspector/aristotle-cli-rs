import Split.FractranCRTMerger_FractranFrac_mk_noConfusion
import Split.FractranCRTMerger_FractranFrac
import Split.Ne
import Split.instOfNatNat
import Split.And
import Split.Nat
import Split.And_intro
import Split.FractranCRTMerger_FractranFrac_mk
import Split.OfNat_ofNat
import Split.Eq

-- FractranCRTMerger.FractranFrac.mk.inj from environment
-- theorem FractranCRTMerger.FractranFrac.mk.inj : forall {num : Nat} {den : Nat} {den_pos : Ne.{1} Nat den (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))} {num_1 : Nat} {den_1 : Nat} {den_pos_1 : Ne.{1} Nat den_1 (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))}, (Eq.{1} FractranCRTMerger.FractranFrac (FractranCRTMerger.FractranFrac.mk num den den_pos) (FractranCRTMerger.FractranFrac.mk num_1 den_1 den_pos_1)) -> (And (Eq.{1} Nat num num_1) (Eq.{1} Nat den den_1))

-- Stub: this file represents the declaration `FractranCRTMerger.FractranFrac.mk.inj`.
-- In a full split, the body would be extracted from the environment.
