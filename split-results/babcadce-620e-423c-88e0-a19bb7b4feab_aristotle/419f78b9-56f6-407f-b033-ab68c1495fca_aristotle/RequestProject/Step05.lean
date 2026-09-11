import Lean

/-!
# Stage 5 — Construct Local Proposition

Generate a local proposition programmatically.
This creates an `Expr.fvar`, a scoped context, and local semantic state.
We now have contextual self-reference.
-/

open Lean Meta

def localProp : MetaM Expr := do
  withLocalDecl `p .default (mkSort levelZero) fun p => do
    return p

#check localProp
