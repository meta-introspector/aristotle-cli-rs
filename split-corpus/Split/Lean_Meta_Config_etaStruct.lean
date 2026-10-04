import Mathlib

set_option pp.all true
-- spec: Lean.Meta.Config.etaStruct : Lean.Meta.Config -> Lean.Meta.EtaStructMode
def Lean.Meta.Config.etaStruct : Lean.Meta.Config -> Lean.Meta.EtaStructMode :=
  fun (self : Lean.Meta.Config) => self.11
