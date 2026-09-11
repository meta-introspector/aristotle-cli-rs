/-
  Desk.lean — the senators' desk: signed accounts, news, trade attachments,
  comments and shares.

  A senator already has a badge (`RequestProject/Badges/Claim.lean`) proving
  they hold the key to a Senate-tier address.  The desk is what they do with
  that key afterwards.  Five kinds of record, each one signed by the address
  that publishes it:

      account  platform handle proof   "this X / mastodon / … account is mine"
      news     url title source        a news item put on the record
      attach   newsId tradeId note     that news item explains this trade
      comment  parentId text           a comment on an earlier record
      share    targetId text           a re-share of an earlier record

  A record is turned into one canonical string (`message`), signed, and
  appended to a log.  The log is kept newest-first, and a record is only
  accepted (`acceptable`) when

    * every field is separator-free,
    * the signature verifies against the record's own author,
    * its identifier is new — nothing can be posted twice,
    * everything it refers to (a parent comment, a shared record, the news
      item an attachment is about) is already in the log, and
    * its sequence number is above every sequence number that author already
      used.

  What is proved here, against an abstract signature verifier `V` and an
  abstract identifier hash `H`:

    * `message_injective` — the canonical string determines the record, so a
      signature is a signature over exactly one record (this rests on
      `Senate.Wire`);
    * `valid_verify`, `valid_author_holds_key`, `valid_author_signed` — every
      record in a valid log is signed by the address it names;
    * `valid_ids_nodup`, `post_replay_rejected` — no record appears twice;
    * `valid_refs_resolve`, `comment_parent_exists`, `share_target_exists`,
      `attach_news_exists` — no comment, share or attachment dangles: what it
      points at is an older record of the same log, so the log is acyclic
      (`valid_no_self_reference`) and threads are well founded;
    * `valid_id_unique` — with an injective `H`, an identifier names one
      record, so a share really does carry the record it says it carries;
    * `tampering_needs_new_signature`, `attach_binds_trade`,
      `comment_binds_parent` — editing any field of a record, moving an
      attachment to another trade, or re-pointing a comment, all invalidate
      the signature;
    * `post_append_only`, `valid_seq_strict_mono` — the log only grows, and
      an author's own records carry strictly increasing sequence numbers, so a
      gap or a reordering is visible;
    * `desk_message_ne_badge_challenge` — a desk signature can never be
      replayed as a badge claim, nor a badge signature as a desk record.

  `scripts/desk.js` implements exactly this, and `senate/desk.html` is the
  offline page a senator uses to do it.
-/

import RequestProject.Solfunmeme.Senate.Wire
import RequestProject.Solfunmeme.Badges.Claim

namespace Senate.Desk

open Senate.Wire

/-! ### Records -/

/-- What a senator can publish from the desk. -/
inductive Payload where
  /-- "This social account is mine": platform, handle, and a URL to a post on
  that account quoting the address. -/
  | account (platform handle proof : String)
  /-- A news item: link, headline, source. -/
  | news (url title source : String)
  /-- An attachment: this news record explains this trade (a transaction
  signature on chain), with a note. -/
  | attach (newsId tradeId note : String)
  /-- A comment on an earlier record. -/
  | comment (parentId text : String)
  /-- A re-share of an earlier record, with the sharer's own words. -/
  | share (targetId text : String)
  deriving DecidableEq, Repr, Inhabited

/-- The tag naming the kind of a record. -/
def kindTag : Payload → String
  | .account .. => "account"
  | .news .. => "news"
  | .attach .. => "attach"
  | .comment .. => "comment"
  | .share .. => "share"

/-- The three payload slots.  Every kind uses the same three, padded with the
empty string, so the encoding has a fixed shape. -/
def args : Payload → List String
  | .account p h u => [p, h, u]
  | .news u t s => [u, t, s]
  | .attach n t note => [n, t, note]
  | .comment p t => [p, t, ""]
  | .share t c => [t, c, ""]

theorem args_length (p : Payload) : (args p).length = 3 := by
  cases p <;> rfl

