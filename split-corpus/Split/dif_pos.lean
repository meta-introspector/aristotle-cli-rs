import Mathlib

-- spec: theorem dif_pos : forall {c : Prop} {h : Decidable c} (hc : c) {α : Sort.{u}} {t : c -> α} {e : (Not c) -> α}, Eq.{u} α (dite.{u} α c h t e) (t hc)
theorem dif_pos : forall {c : Prop} {h : Decidable c} (hc : c) {α : Sort.{u}} {t : c -> α} {e : (Not c) -> α}, Eq.{u} α (dite.{u} α c h t e) (t hc) :=
  fun {c : Prop} {h : Decidable c} (hc : c) {α : Sort.{u}} {t : c -> α} {e : (Not c) -> α} => _private.Init.Core.0.dif_pos.match_1_1 c (fun (h._@.Init.Core.631123022._hygCtx._hyg.32 : Decidable c) => Eq.{u} α (dite.{u} α c h._@.Init.Core.631123022._hygCtx._hyg.32 t e) (t hc)) h (fun (h._@.Init.Core.631123022._hygCtx._hyg.39 : c) => rfl.{u} α (dite.{u} α c (Decidable.isTrue c h._@.Init.Core.631123022._hygCtx._hyg.39) t e)) (fun (hnc : Not c) => absurd.{0} c (Eq.{u} α (dite.{u} α c (Decidable.isFalse c hnc) t e) (t hc)) hc hnc)
