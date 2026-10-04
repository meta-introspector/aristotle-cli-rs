import Mathlib

set_option pp.all true
-- spec: instDecidableAnd : forall {p : Prop} {q : Prop} [dp : Decidable p] [dq : Decidable q], Decidable (And p q)
def instDecidableAnd : forall {p : Prop} {q : Prop} [dp : Decidable p] [dq : Decidable q], Decidable (And p q) :=
  fun {p : Prop} {q : Prop} [dp : Decidable p] [dq : Decidable q] => instDecidableAnd.match_1.{1} p (fun (dp._@.Init.Prelude.3138210578._hygCtx._hyg.17 : Decidable p) => Decidable (And p q)) dp (fun (hp : p) => instDecidableAnd.match_1.{1} q (fun (dq._@.Init.Prelude.3138210578._hygCtx._hyg.26 : Decidable q) => Decidable (And p q)) dq (fun (hq : q) => Decidable.isTrue (And p q) (And.intro p q hp hq)) (fun (hq : Not q) => Decidable.isFalse (And p q) (instDecidableAnd._proof_1 p q hq))) (fun (hp : Not p) => Decidable.isFalse (And p q) (instDecidableAnd._proof_2 p q hp))
