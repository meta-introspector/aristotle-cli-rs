import Split.List_map
import Split.Membership_mem
import Split.Exists
import Split.instOfNatNat
import Split.List_range
import Split.ZMod
import Split.List
import Split.List_instMembership
import Split.Nat
import Split.QExpansionSampler_jCoeff
import Split.Exists_intro
import Split.Prod
import Split.OfNat_ofNat
import Split.Eq
import Split.rfl
import Split.QExpansionSampler_Phi

-- QExpansionSampler.extruder_well_defined from environment
-- theorem QExpansionSampler.extruder_well_defined : forall (d : Nat) (c : Nat), (Membership.mem.{0, 0} Nat (List.{0} Nat) (List.instMembership.{0} Nat) (List.map.{0, 0} Nat Nat QExpansionSampler.jCoeff (List.range d)) c) -> (Exists.{1} (Prod.{0, 0} (ZMod (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47))) (Prod.{0, 0} (ZMod (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59))) (ZMod (OfNat.ofNat.{0} Nat 71 (instOfNatNat 71))))) (fun (addr : Prod.{0, 0} (ZMod (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47))) (Prod.{0, 0} (ZMod (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59))) (ZMod (OfNat.ofNat.{0} Nat 71 (instOfNatNat 71))))) => Eq.{1} (Prod.{0, 0} (ZMod (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47))) (Prod.{0, 0} (ZMod (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59))) (ZMod (OfNat.ofNat.{0} Nat 71 (instOfNatNat 71))))) (QExpansionSampler.Phi c) addr))

-- Stub: this file represents the declaration `QExpansionSampler.extruder_well_defined`.
-- In a full split, the body would be extracted from the environment.
