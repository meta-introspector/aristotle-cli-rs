import Mathlib

set_option pp.all true
-- spec: Lean.addMacroScope : Lean.Name -> Lean.Name -> Lean.MacroScope -> Lean.Name
def Lean.addMacroScope : Lean.Name -> Lean.Name -> Lean.MacroScope -> Lean.Name :=
  fun (ctx : Lean.Name) (n : Lean.Name) (scp : Lean.MacroScope) => cond.match_1.{1} (fun (x._@.Init.Prelude.4222034686._hygCtx._hyg.9 : Bool) => Lean.Name) (Lean.Name.hasMacroScopes n) (fun (_ : Unit) => have view : Lean.MacroScopesView := Lean.extractMacroScopes n; cond.match_1.{1} (fun (x._@.Init.Prelude.4222034686._hygCtx._hyg.26 : Bool) => Lean.Name) (BEq.beq.{0} Lean.Name Lean.Name.instBEq (Lean.MacroScopesView.ctx view) ctx) (fun (_ : Unit) => Lean.Name.mkNum n scp) (fun (_ : Unit) => Lean.MacroScopesView.review (Lean.MacroScopesView.mk (Lean.MacroScopesView.name view) (List.foldl.{0, 0} Lean.Name Nat Lean.Name.mkNum (Lean.Name.appendCore (Lean.MacroScopesView.imported view) (Lean.MacroScopesView.ctx view)) (Lean.MacroScopesView.scopes view)) ctx (List.cons.{0} Lean.MacroScope scp (List.nil.{0} Lean.MacroScope))))) (fun (_ : Unit) => Lean.Name.mkNum (Lean.Name.mkStr (Lean.Name.appendCore (Lean.Name.mkStr n "_@") ctx) "_hyg") scp)
