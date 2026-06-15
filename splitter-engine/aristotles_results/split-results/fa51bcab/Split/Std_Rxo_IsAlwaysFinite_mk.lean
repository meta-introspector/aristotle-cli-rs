import Split.Std_PRange_UpwardEnumerable
import Split.Exists
import Split.Std_Rxo_IsAlwaysFinite
import Split.Std_PRange_UpwardEnumerable_succMany?
import Split.Nat
import Split.LT_lt
import Split.True
import Split.Option_elim
import Split.Not
import Split.LT

-- Std.Rxo.IsAlwaysFinite.mk from environment
-- constructor Std.Rxo.IsAlwaysFinite.mk : forall {α : Type.{u}} [inst._@.Init.Data.Range.Polymorphic.PRange.365382383._hygCtx._hyg.3 : Std.PRange.UpwardEnumerable.{u} α] [inst._@.Init.Data.Range.Polymorphic.PRange.365382383._hygCtx._hyg.6 : LT.{u} α], (forall (init : α) (hi : α), Exists.{1} Nat (fun (n : Nat) => Option.elim.{u, 1} α Prop (Std.PRange.UpwardEnumerable.succMany?.{u} α inst._@.Init.Data.Range.Polymorphic.PRange.365382383._hygCtx._hyg.3 n init) True (fun (x._@.Init.Data.Range.Polymorphic.PRange.365382383._hygCtx._hyg.27 : α) => Not (LT.lt.{u} α inst._@.Init.Data.Range.Polymorphic.PRange.365382383._hygCtx._hyg.6 x._@.Init.Data.Range.Polymorphic.PRange.365382383._hygCtx._hyg.27 hi)))) -> (Std.Rxo.IsAlwaysFinite.{u} α inst._@.Init.Data.Range.Polymorphic.PRange.365382383._hygCtx._hyg.3 inst._@.Init.Data.Range.Polymorphic.PRange.365382383._hygCtx._hyg.6)

-- Stub: this file represents the declaration `Std.Rxo.IsAlwaysFinite.mk`.
-- In a full split, the body would be extracted from the environment.
