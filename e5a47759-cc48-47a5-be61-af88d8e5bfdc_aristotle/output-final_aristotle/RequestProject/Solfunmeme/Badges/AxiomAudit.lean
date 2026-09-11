/-
  AxiomAudit.lean — trusted-base audit of the badge modules.

  Every theorem in `Badges.Tiers`, `Badges.TokenDays` and `Badges.Badge` is
  discharged by the kernel or by ordinary tactics; the two large numeric facts
  (0.1% per day compounds above 44% a year, and the supply more than doubles in
  two years) use `decide +kernel`, not `native_decide`, so neither adds
  `Lean.ofReduceBool` or `Lean.trustCompiler` to the trusted base.  The
  `#print axioms` commands below report the trusted base of each headline
  result (they emit information messages during elaboration).
-/

import RequestProject.Solfunmeme.Badges.Tiers
import RequestProject.Solfunmeme.Badges.TokenDays
import RequestProject.Solfunmeme.Badges.Badge
import RequestProject.Solfunmeme.Badges.SnapshotFacts
import RequestProject.Solfunmeme.Badges.ClaimFacts
import RequestProject.Solfunmeme.Badges.Disclosure
import RequestProject.Solfunmeme.Badges.AnonymityFacts

namespace Badges.AxiomAudit

-- Tier structure and the golden-ratio claims.
#print axioms Badges.tier_exhaustive
#print axioms Badges.no_voice_beyond_1600
#print axioms Badges.senate_seat_count
#print axioms Badges.representative_seat_count
#print axioms Badges.vendor_seat_count
#print axioms Badges.tier_sizes_not_fibonacci
#print axioms Badges.cumulative_sizes_not_fibonacci
#print axioms Badges.tier_ratios_differ
#print axioms Badges.senate_rep_ratio_off_from_phi_cubed
#print axioms Badges.rep_vendor_ratio_off_from_phi
#print axioms Badges.phi_progression_from_100
#print axioms Badges.senate_alone_cannot_enact
#print axioms Badges.operational_bypasses_senate
#print axioms Badges.senate_veto_redundant_for_major

-- The token-day integral and the interest arithmetic.
#print axioms Badges.tokenDays_eq_sum_balanceOn
#print axioms Badges.tokenDays_append
#print axioms Badges.tokenDays_lt_append
#print axioms Badges.tokenDays_mono_balance
#print axioms Badges.chad_tokenDays
#print axioms Badges.chad_interest
#print axioms Badges.time_beats_size
#print axioms Badges.accrue_le_tokenDays
#print axioms Badges.accrue_eq_tokenDays
#print axioms Badges.dip_wipes_history
#print axioms Badges.daily_rate_compounds_above_44_percent
#print axioms Badges.simple_understates_compound
#print axioms Badges.supply_more_than_doubles_in_two_years
#print axioms Badges.uniform_interest_share_invariant
#print axioms Badges.uniform_interest_rank_invariant

-- The badge itself.
#print axioms Badges.mint_address_irrelevant
#print axioms Badges.mint_hides_rank_within_tier
#print axioms Badges.mint_reveals_constant_balance
#print axioms Badges.genesis_tokenDays_lower_bound
#print axioms Badges.chad_badge
#print axioms Badges.senate_badges_short
#print axioms Badges.all_badges_short
#print axioms Badges.badge_shortfall

-- The badge computed from the dataset's 52 tier snapshots.
#print axioms Badges.Snapshot.snapshot_count
#print axioms Badges.Snapshot.senate_recorded
#print axioms Badges.Snapshot.times_increasing
#print axioms Badges.Snapshot.window_days
#print axioms Badges.Snapshot.genesis_count
#print axioms Badges.Snapshot.genesis_fewer_than_credentials
#print axioms Badges.Snapshot.genesis_fewer_than_seats
#print axioms Badges.Snapshot.senate_churn
#print axioms Badges.Snapshot.third_tokenDays_upper
#print axioms Badges.Snapshot.fourth_tokenDays_lower
#print axioms Badges.Snapshot.tokenDays_reorders_senate
#print axioms Badges.Snapshot.leader_tokenDays
#print axioms Badges.Snapshot.leader_dominates

-- The claim protocol of the single-page badges.
#print axioms Badges.Claim.unlock_eq_some_iff
#print axioms Badges.Claim.unlock_requires_key
#print axioms Badges.Claim.unlock_output_is_page_statement
#print axioms Badges.Claim.no_replay
#print axioms Badges.Claim.challenge_binds_statement
#print axioms Badges.Claim.challenge_binds_nonce
#print axioms Badges.Claim.verifyToken_mintToken
#print axioms Badges.Claim.token_tampering_needs_new_signature
#print axioms Badges.Claim.verifyToken_requires_key

