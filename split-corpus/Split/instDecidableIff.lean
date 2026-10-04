import Mathlib

set_option pp.all true
-- spec: instDecidableIff : forall {p : Prop} {q : Prop} [inst._@.Init.Core.137670766._hygCtx._hyg.8 : Decidable p] [inst._@.Init.Core.137670766._hygCtx._hyg.11 : Decidable q], Decidable (Iff p q)
def instDecidableIff : forall {p : Prop} {q : Prop} [inst._@.Init.Core.137670766._hygCtx._hyg.8 : Decidable p] [inst._@.Init.Core.137670766._hygCtx._hyg.11 : Decidable q], Decidable (Iff p q) :=
  fun {p : Prop} {q : Prop} [inst._@.Init.Core.137670766._hygCtx._hyg.8 : Decidable p] [inst._@.Init.Core.137670766._hygCtx._hyg.11 : Decidable q] => dite.{1} (Decidable (Iff p q)) p inst._@.Init.Core.137670766._hygCtx._hyg.8 (fun (hp : p) => dite.{1} (Decidable (Iff p q)) q inst._@.Init.Core.137670766._hygCtx._hyg.11 (fun (hq : q) => Decidable.isTrue (Iff p q) (instDecidableIff._proof_1 p q hp hq)) (fun (hq : Not q) => Decidable.isFalse (Iff p q) (instDecidableIff._proof_2 p q hp hq))) (fun (hp : Not p) => dite.{1} (Decidable (Iff p q)) q inst._@.Init.Core.137670766._hygCtx._hyg.11 (fun (hq : q) => Decidable.isFalse (Iff p q) (instDecidableIff._proof_3 p q hp hq)) (fun (hq : Not q) => Decidable.isTrue (Iff p q) (instDecidableIff._proof_4 p q hp hq)))
