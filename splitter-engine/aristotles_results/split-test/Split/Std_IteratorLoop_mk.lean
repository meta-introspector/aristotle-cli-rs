import Split.Std_IteratorLoop
import Split.Subtype
import Split.Std_IterM_IsPlausibleIndirectOutput
import Split.ForInStep
import Split.Std_Iterator
import Split.Std_IterM

-- Std.IteratorLoop.mk from environment
-- constructor Std.IteratorLoop.mk : forall {α : Type.{w}} {m : Type.{w} -> Type.{w'}} {β : Type.{w}} [inst._@.Init.Data.Iterators.Consumers.Monadic.Loop.2427246512._hygCtx._hyg.7 : Std.Iterator.{w, w'} α m β] {n : Type.{x} -> Type.{x'}}, ((forall (γ : Type.{w}) (δ : Type.{x}), (γ -> (n δ)) -> (m γ) -> (n δ)) -> (forall (γ : Type.{x}) (plausible_forInStep : β -> γ -> (ForInStep.{x} γ) -> Prop) (it : Std.IterM.{w, w'} α m β), γ -> (forall (b : β), (Std.IterM.IsPlausibleIndirectOutput.{w, w'} α β m inst._@.Init.Data.Iterators.Consumers.Monadic.Loop.2427246512._hygCtx._hyg.7 it b) -> (forall (c : γ), n (Subtype.{succ x} (ForInStep.{x} γ) (plausible_forInStep b c)))) -> (n γ))) -> (Std.IteratorLoop.{w, w', x, x'} α m β inst._@.Init.Data.Iterators.Consumers.Monadic.Loop.2427246512._hygCtx._hyg.7 n)

-- Stub: this file represents the declaration `Std.IteratorLoop.mk`.
-- In a full split, the body would be extracted from the environment.
