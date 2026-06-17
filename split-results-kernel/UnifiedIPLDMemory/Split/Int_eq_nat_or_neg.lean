import Split.Exists
import Split.Int_instNegInt
import Split.Int
import Split.Nat_cast
import Split.Nat
import Split.Int_natAbs
import Split.Exists_intro
import Split.Int_natAbs_eq
import Split.Or
import Split.instNatCastInt
import Split.Eq
import Split.Neg_neg

-- Int.eq_nat_or_neg from environment
-- theorem Int.eq_nat_or_neg : forall (a : Int), Exists.{1} Nat (fun (n : Nat) => Or (Eq.{1} Int a (Nat.cast.{0} Int instNatCastInt n)) (Eq.{1} Int a (Neg.neg.{0} Int Int.instNegInt (Nat.cast.{0} Int instNatCastInt n))))

-- Stub: this file represents the declaration `Int.eq_nat_or_neg`.
-- In a full split, the body would be extracted from the environment.
