/-
  Disclosure.lean — the redactable badge.

  `RequestProject/Badges/Claim.lean` mints one fixed sentence: the page decides
  what the badge says and the holder decides nothing.  That is safe but blunt —
  a holder who wants to prove they are a senator has to publish their rank and
  their token-day standing along with it.

  This file is the second version of the badge, in which the holder chooses:

      Policy    which of the page's facts are published — seniority, the
                snapshot, the rank, the token-day standing, the genesis mark —
                each independently redactable;
      Field     a label and a value the holder *adds* themselves;
      statement the sentence, built from exactly the disclosed page fields plus
                the holder's own additions, in that order.

  Everything else is as before: the statement goes inside the signed challenge,
  so the signature binds precisely what is shown.

  What is proved:

    * **redaction really hides.**  With the standing redacted, the badge is
      literally the same string for every token-day figure the page could carry
      (`standing_redaction_is_invisible`); the same holds for the rank, the
      seniority, the snapshot and the genesis mark.  A redacted field is not
      merely omitted from the display — it does not influence the badge at all,
      so nothing about it can be read off.
    * **redaction is visible as an omission**: a redacted field's label does not
      appear among the disclosed fields (`redacted_label_absent`).
    * **disclosing more changes the badge**, so an unredacted badge cannot be
      manufactured from a redacted one: the statement gets strictly longer, the
      challenge changes, and the altered badge verifies only if the key holder
      signed the fuller sentence (`disclosing_more_changes_the_statement`,
      `cannot_unredact_without_a_new_signature`).
    * **the holder's own additions are signed too.**  Adding a field after the
      fact changes the statement (`adding_a_field_changes_the_statement`) and
      hence needs a new signature (`token_tampering_needs_new_signature`).
    * **an addition cannot impersonate a page fact**: the labels the page uses
      are reserved, and a well-formed addition may not use them
      (`extras_cannot_forge_a_page_field`).
    * the badge still opens exactly for a proof of the key
      (`unlock_eq_some_iff`, `unlock_requires_key`), still cannot be replayed
      (`no_replay`), and a minted token still re-verifies
      (`verifyToken_mintToken`).
-/

import RequestProject.Solfunmeme.Badges.Claim

namespace Badges.Disclose

open Badges.Claim

/-! ### What the holder chooses -/

/-- Which of the page's facts to publish.  Every flag defaults to nothing being
disclosed; the holder turns on what they want to show. -/
structure Policy where
  /-- Publish "senator since <date>". -/
  since : Bool
  /-- Publish the snapshot index and its unix time. -/
  snapshot : Bool
  /-- Publish the rank. -/
  rank : Bool
  /-- Publish the token-day standing bracket. -/
  standing : Bool
  /-- Publish the genesis mark. -/
  genesis : Bool
deriving DecidableEq, Repr, Inhabited

namespace Policy

/-- Publish everything the page knows: the old, unredactable badge. -/
def full : Policy := ⟨true, true, true, true, true⟩

/-- Publish nothing but the address: "the holder of this address is a
senator". -/
def bare : Policy := ⟨false, false, false, false, false⟩

/-- Publish seniority only — the common case: prove you are a senator and how
long you have been one, without saying how much you hold. -/
def seniorityOnly : Policy := ⟨true, false, false, false, false⟩

end Policy

/-- A labelled fact on the badge. -/
structure Field where
  /-- The label. -/
  label : String
  /-- The value. -/
  value : String
deriving DecidableEq, Repr, Inhabited

/-- The labels the page itself uses.  A holder's own addition may not use one
of these, so an addition can never be read as a page fact. -/
def reservedLabels : List String :=
  ["since", "snapshot", "unix", "rank", "token-days-lower", "token-days-upper", "genesis"]

/-- A group of fields, published or withheld. -/
def group (b : Bool) (fs : List Field) : List Field := if b then fs else []

/-- The token-day standing, as the two fields that carry it. -/
def standingFields (p : ClaimPage) : List Field :=
  [⟨"token-days-lower", toString p.tokenDaysLower⟩,
   ⟨"token-days-upper", toString p.tokenDaysUpper⟩]

