/-
# Prove2me §7–§8 — verification results, and what they do not say

Verification is an external, sandboxed compile.  Lean cannot perform it
inside this specification, and this module does not pretend to: the
verifier appears as an **abstract oracle** `Oracle = Cid → Cid → Status`,
a function of the submission address and the environment address, and
everything proved here is about the bookkeeping around it.

That the verifier really is a function of those two addresses — which is
what "reproducible" means — is a property of the deployment, not of this
model, so it appears as the explicit hypothesis `Honest`.

Proved here:

* `honest_results_agree` — two honest verifiers of the same submission in
  the same environment report the same status; disagreement is therefore
  evidence, not noise;
* `conflict_not_both_honest`, `resultFork_sound` — a conflicting pair is
  a *fork certificate* against a verifier: both results verify under its
  key, and at least one of them is not reproducible;
* `no_env_transfer` — acceptance does **not** transfer across
  environments.  This is proved, by exhibiting an oracle that accepts a
  submission in one environment and rejects it in another, so the
  transfer rule is not merely absent from the specification but unsound;
* `accepted_iff` and `accepted_names_everything` — the §17 invariant: an
  accepted result names the target theorem, the exact source, the
  environment and the verifier, and the submission behind it is a
  hole-free non-sketch that does not import its own target.  A peer can
  answer "what exactly was proved, with which code, under which
  environment, and who verified it" from local data alone;
* `accepted_determines_statement`, `accepted_determines_source` — with an
  idealised `Addressing`, those addresses pin down the actual statement
  text and the actual proof text.
-/
import RequestProject.Kant.Prove2me.Submission

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace Kant.Prove2me

open Kant Kant.Bytes Kant.Text Kant.Urania

/-! ## Results -/

/-- What a verifier reports. -/
inductive Status where
  /-- The submission compiled against the target statement. -/
  | accepted
  /-- It compiled, and the compiler rejected it. -/
  | rejected
  /-- The run failed for a reason other than the proof. -/
  | failed
  /-- The run exceeded the environment's limits. -/
  | timeout
  /-- The environment could not be reconstructed. -/
  | envUnavailable
deriving DecidableEq, Repr

/-- Wire code of a status. -/
def Status.code : Status → Nat
  | .accepted => 1
  | .rejected => 2
  | .failed => 3
  | .timeout => 4
  | .envUnavailable => 5

/-- Read a status back. -/
def Status.ofCode : Nat → Option Status
  | 1 => some .accepted
  | 2 => some .rejected
  | 3 => some .failed
  | 4 => some .timeout
  | 5 => some .envUnavailable
  | _ => none

@[simp] theorem Status.ofCode_code (s : Status) : Status.ofCode s.code = some s := by
  cases s <;> rfl

theorem Status.code_inj {a b : Status} (h : a.code = b.code) : a = b := by
  have hr := Status.ofCode_code a
  rw [h, Status.ofCode_code b] at hr
  exact (Option.some.inj hr).symm

/-- One verifier's result for one submission in one environment. -/
structure VResult where
  /-- The submission that was checked. -/
  submission : Cid
  /-- The theorem it targets. -/
  target : Cid
  /-- The environment it was checked in. -/
  environment : Cid
  /-- Who checked it. -/
  verifier : Key
  /-- What happened. -/
  status : Status
  /-- The compiler's output, kept for reproduction. -/
  diagnostics : Str
deriving DecidableEq, Repr

/-- A result is transmissible when its text is printable. -/
structure VResult.Wire (r : VResult) : Prop where
  /-- The submission address is printable. -/
  submission : IsAscii r.submission
  /-- The target address is printable. -/
  target : IsAscii r.target
  /-- The environment address is printable. -/
  environment : IsAscii r.environment
  /-- The verifier key is printable. -/
  verifier : IsAscii r.verifier
  /-- The diagnostics are printable. -/
  diagnostics : IsAscii r.diagnostics

/-- The content of a verification result. -/
def VResult.content (r : VResult) : Content :=
  ⟨.verification,
    [r.submission, r.target, r.environment, r.verifier, natField r.status.code,
      r.diagnostics]⟩

theorem VResult.content_wire {r : VResult} (h : r.Wire) : r.content.Wire := by
  intro f hf
  simp only [VResult.content, List.mem_cons] at hf
  rcases hf with rfl | rfl | rfl | rfl | rfl | hf
  · exact h.submission
  · exact h.target
  · exact h.environment
  · exact h.verifier
  · exact isAscii_natField _
  · rcases hf with rfl | hf
    · exact h.diagnostics
    · cases hf

