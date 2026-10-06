import Mathlib

-- spec: constructor Std.Iterators.Types.FilterMap.mk : forall {α : Type.{w}} {β : Type.{w}} {γ : Type.{w}} {m : Type.{w} -> Type.{w'}} {n : Type.{w} -> Type.{w''}} {lift : forall {{α : Type.{w}}}, (m α) -> (n α)} {f : β -> (Std.Iterators.PostconditionT.{w, w''} n (Option.{w} γ))}, (Std.IterM.{w, w'} α m β) -> (Std.Iterators.Types.FilterMap.{w, w', w''} α β γ m n lift f)
