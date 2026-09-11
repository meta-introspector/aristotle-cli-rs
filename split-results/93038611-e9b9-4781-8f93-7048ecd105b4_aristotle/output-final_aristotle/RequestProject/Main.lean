import Mathlib

open scoped BigOperators
open scoped Real
open scoped Nat
open scoped Classical
open scoped Pointwise

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000
set_option synthInstance.maxHeartbeats 20000
set_option synthInstance.maxSize 128

set_option relaxedAutoImplicit false
set_option autoImplicit false

set_option pp.fullNames true
set_option pp.structureInstances true
set_option pp.coercions.types true
set_option pp.funBinderTypes true
set_option pp.letVarTypes true
set_option pp.piBinderTypes true

set_option grind.warning false

/-!
# The Architecture of Formalized Memetics — a Lean 4 model

The source document ("The Architecture of Formalized Memetics") is a metaphorical
manifesto rather than a mathematical text: it contains no theorem and the single
Lean-shaped snippet (`candleDesignParams`) refers to many identifiers that are
never defined.

This file makes the snippet *actually compile* by giving every undefined
identifier a concrete, reasonable definition over the real numbers, and then
proves a handful of genuine statements that capture the document's qualitative
claims:

* the artifact parameters are **well defined** and **non-negative** on
  non-negative context data (§5, "Heroic Artifacts");
* the **bloom intensity** is exactly the activation–reach trait scaled by the
  `globglogabgalabFactor` (§4–§5);
