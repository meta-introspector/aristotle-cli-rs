import Mathlib
import RequestProject.EngineMonoidal

/-!
# A monoidal composition functor over execution traces

This module answers the **execution-trace** direction: a *monoidal composition
functor* sending an execution trace of the extension engine to the synchronized
endofunctor that runs it.

An **execution trace** is a finite record of what the cart actually did: a list of
steps, where each step fires some number of *parallel* carts.  Traces compose by
*concatenation* (run one trace, then the next), with the empty trace as the unit —
i.e. traces form the free monoid `FreeMonoid ℕ`.

The headline construction `runTrace : Trace → (ℕ ⥤ ℕ)` interprets a trace as the
synchronized endofunctor (`cartPow` of the total cart count) of
`RequestProject/EngineMonoidal.lean`.  It is a **strict monoidal functor** out of
the (one-object) monoidal category of traces:

* `runTrace_nil` — the empty trace maps to the monoidal **unit** (the idle engine).
* `runTrace_append` — concatenation of traces maps to the **tensor product** of
  their engines; composing execution traces *is* tensoring (composing) the carts.
* `traceTotalHom` — the total cart count is a genuine **monoid homomorphism**
  `FreeMonoid ℕ →* Multiplicative ℕ`, the numerical shadow of the functor.

Everything compiles and every `theorem` is fully proved (no `sorry`).
-/

open CategoryTheory CategoryTheory.MonoidalCategory

namespace Aristotle.Extension

attribute [local instance] endofunctorMonoidalCategory

/-! ## Execution traces -/

/-- An **execution trace**: a finite sequence of cart steps, each step recording
how many parallel carts were fired.  Traces compose by concatenation, with the
empty trace `[]` as unit — i.e. the free monoid on `ℕ`. -/
abbrev Trace := List ℕ

/-- The **total cart count** of a trace: the sum of all its parallel-cart steps. -/
def traceTotal (t : Trace) : ℕ := t.sum

@[simp] theorem traceTotal_nil : traceTotal [] = 0 := rfl

@[simp] theorem traceTotal_append (s t : Trace) :
    traceTotal (s ++ t) = traceTotal s + traceTotal t := by
  simp [traceTotal]

@[simp] theorem traceTotal_singleton (n : ℕ) : traceTotal [n] = n := by
  simp [traceTotal]

/-! ## The interpretation functor -/

/-- **Running an execution trace.**  Interpret a trace as the synchronized engine
endofunctor: `cartPow` of the trace's total cart count.  This is the object map of
the monoidal composition functor. -/
noncomputable def runTrace (t : Trace) : (ℕ ⥤ ℕ) := cartPow (traceTotal t)

/-- Running a trace advances the global index by the total cart count. -/
theorem runTrace_obj (t : Trace) (k : ℕ) : (runTrace t).obj k = k + traceTotal t := by
  rw [runTrace, cartPow_obj]

/-- **The empty trace is the idle engine.**  Running the empty execution trace
gives the monoidal **unit** `𝟙_ (ℕ ⥤ ℕ)`: the functor preserves the unit strictly. -/
theorem runTrace_nil : runTrace [] = 𝟙_ (ℕ ⥤ ℕ) := rfl

/-- **Concatenation maps to the tensor product (on objects).**  Running a
concatenated trace `s ++ t` agrees on objects with tensoring the two engines:
composing execution traces *is* composing (tensoring) the synchronized carts. -/
theorem runTrace_append_obj (s t : Trace) (k : ℕ) :
    (runTrace (s ++ t)).obj k = (runTrace s ⊗ runTrace t).obj k := by
  rw [runTrace, runTrace, runTrace, traceTotal_append, cartPow_add_obj]

/-- **Strict monoidal preservation of composition.**  Running a concatenated trace
equals tensoring the two engines as *functors* (`ℕ ⥤ ℕ`), not merely on objects:
the index category `ℕ` is a thin category, so functors are pinned down by their
object map.  This is the defining law of the monoidal composition functor. -/
theorem runTrace_append (s t : Trace) :
    runTrace (s ++ t) = runTrace s ⊗ runTrace t := by
  simp only [runTrace, traceTotal_append]
  convert CategoryTheory.Functor.ext _ _
  · convert cartPow_add_obj (traceTotal s) (traceTotal t) using 1
  · aesop

/-- The total cart count is **additive** over composition — the numerical shadow
of the monoidal functor preserving tensor. -/
theorem runTrace_total_append (s t : Trace) :
    traceTotal (s ++ t) = traceTotal s + traceTotal t := traceTotal_append s t

/-! ## The numerical monoid homomorphism -/

/-- **The total-count monoid homomorphism.**  The total cart count is a genuine
monoid homomorphism from the free monoid of execution traces `FreeMonoid ℕ` to
`Multiplicative ℕ`: concatenation of traces maps to addition of cart counts.  This
is the one-dimensional shadow of the monoidal composition functor. -/
def traceTotalHom : FreeMonoid ℕ →* Multiplicative ℕ where
  toFun t := Multiplicative.ofAdd (traceTotal (FreeMonoid.toList t))
  map_one' := by simp [traceTotal]
  map_mul' s t := by
    apply Multiplicative.toAdd.injective
    simp [traceTotal, FreeMonoid.toList_mul]

@[simp] theorem traceTotalHom_apply (t : FreeMonoid ℕ) :
    Multiplicative.toAdd (traceTotalHom t) = traceTotal (FreeMonoid.toList t) := rfl

/-! ## Inexhaustibility is preserved -/

/-- **A non-empty trace never stalls.**  Any trace that fires at least one cart
strictly advances the global index: running execution traces preserves the
inexhaustibility of the cart–carrot motion. -/
theorem runTrace_strict (t : Trace) (k : ℕ) (ht : 0 < traceTotal t) :
    k < (runTrace t).obj k := by
  rw [runTrace_obj]; omega

end Aristotle.Extension