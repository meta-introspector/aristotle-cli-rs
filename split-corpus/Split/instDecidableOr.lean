import Mathlib

set_option pp.all true
-- spec: instDecidableOr : forall {p : Prop} {q : Prop} [dp : Decidable p] [dq : Decidable q], Decidable (Or p q)
def instDecidableOr : forall {p : Prop} {q : Prop} [dp : Decidable p] [dq : Decidable q], Decidable (Or p q) :=
  fun {p : Prop} {q : Prop} [dp : Decidable p] [dq : Decidable q] => instDecidableAnd.match_1.{1} p (fun (dp._@.Init.Prelude.1087427824._hygCtx._hyg.21 : Decidable p) => Decidable (Or p q)) dp (fun (hp : p) => Decidable.isTrue (Or p q) (Or.inl p q hp)) (fun (hp : Not p) => instDecidableAnd.match_1.{1} q (fun (dq._@.Init.Prelude.1087427824._hygCtx._hyg.40 : Decidable q) => Decidable (Or p q)) dq (fun (hq : q) => Decidable.isTrue (Or p q) (Or.inr p q hq)) (fun (hq : Not q) => Decidable.isFalse (Or p q) (instDecidableOr._proof_1 p q hp hq)))
