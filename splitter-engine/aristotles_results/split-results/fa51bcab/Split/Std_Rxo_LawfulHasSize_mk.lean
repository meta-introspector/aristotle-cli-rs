import Split.Std_PRange_UpwardEnumerable
import Split.Std_Rxo_LawfulHasSize
import Split.Option_some
import Split.instOfNatNat
import Split.Std_PRange_UpwardEnumerable_succ?
import Split.Option_none
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Nat
import Split.LT_lt
import Split.Std_Rxo_HasSize
import Split.instAddNat
import Split.OfNat_ofNat
import Split.Std_Rxo_HasSize_size
import Split.Eq
import Split.Not
import Split.LT
import Split.Option

-- Std.Rxo.LawfulHasSize.mk from environment
-- constructor Std.Rxo.LawfulHasSize.mk : forall {α : Type.{u}} [inst._@.Init.Data.Range.Polymorphic.Basic.1963379685._hygCtx._hyg.11 : LT.{u} α] [inst._@.Init.Data.Range.Polymorphic.Basic.1963379685._hygCtx._hyg.14 : Std.PRange.UpwardEnumerable.{u} α] [inst._@.Init.Data.Range.Polymorphic.Basic.1963379685._hygCtx._hyg.17 : Std.Rxo.HasSize.{u} α], (forall (lo : α) (hi : α), (Not (LT.lt.{u} α inst._@.Init.Data.Range.Polymorphic.Basic.1963379685._hygCtx._hyg.11 lo hi)) -> (Eq.{1} Nat (Std.Rxo.HasSize.size.{u} α inst._@.Init.Data.Range.Polymorphic.Basic.1963379685._hygCtx._hyg.17 lo hi) (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)))) -> (forall (lo : α) (hi : α), (LT.lt.{u} α inst._@.Init.Data.Range.Polymorphic.Basic.1963379685._hygCtx._hyg.11 lo hi) -> (Eq.{succ u} (Option.{u} α) (Std.PRange.UpwardEnumerable.succ?.{u} α inst._@.Init.Data.Range.Polymorphic.Basic.1963379685._hygCtx._hyg.14 lo) (Option.none.{u} α)) -> (Eq.{1} Nat (Std.Rxo.HasSize.size.{u} α inst._@.Init.Data.Range.Polymorphic.Basic.1963379685._hygCtx._hyg.17 lo hi) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)))) -> (forall (lo : α) (hi : α) (lo' : α), (LT.lt.{u} α inst._@.Init.Data.Range.Polymorphic.Basic.1963379685._hygCtx._hyg.11 lo hi) -> (Eq.{succ u} (Option.{u} α) (Std.PRange.UpwardEnumerable.succ?.{u} α inst._@.Init.Data.Range.Polymorphic.Basic.1963379685._hygCtx._hyg.14 lo) (Option.some.{u} α lo')) -> (Eq.{1} Nat (Std.Rxo.HasSize.size.{u} α inst._@.Init.Data.Range.Polymorphic.Basic.1963379685._hygCtx._hyg.17 lo hi) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (Std.Rxo.HasSize.size.{u} α inst._@.Init.Data.Range.Polymorphic.Basic.1963379685._hygCtx._hyg.17 lo' hi) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))))) -> (Std.Rxo.LawfulHasSize.{u} α inst._@.Init.Data.Range.Polymorphic.Basic.1963379685._hygCtx._hyg.11 inst._@.Init.Data.Range.Polymorphic.Basic.1963379685._hygCtx._hyg.14 inst._@.Init.Data.Range.Polymorphic.Basic.1963379685._hygCtx._hyg.17)

-- Stub: this file represents the declaration `Std.Rxo.LawfulHasSize.mk`.
-- In a full split, the body would be extracted from the environment.
