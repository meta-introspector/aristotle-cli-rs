/-
# RequestProject/FractranVM.lean
## Fractran VM — A Typed, Monster-Aligned Fractran Interpreter

Conway's Fractran is a Turing-complete model of computation where a program
is a list of fractions and the state is a single positive integer. At each step,
the first fraction in the list whose product with the current integer is again
an integer is applied — i.e., the first fraction f = p/q such that q | n
gives n' = (p * n) / q.

This file builds:
1. **Core Fractran objects**: `Frac`, `Program`, `Config`, `Step` relation
2. **Deterministic step function** + `runN`, `runUntil`
3. **Monster/CRT embedding**: configurations → S_ss coordinates
4. **Crank bridge**: `FractranCrank` linking Fractran execution to the
   Crankmining pipeline
5. **Governance hook**: fiber-coherence of execution traces
-/

import Mathlib
import RequestProject.Compute.Cosmic.Crankmining

set_option maxHeartbeats 800000

open Crankmining FiberedUniverse

namespace FractranVM

/-! ## §1. Core Fractran Objects -/

/-- A single Fractran fraction p/q with the coprimality invariant. -/
structure Frac where
  /-- Numerator. -/
  num : ℕ
  /-- Denominator (must be positive). -/
  den : ℕ
  /-- Numerator and denominator are coprime. -/
  coprime : Nat.Coprime num den
  /-- Denominator is positive. -/
  den_pos : den > 0
  deriving Repr

/-- A Fractran program is a list of fractions. -/
abbrev Program := List Frac

/-- A Fractran configuration: the current integer and step count. -/
structure Config where
  /-- The current positive integer state. -/
  n : ℕ
  /-- The number of steps executed so far. -/
  steps : ℕ
  deriving Repr, DecidableEq

/-! ## §2. Step Relation — Relational Semantics -/

/-- The step relation for a Fractran program.
    `Step P c c'` means configuration `c` transitions to `c'` by applying
    some fraction `f` from `P` such that `f.den ∣ c.n`. -/
inductive Step (P : Program) : Config → Config → Prop where
  | apply (c : Config) (f : Frac)
      (hmem : f ∈ P)
      (hdiv : f.den ∣ c.n)
      (hpos : f.num * c.n / f.den > 0) :
      Step P c ⟨f.num * c.n / f.den, c.steps + 1⟩

/-! ## §3. Deterministic Step Function -/

/-- Find the first applicable fraction in a program for a given integer.
    Returns `some f` if `f` is the first fraction whose denominator divides `n`,
    or `none` if no fraction applies (the program halts). -/
def findApplicable (P : Program) (n : ℕ) : Option Frac :=
  P.find? (fun f => n % f.den == 0)

/-- Apply a single Fractran step: find the first applicable fraction and apply it.
    Returns `none` if the program halts (no fraction applies). -/
def step (P : Program) (c : Config) : Option Config :=
  match findApplicable P c.n with
  | none => none
  | some f =>
    let n' := f.num * c.n / f.den
    some ⟨n', c.steps + 1⟩

/-- A Fractran program halts on configuration `c` when no fraction applies. -/
def halts (P : Program) (c : Config) : Prop :=
  step P c = none

/-- Run a Fractran program for at most `fuel` steps. -/
def runN (P : Program) (c : Config) : ℕ → Config
  | 0 => c
  | fuel + 1 =>
    match step P c with
    | none => c
    | some c' => runN P c' fuel

/-- Run a Fractran program until it halts or fuel is exhausted.
    Returns `some final` if the program halted, `none` if fuel ran out. -/
def runUntil (P : Program) (c : Config) : ℕ → Option Config
  | 0 => if step P c = none then some c else none
  | fuel' + 1 =>
    match step P c with
    | none => some c
    | some c' => runUntil P c' fuel'

/-- `runN` with 0 fuel is the identity. -/
theorem runN_zero (P : Program) (c : Config) : runN P c 0 = c := rfl

/-- If the program halts, `runN` returns the same configuration. -/
theorem runN_halts (P : Program) (c : Config) (fuel : ℕ)
    (h : step P c = none) :
    runN P c (fuel + 1) = c := by
  simp [runN, h]

