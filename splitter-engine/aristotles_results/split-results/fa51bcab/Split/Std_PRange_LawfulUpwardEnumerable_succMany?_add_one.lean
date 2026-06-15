import Split.Std_PRange_UpwardEnumerable
import Split.Option_bind
import Split.instOfNatNat
import Split.Std_PRange_UpwardEnumerable_succ?
import Split.instHAdd
import Split.Std_PRange_UpwardEnumerable_succMany?
import Split.HAdd_hAdd
import Split.Nat
import Split.instAddNat
import Split.OfNat_ofNat
import Split.Eq
import Split.Std_PRange_LawfulUpwardEnumerable
import Split.Option

-- Std.PRange.LawfulUpwardEnumerable.succMany?_add_one from environment
-- theorem Std.PRange.LawfulUpwardEnumerable.succMany?_add_one : forall {α : Type.{u}} {inst._@.Init.Data.Range.Polymorphic.UpwardEnumerable.4044214821._hygCtx._hyg.3 : Std.PRange.UpwardEnumerable.{u} α} [self : Std.PRange.LawfulUpwardEnumerable.{u} α inst._@.Init.Data.Range.Polymorphic.UpwardEnumerable.4044214821._hygCtx._hyg.3] (n : Nat) (a : α), Eq.{succ u} (Option.{u} α) (Std.PRange.UpwardEnumerable.succMany?.{u} α inst._@.Init.Data.Range.Polymorphic.UpwardEnumerable.4044214821._hygCtx._hyg.3 (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) n (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))) a) (Option.bind.{u, u} α α (Std.PRange.UpwardEnumerable.succMany?.{u} α inst._@.Init.Data.Range.Polymorphic.UpwardEnumerable.4044214821._hygCtx._hyg.3 n a) (Std.PRange.UpwardEnumerable.succ?.{u} α inst._@.Init.Data.Range.Polymorphic.UpwardEnumerable.4044214821._hygCtx._hyg.3))

-- Stub: this file represents the declaration `Std.PRange.LawfulUpwardEnumerable.succMany?_add_one`.
-- In a full split, the body would be extracted from the environment.
