import Mathlib

/-!
# Libraries of named objects: seals, merging, certificates and what may be published

The specification of `web/js/library.js` and of the escaping in
`web/js/commons.js`.

A **record** is one named object taken from an outside source (the LMFDB, the
OEIS, Wikidata).  Everything about it but its seal is its canonical form, its
`body`; the seal is the hash of that body.  A record whose body no longer
hashes to its seal is refused rather than drawn, so an edit made anywhere
between the source and the reader — in a file, in a link, in someone's fork of
a library — is caught.

A **library** is a list of records.  Opening one merges it into what the reader
already holds: only records that verify are admitted, no identifier is held
twice, and a record already held is never replaced.  That is what makes opening
a library safe: the worst a bad library can do is add nothing.

A **certificate** is what makes a rendering citable: the hash of the exact
playbook, the sealed records it drew from, and the result of every check that
was recomputed.  Auditing one against what the reader holds is a decision, and
it is positive only when the playbook and every record are the ones the
certificate names.

Finally, text that is about to become a Wikimedia Commons file page is
**escaped**: every character that could open a template, a link, a category, a
table cell, a tag, a heading or a signature is replaced by its numeric entity.

What is proved:

* `verify_sealWith`, `sealWith_idempotent`, `verify_iff` — sealing works,
  sealing twice is sealing once, and a seal asserts exactly one thing;
* `body_of_verify_of_hash_eq`, `tamper_detected` — under a collision-free hash,
  two records that verify under the same seal have the same body, so any change
  to a body is detected;
* `mem_keep`, `keep_verify`, `keep_nodup_id`, `keep_idem` — admission keeps only
  verified records of the input, never repeats an identifier, and is idempotent;
* `merge_verify`, `merge_subset`, `merge_left_untouched`, `merge_self` — merging
  admits nothing broken, invents nothing, never replaces a record the reader
  holds, and opening the same library twice changes nothing;
* `certified_iff`, `audit_certify`, `audit_of_other_playbook`,
  `audit_of_altered_record` — “certified” means every check passed, and a
  certificate audits against exactly the playbook and the records it was
  written for;
* `escape_no_opener`, `escape_of_safe`, `escape_preserves_safe` — escaped text
  contains no character that can open markup, leaves safe text alone, and keeps
  every safe character it was given.
-/

namespace Hesper.Library

/-! ## Records and their seals -/

/-- A record: its identifier, the canonical form of everything else, and the
seal taken over that canonical form. -/
structure Record where
  id : String
  body : String
  hash : String
deriving DecidableEq, Repr

variable (H : String → String)

/-- The seal a record should carry. -/
def digest (r : Record) : String := H r.body

/-- The record, sealed.  (`seal` is a Lean keyword, hence the name.) -/
def sealWith (r : Record) : Record := { r with hash := H r.body }

/-- Does this record still say what it said when it was sealed? -/
def verify (r : Record) : Bool := r.hash == H r.body

@[simp] theorem sealWith_id (r : Record) : (sealWith H r).id = r.id := rfl

@[simp] theorem sealWith_body (r : Record) : (sealWith H r).body = r.body := rfl

@[simp] theorem verify_sealWith (r : Record) : verify H (sealWith H r) = true := by
  simp [verify, sealWith]

@[simp] theorem sealWith_idempotent (r : Record) :
    sealWith H (sealWith H r) = sealWith H r := rfl

theorem verify_iff {r : Record} : verify H r = true ↔ r.hash = H r.body := by
  simp [verify]

/-- Under a collision-free hash, two records that verify and carry the same
seal have the same contents. -/
theorem body_of_verify_of_hash_eq (hinj : Function.Injective H) {r s : Record}
    (hr : verify H r = true) (hs : verify H s = true) (h : r.hash = s.hash) :
    r.body = s.body := by
  rw [verify_iff] at hr hs
  exact hinj (by rw [← hr, ← hs, h])

/-- So a record whose contents were changed while its seal was kept is refused.
This is what the studio relies on when it reads a library out of a file or a
link. -/
theorem tamper_detected (hinj : Function.Injective H) {r s : Record}
    (hr : verify H r = true) (hne : s.body ≠ r.body) (hsame : s.hash = r.hash) :
    verify H s = false := by
  by_contra h
  exact hne (body_of_verify_of_hash_eq H hinj (by simpa using h) hr hsame)

/-! ## Libraries: admitting and merging -/