/-- The address of a verification result. -/
def resultId (A : Addressing) (r : VResult) : Cid := idOf A r.content

/-! ## The verifier as an oracle -/

/-- The external verifier, modelled as a function of the submission
address and the environment address.  Nothing in Lean computes it. -/
abbrev Oracle := Cid → Cid → Status

/-- **The reproducibility hypothesis.**  A result is honest when it
reports what the oracle says for its `(submission, environment)` pair.
A deployment earns this by pinning the toolchain and sandboxing the run;
this module never assumes it silently. -/
def Honest (O : Oracle) (r : VResult) : Prop := r.status = O r.submission r.environment

/-- **Honest verifiers agree.**  Same submission, same environment, same
status — so two peers reverifying independently must match. -/
theorem honest_results_agree {O : Oracle} {r₁ r₂ : VResult}
    (h₁ : Honest O r₁) (h₂ : Honest O r₂)
    (hs : r₁.submission = r₂.submission) (he : r₁.environment = r₂.environment) :
    r₁.status = r₂.status := by
  rw [h₁, h₂, hs, he]

/-- Two results contradict each other about the same job. -/
def conflicting (r₁ r₂ : VResult) : Bool :=
  (r₁.submission == r₂.submission) && (r₁.environment == r₂.environment) &&
    (r₁.status != r₂.status)

/-- **A conflict is evidence.**  If two results conflict, at least one of
them is not reproducible. -/
theorem conflict_not_both_honest {O : Oracle} {r₁ r₂ : VResult}
    (h : conflicting r₁ r₂ = true) : ¬ (Honest O r₁ ∧ Honest O r₂) := by
  simp only [conflicting, Bool.and_eq_true, beq_iff_eq, bne_iff_ne, ne_eq] at h
  obtain ⟨⟨hs, he⟩, hne⟩ := h
  rintro ⟨h₁, h₂⟩
  exact hne (honest_results_agree h₁ h₂ hs he)

/-- **Acceptance does not transfer between environments.**  There is an
oracle, a submission and two environments in which the same source is
accepted and rejected.  So `Accepted(sub, A)` never licenses
`Accepted(sub, B)`; the transfer rule is unsound, not merely omitted. -/
theorem no_env_transfer :
    ∃ (O : Oracle) (sub e₁ e₂ : Cid),
      e₁ ≠ e₂ ∧ O sub e₁ = .accepted ∧ O sub e₂ = .rejected := by
  refine ⟨fun _ e => if e = ['a'] then .accepted else .rejected, ['s'], ['a'], ['b'], ?_, ?_, ?_⟩
  · decide
  · simp
  · simp

/-! ## Signed results and verifier equivocation -/

/-- A result together with the verifier's signature over it. -/
structure SignedResult (Sig : Type) where
  /-- What is claimed. -/
  result : VResult
  /-- The verifier's signature over exactly that result. -/
  signature : Sig
deriving Repr

/-- A peer accepts a result only if it verifies under the verifier's own
key. -/
def validResult {Sig : Type} (S : SigScheme Key VResult Sig) (sr : SignedResult Sig) : Bool :=
  S.verify sr.result.verifier sr.result sr.signature

/-- A verifying result is attributable to the verifier's key — and that
is all it is. -/
theorem result_authentic {Sig : Type} {S : SigScheme Key VResult Sig} {sr : SignedResult Sig}
    (h : validResult S sr = true) :
    S.signedBy sr.result.verifier sr.result sr.signature :=
  S.noForgery _ _ _ h

/-- Two signed results offered as evidence that a verifier contradicted
itself. -/
structure ResultFork (Sig : Type) where
  /-- One result. -/
  a : SignedResult Sig
  /-- The other. -/
  b : SignedResult Sig

/-- Check a claimed verifier fork: both signed by the same verifier, and
contradicting each other about the same job. -/
def checkResultFork {Sig : Type} (S : SigScheme Key VResult Sig) (f : ResultFork Sig) : Bool :=
  validResult S f.a && validResult S f.b &&
    (f.a.result.verifier == f.b.result.verifier) && conflicting f.a.result f.b.result

