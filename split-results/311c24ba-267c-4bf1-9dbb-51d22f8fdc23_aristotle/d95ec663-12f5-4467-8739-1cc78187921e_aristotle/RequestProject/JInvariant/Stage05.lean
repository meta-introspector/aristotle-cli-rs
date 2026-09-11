/-
# Stage 05 — Second q-coefficient: 21493760·q²

Extract jInv04, extend with coeff[2] = 21493760.
Build a lambda `fun q : Int => 21493760 * q^2` in MetaM,
infer its type as `Int → Int`, and verify.
-/
import RequestProject.JInvariant.Stage04

open Lean Meta Elab Command Term

/-- The j-invariant series after stage 05: q⁻¹ + 744 + 196884·q + 21493760·q² -/
def jInv05 : QExp := coExtend (fun s => s.setCoeff 2 21493760) jInv04

run_cmd do
  let msgs ← liftTermElabM do
    let intExpr := Lean.mkConst ``Int

    -- Build the lambda: fun q : Int => 21493760 * q ^ 2
    let lam ← withLocalDecl `q .default intExpr fun qFVar => do
      let c := mkApp (Lean.mkConst ``Int.ofNat) (mkNatLit 21493760)
      let two := mkNatLit 2
      let qPow ← mkAppM ``HPow.hPow #[qFVar, two]
      let body ← mkAppM ``HMul.hMul #[c, qPow]
      mkLambdaFVars #[qFVar] body

    let lamTy ← inferType lam
    let tyStr ← ppExpr lamTy
    let lamStr ← ppExpr lam

    let mut out : List String := []
    out := out ++ [s!"  Built λ: {lamStr}"]
    out := out ++ [s!"  Type: {tyStr}"]

    -- Verify the series so far
    let checks ← verifyCoeffs jInv05 [(-1, 1), (0, 744), (1, 196884), (2, 21493760)]
    out := out ++ checks
    return out

  let r : StageResult := ⟨5, jInv05, msgs⟩
  logStage r
