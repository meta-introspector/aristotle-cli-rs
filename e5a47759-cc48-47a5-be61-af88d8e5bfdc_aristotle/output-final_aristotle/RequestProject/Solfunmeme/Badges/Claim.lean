/-
  Claim.lean — the claim protocol of the single-page senate badges.

  `badges/<address>.html` is one self-contained page per sitting senator.  The
  page is *locked*: it displays the holder's standing, but mints nothing until
  whoever opens it proves, in the browser, that they hold the key to the
  address the page is about.  The proof is an Ed25519 signature over a
  challenge the page generates, checked by the verifier carried inside the page
  itself (`scripts/badge.js`); no key, signature or address leaves the machine.
  Once the signature checks out the page mints a statement —

      "I am a senator of SOLFUNMEME since 2025-01-15 (snapshot 0, unix
       1736974661), rank #1, with a standing of at least 8787467393 and at
       most 8787467393 token-days, a Genesis Senator."

  — and wraps it, with the challenge and the signature, in a shareable badge
  token that anyone can re-verify.

  This file is the specification of that protocol, and the page's script is
  written to match it line for line:

      statement  p          the sentence the badge asserts
      challenge  p nonce    domainTag | address | statement p | nonce
      unlock     V p nonce sig
      verifyToken V t

  What is proved here:

    * `unlock_eq_some_iff` — the badge opens exactly when the signature
      verifies against the page's own address, and what it then yields is the
      page's statement and nothing else;
    * `unlock_requires_key` — under the unforgeability assumption for the
      signature scheme, an unlocked badge implies the claimant holds the key;
    * `no_replay` — because the nonce is inside the signed message, a
      signature the holder never produced for *this* challenge cannot open the
      badge: an old transcript is useless;
    * `challenge_binds_statement`, `token_tampering_needs_new_signature` — the
      statement is inside the signed message, so changing any figure on the
      badge (seniority, rank, standing, genesis mark) invalidates the
      signature; a forged badge would need a fresh signature by the same key
      over the forged sentence.

  The corresponding facts about the *data* printed on the pages — that every
  figure is what the dataset's 52 snapshots yield — are in
  `RequestProject/Badges/ClaimFacts.lean`.
-/

import Mathlib

namespace Badges.Claim

/-! ### Strings: the two cancellation facts the protocol needs -/

