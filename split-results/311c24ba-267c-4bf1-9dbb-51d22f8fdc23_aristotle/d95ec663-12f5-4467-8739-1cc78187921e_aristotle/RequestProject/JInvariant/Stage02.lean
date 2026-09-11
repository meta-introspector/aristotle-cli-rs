/-
# Stage 02 — First coefficient: q⁻¹

Extract jInv01, extend with coeff[-1] = 1.
Build the Expr `(1 : Int)` in MetaM, infer its type, verify.
-/
import RequestProject.JInvariant.Stage01

open Lean Meta Elab Command Term

/-- The j-invariant series after stage 02: q⁻¹ -/
def jInv02 : QExp := coExtend (fun s => s.setCoeff (-1) 1) jInv01

run_cmd do
  let msgs ← liftTermElabM do
    -- Construct the expression `(1 : Int)` and verify its type
    let oneExpr := mkApp (mkConst ``Int.ofNat) (mkNatLit 1)
    let ty ← inferType oneExpr
    let tyStr ← ppExpr ty
    let mut out : List String := [s!"  Built Expr (1 : Int), inferred type: {tyStr}"]

    -- Verify coefficient
    let checks ← verifyCoeffs jInv02 [(-1, 1)]
    out := out ++ checks
    return out

  let r : StageResult := ⟨2, jInv02, msgs⟩
  logStage r
