import Split.instHSMul
import Split.AddMonoid_toAddZeroClass
import Split.AddMonoid_toNSMul
import Split.AddMonoid_nsmul_zero
import Split.AddZeroClass_toAddZero
import Split.instOfNatNat
import Split.AddZero_toZero
import Split.Nat
import Split.AddMonoid
import Split.Zero_toOfNat0
import Split.HSMul_hSMul
import Split.OfNat_ofNat
import Split.Eq

-- zero_nsmul from environment
-- theorem zero_nsmul : forall {M : Type.{u_2}} [inst._@.Mathlib.Algebra.Group.Defs.3472475958._hygCtx._hyg.4 : AddMonoid.{u_2} M] (a : M), Eq.{succ u_2} M (HSMul.hSMul.{0, u_2, u_2} Nat M M (instHSMul.{0, u_2} Nat M (AddMonoid.toNSMul.{u_2} M inst._@.Mathlib.Algebra.Group.Defs.3472475958._hygCtx._hyg.4)) (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) a) (OfNat.ofNat.{u_2} M 0 (Zero.toOfNat0.{u_2} M (AddZero.toZero.{u_2} M (AddZeroClass.toAddZero.{u_2} M (AddMonoid.toAddZeroClass.{u_2} M inst._@.Mathlib.Algebra.Group.Defs.3472475958._hygCtx._hyg.4)))))

-- Stub: this file represents the declaration `zero_nsmul`.
-- In a full split, the body would be extracted from the environment.
