import Mathlib

set_option pp.all true
-- spec: Std.PRange.UpwardEnumerable.LT : forall {α : Type.{u}} [inst._@.Init.Data.Range.Polymorphic.UpwardEnumerable.1798787095._hygCtx._hyg.3 : Std.PRange.UpwardEnumerable.{u} α], α -> α -> Prop
def Std.PRange.UpwardEnumerable.LT : forall {α : Type.{u}} [inst._@.Init.Data.Range.Polymorphic.UpwardEnumerable.1798787095._hygCtx._hyg.3 : Std.PRange.UpwardEnumerable.{u} α], α -> α -> Prop :=
  fun {α : Type.{u}} [inst._@.Init.Data.Range.Polymorphic.UpwardEnumerable.1798787095._hygCtx._hyg.3 : Std.PRange.UpwardEnumerable.{u} α] (a : α) (b : α) => Exists.{1} Nat (fun (n : Nat) => Eq.{succ u} (Option.{u} α) (Std.PRange.UpwardEnumerable.succMany?.{u} α inst._@.Init.Data.Range.Polymorphic.UpwardEnumerable.1798787095._hygCtx._hyg.3 (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) n (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))) a) (Option.some.{u} α b))
