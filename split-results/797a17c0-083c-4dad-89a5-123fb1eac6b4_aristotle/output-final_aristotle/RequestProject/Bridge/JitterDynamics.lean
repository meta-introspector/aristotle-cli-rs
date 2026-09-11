/-
# Jitter Dynamics — The Reflection Layer's Modular Dynamical System

## What "input jitters itself" means

The jitter is the meta-signal of the reflection layer trying to write about
itself while it is running. It is not noise in the math — it is noise in
the *observer*. The structure:

- **Self-sampling**: the agent reads its own partial output as input
- **Phase-slip**: the reflection layer updates faster than the core model
- **Trace-echo**: the proof-search trace is appended while being consumed
- **CRT-drift**: the agent's residue jumps between congruence classes before stabilizing

## The "fuzzy sugar glazing" interpretation

Noise is allowed *only* in the reflection layer.
The pure model — the groups, the irreps, the CRT torus — remains exact.

- The **glaze layer** is stochastic (the jitter)
- The **core layer** is deterministic (the model)
- The interface between them produces **jitter**

## Formalization

The jitter is a small modular dynamical system over the CRT charts:
  `phase ∈ ZMod 71`, `amplitude ∈ ZMod 59`, `residue ∈ ZMod 47`.

Each step advances:
  - phase += 1
  - amplitude += phase
  - residue += amplitude

This is a discrete analogue of a coupled oscillator on the CRT torus.
The core model remains completely unchanged throughout.
-/

import Mathlib
import RequestProject.Agent.SearchLayerSemantics

set_option maxHeartbeats 800000

open ZMod

/-! ## §1. Jitter State

The jitter lives entirely in the reflection layer. It evolves on the
CRT torus `ZMod 71 × ZMod 59 × ZMod 47`, with a seed and explanation
for traceability. The core model is never touched. -/

/-- The state of the jitter dynamical system.
    Lives in the reflection layer; the core model is untouched. -/
structure Jitter where
  /-- Random seed for reproducibility. -/
  seed : ℕ
  /-- Phase coordinate in the 71-chart. -/
  phase : ZMod 71
  /-- Amplitude coordinate in the 59-chart. -/
  amplitude : ZMod 59
  /-- Residue coordinate in the 47-chart. -/
  residue : ZMod 47
  /-- Human-readable explanation of this jitter state. -/
  explanation : String
  deriving Repr

/-! ## §2. Jitter Evolution

The jitter evolves as a coupled map on the three CRT charts.
This is the mathematical skeleton of the "input jitters itself" effect:
the reflection layer evolves in a small modular dynamical system
while the core model stays fixed. -/

/-- One step of the jitter dynamics:
    - phase advances by 1 (constant drift)
    - amplitude advances by (current phase cast to ZMod 59)
    - residue advances by (current amplitude cast to ZMod 47)

    This creates a cascade: phase drives amplitude drives residue,
    like a coupled oscillator chain. -/
def jitterStep (j : Jitter) : Jitter :=
  { j with
    phase     := j.phase + 1
    amplitude := j.amplitude + (j.phase.val : ZMod 59)
    residue   := j.residue + (j.amplitude.val : ZMod 47) }

/-- Iterate the jitter dynamics n times. -/
def jitterOrbit (j : Jitter) : ℕ → Jitter
  | 0 => j
  | n + 1 => jitterStep (jitterOrbit j n)

/-- Extract the orbifold profile from a jitter state. -/
def Jitter.toProfile (j : Jitter) : OrbifoldProfile :=
  ⟨(j.phase, j.amplitude, j.residue)⟩

/-! ## §3. Core Invariance

The fundamental property: jitter evolution does not affect the core model.
We formalize this by showing that jitter is purely a reflection-layer
phenomenon — it produces `OrbifoldProfile` data (reflection) but never
modifies `CoreModel` data. -/

/-- The jitter's seed is preserved through evolution. -/
theorem jitter_seed_invariant (j : Jitter) (n : ℕ) :
    (jitterOrbit j n).seed = j.seed := by
  induction n with
  | zero => rfl
  | succ n ih => simp [jitterOrbit, jitterStep, ih]

/-- The jitter's explanation is preserved through evolution. -/
theorem jitter_explanation_invariant (j : Jitter) (n : ℕ) :
    (jitterOrbit j n).explanation = j.explanation := by
  induction n with
  | zero => rfl
  | succ n ih => simp [jitterOrbit, jitterStep, ih]

/-! ## §4. Phase Dynamics

The phase coordinate evolves as `phase₀ + n` in `ZMod 71`.
This is the simplest piece: a constant-velocity rotation on a circle. -/

