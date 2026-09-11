/-
# Prove2me §8 — acceptance policy

Acceptance is not a property of a proof; it is a decision a peer makes
under its own configuration.  The source specification's
`[verification]` block — `required_results`, `trusted_verifiers`,
`require_reproducible_result`, `allow_local_verifiers` — becomes a
`Policy` record here, and the decision becomes a `Bool` of data the peer
already holds.

**One correction to the source specification.**  It says
`required_results = n` without saying what is counted.  Counting
*results* is unsafe on a peer-to-peer network: a relay that delivers one
accepted result twice would satisfy `required_results = 2` for free.
What is counted here is the number of **distinct trusted verifier keys**
that endorsed the submission, so duplication is inert
(`duplicates_inert`) and "two independent verifiers" means what it says.

Proved here:

* `accepts_needs_endorsement` — a verdict of "accepted" is always backed
  by a concrete result from a concrete trusted verifier;
* `accepts_zero_never` — a policy requiring no results accepts nothing.
  There is no configuration under which acceptance is free;
* `accepts_of_mem_iff` and `peers_agree` — the verdict depends only on
  *which* results the peer holds, not on how many copies of them arrived
  or in what order.  This is the lemma the replication layer needs;
* `duplicates_inert` — redelivering a result changes nothing;
* `accepts_mono_results` — receiving more results never retracts an
  acceptance;
* `accepts_mono_verifiers` — trusting more verifiers never retracts an
  acceptance;
* `untrusted_ignored` — results from verifiers the peer does not trust,
  and results that fail the local gate, make no difference at all.  This
  is what makes injection by a relay harmless.
-/
import RequestProject.Kant.Prove2me.Verification

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace Kant.Prove2me

open Kant Kant.Text

/-! ## Counting distinct things -/

theorem dedupLen_mono {α : Type} [DecidableEq α] {l l' : List α} (h : ∀ x ∈ l, x ∈ l') :
    l.dedup.length ≤ l'.dedup.length := by
  rw [← List.card_toFinset, ← List.card_toFinset]
  apply Finset.card_le_card
  intro x hx
  simp only [List.mem_toFinset] at *
  exact h x hx

theorem dedupLen_eq {α : Type} [DecidableEq α] {l l' : List α} (h : ∀ x, x ∈ l ↔ x ∈ l') :
    l.dedup.length = l'.dedup.length :=
  le_antisymm (dedupLen_mono (fun x hx => (h x).mp hx)) (dedupLen_mono (fun x hx => (h x).mpr hx))

/-! ## The policy record -/

/-- A peer's acceptance policy. -/
structure Policy where
  /-- How many *distinct* trusted verifiers are required.  Zero accepts
  nothing. -/
  requiredResults : Nat
  /-- Whose results count. -/
  trustedVerifiers : List Key
deriving DecidableEq, Repr

/-- The results that count towards a verdict: those that pass the local
gate and come from a trusted verifier. -/
def endorsements (P : Policy) (tid envCid sid : Cid) (e : Env) (s : Sub)
    (rs : List VResult) : List VResult :=
  rs.filter (fun r => acceptedB tid envCid sid e s r && P.trustedVerifiers.contains r.verifier)

/-- The distinct verifiers behind those results. -/
def endorsingVerifiers (P : Policy) (tid envCid sid : Cid) (e : Env) (s : Sub)
    (rs : List VResult) : List Key :=
  ((endorsements P tid envCid sid e s rs).map VResult.verifier).dedup

/-- **The verdict.**  Entirely a function of local data, and of the *set*
of results held rather than of their multiplicity or order. -/
def acceptsB (P : Policy) (tid envCid sid : Cid) (e : Env) (s : Sub)
    (rs : List VResult) : Bool :=
  decide (0 < P.requiredResults) &&
    decide (P.requiredResults ≤ (endorsingVerifiers P tid envCid sid e s rs).length)

/-! ## What a verdict rests on -/

theorem mem_endorsements_iff {P : Policy} {tid envCid sid : Cid} {e : Env} {s : Sub}
    {rs : List VResult} {r : VResult} :
    r ∈ endorsements P tid envCid sid e s rs ↔
      (r ∈ rs ∧ acceptedB tid envCid sid e s r = true ∧ r.verifier ∈ P.trustedVerifiers) := by
  simp [endorsements, List.mem_filter, Bool.and_eq_true]

