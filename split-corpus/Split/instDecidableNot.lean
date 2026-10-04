import Mathlib

set_option pp.all true
-- spec: instDecidableNot : forall {p : Prop} [dp : Decidable p], Decidable (Not p)
def instDecidableNot : forall {p : Prop} [dp : Decidable p], Decidable (Not p) :=
  fun {p : Prop} [dp : Decidable p] => instDecidableAnd.match_1.{1} p (fun (dp._@.Init.Prelude.84834074._hygCtx._hyg.14 : Decidable p) => Decidable (Not p)) dp (fun (hp : p) => Decidable.isFalse (Not p) (absurd.{0} p False hp)) (fun (hp : Not p) => Decidable.isTrue (Not p) hp)
