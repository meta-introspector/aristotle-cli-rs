import Mathlib

set_option pp.all true
-- spec: Lean.AddMessageContext.addMessageContext : forall {m : Type -> Type} [self : Lean.AddMessageContext m], Lean.MessageData -> (m Lean.MessageData)
def Lean.AddMessageContext.addMessageContext : forall {m : Type -> Type} [self : Lean.AddMessageContext m], Lean.MessageData -> (m Lean.MessageData) :=
  fun (m : Type -> Type) [self : Lean.AddMessageContext m] => self.1
