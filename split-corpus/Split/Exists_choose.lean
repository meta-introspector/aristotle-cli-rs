import Mathlib

set_option pp.all true
-- spec: Exists.choose : forall {α : Sort.{u_1}} {p : α -> Prop}, (Exists.{u_1} α (fun (a : α) => p a)) -> α
def Exists.choose : forall {α : Sort.{u_1}} {p : α -> Prop}, (Exists.{u_1} α (fun (a : α) => p a)) -> α :=
  fun {α : Sort.{u_1}} {p : α -> Prop} (P : Exists.{u_1} α (fun (a : α) => p a)) => Classical.choose.{u_1} α p P