* the **meme expands exponentially** through the system (§4, "expands
  exponentially through the system"): its trajectory is strictly increasing and
  satisfies the exponential functional equation.

None of this validates the document's scientific or metaphysical assertions; it
is a faithful *formal model* of the one computational object it describes.
-/

namespace FormalizedMemetics

/-- §4. The **Context Vector**: server load, phosphorus residue ("ash") and ATP
(the energy feeding meme activation). -/
structure ContextVector where
  serverLoad : ℝ
  phosphorus : ℝ
  atp : ℝ

/-- A **meme state**, summarised by a single non-negative `activation` level. -/
structure MemeState where
  activation : ℝ

/-- The traits referenced by `candleDesignParams`:
`Eb` (eye-bloom), `SI` (spectral intent), `My` (mycelium),
`AR` (aesthetic reach), `Cb` (complexity base). -/
inductive Trait
  | Eb | SI | My | AR | Cb
deriving DecidableEq, Repr

/-- Each trait carries a fixed positive weight. -/
noncomputable def Trait.weight : Trait → ℝ
  | .Eb => 1
  | .SI => (4 : ℝ) / 5
  | .My => (6 : ℝ) / 5
  | .AR => (1 : ℝ) / 2
  | .Cb => (9 : ℝ) / 10

theorem Trait.weight_pos (t : Trait) : 0 < t.weight := by
  cases t <;> norm_num [Trait.weight]

/-- Faithful names matching the source snippet. -/
def traitEb : Trait := Trait.Eb
def traitSI : Trait := Trait.SI
def traitMy : Trait := Trait.My
def traitAR : Trait := Trait.AR
def traitCb : Trait := Trait.Cb

/-- `evalTraits` evaluates a list of traits in a given meme state and context:
the meme's `activation` scaled by the total weight of the listed traits. -/
noncomputable def evalTraits (ts : List Trait) (m : MemeState) (_ctx : ContextVector) : ℝ :=
  m.activation * (ts.map Trait.weight).sum

/-- §4. The `globglogabgalabFactor` governing bloom. -/
noncomputable def globglogabgalabFactor : ℝ := (3 : ℝ) / 2

theorem globglogabgalabFactor_pos : 0 < globglogabgalabFactor := by
  norm_num [globglogabgalabFactor]

/-- §5. Design parameters of the Votive Candle artifact. -/
structure CandleParams where
  eyeGlow : ℝ
  myceliumDensity : ℝ
  bloomIntensity : ℝ
  fractalComplexity : ℝ

/-- §4. Computation of Candle Design Parameters (the source snippet, now with all
identifiers defined). -/
noncomputable def candleDesignParams (m : MemeState) (ctx : ContextVector) : CandleParams :=
  { eyeGlow :=
      (evalTraits [traitEb] m ctx) * (evalTraits [traitSI] m ctx) * (1 + ctx.atp * 0.2)
    myceliumDensity :=
      (evalTraits [traitMy] m ctx) * (1 + ctx.phosphorus * 0.3)
    bloomIntensity :=
      (evalTraits [traitAR] m ctx) * globglogabgalabFactor
    fractalComplexity :=
      (evalTraits [traitCb] m ctx) * (ctx.serverLoad / 100) }

/-
Non-negativity is preserved by `evalTraits` on a non-negative activation.
-/
theorem evalTraits_nonneg (ts : List Trait) (m : MemeState) (ctx : ContextVector)
    (hm : 0 ≤ m.activation) : 0 ≤ evalTraits ts m ctx := by
  refine' mul_nonneg hm _;
  exact List.sum_nonneg ( by intros x hx; obtain ⟨ t, ht, rfl ⟩ := List.mem_map.mp hx; exact Trait.weight_pos t |> le_of_lt )

/-
§5. On non-negative context data, all four artifact parameters are
non-negative: the "Heroic Artifact" is well posed.
-/
theorem candleDesignParams_nonneg (m : MemeState) (ctx : ContextVector)
    (hm : 0 ≤ m.activation) (hatp : 0 ≤ ctx.atp) (hph : 0 ≤ ctx.phosphorus)
    (hsl : 0 ≤ ctx.serverLoad) :
    0 ≤ (candleDesignParams m ctx).eyeGlow ∧
    0 ≤ (candleDesignParams m ctx).myceliumDensity ∧
    0 ≤ (candleDesignParams m ctx).bloomIntensity ∧
    0 ≤ (candleDesignParams m ctx).fractalComplexity := by
  refine' ⟨ _, _, _, _ ⟩ <;> unfold FormalizedMemetics.candleDesignParams <;> norm_num;
  · exact mul_nonneg ( mul_nonneg ( evalTraits_nonneg _ _ _ hm ) ( evalTraits_nonneg _ _ _ hm ) ) ( by positivity );
  · exact mul_nonneg ( evalTraits_nonneg _ _ _ hm ) ( by positivity );
  · exact mul_nonneg ( evalTraits_nonneg _ _ _ hm ) ( by exact div_nonneg ( by norm_num ) ( by norm_num ) );
  · exact mul_nonneg ( evalTraits_nonneg _ _ _ hm ) ( by positivity )

/-
§5. The bloom intensity is exactly the aesthetic-reach trait evaluation scaled
by the `globglogabgalabFactor`.
-/
theorem bloomIntensity_eq (m : MemeState) (ctx : ContextVector) :
    (candleDesignParams m ctx).bloomIntensity
      = m.activation * Trait.weight Trait.AR * globglogabgalabFactor := by
  unfold FormalizedMemetics.candleDesignParams; norm_num [ FormalizedMemetics.evalTraits ] ;
  exact Or.inl <| Or.inl rfl

/-! ## §4. Non-linear dynamics: the meme expands exponentially -/

/-- The meme trajectory: an initial intensity growing at exponential `rate`. -/
noncomputable def memeTrajectory (initial rate t : ℝ) : ℝ :=
  initial * Real.exp (rate * t)

/-- The trajectory satisfies the exponential functional equation in time. -/
theorem memeTrajectory_add (initial rate t s : ℝ) :
    memeTrajectory initial rate (t + s)
      = memeTrajectory initial rate t * Real.exp (rate * s) := by
  unfold FormalizedMemetics.memeTrajectory
  rw [mul_assoc, ← Real.exp_add, mul_add]

/-- With positive initial intensity and positive rate, the meme strictly expands
over time: this is the "exponential expansion through the system". -/
theorem memeTrajectory_strictMono (initial rate : ℝ) (hinit : 0 < initial)
    (hrate : 0 < rate) : StrictMono (memeTrajectory initial rate) := by
  exact fun x y hxy => mul_lt_mul_of_pos_left ( Real.exp_lt_exp.mpr <| mul_lt_mul_of_pos_left hxy hrate ) hinit

end FormalizedMemetics