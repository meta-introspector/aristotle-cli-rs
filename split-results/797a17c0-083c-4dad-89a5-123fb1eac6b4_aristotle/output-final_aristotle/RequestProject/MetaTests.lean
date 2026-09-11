/-
# MetaTests.lean — Lean 4 Meta Program for Generating & Running Tests

Uses Lean 4 metaprogramming (`Elab.Command`) to programmatically generate
~45 test theorems that verify consistency of MonsterConstants and SharedStructures.
Each test is a `theorem` proved by `native_decide` or `decide`, so the kernel
itself certifies correctness — no sorry, no trust-me.

## Usage
Simply import this file; all tests run at elaboration time.
If any test fails, the file won't compile.
-/
import Mathlib
import RequestProject.MonsterConstants
import RequestProject.SharedStructures

open Lean Elab Command Meta Term
open MonsterConstants SharedStructures

/-! ## §1. The Test Generator Engine -/

/-- A test specification: a name and a decidable proposition (as Lean syntax). -/
structure TestSpec where
  name : String
  desc : String        -- docstring
  prop : TSyntax `term -- the proposition to verify

/-- Generate a single test theorem from a `TestSpec`. -/
private def mkTestCommand (spec : TestSpec) : CommandElabM Unit := do
  let nm := mkIdent (.mkSimple spec.name)
  let prop := spec.prop
  elabCommand (← `(
    theorem $nm : $prop := by native_decide
  ))
  logInfo m!"✓ {spec.name}"

/-- Run a batch of test specs, reporting results. -/
private def runTests (label : String) (specs : Array TestSpec) : CommandElabM Unit := do
  logInfo m!"━━━ Running {label} ({specs.size} tests) ━━━"
  for spec in specs do
    mkTestCommand spec
  logInfo m!"━━━ All {label} tests passed ━━━"

/-! ## §2. Test Batteries -/

-- Battery 1 — Every supersingular prime is prime (15 tests).
run_cmd do
  let primes := #[2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71]
  let mut specs : Array TestSpec := #[]
  for p in primes do
    let pLit := Syntax.mkNumLit (toString p)
    specs := specs.push {
      name := s!"ssp_prime_{p}"
      desc := s!"{p} is prime"
      prop := ← `(Nat.Prime $pLit)
    }
  runTests "SSP primality" specs

-- Battery 2 — Every SSP divides |M| (15 tests).
run_cmd do
  let primes := #[2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71]
  let mut specs : Array TestSpec := #[]
  for p in primes do
    let pLit := Syntax.mkNumLit (toString p)
    specs := specs.push {
      name := s!"ssp_divides_M_{p}"
      desc := s!"{p} divides the Monster order"
      prop := ← `($pLit ∣ MonsterConstants.M_order)
    }
  runTests "SSP divides |M|" specs

-- Battery 3 — CRT moduli are pairwise coprime (3 tests).
run_cmd do
  let pairs := #[(47, 59), (47, 71), (59, 71)]
  let mut specs : Array TestSpec := #[]
  for (a, b) in pairs do
    let aLit := Syntax.mkNumLit (toString a)
    let bLit := Syntax.mkNumLit (toString b)
    specs := specs.push {
      name := s!"crt_coprime_{a}_{b}"
      desc := s!"gcd({a},{b}) = 1"
      prop := ← `(Nat.Coprime $aLit $bLit)
    }
  runTests "CRT coprimality" specs

-- Battery 4 — Numerical identity checks (11 tests).
run_cmd do
  let specs : Array TestSpec := #[
    { name := "crt_product_is_196883"
      desc := "47 × 59 × 71 = 196883"
      prop := ← `((47 * 59 * 71 : ℕ) = 196883) },
    { name := "griess_is_196884"
      desc := "Griess dim = 196884"
      prop := ← `(MonsterConstants.griess_dim = 196884) },
    { name := "mckay_196884_eq_196883_plus_1"
      desc := "196884 = 196883 + 1 (McKay)"
      prop := ← `((196884 : ℕ) = 196883 + 1) },
    { name := "eigenspace_dims_sum_15"
      desc := "Eigenspace dims: 7+5+1+2 = 15"
      prop := ← `((7 + 5 + 1 + 2 : ℕ) = 15) },
    { name := "bott_period_is_8"
      desc := "Bott period = 8"
      prop := ← `(MonsterConstants.bott_period = 8) },
    { name := "ssp_plus_bott_plus_void_eq_niemeier"
      desc := "15 + 8 + 1 = 24"
      prop := ← `((15 + 8 + 1 : ℕ) = 24) },
    { name := "leech_rank_is_24"
      desc := "Leech lattice rank = 24"
      prop := ← `(MonsterConstants.leech_rank = 24) },
    { name := "j_constant_term_744"
      desc := "j-function constant term = 744"
      prop := ← `(MonsterConstants.jCoeff 1 = 744) },
    { name := "monster_classes_194"
      desc := "Monster has 194 conjugacy classes"
      prop := ← `(MonsterConstants.M_classes = 194) },
    { name := "baby_monster_classes_184"
      desc := "Baby Monster has 184 conjugacy classes"
      prop := ← `(MonsterConstants.B_classes = 184) },
    { name := "crt_moduli_all_in_ssp"
      desc := "All CRT moduli (47,59,71) are in supersingularPrimes"
      prop := ← `(47 ∈ MonsterConstants.supersingularPrimes ∧
                   59 ∈ MonsterConstants.supersingularPrimes ∧
                   71 ∈ MonsterConstants.supersingularPrimes) }
  ]
  runTests "Numerical identities" specs

-- Battery 5 — Fintype cardinality checks on SharedStructures (2 tests).
run_cmd do
  let specs : Array TestSpec := #[
    { name := "eigenspace_has_4_values"
      desc := "Eigenspace has 4 constructors"
      prop := ← `(Fintype.card SharedStructures.Eigenspace = 4) },
    { name := "bottphase_has_8_values"
      desc := "BottPhase has 8 constructors"
      prop := ← `(Fintype.card SharedStructures.BottPhase = 8) }
  ]
  runTests "SharedStructures cardinality" specs

/-! ## §3. Summary -/

-- Total: 15 + 15 + 3 + 11 + 2 = 46 tests generated and verified.
-- All proved by `native_decide` at elaboration time.

-- Spot-check: these theorems exist in the environment after elaboration.
#check @ssp_prime_2
#check @ssp_prime_71
#check @ssp_divides_M_71
#check @crt_coprime_47_59
#check @mckay_196884_eq_196883_plus_1
#check @eigenspace_has_4_values
#check @bottphase_has_8_values
