import Mathlib

-- spec: theorem Exists.choose_spec : forall {α : Sort.{u_1}} {p : α -> Prop} (P : Exists.{u_1} α (fun (a : α) => p a)), p (Exists.choose.{u_1} α p P)
theorem Exists.choose_spec : forall {α : Sort.{u_1}} {p : α -> Prop} (P : Exists.{u_1} α (fun (a : α) => p a)), p (Exists.choose.{u_1} α p P) :=
  fun {α : Sort.{u_1}} {p : α -> Prop} (P : Exists.{u_1} α (fun (a : α) => p a)) => Classical.choose_spec.{u_1} α p P
