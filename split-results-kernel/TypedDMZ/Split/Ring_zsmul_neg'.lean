import Split.Ring_toNeg
import Split.Int
import Split.Nat_cast
import Split.Nat
import Split.instNatCastInt
import Split.Int_negSucc
import Split.Nat_succ
import Split.Eq
import Split.Ring_zsmul
import Split.Ring
import Split.Neg_neg

-- Ring.zsmul_neg' from environment
-- theorem Ring.zsmul_neg' : forall {R : Type.{u}} [self : Ring.{u} R] (n : Nat) (a : R), Eq.{succ u} R (Ring.zsmul.{u} R self (Int.negSucc n) a) (Neg.neg.{u} R (Ring.toNeg.{u} R self) (Ring.zsmul.{u} R self (Nat.cast.{0} Int instNatCastInt (Nat.succ n)) a))

-- Stub: this file represents the declaration `Ring.zsmul_neg'`.
-- In a full split, the body would be extracted from the environment.
