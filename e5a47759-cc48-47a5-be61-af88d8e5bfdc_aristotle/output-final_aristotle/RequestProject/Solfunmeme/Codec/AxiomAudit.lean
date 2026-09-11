import RequestProject.Solfunmeme.Codec.Conformance

/-!
# Axiom audit for the standard proof codec

Every load-bearing result of `RequestProject/Codec/`, printed with the axioms it
rests on.  As elsewhere in this project the intent is that nothing here needs
`native_decide`: the codecs are ordinary functions on strings and lists, so at
worst these use `propext`, `Classical.choice` and `Quot.sound`.
-/

namespace Solfunmeme.Codec

-- the character layer
#print axioms unescape_escape
#print axioms escape_no_sep
#print axioms splitFields_joinFields
#print axioms splitTerm_joinTerm
#print axioms decList_encList
#print axioms decPairs_encPairs

-- the canonical model
#print axioms Status.ofName_name
#print axioms Status.name_injective
#print axioms Status.no_silent_conversion
#print axioms Lossiness.worse_eq_lossless
#print axioms ProofObject.minimalProfile_withIdentity
#print axioms ProofObject.extension_withExtension

-- the tabular projection
#print axioms takeBlock_blockCells
#print axioms decodeChildren_blocks
#print axioms decodeTable_encodeTable
#print axioms inferType_integer

-- the adapter layer
#print axioms RowSyntax.parseCell_renderCell
#print axioms RowSyntax.parse_render
#print axioms RowSyntax.decode_encode
#print axioms RowSyntax.declaredLossiness_honest

-- the five codecs
#print axioms ofIpdl_toIpdl
#print axioms ofXml_toXml
#print axioms ofCsv_toCsv
#print axioms ofYaml_toYaml
#print axioms ofText_toText
#print axioms codecs_lossless
#print axioms flatCsv_not_injective
#print axioms flatCsv_no_decoder

-- raw text and detection
#print axioms RawText.ingest_preserves_text
#print axioms RawText.ingest_status_not_invalid
#print axioms detect_encode
#print axioms detect_declared

-- canonical serialization
#print axioms canonicalSerialize_inj
#print axioms contentId_of_any_codec

-- validation and resolution
#print axioms validateStructure_nil_iff
#print axioms validate_clean_of_minimal
#print axioms validation_is_not_proof
#print axioms resolveInput_records
#print axioms resolveInput_idem
#print axioms validateWith_records_engine
#print axioms factorisation_conforms

-- reconciliation
#print axioms compareObjects_refl
#print axioms compareObjects_eq_equivalent_iff
#print axioms diff_value_mismatch
#print axioms conflict_of_decisive_disagreement
#print axioms incomplete_of_unknown
#print axioms resolveConflict_records
#print axioms resolveConflict_marks_conflict
#print axioms merge_keeps_both

-- exchange
#print axioms chainLossiness_eq_lossless_iff
#print axioms linked_append_step
#print axioms openEnvelope_seal
#print axioms openEnvelope_rejects_tamper
#print axioms provenanceChain_example
#print axioms importArtifact_preserves_bytes
#print axioms importArtifact_of_encoded
#print axioms importArtifact_unparsed_is_unknown
#print axioms exportArtifact_roundTrips
#print axioms importWithSchema_major_mismatch

-- conformance and the definition of done
#print axioms suite_roundTrips
#print axioms importArtifact_status_from_document
#print axioms compareObjects_of_semanticEq
#print axioms level2_typed
#print axioms definition_of_done

end Solfunmeme.Codec
