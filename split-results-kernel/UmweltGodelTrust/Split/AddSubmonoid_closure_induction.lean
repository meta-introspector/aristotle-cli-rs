import Split.Iff_mpr
import Split.AddSubmonoidClass_toAddMemClass
import Split.AddSubmonoid_instAddSubmonoidClass
import Split.PartialOrder_toPreorder
import Split.setOf
import Split.Preorder_toLE
import Split.AddSubmonoid_subset_closure
import Split.Membership_mem
import Split.Exists
import Split.AddZeroClass_toAddZero
import Split.id
import Split.AddSubmonoid
import Split.HasSubset_Subset
import Split.LE_le
import Split.AddSubmonoid_mk
import Split.AddSubsemigroup_mk
import Split.AddZero_toZero
import Split.instHAdd
import Split.AddZeroClass
import Split.SetLike_coe
import Split.HAdd_hAdd
import Split.AddSubmonoid_closure
import Split.AddSubmonoid_closure_le
import Split.Exists_intro
import Split.AddMemClass_add_mem
import Split.AddZero_toAdd
import Split.Zero_toOfNat0
import Split.ZeroMemClass_zero_mem
import Split.OfNat_ofNat
import Split.AddSubmonoid_instSetLike
import Split.Set_instMembership
import Split.SetLike_instMembership
import Split.AddSubmonoid_instPartialOrder
import Split.Exists_elim
import Split.AddSubmonoidClass_toZeroMemClass
import Split.Set_instHasSubset
import Split.Set

