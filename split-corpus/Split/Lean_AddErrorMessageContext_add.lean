import Mathlib

set_option pp.all true
-- spec: Lean.AddErrorMessageContext.add : forall {m : Type -> Type} [self : Lean.AddErrorMessageContext m], Lean.Syntax -> Lean.MessageData -> (m (Prod.{0, 0} Lean.Syntax Lean.MessageData))
def Lean.AddErrorMessageContext.add : forall {m : Type -> Type} [self : Lean.AddErrorMessageContext m], Lean.Syntax -> Lean.MessageData -> (m (Prod.{0, 0} Lean.Syntax Lean.MessageData)) :=
  fun (m : Type -> Type) [self : Lean.AddErrorMessageContext m] => self.1
