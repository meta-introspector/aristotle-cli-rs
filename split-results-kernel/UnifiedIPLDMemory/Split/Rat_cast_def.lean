import Split.Int_cast
import Split.Rat_num
import Split.instHDiv
import Split.DivisionRing_toRatCast
import Split.Rat
import Split.AddGroupWithOne_toAddMonoidWithOne
import Split.Rat_den
import Split.DivisionRing_toDivInvMonoid
import Split.HDiv_hDiv
import Split.Rat_cast
import Split.AddMonoidWithOne_toNatCast
import Split.DivisionRing_toRing
import Split.AddGroupWithOne_toIntCast
import Split.Nat_cast
import Split.DivisionRing_ratCast_def
import Split.DivInvMonoid_toDiv
import Split.DivisionRing
import Split.Eq
import Split.Ring_toAddGroupWithOne

-- Rat.cast_def from environment
-- theorem Rat.cast_def : forall {K : Type.{u_1}} [inst._@.Mathlib.Algebra.Field.Defs.1858161881._hygCtx._hyg.3 : DivisionRing.{u_1} K] (q : Rat), Eq.{succ u_1} K (Rat.cast.{u_1} K (DivisionRing.toRatCast.{u_1} K inst._@.Mathlib.Algebra.Field.Defs.1858161881._hygCtx._hyg.3) q) (HDiv.hDiv.{u_1, u_1, u_1} K K K (instHDiv.{u_1} K (DivInvMonoid.toDiv.{u_1} K (DivisionRing.toDivInvMonoid.{u_1} K inst._@.Mathlib.Algebra.Field.Defs.1858161881._hygCtx._hyg.3))) (Int.cast.{u_1} K (AddGroupWithOne.toIntCast.{u_1} K (Ring.toAddGroupWithOne.{u_1} K (DivisionRing.toRing.{u_1} K inst._@.Mathlib.Algebra.Field.Defs.1858161881._hygCtx._hyg.3))) (Rat.num q)) (Nat.cast.{u_1} K (AddMonoidWithOne.toNatCast.{u_1} K (AddGroupWithOne.toAddMonoidWithOne.{u_1} K (Ring.toAddGroupWithOne.{u_1} K (DivisionRing.toRing.{u_1} K inst._@.Mathlib.Algebra.Field.Defs.1858161881._hygCtx._hyg.3)))) (Rat.den q)))

-- Stub: this file represents the declaration `Rat.cast_def`.
-- In a full split, the body would be extracted from the environment.
