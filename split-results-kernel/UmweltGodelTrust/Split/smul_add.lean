import Split.instHSMul
import Split.AddZeroClass_toAddZero
import Split.DistribSMul_toSMulZeroClass
import Split.AddZero_toZero
import Split.instHAdd
import Split.AddZeroClass
import Split.DistribSMul_smul_add
import Split.HAdd_hAdd
import Split.DistribSMul
import Split.AddZero_toAdd
import Split.HSMul_hSMul
import Split.SMulZeroClass_toSMul
import Split.Eq

-- smul_add from environment
-- theorem smul_add : forall {M : Type.{u_1}} {A : Type.{u_7}} [inst._@.Mathlib.Algebra.GroupWithZero.Action.Defs.3291880512._hygCtx._hyg.13 : AddZeroClass.{u_7} A] [inst._@.Mathlib.Algebra.GroupWithZero.Action.Defs.3291880512._hygCtx._hyg.16 : DistribSMul.{u_1, u_7} M A inst._@.Mathlib.Algebra.GroupWithZero.Action.Defs.3291880512._hygCtx._hyg.13] (a : M) (b₁ : A) (b₂ : A), Eq.{succ u_7} A (HSMul.hSMul.{u_1, u_7, u_7} M A A (instHSMul.{u_1, u_7} M A (SMulZeroClass.toSMul.{u_1, u_7} M A (AddZero.toZero.{u_7} A (AddZeroClass.toAddZero.{u_7} A inst._@.Mathlib.Algebra.GroupWithZero.Action.Defs.3291880512._hygCtx._hyg.13)) (DistribSMul.toSMulZeroClass.{u_1, u_7} M A inst._@.Mathlib.Algebra.GroupWithZero.Action.Defs.3291880512._hygCtx._hyg.13 inst._@.Mathlib.Algebra.GroupWithZero.Action.Defs.3291880512._hygCtx._hyg.16))) a (HAdd.hAdd.{u_7, u_7, u_7} A A A (instHAdd.{u_7} A (AddZero.toAdd.{u_7} A (AddZeroClass.toAddZero.{u_7} A inst._@.Mathlib.Algebra.GroupWithZero.Action.Defs.3291880512._hygCtx._hyg.13))) b₁ b₂)) (HAdd.hAdd.{u_7, u_7, u_7} A A A (instHAdd.{u_7} A (AddZero.toAdd.{u_7} A (AddZeroClass.toAddZero.{u_7} A inst._@.Mathlib.Algebra.GroupWithZero.Action.Defs.3291880512._hygCtx._hyg.13))) (HSMul.hSMul.{u_1, u_7, u_7} M A A (instHSMul.{u_1, u_7} M A (SMulZeroClass.toSMul.{u_1, u_7} M A (AddZero.toZero.{u_7} A (AddZeroClass.toAddZero.{u_7} A inst._@.Mathlib.Algebra.GroupWithZero.Action.Defs.3291880512._hygCtx._hyg.13)) (DistribSMul.toSMulZeroClass.{u_1, u_7} M A inst._@.Mathlib.Algebra.GroupWithZero.Action.Defs.3291880512._hygCtx._hyg.13 inst._@.Mathlib.Algebra.GroupWithZero.Action.Defs.3291880512._hygCtx._hyg.16))) a b₁) (HSMul.hSMul.{u_1, u_7, u_7} M A A (instHSMul.{u_1, u_7} M A (SMulZeroClass.toSMul.{u_1, u_7} M A (AddZero.toZero.{u_7} A (AddZeroClass.toAddZero.{u_7} A inst._@.Mathlib.Algebra.GroupWithZero.Action.Defs.3291880512._hygCtx._hyg.13)) (DistribSMul.toSMulZeroClass.{u_1, u_7} M A inst._@.Mathlib.Algebra.GroupWithZero.Action.Defs.3291880512._hygCtx._hyg.13 inst._@.Mathlib.Algebra.GroupWithZero.Action.Defs.3291880512._hygCtx._hyg.16))) a b₂))

-- Stub: this file represents the declaration `smul_add`.
-- In a full split, the body would be extracted from the environment.
