import RequestProject.Solfunmeme.Token.Credits
import RequestProject.Solfunmeme.Token.Facts
import RequestProject.Solfunmeme.Token.Governance
import RequestProject.Solfunmeme.Token.Treasury

/-!
# Axiom audit for the token layer

Every result of the token development, printed with the axioms it rests on.
Nothing here uses `native_decide` or an axiom of our own: at worst these proofs
use `propext`, `Classical.choice` and `Quot.sound`, and several depend on no
axiom at all.
-/

namespace SFM.Token

-- the book: fixed supply
#print axioms Book.genesis_issued
#print axioms Book.genesis_outstanding
#print axioms Book.step_issued
#print axioms Book.run_issued
#print axioms Book.fixed_cap
#print axioms Book.outstanding_add_burned

-- the book: the supply only falls, and only by burning
#print axioms Book.step_outstanding_le
#print axioms Book.step_burned_ge
#print axioms Book.run_outstanding_le
#print axioms Book.run_outstanding_eq
#print axioms Book.burn_strict_decrease

-- the book: locking is not burning
#print axioms Book.lock_outstanding
#print axioms Book.unlock_outstanding
#print axioms Book.lock_burned
#print axioms Book.lock_circulating

-- the book: the proof is the payment
#print axioms Book.mint_of_unproved
#print axioms Book.mint_of_proved
#print axioms Book.mint_of_unaffordable
#print axioms Book.mintRun_eq
#print axioms Book.badge_count_le

-- governance: why a holder locks rather than burns
#print axioms Holder.lockAll_weight
#print axioms Holder.lockAll_circulating
#print axioms Holder.burn_weight_le
#print axioms Holder.burn_weight_lt
#print axioms register_lock_totalWeight
#print axioms yesWeight_le_totalWeight
#print axioms no_double_vote
#print axioms not_carries_of_empty
#print axioms carries_mono
#print axioms carries_of_majority

-- credits: accrual
#print axioms accrued_eq_rate_mul_tokenDays
#print axioms accrued_append
#print axioms accrued_mono
#print axioms accrued_lt
#print axioms accrual_does_not_touch_the_book

-- credits: no double spending
#print axioms Account.spend_honoured
#print axioms Account.spend_honoured_subset
#print axioms Account.settle_honoured_subset
#print axioms Account.spend_replay_rejected
#print axioms Account.settle_none_of_mem_honoured
#print axioms Account.settle_of_duplicate_ids
#print axioms Account.spend_spent_le_earned
#print axioms Account.settle_earned_eq
#print axioms Account.settle_spent_le_earned
#print axioms Account.ofHistory_spent_le_earned

-- credits: what settlement costs
#print axioms rollupFee_le_onchainFee
#print axioms rollupFee_lt_onchainFee
#print axioms fee_saving
#print axioms amortisedFee_antitone
#print axioms amortisedFee_tendsto_zero

-- the treasury: funding out of yield
#print axioms Position.settle_principal
#print axioms Position.yield_add_principal
#print axioms Position.yield_add_years
#print axioms Position.budget_le_yield
#print axioms Position.budget_mono
#print axioms Position.funds_iff
#print axioms bootstrapSpendUSD_eq
#print axioms bootstrapFloatUSD_eq
#print axioms stake_funds_the_plan
#print axioms stake_threshold_bounds
#print axioms stake_funds_the_float
#print axioms float_threshold_bounds
#print axioms principal_untouched

-- the chain: what the mint's own capture says
#print axioms supply_no_longer_growable
#print axioms captured_supply_le_nominal
#print axioms gap_to_nominal
#print axioms gap_is_under_a_hundredth_of_a_percent
#print axioms chainBook_issued
#print axioms chain_supply_capped
#print axioms chain_supply_only_falls

end SFM.Token
