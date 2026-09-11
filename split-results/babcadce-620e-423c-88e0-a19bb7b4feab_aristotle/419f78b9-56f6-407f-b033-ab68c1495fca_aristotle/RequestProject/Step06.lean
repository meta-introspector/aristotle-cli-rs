import Lean

/-!
# Stage 6 — Infer the Type of p

The program reflects on the reflected object.
Conceptually: `p : Prop`, and the system proves this internally.
-/

open Lean Meta

def inferLocalProp : MetaM Expr := do
  withLocalDecl `p .default (mkSort levelZero) fun p => do
    inferType p

#check inferLocalProp
