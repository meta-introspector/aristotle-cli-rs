import RequestProject.Solfunmeme.Mesh.Quote
import RequestProject.Solfunmeme.Senate.Wire

/-!
# Signed market posts, and co-signing them

A **post** is what leaves a node: a title, the token and slot window it is
about, and *the quotes themselves* — never a picture of them, never a number
without the readings behind it.  A chart, a report and a meme are all rendered
from the same `View`, so a reader can recompute every pixel of what they were
shown (`Mesh.Chart`).

A post is signed over one canonical text, built with the desk's wire format
(`Senate.Wire`), and `message_injective` proves that text determines the post.
Everything else follows from that one fact:

* **you cannot move a signature onto other data** — `tamper_needs_new_signature`;
* **co-signing is signing the same text** — a second reader who has checked the
  data appends an endorsement over the identical message (`cosign`), so
  `cosign_preserves_view` and `valid_cosigners_signed_view` together say that
  every name on a post is a name on *this* data;
* **a citation pins its source** — a new post imports earlier posts by the
  digest of their message, and `import_binds_source` shows that with an
  injective digest the citation determines the cited post, so nobody can swap
  the market data under a quote of it.

The one thing assumed rather than proved is the signature scheme: `Verifier` is
abstract, and the statements that need unforgeability take it as an explicit
hypothesis, exactly as the senators' desk does.
-/

namespace Mesh

open Senate.Wire

/-! ## Views -/

/-- What a post shows: a window of the market, with its data attached. -/
structure View where
  /-- Human-readable title of the view. -/
  title : String
  /-- The token this view is about. -/
  token : Nat
  /-- First slot of the window. -/
  fromSlot : Nat
  /-- Last slot of the window. -/
  toSlot : Nat
  /-- The readings the view is computed from. -/
  quotes : Board
  deriving DecidableEq, Repr, Inhabited

/-- The five fields of a quote on the wire. -/
def quoteFields (q : Quote) : List String :=
  [natStr q.token, natStr q.venue, natStr q.slot, natStr q.price, natStr q.size]

@[simp] theorem quoteFields_length (q : Quote) : (quoteFields q).length = 5 := rfl

theorem quoteFields_inj {q r : Quote} (h : quoteFields q = quoteFields r) : q = r := by
  simp only [quoteFields, List.cons.injEq] at h
  obtain ⟨h1, h2, h3, h4, h5, -⟩ := h
  have e1 : q.token = r.token := natStr_injective h1
  have e2 : q.venue = r.venue := natStr_injective h2
  have e3 : q.slot = r.slot := natStr_injective h3
  have e4 : q.price = r.price := natStr_injective h4
  have e5 : q.size = r.size := natStr_injective h5
  cases q; cases r
  simp_all

theorem flatMap_quoteFields_inj {l m : Board}
    (h : l.flatMap quoteFields = m.flatMap quoteFields) : l = m := by
  induction l generalizing m with
  | nil =>
    cases m with
    | nil => rfl
    | cons b s => simp [quoteFields] at h
  | cons a t ih =>
    cases m with
    | nil => simp [quoteFields] at h
    | cons b s =>
      simp only [List.flatMap_cons] at h
      obtain ⟨hq, hr⟩ := List.append_inj h (by simp)
      rw [quoteFields_inj hq, ih hr]

/-- The wire fields of a view: the header, the number of readings, then the
readings. -/
def viewFields (v : View) : List String :=
  v.title :: natStr v.token :: natStr v.fromSlot :: natStr v.toSlot ::
    natStr v.quotes.length :: v.quotes.flatMap quoteFields

theorem viewFields_inj {v w : View} (h : viewFields v = viewFields w) : v = w := by
  simp only [viewFields, List.cons.injEq] at h
  obtain ⟨ht, hk, hf, hto, -, hq⟩ := h
  have h1 : v.token = w.token := natStr_injective hk
  have h2 : v.fromSlot = w.fromSlot := natStr_injective hf
  have h3 : v.toSlot = w.toSlot := natStr_injective hto
  have h4 : v.quotes = w.quotes := flatMap_quoteFields_inj hq
  cases v; cases w
  simp_all

/-! ## Posts -/

/-- A post: who, when, what they are showing, and what they are co-signing. -/
structure Post where
  /-- Base-58 public key of the author. -/
  author : String
  /-- The author's own counter. -/
  seq : Nat
  /-- Unix time as claimed by the author. -/
  time : Nat
  /-- Digests of the posts this one imports and endorses. -/
  imports : List String
  /-- The market view being published. -/
  view : View
  deriving DecidableEq, Repr, Inhabited

/-- Domain separation: a mesh post is not a desk record and not a badge
challenge. -/
def domainTag : String := "SOLFUNMEME-MESH-QUOTE-v1"

/-- The wire fields of a post. -/
def postFields (p : Post) : List String :=
  domainTag :: p.author :: natStr p.seq :: natStr p.time ::
    natStr p.imports.length :: (p.imports ++ viewFields p.view)

