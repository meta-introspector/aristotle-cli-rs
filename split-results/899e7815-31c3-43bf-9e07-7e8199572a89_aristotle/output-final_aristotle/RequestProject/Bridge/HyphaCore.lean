/-
# HyphaCore — The Boardroom Layer (Pre-Feedback Partial Coalgebra)

## Regime: Hypha (Pure Partial Chains)

This is the first of three layers in the regime-separated architecture.
No feedback, no failure tracking, no observation. Only successful landings
are recorded. This is the clean proof regime: ZKP-exportable, the boardroom DAO.

### Key invariant

**Nothing in this file references FeedbackSignal, AttemptedStep, or any
tentacle-level structure.** The regime boundary is enforced at the import level:
TentacleCore imports HyphaCore, but HyphaCore does not import TentacleCore.
This is the type-level regime separation.

### Contents

- Activation (energetic event, Type not Prop, ZKP-extractable witness)
- PropagationF (the partial transition functor: Option (Activation × A))
- PartialCoalgebra (state space with partial transition)
- PartialPropStep / PartialChain (realized hypha-level propagation)
- MemeSystem (boardroom record: successful path + invariant)
- ComonadicMeme / MonadicActivation (dual pair)
- Vine (hypha-level quasi-fiber bundle)
- Concrete fungal chain (Cordyceps → Chytrid → Mycorrhiza → Decomposer)
-/

import Mathlib
import RequestProject.Bridge.FungalExtruder

set_option maxHeartbeats 800000

open ZMod Finset HeroMonster FixedPoint MonsterMycology

/-! ## §1. Activation — The Energetic Event

Viability is not a property of the chain — it is the energetic event that
the chain *is*. Each link fires only if there is an activation event in the
external system. Activation is the ATP, the meme invocation, the dehydration,
the decoding. -/

/-- An activation context: the energetic event that drives a propagation step.
    This is a Type (not a Prop) because the witness — the specific activation
    event — is extractable for ZKP purposes. -/
structure Activation where
  /-- Description of the activation event -/
  description : String
  /-- The energy level / work done -/
  workLevel : ℕ
  /-- Activation is non-trivial -/
  nontrivial : workLevel > 0
  deriving Repr

/-- An activation produces a witness: the proof that work was done. -/
def Activation.witness (a : Activation) : ℕ := a.workLevel

/-! ## §2. PropagationF — The Partial Transition Functor -/

/-- The partial transition functor. `none` = chain terminates (no landing site
    found). `some` = activation fired, result carries forward. -/
def PropagationF (A : Type) : Type := Option (Activation × A)

/-- A partial coalgebra: a state space with a partial transition function.
    This is the base structure for the hypha regime. -/
structure PartialCoalgebra (A : Type) where
  /-- The partial transition: may or may not produce a next state -/
  step : A → PropagationF A

/-- A step that landed successfully. -/
def PartialCoalgebra.landed {A : Type} (c : PartialCoalgebra A) (x : A) : Prop :=
  c.step x ≠ none

/-- A step that terminated (failed to find a landing site). -/
def PartialCoalgebra.terminated {A : Type} (c : PartialCoalgebra A) (x : A) : Prop :=
  c.step x = none

/-! ## §3. Hypha Regime — Realized Propagation (Boardroom)

Only successful landings are recorded. No error signal, no feedback.
This is the clean proof regime. -/

/-- A realized propagation step: the activation fired and the meme landed.
    **Hypha-level**: no record of failed attempts. This is what gets
    committed to the boardroom. -/
structure PartialPropStep {S T : Type} (mS : Metameme S) (mT : Metameme T) where
  /-- The activation event that drove this step -/
  activation : Activation
  /-- The invariant was preserved -/
  invariantPreserved : mT.invariant = mS.invariant
  /-- Viability was regenerated (not just conserved) -/
  viabilityRegenerated : mS.isViable → mT.isViable

/-- A chain of realized propagation steps. Each link is a successful landing.
    **Hypha-level**: the boardroom sees only this. Silent about failures.

    Note: this is a finite chain — termination is a constructor (`single`),
    not an axiom. The chain records exactly the realized trace. -/
