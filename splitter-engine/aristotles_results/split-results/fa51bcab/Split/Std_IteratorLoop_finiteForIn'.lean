import Split.Pure_pure
import Split.Std_IteratorLoop_forIn
import Split.trivial
import Split.Monad_toApplicative
import Split.Std_IteratorLoop
import Split.Membership_mem
import Split.ForIn'_mk
import Split.Subtype
import Split.Applicative_toPure
import Split.Std_IterM_IsPlausibleIndirectOutput
import Split.ForInStep
import Split.Std_Iterator
import Split.ForIn'
import Split.Subtype_mk
import Split.True
import Split.Membership_mk
import Split.Monad_toBind
import Split.Std_IterM
import Split.Bind_bind
import Split.Monad

-- Std.IteratorLoop.finiteForIn' from environment
-- def Std.IteratorLoop.finiteForIn' : forall {m : Type.{w} -> Type.{w'}} {n : Type.{x} -> Type.{x'}} {α : Type.{w}} {β : Type.{w}} [inst._@.Init.Data.Iterators.Consumers.Monadic.Loop.96912050._hygCtx._hyg.10 : Std.Iterator.{w, w'} α m β] [inst._@.Init.Data.Iterators.Consumers.Monadic.Loop.96912050._hygCtx._hyg.15 : Std.IteratorLoop.{w, w', x, x'} α m β inst._@.Init.Data.Iterators.Consumers.Monadic.Loop.96912050._hygCtx._hyg.10 n] [inst._@.Init.Data.Iterators.Consumers.Monadic.Loop.96912050._hygCtx._hyg.20 : Monad.{x, x'} n], (forall (γ : Type.{w}) (δ : Type.{x}), (γ -> (n δ)) -> (m γ) -> (n δ)) -> (ForIn'.{w, w, x, x'} n (Std.IterM.{w, w'} α m β) β (Membership.mk.{w, w} β (Std.IterM.{w, w'} α m β) (fun (it : Std.IterM.{w, w'} α m β) (out : β) => Std.IterM.IsPlausibleIndirectOutput.{w, w'} α β m inst._@.Init.Data.Iterators.Consumers.Monadic.Loop.96912050._hygCtx._hyg.10 it out)))
-- (definition body omitted)

-- Stub: this file represents the declaration `Std.IteratorLoop.finiteForIn'`.
-- In a full split, the body would be extracted from the environment.
