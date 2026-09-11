import Lean

namespace QExp

/-- Truncated Laurent q-series with fixed length n -/
structure QExp (n : Nat) where
  shift  : Int
  coeffs : Fin n → Int

variable {n : Nat}

instance : Inhabited (QExp n) := ⟨{ shift := 0, coeffs := fun _ => 0 }⟩

/-- Step 1: Zero series -/
def zero : QExp n :=
  { shift := 0, coeffs := fun _ => 0 }

/-- Step 2: Monomial constructor -/
def monomial (e : Int) (c : Int) : QExp n :=
  { shift  := e
    coeffs := fun k => if (k : Nat) = 0 then c else 0 }

/-- Step 3: Pretty printer (self-description layer) -/
def termToString (exp : Int) (c : Int) : Option String :=
  if c = 0 then none
  else if exp = 0 then some s!"{c}"
  else if exp = 1 then some s!"{c}*q"
  else some s!"{c}*q^{exp}"

def toString (s : QExp n) : String :=
  let terms := (List.finRange n).foldl (init := ([] : List String)) fun acc (k : Fin n) =>
    let exp := s.shift + (k.val : Int)
    match termToString exp (s.coeffs k) with
    | none => acc
    | some t => t :: acc
  match terms.reverse with
  | [] => "0"
  | t :: ts => ts.foldl (fun acc u => acc ++ " + " ++ u) t

instance : ToString (QExp n) where
  toString := toString

/-- Step 4: Addition operator (core comonadic-style update) -/
def add (a b : QExp n) : QExp n :=
  let shift := min a.shift b.shift
  let coeffs : Fin n → Int := fun k =>
    let exp := shift + (k.val : Int)
    let get (s : QExp n) : Int :=
      let idx := exp - s.shift
      if h : 0 ≤ idx ∧ idx < n then
        s.coeffs ⟨idx.toNat, by omega⟩
      else 0
    get a + get b
  { shift, coeffs }

/-- Step 5: Main growth operator -/
def addTerm (s : QExp n) (e : Int) (c : Int) : QExp n :=
  add s (monomial e c)

end QExp

namespace QExp

abbrev JExp := QExp 5

/-- Step 6–10: Successive growth of the j-invariant (the growing quine) -/
def j0 : JExp := zero

def j1 : JExp := addTerm j0 (-1) 1          -- q⁻¹
def j2 : JExp := addTerm j1 0 744           -- + 744
def j3 : JExp := addTerm j2 1 196884        -- + 196884 q
def j4 : JExp := addTerm j3 2 21493760      -- + 21493760 q²
def j5 : JExp := addTerm j4 3 864299970     -- + 864299970 q³

/-- Final result: j(q) up to O(q⁴) -/
def jInvariant_qexp4 : JExp := j5

#check jInvariant_qexp4
#eval toString jInvariant_qexp4   -- Optional, for inspection

end QExp