theorem String.append_cancel_left {a b c : String} (h : a ++ b = a ++ c) : b = c := by
  have h' : a.toList ++ b.toList = a.toList ++ c.toList := by
    rw [← String.toList_append, ← String.toList_append, h]
  exact String.toList_inj.mp (List.append_cancel_left h')

/-- Two equal concatenations with tails of equal length agree on both parts. -/
theorem String.append_inj_of_length {a b c d : String} (h : a ++ b = c ++ d)
    (hl : b.length = d.length) : a = c ∧ b = d := by
  have h' : a.toList ++ b.toList = c.toList ++ d.toList := by
    rw [← String.toList_append, ← String.toList_append, h]
  have hl' : b.toList.length = d.toList.length := by
    simpa [_root_.String.length_toList] using hl
  obtain ⟨h1, h2⟩ := List.append_inj' h' hl'
  exact ⟨String.toList_inj.mp h1, String.toList_inj.mp h2⟩

theorem String.append_assoc' (a b c : String) : (a ++ b) ++ c = a ++ (b ++ c) := by
  apply String.toList_inj.mp
  simp [List.append_assoc]

/-! ### The page -/

/-- Everything a badge page asserts about one holder.  `sinceIndex` is the
first of the run of consecutive snapshots, reaching the last snapshot, at which
the address held a Senate-tier balance; `sinceTime` and `sinceDate` are that
snapshot's time; `tokenDaysLower`/`tokenDaysUpper` bracket the area under the
holder's balance curve over the recorded window. -/
structure ClaimPage where
  address : String
  rank : Nat
  finalBalance : Nat
  sinceIndex : Nat
  sinceTime : Nat
  sinceDate : String
  tokenDaysLower : Nat
  tokenDaysUpper : Nat
  genesis : Bool
  deriving DecidableEq, Repr, Inhabited

/-- The domain separation tag: what these signatures are for.  A signature made
for any other purpose cannot be recycled into a badge claim, and vice versa. -/
def domainTag : String := "SOLFUNMEME-BADGE-CLAIM-v1"

/-- The sentence the unlocked badge asserts.  It is a function of the page
alone: the claimant chooses nothing. -/
def statement (p : ClaimPage) : String :=
  "I am a senator of SOLFUNMEME since " ++ p.sinceDate ++
    " (snapshot " ++ toString p.sinceIndex ++ ", unix " ++ toString p.sinceTime ++
    "), rank #" ++ toString p.rank ++ ", with a standing of at least " ++
    toString p.tokenDaysLower ++ " and at most " ++ toString p.tokenDaysUpper ++
    " token-days" ++ (if p.genesis then ", a Genesis Senator." else ".")

/-- Everything the claimant signs except the nonce. -/
def challengePrefix (p : ClaimPage) : String :=
  domainTag ++ "|" ++ p.address ++ "|" ++ statement p ++ "|"

/-- The challenge: the domain tag, the address, the whole statement, and a
fresh nonce.  Signing it proves possession of the key *and* fixes every figure
the badge will carry. -/
def challenge (p : ClaimPage) (nonce : String) : String := challengePrefix p ++ nonce

/-- A signature verifier: address (an Ed25519 public key in base58), message,
signature.  In the page this is the Ed25519 implementation in
`scripts/badge.js`; here it is abstract, so the results below hold of any
verifier the page might use. -/
abbrev Verifier := String → String → String → Bool

/-- Unlocking a badge page: the statement, if the signature proves the key to
the page's address over the page's challenge; nothing otherwise. -/
def unlock (V : Verifier) (p : ClaimPage) (nonce sig : String) : Option String :=
  if V p.address (challenge p nonce) sig then some (statement p) else none

/-! ### Unlocking -/

/-- **The badge opens exactly for a valid proof of the key, and what it yields
is the page's own statement.** -/
theorem unlock_eq_some_iff {V : Verifier} {p : ClaimPage} {nonce sig s : String} :
    unlock V p nonce sig = some s ↔
      V p.address (challenge p nonce) sig = true ∧ s = statement p := by
  unfold unlock
  cases h : V p.address (challenge p nonce) sig <;> simp [eq_comm]

/-- Soundness: an open badge carries a verified signature. -/
theorem unlock_sound {V : Verifier} {p : ClaimPage} {nonce sig s : String}
    (h : unlock V p nonce sig = some s) :
    V p.address (challenge p nonce) sig = true :=
  (unlock_eq_some_iff.mp h).1

/-- Completeness: the key holder gets in. -/
theorem unlock_complete {V : Verifier} {p : ClaimPage} {nonce sig : String}
    (h : V p.address (challenge p nonce) sig = true) :
    unlock V p nonce sig = some (statement p) := by
  simp [unlock, h]

/-- Without a verifying signature the page stays locked. -/
theorem unlock_locked {V : Verifier} {p : ClaimPage} {nonce sig : String}
    (h : V p.address (challenge p nonce) sig = false) : unlock V p nonce sig = none := by
  simp [unlock, h]

/-- The badge cannot be made to say anything but the page's statement: the
claimant contributes the nonce and the signature, neither of which appears in
the output. -/
theorem unlock_output_is_page_statement {V : Verifier} {p : ClaimPage}
    {nonce sig s : String} (h : unlock V p nonce sig = some s) : s = statement p :=
  (unlock_eq_some_iff.mp h).2

/-- The claimant's own choices — the nonce and the signature — do not change
what the badge says. -/
theorem unlock_independent_of_claimant_input {V : Verifier} {p : ClaimPage}
    {n₁ n₂ sig₁ sig₂ s₁ s₂ : String}
    (h₁ : unlock V p n₁ sig₁ = some s₁) (h₂ : unlock V p n₂ sig₂ = some s₂) :
    s₁ = s₂ := by
  rw [unlock_output_is_page_statement h₁, unlock_output_is_page_statement h₂]

/-! ### What an unlocked badge proves -/

/-- Unforgeability, as an assumption on the verifier: an accepted signature for
an address can only have come from whoever holds the key to it. -/
def OnlyKeyHolderSigns (V : Verifier) (HasKey : String → Prop) : Prop :=
  ∀ a msg sig, V a msg sig = true → HasKey a

/-- **Proof of ownership.**  Under unforgeability, an unlocked badge means the
claimant holds the key to the address the page is about. -/
theorem unlock_requires_key {V : Verifier} {HasKey : String → Prop}
    (hV : OnlyKeyHolderSigns V HasKey) {p : ClaimPage} {nonce sig s : String}
    (h : unlock V p nonce sig = some s) : HasKey p.address :=
  hV _ _ _ (unlock_sound h)

/-- Honesty of the verifier about *what* was signed: an accepted signature for
an address is a signature that address made over that exact message. -/
def SignsOnlyWhatWasSigned (V : Verifier) (Signed : String → String → Prop) : Prop :=
  ∀ a msg sig, V a msg sig = true → Signed a msg

/-- **Freshness / no replay.**  The nonce sits inside the signed message, so a
signature the key holder never made over *this* challenge cannot open the
badge, whatever else it was made over. -/
theorem no_replay {V : Verifier} {Signed : String → String → Prop}
    (hV : SignsOnlyWhatWasSigned V Signed) {p : ClaimPage} {nonce sig : String}
    (hfresh : ¬ Signed p.address (challenge p nonce)) : unlock V p nonce sig = none := by
  by_cases h : V p.address (challenge p nonce) sig = true
  · exact absurd (hV _ _ _ h) hfresh
  · exact unlock_locked (by simpa using h)

/-! ### The signed message pins down the badge -/

/-- The statement is literally inside the message that gets signed. -/
theorem statement_inside_challenge (p : ClaimPage) (nonce : String) :
    ∃ pre suf, challenge p nonce = pre ++ statement p ++ suf :=
  ⟨domainTag ++ "|" ++ p.address ++ "|", "|" ++ nonce, by
    simp only [challenge, challengePrefix]
    apply String.toList_inj.mp
    simp [List.append_assoc]⟩

/-- **Tamper resistance.**  For a fixed address and nonces of equal length —
the page always draws a 32-byte nonce — two different statements are two
different challenges.  Changing any figure on the badge therefore invalidates
the signature. -/
theorem challenge_binds_statement {p q : ClaimPage} {n m : String}
    (haddr : p.address = q.address) (hlen : n.length = m.length)
    (h : challenge p n = challenge q m) : statement p = statement q := by
  simp only [challenge, challengePrefix, ← haddr] at h
  have h' : (domainTag ++ "|" ++ p.address ++ "|") ++ (statement p ++ ("|" ++ n))
      = (domainTag ++ "|" ++ p.address ++ "|") ++ (statement q ++ ("|" ++ m)) := by
    apply String.toList_inj.mp
    simpa [List.append_assoc] using congrArg String.toList h
  have h2 : statement p ++ ("|" ++ n) = statement q ++ ("|" ++ m) :=
    String.append_cancel_left h'
  have hl2 : ("|" ++ n : String).length = ("|" ++ m : String).length := by
    simp [String.length_append, hlen]
  exact (String.append_inj_of_length h2 hl2).1

/-- And the nonce is recovered too: equal-length nonces and equal challenges
force equal nonces. -/
theorem challenge_binds_nonce {p q : ClaimPage} {n m : String}
    (hlen : n.length = m.length) (h : challenge p n = challenge q m) : n = m :=
  (String.append_inj_of_length (a := challengePrefix p) (c := challengePrefix q) h hlen).2

/-- Different prefixes, equal-length nonces: different challenges.  This is the
form used against the real table of 100 pages, whose prefixes are pairwise
distinct (`ClaimFacts.challengePrefixes_pairwise_distinct`). -/
theorem challenge_ne_of_prefix_ne {p q : ClaimPage} {n m : String}
    (hpre : challengePrefix p ≠ challengePrefix q) (hlen : n.length = m.length) :
    challenge p n ≠ challenge q m := fun h =>
  hpre (String.append_inj_of_length h hlen).1

/-! ### The shareable badge token -/

/-- What the page emits after unlocking: the page's own fields, the nonce, the
signature, and the sentence.  (The HTML page transports this as
`sfmbadge1.<base64url of the JSON>`.) -/
structure Token where
  page : ClaimPage
  nonce : String
  sig : String
  claim : String
  deriving DecidableEq, Repr

/-- Minting: only a genuine unlock produces a token. -/
def mintToken (V : Verifier) (p : ClaimPage) (nonce sig : String) : Option Token :=
  (unlock V p nonce sig).map (fun s => { page := p, nonce := nonce, sig := sig, claim := s })

/-- Re-verifying a token, as any third party can: the sentence must be the one
the fields generate, and the signature must verify over the challenge those
fields determine. -/
def verifyToken (V : Verifier) (t : Token) : Bool :=
  (t.claim == statement t.page) && V t.page.address (challenge t.page t.nonce) t.sig

/-- A minted token always re-verifies. -/
theorem verifyToken_mintToken {V : Verifier} {p : ClaimPage} {nonce sig : String}
    {t : Token} (h : mintToken V p nonce sig = some t) : verifyToken V t = true := by
  unfold mintToken at h
  rcases hu : unlock V p nonce sig with _ | s
  · rw [hu] at h; simp at h
  · rw [hu] at h
    simp only [Option.map_some] at h
    have ht := Option.some.inj h
    subst ht
    simp [verifyToken, unlock_output_is_page_statement hu, unlock_sound hu]

/-- A token that verifies carries the statement its own fields generate: the
sentence cannot be edited in transit. -/
theorem verifyToken_claim {V : Verifier} {t : Token} (h : verifyToken V t = true) :
    t.claim = statement t.page := by
  have := (Bool.and_eq_true _ _).mp h
  simpa using this.1

/-- A token that verifies carries a signature over its own challenge. -/
theorem verifyToken_signature {V : Verifier} {t : Token} (h : verifyToken V t = true) :
    V t.page.address (challenge t.page t.nonce) t.sig = true :=
  ((Bool.and_eq_true _ _).mp h).2

/-- **Forging a badge needs a fresh signature.**  Take a verifying token and
alter any figure on it — seniority, rank, standing, the genesis mark — keeping
the address and the nonce.  The altered token verifies only if the key holder
signed the altered sentence too. -/
theorem token_tampering_needs_new_signature {V : Verifier}
    {Signed : String → String → Prop} (hV : SignsOnlyWhatWasSigned V Signed)
    {t t' : Token} (haddr : t'.page.address = t.page.address) (hnonce : t'.nonce = t.nonce)
    (hchanged : statement t'.page ≠ statement t.page)
    (h : verifyToken V t' = true) :
    Signed t.page.address (challenge t'.page t.nonce) ∧
      challenge t'.page t.nonce ≠ challenge t.page t.nonce := by
  refine ⟨?_, ?_⟩
  · have := hV _ _ _ (verifyToken_signature h)
    rw [haddr, hnonce] at this
    exact this
  · intro hc
    exact hchanged (challenge_binds_statement haddr rfl hc)

/-- Under unforgeability, a verifying token proves the key to the address it
names — that is all it proves, and it is what the badge claims. -/
theorem verifyToken_requires_key {V : Verifier} {HasKey : String → Prop}
    (hV : OnlyKeyHolderSigns V HasKey) {t : Token} (h : verifyToken V t = true) :
    HasKey t.page.address :=
  hV _ _ _ (verifyToken_signature h)

end Badges.Claim
