import Mathlib

set_option pp.all true
-- spec: Bool.decEq : forall (a : Bool) (b : Bool), Decidable (Eq.{1} Bool a b)
def Bool.decEq : forall (a : Bool) (b : Bool), Decidable (Eq.{1} Bool a b) :=
  fun (a : Bool) (b : Bool) => Bool.decEq.match_1.{1} (fun (a._@.Init.Prelude.18944135._hygCtx._hyg.14 : Bool) (b._@.Init.Prelude.18944135._hygCtx._hyg.16 : Bool) => Decidable (Eq.{1} Bool a._@.Init.Prelude.18944135._hygCtx._hyg.14 b._@.Init.Prelude.18944135._hygCtx._hyg.16)) a b (fun (_ : Unit) => Decidable.isTrue (Eq.{1} Bool Bool.false Bool.false) (rfl.{1} Bool Bool.false)) (fun (_ : Unit) => Decidable.isFalse (Eq.{1} Bool Bool.false Bool.true) (fun (h : Eq.{1} Bool Bool.false Bool.true) => Bool.noConfusion.{0} False Bool.false Bool.true h)) (fun (_ : Unit) => Decidable.isFalse (Eq.{1} Bool Bool.true Bool.false) (fun (h : Eq.{1} Bool Bool.true Bool.false) => Bool.noConfusion.{0} False Bool.true Bool.false h)) (fun (_ : Unit) => Decidable.isTrue (Eq.{1} Bool Bool.true Bool.true) (rfl.{1} Bool Bool.true))
