import Mathlib

set_option pp.all true
-- spec: Lean.instMonadMCtxStateRefT'MetavarContextST : forall {ω : Type}, Lean.MonadMCtx (StateRefT' ω Lean.MetavarContext (ST ω))
def Lean.instMonadMCtxStateRefT'MetavarContextST : forall {ω : Type}, Lean.MonadMCtx (StateRefT' ω Lean.MetavarContext (ST ω)) :=
  fun {ω : Type} => Lean.MonadMCtx.mk (StateRefT' ω Lean.MetavarContext (ST ω)) (MonadState.get.{0, 0} Lean.MetavarContext (StateRefT' ω Lean.MetavarContext (ST ω)) (instMonadStateOfMonadStateOf.{0, 0} Lean.MetavarContext (StateRefT' ω Lean.MetavarContext (ST ω)) (StateRefT'.instMonadStateOfOfMonadLiftTST ω Lean.MetavarContext (ST ω) (instMonadLiftT.{0, 0} (ST ω))))) (modify.{0, 0} Lean.MetavarContext (StateRefT' ω Lean.MetavarContext (ST ω)) (instMonadStateOfMonadStateOf.{0, 0} Lean.MetavarContext (StateRefT' ω Lean.MetavarContext (ST ω)) (StateRefT'.instMonadStateOfOfMonadLiftTST ω Lean.MetavarContext (ST ω) (instMonadLiftT.{0, 0} (ST ω)))))
