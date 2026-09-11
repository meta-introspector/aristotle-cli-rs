/-
# Prove2me §10 — replication, and the relay that is not an authority

This is the headline module.  The relay in the source specification
carries `PUBLISH`, `FETCH`, `HAVE`, `WANT`, `ANNOUNCE`, `SUBSCRIBE`,
`QUERY` and `VERIFY`; none of those verbs appears below, because the
point is that *no* transport behaviour is allowed to matter.  What is
modelled is exactly what a peer ends up holding, and what it accepts
from it.

An adversarial relay may:

* **drop** messages (deliver fewer),
* **delay** and **reorder** them (deliver in any order),
* **duplicate** them (deliver the same message repeatedly),
* **inject** messages of its own — bodies that do not hash to the
  address they are offered under, and results signed by nobody.

`RelayRun` is precisely that: every message a peer receives was either
sent by an honest publisher or fails the peer's own local validation.

Proved here:

* `kept_results_authentic` — every result a peer keeps was signed by the
  verifier it names;
* `kept_body_matches` and `kept_body_unique` — every body a peer keeps
  re-derives the address it was offered under, and at most one body can
  do so;
* `relay_cannot_manufacture` — if a peer accepts a proof after a relay
  run, the honest publishers had already sent the evidence.  A relay
  cannot make an unaccepted submission accepted;
* `relay_cannot_change_accepted` — if in addition nothing was dropped,
  the accepted set is *exactly* what it would have been over a perfect
  channel, no matter how the relay reordered, duplicated or padded the
  stream;
* `malicious_relay_harmless` — the three above as the single statement
  the acceptance test in §18 checks.

`relay_transport_is_not_validity` states the same conclusion in the
form the source specification asks for in prose.
-/
import RequestProject.Kant.Prove2me.Graph

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace Kant.Prove2me

open Kant Kant.Text Kant.Urania

/-! ## What travels -/

/-- A message on the wire: either a body offered under an address, or a
signed verification result. -/
inductive Msg (Sig : Type) where
  /-- "Here are the bytes for this address." -/
  | body (cid : Cid) (content : Content)
  /-- "Here is a verification result." -/
  | result (sr : SignedResult Sig)

/-- A message a peer refuses on its own: a body that does not re-derive
its address, or a result whose signature does not verify. -/
def Forged {Sig : Type} (A : Addressing) (S : SigScheme Key VResult Sig) :
    Msg Sig → Prop
  | .body cid c => idOf A c ≠ cid
  | .result sr => validResult S sr = false

/-- The bodies a peer keeps: those that re-derive the address they were
offered under. -/
def keepBodies {Sig : Type} (A : Addressing) (ms : List (Msg Sig)) : List (Cid × Content) :=
  ms.filterMap (fun m =>
    match m with
    | .body cid c => if idOf A c = cid then some (cid, c) else none
    | .result _ => none)

/-- The results a peer keeps: those whose signature verifies under the
verifier key they name. -/
def keepResults {Sig : Type} (S : SigScheme Key VResult Sig)
    (ms : List (Msg Sig)) : List VResult :=
  ms.filterMap (fun m =>
    match m with
    | .body _ _ => none
    | .result sr => if validResult S sr = true then some sr.result else none)

theorem mem_keepResults_iff {Sig : Type} {S : SigScheme Key VResult Sig}
    {ms : List (Msg Sig)} {r : VResult} :
    r ∈ keepResults S ms ↔
      ∃ sr : SignedResult Sig, Msg.result sr ∈ ms ∧ validResult S sr = true ∧ sr.result = r := by
  simp only [keepResults, List.mem_filterMap]
  constructor
  · rintro ⟨m, hm, hf⟩
    cases m with
    | body cid c => simp at hf
    | result sr =>
        by_cases hv : validResult S sr = true
        · simp only [hv, if_true] at hf
          exact ⟨sr, hm, hv, (Option.some.inj hf)⟩
        · simp only [hv] at hf
          exact absurd hf (by simp)
  · rintro ⟨sr, hm, hv, rfl⟩
    exact ⟨.result sr, hm, by simp [hv]⟩

