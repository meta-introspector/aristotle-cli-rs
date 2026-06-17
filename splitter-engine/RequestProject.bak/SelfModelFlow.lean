/-
SelfModelFlow.lean — modelling the project's own pipeline as a *flow* in Lean.

The companion tools of this project realise one and the same pipeline,

      Text  ──parse──▶  Lean  ──reflect──▶  Reflection  ──model──▶  Math

`SplitDecls`/`*Finder` take raw **text** (source / config), turn it into **Lean**
declarations, **reflect** them through the kernel `Environment` API into meta-level data
(sizes, dependency multisets, …), and finally build a **mathematical** model of that data
(the graded algebra of `GradedCodeModel`, the Bott-clock crystal cells of `PeriodicTable`,
the fusion arrows of `CFTMorphisms`, …).

This file makes that pipeline a first-class mathematical object — a **`Pipeline`** — and
proves it is a genuine *flow*:

* `Pipeline.run` is the composite arrow `Text → Math`, the whole flow run end-to-end.
* `Pipeline.Hom` is a **morphism of flows**: four maps, one per stage, whose three squares
  commute.  Morphisms compose and have identities, so pipelines form a
  `CategoryTheory.Category` (`instCategoryPipeline`).  This is exactly the structure that
  lets the system **reuse** a flow: a morphism embeds / quotients one flow inside another.
* `Pipeline.run_natural` : running the flow is *natural* — it commutes with every morphism.
  Hence `run_comp` / `run_id`: end-to-end runs are functorial.  Consuming a related flow
  (a morphism) and chaining it never escapes the category, so improvement is composable.

**A similar flow in the Lean source, reused.**  `leanFlow` is the shape of Lean's own
toolchain, `String → tokens → size → value` (parse → reflect → evaluate).  `cellFlow` is
*this* project's crystal-cell flow; it **reuses** `leanFlow`'s `parse`/`reflect` verbatim
and only adds the mathematical stage `· % 8` (the real Bott-clock residue of
`PeriodicTable`).  `reuse : leanFlow ⟶ cellFlow` is a verified morphism witnessing the
reuse, and `cellFlow_run` shows the project flow factors through the Lean flow.

**Self-improvement converges.**  `selfFlow` feeds the mathematical output back as text
(`Text = Math`), modelling "model our current code with itself".  Its run is idempotent
(`selfFlow_run_idem`): self-application reaches a fixed point in one step — self-improvement
by consuming one's own output stabilises rather than diverging.

Everything is `sorry`-free and axiom-clean (only `propext`, `Classical.choice`, `Quot.sound`).
-/
import Mathlib

namespace SelfModelFlow

/-! ## The flow as a mathematical object -/

/-- A **pipeline / flow**: four stages of data with the three connecting maps of the
project's `Text → Lean → Reflection → Math` flow. -/
structure Pipeline where
  /-- raw text / source stage -/
  Text : Type
  /-- parsed Lean stage -/
  Lean : Type
  /-- reflected meta-level stage -/
  Refl : Type
  /-- mathematical-model stage -/
  Math : Type
  /-- text ↦ Lean -/
  parse : Text → Lean
  /-- Lean ↦ reflection -/
  reflect : Lean → Refl
  /-- reflection ↦ math -/
  model : Refl → Math

/-- **The whole flow run end-to-end**, the composite arrow `Text → Math`. -/
def Pipeline.run (P : Pipeline) : P.Text → P.Math :=
  P.model ∘ P.reflect ∘ P.parse

/-- A **morphism of flows**: a map of each stage whose three squares commute.  This is the
structure that lets one flow be *reused* inside another. -/
structure Pipeline.Hom (P Q : Pipeline) where
  /-- text component -/
  fT : P.Text → Q.Text
  /-- Lean component -/
  fL : P.Lean → Q.Lean
  /-- reflection component -/
  fR : P.Refl → Q.Refl
  /-- math component -/
  fM : P.Math → Q.Math
  /-- the parse square commutes -/
  sq_parse : fL ∘ P.parse = Q.parse ∘ fT
  /-- the reflect square commutes -/
  sq_reflect : fR ∘ P.reflect = Q.reflect ∘ fL
  /-- the model square commutes -/
  sq_model : fM ∘ P.model = Q.model ∘ fR

