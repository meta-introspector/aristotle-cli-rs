import Lean

/-!
# Stage 7 — Create Proof Metavariable

Introduce an incomplete proof state — the first genuine "hole in knowledge".
A Gödelian incompleteness node appears in the quine.
-/

open Lean Meta

def mkProofHole : MetaM Expr := do
  withLocalDecl `p .default (mkSort levelZero) fun p => do
    let mvar ← mkFreshExprMVar p
    return mvar

#check mkProofHole