theorem mem_keepBodies_iff {Sig : Type} {A : Addressing} {ms : List (Msg Sig)}
    {cid : Cid} {c : Content} :
    (cid, c) ∈ keepBodies (Sig := Sig) A ms ↔ (Msg.body cid c ∈ ms ∧ idOf A c = cid) := by
  simp only [keepBodies, List.mem_filterMap]
  constructor
  · rintro ⟨m, hm, hf⟩
    cases m with
    | body cid' c' =>
        by_cases ha : idOf A c' = cid'
        · simp only [ha, if_true] at hf
          obtain ⟨rfl, rfl⟩ := Prod.mk.injEq .. ▸ (Option.some.inj hf)
          exact ⟨hm, ha⟩
        · simp only [ha, if_false] at hf
          exact absurd hf (by simp)
    | result sr => simp at hf
  · rintro ⟨hm, ha⟩
    exact ⟨.body cid c, hm, by simp [ha]⟩

/-! ## Local validation is not negotiable -/

/-- **Every kept result is attributable.**  A relay cannot put words in a
verifier's mouth. -/
theorem kept_results_authentic {Sig : Type} {S : SigScheme Key VResult Sig}
    {ms : List (Msg Sig)} {r : VResult} (h : r ∈ keepResults S ms) :
    ∃ sig : Sig, S.signedBy r.verifier r sig := by
  obtain ⟨sr, _, hv, rfl⟩ := mem_keepResults_iff.mp h
  exact ⟨sr.signature, result_authentic hv⟩

/-- Every kept body really is the artifact its address names. -/
theorem kept_body_matches {Sig : Type} {A : Addressing} {ms : List (Msg Sig)}
    {cid : Cid} {c : Content} (h : (cid, c) ∈ keepBodies (Sig := Sig) A ms) :
    addressMatches A cid c :=
  (mem_keepBodies_iff.mp h).2

