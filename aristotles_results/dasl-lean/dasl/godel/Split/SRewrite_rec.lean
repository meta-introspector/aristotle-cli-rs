import Mathlib

-- spec: recursor SRewrite.rec : forall {motive : SRewrite -> Sort.{u}}, (forall (fromThing : Something) (how : Something) (via : Option.{0} Something) (toThing : Something), motive (SRewrite.mk fromThing how via toThing)) -> (forall (t : SRewrite), motive t)
