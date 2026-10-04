import Mathlib

set_option pp.all true
-- spec: Lean.MacroScopesView.review : Lean.MacroScopesView -> Lean.Name
def Lean.MacroScopesView.review : Lean.MacroScopesView -> Lean.Name :=
  fun (view : Lean.MacroScopesView) => _private.Init.Prelude.0.Lean.MacroScopesView.review.match_1.{1} (fun (x._@.Init.Prelude.3358819677._hygCtx._hyg.7 : List.{0} Lean.MacroScope) => Lean.Name) (Lean.MacroScopesView.scopes view) (fun (_ : Unit) => Lean.MacroScopesView.name view) (fun (head._@.Init.Prelude.3358819677._hygCtx._hyg.21 : Lean.MacroScope) (tail._@.Init.Prelude.3358819677._hygCtx._hyg.22 : List.{0} Lean.MacroScope) => have base : Lean.Name := Lean.Name.mkStr (Lean.Name.appendCore (Lean.Name.appendCore (Lean.Name.mkStr (Lean.MacroScopesView.name view) "_@") (Lean.MacroScopesView.imported view)) (Lean.MacroScopesView.ctx view)) "_hyg"; List.foldl.{0, 0} Lean.Name Nat Lean.Name.mkNum base (Lean.MacroScopesView.scopes view))
