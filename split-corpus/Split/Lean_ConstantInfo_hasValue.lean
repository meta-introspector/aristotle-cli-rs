import Mathlib

set_option pp.all true
-- spec: Lean.ConstantInfo.hasValue : Lean.ConstantInfo -> (optParam.{1} Bool Bool.false) -> Bool
def Lean.ConstantInfo.hasValue : Lean.ConstantInfo -> (optParam.{1} Bool Bool.false) -> Bool :=
  fun (info : Lean.ConstantInfo) (allowOpaque : Bool) => _private.Lean.Declaration.0.Lean.ConstantInfo.hasValue.match_1.{1} (fun (info._@.Lean.Declaration.2622340165._hygCtx._hyg.10 : Lean.ConstantInfo) => Bool) info (fun (val._@.Lean.Declaration.2622340165._hygCtx._hyg.16 : Lean.DefinitionVal) => Bool.true) (fun (val._@.Lean.Declaration.2622340165._hygCtx._hyg.23 : Lean.TheoremVal) => Bool.true) (fun (val._@.Lean.Declaration.2622340165._hygCtx._hyg.30 : Lean.OpaqueVal) => allowOpaque) (fun (x._@.Lean.Declaration.2622340165._hygCtx._hyg.35 : Lean.ConstantInfo) => Bool.false)
