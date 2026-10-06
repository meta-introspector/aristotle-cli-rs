import Mathlib

-- spec: theorem iff_true : forall (p : Prop), Eq.{1} Prop (Iff p True) p
theorem iff_true : forall (p : Prop), Eq.{1} Prop (Iff p True) p :=
  fun (p : Prop) => propext (Iff p True) p (Iff.intro (Iff p True) p (fun (x._@.Init.SimpLemmas.844606021._hygCtx._hyg.16 : Iff p True) => Iff.mpr p True x._@.Init.SimpLemmas.844606021._hygCtx._hyg.16 trivial) (fun (h : p) => Iff.intro p True (fun (x._@.Init.SimpLemmas.844606021._hygCtx._hyg.29 : p) => trivial) (fun (x._@.Init.SimpLemmas.844606021._hygCtx._hyg.34 : True) => h)))
