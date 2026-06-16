import Split.Iff_mpr
import Split.Int_natAbs_pos
import Split.Nat_instMod
import Split.instHMod
import Split.Int_sub_nonneg_of_le
import Split.Ne
import Split.instOfNatNat
import Split.Int
import Split.LE_le
import Split.instLENat
import Split.Nat_cast
import Split.Nat_mod_lt
import Split.HMod_hMod
import Split.instOfNat
import Split.Nat
import Split.LT_lt
import Split.Int_natAbs
import Split.Int_instMod
import Split.instNatCastInt
import Split.instLTNat
import Split.Int_ofNat_le
import Split.OfNat_ofNat
import Split.Nat_succ
import Split.Int_instLEInt
import Split.Int_natCast_nonneg

-- Int.emod_nonneg from environment
-- theorem Int.emod_nonneg : forall (a : Int) {b : Int}, (Ne.{1} Int b (OfNat.ofNat.{0} Int 0 (instOfNat 0))) -> (LE.le.{0} Int Int.instLEInt (OfNat.ofNat.{0} Int 0 (instOfNat 0)) (HMod.hMod.{0, 0, 0} Int Int Int (instHMod.{0} Int Int.instMod) a b))

-- Stub: this file represents the declaration `Int.emod_nonneg`.
-- In a full split, the body would be extracted from the environment.
