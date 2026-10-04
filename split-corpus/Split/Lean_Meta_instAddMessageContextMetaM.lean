import Mathlib

set_option pp.all true
-- spec: Lean.Meta.instAddMessageContextMetaM : Lean.AddMessageContext Lean.Meta.MetaM
def Lean.Meta.instAddMessageContextMetaM : Lean.AddMessageContext Lean.Meta.MetaM :=
  Lean.AddMessageContext.mk Lean.Meta.MetaM (Lean.addMessageContextFull Lean.Meta.MetaM Lean.Meta.instMonadMetaM Lean.Meta.instMonadEnvMetaM Lean.Meta.instMonadMCtxMetaM Lean.Meta.instMonadLCtxMetaM (Lean.instMonadOptionsOfMonadLift (StateRefT' IO.RealWorld Lean.Meta.State Lean.Core.CoreM) Lean.Meta.MetaM (ReaderT.instMonadLift.{0, 0} Lean.Meta.Context (StateRefT' IO.RealWorld Lean.Meta.State Lean.Core.CoreM)) (Lean.instMonadOptionsOfMonadLift Lean.Core.CoreM (StateRefT' IO.RealWorld Lean.Meta.State Lean.Core.CoreM) (StateRefT'.instMonadLift IO.RealWorld Lean.Meta.State Lean.Core.CoreM) Lean.Core.instMonadOptionsCoreM)))
