import Mathlib

-- spec: constructor Std.Iterators.PostconditionT.mk : forall {m : Type.{w} -> Type.{w'}} {α : Type.{w}} (Property : α -> Prop), (m (Subtype.{succ w} α Property)) -> (Std.Iterators.PostconditionT.{w, w'} m α)