/-- The identifiers admitted so far, after reading a list. -/
def seenAfter : List String → List Record → List String
  | seen, [] => seen
  | seen, r :: rs =>
      if verify H r = true ∧ r.id ∉ seen then seenAfter (r.id :: seen) rs else seenAfter seen rs

/-- Admission: keep the records that verify, in the order given, and never a
second record with an identifier already kept. -/
def keepAux : List String → List Record → List Record
  | _, [] => []
  | seen, r :: rs =>
      if verify H r = true ∧ r.id ∉ seen then r :: keepAux (r.id :: seen) rs else keepAux seen rs

/-- What a library becomes when it is opened. -/
def keep (rs : List Record) : List Record := keepAux H [] rs

/-- Opening a library: everything already held, then everything of the new one
that is admissible and not held already. -/
def merge (a b : List Record) : List Record := keep H (a ++ b)

/-- The record held under this identifier, if any. -/
def find (rs : List Record) (id : String) : Option Record :=
  rs.find? (fun r => r.id == id)

@[simp] theorem keepAux_nil (seen : List String) : keepAux H seen [] = [] := rfl

@[simp] theorem seenAfter_nil (seen : List String) : seenAfter H seen [] = seen := rfl

theorem keepAux_cons_pos {seen : List String} {a : Record} {rs : List Record}
    (h : verify H a = true ∧ a.id ∉ seen) :
    keepAux H seen (a :: rs) = a :: keepAux H (a.id :: seen) rs := by
  simp [keepAux, h]

theorem keepAux_cons_neg {seen : List String} {a : Record} {rs : List Record}
    (h : ¬ (verify H a = true ∧ a.id ∉ seen)) :
    keepAux H seen (a :: rs) = keepAux H seen rs := by
  simp [keepAux, h]

/-- Everything admitted was in the library that was opened, verifies, and was
not held already. -/
theorem mem_keepAux {seen : List String} {rs : List Record} {r : Record}
    (h : r ∈ keepAux H seen rs) : r ∈ rs ∧ verify H r = true ∧ r.id ∉ seen := by
  induction rs generalizing seen with
  | nil => simp at h
  | cons a as ih =>
      by_cases hc : verify H a = true ∧ a.id ∉ seen
      · rw [keepAux_cons_pos H hc] at h
        rcases List.mem_cons.mp h with rfl | hmem
        · exact ⟨List.mem_cons_self, hc.1, hc.2⟩
        · obtain ⟨h1, h2, h3⟩ := ih hmem
          exact ⟨List.mem_cons_of_mem _ h1, h2, fun hx => h3 (List.mem_cons_of_mem _ hx)⟩
      · rw [keepAux_cons_neg H hc] at h
        obtain ⟨h1, h2, h3⟩ := ih h
        exact ⟨List.mem_cons_of_mem _ h1, h2, h3⟩

/-- Nothing broken is ever admitted. -/
theorem keep_verify {rs : List Record} : ∀ r ∈ keep H rs, verify H r = true :=
  fun _ h => (mem_keepAux H h).2.1

/-- Nothing is admitted that was not offered. -/
theorem keep_subset {rs : List Record} : ∀ r ∈ keep H rs, r ∈ rs :=
  fun _ h => (mem_keepAux H h).1

/-- Reading more can only add identifiers. -/
theorem seen_subset_seenAfter (seen : List String) (rs : List Record) :
    ∀ i ∈ seen, i ∈ seenAfter H seen rs := by
  induction rs generalizing seen with
  | nil => simp
  | cons a as ih =>
      intro i hi
      by_cases hc : verify H a = true ∧ a.id ∉ seen
      · simpa [seenAfter, hc] using ih (a.id :: seen) i (List.mem_cons_of_mem _ hi)
      · simpa [seenAfter, hc] using ih seen i hi

/-- Every identifier admitted is an identifier seen. -/
theorem id_mem_seenAfter {seen : List String} {rs : List Record} {r : Record}
    (h : r ∈ keepAux H seen rs) : r.id ∈ seenAfter H seen rs := by
  induction rs generalizing seen with
  | nil => simp at h
  | cons a as ih =>
      by_cases hc : verify H a = true ∧ a.id ∉ seen
      · rw [keepAux_cons_pos H hc] at h
        rcases List.mem_cons.mp h with rfl | hmem
        · simpa [seenAfter, hc] using
            seen_subset_seenAfter H (r.id :: seen) as r.id List.mem_cons_self
        · simpa [seenAfter, hc] using ih hmem
      · rw [keepAux_cons_neg H hc] at h
        simpa [seenAfter, hc] using ih h