/-- The kind and the three slots determine the payload. -/
theorem payload_inj {p q : Payload} (hk : kindTag p = kindTag q) (ha : args p = args q) :
    p = q := by
  cases p <;> cases q <;> simp_all [kindTag, args]

/-- One record of the desk: who, when, what. -/
structure Record where
  /-- The base58 address of the senator publishing. -/
  author : String
  /-- The author's own counter, strictly increasing over their records. -/
  seq : Nat
  /-- Unix time as claimed by the author. -/
  time : Nat
  /-- A fresh nonce, so two identical posts are still two records. -/
  nonce : String
  /-- What is being published. -/
  payload : Payload
  deriving DecidableEq, Repr, Inhabited

/-- The domain separation tag of the desk.  It is not the badge's tag, and
`desk_message_ne_badge_challenge` below turns that into a theorem. -/
def domainTag : String := "SOLFUNMEME-SENATE-DESK-v1"

/-- The fields of a record, in order. -/
def fields (r : Record) : List String :=
  domainTag :: r.author :: natStr r.seq :: natStr r.time :: r.nonce ::
    kindTag r.payload :: args r.payload

/-- **The signed text.**  `scripts/desk.js` builds this with
`fields.join("|")`. -/
def message (r : Record) : String := joinFields (fields r)

/-! ### Well-formedness -/

/-- A separator-free field, as a `Bool`. -/
def sepFreeB (s : String) : Bool := !s.toList.contains sep

theorem sepFreeB_iff {s : String} : sepFreeB s = true ↔ SepFree s := by
  simp [sepFreeB, SepFree]

/-- A record is well formed when none of its fields contains the separator.
The desk refuses anything else. -/
def wf (r : Record) : Bool := (fields r).all sepFreeB

theorem wf_fields {r : Record} (h : wf r = true) : ∀ s ∈ fields r, SepFree s := by
  intro s hs
  exact sepFreeB_iff.mp (List.all_eq_true.mp h s hs)

theorem fields_ne_nil (r : Record) : fields r ≠ [] := by simp [fields]

/-! ### The encoding is injective -/

