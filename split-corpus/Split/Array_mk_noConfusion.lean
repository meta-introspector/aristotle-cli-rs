import Mathlib

set_option pp.all true
-- spec: Array.mk.noConfusion : forall {α : Type.{u}} {P : Sort.{u_1}} {toList : List.{u} α} {toList' : List.{u} α}, (Eq.{succ u} (Array.{u} α) (Array.mk.{u} α toList) (Array.mk.{u} α toList')) -> ((HEq.{succ u} (List.{u} α) toList (List.{u} α) toList') -> P) -> P
def Array.mk.noConfusion : forall {α : Type.{u}} {P : Sort.{u_1}} {toList : List.{u} α} {toList' : List.{u} α}, (Eq.{succ u} (Array.{u} α) (Array.mk.{u} α toList) (Array.mk.{u} α toList')) -> ((HEq.{succ u} (List.{u} α) toList (List.{u} α) toList') -> P) -> P :=
  fun {α : Type.{u}} {P : Sort.{u_1}} {toList : List.{u} α} {toList' : List.{u} α} (eq : Eq.{succ u} (Array.{u} α) (Array.mk.{u} α toList) (Array.mk.{u} α toList')) (k : (HEq.{succ u} (List.{u} α) toList (List.{u} α) toList') -> P) => id.{u_1} P (Array.noConfusion.{u_1, u} P α (Array.mk.{u} α toList) α (Array.mk.{u} α toList') (Eq.refl.{succ (succ u)} Type.{u} α) (heq_of_eq.{succ u} (Array.{u} α) (Array.mk.{u} α toList) (Array.mk.{u} α toList') eq) k)