/-- **A relay cannot substitute content.**  At most one body passes the
address check for a given address, so whatever else the relay sends, a
peer either gets the artifact or gets nothing. -/
theorem kept_body_unique {Sig : Type} {A : Addressing} {ms ms' : List (Msg Sig)}
    {cid : Cid} {c c' : Content} (hw : c.Wire) (hw' : c'.Wire)
    (h : (cid, c) ∈ keepBodies (Sig := Sig) A ms)
    (h' : (cid, c') ∈ keepBodies (Sig := Sig) A ms') : c = c' :=
  addressMatches_unique A hw hw' (kept_body_matches h) (kept_body_matches h')

/-! ## The relay adversary -/

/-- **What a relay is allowed to do.**  Every message the peer received
was either genuinely sent, or is something the peer refuses on its own.
Dropping, delaying, reordering and duplicating are all permitted by this
condition, since it constrains only the provenance of what arrives. -/
def RelayRun {Sig : Type} (A : Addressing) (S : SigScheme Key VResult Sig)
    (sent received : List (Msg Sig)) : Prop :=
  ∀ m ∈ received, m ∈ sent ∨ Forged A S m

/-- Nothing was dropped. -/
def Delivered {Sig : Type} (sent received : List (Msg Sig)) : Prop :=
  ∀ m ∈ sent, m ∈ received

/-- Injected results are discarded, so the results a peer keeps after a
relay run are a subset of what was actually published. -/
theorem keepResults_of_run {Sig : Type} {A : Addressing} {S : SigScheme Key VResult Sig}
    {sent received : List (Msg Sig)} (run : RelayRun A S sent received) :
    ∀ r ∈ keepResults S received, r ∈ keepResults S sent := by
  intro r hr
  obtain ⟨sr, hmem, hv, rfl⟩ := mem_keepResults_iff.mp hr
  rcases run _ hmem with h | h
  · exact mem_keepResults_iff.mpr ⟨sr, h, hv, rfl⟩
  · simp only [Forged] at h
    rw [h] at hv
    exact absurd hv (by simp)

/-- Injected bodies are discarded too. -/
theorem keepBodies_of_run {Sig : Type} {A : Addressing} {S : SigScheme Key VResult Sig}
    {sent received : List (Msg Sig)} (run : RelayRun A S sent received) :
    ∀ p ∈ keepBodies (Sig := Sig) A received, p ∈ keepBodies (Sig := Sig) A sent := by
  rintro ⟨cid, c⟩ hp
  obtain ⟨hmem, ha⟩ := mem_keepBodies_iff.mp hp
  rcases run _ hmem with h | h
  · exact mem_keepBodies_iff.mpr ⟨h, ha⟩
  · simp only [Forged] at h
    exact absurd ha h

theorem keepResults_of_delivered {Sig : Type} {S : SigScheme Key VResult Sig}
    {sent received : List (Msg Sig)} (hdel : Delivered sent received) :
    ∀ r ∈ keepResults S sent, r ∈ keepResults S received := by
  intro r hr
  obtain ⟨sr, hmem, hv, rfl⟩ := mem_keepResults_iff.mp hr
  exact mem_keepResults_iff.mpr ⟨sr, hdel _ hmem, hv, rfl⟩

/-! ## The relay cannot change what is accepted -/

/-- **A relay cannot manufacture an acceptance.**  If a peer accepts a
proof from what a relay delivered, then the evidence was published by
honest peers: the relay's own contributions were discarded before the
decision was made. -/
theorem relay_cannot_manufacture {Sig : Type} {A : Addressing} {S : SigScheme Key VResult Sig}
    {sent received : List (Msg Sig)} (run : RelayRun A S sent received)
    {P : Policy} {tid envCid sid : Cid} {e : Env} {s : Sub}
    (h : acceptsB P tid envCid sid e s (keepResults S received) = true) :
    acceptsB P tid envCid sid e s (keepResults S sent) = true :=
  accepts_mono_results (keepResults_of_run run) h

/-- **A relay that delivers everything changes nothing.**  Reorder,
duplicate, delay and pad the stream with forgeries as much as you like:
the accepted set is exactly the one a perfect channel would have
produced. -/
theorem relay_cannot_change_accepted {Sig : Type} {A : Addressing}
    {S : SigScheme Key VResult Sig} {sent received : List (Msg Sig)}
    (run : RelayRun A S sent received) (hdel : Delivered sent received)
    {P : Policy} {tid envCid sid : Cid} {e : Env} {s : Sub} :
    acceptsB P tid envCid sid e s (keepResults S received)
      = acceptsB P tid envCid sid e s (keepResults S sent) :=
  accepts_of_mem_iff (fun r =>
    ⟨fun hr => keepResults_of_run run r hr, fun hr => keepResults_of_delivered hdel r hr⟩)

/-- The same, stated as the source specification states it in prose:
transport is not validity. -/
theorem relay_transport_is_not_validity {Sig : Type} {A : Addressing}
    {S : SigScheme Key VResult Sig} {sent received received' : List (Msg Sig)}
    (run : RelayRun A S sent received) (hdel : Delivered sent received)
    (run' : RelayRun A S sent received') (hdel' : Delivered sent received')
    {P : Policy} {tid envCid sid : Cid} {e : Env} {s : Sub} :
    acceptsB P tid envCid sid e s (keepResults S received)
      = acceptsB P tid envCid sid e s (keepResults S received') := by
  rw [relay_cannot_change_accepted run hdel, relay_cannot_change_accepted run' hdel']

/-- **The §18 acceptance test, as one statement.**  After any relay run
that delivers what was published:

* the verdict is exactly the honest-channel verdict;
* every result the peer kept was signed by the verifier it names;
* every body the peer kept is the artifact its address names. -/
theorem malicious_relay_harmless {Sig : Type} {A : Addressing} {S : SigScheme Key VResult Sig}
    {sent received : List (Msg Sig)} (run : RelayRun A S sent received)
    (hdel : Delivered sent received)
    (P : Policy) (tid envCid sid : Cid) (e : Env) (s : Sub) :
    acceptsB P tid envCid sid e s (keepResults S received)
        = acceptsB P tid envCid sid e s (keepResults S sent) ∧
      (∀ r ∈ keepResults S received, ∃ sig : Sig, S.signedBy r.verifier r sig) ∧
      (∀ p ∈ keepBodies (Sig := Sig) A received, addressMatches A p.1 p.2) := by
  refine ⟨relay_cannot_change_accepted run hdel, ?_, ?_⟩
  · intro r hr
    exact kept_results_authentic hr
  · rintro ⟨cid, c⟩ hp
    exact kept_body_matches hp

/-- A peer that receives nothing accepts nothing new: acceptance is
monotone in what is held, never in what is claimed. -/
theorem no_delivery_no_acceptance {Sig : Type} {S : SigScheme Key VResult Sig}
    {P : Policy} {tid envCid sid : Cid} {e : Env} {s : Sub} :
    acceptsB P tid envCid sid e s (keepResults S ([] : List (Msg Sig))) = false := by
  simp only [acceptsB, keepResults, endorsingVerifiers, endorsements, List.filterMap_nil,
    List.filter_nil, List.map_nil, List.dedup_nil, List.length_nil, Bool.and_eq_false_iff,
    decide_eq_false_iff_not, Nat.not_lt, Nat.le_zero]
  omega

end Kant.Prove2me
