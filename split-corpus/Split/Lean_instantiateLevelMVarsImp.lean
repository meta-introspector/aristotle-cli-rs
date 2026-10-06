import Mathlib

-- spec: opaque Lean.instantiateLevelMVarsImp : Lean.MetavarContext -> Lean.Level -> (Prod.{0, 0} Lean.MetavarContext Lean.Level)
opaque Lean.instantiateLevelMVarsImp : Lean.MetavarContext -> Lean.Level -> (Prod.{0, 0} Lean.MetavarContext Lean.Level) :=
  fun (mctx : Lean.MetavarContext) (l : Lean.Level) => Inhabited.default.{1} (Prod.{0, 0} Lean.MetavarContext Lean.Level) (instInhabitedProd.{0, 0} Lean.MetavarContext Lean.Level Lean.instInhabitedMetavarContext Lean.instInhabitedLevel)