/-- An identifier is held at most once. -/
theorem keepAux_nodup_id (seen : List String) (rs : List Record) :
    ((keepAux H seen rs).map Record.id).Nodup := by
  induction rs generalizing seen with
  | nil => simp
  | cons a as ih =>
      by_cases hc : verify H a = true ∧ a.id ∉ seen
      · rw [keepAux_cons_pos H hc]
        simp only [List.map_cons, List.nodup_cons]
        refine ⟨?_, ih _⟩
        intro hmem
        obtain ⟨s, hs, hid⟩ := List.mem_map.mp hmem
        exact (mem_keepAux H hs).2.2 (hid ▸ List.mem_cons_self)
      · rw [keepAux_cons_neg H hc]; exact ih _

theorem keep_nodup_id (rs : List Record) : ((keep H rs).map Record.id).Nodup :=
  keepAux_nodup_id H [] rs

/-- A library that already verifies, holds distinct identifiers and clashes with
nothing seen is admitted exactly as it stands. -/
theorem keepAux_eq_self {seen : List String} {l : List Record}
    (hv : ∀ r ∈ l, verify H r = true) (hnd : (l.map Record.id).Nodup)
    (hfresh : ∀ r ∈ l, r.id ∉ seen) : keepAux H seen l = l := by
  induction l generalizing seen with
  | nil => simp
  | cons a as ih =>
      have hc : verify H a = true ∧ a.id ∉ seen :=
        ⟨hv a List.mem_cons_self, hfresh a List.mem_cons_self⟩
      rw [keepAux_cons_pos H hc]
      congr 1
      refine ih (fun r hr => hv r (List.mem_cons_of_mem _ hr)) (List.nodup_cons.mp hnd).2 ?_
      intro r hr hmem
      rcases List.mem_cons.mp hmem with hid | hid
      · exact (List.nodup_cons.mp hnd).1 (List.mem_map.mpr ⟨r, hr, hid⟩)
      · exact hfresh r (List.mem_cons_of_mem _ hr) hid

/-- Nothing is admitted twice: a library all of whose identifiers are already
held adds nothing. -/
theorem keepAux_nil_of_seen {seen : List String} {l : List Record}
    (h : ∀ r ∈ l, r.id ∈ seen) : keepAux H seen l = [] := by
  induction l generalizing seen with
  | nil => simp
  | cons a as ih =>
      have hc : ¬ (verify H a = true ∧ a.id ∉ seen) := by
        rintro ⟨-, hn⟩
        exact hn (h a List.mem_cons_self)
      rw [keepAux_cons_neg H hc]
      exact ih (fun r hr => h r (List.mem_cons_of_mem _ hr))

/-- Admission reads one library after the other. -/
theorem keepAux_append (seen : List String) (l m : List Record) :
    keepAux H seen (l ++ m) = keepAux H seen l ++ keepAux H (seenAfter H seen l) m := by
  induction l generalizing seen with
  | nil => simp
  | cons a as ih =>
      by_cases hc : verify H a = true ∧ a.id ∉ seen
      · rw [List.cons_append, keepAux_cons_pos H hc, keepAux_cons_pos H hc, ih]
        simp [seenAfter, hc]
      · rw [List.cons_append, keepAux_cons_neg H hc, keepAux_cons_neg H hc, ih]
        simp [seenAfter, hc]

/-- Admitting an admitted library changes nothing. -/
theorem keep_idem (rs : List Record) : keep H (keep H rs) = keep H rs :=
  keepAux_eq_self H (keep_verify H) (keep_nodup_id H rs) (by simp)

/-- Merging admits only records that verify. -/
theorem merge_verify (a b : List Record) : ∀ r ∈ merge H a b, verify H r = true :=
  fun _ h => keep_verify H _ h

/-- Merging invents nothing: everything in the result came from one side. -/
theorem merge_subset (a b : List Record) : ∀ r ∈ merge H a b, r ∈ a ∨ r ∈ b := by
  intro r h
  simpa using List.mem_append.mp (keep_subset H _ h)

/-- Opening a library never replaces a record the reader already holds: the
first record of what is held is still found, unchanged, under its identifier. -/
theorem merge_left_untouched (r : Record) (a b : List Record) (hv : verify H r = true) :
    find (merge H (r :: a) b) r.id = some r := by
  have h : merge H (r :: a) b = r :: keepAux H [r.id] (a ++ b) := by
    simpa [merge, keep, List.cons_append] using
      keepAux_cons_pos H (seen := ([] : List String)) (a := r) (rs := a ++ b) ⟨hv, by simp⟩
  rw [h, find]
  simp