/-- **The signed text.**  `scripts/mesh.js` builds the same string with
`fields.join("|")`. -/
def message (p : Post) : String := joinFields (postFields p)

/-- A separator-free field, as a `Bool`. -/
def sepFreeB (s : String) : Bool := !s.toList.contains sep

theorem sepFreeB_iff {s : String} : sepFreeB s = true ↔ SepFree s := by
  simp [sepFreeB, SepFree]

/-- A post is well formed when no field carries the separator. -/
def wf (p : Post) : Bool := (postFields p).all sepFreeB

theorem wf_fields {p : Post} (h : wf p = true) : ∀ s ∈ postFields p, SepFree s := by
  intro s hs
  exact sepFreeB_iff.mp (List.all_eq_true.mp h s hs)

theorem postFields_ne_nil (p : Post) : postFields p ≠ [] := by simp [postFields]

/-- **The signed text determines the post.**  Two well-formed posts with the
same canonical message are the same post — same author, same window, same
readings, same citations. -/
theorem message_injective {p q : Post} (hp : wf p = true) (hq : wf q = true)
    (hm : message p = message q) : p = q := by
  have hf : postFields p = postFields q :=
    joinFields_injective (wf_fields hp) (wf_fields hq) (postFields_ne_nil p)
      (postFields_ne_nil q) hm
  simp only [postFields, List.cons.injEq] at hf
  obtain ⟨-, ha, hs, ht, hn, hrest⟩ := hf
  have hlen : p.imports.length = q.imports.length := natStr_injective hn
  obtain ⟨himp, hview⟩ := List.append_inj hrest hlen
  have hv : p.view = q.view := viewFields_inj hview
  have hseq : p.seq = q.seq := natStr_injective hs
  have htime : p.time = q.time := natStr_injective ht
  cases p; cases q
  simp_all

/-- Contrapositive: different well-formed posts are signed differently. -/
theorem message_ne_of_ne {p q : Post} (hp : wf p = true) (hq : wf q = true) (hne : p ≠ q) :
    message p ≠ message q :=
  fun hm => hne (message_injective hp hq hm)

/-! ## Signatures and endorsements -/

/-- A signature verifier: key, message, signature.  In the page this is
WebCrypto ECDSA P-256; in Lean it stays abstract. -/
abbrev Verifier := String → String → String → Bool

/-- One name on a post: the author's own signature, or a co-signature. -/
structure Endorsement where
  /-- Base-58 public key of the signer. -/
  signer : String
  /-- Their signature over `message post`. -/
  sig : String
  deriving DecidableEq, Repr, Inhabited

/-- A post with the signatures collected on it, author first. -/
structure SignedPost where
  /-- The post itself. -/
  post : Post
  /-- Author's signature first, then co-signatures in the order they arrived. -/
  sigs : List Endorsement
  deriving DecidableEq, Repr, Inhabited

/-- The names on a post. -/
def signers (sp : SignedPost) : List String := sp.sigs.map Endorsement.signer

/-- Check one endorsement against the post's canonical text. -/
def verifyEndorsement (V : Verifier) (p : Post) (e : Endorsement) : Bool :=
  V e.signer (message p) e.sig

/-- The acceptance rule for a signed post: well formed, at least the author's
signature, the author signs first, every signature checks out over the same
text, and nobody signs twice. -/
def verifyPost (V : Verifier) (sp : SignedPost) : Bool :=
  wf sp.post && (sp.sigs.head?.map Endorsement.signer == some sp.post.author) &&
    sp.sigs.all (verifyEndorsement V sp.post) && (signers sp).Nodup

theorem verifyPost_iff {V : Verifier} {sp : SignedPost} :
    verifyPost V sp = true ↔
      wf sp.post = true ∧ sp.sigs.head?.map Endorsement.signer = some sp.post.author ∧
        (∀ e ∈ sp.sigs, verifyEndorsement V sp.post e = true) ∧ (signers sp).Nodup := by
  simp only [verifyPost, Bool.and_eq_true, List.all_eq_true, beq_iff_eq, decide_eq_true_eq]
  tauto

theorem verifyPost_wf {V sp} (h : verifyPost V sp = true) : wf sp.post = true :=
  (verifyPost_iff.mp h).1

/-- A verified post carries at least the author's signature. -/
theorem verifyPost_sigs_ne_nil {V sp} (h : verifyPost V sp = true) : sp.sigs ≠ [] := by
  intro hnil
  have := (verifyPost_iff.mp h).2.1
  simp [hnil] at this

/-- **Every name on a verified post signed exactly this data.** -/
theorem valid_cosigners_signed_view {V : Verifier} {sp : SignedPost}
    (h : verifyPost V sp = true) {e : Endorsement} (he : e ∈ sp.sigs) :
    V e.signer (message sp.post) e.sig = true :=
  (verifyPost_iff.mp h).2.2.1 e he

