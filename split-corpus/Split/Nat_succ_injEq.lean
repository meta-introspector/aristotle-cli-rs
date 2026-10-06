import Mathlib

-- spec: theorem Nat.succ.injEq : forall (u : Nat) (v : Nat), Eq.{1} Prop (Eq.{1} Nat (Nat.succ u) (Nat.succ v)) (Eq.{1} Nat u v)
theorem Nat.succ.injEq : forall (u : Nat) (v : Nat), Eq.{1} Prop (Eq.{1} Nat (Nat.succ u) (Nat.succ v)) (Eq.{1} Nat u v) :=
  fun (u : Nat) (v : Nat) => Eq.propIntro (Eq.{1} Nat (Nat.succ u) (Nat.succ v)) (Eq.{1} Nat u v) (Nat.succ.inj u v) (congrArg.{1, 1} Nat Nat u v Nat.succ)
