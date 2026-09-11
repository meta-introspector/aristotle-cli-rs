/-
  ClaudeClaims.lean — the checkable claims made by the Claude-attributed
  analyses that the dataset itself carries, checked against the dataset's own
  Lean modules and published artifacts.

  The dataset's Codeberg export (`data/codeberg/solfunmeme-comments.json`)
  contains nineteen comments that quote or paste an analysis attributed to
  Claude.  Most of what they say is interpretive and has no formal content
  ("misuse of the term Paxos", "red flag: inconsistent messaging").  Three
  threads, however, make claims that are arithmetic or protocol statements and
  can therefore be settled here:

    #44  "only the first 1600 holders can influence the dao according to this
          proposal", and, in the follow-up, "agents … prove membership in the
          top 1600 holders" and "one vote per eligible agent".
    #80  a fully costed building-investment framework (2,000 ownership tokens at
          $1,000, four 2,500 sq ft units, 500 usage tokens per unit at
          $500/$400/$600/$300).
    #109 "holders influence" as a general description of the governance design.

  Verdicts proved below.

    * The franchise really is 1,600 ranks wide (`franchise_is_1600`), so the
      figure quoted in #44 is the right one for *eligibility*.
    * It is the wrong figure for *influence*: the lobby's 1,000 seats are
      advisory, and no lobby vote changes any outcome, so only the first 600
      ranks are binding (`binding_franchise_is_600`, `lobby_cannot_influence`).
    * Under the electorate actually published, influence is narrower still: 187
      binding credentials exist, 948 of the 1,600 seats were never issued, and
      no bill can be enacted at all (`seats_never_issued`,
      `binding_credentials_issued`).
    * The shipped protocol does not implement either half of the #44 design.  A
      credential's rank is never read, so a vote from rank 1,000,000 is accepted
      (`rank_one_million_accepted`, `no_rank_bound_enforced`); and votes are not
      deduplicated, so one agent's single ballot can be counted any number of
      times (`one_vote_per_agent_violated`).
    * Both are implementable: `voteEligible1600` adds the missing rank test and
      `eligibleRanks` the missing deduplication, and with them the #44 design
      goal becomes a theorem — at most 1,600 ballots can ever be counted
      (`eligibleRanks_length_le_1600`), independently of how many are submitted.
    * The #80 framework's arithmetic is internally consistent: every total it
      states is the sum of its parts (`building_value_consistent`,
      `unit_areas_sum`, `usage_rights_raise`), and the ownership and usage token
      supplies coincide at 2,000 (`token_supplies_coincide`).
-/

import Mathlib.Tactic
import RequestProject.Solfunmeme.Review.PublishedData
import RequestProject.Solfunmeme.Review.VotingProtocolProperties

namespace Review.ClaudeClaims

open Review.PublishedData

/-! ## Claim 1 — "only the first 1600 holders can influence the DAO"

    Codeberg issue #44, quoting a Claude thread about proposal #86. -/

/-- The eligibility half of the claim is exact: the three chambers together span
    ranks 1–1600. -/
theorem franchise_is_1600 : senateSize + houseSize + lobbySize = 1600 := by decide

/-- The influence half is not: the lobby is advisory.  Only the senate's 100 and
    the house's 500 seats carry a binding vote. -/
theorem binding_franchise_is_600 : senateSize + houseSize = 600 := by decide

theorem advisory_seats : lobbySize = 1000 := by decide

/-- No lobby vote can influence a bill: replacing the lobby tally by an arbitrary
    one leaves the outcome unchanged. -/
theorem lobby_cannot_influence (s h l₁ l₂ : ChamberVote) :
    resolveBill ⟨s, h, l₁⟩ = resolveBill ⟨s, h, l₂⟩ := rfl

/-- Nor can it influence a veto override. -/
theorem lobby_cannot_influence_override (s h l₁ l₂ : ChamberVote) :
    vetoOverride ⟨s, h, l₁⟩ = vetoOverride ⟨s, h, l₂⟩ := rfl

/-- So the claim, read as a claim about influence, overstates the electorate by a
    factor of more than two and a half: 600 binding ranks, not 1600. -/
theorem claim_1600_overstates_influence :
    senateSize + houseSize < 1600 ∧ senateSize + houseSize + lobbySize = 1600 := by decide

