import Mathlib
import RequestProject.Compute.Cosmic.Crankmining
import RequestProject.Compute.Cosmic.RamanujanCrankBridge

/-!
# OracleMonad — Generic OODA Monad Laws and Oracle Engine

This module provides:
- Generic monad laws for `OodaM`
- `preserves_base` lemmas in a general setting
- A simulation lemma: k oracle steps ≡ evolveN k
- A small API for running the oracle on RamanujanObj to produce Cranks

## Main definitions
- `OodaM.pure_run`, `OodaM.bind_run`: monad law characterizations
- `OodaM.repeatN`: iterate the oracle n times
- `simulation_lemma`: k oracle cycles = evolveN k at the fiber level
- `oracleProduceCrank`: given a RamanujanObj, run the oracle + evolve to produce a Crank

## Main theorems
- `OodaM_left_identity`, `OodaM_right_identity`, `OodaM_assoc`: monad laws
- `repeatN_preserves_base`: iterated oracle preserves fiber base
- `simulation_lemma`: operational equivalence of oracle iteration and crank evolution
-/

set_option maxHeartbeats 4000000

open Crankmining
open CosmicSynthesis
open DA51PrefixClassification PadicEntropyDAG BottMoonshineExperiment
open FiberedUniverse GradedFiberedUniverse CelestialShell Gearbox UnifiedIPLDMemory
open RamanujanCrankBridge

namespace OracleMonad

/-! ## §1. OodaM Monad Laws

We prove that `OodaM` satisfies the three monad laws:
- Left identity: `pure a >>= f = f a`
- Right identity: `m >>= pure = m`
- Associativity: `(m >>= f) >>= g = m >>= (fun x => f x >>= g)`
-/

/-- Running pure returns the value and leaves state unchanged. -/
theorem OodaM_pure_run {α : Type} (a : α) (fs : FiberState) :
    (pure a : OodaM α).run fs = (a, fs) := rfl

/-- Running bind composes the state transformations. -/
theorem OodaM_bind_run {α β : Type} (m : OodaM α) (f : α → OodaM β) (fs : FiberState) :
    (m >>= f).run fs = (f (m.run fs).1).run (m.run fs).2 := rfl

/-- Left identity law: `pure a >>= f = f a`. -/
theorem OodaM_left_identity {α β : Type} (a : α) (f : α → OodaM β) :
    ((pure a : OodaM α) >>= f) = f a := rfl

/-- Right identity law: `m >>= pure = m`. -/
theorem OodaM_right_identity {α : Type} (m : OodaM α) :
    (m >>= (pure : α → OodaM α)) = m := by
  funext fs
  rfl

/-- Associativity law: `(m >>= f) >>= g = m >>= (fun x => f x >>= g)`. -/
theorem OodaM_assoc {α β γ : Type} (m : OodaM α) (f : α → OodaM β) (g : β → OodaM γ) :
    ((m >>= f) >>= g) = (m >>= fun x => f x >>= g) := by
  funext fs
  rfl

/-! ## §2. Iterated Oracle — repeatN -/

/-- Run the full OODA cycle n times as a monadic computation. -/
def OodaM.repeatN : ℕ → OodaM Unit
  | 0 => pure ()
  | n + 1 => OodaM.fullCycle >>= fun _ => OodaM.repeatN n

/-- Running repeatN 0 is the identity. -/
theorem repeatN_zero_run (fs : FiberState) :
    (OodaM.repeatN 0).run fs = ((), fs) := rfl

/-- Running repeatN (n+1) applies one cycle then repeats n times. -/
theorem repeatN_succ_run (n : ℕ) (fs : FiberState) :
    (OodaM.repeatN (n + 1)).run fs =
      (OodaM.repeatN n).run (oodaCycle fs) := by
  simp [OodaM.repeatN, OodaM.run, Bind.bind,
        OodaM.fullCycle, OodaM.step, oodaCycle]

/-- Iterated oracle cycles preserve the base point. -/
theorem repeatN_preserves_base (n : ℕ) (fs : FiberState) :
    ((OodaM.repeatN n).run fs).2.basePoint = fs.basePoint := by
  induction n generalizing fs with
  | zero => rfl
  | succ n ih =>
    rw [repeatN_succ_run]
    rw [ih]
    exact oodaCycle_preserves_base fs