/-- **A verifier fork certificate is self-contained evidence.**  A
checking peer learns that this key signed both results and that at least
one of them is not reproducible — without trusting whoever handed over
the certificate. -/
theorem resultFork_sound {Sig : Type} {S : SigScheme Key VResult Sig} {O : Oracle}
    {f : ResultFork Sig} (h : checkResultFork S f = true) :
    S.signedBy f.a.result.verifier f.a.result f.a.signature ∧
      S.signedBy f.b.result.verifier f.b.result f.b.signature ∧
      f.a.result.verifier = f.b.result.verifier ∧
      ¬ (Honest O f.a.result ∧ Honest O f.b.result) := by
  simp only [checkResultFork, Bool.and_eq_true, beq_iff_eq] at h
  obtain ⟨⟨⟨ha, hb⟩, hk⟩, hc⟩ := h
  exact ⟨result_authentic ha, result_authentic hb, hk, conflict_not_both_honest hc⟩

/-! ## Acceptance -/

/-- **The acceptance gate for one result.**  Every conjunct is a check on
data the peer already holds: no network call takes part in the decision. -/
def acceptedB (tid envCid sid : Cid) (e : Env) (s : Sub) (r : VResult) : Bool :=
  proofCandidateB tid envCid e s && (r.submission == sid) && (r.target == tid) &&
    (r.environment == envCid) && (r.status == Status.accepted)

theorem accepted_iff {tid envCid sid : Cid} {e : Env} {s : Sub} {r : VResult} :
    acceptedB tid envCid sid e s r = true ↔
      (proofCandidateB tid envCid e s = true ∧ r.submission = sid ∧ r.target = tid ∧
        r.environment = envCid ∧ r.status = Status.accepted) := by
  simp only [acceptedB, Bool.and_eq_true, beq_iff_eq]
  tauto

/-- **The §17 invariant.**  From an accepted result a peer can say
exactly what was proved (`tid`, and through it the statement), with which
code (`sid`, and through it the source), under which environment
(`envCid`), and who verified it (`r.verifier`) — and knows that the
submission is not a sketch, contains no `sorry` or `admit`, and does not
import its own target. -/
theorem accepted_names_everything {tid envCid sid : Cid} {e : Env} {s : Sub} {r : VResult}
    (h : acceptedB tid envCid sid e s r = true) :
    r.target = tid ∧ r.submission = sid ∧ r.environment = envCid ∧
      r.status = Status.accepted ∧
      s.target = tid ∧ s.environment = envCid ∧ s.isSketch = false ∧
      moduleOf s.target ∉ s.declaredImports ∧
      ¬ "sorry".toList <:+: s.source ∧ ¬ "admit".toList <:+: s.source := by
  obtain ⟨hc, hsub, htar, henv, hst⟩ := accepted_iff.mp h
  have hsketch : s.isSketch = false := by
    have hc' := hc
    simp only [proofCandidateB, Bool.and_eq_true, Bool.not_eq_true'] at hc'
    exact hc'.2
  obtain ⟨ht, he, hself, hs1, hs2⟩ := proofCandidate_sound hc
  exact ⟨htar, hsub, henv, hst, ht, he, hsketch, hself, hs1, hs2⟩

/-- An accepted result about a sketch is impossible. -/
theorem accepted_not_sketch {tid envCid sid : Cid} {e : Env} {s : Sub} {r : VResult}
    (hs : s.isSketch = true) : acceptedB tid envCid sid e s r = false := by
  simp [acceptedB, sketch_is_not_a_proof (tid := tid) (envCid := envCid) (e := e) hs]

/-- With an idealised addressing, the target address in an accepted
result pins down the statement text itself. -/
theorem accepted_determines_statement (A : Addressing) {t t' : Thm}
    {envCid sid : Cid} {e : Env} {s : Sub} {r : VResult}
    (hw : t.core.Wire) (hw' : t'.core.Wire)
    (h : acceptedB (theoremId A t) envCid sid e s r = true)
    (h' : acceptedB (theoremId A t') envCid sid e s r = true) :
    t.core = t'.core := by
  have h1 := (accepted_names_everything h).1
  have h2 := (accepted_names_everything h').1
  exact theoremId_determines_core A hw hw' (h1 ▸ h2)

/-- And the submission address pins down the proof source itself. -/
theorem accepted_determines_source (A : Addressing) {tid envCid : Cid} {e : Env}
    {s s' : Sub} {r : VResult} (hw : s.Wire) (hw' : s'.Wire)
    (h : acceptedB tid envCid (subId A s) e s r = true)
    (h' : acceptedB tid envCid (subId A s') e s' r = true) :
    s.source = s'.source := by
  have h1 := (accepted_names_everything h).2.1
  have h2 := (accepted_names_everything h').2.1
  exact (subId_determines A hw hw' (h1 ▸ h2)).2.1

end Kant.Prove2me
