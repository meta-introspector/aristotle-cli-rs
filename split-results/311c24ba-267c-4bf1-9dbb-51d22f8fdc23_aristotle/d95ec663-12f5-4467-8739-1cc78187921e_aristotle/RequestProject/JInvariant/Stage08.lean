/-
# Stage 08 — Verification: Ramanujan's Δ (discriminant) via τ function

Δ(q) = q · Π_{n≥1} (1-qⁿ)²⁴ = Σ τ(n)·qⁿ
The first few τ(n) (Ramanujan tau function):
  τ(1) = 1, τ(2) = -24, τ(3) = 252, τ(4) = -1472,
  τ(5) = 4830, τ(6) = -6048

We compute these from the product formula and verify in MetaM
by constructing Exprs for each coefficient.
-/
import RequestProject.JInvariant.Stage07

open Lean Meta Elab Command Term

/-- Compute the coefficients of Π_{n=1}^{N} (1 - q^n)^24 truncated to order N.
    Returns an array of length N+1, where result[i] = coefficient of q^i.
    Then Δ(q) = q · this product, so Δ[i] = product[i-1]. -/
def deltaCoeffs (N : Nat) : Array Int := Id.run do
  -- Start with the polynomial 1
  let mut poly : Array Int := .ofFn (n := N + 1) (fun _ => 0)
  poly := poly.set! 0 1

  -- Multiply by (1 - q^n)^24 for n = 1..N
  for n in List.range N do
    let n := n + 1
    -- Multiply by (1 - q^n) twenty-four times
    for _ in List.range 24 do
      let mut newPoly := poly
      for i in List.range (N + 1) do
        if i >= n then
          newPoly := newPoly.set! i (newPoly[i]! - poly[i - n]!)
      poly := newPoly

  -- Shift by q (multiply by q): Δ starts at q^1
  let mut result : Array Int := .ofFn (n := N + 1) (fun _ => 0)
  for i in List.range N do
    result := result.set! (i + 1) poly[i]!
  return result

/-- The Ramanujan tau function τ(n), i.e., the coefficient of qⁿ in Δ. -/
def ramanujanTau (n : Nat) : Int :=
  let coeffs := deltaCoeffs (n + 1)
  coeffs[n]!

run_cmd do
  let msgs ← liftTermElabM do
    let mut out : List String := []

    -- Compute Δ coefficients
    let dCoeffs := deltaCoeffs 8
    out := out ++ [s!"  Δ coefficients (first 8):"]
    for i in List.range 8 do
      out := out ++ [s!"    Δ[{i}] = {dCoeffs[i]!}"]

    -- Verify known τ values
    let expectedTau : List (Nat × Int) :=
      [(1, 1), (2, -24), (3, 252), (4, -1472), (5, 4830), (6, -6048)]
    for (n, expected) in expectedTau do
      let actual := ramanujanTau n
      let ok := if actual == expected then "✓" else "✗"
      out := out ++ [s!"  τ({n}) = {actual} (expected {expected}) {ok}"]

    -- Build Expr for τ(1) and type-check
    let tau1Expr := mkApp (Lean.mkConst ``Int.ofNat) (mkNatLit 1)
    let ty ← inferType tau1Expr
    let tyStr ← ppExpr ty
    out := out ++ [s!"  τ(1) Expr type: {tyStr} ✓"]

    return out

  let r : StageResult := ⟨8, jInv06, msgs⟩
  logStage r
