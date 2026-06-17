import Split.Pure_pure
import Split.PSigma_snd
import Split.Std_PRange_UpwardEnumerable
import Split.Std_Rxc_Iterator_instIteratorLoop_loop_match_3
import Split.Monad_toApplicative
import Split.InvImage
import Split.Std_PRange_UpwardEnumerable_LE
import Split.Option_some
import Split.Std_Rxo_instIteratorIteratorIdOfUpwardEnumerableOfDecidableLT
import Split.ForInStep_done
import Split.Std_Rxc_Iterator_instIteratorLoop_loop_match_1
import Split.Std_Rxo_Iterator_mk
import Split.Subtype
import Split.Std_IteratorLoop_rel
import Split.Prod_mk
import Split.Std_IterM_mk
import Split.Std_Rxo_Iterator
import Split.Id
import Split.Applicative_toPure
import Split.Std_PRange_UpwardEnumerable_succ?
import Split.ForInStep
import Split.dite
import Split.Option_none
import Split.LT_lt
import Split.WellFounded_extrinsicFix₃
import Split.PSigma_mk
import Split.Monad_toBind
import Split.Std_IterM
import Split.Bind_bind
import Split.PSigma_fst
import Split.Prod
import Split.Monad
import Split.PSigma
import Split.Eq
import Split.Not
import Split.DecidableLT
import Split.ForInStep_yield
import Split.LT
import Split.Std_PRange_LawfulUpwardEnumerable
import Split.Option

-- Std.Rxo.Iterator.instIteratorLoop.loop from environment
-- def Std.Rxo.Iterator.instIteratorLoop.loop : forall {α : Type.{u}} [inst._@.Init.Data.Range.Polymorphic.RangeIterator.59787604._hygCtx._hyg.6 : Std.PRange.UpwardEnumerable.{u} α] [inst._@.Init.Data.Range.Polymorphic.RangeIterator.59787604._hygCtx._hyg.9 : LT.{u} α] [inst._@.Init.Data.Range.Polymorphic.RangeIterator.59787604._hygCtx._hyg.12 : DecidableLT.{u} α inst._@.Init.Data.Range.Polymorphic.RangeIterator.59787604._hygCtx._hyg.9] [inst._@.Init.Data.Range.Polymorphic.RangeIterator.59787604._hygCtx._hyg.15 : Std.PRange.LawfulUpwardEnumerable.{u} α inst._@.Init.Data.Range.Polymorphic.RangeIterator.59787604._hygCtx._hyg.6] {n : Type.{u} -> Type.{w}} [inst._@.Init.Data.Range.Polymorphic.RangeIterator.59787604._hygCtx._hyg.24 : Monad.{u, w} n] (γ : Type.{u}) (Pl : α -> γ -> (ForInStep.{u} γ) -> Prop) (LargeEnough : α -> Prop), (forall (a : α) (b : α), (Std.PRange.UpwardEnumerable.LE.{u} α inst._@.Init.Data.Range.Polymorphic.RangeIterator.59787604._hygCtx._hyg.6 a b) -> (LargeEnough a) -> (LargeEnough b)) -> (forall (upperBound : α), γ -> (forall (next : α), (LargeEnough next) -> (forall (out : α), (LargeEnough out) -> (LT.lt.{u} α inst._@.Init.Data.Range.Polymorphic.RangeIterator.59787604._hygCtx._hyg.9 out upperBound) -> (forall (c : γ), n (Subtype.{succ u} (ForInStep.{u} γ) (Pl out c)))) -> (n γ)))
-- (definition body omitted)

-- Stub: this file represents the declaration `Std.Rxo.Iterator.instIteratorLoop.loop`.
-- In a full split, the body would be extracted from the environment.
