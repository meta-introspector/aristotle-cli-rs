import RequestProject.Solfunmeme.Game.Engine
import RequestProject.Solfunmeme.Game.Stake
import RequestProject.Solfunmeme.Game.Commit

/-!
# Axiom audit for the game

Every result about the game, printed with the axioms it rests on.  As
elsewhere in this project nothing here uses `native_decide` or an axiom of our
own: at worst these proofs use `propext`, `Classical.choice` and `Quot.sound`.
-/

namespace Solfunmeme.Game

-- the balance never reaches zero
#print axioms rugged_pos
#print axioms worldBalance_pos
#print axioms balance_pos
#print axioms run_balance_pos
#print axioms initial_run_balance_pos

-- the meme counter counts memes
#print axioms run_minted
#print axioms minted_le_of_run

-- stake is token-days
#print axioms stake_step
#print axioms run_stake
#print axioms stake_mono
#print axioms balance_mono_of_holds
#print axioms heldDays_mono
#print axioms stake_ge_of_holds
#print axioms stake_strict_of_day

-- the bridge to the dataset's own token-day model
#print axioms run_stake_eq_sum
#print axioms run_heldDays_eq
#print axioms stake_eq_tokenDays
#print axioms duration_eq_heldDays
#print axioms stake_mono_append
#print axioms stake_lt_of_day
#print axioms stake_le_of_daily_le
#print axioms holder_stake_ge

-- unlocks
#print axioms unlocks_mono
#print axioms unlocks_mono_run

-- the claim format
#print axioms run_append
#print axioms unrle_rle
#print axioms verify_claimOf
#print axioms verify_sound

end Solfunmeme.Game

namespace Solfunmeme.Game.Commit

-- commitments
#print axioms commit_add
#print axioms commit_succ
#print axioms commit_sum
#print axioms commit_binding
#print axioms commit_pred

-- sigma protocols
#print axioms schnorr_complete
#print axioms schnorr_extract
#print axioms chaumPedersen_complete
#print axioms chaumPedersen_extract

-- bits, ranges, positivity
#print axioms bit_iff
#print axioms fromBits_lt
#print axioms balance_pos_of_bit_proofs
#print axioms total_bounds

end Solfunmeme.Game.Commit
