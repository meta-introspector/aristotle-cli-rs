import Mathlib

-- spec: theorem if_pos : forall {c : Prop} {h : Decidable c}, c -> (forall {α : Sort.{u}} {t : α} {e : α}, Eq.{u} α (ite.{u} α c h t e) t)
theorem if_pos : forall {c : Prop} {h : Decidable c}, c -> (forall {α : Sort.{u}} {t : α} {e : α}, Eq.{u} α (ite.{u} α c h t e) t) :=
  fun {c : Prop} {h : Decidable c} (hc : c) {α : Sort.{u}} {t : α} {e : α} => _private.Init.Core.0.if_pos.match_1_1 c (fun (h._@.Init.Core.2554475610._hygCtx._hyg.24 : Decidable c) => Eq.{u} α (ite.{u} α c h._@.Init.Core.2554475610._hygCtx._hyg.24 t e) t) h (fun (h._@.Init.Core.2554475610._hygCtx._hyg.31 : c) => rfl.{u} α (ite.{u} α c (Decidable.isTrue c h._@.Init.Core.2554475610._hygCtx._hyg.31) t e)) (fun (hnc : Not c) => absurd.{0} c (Eq.{u} α (ite.{u} α c (Decidable.isFalse c hnc) t e) t) hc hnc)
