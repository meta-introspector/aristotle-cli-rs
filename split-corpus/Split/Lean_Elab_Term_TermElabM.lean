import Mathlib

set_option pp.all true
-- spec: Lean.Elab.Term.TermElabM : Type -> Type
def Lean.Elab.Term.TermElabM : Type -> Type :=
  ReaderT.{0, 0} Lean.Elab.Term.Context (StateRefT' IO.RealWorld Lean.Elab.Term.State Lean.Meta.MetaM)
