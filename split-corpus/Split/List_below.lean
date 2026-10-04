import Mathlib

set_option pp.all true
-- spec: List.below : forall {α : Type.{u}} {motive : (List.{u} α) -> Sort.{u_1}}, (List.{u} α) -> Sort.{max (succ u) u_1}
def List.below : forall {α : Type.{u}} {motive : (List.{u} α) -> Sort.{u_1}}, (List.{u} α) -> Sort.{max (succ u) u_1} :=
  fun {α : Type.{u}} {motive : (List.{u} α) -> Sort.{u_1}} (t : List.{u} α) => List.rec.{succ (max (succ u) u_1), u} α (fun (t : List.{u} α) => Sort.{max (succ u) u_1}) PUnit.{max (succ u) u_1} (fun (head : α) (tail : List.{u} α) (tail_ih : Sort.{max (succ u) u_1}) => PProd.{u_1, max (succ u) u_1} (motive tail) tail_ih) t
