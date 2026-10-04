import Mathlib

set_option pp.all true
-- spec: Std.Rio.Internal.iter : forall {α : Type.{u}} [inst._@.Init.Data.Range.Polymorphic.Iterators.2119510816._hygCtx._hyg.3 : Std.PRange.UpwardEnumerable.{u} α] [inst._@.Init.Data.Range.Polymorphic.Iterators.2119510816._hygCtx._hyg.6 : Std.PRange.Least?.{u} α], (Std.Rio.{u} α) -> (Std.Iter.{u} (Std.Rxo.Iterator.{u} α) α)
def Std.Rio.Internal.iter : forall {α : Type.{u}} [inst._@.Init.Data.Range.Polymorphic.Iterators.2119510816._hygCtx._hyg.3 : Std.PRange.UpwardEnumerable.{u} α] [inst._@.Init.Data.Range.Polymorphic.Iterators.2119510816._hygCtx._hyg.6 : Std.PRange.Least?.{u} α], (Std.Rio.{u} α) -> (Std.Iter.{u} (Std.Rxo.Iterator.{u} α) α) :=
  fun {α : Type.{u}} [inst._@.Init.Data.Range.Polymorphic.Iterators.2119510816._hygCtx._hyg.3 : Std.PRange.UpwardEnumerable.{u} α] [inst._@.Init.Data.Range.Polymorphic.Iterators.2119510816._hygCtx._hyg.6 : Std.PRange.Least?.{u} α] (r : Std.Rio.{u} α) => Std.Iter.mk.{u} (Std.Rxo.Iterator.{u} α) α (Std.Rxo.Iterator.mk.{u} α (Std.PRange.Least?.least?.{u} α inst._@.Init.Data.Range.Polymorphic.Iterators.2119510816._hygCtx._hyg.6) (Std.Rio.upper.{u} α r))
