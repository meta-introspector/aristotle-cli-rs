import Mathlib

open Lean Meta Elab

/-!
# J‑invariant q‑expansion via MetaM

We construct the truncated Laurent series for the j‑invariant:

    j(q) = q⁻¹ + 744 + 196884·q + 21493760·q² + 864299970·q³

as a Lean `Expr` of type `ℚ`, built step‑by‑step inside the `MetaM` monad.
Each step adds one term, type‑checks the running sum, and logs its progress.

We use `ℚ` as the ambient ring so that `q⁻¹` and `q ^ k` are both well‑typed.
The variable `q` is introduced as a free variable via `withLocalDecl`.
-/

-- Step 0: state that tracks the growing sum expression and step counter
structure StepState where
  sumExpr : Expr
  stepNo  : Nat

abbrev StepM := StateRefT StepState MetaM

/-- Build a rational literal `(n : ℚ)` from a natural number. -/
private def mkRatOfNat (n : Nat) : MetaM Expr :=
  mkAppOptM ``OfNat.ofNat #[mkConst ``Rat, mkNatLit n, none]

/-- Build `q ^ k` where `k : ℤ` (uses `zpow` for negative exponents). -/
private def mkQZPow (q : Expr) (k : Int) : MetaM Expr :=
  mkAppM ``HPow.hPow #[q, mkIntLit k]

/-- Build `q ^ k` where `k : ℕ`. -/
private def mkQNPow (q : Expr) (k : Nat) : MetaM Expr :=
  mkAppM ``HPow.hPow #[q, mkNatLit k]

/-- Add a term `coeff · q ^ exp` to the running sum and type‑check. -/
private def addTerm (q : Expr) (coeff : Nat) (exp : Int) (label : String) : StepM Unit := do
  let st ← get
  -- Build the term
  let term ← if coeff == 1 then
      -- For coefficient 1, just use the power directly
      if exp == 0 then mkRatOfNat 1
      else mkQZPow q exp
    else
      let c ← mkRatOfNat coeff
      if exp == 0 then pure c
      else if exp == 1 then mkAppM ``HMul.hMul #[c, q]
      else do
        let qk ← if exp ≥ 0 then mkQNPow q exp.toNat else mkQZPow q exp
        mkAppM ``HMul.hMul #[c, qk]
  -- Add to running sum
  let newSum ← mkAppM ``HAdd.hAdd #[st.sumExpr, term]
  -- Type check
  let sumType ← inferType newSum
  let ok ← isDefEq sumType (mkConst ``Rat)
  let stepNum := st.stepNo + 1
  if !ok then
    throwError "Step {stepNum}: type mismatch! Got {sumType}, expected ℚ"
  set (StepState.mk newSum stepNum)
  IO.println s!"✓ Step {stepNum}: {label} — sum type is ℚ ✔"

/--
Build the j‑invariant q‑expansion in 10 steps.

Returns the final `Expr` (of type `ℚ`, under a binder for `q : ℚ`).
-/
def buildJInvariant : MetaM Unit := do
  let ratTy := mkConst ``Rat
  withLocalDecl `q .default ratTy fun q => do
    -- Initialise: sum = 0
    let zero ← mkRatOfNat 0
    let ((), _finalState) ← (do
      -- Step 1: q⁻¹
      addTerm q 1 (-1) "added q⁻¹"
      -- Step 2: + 744
      addTerm q 744 0 "added 744"
      -- Step 3: + 196884·q
      addTerm q 196884 1 "added 196884·q"
      -- Step 4: + 21493760·q²
      addTerm q 21493760 2 "added 21493760·q²"
      -- Step 5: + 864299970·q³
      addTerm q 864299970 3 "added 864299970·q³"

      -- Step 6: pretty‑print the expression
      let st ← get
      IO.println s!"✓ Step 6: current expression:\n    {← ppExpr st.sumExpr}"

      -- Step 7: verify the type once more
      let ty ← inferType st.sumExpr
      let ok ← isDefEq ty ratTy
      IO.println s!"✓ Step 7: inferred type is ℚ — {ok}"

      -- Step 8: reduce to weak head normal form
      let _reduced ← whnf st.sumExpr
      IO.println "✓ Step 8: weak head normal form computed"

      -- Step 9: abstract over `q` to get a function `ℚ → ℚ`
      let fn ← mkLambdaFVars #[q] st.sumExpr
      let fnTy ← inferType fn
      IO.println s!"✓ Step 9: abstracted over q — type: {← ppExpr fnTy}"

      -- Step 10: final sanity check — no metavariables remain
      let hasMVars := st.sumExpr.hasMVar
      if hasMVars then
        IO.println "⚠ Step 10: expression still contains metavariables"
      else
        IO.println "✓ Step 10: no metavariables — j‑invariant series constructed successfully"

      IO.println "\n══════════════════════════════════════════"
      IO.println "  j(q) = q⁻¹ + 744 + 196884q + 21493760q² + 864299970q³"
      IO.println "══════════════════════════════════════════"
    : StepM Unit).run { sumExpr := zero, stepNo := 0 }

-- Run the construction
#eval buildJInvariant
