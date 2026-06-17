import Split.Nat_Coprime
import Split.False
import Split.HMul_hMul
import Split.eq_false
import Split.congrArg
import Split.and_self
import Split.Rat
import Split.Rat_divInt
import Split.Exists
import Split.Eq_mp
import Split.id
import Split.Int_instNegInt
import Split.Ne
import Split.instMulNat
import Split.instOfNatNat
import Split.Int
import Split.Nat_cast
import Split.Int_mul_neg
import Split.Or_casesOn
import Split.Int_instMul
import Split.Rat_divInt_ofNat
import Split.mkRat
import Split.And
import Split.Rat_mkRat_num_den
import Split.Exists_casesOn
import Split.Rat_divInt_neg'
import Split.instOfNat
import Split.Int_eq_nat_or_neg
import Split.Nat
import Split.congr
import Split.True
import Split.Int_natAbs
import Split.eq_self
import Split.propext
import Split.Exists_intro
import Split.of_eq_true
import Split.Eq_ndrec
import Split.congrFun'
import Split.Or
import Split.instNatCastInt
import Split.Int_neg_neg
import Split.Rat_mk'
import Split.OfNat_ofNat
import Split.Eq_symm
import Split.not_false_eq_true
import Split.Eq
import Split.Not
import Split.Neg_neg
import Split.Eq_trans
import Split.Int_neg_inj
import Split.instHMul

-- Rat.divInt_num_den from environment
-- theorem Rat.divInt_num_den : forall {d : Int} {n : Int} {n' : Int} {d' : Nat} {z' : Ne.{1} Nat d' (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))} {c : Nat.Coprime (Int.natAbs n') d'}, (Ne.{1} Int d (OfNat.ofNat.{0} Int 0 (instOfNat 0))) -> (Eq.{1} Rat (Rat.divInt n d) (Rat.mk' n' d' z' c)) -> (Exists.{1} Int (fun (m : Int) => And (Ne.{1} Int m (OfNat.ofNat.{0} Int 0 (instOfNat 0))) (And (Eq.{1} Int n (HMul.hMul.{0, 0, 0} Int Int Int (instHMul.{0} Int Int.instMul) n' m)) (Eq.{1} Int d (HMul.hMul.{0, 0, 0} Int Int Int (instHMul.{0} Int Int.instMul) (Nat.cast.{0} Int instNatCastInt d') m)))))

-- Stub: this file represents the declaration `Rat.divInt_num_den`.
-- In a full split, the body would be extracted from the environment.