/-- Opening the same library a second time changes nothing. -/
theorem merge_self (a : List Record) : merge H (keep H a) (keep H a) = keep H a := by
  have hself : keepAux H [] (keep H a) = keep H a :=
    keepAux_eq_self H (keep_verify H) (keep_nodup_id H a) (by simp)
  have hsecond : keepAux H (seenAfter H [] (keep H a)) (keep H a) = [] := by
    refine keepAux_nil_of_seen H ?_
    intro r hr
    exact id_mem_seenAfter H (by rwa [hself])
  rw [merge, keep, keepAux_append, hself, hsecond, List.append_nil]

/-! ## Certificates -/

/-- One recomputation and what it said. -/
structure Check where
  id : String
  ok : Bool
deriving DecidableEq, Repr

/-- A record as a certificate cites it. -/
structure Cited where
  id : String
  hash : String
  checks : List Check
deriving DecidableEq, Repr

/-- What a rendering claims: this playbook, these records, these checks. -/
structure Cert where
  playbookHash : String
  records : List Cited
  checks : Nat
  failed : Nat
  certified : Bool
deriving DecidableEq, Repr

/-- The certificate of a rendering. -/
def certify (playbook : String) (cited : List Cited) : Cert :=
  let all := cited.flatMap Cited.checks
  { playbookHash := H playbook
    records := cited
    checks := all.length
    failed := (all.filter (fun c => !c.ok)).length
    certified := !all.isEmpty && all.all (fun c => c.ok) }

/-- Reading a certificate against what the reader holds: the playbook must be
the one it names, every record it cites that is held must be held with the same
seal, and the certificate must say that everything passed. -/
def audit (c : Cert) (playbook : String) (held : List Record) : Bool :=
  (c.playbookHash == H playbook)
    && c.records.all (fun x => match find held x.id with
        | none => true
        | some r => (r.hash == x.hash) && verify H r)
    && c.certified

/-- “Certified” means: something was recomputed, and all of it passed. -/
theorem certified_iff (playbook : String) (cited : List Cited) :
    (certify H playbook cited).certified = true ↔
      cited.flatMap Cited.checks ≠ [] ∧ ∀ c ∈ cited.flatMap Cited.checks, c.ok = true := by
  constructor
  · intro h
    obtain ⟨h1, h2⟩ := Bool.and_eq_true_iff.mp h
    exact ⟨by simpa [List.isEmpty_iff] using h1, List.all_eq_true.mp h2⟩
  · rintro ⟨h1, h2⟩
    exact Bool.and_eq_true_iff.mpr
      ⟨by simpa [List.isEmpty_iff] using h1, List.all_eq_true.mpr h2⟩

/-- A freshly issued certificate audits against the very playbook and the very
records it was written for. -/
theorem audit_certify (playbook : String) (held : List Record) (cited : List Cited)
    (hcited : ∀ x ∈ cited, ∀ r, find held x.id = some r → r.hash = x.hash ∧ verify H r = true)
    (hall : ∀ c ∈ cited.flatMap Cited.checks, c.ok = true)
    (hne : cited.flatMap Cited.checks ≠ []) :
    audit H (certify H playbook cited) playbook held = true := by
  have hcert : (certify H playbook cited).certified = true :=
    (certified_iff H playbook cited).mpr ⟨hne, hall⟩
  refine Bool.and_eq_true_iff.mpr ⟨Bool.and_eq_true_iff.mpr ⟨by simp [certify], ?_⟩, hcert⟩
  simp only [certify, List.all_eq_true]
  intro x hx
  cases hfind : find held x.id with
  | none => simp
  | some r =>
      obtain ⟨h1, h2⟩ := hcited x hx r hfind
      simp [h1, h2]

/-- A certificate does not audit against a different playbook. -/
theorem audit_of_other_playbook (hinj : Function.Injective H) (playbook other : String)
    (held : List Record) (cited : List Cited) (hne : other ≠ playbook) :
    audit H (certify H playbook cited) other held = false := by
  have h : H playbook ≠ H other := fun h => hne (hinj h).symm
  simp [audit, certify, h]

