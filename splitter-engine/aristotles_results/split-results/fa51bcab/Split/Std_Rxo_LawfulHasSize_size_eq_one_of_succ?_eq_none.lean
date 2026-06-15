import Split.Std_PRange_UpwardEnumerable
import Split.Std_Rxo_LawfulHasSize
import Split.instOfNatNat
import Split.Std_PRange_UpwardEnumerable_succ?
import Split.Option_none
import Split.Nat
import Split.LT_lt
import Split.Std_Rxo_HasSize
import Split.OfNat_ofNat
import Split.Std_Rxo_HasSize_size
import Split.Eq
import Split.LT
import Split.Option

-- Std.Rxo.LawfulHasSize.size_eq_one_of_succ?_eq_none from environment
-- theorem Std.Rxo.LawfulHasSize.size_eq_one_of_succ?_eq_none : forall {α : Type.{u}} {inst._@.Init.Data.Range.Polymorphic.Basic.1963379685._hygCtx._hyg.11 : LT.{u} α} {inst._@.Init.Data.Range.Polymorphic.Basic.1963379685._hygCtx._hyg.14 : Std.PRange.UpwardEnumerable.{u} α} {inst._@.Init.Data.Range.Polymorphic.Basic.1963379685._hygCtx._hyg.17 : Std.Rxo.HasSize.{u} α} [self : Std.Rxo.LawfulHasSize.{u} α inst._@.Init.Data.Range.Polymorphic.Basic.1963379685._hygCtx._hyg.11 inst._@.Init.Data.Range.Polymorphic.Basic.1963379685._hygCtx._hyg.14 inst._@.Init.Data.Range.Polymorphic.Basic.1963379685._hygCtx._hyg.17] (lo : α) (hi : α), (LT.lt.{u} α inst._@.Init.Data.Range.Polymorphic.Basic.1963379685._hygCtx._hyg.11 lo hi) -> (Eq.{succ u} (Option.{u} α) (Std.PRange.UpwardEnumerable.succ?.{u} α inst._@.Init.Data.Range.Polymorphic.Basic.1963379685._hygCtx._hyg.14 lo) (Option.none.{u} α)) -> (Eq.{1} Nat (Std.Rxo.HasSize.size.{u} α inst._@.Init.Data.Range.Polymorphic.Basic.1963379685._hygCtx._hyg.17 lo hi) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)))

-- Stub: this file represents the declaration `Std.Rxo.LawfulHasSize.size_eq_one_of_succ?_eq_none`.
-- In a full split, the body would be extracted from the environment.
