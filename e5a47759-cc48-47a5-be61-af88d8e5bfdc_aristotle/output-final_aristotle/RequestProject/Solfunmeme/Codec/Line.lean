import RequestProject.Solfunmeme.Codec.Table

/-!
# One adapter, five concrete syntaxes

§2 of the specification insists that every supported codec is "an adapter to
and from the same semantic object", and §18 points out why: pairwise
translators cost `O(N²)`, a standard costs `O(N)`.  This file is that
arithmetic made literal.

A `RowSyntax` says how one row of the canonical table (`Codec.Table`) is
written on one line:

```text
open_  deco₁.1 value₁ deco₁.2  sep  …  deco₆.1 value₆ deco₆.2  close_
```

and how a document is topped and tailed.  Everything else — the round trip, the
losslessness, the fact that a proof object survives — is proved *once*, here,
for every syntax satisfying `RowSyntax.WF`:

* `RowSyntax.parse_render` — the row/document layer round trips (§17);
* `RowSyntax.decode_encode` — therefore so does the canonical object;
* `RowSyntax.declaredLossiness_honest` — so the declared preservation level of
  §9 is not a claim but a theorem.

Adding a sixth format is then a `RowSyntax` value and a `by decide`.
-/

namespace Solfunmeme.Codec

/-! ## Fixed affixes -/

/-- Drop a known prefix. -/
def dropPreL : List Char → List Char → Option (List Char)
  | [], l => some l
  | _ :: _, [] => none
  | p :: ps, c :: cs => if p = c then dropPreL ps cs else none

theorem dropPreL_append (p l : List Char) : dropPreL p (p ++ l) = some l := by
  induction p with
  | nil => rfl
  | cons c cs ih => simp [dropPreL, ih]

/-- Drop a known suffix. -/
def dropSufL (s l : List Char) : Option (List Char) :=
  (dropPreL s.reverse l.reverse).map List.reverse

theorem dropSufL_append (s l : List Char) : dropSufL s (l ++ s) = some l := by
  simp [dropSufL, List.reverse_append, dropPreL_append]

/-- Drop a known prefix from a string. -/
def dropPre (p s : String) : Option String := (dropPreL p.toList s.toList).map String.ofList

/-- Drop a known suffix from a string. -/
def dropSuf (p s : String) : Option String := (dropSufL p.toList s.toList).map String.ofList

@[simp] theorem dropPre_append (p s : String) : dropPre p (p ++ s) = some s := by
  simp [dropPre, String.toList_append, dropPreL_append]

@[simp] theorem dropSuf_append (p s : String) : dropSuf p (s ++ p) = some s := by
  simp [dropSuf, String.toList_append, dropSufL_append]

/-! ## A decorated row -/

/-- The six values of a row, in the order fixed by §14. -/
def cellValues (c : Cell) : List String :=
  [c.objectId, c.objectType, c.field, c.value, c.valueType, c.parentId]

/-- Rebuild a row from its six values. -/
def cellOfValues : List String → Option Cell
  | [a, b, c, d, e, f] =>
    some { objectId := a, objectType := b, field := c, value := d, valueType := e, parentId := f }
  | _ => none

@[simp] theorem cellOfValues_cellValues (c : Cell) : cellOfValues (cellValues c) = some c := by
  simp [cellValues, cellOfValues]

theorem cellValues_length (c : Cell) : (cellValues c).length = 6 := rfl

/-- Write the decorated fields of a row. -/
def decorateFields (sp : Bool) (decos : List (String × String)) (vals : List String) :
    List String :=
  List.zipWith (fun d v => d.1 ++ escape sp v ++ d.2) decos vals

/-- Read the decorated fields of a row back. -/
def undecorateFields : List (String × String) → List String → Option (List String)
  | [], [] => some []
  | d :: ds, x :: xs =>
    match (dropPre d.1 x).bind (dropSuf d.2) with
    | some e =>
      match unescape e, undecorateFields ds xs with
      | some v, some vs => some (v :: vs)
      | _, _ => none
    | none => none
  | _, _ => none

theorem undecorateFields_decorateFields (sp : Bool) :
    ∀ (decos : List (String × String)) (vals : List String), decos.length = vals.length →
      undecorateFields decos (decorateFields sp decos vals) = some vals := by
  intro decos
  induction decos with
  | nil =>
    intro vals h
    cases vals with
    | nil => rfl
    | cons v vs => simp at h
  | cons d ds ih =>
    intro vals h
    cases vals with
    | nil => simp at h
    | cons v vs =>
      have hlen : ds.length = vs.length := by simpa using h
      have hstrip : (dropPre d.1 (d.1 ++ escape sp v ++ d.2)).bind (dropSuf d.2)
          = some (escape sp v) := by
        rw [String.append_assoc, dropPre_append]
        simp
      have hrec := ih vs hlen
      rw [decorateFields] at hrec
      simp [decorateFields, undecorateFields, hstrip, hrec]