/-! ### Against the published holder list

    `proofs/holder_identities.json` ranks 1,976 holders, so the 1,600-rank
    franchise is fully populated on paper and excludes 376 ranked holders. -/

theorem franchise_within_ranked_holders : 1600 ≤ identifiedHolders := by decide

theorem ranked_holders_outside_franchise : identifiedHolders - 1600 = 376 := by decide

/-- But credentials were issued to only 652 of the 1,600 seats. -/
theorem seats_never_issued : 1600 - totalCredentials = 948 := by decide

/-- Of those 652, only 187 sit in a chamber whose vote binds. -/
theorem binding_credentials_issued : senateCredentials + houseCredentials = 187 := by decide

/-- And even those 187 cannot influence anything, because the senate's 42
    credentials cannot reach the quorum of 51 (`no_bill_can_be_enacted`).  Stated
    for the record with the published numbers in place. -/
theorem binding_credentials_below_quorum :
    senateCredentials < 51 ∧ houseCredentials < 251 := by decide

/-! ## Claim 2 — "prove membership in the top 1600" and "one vote per agent"

    The same thread specifies the intended ZK design.  Neither requirement is
    present in `lean4/VotingProtocol.lean`. -/

/-- A credential claiming rank one million — far outside any chamber — is
    accepted. -/
def rankOneMillionVote : SignedVote :=
  { credential := ⟨"rank_1000000", .senate, 1000000, 1500000, 20537⟩
    freshness := ⟨"rank_1000000", 1500000, 408700000, "zk_any"⟩
    choice := .yea
    signature := ""
    channel := "direct"
    castSlot := 408700100
    deadline := 4436208000 }

theorem rank_one_million_accepted : voteValid rankOneMillionVote = true := by decide

/-- More than an example: no rank bound whatsoever is enforced, since the rank
    field does not occur in the validity test. -/
theorem no_rank_bound_enforced (v : SignedVote) (r : Nat) :
    voteValid { v with credential := { v.credential with rank := r } } = voteValid v := rfl

/-- "One vote per eligible agent" fails too: a single accepted ballot, resubmitted
    `n` times, contributes `n` to the tally. -/
