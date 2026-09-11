/-
# Stage 01 — Bootstrap: MetaM is alive

We confirm MetaM can run, create a Prop-typed free variable,
infer its type, and log the result. The series is empty.
-/
import RequestProject.JInvariant.Defs

open Lean Meta Elab Command Term

/-- The j-invariant series after stage 01 (empty). -/
def jInv01 : QExp := QExp.empty

run_cmd do
  -- Run a MetaM action inside CommandElabM
  let msg ← liftTermElabM do
    -- Create Prop = Sort 0
    let propType := mkSort levelZero
    -- Introduce p : Prop as a local free variable
    withLocalDecl `p .default propType fun pFVar => do
      let ty ← inferType pFVar
      let tyFmt ← ppExpr ty
      return s!"MetaM bootstrap ✓ | introduced p : {tyFmt} | series: {jInv01}"
  logInfo m!"{msg}"
