import Split.NonUnitalNonAssocRing
import Split.One
import Split.HMul_hMul
import Split.AddMonoid_toAddSemigroup
import Split.NonUnitalNonAssocRing_toMul
import Split.AddMonoid_toZero
import Split.NonUnitalNonAssocRing_toAddCommGroup
import Split.IntCast_intCast
import Split.AddCommGroup_toAddGroup
import Split.IntCast
import Split.NatCast
import Split.instOfNatNat
import Split.NonAssocRing
import Split.Int
import Split.NatCast_natCast
import Split.Nat_cast
import Split.autoParam
import Split.instHAdd
import Split.AddSemigroup_toAdd
import Split.AddGroup_toSubNegMonoid
import Split.HAdd_hAdd
import Split.Nat
import Split.SubNegMonoid_toNeg
import Split.One_toOfNat1
import Split.instAddNat
import Split.Zero_toOfNat0
import Split.instNatCastInt
import Split.Int_negSucc
import Split.SubNegMonoid_toAddMonoid
import Split.OfNat_ofNat
import Split.Eq
import Split.Neg_neg
import Split.instHMul

-- NonAssocRing.mk from environment
-- constructor NonAssocRing.mk : forall {α : Type.{u_1}} [toNonUnitalNonAssocRing : NonUnitalNonAssocRing.{u_1} α] [toOne : One.{u_1} α], (forall (a : α), Eq.{succ u_1} α (HMul.hMul.{u_1, u_1, u_1} α α α (instHMul.{u_1} α (NonUnitalNonAssocRing.toMul.{u_1} α toNonUnitalNonAssocRing)) (OfNat.ofNat.{u_1} α 1 (One.toOfNat1.{u_1} α toOne)) a) a) -> (forall (a : α), Eq.{succ u_1} α (HMul.hMul.{u_1, u_1, u_1} α α α (instHMul.{u_1} α (NonUnitalNonAssocRing.toMul.{u_1} α toNonUnitalNonAssocRing)) a (OfNat.ofNat.{u_1} α 1 (One.toOfNat1.{u_1} α toOne))) a) -> (forall [toNatCast : NatCast.{u_1} α], (autoParam.{0} (Eq.{succ u_1} α (NatCast.natCast.{u_1} α toNatCast (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) (OfNat.ofNat.{u_1} α 0 (Zero.toOfNat0.{u_1} α (AddMonoid.toZero.{u_1} α (SubNegMonoid.toAddMonoid.{u_1} α (AddGroup.toSubNegMonoid.{u_1} α (AddCommGroup.toAddGroup.{u_1} α (NonUnitalNonAssocRing.toAddCommGroup.{u_1} α toNonUnitalNonAssocRing)))))))) AddMonoidWithOne.natCast_zero._autoParam) -> (autoParam.{0} (forall (n : Nat), Eq.{succ u_1} α (NatCast.natCast.{u_1} α toNatCast (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) n (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)))) (HAdd.hAdd.{u_1, u_1, u_1} α α α (instHAdd.{u_1} α (AddSemigroup.toAdd.{u_1} α (AddMonoid.toAddSemigroup.{u_1} α (SubNegMonoid.toAddMonoid.{u_1} α (AddGroup.toSubNegMonoid.{u_1} α (AddCommGroup.toAddGroup.{u_1} α (NonUnitalNonAssocRing.toAddCommGroup.{u_1} α toNonUnitalNonAssocRing))))))) (NatCast.natCast.{u_1} α toNatCast n) (OfNat.ofNat.{u_1} α 1 (One.toOfNat1.{u_1} α toOne)))) AddMonoidWithOne.natCast_succ._autoParam) -> (forall [toIntCast : IntCast.{u_1} α], (autoParam.{0} (forall (n : Nat), Eq.{succ u_1} α (IntCast.intCast.{u_1} α toIntCast (Nat.cast.{0} Int instNatCastInt n)) (Nat.cast.{u_1} α toNatCast n)) AddGroupWithOne.intCast_ofNat._autoParam) -> (autoParam.{0} (forall (n : Nat), Eq.{succ u_1} α (IntCast.intCast.{u_1} α toIntCast (Int.negSucc n)) (Neg.neg.{u_1} α (SubNegMonoid.toNeg.{u_1} α (AddGroup.toSubNegMonoid.{u_1} α (AddCommGroup.toAddGroup.{u_1} α (NonUnitalNonAssocRing.toAddCommGroup.{u_1} α toNonUnitalNonAssocRing)))) (Nat.cast.{u_1} α toNatCast (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) n (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)))))) AddGroupWithOne.intCast_negSucc._autoParam) -> (NonAssocRing.{u_1} α)))

-- Stub: this file represents the declaration `NonAssocRing.mk`.
-- In a full split, the body would be extracted from the environment.
