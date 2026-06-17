import Split.AddGroup_toSubtractionMonoid
import Split.Int_cast
import Split.NegZeroClass_toNeg
import Split.instHSMul
import Split.AddMonoidWithOne_natCast_zero
import Split.AddMonoidWithOne_mk
import Split.One
import Split.AddMonoid_toAddSemigroup
import Split.AddGroupWithOne_toAddGroup
import Split.SMul
import Split.AddGroupWithOne_toAddMonoidWithOne
import Split.HSub_hSub
import Split.AddMonoid_toNSMul
import Split.IntCast
import Split.NatCast
import Split.Function_Injective_addMonoidWithOne
import Split.AddMonoidWithOne_toNatCast
import Split.SubtractionMonoid_toSubNegZeroMonoid
import Split.Int
import Split.AddGroupWithOne_toIntCast
import Split.AddMonoidWithOne_natCast_succ
import Split.SubNegZeroMonoid_toNegZeroClass
import Split.Nat_cast
import Split.SubNegMonoid_toSub
import Split.AddMonoidWithOne_toOne
import Split.SubNegMonoid_zsmul
import Split.instHAdd
import Split.Neg
import Split.AddSemigroup_toAdd
import Split.AddGroup
import Split.instHSub
import Split.Function_Injective_addGroup
import Split.AddGroup_toSubNegMonoid
import Split.HAdd_hAdd
import Split.Nat
import Split.SubNegMonoid_toNeg
import Split.One_toOfNat1
import Split.Zero_toOfNat0
import Split.AddGroupWithOne
import Split.HSMul_hSMul
import Split.AddGroupWithOne_mk
import Split.Function_Injective
import Split.AddMonoidWithOne_toAddMonoid
import Split.SubNegMonoid_toAddMonoid
import Split.OfNat_ofNat
import Split.IntCast_mk
import Split.NegZeroClass_toZero
import Split.Eq
import Split.AddGroup_neg_add_cancel
import Split.Neg_neg
import Split.Add
import Split.AddMonoidWithOne
import Split.Sub
import Split.SubNegMonoid_toZSMul
import Split.Zero

