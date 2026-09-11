import Mathlib
import RequestProject.ExtensionEngine

/-!
# The Scale Tower and its Colimit — the category-theoretic face of the Extension Engine

This module connects the **Universal Extension Engine** of
`RequestProject/ExtensionEngine.lean` to category-theoretic (co)limits, realizing
the requested *Functorial Advance* and *Co-Filtered Limit* programme.

The picture:

* Each extension engine `X` carries a tower of finite maps `finiteApprox N`.  Read
  as subsets of the carrier, `scaleTower X N : Set X`, these form a **direct system
  of inclusions** whenever the tower is monotone.
* The advancement step (the *cart*) is genuinely **functorial**: it is the
  successor endofunctor `cartFunctor : ℕ ⥤ ℕ` on the index category.
* `scaleDiagram` packages a monotone tower as an honest functor `ℕ ⥤ Set X` into
  the complete lattice of subsets, and `colimit_scaleDiagram` proves that its
  **colimit is exactly the union of all finite maps** (`globalSections`), using
  Mathlib's `CompleteLattice.colimit_eq_iSup`.
* For the genuine `q`-expansion engine this colimit **recovers the infinite global
  sections line `ℕ`** (`qExpansion_colimit_eq_univ`): the cart–carrot stream,
  taken to its limit, is all of `ℕ`.

We also formalize the **Monster-theoretic stratification and obstruction**:

* `carrot_residue_surjective` — the carrot stream surjects onto the supersingular
  residue register `ZMod 71 × ZMod 59 × ZMod 47` (CRT stratification);
* `carrot_residue_fiber_infinite` — every residue class contains infinitely many
  carrots, so the stream stratifies into `196883` infinite fibers;
* `monster_obstruction_collision` — any map of the infinite carrot index into the
  finite Monster coordinate system `CRTAddress` must collide: the *non-trivial
  failure code* witnessing that the finite blade space cannot index the engine.

Everything compiles and every `theorem` is fully proved (no `sorry`).
-/

open CategoryTheory CategoryTheory.Limits

namespace Aristotle.Extension

open Moonshine Moonshine.CartCarrot

/-! ## The advancement step as an endofunctor on the index category -/

/-- **The cart as an endofunctor.**  The advancement step `N ↦ N + 1` is the
successor endofunctor on the index category `ℕ` (a preorder, hence a category). -/
def cartFunctor : ℕ ⥤ ℕ :=
  (show Monotone (fun n : ℕ => n + 1) from fun _ _ h => by dsimp only; omega).functor

@[simp] theorem cartFunctor_obj (n : ℕ) : cartFunctor.obj n = n + 1 := rfl

/-! ## The scale tower as a direct system of inclusions -/

/-- The **scale tower** of an extension engine, read as a family of subsets of the
carrier: `scaleTower X N` is the set of points captured by the finite map at stage
`N`.  When monotone this is a genuine direct system of inclusions. -/
def scaleTower (X : Type _) [ExtensionEngine X] (N : ℕ) : Set X :=
  ↑(ExtensionEngine.finiteApprox (X := X) N)

/-- The **global sections** of an extension engine: the union of every finite map.
Categorically this is the colimit of the scale-tower diagram. -/
def globalSections (X : Type _) [ExtensionEngine X] : Set X :=
  ⋃ N, scaleTower X N

/-- A monotone scale tower as an honest functor from the preorder category `ℕ`
into the complete lattice `Set X` of subsets of the carrier — the *direct system
of inclusions* underpinning the layer. -/
def scaleDiagram (X : Type _) [ExtensionEngine X]
    (hmono : Monotone (scaleTower X)) : ℕ ⥤ Set X :=
  hmono.functor

/-- **The colimit of the scale-tower diagram is the global sections.**  Using that
in the complete lattice `Set X` the categorical colimit of a diagram is the
supremum of its objects, the colimit of the (monotone) scale tower is exactly the
union of all finite maps. -/
theorem colimit_scaleDiagram (X : Type _) [ExtensionEngine X]
    (hmono : Monotone (scaleTower X)) :
    colimit (scaleDiagram X hmono) = globalSections X := by
  rw [CompleteLattice.colimit_eq_iSup]
  simp only [scaleDiagram, Monotone.functor_obj]
  rw [globalSections, Set.iSup_eq_iUnion]

/-! ## The `q`-expansion engine: the colimit recovers the line `ℕ` -/

/-- The `q`-expansion scale tower is a genuine direct system of inclusions. -/
theorem qExpansion_scaleTower_monotone : Monotone (scaleTower ℕ) := by
  intro a b hab
  simp only [scaleTower]
  have h : ExtensionEngine.finiteApprox (X := ℕ) = knownMap := rfl
  rw [h]
  simp only [knownMap, Finset.coe_range]
  exact Set.Iio_subset_Iio hab

