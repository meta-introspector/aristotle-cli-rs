import RequestProject.Solfunmeme.Mesh.Cli
import RequestProject.Solfunmeme.Mesh.Examples

/-!
# What the mesh theorems rest on

Every result the game relies on is listed here with `#print axioms`.  Building
this file prints the trusted base of each one; nothing in `Mesh.*` uses `sorry`
or any axiom beyond Lean's own `propext`, `Classical.choice` and `Quot.sound`.
-/

namespace Mesh.Audit

/-! ## Boards and the mesh -/

#print axioms Mesh.mem_merge
#print axioms Mesh.merge_comm_toFinset
#print axioms Mesh.merge_assoc_toFinset
#print axioms Mesh.merge_idem_toFinset
#print axioms Mesh.ingest_toFinset
#print axioms Mesh.Quote.score_inj
#print axioms Mesh.latest_mem
#print axioms Mesh.latest_max
#print axioms Mesh.vwap_mem_range
#print axioms Mesh.exchange_sound
#print axioms Mesh.deliver_mono
#print axioms Mesh.deliver_sound
#print axioms Mesh.deliver_routed
#print axioms Mesh.sync_all_eq
#print axioms Mesh.sync_idem_toFinset

/-! ## Posts, signatures and co-signatures -/

#print axioms Mesh.message_injective
#print axioms Mesh.verifyPost_iff
#print axioms Mesh.valid_cosigners_signed_view
#print axioms Mesh.valid_signers_hold_keys
#print axioms Mesh.tamper_needs_new_signature
#print axioms Mesh.cosign_verify
#print axioms Mesh.cosign_preserves_view
#print axioms Mesh.verified_signers_nodup
#print axioms Mesh.import_binds_source
#print axioms Mesh.cited_data_cannot_be_swapped

/-! ## The wire: bytes, links, QR codes -/

#print axioms Mesh.Codec.decodeCard_encodeCard
#print axioms Mesh.Codec.ofCode_toCode
#print axioms Mesh.Codec.ofUrl_toUrl
#print axioms Mesh.Codec.assemble_fragments
#print axioms Mesh.Codec.assemble_eq_none_of_missing

/-! ## The runtime, the chart and the meme -/

#print axioms Mesh.Runtime.unweave_weave
#print axioms Mesh.Runtime.weave_injective
#print axioms Mesh.Runtime.run_sound
#print axioms Mesh.Runtime.tamper_changes_digest
#print axioms Mesh.Runtime.strip_detected
#print axioms Mesh.Runtime.runtime_swap_detected
#print axioms Mesh.Runtime.rehost_rejected
#print axioms Mesh.Chart.render_of_message_eq
#print axioms Mesh.Chart.x_le_width
#print axioms Mesh.Chart.y_le_height
#print axioms Mesh.Skin.reveal_hide

/-! ## The worked examples -/

#print axioms Mesh.Examples.signed2_cardWf
#print axioms Mesh.Examples.page_wf

end Mesh.Audit
