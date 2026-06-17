/-
ShapeNarrative.lean — interpreting the data: atoms, arrows, and the stories they tell.

The earlier files give us the raw material of a *form*:

* atoms — the size axes / generators (`SizeSignature`, `ShapeAlgebra.Genuine.E`);
* arrows — the consecutive size-pairs / n-grams of a shape (`ShapeAlgebra.arrows`);
* a coordinate-free notion of structure (`ShapeAlgebra.StructuralShape`).

Here we begin to **interpret** that data: we read the formal objects as *narratives*, and we
look for the timeless patterns that recur across the whole construction. Each narrative beat
is pinned to a machine-checked theorem, so the story is not decoration — it is the proof.

Three classical narrative patterns and one meta-pattern:

1. **The Hero's Journey (monomyth).** Departure → Initiation → Return. An isolated axis
   (`departure`) is called out of its ordinary commutative world, crosses the threshold into
   the anti-commuting abyss (`ordeal` = the grade-2 bivector), survives the *supreme ordeal*
   of squaring into a negative scalar (`ordeal_squares_negative`), and returns to a world that
   is *changed* — order now matters (`world_changed`). As structure, a hero's journey is a
   three-act decomposition of a shape's arrows (`ThreeAct`, `exists_threeAct`).

2. **The Dialectic (thesis–antithesis–synthesis).** Two static generators are thesis and
   antithesis; their friction is anti-commutation (`antithesis_negates_thesis`); the
   `synthesis` is the bivector, whose tension *resolves* to a scalar (`synthesis_resolves`).

3. **The Weaver's Loom.** Distinct sizes are the `warp`, arrows are the `weft`; the woven
   `StructuralShape` pattern is invariant under *dyeing the threads* — any injective renaming
   (`loom_invariant_under_dyeing`) — and you cannot use more warp-threads than weft-passes
   (`warp_le_weft`).

