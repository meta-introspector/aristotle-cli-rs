/-
An implementation plan for the SOLFUNMEME wish list, and its correctness.
-/
import RequestProject.Solfunmeme.Tickets.PlanData

/-!
# The plan

`PlanData.lean` carries the plan produced by `scripts/codeberg_plan.py`: a
total order on the wish list, each item tagged with a phase and with the wishes
it needs done first. This file says what a plan *is*, what makes one correct,
and checks that this one is.

## The general theory

A `Step` schedules one ticket in one phase after a list of prerequisites, and a
plan is a list of steps. Two things are asked of a plan:

* `PrereqsEarlier` — every prerequisite of a step is scheduled strictly before
  it;
* `PrereqsPresent` — every prerequisite is scheduled at all.

From the first alone the plan cannot ask for the impossible: `Plan.acyclic`
says the prerequisite relation it induces has no cycle, because the position of
a ticket in the plan strictly decreases along the relation
(`Plan.rank_lt_of_transGen`). This part is about any plan over any tickets.

## This plan

The plan is then tied to the ontology of `TBox.lean` and the ticket database of
`Corpus.lean`:

* `plan_schedules_the_wish_list` — the plan schedules the 105 wishes, each
  exactly once, and nothing else;
* `plan_entails_wish` — every scheduled ticket is one the knowledge base
  *entails* to be on the wish list, in every model, not merely one the corpus
  happens to list;
* `plan_prereqs_are_the_links` — the prerequisites in the plan are exactly the
  open wishes each ticket links to, as recorded in the corpus;
* `plan_prereqs_earlier`, `plan_no_cycle` — nothing is scheduled before
  something it needs, so the order is realisable;
* `plan_phases_monotone`, `plan_phase_counts` — the plan runs through its
  phases in order, and how big each phase is;
* `plan_blocked_go_last`, `plan_quickWins_before_epics` — the two ticket-level
  policies the phases are supposed to enforce.
-/

namespace SFM.Tickets

open SFM.DL

set_option maxRecDepth 400000

/-! ## Plans in general -/

/-- One step of a plan: a ticket, the phase it is scheduled in, and the
tickets that have to be done before it. -/
structure Step where
  /-- The ticket this step does. -/
  ticket : Nat
  /-- The phase the step belongs to. -/
  phase : Nat
  /-- The tickets that must be finished first. -/
  prereqs : List Nat
  deriving DecidableEq, Repr

namespace Plan

/-- The tickets a plan schedules, in order. -/
def tickets (p : List Step) : List Nat := p.map Step.ticket

/-- The position of a ticket in the plan. -/
def rank (p : List Step) (t : Nat) : Nat := (tickets p).idxOf t

/-- Every prerequisite of every step is scheduled strictly earlier. -/
def PrereqsEarlier (p : List Step) : Bool :=
  p.all (fun s => s.prereqs.all (fun d => rank p d < rank p s.ticket))

/-- Every prerequisite of every step is scheduled at all. -/
def PrereqsPresent (p : List Step) : Bool :=
  p.all (fun s => s.prereqs.all (fun d => (tickets p).contains d))

/-- The prerequisite relation a plan induces: `a` must come before `b`. -/
def DepEdge (p : List Step) (a b : Nat) : Prop :=
  ∃ s ∈ p, s.ticket = b ∧ a ∈ s.prereqs

/-- In a plan whose prerequisites all come earlier, an edge of the
prerequisite relation strictly increases position. -/
theorem rank_lt_of_depEdge {p : List Step} (h : PrereqsEarlier p = true) {a b : Nat}
    (hab : DepEdge p a b) : rank p a < rank p b := by
  obtain ⟨s, hs, rfl, hmem⟩ := hab
  have h1 := (List.all_eq_true.1 h) s hs
  have h2 := (List.all_eq_true.1 h1) a hmem
  simpa using h2

/-- Hence position strictly increases along any chain of prerequisites. -/
theorem rank_lt_of_transGen {p : List Step} (h : PrereqsEarlier p = true) {a b : Nat}
    (hab : Relation.TransGen (DepEdge p) a b) : rank p a < rank p b := by
  induction hab with
  | single hbc => exact rank_lt_of_depEdge h hbc
  | tail _ hcd ih => exact lt_trans ih (rank_lt_of_depEdge h hcd)

/-- **A plan that schedules every prerequisite first has no circular
prerequisites**: no ticket needs itself, however long the chain. -/
theorem acyclic {p : List Step} (h : PrereqsEarlier p = true) (a : Nat) :
    ¬ Relation.TransGen (DepEdge p) a a :=
  fun hcyc => lt_irrefl _ (rank_lt_of_transGen h hcyc)