inductive PartialChain :
    {S : Type} → {T : Type} → Metameme S → Metameme T → Type 1 where
  /-- A single realized step -/
  | single {S T : Type} {mS : Metameme S} {mT : Metameme T}
      (step : PartialPropStep mS mT) : PartialChain mS mT
  /-- Chain extension: a step followed by more steps -/
  | cons {S T U : Type} {mS : Metameme S} {mT : Metameme T} {mU : Metameme U}
      (step : PartialPropStep mS mT)
      (rest : PartialChain mT mU) : PartialChain mS mU

/-- Total work in a chain: sum of all activation energies. -/
def PartialChain.totalWork : {S T : Type} → {mS : Metameme S} → {mT : Metameme T} →
    PartialChain mS mT → ℕ
  | _, _, _, _, .single step => step.activation.workLevel
  | _, _, _, _, .cons step rest => step.activation.workLevel + rest.totalWork

/-- Length of a chain: number of realized steps. -/
def PartialChain.length : {S T : Type} → {mS : Metameme S} → {mT : Metameme T} →
    PartialChain mS mT → ℕ
  | _, _, _, _, .single _ => 1
  | _, _, _, _, .cons _ rest => 1 + rest.length

/-- The invariant is preserved through the entire chain.
    Proved by induction on realized steps only — no reference to failures. -/
theorem partialChain_preserves_invariant
    {S T : Type} {mS : Metameme S} {mT : Metameme T}
    (chain : PartialChain mS mT) :
    mT.invariant = mS.invariant := by
  induction chain with
  | single step => exact step.invariantPreserved
  | cons step _rest ih => exact ih ▸ step.invariantPreserved

/-- Viability is regenerated at each step of the chain.
    Each activation produces enough energy for the next step. -/
theorem partialChain_preserves_viability
    {S T : Type} {mS : Metameme S} {mT : Metameme T}
    (chain : PartialChain mS mT)
    (h : mS.isViable) :
    mT.isViable := by
  induction chain with
  | single step => exact step.viabilityRegenerated h
  | cons step _rest ih => exact ih (step.viabilityRegenerated h)

/-- The total work in a chain is always positive. -/
theorem partialChain_work_positive
    {S T : Type} {mS : Metameme S} {mT : Metameme T}
    (chain : PartialChain mS mT) :
    chain.totalWork > 0 := by
  induction chain with
  | single step => exact step.activation.nontrivial
  | cons step _ _ => exact Nat.lt_of_lt_of_le step.activation.nontrivial (Nat.le_add_right _ _)

/-! ## §4. Concrete Fungal Partial Chain — Boardroom Record -/

/-- Activation: Cordyceps → Chytrid. -/
def cordycepsActivation : Activation where
  description := "Cordyceps spore germination: host colonization event"
  workLevel := 3
  nontrivial := by omega

/-- Activation: Chytrid → Mycorrhiza. -/
def chytridActivation : Activation where
  description := "Chytrid → Mycorrhiza: pathogen-to-symbiont transduction"
  workLevel := 5
  nontrivial := by omega

/-- Activation: Mycorrhiza → Decomposer. -/
def mycorrhizaActivation : Activation where
  description := "Mycorrhiza → Decomposer: symbiont-to-decomposer transduction"
  workLevel := 4
  nontrivial := by omega

/-- Step 1: Cordyceps → Chytrid (realized). -/
def cordyceps_chytrid_step :
    PartialPropStep cordycepsMetameme cordyceps_to_chytrid.result where
  activation := cordycepsActivation
  invariantPreserved := propagation_preserves_invariant cordyceps_to_chytrid
  viabilityRegenerated := propagation_preserves_viability cordyceps_to_chytrid

/-- Step 2: Chytrid → Mycorrhiza (realized). -/
def chytrid_mycorrhiza_step :
    PartialPropStep cordyceps_to_chytrid.result chytrid_to_mycorrhiza.result where
  activation := chytridActivation
  invariantPreserved := propagation_preserves_invariant chytrid_to_mycorrhiza
  viabilityRegenerated := propagation_preserves_viability chytrid_to_mycorrhiza

