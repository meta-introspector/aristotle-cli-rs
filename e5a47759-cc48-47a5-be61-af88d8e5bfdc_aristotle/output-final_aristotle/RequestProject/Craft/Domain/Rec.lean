/-
# Domain data codec — the record/token backbone

Every emitted representation of the domain is a rendering of the *same* token
stream.  This file defines

* `Field`, `Rec` — the flat record model that the canonical domain graph is
  projected onto (a record has a kind, an identity and an ordered list of
  scalar or list-valued fields);
* `Tok` — the token stream shared by all five formats;
* `toToks` / `ofToks` and the round-trip theorem `ofToks_toToks`.

Because every format is obtained by rendering the *same* tokens line by line,
the cross-representation invariant of the specification (§18) is a consequence
of a single per-format lemma `parseLine (renderLine t) = some t`.
-/
import RequestProject.Craft.Domain.Escape

namespace Domain

/-! ## Records -/

/-- A record field value: either a scalar string or an ordered list of strings. -/
inductive Field where
  | scalar : String → Field
  | items : List String → Field
  deriving Repr, DecidableEq, Inhabited

/-- A flat record: a kind tag, an identity, and ordered fields. -/
structure Rec where
  kind : String
  id : String
  fields : List (String × Field)
  deriving Repr, DecidableEq, Inhabited

/-! ## Tokens -/

/-- One line of an emitted document, format-independently. -/
inductive Tok where
  | header : String → Tok
  | recStart : String → String → Tok
  | scalar : String → String → Tok
  | listStart : String → Tok
  | item : String → Tok
  | listEnd : Tok
  | recEnd : Tok
  | footer : Tok
  deriving Repr, DecidableEq, Inhabited

/-- The tokens of one field. -/
def fieldToks : String × Field → List Tok
  | (k, .scalar v) => [.scalar k v]
  | (k, .items vs) => .listStart k :: (vs.map .item ++ [.listEnd])

/-- The tokens of a field list. -/
def fieldsToks (fs : List (String × Field)) : List Tok := fs.flatMap fieldToks

/-- The tokens of one record. -/
def recToks (r : Rec) : List Tok :=
  .recStart r.kind r.id :: (fieldsToks r.fields ++ [.recEnd])

/-- The tokens of a list of records. -/
def recsToks (rs : List Rec) : List Tok := rs.flatMap recToks

/-- The token stream of a whole document: a header carrying the document
identity, the records, and a footer. -/
def toToks (docId : String) (rs : List Rec) : List Tok :=
  .header docId :: (recsToks rs ++ [.footer])

/-! ## Parsing the token stream

The parser is a single structural recursion over the token list.  Reading a
suffix of the document yields the records completed in that suffix, the fields
of the record that is still open at that point, and the items of the list that
is still open at that point. -/

/-- Parse a suffix of a token stream: returns the completed records, the
fields of the still-open record, and the items of the still-open list. -/
def go : List Tok → Option (List Rec × List (String × Field) × List String)
  | [] => none
  | .footer :: ts => if ts.isEmpty then some ([], [], []) else none
  | .recEnd :: ts =>
      match go ts with
      | some (rs, _, _) => some (rs, [], [])
      | none => none
  | .listEnd :: ts =>
      match go ts with
      | some (rs, fs, _) => some (rs, fs, [])
      | none => none
  | .item v :: ts =>
      match go ts with
      | some (rs, fs, its) => some (rs, fs, v :: its)
      | none => none
  | .listStart k :: ts =>
      match go ts with
      | some (rs, fs, its) => some (rs, (k, .items its) :: fs, [])
      | none => none
  | .scalar k v :: ts =>
      match go ts with
      | some (rs, fs, its) => some (rs, (k, .scalar v) :: fs, its)
      | none => none
  | .recStart k i :: ts =>
      match go ts with
      | some (rs, fs, its) => some (⟨k, i, fs⟩ :: rs, [], its)
      | none => none
  | .header _ :: _ => none

/-- Parse a complete document token stream. -/
def ofToks (ts : List Tok) : Option (String × List Rec) :=
  match ts with
  | .header d :: rest =>
      match go rest with
      | some (rs, [], []) => some (d, rs)
      | _ => none
  | _ => none

/-! ## The round trip -/

theorem go_items (vs : List String) (rest : List Tok) {rs fs its}
    (h : go rest = some (rs, fs, its)) :
    go (vs.map .item ++ rest) = some (rs, fs, vs ++ its) := by
  induction vs with
  | nil => simpa using h
  | cons v vs ih => simp only [List.map_cons, List.cons_append, go, ih]

theorem go_fields (flds : List (String × Field)) (rest : List Tok) {rs fs}
    (h : go rest = some (rs, fs, [])) :
    go (fieldsToks flds ++ rest) = some (rs, flds ++ fs, []) := by
  induction flds with
  | nil => simpa [fieldsToks] using h
  | cons f flds ih =>
      obtain ⟨k, v⟩ := f
      rw [show fieldsToks ((k, v) :: flds) = fieldToks (k, v) ++ fieldsToks flds from rfl]
      cases v with
      | scalar s =>
          rw [show fieldToks (k, Field.scalar s) = [Tok.scalar k s] from rfl]
          simp only [List.cons_append, go, List.nil_append, ih]
      | items vs =>
          rw [show fieldToks (k, Field.items vs)
              = Tok.listStart k :: (vs.map Tok.item ++ [Tok.listEnd]) from rfl]
          have hle : go (Tok.listEnd :: (fieldsToks flds ++ rest))
              = some (rs, flds ++ fs, []) := by
            simp only [go, ih]
          simp only [List.cons_append, List.append_assoc, go, List.nil_append]
          rw [go_items vs (Tok.listEnd :: (fieldsToks flds ++ rest)) hle]
          simp

theorem go_recs (rcs : List Rec) (rest : List Tok) {rs}
    (h : go rest = some (rs, [], [])) :
    go (recsToks rcs ++ rest) = some (rcs ++ rs, [], []) := by
  induction rcs with
  | nil => simpa [recsToks] using h
  | cons r rcs ih =>
      obtain ⟨k, i, flds⟩ := r
      rw [show recsToks (⟨k, i, flds⟩ :: rcs) = recToks ⟨k, i, flds⟩ ++ recsToks rcs from rfl,
        show recToks (⟨k, i, flds⟩ : Rec)
          = Tok.recStart k i :: (fieldsToks flds ++ [Tok.recEnd]) from rfl]
      have hre : go (Tok.recEnd :: (recsToks rcs ++ rest)) = some (rcs ++ rs, [], []) := by
        simp only [go, ih]
      simp only [List.cons_append, List.append_assoc, go, List.nil_append]
      rw [go_fields flds (Tok.recEnd :: (recsToks rcs ++ rest)) hre]
      simp

theorem go_document (rs : List Rec) :
    go (recsToks rs ++ [Tok.footer]) = some (rs, [], []) := by
  have h : go [Tok.footer] = some (([] : List Rec), [], []) := by simp [go]
  simpa using go_recs rs [Tok.footer] h

theorem ofToks_toToks (docId : String) (rs : List Rec) :
    ofToks (toToks docId rs) = some (docId, rs) := by
  simp only [toToks, ofToks, go_document]

end Domain
