import Mathlib

set_option pp.all true
-- spec: MonadWithReader.withReader : forall {ρ : outParam.{succ (succ u)} Type.{u}} {m : Type.{u} -> Type.{v}} [self : MonadWithReader.{u, v} ρ m] {α : Type.{u}}, (ρ -> ρ) -> (m α) -> (m α)
def MonadWithReader.withReader : forall {ρ : outParam.{succ (succ u)} Type.{u}} {m : Type.{u} -> Type.{v}} [self : MonadWithReader.{u, v} ρ m] {α : Type.{u}}, (ρ -> ρ) -> (m α) -> (m α) :=
  fun {ρ : outParam.{succ (succ u)} Type.{u}} (m : Type.{u} -> Type.{v}) [self : MonadWithReader.{u, v} ρ m] => self.1
