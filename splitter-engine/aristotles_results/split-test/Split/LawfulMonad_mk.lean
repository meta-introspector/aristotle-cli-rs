import Split.Pure_pure
import Split.Monad_toApplicative
import Split.LawfulMonad
import Split.Seq_seq
import Split.Applicative_toPure
import Split.Unit
import Split.Applicative_toFunctor
import Split.Monad_toBind
import Split.Bind_bind
import Split.Applicative_toSeq
import Split.Monad
import Split.Eq
import Split.Functor_map
import Split.LawfulApplicative

-- LawfulMonad.mk from environment
-- constructor LawfulMonad.mk : forall {m : Type.{u} -> Type.{v}} [inst._@.Init.Control.Lawful.Basic.1965207783._hygCtx._hyg.5 : Monad.{u, v} m] [toLawfulApplicative : LawfulApplicative.{u, v} m (Monad.toApplicative.{u, v} m inst._@.Init.Control.Lawful.Basic.1965207783._hygCtx._hyg.5)], (forall {α : Type.{u}} {β : Type.{u}} (f : α -> β) (x : m α), Eq.{succ v} (m β) (Bind.bind.{u, v} m (Monad.toBind.{u, v} m inst._@.Init.Control.Lawful.Basic.1965207783._hygCtx._hyg.5) α β x (fun (a : α) => Pure.pure.{u, v} m (Applicative.toPure.{u, v} m (Monad.toApplicative.{u, v} m inst._@.Init.Control.Lawful.Basic.1965207783._hygCtx._hyg.5)) β (f a))) (Functor.map.{u, v} m (Applicative.toFunctor.{u, v} m (Monad.toApplicative.{u, v} m inst._@.Init.Control.Lawful.Basic.1965207783._hygCtx._hyg.5)) α β f x)) -> (forall {α : Type.{u}} {β : Type.{u}} (f : m (α -> β)) (x : m α), Eq.{succ v} (m β) (Bind.bind.{u, v} m (Monad.toBind.{u, v} m inst._@.Init.Control.Lawful.Basic.1965207783._hygCtx._hyg.5) (α -> β) β f (fun (x._@.Init.Control.Lawful.Basic.1965207783._hygCtx._hyg.59 : α -> β) => Functor.map.{u, v} m (Applicative.toFunctor.{u, v} m (Monad.toApplicative.{u, v} m inst._@.Init.Control.Lawful.Basic.1965207783._hygCtx._hyg.5)) α β x._@.Init.Control.Lawful.Basic.1965207783._hygCtx._hyg.59 x)) (Seq.seq.{u, v} m (Applicative.toSeq.{u, v} m (Monad.toApplicative.{u, v} m inst._@.Init.Control.Lawful.Basic.1965207783._hygCtx._hyg.5)) α β f (fun (x._@.Init.Control.Lawful.Basic.1965207783._hygCtx._hyg.75 : Unit) => x))) -> (forall {α : Type.{u}} {β : Type.{u}} (x : α) (f : α -> (m β)), Eq.{succ v} (m β) (Bind.bind.{u, v} m (Monad.toBind.{u, v} m inst._@.Init.Control.Lawful.Basic.1965207783._hygCtx._hyg.5) α β (Pure.pure.{u, v} m (Applicative.toPure.{u, v} m (Monad.toApplicative.{u, v} m inst._@.Init.Control.Lawful.Basic.1965207783._hygCtx._hyg.5)) α x) f) (f x)) -> (forall {α : Type.{u}} {β : Type.{u}} {γ : Type.{u}} (x : m α) (f : α -> (m β)) (g : β -> (m γ)), Eq.{succ v} (m γ) (Bind.bind.{u, v} m (Monad.toBind.{u, v} m inst._@.Init.Control.Lawful.Basic.1965207783._hygCtx._hyg.5) β γ (Bind.bind.{u, v} m (Monad.toBind.{u, v} m inst._@.Init.Control.Lawful.Basic.1965207783._hygCtx._hyg.5) α β x f) g) (Bind.bind.{u, v} m (Monad.toBind.{u, v} m inst._@.Init.Control.Lawful.Basic.1965207783._hygCtx._hyg.5) α γ x (fun (x : α) => Bind.bind.{u, v} m (Monad.toBind.{u, v} m inst._@.Init.Control.Lawful.Basic.1965207783._hygCtx._hyg.5) β γ (f x) g))) -> (LawfulMonad.{u, v} m inst._@.Init.Control.Lawful.Basic.1965207783._hygCtx._hyg.5)

-- Stub: this file represents the declaration `LawfulMonad.mk`.
-- In a full split, the body would be extracted from the environment.
