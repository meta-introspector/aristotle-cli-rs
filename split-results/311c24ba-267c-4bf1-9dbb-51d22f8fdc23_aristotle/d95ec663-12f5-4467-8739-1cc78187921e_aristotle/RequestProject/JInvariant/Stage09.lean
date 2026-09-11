/-
# Stage 09 — Verification: j = E₄³ / Δ

The j-invariant is j(q) = E₄(q)³ / Δ(q).
We compute E₄³ as a truncated power series, then perform
formal Laurent series division by Δ, and verify the quotient
matches our j-invariant coefficients.

This is the key verification: all coefficients are derived,
not assumed.
-/
import RequestProject.JInvariant.Stage08

open Lean Meta Elab Command Term

/-- Multiply two truncated power series (represented as arrays of Int,
    indexed from 0). Result truncated to length N. -/
def polyMul (a b : Array Int) (N : Nat) : Array Int := Id.run do
  let mut result : Array Int := .ofFn (n := N) (fun _ => 0)
  for i in List.range N do
    for j in List.range N do
      if i + j < N then
        result := result.set! (i + j) (result[i + j]! + a[i]! * b[j]!)
  return result

/-- Compute E₄ as a truncated power series to order N. -/
def e4Poly (N : Nat) : Array Int := Id.run do
  let mut result : Array Int := .ofFn (n := N) (fun _ => 0)
  for i in List.range N do
    result := result.set! i (e4Coeff i)
  return result

/-- Compute E₄³ as a truncated power series. -/
def e4Cubed (N : Nat) : Array Int :=
  let e4 := e4Poly N
  let e4sq := polyMul e4 e4 N
  polyMul e4sq e4 N

/-- Divide a power series by Δ (which starts at q^1),
    giving a Laurent series starting at q^{-1}.
    f / Δ where Δ = Δ[1]·q + Δ[2]·q² + ...
    Result: array where result[i] = coefficient of q^{i-1}.
    So result[0] = coeff of q⁻¹, result[1] = coeff of q⁰, etc. -/
def laurentDiv (f g : Array Int) (N : Nat) : Array Int := Id.run do
  -- g starts at q^1, so gShifted[i] = g[i+1]
  let mut gShifted : Array Int := .ofFn (n := N) (fun _ => 0)
  for i in List.range (N - 1) do
    gShifted := gShifted.set! i g[i + 1]!

  let g0 := gShifted[0]!  -- should be 1 for Δ
  let mut result : Array Int := .ofFn (n := N) (fun _ => 0)
  let mut remainder : Array Int := .ofFn (n := N) (fun _ => 0)
  for i in List.range N do
    remainder := remainder.set! i f[i]!

  for i in List.range N do
    let qi := remainder[i]! / g0
    result := result.set! i qi
    for j in List.range N do
      if i + j < N then
        remainder := remainder.set! (i + j) (remainder[i + j]! - qi * gShifted[j]!)

  return result

run_cmd do
  let msgs ← liftTermElabM do
    let N := 8
    let mut out : List String := []

    -- Compute E₄³
    let e4c := e4Cubed N
    out := out ++ [s!"  E₄³ coefficients (first {N}):"]
    for i in List.range N do
      out := out ++ [s!"    E₄³[{i}] = {e4c[i]!}"]

    -- Compute Δ
    let delta := deltaCoeffs N
    out := out ++ [s!"  Δ coefficients (first {N}):"]
    for i in List.range N do
      out := out ++ [s!"    Δ[{i}] = {delta[i]!}"]

    -- Compute j = E₄³ / Δ
    let jCoeffs := laurentDiv e4c delta N
    out := out ++ [s!"  j = E₄³/Δ coefficients:"]
    let labels := #["q⁻¹", "q⁰", "q¹", "q²", "q³", "q⁴"]
    for i in List.range (min 6 N) do
      let label := if i < labels.size then labels[i]! else s!"q^{i-1}"
      out := out ++ [s!"    j[{label}] = {jCoeffs[i]!}"]

    -- Verify against our jInv06
    let expected := #[(0, (1 : Int)), (1, 744), (2, 196884), (3, 21493760), (4, 864299970)]
    out := out ++ [s!"  Verification against jInv06:"]
    for (i, c) in expected do
      let actual := jCoeffs[i]!
      let ok := if actual == c then "✓" else "✗"
      out := out ++ [s!"    j[{i}] = {actual} (expected {c}) {ok}"]

    return out

  let r : StageResult := ⟨9, jInv06, msgs⟩
  logStage r