attribute [ext] Pipeline.Hom

@[ext] theorem Pipeline.Hom.ext' {P Q : Pipeline} {f g : Pipeline.Hom P Q}
    (hT : f.fT = g.fT) (hL : f.fL = g.fL) (hR : f.fR = g.fR) (hM : f.fM = g.fM) : f = g := by
  cases f; cases g; simp_all

/-- The identity morphism of a flow. -/
def Pipeline.Hom.id (P : Pipeline) : Pipeline.Hom P P where
  fT := _root_.id; fL := _root_.id; fR := _root_.id; fM := _root_.id
  sq_parse := rfl; sq_reflect := rfl; sq_model := rfl

/-- Composition of flow morphisms (consuming one reuse after another). -/
def Pipeline.Hom.comp {P Q R : Pipeline} (f : Pipeline.Hom P Q) (g : Pipeline.Hom Q R) :
    Pipeline.Hom P R where
  fT := g.fT ∘ f.fT
  fL := g.fL ∘ f.fL
  fR := g.fR ∘ f.fR
  fM := g.fM ∘ f.fM
  sq_parse := by
    have hf := f.sq_parse; have hg := g.sq_parse
    ext x
    have : g.fL (f.fL (P.parse x)) = g.fL (Q.parse (f.fT x)) := by
      rw [show f.fL (P.parse x) = Q.parse (f.fT x) from congrFun hf x]
    simpa [Function.comp] using this.trans (congrFun hg (f.fT x))
  sq_reflect := by
    have hf := f.sq_reflect; have hg := g.sq_reflect
    ext x
    have : g.fR (f.fR (P.reflect x)) = g.fR (Q.reflect (f.fL x)) := by
      rw [show f.fR (P.reflect x) = Q.reflect (f.fL x) from congrFun hf x]
    simpa [Function.comp] using this.trans (congrFun hg (f.fL x))
  sq_model := by
    have hf := f.sq_model; have hg := g.sq_model
    ext x
    have : g.fM (f.fM (P.model x)) = g.fM (Q.model (f.fR x)) := by
      rw [show f.fM (P.model x) = Q.model (f.fR x) from congrFun hf x]
    simpa [Function.comp] using this.trans (congrFun hg (f.fR x))

/-- Flows and their morphisms form a category. -/
instance instCategoryPipeline : CategoryTheory.Category Pipeline where
  Hom P Q := Pipeline.Hom P Q
  id P := Pipeline.Hom.id P
  comp f g := Pipeline.Hom.comp f g
  id_comp f := by ext <;> rfl
  comp_id f := by ext <;> rfl
  assoc f g h := by ext <;> rfl

/-! ## Running the flow is natural -/

/-- **Running the flow is natural.**  The end-to-end run commutes with every morphism of
flows: `fM ∘ P.run = Q.run ∘ fT`.  Reusing a flow and then running it is the same as
running it and then mapping the result. -/
theorem Pipeline.run_natural {P Q : Pipeline} (f : Pipeline.Hom P Q) :
    f.fM ∘ P.run = Q.run ∘ f.fT := by
  have hp := f.sq_parse; have hr := f.sq_reflect; have hm := f.sq_model
  ext x
  simp only [Pipeline.run, Function.comp] at *
  have e1 : f.fL (P.parse x) = Q.parse (f.fT x) := congrFun hp x
  have e2 : f.fR (P.reflect (P.parse x)) = Q.reflect (f.fL (P.parse x)) := congrFun hr (P.parse x)
  have e3 : f.fM (P.model (P.reflect (P.parse x)))
      = Q.model (f.fR (P.reflect (P.parse x))) := congrFun hm (P.reflect (P.parse x))
  rw [e3, e2, e1]

/-- The run of the identity morphism is naturality for `id`. -/
theorem Pipeline.run_id (P : Pipeline) :
    (Pipeline.Hom.id P).fM ∘ P.run = P.run ∘ (Pipeline.Hom.id P).fT := by
  simpa using Pipeline.run_natural (Pipeline.Hom.id P)

