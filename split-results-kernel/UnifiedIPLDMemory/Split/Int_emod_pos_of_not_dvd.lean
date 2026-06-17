import Split.Iff_mpr
import Split.Dvd_dvd
import Split.congrArg
import Split.true_or
import Split.Int_instDecidableEq
import Split.Eq_mp
import Split.instHMod
import Split.Ne
import Split.Ne_symm
import Split.Int
import Split.LE_le
import Split.Int_lt_iff_le_and_ne
import Split.dite
import Split.Int_instDvd
import Split.Int_instLTInt
import Split.HMod_hMod
import Split.Int_emod_zero
import Split.And
import Split.instOfNat
import Split.And_intro
import Split.congr
import Split.LT_lt
import Split.True
import Split.eq_self
import Split.propext
import Split.of_eq_true
import Split.Int_instMod
import Split.congrFun'
import Split.Or
import Split.OfNat_ofNat
import Split.Eq
import Split.Not
import Split.Int_emod_nonneg
import Split.Or_inr
import Split.Int_instLEInt
import Split.Int_dvd_iff_emod_eq_zero
import Split.Eq_trans

-- Int.emod_pos_of_not_dvd from environment
-- theorem Int.emod_pos_of_not_dvd : forall {a : Int} {b : Int}, (Not (Dvd.dvd.{0} Int Int.instDvd a b)) -> (Or (Eq.{1} Int a (OfNat.ofNat.{0} Int 0 (instOfNat 0))) (LT.lt.{0} Int Int.instLTInt (OfNat.ofNat.{0} Int 0 (instOfNat 0)) (HMod.hMod.{0, 0, 0} Int Int Int (instHMod.{0} Int Int.instMod) b a)))

-- Stub: this file represents the declaration `Int.emod_pos_of_not_dvd`.
-- In a full split, the body would be extracted from the environment.
