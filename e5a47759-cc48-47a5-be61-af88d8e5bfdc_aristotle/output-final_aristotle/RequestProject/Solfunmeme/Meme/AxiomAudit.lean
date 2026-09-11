import RequestProject.Solfunmeme.Meme.Proofs.Commit
import RequestProject.Solfunmeme.Meme.Proofs.Engine
import RequestProject.Solfunmeme.Meme.Proofs.Share
import RequestProject.Solfunmeme.Meme.Proofs.Stake
import RequestProject.Solfunmeme.Meme.Proofs.Stego
import RequestProject.Solfunmeme.Meme.Proofs.Svg
import RequestProject.Solfunmeme.Meme.Proofs.Tape

/-!
# Axiom audit for the FHME game

Every theorem about the deterministic game engine — replay soundness, the
economy ledger, monotone badges, staking, the share/tape codes, the stego
carrier and checkpoint disclosures — is an ordinary proof: it rests on at most
`propext`, `Classical.choice` and `Quot.sound`.  Nothing here is checked by
evaluation, so this file should print no `Lean.ofReduceBool`.
-/

namespace Meme.AxiomAudit

-- the engine and its ledger
#print axioms Meme.Engine.run_append
#print axioms Meme.Engine.code_injective
#print axioms Meme.Engine.ledger_run
#print axioms Meme.Engine.mint_backed
#print axioms Meme.Engine.parts_backed
#print axioms Meme.Engine.memes_le_length
#print axioms Meme.Engine.blocks_pos
#print axioms Meme.Engine.unlocked_mono
#print axioms Meme.Engine.stake_ticks
#print axioms Meme.Engine.stake_strict_mono

-- published claims
#print axioms Meme.Engine.Claim.verify_iff
#print axioms Meme.Engine.Claim.verified_blocks_pos
#print axioms Meme.Engine.Claim.verified_mint_backed
#print axioms Meme.Engine.Claim.verified_memes_le

-- staking payout
#print axioms Meme.Stake.payout_ticks
#print axioms Meme.Stake.payout_add_days
#print axioms Meme.Stake.payout_strict_mono_days
#print axioms Meme.Stake.payout_mono_memes

-- share codes, replay tapes, badge cards
#print axioms Meme.Share.decodeShare_encodeShare
#print axioms Meme.Share.encodeShare_injective
#print axioms Meme.Tape.decodeTape_encodeTape
#print axioms Meme.Tape.encodeTape_injective
#print axioms Meme.Svg.render_eq
#print axioms Meme.Svg.chunk_mem_of_mem_chunks

-- the stego carrier
#print axioms Meme.Stego.extractBits_embedBits
#print axioms Meme.Stego.extractBytes_embedBytes
#print axioms Meme.Stego.embedBits_preserves_upper

-- commitments and checkpoint disclosure
#print axioms Meme.Commit.chain_injective
#print axioms Meme.Engine.run_commit
#print axioms Meme.Engine.segment_verify_run
#print axioms Meme.Engine.segment_verify_iff
#print axioms Meme.Engine.segment_compose
#print axioms Meme.Engine.tape_binding

end Meme.AxiomAudit
