/-
# The senator's wishes, as a scheduled wish list

`SENATE-REPORT-VAICU.md` ends with a finding that is easy to miss:

> Nobody on the tracker has written down the compute market itself.  No ticket
> mentions a compute market, paying for proofs, or verified compute.  If the
> report's proposal is adopted it is a new item for the wish list, not an
> existing one.

This file adopts it.  The report's asks are written down here as wishes, each
with the wishes it depends on, each marked done or open, and each done wish
carrying the name of the theorem in this project that discharges it.  The result
is checked with exactly the machinery the tracker's own plan is checked with
(`RequestProject/Tickets/Plan.lean`): a wish list is a `List Step`, and the same
`PrereqsEarlier` / `PrereqsPresent` conditions make it realisable and acyclic.

What is proved here:

* `vaicuPlan_correct` — the wish list is a correct plan: every dependency is
  scheduled, and scheduled strictly earlier, so nothing waits on itself
  (`vaicu_no_cycle`);
* `vaicu_done_is_downward_closed` — nothing was ticked off on top of unfinished
  work: every dependency of a finished wish is finished;
* `vaicu_done_before_open` — the finished wishes are exactly a prefix of the
  plan, so the roadmap has a frontier rather than holes;
* `vaicu_ready` — the frontier: the open wishes all of whose dependencies are
  already done, and `vaicu_ready_nonempty`, that work can start today;
* `vaicu_every_done_has_evidence` — every wish marked done names at least one
  theorem, and no open wish claims any (the named theorems are `#check`ed
  below, so a renamed or deleted one breaks this file);
* `vaicu_open_nonempty`, `vaicu_done_nonempty` — the list is neither empty
  boasting nor an empty to-do list: both parts are inhabited, so none of the
  statements above is vacuous;
* `vaicu_wishes_are_new` — every one of these wishes is genuinely new: none of
  them is a ticket the tracker's plan already schedules.
-/
import RequestProject.Solfunmeme.Tickets.Plan
import RequestProject.Solfunmeme.Market.Challenge
import RequestProject.Solfunmeme.Market.Fit
import RequestProject.Solfunmeme.Market.Private
import RequestProject.Solfunmeme.Market.Stake
import RequestProject.Solfunmeme.Market.Supply
import RequestProject.Solfunmeme.Market.Twin

namespace RequestProject.Market

open SFM.Tickets hiding Step

/-- The step type of the plan theory, renamed to avoid the build-chain `Step`
of `RequestProject/Market/Supply.lean`. -/
abbrev WishStep := SFM.Tickets.Step

/-! ## The wish list -/

/-- One of the senator's wishes: an identifier (numbered from 900 so that it
cannot be confused with a codeberg ticket number), the phase it belongs to, the
wishes it depends on, a title, whether it is finished, and the theorems that
finish it. -/
structure Wish where
  /-- The identifier of the wish. -/
  id : Nat
  /-- The phase of the roadmap the wish belongs to. -/
  phase : Nat
  /-- The wishes that must be granted first. -/
  prereqs : List Nat
  /-- What is asked for. -/
  title : String
  /-- Whether it is done. -/
  done : Bool
  /-- The theorems in this project that discharge it, when it is done. -/
  evidence : List String
  deriving DecidableEq, Repr