-- The 100 published badge pages, against the dataset.
#print axioms Badges.Claim.claims_eq_pages
#print axioms Badges.Claim.dates_agree
#print axioms Badges.Claim.since_backed
#print axioms Badges.Claim.since_maximal
#print axioms Badges.Claim.genesis_badge_count
#print axioms Badges.Claim.standing_bracket
#print axioms Badges.Claim.leader_statement
#print axioms Badges.Claim.addresses_are_32_byte_keys
#print axioms Badges.Claim.addresses_nodup
#print axioms Badges.Claim.challengePrefixes_nodup
#print axioms Badges.Claim.distinct_pages_distinct_challenges

/-! ### `RequestProject/Badges/Disclosure.lean` -/

#print axioms Badges.Disclose.standing_redaction_is_invisible
#print axioms Badges.Disclose.rank_redaction_is_invisible
#print axioms Badges.Disclose.since_redaction_is_invisible
#print axioms Badges.Disclose.snapshot_redaction_is_invisible
#print axioms Badges.Disclose.genesis_redaction_is_invisible
#print axioms Badges.Disclose.redacted_label_absent
#print axioms Badges.Disclose.extras_cannot_forge_a_page_field
#print axioms Badges.Disclose.render_append
#print axioms Badges.Disclose.render_append_length
#print axioms Badges.Disclose.render_pos
#print axioms Badges.Disclose.adding_a_field_changes_the_statement
#print axioms Badges.Disclose.disclosed_length_standing
#print axioms Badges.Disclose.disclosing_more_changes_the_statement
#print axioms Badges.Disclose.unlock_eq_some_iff
#print axioms Badges.Disclose.unlock_sound
#print axioms Badges.Disclose.unlock_complete
#print axioms Badges.Disclose.unlock_requires_key
#print axioms Badges.Disclose.no_replay
#print axioms Badges.Disclose.statement_inside_challenge
#print axioms Badges.Disclose.challenge_binds_statement
#print axioms Badges.Disclose.verifyToken_claim
#print axioms Badges.Disclose.verifyToken_signature
#print axioms Badges.Disclose.verifyToken_extras_wf
#print axioms Badges.Disclose.verifyToken_mintToken
#print axioms Badges.Disclose.token_tampering_needs_new_signature
#print axioms Badges.Disclose.cannot_unredact_without_a_new_signature

/-! ### `RequestProject/Badges/Anonymity.lean` -/

#print axioms Badges.Anonymity.profile_determines_the_badge
#print axioms Badges.Anonymity.bare_is_fully_anonymous
#print axioms Badges.Anonymity.bare_is_k_anonymous
#print axioms Badges.Anonymity.profile_eq_of_le
#print axioms Badges.Anonymity.profile_le_cohort_subset
#print axioms Badges.Anonymity.anonymity_antitone
#print axioms Badges.Anonymity.one_le_anonymity
#print axioms Badges.Anonymity.kAnonymous_false_of_witness
#print axioms Badges.Anonymity.le_onlySince
#print axioms Badges.Anonymity.le_onlySnapshot
#print axioms Badges.Anonymity.le_onlyRank
#print axioms Badges.Anonymity.le_onlyStanding
#print axioms Badges.Anonymity.identified_by_more
#print axioms Badges.Anonymity.allPolicies_complete
#print axioms Badges.Anonymity.search_is_k_anonymous
#print axioms Badges.Anonymity.search_is_best

/-! ### `RequestProject/Badges/AnonymityFacts.lean` -/

#print axioms Badges.Anonymity.roster_length
#print axioms Badges.Anonymity.rank_identifies_someone
#print axioms Badges.Anonymity.standing_identifies_someone
#print axioms Badges.Anonymity.since_identifies_someone
#print axioms Badges.Anonymity.snapshot_identifies_someone
#print axioms Badges.Anonymity.identifying_fields_break_anonymity
#print axioms Badges.Anonymity.safe_policies_publish_at_most_the_genesis_mark
#print axioms Badges.Anonymity.genesis_only_is_39_anonymous
#print axioms Badges.Anonymity.genesis_only_is_2_anonymous
#print axioms Badges.Anonymity.two_anonymity_costs_everything_but_genesis
#print axioms Badges.Anonymity.search_finds_the_genesis_bit

end Badges.AxiomAudit
