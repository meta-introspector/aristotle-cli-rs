import RequestProject.Solfunmeme.Domain.Ledger

/-!
# The proof catalog of this repository

GENERATED FILE — do not edit.  `python3 scripts/domain_facts.py`
regenerates it and `--check` fails if it has drifted from the corpus.

Every entry is a theorem this repository audits with `#print axioms`.
The status and the validation state are read from the build output of
the audit modules, and the source location from a scan of the Lean
sources, so nothing here is an assertion about the corpus: it is a
reading of it.

* audited theorems: 869
* modules holding them: 86
-/

namespace Solfunmeme.Domain.Data

open Solfunmeme.Domain

/-- One catalog entry.  The arguments are the theorem's full name, its
source file, the line it is declared on, the certificate kind, and the
axioms its proof actually depends on. -/
def entry (name file line cert : String) (axioms : List String)
    (status : ProofStatus) (validation : Validation) : ProofRecord :=
  { id := name
    name := name
    kind := "lean-theorem"
    sourceFile := file
    sourceLocation := "line " ++ line
    inputRefs := [file]
    assumptions := axioms
    procedure := "Lean 4 elaboration and kernel type checking"
    outputRefs := ["claim:" ++ name]
    claimRefs := ["claim:" ++ name]
    status := status
    certificateKind := cert
    certificateLocation := file
    validation := validation
    provenance := { sourceSystem := "lean4-4.28.0", sourceFile := file
                    sourceFormat := "lean" } }

