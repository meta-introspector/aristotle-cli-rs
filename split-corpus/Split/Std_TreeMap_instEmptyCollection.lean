import Mathlib

set_option pp.all true
-- spec: Std.TreeMap.instEmptyCollection : forall {α : Type.{u}} {β : Type.{v}} {cmp : α -> α -> Ordering}, EmptyCollection.{max v u} (Std.TreeMap.{u, v} α β cmp)
def Std.TreeMap.instEmptyCollection : forall {α : Type.{u}} {β : Type.{v}} {cmp : α -> α -> Ordering}, EmptyCollection.{max v u} (Std.TreeMap.{u, v} α β cmp) :=
  fun {α : Type.{u}} {β : Type.{v}} {cmp : α -> α -> Ordering} => EmptyCollection.mk.{max u v} (Std.TreeMap.{u, v} α β cmp) (Std.TreeMap.empty.{u, v} α β cmp)
