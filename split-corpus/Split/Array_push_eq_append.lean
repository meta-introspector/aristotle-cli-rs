import Mathlib

-- spec: theorem Array.push_eq_append : forall {α : Type.{u_1}} {a : α} {as : Array.{u_1} α}, Eq.{succ u_1} (Array.{u_1} α) (Array.push.{u_1} α as a) (HAppend.hAppend.{u_1, u_1, u_1} (Array.{u_1} α) (Array.{u_1} α) (Array.{u_1} α) (instHAppendOfAppend.{u_1} (Array.{u_1} α) (Array.instAppend.{u_1} α)) as (List.toArray.{u_1} α (List.cons.{u_1} α a (List.nil.{u_1} α))))
theorem Array.push_eq_append : forall {α : Type.{u_1}} {a : α} {as : Array.{u_1} α}, Eq.{succ u_1} (Array.{u_1} α) (Array.push.{u_1} α as a) (HAppend.hAppend.{u_1, u_1, u_1} (Array.{u_1} α) (Array.{u_1} α) (Array.{u_1} α) (instHAppendOfAppend.{u_1} (Array.{u_1} α) (Array.instAppend.{u_1} α)) as (List.toArray.{u_1} α (List.cons.{u_1} α a (List.nil.{u_1} α)))) :=
  fun {α : Type.{u_1}} {a : α} {as : Array.{u_1} α} => rfl.{succ u_1} (Array.{u_1} α) (Array.push.{u_1} α as a)
