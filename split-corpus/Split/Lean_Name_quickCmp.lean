import Mathlib

set_option pp.all true
-- spec: Lean.Name.quickCmp : Lean.Name -> Lean.Name -> Ordering
def Lean.Name.quickCmp : Lean.Name -> Lean.Name -> Ordering :=
  fun (n₁ : Lean.Name) (n₂ : Lean.Name) => _private.Lean.Data.Name.0.Lean.Name.cmp.match_1.{1} (fun (x._@.Lean.Data.Name.3089803668._hygCtx._hyg.14 : Ordering) => Ordering) (Ord.compare.{0} UInt64 UInt64.instOrd (Lean.Name.hash n₁) (Lean.Name.hash n₂)) (fun (_ : Unit) => Lean.Name.quickCmpAux n₁ n₂) (fun (ord : Ordering) => ord)
