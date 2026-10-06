import Mathlib

-- spec: theorem Nat.min_self : forall (a : Nat), Eq.{1} Nat (Min.min.{0} Nat instMinNat a a) a
theorem Nat.min_self : forall (a : Nat), Eq.{1} Nat (Min.min.{0} Nat instMinNat a a) a :=
  fun (a : Nat) => of_eq_true (Eq.{1} Nat (Min.min.{0} Nat instMinNat a a) a) (Eq.trans.{1} Prop (Eq.{1} Nat (Min.min.{0} Nat instMinNat a a) a) (Eq.{1} Nat a a) True (congrFun'.{1, 1} Nat Prop (Eq.{1} Nat (Min.min.{0} Nat instMinNat a a)) (Eq.{1} Nat a) (congrArg.{1, 1} Nat (Nat -> Prop) (Min.min.{0} Nat instMinNat a a) a (Eq.{1} Nat) (Nat.min_eq_left a a (of_eq_true (LE.le.{0} Nat instLENat a a) (Std.le_refl._simp_1.{0} Nat instLENat (Std.instReflLeOfIsPreorder.{0} Nat instLENat (Std.IsLinearPreorder.toIsPreorder.{0} Nat instLENat (Std.IsLinearOrder.toIsLinearPreorder.{0} Nat instLENat Nat.instIsLinearOrder))) a)))) a) (eq_self.{1} Nat a))