/-- **The signed text determines the record.**  Two well-formed records with
the same canonical message are the same record — so a signature over a message
is a signature over exactly one record, and every tamper statement below
follows from this. -/
theorem message_injective {r r' : Record} (h : wf r = true) (h' : wf r' = true)
    (hm : message r = message r') : r = r' := by
  have hf : fields r = fields r' :=
    joinFields_injective (wf_fields h) (wf_fields h') (fields_ne_nil r) (fields_ne_nil r') hm
  simp only [fields, List.cons.injEq] at hf
  obtain ⟨-, hauthor, hseq, htime, hnonce, hkind, hargs⟩ := hf
  have hs : r.seq = r'.seq := natStr_injective hseq
  have ht : r.time = r'.time := natStr_injective htime
  have hp : r.payload = r'.payload := payload_inj hkind hargs
  cases r; cases r'; simp_all

/-- Contrapositive: different well-formed records are signed differently. -/
theorem message_ne_of_ne {r r' : Record} (h : wf r = true) (h' : wf r' = true)
    (hne : r ≠ r') : message r ≠ message r' :=
  fun hm => hne (message_injective h h' hm)

/-! ### SignedRecord records and the log -/

/-- A signature verifier: address, message, signature.  In the browser this is
the Ed25519 implementation the badge pages already carry. -/
abbrev Verifier := String → String → String → Bool

/-- A record together with its author's signature over `message`. -/
structure SignedRecord where
  /-- The record. -/
  record : Record
  /-- The author's signature over `message rec`. -/
  sig : String
  deriving DecidableEq, Repr, Inhabited

/-- Checking one signed record. -/
def verify (V : Verifier) (s : SignedRecord) : Bool := V s.record.author (message s.record) s.sig

/-- The log: the desk's records, newest first. -/
abbrev Feed := List SignedRecord

/-- A record's identifier, the hash of its signed text.  In the page this is
the first 16 bytes of SHA-512, base58-encoded. -/
def rid (H : String → String) (r : Record) : String := H (message r)

/-- The identifiers currently in the log. -/
def ids (H : String → String) (f : Feed) : List String := f.map (fun s => rid H s.record)

/-- What a record points at inside the log.  A trade id is *not* in here: it
names a transaction on chain, not a record of this log. -/
def refs : Payload → List String
  | .attach newsId _ _ => [newsId]
  | .comment parentId _ => [parentId]
  | .share targetId _ => [targetId]
  | _ => []

/-- The sequence numbers an author has already used. -/
def authorSeqs (f : Feed) (a : String) : List Nat :=
  (f.filter (fun s => s.record.author == a)).map (fun s => s.record.seq)

/-- **The acceptance rule.**  Everything the desk checks before a record joins
the log. -/
def acceptable (V : Verifier) (H : String → String) (f : Feed) (s : SignedRecord) : Bool :=
  wf s.record && verify V s &&
    !(ids H f).contains (rid H s.record) &&
    (refs s.record.payload).all (fun i => (ids H f).contains i) &&
    (authorSeqs f s.record.author).all (fun n => n < s.record.seq)

/-- What `acceptable` says, unpacked. -/
theorem acceptable_iff {V H} {f : Feed} {s : SignedRecord} :
    acceptable V H f s = true ↔
      wf s.record = true ∧ verify V s = true ∧ rid H s.record ∉ ids H f ∧
        (∀ i ∈ refs s.record.payload, i ∈ ids H f) ∧
        (∀ n ∈ authorSeqs f s.record.author, n < s.record.seq) := by
  simp only [acceptable, Bool.and_eq_true, List.all_eq_true, List.contains_iff_mem,
    decide_eq_true_eq]
  simp only [show ((!(ids H f).contains (rid H s.record)) = true) ↔ rid H s.record ∉ ids H f by simp]
  tauto

/-- Posting: the log grows by one accepted record, or not at all. -/
def post (V : Verifier) (H : String → String) (f : Feed) (s : SignedRecord) : Option Feed :=
  if acceptable V H f s then some (s :: f) else none

/-- A log built only by posting. -/
inductive Valid (V : Verifier) (H : String → String) : Feed → Prop
  | nil : Valid V H []
  | cons {f : Feed} {s : SignedRecord} : Valid V H f → acceptable V H f s = true → Valid V H (s :: f)

/-! ### Posting -/

theorem post_eq_some_iff {V H f s g} :
    post V H f s = some g ↔ acceptable V H f s = true ∧ g = s :: f := by
  unfold post
  cases h : acceptable V H f s <;> simp [eq_comm]

/-- **Append only.**  A successful post adds the new record and changes
nothing else: the old log is a suffix of the new one. -/
theorem post_append_only {V H f s g} (h : post V H f s = some g) : f <:+ g := by
  rw [(post_eq_some_iff.mp h).2]
  exact ⟨[s], rfl⟩

theorem post_valid {V H f s g} (hf : Valid V H f) (h : post V H f s = some g) :
    Valid V H g := by
  obtain ⟨hacc, rfl⟩ := post_eq_some_iff.mp h
  exact .cons hf hacc

/-- **No replay.**  A record already in the log — the same record, byte for
byte, with the same signature and nonce — is refused. -/
theorem post_replay_rejected {V H f s} (h : rid H s.record ∈ ids H f) :
    post V H f s = none := by
  have hacc : ¬ acceptable V H f s = true := fun hc => (acceptable_iff.mp hc).2.2.1 h
  simp [post, Bool.eq_false_iff.mpr hacc]

/-- A record referring to something the log does not have is refused. -/
theorem post_dangling_rejected {V H f s i} (hi : i ∈ refs s.record.payload)
    (h : i ∉ ids H f) : post V H f s = none := by
  have hacc : ¬ acceptable V H f s = true := fun hc => h ((acceptable_iff.mp hc).2.2.2.1 i hi)
  simp [post, Bool.eq_false_iff.mpr hacc]

/-! ### Everything in a valid log is signed by its author -/

theorem valid_acceptable {V H} {f : Feed} (hf : Valid V H f) {s : SignedRecord} (hs : s ∈ f) :
    ∃ g, Valid V H g ∧ acceptable V H g s = true := by
  induction hf with
  | nil => cases hs
  | @cons g t hg hacc ih =>
    rcases List.mem_cons.mp hs with rfl | hmem
    · exact ⟨g, hg, hacc⟩
    · exact ih hmem

/-- **Authenticity.**  Every record in a valid log carries a signature that
verifies against the address it names. -/
theorem valid_verify {V H} {f : Feed} (hf : Valid V H f) {s : SignedRecord} (hs : s ∈ f) :
    verify V s = true := by
  obtain ⟨g, -, hacc⟩ := valid_acceptable hf hs
  exact (acceptable_iff.mp hacc).2.1

theorem valid_wf {V H} {f : Feed} (hf : Valid V H f) {s : SignedRecord} (hs : s ∈ f) :
    wf s.record = true := by
  obtain ⟨g, -, hacc⟩ := valid_acceptable hf hs
  exact (acceptable_iff.mp hacc).1

/-- Unforgeability, as an assumption on the verifier (the same one the badge
protocol uses). -/
def OnlyKeyHolderSigns (V : Verifier) (HasKey : String → Prop) : Prop :=
  ∀ a msg sig, V a msg sig = true → HasKey a

/-- Honesty of the verifier about *what* was signed. -/
def SignsOnlyWhatWasSigned (V : Verifier) (Signed' : String → String → Prop) : Prop :=
  ∀ a msg sig, V a msg sig = true → Signed' a msg

/-- **Nobody can post as somebody else.**  Under unforgeability, every record
in a valid log was published by the holder of the key to the address on it. -/
theorem valid_author_holds_key {V H} {HasKey : String → Prop}
    (hV : OnlyKeyHolderSigns V HasKey) {f : Feed} (hf : Valid V H f)
    {s : SignedRecord} (hs : s ∈ f) : HasKey s.record.author :=
  hV _ _ _ (valid_verify hf hs)

/-- **Nobody's words can be edited.**  Under an honest verifier, the author of
every record in a valid log signed exactly the text of that record. -/
theorem valid_author_signed {V H} {Signed' : String → String → Prop}
    (hV : SignsOnlyWhatWasSigned V Signed') {f : Feed} (hf : Valid V H f)
    {s : SignedRecord} (hs : s ∈ f) : Signed' s.record.author (message s.record) :=
  hV _ _ _ (valid_verify hf hs)

/-! ### Identifiers -/

theorem mem_ids {H} {f : Feed} {i : String} :
    i ∈ ids H f ↔ ∃ s ∈ f, rid H s.record = i := by
  simp [ids, eq_comm]

/-- **No duplicates.**  The identifiers of a valid log are pairwise
distinct. -/
theorem valid_ids_nodup {V H} {f : Feed} (hf : Valid V H f) : (ids H f).Nodup := by
  induction hf with
  | nil => simp [ids]
  | @cons g t hg hacc ih =>
    have hfresh : rid H t.record ∉ ids H g := (acceptable_iff.mp hacc).2.2.1
    simpa [ids] using List.nodup_cons.mpr ⟨hfresh, ih⟩

/-- **An identifier names one record.**  When the hash is injective, two
records of a valid log with the same identifier are the same record — so
whatever a share or a comment points at is unambiguous. -/
theorem valid_id_unique {V H} (hH : Function.Injective H) {f : Feed} (hf : Valid V H f)
    {s t : SignedRecord} (hs : s ∈ f) (ht : t ∈ f) (h : rid H s.record = rid H t.record) :
    s.record = t.record :=
  message_injective (valid_wf hf hs) (valid_wf hf ht) (hH h)

/-! ### References resolve, backwards -/

/-- **Nothing dangles, and everything points backwards.**  In a valid log,
whatever a record refers to — a comment's parent, a share's target, an
attachment's news item — is already in the part of the log that was there
before it. -/
theorem valid_refs_resolve {V H} {f : Feed} (hf : Valid V H f) :
    ∀ (pre : Feed) (s : SignedRecord) (rest : Feed), f = pre ++ s :: rest →
      ∀ i ∈ refs s.record.payload, i ∈ ids H rest := by
  induction hf with
  | nil => intro pre s rest h; simp at h
  | @cons g t hg hacc ih =>
    intro pre s rest hsplit i hi
    cases pre with
    | nil =>
      simp only [List.nil_append, List.cons.injEq] at hsplit
      obtain ⟨rfl, rfl⟩ := hsplit
      exact (acceptable_iff.mp hacc).2.2.2.1 i hi
    | cons a pre' =>
      simp only [List.cons_append, List.cons.injEq] at hsplit
      exact ih pre' s rest hsplit.2 i hi

/-- The older part of the log is where a reference lands, so a record can
never refer to itself: the log of comments and shares is acyclic. -/
theorem valid_no_self_reference {V H} {f : Feed} (hf : Valid V H f)
    {s : SignedRecord} (hs : s ∈ f) : rid H s.record ∉ refs s.record.payload := by
  obtain ⟨pre, rest, rfl⟩ := List.append_of_mem hs
  intro hself
  have hin : rid H s.record ∈ ids H rest := valid_refs_resolve hf pre s rest rfl _ hself
  have hnodup := valid_ids_nodup hf
  have hids : ids H (pre ++ s :: rest) = ids H pre ++ rid H s.record :: ids H rest := by
    simp [ids]
  rw [hids] at hnodup
  exact (List.nodup_cons.mp (List.nodup_append.mp hnodup).2.1).1 hin

/-- A comment in a valid log has a real parent, older than itself. -/
theorem comment_parent_exists {V H} {f : Feed} (hf : Valid V H f)
    {pre : Feed} {s : SignedRecord} {rest : Feed} (hsplit : f = pre ++ s :: rest)
    {parentId text : String} (hp : s.record.payload = .comment parentId text) :
    ∃ t ∈ rest, rid H t.record = parentId := by
  have := valid_refs_resolve hf pre s rest hsplit parentId (by simp [refs, hp])
  exact mem_ids.mp this

/-- A share in a valid log carries a real record, older than itself. -/
theorem share_target_exists {V H} {f : Feed} (hf : Valid V H f)
    {pre : Feed} {s : SignedRecord} {rest : Feed} (hsplit : f = pre ++ s :: rest)
    {targetId text : String} (hp : s.record.payload = .share targetId text) :
    ∃ t ∈ rest, rid H t.record = targetId := by
  have := valid_refs_resolve hf pre s rest hsplit targetId (by simp [refs, hp])
  exact mem_ids.mp this

/-- An attachment in a valid log is about a news record that is really
there. -/
theorem attach_news_exists {V H} {f : Feed} (hf : Valid V H f)
    {pre : Feed} {s : SignedRecord} {rest : Feed} (hsplit : f = pre ++ s :: rest)
    {newsId tradeId note : String} (hp : s.record.payload = .attach newsId tradeId note) :
    ∃ t ∈ rest, rid H t.record = newsId := by
  have := valid_refs_resolve hf pre s rest hsplit newsId (by simp [refs, hp])
  exact mem_ids.mp this

/-- **A share carries the original, unaltered.**  With an injective hash, the
record a share points at is unique in the log, and it is signed by its own
author — a sharer cannot put words in it. -/
theorem share_carries_original {V H} (hH : Function.Injective H)
    {Signed' : String → String → Prop} (hV : SignsOnlyWhatWasSigned V Signed')
    {f : Feed} (hf : Valid V H f) {pre : Feed} {s : SignedRecord} {rest : Feed}
    (hsplit : f = pre ++ s :: rest) {targetId text : String}
    (hp : s.record.payload = .share targetId text) :
    ∃ t ∈ f, rid H t.record = targetId ∧ Signed' t.record.author (message t.record) ∧
      ∀ u ∈ f, rid H u.record = targetId → u.record = t.record := by
  obtain ⟨t, ht, hid⟩ := share_target_exists hf hsplit hp
  have htf : t ∈ f := by rw [hsplit]; exact List.mem_append_right _ (List.mem_cons_of_mem _ ht)
  refine ⟨t, htf, hid, valid_author_signed hV hf htf, ?_⟩
  intro u hu hu'
  exact valid_id_unique hH hf hu htf (hu'.trans hid.symm)

/-! ### Sequence numbers -/

theorem mem_authorSeqs {f : Feed} {a : String} {n : Nat} :
    n ∈ authorSeqs f a ↔ ∃ s ∈ f, s.record.author = a ∧ s.record.seq = n := by
  simp only [authorSeqs, List.mem_map, List.mem_filter, beq_iff_eq]
  constructor
  · rintro ⟨s, ⟨hs, ha⟩, rfl⟩; exact ⟨s, hs, ha, rfl⟩
  · rintro ⟨s, hs, ha, rfl⟩; exact ⟨s, ⟨hs, ha⟩, rfl⟩

/-- **An author's records are strictly ordered.**  Anything an author posted
before carries a strictly smaller sequence number, so a missing or reordered
record of theirs is visible in the numbering. -/
theorem valid_seq_strict_mono {V H} {f : Feed} (hf : Valid V H f)
    {pre : Feed} {s : SignedRecord} {rest : Feed} (hsplit : f = pre ++ s :: rest)
    {t : SignedRecord} (ht : t ∈ rest) (hsame : t.record.author = s.record.author) :
    t.record.seq < s.record.seq := by
  induction hf generalizing pre with
  | nil => simp [List.append_eq_nil_iff] at hsplit
  | @cons g u hg hacc ih =>
    cases pre with
    | nil =>
      simp only [List.nil_append, List.cons.injEq] at hsplit
      obtain ⟨rfl, rfl⟩ := hsplit
      exact (acceptable_iff.mp hacc).2.2.2.2 t.record.seq
        (mem_authorSeqs.mpr ⟨t, ht, hsame, rfl⟩)
    | cons a pre' =>
      simp only [List.cons_append, List.cons.injEq] at hsplit
      exact ih hsplit.2

/-! ### Tampering -/

/-- **Editing a record needs a fresh signature.**  Take a record of the log and
alter anything at all — the text, the link, the time, the trade a piece of news
is attached to — and the altered record verifies only if its author signed the
altered text too. -/
theorem tampering_needs_new_signature {V} {Signed' : String → String → Prop}
    (hV : SignsOnlyWhatWasSigned V Signed') {r r' : Record} {sig' : String}
    (hwf : wf r = true) (hwf' : wf r' = true) (hne : r' ≠ r)
    (h : verify V ⟨r', sig'⟩ = true) :
    Signed' r'.author (message r') ∧ message r' ≠ message r :=
  ⟨hV _ _ _ h, message_ne_of_ne hwf' hwf hne⟩

/-- **An attachment is bound to its trade.**  The same news item attached to
another trade is another record with another signed text: an attachment cannot
be moved from one trade to another. -/
theorem attach_binds_trade {r r' : Record} (hwf : wf r = true) (hwf' : wf r' = true)
    {newsId tradeId tradeId' note note' : String}
    (hp : r.payload = .attach newsId tradeId note)
    (hp' : r'.payload = .attach newsId tradeId' note')
    (hdiff : tradeId ≠ tradeId') : message r ≠ message r' := by
  refine message_ne_of_ne hwf hwf' ?_
  intro hrr
  rw [hrr, hp'] at hp
  simp at hp
  exact hdiff hp.1.symm

/-- **A comment is bound to what it comments on.**  Re-pointing a comment at
another record changes the signed text. -/
theorem comment_binds_parent {r r' : Record} (hwf : wf r = true) (hwf' : wf r' = true)
    {parentId parentId' text : String}
    (hp : r.payload = .comment parentId text)
    (hp' : r'.payload = .comment parentId' text)
    (hdiff : parentId ≠ parentId') : message r ≠ message r' := by
  refine message_ne_of_ne hwf hwf' ?_
  intro hrr
  rw [hrr, hp'] at hp
  simp at hp
  exact hdiff hp.symm

/-- **A record is bound to the address that makes it.**  Two well-formed
records by different authors have different signed texts — so the same social
handle claimed from two addresses is two claims, and neither can be re-stamped
with the other's address. -/
theorem message_binds_author {r r' : Record} (hwf : wf r = true) (hwf' : wf r' = true)
    (hdiff : r.author ≠ r'.author) : message r ≠ message r' := by
  refine message_ne_of_ne hwf hwf' ?_
  intro hrr
  exact hdiff (by rw [hrr])

/-- And under unforgeability only the key holder can make the claim at all. -/
theorem account_claim_requires_key {V} {HasKey : String → Prop}
    (hV : OnlyKeyHolderSigns V HasKey) {s : SignedRecord}
    (h : verify V s = true) : HasKey s.record.author :=
  hV _ _ _ h

/-! ### Mutual social links -/

/-- A social account link is *mutual* when the senator's address published the
handle and the account itself published the address.  Only the second half is
outside this file's reach, so it is named as an oracle. -/
def MutualLink (V : Verifier) (Publishes : String → String → String → Prop)
    (s : SignedRecord) (platform handle : String) : Prop :=
  s.record.payload = .account platform handle (match s.record.payload with
    | .account _ _ p => p | _ => "") ∧ verify V s = true ∧
    Publishes platform handle s.record.author

/-- **A mutual link is unambiguous.**  If an account publishes at most one
address, two mutual links for the same account name the same senator: a handle
cannot be shared between two addresses. -/
theorem mutual_link_unique {V} {Publishes : String → String → String → Prop}
    (hfun : ∀ p h a b, Publishes p h a → Publishes p h b → a = b)
    {s t : SignedRecord} {platform handle : String}
    (hs : MutualLink V Publishes s platform handle)
    (ht : MutualLink V Publishes t platform handle) :
    s.record.author = t.record.author :=
  hfun platform handle _ _ hs.2.2 ht.2.2

/-! ### Domain separation from the badge -/

theorem domainTag_sepFree : SepFree domainTag := by decide

theorem badge_domainTag_sepFree : SepFree Badges.Claim.domainTag := by decide

/-- The badge challenge is the same shape of join, under its own tag. -/
theorem badge_challenge_eq_join (p : Badges.Claim.ClaimPage) (nonce : String) :
    Badges.Claim.challenge p nonce =
      joinFields [Badges.Claim.domainTag, p.address, Badges.Claim.statement p, nonce] := by
  apply String.toList_inj.mp
  simp [Badges.Claim.challenge, Badges.Claim.challengePrefix, joinFields, List.append_assoc]

/-- **A desk signature is not a badge signature.**  The two protocols put
different tags in the first field of the signed text, so no signature made at
the desk can be replayed as a badge claim, and no badge claim can be replayed
as a post. -/
theorem desk_message_ne_badge_challenge (r : Record) (p : Badges.Claim.ClaimPage)
    (nonce : String) : message r ≠ Badges.Claim.challenge p nonce := by
  rw [badge_challenge_eq_join]
  simpa [message, fields] using
    joinFields_ne_of_head_ne (t := r.author :: natStr r.seq :: natStr r.time :: r.nonce ::
        kindTag r.payload :: args r.payload)
      (u := [p.address, Badges.Claim.statement p, nonce])
      domainTag_sepFree badge_domainTag_sepFree (by decide)

/-! ### Reading the log -/

/-- The comments on a record. -/
def commentsOn (f : Feed) (id : String) : Feed :=
  f.filter (fun s => match s.record.payload with | .comment p _ => p == id | _ => false)

/-- The shares of a record. -/
def sharesOf (f : Feed) (id : String) : Feed :=
  f.filter (fun s => match s.record.payload with | .share t _ => t == id | _ => false)

/-- The news attached to a trade. -/
def newsForTrade (f : Feed) (tradeId : String) : List String :=
  f.filterMap (fun s => match s.record.payload with
    | .attach newsId t _ => if t = tradeId then some newsId else none
    | _ => none)

theorem mem_commentsOn {f : Feed} {id : String} {s : SignedRecord} :
    s ∈ commentsOn f id ↔ s ∈ f ∧ ∃ text, s.record.payload = .comment id text := by
  simp only [commentsOn, List.mem_filter, and_congr_right_iff]
  intro _
  cases s.record.payload <;> simp only [beq_iff_eq, Payload.comment.injEq] <;> simp [eq_comm]

/-- Everything shown in a thread is authentic: a comment displayed under a
record is signed by the senator it names. -/
theorem commentsOn_verify {V H} {f : Feed} (hf : Valid V H f) {id : String}
    {s : SignedRecord} (hs : s ∈ commentsOn f id) : verify V s = true :=
  valid_verify hf (mem_commentsOn.mp hs).1

/-- A thread under an identifier the log does not know is empty: the desk
never shows a comment whose parent it cannot produce. -/
theorem commentsOn_unknown_empty {V H} {f : Feed} (hf : Valid V H f) {id : String}
    (hid : id ∉ ids H f) : commentsOn f id = [] := by
  rcases hc : commentsOn f id with _ | ⟨s, rest⟩
  · rfl
  · exfalso
    have hs : s ∈ commentsOn f id := by rw [hc]; simp
    obtain ⟨hsf, text, hp⟩ := mem_commentsOn.mp hs
    obtain ⟨pre, rest', rfl⟩ := List.append_of_mem hsf
    obtain ⟨t, ht, hid'⟩ := comment_parent_exists hf rfl hp
    exact hid (mem_ids.mpr ⟨t, List.mem_append_right _ (List.mem_cons_of_mem _ ht), hid'⟩)

/-- Every news item the desk shows against a trade comes from a record of the
log that says exactly that. -/
theorem mem_newsForTrade {f : Feed} {tradeId newsId : String} :
    newsId ∈ newsForTrade f tradeId ↔
      ∃ s ∈ f, ∃ note, s.record.payload = .attach newsId tradeId note := by
  simp only [newsForTrade, List.mem_filterMap]
  constructor
  · rintro ⟨s, hs, hmap⟩
    cases hp : s.record.payload with
    | attach n t note =>
      rw [hp] at hmap
      by_cases htt : t = tradeId
      · subst htt
        simp at hmap
        exact ⟨s, hs, note, by rw [hp, hmap]⟩
      · simp [htt] at hmap
    | _ => rw [hp] at hmap; simp at hmap
  · rintro ⟨s, hs, note, hp⟩
    exact ⟨s, hs, by rw [hp]; simp⟩



/-! ### One worked record, pinned to the JavaScript

`scripts/test_desk_js.js` checks that `scripts/desk.js` builds this exact
string for this exact record, so the two implementations are known to agree on
at least one full record of each shape. -/

/-- A news record of the leading senate address. -/
def exampleNews : Record :=
  { author := "AtTjQKXo1CYTa2MuxPARtr382ZyhPU5YX4wMMpvaa1oy", seq := 1, time := 1745833745,
    nonce := "0f1e2d", payload := .news "https://example.org/a" "Headline" "Reuters" }

theorem exampleNews_message :
    message exampleNews =
      "SOLFUNMEME-SENATE-DESK-v1|AtTjQKXo1CYTa2MuxPARtr382ZyhPU5YX4wMMpvaa1oy|1|1745833745|0f1e2d|news|https://example.org/a|Headline|Reuters" := by
  simp [message, fields, exampleNews, kindTag, args, joinFields, natStr, digitChar, domainTag]

theorem exampleNews_wf : wf exampleNews = true := by
  simp [wf, fields, exampleNews, kindTag, args, sepFreeB, natStr, digitChar, domainTag]
  decide

end Senate.Desk
