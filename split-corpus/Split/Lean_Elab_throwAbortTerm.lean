import Mathlib

set_option pp.all true
-- spec: Lean.Elab.throwAbortTerm : forall {α : Type.{u_1}} {m : Type.{u_1} -> Type.{u_2}} [inst._@.Lean.Elab.Exception.2885299721._hygCtx._hyg.4 : MonadExcept.{0, u_1, u_2} Lean.Exception m], m α
def Lean.Elab.throwAbortTerm : forall {α : Type.{u_1}} {m : Type.{u_1} -> Type.{u_2}} [inst._@.Lean.Elab.Exception.2885299721._hygCtx._hyg.4 : MonadExcept.{0, u_1, u_2} Lean.Exception m], m α :=
  fun {α : Type.{u_1}} {m : Type.{u_1} -> Type.{u_2}} [inst._@.Lean.Elab.Exception.2885299721._hygCtx._hyg.4 : MonadExcept.{0, u_1, u_2} Lean.Exception m] => MonadExcept.throw.{0, u_1, u_2} Lean.Exception m inst._@.Lean.Elab.Exception.2885299721._hygCtx._hyg.4 α (Lean.Exception.internal Lean.Elab.abortTermExceptionId (Lean.KVMap.mk (List.nil.{0} (Prod.{0, 0} Lean.Name Lean.DataValue))))
