/-
# A counting recognizer: `(aa)*`, and why it is *not* group complexity 0

The two-state parity automaton recognizing `(aa)*` (words of even length over a
one-letter alphabet) is the smallest recognizer that genuinely counts. Its
transition monoid is the cyclic group of order two, so:

* it is **not** aperiodic — its group complexity is at least `1`
  (`parity_not_groupComplexityZero`);
* its group capacity is exactly `2` (`parity_dfaGroupCapacity_eq_two`), matching
  the capacity of the lattice node `gpZ2`.

This is the contrast case for `RequestProject/Recognizers/TightLexer.lean`: the
"no weird machines by group complexity" property is a real, falsifiable
condition, and a recognizer as innocent-looking as `(aa)*` already fails it.
`(aa)*` is one of the languages in the accompanying experimental language suite
(`external/state-tracking-crasp`), where it is likewise recorded as lying
outside the star-free/aperiodic class.
-/
import RequestProject.KrohnRhodes.LatticeBridge

namespace Recognizers

open KrohnRhodes ComplexityLattice

/-- States of the parity automaton: the length read so far, mod 2. -/
abbrev ParState := Fin 2

instance : DecidableEq (Function.End ParState) :=
  inferInstanceAs (DecidableEq (ParState → ParState))

instance : Fintype (Function.End ParState) :=
  inferInstanceAs (Fintype (ParState → ParState))

/-- The state map of the single letter: flip parity. -/
def parFlip : Function.End ParState := ![1, 0]

/-- The parity automaton for `(aa)*` over the one-letter alphabet `Unit`. -/
def parityDFA : DFA Unit ParState where
  step q _ := parFlip q
  start := 0
  accept := {0}

@[simp] lemma parityDFA_letterMap (a : Unit) : letterMap parityDFA a = parFlip := rfl

lemma parFlip_flip (q : ParState) : parFlip (parFlip q) = q := by fin_cases q <;> rfl

lemma parity_evalFrom (w : List Unit) (q : ParState) :
    parityDFA.evalFrom q w = if Even w.length then q else parFlip q := by
  induction w generalizing q with
  | nil => simp [DFA.evalFrom]
  | cons a w ih =>
      have hstep : parityDFA.evalFrom q (a :: w) = parityDFA.evalFrom (parFlip q) w := rfl
      have hlen : (a :: w).length = w.length + 1 := rfl
      rw [hstep, ih, hlen]
      by_cases h : Even w.length
      · rw [if_pos h, if_neg (by simpa [Nat.even_add_one] using h)]
      · rw [if_neg h, if_pos (Nat.even_add_one.2 h), parFlip_flip]

/-- The automaton accepts exactly the words of even length, i.e. it recognizes
`(aa)*`. -/
theorem parityDFA_accepts (w : List Unit) : w ∈ parityDFA.accepts ↔ Even w.length := by
  have h : parityDFA.eval w = if Even w.length then (0 : ParState) else parFlip 0 :=
    parity_evalFrom w 0
  constructor
  · intro hw
    have hw0 : parityDFA.eval w = 0 := hw
    by_contra hodd
    rw [h, if_neg hodd] at hw0
    exact absurd hw0 (by decide)
  · intro hw
    show parityDFA.eval w ∈ parityDFA.accept
    rw [h, if_pos hw]
    rfl

/-! ## The parity automaton realizes the lattice node `gpZ2` -/

/-- The nontrivial permutation of the two states, as a group element. -/
def parSwap : Equiv.Perm ParState := Equiv.swap 0 1

lemma permEnd_parSwap : permEnd parSwap = parFlip := by
  funext q
  fin_cases q <;> rfl

lemma perm_parState_cases (h : Equiv.Perm ParState) : h = 1 ∨ h = parSwap := by
  revert h
  decide

/-- Every permutation of the two states is realized by a word of the parity
automaton. -/
lemma parity_permSubgroupIn_top : PermSubgroupIn parityDFA (⊤ : Subgroup (Equiv.Perm ParState)) := by
  intro h _
  rcases perm_parState_cases h with rfl | rfl
  · rw [map_one]
    exact (transitionMonoid parityDFA).one_mem
  · rw [permEnd_parSwap]
    exact letterMap_mem parityDFA ()

lemma card_perm_parState : Nat.card (Equiv.Perm ParState) = 2 := by
  simp [Nat.card_eq_fintype_card, Fintype.card_perm]

/-- The parity automaton is **not** of group complexity `0`. -/
theorem parity_not_groupComplexityZero : ¬ GroupComplexityZero parityDFA := by
  refine not_groupComplexityZero_of_nontrivial_permSubgroup parity_permSubgroupIn_top ?_
  rw [Nat.card_congr (Subgroup.topEquiv (G := Equiv.Perm ParState)).toEquiv, card_perm_parState]

/-- The parity automaton's group capacity is exactly `2` — the capacity of the
lattice node `gpZ2`. -/
theorem parity_dfaGroupCapacity_eq_two : dfaGroupCapacity parityDFA = 2 := by
  refine le_antisymm (dfaGroupCapacity_le ?_) ?_
  · rintro n ⟨H, -, rfl⟩
    calc Nat.card H ≤ Nat.card (Equiv.Perm ParState) :=
          Nat.card_le_card_of_injective _ Subtype.val_injective
    _ = 2 := card_perm_parState
  · have hcard : Nat.card (⊤ : Subgroup (Equiv.Perm ParState)) = 2 := by
      rw [Nat.card_congr (Subgroup.topEquiv (G := Equiv.Perm ParState)).toEquiv,
        card_perm_parState]
    calc (2 : ℕ) = Nat.card (⊤ : Subgroup (Equiv.Perm ParState)) := hcard.symm
    _ ≤ dfaGroupCapacity parityDFA := le_dfaGroupCapacity parity_permSubgroupIn_top

/-- The capacity of the parity recognizer equals the capacity of the lattice node
`gpZ2`: the recognizer sits exactly at that node. -/
theorem parity_isAt_gpZ2 : dfaGroupCapacity parityDFA = capacity gpZ2 := by
  rw [parity_dfaGroupCapacity_eq_two, isAt_gpZ2]

end Recognizers
