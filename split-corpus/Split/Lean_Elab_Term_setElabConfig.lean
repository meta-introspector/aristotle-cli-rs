import Mathlib

set_option pp.all true
-- spec: Lean.Elab.Term.setElabConfig : Lean.Meta.Config -> Lean.Meta.Config
def Lean.Elab.Term.setElabConfig : Lean.Meta.Config -> Lean.Meta.Config :=
  fun (cfg : Lean.Meta.Config) => Lean.Meta.Config.mk Bool.true Bool.true Bool.false Bool.false (Lean.Meta.Config.isDefEqStuckEx cfg) (Lean.Meta.Config.unificationHints cfg) (Lean.Meta.Config.proofIrrelevance cfg) (Lean.Meta.Config.assignSyntheticOpaque cfg) (Lean.Meta.Config.offsetCnstrs cfg) (Lean.Meta.Config.transparency cfg) (Lean.Meta.Config.etaStruct cfg) (Lean.Meta.Config.univApprox cfg) (Lean.Meta.Config.iota cfg) (Lean.Meta.Config.beta cfg) (Lean.Meta.Config.proj cfg) (Lean.Meta.Config.zeta cfg) (Lean.Meta.Config.zetaDelta cfg) (Lean.Meta.Config.zetaUnused cfg) (Lean.Meta.Config.zetaHave cfg)
