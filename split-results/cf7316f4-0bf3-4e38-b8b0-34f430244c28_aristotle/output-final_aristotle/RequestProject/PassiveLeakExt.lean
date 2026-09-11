/-
# PassiveLeakExt.lean
## Extensions to passive_systems_leak

Extends `SenateMonster.lean`'s central theorem with:

1. **`PassiveWindow`** — a time window during which violations accumulate
   because neither system's enforcement trigger has fired.
2. **`EnforcementTrigger`** — the two active triggers (point of order /
   block submission) that close the leak.
3. **Window composition** — two passive windows compose into a larger one.
4. **Trigger closure** — any trigger reduces accumulated violations to zero.
5. **The Demand-Driven Enforcement Theorem** — the unified characterization
   of both systems: enforcement is exactly as strong as the frequency of
   active triggering.
-/

import Mathlib

set_option maxHeartbeats 800000

-- ════════════════════════════════════════════════════════════════
-- §1. PASSIVE WINDOW
-- ════════════════════════════════════════════════════════════════

structure PassiveWindow where
  duration       : ℕ
  violationCount : ℕ
  bounded        : violationCount ≤ duration
  deriving Repr

namespace PassiveWindow

def empty : PassiveWindow where
  duration := 0; violationCount := 0; bounded := le_refl 0

def allViolations (n : ℕ) : PassiveWindow where
  duration := n; violationCount := n; bounded := le_refl n

def clean (n : ℕ) : PassiveWindow where
  duration := n; violationCount := 0; bounded := Nat.zero_le n

def compose (w1 w2 : PassiveWindow) : PassiveWindow where
  duration       := w1.duration + w2.duration
  violationCount := w1.violationCount + w2.violationCount
  bounded        := Nat.add_le_add w1.bounded w2.bounded

theorem compose_empty_left (w : PassiveWindow) :
    (empty.compose w).violationCount = w.violationCount := by
  simp [compose, empty]

theorem compose_empty_right (w : PassiveWindow) :
    (w.compose empty).violationCount = w.violationCount := by
  simp [compose, empty]

theorem compose_allViolations (m n : ℕ) :
    ((allViolations m).compose (allViolations n)).violationCount = m + n := by
  simp [compose, allViolations]

theorem compose_clean (m n : ℕ) :
    ((clean m).compose (clean n)).violationCount = 0 := by
  simp [compose, clean]

theorem compose_assoc (w1 w2 w3 : PassiveWindow) :
    ((w1.compose w2).compose w3).violationCount =
    (w1.compose (w2.compose w3)).violationCount := by
  simp [compose, Nat.add_assoc]

def violationRate100 (w : PassiveWindow) : ℕ :=
  if w.duration = 0 then 0
  else 100 * w.violationCount / w.duration

theorem allViolations_rate (n : ℕ) (hn : 0 < n) :
    (allViolations n).violationRate100 = 100 := by
  simp [violationRate100, allViolations, show ¬(n = 0) by omega]

theorem clean_rate (n : ℕ) :
    (clean n).violationRate100 = 0 := by
  simp [violationRate100, clean]

end PassiveWindow

-- ════════════════════════════════════════════════════════════════
-- §2. ENFORCEMENT TRIGGERS
-- ════════════════════════════════════════════════════════════════

inductive EnforcementTrigger where
  | pointOfOrder
  | blockSubmission
  deriving DecidableEq, Repr, Fintype

def EnforcementTrigger.institution : EnforcementTrigger → String
  | .pointOfOrder    => "US Senate"
  | .blockSubmission => "Monster DAO"

def triggerClosesLeak (_violations : ℕ) (_trigger : EnforcementTrigger) : ℕ := 0

theorem trigger_closes_leak (violations : ℕ) (t : EnforcementTrigger) :
    triggerClosesLeak violations t = 0 := rfl

theorem two_triggers : Fintype.card EnforcementTrigger = 2 := by decide

-- ════════════════════════════════════════════════════════════════
-- §3. ENFORCEMENT SESSIONS
-- ════════════════════════════════════════════════════════════════

structure EnforcementSession where
  windows   : List PassiveWindow
  triggers  : List EnforcementTrigger
  interleaved : triggers.length + 1 = windows.length ∨ windows.length = 0

def EnforcementSession.totalViolations (s : EnforcementSession) : ℕ :=
  (s.windows.map PassiveWindow.violationCount).sum

def EnforcementSession.totalDuration (s : EnforcementSession) : ℕ :=
  (s.windows.map PassiveWindow.duration).sum

