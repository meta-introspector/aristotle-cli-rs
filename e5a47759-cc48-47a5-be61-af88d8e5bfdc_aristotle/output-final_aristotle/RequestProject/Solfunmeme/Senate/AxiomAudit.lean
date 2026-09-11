/-
  AxiomAudit.lean — what the senators' desk results depend on.

  Every theorem of `RequestProject/Senate/` printed below should report only
  the three standard axioms `propext`, `Classical.choice`, `Quot.sound` (many
  report fewer).  Nothing in this directory uses `sorry`, `native_decide`, an
  `axiom` declaration or `@[implemented_by]`.
-/

import RequestProject.Solfunmeme.Senate.Roster

namespace Senate

/-! ### The wire encoding -/

#print axioms Senate.Wire.natStr_injective
#print axioms Senate.Wire.natStr_sepFree
#print axioms Senate.Wire.joinFields_injective
#print axioms Senate.Wire.joinFields_head
#print axioms Senate.Wire.joinFields_ne_of_head_ne

/-! ### The record protocol -/

#print axioms Senate.Desk.message_injective
#print axioms Senate.Desk.message_ne_of_ne
#print axioms Senate.Desk.acceptable_iff
#print axioms Senate.Desk.post_append_only
#print axioms Senate.Desk.post_valid
#print axioms Senate.Desk.post_replay_rejected
#print axioms Senate.Desk.post_dangling_rejected

/-! ### The log -/

#print axioms Senate.Desk.valid_verify
#print axioms Senate.Desk.valid_wf
#print axioms Senate.Desk.valid_author_holds_key
#print axioms Senate.Desk.valid_author_signed
#print axioms Senate.Desk.valid_ids_nodup
#print axioms Senate.Desk.valid_id_unique
#print axioms Senate.Desk.valid_refs_resolve
#print axioms Senate.Desk.valid_no_self_reference
#print axioms Senate.Desk.valid_seq_strict_mono

/-! ### Comments, shares, attachments -/

#print axioms Senate.Desk.comment_parent_exists
#print axioms Senate.Desk.share_target_exists
#print axioms Senate.Desk.attach_news_exists
#print axioms Senate.Desk.share_carries_original
#print axioms Senate.Desk.commentsOn_verify
#print axioms Senate.Desk.commentsOn_unknown_empty
#print axioms Senate.Desk.mem_newsForTrade

/-! ### Tampering and domain separation -/

#print axioms Senate.Desk.tampering_needs_new_signature
#print axioms Senate.Desk.attach_binds_trade
#print axioms Senate.Desk.comment_binds_parent
#print axioms Senate.Desk.message_binds_author
#print axioms Senate.Desk.account_claim_requires_key
#print axioms Senate.Desk.mutual_link_unique
#print axioms Senate.Desk.desk_message_ne_badge_challenge

/-! ### The roster, and the worked record -/

#print axioms Senate.Desk.roster_length
#print axioms Senate.Desk.roster_nodup
#print axioms Senate.Desk.roster_sepFree
#print axioms Senate.Desk.wf_of_senator
#print axioms Senate.Desk.senateOnly_authentic
#print axioms Senate.Desk.exampleNews_message
#print axioms Senate.Desk.exampleNews_wf

end Senate
