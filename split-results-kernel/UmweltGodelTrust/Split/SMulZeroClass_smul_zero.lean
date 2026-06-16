import Split.instHSMul
import Split.SMulZeroClass
import Split.Zero_toOfNat0
import Split.HSMul_hSMul
import Split.SMulZeroClass_toSMul
import Split.OfNat_ofNat
import Split.Eq
import Split.Zero

-- SMulZeroClass.smul_zero from environment
-- theorem SMulZeroClass.smul_zero : forall {M : Type.{u_12}} {A : Type.{u_13}} {inst._@.Mathlib.Algebra.GroupWithZero.Action.Defs.3448871560._hygCtx._hyg.26 : Zero.{u_13} A} [self : SMulZeroClass.{u_12, u_13} M A inst._@.Mathlib.Algebra.GroupWithZero.Action.Defs.3448871560._hygCtx._hyg.26] (a : M), Eq.{succ u_13} A (HSMul.hSMul.{u_12, u_13, u_13} M A A (instHSMul.{u_12, u_13} M A (SMulZeroClass.toSMul.{u_12, u_13} M A inst._@.Mathlib.Algebra.GroupWithZero.Action.Defs.3448871560._hygCtx._hyg.26 self)) a (OfNat.ofNat.{u_13} A 0 (Zero.toOfNat0.{u_13} A inst._@.Mathlib.Algebra.GroupWithZero.Action.Defs.3448871560._hygCtx._hyg.26))) (OfNat.ofNat.{u_13} A 0 (Zero.toOfNat0.{u_13} A inst._@.Mathlib.Algebra.GroupWithZero.Action.Defs.3448871560._hygCtx._hyg.26))

-- Stub: this file represents the declaration `SMulZeroClass.smul_zero`.
-- In a full split, the body would be extracted from the environment.
