import Split.Nat_Coprime
import Split.Rat_num
import Split.HMul_hMul
import Split.congrArg
import Split.Rat
import Split.Rat_den
import Split.Exists
import Split.Eq_mp
import Split.Ne
import Split.instMulNat
import Split.instOfNatNat
import Split.Int
import Split.Nat_cast
import Split.Rat_normalize
import Split.Int_instMul
import Split.And
import Split.Nat
import Split.Int_natAbs
import Split.instNatCastInt
import Split.Rat_mk'
import Split.optParam
import Split.OfNat_ofNat
import Split.Eq
import Split.Rat_normalize_num_den'
import Split.instHMul

-- Rat.normalize_num_den from environment
-- theorem Rat.normalize_num_den : forall {n : Int} {d : Nat} {z : Ne.{1} (optParam.{1} Nat (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))) d (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))} {n' : Int} {d' : Nat} {z' : Ne.{1} Nat d' (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))} {c : Nat.Coprime (Int.natAbs n') d'}, (Eq.{1} Rat (Rat.normalize n d z) (Rat.mk' n' d' z' c)) -> (Exists.{1} Nat (fun (m : Nat) => And (Ne.{1} Nat m (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) (And (Eq.{1} Int n (HMul.hMul.{0, 0, 0} Int Int Int (instHMul.{0} Int Int.instMul) n' (Nat.cast.{0} Int instNatCastInt m))) (Eq.{1} Nat d (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) d' m)))))

-- Stub: this file represents the declaration `Rat.normalize_num_den`.
-- In a full split, the body would be extracted from the environment.
