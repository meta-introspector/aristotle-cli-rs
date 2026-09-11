import Mathlib

/-!
# Comment threads in a link

The formal counterpart of `web/js/thread.js`: the conversation about a
rendering travels in the URL beside it (`#th=…`), so a thread is shared the
same way a picture is — by sending a link.

A comment is `{ parent, author, text, ts }` together with `id`, the fingerprint
of a canonical line built from all four.  What is proved:

*The wire format is lossless and unambiguous.*  `unescape_escape` and
`splitOnTilde_joinTilde` — escaping removes every separator from the data
(`tilde_not_mem_escape`), so a line splits back into exactly the fields it was
joined from: `decode_encode`, and hence `encodeFields_inj`.

*A comment cannot be edited in transit.*  `canonical_inj` — two comments with
the same canonical line are the same comment; `id_ne_of_text_ne` — so with an
injective fingerprint, changing so much as the text gives a different id, which
is what the studio's integrity check catches; `orphan_of_edit` — and every
reply that named the old comment is left an orphan, which the pane reports
rather than hides.

*A thread is a forest.*  A reply can only name a comment that already exists,
so a parent always sits earlier in the list (`parent_lt`); ancestry therefore
strictly decreases the position (`ancestor_lt`) and no comment is its own
ancestor (`not_ancestor_self`): a conversation cannot loop.

*Threads merge cleanly.*  `toFinset_merge`, `merge_idem`, `merge_comm`,
`merge_assoc`, `subset_merge` — two people replying at once end with one
conversation once they have swapped links, in whatever order those arrive, and
nothing already held is ever lost.

`tests/node/test_lab.mjs` checks the shipped JavaScript against the same
statements.
-/

namespace Hesper.Thread

/-! ## The wire format

Each comment is one line, its fields separated by `~`, with `~` and `%` escaped
out of the data first.  That is what makes the split unambiguous. -/

def escapeChar (c : Char) : List Char :=
  if c = '%' then ['%', '2', '5'] else if c = '~' then ['%', '7', 'E'] else [c]

def escape (s : List Char) : List Char := s.flatMap escapeChar

def unescape : List Char → List Char
  | '%' :: '2' :: '5' :: rest => '%' :: unescape rest
  | '%' :: '7' :: 'E' :: rest => '~' :: unescape rest
  | c :: rest => c :: unescape rest
  | [] => []

theorem unescape_cons {c : Char} (h : c ≠ '%') (rest : List Char) :
    unescape (c :: rest) = c :: unescape rest := by
  conv_lhs => unfold unescape
  split <;> simp_all

/-- Escaping is undone exactly. -/
theorem unescape_escape (s : List Char) : unescape (escape s) = s := by
  induction s with
  | nil => rfl
  | cons c s ih =>
    unfold escape at *
    by_cases h1 : c = '%'
    · subst h1; simp [escapeChar, unescape, ih]
    · by_cases h2 : c = '~'
      · subst h2; simp [escapeChar, unescape, ih]
      · have hc : escapeChar c = [c] := by simp [escapeChar, h1, h2]
        rw [List.flatMap_cons, hc, List.singleton_append, unescape_cons h1, ih]

/-- Escaped data carries no separator. -/
theorem tilde_not_mem_escape (s : List Char) : '~' ∉ escape s := by
  intro h
  unfold escape at h
  rw [List.mem_flatMap] at h
  obtain ⟨c, _, hc⟩ := h
  unfold escapeChar at hc
  by_cases h1 : c = '%'
  · simp [h1] at hc
  · by_cases h2 : c = '~'
    · rw [if_neg h1, if_pos h2, List.mem_cons] at hc
      simp at hc
    · rw [if_neg h1, if_neg h2, List.mem_singleton] at hc
      exact h2 hc.symm

/-- Split a line on the separator. -/
def splitOnTilde : List Char → List (List Char)
  | [] => [[]]
  | c :: cs =>
    if c = '~' then [] :: splitOnTilde cs
    else match splitOnTilde cs with
      | [] => [[c]]
      | f :: fs => (c :: f) :: fs

/-- Join fields with the separator. -/
def joinTilde : List (List Char) → List Char
  | [] => []
  | [f] => f
  | f :: fs => f ++ '~' :: joinTilde fs

theorem splitOnTilde_of_no_tilde {f : List Char} (h : '~' ∉ f) : splitOnTilde f = [f] := by
  induction f with
  | nil => rfl
  | cons c cs ih =>
    have hc : c ≠ '~' := by intro hcon; exact h (by simp [hcon])
    have hcs : '~' ∉ cs := fun hcon => h (by simp [hcon])
    simp [splitOnTilde, hc, ih hcs]

theorem splitOnTilde_append {f t : List Char} (h : '~' ∉ f) :
    splitOnTilde (f ++ '~' :: t) = f :: splitOnTilde t := by
  induction f with
  | nil => simp [splitOnTilde]
  | cons c cs ih =>
    have hc : c ≠ '~' := by intro hcon; exact h (by simp [hcon])
    have hcs : '~' ∉ cs := fun hcon => h (by simp [hcon])
    simp [splitOnTilde, hc, ih hcs]