-- Function.Injective.addGroupWithOne from environment
-- def Function.Injective.addGroupWithOne : forall {R : Type.{u_1}} {S : Type.{u_3}} [inst._@.Mathlib.Algebra.Ring.InjSurj.401502261._hygCtx._hyg.52 : Zero.{u_3} S] [inst._@.Mathlib.Algebra.Ring.InjSurj.401502261._hygCtx._hyg.55 : One.{u_3} S] [inst._@.Mathlib.Algebra.Ring.InjSurj.401502261._hygCtx._hyg.58 : Add.{u_3} S] [inst._@.Mathlib.Algebra.Ring.InjSurj.401502261._hygCtx._hyg.61 : SMul.{0, u_3} Nat S] [inst._@.Mathlib.Algebra.Ring.InjSurj.401502261._hygCtx._hyg.67 : Neg.{u_3} S] [inst._@.Mathlib.Algebra.Ring.InjSurj.401502261._hygCtx._hyg.70 : Sub.{u_3} S] [inst._@.Mathlib.Algebra.Ring.InjSurj.401502261._hygCtx._hyg.73 : SMul.{0, u_3} Int S] [inst._@.Mathlib.Algebra.Ring.InjSurj.401502261._hygCtx._hyg.79 : NatCast.{u_3} S] [inst._@.Mathlib.Algebra.Ring.InjSurj.401502261._hygCtx._hyg.82 : IntCast.{u_3} S] [inst._@.Mathlib.Algebra.Ring.InjSurj.401502261._hygCtx._hyg.85 : AddGroupWithOne.{u_1} R] (f : S -> R), (Function.Injective.{succ u_3, succ u_1} S R f) -> (Eq.{succ u_1} R (f (OfNat.ofNat.{u_3} S 0 (Zero.toOfNat0.{u_3} S inst._@.Mathlib.Algebra.Ring.InjSurj.401502261._hygCtx._hyg.52))) (OfNat.ofNat.{u_1} R 0 (Zero.toOfNat0.{u_1} R (NegZeroClass.toZero.{u_1} R (SubNegZeroMonoid.toNegZeroClass.{u_1} R (SubtractionMonoid.toSubNegZeroMonoid.{u_1} R (AddGroup.toSubtractionMonoid.{u_1} R (AddGroupWithOne.toAddGroup.{u_1} R inst._@.Mathlib.Algebra.Ring.InjSurj.401502261._hygCtx._hyg.85)))))))) -> (Eq.{succ u_1} R (f (OfNat.ofNat.{u_3} S 1 (One.toOfNat1.{u_3} S inst._@.Mathlib.Algebra.Ring.InjSurj.401502261._hygCtx._hyg.55))) (OfNat.ofNat.{u_1} R 1 (One.toOfNat1.{u_1} R (AddMonoidWithOne.toOne.{u_1} R (AddGroupWithOne.toAddMonoidWithOne.{u_1} R inst._@.Mathlib.Algebra.Ring.InjSurj.401502261._hygCtx._hyg.85))))) -> (forall (x : S) (y : S), Eq.{succ u_1} R (f (HAdd.hAdd.{u_3, u_3, u_3} S S S (instHAdd.{u_3} S inst._@.Mathlib.Algebra.Ring.InjSurj.401502261._hygCtx._hyg.58) x y)) (HAdd.hAdd.{u_1, u_1, u_1} R R R (instHAdd.{u_1} R (AddSemigroup.toAdd.{u_1} R (AddMonoid.toAddSemigroup.{u_1} R (AddMonoidWithOne.toAddMonoid.{u_1} R (AddGroupWithOne.toAddMonoidWithOne.{u_1} R inst._@.Mathlib.Algebra.Ring.InjSurj.401502261._hygCtx._hyg.85))))) (f x) (f y))) -> (forall (x : S), Eq.{succ u_1} R (f (Neg.neg.{u_3} S inst._@.Mathlib.Algebra.Ring.InjSurj.401502261._hygCtx._hyg.67 x)) (Neg.neg.{u_1} R (NegZeroClass.toNeg.{u_1} R (SubNegZeroMonoid.toNegZeroClass.{u_1} R (SubtractionMonoid.toSubNegZeroMonoid.{u_1} R (AddGroup.toSubtractionMonoid.{u_1} R (AddGroupWithOne.toAddGroup.{u_1} R inst._@.Mathlib.Algebra.Ring.InjSurj.401502261._hygCtx._hyg.85))))) (f x))) -> (forall (x : S) (y : S), Eq.{succ u_1} R (f (HSub.hSub.{u_3, u_3, u_3} S S S (instHSub.{u_3} S inst._@.Mathlib.Algebra.Ring.InjSurj.401502261._hygCtx._hyg.70) x y)) (HSub.hSub.{u_1, u_1, u_1} R R R (instHSub.{u_1} R (SubNegMonoid.toSub.{u_1} R (AddGroup.toSubNegMonoid.{u_1} R (AddGroupWithOne.toAddGroup.{u_1} R inst._@.Mathlib.Algebra.Ring.InjSurj.401502261._hygCtx._hyg.85)))) (f x) (f y))) -> (forall (n : Nat) (x : S), Eq.{succ u_1} R (f (HSMul.hSMul.{0, u_3, u_3} Nat S S (instHSMul.{0, u_3} Nat S inst._@.Mathlib.Algebra.Ring.InjSurj.401502261._hygCtx._hyg.61) n x)) (HSMul.hSMul.{0, u_1, u_1} Nat R R (instHSMul.{0, u_1} Nat R (AddMonoid.toNSMul.{u_1} R (AddMonoidWithOne.toAddMonoid.{u_1} R (AddGroupWithOne.toAddMonoidWithOne.{u_1} R inst._@.Mathlib.Algebra.Ring.InjSurj.401502261._hygCtx._hyg.85)))) n (f x))) -> (forall (n : Int) (x : S), Eq.{succ u_1} R (f (HSMul.hSMul.{0, u_3, u_3} Int S S (instHSMul.{0, u_3} Int S inst._@.Mathlib.Algebra.Ring.InjSurj.401502261._hygCtx._hyg.73) n x)) (HSMul.hSMul.{0, u_1, u_1} Int R R (instHSMul.{0, u_1} Int R (SubNegMonoid.toZSMul.{u_1} R (AddGroup.toSubNegMonoid.{u_1} R (AddGroupWithOne.toAddGroup.{u_1} R inst._@.Mathlib.Algebra.Ring.InjSurj.401502261._hygCtx._hyg.85)))) n (f x))) -> (forall (n : Nat), Eq.{succ u_1} R (f (Nat.cast.{u_3} S inst._@.Mathlib.Algebra.Ring.InjSurj.401502261._hygCtx._hyg.79 n)) (Nat.cast.{u_1} R (AddMonoidWithOne.toNatCast.{u_1} R (AddGroupWithOne.toAddMonoidWithOne.{u_1} R inst._@.Mathlib.Algebra.Ring.InjSurj.401502261._hygCtx._hyg.85)) n)) -> (forall (n : Int), Eq.{succ u_1} R (f (Int.cast.{u_3} S inst._@.Mathlib.Algebra.Ring.InjSurj.401502261._hygCtx._hyg.82 n)) (Int.cast.{u_1} R (AddGroupWithOne.toIntCast.{u_1} R inst._@.Mathlib.Algebra.Ring.InjSurj.401502261._hygCtx._hyg.85) n)) -> (AddGroupWithOne.{u_3} S)
-- (definition body omitted)

-- Stub: this file represents the declaration `Function.Injective.addGroupWithOne`.
-- In a full split, the body would be extracted from the environment.
