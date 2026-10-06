import Mathlib

set_option pp.all true
-- spec: ReaderT.run : forall {ρ : Type.{u}} {m : Type.{u} -> Type.{v}} {α : Type.{u}}, (ReaderT.{u, v} ρ m α) -> ρ -> (m α)
def ReaderT.run : forall {ρ : Type.{u}} {m : Type.{u} -> Type.{v}} {α : Type.{u}}, (ReaderT.{u, v} ρ m α) -> ρ -> (m α) :=
  fun {ρ : Type.{u}} {m : Type.{u} -> Type.{v}} {α : Type.{u}} (x : ReaderT.{u, v} ρ m α) (r : ρ) => x r
