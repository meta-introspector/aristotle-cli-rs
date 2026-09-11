import Mathlib

/-!
# Gödel Sentence for Aristotle

Formalizes the self-referential paradox:
  s = "this proof cannot be proven in aristotle"

We model a formal system as a set of provable propositions and show
that any consistent system satisfying minimal conditions has
true-but-unprovable statements (Gödel's First Incompleteness Theorem,
specialized to our setting).

This is a simplified formalization — the full Gödel theorem requires
encoding of arithmetic and diagonal lemma, which we abstract here.
-/

/-- A formal proof system: a set of propositions it can prove -/
structure FormalSystem where
  /-- The type of propositions -/
  Prop' : Type
  /-- The provability predicate -/
  Provable : Prop' → Prop
  /-- The truth predicate -/
  True' : Prop' → Prop

/-- A formal system is consistent if it cannot prove both P and ¬P -/
def FormalSystem.Consistent (S : FormalSystem) : Prop :=
  ¬∃ (P : S.Prop'), S.Provable P ∧ ∀ Q : S.Prop', S.Provable Q

/-- A formal system is sound if everything provable is true -/
def FormalSystem.Sound (S : FormalSystem) : Prop :=
  ∀ P : S.Prop', S.Provable P → S.True' P

/-- A formal system is complete if every true proposition is provable -/
def FormalSystem.Complete (S : FormalSystem) : Prop :=
  ∀ P : S.Prop', S.True' P → S.Provable P

/-- The Gödel sentence for a system: a proposition that asserts its own unprovability.
    We model this as: there exists a proposition G such that
    G is true ↔ G is not provable. -/
def FormalSystem.HasGoedelSentence (S : FormalSystem) : Prop :=
  ∃ G : S.Prop', (S.True' G ↔ ¬S.Provable G)

/-
If a sound system has a Gödel sentence, it is incomplete
-/
theorem goedel_incompleteness (S : FormalSystem)
    (hSound : S.Sound)
    (hGoedel : S.HasGoedelSentence) :
    ¬S.Complete := by
  -- Assume S is complete. Then by hGoedel, there exists a proposition G such that G is true if and only if it's not provable.
  by_contra hComplete
  obtain ⟨G, hG⟩ := hGoedel;
  by_cases h : S.Provable G <;> simp_all +decide [ FormalSystem.Complete ];
  exact hG <| hSound G h

/-
If a sound system has a Gödel sentence, that sentence is true but unprovable
-/
theorem goedel_true_but_unprovable (S : FormalSystem)
    (hSound : S.Sound)
    (hGoedel : S.HasGoedelSentence) :
    ∃ G : S.Prop', S.True' G ∧ ¬S.Provable G := by
  cases' hGoedel with G hG
  use G
  by_cases hP : S.Provable G;
  · exact absurd ( hSound G hP ) ( by aesop );
  · exact ⟨ hG.mpr hP, hP ⟩

/-
The comonad breaks on the Gödel sentence:
    If the system cannot prove G, then self-reproduction halts.
    We model this as: if extend reflects provability (proving extend(G)
    implies proving G), then there exists G where extend(G) is unprovable.
-/
theorem comonad_halts_on_goedel (S : FormalSystem)
    (hSound : S.Sound)
    (hGoedel : S.HasGoedelSentence)
    (extend : S.Prop' → S.Prop')
    (hExtend : ∀ P, S.Provable (extend P) → S.Provable P) :
    ∃ G : S.Prop', ¬S.Provable (extend G) := by
  grind +locals

/-
Metameme 43 never converges to 42 for the Gödel sentence:
    If the convergence requires provability, and G is unprovable,
    then convergence fails.
-/
theorem metameme_43_stuck (S : FormalSystem)
    (hSound : S.Sound)
    (hGoedel : S.HasGoedelSentence)
    (converges : S.Prop' → Prop)
    (hConv : ∀ P, converges P → S.Provable P) :
    ∃ G : S.Prop', ¬converges G := by
  -- By the properties of the Gödel sentence, we know that G is true but unprovable.
  obtain ⟨G, hG⟩ : ∃ G : S.Prop', S.True' G ∧ ¬S.Provable G := by
    exact goedel_true_but_unprovable S hSound hGoedel;
  exact ⟨ G, fun h => hG.2 <| hConv G h ⟩