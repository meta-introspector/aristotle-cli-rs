/-
# Stage 07 — Verification: Eisenstein E₄ coefficients

The normalized Eisenstein series E₄ has q-expansion:
  E₄(q) = 1 + 240·σ₃(1)·q + 240·σ₃(2)·q² + 240·σ₃(3)·q³ + ...
         = 1 + 240·q + 2160·q² + 6720·q³ + ...

We verify these coefficients by computing σ₃(n) = Σ_{d|n} d³
in MetaM, creating metavariables for each and assigning them.
-/
import RequestProject.JInvariant.Stage06

open Lean Meta Elab Command Term

/-- σ_k(n) = sum of k-th powers of divisors of n -/
def sigma (k n : Nat) : Nat :=
  (List.range n).foldl (fun acc d =>
    if n % (d + 1) == 0 then acc + (d + 1) ^ k else acc) 0

/-- E₄ coefficients: E₄[n] = 240 · σ₃(n) for n ≥ 1, E₄[0] = 1 -/
def e4Coeff (n : Nat) : Nat :=
  if n == 0 then 1 else 240 * sigma 3 n

/-- E₄ series to order 6 -/
def e4Series : QExp :=
  let s := QExp.empty
  let s := s.setCoeff 0 (e4Coeff 0)
  let s := s.setCoeff 1 (e4Coeff 1)
  let s := s.setCoeff 2 (e4Coeff 2)
  let s := s.setCoeff 3 (e4Coeff 3)
  let s := s.setCoeff 4 (e4Coeff 4)
  let s := s.setCoeff 5 (e4Coeff 5)
  let s := s.setCoeff 6 (e4Coeff 6)
  s

run_cmd do
  let msgs ← liftTermElabM do
    let intExpr := Lean.mkConst ``Int
    let mut out : List String := []

    -- Compute σ₃(n) for n = 1..6
    for n in List.range 6 do
      let s3 := sigma 3 (n + 1)
      out := out ++ [s!"  σ₃({n+1}) = {s3}"]

    -- Compute E₄ coefficients
    for n in List.range 7 do
      let c := e4Coeff n
      out := out ++ [s!"  E₄[{n}] = {c}"]

    -- Create metavariables for each E₄ coefficient and assign
    for n in List.range 4 do
      let mvar ← mkFreshExprMVar (some intExpr) .natural (`e4coeff ++ .mkSimple s!"{n}")
      mvar.mvarId!.assign (mkApp (Lean.mkConst ``Int.ofNat) (mkNatLit (e4Coeff n)))
      let resolved ← instantiateMVars mvar
      let rStr ← ppExpr resolved
      out := out ++ [s!"  ?e4coeff{n} := {rStr} ✓"]

    out := out ++ [s!"  E₄ series: {e4Series}"]
    return out

  let r : StageResult := ⟨7, jInv06, msgs⟩
  logStage r
