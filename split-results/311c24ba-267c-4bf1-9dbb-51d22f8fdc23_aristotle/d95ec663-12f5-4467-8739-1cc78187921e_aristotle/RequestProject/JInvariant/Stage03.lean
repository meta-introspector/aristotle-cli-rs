/-
# Stage 03 — Constant term: 744

Extract jInv02, extend with coeff[0] = 744.
Create a metavariable `?m : Int`, assign it to 744, instantiate.
-/
import RequestProject.JInvariant.Stage02

open Lean Meta Elab Command Term

/-- The j-invariant series after stage 03: q⁻¹ + 744 -/
def jInv03 : QExp := coExtend (fun s => s.setCoeff 0 744) jInv02

run_cmd do
  let msgs ← liftTermElabM do
    -- Create a metavariable ?m : Int
    let intExpr := Lean.mkConst ``Int
    let mvar ← mkFreshExprMVar (some intExpr) .natural `coeffHole
    let mvarId := mvar.mvarId!

    -- Construct 744 as an Int expression
    let val744 := mkApp (Lean.mkConst ``Int.ofNat) (mkNatLit 744)

    -- Assign the metavariable
    mvarId.assign val744

    -- Instantiate to get the resolved expression
    let resolved ← instantiateMVars mvar
    let resolvedStr ← ppExpr resolved
    let resolvedTy ← inferType resolved
    let tyStr ← ppExpr resolvedTy

    let mut out : List String := []
    out := out ++ [s!"  Created ?m : Int, assigned to {resolvedStr} : {tyStr}"]

    -- Check metavariable is no longer unassigned
    let isAssigned ← mvarId.isAssigned
    out := out ++ [s!"  Metavariable assigned: {isAssigned}"]

    -- Verify coefficients so far
    let checks ← verifyCoeffs jInv03 [(-1, 1), (0, 744)]
    out := out ++ checks
    return out

  let r : StageResult := ⟨3, jInv03, msgs⟩
  logStage r
