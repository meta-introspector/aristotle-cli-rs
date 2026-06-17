import Split.outParam
import Split.Trans

-- Trans.trans from environment
-- def Trans.trans : forall {α : Sort.{u_1}} {β : Sort.{u_2}} {γ : Sort.{u_3}} {r : α -> β -> Sort.{u}} {s : β -> γ -> Sort.{v}} {t : outParam.{max (max (succ w) u_1) u_3} (α -> γ -> Sort.{w})} [self : Trans.{u, v, w, u_1, u_2, u_3} α β γ r s t] {a : α} {b : β} {c : γ}, (r a b) -> (s b c) -> (t a c)
-- (definition body omitted)

-- Stub: this file represents the declaration `Trans.trans`.
-- In a full split, the body would be extracted from the environment.