theorem mem_endorsingVerifiers_iff {P : Policy} {tid envCid sid : Cid} {e : Env} {s : Sub}
    {rs : List VResult} {k : Key} :
    k ∈ endorsingVerifiers P tid envCid sid e s rs ↔
      ∃ r ∈ rs, acceptedB tid envCid sid e s r = true ∧ r.verifier ∈ P.trustedVerifiers ∧
        r.verifier = k := by
  simp only [endorsingVerifiers, List.mem_dedup, List.mem_map]
  constructor
  · rintro ⟨r, hr, hk⟩
    obtain ⟨hmem, hacc, htr⟩ := mem_endorsements_iff.mp hr
    exact ⟨r, hmem, hacc, htr, hk⟩
  · rintro ⟨r, hmem, hacc, htr, hk⟩
    exact ⟨r, mem_endorsements_iff.mpr ⟨hmem, hacc, htr⟩, hk⟩

/-- **Acceptance is backed by evidence.**  Whenever a peer says
"accepted", it can name a result, from a verifier it trusts, that passes
the local gate. -/
theorem accepts_needs_endorsement {P : Policy} {tid envCid sid : Cid} {e : Env} {s : Sub}
    {rs : List VResult} (h : acceptsB P tid envCid sid e s rs = true) :
    ∃ r ∈ rs, acceptedB tid envCid sid e s r = true ∧ r.verifier ∈ P.trustedVerifiers := by
  simp only [acceptsB, Bool.and_eq_true, decide_eq_true_eq] at h
  obtain ⟨hpos, hlen⟩ := h
  have hne : endorsingVerifiers P tid envCid sid e s rs ≠ [] := by
    intro hnil
    rw [hnil] at hlen
    simp at hlen
    omega
  obtain ⟨k, hk⟩ := List.exists_mem_of_ne_nil _ hne
  obtain ⟨r, hmem, hacc, htr, _⟩ := mem_endorsingVerifiers_iff.mp hk
  exact ⟨r, hmem, hacc, htr⟩

/-- **No free acceptance.**  A policy that requires no results accepts
nothing. -/
theorem accepts_zero_never {P : Policy} (h : P.requiredResults = 0)
    {tid envCid sid : Cid} {e : Env} {s : Sub} {rs : List VResult} :
    acceptsB P tid envCid sid e s rs = false := by
  simp [acceptsB, h]

/-! ## The verdict depends only on which results are held -/

theorem endorsements_mem_mono {P : Policy} {tid envCid sid : Cid} {e : Env} {s : Sub}
    {rs rs' : List VResult} (h : ∀ r ∈ rs, r ∈ rs') :
    ∀ r ∈ endorsements P tid envCid sid e s rs, r ∈ endorsements P tid envCid sid e s rs' := by
  intro r hr
  obtain ⟨hmem, hacc, htr⟩ := mem_endorsements_iff.mp hr
  exact mem_endorsements_iff.mpr ⟨h r hmem, hacc, htr⟩