/-- A certificate does not audit against a record that has changed since. -/
theorem audit_of_altered_record (playbook : String) (x : Cited) (cited : List Cited)
    (held : List Record) (r : Record) (hx : x ∈ cited)
    (hfind : find held x.id = some r) (hdiff : r.hash ≠ x.hash) :
    audit H (certify H playbook cited) playbook held = false := by
  simp only [audit, certify, Bool.and_eq_false_iff, List.all_eq_false]
  exact Or.inl (Or.inr ⟨x, hx, by simp [hfind, hdiff]⟩)

/-! ## What may be published: escaping wikitext -/

/-- The characters that can open or close markup on a wiki page: links,
templates, tables, tags, headings, lists, signatures and emphasis. -/
def dangerous : List Char :=
  ['[', ']', '{', '}', '|', '<', '>', '\'', '&', '=', '~', '*', '#', ':', ';', '!']

/-- Those of them that must not survive escaping.  `&`, `#` and `;` are what a
numeric entity is made of, so they are what the escaper itself emits. -/
def openers : List Char :=
  ['[', ']', '{', '}', '|', '<', '>', '\'', '=', '~', '*', ':', '!']

/-- The decimal numeral of a number, as characters. -/
def digitsOf (n : Nat) : List Char :=
  (Nat.digits 10 n).reverse.map (fun d => Char.ofNat (48 + d))

/-- One character, escaped: itself, or its numeric entity. -/
def escChar (c : Char) : List Char :=
  if c ∈ dangerous then '&' :: '#' :: (digitsOf c.toNat ++ [';']) else [c]

/-- Text, made inert. -/
def escape (cs : List Char) : List Char := cs.flatMap escChar

/-- A character of a decimal numeral is a decimal digit. -/
private theorem digitsOf_range {n : Nat} {c : Char} (h : c ∈ digitsOf n) :
    48 ≤ c.toNat ∧ c.toNat ≤ 57 := by
  simp [digitsOf] at h
  obtain ⟨d, hd, rfl⟩ := h
  have h10 : d < 10 := Nat.digits_lt_base (by norm_num) hd
  have hv : (48 + d) < 0xd800 := by omega
  simp [Char.ofNat, Nat.isValidChar, hv, Char.toNat, Char.ofNatAux]
  omega

/-- Every opener is dangerous, and none of them is a decimal digit. -/
private theorem openers_dangerous : ∀ c ∈ openers, c ∈ dangerous := by
  simp [openers, dangerous]

private theorem openers_not_digit : ∀ c ∈ openers, c.toNat < 48 ∨ 57 < c.toNat := by
  intro c hc
  fin_cases hc <;> decide

/-- No character that can open markup survives escaping. -/
theorem escape_no_opener (cs : List Char) (c : Char) (hc : c ∈ openers) :
    c ∉ escape cs := by
  intro h
  obtain ⟨x, _, hmem⟩ := List.mem_flatMap.mp h
  by_cases hd : x ∈ dangerous
  · rw [escChar, if_pos hd] at hmem
    rcases List.mem_cons.mp hmem with rfl | h1
    · exact absurd hc (by decide)
    rcases List.mem_cons.mp h1 with rfl | h2
    · exact absurd hc (by decide)
    rcases List.mem_append.mp h2 with hdig | hsemi
    · have hr := digitsOf_range hdig
      have := openers_not_digit c hc
      omega
    · have : c = ';' := by simpa using hsemi
      subst this
      exact absurd hc (by decide)
  · rw [escChar, if_neg hd] at hmem
    have hcx : c = x := by simpa using hmem
    subst hcx
    exact hd (openers_dangerous c hc)

/-- Text with nothing dangerous in it is left exactly as it was. -/
theorem escape_of_safe (cs : List Char) (h : ∀ c ∈ cs, c ∉ dangerous) : escape cs = cs := by
  induction cs with
  | nil => simp [escape]
  | cons a as ih =>
      have ha : a ∉ dangerous := h a List.mem_cons_self
      have := ih (fun c hc => h c (List.mem_cons_of_mem _ hc))
      simp [escape, escChar, ha, List.flatMap_cons] at this ⊢
      exact this

/-- The words survive: a safe character of the input is a character of the
output. -/
theorem escape_preserves_safe {cs : List Char} {c : Char} (hc : c ∈ cs)
    (hsafe : c ∉ dangerous) : c ∈ escape cs :=
  List.mem_flatMap.mpr ⟨c, hc, by simp [escChar, hsafe]⟩

end Hesper.Library
