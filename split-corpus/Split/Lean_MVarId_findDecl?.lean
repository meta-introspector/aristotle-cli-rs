import Mathlib

set_option pp.all true
-- spec: Lean.MVarId.findDecl? : Lean.MVarId -> (Lean.Meta.MetaM (Option.{0} Lean.MetavarDecl))
def Lean.MVarId.findDecl? : Lean.MVarId -> (Lean.Meta.MetaM (Option.{0} Lean.MetavarDecl)) :=
  fun (mvarId : Lean.MVarId) => Bind.bind.{0, 0} Lean.Meta.MetaM (Monad.toBind.{0, 0} Lean.Meta.MetaM Lean.Meta.instMonadMetaM) Lean.MetavarContext (Option.{0} Lean.MetavarDecl) (Lean.MonadMCtx.getMCtx Lean.Meta.MetaM Lean.Meta.instMonadMCtxMetaM) (fun (__do_lift._@.Lean.Meta.Basic.2558232476._hygCtx._hyg.26.0 : Lean.MetavarContext) => Pure.pure.{0, 0} Lean.Meta.MetaM (Applicative.toPure.{0, 0} Lean.Meta.MetaM (ReaderT.instApplicativeOfMonad.{0, 0} Lean.Meta.Context (StateRefT' IO.RealWorld Lean.Meta.State Lean.Core.CoreM) (StateRefT'.instMonad IO.RealWorld Lean.Meta.State Lean.Core.CoreM Lean.Core.instMonadCoreM))) (Option.{0} Lean.MetavarDecl) (Lean.MetavarContext.findDecl? __do_lift._@.Lean.Meta.Basic.2558232476._hygCtx._hyg.26.0 mvarId))
