import Split.Pure_pure
import Split.Monad_toApplicative
import Split.LawfulMonad
import Split.Applicative_toPure
import Split.Applicative_toFunctor
import Split.Monad_toBind
import Split.Bind_bind
import Split.Monad
import Split.Eq
import Split.Functor_map

-- LawfulMonad.bind_pure_comp from environment
-- theorem LawfulMonad.bind_pure_comp : forall {m : Type.{u} -> Type.{v}} {inst._@.Init.Control.Lawful.Basic.1965207783._hygCtx._hyg.5 : Monad.{u, v} m} [self : LawfulMonad.{u, v} m inst._@.Init.Control.Lawful.Basic.1965207783._hygCtx._hyg.5] {α : Type.{u}} {β : Type.{u}} (f : α -> β) (x : m α), Eq.{succ v} (m β) (Bind.bind.{u, v} m (Monad.toBind.{u, v} m inst._@.Init.Control.Lawful.Basic.1965207783._hygCtx._hyg.5) α β x (fun (a : α) => Pure.pure.{u, v} m (Applicative.toPure.{u, v} m (Monad.toApplicative.{u, v} m inst._@.Init.Control.Lawful.Basic.1965207783._hygCtx._hyg.5)) β (f a))) (Functor.map.{u, v} m (Applicative.toFunctor.{u, v} m (Monad.toApplicative.{u, v} m inst._@.Init.Control.Lawful.Basic.1965207783._hygCtx._hyg.5)) α β f x)

-- Stub: this file represents the declaration `LawfulMonad.bind_pure_comp`.
-- In a full split, the body would be extracted from the environment.
