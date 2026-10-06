import Mathlib

set_option pp.all true
-- spec: Lean.Meta.getNumPostponed : Lean.Meta.MetaM Nat
def Lean.Meta.getNumPostponed : Lean.Meta.MetaM Nat :=
  Bind.bind.{0, 0} Lean.Meta.MetaM (Monad.toBind.{0, 0} Lean.Meta.MetaM Lean.Meta.instMonadMetaM) (Lean.PersistentArray.{0} Lean.Meta.PostponedEntry) Nat Lean.Meta.getPostponed (fun (__do_lift._@.Lean.Meta.Basic.4175971312._hygCtx._hyg.9.0 : Lean.PersistentArray.{0} Lean.Meta.PostponedEntry) => Pure.pure.{0, 0} Lean.Meta.MetaM (Applicative.toPure.{0, 0} Lean.Meta.MetaM (ReaderT.instApplicativeOfMonad.{0, 0} Lean.Meta.Context (StateRefT' IO.RealWorld Lean.Meta.State Lean.Core.CoreM) (StateRefT'.instMonad IO.RealWorld Lean.Meta.State Lean.Core.CoreM Lean.Core.instMonadCoreM))) Nat (Lean.PersistentArray.size.{0} Lean.Meta.PostponedEntry __do_lift._@.Lean.Meta.Basic.4175971312._hygCtx._hyg.9.0))
