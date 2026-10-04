import Mathlib

set_option pp.all true
-- spec: Option.some.noConfusion : forall {α : Type.{u}} {P : Sort.{u_1}} {val : α} {val' : α}, (Eq.{succ u} (Option.{u} α) (Option.some.{u} α val) (Option.some.{u} α val')) -> ((HEq.{succ u} α val α val') -> P) -> P
def Option.some.noConfusion : forall {α : Type.{u}} {P : Sort.{u_1}} {val : α} {val' : α}, (Eq.{succ u} (Option.{u} α) (Option.some.{u} α val) (Option.some.{u} α val')) -> ((HEq.{succ u} α val α val') -> P) -> P :=
  fun {α : Type.{u}} {P : Sort.{u_1}} {val : α} {val' : α} (eq : Eq.{succ u} (Option.{u} α) (Option.some.{u} α val) (Option.some.{u} α val')) (k : (HEq.{succ u} α val α val') -> P) => id.{u_1} P (Option.noConfusion.{u_1, u} P α (Option.some.{u} α val) α (Option.some.{u} α val') (Eq.refl.{succ (succ u)} Type.{u} α) (heq_of_eq.{succ u} (Option.{u} α) (Option.some.{u} α val) (Option.some.{u} α val') eq) k)
