import Split.Std_PRange_UpwardEnumerable
import Split.Std_Rxo_LawfulHasSize
import Split.instOfNatNat
import Split.Nat
import Split.LT_lt
import Split.Std_Rxo_HasSize
import Split.OfNat_ofNat
import Split.Std_Rxo_HasSize_size
import Split.Eq
import Split.Not
import Split.LT

-- Std.Rxo.LawfulHasSize.size_eq_zero_of_not_le from environment
-- theorem Std.Rxo.LawfulHasSize.size_eq_zero_of_not_le : forall {α : Type.{u}} {inst._@.Init.Data.Range.Polymorphic.Basic.1963379685._hygCtx._hyg.11 : LT.{u} α} {inst._@.Init.Data.Range.Polymorphic.Basic.1963379685._hygCtx._hyg.14 : Std.PRange.UpwardEnumerable.{u} α} {inst._@.Init.Data.Range.Polymorphic.Basic.1963379685._hygCtx._hyg.17 : Std.Rxo.HasSize.{u} α} [self : Std.Rxo.LawfulHasSize.{u} α inst._@.Init.Data.Range.Polymorphic.Basic.1963379685._hygCtx._hyg.11 inst._@.Init.Data.Range.Polymorphic.Basic.1963379685._hygCtx._hyg.14 inst._@.Init.Data.Range.Polymorphic.Basic.1963379685._hygCtx._hyg.17] (lo : α) (hi : α), (Not (LT.lt.{u} α inst._@.Init.Data.Range.Polymorphic.Basic.1963379685._hygCtx._hyg.11 lo hi)) -> (Eq.{1} Nat (Std.Rxo.HasSize.size.{u} α inst._@.Init.Data.Range.Polymorphic.Basic.1963379685._hygCtx._hyg.17 lo hi) (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)))

-- Stub: this file represents the declaration `Std.Rxo.LawfulHasSize.size_eq_zero_of_not_le`.
-- In a full split, the body would be extracted from the environment.
