import Mathlib

-- spec: constructor MonadControl.mk : forall {m : semiOutParam.{max (succ (succ u)) (succ (succ v))} (Type.{u} -> Type.{v})} {n : Type.{u} -> Type.{w}} (stM : Type.{u} -> Type.{u}), (forall {α : Type.{u}}, ((forall {β : Type.{u}}, (n β) -> (m (stM β))) -> (m α)) -> (n α)) -> (forall {α : Type.{u}}, (m (stM α)) -> (n α)) -> (MonadControl.{u, v, w} m n)
