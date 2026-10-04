import Mathlib

set_option pp.all true
-- spec: SRewrite.recOn : forall {motive : SRewrite -> Sort.{u}} (t : SRewrite), (forall (fromThing : Something) (how : Something) (via : Option.{0} Something) (toThing : Something), motive (SRewrite.mk fromThing how via toThing)) -> (motive t)
def SRewrite.recOn : forall {motive : SRewrite -> Sort.{u}} (t : SRewrite), (forall (fromThing : Something) (how : Something) (via : Option.{0} Something) (toThing : Something), motive (SRewrite.mk fromThing how via toThing)) -> (motive t) :=
  fun {motive : SRewrite -> Sort.{u}} (t : SRewrite) (mk : forall (fromThing : Something) (how : Something) (via : Option.{0} Something) (toThing : Something), motive (SRewrite.mk fromThing how via toThing)) => SRewrite.rec.{u} motive mk t