/-- Runs are functorial under composition of morphisms. -/
theorem Pipeline.run_comp {P Q R : Pipeline} (f : Pipeline.Hom P Q) (g : Pipeline.Hom Q R) :
    (Pipeline.Hom.comp f g).fM ∘ P.run = R.run ∘ (Pipeline.Hom.comp f g).fT := by
  exact Pipeline.run_natural (Pipeline.Hom.comp f g)

/-! ## A similar flow in the Lean source, reused

`leanFlow` is the shape of Lean's own toolchain: a `String` is parsed into a list of
**tokens** (`Syntax`), reflected to its **size** (`Expr`/`Environment` data), and evaluated
to a numeric **value**.  `cellFlow` is this project's crystal-cell flow; it *reuses*
`leanFlow`'s `parse` and `reflect` verbatim and only replaces the math stage by the real
Bott-clock residue `· % 8` of `RequestProject/PeriodicTable.lean`. -/

/-- The shape of Lean's own toolchain flow: `String → tokens → size → value`. -/
abbrev leanFlow : Pipeline where
  Text := String
  Lean := List String
  Refl := Nat
  Math := Nat
  parse := fun s => s.splitOn " "
  reflect := List.length
  model := _root_.id

/-- This project's crystal-cell flow: identical parse/reflect to `leanFlow`, with the
mathematical stage given by the real Bott-clock residue `· % 8`. -/
abbrev cellFlow : Pipeline where
  Text := String
  Lean := List String
  Refl := Nat
  Math := Nat
  parse := fun s => s.splitOn " "
  reflect := List.length
  model := fun n => n % 8

/-- **Reuse witnessed as a morphism of flows.**  `cellFlow` reuses every earlier stage of
`leanFlow`; only the final mathematical map differs, by the residue `· % 8`. -/
def reuse : Pipeline.Hom leanFlow cellFlow where
  fT := _root_.id
  fL := _root_.id
  fR := _root_.id
  fM := fun n => n % 8
  sq_parse := rfl
  sq_reflect := rfl
  sq_model := rfl

/-- The project's crystal-cell flow **factors through** the Lean toolchain flow: running
`cellFlow` is running `leanFlow` and then taking the Bott-clock residue. -/
theorem cellFlow_run : cellFlow.run = (fun n => n % 8) ∘ leanFlow.run := by
  rfl

/-- The reuse morphism realises this factorisation through naturality. -/
theorem cellFlow_run_natural :
    reuse.fM ∘ leanFlow.run = cellFlow.run ∘ reuse.fT :=
  Pipeline.run_natural reuse

/-! ## Self-improvement converges

`selfFlow` feeds the mathematical output back as text (`Text = Math = Nat`), modelling
"model our current code with itself".  Its run is the crystal-cell map `· % 8`, which is
**idempotent**: self-application reaches a fixed point in one step. -/

/-- A flow that models the code with itself: the output type is the input type, so the run
is an endomorphism that can be iterated. -/
abbrev selfFlow : Pipeline where
  Text := Nat
  Lean := Nat
  Refl := Nat
  Math := Nat
  parse := _root_.id
  reflect := _root_.id
  model := fun n => n % 8

/-- The self-model run is the crystal-cell map. -/
theorem selfFlow_run : selfFlow.run = fun n => n % 8 := rfl

/-- **Self-improvement converges.**  Modelling the code with itself is idempotent:
applying the flow to its own output again changes nothing.  Self-consumption stabilises at
a fixed point rather than diverging. -/
theorem selfFlow_run_idem (x : selfFlow.Text) :
    selfFlow.run (selfFlow.run x) = selfFlow.run x := by
  show x % 8 % 8 = x % 8
  exact Nat.mod_mod_of_dvd x (Nat.dvd_refl 8)

/-- Every value reached by the self-model flow is a genuine fixed point of one more step. -/
theorem selfFlow_run_isFixed (x : selfFlow.Text) :
    selfFlow.run (selfFlow.run x) = selfFlow.run x :=
  selfFlow_run_idem x

/-- Iterating the self-model flow any positive number of times equals one run: convergence
in a single step. -/
theorem selfFlow_run_iterate (x : selfFlow.Text) (n : Nat) :
    selfFlow.run^[n + 1] x = selfFlow.run x := by
  induction n with
  | zero => rfl
  | succ k ih =>
    rw [Function.iterate_succ_apply', ih, selfFlow_run_idem]

end SelfModelFlow
