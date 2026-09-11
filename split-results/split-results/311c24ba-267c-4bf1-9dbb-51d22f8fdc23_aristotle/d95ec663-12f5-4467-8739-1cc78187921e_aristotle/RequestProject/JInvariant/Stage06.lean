/-
# Stage 06 — Third q-coefficient: 864299970·q³

Extract jInv05, extend with coeff[3] = 864299970.
Build the full partial sum as a single lambda expression
and type-check it.
-/
import RequestProject.JInvariant.Stage05

open Lean Meta Elab Command Term

/-- The j-invariant series after stage 06 (complete to O(q⁴)):
    q⁻¹ + 744 + 196884·q + 21493760·q² + 864299970·q³ -/
def jInv06 : QExp := coExtend (fun s => s.setCoeff 3 864299970) jInv05

run_cmd do
  let msgs ← liftTermElabM do
    let intExpr := Lean.mkConst ``Int

    -- Build the full non-negative-power part as a lambda
    let fullLam ← withLocalDecl `q .default intExpr fun qFVar => do
      let mkIntLit (n : Nat) := mkApp (Lean.mkConst ``Int.ofNat) (mkNatLit n)
      let c0 := mkIntLit 744
      let c1 := mkIntLit 196884
      let c2 := mkIntLit 21493760
      let c3 := mkIntLit 864299970

      let two := mkNatLit 2
      let three := mkNatLit 3

      let q1 := qFVar
      let q2 ← mkAppM ``HPow.hPow #[qFVar, two]
      let q3 ← mkAppM ``HPow.hPow #[qFVar, three]

      let t1 ← mkAppM ``HMul.hMul #[c1, q1]
      let t2 ← mkAppM ``HMul.hMul #[c2, q2]
      let t3 ← mkAppM ``HMul.hMul #[c3, q3]

      let sum1 ← mkAppM ``HAdd.hAdd #[c0, t1]
      let sum2 ← mkAppM ``HAdd.hAdd #[sum1, t2]
      let sum3 ← mkAppM ``HAdd.hAdd #[sum2, t3]
      mkLambdaFVars #[qFVar] sum3

    let lamTy ← inferType fullLam
    let tyStr ← ppExpr lamTy
    let mut out : List String := []
    out := out ++ [s!"  Full polynomial λ built ✓"]
    out := out ++ [s!"  Type: {tyStr}"]

    -- Verify all coefficients
    let checks ← verifyCoeffs jInv06
      [(-1, 1), (0, 744), (1, 196884), (2, 21493760), (3, 864299970)]
    out := out ++ checks
    return out

  let r : StageResult := ⟨6, jInv06, msgs⟩
  logStage r
