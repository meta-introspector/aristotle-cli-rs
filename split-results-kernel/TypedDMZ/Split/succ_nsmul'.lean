import Split.Eq_mpr
import Split.instHSMul
import Split.AddMonoid_toAddSemigroup
import Split.congrArg
import Split.add_assoc
import Split.AddMonoid_toAddZeroClass
import Split.AddMonoid_toNSMul
import Split.AddZeroClass_toAddZero
import Split.Nat_brecOn
import Split.id
import Split.instOfNatNat
import Split.Nat_below
import Split.AddZero_toZero
import Split.instHAdd
import Split.AddSemigroup_toAdd
import Split.Unit
import Split.zero_nsmul
import Split.HAdd_hAdd
import Split.Nat
import Split.congr
import Split.True
import Split.eq_self
import Split.AddMonoid
import Split.of_eq_true
import Split.instAddNat
import Split.AddZero_toAdd
import Split.Zero_toOfNat0
import Split.Eq_refl
import Split.HSMul_hSMul
import Split.Nat_zero_add
import Split.add_zero
import Split.OfNat_ofNat
import Split.Nat_succ
import Split.Eq
import Split.one_nsmul
import Split.Eq_trans
import Split.succ_nsmul

-- succ_nsmul' from environment
-- theorem succ_nsmul' : forall {M : Type.{u_2}} [inst._@.Mathlib.Algebra.Group.Defs.3353052494._hygCtx._hyg.4 : AddMonoid.{u_2} M] (a : M) (n : Nat), Eq.{succ u_2} M (HSMul.hSMul.{0, u_2, u_2} Nat M M (instHSMul.{0, u_2} Nat M (AddMonoid.toNSMul.{u_2} M inst._@.Mathlib.Algebra.Group.Defs.3353052494._hygCtx._hyg.4)) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) n (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))) a) (HAdd.hAdd.{u_2, u_2, u_2} M M M (instHAdd.{u_2} M (AddZero.toAdd.{u_2} M (AddZeroClass.toAddZero.{u_2} M (AddMonoid.toAddZeroClass.{u_2} M inst._@.Mathlib.Algebra.Group.Defs.3353052494._hygCtx._hyg.4)))) a (HSMul.hSMul.{0, u_2, u_2} Nat M M (instHSMul.{0, u_2} Nat M (AddMonoid.toNSMul.{u_2} M inst._@.Mathlib.Algebra.Group.Defs.3353052494._hygCtx._hyg.4)) n a))

-- Stub: this file represents the declaration `succ_nsmul'`.
-- In a full split, the body would be extracted from the environment.