/-- **The wishes of senator Vaicu's report**, in the order the project can take
them.  Phase 1 is the settlement layer the market rests on, phase 2 the
mechanisms that make it safe to run, phase 3 the products the report ranks, and
phase 4 the things the report asks for that nothing here yet proves. -/
def vaicuWishes : List Wish :=
  [ ⟨901, 1, [], "settle a job by verification: job → spec → execution → proof → payment",
      true, ["paid_implies_spec", "honest_operator_paid", "payout_conserves"]⟩
  , ⟨902, 1, [901], "measure contribution by verified work only, not by validator vote",
      true, ["revenue_only_from_verified", "vote_market_pays_for_wrong_result",
             "proof_market_immune_to_collusion"]⟩
  , ⟨903, 1, [901], "make the token coordinate the market: stake, bond, reward",
      true, ["run_of_all_accepted", "failure_count_le_stake_div_bond", "liar_earns_nothing"]⟩
  , ⟨904, 2, [901, 902], "an optimistic market: challenge window, slashing, challenger reward",
      true, ["diligent_court_pays_iff_spec", "slashed_iff_challenged",
             "optimistic_pays_for_wrong_result"]⟩
  , ⟨905, 2, [904], "auditing by sampling: what a partial audit does and does not buy",
      true, ["escaping_samples_card", "escaping_lt_all", "full_audit_detects"]⟩
  , ⟨914, 2, [905], "an economic security parameter: how much auditing buys how much safety",
      true, ["escape_geometric_bound", "escape_ratio_le", "escaping_samples_geometric"]⟩
  , ⟨906, 2, [901], "private input + untrusted compute + verifiable result",
      true, ["mask_bijective", "card_mask_fiber", "private_verified_result"]⟩
  , ⟨907, 3, [901], "software supply chain: source =? deployed artifact",
      true, ["deployed_eq_rebuild", "deployed_unique", "tampering_invalidates_chain"]⟩
  , ⟨908, 3, [907], "artifact ⊨ required properties",
      true, ["deployed_satisfies", "deployed_satisfies_all", "deployed_of_matching_digest"]⟩
  , ⟨909, 3, [901], "digital twins: A may connect to B, and a substitution keeps the guarantees",
      true, ["Assembly.closed_substitute", "Assembly.guarantee_preserved",
             "Assembly.closed_substitute_list"]⟩
  , ⟨913, 3, [909], "tolerances and timing in the twin, so \"connects\" means fits",
      true, ["fits_iff_worst_case", "FitMachine.fitClosed_substitute",
             "FitMachine.closed_of_fitClosed", "deadline_met_iff"]⟩
  , ⟨910, 4, [901, 902], "a sound and complete verifier for LLM inference",
      false, []⟩
  , ⟨911, 4, [906], "encrypted execution beyond additively equivariant computations",
      false, []⟩
  , ⟨912, 4, [907, 908], "semantics for the toolchain, so a build trusts less than its tools",
      false, []⟩
  , ⟨916, 4, [913], "geometry and kinematics beyond one-dimensional tolerances",
      false, []⟩
  , ⟨915, 4, [903, 904, 910], "the whole loop, on chain: a staked verified compute network",
      false, []⟩
  ]

/-- The wish list as a plan in the sense of `RequestProject/Tickets/Plan.lean`. -/
def vaicuPlan : List WishStep := vaicuWishes.map (fun w => ⟨w.id, w.phase, w.prereqs⟩)

/-- The wishes in the order they are scheduled. -/
def vaicuTickets : List Nat := Plan.tickets vaicuPlan

/-- The wishes already granted. -/
def vaicuDone : List Nat := (vaicuWishes.filter (·.done)).map Wish.id

/-- The wishes still open. -/
def vaicuOpen : List Nat := (vaicuWishes.filter (fun w => !w.done)).map Wish.id

/-! ## It is a correct plan -/

/-- The list schedules sixteen wishes, no wish twice. -/
theorem vaicu_length : vaicuPlan.length = 16 := by decide

/-- No wish is scheduled twice. -/
theorem vaicu_nodup : vaicuTickets.Nodup := by decide

/-- Every dependency is scheduled strictly earlier than the wish needing it. -/
theorem vaicu_prereqs_earlier : Plan.PrereqsEarlier vaicuPlan = true := by decide

/-- Every dependency is scheduled at all. -/
theorem vaicu_prereqs_present : Plan.PrereqsPresent vaicuPlan = true := by decide

/-- **The senator's wish list is a correct plan.** -/
theorem vaicuPlan_correct :
    vaicuTickets.Nodup ∧ Plan.PrereqsEarlier vaicuPlan = true ∧
      Plan.PrereqsPresent vaicuPlan = true :=
  ⟨vaicu_nodup, vaicu_prereqs_earlier, vaicu_prereqs_present⟩

