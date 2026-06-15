import Split.Std_PRange_UpwardEnumerable
import Split.Option_casesOn
import Split.Option_some
import Split.Std_Rxo_instIteratorIteratorIdOfUpwardEnumerableOfDecidableLT
import Split.Std_Rxo_Iterator_mk
import Split.Subtype
import Split.Std_IterM_mk
import Split.Std_Rxo_Iterator
import Split.Id
import Split.Std_IterM_IsPlausibleIndirectOutput
import Split.ForInStep
import Split.Option_none
import Split.Std_IterM
import Split.Std_IterM_casesOn
import Split.Std_Rxo_Iterator_casesOn
import Split.DecidableLT
import Split.LT
import Split.Option

-- Std.Rxo.Iterator.instIteratorLoop.match_1 from environment
-- def Std.Rxo.Iterator.instIteratorLoop.match_1 : forall {α : Type.{u_1}} [inst._@.Init.Data.Range.Polymorphic.RangeIterator.59787604._hygCtx._hyg.6 : Std.PRange.UpwardEnumerable.{u_1} α] [inst._@.Init.Data.Range.Polymorphic.RangeIterator.59787604._hygCtx._hyg.9 : LT.{u_1} α] [inst._@.Init.Data.Range.Polymorphic.RangeIterator.59787604._hygCtx._hyg.12 : DecidableLT.{u_1} α inst._@.Init.Data.Range.Polymorphic.RangeIterator.59787604._hygCtx._hyg.9] {n : Type.{u_1} -> Type.{u_3}} (γ : Type.{u_1}) (Pl : α -> γ -> (ForInStep.{u_1} γ) -> Prop) (motive : forall (it._@.Init.Data.Range.Polymorphic.RangeIterator.59787604._hygCtx._hyg.296 : Std.IterM.{u_1, u_1} (Std.Rxo.Iterator.{u_1} α) Id.{u_1} α), (forall (b : α), (Std.IterM.IsPlausibleIndirectOutput.{u_1, u_1} (Std.Rxo.Iterator.{u_1} α) α Id.{u_1} (Std.Rxo.instIteratorIteratorIdOfUpwardEnumerableOfDecidableLT.{u_1} α inst._@.Init.Data.Range.Polymorphic.RangeIterator.59787604._hygCtx._hyg.6 inst._@.Init.Data.Range.Polymorphic.RangeIterator.59787604._hygCtx._hyg.9 inst._@.Init.Data.Range.Polymorphic.RangeIterator.59787604._hygCtx._hyg.12) it._@.Init.Data.Range.Polymorphic.RangeIterator.59787604._hygCtx._hyg.296 b) -> (forall (c : γ), n (Subtype.{succ u_1} (ForInStep.{u_1} γ) (Pl b c)))) -> Sort.{u_2}) (it._@.Init.Data.Range.Polymorphic.RangeIterator.59787604._hygCtx._hyg.296 : Std.IterM.{u_1, u_1} (Std.Rxo.Iterator.{u_1} α) Id.{u_1} α) (f : forall (b : α), (Std.IterM.IsPlausibleIndirectOutput.{u_1, u_1} (Std.Rxo.Iterator.{u_1} α) α Id.{u_1} (Std.Rxo.instIteratorIteratorIdOfUpwardEnumerableOfDecidableLT.{u_1} α inst._@.Init.Data.Range.Polymorphic.RangeIterator.59787604._hygCtx._hyg.6 inst._@.Init.Data.Range.Polymorphic.RangeIterator.59787604._hygCtx._hyg.9 inst._@.Init.Data.Range.Polymorphic.RangeIterator.59787604._hygCtx._hyg.12) it._@.Init.Data.Range.Polymorphic.RangeIterator.59787604._hygCtx._hyg.296 b) -> (forall (c : γ), n (Subtype.{succ u_1} (ForInStep.{u_1} γ) (Pl b c)))), (forall (next : α) (upperBound : α) (f : forall (b : α), (Std.IterM.IsPlausibleIndirectOutput.{u_1, u_1} (Std.Rxo.Iterator.{u_1} α) α Id.{u_1} (Std.Rxo.instIteratorIteratorIdOfUpwardEnumerableOfDecidableLT.{u_1} α inst._@.Init.Data.Range.Polymorphic.RangeIterator.59787604._hygCtx._hyg.6 inst._@.Init.Data.Range.Polymorphic.RangeIterator.59787604._hygCtx._hyg.9 inst._@.Init.Data.Range.Polymorphic.RangeIterator.59787604._hygCtx._hyg.12) (Std.IterM.mk.{u_1, u_1} (Std.Rxo.Iterator.{u_1} α) Id.{u_1} α (Std.Rxo.Iterator.mk.{u_1} α (Option.some.{u_1} α next) upperBound)) b) -> (forall (c : γ), n (Subtype.{succ u_1} (ForInStep.{u_1} γ) (Pl b c)))), motive (Std.IterM.mk.{u_1, u_1} (Std.Rxo.Iterator.{u_1} α) Id.{u_1} α (Std.Rxo.Iterator.mk.{u_1} α (Option.some.{u_1} α next) upperBound)) f) -> (forall (upperBound._@.Init.Data.Range.Polymorphic.RangeIterator.59787604._hygCtx._hyg.372 : α) (f : forall (b : α), (Std.IterM.IsPlausibleIndirectOutput.{u_1, u_1} (Std.Rxo.Iterator.{u_1} α) α Id.{u_1} (Std.Rxo.instIteratorIteratorIdOfUpwardEnumerableOfDecidableLT.{u_1} α inst._@.Init.Data.Range.Polymorphic.RangeIterator.59787604._hygCtx._hyg.6 inst._@.Init.Data.Range.Polymorphic.RangeIterator.59787604._hygCtx._hyg.9 inst._@.Init.Data.Range.Polymorphic.RangeIterator.59787604._hygCtx._hyg.12) (Std.IterM.mk.{u_1, u_1} (Std.Rxo.Iterator.{u_1} α) Id.{u_1} α (Std.Rxo.Iterator.mk.{u_1} α (Option.none.{u_1} α) upperBound._@.Init.Data.Range.Polymorphic.RangeIterator.59787604._hygCtx._hyg.372)) b) -> (forall (c : γ), n (Subtype.{succ u_1} (ForInStep.{u_1} γ) (Pl b c)))), motive (Std.IterM.mk.{u_1, u_1} (Std.Rxo.Iterator.{u_1} α) Id.{u_1} α (Std.Rxo.Iterator.mk.{u_1} α (Option.none.{u_1} α) upperBound._@.Init.Data.Range.Polymorphic.RangeIterator.59787604._hygCtx._hyg.372)) f) -> (motive it._@.Init.Data.Range.Polymorphic.RangeIterator.59787604._hygCtx._hyg.296 f)
-- (definition body omitted)

-- Stub: this file represents the declaration `Std.Rxo.Iterator.instIteratorLoop.match_1`.
-- In a full split, the body would be extracted from the environment.