/-- Step 3: Mycorrhiza → Decomposer (realized). -/
def mycorrhiza_decomposer_step :
    PartialPropStep chytrid_to_mycorrhiza.result mycorrhiza_to_decomposer.result where
  activation := mycorrhizaActivation
  invariantPreserved := propagation_preserves_invariant mycorrhiza_to_decomposer
  viabilityRegenerated := propagation_preserves_viability mycorrhiza_to_decomposer

/-- The full fungal partial chain: a boardroom-verified record of three
    successful landings. Silent about branches that didn't land. -/
def fungalPartialChain :
    PartialChain cordycepsMetameme mycorrhiza_to_decomposer.result :=
  .cons cordyceps_chytrid_step
    (.cons chytrid_mycorrhiza_step
      (.single mycorrhiza_decomposer_step))

/-- The selfish meme persists through the fungal partial chain. -/
theorem fungalPartialChain_preserves_monomyth :
    mycorrhiza_to_decomposer.result.invariant = canonicalMonomyth :=
  partialChain_preserves_invariant fungalPartialChain

/-- The fungal partial chain regenerates viability at each step. -/
theorem fungalPartialChain_preserves_viability :
    mycorrhiza_to_decomposer.result.isViable :=
  partialChain_preserves_viability fungalPartialChain cordycepsMetameme_viable

/-- Total ecological work: 3 + 5 + 4 = 12 activation units. -/
theorem fungalPartialChain_total_work :
    fungalPartialChain.totalWork = 12 := by rfl

/-- Three successful landings. -/
theorem fungalPartialChain_length :
    fungalPartialChain.length = 3 := by rfl

/-! ## §5. MemeSystem — Boardroom Record

The hypha-level meme system: a record of successful computations.
This is what the boardroom DAO operates on. No reference to failure. -/

/-- A MemeSystem captures the boardroom's view of propagation:
    - A state space with partial dynamics
    - An invariant (the selfish meme)
    - A successful path through the substrate
    - Proof that the invariant held at every realized node -/
structure MemeSystem where
  /-- The state space -/
  State : Type
  /-- Partial transition: may or may not produce a next state -/
  step : State → Option State
  /-- The selfish meme: a predicate on states -/
  invariant : State → Prop
  /-- The observed successful path -/
  path : List State
  /-- The path is non-empty -/
  pathNonempty : path ≠ []
  /-- Adjacent elements are connected by successful steps -/
  pathValid : ∀ i : Fin (path.length - 1),
    step (path[i.val]'(by omega)) = some (path[i.val + 1]'(by omega))
  /-- The invariant holds at every realized node -/
  invHeld : ∀ x ∈ path, invariant x

/-- The initial state of a meme system. -/
def MemeSystem.initial (sys : MemeSystem) : sys.State :=
  sys.path.head sys.pathNonempty

/-- The terminal state (where the last activation landed).
    Note: "terminal" here means "last observed landing in this finite trace."
    It does NOT assume the system has halted or that continuation is impossible.
    It is just the rightmost node in the realized hypha record. -/
def MemeSystem.terminal (sys : MemeSystem) : sys.State :=
  sys.path.getLast sys.pathNonempty

/-- The invariant holds at the initial state. -/
theorem MemeSystem.invariant_at_initial (sys : MemeSystem) :
    sys.invariant sys.initial := by
  apply sys.invHeld
  exact List.head_mem sys.pathNonempty

/-- The invariant holds at the terminal state. -/
theorem MemeSystem.invariant_at_terminal (sys : MemeSystem) :
    sys.invariant sys.terminal := by
  apply sys.invHeld
  exact List.getLast_mem sys.pathNonempty

/-! ## §6. The Comonadic / Monadic Dual Pair

The two preservation theorems are dual:

- **Invariant (comonadic extract)**: extracted at each step, unchanged.
  Regime-independent — works at hypha level (no feedback needed).

- **Viability (monadic bind)**: each activation binds into a new context.
  At hypha-level: just successful threading.

The selfish meme rides through every activation (comonadic extract)
while consuming and regenerating activation (monadic bind). -/

/-- The comonadic structure on meme states: extract the invariant. -/
structure ComonadicMeme (A : Type) where
  /-- The carrier state -/
  state : A
  /-- Extract the invariant from any state -/
  extract : A → MonomythSignature
  /-- Duplicate: embed in richer context (only on successful landings) -/
  duplicate : A → Option A