4. **The timeless pattern of proving (Alexander's pattern language).** Across the project the
   *same proof* recurs: "two things are the same when they share a common form", `a ~ b ↔
   key a = key b`, and is then shown to be an equivalence. We name this pattern once
   (`ComparedBy`, `comparedBy_equivalence`) and exhibit every similarity notion in the project
   as a literal instance of it (`sameSize`, `similarN`, `RenEquiv`, `StructEqShape`).
-/
import Mathlib
import RequestProject.SizeSignature
import RequestProject.ShapeAlgebra
import RequestProject.ShapeCliffordGenuine
import RequestProject.ShapeStructural

namespace ShapeAlgebra

open SizeSignature

/-! ## 4. The timeless pattern of proving (Alexander's pattern language)

A *pattern language* (Christopher Alexander) is a catalogue of patterns, each of which solves
the same recurring problem the same way every time it appears. The recurring "problem" in this
project is *defining a notion of sameness and proving it is an equivalence relation*; the
recurring "solution" is always the same: declare `a ~ b` to mean that some chosen *form*
`key a` equals `key b`. We capture that timeless pattern a single time. -/

/-- **The timeless pattern.** Two things are *compared by* `key` when they share a common form:
`key a = key b`. This is the kernel-of-a-function relation, the one pattern from which every
"sameness" notion in this development is built. -/
def ComparedBy {α : Sort*} {β : Sort*} (key : α → β) (a b : α) : Prop := key a = key b

/-- The timeless pattern always yields an equivalence relation — proved once, reused forever. -/
theorem comparedBy_equivalence {α : Sort*} {β : Sort*} (key : α → β) :
    Equivalence (ComparedBy key) where
  refl _ := rfl
  symm h := h.symm
  trans h1 h2 := h1.trans h2

/-- Sameness of *size* is an instance of the pattern. -/
theorem sameSize_eq_comparedBy : SizeSignature.sameSize = ComparedBy SizeSignature.size := rfl

/-- Sameness by *arrows* (n-gram similarity) is an instance of the pattern. -/
theorem similarN_eq_comparedBy (n : Nat) : similarN n = ComparedBy (bagNgrams n) := rfl

/-- Sameness up to *renaming* of sizes is an instance of the pattern. -/
theorem renEquiv_eq_comparedBy : RenEquiv = ComparedBy canon := rfl

/-- *Structural* sameness of shapes is an instance of the pattern. -/
theorem structEqShape_eq_comparedBy : StructEqShape = ComparedBy structuralOf := rfl

/-- Every similarity notion's "it is an equivalence relation" theorem is *one and the same*
proof, read off the timeless pattern. -/
theorem sameSize_equivalence' : Equivalence SizeSignature.sameSize :=
  sameSize_eq_comparedBy ▸ comparedBy_equivalence SizeSignature.size

theorem similarN_equivalence' (n : Nat) : Equivalence (similarN n) :=
  similarN_eq_comparedBy n ▸ comparedBy_equivalence (bagNgrams n)

theorem renEquiv_equivalence' : Equivalence RenEquiv :=
  renEquiv_eq_comparedBy ▸ comparedBy_equivalence canon

theorem structEqShape_equivalence' : Equivalence StructEqShape :=
  structEqShape_eq_comparedBy ▸ comparedBy_equivalence structuralOf

/-! ## 1. The Hero's Journey on the genuine anti-commuting axes

The protagonist is an *atom* — a single size axis. The arrow into a second axis is the call to
adventure; their bivector is the threshold the hero crosses. -/

namespace Genuine

open CliffordAlgebra

variable (N : Nat)

/-- **The Ordinary World.** The hero begins as a single, isolated size-axis `E i`. -/
noncomputable def departure (i : Fin N) : CliffordAlgebra (Qm N) := E N i

/-- **Crossing the Threshold.** Drawn out by a distinct second axis, the atoms combine into the
grade-2 bivector — the *ordeal* in the anti-commuting abyss. -/
noncomputable def ordeal (i j : Fin N) : CliffordAlgebra (Qm N) := wedge N i j

/-- **The Ordinary World is commutative.** Back in the legacy one-dimensional ("thin") algebra,
order never mattered — there is no adventure to be had. -/
theorem ordinary_world_commutative (m n : Nat) :
    shapeGen m * shapeGen n = shapeGen n * shapeGen m :=
  shapeGen_comm m n

/-- **The Road Back: a changed world.** Having crossed the threshold, the old commutative law
survives only as exact cancellation — swapping the order flips the sign. -/
theorem world_changed {i j : Fin N} (h : i ≠ j) :
    E N i * E N j + E N j * E N i = 0 :=
  E_add_swap N h

/-- **The Supreme Ordeal.** The bivector confronts its own reflection: squaring itself, it
dips into the negative-scalar abyss, breaking the old rules to find a higher spatial truth. -/
theorem ordeal_squares_negative {i j : Fin N} (h : i ≠ j) :
    ordeal N i j * ordeal N i j
      = algebraMap ℚ (CliffordAlgebra (Qm N)) (-(((i : ℕ) : ℚ) ^ 2 * ((j : ℕ) : ℚ) ^ 2)) :=
  E_bivector_sq N h

/-- **The journey is directional.** The ordeal taken one way is the negative of the ordeal
taken the other — the hero cannot retrace the path unchanged. -/
theorem ordeal_directional {i j : Fin N} (h : i ≠ j) :
    ordeal N i j = -(ordeal N j i) :=
  wedge_antisymm N h

/-! ## 2. The Dialectic: thesis, antithesis, synthesis -/

/-- **Synthesis.** The thesis `E i` and antithesis `E j` are resolved into their bivector. -/
noncomputable def synthesis (i j : Fin N) : CliffordAlgebra (Qm N) := E N i * E N j

/-- **Antithesis negates thesis.** The friction of the two static generators: reversing them
flips the sign — order now changes the outcome entirely. -/
theorem antithesis_negates_thesis {i j : Fin N} (h : i ≠ j) :
    E N i * E N j = -(E N j * E N i) :=
  E_anticomm N h

/-- **The synthesis resolves the tension** of the dialectic down to a single scalar. -/
theorem synthesis_resolves {i j : Fin N} (h : i ≠ j) :
    synthesis N i j * synthesis N i j
      = algebraMap ℚ (CliffordAlgebra (Qm N)) (-(((i : ℕ) : ℚ) ^ 2 * ((j : ℕ) : ℚ) ^ 2)) :=
  E_bivector_sq N h

end Genuine

/-! ## 1′. The Hero's Journey as structure: the three-act arc

At the level of a shape's *arrows* (its size word), a hero's journey is a decomposition into a
departure, an initiation, and a homecoming, each carrying at least one arrow. -/

/-- A **three-act arc** over a size word `l`: a split into a nonempty *departure*, *initiation*
and *homecoming*, glued back to `l`. The monomyth as a structural decomposition. -/
structure ThreeAct (l : List Nat) where
  /-- The ordinary world we leave behind. -/
  departure : List Nat
  /-- The trials in the special world. -/
  initiation : List Nat
  /-- The return, transformed. -/
  homecoming : List Nat
  ne_dep : departure ≠ []
  ne_init : initiation ≠ []
  ne_home : homecoming ≠ []
  glue : departure ++ initiation ++ homecoming = l

/-- **No arrow is lost in the telling**: the three acts account for exactly the arrows of the
whole word. -/
theorem ThreeAct.acts_cover {l : List Nat} (a : ThreeAct l) :
    a.departure.length + a.initiation.length + a.homecoming.length = l.length := by
  conv_rhs => rw [← a.glue]
  simp [List.length_append, Nat.add_assoc]

/-- **Every sufficiently rich form has a story.** Any size word with at least three arrows
admits a three-act hero's journey. -/
theorem exists_threeAct {l : List Nat} (h : 3 ≤ l.length) : Nonempty (ThreeAct l) := by
  obtain ⟨x, y, z, t, rfl⟩ : ∃ x y z t, l = x :: y :: z :: t := by
    match l, h with
    | x :: y :: z :: t, _ => exact ⟨x, y, z, t, rfl⟩
  exact ⟨{ departure := [x], initiation := [y], homecoming := z :: t,
           ne_dep := by simp, ne_init := by simp, ne_home := by simp, glue := by simp }⟩

/-- A shape long enough to have a beginning, middle and end always carries a hero's journey. -/
theorem exists_threeAct_of_shape {s : Shape} (h : 3 ≤ (sizeWord s).length) :
    Nonempty (ThreeAct (sizeWord s)) :=
  exists_threeAct h

/-! ## 1″. The honest recalibration: the *seven*-act arc (ℤ₇, not the Bott ℤ₈)

The modulus-resonance sweep (`SemanticDupFinder`, full `import Mathlib`, unbiased sample) found
that the library's true cross-axis size-periodicity is the **prime ℤ₇**, not the Bott clock
ℤ₈.  So the monomyth, read structurally onto a shape's arrows, recalibrates from eight steps to
**seven acts**: a split of a size word into seven nonempty consecutive pieces.  (This is the
`DepthFinder` companion to the empirical `depth-out/` finding.) -/

/-- A **seven-act arc** over a size word `l`: a split into seven nonempty consecutive acts,
glued back to `l`.  The recalibrated (ℤ₇) monomyth as a structural decomposition. -/
structure SevenAct (l : List Nat) where
  /-- Act I — the ordinary world. -/
  act1 : List Nat
  /-- Act II — the call. -/
  act2 : List Nat
  /-- Act III — the threshold. -/
  act3 : List Nat
  /-- Act IV — the trials. -/
  act4 : List Nat
  /-- Act V — the ordeal. -/
  act5 : List Nat
  /-- Act VI — the reward. -/
  act6 : List Nat
  /-- Act VII — the return. -/
  act7 : List Nat
  ne1 : act1 ≠ []
  ne2 : act2 ≠ []
  ne3 : act3 ≠ []
  ne4 : act4 ≠ []
  ne5 : act5 ≠ []
  ne6 : act6 ≠ []
  ne7 : act7 ≠ []
  glue : act1 ++ act2 ++ act3 ++ act4 ++ act5 ++ act6 ++ act7 = l

/-- **No arrow is lost in the seven-fold telling**: the seven acts account for exactly the
arrows of the whole word. -/
theorem SevenAct.acts_cover {l : List Nat} (a : SevenAct l) :
    a.act1.length + a.act2.length + a.act3.length + a.act4.length
      + a.act5.length + a.act6.length + a.act7.length = l.length := by
  conv_rhs => rw [← a.glue]
  simp [List.length_append, Nat.add_assoc]

/-- **Every form rich enough for the recalibrated clock has a seven-act story.** Any size word
with at least seven arrows admits a seven-act hero's journey. -/
theorem exists_sevenAct {l : List Nat} (h : 7 ≤ l.length) : Nonempty (SevenAct l) := by
  obtain ⟨x1, x2, x3, x4, x5, x6, x7, t, rfl⟩ :
      ∃ x1 x2 x3 x4 x5 x6 x7 t, l = x1 :: x2 :: x3 :: x4 :: x5 :: x6 :: x7 :: t := by
    match l, h with
    | x1 :: x2 :: x3 :: x4 :: x5 :: x6 :: x7 :: t, _ =>
      exact ⟨x1, x2, x3, x4, x5, x6, x7, t, rfl⟩
  exact ⟨{ act1 := [x1], act2 := [x2], act3 := [x3], act4 := [x4], act5 := [x5], act6 := [x6],
           act7 := x7 :: t,
           ne1 := by simp, ne2 := by simp, ne3 := by simp, ne4 := by simp, ne5 := by simp,
           ne6 := by simp, ne7 := by simp, glue := by simp }⟩

/-- A shape long enough for the recalibrated ℤ₇ clock always carries a seven-act journey. -/
theorem exists_sevenAct_of_shape {s : Shape} (h : 7 ≤ (sizeWord s).length) :
    Nonempty (SevenAct (sizeWord s)) :=
  exists_sevenAct h

/-! ## 3. The Weaver's Loom: warp, weft, and the timeless pattern in the cloth -/

/-- **Warp** — the vertical threads: the number of *distinct* sizes, the raw material of the
weave. -/
def warp (s : StructuralShape) : Nat := StructuralShape.distinctSizes s

/-- **Weft** — the horizontal shuttle: the number of arrows woven through the warp. -/
def weft (s : StructuralShape) : Nat := StructuralShape.length s

/-- **Dyeing the threads does not change the cloth.** Recolouring the sizes by any injective
renaming leaves the woven structural pattern — and hence its warp and weft — unchanged. -/
theorem loom_invariant_under_dyeing (f : Nat → Nat) (hf : Function.Injective f) (l : List Nat) :
    warp (StructuralShape.of (l.map f)) = warp (StructuralShape.of l)
      ∧ weft (StructuralShape.of (l.map f)) = weft (StructuralShape.of l) := by
  have h := StructuralShape.of_map_injective f hf l
  exact ⟨by rw [warp, warp, h], by rw [weft, weft, h]⟩

/-- **You cannot use more warp-threads than weft-passes.** The number of distinct sizes never
exceeds the number of arrows. -/
theorem warp_le_weft (s : StructuralShape) : warp s ≤ weft s := by
  induction s using Quotient.inductionOn with
  | _ l => exact (List.dedup_sublist l).length_le

/-! ## Capstone: structurally equal shapes tell the same story -/

/-- Two shapes **tell the same story** exactly when they share a `StructuralShape` — the same
timeless pattern, read through the kernel-equivalence of `structuralOf`. -/
theorem tellSameStory_iff (a b : Shape) :
    StructEqShape a b ↔ ComparedBy structuralOf a b := Iff.rfl

end ShapeAlgebra
