import Mathlib

-- spec: theorem Bool.false_eq_true : Eq.{1} Prop (Eq.{1} Bool Bool.false Bool.true) False
theorem Bool.false_eq_true : Eq.{1} Prop (Eq.{1} Bool Bool.false Bool.true) False :=
  of_eq_true (Eq.{1} Prop (Eq.{1} Bool Bool.false Bool.true) False) (Eq.trans.{1} Prop (Eq.{1} Prop (Eq.{1} Bool Bool.false Bool.true) False) (Eq.{1} Prop False False) True (congrFun'.{1, 1} Prop Prop (Eq.{1} Prop (Eq.{1} Bool Bool.false Bool.true)) (Eq.{1} Prop False) (congrArg.{1, 1} Prop (Prop -> Prop) (Eq.{1} Bool Bool.false Bool.true) False (Eq.{1} Prop) (eq_false' (Eq.{1} Bool Bool.false Bool.true) (fun (h : Eq.{1} Bool Bool.false Bool.true) => False.elim.{0} False (noConfusion_of_Nat.{1} Bool Bool.ctorIdx Bool.false Bool.true h)))) False) (eq_self.{1} Prop False))