theorem endorsingVerifiers_len_mono {P : Policy} {tid envCid sid : Cid} {e : Env} {s : Sub}
    {rs rs' : List VResult} (h : ∀ r ∈ rs, r ∈ rs') :
    (endorsingVerifiers P tid envCid sid e s rs).length
      ≤ (endorsingVerifiers P tid envCid sid e s rs').length := by
  refine dedupLen_mono ?_
  intro k hk
  simp only [List.mem_map] at hk ⊢
  obtain ⟨r, hr, hk⟩ := hk
  exact ⟨r, endorsements_mem_mono h r hr, hk⟩

/-- **Two peers holding the same results agree**, whatever the order and
multiplicity of delivery. -/
theorem accepts_of_mem_iff {P : Policy} {tid envCid sid : Cid} {e : Env} {s : Sub}
    {rs rs' : List VResult} (h : ∀ r, r ∈ rs ↔ r ∈ rs') :
    acceptsB P tid envCid sid e s rs = acceptsB P tid envCid sid e s rs' := by
  unfold acceptsB
  have h1 := endorsingVerifiers_len_mono (P := P) (tid := tid) (envCid := envCid) (sid := sid)
    (e := e) (s := s) (fun r hr => (h r).mp hr)
  have h2 := endorsingVerifiers_len_mono (P := P) (tid := tid) (envCid := envCid) (sid := sid)
    (e := e) (s := s) (fun r hr => (h r).mpr hr)
  rw [le_antisymm h1 h2]

/-- Reordering the results changes nothing. -/
theorem peers_agree {P : Policy} {tid envCid sid : Cid} {e : Env} {s : Sub}
    {rs rs' : List VResult} (h : rs.Perm rs') :
    acceptsB P tid envCid sid e s rs = acceptsB P tid envCid sid e s rs' :=
  accepts_of_mem_iff (fun _ => ⟨fun hr => h.mem_iff.mp hr, fun hr => h.mem_iff.mpr hr⟩)

/-- **Duplication is inert.**  A relay that delivers the same result
again cannot push a peer over its `required_results` threshold. -/
theorem duplicates_inert {P : Policy} {tid envCid sid : Cid} {e : Env} {s : Sub}
    {rs : List VResult} {r : VResult} (hr : r ∈ rs) :
    acceptsB P tid envCid sid e s (r :: rs) = acceptsB P tid envCid sid e s rs := by
  refine accepts_of_mem_iff ?_
  intro x
  constructor
  · intro hx
    rcases List.mem_cons.mp hx with rfl | hx
    · exact hr
    · exact hx
  · intro hx
    exact List.mem_cons_of_mem _ hx

/-- Receiving more results never retracts an acceptance. -/
theorem accepts_mono_results {P : Policy} {tid envCid sid : Cid} {e : Env} {s : Sub}
    {rs rs' : List VResult} (hsub : ∀ r ∈ rs, r ∈ rs')
    (h : acceptsB P tid envCid sid e s rs = true) :
    acceptsB P tid envCid sid e s rs' = true := by
  simp only [acceptsB, Bool.and_eq_true, decide_eq_true_eq] at h ⊢
  exact ⟨h.1, le_trans h.2 (endorsingVerifiers_len_mono hsub)⟩

/-- Trusting more verifiers never retracts an acceptance. -/
theorem accepts_mono_verifiers {P P' : Policy} {tid envCid sid : Cid} {e : Env} {s : Sub}
    {rs : List VResult} (hreq : P'.requiredResults = P.requiredResults)
    (hsub : ∀ k ∈ P.trustedVerifiers, k ∈ P'.trustedVerifiers)
    (h : acceptsB P tid envCid sid e s rs = true) :
    acceptsB P' tid envCid sid e s rs = true := by
  simp only [acceptsB, Bool.and_eq_true, decide_eq_true_eq, hreq] at h ⊢
  refine ⟨h.1, le_trans h.2 ?_⟩
  refine dedupLen_mono ?_
  intro k hk
  simp only [List.mem_map] at hk ⊢
  obtain ⟨r, hr, hk⟩ := hk
  obtain ⟨hmem, hacc, htr⟩ := mem_endorsements_iff.mp hr
  exact ⟨r, mem_endorsements_iff.mpr ⟨hmem, hacc, hsub _ htr⟩, hk⟩

/-- **Injected noise is inert.**  Results that fail the local gate, or
come from verifiers the peer does not trust, do not change the verdict —
however many of them a relay delivers. -/
theorem untrusted_ignored {P : Policy} {tid envCid sid : Cid} {e : Env} {s : Sub}
    {rs junk : List VResult}
    (hjunk : ∀ r ∈ junk, acceptedB tid envCid sid e s r = false ∨
      r.verifier ∉ P.trustedVerifiers) :
    acceptsB P tid envCid sid e s (rs ++ junk) = acceptsB P tid envCid sid e s rs := by
  have hfilter : endorsements P tid envCid sid e s (rs ++ junk)
      = endorsements P tid envCid sid e s rs := by
    unfold endorsements
    rw [List.filter_append]
    have hnil : junk.filter
        (fun r => acceptedB tid envCid sid e s r &&
          P.trustedVerifiers.contains r.verifier) = [] := by
      rw [List.filter_eq_nil_iff]
      intro r hr
      rcases hjunk r hr with h | h
      · simp [h]
      · simp only [Bool.and_eq_true, List.contains_eq_mem, decide_eq_true_eq, not_and]
        intro _
        exact h
    rw [hnil, List.append_nil]
  unfold acceptsB endorsingVerifiers
  rw [hfilter]

end Kant.Prove2me
