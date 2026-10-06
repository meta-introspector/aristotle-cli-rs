import Mathlib

set_option pp.all true
-- spec: Lean.LocalContext.get! : Lean.LocalContext -> Lean.FVarId -> Lean.LocalDecl
def Lean.LocalContext.get! : Lean.LocalContext -> Lean.FVarId -> Lean.LocalDecl :=
  fun (lctx : Lean.LocalContext) (fvarId : Lean.FVarId) => _private.Lean.LocalContext.0.Lean.LocalContext.get!.match_1.{1} (fun (x._@.Lean.LocalContext.2959036029._hygCtx._hyg.13 : Option.{0} Lean.LocalDecl) => Lean.LocalDecl) (Lean.LocalContext.find? lctx fvarId) (fun (d : Lean.LocalDecl) => d) (fun (_ : Unit) => panicWithPosWithDecl.{1} Lean.LocalDecl Lean.instInhabitedLocalDecl "Lean.LocalContext" "Lean.LocalContext.get!" (OfNat.ofNat.{0} Nat 340 (instOfNatNat 340)) (OfNat.ofNat.{0} Nat 14 (instOfNatNat 14)) "unknown free variable")