/-! ## A line-oriented concrete syntax -/

/-- How one row of the canonical table is written on one line, and how the
document is topped and tailed. -/
structure RowSyntax where
  /-- The name of the format, as it appears in provenance and transformations. -/
  name : String
  /-- The version of this codec, as it appears in the transformation ledger. -/
  version : String
  /-- Whether the space is escaped: token-oriented syntaxes need it. -/
  escapeSpace : Bool
  /-- The character between fields. -/
  sep : Char
  /-- What opens a row. -/
  open_ : String
  /-- What closes a row. -/
  close_ : String
  /-- What surrounds each of the six fields. -/
  decos : List (String × String)
  /-- Literal lines before the rows. -/
  header : List String
  /-- Literal lines after the rows. -/
  footer : List String
  deriving DecidableEq, Repr

/-- A syntax is well formed when its own punctuation can never appear inside a
field: the separator is escaped and no affix contains the separator or a line
break.  This is decidable, so each concrete codec discharges it by `decide`. -/
def RowSyntax.WF (r : RowSyntax) : Prop :=
  r.decos.length = 6
    ∧ escCode r.escapeSpace r.sep ≠ none
    ∧ r.sep ≠ '\\'
    ∧ r.sep ≠ '\n'
    ∧ (∀ d ∈ r.decos, r.sep ∉ d.1.toList ∧ r.sep ∉ d.2.toList)
    ∧ (∀ d ∈ r.decos, '\n' ∉ d.1.toList ∧ '\n' ∉ d.2.toList)
    ∧ '\n' ∉ r.open_.toList
    ∧ '\n' ∉ r.close_.toList
    ∧ (∀ l ∈ r.header, '\n' ∉ l.toList)
    ∧ (∀ l ∈ r.footer, '\n' ∉ l.toList)

instance (r : RowSyntax) : Decidable r.WF := by
  unfold RowSyntax.WF; infer_instance

/-- Write one row. -/
def RowSyntax.renderCell (r : RowSyntax) (c : Cell) : String :=
  r.open_ ++ joinFields r.sep (decorateFields r.escapeSpace r.decos (cellValues c)) ++ r.close_

/-- Read one row. -/
def RowSyntax.parseCell (r : RowSyntax) (s : String) : Option Cell :=
  match (dropPre r.open_ s).bind (dropSuf r.close_) with
  | none => none
  | some body =>
    match undecorateFields r.decos (splitFields r.sep body) with
    | none => none
    | some vals => cellOfValues vals

theorem RowSyntax.parseCell_renderCell {r : RowSyntax} (h : r.WF) (c : Cell) :
    r.parseCell (r.renderCell c) = some c := by
  obtain ⟨hlen, hesc, hbs, _, hsep, _, _, _, _, _⟩ := h
  have hlen6 : r.decos.length = (cellValues c).length := by rw [hlen, cellValues_length]
  have hparts : ∀ x ∈ decorateFields r.escapeSpace r.decos (cellValues c),
      r.sep ∉ x.toList := by
    intro x hx
    rw [decorateFields] at hx
    obtain ⟨i, hi, hxi⟩ := List.mem_iff_getElem.mp hx
    rw [List.getElem_zipWith] at hxi
    rw [List.length_zipWith] at hi
    have hd : r.decos[i]'(by omega) ∈ r.decos := List.getElem_mem _
    have hdd := hsep _ hd
    subst hxi
    intro hmem
    rw [String.toList_append, String.toList_append, List.mem_append, List.mem_append] at hmem
    rcases hmem with (h1 | h2) | h3
    · exact hdd.1 h1
    · exact escape_no_sep hesc hbs h2
    · exact hdd.2 h3
  have hne : decorateFields r.escapeSpace r.decos (cellValues c) ≠ [] := by
    intro hcon
    rw [decorateFields, List.zipWith_eq_nil_iff] at hcon
    rcases hcon with hcon | hcon
    · rw [hcon] at hlen; simp at hlen
    · simp [cellValues] at hcon
  rw [RowSyntax.renderCell, RowSyntax.parseCell, String.append_assoc, dropPre_append]
  simp only [Option.bind_some, dropSuf_append,
    splitFields_joinFields r.sep hne hparts,
    undecorateFields_decorateFields r.escapeSpace r.decos (cellValues c) hlen6,
    cellOfValues_cellValues]

