import RequestProject.Relay.Shapes
import RequestProject.Relay.Commit
import RequestProject.Relay.Capacity
import RequestProject.Relay.Seed
import RequestProject.Relay.ProofCarrying
import RequestProject.Relay.Recover
import RequestProject.Kernel.Vectors
import RequestProject.Kernel.Prove
import RequestProject.Kernel.Independence

/-!
# Axiom audit of the relay

Building this module prints, for every headline theorem of the relay, the
axioms it depends on.  They are the standard three (`propext`,
`Classical.choice`, `Quot.sound`); the shape theorems need only `propext`.
Nothing here uses `native_decide`, so no compiler-evaluation axiom appears: the
well-formedness of the twenty-two concrete programs is checked by the kernel.
-/

namespace RequestProject.Relay

-- the abstract relay
#print axioms Relay.host_prog
#print axioms Relay.host_self
#print axioms Relay.run_prog
#print axioms Relay.runN_size
#print axioms Relay.rebuildAll_prog
#print axioms stages_readSize
#print axioms stages_rebuild_all

-- data shapes
#print axioms Shape.parse_render
#print axioms Shape.commute
#print axioms Shapes.round_trip
#print axioms Shapes.interchange

-- the twenty-two concrete programs
#print axioms stages_wf
#print axioms program_host
#print axioms program_self
#print axioms program_step
#print axioms relay_cycle
#print axioms program_carries_sources

-- cargo: carrying the repository's own sources around the relay
#print axioms Relay.readCargo_prog
#print axioms Relay.cargo_survives_cycle
#print axioms stages_carry_cargo
#print axioms stages_cargo_cycle
#print axioms stages_cargo_unbounded

-- the bootstrap: builders recovered from a program's own payload
#print axioms rebuild_eq_host
#print axioms Relay.recover_prog
#print axioms Relay.bootstrap_fixed_point
#print axioms Relay.boot_cycle
#print axioms Relay.loaded_self_hosting
#print axioms cost_le_of_budget

-- the seed: the one-stage relay bootstrap.sh starts from
#print axioms seed_wf
#print axioms seed_quine
#print axioms seed_cycle
#print axioms seed_fixed_point
#print axioms seed_bytes

-- commitment, extraction and the challenge game
#print axioms Relay.commitment_prog
#print axioms Relay.commitment_eq
#print axioms Relay.openPayload_prog
#print axioms Relay.respond_eq
#print axioms payload_eq_of_respond

-- the externalised proof engine
#print axioms RequestProject.Kernel.Provable.tautology
#print axioms RequestProject.Kernel.check_provable
#print axioms RequestProject.Kernel.check_tautology
#print axioms RequestProject.Kernel.not_proves_fls
#print axioms RequestProject.Kernel.check_subst
#print axioms RequestProject.Kernel.mutate_tautology
#print axioms RequestProject.Kernel.Script.dec_enc
#print axioms RequestProject.Kernel.Script.enc_codeable
#print axioms RequestProject.Kernel.vectors_check
#print axioms RequestProject.Kernel.Provable.of_tautology
#print axioms RequestProject.Kernel.provable_iff_tautology
#print axioms RequestProject.Kernel.check_complete
#print axioms RequestProject.Kernel.proves_iff_tautology
#print axioms RequestProject.Kernel.isTautology_iff
#print axioms RequestProject.Kernel.engine_dichotomy
#print axioms RequestProject.Kernel.prove_sound
#print axioms RequestProject.Kernel.prove_complete
#print axioms RequestProject.Kernel.prove_isSome_iff_tautology
#print axioms RequestProject.Kernel.dne_not_provableKS
#print axioms RequestProject.Kernel.axDne_independent

-- proofs carried by the programs themselves
#print axioms Relay.proof_carried
#print axioms Relay.proof_recoverable
#print axioms Relay.proof_survives_cycle
#print axioms stages_transport_proof
#print axioms stages_transport_found_proof
#print axioms readCargo_eq_of_respond

end RequestProject.Relay