/-- Every audited theorem of the corpus. -/
def catalogProofs : List ProofRecord :=
  [ entry "Badges.Claim.addresses_are_32_byte_keys" "RequestProject/Badges/ClaimFacts.lean" "185" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Badges.Claim.addresses_nodup" "RequestProject/Badges/ClaimFacts.lean" "198" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "Badges.Claim.challengePrefixes_nodup" "RequestProject/Badges/ClaimFacts.lean" "207" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "Badges.Claim.challenge_binds_nonce" "RequestProject/Badges/Claim.lean" "226" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Badges.Claim.challenge_binds_statement" "RequestProject/Badges/Claim.lean" "210" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Badges.Claim.claims_eq_pages" "RequestProject/Badges/ClaimFacts.lean" "78" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "Badges.Claim.dates_agree" "RequestProject/Badges/ClaimFacts.lean" "93" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "Badges.Claim.distinct_pages_distinct_challenges" "RequestProject/Badges/ClaimFacts.lean" "212" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Badges.Claim.genesis_badge_count" "RequestProject/Badges/ClaimFacts.lean" "130" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "Badges.Claim.leader_statement" "RequestProject/Badges/ClaimFacts.lean" "163" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "Badges.Claim.no_replay" "RequestProject/Badges/Claim.lean" "189" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "Badges.Claim.since_backed" "RequestProject/Badges/ClaimFacts.lean" "105" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "Badges.Claim.since_maximal" "RequestProject/Badges/ClaimFacts.lean" "115" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "Badges.Claim.standing_bracket" "RequestProject/Badges/ClaimFacts.lean" "142" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "Badges.Claim.token_tampering_needs_new_signature" "RequestProject/Badges/Claim.lean" "288" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Badges.Claim.unlock_eq_some_iff" "RequestProject/Badges/Claim.lean" "129" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "Badges.Claim.unlock_output_is_page_statement" "RequestProject/Badges/Claim.lean" "155" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "Badges.Claim.unlock_requires_key" "RequestProject/Badges/Claim.lean" "176" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "Badges.Claim.verifyToken_mintToken" "RequestProject/Badges/Claim.lean" "261" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Badges.Claim.verifyToken_requires_key" "RequestProject/Badges/Claim.lean" "304" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "Badges.Snapshot.fourth_tokenDays_lower" "RequestProject/Badges/SnapshotFacts.lean" "126" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "Badges.Snapshot.genesis_count" "RequestProject/Badges/SnapshotFacts.lean" "91" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "Badges.Snapshot.genesis_fewer_than_credentials" "RequestProject/Badges/SnapshotFacts.lean" "94" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "Badges.Snapshot.genesis_fewer_than_seats" "RequestProject/Badges/SnapshotFacts.lean" "98" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "Badges.Snapshot.leader_dominates" "RequestProject/Badges/SnapshotFacts.lean" "152" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "Badges.Snapshot.leader_tokenDays" "RequestProject/Badges/SnapshotFacts.lean" "147" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "Badges.Snapshot.senate_churn" "RequestProject/Badges/SnapshotFacts.lean" "102" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "Badges.Snapshot.senate_recorded" "RequestProject/Badges/SnapshotFacts.lean" "67" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "Badges.Snapshot.snapshot_count" "RequestProject/Badges/SnapshotFacts.lean" "63" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "Badges.Snapshot.third_tokenDays_upper" "RequestProject/Badges/SnapshotFacts.lean" "121" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "Badges.Snapshot.times_increasing" "RequestProject/Badges/SnapshotFacts.lean" "72" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "Badges.Snapshot.tokenDays_reorders_senate" "RequestProject/Badges/SnapshotFacts.lean" "132" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Badges.Snapshot.window_days" "RequestProject/Badges/SnapshotFacts.lean" "77" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "Badges.accrue_eq_tokenDays" "RequestProject/Badges/TokenDays.lean" "199" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "Badges.accrue_le_tokenDays" "RequestProject/Badges/TokenDays.lean" "184" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Badges.all_badges_short" "RequestProject/Badges/Badge.lean" "133" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "Badges.badge_shortfall" "RequestProject/Badges/Badge.lean" "138" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "Badges.chad_badge" "RequestProject/Badges/Badge.lean" "115" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "Badges.chad_interest" "RequestProject/Badges/TokenDays.lean" "141" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Badges.chad_tokenDays" "RequestProject/Badges/TokenDays.lean" "135" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "Badges.cumulative_sizes_not_fibonacci" "RequestProject/Badges/Tiers.lean" "143" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "Badges.daily_rate_compounds_above_44_percent" "RequestProject/Badges/TokenDays.lean" "225" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Badges.dip_wipes_history" "RequestProject/Badges/TokenDays.lean" "214" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "Badges.genesis_tokenDays_lower_bound" "RequestProject/Badges/Badge.lean" "99" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Badges.mint_address_irrelevant" "RequestProject/Badges/Badge.lean" "63" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "Badges.mint_hides_rank_within_tier" "RequestProject/Badges/Badge.lean" "75" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "Badges.mint_reveals_constant_balance" "RequestProject/Badges/Badge.lean" "86" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "Badges.no_voice_beyond_1600" "RequestProject/Badges/Tiers.lean" "74" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Badges.operational_bypasses_senate" "RequestProject/Badges/Tiers.lean" "241" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "Badges.phi_progression_from_100" "RequestProject/Badges/Tiers.lean" "188" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Badges.rep_vendor_ratio_off_from_phi" "RequestProject/Badges/Tiers.lean" "179" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Badges.representative_seat_count" "RequestProject/Badges/Tiers.lean" "110" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Badges.senate_alone_cannot_enact" "RequestProject/Badges/Tiers.lean" "232" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Badges.senate_badges_short" "RequestProject/Badges/Badge.lean" "129" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "Badges.senate_rep_ratio_off_from_phi_cubed" "RequestProject/Badges/Tiers.lean" "170" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Badges.senate_seat_count" "RequestProject/Badges/Tiers.lean" "93" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Badges.senate_veto_redundant_for_major" "RequestProject/Badges/Tiers.lean" "248" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Badges.simple_understates_compound" "RequestProject/Badges/TokenDays.lean" "236" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Badges.supply_more_than_doubles_in_two_years" "RequestProject/Badges/TokenDays.lean" "246" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Badges.tier_exhaustive" "RequestProject/Badges/Tiers.lean" "68" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "Badges.tier_ratios_differ" "RequestProject/Badges/Tiers.lean" "146" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Badges.tier_sizes_not_fibonacci" "RequestProject/Badges/Tiers.lean" "139" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "Badges.time_beats_size" "RequestProject/Badges/TokenDays.lean" "146" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "Badges.tokenDays_append" "RequestProject/Badges/TokenDays.lean" "81" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "Badges.tokenDays_eq_sum_balanceOn" "RequestProject/Badges/TokenDays.lean" "62" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Badges.tokenDays_lt_append" "RequestProject/Badges/TokenDays.lean" "93" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Badges.tokenDays_mono_balance" "RequestProject/Badges/TokenDays.lean" "101" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Badges.uniform_interest_rank_invariant" "RequestProject/Badges/TokenDays.lean" "266" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Badges.uniform_interest_share_invariant" "RequestProject/Badges/TokenDays.lean" "259" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Badges.vendor_seat_count" "RequestProject/Badges/Tiers.lean" "129" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Federal.Roll.bill_must_be_tabled" "RequestProject/Federal/Roll.lean" "220" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Federal.Roll.chamberTally_cast" "RequestProject/Federal/Roll.lean" "251" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Federal.Roll.passage_needs_quorum_of_ballots" "RequestProject/Federal/Roll.lean" "268" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Federal.Roll.passage_needs_quorum_of_senators" "RequestProject/Federal/Roll.lean" "276" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Federal.Roll.rollCall_authentic" "RequestProject/Federal/Roll.lean" "184" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Federal.Roll.rollCall_first_vote_wins" "RequestProject/Federal/Roll.lean" "211" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "Federal.Roll.rollCall_le_seats" "RequestProject/Federal/Roll.lean" "231" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Federal.Roll.rollCall_nodup" "RequestProject/Federal/Roll.lean" "205" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Federal.Roll.rollCall_senator" "RequestProject/Federal/Roll.lean" "197" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Federal.Union.congress_can_legislate" "RequestProject/Federal/Facts.lean" "188" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Federal.Union.every_state_has_two_senators" "RequestProject/Federal/Facts.lean" "99" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "Federal.Union.house_apportionment" "RequestProject/Federal/Facts.lean" "125" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "Federal.Union.house_total" "RequestProject/Federal/Facts.lean" "134" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "Federal.Union.house_total_general" "RequestProject/Federal/Facts.lean" "136" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Federal.Union.no_state_can_carry_the_senate" "RequestProject/Federal/Facts.lean" "197" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Federal.Union.no_state_has_a_house_majority" "RequestProject/Federal/Facts.lean" "143" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "Federal.Union.no_state_has_a_senate_majority" "RequestProject/Federal/Facts.lean" "147" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "Federal.Union.raw_apportionment_agrees" "RequestProject/Federal/Supply.lean" "51" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "Federal.Union.rounding_loses_less_than_a_token_per_senator" "RequestProject/Federal/Supply.lean" "55" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "Federal.Union.seated_length" "RequestProject/Federal/Facts.lean" "102" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "Federal.Union.seated_nodup" "RequestProject/Federal/Facts.lean" "105" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "Federal.Union.seated_subset_roster" "RequestProject/Federal/Facts.lean" "109" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "Federal.Union.senate_apportionment" "RequestProject/Federal/Facts.lean" "114" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "Federal.Union.senate_passage_needs_fourteen_senators" "RequestProject/Federal/Facts.lean" "215" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Federal.Union.senate_passage_needs_fourteen_signatures" "RequestProject/Federal/Facts.lean" "206" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Federal.Union.senate_roll_le_26" "RequestProject/Federal/Facts.lean" "226" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Federal.Union.smallest_state_overrepresented_in_the_senate" "RequestProject/Federal/Facts.lean" "160" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Federal.Union.state_names_nodup" "RequestProject/Federal/Facts.lean" "76" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "Federal.Union.states_length" "RequestProject/Federal/Facts.lean" "74" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "Federal.Union.states_partition_the_roster" "RequestProject/Federal/Facts.lean" "80" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "Federal.Union.total_stake" "RequestProject/Federal/Facts.lean" "86" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "Federal.Union.union_holds_more_than_half_the_supply" "RequestProject/Federal/Supply.lean" "64" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "Federal.Union.union_raw_stake" "RequestProject/Federal/Supply.lean" "47" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "Federal.Union.union_share_bounds" "RequestProject/Federal/Supply.lean" "71" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Federal.Union.union_within_supply" "RequestProject/Federal/Supply.lean" "68" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "Federal.apportion_total" "RequestProject/Federal/Apportion.lean" "291" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Federal.baseTotal_le" "RequestProject/Federal/Apportion.lean" "254" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Federal.contested_passage_needs_majority_of_seats" "RequestProject/Federal/Congress.lean" "231" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Federal.enacted_iff" "RequestProject/Federal/Congress.lean" "132" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "Federal.enacted_needs_both_chambers" "RequestProject/Federal/Congress.lean" "154" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "Federal.enactment_attainable" "RequestProject/Federal/Congress.lean" "200" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Federal.extras_le" "RequestProject/Federal/Apportion.lean" "275" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Federal.house_bloc_bounded" "RequestProject/Federal/Congress.lean" "270" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Federal.one_division_cannot_carry_the_senate" "RequestProject/Federal/Congress.lean" "242" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Federal.one_division_cannot_enact" "RequestProject/Federal/Congress.lean" "255" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Federal.overridden_iff" "RequestProject/Federal/Congress.lean" "143" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Federal.overridden_needs_supermajority" "RequestProject/Federal/Congress.lean" "160" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Federal.override_attainable" "RequestProject/Federal/Congress.lean" "205" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Federal.quorum_attainable" "RequestProject/Federal/Congress.lean" "184" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Federal.seats_ge_lower_quota" "RequestProject/Federal/Apportion.lean" "307" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Federal.seats_le_upper_quota" "RequestProject/Federal/Apportion.lean" "319" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Federal.senateSeats_total" "RequestProject/Federal/Apportion.lean" "66" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Federal.senate_equal" "RequestProject/Federal/Apportion.lean" "61" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Federal.small_division_overrepresented" "RequestProject/Federal/Apportion.lean" "337" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Federal.supermajority_implies_passage" "RequestProject/Federal/Congress.lean" "214" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Federal.veto_sustained_of_not_super" "RequestProject/Federal/Congress.lean" "166" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "Ledger.PopulationFacts.busy_bad" "RequestProject/Ledger/PopulationFacts.lean" "218" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "Ledger.PopulationFacts.busy_good_is_6VzidcFh" "RequestProject/Ledger/PopulationFacts.lean" "224" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "Ledger.PopulationFacts.no_good_heavy" "RequestProject/Ledger/PopulationFacts.lean" "228" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "Ledger.PopulationFacts.population_agrees_with_sample" "RequestProject/Ledger/PopulationFacts.lean" "41" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Ledger.PopulationFacts.population_bad" "RequestProject/Ledger/PopulationFacts.lean" "178" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "Ledger.PopulationFacts.population_good" "RequestProject/Ledger/PopulationFacts.lean" "176" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "Ledger.PopulationFacts.population_size" "RequestProject/Ledger/PopulationFacts.lean" "30" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "Ledger.PopulationFacts.summaryOf_w_J3Z1AfTD" "RequestProject/Ledger/PopulationFacts.lean" "59" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "Ledger.PopulationFacts.txs_of_bad" "RequestProject/Ledger/PopulationFacts.lean" "190" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "Ledger.SampleFacts.sample_burnt" "RequestProject/Ledger/SampleFacts.lean" "79" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "Ledger.SampleFacts.sample_failed" "RequestProject/Ledger/SampleFacts.lean" "36" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "Ledger.SampleFacts.sample_failuresAreInert" "RequestProject/Ledger/SampleFacts.lean" "102" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "Ledger.SampleFacts.sample_fees" "RequestProject/Ledger/SampleFacts.lean" "74" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "Ledger.SampleFacts.sample_live" "RequestProject/Ledger/SampleFacts.lean" "52" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "Ledger.SampleFacts.sample_size" "RequestProject/Ledger/SampleFacts.lean" "31" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "Ledger.SampleFacts.sample_slippage" "RequestProject/Ledger/SampleFacts.lean" "41" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "Ledger.SampleFacts.sample_verdict" "RequestProject/Ledger/SampleFacts.lean" "120" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Ledger.SampleFacts.sample_wf_sound" "RequestProject/Ledger/SampleFacts.lean" "95" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "Ledger.Verdicts.coSlots_wDLp2YLYc_wHCb7hLss" "RequestProject/Ledger/Verdicts.lean" "728" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "Ledger.Verdicts.coSlots_wJ3Z1AfTD_w686oaTQa" "RequestProject/Ledger/Verdicts.lean" "738" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "Ledger.Verdicts.fleet_fees_wEN4kMnNm" "RequestProject/Ledger/Verdicts.lean" "702" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "Ledger.Verdicts.no_exotic_fee_wJ3Z1AfTD" "RequestProject/Ledger/Verdicts.lean" "714" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "Ledger.Verdicts.w_21nALQTX_verdict" "RequestProject/Ledger/Verdicts.lean" "662" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "Ledger.Verdicts.w_27XHsdyK_verdict" "RequestProject/Ledger/Verdicts.lean" "342" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "Ledger.Verdicts.w_4AnrXS8H_verdict" "RequestProject/Ledger/Verdicts.lean" "110" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "Ledger.Verdicts.w_5ssQGkUG_verdict" "RequestProject/Ledger/Verdicts.lean" "373" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "Ledger.Verdicts.w_686oaTQa_verdict" "RequestProject/Ledger/Verdicts.lean" "283" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "Ledger.Verdicts.w_6DAHh1hH_verdict" "RequestProject/Ledger/Verdicts.lean" "555" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "Ledger.Verdicts.w_6VzidcFh_theory_sound" "RequestProject/Ledger/Verdicts.lean" "318" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "Ledger.Verdicts.w_6VzidcFh_verdict" "RequestProject/Ledger/Verdicts.lean" "313" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "Ledger.Verdicts.w_7QeRHULB_verdict" "RequestProject/Ledger/Verdicts.lean" "80" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "Ledger.Verdicts.w_7dGrdJRY_verdict" "RequestProject/Ledger/Verdicts.lean" "194" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "Ledger.Verdicts.w_9XvBYSKe_verdict" "RequestProject/Ledger/Verdicts.lean" "139" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "Ledger.Verdicts.w_C9YvTztk_verdict" "RequestProject/Ledger/Verdicts.lean" "166" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "Ledger.Verdicts.w_CMbBM2BW_verdict" "RequestProject/Ledger/Verdicts.lean" "610" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "Ledger.Verdicts.w_DLp2YLYc_verdict" "RequestProject/Ledger/Verdicts.lean" "464" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "Ledger.Verdicts.w_EN4kMnNm_verdict" "RequestProject/Ledger/Verdicts.lean" "254" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "Ledger.Verdicts.w_F4oEKU8a_verdict" "RequestProject/Ledger/Verdicts.lean" "403" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "Ledger.Verdicts.w_FTotzvz1_verdict" "RequestProject/Ledger/Verdicts.lean" "524" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "Ledger.Verdicts.w_FwqxwTYu_verdict" "RequestProject/Ledger/Verdicts.lean" "636" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "Ledger.Verdicts.w_G1uSQxpf_verdict" "RequestProject/Ledger/Verdicts.lean" "434" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "Ledger.Verdicts.w_HCb7hLss_verdict" "RequestProject/Ledger/Verdicts.lean" "494" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "Ledger.Verdicts.w_HxkTYMtx_theory_sound" "RequestProject/Ledger/Verdicts.lean" "232" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "Ledger.Verdicts.w_HxkTYMtx_verdict" "RequestProject/Ledger/Verdicts.lean" "227" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "Ledger.Verdicts.w_J3Z1AfTD_theory_discriminates_7QeRHULB" "RequestProject/Ledger/Verdicts.lean" "58" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "Ledger.Verdicts.w_J3Z1AfTD_theory_sound" "RequestProject/Ledger/Verdicts.lean" "56" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "Ledger.Verdicts.w_J3Z1AfTD_verdict" "RequestProject/Ledger/Verdicts.lean" "51" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "Ledger.Verdicts.w_x3pJA2jG_verdict" "RequestProject/Ledger/Verdicts.lean" "583" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "Ledger.burnt_le_fees" "RequestProject/Ledger/Behaviour.lean" "207" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Ledger.corroborated_of_sound" "RequestProject/Ledger/Behaviour.lean" "476" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Ledger.countVerdict_total" "RequestProject/Ledger/Behaviour.lean" "569" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Ledger.nExits_le_nSells" "RequestProject/Ledger/Behaviour.lean" "209" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Ledger.nMoves_eq" "RequestProject/Ledger/Behaviour.lean" "208" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Ledger.nOk_add_nFail" "RequestProject/Ledger/Behaviour.lean" "203" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Ledger.ne_of_discriminates" "RequestProject/Ledger/Behaviour.lean" "484" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "Ledger.verdictS_summaryOf" "RequestProject/Ledger/Behaviour.lean" "561" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Ledger.verdict_bad_iff" "RequestProject/Ledger/Behaviour.lean" "421" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "Ledger.verdict_bad_of_inert" "RequestProject/Ledger/Behaviour.lean" "441" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Ledger.verdict_bad_of_neverSettles" "RequestProject/Ledger/Behaviour.lean" "432" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Ledger.verdict_good_iff" "RequestProject/Ledger/Behaviour.lean" "402" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Meme.Commit.chain_injective" "RequestProject/Meme/Proofs/Commit.lean" "39" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Meme.Engine.Claim.verified_blocks_pos" "RequestProject/Meme/Proofs/Engine.lean" "221" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Meme.Engine.Claim.verified_memes_le" "RequestProject/Meme/Proofs/Engine.lean" "236" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Meme.Engine.Claim.verified_mint_backed" "RequestProject/Meme/Proofs/Engine.lean" "229" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Meme.Engine.Claim.verify_iff" "RequestProject/Meme/Proofs/Engine.lean" "213" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "Meme.Engine.blocks_pos" "RequestProject/Meme/Proofs/Engine.lean" "99" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Meme.Engine.code_injective" "RequestProject/Meme/Proofs/Engine.lean" "41" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Meme.Engine.ledger_run" "RequestProject/Meme/Proofs/Engine.lean" "148" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Meme.Engine.memes_le_length" "RequestProject/Meme/Proofs/Engine.lean" "162" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Meme.Engine.mint_backed" "RequestProject/Meme/Proofs/Engine.lean" "154" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Meme.Engine.parts_backed" "RequestProject/Meme/Proofs/Engine.lean" "158" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Meme.Engine.run_append" "RequestProject/Meme/Proofs/Engine.lean" "34" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Meme.Engine.run_commit" "RequestProject/Meme/Proofs/Commit.lean" "70" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "Meme.Engine.segment_compose" "RequestProject/Meme/Proofs/Commit.lean" "85" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Meme.Engine.segment_verify_iff" "RequestProject/Meme/Proofs/Commit.lean" "94" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Meme.Engine.segment_verify_run" "RequestProject/Meme/Proofs/Commit.lean" "80" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Meme.Engine.stake_strict_mono" "RequestProject/Meme/Proofs/Engine.lean" "205" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "Meme.Engine.stake_ticks" "RequestProject/Meme/Proofs/Engine.lean" "183" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "Meme.Engine.tape_binding" "RequestProject/Meme/Proofs/Commit.lean" "100" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Meme.Engine.unlocked_mono" "RequestProject/Meme/Proofs/Engine.lean" "116" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Meme.Share.decodeShare_encodeShare" "RequestProject/Meme/Proofs/Share.lean" "69" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Meme.Share.encodeShare_injective" "RequestProject/Meme/Proofs/Share.lean" "74" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Meme.Stake.payout_add_days" "RequestProject/Meme/Proofs/Stake.lean" "34" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "Meme.Stake.payout_mono_memes" "RequestProject/Meme/Proofs/Stake.lean" "39" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Meme.Stake.payout_strict_mono_days" "RequestProject/Meme/Proofs/Stake.lean" "28" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Meme.Stake.payout_ticks" "RequestProject/Meme/Proofs/Stake.lean" "53" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Meme.Stego.embedBits_preserves_upper" "RequestProject/Meme/Proofs/Stego.lean" "49" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Meme.Stego.extractBits_embedBits" "RequestProject/Meme/Proofs/Stego.lean" "67" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Meme.Stego.extractBytes_embedBytes" "RequestProject/Meme/Proofs/Stego.lean" "106" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Meme.Svg.chunk_mem_of_mem_chunks" "RequestProject/Meme/Proofs/Svg.lean" "25" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Meme.Svg.render_eq" "RequestProject/Meme/Proofs/Svg.lean" "22" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Meme.Tape.decodeTape_encodeTape" "RequestProject/Meme/Proofs/Tape.lean" "73" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Meme.Tape.encodeTape_injective" "RequestProject/Meme/Proofs/Tape.lean" "78" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Mesh.Chart.render_of_message_eq" "RequestProject/Mesh/Chart.lean" "133" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Mesh.Chart.x_le_width" "RequestProject/Mesh/Chart.lean" "73" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "Mesh.Chart.y_le_height" "RequestProject/Mesh/Chart.lean" "79" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "Mesh.Codec.assemble_eq_none_of_missing" "RequestProject/Mesh/Codec.lean" "494" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Mesh.Codec.assemble_fragments" "RequestProject/Mesh/Codec.lean" "480" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Mesh.Codec.decodeCard_encodeCard" "RequestProject/Mesh/Codec.lean" "302" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Mesh.Codec.ofCode_toCode" "RequestProject/Mesh/Codec.lean" "335" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Mesh.Codec.ofUrl_toUrl" "RequestProject/Mesh/Codec.lean" "384" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Mesh.Examples.page_wf" "RequestProject/Mesh/Examples.lean" "162" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Mesh.Examples.signed2_cardWf" "RequestProject/Mesh/Examples.lean" "118" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Mesh.Quote.score_inj" "RequestProject/Mesh/Quote.lean" "148" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Mesh.Runtime.rehost_rejected" "RequestProject/Mesh/Bundle.lean" "196" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Mesh.Runtime.run_sound" "RequestProject/Mesh/Bundle.lean" "146" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Mesh.Runtime.runtime_swap_detected" "RequestProject/Mesh/Bundle.lean" "168" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Mesh.Runtime.strip_detected" "RequestProject/Mesh/Bundle.lean" "159" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Mesh.Runtime.tamper_changes_digest" "RequestProject/Mesh/Bundle.lean" "154" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Mesh.Runtime.unweave_weave" "RequestProject/Mesh/Bundle.lean" "87" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Mesh.Runtime.weave_injective" "RequestProject/Mesh/Bundle.lean" "97" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Mesh.Skin.reveal_hide" "RequestProject/Mesh/Skin.lean" "40" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Mesh.cited_data_cannot_be_swapped" "RequestProject/Mesh/Post.lean" "307" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Mesh.cosign_preserves_view" "RequestProject/Mesh/Post.lean" "256" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "Mesh.cosign_verify" "RequestProject/Mesh/Post.lean" "263" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Mesh.deliver_mono" "RequestProject/Mesh/Net.lean" "135" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Mesh.deliver_routed" "RequestProject/Mesh/Net.lean" "166" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Mesh.deliver_sound" "RequestProject/Mesh/Net.lean" "144" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Mesh.exchange_sound" "RequestProject/Mesh/Net.lean" "114" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Mesh.import_binds_source" "RequestProject/Mesh/Post.lean" "297" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Mesh.ingest_toFinset" "RequestProject/Mesh/Quote.lean" "103" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Mesh.latest_max" "RequestProject/Mesh/Quote.lean" "179" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Mesh.latest_mem" "RequestProject/Mesh/Quote.lean" "173" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Mesh.mem_merge" "RequestProject/Mesh/Quote.lean" "56" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Mesh.merge_assoc_toFinset" "RequestProject/Mesh/Quote.lean" "77" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Mesh.merge_comm_toFinset" "RequestProject/Mesh/Quote.lean" "74" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Mesh.merge_idem_toFinset" "RequestProject/Mesh/Quote.lean" "81" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Mesh.message_injective" "RequestProject/Mesh/Post.lean" "147" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Mesh.sync_all_eq" "RequestProject/Mesh/Net.lean" "218" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "Mesh.sync_idem_toFinset" "RequestProject/Mesh/Net.lean" "225" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Mesh.tamper_needs_new_signature" "RequestProject/Mesh/Post.lean" "237" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Mesh.valid_cosigners_signed_view" "RequestProject/Mesh/Post.lean" "220" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Mesh.valid_signers_hold_keys" "RequestProject/Mesh/Post.lean" "228" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Mesh.verified_signers_nodup" "RequestProject/Mesh/Post.lean" "284" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Mesh.verifyPost_iff" "RequestProject/Mesh/Post.lean" "203" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Mesh.vwap_mem_range" "RequestProject/Mesh/Quote.lean" "228" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Market.Assembly.closed_substitute" "RequestProject/Market/Twin.lean" "161" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Market.Assembly.closed_substitute_list" "RequestProject/Market/Twin.lean" "172" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Market.Assembly.guarantee_preserved" "RequestProject/Market/Twin.lean" "167" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Market.Assembly.guaranteed_subset_substitute" "RequestProject/Market/Twin.lean" "155" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Market.Assembly.provided_subset_substitute" "RequestProject/Market/Twin.lean" "145" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Market.Assembly.required_substitute_subset" "RequestProject/Market/Twin.lean" "150" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Market.Assembly.unions_mono" "RequestProject/Market/Twin.lean" "59" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Market.Blindable.recover" "RequestProject/Market/Private.lean" "87" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Market.FitMachine.closed_of_fitClosed" "RequestProject/Market/Fit.lean" "234" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Market.FitMachine.fitClosed_substitute" "RequestProject/Market/Fit.lean" "289" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Market.Refines.refl" "RequestProject/Market/Twin.lean" "103" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Market.Refines.trans" "RequestProject/Market/Twin.lean" "107" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Market.all_samples_card" "RequestProject/Market/Challenge.lean" "301" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Market.artifact_of_digest" "RequestProject/Market/Supply.lean" "146" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Market.bond_forfeited_iff" "RequestProject/Market/Compute.lean" "125" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Market.card_mask_fiber" "RequestProject/Market/Private.lean" "62" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Market.challenge_agrees_with_proof_market" "RequestProject/Market/Challenge.lean" "239" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Market.challenged_of_not_spec" "RequestProject/Market/Challenge.lean" "194" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Market.clearance_bounds" "RequestProject/Market/Fit.lean" "107" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Market.deadline_met_iff" "RequestProject/Market/Fit.lean" "167" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Market.deployed_eq_rebuild" "RequestProject/Market/Supply.lean" "68" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Market.deployed_of_identity_tools" "RequestProject/Market/Supply.lean" "108" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Market.deployed_of_matching_digest" "RequestProject/Market/Supply.lean" "153" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Market.deployed_satisfies" "RequestProject/Market/Supply.lean" "119" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Market.deployed_satisfies_all" "RequestProject/Market/Supply.lean" "135" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Market.deployed_unique" "RequestProject/Market/Supply.lean" "81" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Market.diligent_court_pays_iff_spec" "RequestProject/Market/Challenge.lean" "226" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Market.diligent_paid_implies_spec" "RequestProject/Market/Challenge.lean" "208" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Market.escape_geometric_bound" "RequestProject/Market/Challenge.lean" "375" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Market.escape_ratio_le" "RequestProject/Market/Challenge.lean" "398" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Market.escape_step" "RequestProject/Market/Challenge.lean" "355" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Market.escaping_lt_all" "RequestProject/Market/Challenge.lean" "309" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Market.escaping_samples" "RequestProject/Market/Challenge.lean" "284" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Market.escaping_samples_card" "RequestProject/Market/Challenge.lean" "294" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Market.escaping_samples_geometric" "RequestProject/Market/Challenge.lean" "415" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Market.failure_count_le_stake_div_bond" "RequestProject/Market/Stake.lean" "131" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Market.failures_bounded" "RequestProject/Market/Stake.lean" "122" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Market.fits_iff_worst_case" "RequestProject/Market/Fit.lean" "97" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Market.fits_of_tighter_shaft" "RequestProject/Market/Fit.lean" "114" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Market.fits_of_wider_hole" "RequestProject/Market/Fit.lean" "118" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Market.full_audit_detects" "RequestProject/Market/Challenge.lean" "277" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Market.honest_claim_paid" "RequestProject/Market/Challenge.lean" "187" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Market.honest_operator_paid" "RequestProject/Market/Compute.lean" "114" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Market.liar_earns_nothing" "RequestProject/Market/Stake.lean" "142" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Market.mask_bijective" "RequestProject/Market/Private.lean" "56" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Market.mask_blindEquiv" "RequestProject/Market/Private.lean" "51" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Market.mul_choose_pred" "RequestProject/Market/Challenge.lean" "333" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Market.optimistic_payout_conserves" "RequestProject/Market/Challenge.lean" "109" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Market.optimistic_pays_for_wrong_result" "RequestProject/Market/Challenge.lean" "143" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Market.paid_implies_spec" "RequestProject/Market/Compute.lean" "91" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Market.payout_conserves" "RequestProject/Market/Compute.lean" "83" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Market.payout_of_no_submission" "RequestProject/Market/Compute.lean" "107" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Market.private_verified_result" "RequestProject/Market/Private.lean" "95" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Market.proof_market_immune_to_collusion" "RequestProject/Market/Compute.lean" "195" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Market.rebuild_of_identity_tools" "RequestProject/Market/Supply.lean" "95" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Market.revenue_mono" "RequestProject/Market/Compute.lean" "162" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Market.revenue_only_from_verified" "RequestProject/Market/Compute.lean" "141" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Market.revenue_zero_of_none_accepted" "RequestProject/Market/Compute.lean" "149" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Market.run_of_all_accepted" "RequestProject/Market/Stake.lean" "68" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Market.silent_watch_always_pays" "RequestProject/Market/Challenge.lean" "153" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Market.slashed_iff_challenged" "RequestProject/Market/Challenge.lean" "127" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Market.stake_plus_forfeits" "RequestProject/Market/Stake.lean" "89" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Market.sum_mem" "RequestProject/Market/Fit.lean" "140" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Market.tampering_invalidates_chain" "RequestProject/Market/Supply.lean" "89" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Market.unchallenged_of_spec" "RequestProject/Market/Challenge.lean" "170" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Market.undetected_iff_disjoint" "RequestProject/Market/Challenge.lean" "272" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Market.unmask_mask" "RequestProject/Market/Private.lean" "42" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Market.vaicuPlan_correct" "RequestProject/Market/Roadmap.lean" "145" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Market.vaicu_blocked" "RequestProject/Market/Roadmap.lean" "218" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Market.vaicu_done_before_open" "RequestProject/Market/Roadmap.lean" "193" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Market.vaicu_done_is_downward_closed" "RequestProject/Market/Roadmap.lean" "182" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Market.vaicu_every_done_has_evidence" "RequestProject/Market/Roadmap.lean" "243" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Market.vaicu_no_cycle" "RequestProject/Market/Roadmap.lean" "151" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Market.vaicu_progress" "RequestProject/Market/Roadmap.lean" "239" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Market.vaicu_ready" "RequestProject/Market/Roadmap.lean" "211" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Market.vaicu_ready_nonempty" "RequestProject/Market/Roadmap.lean" "215" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Market.vaicu_wishes_are_new" "RequestProject/Market/Roadmap.lean" "301" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Market.vote_market_pays_for_wrong_result" "RequestProject/Market/Compute.lean" "184" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Market.watchdog_diligent" "RequestProject/Market/Examples.lean" "83" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Market.width_sum" "RequestProject/Market/Fit.lean" "149" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Pricing.Effort.quote_linear" "RequestProject/Pricing/Model.lean" "523" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Pricing.Effort.quote_mono" "RequestProject/Pricing/Model.lean" "538" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Pricing.Effort.quote_scale_draftMultiplier" "RequestProject/Pricing/Model.lean" "531" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Pricing.Effort.split_add" "RequestProject/Pricing/Model.lean" "518" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Pricing.Gateway.charge_eq_add_fee" "RequestProject/Pricing/Model.lean" "296" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Pricing.Gateway.charge_routeCost_le" "RequestProject/Pricing/Model.lean" "313" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Pricing.MakeOrBuy.buying_always_wins" "RequestProject/Pricing/Model.lean" "356" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Pricing.MakeOrBuy.makeCost_le_buyCost_iff" "RequestProject/Pricing/Model.lean" "348" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Pricing.Offer.blended_eq" "RequestProject/Pricing/Model.lean" "151" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Pricing.Offer.blended_mem_Icc" "RequestProject/Pricing/Model.lean" "164" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Pricing.Offer.quote_add" "RequestProject/Pricing/Model.lean" "143" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Pricing.Offer.quote_mono_outputTokens" "RequestProject/Pricing/Model.lean" "180" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Pricing.RateCard.bill_add" "RequestProject/Pricing/Model.lean" "438" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Pricing.RateCard.bill_mono" "RequestProject/Pricing/Model.lean" "464" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Pricing.RateCard.bill_nonneg" "RequestProject/Pricing/Model.lean" "455" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Pricing.RateCard.bill_sum" "RequestProject/Pricing/Model.lean" "449" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Pricing.annualGeneratedTokens_value" "RequestProject/Pricing/Infra.lean" "245" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Pricing.annual_bill_commodity" "RequestProject/Pricing/Infra.lean" "153" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Pricing.annual_bill_frontier" "RequestProject/Pricing/Infra.lean" "157" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Pricing.attribution_exhausts_the_corpus" "RequestProject/Pricing/Wishes.lean" "163" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Pricing.bill_is_additive" "RequestProject/Pricing/Wishes.lean" "174" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Pricing.bill_linear_in_nodes" "RequestProject/Pricing/Infra.lean" "166" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Pricing.buying_wins_at_our_volume" "RequestProject/Pricing/Infra.lean" "253" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Pricing.checking_exceeds_maintenance" "RequestProject/Pricing/Infra.lean" "209" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Pricing.checking_monthly" "RequestProject/Pricing/Infra.lean" "135" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Pricing.commodity_bill_le_frontier" "RequestProject/Pricing/Prices.lean" "228" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Pricing.dearest_open_wish" "RequestProject/Pricing/Wishes.lean" "229" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Pricing.doubling_waste_doubles_tokens" "RequestProject/Pricing/Wishes.lean" "276" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Pricing.effortOf_add" "RequestProject/Pricing/Prices.lean" "189" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Pricing.effortOf_one" "RequestProject/Pricing/Prices.lean" "186" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Pricing.every_wish_costs_something" "RequestProject/Pricing/Wishes.lean" "147" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Pricing.extremes_listed" "RequestProject/Pricing/Prices.lean" "131" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Pricing.frontier_over_commodity" "RequestProject/Pricing/Wishes.lean" "242" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Pricing.granted_bill_commodity" "RequestProject/Pricing/Wishes.lean" "179" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Pricing.granted_bill_frontier" "RequestProject/Pricing/Wishes.lean" "183" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Pricing.granted_lines" "RequestProject/Pricing/Wishes.lean" "152" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Pricing.h100Year_value" "RequestProject/Pricing/Infra.lean" "220" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Pricing.hosting_dominates" "RequestProject/Pricing/Infra.lean" "203" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Pricing.hosting_one_node" "RequestProject/Pricing/Infra.lean" "129" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Pricing.infra_year_under_one_h100_year" "RequestProject/Pricing/Infra.lean" "273" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Pricing.links_exceed_nodes" "RequestProject/Pricing/Infra.lean" "176" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Pricing.maintenance_range" "RequestProject/Pricing/Infra.lean" "139" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Pricing.measured_iff_granted" "RequestProject/Pricing/Wishes.lean" "140" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Pricing.month_in_h200_hours" "RequestProject/Pricing/Infra.lean" "267" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Pricing.monthly_bill_commodity" "RequestProject/Pricing/Infra.lean" "145" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Pricing.monthly_bill_frontier" "RequestProject/Pricing/Infra.lean" "149" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Pricing.open_bill_commodity" "RequestProject/Pricing/Wishes.lean" "187" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Pricing.open_bill_frontier" "RequestProject/Pricing/Wishes.lean" "191" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Pricing.open_dearer_than_granted" "RequestProject/Pricing/Wishes.lean" "212" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Pricing.open_lines" "RequestProject/Pricing/Wishes.lean" "155" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Pricing.open_lines_exceed_granted" "RequestProject/Pricing/Wishes.lean" "168" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Pricing.open_programme_in_h200_hours" "RequestProject/Pricing/Wishes.lean" "249" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Pricing.own_serving_breakeven" "RequestProject/Pricing/Infra.lean" "234" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Pricing.priceList_length" "RequestProject/Pricing/Prices.lean" "108" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Pricing.priceList_wellFormed" "RequestProject/Pricing/Prices.lean" "111" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Pricing.pricing_covers_the_roadmap" "RequestProject/Pricing/Wishes.lean" "135" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Pricing.programme_bill_commodity" "RequestProject/Pricing/Wishes.lean" "199" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Pricing.programme_bill_frontier" "RequestProject/Pricing/Wishes.lean" "195" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Pricing.programme_share_of_marketplace" "RequestProject/Pricing/Wishes.lean" "255" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Pricing.programme_splits" "RequestProject/Pricing/Wishes.lean" "204" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Pricing.programme_under_three_h100_hours" "RequestProject/Pricing/Wishes.lean" "261" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Pricing.rates_wellFormed" "RequestProject/Pricing/Prices.lean" "207" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Pricing.ready_bill_commodity" "RequestProject/Pricing/Wishes.lean" "224" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Pricing.ready_bill_frontier" "RequestProject/Pricing/Wishes.lean" "220" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Pricing.ready_lines" "RequestProject/Pricing/Wishes.lean" "158" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Pricing.routeCost_cons_le" "RequestProject/Pricing/Model.lean" "233" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Pricing.routeCost_le_blend" "RequestProject/Pricing/Model.lean" "268" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Pricing.routeCost_le_of_mem" "RequestProject/Pricing/Model.lean" "203" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Pricing.routeCost_mem" "RequestProject/Pricing/Model.lean" "218" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Pricing.routeCost_nonneg" "RequestProject/Pricing/Model.lean" "238" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Pricing.sized_counts" "RequestProject/Pricing/Wishes.lean" "144" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Pricing.sneakernet_node_is_storage_only" "RequestProject/Pricing/Infra.lean" "185" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Pricing.state_under_a_gigabyte" "RequestProject/Pricing/Infra.lean" "73" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Pricing.storage_one_node" "RequestProject/Pricing/Infra.lean" "132" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Pricing.thousand_replicas" "RequestProject/Pricing/Infra.lean" "199" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Pricing.whole_operation_annual" "RequestProject/Pricing/Infra.lean" "280" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "RequestProject.Pricing.whole_operation_share" "RequestProject/Pricing/Infra.lean" "287" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Review.KernelChecked.dao_weight_val" "RequestProject/Review/KernelChecked.lean" "79" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "Review.KernelChecked.minimum_passage" "RequestProject/Review/KernelChecked.lean" "129" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "Review.KernelChecked.monster_product" "RequestProject/Review/KernelChecked.lean" "51" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "Review.KernelChecked.senator_vote_valid" "RequestProject/Review/KernelChecked.lean" "220" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "Review.KernelChecked.tier_sorted" "RequestProject/Review/KernelChecked.lean" "25" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "SFM.Bootstrap.affordable_iff" "RequestProject/Bootstrap/Plan.lean" "353" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "SFM.Bootstrap.caps_append" "RequestProject/Bootstrap/Model.lean" "87" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "SFM.Bootstrap.caps_cons" "RequestProject/Bootstrap/Model.lean" "74" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "SFM.Bootstrap.caps_idem" "RequestProject/Bootstrap/Model.lean" "153" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "SFM.Bootstrap.cash_ge_of_selfFunding" "RequestProject/Bootstrap/Model.lean" "307" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "SFM.Bootstrap.deepest_month" "RequestProject/Bootstrap/Plan.lean" "358" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "SFM.Bootstrap.eight_stages_cost_only_the_month" "RequestProject/Bootstrap/Plan.lean" "297" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "SFM.Bootstrap.end_state" "RequestProject/Bootstrap/Plan.lean" "372" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "SFM.Bootstrap.every_stage_pays_the_month" "RequestProject/Bootstrap/Plan.lean" "294" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "SFM.Bootstrap.feasible_from_caps" "RequestProject/Bootstrap/Model.lean" "147" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "SFM.Bootstrap.feasible_mono" "RequestProject/Bootstrap/Model.lean" "105" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "SFM.Bootstrap.float_is_tight" "RequestProject/Bootstrap/Plan.lean" "349" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "SFM.Bootstrap.float_not_repaid_in_four" "RequestProject/Bootstrap/Plan.lean" "392" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "SFM.Bootstrap.float_repaid_in_five_months" "RequestProject/Bootstrap/Plan.lean" "387" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "SFM.Bootstrap.maintenance_solvent_for_ever" "RequestProject/Bootstrap/Plan.lean" "377" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "SFM.Bootstrap.mem_caps_of_mem_gives" "RequestProject/Bootstrap/Model.lean" "82" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "SFM.Bootstrap.mem_caps_of_mem_held" "RequestProject/Bootstrap/Model.lean" "78" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "SFM.Bootstrap.mirror_publishes_the_seed" "RequestProject/Bootstrap/Plan.lean" "263" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "SFM.Bootstrap.mirror_restarts_the_plan" "RequestProject/Bootstrap/Plan.lean" "259" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "SFM.Bootstrap.monthly_run_rounds_up_the_priced_bill" "RequestProject/Bootstrap/Plan.lean" "303" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "SFM.Bootstrap.needs_supplied" "RequestProject/Bootstrap/Model.lean" "120" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "SFM.Bootstrap.no_revenue_float" "RequestProject/Bootstrap/Plan.lean" "408" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "SFM.Bootstrap.not_feasible_of_need_missing" "RequestProject/Bootstrap/Model.lean" "134" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "SFM.Bootstrap.not_self_funding_before_senate" "RequestProject/Bootstrap/Plan.lean" "368" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "SFM.Bootstrap.plan_feasible" "RequestProject/Bootstrap/Plan.lean" "241" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "SFM.Bootstrap.plan_gives_everything" "RequestProject/Bootstrap/Plan.lean" "251" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "SFM.Bootstrap.plan_length" "RequestProject/Bootstrap/Plan.lean" "237" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "SFM.Bootstrap.plan_needs_are_supplied_earlier" "RequestProject/Bootstrap/Plan.lean" "245" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "SFM.Bootstrap.plan_reruns_on_its_own_output" "RequestProject/Bootstrap/Plan.lean" "268" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "SFM.Bootstrap.plan_solvent" "RequestProject/Bootstrap/Plan.lean" "345" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "SFM.Bootstrap.rate_run" "RequestProject/Bootstrap/Model.lean" "216" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "SFM.Bootstrap.requiredFloat_nonneg" "RequestProject/Bootstrap/Model.lean" "258" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "SFM.Bootstrap.requiredFloat_of_free" "RequestProject/Bootstrap/Model.lean" "343" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "SFM.Bootstrap.required_float" "RequestProject/Bootstrap/Plan.lean" "341" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "SFM.Bootstrap.run_append" "RequestProject/Bootstrap/Model.lean" "189" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "SFM.Bootstrap.run_mem_trace" "RequestProject/Bootstrap/Model.lean" "202" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "SFM.Bootstrap.self_funding_from_senate" "RequestProject/Bootstrap/Plan.lean" "363" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "SFM.Bootstrap.solvent_iff_requiredFloat_le" "RequestProject/Bootstrap/Model.lean" "263" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "SFM.Bootstrap.solvent_mono_float" "RequestProject/Bootstrap/Model.lean" "296" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "SFM.Bootstrap.solvent_of_selfFunding" "RequestProject/Bootstrap/Model.lean" "329" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "SFM.Bootstrap.solvent_replicate_of_selfFunding" "RequestProject/Bootstrap/Model.lean" "335" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "SFM.Bootstrap.stage_checks_distinct" "RequestProject/Bootstrap/Plan.lean" "275" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "SFM.Bootstrap.stage_checks_nonempty" "RequestProject/Bootstrap/Plan.lean" "272" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "SFM.Bootstrap.stage_names_distinct" "RequestProject/Bootstrap/Plan.lean" "278" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "SFM.Bootstrap.totalCost_append" "RequestProject/Bootstrap/Model.lean" "359" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "SFM.Bootstrap.totalIncome_append" "RequestProject/Bootstrap/Model.lean" "362" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "SFM.Bootstrap.total_cost" "RequestProject/Bootstrap/Plan.lean" "288" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "SFM.Bootstrap.total_cost_splits" "RequestProject/Bootstrap/Plan.lean" "291" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "SFM.Bootstrap.trace_shift" "RequestProject/Bootstrap/Model.lean" "223" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "SFM.Bootstrap.wish_spend_is_the_open_programme" "RequestProject/Bootstrap/Plan.lean" "313" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "SFM.Bootstrap.wish_stages_are_the_open_wishes" "RequestProject/Bootstrap/Plan.lean" "323" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "SFM.DL.FModel.consistent_of_checkKB" "RequestProject/Tickets/DL.lean" "353" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "SFM.DL.FModel.eval_iff" "RequestProject/Tickets/DL.lean" "281" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "SFM.DL.KB.not_entails_bot_of_consistent" "RequestProject/Tickets/DL.lean" "225" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "SFM.Tickets.Plan.acyclic" "RequestProject/Tickets/Plan.lean" "105" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "SFM.Tickets.Plan.mem_tickets_of_prereq" "RequestProject/Tickets/Plan.lean" "110" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "SFM.Tickets.Plan.rank_lt_of_depEdge" "RequestProject/Tickets/Plan.lean" "89" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "SFM.Tickets.Plan.rank_lt_of_transGen" "RequestProject/Tickets/Plan.lean" "97" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "SFM.Tickets.actionable_blocked_disjoint" "RequestProject/Tickets/Queries.lean" "114" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "SFM.Tickets.actionable_sub_unclaimed" "RequestProject/Tickets/Queries.lean" "103" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "SFM.Tickets.actionable_sub_wishListItem" "RequestProject/Tickets/Queries.lean" "110" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "SFM.Tickets.answered_sub_discussed" "RequestProject/Tickets/Queries.lean" "300" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "SFM.Tickets.blocked_waits" "RequestProject/Tickets/Queries.lean" "129" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "SFM.Tickets.blocked_wishes" "RequestProject/Tickets/Queries.lean" "223" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "SFM.Tickets.community_wishes" "RequestProject/Tickets/Queries.lean" "240" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "SFM.Tickets.corpusModel_checks" "RequestProject/Tickets/Model.lean" "85" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "SFM.Tickets.count_actionable" "RequestProject/Tickets/Queries.lean" "210" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "SFM.Tickets.count_answered_dormant" "RequestProject/Tickets/Queries.lean" "335" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "SFM.Tickets.count_communityWishes" "RequestProject/Tickets/Queries.lean" "216" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "SFM.Tickets.count_epics" "RequestProject/Tickets/Queries.lean" "327" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "SFM.Tickets.count_needsSpec" "RequestProject/Tickets/Queries.lean" "331" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "SFM.Tickets.count_proofWishes" "RequestProject/Tickets/Queries.lean" "213" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "SFM.Tickets.count_quickWins" "RequestProject/Tickets/Queries.lean" "318" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "SFM.Tickets.count_rewarded" "RequestProject/Tickets/Queries.lean" "220" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "SFM.Tickets.count_tickets" "RequestProject/Tickets/Queries.lean" "204" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "SFM.Tickets.count_wishes" "RequestProject/Tickets/Queries.lean" "207" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "SFM.Tickets.discussed_iff_spoken" "RequestProject/Tickets/Queries.lean" "287" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "SFM.Tickets.discussion_counts" "RequestProject/Tickets/Queries.lean" "343" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "SFM.Tickets.endorsed_tickets" "RequestProject/Tickets/Queries.lean" "353" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "SFM.Tickets.extension_wishListItem" "RequestProject/Tickets/Queries.lean" "67" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "SFM.Tickets.kb_consistent" "RequestProject/Tickets/Model.lean" "92" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "SFM.Tickets.kb_no_absurd_individual" "RequestProject/Tickets/Model.lean" "96" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "SFM.Tickets.kb_size" "RequestProject/Tickets/Queries.lean" "199" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "SFM.Tickets.mem_wishNumbers_entails" "RequestProject/Tickets/Queries.lean" "58" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "SFM.Tickets.no_waiting_wishes" "RequestProject/Tickets/Queries.lean" "311" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "SFM.Tickets.plan_blocked_go_last" "RequestProject/Tickets/Plan.lean" "256" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "SFM.Tickets.plan_covers_actionable" "RequestProject/Tickets/Plan.lean" "169" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "SFM.Tickets.plan_covers_wishes" "RequestProject/Tickets/Plan.lean" "148" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "SFM.Tickets.plan_entails_wish" "RequestProject/Tickets/Plan.lean" "164" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "SFM.Tickets.plan_length" "RequestProject/Tickets/Plan.lean" "136" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "SFM.Tickets.plan_no_cycle" "RequestProject/Tickets/Plan.lean" "198" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "SFM.Tickets.plan_nodup" "RequestProject/Tickets/Plan.lean" "139" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "SFM.Tickets.plan_only_wishes" "RequestProject/Tickets/Plan.lean" "142" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "SFM.Tickets.plan_phase_counts" "RequestProject/Tickets/Plan.lean" "219" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "SFM.Tickets.plan_phases_monotone" "RequestProject/Tickets/Plan.lean" "204" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "SFM.Tickets.plan_phases_named" "RequestProject/Tickets/Plan.lean" "207" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "SFM.Tickets.plan_prereq_before" "RequestProject/Tickets/Plan.lean" "192" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "SFM.Tickets.plan_prereqs_are_the_links" "RequestProject/Tickets/Plan.lean" "180" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "SFM.Tickets.plan_prereqs_earlier" "RequestProject/Tickets/Plan.lean" "186" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "SFM.Tickets.plan_prereqs_present" "RequestProject/Tickets/Plan.lean" "189" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "SFM.Tickets.plan_priority_within_phase" "RequestProject/Tickets/Plan.lean" "239" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "SFM.Tickets.plan_quickWins_before_epics" "RequestProject/Tickets/Plan.lean" "267" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "SFM.Tickets.plan_schedules_the_wish_list" "RequestProject/Tickets/Plan.lean" "154" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "SFM.Tickets.proof_wishes" "RequestProject/Tickets/Queries.lean" "234" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "SFM.Tickets.quickWin_sub_ready" "RequestProject/Tickets/Queries.lean" "262" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "SFM.Tickets.quick_wins" "RequestProject/Tickets/Queries.lean" "321" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "SFM.Tickets.ready_eq_actionable" "RequestProject/Tickets/Queries.lean" "314" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "SFM.Tickets.ready_sub_actionable" "RequestProject/Tickets/Queries.lean" "252" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "SFM.Tickets.ready_sub_wishListItem" "RequestProject/Tickets/Queries.lean" "258" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "SFM.Tickets.ready_waiting_disjoint" "RequestProject/Tickets/Queries.lean" "268" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "SFM.Tickets.rewarded_sub_wishListItem" "RequestProject/Tickets/Queries.lean" "122" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "SFM.Tickets.size_counts" "RequestProject/Tickets/Queries.lean" "359" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "SFM.Tickets.small_large_disjoint" "RequestProject/Tickets/Queries.lean" "282" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "SFM.Tickets.ticket10_rewarded" "RequestProject/Tickets/Queries.lean" "147" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "SFM.Tickets.ticket13_not_wish" "RequestProject/Tickets/Queries.lean" "175" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "SFM.Tickets.ticket175_proofWish" "RequestProject/Tickets/Queries.lean" "156" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "SFM.Tickets.ticket42_communityWish" "RequestProject/Tickets/Queries.lean" "164" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "SFM.Tickets.ticket_has_author" "RequestProject/Tickets/Queries.lean" "138" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "SFM.Tickets.unclaimed_sub_wishListItem" "RequestProject/Tickets/Queries.lean" "96" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "SFM.Tickets.waiting_has_open_prerequisite" "RequestProject/Tickets/Queries.lean" "274" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "SFM.Tickets.wishListItem_not_closed" "RequestProject/Tickets/Queries.lean" "89" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "SFM.Tickets.wishListItem_sub_open" "RequestProject/Tickets/Queries.lean" "78" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "SFM.Tickets.wishListItem_sub_ticket" "RequestProject/Tickets/Queries.lean" "84" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "SFM.Tickets.wishNumbers_length" "RequestProject/Tickets/Queries.lean" "63" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "SFM.Tickets.wish_entailed" "RequestProject/Tickets/Queries.lean" "48" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "SFM.Tickets.wish_not_sub_rewarded" "RequestProject/Tickets/Queries.lean" "183" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "SFM.Tickets.wish_topic_counts" "RequestProject/Tickets/Queries.lean" "226" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Senate.Desk.acceptable_iff" "RequestProject/Senate/Desk.lean" "222" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Senate.Desk.account_claim_requires_key" "RequestProject/Senate/Desk.lean" "497" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Senate.Desk.attach_binds_trade" "RequestProject/Senate/Desk.lean" "462" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Senate.Desk.attach_news_exists" "RequestProject/Senate/Desk.lean" "394" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Senate.Desk.comment_binds_parent" "RequestProject/Senate/Desk.lean" "475" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Senate.Desk.comment_parent_exists" "RequestProject/Senate/Desk.lean" "377" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Senate.Desk.commentsOn_unknown_empty" "RequestProject/Senate/Desk.lean" "580" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Senate.Desk.commentsOn_verify" "RequestProject/Senate/Desk.lean" "574" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Senate.Desk.desk_message_ne_badge_challenge" "RequestProject/Senate/Desk.lean" "541" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Senate.Desk.exampleNews_message" "RequestProject/Senate/Desk.lean" "624" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Senate.Desk.exampleNews_wf" "RequestProject/Senate/Desk.lean" "629" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Senate.Desk.mem_newsForTrade" "RequestProject/Senate/Desk.lean" "593" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Senate.Desk.message_binds_author" "RequestProject/Senate/Desk.lean" "490" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Senate.Desk.message_injective" "RequestProject/Senate/Desk.lean" "158" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Senate.Desk.message_ne_of_ne" "RequestProject/Senate/Desk.lean" "170" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Senate.Desk.mutual_link_unique" "RequestProject/Senate/Desk.lean" "516" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Senate.Desk.post_append_only" "RequestProject/Senate/Desk.lean" "250" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Senate.Desk.post_dangling_rejected" "RequestProject/Senate/Desk.lean" "267" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Senate.Desk.post_replay_rejected" "RequestProject/Senate/Desk.lean" "261" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Senate.Desk.post_valid" "RequestProject/Senate/Desk.lean" "254" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Senate.Desk.roster_length" "RequestProject/Senate/Roster.lean" "26" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "Senate.Desk.roster_nodup" "RequestProject/Senate/Roster.lean" "29" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "Senate.Desk.roster_sepFree" "RequestProject/Senate/Roster.lean" "39" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Senate.Desk.senateOnly_authentic" "RequestProject/Senate/Roster.lean" "73" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Senate.Desk.share_carries_original" "RequestProject/Senate/Desk.lean" "404" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Senate.Desk.share_target_exists" "RequestProject/Senate/Desk.lean" "385" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Senate.Desk.tampering_needs_new_signature" "RequestProject/Senate/Desk.lean" "452" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Senate.Desk.valid_author_holds_key" "RequestProject/Senate/Desk.lean" "306" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Senate.Desk.valid_author_signed" "RequestProject/Senate/Desk.lean" "313" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Senate.Desk.valid_id_unique" "RequestProject/Senate/Desk.lean" "336" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Senate.Desk.valid_ids_nodup" "RequestProject/Senate/Desk.lean" "326" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Senate.Desk.valid_no_self_reference" "RequestProject/Senate/Desk.lean" "365" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Senate.Desk.valid_refs_resolve" "RequestProject/Senate/Desk.lean" "347" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Senate.Desk.valid_seq_strict_mono" "RequestProject/Senate/Desk.lean" "429" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Senate.Desk.valid_verify" "RequestProject/Senate/Desk.lean" "285" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Senate.Desk.valid_wf" "RequestProject/Senate/Desk.lean" "290" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Senate.Desk.wf_of_senator" "RequestProject/Senate/Roster.lean" "50" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Senate.Wire.joinFields_head" "RequestProject/Senate/Wire.lean" "197" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Senate.Wire.joinFields_injective" "RequestProject/Senate/Wire.lean" "156" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Senate.Wire.joinFields_ne_of_head_ne" "RequestProject/Senate/Wire.lean" "206" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Senate.Wire.natStr_injective" "RequestProject/Senate/Wire.lean" "80" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Senate.Wire.natStr_sepFree" "RequestProject/Senate/Wire.lean" "124" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solana.Base58.decode_encode" "RequestProject/Onchain/Proofs/Base58.lean" "128" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solana.Base58.encode_injective" "RequestProject/Onchain/Proofs/Base58.lean" "143" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solana.Base58.isValidPubkey_solfunmeme" "RequestProject/Onchain/Proofs/Base58.lean" "151" "lean4-native-decide" ["propext", "Classical.choice", "Lean.ofReduceBool", "Lean.trustCompiler", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solana.CaptureFacts.dataset_files_are_captures_of_the_mint" "RequestProject/Onchain/CaptureFacts.lean" "44" "lean4-native-decide" ["propext", "Classical.choice", "Lean.ofReduceBool", "Lean.trustCompiler", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solana.CaptureFacts.dataset_has_no_largest_accounts" "RequestProject/Onchain/CaptureFacts.lean" "51" "lean4-native-decide" ["propext", "Classical.choice", "Lean.ofReduceBool", "Lean.trustCompiler", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solana.CaptureFacts.fixtureHolders_sortedDesc" "RequestProject/Onchain/CaptureFacts.lean" "120" "lean4-native-decide" ["propext", "Lean.ofReduceBool", "Lean.trustCompiler", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solana.CaptureFacts.fixtureSnapshot_holders" "RequestProject/Onchain/CaptureFacts.lean" "116" "lean4-native-decide" ["propext", "Lean.ofReduceBool", "Lean.trustCompiler", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solana.CaptureFacts.fixtureSupply_render" "RequestProject/Onchain/CaptureFacts.lean" "207" "lean4-native-decide" ["propext", "Lean.ofReduceBool", "Lean.trustCompiler"] .VALID .MACHINE_CHECKED
  , entry "Solana.CaptureFacts.fixture_herfindahl_bound" "RequestProject/Onchain/CaptureFacts.lean" "194" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solana.CaptureFacts.fixture_holders_amounts" "RequestProject/Onchain/CaptureFacts.lean" "142" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "Solana.CaptureFacts.fixture_ingested_share_bounds" "RequestProject/Onchain/CaptureFacts.lean" "157" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solana.CaptureFacts.fixture_ingested_share_eq" "RequestProject/Onchain/CaptureFacts.lean" "148" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solana.CaptureFacts.fixture_merges_two_accounts" "RequestProject/Onchain/CaptureFacts.lean" "125" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "Solana.CaptureFacts.fixture_no_nakamoto" "RequestProject/Onchain/CaptureFacts.lean" "201" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solana.CaptureFacts.fixture_shared_wallet_balance" "RequestProject/Onchain/CaptureFacts.lean" "137" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "Solana.CaptureFacts.fixture_top1_share_bounds" "RequestProject/Onchain/CaptureFacts.lean" "172" "lean4-native-decide" ["propext", "Classical.choice", "Lean.ofReduceBool", "Lean.trustCompiler", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solana.CaptureFacts.fixture_top1_share_eq" "RequestProject/Onchain/CaptureFacts.lean" "164" "lean4-native-decide" ["propext", "Classical.choice", "Lean.ofReduceBool", "Lean.trustCompiler", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solana.CaptureFacts.fixture_topK_saturates" "RequestProject/Onchain/CaptureFacts.lean" "180" "lean4-native-decide" ["propext", "Classical.choice", "Lean.ofReduceBool", "Lean.trustCompiler", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solana.CaptureFacts.fixture_total_conserved" "RequestProject/Onchain/CaptureFacts.lean" "131" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "Solana.CaptureFacts.mint_authorities_are_null" "RequestProject/Onchain/CaptureFacts.lean" "62" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "Solana.CaptureFacts.mint_isValidPubkey" "RequestProject/Onchain/CaptureFacts.lean" "57" "lean4-native-decide" ["propext", "Classical.choice", "Lean.ofReduceBool", "Lean.trustCompiler", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solana.CaptureFacts.realActivity_counts" "RequestProject/Onchain/CaptureFacts.lean" "84" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "Solana.CaptureFacts.realActivity_ranges" "RequestProject/Onchain/CaptureFacts.lean" "90" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "Solana.CaptureFacts.realSignatures_all_timed" "RequestProject/Onchain/CaptureFacts.lean" "96" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "Solana.CaptureFacts.realSupply_render" "RequestProject/Onchain/CaptureFacts.lean" "67" "lean4-native-decide" ["propext", "Lean.ofReduceBool", "Lean.trustCompiler"] .VALID .MACHINE_CHECKED
  , entry "Solana.CaptureFacts.realSupply_render_roundtrip" "RequestProject/Onchain/CaptureFacts.lean" "73" "lean4-native-decide" ["propext", "Classical.choice", "Lean.ofReduceBool", "Lean.trustCompiler", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solana.Decimal.parse_append_renderParts" "RequestProject/Onchain/Proofs/Decimal.lean" "106" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solana.Decimal.renderParts_snd_length" "RequestProject/Onchain/Proofs/Decimal.lean" "89" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solana.Digits.digitsBE_normalized" "RequestProject/Onchain/Proofs/Digits.lean" "103" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solana.Digits.digitsBE_ofDigitsBE" "RequestProject/Onchain/Proofs/Digits.lean" "108" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solana.Digits.ofDigitsBE_digitsBE" "RequestProject/Onchain/Proofs/Digits.lean" "52" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solana.Holders.aggregate_nodup" "RequestProject/Onchain/Proofs/Holders.lean" "67" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solana.Holders.herfindahl_le_one" "RequestProject/Onchain/Proofs/Holders.lean" "200" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solana.Holders.nakamoto_eq_none_of_le_half" "RequestProject/Onchain/Proofs/Holders.lean" "242" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solana.Holders.nakamoto_spec" "RequestProject/Onchain/Proofs/Holders.lean" "219" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solana.Holders.sortedDesc_perm" "RequestProject/Onchain/Proofs/Holders.lean" "80" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solana.Holders.topKShare_mono" "RequestProject/Onchain/Proofs/Holders.lean" "162" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solana.Holders.totalAmount_aggregate" "RequestProject/Onchain/Proofs/Holders.lean" "51" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Codec.Lossiness.worse_eq_lossless" "RequestProject/Codec/Model.lean" "147" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Codec.ProofObject.extension_withExtension" "RequestProject/Codec/Model.lean" "283" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Codec.ProofObject.minimalProfile_withIdentity" "RequestProject/Codec/Model.lean" "260" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Codec.RawText.ingest_preserves_text" "RequestProject/Codec/Raw.lean" "128" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Codec.RawText.ingest_status_not_invalid" "RequestProject/Codec/Raw.lean" "132" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Codec.RowSyntax.declaredLossiness_honest" "RequestProject/Codec/Line.lean" "312" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Codec.RowSyntax.decode_encode" "RequestProject/Codec/Line.lean" "295" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Codec.RowSyntax.parseCell_renderCell" "RequestProject/Codec/Line.lean" "178" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Codec.RowSyntax.parse_render" "RequestProject/Codec/Line.lean" "272" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Codec.Status.name_injective" "RequestProject/Codec/Model.lean" "58" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Codec.Status.no_silent_conversion" "RequestProject/Codec/Model.lean" "65" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Codec.Status.ofName_name" "RequestProject/Codec/Model.lean" "54" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Codec.canonicalSerialize_inj" "RequestProject/Codec/Hash.lean" "42" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Codec.chainLossiness_eq_lossless_iff" "RequestProject/Codec/Exchange.lean" "92" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Codec.codecs_lossless" "RequestProject/Codec/Formats.lean" "194" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Codec.compareObjects_eq_equivalent_iff" "RequestProject/Codec/Reconcile.lean" "139" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Codec.compareObjects_of_semanticEq" "RequestProject/Codec/Conformance.lean" "180" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Codec.compareObjects_refl" "RequestProject/Codec/Reconcile.lean" "135" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Codec.conflict_of_decisive_disagreement" "RequestProject/Codec/Reconcile.lean" "167" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Codec.contentId_of_any_codec" "RequestProject/Codec/Hash.lean" "83" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Codec.decList_encList" "RequestProject/Codec/Escape.lean" "375" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Codec.decPairs_encPairs" "RequestProject/Codec/Escape.lean" "429" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Codec.decodeChildren_blocks" "RequestProject/Codec/Table.lean" "136" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Codec.decodeTable_encodeTable" "RequestProject/Codec/Table.lean" "418" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Codec.definition_of_done" "RequestProject/Codec/Conformance.lean" "247" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Codec.detect_declared" "RequestProject/Codec/Raw.lean" "215" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Codec.detect_encode" "RequestProject/Codec/Raw.lean" "202" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Codec.diff_value_mismatch" "RequestProject/Codec/Reconcile.lean" "111" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Codec.escape_no_sep" "RequestProject/Codec/Escape.lean" "161" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Codec.exportArtifact_roundTrips" "RequestProject/Codec/Exchange.lean" "407" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Codec.factorisation_conforms" "RequestProject/Codec/Validate.lean" "323" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Codec.flatCsv_no_decoder" "RequestProject/Codec/Formats.lean" "224" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Codec.flatCsv_not_injective" "RequestProject/Codec/Formats.lean" "215" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Codec.importArtifact_of_encoded" "RequestProject/Codec/Exchange.lean" "344" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Codec.importArtifact_preserves_bytes" "RequestProject/Codec/Exchange.lean" "297" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Codec.importArtifact_status_from_document" "RequestProject/Codec/Conformance.lean" "158" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Codec.importArtifact_unparsed_is_unknown" "RequestProject/Codec/Exchange.lean" "358" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Codec.importWithSchema_major_mismatch" "RequestProject/Codec/Exchange.lean" "457" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Codec.incomplete_of_unknown" "RequestProject/Codec/Reconcile.lean" "175" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Codec.inferType_integer" "RequestProject/Codec/Table.lean" "59" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Codec.level2_typed" "RequestProject/Codec/Conformance.lean" "215" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Codec.linked_append_step" "RequestProject/Codec/Exchange.lean" "107" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Codec.merge_keeps_both" "RequestProject/Codec/Reconcile.lean" "278" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Codec.ofCsv_toCsv" "RequestProject/Codec/Formats.lean" "114" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Codec.ofIpdl_toIpdl" "RequestProject/Codec/Formats.lean" "58" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Codec.ofText_toText" "RequestProject/Codec/Formats.lean" "169" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Codec.ofXml_toXml" "RequestProject/Codec/Formats.lean" "89" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Codec.ofYaml_toYaml" "RequestProject/Codec/Formats.lean" "141" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Codec.openEnvelope_rejects_tamper" "RequestProject/Codec/Exchange.lean" "196" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Codec.openEnvelope_seal" "RequestProject/Codec/Exchange.lean" "180" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Codec.provenanceChain_example" "RequestProject/Codec/Exchange.lean" "237" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Codec.resolveConflict_marks_conflict" "RequestProject/Codec/Reconcile.lean" "269" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Codec.resolveConflict_records" "RequestProject/Codec/Reconcile.lean" "256" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Codec.resolveInput_idem" "RequestProject/Codec/Validate.lean" "242" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Codec.resolveInput_records" "RequestProject/Codec/Validate.lean" "210" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Codec.splitC_eq_splitCTR" "RequestProject/Codec/Escape.lean" "234" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Codec.splitFields_joinFields" "RequestProject/Codec/Escape.lean" "301" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Codec.splitTerm_joinTerm" "RequestProject/Codec/Escape.lean" "338" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Codec.suite_roundTrips" "RequestProject/Codec/Conformance.lean" "134" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Codec.takeBlock_blockCells" "RequestProject/Codec/Table.lean" "98" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Codec.unescape_escape" "RequestProject/Codec/Escape.lean" "157" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Codec.validateStructure_nil_iff" "RequestProject/Codec/Validate.lean" "94" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Codec.validateWith_records_engine" "RequestProject/Codec/Validate.lean" "262" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Codec.validate_clean_of_minimal" "RequestProject/Codec/Validate.lean" "154" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Codec.validation_is_not_proof" "RequestProject/Codec/Validate.lean" "170" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Domain.Data.corpus_certificates" "RequestProject/Domain/Facts.lean" "102" "lean4-native-decide" ["Lean.ofReduceBool", "Lean.trustCompiler"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Domain.Data.corpus_coverage" "RequestProject/Domain/Facts.lean" "93" "lean4-native-decide" ["propext", "Lean.ofReduceBool", "Lean.trustCompiler"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Domain.Data.corpus_hash_stable" "RequestProject/Domain/Facts.lean" "128" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Domain.Data.corpus_roundTrip" "RequestProject/Domain/Facts.lean" "124" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Domain.Data.corpus_size" "RequestProject/Domain/Facts.lean" "86" "lean4-native-decide" ["propext", "Lean.ofReduceBool", "Lean.trustCompiler"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Domain.Data.corpus_wellFormed" "RequestProject/Domain/Facts.lean" "82" "lean4-native-decide" ["propext", "Lean.ofReduceBool", "Lean.trustCompiler"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Domain.Data.dataset_coverage" "RequestProject/Domain/Facts.lean" "38" "lean4-native-decide" ["propext", "Classical.choice", "Lean.ofReduceBool", "Lean.trustCompiler", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Domain.Data.dataset_coverage_total" "RequestProject/Domain/Facts.lean" "72" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Domain.Data.dataset_cross" "RequestProject/Domain/Facts.lean" "113" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Domain.Data.dataset_data_to_proof" "RequestProject/Domain/Facts.lean" "136" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Domain.Data.dataset_hash_stable" "RequestProject/Domain/Facts.lean" "119" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Domain.Data.dataset_ledger_covers" "RequestProject/Domain/Facts.lean" "67" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Domain.Data.dataset_proof_to_data" "RequestProject/Domain/Facts.lean" "143" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Domain.Data.dataset_proof_to_input" "RequestProject/Domain/Facts.lean" "150" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Domain.Data.dataset_proof_to_output" "RequestProject/Domain/Facts.lean" "159" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Domain.Data.dataset_roundTrip" "RequestProject/Domain/Facts.lean" "108" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Domain.Data.dataset_size" "RequestProject/Domain/Facts.lean" "32" "lean4-native-decide" ["propext", "Classical.choice", "Lean.ofReduceBool", "Lean.trustCompiler", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Domain.Data.dataset_unproven_are_declared" "RequestProject/Domain/Facts.lean" "47" "lean4-native-decide" ["propext", "Classical.choice", "Lean.ofReduceBool", "Lean.trustCompiler", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Domain.Data.dataset_unproven_truth" "RequestProject/Domain/Facts.lean" "54" "lean4-native-decide" ["propext", "Classical.choice", "Lean.ofReduceBool", "Lean.trustCompiler", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Domain.Data.dataset_wellFormed" "RequestProject/Domain/Facts.lean" "29" "lean4-native-decide" ["propext", "Classical.choice", "Lean.ofReduceBool", "Lean.trustCompiler", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Domain.Domain.contradiction_is_reported" "RequestProject/Domain/Ledger.lean" "133" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Domain.Domain.coverageReport_bounds" "RequestProject/Domain/Ledger.lean" "542" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Domain.Domain.coverageReport_total" "RequestProject/Domain/Ledger.lean" "529" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Domain.Domain.coverage_of_no_proofs" "RequestProject/Domain/Model.lean" "424" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Domain.Domain.coverage_of_proven" "RequestProject/Domain/Ledger.lean" "204" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Domain.Domain.data_to_proof" "RequestProject/Domain/Ledger.lean" "325" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Domain.Domain.exists_valid_proof_of_coverage" "RequestProject/Domain/Model.lean" "431" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Domain.Domain.graph_closed_under_converse" "RequestProject/Domain/Ledger.lean" "310" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Domain.Domain.graph_subset_linked" "RequestProject/Domain/Ledger.lean" "385" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Domain.Domain.ledger_covers_objects" "RequestProject/Domain/Ledger.lean" "462" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Domain.Domain.ledger_proven_is_backed" "RequestProject/Domain/Ledger.lean" "474" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Domain.Domain.no_contradicted_proven" "RequestProject/Domain/Ledger.lean" "180" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Domain.Domain.promote_not_proven" "RequestProject/Domain/Ledger.lean" "222" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Domain.Domain.promote_proven" "RequestProject/Domain/Ledger.lean" "228" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Domain.Domain.proofRefs_resolve" "RequestProject/Domain/Ledger.lean" "192" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Domain.Domain.proof_to_data" "RequestProject/Domain/Ledger.lean" "332" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Domain.Domain.proof_to_input" "RequestProject/Domain/Ledger.lean" "348" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Domain.Domain.proof_to_output" "RequestProject/Domain/Ledger.lean" "366" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Domain.Domain.proven_has_valid_proof" "RequestProject/Domain/Ledger.lean" "168" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Domain.Domain.uncertified_valid_is_reported" "RequestProject/Domain/Ledger.lean" "154" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Domain.Domain.unjustified_is_reported" "RequestProject/Domain/Ledger.lean" "124" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Domain.Domain.unresolved_proofRef_is_reported" "RequestProject/Domain/Ledger.lean" "144" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Domain.DomainObject.stamped_idempotent" "RequestProject/Domain/Hash.lean" "200" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Domain.ProofStatus.name_injective" "RequestProject/Domain/Model.lean" "129" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Domain.RelationKind.converse_involutive" "RequestProject/Domain/Model.lean" "248" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Domain.RelationKind.converse_on_proof" "RequestProject/Domain/Model.lean" "254" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Domain.RelationKind.name_injective" "RequestProject/Domain/Model.lean" "222" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Domain.TruthStatus.name_injective" "RequestProject/Domain/Model.lean" "78" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Domain.TruthStatus.no_silent_conversion" "RequestProject/Domain/Model.lean" "84" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Domain.Validation.exists_lt_checked_lt_reproduced" "RequestProject/Domain/Model.lean" "176" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Domain.Validation.name_injective" "RequestProject/Domain/Model.lean" "158" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Domain.Validation.rank_injective" "RequestProject/Domain/Model.lean" "171" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Domain.decodeClaimsDoc_claimsDoc" "RequestProject/Domain/Emit.lean" "136" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Domain.decodeDomainTable_encodeDomainTable" "RequestProject/Domain/Table.lean" "306" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Domain.decodeDomain_cross" "RequestProject/Domain/Emit.lean" "89" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Domain.decodeDomain_encodeDomain" "RequestProject/Domain/Emit.lean" "39" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Domain.decodeDomain_of_codec" "RequestProject/Domain/Emit.lean" "83" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Domain.decodeObjectsDoc_objectsDoc" "RequestProject/Domain/Emit.lean" "132" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Domain.decodeProofsDoc_proofsDoc" "RequestProject/Domain/Emit.lean" "140" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Domain.decodeRelationsDoc_relationsDoc" "RequestProject/Domain/Emit.lean" "144" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Domain.domainCanonical_inj" "RequestProject/Domain/Hash.lean" "125" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Domain.domainCodecLossiness_honest" "RequestProject/Domain/Emit.lean" "162" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Domain.domainHash_cross" "RequestProject/Domain/Hash.lean" "162" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Domain.domainHash_of_any_codec" "RequestProject/Domain/Hash.lean" "156" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Domain.encodeDomainTable_inj" "RequestProject/Domain/Table.lean" "393" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Domain.ledgerRows_not_injective" "RequestProject/Domain/Ledger.lean" "487" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Domain.ledger_no_decoder" "RequestProject/Domain/Ledger.lean" "493" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Domain.objectCanonical_inj" "RequestProject/Domain/Hash.lean" "73" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Domain.objectHash_stamped" "RequestProject/Domain/Hash.lean" "190" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Domain.partition_reassembles" "RequestProject/Domain/Emit.lean" "151" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Domain.proofCanonical_inj" "RequestProject/Domain/Hash.lean" "93" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Domain.transcodeDomain_chain" "RequestProject/Domain/Emit.lean" "103" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Domain.unstamped_stamped" "RequestProject/Domain/Hash.lean" "182" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Domain.withConverses_closed" "RequestProject/Domain/Ledger.lean" "256" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Game.Commit.balance_pos_of_bit_proofs" "RequestProject/Game/Commit.lean" "192" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Game.Commit.bit_iff" "RequestProject/Game/Commit.lean" "162" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Game.Commit.chaumPedersen_complete" "RequestProject/Game/Commit.lean" "143" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Game.Commit.chaumPedersen_extract" "RequestProject/Game/Commit.lean" "150" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Game.Commit.commit_add" "RequestProject/Game/Commit.lean" "46" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Game.Commit.commit_binding" "RequestProject/Game/Commit.lean" "76" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Game.Commit.commit_pred" "RequestProject/Game/Commit.lean" "200" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Game.Commit.commit_succ" "RequestProject/Game/Commit.lean" "57" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Game.Commit.commit_sum" "RequestProject/Game/Commit.lean" "65" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Game.Commit.fromBits_lt" "RequestProject/Game/Commit.lean" "177" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Game.Commit.schnorr_complete" "RequestProject/Game/Commit.lean" "108" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Game.Commit.schnorr_extract" "RequestProject/Game/Commit.lean" "116" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Game.Commit.total_bounds" "RequestProject/Game/Commit.lean" "207" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Game.balance_mono_of_holds" "RequestProject/Game/Engine.lean" "263" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Game.balance_pos" "RequestProject/Game/Engine.lean" "153" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Game.duration_eq_heldDays" "RequestProject/Game/Stake.lean" "86" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Game.heldDays_mono" "RequestProject/Game/Engine.lean" "275" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Game.holder_stake_ge" "RequestProject/Game/Stake.lean" "128" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Game.initial_run_balance_pos" "RequestProject/Game/Engine.lean" "172" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Game.minted_le_of_run" "RequestProject/Game/Engine.lean" "201" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Game.rugged_pos" "RequestProject/Game/Engine.lean" "142" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Game.run_append" "RequestProject/Game/Engine.lean" "136" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Game.run_balance_pos" "RequestProject/Game/Engine.lean" "164" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Game.run_heldDays_eq" "RequestProject/Game/Stake.lean" "49" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Game.run_minted" "RequestProject/Game/Engine.lean" "189" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Game.run_stake" "RequestProject/Game/Engine.lean" "231" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Game.run_stake_eq_sum" "RequestProject/Game/Stake.lean" "38" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Game.stake_eq_tokenDays" "RequestProject/Game/Stake.lean" "81" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Game.stake_ge_of_holds" "RequestProject/Game/Engine.lean" "285" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Game.stake_le_of_daily_le" "RequestProject/Game/Stake.lean" "117" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Game.stake_lt_of_day" "RequestProject/Game/Stake.lean" "104" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Game.stake_mono" "RequestProject/Game/Engine.lean" "238" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Game.stake_mono_append" "RequestProject/Game/Stake.lean" "97" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Game.stake_step" "RequestProject/Game/Engine.lean" "211" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Game.stake_strict_of_day" "RequestProject/Game/Engine.lean" "324" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Game.unlocks_mono" "RequestProject/Game/Engine.lean" "336" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Game.unlocks_mono_run" "RequestProject/Game/Engine.lean" "340" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Game.unrle_rle" "RequestProject/Game/Engine.lean" "364" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Game.verify_claimOf" "RequestProject/Game/Engine.lean" "414" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Game.verify_sound" "RequestProject/Game/Engine.lean" "421" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Game.worldBalance_pos" "RequestProject/Game/Engine.lean" "145" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.IndexFeed.aesop_docs" "RequestProject/IndexFeed/Facts.lean" "171" "lean4-native-decide" ["propext", "Classical.choice", "Lean.ofReduceBool", "Lean.trustCompiler", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.IndexFeed.allPostings_nodup_of_blocks" "RequestProject/IndexFeed/Model.lean" "289" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.IndexFeed.docIds_head_disjoint" "RequestProject/IndexFeed/Model.lean" "199" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.IndexFeed.docIds_nodup" "RequestProject/IndexFeed/Facts.lean" "103" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.IndexFeed.docIds_nodup_of_blocks" "RequestProject/IndexFeed/Model.lean" "248" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.IndexFeed.docs_count" "RequestProject/IndexFeed/Facts.lean" "99" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.IndexFeed.exists_chunk_of_mem_allPostings" "RequestProject/IndexFeed/Model.lean" "270" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.IndexFeed.feed_length" "RequestProject/IndexFeed/Facts.lean" "34" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.IndexFeed.feed_seqs" "RequestProject/IndexFeed/Facts.lean" "37" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.IndexFeed.hapax_count" "RequestProject/IndexFeed/Facts.lean" "148" "lean4-native-decide" ["propext", "Lean.ofReduceBool", "Lean.trustCompiler", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.IndexFeed.hits_append" "RequestProject/IndexFeed/Model.lean" "148" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.IndexFeed.hits_mono" "RequestProject/IndexFeed/Model.lean" "141" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.IndexFeed.mathlib_docs" "RequestProject/IndexFeed/Facts.lean" "168" "lean4-native-decide" ["propext", "Classical.choice", "Lean.ofReduceBool", "Lean.trustCompiler", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.IndexFeed.mem_docIds_of_posting" "RequestProject/IndexFeed/Model.lean" "275" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.IndexFeed.mem_hits" "RequestProject/IndexFeed/Model.lean" "125" "lean4-kernel" ["propext", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.IndexFeed.missing_eq_nil_iff" "RequestProject/IndexFeed/Model.lean" "154" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.IndexFeed.missing_length" "RequestProject/IndexFeed/Facts.lean" "66" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.IndexFeed.no_solfunmeme_document" "RequestProject/IndexFeed/Facts.lean" "181" "lean4-native-decide" ["propext", "Classical.choice", "Lean.ofReduceBool", "Lean.trustCompiler", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.IndexFeed.postings_count" "RequestProject/IndexFeed/Facts.lean" "114" "lean4-kernel" [] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.IndexFeed.postings_nodup" "RequestProject/IndexFeed/Facts.lean" "134" "lean4-native-decide" ["propext", "Lean.ofReduceBool", "Lean.trustCompiler", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.IndexFeed.solfunmeme_no_hits" "RequestProject/IndexFeed/Facts.lean" "195" "lean4-native-decide" ["Lean.ofReduceBool", "Lean.trustCompiler"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.IndexFeed.term_count" "RequestProject/IndexFeed/Facts.lean" "145" "lean4-native-decide" ["propext", "Lean.ofReduceBool", "Lean.trustCompiler", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Sync.card_le_card_merge" "RequestProject/Sync/Lattice.lean" "96" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Sync.converged_pairwise" "RequestProject/Sync/Lattice.lean" "269" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Sync.convergence" "RequestProject/Sync/Lattice.lean" "263" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Sync.delivered_append" "RequestProject/Sync/Lattice.lean" "152" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Sync.final_subset_total" "RequestProject/Sync/Lattice.lean" "247" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Sync.headKey_empty" "RequestProject/Sync/Lattice.lean" "324" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Sync.headKey_mem" "RequestProject/Sync/Lattice.lean" "328" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Sync.headKey_mono" "RequestProject/Sync/Lattice.lean" "313" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Sync.headKey_run" "RequestProject/Sync/Lattice.lean" "319" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Sync.head_congr" "RequestProject/Sync/Lattice.lean" "301" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Sync.heads_agree" "RequestProject/Sync/Lattice.lean" "306" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Sync.merge_assoc" "RequestProject/Sync/Lattice.lean" "73" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Sync.merge_comm" "RequestProject/Sync/Lattice.lean" "70" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Sync.merge_idem" "RequestProject/Sync/Lattice.lean" "76" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Sync.merge_mono" "RequestProject/Sync/Lattice.lean" "91" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Sync.merge_self_right" "RequestProject/Sync/Lattice.lean" "80" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Sync.one_bundle_suffices" "RequestProject/Sync/Lattice.lean" "278" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Sync.online_offline_commute" "RequestProject/Sync/Lattice.lean" "207" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Sync.run_append" "RequestProject/Sync/Lattice.lean" "148" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Sync.run_append_self" "RequestProject/Sync/Lattice.lean" "175" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Sync.run_cons_dup" "RequestProject/Sync/Lattice.lean" "180" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Sync.run_eq_merge_delivered" "RequestProject/Sync/Lattice.lean" "140" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Sync.run_mono_state" "RequestProject/Sync/Lattice.lean" "218" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Sync.run_pair_comm" "RequestProject/Sync/Lattice.lean" "161" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Sync.run_perm_invariant" "RequestProject/Sync/Lattice.lean" "167" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Sync.run_retag" "RequestProject/Sync/Lattice.lean" "186" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Sync.subset_merge_left" "RequestProject/Sync/Lattice.lean" "84" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Sync.subset_run" "RequestProject/Sync/Lattice.lean" "214" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "Solfunmeme.Sync.transports_interchangeable" "RequestProject/Sync/Lattice.lean" "198" "lean4-kernel" ["propext", "Classical.choice", "Quot.sound"] .VALID .MACHINE_CHECKED
  , entry "dao_weight_val" "RequestProject/Upstream/Governance.lean" "117" "lean4-native-decide" ["Lean.ofReduceBool", "Lean.trustCompiler"] .VALID .MACHINE_CHECKED
  , entry "filter_subset" "RequestProject/Upstream/Bills.lean" "118" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  , entry "minimum_passage" "RequestProject/Upstream/FederalGov.lean" "126" "lean4-native-decide" ["Lean.ofReduceBool", "Lean.trustCompiler"] .VALID .MACHINE_CHECKED
  , entry "monster_product" "RequestProject/Upstream/FederalModel.lean" "78" "lean4-native-decide" ["Lean.ofReduceBool", "Lean.trustCompiler"] .VALID .MACHINE_CHECKED
  , entry "senator_vote_valid" "RequestProject/Upstream/VotingProtocol.lean" "107" "lean4-native-decide" ["Lean.ofReduceBool", "Lean.trustCompiler"] .VALID .MACHINE_CHECKED
  , entry "tier_sorted" "RequestProject/Upstream/FederalModel.lean" "21" "lean4-native-decide" ["Lean.ofReduceBool", "Lean.trustCompiler"] .VALID .MACHINE_CHECKED
  , entry "weight_pos" "RequestProject/Upstream/Governance.lean" "67" "lean4-kernel" ["propext"] .VALID .MACHINE_CHECKED
  ]

/-- The claim each catalogued theorem establishes. -/
def catalogClaim (p : ProofRecord) : DomainClaim :=
  { id := "claim:" ++ p.id
    text := "the Lean 4 theorem " ++ p.id ++ " type checks"
    objectRef := p.sourceFile
    proofRefs := [p.id]
    truth := if p.status = .VALID then .PROVEN else .UNRESOLVED }

def catalogClaims : List DomainClaim := catalogProofs.map catalogClaim

/-- One domain object per source module holding audited theorems. -/
def moduleObject (file : String) (audited : List String) : DomainObject :=
  { id := file
    kind := "lean-module"
    name := file
    claim := "every audited theorem of " ++ file ++ " type checks"
    value := toString audited.length
    valueType := "integer"
    proofRefs := audited
    truth := .PROVEN
    sourceRefs := [file]
    provenance := { sourceSystem := "lean4-4.28.0", sourceFile := file
                    sourceFormat := "lean" } }

/-- The modules of the corpus that carry audited theorems. -/
def catalogModules : List DomainObject :=
  [ moduleObject "RequestProject/Badges/Badge.lean" ["Badges.all_badges_short", "Badges.badge_shortfall", "Badges.chad_badge", "Badges.genesis_tokenDays_lower_bound", "Badges.mint_address_irrelevant", "Badges.mint_hides_rank_within_tier", "Badges.mint_reveals_constant_balance", "Badges.senate_badges_short"]
  , moduleObject "RequestProject/Badges/Claim.lean" ["Badges.Claim.challenge_binds_nonce", "Badges.Claim.challenge_binds_statement", "Badges.Claim.no_replay", "Badges.Claim.token_tampering_needs_new_signature", "Badges.Claim.unlock_eq_some_iff", "Badges.Claim.unlock_output_is_page_statement", "Badges.Claim.unlock_requires_key", "Badges.Claim.verifyToken_mintToken", "Badges.Claim.verifyToken_requires_key"]
  , moduleObject "RequestProject/Badges/ClaimFacts.lean" ["Badges.Claim.addresses_are_32_byte_keys", "Badges.Claim.addresses_nodup", "Badges.Claim.challengePrefixes_nodup", "Badges.Claim.claims_eq_pages", "Badges.Claim.dates_agree", "Badges.Claim.distinct_pages_distinct_challenges", "Badges.Claim.genesis_badge_count", "Badges.Claim.leader_statement", "Badges.Claim.since_backed", "Badges.Claim.since_maximal", "Badges.Claim.standing_bracket"]
  , moduleObject "RequestProject/Badges/SnapshotFacts.lean" ["Badges.Snapshot.fourth_tokenDays_lower", "Badges.Snapshot.genesis_count", "Badges.Snapshot.genesis_fewer_than_credentials", "Badges.Snapshot.genesis_fewer_than_seats", "Badges.Snapshot.leader_dominates", "Badges.Snapshot.leader_tokenDays", "Badges.Snapshot.senate_churn", "Badges.Snapshot.senate_recorded", "Badges.Snapshot.snapshot_count", "Badges.Snapshot.third_tokenDays_upper", "Badges.Snapshot.times_increasing", "Badges.Snapshot.tokenDays_reorders_senate", "Badges.Snapshot.window_days"]
  , moduleObject "RequestProject/Badges/Tiers.lean" ["Badges.cumulative_sizes_not_fibonacci", "Badges.no_voice_beyond_1600", "Badges.operational_bypasses_senate", "Badges.phi_progression_from_100", "Badges.rep_vendor_ratio_off_from_phi", "Badges.representative_seat_count", "Badges.senate_alone_cannot_enact", "Badges.senate_rep_ratio_off_from_phi_cubed", "Badges.senate_seat_count", "Badges.senate_veto_redundant_for_major", "Badges.tier_exhaustive", "Badges.tier_ratios_differ", "Badges.tier_sizes_not_fibonacci", "Badges.vendor_seat_count"]
  , moduleObject "RequestProject/Badges/TokenDays.lean" ["Badges.accrue_eq_tokenDays", "Badges.accrue_le_tokenDays", "Badges.chad_interest", "Badges.chad_tokenDays", "Badges.daily_rate_compounds_above_44_percent", "Badges.dip_wipes_history", "Badges.simple_understates_compound", "Badges.supply_more_than_doubles_in_two_years", "Badges.time_beats_size", "Badges.tokenDays_append", "Badges.tokenDays_eq_sum_balanceOn", "Badges.tokenDays_lt_append", "Badges.tokenDays_mono_balance", "Badges.uniform_interest_rank_invariant", "Badges.uniform_interest_share_invariant"]
  , moduleObject "RequestProject/Bootstrap/Model.lean" ["SFM.Bootstrap.caps_append", "SFM.Bootstrap.caps_cons", "SFM.Bootstrap.caps_idem", "SFM.Bootstrap.cash_ge_of_selfFunding", "SFM.Bootstrap.feasible_from_caps", "SFM.Bootstrap.feasible_mono", "SFM.Bootstrap.mem_caps_of_mem_gives", "SFM.Bootstrap.mem_caps_of_mem_held", "SFM.Bootstrap.needs_supplied", "SFM.Bootstrap.not_feasible_of_need_missing", "SFM.Bootstrap.rate_run", "SFM.Bootstrap.requiredFloat_nonneg", "SFM.Bootstrap.requiredFloat_of_free", "SFM.Bootstrap.run_append", "SFM.Bootstrap.run_mem_trace", "SFM.Bootstrap.solvent_iff_requiredFloat_le", "SFM.Bootstrap.solvent_mono_float", "SFM.Bootstrap.solvent_of_selfFunding", "SFM.Bootstrap.solvent_replicate_of_selfFunding", "SFM.Bootstrap.totalCost_append", "SFM.Bootstrap.totalIncome_append", "SFM.Bootstrap.trace_shift"]
  , moduleObject "RequestProject/Bootstrap/Plan.lean" ["SFM.Bootstrap.affordable_iff", "SFM.Bootstrap.deepest_month", "SFM.Bootstrap.eight_stages_cost_only_the_month", "SFM.Bootstrap.end_state", "SFM.Bootstrap.every_stage_pays_the_month", "SFM.Bootstrap.float_is_tight", "SFM.Bootstrap.float_not_repaid_in_four", "SFM.Bootstrap.float_repaid_in_five_months", "SFM.Bootstrap.maintenance_solvent_for_ever", "SFM.Bootstrap.mirror_publishes_the_seed", "SFM.Bootstrap.mirror_restarts_the_plan", "SFM.Bootstrap.monthly_run_rounds_up_the_priced_bill", "SFM.Bootstrap.no_revenue_float", "SFM.Bootstrap.not_self_funding_before_senate", "SFM.Bootstrap.plan_feasible", "SFM.Bootstrap.plan_gives_everything", "SFM.Bootstrap.plan_length", "SFM.Bootstrap.plan_needs_are_supplied_earlier", "SFM.Bootstrap.plan_reruns_on_its_own_output", "SFM.Bootstrap.plan_solvent", "SFM.Bootstrap.required_float", "SFM.Bootstrap.self_funding_from_senate", "SFM.Bootstrap.stage_checks_distinct", "SFM.Bootstrap.stage_checks_nonempty", "SFM.Bootstrap.stage_names_distinct", "SFM.Bootstrap.total_cost", "SFM.Bootstrap.total_cost_splits", "SFM.Bootstrap.wish_spend_is_the_open_programme", "SFM.Bootstrap.wish_stages_are_the_open_wishes"]
  , moduleObject "RequestProject/Codec/Conformance.lean" ["Solfunmeme.Codec.compareObjects_of_semanticEq", "Solfunmeme.Codec.definition_of_done", "Solfunmeme.Codec.importArtifact_status_from_document", "Solfunmeme.Codec.level2_typed", "Solfunmeme.Codec.suite_roundTrips"]
  , moduleObject "RequestProject/Codec/Escape.lean" ["Solfunmeme.Codec.decList_encList", "Solfunmeme.Codec.decPairs_encPairs", "Solfunmeme.Codec.escape_no_sep", "Solfunmeme.Codec.splitC_eq_splitCTR", "Solfunmeme.Codec.splitFields_joinFields", "Solfunmeme.Codec.splitTerm_joinTerm", "Solfunmeme.Codec.unescape_escape"]
  , moduleObject "RequestProject/Codec/Exchange.lean" ["Solfunmeme.Codec.chainLossiness_eq_lossless_iff", "Solfunmeme.Codec.exportArtifact_roundTrips", "Solfunmeme.Codec.importArtifact_of_encoded", "Solfunmeme.Codec.importArtifact_preserves_bytes", "Solfunmeme.Codec.importArtifact_unparsed_is_unknown", "Solfunmeme.Codec.importWithSchema_major_mismatch", "Solfunmeme.Codec.linked_append_step", "Solfunmeme.Codec.openEnvelope_rejects_tamper", "Solfunmeme.Codec.openEnvelope_seal", "Solfunmeme.Codec.provenanceChain_example"]
  , moduleObject "RequestProject/Codec/Formats.lean" ["Solfunmeme.Codec.codecs_lossless", "Solfunmeme.Codec.flatCsv_no_decoder", "Solfunmeme.Codec.flatCsv_not_injective", "Solfunmeme.Codec.ofCsv_toCsv", "Solfunmeme.Codec.ofIpdl_toIpdl", "Solfunmeme.Codec.ofText_toText", "Solfunmeme.Codec.ofXml_toXml", "Solfunmeme.Codec.ofYaml_toYaml"]
  , moduleObject "RequestProject/Codec/Hash.lean" ["Solfunmeme.Codec.canonicalSerialize_inj", "Solfunmeme.Codec.contentId_of_any_codec"]
  , moduleObject "RequestProject/Codec/Line.lean" ["Solfunmeme.Codec.RowSyntax.declaredLossiness_honest", "Solfunmeme.Codec.RowSyntax.decode_encode", "Solfunmeme.Codec.RowSyntax.parseCell_renderCell", "Solfunmeme.Codec.RowSyntax.parse_render"]
  , moduleObject "RequestProject/Codec/Model.lean" ["Solfunmeme.Codec.Lossiness.worse_eq_lossless", "Solfunmeme.Codec.ProofObject.extension_withExtension", "Solfunmeme.Codec.ProofObject.minimalProfile_withIdentity", "Solfunmeme.Codec.Status.name_injective", "Solfunmeme.Codec.Status.no_silent_conversion", "Solfunmeme.Codec.Status.ofName_name"]
  , moduleObject "RequestProject/Codec/Raw.lean" ["Solfunmeme.Codec.RawText.ingest_preserves_text", "Solfunmeme.Codec.RawText.ingest_status_not_invalid", "Solfunmeme.Codec.detect_declared", "Solfunmeme.Codec.detect_encode"]
  , moduleObject "RequestProject/Codec/Reconcile.lean" ["Solfunmeme.Codec.compareObjects_eq_equivalent_iff", "Solfunmeme.Codec.compareObjects_refl", "Solfunmeme.Codec.conflict_of_decisive_disagreement", "Solfunmeme.Codec.diff_value_mismatch", "Solfunmeme.Codec.incomplete_of_unknown", "Solfunmeme.Codec.merge_keeps_both", "Solfunmeme.Codec.resolveConflict_marks_conflict", "Solfunmeme.Codec.resolveConflict_records"]
  , moduleObject "RequestProject/Codec/Table.lean" ["Solfunmeme.Codec.decodeChildren_blocks", "Solfunmeme.Codec.decodeTable_encodeTable", "Solfunmeme.Codec.inferType_integer", "Solfunmeme.Codec.takeBlock_blockCells"]
  , moduleObject "RequestProject/Codec/Validate.lean" ["Solfunmeme.Codec.factorisation_conforms", "Solfunmeme.Codec.resolveInput_idem", "Solfunmeme.Codec.resolveInput_records", "Solfunmeme.Codec.validateStructure_nil_iff", "Solfunmeme.Codec.validateWith_records_engine", "Solfunmeme.Codec.validate_clean_of_minimal", "Solfunmeme.Codec.validation_is_not_proof"]
  , moduleObject "RequestProject/Domain/Emit.lean" ["Solfunmeme.Domain.decodeClaimsDoc_claimsDoc", "Solfunmeme.Domain.decodeDomain_cross", "Solfunmeme.Domain.decodeDomain_encodeDomain", "Solfunmeme.Domain.decodeDomain_of_codec", "Solfunmeme.Domain.decodeObjectsDoc_objectsDoc", "Solfunmeme.Domain.decodeProofsDoc_proofsDoc", "Solfunmeme.Domain.decodeRelationsDoc_relationsDoc", "Solfunmeme.Domain.domainCodecLossiness_honest", "Solfunmeme.Domain.partition_reassembles", "Solfunmeme.Domain.transcodeDomain_chain"]
  , moduleObject "RequestProject/Domain/Facts.lean" ["Solfunmeme.Domain.Data.corpus_certificates", "Solfunmeme.Domain.Data.corpus_coverage", "Solfunmeme.Domain.Data.corpus_hash_stable", "Solfunmeme.Domain.Data.corpus_roundTrip", "Solfunmeme.Domain.Data.corpus_size", "Solfunmeme.Domain.Data.corpus_wellFormed", "Solfunmeme.Domain.Data.dataset_coverage", "Solfunmeme.Domain.Data.dataset_coverage_total", "Solfunmeme.Domain.Data.dataset_cross", "Solfunmeme.Domain.Data.dataset_data_to_proof", "Solfunmeme.Domain.Data.dataset_hash_stable", "Solfunmeme.Domain.Data.dataset_ledger_covers", "Solfunmeme.Domain.Data.dataset_proof_to_data", "Solfunmeme.Domain.Data.dataset_proof_to_input", "Solfunmeme.Domain.Data.dataset_proof_to_output", "Solfunmeme.Domain.Data.dataset_roundTrip", "Solfunmeme.Domain.Data.dataset_size", "Solfunmeme.Domain.Data.dataset_unproven_are_declared", "Solfunmeme.Domain.Data.dataset_unproven_truth", "Solfunmeme.Domain.Data.dataset_wellFormed"]
  , moduleObject "RequestProject/Domain/Hash.lean" ["Solfunmeme.Domain.DomainObject.stamped_idempotent", "Solfunmeme.Domain.domainCanonical_inj", "Solfunmeme.Domain.domainHash_cross", "Solfunmeme.Domain.domainHash_of_any_codec", "Solfunmeme.Domain.objectCanonical_inj", "Solfunmeme.Domain.objectHash_stamped", "Solfunmeme.Domain.proofCanonical_inj", "Solfunmeme.Domain.unstamped_stamped"]
  , moduleObject "RequestProject/Domain/Ledger.lean" ["Solfunmeme.Domain.Domain.contradiction_is_reported", "Solfunmeme.Domain.Domain.coverageReport_bounds", "Solfunmeme.Domain.Domain.coverageReport_total", "Solfunmeme.Domain.Domain.coverage_of_proven", "Solfunmeme.Domain.Domain.data_to_proof", "Solfunmeme.Domain.Domain.graph_closed_under_converse", "Solfunmeme.Domain.Domain.graph_subset_linked", "Solfunmeme.Domain.Domain.ledger_covers_objects", "Solfunmeme.Domain.Domain.ledger_proven_is_backed", "Solfunmeme.Domain.Domain.no_contradicted_proven", "Solfunmeme.Domain.Domain.promote_not_proven", "Solfunmeme.Domain.Domain.promote_proven", "Solfunmeme.Domain.Domain.proofRefs_resolve", "Solfunmeme.Domain.Domain.proof_to_data", "Solfunmeme.Domain.Domain.proof_to_input", "Solfunmeme.Domain.Domain.proof_to_output", "Solfunmeme.Domain.Domain.proven_has_valid_proof", "Solfunmeme.Domain.Domain.uncertified_valid_is_reported", "Solfunmeme.Domain.Domain.unjustified_is_reported", "Solfunmeme.Domain.Domain.unresolved_proofRef_is_reported", "Solfunmeme.Domain.ledgerRows_not_injective", "Solfunmeme.Domain.ledger_no_decoder", "Solfunmeme.Domain.withConverses_closed"]
  , moduleObject "RequestProject/Domain/Model.lean" ["Solfunmeme.Domain.Domain.coverage_of_no_proofs", "Solfunmeme.Domain.Domain.exists_valid_proof_of_coverage", "Solfunmeme.Domain.ProofStatus.name_injective", "Solfunmeme.Domain.RelationKind.converse_involutive", "Solfunmeme.Domain.RelationKind.converse_on_proof", "Solfunmeme.Domain.RelationKind.name_injective", "Solfunmeme.Domain.TruthStatus.name_injective", "Solfunmeme.Domain.TruthStatus.no_silent_conversion", "Solfunmeme.Domain.Validation.exists_lt_checked_lt_reproduced", "Solfunmeme.Domain.Validation.name_injective", "Solfunmeme.Domain.Validation.rank_injective"]
  , moduleObject "RequestProject/Domain/Table.lean" ["Solfunmeme.Domain.decodeDomainTable_encodeDomainTable", "Solfunmeme.Domain.encodeDomainTable_inj"]
  , moduleObject "RequestProject/Federal/Apportion.lean" ["Federal.apportion_total", "Federal.baseTotal_le", "Federal.extras_le", "Federal.seats_ge_lower_quota", "Federal.seats_le_upper_quota", "Federal.senateSeats_total", "Federal.senate_equal", "Federal.small_division_overrepresented"]
  , moduleObject "RequestProject/Federal/Congress.lean" ["Federal.contested_passage_needs_majority_of_seats", "Federal.enacted_iff", "Federal.enacted_needs_both_chambers", "Federal.enactment_attainable", "Federal.house_bloc_bounded", "Federal.one_division_cannot_carry_the_senate", "Federal.one_division_cannot_enact", "Federal.overridden_iff", "Federal.overridden_needs_supermajority", "Federal.override_attainable", "Federal.quorum_attainable", "Federal.supermajority_implies_passage", "Federal.veto_sustained_of_not_super"]
  , moduleObject "RequestProject/Federal/Facts.lean" ["Federal.Union.congress_can_legislate", "Federal.Union.every_state_has_two_senators", "Federal.Union.house_apportionment", "Federal.Union.house_total", "Federal.Union.house_total_general", "Federal.Union.no_state_can_carry_the_senate", "Federal.Union.no_state_has_a_house_majority", "Federal.Union.no_state_has_a_senate_majority", "Federal.Union.seated_length", "Federal.Union.seated_nodup", "Federal.Union.seated_subset_roster", "Federal.Union.senate_apportionment", "Federal.Union.senate_passage_needs_fourteen_senators", "Federal.Union.senate_passage_needs_fourteen_signatures", "Federal.Union.senate_roll_le_26", "Federal.Union.smallest_state_overrepresented_in_the_senate", "Federal.Union.state_names_nodup", "Federal.Union.states_length", "Federal.Union.states_partition_the_roster", "Federal.Union.total_stake"]
  , moduleObject "RequestProject/Federal/Roll.lean" ["Federal.Roll.bill_must_be_tabled", "Federal.Roll.chamberTally_cast", "Federal.Roll.passage_needs_quorum_of_ballots", "Federal.Roll.passage_needs_quorum_of_senators", "Federal.Roll.rollCall_authentic", "Federal.Roll.rollCall_first_vote_wins", "Federal.Roll.rollCall_le_seats", "Federal.Roll.rollCall_nodup", "Federal.Roll.rollCall_senator"]
  , moduleObject "RequestProject/Federal/Supply.lean" ["Federal.Union.raw_apportionment_agrees", "Federal.Union.rounding_loses_less_than_a_token_per_senator", "Federal.Union.union_holds_more_than_half_the_supply", "Federal.Union.union_raw_stake", "Federal.Union.union_share_bounds", "Federal.Union.union_within_supply"]
  , moduleObject "RequestProject/Game/Commit.lean" ["Solfunmeme.Game.Commit.balance_pos_of_bit_proofs", "Solfunmeme.Game.Commit.bit_iff", "Solfunmeme.Game.Commit.chaumPedersen_complete", "Solfunmeme.Game.Commit.chaumPedersen_extract", "Solfunmeme.Game.Commit.commit_add", "Solfunmeme.Game.Commit.commit_binding", "Solfunmeme.Game.Commit.commit_pred", "Solfunmeme.Game.Commit.commit_succ", "Solfunmeme.Game.Commit.commit_sum", "Solfunmeme.Game.Commit.fromBits_lt", "Solfunmeme.Game.Commit.schnorr_complete", "Solfunmeme.Game.Commit.schnorr_extract", "Solfunmeme.Game.Commit.total_bounds"]
  , moduleObject "RequestProject/Game/Engine.lean" ["Solfunmeme.Game.balance_mono_of_holds", "Solfunmeme.Game.balance_pos", "Solfunmeme.Game.heldDays_mono", "Solfunmeme.Game.initial_run_balance_pos", "Solfunmeme.Game.minted_le_of_run", "Solfunmeme.Game.rugged_pos", "Solfunmeme.Game.run_append", "Solfunmeme.Game.run_balance_pos", "Solfunmeme.Game.run_minted", "Solfunmeme.Game.run_stake", "Solfunmeme.Game.stake_ge_of_holds", "Solfunmeme.Game.stake_mono", "Solfunmeme.Game.stake_step", "Solfunmeme.Game.stake_strict_of_day", "Solfunmeme.Game.unlocks_mono", "Solfunmeme.Game.unlocks_mono_run", "Solfunmeme.Game.unrle_rle", "Solfunmeme.Game.verify_claimOf", "Solfunmeme.Game.verify_sound", "Solfunmeme.Game.worldBalance_pos"]
  , moduleObject "RequestProject/Game/Stake.lean" ["Solfunmeme.Game.duration_eq_heldDays", "Solfunmeme.Game.holder_stake_ge", "Solfunmeme.Game.run_heldDays_eq", "Solfunmeme.Game.run_stake_eq_sum", "Solfunmeme.Game.stake_eq_tokenDays", "Solfunmeme.Game.stake_le_of_daily_le", "Solfunmeme.Game.stake_lt_of_day", "Solfunmeme.Game.stake_mono_append"]
  , moduleObject "RequestProject/IndexFeed/Facts.lean" ["Solfunmeme.IndexFeed.aesop_docs", "Solfunmeme.IndexFeed.docIds_nodup", "Solfunmeme.IndexFeed.docs_count", "Solfunmeme.IndexFeed.feed_length", "Solfunmeme.IndexFeed.feed_seqs", "Solfunmeme.IndexFeed.hapax_count", "Solfunmeme.IndexFeed.mathlib_docs", "Solfunmeme.IndexFeed.missing_length", "Solfunmeme.IndexFeed.no_solfunmeme_document", "Solfunmeme.IndexFeed.postings_count", "Solfunmeme.IndexFeed.postings_nodup", "Solfunmeme.IndexFeed.solfunmeme_no_hits", "Solfunmeme.IndexFeed.term_count"]
  , moduleObject "RequestProject/IndexFeed/Model.lean" ["Solfunmeme.IndexFeed.allPostings_nodup_of_blocks", "Solfunmeme.IndexFeed.docIds_head_disjoint", "Solfunmeme.IndexFeed.docIds_nodup_of_blocks", "Solfunmeme.IndexFeed.exists_chunk_of_mem_allPostings", "Solfunmeme.IndexFeed.hits_append", "Solfunmeme.IndexFeed.hits_mono", "Solfunmeme.IndexFeed.mem_docIds_of_posting", "Solfunmeme.IndexFeed.mem_hits", "Solfunmeme.IndexFeed.missing_eq_nil_iff"]
  , moduleObject "RequestProject/Ledger/Behaviour.lean" ["Ledger.burnt_le_fees", "Ledger.corroborated_of_sound", "Ledger.countVerdict_total", "Ledger.nExits_le_nSells", "Ledger.nMoves_eq", "Ledger.nOk_add_nFail", "Ledger.ne_of_discriminates", "Ledger.verdictS_summaryOf", "Ledger.verdict_bad_iff", "Ledger.verdict_bad_of_inert", "Ledger.verdict_bad_of_neverSettles", "Ledger.verdict_good_iff"]
  , moduleObject "RequestProject/Ledger/PopulationFacts.lean" ["Ledger.PopulationFacts.busy_bad", "Ledger.PopulationFacts.busy_good_is_6VzidcFh", "Ledger.PopulationFacts.no_good_heavy", "Ledger.PopulationFacts.population_agrees_with_sample", "Ledger.PopulationFacts.population_bad", "Ledger.PopulationFacts.population_good", "Ledger.PopulationFacts.population_size", "Ledger.PopulationFacts.summaryOf_w_J3Z1AfTD", "Ledger.PopulationFacts.txs_of_bad"]
  , moduleObject "RequestProject/Ledger/SampleFacts.lean" ["Ledger.SampleFacts.sample_burnt", "Ledger.SampleFacts.sample_failed", "Ledger.SampleFacts.sample_failuresAreInert", "Ledger.SampleFacts.sample_fees", "Ledger.SampleFacts.sample_live", "Ledger.SampleFacts.sample_size", "Ledger.SampleFacts.sample_slippage", "Ledger.SampleFacts.sample_verdict", "Ledger.SampleFacts.sample_wf_sound"]
  , moduleObject "RequestProject/Ledger/Verdicts.lean" ["Ledger.Verdicts.coSlots_wDLp2YLYc_wHCb7hLss", "Ledger.Verdicts.coSlots_wJ3Z1AfTD_w686oaTQa", "Ledger.Verdicts.fleet_fees_wEN4kMnNm", "Ledger.Verdicts.no_exotic_fee_wJ3Z1AfTD", "Ledger.Verdicts.w_21nALQTX_verdict", "Ledger.Verdicts.w_27XHsdyK_verdict", "Ledger.Verdicts.w_4AnrXS8H_verdict", "Ledger.Verdicts.w_5ssQGkUG_verdict", "Ledger.Verdicts.w_686oaTQa_verdict", "Ledger.Verdicts.w_6DAHh1hH_verdict", "Ledger.Verdicts.w_6VzidcFh_theory_sound", "Ledger.Verdicts.w_6VzidcFh_verdict", "Ledger.Verdicts.w_7QeRHULB_verdict", "Ledger.Verdicts.w_7dGrdJRY_verdict", "Ledger.Verdicts.w_9XvBYSKe_verdict", "Ledger.Verdicts.w_C9YvTztk_verdict", "Ledger.Verdicts.w_CMbBM2BW_verdict", "Ledger.Verdicts.w_DLp2YLYc_verdict", "Ledger.Verdicts.w_EN4kMnNm_verdict", "Ledger.Verdicts.w_F4oEKU8a_verdict", "Ledger.Verdicts.w_FTotzvz1_verdict", "Ledger.Verdicts.w_FwqxwTYu_verdict", "Ledger.Verdicts.w_G1uSQxpf_verdict", "Ledger.Verdicts.w_HCb7hLss_verdict", "Ledger.Verdicts.w_HxkTYMtx_theory_sound", "Ledger.Verdicts.w_HxkTYMtx_verdict", "Ledger.Verdicts.w_J3Z1AfTD_theory_discriminates_7QeRHULB", "Ledger.Verdicts.w_J3Z1AfTD_theory_sound", "Ledger.Verdicts.w_J3Z1AfTD_verdict", "Ledger.Verdicts.w_x3pJA2jG_verdict"]
  , moduleObject "RequestProject/Market/Challenge.lean" ["RequestProject.Market.all_samples_card", "RequestProject.Market.challenge_agrees_with_proof_market", "RequestProject.Market.challenged_of_not_spec", "RequestProject.Market.diligent_court_pays_iff_spec", "RequestProject.Market.diligent_paid_implies_spec", "RequestProject.Market.escape_geometric_bound", "RequestProject.Market.escape_ratio_le", "RequestProject.Market.escape_step", "RequestProject.Market.escaping_lt_all", "RequestProject.Market.escaping_samples", "RequestProject.Market.escaping_samples_card", "RequestProject.Market.escaping_samples_geometric", "RequestProject.Market.full_audit_detects", "RequestProject.Market.honest_claim_paid", "RequestProject.Market.mul_choose_pred", "RequestProject.Market.optimistic_payout_conserves", "RequestProject.Market.optimistic_pays_for_wrong_result", "RequestProject.Market.silent_watch_always_pays", "RequestProject.Market.slashed_iff_challenged", "RequestProject.Market.unchallenged_of_spec", "RequestProject.Market.undetected_iff_disjoint"]
  , moduleObject "RequestProject/Market/Compute.lean" ["RequestProject.Market.bond_forfeited_iff", "RequestProject.Market.honest_operator_paid", "RequestProject.Market.paid_implies_spec", "RequestProject.Market.payout_conserves", "RequestProject.Market.payout_of_no_submission", "RequestProject.Market.proof_market_immune_to_collusion", "RequestProject.Market.revenue_mono", "RequestProject.Market.revenue_only_from_verified", "RequestProject.Market.revenue_zero_of_none_accepted", "RequestProject.Market.vote_market_pays_for_wrong_result"]
  , moduleObject "RequestProject/Market/Examples.lean" ["RequestProject.Market.watchdog_diligent"]
  , moduleObject "RequestProject/Market/Fit.lean" ["RequestProject.Market.FitMachine.closed_of_fitClosed", "RequestProject.Market.FitMachine.fitClosed_substitute", "RequestProject.Market.clearance_bounds", "RequestProject.Market.deadline_met_iff", "RequestProject.Market.fits_iff_worst_case", "RequestProject.Market.fits_of_tighter_shaft", "RequestProject.Market.fits_of_wider_hole", "RequestProject.Market.sum_mem", "RequestProject.Market.width_sum"]
  , moduleObject "RequestProject/Market/Private.lean" ["RequestProject.Market.Blindable.recover", "RequestProject.Market.card_mask_fiber", "RequestProject.Market.mask_bijective", "RequestProject.Market.mask_blindEquiv", "RequestProject.Market.private_verified_result", "RequestProject.Market.unmask_mask"]
  , moduleObject "RequestProject/Market/Roadmap.lean" ["RequestProject.Market.vaicuPlan_correct", "RequestProject.Market.vaicu_blocked", "RequestProject.Market.vaicu_done_before_open", "RequestProject.Market.vaicu_done_is_downward_closed", "RequestProject.Market.vaicu_every_done_has_evidence", "RequestProject.Market.vaicu_no_cycle", "RequestProject.Market.vaicu_progress", "RequestProject.Market.vaicu_ready", "RequestProject.Market.vaicu_ready_nonempty", "RequestProject.Market.vaicu_wishes_are_new"]
  , moduleObject "RequestProject/Market/Stake.lean" ["RequestProject.Market.failure_count_le_stake_div_bond", "RequestProject.Market.failures_bounded", "RequestProject.Market.liar_earns_nothing", "RequestProject.Market.run_of_all_accepted", "RequestProject.Market.stake_plus_forfeits"]
  , moduleObject "RequestProject/Market/Supply.lean" ["RequestProject.Market.artifact_of_digest", "RequestProject.Market.deployed_eq_rebuild", "RequestProject.Market.deployed_of_identity_tools", "RequestProject.Market.deployed_of_matching_digest", "RequestProject.Market.deployed_satisfies", "RequestProject.Market.deployed_satisfies_all", "RequestProject.Market.deployed_unique", "RequestProject.Market.rebuild_of_identity_tools", "RequestProject.Market.tampering_invalidates_chain"]
  , moduleObject "RequestProject/Market/Twin.lean" ["RequestProject.Market.Assembly.closed_substitute", "RequestProject.Market.Assembly.closed_substitute_list", "RequestProject.Market.Assembly.guarantee_preserved", "RequestProject.Market.Assembly.guaranteed_subset_substitute", "RequestProject.Market.Assembly.provided_subset_substitute", "RequestProject.Market.Assembly.required_substitute_subset", "RequestProject.Market.Assembly.unions_mono", "RequestProject.Market.Refines.refl", "RequestProject.Market.Refines.trans"]
  , moduleObject "RequestProject/Meme/Proofs/Commit.lean" ["Meme.Commit.chain_injective", "Meme.Engine.run_commit", "Meme.Engine.segment_compose", "Meme.Engine.segment_verify_iff", "Meme.Engine.segment_verify_run", "Meme.Engine.tape_binding"]
  , moduleObject "RequestProject/Meme/Proofs/Engine.lean" ["Meme.Engine.Claim.verified_blocks_pos", "Meme.Engine.Claim.verified_memes_le", "Meme.Engine.Claim.verified_mint_backed", "Meme.Engine.Claim.verify_iff", "Meme.Engine.blocks_pos", "Meme.Engine.code_injective", "Meme.Engine.ledger_run", "Meme.Engine.memes_le_length", "Meme.Engine.mint_backed", "Meme.Engine.parts_backed", "Meme.Engine.run_append", "Meme.Engine.stake_strict_mono", "Meme.Engine.stake_ticks", "Meme.Engine.unlocked_mono"]
  , moduleObject "RequestProject/Meme/Proofs/Share.lean" ["Meme.Share.decodeShare_encodeShare", "Meme.Share.encodeShare_injective"]
  , moduleObject "RequestProject/Meme/Proofs/Stake.lean" ["Meme.Stake.payout_add_days", "Meme.Stake.payout_mono_memes", "Meme.Stake.payout_strict_mono_days", "Meme.Stake.payout_ticks"]
  , moduleObject "RequestProject/Meme/Proofs/Stego.lean" ["Meme.Stego.embedBits_preserves_upper", "Meme.Stego.extractBits_embedBits", "Meme.Stego.extractBytes_embedBytes"]
  , moduleObject "RequestProject/Meme/Proofs/Svg.lean" ["Meme.Svg.chunk_mem_of_mem_chunks", "Meme.Svg.render_eq"]
  , moduleObject "RequestProject/Meme/Proofs/Tape.lean" ["Meme.Tape.decodeTape_encodeTape", "Meme.Tape.encodeTape_injective"]
  , moduleObject "RequestProject/Mesh/Bundle.lean" ["Mesh.Runtime.rehost_rejected", "Mesh.Runtime.run_sound", "Mesh.Runtime.runtime_swap_detected", "Mesh.Runtime.strip_detected", "Mesh.Runtime.tamper_changes_digest", "Mesh.Runtime.unweave_weave", "Mesh.Runtime.weave_injective"]
  , moduleObject "RequestProject/Mesh/Chart.lean" ["Mesh.Chart.render_of_message_eq", "Mesh.Chart.x_le_width", "Mesh.Chart.y_le_height"]
  , moduleObject "RequestProject/Mesh/Codec.lean" ["Mesh.Codec.assemble_eq_none_of_missing", "Mesh.Codec.assemble_fragments", "Mesh.Codec.decodeCard_encodeCard", "Mesh.Codec.ofCode_toCode", "Mesh.Codec.ofUrl_toUrl"]
  , moduleObject "RequestProject/Mesh/Examples.lean" ["Mesh.Examples.page_wf", "Mesh.Examples.signed2_cardWf"]
  , moduleObject "RequestProject/Mesh/Net.lean" ["Mesh.deliver_mono", "Mesh.deliver_routed", "Mesh.deliver_sound", "Mesh.exchange_sound", "Mesh.sync_all_eq", "Mesh.sync_idem_toFinset"]
  , moduleObject "RequestProject/Mesh/Post.lean" ["Mesh.cited_data_cannot_be_swapped", "Mesh.cosign_preserves_view", "Mesh.cosign_verify", "Mesh.import_binds_source", "Mesh.message_injective", "Mesh.tamper_needs_new_signature", "Mesh.valid_cosigners_signed_view", "Mesh.valid_signers_hold_keys", "Mesh.verified_signers_nodup", "Mesh.verifyPost_iff"]
  , moduleObject "RequestProject/Mesh/Quote.lean" ["Mesh.Quote.score_inj", "Mesh.ingest_toFinset", "Mesh.latest_max", "Mesh.latest_mem", "Mesh.mem_merge", "Mesh.merge_assoc_toFinset", "Mesh.merge_comm_toFinset", "Mesh.merge_idem_toFinset", "Mesh.vwap_mem_range"]
  , moduleObject "RequestProject/Mesh/Skin.lean" ["Mesh.Skin.reveal_hide"]
  , moduleObject "RequestProject/Onchain/CaptureFacts.lean" ["Solana.CaptureFacts.dataset_files_are_captures_of_the_mint", "Solana.CaptureFacts.dataset_has_no_largest_accounts", "Solana.CaptureFacts.fixtureHolders_sortedDesc", "Solana.CaptureFacts.fixtureSnapshot_holders", "Solana.CaptureFacts.fixtureSupply_render", "Solana.CaptureFacts.fixture_herfindahl_bound", "Solana.CaptureFacts.fixture_holders_amounts", "Solana.CaptureFacts.fixture_ingested_share_bounds", "Solana.CaptureFacts.fixture_ingested_share_eq", "Solana.CaptureFacts.fixture_merges_two_accounts", "Solana.CaptureFacts.fixture_no_nakamoto", "Solana.CaptureFacts.fixture_shared_wallet_balance", "Solana.CaptureFacts.fixture_top1_share_bounds", "Solana.CaptureFacts.fixture_top1_share_eq", "Solana.CaptureFacts.fixture_topK_saturates", "Solana.CaptureFacts.fixture_total_conserved", "Solana.CaptureFacts.mint_authorities_are_null", "Solana.CaptureFacts.mint_isValidPubkey", "Solana.CaptureFacts.realActivity_counts", "Solana.CaptureFacts.realActivity_ranges", "Solana.CaptureFacts.realSignatures_all_timed", "Solana.CaptureFacts.realSupply_render", "Solana.CaptureFacts.realSupply_render_roundtrip"]
  , moduleObject "RequestProject/Onchain/Proofs/Base58.lean" ["Solana.Base58.decode_encode", "Solana.Base58.encode_injective", "Solana.Base58.isValidPubkey_solfunmeme"]
  , moduleObject "RequestProject/Onchain/Proofs/Decimal.lean" ["Solana.Decimal.parse_append_renderParts", "Solana.Decimal.renderParts_snd_length"]
  , moduleObject "RequestProject/Onchain/Proofs/Digits.lean" ["Solana.Digits.digitsBE_normalized", "Solana.Digits.digitsBE_ofDigitsBE", "Solana.Digits.ofDigitsBE_digitsBE"]
  , moduleObject "RequestProject/Onchain/Proofs/Holders.lean" ["Solana.Holders.aggregate_nodup", "Solana.Holders.herfindahl_le_one", "Solana.Holders.nakamoto_eq_none_of_le_half", "Solana.Holders.nakamoto_spec", "Solana.Holders.sortedDesc_perm", "Solana.Holders.topKShare_mono", "Solana.Holders.totalAmount_aggregate"]
  , moduleObject "RequestProject/Pricing/Infra.lean" ["RequestProject.Pricing.annualGeneratedTokens_value", "RequestProject.Pricing.annual_bill_commodity", "RequestProject.Pricing.annual_bill_frontier", "RequestProject.Pricing.bill_linear_in_nodes", "RequestProject.Pricing.buying_wins_at_our_volume", "RequestProject.Pricing.checking_exceeds_maintenance", "RequestProject.Pricing.checking_monthly", "RequestProject.Pricing.h100Year_value", "RequestProject.Pricing.hosting_dominates", "RequestProject.Pricing.hosting_one_node", "RequestProject.Pricing.infra_year_under_one_h100_year", "RequestProject.Pricing.links_exceed_nodes", "RequestProject.Pricing.maintenance_range", "RequestProject.Pricing.month_in_h200_hours", "RequestProject.Pricing.monthly_bill_commodity", "RequestProject.Pricing.monthly_bill_frontier", "RequestProject.Pricing.own_serving_breakeven", "RequestProject.Pricing.sneakernet_node_is_storage_only", "RequestProject.Pricing.state_under_a_gigabyte", "RequestProject.Pricing.storage_one_node", "RequestProject.Pricing.thousand_replicas", "RequestProject.Pricing.whole_operation_annual", "RequestProject.Pricing.whole_operation_share"]
  , moduleObject "RequestProject/Pricing/Model.lean" ["RequestProject.Pricing.Effort.quote_linear", "RequestProject.Pricing.Effort.quote_mono", "RequestProject.Pricing.Effort.quote_scale_draftMultiplier", "RequestProject.Pricing.Effort.split_add", "RequestProject.Pricing.Gateway.charge_eq_add_fee", "RequestProject.Pricing.Gateway.charge_routeCost_le", "RequestProject.Pricing.MakeOrBuy.buying_always_wins", "RequestProject.Pricing.MakeOrBuy.makeCost_le_buyCost_iff", "RequestProject.Pricing.Offer.blended_eq", "RequestProject.Pricing.Offer.blended_mem_Icc", "RequestProject.Pricing.Offer.quote_add", "RequestProject.Pricing.Offer.quote_mono_outputTokens", "RequestProject.Pricing.RateCard.bill_add", "RequestProject.Pricing.RateCard.bill_mono", "RequestProject.Pricing.RateCard.bill_nonneg", "RequestProject.Pricing.RateCard.bill_sum", "RequestProject.Pricing.routeCost_cons_le", "RequestProject.Pricing.routeCost_le_blend", "RequestProject.Pricing.routeCost_le_of_mem", "RequestProject.Pricing.routeCost_mem", "RequestProject.Pricing.routeCost_nonneg"]
  , moduleObject "RequestProject/Pricing/Prices.lean" ["RequestProject.Pricing.commodity_bill_le_frontier", "RequestProject.Pricing.effortOf_add", "RequestProject.Pricing.effortOf_one", "RequestProject.Pricing.extremes_listed", "RequestProject.Pricing.priceList_length", "RequestProject.Pricing.priceList_wellFormed", "RequestProject.Pricing.rates_wellFormed"]
  , moduleObject "RequestProject/Pricing/Wishes.lean" ["RequestProject.Pricing.attribution_exhausts_the_corpus", "RequestProject.Pricing.bill_is_additive", "RequestProject.Pricing.dearest_open_wish", "RequestProject.Pricing.doubling_waste_doubles_tokens", "RequestProject.Pricing.every_wish_costs_something", "RequestProject.Pricing.frontier_over_commodity", "RequestProject.Pricing.granted_bill_commodity", "RequestProject.Pricing.granted_bill_frontier", "RequestProject.Pricing.granted_lines", "RequestProject.Pricing.measured_iff_granted", "RequestProject.Pricing.open_bill_commodity", "RequestProject.Pricing.open_bill_frontier", "RequestProject.Pricing.open_dearer_than_granted", "RequestProject.Pricing.open_lines", "RequestProject.Pricing.open_lines_exceed_granted", "RequestProject.Pricing.open_programme_in_h200_hours", "RequestProject.Pricing.pricing_covers_the_roadmap", "RequestProject.Pricing.programme_bill_commodity", "RequestProject.Pricing.programme_bill_frontier", "RequestProject.Pricing.programme_share_of_marketplace", "RequestProject.Pricing.programme_splits", "RequestProject.Pricing.programme_under_three_h100_hours", "RequestProject.Pricing.ready_bill_commodity", "RequestProject.Pricing.ready_bill_frontier", "RequestProject.Pricing.ready_lines", "RequestProject.Pricing.sized_counts"]
  , moduleObject "RequestProject/Review/KernelChecked.lean" ["Review.KernelChecked.dao_weight_val", "Review.KernelChecked.minimum_passage", "Review.KernelChecked.monster_product", "Review.KernelChecked.senator_vote_valid", "Review.KernelChecked.tier_sorted"]
  , moduleObject "RequestProject/Senate/Desk.lean" ["Senate.Desk.acceptable_iff", "Senate.Desk.account_claim_requires_key", "Senate.Desk.attach_binds_trade", "Senate.Desk.attach_news_exists", "Senate.Desk.comment_binds_parent", "Senate.Desk.comment_parent_exists", "Senate.Desk.commentsOn_unknown_empty", "Senate.Desk.commentsOn_verify", "Senate.Desk.desk_message_ne_badge_challenge", "Senate.Desk.exampleNews_message", "Senate.Desk.exampleNews_wf", "Senate.Desk.mem_newsForTrade", "Senate.Desk.message_binds_author", "Senate.Desk.message_injective", "Senate.Desk.message_ne_of_ne", "Senate.Desk.mutual_link_unique", "Senate.Desk.post_append_only", "Senate.Desk.post_dangling_rejected", "Senate.Desk.post_replay_rejected", "Senate.Desk.post_valid", "Senate.Desk.share_carries_original", "Senate.Desk.share_target_exists", "Senate.Desk.tampering_needs_new_signature", "Senate.Desk.valid_author_holds_key", "Senate.Desk.valid_author_signed", "Senate.Desk.valid_id_unique", "Senate.Desk.valid_ids_nodup", "Senate.Desk.valid_no_self_reference", "Senate.Desk.valid_refs_resolve", "Senate.Desk.valid_seq_strict_mono", "Senate.Desk.valid_verify", "Senate.Desk.valid_wf"]
  , moduleObject "RequestProject/Senate/Roster.lean" ["Senate.Desk.roster_length", "Senate.Desk.roster_nodup", "Senate.Desk.roster_sepFree", "Senate.Desk.senateOnly_authentic", "Senate.Desk.wf_of_senator"]
  , moduleObject "RequestProject/Senate/Wire.lean" ["Senate.Wire.joinFields_head", "Senate.Wire.joinFields_injective", "Senate.Wire.joinFields_ne_of_head_ne", "Senate.Wire.natStr_injective", "Senate.Wire.natStr_sepFree"]
  , moduleObject "RequestProject/Sync/Lattice.lean" ["Solfunmeme.Sync.card_le_card_merge", "Solfunmeme.Sync.converged_pairwise", "Solfunmeme.Sync.convergence", "Solfunmeme.Sync.delivered_append", "Solfunmeme.Sync.final_subset_total", "Solfunmeme.Sync.headKey_empty", "Solfunmeme.Sync.headKey_mem", "Solfunmeme.Sync.headKey_mono", "Solfunmeme.Sync.headKey_run", "Solfunmeme.Sync.head_congr", "Solfunmeme.Sync.heads_agree", "Solfunmeme.Sync.merge_assoc", "Solfunmeme.Sync.merge_comm", "Solfunmeme.Sync.merge_idem", "Solfunmeme.Sync.merge_mono", "Solfunmeme.Sync.merge_self_right", "Solfunmeme.Sync.one_bundle_suffices", "Solfunmeme.Sync.online_offline_commute", "Solfunmeme.Sync.run_append", "Solfunmeme.Sync.run_append_self", "Solfunmeme.Sync.run_cons_dup", "Solfunmeme.Sync.run_eq_merge_delivered", "Solfunmeme.Sync.run_mono_state", "Solfunmeme.Sync.run_pair_comm", "Solfunmeme.Sync.run_perm_invariant", "Solfunmeme.Sync.run_retag", "Solfunmeme.Sync.subset_merge_left", "Solfunmeme.Sync.subset_run", "Solfunmeme.Sync.transports_interchangeable"]
  , moduleObject "RequestProject/Tickets/DL.lean" ["SFM.DL.FModel.consistent_of_checkKB", "SFM.DL.FModel.eval_iff", "SFM.DL.KB.not_entails_bot_of_consistent"]
  , moduleObject "RequestProject/Tickets/Model.lean" ["SFM.Tickets.corpusModel_checks", "SFM.Tickets.kb_consistent", "SFM.Tickets.kb_no_absurd_individual"]
  , moduleObject "RequestProject/Tickets/Plan.lean" ["SFM.Tickets.Plan.acyclic", "SFM.Tickets.Plan.mem_tickets_of_prereq", "SFM.Tickets.Plan.rank_lt_of_depEdge", "SFM.Tickets.Plan.rank_lt_of_transGen", "SFM.Tickets.plan_blocked_go_last", "SFM.Tickets.plan_covers_actionable", "SFM.Tickets.plan_covers_wishes", "SFM.Tickets.plan_entails_wish", "SFM.Tickets.plan_length", "SFM.Tickets.plan_no_cycle", "SFM.Tickets.plan_nodup", "SFM.Tickets.plan_only_wishes", "SFM.Tickets.plan_phase_counts", "SFM.Tickets.plan_phases_monotone", "SFM.Tickets.plan_phases_named", "SFM.Tickets.plan_prereq_before", "SFM.Tickets.plan_prereqs_are_the_links", "SFM.Tickets.plan_prereqs_earlier", "SFM.Tickets.plan_prereqs_present", "SFM.Tickets.plan_priority_within_phase", "SFM.Tickets.plan_quickWins_before_epics", "SFM.Tickets.plan_schedules_the_wish_list"]
  , moduleObject "RequestProject/Tickets/Queries.lean" ["SFM.Tickets.actionable_blocked_disjoint", "SFM.Tickets.actionable_sub_unclaimed", "SFM.Tickets.actionable_sub_wishListItem", "SFM.Tickets.answered_sub_discussed", "SFM.Tickets.blocked_waits", "SFM.Tickets.blocked_wishes", "SFM.Tickets.community_wishes", "SFM.Tickets.count_actionable", "SFM.Tickets.count_answered_dormant", "SFM.Tickets.count_communityWishes", "SFM.Tickets.count_epics", "SFM.Tickets.count_needsSpec", "SFM.Tickets.count_proofWishes", "SFM.Tickets.count_quickWins", "SFM.Tickets.count_rewarded", "SFM.Tickets.count_tickets", "SFM.Tickets.count_wishes", "SFM.Tickets.discussed_iff_spoken", "SFM.Tickets.discussion_counts", "SFM.Tickets.endorsed_tickets", "SFM.Tickets.extension_wishListItem", "SFM.Tickets.kb_size", "SFM.Tickets.mem_wishNumbers_entails", "SFM.Tickets.no_waiting_wishes", "SFM.Tickets.proof_wishes", "SFM.Tickets.quickWin_sub_ready", "SFM.Tickets.quick_wins", "SFM.Tickets.ready_eq_actionable", "SFM.Tickets.ready_sub_actionable", "SFM.Tickets.ready_sub_wishListItem", "SFM.Tickets.ready_waiting_disjoint", "SFM.Tickets.rewarded_sub_wishListItem", "SFM.Tickets.size_counts", "SFM.Tickets.small_large_disjoint", "SFM.Tickets.ticket10_rewarded", "SFM.Tickets.ticket13_not_wish", "SFM.Tickets.ticket175_proofWish", "SFM.Tickets.ticket42_communityWish", "SFM.Tickets.ticket_has_author", "SFM.Tickets.unclaimed_sub_wishListItem", "SFM.Tickets.waiting_has_open_prerequisite", "SFM.Tickets.wishListItem_not_closed", "SFM.Tickets.wishListItem_sub_open", "SFM.Tickets.wishListItem_sub_ticket", "SFM.Tickets.wishNumbers_length", "SFM.Tickets.wish_entailed", "SFM.Tickets.wish_not_sub_rewarded", "SFM.Tickets.wish_topic_counts"]
  , moduleObject "RequestProject/Upstream/Bills.lean" ["filter_subset"]
  , moduleObject "RequestProject/Upstream/FederalGov.lean" ["minimum_passage"]
  , moduleObject "RequestProject/Upstream/FederalModel.lean" ["monster_product", "tier_sorted"]
  , moduleObject "RequestProject/Upstream/Governance.lean" ["dao_weight_val", "weight_pos"]
  , moduleObject "RequestProject/Upstream/VotingProtocol.lean" ["senator_vote_valid"]
  ]

/-- The number of audited theorems, as scanned. -/
def catalogProofCount : Nat := 869

/-- The number of source modules holding them. -/
def catalogModuleCount : Nat := 86

/-- Audited theorems whose proof is kernel-checked outright. -/
def catalogKernelCount : Nat := 836

/-- Audited theorems that also rest on evaluation by the compiler. -/
def catalogNativeCount : Nat := 33

end Solfunmeme.Domain.Data
