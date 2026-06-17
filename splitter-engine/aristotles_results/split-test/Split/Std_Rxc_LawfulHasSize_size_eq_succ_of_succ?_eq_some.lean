import Split.Std_PRange_UpwardEnumerable
import Split.Std_Rxc_HasSize
import Split.Option_some
import Split.Std_Rxc_LawfulHasSize
import Split.instOfNatNat
import Split.LE_le
import Split.Std_PRange_UpwardEnumerable_succ?
import Split.LE
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Nat
import Split.instAddNat
import Split.Std_Rxc_HasSize_size
import Split.OfNat_ofNat
import Split.Eq
import Split.Option

-- Std.Rxc.LawfulHasSize.size_eq_succ_of_succ?_eq_some from environment
-- theorem Std.Rxc.LawfulHasSize.size_eq_succ_of_succ?_eq_some : forall {α : Type.{u}} {inst._@.Init.Data.Range.Polymorphic.Basic.1963379684._hygCtx._hyg.11 : LE.{u} α} {inst._@.Init.Data.Range.Polymorphic.Basic.1963379684._hygCtx._hyg.14 : Std.PRange.UpwardEnumerable.{u} α} {inst._@.Init.Data.Range.Polymorphic.Basic.1963379684._hygCtx._hyg.17 : Std.Rxc.HasSize.{u} α} [self : Std.Rxc.LawfulHasSize.{u} α inst._@.Init.Data.Range.Polymorphic.Basic.1963379684._hygCtx._hyg.11 inst._@.Init.Data.Range.Polymorphic.Basic.1963379684._hygCtx._hyg.14 inst._@.Init.Data.Range.Polymorphic.Basic.1963379684._hygCtx._hyg.17] (lo : α) (hi : α) (lo' : α), (LE.le.{u} α inst._@.Init.Data.Range.Polymorphic.Basic.1963379684._hygCtx._hyg.11 lo hi) -> (Eq.{succ u} (Option.{u} α) (Std.PRange.UpwardEnumerable.succ?.{u} α inst._@.Init.Data.Range.Polymorphic.Basic.1963379684._hygCtx._hyg.14 lo) (Option.some.{u} α lo')) -> (Eq.{1} Nat (Std.Rxc.HasSize.size.{u} α inst._@.Init.Data.Range.Polymorphic.Basic.1963379684._hygCtx._hyg.17 lo hi) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (Std.Rxc.HasSize.size.{u} α inst._@.Init.Data.Range.Polymorphic.Basic.1963379684._hygCtx._hyg.17 lo' hi) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))))

-- Stub: this file represents the declaration `Std.Rxc.LawfulHasSize.size_eq_succ_of_succ?_eq_some`.
-- In a full split, the body would be extracted from the environment.
