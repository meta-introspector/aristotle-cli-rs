/-
  LogicTlurey.lean — Port of LogicTlurey.agda: Dialectical stages with
  4-periodicity, Tlurey traces, and semantics via triadic values.
-/
import Mathlib
import RequestProject.Math.DASHI.Base369

/-! ## §1. Dialectical stages -/

inductive Stage : Type where
  | seed | counter | resonance | overflow
  deriving DecidableEq, Repr

namespace Stage

def next : Stage → Stage
  | seed      => counter
  | counter   => resonance
  | resonance => overflow
  | overflow  => seed

/-! ## §2. Tlurey traces -/

def stageTrace : ℕ → Stage → List Stage
  | 0, _ => []
  | n + 1, s => s :: stageTrace n s.next

theorem stageTrace_length (n : ℕ) (s : Stage) : (stageTrace n s).length = n := by
  induction n generalizing s with
  | zero => simp [stageTrace]
  | succ n ih => simp [stageTrace, ih]

/-! ## §3. 4-periodicity -/

theorem next_period_4 (s : Stage) : s.next.next.next.next = s := by
  cases s <;> rfl

theorem spin4_next (s : Stage) : spin 4 next s = s := by
  cases s <;> rfl

/-! ## §4. Semantics via triadic values -/

def stageTone : Stage → TriTruth
  | seed      => .low
  | counter   => .mid
  | resonance => .high
  | overflow  => .low

def combineStage (a b : Stage) : TriTruth :=
  TriTruth.xor (stageTone a) (stageTone b)

theorem stageTone_next_seed : stageTone (next seed) = TriTruth.rotate (stageTone seed) := rfl
theorem stageTone_next_counter : stageTone (next counter) = TriTruth.rotate (stageTone counter) := rfl
theorem stageTone_next_resonance : stageTone (next resonance) = TriTruth.rotate (stageTone resonance) := rfl
theorem stageTone_next_overflow : stageTone (next overflow) = stageTone seed := rfl
theorem resonance_combine : combineStage resonance resonance = .mid := rfl

end Stage