/-- A prerequisite of a scheduled step is itself scheduled. -/
theorem mem_tickets_of_prereq {p : List Step} (h : PrereqsPresent p = true) {s : Step}
    (hs : s ∈ p) {d : Nat} (hd : d ∈ s.prereqs) : d ∈ tickets p := by
  have h1 := (List.all_eq_true.1 h) s hs
  have h2 := (List.all_eq_true.1 h1) d hd
  simpa using h2

end Plan

/-! ## The plan for the SOLFUNMEME wish list -/

/-- The generated plan, as steps. -/
def planSteps : List Step := planRaw.map (fun t => ⟨t.1, t.2.1, t.2.2⟩)

/-- The tickets the plan schedules, in order. -/
def planTickets : List Nat := Plan.tickets planSteps

/-- The prerequisites of a ticket according to the corpus: the wishes it links
to in its body, or declares that it depends on. -/
def prereqsOf (d : Nat) : List Nat :=
  domList.filter (fun e =>
    ((succD .Rreferences d).contains e || (succD .RdependsOn d).contains e) &&
      atomBC .WishListItem e)

/-! ### What the plan schedules -/

/-- The plan has one step for each of the 105 wishes. -/
theorem plan_length : planSteps.length = 105 := by decide

/-- No ticket is scheduled twice. -/
theorem plan_nodup : planTickets.Nodup := by decide

/-- Everything the plan schedules is on the wish list. -/
theorem plan_only_wishes : ∀ s ∈ planSteps, s.ticket ∈ wishNumbers := by
  have h : planSteps.all (fun s => wishNumbers.contains s.ticket) = true := by decide
  intro s hs
  simpa using (List.all_eq_true.1 h) s hs

/-- Everything on the wish list is scheduled. -/
theorem plan_covers_wishes : ∀ n ∈ wishNumbers, n ∈ planTickets := by
  have h : wishNumbers.all (fun n => planTickets.contains n) = true := by decide
  intro n hn
  simpa using (List.all_eq_true.1 h) n hn

/-- **The plan schedules exactly the wish list, each item once.** -/
theorem plan_schedules_the_wish_list :
    planTickets.Nodup ∧ (∀ n, n ∈ planTickets ↔ n ∈ wishNumbers) := by
  refine ⟨plan_nodup, fun n => ⟨?_, plan_covers_wishes n⟩⟩
  intro hn
  obtain ⟨s, hs, rfl⟩ := List.mem_map.1 hn
  exact plan_only_wishes s hs

/-- **Every ticket the plan schedules is entailed to be on the wish list** —
by the ontology together with the ticket database, in every model of them, not
just in the model the corpus describes. -/
theorem plan_entails_wish :
    ∀ s ∈ planSteps, kb.entails (.inst s.ticket (cn .WishListItem)) :=
  fun s hs => mem_wishNumbers_entails (plan_only_wishes s hs)

/-- Every wish that can be worked on right now is scheduled. -/
theorem plan_covers_actionable :
    ∀ n ∈ corpusModel.extension (cn .Actionable), n ∈ planTickets := by
  have h : (corpusModel.extension (cn .Actionable)).all
      (fun n => planTickets.contains n) = true := by decide
  intro n hn
  simpa using (List.all_eq_true.1 h) n hn

/-! ### That the order is realisable -/

/-- The prerequisites recorded in the plan are exactly the ones the corpus
gives: the open wishes each ticket links to. -/
theorem plan_prereqs_are_the_links : ∀ s ∈ planSteps, s.prereqs = prereqsOf s.ticket := by
  have h : planSteps.all (fun s => s.prereqs == prereqsOf s.ticket) = true := by decide
  intro s hs
  simpa using (List.all_eq_true.1 h) s hs

/-- Every prerequisite is scheduled strictly earlier than the step needing it. -/
theorem plan_prereqs_earlier : Plan.PrereqsEarlier planSteps = true := by decide

/-- Every prerequisite is scheduled. -/
theorem plan_prereqs_present : Plan.PrereqsPresent planSteps = true := by decide

/-- Spelled out: a prerequisite of a step comes before it in the plan. -/
theorem plan_prereq_before {s : Step} (hs : s ∈ planSteps) {d : Nat} (hd : d ∈ s.prereqs) :
    Plan.rank planSteps d < Plan.rank planSteps s.ticket :=
  Plan.rank_lt_of_depEdge plan_prereqs_earlier ⟨s, hs, rfl, hd⟩

/-- **The plan asks for nothing circular**: no ticket in it waits, through any
chain of prerequisites, on itself. -/
theorem plan_no_cycle (a : Nat) : ¬ Relation.TransGen (Plan.DepEdge planSteps) a a :=
  Plan.acyclic plan_prereqs_earlier a