theorem one_vote_per_agent_violated (n : Nat) :
    (tallyValid (List.replicate n rankOneMillionVote) .senate).1 = n := by
  have h : voteValid rankOneMillionVote = true ∧
      rankOneMillionVote.credential.chamber = Chamber.senate := by decide
  have h' : rankOneMillionVote.choice = BallotChoice.yea := by decide
  simp [tallyValid, h, h']

/-! ### The design as specified, and what it would guarantee

    Adding the two missing checks is cheap.  `voteEligible1600` is `voteValid`
    plus the rank bound the #44 design asks for; `eligibleRanks` collects the
    distinct credentials that voted, which is what "one vote per agent" means
    once each agent holds one credential. -/

/-- `voteValid` together with the top-1600 membership test. -/
def voteEligible1600 (v : SignedVote) : Bool :=
  voteValid v && 1 ≤ v.credential.rank && v.credential.rank ≤ 1600

/-- The distinct credential ranks among the eligible ballots of a submission list. -/
def eligibleRanks (votes : List SignedVote) : List Nat :=
  ((votes.filter voteEligible1600).map (fun v => v.credential.rank)).dedup

theorem voteEligible1600_rejects_high_rank (v : SignedVote) (h : 1600 < v.credential.rank) :
    voteEligible1600 v = false := by
  simp [voteEligible1600, Nat.not_le.2 h]

theorem voteEligible1600_rejects_invalid (v : SignedVote) (h : voteValid v = false) :
    voteEligible1600 v = false := by simp [voteEligible1600, h]

/-- The rank-one-million vote, which the shipped check accepts, is rejected. -/
theorem rankOneMillion_rejected : voteEligible1600 rankOneMillionVote = false := by decide

theorem eligibleRanks_nodup (votes : List SignedVote) : (eligibleRanks votes).Nodup :=
  List.nodup_dedup _

theorem eligibleRanks_mem {votes : List SignedVote} {r : Nat} (hr : r ∈ eligibleRanks votes) :
    1 ≤ r ∧ r ≤ 1600 := by
  rw [eligibleRanks, List.mem_dedup, List.mem_map] at hr
  obtain ⟨v, hv, rfl⟩ := hr
  have := (List.mem_filter.1 hv).2
  simp only [voteEligible1600, Bool.and_eq_true, decide_eq_true_eq] at this
  exact ⟨this.1.2, this.2⟩

/-- **The #44 design goal, as a theorem.**  However many ballots are submitted,
    at most 1,600 distinct credentials can ever be counted. -/
theorem eligibleRanks_length_le_1600 (votes : List SignedVote) :
    (eligibleRanks votes).length ≤ 1600 := by
  have hsub : (eligibleRanks votes).toFinset ⊆ Finset.Icc 1 1600 := by
    intro r hr
    rw [List.mem_toFinset] at hr
    obtain ⟨h1, h2⟩ := eligibleRanks_mem hr
    simp [Finset.mem_Icc, h1, h2]
  have hcard := Finset.card_le_card hsub
  rwa [List.toFinset_card_of_nodup (eligibleRanks_nodup votes), Nat.card_Icc] at hcard

private theorem dedup_replicate_succ (r n : Nat) :
    (List.replicate (n + 1) r).dedup = [r] := by
  induction n with
  | zero => simp
  | succ k ih => rw [List.replicate_succ, List.dedup_cons_of_mem (by simp), ih]

/-- Replay is neutralised: resubmitting one ballot changes nothing. -/
theorem eligibleRanks_replicate (v : SignedVote) (n : Nat) (hv : voteEligible1600 v = true) :
    eligibleRanks (List.replicate (n + 1) v) = [v.credential.rank] := by
  have hmap : ((List.replicate (n + 1) v).filter voteEligible1600).map
      (fun w => w.credential.rank) = List.replicate (n + 1) v.credential.rank := by
    simp [hv, List.map_replicate]
  rw [eligibleRanks, hmap, dedup_replicate_succ]

/-! ## Claim 3 — the building-investment framework of issue #80

    A Claude-authored proposal for a $2M multi-use building financed by two
    layers of tokens.  Unlike the governance numbers, its arithmetic is
    internally consistent; the theorems record each total. -/

def buildingValue : Nat := 2000000
def ownershipTokens : Nat := 2000
def ownershipTokenPrice : Nat := 1000

def totalArea : Nat := 10000
def unitCount : Nat := 4
def unitArea : Nat := 2500

def usageTokensPerUnit : Nat := 500
def unitAPrice : Nat := 500
def unitBPrice : Nat := 400
def unitCPrice : Nat := 600
def unitDPrice : Nat := 300

/-- 2,000 tokens at $1,000 is exactly the stated $2M building value. -/
theorem building_value_consistent :
    ownershipTokens * ownershipTokenPrice = buildingValue := by decide

/-- Four units of 2,500 sq ft is exactly the stated 10,000 sq ft. -/
theorem unit_areas_sum : unitCount * unitArea = totalArea := by decide

/-- The implied price of the building is $200 per square foot. -/
theorem price_per_square_foot : buildingValue / totalArea = 200 := by decide

/-- The four usage-rights offerings raise $900,000 between them. -/
theorem usage_rights_raise :
    usageTokensPerUnit * (unitAPrice + unitBPrice + unitCPrice + unitDPrice) = 900000 := by
  decide

/-- Total capital called for by the framework: $2.9M. -/
theorem total_capital :
    ownershipTokens * ownershipTokenPrice +
      usageTokensPerUnit * (unitAPrice + unitBPrice + unitCPrice + unitDPrice) = 2900000 := by
  decide

/-- The two token layers happen to have the same supply, 2,000 — a coincidence
    the proposal does not comment on, and a plausible source of confusion, since
    the two are not interchangeable. -/
theorem token_supplies_coincide : unitCount * usageTokensPerUnit = ownershipTokens := by decide

/-- The usage tokens are cheaper than the ownership tokens in every unit, so no
    unit's usage-rights offering by itself buys a controlling share of the
    building. -/
theorem usage_cheaper_than_ownership :
    unitAPrice < ownershipTokenPrice ∧ unitBPrice < ownershipTokenPrice ∧
      unitCPrice < ownershipTokenPrice ∧ unitDPrice < ownershipTokenPrice := by decide

end Review.ClaudeClaims
