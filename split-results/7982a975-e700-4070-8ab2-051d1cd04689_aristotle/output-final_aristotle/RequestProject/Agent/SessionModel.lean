/-
# SessionModel.lean
## Layer 5: Time — Session Model and Liveness

None of the current theorems mention time/ordering beyond `strictlyIncreasing` IDs.
This file adds:

1. **Session model**: Finite-duration sessions, with `dual_persistence` holding
   across session boundaries — the "continuing body" property formalized with time.

2. **Liveness**: Under fairness assumptions (a trigger is eventually raised),
   the leak is eventually closed. This is the first liveness property in the project.
-/

import Mathlib
import RequestProject.Governance.SenateMonster
import RequestProject.Governance.PrecedentLog

-- ════════════════════════════════════════════════════════════════
-- §1. SESSION MODEL
-- ════════════════════════════════════════════════════════════════

/-! ### Sessions as Finite-Duration Intervals

A session is a finite interval of legislative activity. The Senate's
"continuing body" property means that quorum persists across session
boundaries. -/

/-- A Congressional session with a start Congress number, session within
    that Congress, and a duration in legislative days. -/
structure Session where
  /-- The Congress number (e.g., 118). -/
  congress : ℕ
  /-- The session within the Congress (1 or 2). -/
  sessionNum : Fin 2
  /-- Duration in legislative days. -/
  duration : ℕ
  /-- Duration is positive. -/
  duration_pos : duration > 0

/-- The state of the Senate at the end of a session. -/
structure SessionEndState where
  /-- Number of continuing Senators (those whose terms don't expire). -/
  continuingSenators : ℕ
  /-- The precedent log accumulated during this session. -/
  precedentLog : PrecedentLog

/-- The state of the Senate at the start of the next session. -/
structure SessionStartState where
  /-- Number of Senators seated (continuing + newly sworn). -/
  seatedSenators : ℕ
  /-- The precedent log carried forward. -/
  precedentLog : PrecedentLog

/-- The transition between sessions preserves the continuing body property:
    continuing Senators from the old session are a subset of the new session's
    seated Senators. -/
def validTransition (endState : SessionEndState) (startState : SessionStartState) : Prop :=
  startState.seatedSenators ≥ endState.continuingSenators ∧
  startState.precedentLog = endState.precedentLog

/-
**Continuing Body Theorem with Sessions**: If the continuing Senators
    at session end form a quorum, then the next session starts with a quorum,
    and any block still has a fiber in the Monster address space.
-/
theorem dual_persistence_across_sessions
    (endState : SessionEndState)
    (startState : SessionStartState)
    (htrans : validTransition endState startState)
    (hcont : endState.continuingSenators ≥ 51)
    (b : Block) :
    startState.seatedSenators ≥ 51 ∧
    (∃ fiber : MonsterBase, blockToBase b = fiber) := by
  exact ⟨ htrans.1.trans' hcont, _, rfl ⟩

/-- The Senate always has at least 66 continuing Senators (2/3 of 100),
    so every session transition maintains a quorum. -/
theorem continuing_body_always_quorate :
    continuingSeats ≥ 51 := continuing_exceeds_quorum'

-- ════════════════════════════════════════════════════════════════
-- §2. LIVENESS: THE LEAK IS EVENTUALLY CLOSED
-- ════════════════════════════════════════════════════════════════

/-! ### Liveness Under Fairness

All current theorems are safety properties (invariants). Here we add the
first liveness theorem: under fairness assumptions (a trigger is eventually
raised), the leak is eventually closed.

We use a lightweight `∃ n, P n` formulation rather than importing the full
`Filter` / `Eventually` machinery. -/

/-- A stream of enforcement events over time steps. At each step,
    either a trigger fires or it doesn't. -/
def EnforcementStream := ℕ → Bool

/-- Fairness assumption: eventually, a trigger fires. -/
def isFair (stream : EnforcementStream) : Prop :=
  ∃ n : ℕ, stream n = true

/-- The number of accumulated violations at time `t`, given a violation
    stream and an enforcement stream. Violations accumulate until cleared
    by a trigger. -/
def accumulatedViolations
    (violations : ℕ → Bool) (enforcement : EnforcementStream) : ℕ → ℕ
  | 0 => if violations 0 then (if enforcement 0 then 0 else 1) else 0
  | n + 1 =>
    let prev := accumulatedViolations violations enforcement n
    let new := if violations (n + 1) then prev + 1 else prev
    if enforcement (n + 1) then 0 else new

/-
**Liveness Theorem**: Under fairness, accumulated violations eventually
    reach zero.
-/
theorem leak_eventually_closed
    (violations : ℕ → Bool)
    (enforcement : EnforcementStream)
    (hfair : isFair enforcement) :
    ∃ t : ℕ, accumulatedViolations violations enforcement t = 0 := by
  obtain ⟨ n, hn ⟩ := hfair;
  exact ⟨ n, by induction' n with n ih <;> simp_all +decide [ accumulatedViolations ] ⟩

/-
Under constant enforcement (every step triggers), violations never accumulate.
-/
theorem constant_enforcement_no_leak (violations : ℕ → Bool) :
    ∀ t, accumulatedViolations violations (fun _ => true) t = 0 := by
  intro t; induction' t with t ih <;> {unfold accumulatedViolations; aesop};

/-
Under no enforcement, violations can accumulate without bound.
    (The contrapositive of liveness: without fairness, no guarantee.)
-/
theorem no_enforcement_unbounded :
    ∀ n : ℕ, ∃ violations : ℕ → Bool,
    accumulatedViolations violations (fun _ => false) n = n := by
  intro n;
  induction' n with n ih;
  · exists fun _ => false;
  · obtain ⟨ violations, h ⟩ := ih;
    use fun i => if i = n + 1 then true else violations i;
    simp +decide [ *, accumulatedViolations ];
    convert h using 1;
    -- By definition of `accumulatedViolations`, we can prove this by induction on `n`.
    have h_ind : ∀ m ≤ n, accumulatedViolations (fun i => decide (i = n + 1) || violations i) (fun _ => false) m = accumulatedViolations violations (fun _ => false) m := by
      intro m hm; induction' m with m ih <;> simp_all +decide [ accumulatedViolations ] ;
      grind;
    exact h_ind n le_rfl

-- ════════════════════════════════════════════════════════════════
-- §3. PRECEDENT LOG GROWS ACROSS SESSIONS
-- ════════════════════════════════════════════════════════════════

/-! ### Precedent Monotonicity Across Time

The precedent log never shrinks across session boundaries.
"Historically, the Senate follows such precedents until 'the Senate in its
wisdom should reverse or modify that decision.'" -/

/-
Precedent logs are monotone: the log at the start of the next session
    has at least as many entries as at the end of the previous session.
-/
theorem precedent_monotone_across_sessions
    (endState : SessionEndState)
    (startState : SessionStartState)
    (htrans : validTransition endState startState) :
    startState.precedentLog.size ≥ endState.precedentLog.size := by
  cases htrans ; aesop