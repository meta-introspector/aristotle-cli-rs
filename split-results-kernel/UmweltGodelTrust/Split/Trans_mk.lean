import Split.outParam
import Split.Trans

-- Trans.mk from environment
-- constructor Trans.mk : forall {α : Sort.{u_1}} {β : Sort.{u_2}} {γ : Sort.{u_3}} {r : α -> β -> Sort.{u}} {s : β -> γ -> Sort.{v}} {t : outParam.{max (max (succ w) u_1) u_3} (α -> γ -> Sort.{w})}, (forall {a : α} {b : β} {c : γ}, (r a b) -> (s b c) -> (t a c)) -> (Trans.{u, v, w, u_1, u_2, u_3} α β γ r s t)

-- Stub: this file represents the declaration `Trans.mk`.
-- In a full split, the body would be extracted from the environment.
