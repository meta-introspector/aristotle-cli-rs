import Split.AddGroup_toSubtractionMonoid
import Split.Int_cast
import Split.NegZeroClass_toNeg
import Split.instHSMul
import Split.One
import Split.AddMonoid_toAddSemigroup
import Split.AddGroupWithOne_toAddGroup
import Split.SMul
import Split.AddGroupWithOne_toAddMonoidWithOne
import Split.HSub_hSub
import Split.AddMonoid_toNSMul
import Split.IntCast
import Split.NatCast
import Split.AddMonoidWithOne_toNatCast
import Split.SubtractionMonoid_toSubNegZeroMonoid
import Split.Int
import Split.AddGroupWithOne_toIntCast
import Split.Function_Surjective_addMonoidWithOne
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
import Split.AddGroup_toSubNegMonoid
import Split.HAdd_hAdd
import Split.Nat
import Split.SubNegMonoid_toNeg
import Split.One_toOfNat1
import Split.Zero_toOfNat0
import Split.AddGroupWithOne
import Split.HSMul_hSMul
import Split.AddGroupWithOne_mk
import Split.AddMonoidWithOne_toAddMonoid
import Split.OfNat_ofNat
import Split.IntCast_mk
import Split.NegZeroClass_toZero
import Split.Eq
import Split.AddGroup_neg_add_cancel
import Split.Function_Surjective
import Split.Function_Surjective_addGroup
import Split.Neg_neg
import Split.Add
import Split.AddMonoidWithOne
import Split.Sub
import Split.SubNegMonoid_toZSMul
import Split.Zero