/-- If `runUntil` returns `some c'`, then `c'` is a halted configuration. -/
theorem runUntil_halts (P : Program) (c : Config) (fuel : ℕ) (c' : Config)
    (h : runUntil P c fuel = some c') : step P c' = none := by
  induction fuel generalizing c with
  | zero =>
    simp only [runUntil] at h
    split at h
    case isTrue h' => simp at h; subst h; exact h'
    case isFalse => simp at h
  | succ n ih =>
    simp only [runUntil] at h
    split at h
    case h_1 heq => simp at h; subst h; exact heq
    case h_2 c'' heq => exact ih c'' h

/-! ## §4. Example Programs -/

/-- The trivial Fractran program (empty list) — always halts immediately. -/
def trivialProgram : Program := []

/-- The trivial program always halts. -/
theorem trivialProgram_halts (c : Config) : step trivialProgram c = none := by
  simp [step, findApplicable, trivialProgram]

/-- A simple doubling fraction: 2/1. -/
def doubleFrac : Frac where
  num := 2
  den := 1
  coprime := by decide
  den_pos := by omega

/-- The doubling fraction always applies (1 divides everything). -/
theorem doubleFrac_always_applies (n : ℕ) : doubleFrac.den ∣ n := by
  simp [doubleFrac]

/-! ## §5. Monster/CRT Embedding — Configurations on S_ss

Each Fractran configuration is embedded into the supersingular CRT torus
S_ss = ℤ/71 × ℤ/59 × ℤ/47 by reducing the current integer mod each prime. -/

/-- Embed a Fractran configuration into S_ss via CRT projection.
    The three coordinates are n mod 71, n mod 59, n mod 47. -/
def configCoord (c : Config) : S_ss :=
  ((c.n : ZMod 71), (c.n : ZMod 59), (c.n : ZMod 47))

/-- The Bott class of a configuration: steps mod 8. -/
def configBottClass (c : Config) : Fin 8 :=
  ⟨c.steps % 8, Nat.mod_lt _ (by omega)⟩

/-- Each step advances the step counter by 1. -/
theorem step_advances_steps (P : Program) (c c' : Config)
    (h : step P c = some c') :
    c'.steps = c.steps + 1 := by
  simp only [step] at h
  split at h
  · simp at h
  · simp at h; exact (congrArg Config.steps h).symm

/-- The S_ss coordinate of the zero configuration. -/
theorem configCoord_zero :
    configCoord ⟨0, 0⟩ = ((0 : ZMod 71), (0 : ZMod 59), (0 : ZMod 47)) := by
  rfl

/-! ## §6. Execution Trace and Fiber Coherence

A Fractran execution trace is the sequence of S_ss coordinates visited
during execution. We define fiber coherence: all configurations in a
trace project to the same fiber class. -/

/-- The execution trace: the sequence of S_ss coordinates visited during `runN`. -/
def executionTrace (P : Program) (c : Config) (fuel : ℕ) : S_ss :=
  configCoord (runN P c fuel)

/-- A Fractran program is fiber-stable at `c` if all reachable configurations
    have the same S_ss coordinate. -/
def isFiberStable (P : Program) (c : Config) : Prop :=
  ∀ fuel : ℕ, configCoord (runN P c fuel) = configCoord c

/-- A Fractran program is fiber-coherent at `c` if the execution trace
    stays within a specified set of S_ss coordinates (a fiber class). -/
def isFiberCoherent (P : Program) (c : Config) (fiberClass : Set S_ss) : Prop :=
  ∀ fuel : ℕ, configCoord (runN P c fuel) ∈ fiberClass

/-- The trivial program is trivially fiber-stable. -/
theorem trivialProgram_fiberStable (c : Config) :
    isFiberStable trivialProgram c := by
  intro fuel
  induction fuel with
  | zero => rfl
  | succ n _ =>
    simp [runN, step, findApplicable, trivialProgram]

/-- A fiber-stable program is automatically fiber-coherent with respect
    to the singleton fiber class {configCoord init}. -/
theorem fiberStable_implies_coherent (P : Program) (c : Config)
    (h : isFiberStable P c) :
    isFiberCoherent P c {configCoord c} := by
  intro fuel
  simp [Set.mem_singleton_iff]
  exact h fuel

/-! ## §7. The Fractran Crank Bridge

A `FractranCrank` bundles a Fractran program with its initial and final
configurations, a proof of halting, and a link to the Crankmining crank
whose coordinate matches the final configuration's S_ss projection. -/

/-- A FractranCrank: a Fractran computation that has halted, linked to
    the crank pipeline. -/
structure FractranCrank where
  /-- The Fractran program. -/
  prog : Program
  /-- The initial configuration. -/
  init : Config
  /-- The final (halted) configuration. -/
  final : Config
  /-- Fuel used to reach the final configuration. -/
  fuel : ℕ
  /-- The computation reached `final` from `init` within `fuel` steps. -/
  reaches : runUntil prog init fuel = some final
  /-- The associated crank in the mining pipeline. -/
  crank : Crankmining.Crank
  /-- The crank's coordinate matches the final configuration's S_ss projection. -/
  link : crank.coordinate = configCoord final

/-- The final configuration of a FractranCrank is halted. -/
theorem FractranCrank.final_halts (fc : FractranCrank) :
    step fc.prog fc.final = none :=
  runUntil_halts fc.prog fc.init fc.fuel fc.final fc.reaches

/-! ## §8. Program Encoding and Monster Hash

Encode a Fractran program as a natural number (Gödel encoding) and
hash it into S_ss. This provides a content-addressed identifier for
every Fractran program. -/

/-- Encode a single fraction as a natural number via Cantor pairing. -/
def encodeFrac (f : Frac) : ℕ :=
  Nat.pair f.num f.den

/-- Encode a Fractran program as a natural number.
    Uses iterated Cantor pairing over the fraction list. -/
def encodeProgram (P : Program) : ℕ :=
  P.foldl (fun acc f => Nat.pair acc (encodeFrac f)) 0

/-- Hash a Fractran program into S_ss. -/
def programCoord (P : Program) : S_ss :=
  let code := encodeProgram P
  ((code : ZMod 71), (code : ZMod 59), (code : ZMod 47))

/-- Hash a Fractran program into a CrankName. -/
def programToCrankName (P : Program) : Crankmining.CrankName :=
  ⟨s!"fractran_{encodeProgram P}"⟩

/-- The crank mined from a Fractran program preserves the Monster Hash. -/
theorem fractranToCrank_coordinate (P : Program) :
    (Crankmining.mkCrank (programToCrankName P)).coordinate =
      Crankmining.monsterHash (programToCrankName P) := by
  rfl

/-! ## §9. Governance Hook — Fiber-Coherent Execution

A Fractran program is "admitted" (governable) if its execution trace
is fiber-coherent. This means the computation stays "thinkable" —
within the Monster's coordinate system. -/

/-- A governed Fractran program: one whose execution trace lives in
    a specified fiber class on S_ss. -/
structure GovernedFractranProgram where
  /-- The Fractran program. -/
  prog : Program
  /-- The initial configuration. -/
  init : Config
  /-- The fiber class the execution must remain within. -/
  fiberClass : Set S_ss
  /-- The program is fiber-coherent: all reachable configurations
      lie in the specified fiber class. -/
  coherent : isFiberCoherent prog init fiberClass

/-- The trivial program is trivially governed (within any class containing
    the initial coordinate). -/
theorem trivialProgram_governed (c : Config) :
    isFiberCoherent trivialProgram c {configCoord c} :=
  fiberStable_implies_coherent _ _ (trivialProgram_fiberStable c)

/-! ## §10. Steps-to-Bott Correspondence -/

/-- The Bott class of a configuration after `n` non-halting steps
    starting from step 0 is `n % 8`. -/
theorem bott_class_of_steps (n : ℕ) :
    configBottClass ⟨0, n⟩ = ⟨n % 8, Nat.mod_lt _ (by omega)⟩ := by
  rfl

/-- After 8 steps, the Bott class returns to its original value (periodicity). -/
theorem bott_periodicity_8 (c : Config) :
    configBottClass ⟨c.n, c.steps + 8⟩ = configBottClass c := by
  simp only [configBottClass]
  congr 1
  omega

/-! ## §11. Decidability and Computability -/

/-- The step function is total: it either produces a next config or signals halt. -/
theorem step_total (P : Program) (c : Config) :
    (∃ c', step P c = some c') ∨ step P c = none := by
  cases h : step P c with
  | none => right; rfl
  | some c' => left; exact ⟨c', rfl⟩

/-! ## §12. Multi-Step Properties -/

/-- `runN` is monotone in steps: the step counter never decreases. -/
theorem runN_steps_mono (P : Program) (c : Config) (fuel : ℕ) :
    c.steps ≤ (runN P c fuel).steps := by
  induction fuel generalizing c with
  | zero => simp [runN]
  | succ n ih =>
    simp only [runN]
    split
    · exact Nat.le_refl _
    case h_2 c' heq =>
      have : c.steps + 1 = c'.steps := by
        exact (step_advances_steps P c c' heq).symm
      calc c.steps ≤ c.steps + 1 := Nat.le_succ _
        _ = c'.steps := this
        _ ≤ (runN P c' n).steps := ih c'

/-! ## §13. Summary

| Component            | Definition / Theorem                        |
|----------------------|---------------------------------------------|
| Fractran fraction    | `Frac` with coprimality invariant           |
| Program              | `Program = List Frac`                       |
| Configuration        | `Config` with integer state + step count    |
| Step relation        | `Step P c c'` (relational)                  |
| Step function        | `step P c` (deterministic, computable)      |
| Run engine           | `runN`, `runUntil` with fuel                |
| Halting              | `halts`, `runUntil_halts`                   |
| S_ss embedding       | `configCoord : Config → S_ss`              |
| Bott class           | `configBottClass : Config → Fin 8`         |
| Fiber coherence      | `isFiberCoherent`, `isFiberStable`          |
| Crank bridge         | `FractranCrank` with `link` field           |
| Program hash         | `programCoord`, `encodeProgram`             |
| Governance           | `GovernedFractranProgram`                   |
| Bott periodicity     | `bott_periodicity_8`                        |
-/

end FractranVM