/-- **A line splits back into exactly the fields it was joined from.** -/
theorem splitOnTilde_joinTilde : ∀ {fs : List (List Char)}, fs ≠ [] →
    (∀ f ∈ fs, '~' ∉ f) → splitOnTilde (joinTilde fs) = fs := by
  intro fs
  induction fs with
  | nil => intro h _; exact absurd rfl h
  | cons f fs ih =>
    intro _ hno
    cases fs with
    | nil => simpa [joinTilde] using splitOnTilde_of_no_tilde (hno f (by simp))
    | cons g gs =>
      have hf : '~' ∉ f := hno f (by simp)
      have hrest : ∀ x ∈ g :: gs, '~' ∉ x := fun x hx => hno x (by simp [hx])
      have hj : joinTilde (f :: g :: gs) = f ++ '~' :: joinTilde (g :: gs) := rfl
      rw [hj, splitOnTilde_append hf, ih (by simp) hrest]

/-- Pack a record's fields into one line. -/
def encodeFields (fs : List (List Char)) : List Char := joinTilde (fs.map escape)

/-- Read a line back into its fields. -/
def decodeFields (line : List Char) : List (List Char) :=
  (splitOnTilde line).map unescape

/-- **A record round-trips through a link.** -/
theorem decode_encode {fs : List (List Char)} (h : fs ≠ []) :
    decodeFields (encodeFields fs) = fs := by
  unfold decodeFields encodeFields
  rw [splitOnTilde_joinTilde (by simpa using h) (by
    intro f hf
    simp only [List.mem_map] at hf
    obtain ⟨x, _, rfl⟩ := hf
    exact tilde_not_mem_escape x)]
  simp [List.map_map, Function.comp_def, unescape_escape]

/-- Two records with the same line are the same record. -/
theorem encodeFields_inj {fs gs : List (List Char)} (hf : fs ≠ []) (hg : gs ≠ [])
    (h : encodeFields fs = encodeFields gs) : fs = gs := by
  have := congrArg decodeFields h
  rwa [decode_encode hf, decode_encode hg] at this

/-! ## Comments -/

/-- A comment: what it replies to, who wrote it, what it says, and when. -/
structure Comment where
  parent : List Char
  author : List Char
  text : List Char
  /-- The time, as it is written into the line. -/
  ts : List Char
  deriving DecidableEq, Inhabited

/-- The fields a comment's fingerprint is taken from. -/
def fields (c : Comment) : List (List Char) :=
  [c.parent, c.author, c.ts, c.text]

@[simp] theorem fields_ne_nil (c : Comment) : fields c ≠ [] := by simp [fields]

/-- The canonical line of a comment. -/
def canonical (c : Comment) : List Char := encodeFields (fields c)

/-- Comments with the same canonical line agree on every field. -/
theorem fields_inj {a b : Comment} (h : canonical a = canonical b) : fields a = fields b :=
  encodeFields_inj (fields_ne_nil a) (fields_ne_nil b) h

theorem text_eq_of_canonical_eq {a b : Comment} (h : canonical a = canonical b) :
    a.text = b.text := by
  have := fields_inj h
  simpa [fields] using congrArg (fun l => l.getD 3 []) this

theorem parent_eq_of_canonical_eq {a b : Comment} (h : canonical a = canonical b) :
    a.parent = b.parent := by
  have := fields_inj h
  simpa [fields] using congrArg (fun l => l.getD 0 []) this

theorem author_eq_of_canonical_eq {a b : Comment} (h : canonical a = canonical b) :
    a.author = b.author := by
  have := fields_inj h
  simpa [fields] using congrArg (fun l => l.getD 1 []) this

/-- Two comments with the same canonical line are the same comment. -/
theorem canonical_inj {a b : Comment} (h : canonical a = canonical b) : a = b := by
  have hf := fields_inj h
  obtain ⟨pa, aa, ta, na⟩ := a
  obtain ⟨pb, ab, tb, nb⟩ := b
  simp only [fields, List.cons.injEq, and_true] at hf
  obtain ⟨h1, h2, h3, h4⟩ := hf
  simp_all

/-- The identity of a comment, under a fingerprint `hash`. -/
def cid (hash : List Char → String) (c : Comment) : String := hash (canonical c)

/-- **An edited comment is a different comment.** -/
theorem id_ne_of_text_ne {hash : List Char → String} (hinj : Function.Injective hash)
    {a b : Comment} (h : a.text ≠ b.text) : cid hash a ≠ cid hash b := by
  intro hc
  exact h (text_eq_of_canonical_eq (hinj hc))

/-! ## Threads -/

/-- A comment as it sits in a thread: its contents and the id it claims. -/
structure Entry where
  comment : Comment
  id : String
  deriving DecidableEq, Inhabited

