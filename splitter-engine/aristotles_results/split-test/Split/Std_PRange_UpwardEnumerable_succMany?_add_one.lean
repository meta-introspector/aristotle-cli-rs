import Split.Std_PRange_UpwardEnumerable
import Split.Option_bind
import Split.instOfNatNat
import Split.Std_PRange_UpwardEnumerable_succ?
import Split.instHAdd
import Split.Std_PRange_UpwardEnumerable_succMany?
import Split.HAdd_hAdd
import Split.Std_PRange_LawfulUpwardEnumerable_succMany?_add_one
import Split.Nat
import Split.instAddNat
import Split.OfNat_ofNat
import Split.Eq
import Split.Std_PRange_LawfulUpwardEnumerable
import Split.Option

-- Std.PRange.UpwardEnumerable.succMany?_add_one from environment
-- theorem Std.PRange.UpwardEnumerable.succMany?_add_one : forall {α : Type.{u_1}} [inst._@.Init.Data.Range.Polymorphic.UpwardEnumerable.970398005._hygCtx._hyg.5 : Std.PRange.UpwardEnumerable.{u_1} α] [inst._@.Init.Data.Range.Polymorphic.UpwardEnumerable.970398005._hygCtx._hyg.8 : Std.PRange.LawfulUpwardEnumerable.{u_1} α inst._@.Init.Data.Range.Polymorphic.UpwardEnumerable.970398005._hygCtx._hyg.5] {n : Nat} {a : α}, Eq.{succ u_1} (Option.{u_1} α) (Std.PRange.UpwardEnumerable.succMany?.{u_1} α inst._@.Init.Data.Range.Polymorphic.UpwardEnumerable.970398005._hygCtx._hyg.5 (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) n (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))) a) (Option.bind.{u_1, u_1} α α (Std.PRange.UpwardEnumerable.succMany?.{u_1} α inst._@.Init.Data.Range.Polymorphic.UpwardEnumerable.970398005._hygCtx._hyg.5 n a) (Std.PRange.UpwardEnumerable.succ?.{u_1} α inst._@.Init.Data.Range.Polymorphic.UpwardEnumerable.970398005._hygCtx._hyg.5))

-- Stub: this file represents the declaration `Std.PRange.UpwardEnumerable.succMany?_add_one`.
-- In a full split, the body would be extracted from the environment.
