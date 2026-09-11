import RequestProject.Solfunmeme.Domain.Cli

/-!
# Axiom audit for the domain data codec

The theory — the vocabularies, the tabular projection, the five codecs, the
canonical hash, the validation, the graph and the ledger — is ordinary
mathematics and is kernel-checked: those proofs rest on at most `propext`,
`Classical.choice` and `Quot.sound`.

The facts about the two *shipped packages* are finite checks over lists of
strings.  They are evaluated rather than reduced by the kernel — string
comparison of a few thousand records does not unfold in reasonable time — so
they also rest on `Lean.ofReduceBool`.  This file prints both groups so the
difference is on the record, exactly as the other audits in this repository do.
-/

namespace Solfunmeme.Domain.AxiomAudit

-- the vocabularies: no status can be silently converted into another
#print axioms Solfunmeme.Domain.TruthStatus.no_silent_conversion
#print axioms Solfunmeme.Domain.TruthStatus.name_injective
#print axioms Solfunmeme.Domain.ProofStatus.name_injective
#print axioms Solfunmeme.Domain.Validation.name_injective
#print axioms Solfunmeme.Domain.Validation.rank_injective
#print axioms Solfunmeme.Domain.Validation.exists_lt_checked_lt_reproduced
#print axioms Solfunmeme.Domain.RelationKind.name_injective
#print axioms Solfunmeme.Domain.RelationKind.converse_involutive
#print axioms Solfunmeme.Domain.RelationKind.converse_on_proof

-- the canonical projection and the five codecs
#print axioms Solfunmeme.Domain.decodeDomainTable_encodeDomainTable
#print axioms Solfunmeme.Domain.encodeDomainTable_inj
#print axioms Solfunmeme.Domain.decodeDomain_encodeDomain
#print axioms Solfunmeme.Domain.decodeDomain_of_codec
#print axioms Solfunmeme.Domain.decodeDomain_cross
#print axioms Solfunmeme.Domain.transcodeDomain_chain
#print axioms Solfunmeme.Domain.decodeObjectsDoc_objectsDoc
#print axioms Solfunmeme.Domain.decodeProofsDoc_proofsDoc
#print axioms Solfunmeme.Domain.decodeRelationsDoc_relationsDoc
#print axioms Solfunmeme.Domain.decodeClaimsDoc_claimsDoc
#print axioms Solfunmeme.Domain.partition_reassembles
#print axioms Solfunmeme.Domain.domainCodecLossiness_honest

-- the canonical hash
#print axioms Solfunmeme.Domain.objectCanonical_inj
#print axioms Solfunmeme.Domain.proofCanonical_inj
#print axioms Solfunmeme.Domain.domainCanonical_inj
#print axioms Solfunmeme.Domain.domainHash_of_any_codec
#print axioms Solfunmeme.Domain.domainHash_cross
#print axioms Solfunmeme.Domain.unstamped_stamped
#print axioms Solfunmeme.Domain.DomainObject.stamped_idempotent
#print axioms Solfunmeme.Domain.objectHash_stamped

-- validation, and what a clean validation guarantees
#print axioms Solfunmeme.Domain.Domain.unjustified_is_reported
#print axioms Solfunmeme.Domain.Domain.contradiction_is_reported
#print axioms Solfunmeme.Domain.Domain.unresolved_proofRef_is_reported
#print axioms Solfunmeme.Domain.Domain.uncertified_valid_is_reported
#print axioms Solfunmeme.Domain.Domain.proven_has_valid_proof
#print axioms Solfunmeme.Domain.Domain.no_contradicted_proven
#print axioms Solfunmeme.Domain.Domain.proofRefs_resolve
#print axioms Solfunmeme.Domain.Domain.coverage_of_proven
#print axioms Solfunmeme.Domain.Domain.promote_not_proven
#print axioms Solfunmeme.Domain.Domain.promote_proven

-- the graph, in both directions
#print axioms Solfunmeme.Domain.withConverses_closed
#print axioms Solfunmeme.Domain.Domain.graph_closed_under_converse
#print axioms Solfunmeme.Domain.Domain.data_to_proof
#print axioms Solfunmeme.Domain.Domain.proof_to_data
#print axioms Solfunmeme.Domain.Domain.proof_to_input
#print axioms Solfunmeme.Domain.Domain.proof_to_output
#print axioms Solfunmeme.Domain.Domain.graph_subset_linked

-- the ledger and the coverage report
#print axioms Solfunmeme.Domain.Domain.ledger_covers_objects
#print axioms Solfunmeme.Domain.Domain.ledger_proven_is_backed
#print axioms Solfunmeme.Domain.ledgerRows_not_injective
#print axioms Solfunmeme.Domain.ledger_no_decoder
#print axioms Solfunmeme.Domain.Domain.coverageReport_total
#print axioms Solfunmeme.Domain.Domain.coverageReport_bounds
#print axioms Solfunmeme.Domain.Domain.exists_valid_proof_of_coverage
#print axioms Solfunmeme.Domain.Domain.coverage_of_no_proofs

-- the two shipped packages: finite checks, evaluated
#print axioms Solfunmeme.Domain.Data.dataset_wellFormed
#print axioms Solfunmeme.Domain.Data.dataset_size
#print axioms Solfunmeme.Domain.Data.dataset_coverage
#print axioms Solfunmeme.Domain.Data.dataset_unproven_are_declared
#print axioms Solfunmeme.Domain.Data.dataset_unproven_truth
#print axioms Solfunmeme.Domain.Data.corpus_wellFormed
#print axioms Solfunmeme.Domain.Data.corpus_size
#print axioms Solfunmeme.Domain.Data.corpus_coverage
#print axioms Solfunmeme.Domain.Data.corpus_certificates

-- and what follows for them from the general theorems, without evaluation
#print axioms Solfunmeme.Domain.Data.dataset_ledger_covers
#print axioms Solfunmeme.Domain.Data.dataset_coverage_total
#print axioms Solfunmeme.Domain.Data.dataset_roundTrip
#print axioms Solfunmeme.Domain.Data.dataset_cross
#print axioms Solfunmeme.Domain.Data.dataset_hash_stable
#print axioms Solfunmeme.Domain.Data.corpus_roundTrip
#print axioms Solfunmeme.Domain.Data.corpus_hash_stable
#print axioms Solfunmeme.Domain.Data.dataset_data_to_proof
#print axioms Solfunmeme.Domain.Data.dataset_proof_to_data
#print axioms Solfunmeme.Domain.Data.dataset_proof_to_input
#print axioms Solfunmeme.Domain.Data.dataset_proof_to_output

-- the tail-recursive cut the compiler substitutes for the specification
#print axioms Solfunmeme.Codec.splitC_eq_splitCTR

end Solfunmeme.Domain.AxiomAudit
