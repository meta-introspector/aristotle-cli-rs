import Split.Pure_pure
import Split.Applicative_toPure
import Split.Applicative
import Split.Applicative_toFunctor
import Split.Eq
import Split.Functor_map
import Split.LawfulApplicative

-- LawfulApplicative.map_pure from environment
-- theorem LawfulApplicative.map_pure : forall {f : Type.{u} -> Type.{v}} {inst._@.Init.Control.Lawful.Basic.138018349._hygCtx._hyg.5 : Applicative.{u, v} f} [self : LawfulApplicative.{u, v} f inst._@.Init.Control.Lawful.Basic.138018349._hygCtx._hyg.5] {α : Type.{u}} {β : Type.{u}} (g : α -> β) (x : α), Eq.{succ v} (f β) (Functor.map.{u, v} f (Applicative.toFunctor.{u, v} f inst._@.Init.Control.Lawful.Basic.138018349._hygCtx._hyg.5) α β g (Pure.pure.{u, v} f (Applicative.toPure.{u, v} f inst._@.Init.Control.Lawful.Basic.138018349._hygCtx._hyg.5) α x)) (Pure.pure.{u, v} f (Applicative.toPure.{u, v} f inst._@.Init.Control.Lawful.Basic.138018349._hygCtx._hyg.5) β (g x))

-- Stub: this file represents the declaration `LawfulApplicative.map_pure`.
-- In a full split, the body would be extracted from the environment.