-- Function.Surjective.addGroupWithOne from environment
-- def Function.Surjective.addGroupWithOne : forall {R : Type.{u_1}} {S : Type.{u_2}} (f : R -> S), (Function.Surjective.{succ u_1, succ u_2} R S f) -> (forall [inst._@.Mathlib.Algebra.Ring.InjSurj.401502262._hygCtx._hyg.9 : Add.{u_2} S] [inst._@.Mathlib.Algebra.Ring.InjSurj.401502262._hygCtx._hyg.15 : Zero.{u_2} S] [inst._@.Mathlib.Algebra.Ring.InjSurj.401502262._hygCtx._hyg.18 : One.{u_2} S] [inst._@.Mathlib.Algebra.Ring.InjSurj.401502262._hygCtx._hyg.21 : Neg.{u_2} S] [inst._@.Mathlib.Algebra.Ring.InjSurj.401502262._hygCtx._hyg.24 : Sub.{u_2} S] [inst._@.Mathlib.Algebra.Ring.InjSurj.401502262._hygCtx._hyg.27 : SMul.{0, u_2} Nat S] [inst._@.Mathlib.Algebra.Ring.InjSurj.401502262._hygCtx._hyg.33 : SMul.{0, u_2} Int S] [inst._@.Mathlib.Algebra.Ring.InjSurj.401502262._hygCtx._hyg.45 : NatCast.{u_2} S] [inst._@.Mathlib.Algebra.Ring.InjSurj.401502262._hygCtx._hyg.48 : IntCast.{u_2} S] [inst._@.Mathlib.Algebra.Ring.InjSurj.401502262._hygCtx._hyg.51 : AddGroupWithOne.{u_1} R], (Eq.{succ u_2} S (f (OfNat.ofNat.{u_1} R 0 (Zero.toOfNat0.{u_1} R (NegZeroClass.toZero.{u_1} R (SubNegZeroMonoid.toNegZeroClass.{u_1} R (SubtractionMonoid.toSubNegZeroMonoid.{u_1} R (AddGroup.toSubtractionMonoid.{u_1} R (AddGroupWithOne.toAddGroup.{u_1} R inst._@.Mathlib.Algebra.Ring.InjSurj.401502262._hygCtx._hyg.51)))))))) (OfNat.ofNat.{u_2} S 0 (Zero.toOfNat0.{u_2} S inst._@.Mathlib.Algebra.Ring.InjSurj.401502262._hygCtx._hyg.15))) -> (Eq.{succ u_2} S (f (OfNat.ofNat.{u_1} R 1 (One.toOfNat1.{u_1} R (AddMonoidWithOne.toOne.{u_1} R (AddGroupWithOne.toAddMonoidWithOne.{u_1} R inst._@.Mathlib.Algebra.Ring.InjSurj.401502262._hygCtx._hyg.51))))) (OfNat.ofNat.{u_2} S 1 (One.toOfNat1.{u_2} S inst._@.Mathlib.Algebra.Ring.InjSurj.401502262._hygCtx._hyg.18))) -> (forall (x : R) (y : R), Eq.{succ u_2} S (f (HAdd.hAdd.{u_1, u_1, u_1} R R R (instHAdd.{u_1} R (AddSemigroup.toAdd.{u_1} R (AddMonoid.toAddSemigroup.{u_1} R (AddMonoidWithOne.toAddMonoid.{u_1} R (AddGroupWithOne.toAddMonoidWithOne.{u_1} R inst._@.Mathlib.Algebra.Ring.InjSurj.401502262._hygCtx._hyg.51))))) x y)) (HAdd.hAdd.{u_2, u_2, u_2} S S S (instHAdd.{u_2} S inst._@.Mathlib.Algebra.Ring.InjSurj.401502262._hygCtx._hyg.9) (f x) (f y))) -> (forall (x : R), Eq.{succ u_2} S (f (Neg.neg.{u_1} R (NegZeroClass.toNeg.{u_1} R (SubNegZeroMonoid.toNegZeroClass.{u_1} R (SubtractionMonoid.toSubNegZeroMonoid.{u_1} R (AddGroup.toSubtractionMonoid.{u_1} R (AddGroupWithOne.toAddGroup.{u_1} R inst._@.Mathlib.Algebra.Ring.InjSurj.401502262._hygCtx._hyg.51))))) x)) (Neg.neg.{u_2} S inst._@.Mathlib.Algebra.Ring.InjSurj.401502262._hygCtx._hyg.21 (f x))) -> (forall (x : R) (y : R), Eq.{succ u_2} S (f (HSub.hSub.{u_1, u_1, u_1} R R R (instHSub.{u_1} R (SubNegMonoid.toSub.{u_1} R (AddGroup.toSubNegMonoid.{u_1} R (AddGroupWithOne.toAddGroup.{u_1} R inst._@.Mathlib.Algebra.Ring.InjSurj.401502262._hygCtx._hyg.51)))) x y)) (HSub.hSub.{u_2, u_2, u_2} S S S (instHSub.{u_2} S inst._@.Mathlib.Algebra.Ring.InjSurj.401502262._hygCtx._hyg.24) (f x) (f y))) -> (forall (n : Nat) (x : R), Eq.{succ u_2} S (f (HSMul.hSMul.{0, u_1, u_1} Nat R R (instHSMul.{0, u_1} Nat R (AddMonoid.toNSMul.{u_1} R (AddMonoidWithOne.toAddMonoid.{u_1} R (AddGroupWithOne.toAddMonoidWithOne.{u_1} R inst._@.Mathlib.Algebra.Ring.InjSurj.401502262._hygCtx._hyg.51)))) n x)) (HSMul.hSMul.{0, u_2, u_2} Nat S S (instHSMul.{0, u_2} Nat S inst._@.Mathlib.Algebra.Ring.InjSurj.401502262._hygCtx._hyg.27) n (f x))) -> (forall (n : Int) (x : R), Eq.{succ u_2} S (f (HSMul.hSMul.{0, u_1, u_1} Int R R (instHSMul.{0, u_1} Int R (SubNegMonoid.toZSMul.{u_1} R (AddGroup.toSubNegMonoid.{u_1} R (AddGroupWithOne.toAddGroup.{u_1} R inst._@.Mathlib.Algebra.Ring.InjSurj.401502262._hygCtx._hyg.51)))) n x)) (HSMul.hSMul.{0, u_2, u_2} Int S S (instHSMul.{0, u_2} Int S inst._@.Mathlib.Algebra.Ring.InjSurj.401502262._hygCtx._hyg.33) n (f x))) -> (forall (n : Nat), Eq.{succ u_2} S (f (Nat.cast.{u_1} R (AddMonoidWithOne.toNatCast.{u_1} R (AddGroupWithOne.toAddMonoidWithOne.{u_1} R inst._@.Mathlib.Algebra.Ring.InjSurj.401502262._hygCtx._hyg.51)) n)) (Nat.cast.{u_2} S inst._@.Mathlib.Algebra.Ring.InjSurj.401502262._hygCtx._hyg.45 n)) -> (forall (n : Int), Eq.{succ u_2} S (f (Int.cast.{u_1} R (AddGroupWithOne.toIntCast.{u_1} R inst._@.Mathlib.Algebra.Ring.InjSurj.401502262._hygCtx._hyg.51) n)) (Int.cast.{u_2} S inst._@.Mathlib.Algebra.Ring.InjSurj.401502262._hygCtx._hyg.48 n)) -> (AddGroupWithOne.{u_2} S))
-- (definition body omitted)

-- Stub: this file represents the declaration `Function.Surjective.addGroupWithOne`.
-- In a full split, the body would be extracted from the environment.