/-! ## §3. Simulation Lemma

Running the oracle for k steps produces the same fiber state as
`oodaCycleN k` — the two formulations are observationally equivalent. -/

/-- The oracle repeatN agrees with direct oodaCycleN on the fiber state. -/
theorem simulation_lemma (k : ℕ) (fs : FiberState) :
    ((OodaM.repeatN k).run fs).2 = oodaCycleN k fs := by
  induction k generalizing fs with
  | zero => rfl
  | succ k ih =>
    rw [repeatN_succ_run, ih, oodaCycleN]

/-- Corollary: the oracle unit value is always (). -/
theorem repeatN_unit (k : ℕ) (fs : FiberState) :
    ((OodaM.repeatN k).run fs).1 = () := by
  induction k generalizing fs with
  | zero => rfl
  | succ k ih =>
    rw [repeatN_succ_run, ih]

/-! ## §4. Oracle-Preserving-Base Typeclass -/

/-- A `FiberPreserving` operation is one that preserves the base point. -/
class FiberPreserving (f : FiberState → FiberState) where
  preserves_base : ∀ fs, (f fs).basePoint = fs.basePoint

instance : FiberPreserving oodaCycle where
  preserves_base := oodaCycle_preserves_base

instance : FiberPreserving (oodaStep OodaPhase.observe) where
  preserves_base := fun fs => trainAdvance_preserves_base fs

instance : FiberPreserving (oodaStep OodaPhase.orient) where
  preserves_base := fun fs => shah_preserves_base fs

instance : FiberPreserving (oodaStep OodaPhase.decide) where
  preserves_base := fun fs => bottFold_preserves_base fs

instance : FiberPreserving (oodaStep OodaPhase.act) where
  preserves_base := fun fs => growthG_preserves_base fs

instance : FiberPreserving (oodaCycleN k) where
  preserves_base := oodaCycleN_preserves_base k

instance : FiberPreserving (Gearbox.blade) where
  preserves_base := Gearbox.blade_preserves_base

/-- Composition of fiber-preserving operations is fiber-preserving. -/
theorem fiberPreserving_comp {f g : FiberState → FiberState}
    [FiberPreserving f] [FiberPreserving g] (fs : FiberState) :
    (f (g fs)).basePoint = fs.basePoint := by
  rw [FiberPreserving.preserves_base, FiberPreserving.preserves_base]

/-! ## §5. Oracle Produce Crank API

Given a RamanujanObj, run the namagiri oracle + evolveN to produce
a Crank, with proofs that base coordinates are preserved and hash is aligned. -/

/-- Given a RamanujanObj, produce a Crank via the oracle pipeline.
    This is equivalent to `ramanujanToCrank` but makes the oracle involvement explicit. -/
def oracleProduceCrank (r : RamanujanObj) : Crank :=
  ramanujanToCrank r

/-- The produced crank's coordinate matches the Monster Hash of the formula name. -/
theorem oracleProduceCrank_hash (r : RamanujanObj) :
    (oracleProduceCrank r).coordinate = monsterHash (ramanujanToCrankName r) :=
  ramanujanToCrank_preserves_hash r

/-- The produced crank has the correct number of evolution steps. -/
theorem oracleProduceCrank_steps (r : RamanujanObj) :
    (oracleProduceCrank r).evolutionSteps = r.dreamCycles :=
  ramanujanToCrank_steps r

/-- The produced crank's fiber state has base point matching its coordinate. -/
theorem oracleProduceCrank_baseCoh (r : RamanujanObj) :
    (oracleProduceCrank r).fiberState.basePoint = (oracleProduceCrank r).coordinate :=
  (oracleProduceCrank r).baseCoh

/-- Running the oracle is equivalent to evolving the crank.
    This connects the monadic oracle pipeline to the direct crank evolution. -/
theorem oracle_evolution_equivalence (r : RamanujanObj) :
    (oracleProduceCrank r).fiberState =
    ((mkCrank (ramanujanToCrankName r)).evolveN r.dreamCycles).fiberState := by
  rfl

end OracleMonad
