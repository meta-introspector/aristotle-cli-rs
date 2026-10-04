import Mathlib

set_option pp.all true
-- spec: IO.toEIO : forall {ε : Type} {α : Type}, (IO.Error -> ε) -> (IO α) -> (EIO ε α)
def IO.toEIO : forall {ε : Type} {α : Type}, (IO.Error -> ε) -> (IO α) -> (EIO ε α) :=
  fun {ε : Type} {α : Type} (f : IO.Error -> ε) (act : IO α) => EIO.adapt IO.Error ε α f act
