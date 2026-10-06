import Mathlib

set_option pp.all true
-- spec: Std.Rxo.HasSize.ofClosed : forall {α : Type.{u_1}} [inst._@.Init.Data.Range.Polymorphic.Instances.1006423556._hygCtx._hyg.5 : Std.Rxc.HasSize.{u_1} α], Std.Rxo.HasSize.{u_1} α
def Std.Rxo.HasSize.ofClosed : forall {α : Type.{u_1}} [inst._@.Init.Data.Range.Polymorphic.Instances.1006423556._hygCtx._hyg.5 : Std.Rxc.HasSize.{u_1} α], Std.Rxo.HasSize.{u_1} α :=
  fun {α : Type.{u_1}} [inst._@.Init.Data.Range.Polymorphic.Instances.1006423556._hygCtx._hyg.5 : Std.Rxc.HasSize.{u_1} α] => Std.Rxo.HasSize.mk.{u_1} α (fun (lo : α) (hi : α) => HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) (Std.Rxc.HasSize.size.{u_1} α inst._@.Init.Data.Range.Polymorphic.Instances.1006423556._hygCtx._hyg.5 lo hi) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)))
