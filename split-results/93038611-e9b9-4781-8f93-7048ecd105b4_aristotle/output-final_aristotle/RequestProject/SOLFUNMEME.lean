import RequestProject.Main

open scoped BigOperators
open scoped Real
open scoped Classical

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000

set_option relaxedAutoImplicit false
set_option autoImplicit false

/-!
# SOLFUNMEME — the meme as an instance of itself, and a rewrite calculus

This file extends `RequestProject.Main` with two further pieces of the document's
informal program:

1. **"Insert this meme as an instance of itself."**  We realise the closed
   semantic loop (the "ZOS self-evaluation"): a `MemeState` is embedded as its
   *own* `ContextVector` and then evaluated against the full trait list.  This
   yields a one-dimensional discrete dynamical system whose iterates expand
   exponentially — tying the self-reference back to §4's "exponential
   expansion".

2. **#SOLFUNMEME: a formally verified, invariant-preserving rewrite calculus
   with consensus-constrained evolution.**  We give a small core of rewrites,
   invariants and a consensus filter, and prove that concrete rewrites are
   *admissible* (consensus-respecting and invariant-preserving), so that the
   induced evolution is well posed.

As in `Main.lean`, this is a faithful *formal model* of the document's
computational vocabulary, not a validation of its metaphysical claims.
-/

namespace FormalizedMemetics

/-! ## Insert the meme as an instance of itself (the ZOS self-evaluation loop) -/

/-- Canonical embedding of a meme state as its **own** context: the state's
single `activation` value is poured into every slot of the `ContextVector`.
This is the literal "insert the meme as an instance of itself". -/
noncomputable def MemeState.toContext (m : MemeState) : ContextVector :=
  { serverLoad := m.activation
    phosphorus := m.activation
    atp := m.activation }

/-- The self-evaluation of a meme: evaluate the full trait list with the meme
acting simultaneously as subject and as context. -/
noncomputable def MemeState.selfEval (m : MemeState) : ℝ :=
  evalTraits [traitEb, traitSI, traitMy, traitAR, traitCb] m m.toContext

/-
The total trait weight `1 + 4/5 + 6/5 + 1/2 + 9/10 = 22/5`, so the
self-evaluation is `activation * 22/5`.
-/
theorem selfEval_eq (m : MemeState) : m.selfEval = m.activation * (22 / 5) := by
  unfold MemeState.selfEval evalTraits;
  norm_num [ traitEb, traitSI, traitMy, traitAR, traitCb, Trait.weight ]

/-
Self-evaluation preserves non-negativity.
-/
theorem selfEval_nonneg (m : MemeState) (hm : 0 ≤ m.activation) : 0 ≤ m.selfEval := by
  exact selfEval_eq m ▸ mul_nonneg hm ( by norm_num )

/-- The **self-step**: the meme reinstantiated as itself, whose new activation is
its own self-evaluation.  Iterating this is the closed memetic loop. -/
noncomputable def selfStep (m : MemeState) : MemeState :=
  { activation := m.selfEval }

