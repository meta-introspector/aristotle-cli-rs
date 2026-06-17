import Split.instHSMul
import Split.AddMonoidWithOne_mk
import Split.One
import Split.AddMonoid_toAddSemigroup
import Split.SMul
import Split.AddMonoid_toAddZeroClass
import Split.AddMonoid_toNSMul
import Split.Function_Surjective_addMonoid
import Split.AddZeroClass_toAddZero
import Split.NatCast
import Split.AddMonoidWithOne_toNatCast
import Split.Nat_cast
import Split.AddMonoidWithOne_toOne
import Split.AddZero_toZero
import Split.instHAdd
import Split.AddSemigroup_toAdd
import Split.HAdd_hAdd
import Split.Nat
import Split.NatCast_mk
import Split.AddMonoid
import Split.One_toOfNat1
import Split.Zero_toOfNat0
import Split.HSMul_hSMul
import Split.AddMonoidWithOne_toAddMonoid
import Split.OfNat_ofNat
import Split.Eq
import Split.Function_Surjective
import Split.Add
import Split.AddMonoidWithOne
import Split.Zero

-- Function.Surjective.addMonoidWithOne from environment
-- def Function.Surjective.addMonoidWithOne : forall {R : Type.{u_1}} {S : Type.{u_2}} (f : R -> S), (Function.Surjective.{succ u_1, succ u_2} R S f) -> (forall [inst._@.Mathlib.Algebra.Ring.InjSurj.2168556279._hygCtx._hyg.9 : Add.{u_2} S] [inst._@.Mathlib.Algebra.Ring.InjSurj.2168556279._hygCtx._hyg.15 : Zero.{u_2} S] [inst._@.Mathlib.Algebra.Ring.InjSurj.2168556279._hygCtx._hyg.18 : One.{u_2} S] [inst._@.Mathlib.Algebra.Ring.InjSurj.2168556279._hygCtx._hyg.27 : SMul.{0, u_2} Nat S] [inst._@.Mathlib.Algebra.Ring.InjSurj.2168556279._hygCtx._hyg.45 : NatCast.{u_2} S] [inst._@.Mathlib.Algebra.Ring.InjSurj.2168556279._hygCtx._hyg.51 : AddMonoidWithOne.{u_1} R], (Eq.{succ u_2} S (f (OfNat.ofNat.{u_1} R 0 (Zero.toOfNat0.{u_1} R (AddZero.toZero.{u_1} R (AddZeroClass.toAddZero.{u_1} R (AddMonoid.toAddZeroClass.{u_1} R (AddMonoidWithOne.toAddMonoid.{u_1} R inst._@.Mathlib.Algebra.Ring.InjSurj.2168556279._hygCtx._hyg.51))))))) (OfNat.ofNat.{u_2} S 0 (Zero.toOfNat0.{u_2} S inst._@.Mathlib.Algebra.Ring.InjSurj.2168556279._hygCtx._hyg.15))) -> (Eq.{succ u_2} S (f (OfNat.ofNat.{u_1} R 1 (One.toOfNat1.{u_1} R (AddMonoidWithOne.toOne.{u_1} R inst._@.Mathlib.Algebra.Ring.InjSurj.2168556279._hygCtx._hyg.51)))) (OfNat.ofNat.{u_2} S 1 (One.toOfNat1.{u_2} S inst._@.Mathlib.Algebra.Ring.InjSurj.2168556279._hygCtx._hyg.18))) -> (forall (x : R) (y : R), Eq.{succ u_2} S (f (HAdd.hAdd.{u_1, u_1, u_1} R R R (instHAdd.{u_1} R (AddSemigroup.toAdd.{u_1} R (AddMonoid.toAddSemigroup.{u_1} R (AddMonoidWithOne.toAddMonoid.{u_1} R inst._@.Mathlib.Algebra.Ring.InjSurj.2168556279._hygCtx._hyg.51)))) x y)) (HAdd.hAdd.{u_2, u_2, u_2} S S S (instHAdd.{u_2} S inst._@.Mathlib.Algebra.Ring.InjSurj.2168556279._hygCtx._hyg.9) (f x) (f y))) -> (forall (n : Nat) (x : R), Eq.{succ u_2} S (f (HSMul.hSMul.{0, u_1, u_1} Nat R R (instHSMul.{0, u_1} Nat R (AddMonoid.toNSMul.{u_1} R (AddMonoidWithOne.toAddMonoid.{u_1} R inst._@.Mathlib.Algebra.Ring.InjSurj.2168556279._hygCtx._hyg.51))) n x)) (HSMul.hSMul.{0, u_2, u_2} Nat S S (instHSMul.{0, u_2} Nat S inst._@.Mathlib.Algebra.Ring.InjSurj.2168556279._hygCtx._hyg.27) n (f x))) -> (forall (n : Nat), Eq.{succ u_2} S (f (Nat.cast.{u_1} R (AddMonoidWithOne.toNatCast.{u_1} R inst._@.Mathlib.Algebra.Ring.InjSurj.2168556279._hygCtx._hyg.51) n)) (Nat.cast.{u_2} S inst._@.Mathlib.Algebra.Ring.InjSurj.2168556279._hygCtx._hyg.45 n)) -> (AddMonoidWithOne.{u_2} S))
-- (definition body omitted)

-- Stub: this file represents the declaration `Function.Surjective.addMonoidWithOne`.
-- In a full split, the body would be extracted from the environment.