/-- The fields the policy publishes, in a fixed order. -/
def disclosed (p : ClaimPage) (pol : Policy) : List Field :=
  group pol.since [⟨"since", p.sinceDate⟩]
    ++ group pol.snapshot
        [⟨"snapshot", toString p.sinceIndex⟩, ⟨"unix", toString p.sinceTime⟩]
    ++ group pol.rank [⟨"rank", toString p.rank⟩]
    ++ group pol.standing (standingFields p)
    ++ group pol.genesis [⟨"genesis", if p.genesis then "yes" else "no"⟩]

/-- A field is well formed when neither part carries a separator and the label
is not one the page has reserved. -/
def wfField (f : Field) : Bool :=
  !f.label.isEmpty
    && !(f.label.contains '=') && !(f.label.contains ';') && !(f.label.contains '|')
    && !(f.value.contains '=') && !(f.value.contains ';') && !(f.value.contains '|')
    && !reservedLabels.contains f.label

/-- The holder's additions are well formed. -/
def wfExtras (xs : List Field) : Bool := xs.all wfField

/-! ### The sentence -/

/-- Fields, rendered.  Each field contributes `label=value;`, so the rendering
of a concatenation is the concatenation of the renderings. -/
def render : List Field → String
  | [] => ""
  | f :: t => f.label ++ "=" ++ f.value ++ ";" ++ render t

/-- The domain separation tag of the redactable badge.  It differs from the
tag of the fixed badge, so a signature made for one cannot be recycled into the
other. -/
def domainTag : String := "SOLFUNMEME-BADGE-DISCLOSE-v2"

/-- The sentence the badge asserts: the address, then the disclosed page fields,
then the holder's own additions. -/
def statement (p : ClaimPage) (pol : Policy) (xs : List Field) : String :=
  "senator=" ++ p.address ++ ";" ++ render (disclosed p pol ++ xs)

/-- Everything signed except the nonce. -/
def challengePrefix (p : ClaimPage) (pol : Policy) (xs : List Field) : String :=
  domainTag ++ "|" ++ p.address ++ "|" ++ statement p pol xs ++ "|"

/-- The challenge: the tag, the address, the disclosed sentence, and a fresh
nonce. -/
def challenge (p : ClaimPage) (pol : Policy) (xs : List Field) (nonce : String) : String :=
  challengePrefix p pol xs ++ nonce

/-- Unlocking a redactable badge. -/
def unlock (V : Verifier) (p : ClaimPage) (pol : Policy) (xs : List Field)
    (nonce sig : String) : Option String :=
  if V p.address (challenge p pol xs nonce) sig then some (statement p pol xs) else none

/-! ### Redaction hides -/

private theorem disclosed_congr_standing (p : ClaimPage) (pol : Policy) (a b : Nat)
    (h : pol.standing = false) :
    disclosed { p with tokenDaysLower := a, tokenDaysUpper := b } pol = disclosed p pol := by
  simp [disclosed, group, h]

/-- **A redacted standing is invisible.**  With `standing` redacted the badge is
literally the same string whatever the page's token-day figures are, so no
reader — however clever — can learn anything about them from the badge. -/
theorem standing_redaction_is_invisible (p : ClaimPage) (pol : Policy) (xs : List Field)
    (a b : Nat) (h : pol.standing = false) :
    statement { p with tokenDaysLower := a, tokenDaysUpper := b } pol xs
      = statement p pol xs := by
  simp [statement, disclosed_congr_standing p pol a b h]

/-- **A redacted rank is invisible.** -/
theorem rank_redaction_is_invisible (p : ClaimPage) (pol : Policy) (xs : List Field)
    (r : Nat) (h : pol.rank = false) :
    statement { p with rank := r } pol xs = statement p pol xs := by
  simp [statement, disclosed, group, standingFields, h]

/-- **A redacted seniority is invisible.** -/
theorem since_redaction_is_invisible (p : ClaimPage) (pol : Policy) (xs : List Field)
    (d : String) (h : pol.since = false) :
    statement { p with sinceDate := d } pol xs = statement p pol xs := by
  simp [statement, disclosed, group, standingFields, h]

/-- **A redacted snapshot is invisible.** -/
theorem snapshot_redaction_is_invisible (p : ClaimPage) (pol : Policy) (xs : List Field)
    (i t : Nat) (h : pol.snapshot = false) :
    statement { p with sinceIndex := i, sinceTime := t } pol xs = statement p pol xs := by
  simp [statement, disclosed, group, standingFields, h]

