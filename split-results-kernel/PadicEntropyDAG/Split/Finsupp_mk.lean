import Split.Finset
import Split.Membership_mem
import Split.Ne
import Split.Iff
import Split.Finset_instSetLike
import Split.Zero_toOfNat0
import Split.OfNat_ofNat
import Split.SetLike_instMembership
import Split.Finsupp
import Split.Zero

-- Finsupp.mk from environment
-- constructor Finsupp.mk : forall {α : Type.{u_9}} {M : Type.{u_10}} [inst._@.Mathlib.Data.Finsupp.Defs.1123949282._hygCtx._hyg.20 : Zero.{u_10} M] (support : Finset.{u_9} α) (toFun : α -> M), (forall (a : α), Iff (Membership.mem.{u_9, u_9} α (Finset.{u_9} α) (SetLike.instMembership.{u_9, u_9} (Finset.{u_9} α) α (Finset.instSetLike.{u_9} α)) support a) (Ne.{succ u_10} M (toFun a) (OfNat.ofNat.{u_10} M 0 (Zero.toOfNat0.{u_10} M inst._@.Mathlib.Data.Finsupp.Defs.1123949282._hygCtx._hyg.20)))) -> (Finsupp.{u_9, u_10} α M inst._@.Mathlib.Data.Finsupp.Defs.1123949282._hygCtx._hyg.20)

-- Stub: this file represents the declaration `Finsupp.mk`.
-- In a full split, the body would be extracted from the environment.
