import Mathlib

-- spec: constructor Trans.mk : forall {α : Sort.{u_1}} {β : Sort.{u_2}} {γ : Sort.{u_3}} {r : α -> β -> Sort.{u}} {s : β -> γ -> Sort.{v}} {t : outParam.{max (max (succ w) u_1) u_3} (α -> γ -> Sort.{w})}, (forall {a : α} {b : β} {c : γ}, (r a b) -> (s b c) -> (t a c)) -> (Trans.{u, v, w, u_1, u_2, u_3} α β γ r s t)
