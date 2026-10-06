import Mathlib

set_option pp.all true
-- spec: Std.Iterators.PostconditionT.pure : forall {m : Type.{w} -> Type.{w'}} [inst._@.Init.Data.Iterators.PostconditionMonad.3537041524._hygCtx._hyg.5 : Pure.{w, w'} m] {α : Type.{w}}, α -> (Std.Iterators.PostconditionT.{w, w'} m α)
def Std.Iterators.PostconditionT.pure : forall {m : Type.{w} -> Type.{w'}} [inst._@.Init.Data.Iterators.PostconditionMonad.3537041524._hygCtx._hyg.5 : Pure.{w, w'} m] {α : Type.{w}}, α -> (Std.Iterators.PostconditionT.{w, w'} m α) :=
  fun {m : Type.{w} -> Type.{w'}} [inst._@.Init.Data.Iterators.PostconditionMonad.3537041524._hygCtx._hyg.5 : Pure.{w, w'} m] {α : Type.{w}} (a : α) => Std.Iterators.PostconditionT.mk.{w, w'} m α (fun (y : α) => Eq.{succ w} α a y) (Pure.pure.{w, w'} m inst._@.Init.Data.Iterators.PostconditionMonad.3537041524._hygCtx._hyg.5 (Subtype.{succ w} α (fun (y : α) => Eq.{succ w} α a y)) (Subtype.mk.{succ w} α (fun (y : α) => Eq.{succ w} α a y) a (rfl.{succ w} α a)))
