import Mathlib

set_option pp.all true
-- spec: Lean.MonadCacheT : forall {ω : Type} (α : Type), Type -> (forall (m : Type -> Type) [inst._@.Lean.Util.MonadCache.2425016109._hygCtx._hyg.8 : STWorld ω m] [inst._@.Lean.Util.MonadCache.2425016109._hygCtx._hyg.12 : BEq.{0} α] [inst._@.Lean.Util.MonadCache.2425016109._hygCtx._hyg.15 : Hashable.{1} α], Type -> Type)
def Lean.MonadCacheT : forall {ω : Type} (α : Type), Type -> (forall (m : Type -> Type) [inst._@.Lean.Util.MonadCache.2425016109._hygCtx._hyg.8 : STWorld ω m] [inst._@.Lean.Util.MonadCache.2425016109._hygCtx._hyg.12 : BEq.{0} α] [inst._@.Lean.Util.MonadCache.2425016109._hygCtx._hyg.15 : Hashable.{1} α], Type -> Type) :=
  fun {ω : Type} (α : Type) (β : Type) (m : Type -> Type) [inst._@.Lean.Util.MonadCache.2425016109._hygCtx._hyg.8 : STWorld ω m] [inst._@.Lean.Util.MonadCache.2425016109._hygCtx._hyg.12 : BEq.{0} α] [inst._@.Lean.Util.MonadCache.2425016109._hygCtx._hyg.15 : Hashable.{1} α] => StateRefT' ω (Std.HashMap.{0, 0} α β inst._@.Lean.Util.MonadCache.2425016109._hygCtx._hyg.12 inst._@.Lean.Util.MonadCache.2425016109._hygCtx._hyg.15) m
