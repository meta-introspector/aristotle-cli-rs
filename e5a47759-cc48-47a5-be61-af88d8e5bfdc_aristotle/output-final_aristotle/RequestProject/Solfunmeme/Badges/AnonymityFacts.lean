/-
  AnonymityFacts.lean — what the redaction search finds on the real roster.

  `RequestProject/Badges/Anonymity.lean` is the theory; this file runs it
  against the hundred badge pages the dataset supports
  (`RequestProject/Badges/Data/Claims.lean`).  Every concrete figure is checked
  by `decide`, so the kernel recomputes it from the dataset's own table.

  The answer is blunt, and worth knowing before publishing anything:

    * the rank identifies outright — it is a key, so a badge showing the rank
      names one senator (`rank_identifies_someone`);
    * so does the token-day standing (`standing_identifies_someone`), and so do
      the seniority date and the snapshot for at least one senator
      (`since_identifies_someone`, `snapshot_identifies_someone`);
    * and therefore *any* policy publishing any of those four leaves somebody
      alone in their crowd (`identifying_fields_break_anonymity`) — this is the
      monotonicity result doing the work: it is not enough to redact three of
      the four;
    * the genesis mark is the one publishable fact: publishing it alone still
      leaves every senator in a crowd of at least thirty-nine
      (`genesis_only_is_39_anonymous`);
    * so on this roster the most a holder can safely publish is one bit
      (`safe_policies_publish_at_most_the_genesis_mark`,
      `two_anonymity_costs_everything_but_genesis`).

  The badge that carries more than this is still perfectly usable — it just
  identifies its holder, which is often exactly what the holder wants.  What
  the file rules out is publishing *more* under the impression that redacting
  the standing alone made the badge anonymous.
-/

import RequestProject.Solfunmeme.Badges.Anonymity
import RequestProject.Solfunmeme.Badges.Data.Claims

namespace Badges.Anonymity

open Badges.Claim Badges.Disclose

/-- The hundred badge pages of the dataset. -/
def roster : List ClaimPage := Badges.Claim.claims

theorem roster_length : roster.length = 100 := by rfl

/-! ### The four identifying fields -/

theorem rank_identifies_someone : ∃ p ∈ roster, anonymity roster onlyRank p = 1 := by decide

theorem standing_identifies_someone : ∃ p ∈ roster, anonymity roster onlyStanding p = 1 := by
  decide

theorem since_identifies_someone : ∃ p ∈ roster, anonymity roster onlySince p = 1 := by decide

theorem snapshot_identifies_someone : ∃ p ∈ roster, anonymity roster onlySnapshot p = 1 := by
  decide

/-- **Publishing any of the four identifying fields breaks anonymity**, whatever
else is redacted. -/
theorem identifying_fields_break_anonymity (pol : Policy)
    (h : pol.since = true ∨ pol.snapshot = true ∨ pol.rank = true ∨ pol.standing = true) :
    kAnonymous roster pol 2 = false := by
  rcases h with h | h | h | h
  · obtain ⟨p, hp, hone⟩ := since_identifies_someone
    exact kAnonymous_false_of_witness hp
      (by rw [identified_by_more (le_onlySince h) hp hone]; omega)
  · obtain ⟨p, hp, hone⟩ := snapshot_identifies_someone
    exact kAnonymous_false_of_witness hp
      (by rw [identified_by_more (le_onlySnapshot h) hp hone]; omega)
  · obtain ⟨p, hp, hone⟩ := rank_identifies_someone
    exact kAnonymous_false_of_witness hp
      (by rw [identified_by_more (le_onlyRank h) hp hone]; omega)
  · obtain ⟨p, hp, hone⟩ := standing_identifies_someone
    exact kAnonymous_false_of_witness hp
      (by rw [identified_by_more (le_onlyStanding h) hp hone]; omega)

/-- **So a policy that keeps everybody in company publishes at most the genesis
mark.** -/
theorem safe_policies_publish_at_most_the_genesis_mark (pol : Policy)
    (h : kAnonymous roster pol 2 = true) :
    pol.since = false ∧ pol.snapshot = false ∧ pol.rank = false ∧ pol.standing = false := by
  have key : ∀ b : Bool, (b = true → kAnonymous roster pol 2 = false) → b = false := by
    intro b hb
    cases b
    · rfl
    · rw [hb rfl] at h; exact Bool.noConfusion h
  exact ⟨key _ (fun hb => identifying_fields_break_anonymity pol (Or.inl hb)),
    key _ (fun hb => identifying_fields_break_anonymity pol (Or.inr (Or.inl hb))),
    key _ (fun hb => identifying_fields_break_anonymity pol (Or.inr (Or.inr (Or.inl hb)))),
    key _ (fun hb => identifying_fields_break_anonymity pol (Or.inr (Or.inr (Or.inr hb))))⟩

/-- **And one bit is genuinely safe**: the genesis mark alone leaves every
senator in a crowd of at least thirty-nine. -/
theorem genesis_only_is_39_anonymous : kAnonymous roster onlyGenesis 39 = true := by decide

theorem genesis_only_is_2_anonymous : kAnonymous roster onlyGenesis 2 = true := by
  have h := genesis_only_is_39_anonymous
  simp only [kAnonymous, List.all_eq_true, decide_eq_true_eq] at h ⊢
  intro p hp
  have := h p hp
  omega

/-- **What two-anonymity costs on this roster**: everything except one bit. -/
theorem two_anonymity_costs_everything_but_genesis (pol : Policy)
    (h : kAnonymous roster pol 2 = true) : info pol ≤ 1 := by
  obtain ⟨h1, h2, h3, h4⟩ := safe_policies_publish_at_most_the_genesis_mark pol h
  simp only [info, h1, h2, h3, h4, if_false, Bool.false_eq_true]
  split <;> omega

/-- **The search finds it.**  Whatever the search returns for two-anonymity is
two-anonymous and publishes at least as much as the genesis mark alone — which,
by the previous theorem, is exactly one bit. -/
theorem search_finds_the_genesis_bit :
    kAnonymous roster (search roster 2) 2 = true ∧ info (search roster 2) = 1 := by
  have hk : kAnonymous roster (search roster 2) 2 = true :=
    search_is_k_anonymous roster 2 (by rw [roster_length]; omega)
  refine ⟨hk, ?_⟩
  have hle : info (search roster 2) ≤ 1 := two_anonymity_costs_everything_but_genesis _ hk
  have hge : info onlyGenesis ≤ info (search roster 2) :=
    search_is_best roster 2 onlyGenesis genesis_only_is_2_anonymous
  have : info onlyGenesis = 1 := by decide
  omega

end Badges.Anonymity