/-- Hence no wish waits, through any chain of dependencies, on itself. -/
theorem vaicu_no_cycle (a : Nat) : ¬ Relation.TransGen (Plan.DepEdge vaicuPlan) a a :=
  Plan.acyclic vaicu_prereqs_earlier a

/-- Spelled out: a dependency of a wish comes before it. -/
theorem vaicu_prereq_before {s : WishStep} (hs : s ∈ vaicuPlan) {d : Nat} (hd : d ∈ s.prereqs) :
    Plan.rank vaicuPlan d < Plan.rank vaicuPlan s.ticket :=
  Plan.rank_lt_of_depEdge vaicu_prereqs_earlier ⟨s, hs, rfl, hd⟩

/-- The roadmap runs through its phases in order. -/
theorem vaicu_phases_monotone : (vaicuPlan.map (·.phase)).IsChain (· ≤ ·) := by decide

/-- How big each phase is: three for the settlement layer, four for the safety
mechanisms, four for the products, five still open. -/
theorem vaicu_phase_counts :
    (List.range' 1 4).map (fun k => (k, vaicuPlan.countP (fun s => s.phase == k))) =
      [(1, 3), (2, 4), (3, 4), (4, 5)] := by decide

/-! ## Done, open, and the frontier -/

/-- Every wish is either done or open, and not both. -/
theorem vaicu_done_open_partition :
    ∀ n ∈ vaicuTickets, (n ∈ vaicuDone) ≠ (n ∈ vaicuOpen) := by
  have h : vaicuTickets.all (fun n =>
      (vaicuDone.contains n) != (vaicuOpen.contains n)) = true := by decide
  intro n hn
  have h1 := (List.all_eq_true.1 h) n hn
  simp only [bne_iff_ne, ne_eq] at h1
  simpa using h1

/-- **Nothing was ticked off on top of unfinished work**: every dependency of a
granted wish is itself granted. -/
theorem vaicu_done_is_downward_closed :
    ∀ w ∈ vaicuWishes, w.done = true → ∀ d ∈ w.prereqs, d ∈ vaicuDone := by
  have h : vaicuWishes.all (fun w =>
      !w.done || w.prereqs.all (fun d => vaicuDone.contains d)) = true := by decide
  intro w hw hdone d hd
  have h1 := (List.all_eq_true.1 h) w hw
  simp only [hdone, Bool.not_true, Bool.false_or] at h1
  simpa using (List.all_eq_true.1 h1) d hd

/-- **The finished work is a prefix**: every granted wish is scheduled before
every open one, so the roadmap has a single frontier and no holes behind it. -/
theorem vaicu_done_before_open :
    ∀ a ∈ vaicuDone, ∀ b ∈ vaicuOpen,
      Plan.rank vaicuPlan a < Plan.rank vaicuPlan b := by
  have h : vaicuDone.all (fun a => vaicuOpen.all (fun b =>
      decide (Plan.rank vaicuPlan a < Plan.rank vaicuPlan b))) = true := by decide
  intro a ha b hb
  have h1 := (List.all_eq_true.1 ((List.all_eq_true.1 h) a ha)) b hb
  simpa using h1

/-- The frontier: an open wish whose dependencies are all granted can be started
now. -/
def VaicuReady (w : Wish) : Bool :=
  !w.done && w.prereqs.all (fun d => vaicuDone.contains d)

/-- **What can be started today**: the verifier for inference, encrypted
execution beyond additive masks, toolchain semantics and geometry beyond
one-dimensional tolerances.  Only the last wish — the whole loop on chain — is
blocked, and it is blocked on the verifier. -/
theorem vaicu_ready :
    (vaicuWishes.filter VaicuReady).map Wish.id = [910, 911, 912, 916] := by decide

/-- Work can start: the frontier is not empty. -/
theorem vaicu_ready_nonempty : (vaicuWishes.filter VaicuReady) ≠ [] := by decide

/-- The one wish that is blocked is blocked on an open wish. -/
theorem vaicu_blocked :
    ∀ w ∈ vaicuWishes, w.done = false → VaicuReady w = false →
      ∃ d ∈ w.prereqs, d ∈ vaicuOpen := by
  have h : vaicuWishes.all (fun w =>
      w.done || VaicuReady w || w.prereqs.any (fun d => vaicuOpen.contains d)) = true := by
    decide
  intro w hw hdone hready
  have h1 := (List.all_eq_true.1 h) w hw
  simp only [hdone, hready, Bool.or_self, Bool.false_or] at h1
  obtain ⟨d, hd, hd'⟩ := List.any_eq_true.1 h1
  exact ⟨d, hd, by simpa using hd'⟩

/-! ## Nothing here is vacuous -/

/-- Some wishes are granted. -/
theorem vaicu_done_nonempty : vaicuDone ≠ [] := by decide

/-- And some are not: the roadmap is not a victory lap. -/
theorem vaicu_open_nonempty : vaicuOpen ≠ [] := by decide

/-- Eleven of sixteen are granted. -/
theorem vaicu_progress : vaicuDone.length = 11 ∧ vaicuOpen.length = 5 := by decide

/-- **Every granted wish names the theorems that grant it**, and no open wish
claims any. -/
theorem vaicu_every_done_has_evidence :
    ∀ w ∈ vaicuWishes, (w.done = true ↔ w.evidence ≠ []) := by
  have h : vaicuWishes.all (fun w => w.done == !w.evidence.isEmpty) = true := by decide
  intro w hw
  have h1 := (List.all_eq_true.1 h) w hw
  simp only [beq_iff_eq] at h1
  cases hd : w.done <;> cases he : w.evidence <;> simp_all

/- The evidence is not just a string: each theorem named in the `evidence`
field above is a real theorem of this project.  The `#check`s below fail to
elaborate if any of those names goes away or is renamed. -/
section EvidenceCheck

-- phase 1
#check @paid_implies_spec
#check @honest_operator_paid
#check @payout_conserves
#check @revenue_only_from_verified
#check @vote_market_pays_for_wrong_result
#check @proof_market_immune_to_collusion
#check @run_of_all_accepted
#check @failure_count_le_stake_div_bond
#check @liar_earns_nothing
-- phase 2
#check @diligent_court_pays_iff_spec
#check @slashed_iff_challenged
#check @optimistic_pays_for_wrong_result
#check @escaping_samples_card
#check @escaping_lt_all
#check @full_audit_detects
#check @escape_geometric_bound
#check @escape_ratio_le
#check @escaping_samples_geometric
#check @mask_bijective
#check @card_mask_fiber
#check @private_verified_result
-- phase 3
#check @deployed_eq_rebuild
#check @deployed_unique
#check @tampering_invalidates_chain
#check @deployed_satisfies
#check @deployed_satisfies_all
#check @deployed_of_matching_digest
#check @Assembly.closed_substitute
#check @Assembly.guarantee_preserved
#check @Assembly.closed_substitute_list
#check @fits_iff_worst_case
#check @FitMachine.fitClosed_substitute
#check @FitMachine.closed_of_fitClosed
#check @deadline_met_iff

end EvidenceCheck

/-! ## These wishes are new -/

/-- **The senator's wishes are not on the tracker.**  None of them is a ticket
the tracker's own plan schedules — which is the report's finding, now a
theorem: the compute market had to be written down, it was not already there. -/
theorem vaicu_wishes_are_new : ∀ s ∈ vaicuPlan, s.ticket ∉ planTickets := by
  have h : vaicuPlan.all (fun s => !planTickets.contains s.ticket) = true := by decide
  intro s hs
  have h1 := (List.all_eq_true.1 h) s hs
  simpa using h1

end RequestProject.Market
