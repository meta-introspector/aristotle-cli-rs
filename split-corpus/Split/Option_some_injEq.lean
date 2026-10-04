import Mathlib

-- spec: theorem Option.some.injEq : forall {α : Type.{u}} (val : α) (val_1 : α), Eq.{1} Prop (Eq.{succ u} (Option.{u} α) (Option.some.{u} α val) (Option.some.{u} α val_1)) (Eq.{succ u} α val val_1)
theorem Option.some.injEq : forall {α : Type.{u}} (val : α) (val_1 : α), Eq.{1} Prop (Eq.{succ u} (Option.{u} α) (Option.some.{u} α val) (Option.some.{u} α val_1)) (Eq.{succ u} α val val_1) :=
  fun {α : Type.{u}} (val : α) (val_1 : α) => Eq.propIntro (Eq.{succ u} (Option.{u} α) (Option.some.{u} α val) (Option.some.{u} α val_1)) (Eq.{succ u} α val val_1) (Option.some.inj.{u} α val val_1) (Eq.ndrec.{0, succ u} α val (fun (val_1 : α) => Eq.{succ u} (Option.{u} α) (Option.some.{u} α val) (Option.some.{u} α val_1)) (Eq.refl.{succ u} (Option.{u} α) (Option.some.{u} α val)) val_1)