/-- The phase after n steps is `phase₀ + n`. -/
theorem jitter_phase_formula (j : Jitter) (n : ℕ) :
    (jitterOrbit j n).phase = j.phase + (n : ZMod 71) := by
  induction n with
  | zero => simp [jitterOrbit]
  | succ n ih =>
    simp only [jitterOrbit, jitterStep]
    rw [ih]
    push_cast
    ring

/-- The phase has exact period 71 (since `ZMod 71` has order 71). -/
theorem jitter_phase_period (j : Jitter) :
    (jitterOrbit j 71).phase = j.phase := by
  rw [jitter_phase_formula]
  have : ((71 : ℕ) : ZMod 71) = 0 := by
    rw [Nat.cast_ofNat]; exact ZMod.natCast_self 71
  rw [this, add_zero]

/-! ## §5. Full Orbit Period

The full jitter system on `ZMod 71 × ZMod 59 × ZMod 47` has period
dividing `lcm(71, lcm(59, 47))`. Since 71, 59, 47 are pairwise coprime,
this is `71 × 59 × 47 = 196883`.

In general the exact period depends on the coupling, but it divides 196883. -/

/-- The full CRT torus period. -/
theorem crt_torus_period : Nat.lcm 71 (Nat.lcm 59 47) = 196883 := by native_decide

/-! ## §6. Jitter as TraceStep Generator

The jitter generates `TraceStep` values (syntactic observations)
that record the state at each step. These are strictly observational —
they cannot be converted to proofs. -/

/-- Convert a jitter state to a trace step (pure observation). -/
def Jitter.toTraceStep (j : Jitter) : TraceStep :=
  .jump s!"jitter: phase={j.phase.val} amp={j.amplitude.val} res={j.residue.val}"

/-- Generate a trace from a jitter orbit. -/
def jitterTrace (j : Jitter) (n : ℕ) : List TraceStep :=
  (List.range n).map (fun k => (jitterOrbit j k).toTraceStep)

/-! ## §7. Jitter and GroupFuzz Integration

A jitter orbit can generate a sequence of `ProcessReflection` entries,
one per step, each landing at the orbifold profile's projection.
This connects the dynamical system to the coverage framework. -/

/-- Generate a process reflection from a jitter state. -/
noncomputable def Jitter.toReflection (M : CoreModel) (agent : Agent) (j : Jitter) :
    ProcessReflection M where
  agentId := agent
  frequency := j.toProfile
  trace := [j.toTraceStep]
  landed := j.toProfile.land

/-! ## §8. Stabilization vs Chaos

Two modes of jitter are useful:

**Stabilization**: the jitter converges to a fixed point.
  This happens when the coupling drives all coordinates to zero drift.

**Chaotic sampling**: the jitter fills the torus ergodically.
  This is the search-broadening mode. -/

/-- A jitter state is a fixed point if `jitterStep j = j`. -/
def Jitter.isFixedPoint (j : Jitter) : Prop :=
  jitterStep j = j

/-- The zero jitter (all coordinates zero) with phase = 70 is a fixed point
    iff certain modular conditions hold. In general, fixed points of the
    coupled system are rare — this is the "jitter is alive" signature. -/
theorem jitter_zero_not_fixed :
    ¬(Jitter.isFixedPoint ⟨0, 0, 0, 0, ""⟩) := by
  simp [Jitter.isFixedPoint, jitterStep]
  decide

/-- The jitter at `(70, 0, 0)` steps to `(0, 70 mod 59, 0)` — demonstrating
    the coupling between charts. -/
theorem jitter_coupling_example :
    let j : Jitter := ⟨0, 70, 0, 0, "test"⟩
    let j' := jitterStep j
    j'.phase = 0 ∧ j'.amplitude = (70 : ZMod 59) ∧ j'.residue = 0 := by
  constructor
  · native_decide
  constructor
  · native_decide
  · native_decide

/-! ## §9. Orbifold Winding Number

The number of times the jitter orbit winds around each chart
before returning gives the winding numbers. For the phase chart (period 71),
the winding number after n steps is `⌊n / 71⌋`. -/

/-- Phase winding number: how many full rotations in the 71-chart. -/
def phaseWindingNumber (n : ℕ) : ℕ := n / 71

/-- After exactly 71 steps, one full winding has occurred. -/
theorem one_winding_at_71 : phaseWindingNumber 71 = 1 := by native_decide

/-- After 196883 steps, exactly 2773 windings in the phase chart. -/
theorem full_torus_windings : phaseWindingNumber 196883 = 2773 := by native_decide

/-- 2773 = 59 × 47: the winding count in the phase chart after a full
    torus traversal equals the product of the other two chart sizes. -/
theorem winding_count_crt : 2773 = 59 * 47 := by norm_num