/-- **A redacted genesis mark is invisible.** -/
theorem genesis_redaction_is_invisible (p : ClaimPage) (pol : Policy) (xs : List Field)
    (g : Bool) (h : pol.genesis = false) :
    statement { p with genesis := g } pol xs = statement p pol xs := by
  simp [statement, disclosed, group, standingFields, h]

/-- **A redacted field's label does not appear.** -/
theorem redacted_label_absent (p : ClaimPage) (pol : Policy) (h : pol.standing = false) :
    ∀ f ∈ disclosed p pol, f.label ≠ "token-days-lower" ∧ f.label ≠ "token-days-upper" := by
  obtain ⟨s1, s2, s3, s4, s5⟩ := pol
  cases s4
  · cases s1 <;> cases s2 <;> cases s3 <;> cases s5 <;>
      simp +decide [disclosed, group]
  · exact absurd h (by simp)

/-- **A holder's addition cannot impersonate a page fact.** -/
theorem extras_cannot_forge_a_page_field (xs : List Field) (h : wfExtras xs = true) :
    ∀ f ∈ xs, f.label ∉ reservedLabels := by
  intro f hf hmem
  have := (List.all_eq_true.mp h) f hf
  simp only [wfField, Bool.and_eq_true, Bool.not_eq_true'] at this
  have hcontains : reservedLabels.contains f.label = true := by
    simpa using hmem
  rw [hcontains] at this
  simp at this

/-! ### Disclosing more, or adding a field, changes the badge -/

theorem render_append (a b : List Field) : render (a ++ b) = render a ++ render b := by
  induction a with
  | nil => simp [render]
  | cons f t ih =>
      simp only [List.cons_append, render, ih]
      apply String.toList_inj.mp
      simp [List.append_assoc]

theorem render_append_length (a b : List Field) :
    (render (a ++ b)).length = (render a).length + (render b).length := by
  rw [render_append, String.length_append]

theorem render_pos (f : Field) (t : List Field) : 0 < (render (f :: t)).length := by
  have h1 : ("=" : String).length = 1 := rfl
  have h2 : (";" : String).length = 1 := rfl
  simp only [render, String.length_append, h1, h2]
  omega

/-- **Adding a field changes the sentence.** -/
theorem adding_a_field_changes_the_statement (p : ClaimPage) (pol : Policy)
    (xs : List Field) (f : Field) :
    statement p pol xs ≠ statement p pol (xs ++ [f]) := by
  intro h
  have hl := congrArg String.length h
  simp only [statement, String.length_append, ← List.append_assoc, render_append_length] at hl
  have hpos : 0 < (render [f]).length := render_pos f []
  omega

/-- The standing costs exactly the length of its two fields. -/
theorem disclosed_length_standing (p : ClaimPage) (pol : Policy) :
    (render (disclosed p { pol with standing := true })).length
      = (render (disclosed p { pol with standing := false })).length
        + (render (standingFields p)).length := by
  have h0 : (render []).length = 0 := rfl
  simp only [disclosed, group, render_append_length, if_true, if_false, h0,
    Bool.false_eq_true]
  omega

private theorem policy_eta_standing (pol : Policy) (h : pol.standing = false) :
    { pol with standing := false } = pol := by
  obtain ⟨s1, s2, s3, s4, s5⟩ := pol
  cases s4
  · rfl
  · exact absurd h (by simp)

/-- **Disclosing a redacted field changes the sentence.**  A badge that shows
the standing is a strictly longer string than the same badge with the standing
redacted, so the two are never the same badge. -/
theorem disclosing_more_changes_the_statement (p : ClaimPage) (pol : Policy)
    (xs : List Field) (h : pol.standing = false) :
    statement p pol xs ≠ statement p { pol with standing := true } xs := by
  intro heq
  have hl := congrArg String.length heq
  have hstand := disclosed_length_standing p pol
  rw [policy_eta_standing pol h] at hstand
  have hpos : 0 < (render (standingFields p)).length := by
    rw [standingFields]; exact render_pos _ _
  simp only [statement, String.length_append, render_append_length] at hl
  omega

/-! ### The badge still behaves like a badge -/

theorem unlock_eq_some_iff {V : Verifier} {p : ClaimPage} {pol : Policy} {xs : List Field}
    {nonce sig s : String} :
    unlock V p pol xs nonce sig = some s ↔
      V p.address (challenge p pol xs nonce) sig = true ∧ s = statement p pol xs := by
  unfold unlock
  cases h : V p.address (challenge p pol xs nonce) sig <;> simp [eq_comm]

theorem unlock_sound {V : Verifier} {p : ClaimPage} {pol : Policy} {xs : List Field}
    {nonce sig s : String} (h : unlock V p pol xs nonce sig = some s) :
    V p.address (challenge p pol xs nonce) sig = true := (unlock_eq_some_iff.mp h).1

theorem unlock_complete {V : Verifier} {p : ClaimPage} {pol : Policy} {xs : List Field}
    {nonce sig : String} (h : V p.address (challenge p pol xs nonce) sig = true) :
    unlock V p pol xs nonce sig = some (statement p pol xs) := by
  simp [unlock, h]

/-- **Proof of ownership** carries over: an unlocked redacted badge still means
the claimant holds the key to the address. -/
theorem unlock_requires_key {V : Verifier} {HasKey : String → Prop}
    (hV : OnlyKeyHolderSigns V HasKey) {p : ClaimPage} {pol : Policy} {xs : List Field}
    {nonce sig s : String} (h : unlock V p pol xs nonce sig = some s) : HasKey p.address :=
  hV _ _ _ (unlock_sound h)

/-- **No replay**: the nonce is inside the signed message. -/
theorem no_replay {V : Verifier} {Signed : String → String → Prop}
    (hV : SignsOnlyWhatWasSigned V Signed) {p : ClaimPage} {pol : Policy} {xs : List Field}
    {nonce sig : String} (hfresh : ¬ Signed p.address (challenge p pol xs nonce)) :
    unlock V p pol xs nonce sig = none := by
  by_cases h : V p.address (challenge p pol xs nonce) sig = true
  · exact absurd (hV _ _ _ h) hfresh
  · simp [unlock, h]

/-- The disclosed sentence sits inside the signed message. -/
theorem statement_inside_challenge (p : ClaimPage) (pol : Policy) (xs : List Field)
    (nonce : String) :
    ∃ pre suf, challenge p pol xs nonce = pre ++ statement p pol xs ++ suf :=
  ⟨domainTag ++ "|" ++ p.address ++ "|", "|" ++ nonce, by
    simp only [challenge, challengePrefix]
    apply String.toList_inj.mp
    simp [List.append_assoc]⟩

/-- **Tamper resistance.**  For a fixed address and equal-length nonces, two
different disclosed sentences are two different challenges: changing the
policy, any page fact shown, or any addition invalidates the signature. -/
theorem challenge_binds_statement {p q : ClaimPage} {pol pol' : Policy} {xs ys : List Field}
    {n m : String} (haddr : p.address = q.address) (hlen : n.length = m.length)
    (h : challenge p pol xs n = challenge q pol' ys m) :
    statement p pol xs = statement q pol' ys := by
  simp only [challenge, challengePrefix, ← haddr] at h
  have h' : (domainTag ++ "|" ++ p.address ++ "|") ++ (statement p pol xs ++ ("|" ++ n))
      = (domainTag ++ "|" ++ p.address ++ "|") ++ (statement q pol' ys ++ ("|" ++ m)) := by
    apply String.toList_inj.mp
    simpa [List.append_assoc] using congrArg String.toList h
  have h2 : statement p pol xs ++ ("|" ++ n) = statement q pol' ys ++ ("|" ++ m) :=
    Badges.Claim.String.append_cancel_left h'
  have hl2 : ("|" ++ n : String).length = ("|" ++ m : String).length := by
    simp [String.length_append, hlen]
  exact (Badges.Claim.String.append_inj_of_length h2 hl2).1

/-! ### The shareable token -/

/-- What the page emits: the page's fields, the disclosure policy, the holder's
additions, the nonce, the signature and the sentence. -/
structure Token where
  /-- The page the badge is about. -/
  page : ClaimPage
  /-- What the holder chose to disclose. -/
  policy : Policy
  /-- What the holder added. -/
  extras : List Field
  /-- The nonce. -/
  nonce : String
  /-- The signature. -/
  sig : String
  /-- The sentence. -/
  claim : String
deriving DecidableEq, Repr

/-- Minting: only a genuine unlock produces a token. -/
def mintToken (V : Verifier) (p : ClaimPage) (pol : Policy) (xs : List Field)
    (nonce sig : String) : Option Token :=
  (unlock V p pol xs nonce sig).map
    (fun s => { page := p, policy := pol, extras := xs, nonce := nonce, sig := sig, claim := s })

/-- Re-verifying a token, as any third party can: the sentence must be the one
the disclosed data generates, the additions must be well formed, and the
signature must verify over the challenge that data determines. -/
def verifyToken (V : Verifier) (t : Token) : Bool :=
  (t.claim == statement t.page t.policy t.extras)
    && wfExtras t.extras
    && V t.page.address (challenge t.page t.policy t.extras t.nonce) t.sig

theorem verifyToken_claim {V : Verifier} {t : Token} (h : verifyToken V t = true) :
    t.claim = statement t.page t.policy t.extras := by
  simp only [verifyToken, Bool.and_eq_true, beq_iff_eq] at h
  exact h.1.1

theorem verifyToken_signature {V : Verifier} {t : Token} (h : verifyToken V t = true) :
    V t.page.address (challenge t.page t.policy t.extras t.nonce) t.sig = true := by
  simp only [verifyToken, Bool.and_eq_true] at h
  exact h.2

theorem verifyToken_extras_wf {V : Verifier} {t : Token} (h : verifyToken V t = true) :
    wfExtras t.extras = true := by
  simp only [verifyToken, Bool.and_eq_true] at h
  exact h.1.2

/-- A minted token re-verifies, provided the additions are well formed. -/
theorem verifyToken_mintToken {V : Verifier} {p : ClaimPage} {pol : Policy} {xs : List Field}
    {nonce sig : String} {t : Token} (hwf : wfExtras xs = true)
    (h : mintToken V p pol xs nonce sig = some t) : verifyToken V t = true := by
  unfold mintToken at h
  rcases hu : unlock V p pol xs nonce sig with _ | s
  · rw [hu] at h; simp at h
  · rw [hu] at h
    simp only [Option.map_some] at h
    have ht := Option.some.inj h
    subst ht
    have hs : s = statement p pol xs := (unlock_eq_some_iff.mp hu).2
    simp [verifyToken, hs, hwf, unlock_sound hu]

/-- **Forging a badge needs a fresh signature.**  Take a verifying token and
change what it discloses — unredact a field, edit a page fact, add or drop one
of the holder's own fields — keeping the address and the nonce.  If the
sentence changes at all, the altered badge verifies only if the key holder
signed the altered sentence. -/
theorem token_tampering_needs_new_signature {V : Verifier}
    {Signed : String → String → Prop} (hV : SignsOnlyWhatWasSigned V Signed)
    {t t' : Token} (haddr : t'.page.address = t.page.address) (hnonce : t'.nonce = t.nonce)
    (hchanged : statement t'.page t'.policy t'.extras ≠ statement t.page t.policy t.extras)
    (h : verifyToken V t' = true) :
    Signed t.page.address (challenge t'.page t'.policy t'.extras t.nonce) ∧
      challenge t'.page t'.policy t'.extras t.nonce
        ≠ challenge t.page t.policy t.extras t.nonce := by
  refine ⟨?_, ?_⟩
  · have hsig := hV _ _ _ (verifyToken_signature h)
    rw [haddr, hnonce] at hsig
    exact hsig
  · intro hc
    exact hchanged (challenge_binds_statement haddr rfl hc)

/-- **A redacted badge cannot be unredacted.**  Given a badge that verifies with
the standing redacted, a badge showing the standing — same page, same
additions, same address, same nonce — is a *different* sentence, and so
verifies only against a fresh signature by the key holder. -/
theorem cannot_unredact_without_a_new_signature {V : Verifier}
    {Signed : String → String → Prop} (hV : SignsOnlyWhatWasSigned V Signed)
    {t t' : Token} (hred : t.policy.standing = false)
    (hpage : t'.page = t.page) (hextras : t'.extras = t.extras)
    (hpol : t'.policy = { t.policy with standing := true }) (hnonce : t'.nonce = t.nonce)
    (h : verifyToken V t' = true) :
    Signed t.page.address (challenge t'.page t'.policy t'.extras t.nonce) := by
  refine (token_tampering_needs_new_signature hV (by rw [hpage]) hnonce ?_ h).1
  rw [hpage, hextras, hpol]
  exact fun hc =>
    (disclosing_more_changes_the_statement t.page t.policy t.extras hred) hc.symm

end Badges.Disclose
