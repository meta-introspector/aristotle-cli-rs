/-
  AxiomAudit.lean — what the proof schema depends on.

  The commitment scheme is abstract: `Binding` and `Hiding` are named
  hypotheses of the theorems that need them, not axioms, so no theorem here
  assumes the security of any deployed proof system.  Nothing uses `sorry`,
  `native_decide`, an `axiom` declaration or `@[implemented_by]`.
-/

import RequestProject.Solfunmeme.ZKP.Schema

namespace ZKP.AxiomAudit

/-! ### `RequestProject/ZKP/Merkle.lean` -/

#print axioms ZKP.open_unique
#print axioms ZKP.hiding_gives_indistinguishable_commitments
#print axioms ZKP.verify_of_mem
#print axioms ZKP.mem_of_verify

/-! ### `RequestProject/ZKP/Schema.lean` -/

#print axioms ZKP.complete
#print axioms ZKP.complete_rosterMember
#print axioms ZKP.sound
#print axioms ZKP.sound_binds
#print axioms ZKP.roster_membership_sound
#print axioms ZKP.standing_threshold_hides_the_value
#print axioms ZKP.ownership_threshold_hides_the_cap_table
#print axioms ZKP.statements_are_decidable
#print axioms ZKP.schema_length
#print axioms ZKP.schema_names_nodup
#print axioms ZKP.schema_covers_every_statement

end ZKP.AxiomAudit
