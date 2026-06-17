import Split.Rat_normalize_eq_mkRat
import Split.Nat_Coprime
import Split.HMul_hMul
import Split.Rat
import Split.Rat_normalize_num_den
import Split.Exists
import Split.Eq_rec
import Split.Ne
import Split.instMulNat
import Split.instOfNatNat
import Split.Int
import Split.Nat_cast
import Split.Rat_normalize
import Split.Int_instMul
import Split.mkRat
import Split.And
import Split.Nat
import Split.Int_natAbs
import Split.instNatCastInt
import Split.Rat_mk'
import Split.OfNat_ofNat
import Split.Eq_symm
import Split.Eq
import Split.instHMul

-- Rat.mkRat_num_den from environment
-- theorem Rat.mkRat_num_den : forall {d : Nat} {n : Int} {n' : Int} {d' : Nat} {z' : Ne.{1} Nat d' (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))} {c : Nat.Coprime (Int.natAbs n') d'}, (Ne.{1} Nat d (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) -> (Eq.{1} Rat (mkRat n d) (Rat.mk' n' d' z' c)) -> (Exists.{1} Nat (fun (m : Nat) => And (Ne.{1} Nat m (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) (And (Eq.{1} Int n (HMul.hMul.{0, 0, 0} Int Int Int (instHMul.{0} Int Int.instMul) n' (Nat.cast.{0} Int instNatCastInt m))) (Eq.{1} Nat d (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) d' m)))))

-- Stub: this file represents the declaration `Rat.mkRat_num_den`.
-- In a full split, the body would be extracted from the environment.
