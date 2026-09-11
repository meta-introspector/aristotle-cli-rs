import Mathlib

/-!
# Formal model of gean's `SlotIsJustifiableAfter` (3SF-mini justification rule)

This file is a faithful Lean4 model of the justification predicate from
`gean/statetransition/justifiable.go`.

The 3SF-mini rule says that a candidate slot can be justified after the finalized
slot when the candidate is strictly later than the finalized slot **and** the
distance `delta = candidate - finalized` is

* at most `5`, or
* a perfect square (`delta = n * n`), or
* a pronic number (`delta = n * (n + 1)`).

The Go implementation computes the perfect-square and pronic tests with
`math.Sqrt(float64(delta))`, which loses precision for large `delta`.  Here we
model the intended behaviour with the precision-safe integer square root
`Nat.sqrt`, and prove the exact characterization of the predicate together with
the basic sanity properties.
-/

namespace Gean

/-- `d` is a perfect square. -/
def IsSquareN (d : ℕ) : Prop := ∃ n : ℕ, n * n = d

/-- `d` is a pronic number, i.e. of the form `n * (n + 1)`. -/
def IsPronic (d : ℕ) : Prop := ∃ n : ℕ, n * (n + 1) = d

/-- Boolean perfect-square test via the integer square root. -/
def isSquareB (d : ℕ) : Bool := Nat.sqrt d * Nat.sqrt d == d

/-- Boolean pronic test via the integer square root. -/
def isPronicB (d : ℕ) : Bool := Nat.sqrt d * (Nat.sqrt d + 1) == d

/-- Faithful Lean model of gean's `SlotIsJustifiableAfter(candidate, finalized)`.

    Returns `false` unless the candidate is strictly later than the finalized
    slot; otherwise it accepts the distance when it is `≤ 5`, a perfect square,
    or a pronic number. -/
def slotIsJustifiableAfter (candidate finalized : ℕ) : Bool :=
  if candidate ≤ finalized then
    false
  else
    let delta := candidate - finalized
    decide (delta ≤ 5) || isSquareB delta || isPronicB delta

/-- The boolean square test agrees with the mathematical perfect-square predicate. -/
theorem isSquareB_iff (d : ℕ) : isSquareB d = true ↔ IsSquareN d := by
  simp +decide [ isSquareB, IsSquareN ];
  grind +suggestions

/-- The boolean pronic test agrees with the mathematical pronic predicate. -/
theorem isPronicB_iff (d : ℕ) : isPronicB d = true ↔ IsPronic d := by
  constructor;
  · grind +locals;
  · unfold isPronicB;
    intro h
    obtain ⟨n, hn⟩ := h
    have h_sqrt : Nat.sqrt d = n := by
      exact le_antisymm ( Nat.le_of_lt_succ <| Nat.sqrt_lt.2 <| by nlinarith ) ( Nat.le_sqrt.2 <| by nlinarith )
    rw [h_sqrt];
    aesop

/-- **Characterization theorem.**

    `slotIsJustifiableAfter candidate finalized` is `true` exactly when the
    candidate is strictly later than the finalized slot and the distance is
    `≤ 5`, a perfect square, or a pronic number. -/
theorem slotIsJustifiableAfter_iff (candidate finalized : ℕ) :
    slotIsJustifiableAfter candidate finalized = true ↔
      finalized < candidate ∧
        ((candidate - finalized ≤ 5) ∨
          IsSquareN (candidate - finalized) ∨
          IsPronic (candidate - finalized)) := by
  unfold slotIsJustifiableAfter;
  by_cases h : candidate ≤ finalized <;> simp_all +decide [ isSquareB_iff, isPronicB_iff ];
  tauto

/-- Sanity property: the predicate is `false` whenever the candidate is not
    strictly later than the finalized slot. -/
theorem slotIsJustifiableAfter_eq_false_of_le {candidate finalized : ℕ}
    (h : candidate ≤ finalized) :
    slotIsJustifiableAfter candidate finalized = false := by
  exact if_pos h

/-- Sanity property: a candidate within distance `5` of (and strictly later than)
    the finalized slot is always justifiable. -/
theorem slotIsJustifiableAfter_of_close {candidate finalized : ℕ}
    (h1 : finalized < candidate) (h2 : candidate - finalized ≤ 5) :
    slotIsJustifiableAfter candidate finalized = true := by
  unfold slotIsJustifiableAfter; aesop;

end Gean