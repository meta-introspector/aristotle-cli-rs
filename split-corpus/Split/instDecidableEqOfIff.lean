import Mathlib

set_option pp.all true
-- spec: instDecidableEqOfIff : forall {p : Prop} {q : Prop} [d : Decidable (Iff p q)], Decidable (Eq.{1} Prop p q)
def instDecidableEqOfIff : forall {p : Prop} {q : Prop} [d : Decidable (Iff p q)], Decidable (Eq.{1} Prop p q) :=
  fun {p : Prop} {q : Prop} [d : Decidable (Iff p q)] => instDecidableEqOfIff.match_1.{1} p q (fun (d._@.Init.Core.4288742172._hygCtx._hyg.27 : Decidable (Iff p q)) => Decidable (Eq.{1} Prop p q)) d (fun (h : Iff p q) => Decidable.isTrue (Eq.{1} Prop p q) (propext p q h)) (fun (h : Not (Iff p q)) => Decidable.isFalse (Eq.{1} Prop p q) (instDecidableEqOfIff._proof_1 p q h))
