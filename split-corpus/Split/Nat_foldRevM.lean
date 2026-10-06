import Mathlib

set_option pp.all true
-- spec: Nat.foldRevM : forall {α : Type.{u}} {m : Type.{u} -> Type.{v}} [inst._@.Init.Data.Nat.Control.2912609329._hygCtx._hyg.6 : Monad.{u, v} m] (n : Nat), (forall (i : Nat), (LT.lt.{0} Nat instLTNat i n) -> α -> (m α)) -> α -> (m α)
def Nat.foldRevM : forall {α : Type.{u}} {m : Type.{u} -> Type.{v}} [inst._@.Init.Data.Nat.Control.2912609329._hygCtx._hyg.6 : Monad.{u, v} m] (n : Nat), (forall (i : Nat), (LT.lt.{0} Nat instLTNat i n) -> α -> (m α)) -> α -> (m α) :=
  fun {α : Type.{u}} {m : Type.{u} -> Type.{v}} [inst._@.Init.Data.Nat.Control.2912609329._hygCtx._hyg.6 : Monad.{u, v} m] (n : Nat) (f : forall (i : Nat), (LT.lt.{0} Nat instLTNat i n) -> α -> (m α)) (init : α) => _private.Init.Data.Nat.Control.0.Nat.foldRevM.loop.{u, v} α m inst._@.Init.Data.Nat.Control.2912609329._hygCtx._hyg.6 n f n (_private.Init.Data.Nat.Control.0.Nat.forM._proof_2 n) init
