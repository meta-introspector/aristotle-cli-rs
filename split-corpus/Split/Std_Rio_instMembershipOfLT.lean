import Mathlib

set_option pp.all true
-- spec: Std.Rio.instMembershipOfLT : forall {α : Type.{u}} [inst._@.Init.Data.Range.Polymorphic.PRange.2630667941._hygCtx._hyg.6 : LT.{u} α], Membership.{u, u} α (Std.Rio.{u} α)
def Std.Rio.instMembershipOfLT : forall {α : Type.{u}} [inst._@.Init.Data.Range.Polymorphic.PRange.2630667941._hygCtx._hyg.6 : LT.{u} α], Membership.{u, u} α (Std.Rio.{u} α) :=
  fun {α : Type.{u}} [inst._@.Init.Data.Range.Polymorphic.PRange.2630667941._hygCtx._hyg.6 : LT.{u} α] => Membership.mk.{u, u} α (Std.Rio.{u} α) (fun (r : Std.Rio.{u} α) (a : α) => LT.lt.{u} α inst._@.Init.Data.Range.Polymorphic.PRange.2630667941._hygCtx._hyg.6 a (Std.Rio.upper.{u} α r))
