import Split.outParam

-- Trans from environment
-- inductive Trans : forall {α : Sort.{u_1}} {β : Sort.{u_2}} {γ : Sort.{u_3}}, (α -> β -> Sort.{u}) -> (β -> γ -> Sort.{v}) -> (outParam.{max (max (succ w) u_1) u_3} (α -> γ -> Sort.{w})) -> Sort.{max (max (max (max (max (max 1 u) u_1) u_2) u_3) v) w}
-- ctors: [Trans.mk]

-- Stub: this file represents the declaration `Trans`.
-- In a full split, the body would be extracted from the environment.
