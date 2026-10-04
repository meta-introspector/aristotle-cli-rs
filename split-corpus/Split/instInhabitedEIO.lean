import Mathlib

set_option pp.all true
-- spec: instInhabitedEIO : forall {ε : Type} {α : Type} [inst._@.Init.System.IO.1736496984._hygCtx._hyg.14 : Inhabited.{1} ε], Inhabited.{1} (EIO ε α)
def instInhabitedEIO : forall {ε : Type} {α : Type} [inst._@.Init.System.IO.1736496984._hygCtx._hyg.14 : Inhabited.{1} ε], Inhabited.{1} (EIO ε α) :=
  fun {ε : Type} {α : Type} [inst._@.Init.System.IO.1736496984._hygCtx._hyg.14 : Inhabited.{1} ε] => Inhabited.mk.{1} (EIO ε α) (instInhabitedEIO._aux_1 ε α inst._@.Init.System.IO.1736496984._hygCtx._hyg.14)
