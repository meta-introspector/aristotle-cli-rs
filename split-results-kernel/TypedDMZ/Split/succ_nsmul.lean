import Split.instHSMul
import Split.AddMonoid_toAddZeroClass
import Split.AddMonoid_toNSMul
import Split.AddZeroClass_toAddZero
import Split.instOfNatNat
import Split.instHAdd
import Split.HAdd_hAdd
import Split.AddMonoid_nsmul_succ
import Split.Nat
import Split.AddMonoid
import Split.instAddNat
import Split.AddZero_toAdd
import Split.HSMul_hSMul
import Split.OfNat_ofNat
import Split.Eq

-- succ_nsmul from environment
-- theorem succ_nsmul : forall {M : Type.{u_2}} [inst._@.Mathlib.Algebra.Group.Defs.2508248740._hygCtx._hyg.4 : AddMonoid.{u_2} M] (a : M) (n : Nat), Eq.{succ u_2} M (HSMul.hSMul.{0, u_2, u_2} Nat M M (instHSMul.{0, u_2} Nat M (AddMonoid.toNSMul.{u_2} M inst._@.Mathlib.Algebra.Group.Defs.2508248740._hygCtx._hyg.4)) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) n (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))) a) (HAdd.hAdd.{u_2, u_2, u_2} M M M (instHAdd.{u_2} M (AddZero.toAdd.{u_2} M (AddZeroClass.toAddZero.{u_2} M (AddMonoid.toAddZeroClass.{u_2} M inst._@.Mathlib.Algebra.Group.Defs.2508248740._hygCtx._hyg.4)))) (HSMul.hSMul.{0, u_2, u_2} Nat M M (instHSMul.{0, u_2} Nat M (AddMonoid.toNSMul.{u_2} M inst._@.Mathlib.Algebra.Group.Defs.2508248740._hygCtx._hyg.4)) n a) a)

-- Stub: this file represents the declaration `succ_nsmul`.
-- In a full split, the body would be extracted from the environment.
