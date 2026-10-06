import Mathlib

set_option pp.all true
-- spec: Lean.PersistentHashMap.mkEmptyEntriesArray : forall {α : Type.{u_1}} {β : Type.{u_2}}, Array.{max u_2 u_1} (Lean.PersistentHashMap.Entry.{u_1, u_2, max u_2 u_1} α β (Lean.PersistentHashMap.Node.{u_1, u_2} α β))
def Lean.PersistentHashMap.mkEmptyEntriesArray : forall {α : Type.{u_1}} {β : Type.{u_2}}, Array.{max u_2 u_1} (Lean.PersistentHashMap.Entry.{u_1, u_2, max u_2 u_1} α β (Lean.PersistentHashMap.Node.{u_1, u_2} α β)) :=
  fun {α : Type.{u_1}} {β : Type.{u_2}} => Array.replicate.{max u_2 u_1} (Lean.PersistentHashMap.Entry.{u_1, u_2, max u_2 u_1} α β (Lean.PersistentHashMap.Node.{u_1, u_2} α β)) (USize.toNat Lean.PersistentHashMap.branching) (Lean.PersistentHashMap.Entry.null.{u_1, u_2, max u_2 u_1} α β (Lean.PersistentHashMap.Node.{u_1, u_2} α β))
