import Mathlib

/-!
# The claim lifecycle of a Mekanism resource network, verified

The `mekanism-network` router tracks each request as a *claim* whose status
moves through a state machine:

```
created --> in_transit --> arrived --> delivering --> completed
   |             |            |            |
   |-> expired   |-> expired  `-> failed   `-> failed
   `-> failed    `-> failed
```

(`created` may also jump straight to `arrived`, when the "shipped" notice is
lost but the goods show up.)  `completed`, `failed` and `expired` are terminal.
`transition` refuses any move that is not in this table, and appends the new
status to the claim's history.

This file transcribes the table and proves what the router relies on: terminal
statuses are dead ends, no claim can ever return to a status it has left, every
claim reaches a terminal status in at most four moves, and a claim's history is
always a legal run starting at `created` and ending at its current status.
-/

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace ClaimLifecycle

/-- The seven claim statuses. -/
inductive Status where
  /-- The claim has just been created. -/
  | created
  /-- The sender has shipped the goods. -/
  | inTransit
  /-- The goods have arrived at the router. -/
  | arrived
  /-- The router is delivering to the sender's inbox. -/
  | delivering
  /-- Delivered. -/
  | completed
  /-- Something went wrong. -/
  | failed
  /-- The claim timed out. -/
  | expired
deriving DecidableEq, Repr, Inhabited

open Status

/-- The transition table, transcribed from the router. -/
def allowed : Status → Status → Bool
  | created, inTransit => true
  | created, arrived => true
  | created, expired => true
  | created, failed => true
  | inTransit, arrived => true
  | inTransit, expired => true
  | inTransit, failed => true
  | arrived, delivering => true
  | arrived, failed => true
  | delivering, completed => true
  | delivering, failed => true
  | _, _ => false

/-- The terminal statuses. -/
def Terminal (s : Status) : Prop := s = completed ∨ s = failed ∨ s = expired

instance (s : Status) : Decidable (Terminal s) := by
  unfold Terminal; infer_instance

/-- How far along a claim is.  Every legal move increases it. -/
def rank : Status → ℕ
  | created => 0
  | inTransit => 1
  | arrived => 2
  | delivering => 3
  | completed => 4
  | failed => 4
  | expired => 4

/-! ## Basic properties of the table -/

/-- **Every legal move makes progress.** -/
theorem rank_lt_of_allowed {s t : Status} (h : allowed s t = true) : rank s < rank t := by
  cases s <;> cases t <;> simp_all [allowed, rank]

/-- **Terminal statuses are dead ends.** -/
theorem no_transition_of_terminal {s : Status} (h : Terminal s) (t : Status) :
    allowed s t = false := by
  rcases h with rfl | rfl | rfl <;> cases t <;> rfl

/-- **… and only terminal statuses are dead ends.** -/
theorem terminal_of_no_transition {s : Status} (h : ∀ t, allowed s t = false) :
    Terminal s := by
  cases s
  · exact absurd (h inTransit) (by simp [allowed])
  · exact absurd (h arrived) (by simp [allowed])
  · exact absurd (h delivering) (by simp [allowed])
  · exact absurd (h completed) (by simp [allowed])
  · exact Or.inl rfl
  · exact Or.inr (Or.inl rfl)
  · exact Or.inr (Or.inr rfl)

/-- **A claim can only be completed from `delivering`.** -/
theorem allowed_completed {s : Status} (h : allowed s completed = true) : s = delivering := by
  cases s <;> simp_all [allowed]

/-- **A claim can only reach `delivering` from `arrived`.** -/
theorem allowed_delivering {s : Status} (h : allowed s delivering = true) : s = arrived := by
  cases s <;> simp_all [allowed]

/-! ## Runs -/

/-- A run: a list of statuses each of which legally follows the previous one. -/
def Chain : List Status → Prop
  | [] => True
  | [_] => True
  | a :: b :: rest => allowed a b = true ∧ Chain (b :: rest)

theorem chain_cons_of {a b : Status} {rest : List Status}
    (h1 : allowed a b = true) (h2 : Chain (b :: rest)) : Chain (a :: b :: rest) := ⟨h1, h2⟩

/-- **A run never repeats a status**: its ranks strictly increase, so nothing
can come back. -/
theorem chain_rank_lt {a b : Status} {rest : List Status}
    (h : Chain (a :: b :: rest)) : rank a < rank b :=
  rank_lt_of_allowed h.1

