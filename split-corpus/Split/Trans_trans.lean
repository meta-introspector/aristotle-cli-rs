import Mathlib

set_option pp.all true
-- spec: Trans.trans : forall {α : Sort.{u_1}} {β : Sort.{u_2}} {γ : Sort.{u_3}} {r : α -> β -> Sort.{u}} {s : β -> γ -> Sort.{v}} {t : outParam.{max (max (succ w) u_1) u_3} (α -> γ -> Sort.{w})} [self : Trans.{u, v, w, u_1, u_2, u_3} α β γ r s t] {a : α} {b : β} {c : γ}, (r a b) -> (s b c) -> (t a c)
def Trans.trans : forall {α : Sort.{u_1}} {β : Sort.{u_2}} {γ : Sort.{u_3}} {r : α -> β -> Sort.{u}} {s : β -> γ -> Sort.{v}} {t : outParam.{max (max (succ w) u_1) u_3} (α -> γ -> Sort.{w})} [self : Trans.{u, v, w, u_1, u_2, u_3} α β γ r s t] {a : α} {b : β} {c : γ}, (r a b) -> (s b c) -> (t a c) :=
  fun (α : Sort.{u_1}) (β : Sort.{u_2}) (γ : Sort.{u_3}) (r : α -> β -> Sort.{u}) (s : β -> γ -> Sort.{v}) {t : outParam.{max (max (succ w) u_1) u_3} (α -> γ -> Sort.{w})} [self : Trans.{u, v, w, u_1, u_2, u_3} α β γ r s t] => self.1
