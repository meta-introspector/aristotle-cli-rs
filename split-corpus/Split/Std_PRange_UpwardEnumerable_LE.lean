import Mathlib

set_option pp.all true
-- spec: Std.PRange.UpwardEnumerable.LE : forall {α : Type.{u}} [inst._@.Init.Data.Range.Polymorphic.UpwardEnumerable.170131061._hygCtx._hyg.3 : Std.PRange.UpwardEnumerable.{u} α], α -> α -> Prop
def Std.PRange.UpwardEnumerable.LE : forall {α : Type.{u}} [inst._@.Init.Data.Range.Polymorphic.UpwardEnumerable.170131061._hygCtx._hyg.3 : Std.PRange.UpwardEnumerable.{u} α], α -> α -> Prop :=
  fun {α : Type.{u}} [inst._@.Init.Data.Range.Polymorphic.UpwardEnumerable.170131061._hygCtx._hyg.3 : Std.PRange.UpwardEnumerable.{u} α] (a : α) (b : α) => Exists.{1} Nat (fun (n : Nat) => Eq.{succ u} (Option.{u} α) (Std.PRange.UpwardEnumerable.succMany?.{u} α inst._@.Init.Data.Range.Polymorphic.UpwardEnumerable.170131061._hygCtx._hyg.3 n a) (Option.some.{u} α b))
