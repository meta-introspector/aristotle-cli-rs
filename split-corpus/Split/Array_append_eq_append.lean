import Mathlib

-- spec: theorem Array.append_eq_append : forall {α : Type.{u_1}} {xs : Array.{u_1} α} {ys : Array.{u_1} α}, Eq.{succ u_1} (Array.{u_1} α) (Array.append.{u_1} α xs ys) (HAppend.hAppend.{u_1, u_1, u_1} (Array.{u_1} α) (Array.{u_1} α) (Array.{u_1} α) (instHAppendOfAppend.{u_1} (Array.{u_1} α) (Array.instAppend.{u_1} α)) xs ys)
theorem Array.append_eq_append : forall {α : Type.{u_1}} {xs : Array.{u_1} α} {ys : Array.{u_1} α}, Eq.{succ u_1} (Array.{u_1} α) (Array.append.{u_1} α xs ys) (HAppend.hAppend.{u_1, u_1, u_1} (Array.{u_1} α) (Array.{u_1} α) (Array.{u_1} α) (instHAppendOfAppend.{u_1} (Array.{u_1} α) (Array.instAppend.{u_1} α)) xs ys) :=
  fun {α : Type.{u_1}} {xs : Array.{u_1} α} {ys : Array.{u_1} α} => rfl.{succ u_1} (Array.{u_1} α) (Array.append.{u_1} α xs ys)
