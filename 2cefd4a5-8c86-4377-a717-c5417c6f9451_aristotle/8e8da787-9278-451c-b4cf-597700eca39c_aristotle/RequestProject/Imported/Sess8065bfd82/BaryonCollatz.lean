import Mathlib

set_option maxHeartbeats 800000

/-- The complete baryon octet. -/
inductive Baryon where
  | Neutron | SigmaMinus | XiMinus | XiZero | SigmaPlus | Proton
  | SigmaNeutral | Lambda
deriving Repr, DecidableEq

/-- Quantum numbers (I₃, S, Q). -/
def baryonQuantumNumbers : Baryon → Rat × Int × Int
  | Baryon.Neutron      => (-1/2, 0, 0)
  | Baryon.SigmaMinus   => (-1, -1, -1)
  | Baryon.XiMinus      => (-1/2, -2, -1)
  | Baryon.XiZero       => (1/2, -2, 0)
  | Baryon.SigmaPlus    => (1, -1, 1)
  | Baryon.Proton       => (1/2, 0, 1)
  | Baryon.SigmaNeutral => (0, -1, 0)
  | Baryon.Lambda       => (0, -1, 0)

/-- Standalone recursive helper for net sign sum. -/
def collatzSignSum.go (m : Nat) (acc : Int) (fuel : Nat) : Int :=
  if fuel = 0 ∨ m = 1 then acc
  else if m % 2 == 0 then collatzSignSum.go (m / 2) (acc - 1) (fuel - 1)
  else collatzSignSum.go (3 * m + 1) (acc + 1) (fuel - 1)
termination_by fuel

/-- Standalone recursive helper for counting odd steps. -/
def countOddSteps.go (m : Nat) (acc : Nat) (fuel : Nat) : Nat :=
  if fuel = 0 ∨ m = 1 then acc
  else if m % 2 == 0 then countOddSteps.go (m / 2) acc (fuel - 1)
  else countOddSteps.go (3 * m + 1) (acc + 1) (fuel - 1)
termination_by fuel

/-- True Collatz orbit length (assumes Collatz conjecture). -/
def trueOrbitLength : Nat → Nat
  | 0 => 0
  | 1 => 0
  | m => if m % 2 = 0 then 1 + trueOrbitLength (m / 2)
         else 1 + trueOrbitLength (3 * m + 1)
decreasing_by all_goals sorry

/-- Net sign sum along the orbit. -/
def collatzSignSum (n : Nat) : Int :=
  collatzSignSum.go n 0 (trueOrbitLength n + 1)

/-- Number of odd steps in the orbit. -/
def countOddSteps (n : Nat) : Nat :=
  countOddSteps.go n 0 (trueOrbitLength n + 1)

/-- Net phase (mod 6). -/
def netPhase (n : Nat) : Fin 6 :=
  let s := collatzSignSum n
  let m := if s ≥ 0 then s % 6 else (s % 6 + 6) % 6
  ⟨m.toNat, by omega⟩

/-- Map from phase to outer baryon. -/
def baryonFromPhase : Fin 6 → Baryon
  | 0 => Baryon.Neutron
  | 1 => Baryon.SigmaMinus
  | 2 => Baryon.XiMinus
  | 3 => Baryon.XiZero
  | 4 => Baryon.SigmaPlus
  | 5 => Baryon.Proton

/-- Drop condition: trajectory reaches exact equilibrium (net displacement = 0). -/
def dropTrigger (n : Nat) : Bool :=
  collatzSignSum n = 0

/-- Isospin tag: parity of odd-step count. -/
def isospinTag (n : Nat) : Bool :=
  (countOddSteps n) % 2 = 1

/-- Full projection operator (Path B). -/
def primeInertiaProjection (n : Nat) : Baryon :=
  if dropTrigger n then
    if isospinTag n then Baryon.SigmaNeutral else Baryon.Lambda
  else
    baryonFromPhase (netPhase n)
