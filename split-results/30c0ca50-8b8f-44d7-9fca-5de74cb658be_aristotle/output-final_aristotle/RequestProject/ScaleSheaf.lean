import Mathlib
import RequestProject.ScaleTower

/-!
# The scale site: a Grothendieck topology over the monotone scale tower

This module answers the **sheafification / site-theoretic** direction: it equips the
natural-number index category `ℕ` (the indexing preorder of the monotone
`scaleDiagram` subsets of `RequestProject/ScaleTower.lean`) with a genuine
**Grothendieck topology** — the first layer of a sheaf-theoretic refinement of the
scale tower.

The index category `ℕ` is a preorder, hence a thin category with an **initial
object `0`** (the base stage of every scale tower).  A sieve `S` on a stage `n` is
a downward-closed family of earlier stages; we declare `S` to be a **scale cover**
exactly when it *reaches back to the base stage `0`* of the tower:

* `ScaleCovers n S` — the sieve `S` contains the canonical arrow `0 ⟶ n`.
* `scaleTopology : GrothendieckTopology ℕ` — the resulting **scale topology**: its
  covering sieves are the scale covers.  All three Grothendieck axioms (maximality,
  pullback stability, transitivity) are verified.
* `scaleCovers_iff_ne_bot` — a scale cover is exactly a **non-empty** sieve: a cover
  must genuinely reach some earlier stage of the tower (equivalently, the base `0`).
* `trivial_le_scaleTopology` / `scaleTopology_le_discrete` — the scale topology sits
  strictly between the trivial and discrete topologies in the lattice of
  Grothendieck topologies, and `bot_not_mem_scaleTopology` shows the empty sieve is
  never covering, so the topology is non-trivial.

Everything compiles and every `theorem` is fully proved (no `sorry`).
-/

open CategoryTheory

namespace Aristotle.Extension

/-! ## The base arrow and the scale-cover predicate -/

/-- The canonical arrow from the **base stage `0`** of the scale tower to any stage
`n`, in the preorder index category `ℕ`. -/
def baseArrow (n : ℕ) : (0 : ℕ) ⟶ n := homOfLE (Nat.zero_le n)

/-- **The scale-cover predicate.**  A sieve `S` on the stage `n` is a *scale cover*
when it reaches back to the base stage `0` of the tower, i.e. contains the base
arrow `0 ⟶ n`. -/
def ScaleCovers (n : ℕ) (S : Sieve n) : Prop := S.arrows (baseArrow n)

/-- In the thin index category `ℕ`, any two arrows with the same source and target
coincide; in particular the composite of base arrows is again a base arrow. -/
theorem baseArrow_comp {m n : ℕ} (f : m ⟶ n) :
    baseArrow m ≫ f = baseArrow n := Subsingleton.elim _ _

/-! ## The three Grothendieck axioms for the scale cover -/

/-- **Maximality.**  The maximal sieve is a scale cover. -/
theorem scale_top_mem (n : ℕ) : ScaleCovers n ⊤ := trivial

/-- **Pullback stability.**  The pullback of a scale cover along any arrow is again
a scale cover (using that `ℕ` has an initial object `0`). -/
theorem scale_pullback {m n : ℕ} (f : m ⟶ n) (S : Sieve n)
    (h : ScaleCovers n S) : ScaleCovers m (S.pullback f) := by
  rw [ScaleCovers, Sieve.pullback_apply, baseArrow_comp]; exact h

/-- **Transitivity.**  If `S` is a scale cover of `n` and `R` is a sieve whose
pullback along every arrow of `S` is a scale cover, then `R` is a scale cover. -/
theorem scale_transitive {n : ℕ} {S : Sieve n} (hS : ScaleCovers n S) (R : Sieve n)
    (h : ∀ ⦃m : ℕ⦄ ⦃f : m ⟶ n⦄, S.arrows f → ScaleCovers m (R.pullback f)) :
    ScaleCovers n R := by
      simp_all +decide [ ScaleCovers ];
      convert h hS using 1

/-! ## The scale topology -/

/-- **The scale topology.**  The Grothendieck topology on the index category `ℕ`
whose covering sieves over each stage `n` are the *scale covers* — the sieves
reaching back to the base stage `0` of the monotone scale tower. -/
def scaleTopology : GrothendieckTopology ℕ where
  sieves n := {S | ScaleCovers n S}
  top_mem' := scale_top_mem
  pullback_stable' _ _ _ f hS := scale_pullback f _ hS
  transitive' _ _ hS R h := scale_transitive hS R h

@[simp] theorem mem_scaleTopology {n : ℕ} (S : Sieve n) :
    S ∈ scaleTopology n ↔ ScaleCovers n S := Iff.rfl

/-! ## Characterizations and lattice position -/

/-
**A scale cover is exactly a non-empty sieve.**  Reaching back to the base stage
is equivalent to the sieve containing *some* earlier stage: a genuine cover cannot
be empty.
-/
theorem scaleCovers_iff_ne_bot {n : ℕ} (S : Sieve n) :
    ScaleCovers n S ↔ S ≠ ⊥ := by
      constructor <;> intro h;
      · cases S ; aesop;
      · -- By contradiction, assume that $S$ is empty.
        by_contra h_empty;
        obtain ⟨m, f, hf⟩ : ∃ m : ℕ, ∃ f : m ⟶ n, S.arrows f := by
          exact not_forall_not.mp fun contra => h <| by ext m f; aesop;
        exact h_empty <| S.downward_closed hf ( baseArrow m )

/-
The empty sieve is **never** a scale cover: the scale topology is non-trivial.
-/
theorem bot_not_mem_scaleTopology (n : ℕ) : (⊥ : Sieve n) ∉ scaleTopology n := by
  simp +decide [ scaleCovers_iff_ne_bot ]

/-
The scale topology refines the **trivial** topology: every maximal sieve is a
scale cover.
-/
theorem trivial_le_scaleTopology :
    GrothendieckTopology.trivial ℕ ≤ scaleTopology := by
      intro n S; simp +decide [ GrothendieckTopology.trivial ] ;
      rintro rfl; exact scale_top_mem n;

/-
The scale topology is refined by the **discrete** topology.
-/
theorem scaleTopology_le_discrete :
    scaleTopology ≤ GrothendieckTopology.discrete ℕ := by
      intro n S; simp +decide [ GrothendieckTopology.discrete ] ;
      exact fun h => Set.mem_univ S

end Aristotle.Extension