theorem RowSyntax.renderCell_no_newline {r : RowSyntax} (h : r.WF) (c : Cell) :
    '\n' ∉ (r.renderCell c).toList := by
  obtain ⟨hlen, _, _, hnlsep, _, hnl, hop, hcl, _, _⟩ := h
  intro hmem
  rw [RowSyntax.renderCell, String.toList_append, String.toList_append, List.mem_append,
    List.mem_append] at hmem
  rcases hmem with (h1 | h2) | h3
  · exact hop h1
  · rw [joinFields, String.toList_ofList] at h2
    rcases joinC_mem r.sep h2 with hs | ⟨x, hx, hcx⟩
    · exact hnlsep hs.symm
    · obtain ⟨y, hy, rfl⟩ := List.mem_map.mp hx
      rw [decorateFields] at hy
      obtain ⟨i, hi, hyi⟩ := List.mem_iff_getElem.mp hy
      rw [List.getElem_zipWith] at hyi
      rw [List.length_zipWith] at hi
      have hd : r.decos[i]'(by omega) ∈ r.decos := List.getElem_mem _
      have hdd := hnl _ hd
      subst hyi
      rw [String.toList_append, String.toList_append, List.mem_append, List.mem_append] at hcx
      rcases hcx with (k1 | k2) | k3
      · exact hdd.1 k1
      · exact escape_no_sep (by cases r.escapeSpace <;> simp [escCode]) (by decide) k2
      · exact hdd.2 k3
  · exact hcl h3

/-! ## Documents -/

/-- Drop a known list of leading lines. -/
def stripLines : List String → List String → Option (List String)
  | [], ls => some ls
  | _ :: _, [] => none
  | p :: ps, l :: ls => if p = l then stripLines ps ls else none

theorem stripLines_append (p l : List String) : stripLines p (p ++ l) = some l := by
  induction p with
  | nil => rfl
  | cons c cs ih => simp [stripLines, ih]

/-- Drop a known list of trailing lines. -/
def stripTrailing (s l : List String) : Option (List String) :=
  (stripLines s.reverse l.reverse).map List.reverse

theorem stripTrailing_append (s l : List String) : stripTrailing s (l ++ s) = some l := by
  simp [stripTrailing, List.reverse_append, stripLines_append]

/-- Write a whole table in this syntax. -/
def RowSyntax.render (r : RowSyntax) (cs : List Cell) : String :=
  joinTerm '\n' (r.header ++ cs.map r.renderCell ++ r.footer)

/-- Read a whole table in this syntax. -/
def RowSyntax.parse (r : RowSyntax) (s : String) : Option (List Cell) :=
  match splitTerm '\n' s with
  | none => none
  | some lines =>
    match stripLines r.header lines with
    | none => none
    | some rest =>
      match stripTrailing r.footer rest with
      | none => none
      | some body => mapOpt r.parseCell body

theorem RowSyntax.parse_render {r : RowSyntax} (h : r.WF) (cs : List Cell) :
    r.parse (r.render cs) = some cs := by
  have hnl : ∀ x ∈ r.header ++ cs.map r.renderCell ++ r.footer, '\n' ∉ x.toList := by
    intro x hx
    rw [List.mem_append, List.mem_append] at hx
    rcases hx with (h1 | h2) | h3
    · exact h.2.2.2.2.2.2.2.2.1 x h1
    · obtain ⟨c, _, rfl⟩ := List.mem_map.mp h2
      exact RowSyntax.renderCell_no_newline h c
    · exact h.2.2.2.2.2.2.2.2.2 x h3
  rw [RowSyntax.render, RowSyntax.parse, splitTerm_joinTerm '\n' hnl]
  simp only [List.append_assoc, stripLines_append, stripTrailing_append,
    mapOpt_map r.parseCell r.renderCell (RowSyntax.parseCell_renderCell h)]

/-! ## §36 A canonical object survives every well formed syntax -/

/-- Export a canonical object in this syntax. -/
def RowSyntax.encode (r : RowSyntax) (p : ProofObject) : String := r.render (encodeTable p)

/-- Import a canonical object from this syntax. -/
def RowSyntax.decode (r : RowSyntax) (s : String) : Option ProofObject :=
  (r.parse s).bind decodeTable

theorem RowSyntax.decode_encode {r : RowSyntax} (h : r.WF) (p : ProofObject) :
    r.decode (r.encode p) = some p := by
  rw [RowSyntax.decode, RowSyntax.encode, RowSyntax.parse_render h, Option.bind_some,
    decodeTable_encodeTable]

/-- §17: the round trip is compared semantically, not byte for byte — and it
passes with the stronger equality anyway. -/
theorem RowSyntax.semantic_roundTrip {r : RowSyntax} (h : r.WF) (p q : ProofObject)
    (hq : r.decode (r.encode p) = some q) : SemanticEq p q := by
  rw [RowSyntax.decode_encode h] at hq
  exact SemanticEq.of_eq (Option.some.inj hq)

/-- §9: every conversion must declare its preservation level. -/
def RowSyntax.declaredLossiness (_ : RowSyntax) : Lossiness := .LOSSLESS

/-- §9: a codec must not claim losslessness unless the complete semantic object
survives.  For a well formed row syntax the claim is a theorem. -/
theorem RowSyntax.declaredLossiness_honest {r : RowSyntax} (h : r.WF) :
    r.declaredLossiness = .LOSSLESS ∧ ∀ p : ProofObject, r.decode (r.encode p) = some p :=
  ⟨rfl, fun p => RowSyntax.decode_encode h p⟩

end Solfunmeme.Codec
