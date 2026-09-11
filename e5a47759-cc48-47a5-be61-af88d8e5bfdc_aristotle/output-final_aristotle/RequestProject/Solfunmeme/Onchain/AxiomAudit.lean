import RequestProject.Solfunmeme.Onchain.CaptureFacts
import RequestProject.Solfunmeme.Onchain.Proofs.Base58
import RequestProject.Solfunmeme.Onchain.Proofs.Decimal
import RequestProject.Solfunmeme.Onchain.Proofs.Digits
import RequestProject.Solfunmeme.Onchain.Proofs.Holders

/-!
# Axiom audit for the on-chain ingestion layer

The theory of the pipeline — digit expansions, base 58, decimal rendering and
the holder metrics — is ordinary mathematics: those proofs rest on at most
`propext`, `Classical.choice` and `Quot.sound`.

The facts about the *shipped captures* in
`RequestProject/Onchain/CaptureFacts.lean` are finite checks.  Those that only
have to add up natural numbers are kernel-checked too; those that have to run
the base-58 decoder, decimal rendering, filename matching or the merge sort go
through `native_decide`, because those definitions use well-founded recursion
that the kernel will not unfold, and therefore also rest on
`Lean.ofReduceBool`.  This file prints all three groups so the difference is on
the record.
-/

namespace Solana.AxiomAudit

-- the theory: kernel-checked
#print axioms Solana.Digits.ofDigitsBE_digitsBE
#print axioms Solana.Digits.digitsBE_ofDigitsBE
#print axioms Solana.Digits.digitsBE_normalized
#print axioms Solana.Base58.decode_encode
#print axioms Solana.Base58.encode_injective
#print axioms Solana.Decimal.parse_append_renderParts
#print axioms Solana.Decimal.renderParts_snd_length
#print axioms Solana.Holders.totalAmount_aggregate
#print axioms Solana.Holders.aggregate_nodup
#print axioms Solana.Holders.sortedDesc_perm
#print axioms Solana.Holders.topKShare_mono
#print axioms Solana.Holders.herfindahl_le_one
#print axioms Solana.Holders.nakamoto_spec
#print axioms Solana.Holders.nakamoto_eq_none_of_le_half

-- the captures: kernel-checked finite arithmetic
#print axioms Solana.CaptureFacts.mint_authorities_are_null
#print axioms Solana.CaptureFacts.realActivity_counts
#print axioms Solana.CaptureFacts.realActivity_ranges
#print axioms Solana.CaptureFacts.realSignatures_all_timed
#print axioms Solana.CaptureFacts.fixture_merges_two_accounts
#print axioms Solana.CaptureFacts.fixture_total_conserved
#print axioms Solana.CaptureFacts.fixture_shared_wallet_balance
#print axioms Solana.CaptureFacts.fixture_holders_amounts

-- the captures: checks that evaluate strings or the sort
#print axioms Solana.Base58.isValidPubkey_solfunmeme
#print axioms Solana.CaptureFacts.dataset_files_are_captures_of_the_mint
#print axioms Solana.CaptureFacts.dataset_has_no_largest_accounts
#print axioms Solana.CaptureFacts.mint_isValidPubkey
#print axioms Solana.CaptureFacts.realSupply_render
#print axioms Solana.CaptureFacts.realSupply_render_roundtrip
#print axioms Solana.CaptureFacts.fixtureSnapshot_holders
#print axioms Solana.CaptureFacts.fixtureHolders_sortedDesc
#print axioms Solana.CaptureFacts.fixtureSupply_render

-- metrics of the ingested (synthetic) distribution
#print axioms Solana.CaptureFacts.fixture_ingested_share_eq
#print axioms Solana.CaptureFacts.fixture_ingested_share_bounds
#print axioms Solana.CaptureFacts.fixture_top1_share_eq
#print axioms Solana.CaptureFacts.fixture_top1_share_bounds
#print axioms Solana.CaptureFacts.fixture_topK_saturates
#print axioms Solana.CaptureFacts.fixture_herfindahl_bound
#print axioms Solana.CaptureFacts.fixture_no_nakamoto

end Solana.AxiomAudit
