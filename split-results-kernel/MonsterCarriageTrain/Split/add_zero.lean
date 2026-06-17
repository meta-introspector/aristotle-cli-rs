import Split.AddZeroClass_toAddZero
import Split.AddZero_toZero
import Split.instHAdd
import Split.AddZeroClass
import Split.HAdd_hAdd
import Split.AddZeroClass_add_zero
import Split.AddZero_toAdd
import Split.Zero_toOfNat0
import Split.OfNat_ofNat
import Split.Eq

-- add_zero from environment
-- theorem add_zero : forall {M : Type.{u}} [inst._@.Mathlib.Algebra.Group.Defs.1575903989._hygCtx._hyg.4 : AddZeroClass.{u} M] (a : M), Eq.{succ u} M (HAdd.hAdd.{u, u, u} M M M (instHAdd.{u} M (AddZero.toAdd.{u} M (AddZeroClass.toAddZero.{u} M inst._@.Mathlib.Algebra.Group.Defs.1575903989._hygCtx._hyg.4))) a (OfNat.ofNat.{u} M 0 (Zero.toOfNat0.{u} M (AddZero.toZero.{u} M (AddZeroClass.toAddZero.{u} M inst._@.Mathlib.Algebra.Group.Defs.1575903989._hygCtx._hyg.4))))) a

-- Stub: this file represents the declaration `add_zero`.
-- In a full split, the body would be extracted from the environment.
