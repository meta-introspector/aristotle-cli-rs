import Mathlib

-- spec: theorem Imp.swap : forall {a : Sort.{u_1}} {b : Sort.{u_2}} {c : Prop}, Iff (a -> b -> c) (b -> a -> c)
theorem Imp.swap : forall {a : Sort.{u_1}} {b : Sort.{u_2}} {c : Prop}, Iff (a -> b -> c) (b -> a -> c) :=
  fun {a : Sort.{u_1}} {b : Sort.{u_2}} {c : Prop} => Iff.intro (a -> b -> c) (b -> a -> c) (fun (h : a -> b -> c) (x : b) (y : a) => h y x) (fun (h : b -> a -> c) (x : a) (y : b) => h y x)
