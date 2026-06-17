import Mathlib

set_option pp.all true
-- spec: SRewrite.casesOn : forall {motive : SRewrite -> Sort.{u}} (t : SRewrite), (forall (fromThing : Something) (how : Something) (via : Option.{0} Something) (toThing : Something), motive (SRewrite.mk fromThing how via toThing)) -> (motive t)
def SRewrite.casesOn : forall {motive : SRewrite -> Sort.{u}} (t : SRewrite), (forall (fromThing : Something) (how : Something) (via : Option.{0} Something) (toThing : Something), motive (SRewrite.mk fromThing how via toThing)) -> (motive t) :=
  fun {motive : SRewrite -> Sort.{u}} (t : SRewrite) (mk : forall (fromThing : Something) (how : Something) (via : Option.{0} Something) (toThing : Something), motive (SRewrite.mk fromThing how via toThing)) => SRewrite.rec.{u} motive (fun (fromThing : Something) (how : Something) (via : Option.{0} Something) (toThing : Something) => mk fromThing how via toThing) t
