import Mathlib

-- spec: theorem Bool.true_eq_false : Eq.{1} Prop (Eq.{1} Bool Bool.true Bool.false) False
theorem Bool.true_eq_false : Eq.{1} Prop (Eq.{1} Bool Bool.true Bool.false) False :=
  of_eq_true (Eq.{1} Prop (Eq.{1} Bool Bool.true Bool.false) False) (Eq.trans.{1} Prop (Eq.{1} Prop (Eq.{1} Bool Bool.true Bool.false) False) (Eq.{1} Prop False False) True (congrFun'.{1, 1} Prop Prop (Eq.{1} Prop (Eq.{1} Bool Bool.true Bool.false)) (Eq.{1} Prop False) (congrArg.{1, 1} Prop (Prop -> Prop) (Eq.{1} Bool Bool.true Bool.false) False (Eq.{1} Prop) (eq_false' (Eq.{1} Bool Bool.true Bool.false) (fun (h : Eq.{1} Bool Bool.true Bool.false) => False.elim.{0} False (noConfusion_of_Nat.{1} Bool Bool.ctorIdx Bool.true Bool.false h)))) False) (eq_self.{1} Prop False))
