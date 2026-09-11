/-
# J-Invariant Q-Expansion: Infrastructure

The j-invariant has the q-expansion:
  j(q) = q⁻¹ + 744 + 196884·q + 21493760·q² + 864299970·q³ + O(q⁴)

We build this step by step using MetaM, with a comonadic
"extract–extend–check" pattern: each stage extracts the current
truncated series, extends it with the next coefficient, and
checks the result via type inference and definitional equality.
-/
import Lean

open Lean Meta Elab Command Term

/-! ## Core Types -/

/-- A truncated Laurent series: coefficients indexed from `minExp` to `maxExp`.
    `coeff i` is the coefficient of q^i. -/
structure QExp where
  minExp : Int
  maxExp : Int
  coeff  : Int → Int

/-- The empty series (zero truncation). -/
def QExp.empty : QExp := ⟨0, -1, fun _ => 0⟩

/-- Extend a QExp by setting the coefficient at index `i`. -/
def QExp.setCoeff (s : QExp) (i : Int) (c : Int) : QExp :=
  { minExp := min s.minExp i
    maxExp := max s.maxExp i
    coeff  := fun j => if j == i then c else s.coeff j }

/-- Extract the coefficient list from minExp to maxExp. -/
def QExp.extractCoeffs (s : QExp) : List (Int × Int) :=
  let rec go (i : Int) (fuel : Nat) : List (Int × Int) :=
    match fuel with
    | 0 => []
    | fuel + 1 =>
      let c := s.coeff i
      (i, c) :: go (i + 1) fuel
  go s.minExp (Int.toNat (s.maxExp - s.minExp + 1))

/-- Pretty-print a QExp as a q-expansion string. -/
def QExp.toString (s : QExp) : String :=
  let terms := s.extractCoeffs |>.filter (fun (_, c) => c != 0) |>.map fun (i, c) =>
    match i with
    | -1 => if c == 1 then "q⁻¹" else s!"{c}·q⁻¹"
    | 0  => s!"{c}"
    | 1  => if c == 1 then "q" else s!"{c}·q"
    | n  => if c == 1 then s!"q^{n}" else s!"{c}·q^{n}"
  String.intercalate " + " terms

instance : ToString QExp := ⟨QExp.toString⟩

instance : Repr QExp where
  reprPrec s _ := s!"{s}"

/-! ## Comonadic Structure

We model the "growing quine" as a comonad W on QExp:
  - `extract` : W QExp → QExp  (read current state)
  - `extend`  : (W QExp → QExp) → W QExp → W QExp  (apply a transformation)

In our case W = Id, so this is trivial, but we name the operations
to make the pattern explicit.
-/

/-- Extract the current series (comonadic extract). -/
def coExtract (s : QExp) : QExp := s

/-- Extend the series by applying a builder function (comonadic extend). -/
def coExtend (f : QExp → QExp) (s : QExp) : QExp := f s

/-! ## MetaM Checking Infrastructure -/

/-- Verify all coefficients of a QExp match expected values. -/
def verifyCoeffs (s : QExp) (expected : List (Int × Int)) : MetaM (List String) := do
  let mut msgs : List String := []
  for (i, c) in expected do
    let actual := s.coeff i
    if actual == c then
      msgs := msgs ++ [s!"  ✓ coeff[{i}] = {c}"]
    else
      msgs := msgs ++ [s!"  ✗ coeff[{i}]: expected {c}, got {actual}"]
  return msgs

/-- A stage result: the series after this stage, plus verification messages. -/
structure StageResult where
  stage   : Nat
  series  : QExp
  msgs    : List String

/-- Log a stage result to the info log. -/
def logStage (r : StageResult) : CommandElabM Unit := do
  let header := s!"═══ Stage {r.stage} ═══"
  let seriesStr := s!"  Series: {r.series}"
  let body := String.intercalate "\n" r.msgs
  logInfo m!"{header}\n{seriesStr}\n{body}"