/-! ### The phases -/

/-- The plan runs through its phases in order: the phase never goes back. -/
theorem plan_phases_monotone : (planSteps.map Step.phase).IsChain (· ≤ ·) := by decide

/-- Every step is in one of the six phases. -/
theorem plan_phases_named :
    ∀ s ∈ planSteps, ∃ q ∈ planPhases, q.1 = s.phase := by
  have h : planSteps.all (fun s => planPhases.any (fun q => q.1 == s.phase)) = true := by
    decide
  intro s hs
  have := (List.all_eq_true.1 h) s hs
  obtain ⟨q, hq, hq'⟩ := List.any_eq_true.1 this
  exact ⟨q, hq, by simpa using hq'⟩

/-- How big each phase is: 4 already in flight, 11 paid, 22 quick wins, 20 in
the main build, 46 to be shaped into specifications first, and 2 that wait on
another wish. -/
theorem plan_phase_counts :
    (List.range' 1 6).map (fun k => (k, planSteps.countP (fun s => s.phase == k))) =
      [(1, 4), (2, 11), (3, 22), (4, 20), (5, 46), (6, 2)] := by decide

/-- The priority score of a ticket, as `scripts/codeberg_plan.py` computes it:
`+8` for the Priority/High label, `+4` for a reward, `+2` for a busy thread,
`+2` if the maintainer has answered, `+1` if it was raised from outside, `+1`
for any kind label. -/
def planScore (d : Nat) : Nat :=
  (if baseHas .LPriorityHigh d then 8 else 0) +
  (if baseHas .LBounty d || baseHas .KBountyOffer d then 4 else 0) +
  (if baseHas .HotTopic d then 2 else 0) +
  (if baseHas .CoreAnswered d then 2 else 0) +
  (if baseHas .FromOutside d then 1 else 0) +
  (if [CN.LFeature, .LEnhancement, .LDocumentation, .LSecurity, .LTesting,
       .LBug].any (fun c => baseHas c d) then 1 else 0)

/-- **Inside a phase the plan follows its own priority rule**: of two
consecutive steps in the same phase, the first scores at least as high as the
second, and on a tie the lower ticket number comes first. -/
theorem plan_priority_within_phase :
    ∀ p ∈ planSteps.zip planSteps.tail, p.1.phase = p.2.phase →
      planScore p.2.ticket < planScore p.1.ticket ∨
      (planScore p.2.ticket = planScore p.1.ticket ∧ p.1.ticket < p.2.ticket) := by
  have h : (planSteps.zip planSteps.tail).all (fun p =>
      !(p.1.phase == p.2.phase) ||
      decide (planScore p.2.ticket < planScore p.1.ticket) ||
      (decide (planScore p.2.ticket = planScore p.1.ticket) &&
        decide (p.1.ticket < p.2.ticket))) = true := by decide
  intro p hp hph
  have h1 := (List.all_eq_true.1 h) p hp
  simp only [hph, beq_self_eq_true, Bool.not_true, Bool.false_or, Bool.or_eq_true,
    Bool.and_eq_true, decide_eq_true_eq] at h1
  exact h1

/-- The wishes blocked on another open wish are the last thing the plan
does. -/
theorem plan_blocked_go_last :
    ∀ s ∈ planSteps, corpusModel.bev (cn .Blocked) s.ticket = true → s.phase = 6 := by
  have h : planSteps.all (fun s =>
      !corpusModel.bev (cn .Blocked) s.ticket || s.phase == 6) = true := by decide
  intro s hs hb
  have := (List.all_eq_true.1 h) s hs
  simp only [hb, Bool.not_true, Bool.false_or, beq_iff_eq] at this
  exact this

/-- Every quick win is scheduled before every epic that is not already in
flight or paid for: the plan clears the short work first. -/
theorem plan_quickWins_before_epics :
    ∀ s ∈ planSteps, ∀ t ∈ planSteps,
      corpusModel.bev (cn .QuickWin) s.ticket = true →
      corpusModel.bev (cn .Epic) t.ticket = true → 3 ≤ t.phase →
      s.phase ≤ t.phase := by
  have h : planSteps.all (fun s => planSteps.all (fun t =>
      !corpusModel.bev (cn .QuickWin) s.ticket ||
      !corpusModel.bev (cn .Epic) t.ticket ||
      decide (t.phase < 3) || decide (s.phase ≤ t.phase))) = true := by decide
  intro s hs t ht hq he h3
  have h1 := (List.all_eq_true.1 ((List.all_eq_true.1 h) s hs)) t ht
  simp only [hq, he, Bool.not_true, Bool.false_or, Bool.or_eq_true, decide_eq_true_eq] at h1
  omega

end SFM.Tickets
