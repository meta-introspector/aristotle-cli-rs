import Mathlib

set_option pp.all true
-- spec: MonadWithReaderOf.withReader : forall {ρ : semiOutParam.{succ (succ u)} Type.{u}} {m : Type.{u} -> Type.{v}} [self : MonadWithReaderOf.{u, v} ρ m] {α : Type.{u}}, (ρ -> ρ) -> (m α) -> (m α)
def MonadWithReaderOf.withReader : forall {ρ : semiOutParam.{succ (succ u)} Type.{u}} {m : Type.{u} -> Type.{v}} [self : MonadWithReaderOf.{u, v} ρ m] {α : Type.{u}}, (ρ -> ρ) -> (m α) -> (m α) :=
  fun (ρ : semiOutParam.{succ (succ u)} Type.{u}) (m : Type.{u} -> Type.{v}) [self : MonadWithReaderOf.{u, v} ρ m] => self.1
