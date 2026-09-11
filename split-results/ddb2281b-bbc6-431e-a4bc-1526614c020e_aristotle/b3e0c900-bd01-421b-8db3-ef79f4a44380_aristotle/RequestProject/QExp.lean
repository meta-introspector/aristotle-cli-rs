/-- Truncated Laurent q-series:
    shift = lowest exponent (can be negative),
    coeffs k = coefficient of q^(shift + k), for k : Fin n. -/
structure QExp (n : Nat) where
  shift  : Int
  coeffs : Fin n → Int

namespace QExp

/-! ## Zero and basic constructors -/

def zero (n : Nat) : QExp n :=
  { shift := 0, coeffs := fun _ => 0 }

def monomial (n : Nat) (e : Int) (c : Int) : QExp n :=
  { shift  := e
    coeffs := fun k =>
      if (k : Nat) = 0 then c else 0 }

/-! ## Pretty-printing as a "quine view"

This is the "self-description" layer: the series can render itself as a q‑polynomial string. -/

private def termToString (exp : Int) (c : Int) : Option String :=
  if c = 0 then
    none
  else
    let base :=
      if exp = 0 then s!"{c}"
      else if exp = 1 then s!"{c}*q"
      else s!"{c}*q^{exp}"
    some base

def toString {n : Nat} (s : QExp n) : String :=
  let terms : List String :=
    (List.finRange n).filterMap fun (k : Fin n) =>
      let exp : Int := s.shift + (k : Nat)
      termToString exp (s.coeffs k)
  match terms with
  | []      => "0"
  | t :: ts => ts.foldl (fun acc u => acc ++ " + " ++ u) t

instance {n : Nat} : ToString (QExp n) where
  toString := QExp.toString

/-! ## Addition (comonadic "update" 1)

Re-aligns shifts and adds coefficients pointwise. -/

/-- Look up the coefficient of `q^exp` in a series, returning 0 if out of range. -/
def coeffAt {n : Nat} (s : QExp n) (exp : Int) : Int :=
  let idx := exp - s.shift
  if h : 0 ≤ idx ∧ idx < n then
    s.coeffs ⟨idx.toNat, by omega⟩
  else 0

def add {n : Nat} (a b : QExp n) : QExp n :=
  let shift := min a.shift b.shift
  { shift := shift
    coeffs := fun k =>
      let exp : Int := shift + (k : Nat)
      coeffAt a exp + coeffAt b exp }

/-! ## The "addTerm" operator

The main "operator on the quine": given a series, add a single monomial. -/

def addTerm {n : Nat} (s : QExp n) (e : Int) (c : Int) : QExp n :=
  add s (monomial n e c)

/-! ## Fix the truncation order for j

We want `q⁻¹ + 744 + 196884 q + 21493760 q² + 864299970 q³ + O(q⁴)`.
Coefficients for exponents −1, 0, 1, 2, 3: that's 5 terms. -/

abbrev JExp := QExp 5

def j0 : JExp := zero 5

/-! ## Grow the "quine" step by step

Each step is a new `def` that applies an operator to the previous one.
The file itself is the growing object; Lean checks each stage. -/

/-- Step 1: start with q⁻¹ term (coefficient 1). -/
def j1 : JExp := addTerm j0 (-1) 1

/-- Step 2: add constant term 744. -/
def j2 : JExp := addTerm j1 0 744

/-- Step 3: add 196884·q. -/
def j3 : JExp := addTerm j2 1 196884

/-- Step 4: add 21493760·q². -/
def j4 : JExp := addTerm j3 2 21493760

/-- Step 5: add 864299970·q³. -/
def j5 : JExp := addTerm j4 3 864299970

/-- Final truncated j-invariant q-expansion up to O(q⁴). -/
def jInvariant_qexp4 : JExp := j5

/-! ## Self-referential check

The chain `j₀ → j₁ → j₂ → j₃ → j₄ → j₅` is the "quine":
each `def` is a comonadic-style update producing a new view,
and `jInvariant_qexp4` is the final truncated series.

Uncomment the following to inspect interactively:
```
#eval QExp.toString jInvariant_qexp4
-- "1*q^-1 + 744 + 196884*q + 21493760*q^2 + 864299970*q^3"
```
-/

end QExp
