import Split.Std_PRange_UpwardEnumerable
import Split.Std_Rxc_HasSize
import Split.Std_Rxc_LawfulHasSize
import Split.instOfNatNat
import Split.LE_le
import Split.LE
import Split.Nat
import Split.Std_Rxc_HasSize_size
import Split.OfNat_ofNat
import Split.Eq
import Split.Not

-- Std.Rxc.LawfulHasSize.size_eq_zero_of_not_le from environment
-- theorem Std.Rxc.LawfulHasSize.size_eq_zero_of_not_le : forall {α : Type.{u}} {inst._@.Init.Data.Range.Polymorphic.Basic.1963379684._hygCtx._hyg.11 : LE.{u} α} {inst._@.Init.Data.Range.Polymorphic.Basic.1963379684._hygCtx._hyg.14 : Std.PRange.UpwardEnumerable.{u} α} {inst._@.Init.Data.Range.Polymorphic.Basic.1963379684._hygCtx._hyg.17 : Std.Rxc.HasSize.{u} α} [self : Std.Rxc.LawfulHasSize.{u} α inst._@.Init.Data.Range.Polymorphic.Basic.1963379684._hygCtx._hyg.11 inst._@.Init.Data.Range.Polymorphic.Basic.1963379684._hygCtx._hyg.14 inst._@.Init.Data.Range.Polymorphic.Basic.1963379684._hygCtx._hyg.17] (lo : α) (hi : α), (Not (LE.le.{u} α inst._@.Init.Data.Range.Polymorphic.Basic.1963379684._hygCtx._hyg.11 lo hi)) -> (Eq.{1} Nat (Std.Rxc.HasSize.size.{u} α inst._@.Init.Data.Range.Polymorphic.Basic.1963379684._hygCtx._hyg.17 lo hi) (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)))

-- Stub: this file represents the declaration `Std.Rxc.LawfulHasSize.size_eq_zero_of_not_le`.
-- In a full split, the body would be extracted from the environment.
