import Split.AddMonoid_toAddSemigroup
import Split.AddMonoid_toZero
import Split.HSub_hSub
import Split.SubNegMonoid
import Split.Int
import Split.Nat_cast
import Split.autoParam
import Split.instHAdd
import Split.Neg
import Split.AddSemigroup_toAdd
import Split.instHSub
import Split.instOfNat
import Split.HAdd_hAdd
import Split.Nat
import Split.AddMonoid
import Split.Zero_toOfNat0
import Split.instNatCastInt
import Split.Int_negSucc
import Split.OfNat_ofNat
import Split.Nat_succ
import Split.Eq
import Split.Neg_neg
import Split.Sub

-- SubNegMonoid.mk from environment
-- constructor SubNegMonoid.mk : forall {G : Type.{u}} [toAddMonoid : AddMonoid.{u} G] [toNeg : Neg.{u} G] [toSub : Sub.{u} G], (autoParam.{0} (forall (a : G) (b : G), Eq.{succ u} G (HSub.hSub.{u, u, u} G G G (instHSub.{u} G toSub) a b) (HAdd.hAdd.{u, u, u} G G G (instHAdd.{u} G (AddSemigroup.toAdd.{u} G (AddMonoid.toAddSemigroup.{u} G toAddMonoid))) a (Neg.neg.{u} G toNeg b))) SubNegMonoid.sub_eq_add_neg._autoParam) -> (forall (zsmul : Int -> G -> G), (autoParam.{0} (forall (a : G), Eq.{succ u} G (zsmul (OfNat.ofNat.{0} Int 0 (instOfNat 0)) a) (OfNat.ofNat.{u} G 0 (Zero.toOfNat0.{u} G (AddMonoid.toZero.{u} G toAddMonoid)))) SubNegMonoid.zsmul_zero'._autoParam) -> (autoParam.{0} (forall (n : Nat) (a : G), Eq.{succ u} G (zsmul (Nat.cast.{0} Int instNatCastInt (Nat.succ n)) a) (HAdd.hAdd.{u, u, u} G G G (instHAdd.{u} G (AddSemigroup.toAdd.{u} G (AddMonoid.toAddSemigroup.{u} G toAddMonoid))) (zsmul (Nat.cast.{0} Int instNatCastInt n) a) a)) SubNegMonoid.zsmul_succ'._autoParam) -> (autoParam.{0} (forall (n : Nat) (a : G), Eq.{succ u} G (zsmul (Int.negSucc n) a) (Neg.neg.{u} G toNeg (zsmul (Nat.cast.{0} Int instNatCastInt (Nat.succ n)) a))) SubNegMonoid.zsmul_neg'._autoParam) -> (SubNegMonoid.{u} G))

-- Stub: this file represents the declaration `SubNegMonoid.mk`.
-- In a full split, the body would be extracted from the environment.