/-- The monadic structure on activation: bind into a new context. -/
structure MonadicActivation (A : Type) where
  /-- The current activation state -/
  state : A
  /-- Bind: attempt to produce the next activation.
      Returns `none` if the substrate fails to produce a landing. -/
  bind : A → Option (Activation × A)

/-- The dual pair: comonad (invariant) + monad (activation).
    Coherence: extract is stable under successful bind. -/
structure MemeComonadMonadPair (A : Type) where
  comonad : ComonadicMeme A
  monad : MonadicActivation A
  /-- The selfish meme persists: extract is stable under successful bind -/
  coherence : ∀ x a y,
    monad.bind x = some (a, y) →
    comonad.extract y = comonad.extract x

/-! ## §7. The Vine — Hypha-Level Quasi-Fiber Bundle -/

/-- A vine in the quasi-fiber bundle: a section that may or may not
    find a fiber at each base point. **Hypha-level**: silent about misses. -/
structure Vine (Base Fiber : Type) where
  /-- The section: attempt to find a fiber at each base point -/
  section_ : Base → Option Fiber
  /-- The invariant that the vine carries -/
  extract : Fiber → MonomythSignature
  /-- Successfully landed fibers -/
  landings : List (Base × Fiber)
  /-- All landings are genuine -/
  landingsValid : ∀ bf ∈ landings, section_ bf.1 = some bf.2
  /-- The invariant is stable across all landings -/
  invariantStable : ∀ bf₁ bf₂,
    bf₁ ∈ landings → bf₂ ∈ landings →
    extract bf₁.2 = extract bf₂.2

/-- The number of successful landings. -/
def Vine.numLandings {B F : Type} (v : Vine B F) : ℕ := v.landings.length

/-- A vine with at least one landing has a well-defined invariant. -/
def Vine.memeSignature {B F : Type} (v : Vine B F)
    (h : v.landings ≠ []) : MonomythSignature :=
  v.extract (v.landings.head h).2

/-! ## §8. The Fungal Vine — Concrete Boardroom Record -/

/-- The fungal vine: the monomyth section over the Totality lattice.
    Lands at the four canonical fungal positions.
    **Hypha-level**: silent about the rest of the lattice. -/
noncomputable def fungalVine : Vine Totality MonomythSignature where
  section_ := fun pt =>
    if pt = cordycepsProcess.home then some canonicalMonomyth
    else if pt = chytridProcess.home then some canonicalMonomyth
    else if pt = mycorrhizalProcess.home then some canonicalMonomyth
    else if pt = decomposerProcess.home then some canonicalMonomyth
    else none
  extract := id
  landings := [
    (cordycepsProcess.home, canonicalMonomyth),
    (chytridProcess.home, canonicalMonomyth),
    (mycorrhizalProcess.home, canonicalMonomyth),
    (decomposerProcess.home, canonicalMonomyth)
  ]
  landingsValid := by
    intro ⟨b, f⟩ hmem
    simp [List.mem_cons, Prod.mk.injEq] at hmem
    rcases hmem with ⟨rfl, rfl⟩ | ⟨rfl, rfl⟩ | ⟨rfl, rfl⟩ | ⟨rfl, rfl⟩ <;> simp
  invariantStable := by
    intro ⟨_, f₁⟩ ⟨_, f₂⟩ h₁ h₂
    simp [List.mem_cons, Prod.mk.injEq] at h₁ h₂
    rcases h₁ with ⟨_, rfl⟩ | ⟨_, rfl⟩ | ⟨_, rfl⟩ | ⟨_, rfl⟩ <;>
    rcases h₂ with ⟨_, rfl⟩ | ⟨_, rfl⟩ | ⟨_, rfl⟩ | ⟨_, rfl⟩ <;>
    rfl

/-- The fungal vine has exactly 4 landings. -/
theorem fungalVine_landings : fungalVine.numLandings = 4 := by rfl

/-- The fungal vine carries the canonical monomyth. -/
theorem fungalVine_carries_monomyth :
    fungalVine.memeSignature (by simp [fungalVine]) = canonicalMonomyth := by
  rfl
