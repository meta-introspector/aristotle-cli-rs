import Split.instHSMul
import Split.AddZeroClass_toAddZero
import Split.DistribSMul_toSMulZeroClass
import Split.AddZero_toZero
import Split.instHAdd
import Split.AddZeroClass
import Split.HAdd_hAdd
import Split.DistribSMul
import Split.AddZero_toAdd
import Split.HSMul_hSMul
import Split.SMulZeroClass_toSMul
import Split.Eq

-- DistribSMul.smul_add from environment
-- theorem DistribSMul.smul_add : forall {M : Type.{u_12}} {A : Type.{u_13}} {inst._@.Mathlib.Algebra.GroupWithZero.Action.Defs.4022976298._hygCtx._hyg.26 : AddZeroClass.{u_13} A} [self : DistribSMul.{u_12, u_13} M A inst._@.Mathlib.Algebra.GroupWithZero.Action.Defs.4022976298._hygCtx._hyg.26] (a : M) (x : A) (y : A), Eq.{succ u_13} A (HSMul.hSMul.{u_12, u_13, u_13} M A A (instHSMul.{u_12, u_13} M A (SMulZeroClass.toSMul.{u_12, u_13} M A (AddZero.toZero.{u_13} A (AddZeroClass.toAddZero.{u_13} A inst._@.Mathlib.Algebra.GroupWithZero.Action.Defs.4022976298._hygCtx._hyg.26)) (DistribSMul.toSMulZeroClass.{u_12, u_13} M A inst._@.Mathlib.Algebra.GroupWithZero.Action.Defs.4022976298._hygCtx._hyg.26 self))) a (HAdd.hAdd.{u_13, u_13, u_13} A A A (instHAdd.{u_13} A (AddZero.toAdd.{u_13} A (AddZeroClass.toAddZero.{u_13} A inst._@.Mathlib.Algebra.GroupWithZero.Action.Defs.4022976298._hygCtx._hyg.26))) x y)) (HAdd.hAdd.{u_13, u_13, u_13} A A A (instHAdd.{u_13} A (AddZero.toAdd.{u_13} A (AddZeroClass.toAddZero.{u_13} A inst._@.Mathlib.Algebra.GroupWithZero.Action.Defs.4022976298._hygCtx._hyg.26))) (HSMul.hSMul.{u_12, u_13, u_13} M A A (instHSMul.{u_12, u_13} M A (SMulZeroClass.toSMul.{u_12, u_13} M A (AddZero.toZero.{u_13} A (AddZeroClass.toAddZero.{u_13} A inst._@.Mathlib.Algebra.GroupWithZero.Action.Defs.4022976298._hygCtx._hyg.26)) (DistribSMul.toSMulZeroClass.{u_12, u_13} M A inst._@.Mathlib.Algebra.GroupWithZero.Action.Defs.4022976298._hygCtx._hyg.26 self))) a x) (HSMul.hSMul.{u_12, u_13, u_13} M A A (instHSMul.{u_12, u_13} M A (SMulZeroClass.toSMul.{u_12, u_13} M A (AddZero.toZero.{u_13} A (AddZeroClass.toAddZero.{u_13} A inst._@.Mathlib.Algebra.GroupWithZero.Action.Defs.4022976298._hygCtx._hyg.26)) (DistribSMul.toSMulZeroClass.{u_12, u_13} M A inst._@.Mathlib.Algebra.GroupWithZero.Action.Defs.4022976298._hygCtx._hyg.26 self))) a y))

-- Stub: this file represents the declaration `DistribSMul.smul_add`.
-- In a full split, the body would be extracted from the environment.