/-- An entry is intact when its id really is the fingerprint of its contents. -/
def Intact (hash : List Char → String) (e : Entry) : Prop := e.id = cid hash e.comment

/-- A thread is well formed when every reply names a comment that already
exists in it — which is the only way a reply can be written. -/
def WellFormed (t : List Entry) : Prop :=
  ∀ i (hi : i < t.length), (t[i]).comment.parent ≠ [] →
    ∃ j, ∃ (_ : j < i), (t[j]'(by omega)).id = String.ofList (t[i]).comment.parent

/-- The ids in a thread are distinct: the studio keys comments by id. -/
def IdsNodup (t : List Entry) : Prop := (t.map Entry.id).Nodup

/-- In a well-formed thread with distinct ids, a parent sits strictly earlier
than its child. -/
theorem parent_lt {t : List Entry} (h : WellFormed t) (hnd : IdsNodup t)
    {i j : ℕ} (hi : i < t.length) (hj : j < t.length)
    (hp : (t[i]).comment.parent ≠ [])
    (hij : (t[j]).id = String.ofList (t[i]).comment.parent) : j < i := by
  obtain ⟨k, hk, hkid⟩ := h i hi hp
  have hklt : k < t.length := by omega
  have hsame : (t[j]).id = (t[k]'hklt).id := by rw [hij, hkid]
  have : j = k := by
    have hmapj : (t.map Entry.id)[j]'(by simpa using hj) = (t[j]).id := by simp
    have hmapk : (t.map Entry.id)[k]'(by simpa using hklt) = (t[k]'hklt).id := by simp
    have := hnd.getElem_inj_iff (hi := by simpa using hj) (hj := by simpa using hklt)
    rw [hmapj, hmapk] at this
    exact this.mp hsame
  omega

/-- Ancestry inside a thread, as indices. -/
def ParentRel (t : List Entry) (i j : ℕ) : Prop :=
  ∃ (hi : i < t.length) (hj : j < t.length),
    (t[i]).comment.parent ≠ [] ∧ (t[j]).id = String.ofList (t[i]).comment.parent

/-- **Ancestry strictly decreases the position in the thread.** -/
theorem ancestor_lt {t : List Entry} (h : WellFormed t) (hnd : IdsNodup t)
    {i j : ℕ} (hij : Relation.TransGen (ParentRel t) i j) : j < i := by
  induction hij with
  | single hr =>
    obtain ⟨hi, hj, hp, hid⟩ := hr
    exact parent_lt h hnd hi hj hp hid
  | tail hr hlast ih =>
    obtain ⟨hi, hj, hp, hid⟩ := hlast
    exact lt_trans (parent_lt h hnd hi hj hp hid) ih

/-- **A conversation cannot loop**: no comment is its own ancestor. -/
theorem not_ancestor_self {t : List Entry} (h : WellFormed t) (hnd : IdsNodup t) (i : ℕ) :
    ¬ Relation.TransGen (ParentRel t) i i := by
  intro hcon
  exact lt_irrefl i (ancestor_lt h hnd hcon)

/-- Editing a comment orphans its replies: nothing carries the id the reply
names any more. -/
theorem orphan_of_edit {hash : List Char → String} (hinj : Function.Injective hash)
    {parent parent' : Comment} {reply : Entry}
    (hne : parent.text ≠ parent'.text)
    (hreply : String.ofList reply.comment.parent = cid hash parent) :
    String.ofList reply.comment.parent ≠ cid hash parent' := by
  rw [hreply]
  exact id_ne_of_text_ne hinj hne

/-! ## Merging threads

Comments arrive in links, and the same link may be opened twice, so a thread is
a grow-only set keyed by id. -/

def merge (a b : List Entry) : List Entry := (a ++ b).dedup

@[simp] theorem mem_merge {x : Entry} {a b : List Entry} :
    x ∈ merge a b ↔ x ∈ a ∨ x ∈ b := by
  unfold merge; simp

theorem toFinset_merge (a b : List Entry) :
    (merge a b).toFinset = a.toFinset ∪ b.toFinset := by
  ext x; simp

theorem merge_idem (a : List Entry) : (merge a a).toFinset = a.toFinset := by
  rw [toFinset_merge]; simp

theorem merge_comm (a b : List Entry) :
    (merge a b).toFinset = (merge b a).toFinset := by
  rw [toFinset_merge, toFinset_merge, Finset.union_comm]

theorem merge_assoc (a b c : List Entry) :
    (merge (merge a b) c).toFinset = (merge a (merge b c)).toFinset := by
  rw [toFinset_merge, toFinset_merge, toFinset_merge, toFinset_merge, Finset.union_assoc]

/-- Merging keeps every comment already held: a thread only grows. -/
theorem subset_merge (a b : List Entry) : ∀ x ∈ a, x ∈ merge a b := by
  intro x hx; simp [hx]

end Hesper.Thread
