import Mathlib

set_option pp.all true
-- spec: Lean.MacroScopesView.isSuffixOf : Lean.MacroScopesView -> Lean.MacroScopesView -> Bool
def Lean.MacroScopesView.isSuffixOf : Lean.MacroScopesView -> Lean.MacroScopesView -> Bool :=
  fun (v₁ : Lean.MacroScopesView) (v₂ : Lean.MacroScopesView) => Bool.and (Bool.and (Bool.and (Lean.Name.isSuffixOf (Lean.MacroScopesView.name v₁) (Lean.MacroScopesView.name v₂)) (BEq.beq.{0} (List.{0} Lean.MacroScope) (List.instBEq.{0} Lean.MacroScope (instBEqOfDecidableEq.{0} Lean.MacroScope instDecidableEqNat)) (Lean.MacroScopesView.scopes v₁) (Lean.MacroScopesView.scopes v₂))) (BEq.beq.{0} Lean.Name Lean.Name.instBEq (Lean.MacroScopesView.ctx v₁) (Lean.MacroScopesView.ctx v₂))) (BEq.beq.{0} Lean.Name Lean.Name.instBEq (Lean.MacroScopesView.imported v₁) (Lean.MacroScopesView.imported v₂))
