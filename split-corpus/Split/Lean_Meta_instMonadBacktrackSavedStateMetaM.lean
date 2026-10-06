import Mathlib

set_option pp.all true
-- spec: Lean.Meta.instMonadBacktrackSavedStateMetaM : Lean.MonadBacktrack Lean.Meta.SavedState Lean.Meta.MetaM
def Lean.Meta.instMonadBacktrackSavedStateMetaM : Lean.MonadBacktrack Lean.Meta.SavedState Lean.Meta.MetaM :=
  Lean.MonadBacktrack.mk Lean.Meta.SavedState Lean.Meta.MetaM Lean.Meta.saveState (fun (s : Lean.Meta.SavedState) => Lean.Meta.SavedState.restore s)