/-
Iterating the self-step makes the activation grow geometrically with ratio
`22/5` — the self-referential meme expands exponentially.
-/
theorem selfStep_iterate (m : MemeState) (n : ℕ) :
    (selfStep^[n] m).activation = m.activation * (22 / 5) ^ n := by
  induction' n with n ih generalizing m <;> simp_all +decide [ Function.iterate_succ_apply' ];
  rw [ pow_succ' ] ; have := ih m; simp_all +decide [ selfStep, selfEval_eq ] ; ring;

/-
The only fixed point of the self-step is the trivial (zero-activation) meme:
in the Zero Ontology System the unique stationary meme is the void.
-/
theorem selfStep_fixed_iff (m : MemeState) :
    selfStep m = m ↔ m.activation = 0 := by
  constructor <;> intro h <;> unfold selfStep at *;
  · have := congr_arg MemeState.activation h; rw [ selfEval_eq ] at this; nlinarith;
  · rw [ show m.selfEval = 0 by rw [ selfEval_eq, h ] ; ring ] ; cases m ; aesop

end FormalizedMemetics

/-! ## #SOLFUNMEME: an invariant-preserving, consensus-constrained rewrite calculus -/

namespace SOLFUNMEME

open FormalizedMemetics

/-- A meme is a state together with its contextual embedding. -/
structure Meme where
  state : MemeState
  context : ContextVector

/-- A rewrite step: a local transformation of a meme. -/
structure Rewrite where
  apply : Meme → Meme

/-- An invariant: a property that admissible rewrites must preserve. -/
def Invariant := Meme → Prop

/-- A consensus constraint: a global admissibility predicate on rewrites. -/
def Consensus := Rewrite → Prop

/-- A SOLFUNMEME system: a list of invariants together with a consensus filter. -/
structure System where
  invariants : List Invariant
  consensus : Consensus

/-- A rewrite is **admissible** for a system when it satisfies consensus and
preserves every invariant. -/
def admissible (sys : System) (r : Rewrite) : Prop :=
  sys.consensus r ∧
    ∀ m, (∀ I ∈ sys.invariants, I m) → (∀ I ∈ sys.invariants, I (r.apply m))

/-- One evolution step: apply an admissible rewrite, otherwise reject. -/
noncomputable def evolve (sys : System) (r : Rewrite) (m : Meme) : Option Meme :=
  if admissible sys r then some (r.apply m) else none

/-! ### Concrete invariants and consensus -/

/-- §5. Non-negativity of all four artifact parameters is an invariant (this is
the user's `heroicArtifactInvariant`). -/
def heroicArtifactInvariant : Invariant :=
  fun m =>
    let p := candleDesignParams m.state m.context
    0 ≤ p.eyeGlow ∧ 0 ≤ p.myceliumDensity ∧
      0 ≤ p.bloomIntensity ∧ 0 ≤ p.fractalComplexity

/-- Non-negativity of the underlying data (activation and every context slot).
This is the natural *preservable* invariant. -/
def dataNonneg : Invariant :=
  fun m =>
    0 ≤ m.state.activation ∧ 0 ≤ m.context.serverLoad ∧
      0 ≤ m.context.phosphorus ∧ 0 ≤ m.context.atp

/-
Non-negative data guarantees the heroic-artifact invariant (via
`candleDesignParams_nonneg`).
-/
theorem dataNonneg_imp_heroic (m : Meme) (h : dataNonneg m) :
    heroicArtifactInvariant m := by
  exact candleDesignParams_nonneg _ _ h.1 h.2.2.2 h.2.2.1 h.2.1

/-- Consensus rule: a rewrite never decreases the activation. -/
def nonDecreasingActivationConsensus : Consensus :=
  fun r => ∀ m, m.state.activation ≤ (r.apply m).state.activation

/-- The canonical SOLFUNMEME system: it preserves non-negativity of the data and
only admits non-decreasing rewrites. -/
def solfunmemeSystem : System :=
  { invariants := [dataNonneg]
    consensus := nonDecreasingActivationConsensus }

/-! ### Concrete admissible rewrites -/

/-- The identity rewrite. -/
def idRewrite : Rewrite := ⟨id⟩

/-- The additive **boost** rewrite: increase activation by a fixed `d`, leaving
the context untouched. -/
noncomputable def boostRewrite (d : ℝ) : Rewrite :=
  ⟨fun m => { state := { activation := m.state.activation + d }, context := m.context }⟩

/-
The identity rewrite is admissible for the canonical system.
-/
theorem idRewrite_admissible : admissible solfunmemeSystem idRewrite := by
  exact ⟨ fun _ => le_rfl, fun _ _ => by tauto ⟩

/-
A non-negative boost is admissible for the canonical system: it never
decreases activation and preserves non-negativity of the data.
-/
theorem boostRewrite_admissible (d : ℝ) (hd : 0 ≤ d) :
    admissible solfunmemeSystem (boostRewrite d) := by
  constructor;
  · exact fun m => le_add_of_nonneg_right hd;
  · -- By definition of `dataNonneg`, we need to show that the boosted meme's activation and context slots are non-negative.
    intro m hm
    simp [solfunmemeSystem, dataNonneg] at hm ⊢;
    exact ⟨ add_nonneg hm.1 hd, hm.2.1, hm.2.2.1, hm.2.2.2 ⟩

/-
Evolution under an admissible rewrite actually fires.
-/
theorem evolve_idRewrite (m : Meme) :
    evolve solfunmemeSystem idRewrite m = some m := by
  exact if_pos ( idRewrite_admissible )

/-
Evolution under a non-negative boost fires and produces the boosted meme.
-/
theorem evolve_boostRewrite (d : ℝ) (hd : 0 ≤ d) (m : Meme) :
    evolve solfunmemeSystem (boostRewrite d) m
      = some { state := { activation := m.state.activation + d }, context := m.context } := by
  exact if_pos ( boostRewrite_admissible d hd )

/-
Iterating a non-negative boost preserves the `dataNonneg` invariant: the
consensus-constrained evolution is well posed for all time.
-/
theorem boost_iterate_dataNonneg (d : ℝ) (hd : 0 ≤ d) (m : Meme)
    (hm : dataNonneg m) (n : ℕ) :
    dataNonneg ((boostRewrite d).apply^[n] m) := by
  induction' n with n ih;
  · exact hm;
  · simp_all +decide [ Function.iterate_succ_apply', dataNonneg, boostRewrite ];
    linarith

end SOLFUNMEME