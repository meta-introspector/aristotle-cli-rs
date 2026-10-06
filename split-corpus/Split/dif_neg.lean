import Mathlib

-- spec: theorem dif_neg : forall {c : Prop} {h : Decidable c} (hnc : Not c) {α : Sort.{u}} {t : c -> α} {e : (Not c) -> α}, Eq.{u} α (dite.{u} α c h t e) (e hnc)
theorem dif_neg : forall {c : Prop} {h : Decidable c} (hnc : Not c) {α : Sort.{u}} {t : c -> α} {e : (Not c) -> α}, Eq.{u} α (dite.{u} α c h t e) (e hnc) :=
  fun {c : Prop} {h : Decidable c} (hnc : Not c) {α : Sort.{u}} {t : c -> α} {e : (Not c) -> α} => _private.Init.Core.0.dif_neg.match_1_1 c (fun (h._@.Init.Core.3914056318._hygCtx._hyg.35 : Decidable c) => Eq.{u} α (dite.{u} α c h._@.Init.Core.3914056318._hygCtx._hyg.35 t e) (e hnc)) h (fun (hc : c) => absurd.{0} c (Eq.{u} α (dite.{u} α c (Decidable.isTrue c hc) t e) (e hnc)) hc hnc) (fun (h._@.Init.Core.3914056318._hygCtx._hyg.50 : Not c) => rfl.{u} α (dite.{u} α c (Decidable.isFalse c h._@.Init.Core.3914056318._hygCtx._hyg.50) t e))
