import Mathlib

set_option pp.all true
-- spec: Lean.MonadLog.logMessage : forall {m : Type -> Type} [self : Lean.MonadLog m], Lean.Message -> (m Unit)
def Lean.MonadLog.logMessage : forall {m : Type -> Type} [self : Lean.MonadLog m], Lean.Message -> (m Unit) :=
  fun (m : Type -> Type) [self : Lean.MonadLog m] => self.5
