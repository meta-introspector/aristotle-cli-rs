import Mathlib

-- spec: theorem if_neg : forall {c : Prop} {h : Decidable c}, (Not c) -> (forall {α : Sort.{u}} {t : α} {e : α}, Eq.{u} α (ite.{u} α c h t e) e)
theorem if_neg : forall {c : Prop} {h : Decidable c}, (Not c) -> (forall {α : Sort.{u}} {t : α} {e : α}, Eq.{u} α (ite.{u} α c h t e) e) :=
  fun {c : Prop} {h : Decidable c} (hnc : Not c) {α : Sort.{u}} {t : α} {e : α} => _private.Init.Core.0.if_neg.match_1_1 c (fun (h._@.Init.Core.3605429635._hygCtx._hyg.27 : Decidable c) => Eq.{u} α (ite.{u} α c h._@.Init.Core.3605429635._hygCtx._hyg.27 t e) e) h (fun (hc : c) => absurd.{0} c (Eq.{u} α (ite.{u} α c (Decidable.isTrue c hc) t e) e) hc hnc) (fun (h._@.Init.Core.3605429635._hygCtx._hyg.42 : Not c) => rfl.{u} α (ite.{u} α c (Decidable.isFalse c h._@.Init.Core.3605429635._hygCtx._hyg.42) t e))