/-- **Every run is short**: from a status of rank `k` there are at most `4 - k`
further moves. -/
theorem chain_length_le {a : Status} {l : List Status} (h : Chain (a :: l)) :
    l.length + rank a ≤ 4 := by
  induction l generalizing a with
  | nil =>
      have : rank a ≤ 4 := by cases a <;> simp [rank]
      simpa using this
  | cons b rest ih =>
      have h1 : rank a < rank b := chain_rank_lt h
      have h2 := ih h.2
      simp only [List.length_cons]
      omega

/-- **A claim is finished after at most four moves.** -/
theorem chain_created_length_le {l : List Status} (h : Chain (created :: l)) :
    l.length ≤ 4 := by
  have := chain_length_le h
  simpa [rank] using this

/-- Extending a run by one legal move is again a run. -/
theorem chain_concat {l : List Status} {a t : Status} (hl : Chain l)
    (hla : l.getLast? = some a) (h : allowed a t = true) : Chain (l ++ [t]) := by
  induction l with
  | nil => simp at hla
  | cons x rest ih =>
      cases rest with
      | nil =>
          simp only [List.getLast?_singleton, Option.some.injEq] at hla
          subst hla
          exact ⟨h, trivial⟩
      | cons y rest' =>
          refine ⟨hl.1, ?_⟩
          exact ih hl.2 (by simpa using hla)

/-! ## Claims -/

/-- A claim, reduced to what the state machine sees: its current status and
the history of statuses it has been through. -/
structure Claim where
  /-- The current status. -/
  status : Status
  /-- Every status the claim has had, oldest first. -/
  history : List Status
deriving Repr

/-- A fresh claim. -/
def newClaim : Claim := { status := created, history := [created] }

/-- `claims.transition`: move to `t` if the table allows it, recording the move
in the history; otherwise fail. -/
def transition (c : Claim) (t : Status) : Option Claim :=
  if allowed c.status t then
    some { status := t, history := c.history ++ [t] }
  else none

/-- The invariant the ledger maintains: a claim's history is a legal run that
starts at `created` and ends at its current status. -/
def Wf (c : Claim) : Prop :=
  c.history.head? = some created ∧ Chain c.history ∧ c.history.getLast? = some c.status

theorem wf_newClaim : Wf newClaim := ⟨rfl, trivial, rfl⟩

/-- **A refused transition is one the table forbids.** -/
theorem transition_eq_none {c : Claim} {t : Status} (h : transition c t = none) :
    allowed c.status t = false := by
  by_cases hb : allowed c.status t
  · simp [transition, hb] at h
  · simpa using hb

/-- **A successful transition records exactly the new status.** -/
theorem transition_eq_some {c c' : Claim} {t : Status} (h : transition c t = some c') :
    allowed c.status t = true ∧ c'.status = t ∧ c'.history = c.history ++ [t] := by
  by_cases hb : allowed c.status t
  · simp only [transition, hb, if_true, Option.some.injEq] at h
    subst h
    exact ⟨hb, rfl, rfl⟩
  · simp [transition, hb] at h

/-- **A terminal claim never changes again.** -/
theorem transition_of_terminal {c : Claim} (h : Terminal c.status) (t : Status) :
    transition c t = none := by
  simp [transition, no_transition_of_terminal h t]

/-- **The invariant is preserved.** -/
theorem wf_transition {c c' : Claim} {t : Status} (hw : Wf c) (h : transition c t = some c') :
    Wf c' := by
  obtain ⟨hb, hst, hhist⟩ := transition_eq_some h
  obtain ⟨hhead, hchain, hlast⟩ := hw
  have hne : c.history ≠ [] := by
    intro hnil
    rw [hnil] at hhead
    simp at hhead
  refine ⟨?_, ?_, ?_⟩
  · rw [hhist, List.head?_append_of_ne_nil _ hne]
    exact hhead
  · rw [hhist]
    exact chain_concat hchain hlast hb
  · rw [hhist, hst]
    simp

/-- **A claim's history is at most five statuses long**, so the ledger's
per-claim history cannot grow without bound. -/
theorem wf_history_length {c : Claim} (hw : Wf c) : c.history.length ≤ 5 := by
  obtain ⟨hhead, hchain, -⟩ := hw
  cases hl : c.history with
  | nil => simp
  | cons a rest =>
      rw [hl] at hhead hchain
      simp only [List.head?_cons, Option.some.injEq] at hhead
      subst hhead
      have := chain_created_length_le hchain
      simp only [List.length_cons]
      omega

/-- The happy path is a legal run; by `chain_created_length_le` no run from
`created` is longer. -/
theorem happy_path : Chain [created, inTransit, arrived, delivering, completed] :=
  ⟨rfl, ⟨rfl, ⟨rfl, ⟨rfl, trivial⟩⟩⟩⟩

end ClaimLifecycle