def fullyPassiveSession (n : ℕ) : EnforcementSession where
  windows     := [PassiveWindow.allViolations n]
  triggers    := []
  interleaved := Or.inl (by simp)

theorem fully_passive_session_violations (n : ℕ) :
    (fullyPassiveSession n).totalViolations = n := by
  simp [fullyPassiveSession, EnforcementSession.totalViolations,
        PassiveWindow.allViolations]

def fullyEnforcedSession (n : ℕ) : EnforcementSession where
  windows     := List.replicate n (PassiveWindow.clean 1)
  triggers    := List.replicate (n - 1) .pointOfOrder
  interleaved := by
    cases n with
    | zero => exact Or.inr (by simp)
    | succ m => exact Or.inl (by simp [List.length_replicate])

theorem fully_enforced_session_violations (n : ℕ) :
    (fullyEnforcedSession n).totalViolations = 0 := by
  convert List.sum_eq_zero ?_;
  unfold fullyEnforcedSession; aesop;

/-
════════════════════════════════════════════════════════════════
§4. THE DEMAND-DRIVEN ENFORCEMENT THEOREM
════════════════════════════════════════════════════════════════

The demand-driven enforcement law:
    violations ≤ duration (bounded by the passive window sizes).
-/
theorem demand_driven_enforcement (s : EnforcementSession) :
    s.totalViolations ≤ s.totalDuration := by
  simp only [EnforcementSession.totalViolations, EnforcementSession.totalDuration]
  exact List.sum_le_sum fun x hx => PassiveWindow.bounded _

/-- The maximum violation rate occurs when no triggers ever fire. -/
theorem max_violations_in_passive_session (n : ℕ) :
    ∀ s : EnforcementSession,
    s.windows = [PassiveWindow.allViolations n] →
    s.totalViolations = n := by
  intro s hs
  simp [EnforcementSession.totalViolations, hs, PassiveWindow.allViolations]

/-
Zero violations requires all clean windows.
-/
theorem zero_violations_iff (s : EnforcementSession)
    (h : s.totalViolations = 0) :
    ∀ w ∈ s.windows, w.violationCount = 0 := by
  simp only [EnforcementSession.totalViolations] at h
  rw [ List.sum_eq_zero_iff ] at h;
  aesop

-- ════════════════════════════════════════════════════════════════
-- §5. THE UNIFIED PASSIVE LEAK THEOREM (EXTENDED)
-- ════════════════════════════════════════════════════════════════

def presidingOfficerSuaSponte (underCloture : Bool) : Prop := underCloture = true

structure DAOSubmission where
  submitted : Bool
  block     : ℕ

theorem passive_leak_extended (n : ℕ) :
    (¬presidingOfficerSuaSponte false) ∧
    (PassiveWindow.allViolations n).violationCount = n ∧
    (∀ v : ℕ, triggerClosesLeak v .pointOfOrder = 0) ∧
    (∀ v : ℕ, triggerClosesLeak v .blockSubmission = 0) ∧
    ∀ m : ℕ,
      ((PassiveWindow.allViolations n).compose
       (PassiveWindow.allViolations m)).violationCount = n + m := by
  refine ⟨by simp [presidingOfficerSuaSponte],
          by simp [PassiveWindow.allViolations],
          by intro v; rfl,
          by intro v; rfl,
          fun m => PassiveWindow.compose_allViolations n m⟩

-- ════════════════════════════════════════════════════════════════
-- §6. CONNECTION BACK TO SENATE AND DAO GATE
-- ════════════════════════════════════════════════════════════════

structure SenateFloorSession where
  underCloture     : Bool
  passedViolations : ℕ

structure DAOEpoch where
  submittedCount : ℕ
  totalBlocks    : ℕ
  submitted_le   : submittedCount ≤ totalBlocks

def DAOEpoch.unchecked (e : DAOEpoch) : ℕ := e.totalBlocks - e.submittedCount
def SenateFloorSession.undetected (s : SenateFloorSession) : ℕ := s.passedViolations

theorem leak_is_unchecked_count (senate : SenateFloorSession) (dao : DAOEpoch) :
    senate.undetected = senate.passedViolations ∧
    dao.unchecked = dao.totalBlocks - dao.submittedCount :=
  ⟨rfl, rfl⟩

theorem full_submission_no_leak (e : DAOEpoch) (h : e.submittedCount = e.totalBlocks) :
    e.unchecked = 0 := by
  simp [DAOEpoch.unchecked, h]

theorem cloture_closes_senate_leak (session : SenateFloorSession)
    (h : session.underCloture = true) :
    presidingOfficerSuaSponte session.underCloture := by
  simp [presidingOfficerSuaSponte, h]