-- AddSubmonoid.closure_induction from environment
-- theorem AddSubmonoid.closure_induction : forall {M : Type.{u_1}} [inst._@.Mathlib.Algebra.Group.Submonoid.Basic.540624867._hygCtx._hyg.5 : AddZeroClass.{u_1} M] {s : Set.{u_1} M} {motive : forall (x : M), (Membership.mem.{u_1, u_1} M (AddSubmonoid.{u_1} M inst._@.Mathlib.Algebra.Group.Submonoid.Basic.540624867._hygCtx._hyg.5) (SetLike.instMembership.{u_1, u_1} (AddSubmonoid.{u_1} M inst._@.Mathlib.Algebra.Group.Submonoid.Basic.540624867._hygCtx._hyg.5) M (AddSubmonoid.instSetLike.{u_1} M inst._@.Mathlib.Algebra.Group.Submonoid.Basic.540624867._hygCtx._hyg.5)) (AddSubmonoid.closure.{u_1} M inst._@.Mathlib.Algebra.Group.Submonoid.Basic.540624867._hygCtx._hyg.5 s) x) -> Prop}, (forall (x : M) (h : Membership.mem.{u_1, u_1} M (Set.{u_1} M) (Set.instMembership.{u_1} M) s x), motive x (AddSubmonoid.subset_closure.{u_1} M inst._@.Mathlib.Algebra.Group.Submonoid.Basic.540624867._hygCtx._hyg.5 s x h)) -> (motive (OfNat.ofNat.{u_1} M 0 (Zero.toOfNat0.{u_1} M (AddZero.toZero.{u_1} M (AddZeroClass.toAddZero.{u_1} M inst._@.Mathlib.Algebra.Group.Submonoid.Basic.540624867._hygCtx._hyg.5)))) (ZeroMemClass.zero_mem.{u_1, u_1} (AddSubmonoid.{u_1} M inst._@.Mathlib.Algebra.Group.Submonoid.Basic.540624867._hygCtx._hyg.5) M (AddZero.toZero.{u_1} M (AddZeroClass.toAddZero.{u_1} M inst._@.Mathlib.Algebra.Group.Submonoid.Basic.540624867._hygCtx._hyg.5)) (AddSubmonoid.instSetLike.{u_1} M inst._@.Mathlib.Algebra.Group.Submonoid.Basic.540624867._hygCtx._hyg.5) (AddSubmonoidClass.toZeroMemClass.{u_1, u_1} (AddSubmonoid.{u_1} M inst._@.Mathlib.Algebra.Group.Submonoid.Basic.540624867._hygCtx._hyg.5) M inst._@.Mathlib.Algebra.Group.Submonoid.Basic.540624867._hygCtx._hyg.5 (AddSubmonoid.instSetLike.{u_1} M inst._@.Mathlib.Algebra.Group.Submonoid.Basic.540624867._hygCtx._hyg.5) (AddSubmonoid.instAddSubmonoidClass.{u_1} M inst._@.Mathlib.Algebra.Group.Submonoid.Basic.540624867._hygCtx._hyg.5)) (AddSubmonoid.closure.{u_1} M inst._@.Mathlib.Algebra.Group.Submonoid.Basic.540624867._hygCtx._hyg.5 s))) -> (forall (x : M) (y : M) (hx : Membership.mem.{u_1, u_1} M (AddSubmonoid.{u_1} M inst._@.Mathlib.Algebra.Group.Submonoid.Basic.540624867._hygCtx._hyg.5) (SetLike.instMembership.{u_1, u_1} (AddSubmonoid.{u_1} M inst._@.Mathlib.Algebra.Group.Submonoid.Basic.540624867._hygCtx._hyg.5) M (AddSubmonoid.instSetLike.{u_1} M inst._@.Mathlib.Algebra.Group.Submonoid.Basic.540624867._hygCtx._hyg.5)) (AddSubmonoid.closure.{u_1} M inst._@.Mathlib.Algebra.Group.Submonoid.Basic.540624867._hygCtx._hyg.5 s) x) (hy : Membership.mem.{u_1, u_1} M (AddSubmonoid.{u_1} M inst._@.Mathlib.Algebra.Group.Submonoid.Basic.540624867._hygCtx._hyg.5) (SetLike.instMembership.{u_1, u_1} (AddSubmonoid.{u_1} M inst._@.Mathlib.Algebra.Group.Submonoid.Basic.540624867._hygCtx._hyg.5) M (AddSubmonoid.instSetLike.{u_1} M inst._@.Mathlib.Algebra.Group.Submonoid.Basic.540624867._hygCtx._hyg.5)) (AddSubmonoid.closure.{u_1} M inst._@.Mathlib.Algebra.Group.Submonoid.Basic.540624867._hygCtx._hyg.5 s) y), (motive x hx) -> (motive y hy) -> (motive (HAdd.hAdd.{u_1, u_1, u_1} M M M (instHAdd.{u_1} M (AddZero.toAdd.{u_1} M (AddZeroClass.toAddZero.{u_1} M inst._@.Mathlib.Algebra.Group.Submonoid.Basic.540624867._hygCtx._hyg.5))) x y) (AddMemClass.add_mem.{u_1, u_1} (AddSubmonoid.{u_1} M inst._@.Mathlib.Algebra.Group.Submonoid.Basic.540624867._hygCtx._hyg.5) M (AddZero.toAdd.{u_1} M (AddZeroClass.toAddZero.{u_1} M inst._@.Mathlib.Algebra.Group.Submonoid.Basic.540624867._hygCtx._hyg.5)) (AddSubmonoid.instSetLike.{u_1} M inst._@.Mathlib.Algebra.Group.Submonoid.Basic.540624867._hygCtx._hyg.5) (AddSubmonoidClass.toAddMemClass.{u_1, u_1} (AddSubmonoid.{u_1} M inst._@.Mathlib.Algebra.Group.Submonoid.Basic.540624867._hygCtx._hyg.5) M inst._@.Mathlib.Algebra.Group.Submonoid.Basic.540624867._hygCtx._hyg.5 (AddSubmonoid.instSetLike.{u_1} M inst._@.Mathlib.Algebra.Group.Submonoid.Basic.540624867._hygCtx._hyg.5) (AddSubmonoid.instAddSubmonoidClass.{u_1} M inst._@.Mathlib.Algebra.Group.Submonoid.Basic.540624867._hygCtx._hyg.5)) (AddSubmonoid.closure.{u_1} M inst._@.Mathlib.Algebra.Group.Submonoid.Basic.540624867._hygCtx._hyg.5 s) x y hx hy))) -> (forall {x : M} (hx : Membership.mem.{u_1, u_1} M (AddSubmonoid.{u_1} M inst._@.Mathlib.Algebra.Group.Submonoid.Basic.540624867._hygCtx._hyg.5) (SetLike.instMembership.{u_1, u_1} (AddSubmonoid.{u_1} M inst._@.Mathlib.Algebra.Group.Submonoid.Basic.540624867._hygCtx._hyg.5) M (AddSubmonoid.instSetLike.{u_1} M inst._@.Mathlib.Algebra.Group.Submonoid.Basic.540624867._hygCtx._hyg.5)) (AddSubmonoid.closure.{u_1} M inst._@.Mathlib.Algebra.Group.Submonoid.Basic.540624867._hygCtx._hyg.5 s) x), motive x hx)

-- Stub: this file represents the declaration `AddSubmonoid.closure_induction`.
-- In a full split, the body would be extracted from the environment.