/-- Unforgeability, as an assumption on the verifier: only the holder of a key
produces signatures that check under it.  `HasKey k m` reads "the holder of `k`
signed `m`". -/
theorem valid_signers_hold_keys {V : Verifier} {HasKey : String → String → Prop}
    (hV : ∀ k m s, V k m s = true → HasKey k m) {sp : SignedPost}
    (h : verifyPost V sp = true) {e : Endorsement} (he : e ∈ sp.sigs) :
    HasKey e.signer (message sp.post) :=
  hV _ _ _ (valid_cosigners_signed_view h he)

/-- **A signature cannot be moved onto other data.**  If a signature that was
made over `p` also checks out over a well-formed `q`, then `q` is `p` — unless
the signer signed twice. -/
theorem tamper_needs_new_signature {V : Verifier} {HasKey : String → String → Prop}
    (hV : ∀ k m s, V k m s = true → HasKey k m) {p q : Post} (hp : wf p = true)
    (hq : wf q = true) (hne : p ≠ q) {e : Endorsement}
    (hsig : V e.signer (message p) e.sig = true)
    (hforge : V e.signer (message q) e.sig = true) :
    HasKey e.signer (message p) ∧ HasKey e.signer (message q) ∧ message p ≠ message q :=
  ⟨hV _ _ _ hsig, hV _ _ _ hforge, message_ne_of_ne hp hq hne⟩

/-! ## Co-signing -/

/-- Co-sign a post: append an endorsement.  The post — and therefore the data,
the window and the chart — is untouched. -/
def cosign (sp : SignedPost) (e : Endorsement) : SignedPost :=
  { sp with sigs := sp.sigs ++ [e] }

@[simp] theorem cosign_post (sp : SignedPost) (e : Endorsement) : (cosign sp e).post = sp.post :=
  rfl

/-- **Co-signing never edits the data.** -/
@[simp] theorem cosign_preserves_view (sp : SignedPost) (e : Endorsement) :
    (cosign sp e).post.view = sp.post.view := rfl

@[simp] theorem cosign_signers (sp : SignedPost) (e : Endorsement) :
    signers (cosign sp e) = signers sp ++ [e.signer] := by simp [signers, cosign]

/-- A co-signature by a new signer over the same text keeps the post valid. -/
theorem cosign_verify {V : Verifier} {sp : SignedPost} (h : verifyPost V sp = true)
    {e : Endorsement} (he : verifyEndorsement V sp.post e = true)
    (hnew : e.signer ∉ signers sp) : verifyPost V (cosign sp e) = true := by
  obtain ⟨hwf, hhead, hall, hnd⟩ := verifyPost_iff.mp h
  refine verifyPost_iff.mpr ⟨hwf, ?_, ?_, ?_⟩
  · have hhd : (sp.sigs ++ [e]).head? = sp.sigs.head? := by
      cases hs : sp.sigs with
      | nil => rw [hs] at hhead; simp at hhead
      | cons a t => simp
    simpa [cosign, hhd] using hhead
  · intro f hf
    rcases List.mem_append.mp hf with hf' | hf'
    · exact hall f hf'
    · simp only [List.mem_singleton] at hf'
      subst hf'
      exact he
  · rw [cosign_signers]
    exact List.Nodup.append hnd (by simp) (by simpa using hnew)

/-- The number of names on a verified post is the number of *distinct* people
who checked it. -/
theorem verified_signers_nodup {V : Verifier} {sp : SignedPost} (h : verifyPost V sp = true) :
    (signers sp).Nodup := (verifyPost_iff.mp h).2.2.2

/-! ## Importing and citing -/

/-- The identifier of a post: a digest of its canonical text.  In the page this
is SHA-256 truncated to 16 bytes, base-58 encoded. -/
def rid (H : String → String) (p : Post) : String := H (message p)

/-- **A citation pins its source.**  With an injective digest, two well-formed
posts with the same identifier are the same post: importing a post by id and
then checking the id is enough to know you are looking at the data that was
signed. -/
theorem import_binds_source {H : String → String} (hH : Function.Injective H) {p q : Post}
    (hp : wf p = true) (hq : wf q = true) (h : rid H p = rid H q) : p = q :=
  message_injective hp hq (hH h)

/-- A post *endorses* another when it carries its identifier. -/
def Endorses (H : String → String) (p q : Post) : Prop := rid H q ∈ p.imports

/-- **The data behind a citation cannot be swapped.**  Two different
well-formed posts never share an identifier, so a post that cites an id cites
at most one body of market data. -/
theorem cited_data_cannot_be_swapped {H : String → String} (hH : Function.Injective H)
    {q q' : Post} (hq : wf q = true) (hq' : wf q' = true) (hne : q ≠ q') :
    rid H q ≠ rid H q' :=
  fun h => hne (import_binds_source hH hq hq' h)

/-- Co-signing leaves the citations alone, so an endorsement chain survives
being endorsed. -/
@[simp] theorem cosign_preserves_endorses {H : String → String} {sp : SignedPost}
    {e : Endorsement} {q : Post} : Endorses H (cosign sp e).post q ↔ Endorses H sp.post q :=
  Iff.rfl

end Mesh
