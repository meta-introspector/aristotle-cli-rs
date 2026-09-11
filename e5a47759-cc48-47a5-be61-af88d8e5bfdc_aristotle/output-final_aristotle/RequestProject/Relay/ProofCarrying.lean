import RequestProject.Kernel.Serialize
import RequestProject.Kernel.Prove
import RequestProject.Relay.Capacity
import RequestProject.Relay.Commit

/-!
# Proof-carrying programs

The relay's cargo channel carries arbitrary bytes around the whole ring and out
of any stage.  This file points it at the thing worth carrying: *proofs*.

A proof script of the externalised engine (`RequestProject.Kernel`) serialises
to printable ASCII, which is exactly what the payload can encode, so a script
can be loaded into the relay as cargo.  What is proved here is that the round
trip is lossless and that the guarantee survives it:

* `Relay.proof_recoverable` — the script read out of *any* of the programs, in
  any of the languages, decodes to the script that was loaded;
* `Relay.proof_survives_cycle` — a full trip around the ring returns the
  program it started from, proof included;
* `stages_transport_proof` — for the concrete twenty-two-stage relay: whatever
  the engine accepted before the journey it accepts after it, and what it
  proves is a tautology.  A single program in any one of twenty-two languages
  is therefore a self-contained, checkable proof.
* `readCargo_eq_of_respond` — **the commitment names the cargo.**  Two programs
  that answer every "what is your `k`-th payload digit?" challenge alike carry
  the same proof.  That is what makes the digest quotable: a reader who can run
  any one program, in any language, can confirm the bundle is the one that was
  published, without a Lean toolchain.
-/

namespace RequestProject.Relay

open RequestProject.Kernel (Script Form check check_tautology Tautology prove prove_complete)

namespace Relay

variable {R : Relay}

/-- Load a relay with a proof script as its cargo. -/
def withProof (R : Relay) (script : Script) : Relay :=
  R.withCargo (Script.enc script)

@[simp] theorem withProof_size (R : Relay) (script : Script) :
    (R.withProof script).size = R.size := withCargo_size R _

/-- **A proof travels.** The serialised script can be read back out of any
program of the loaded relay. -/
theorem proof_carried (h : R.WF) (script : Script) (i : Nat) :
    readCargo (Script.enc script).length ((R.withProof script).prog i)
      = some (Script.enc script) :=
  readCargo_prog h (Script.enc_codeable script).1 (Script.enc_codeable script).2 i

/-- **A proof arrives intact.** Reading the cargo out of any program and
decoding it returns the very script that was loaded. -/
theorem proof_recoverable (h : R.WF) (script : Script) (i : Nat) :
    (readCargo (Script.enc script).length ((R.withProof script).prog i)).bind Script.dec
      = some script := by
  rw [proof_carried h script i, Option.bind_some, Script.dec_enc]

/-- **The proof goes all the way around.** -/
theorem proof_survives_cycle (h : R.WF) (script : Script) (i : Nat) (hi : i < R.size) :
    runN (R.withProof script).size (R.withProof script).size i ((R.withProof script).prog i)
        = some ((R.withProof script).prog i)
      ∧ (readCargo (Script.enc script).length ((R.withProof script).prog i)).bind Script.dec
        = some script := by
  refine ⟨?_, proof_recoverable h script i⟩
  exact (cargo_survives_cycle h (Script.enc_codeable script).1
    (Script.enc_codeable script).2 i hi).1

end Relay

/-! ## The commitment names the cargo -/

/-- Reading the cargo out of a text only ever looks at the text's payload
digits. -/
theorem readCargo_eq_bind (n : Nat) (t : List Char) :
    readCargo n t = (openPayload t).bind
      (fun d => (decode d).bind fun ch => ((splitOnChar sep ch)[1]?).bind
        fun b => some (b.drop (b.length - n))) := by
  simp only [readCargo, openPayload]
  cases extract t <;> simp

/-- **The challenge answers bind the cargo.**  Two programs that answer every
challenge about their payload identically carry exactly the same cargo — so the
commitment published beside a proof bundle names that bundle and no other. -/
theorem readCargo_eq_of_respond {t u : List Char} {a b : List Char} (n : Nat)
    (ht : openPayload t = some a) (hu : openPayload u = some b)
    (h : ∀ k, respond t k = respond u k) : readCargo n t = readCargo n u := by
  have hab : a = b := payload_eq_of_respond ht hu h
  rw [readCargo_eq_bind, readCargo_eq_bind, ht, hu, hab]

/-! ## The twenty-two-stage relay -/

/-- **A single program is a complete, checkable proof.**  Load the relay with a
script the engine accepts; then every one of the twenty-two programs carries it,
the script read out of any of them is the script that went in, the engine still
accepts it, and what it proves is true under every valuation. -/
theorem stages_transport_proof (script : Script) (f : Form) (hf : check script = some f)
    (i : Nat) :
    (readCargo (Script.enc script).length ((stages.withProof script).prog i)).bind Script.dec
        = some script
      ∧ check script = some f
      ∧ Tautology f :=
  ⟨Relay.proof_recoverable stages_wf script i, hf, check_tautology hf⟩

/-- **The engine finds the proof and the relay carries it.**  For any formula
true under every valuation, the prover returns a script, the loaded relay puts
it inside all twenty-two programs, the script read out of any one of them is the
script the prover produced, and it still proves the formula.  Nothing between
the statement and the twenty-two programs is done by hand. -/
theorem stages_transport_found_proof (f : Form) (hf : Tautology f) :
    ∃ script : Script, prove f = some script ∧ check script = some f ∧
      ∀ i, (readCargo (Script.enc script).length ((stages.withProof script).prog i)).bind
        Script.dec = some script := by
  obtain ⟨script, hprove, hcheck⟩ := prove_complete hf
  exact ⟨script, hprove, hcheck, fun i => Relay.proof_recoverable stages_wf script i⟩

/-- The loaded relay still has twenty-two stages, and the cycle still closes. -/
theorem stages_proof_cycle (script : Script) (i : Nat) (hi : i < 22) :
    runN 22 22 i ((stages.withProof script).prog i) = some ((stages.withProof script).prog i) := by
  have hi' : i < stages.size := by rw [stages_size]; exact hi
  have := (Relay.proof_survives_cycle stages_wf script i hi').1
  simpa [Relay.withProof_size, stages_size] using this

end RequestProject.Relay
