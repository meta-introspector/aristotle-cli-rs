import Mathlib

-- spec: theorem iff_iff_implies_and_implies : forall {a : Prop} {b : Prop}, Iff (Iff a b) (And (a -> b) (b -> a))
theorem iff_iff_implies_and_implies : forall {a : Prop} {b : Prop}, Iff (Iff a b) (And (a -> b) (b -> a)) :=
  fun {a : Prop} {b : Prop} => Iff.intro (Iff a b) (And (a -> b) (b -> a)) (fun (h : Iff a b) => And.intro (a -> b) (b -> a) (Iff.mp a b h) (Iff.mpr a b h)) (fun (h : And (a -> b) (b -> a)) => Iff.intro a b (And.left (a -> b) (b -> a) h) (And.right (a -> b) (b -> a) h))
