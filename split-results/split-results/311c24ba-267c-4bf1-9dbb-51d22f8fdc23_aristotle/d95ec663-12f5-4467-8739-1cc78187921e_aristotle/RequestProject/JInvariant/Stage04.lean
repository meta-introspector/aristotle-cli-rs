/-
# Stage 04 — First q-coefficient: 196884·q

Extract jInv03, extend with coeff[1] = 196884.
Build the multiplication `196884 * q` as an Expr using `mkAppM`.
Verify via `isDefEq`.
-/
import RequestProject.JInvariant.Stage03

open Lean Meta Elab Command Term

/-- The j-invariant series after stage 04: q⁻¹ + 744 + 196884·q -/
def jInv04 : QExp := coExtend (fun s => s.setCoeff 1 196884) jInv03

run_cmd do
  let msgs ← liftTermElabM do
    let intExpr := Lean.mkConst ``Int

    -- Build 196884 as Int
    let c := mkApp (Lean.mkConst ``Int.ofNat) (mkNatLit 196884)

    -- Introduce a free variable q : Int
    withLocalDecl `q .default intExpr fun qFVar => do
      -- Build 196884 * q using mkAppM
      let prod ← mkAppM ``HMul.hMul #[c, qFVar]
      let prodTy ← inferType prod
      let tyStr ← ppExpr prodTy
      let prodStr ← ppExpr prod

      let mut out : List String := []
      out := out ++ [s!"  Built Expr: {prodStr} : {tyStr}"]

      -- Check isDefEq: 196884 * q =?= 196884 * q (reflexivity test)
      let eq ← isDefEq prod prod
      out := out ++ [s!"  isDefEq(196884*q, 196884*q) = {eq}"]

      -- Verify coefficients so far
      let checks ← verifyCoeffs jInv04 [(-1, 1), (0, 744), (1, 196884)]
      out := out ++ checks
      return out

  let r : StageResult := ⟨4, jInv04, msgs⟩
  logStage r