/-- The global sections of the `q`-expansion engine are all of `ℕ`: the
cart–carrot stream, taken to its colimit, exhausts the line. -/
theorem qExpansion_globalSections : globalSections ℕ = Set.univ := by
  rw [globalSections]
  ext n
  simp only [Set.mem_iUnion, scaleTower, Set.mem_univ, iff_true]
  refine ⟨n + 1, ?_⟩
  have h : ExtensionEngine.finiteApprox (X := ℕ) = knownMap := rfl
  rw [h]
  simp [knownMap]

/-- **Co-filtered limit recovery.**  The colimit of the `q`-expansion scale-tower
diagram recovers the infinite global sections line `ℕ`.  This is the formal sense
in which extending the finite approximations `finiteApprox N` via the engine
reconstructs the whole infinite object. -/
theorem qExpansion_colimit_eq_univ :
    colimit (scaleDiagram ℕ qExpansion_scaleTower_monotone) = (Set.univ : Set ℕ) := by
  rw [colimit_scaleDiagram]; exact qExpansion_globalSections

/-! ## Monster-theoretic stratification and obstruction -/

/-
**CRT stratification (surjectivity).**  The carrot stream surjects onto the
supersingular residue register `ZMod 71 × ZMod 59 × ZMod 47`: every residue triple
is hit by some carrot, by the Chinese Remainder Theorem on the pairwise-coprime
deep supersingular primes `71, 59, 47`.
-/
theorem carrot_residue_surjective : Function.Surjective crtTriple := by
  intro x;
  -- By the Chinese Remainder Theorem, there exists a natural number `a` such that `a ≡ x₁ (mod 71)`, `a ≡ x₂ (mod 59)`, and `a ≡ x₃ (mod 47)`.
  obtain ⟨a, ha⟩ : ∃ a : ℕ, a ≡ x.1.val [MOD 71] ∧ a ≡ x.2.1.val [MOD 59] ∧ a ≡ x.2.2.val [MOD 47] := by
    have h_crt : ∃ a : ℕ, a ≡ x.1.val [MOD 71] ∧ a ≡ x.2.1.val [MOD 59] := by
      have := Nat.chineseRemainder ( show Nat.Coprime 71 59 by decide );
      exact ⟨ _, this _ _ |>.2 ⟩;
    obtain ⟨ a, ha₁, ha₂ ⟩ := h_crt;
    -- By the Chinese Remainder Theorem, there exists a natural number `b` such that `b ≡ a (mod 71*59)` and `b ≡ x.2.2.val (mod 47)`.
    obtain ⟨ b, hb₁, hb₂ ⟩ : ∃ b : ℕ, b ≡ a [MOD 71 * 59] ∧ b ≡ x.2.2.val [MOD 47] := by
      have h_crt : Nat.gcd (71 * 59) 47 = 1 := by
        decide +revert;
      have := Nat.chineseRemainder h_crt;
      exact ⟨ _, this a x.2.2.val |>.2 ⟩;
    exact ⟨ b, hb₁.of_dvd ( by decide ) |> Nat.ModEq.trans <| ha₁, hb₁.of_dvd ( by decide ) |> Nat.ModEq.trans <| ha₂, hb₂ ⟩;
  simp_all +decide [ ← ZMod.natCast_eq_natCast_iff ];
  exact ⟨ a, Prod.ext ha.1 ( Prod.ext ha.2.1 ha.2.2 ) ⟩

/-
**CRT stratification (infinite fibers).**  Each residue class of the carrot
stream modulo the supersingular triple is infinite: adding `71 * 59 * 47 = 196883`
preserves the residue, so the stream stratifies into `196883` infinite fibers.
-/
theorem carrot_residue_fiber_infinite (c : ZMod 71 × ZMod 59 × ZMod 47) :
    {n : ℕ | crtTriple n = c}.Infinite := by
  obtain ⟨ n, hn ⟩ := carrot_residue_surjective c;
  refine Set.infinite_of_injective_forall_mem ( fun a b h => by aesop ) fun k => show crtTriple ( n + k * 196883 ) = c from ?_;
  unfold crtTriple at *; aesop;

/-- **The Monster obstruction / non-trivial failure code.**  Any map of the
infinite carrot index `ℕ` into the finite Monster coordinate system `CRTAddress`
must collide: there are two distinct carrot indices sent to the same Monster
coordinate.  This collision is the obstruction witnessing that the finite Clifford
blade / coordinate space cannot index the infinite expansion engine injectively. -/
theorem monster_obstruction_collision (f : ℕ → CRTAddress) :
    ∃ a b, a ≠ b ∧ f a = f b := by
  by_contra h
  push_neg at h
  exact moonshine_incompleteness_lemma
    ⟨f, fun a b hab => by by_contra hne; exact h a b hne hab⟩

end Aristotle.Extension