import Split.FractranCRTMerger_FractranFrac
import Split.FractranCRTMerger_mkFrac
import Split.Eq_rec
import Split.Ne
import Split.instOfNatNat
import Split.Nat
import Split.Eq_ndrec
import Split.Eq_refl
import Split.OfNat_ofNat
import Split.Eq

-- FractranCRTMerger.mkFrac.congr_simp from environment
-- theorem FractranCRTMerger.mkFrac.congr_simp : forall (p : Nat) (p_1 : Nat), (Eq.{1} Nat p p_1) -> (forall (q : Nat) (q_1 : Nat) (e_q : Eq.{1} Nat q q_1) (hq : Ne.{1} Nat q (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))), Eq.{1} FractranCRTMerger.FractranFrac (FractranCRTMerger.mkFrac p q hq) (FractranCRTMerger.mkFrac p_1 q_1 (Eq.ndrec.{0, 1} Nat q (fun (q : Nat) => Ne.{1} Nat q (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) hq q_1 e_q)))

-- Stub: this file represents the declaration `FractranCRTMerger.mkFrac.congr_simp`.
-- In a full split, the body would be extracted from the environment.
