/-
# Standard Proof Codec — CSV adapter (SOP §14, §9)

CSV is treated as a *tabular projection* of the canonical model, using the
recommended six-column convention

```text
object_id,object_type,field,value,value_type,parent_id
```

Two layers are developed and proved here.

* **Text level.** Every cell is quoted and internal quotes are doubled, so the
  concrete CSV text of a table can be parsed back exactly:
  `parseTable_renderTable`.
* **Model level.** A proof object is projected to rows and read back. The
  projection carries identity, kind, version, status and the inputs and
  outputs with their names, declared types and values (values of nested shape
  travel as canonical text and are recovered exactly). Everything else —
  provenance, metadata, claims, certificates, diagnostics, extensions — has no
  place in the table.

Accordingly the declared preservation level of this codec is `PARTIAL`, and
that declaration is itself proved: `csv_view_roundtrip` says exactly what
survives, and `csv_not_lossless` exhibits two different proof objects with
identical CSV, so no lossless claim is possible (SOP §9).
-/
import RequestProject.Craft.Codec.Model

namespace Codec

namespace Csv

open CValue

/-! ## Text level: quoting, rendering and parsing -/

/-- Double every quote character in a cell. -/
def escape : List Char → List Char
  | [] => []
  | c :: cs => if c = '"' then '"' :: '"' :: escape cs else c :: escape cs

/-- Render one cell, always quoted. -/
def quoteCell (s : String) : List Char := '"' :: (escape s.toList ++ ['"'])

/-- Render a row: quoted cells separated by commas, terminated by a newline. -/
def renderRow : List String → List Char
  | [] => ['\n']
  | [s] => quoteCell s ++ ['\n']
  | s :: r => quoteCell s ++ ',' :: renderRow r

/-- Render a whole table. -/
def renderTable : List (List String) → List Char
  | [] => []
  | r :: rs => renderRow r ++ renderTable rs

/-- Scan the body of a quoted cell, up to the closing quote. -/
def scanCell : List Char → Option (List Char × List Char)
  | [] => none
  | '"' :: '"' :: rest => (scanCell rest).map (fun p => ('"' :: p.1, p.2))
  | '"' :: rest => some ([], rest)
  | c :: rest => (scanCell rest).map (fun p => (c :: p.1, p.2))

/-- Parse one quoted cell. -/
def parseCell : List Char → Option (String × List Char)
  | '"' :: rest => (scanCell rest).map (fun p => (String.ofList p.1, p.2))
  | _ => none

/-- Parse exactly `n` cells followed by a newline. -/
def parseCells : Nat → List Char → Option (List String × List Char)
  | 0, cs => some ([], cs)
  | 1, cs =>
      match parseCell cs with
      | some (s, '\n' :: rest) => some ([s], rest)
      | _ => none
  | n + 2, cs =>
      match parseCell cs with
      | some (s, ',' :: rest) => (parseCells (n + 1) rest).map (fun p => (s :: p.1, p.2))
      | _ => none

/-- Parse a table of rows of `w` cells; `fuel` bounds the number of rows. -/
def parseTableF : Nat → Nat → List Char → Option (List (List String))
  | _, _, [] => some []
  | 0, _, _ => none
  | fuel + 1, w, cs =>
      match parseCells w cs with
      | some (row, rest) => (parseTableF fuel w rest).map (fun rs => row :: rs)
      | none => none

/-- Parse a table of rows of `w` cells. -/
def parseTable (w : Nat) (cs : List Char) : Option (List (List String)) :=
  parseTableF cs.length w cs

/-- The remainder after a cell never starts with a quote in a well-formed
table; that is what makes a quoted cell unambiguous. -/
def notQuoteHead (rest : List Char) : Prop :=
  ∀ c r, rest = c :: r → c ≠ '"'

theorem scanCell_escape (rest : List Char) (hrest : notQuoteHead rest) :
    ∀ s : List Char, scanCell (escape s ++ '"' :: rest) = some (s, rest) := by
  intro s
  induction s with
  | nil =>
      cases hr : rest with
      | nil => simp [escape, scanCell]
      | cons c r =>
          have hc : c ≠ '"' := hrest c r hr
          simp [escape, scanCell, hc]
  | cons c cs ih =>
      by_cases h : c = '"'
      · subst h
        simp [escape, scanCell, ih]
      · simp [escape, scanCell, h, ih]

theorem parseCell_quoteCell (s : String) (rest : List Char) (hrest : notQuoteHead rest) :
    parseCell (quoteCell s ++ rest) = some (s, rest) := by
  simp only [quoteCell, List.cons_append, parseCell, List.append_assoc, List.cons_append,
    List.nil_append, scanCell_escape rest hrest s.toList, Option.map_some,
    String.ofList_toList]

theorem parseCells_renderRow :
    ∀ (row : List String), row ≠ [] → ∀ (rest : List Char),
      parseCells row.length (renderRow row ++ rest) = some (row, rest) := by
  intro row
  induction row with
  | nil => intro h; exact absurd rfl h
  | cons s tl ih =>
      intro _ rest
      cases tl with
      | nil =>
          have hq : notQuoteHead ('\n' :: rest) := by
            intro c r hc; simp only [List.cons.injEq] at hc; simp [← hc.1]
          simp only [renderRow, List.length_cons, List.length_nil, List.append_assoc,
            List.singleton_append, parseCells, parseCell_quoteCell s ('\n' :: rest) hq]
      | cons t tl' =>
          have hne : (t :: tl') ≠ [] := by simp
          have hq : notQuoteHead (',' :: (renderRow (t :: tl') ++ rest)) := by
            intro c r hc; simp only [List.cons.injEq] at hc; simp [← hc.1]
          have hstep := ih hne rest
          simp only [List.length_cons] at hstep ⊢
          simp only [renderRow, List.cons_append, List.append_assoc, parseCells,
            parseCell_quoteCell s (',' :: (renderRow (t :: tl') ++ rest)) hq, hstep,
            Option.map_some]

theorem renderRow_ne_nil (r : List String) : renderRow r ≠ [] := by
  cases r with
  | nil => simp [renderRow]
  | cons s r =>
      cases r with
      | nil => simp [renderRow, quoteCell]
      | cons t r' => simp [renderRow, quoteCell]

theorem parseTableF_cons (fuel w : Nat) (c : Char) (cs : List Char) :
    parseTableF (fuel + 1) w (c :: cs) =
      match parseCells w (c :: cs) with
      | some (row, rest) => (parseTableF fuel w rest).map (fun rs => row :: rs)
      | none => none := by
  simp [parseTableF]

theorem parseTableF_renderTable (w : Nat) :
    ∀ (rows : List (List String)) (fuel : Nat), rows.length ≤ fuel →
      (∀ r ∈ rows, r ≠ [] ∧ r.length = w) →
      parseTableF fuel w (renderTable rows) = some rows := by
  intro rows
  induction rows with
  | nil => intro fuel _ _; cases fuel <;> simp [renderTable, parseTableF]
  | cons r rs ih =>
      intro fuel hf hall
      obtain ⟨f, rfl⟩ : ∃ f, fuel = f + 1 := ⟨fuel - 1, by simp at hf; omega⟩
      obtain ⟨hr, hw⟩ := hall r (by simp)
      have hcs : renderTable (r :: rs) ≠ [] := by
        simp only [renderTable]
        intro hcon
        exact renderRow_ne_nil r (List.append_eq_nil_iff.mp hcon).1
      have hstep : parseCells w (renderTable (r :: rs)) = some (r, renderTable rs) := by
        simp only [renderTable, ← hw]
        exact parseCells_renderRow r hr (renderTable rs)
      cases hlist : renderTable (r :: rs) with
      | nil => exact absurd hlist hcs
      | cons c cs =>
          have hstep' : parseCells w (c :: cs) = some (r, renderTable rs) := by
            rw [← hlist]; exact hstep
          rw [parseTableF_cons, hstep']
          simp only [ih f (by simp at hf; omega) (fun x hx => hall x (by simp [hx])),
            Option.map_some]

/-- Text-level round trip of the CSV codec: the concrete CSV text of a table
parses back to exactly that table. -/
theorem parseTable_renderTable (w : Nat) (rows : List (List String))
    (h : ∀ r ∈ rows, r ≠ [] ∧ r.length = w) :
    parseTable w (renderTable rows) = some rows := by
  unfold parseTable
  refine parseTableF_renderTable w rows _ ?_ h
  induction rows with
  | nil => simp [renderTable]
  | cons r rs ih =>
      have hr := (h r (by simp)).1
      have : 1 ≤ (renderRow r).length := by
        cases hcase : renderRow r with
        | nil => exact absurd hcase (renderRow_ne_nil r)
        | cons a as => simp
      simp only [renderTable, List.length_cons, List.length_append]
      have := ih (fun x hx => h x (by simp [hx]))
      omega

/-! ## Model level: the six-column projection of a proof object -/

/-- One row of the tabular projection (SOP §14). -/
structure Row where
  /-- Identifier of the object this row describes. -/
  object_id : String
  /-- Kind of object: `proof`, `input`, `output`. -/
  object_type : String
  /-- Which field of that object the row carries. -/
  field : String
  /-- The value, as text. -/
  value : String
  /-- The declared type of the value. -/
  value_type : String
  /-- Identifier of the parent object, if any. -/
  parent_id : String
  deriving Repr, DecidableEq, Inhabited

namespace Row

/-- The cells of a row, in the order of the standard header. -/
def cells (r : Row) : List String :=
  [r.object_id, r.object_type, r.field, r.value, r.value_type, r.parent_id]

/-- Rebuild a row from its cells. -/
def ofCells : List String → Option Row
  | [a, b, c, d, e, f] => some ⟨a, b, c, d, e, f⟩
  | _ => none

theorem ofCells_cells (r : Row) : ofCells (cells r) = some r := by
  obtain ⟨a, b, c, d, e, f⟩ := r
  rfl

theorem cells_length (r : Row) : (cells r).length = 6 := rfl

theorem cells_ne_nil (r : Row) : cells r ≠ [] := by simp [cells]

end Row

/-- The header row of the standard projection. -/
def header : List String :=
  ["object_id", "object_type", "field", "value", "value_type", "parent_id"]

/-- Render a value as a cell, together with the type name to put in the
`value_type` column. Scalars are written plainly; anything else travels as
canonical text so that it can be recovered exactly. -/
def cellOf : CValue → String × String
  | .null => ("", "null")
  | .bool b => (if b then "true" else "false", "boolean")
  | .int n => (intText n, "integer")
  | .str s => (s, "string")
  | v => (CValue.serialize v, "canonical")

/-- Read a cell back, inferring the type conservatively (SOP §14). -/
def valueOf (text ty : String) : CValue :=
  if ty = "null" then .null
  else if ty = "boolean" then (if text = "true" then .bool true else .bool false)
  else if ty = "integer" then
    match parseIntText text with
    | some n => .int n
    | none => .str text
  else if ty = "canonical" then
    match CValue.deserialize text with
    | some v => v
    | none => .str text
  else .str text

/-- A canonical value survives the trip through a cell, up to normalization:
scalars exactly, nested values through their canonical text. -/
theorem valueOf_cellOf (v : CValue) :
    valueOf (cellOf v).1 (cellOf v).2 = CValue.normalize v := by
  cases v with
  | null => simp [cellOf, valueOf, CValue.normalize]
  | bool b => cases b <;> simp [cellOf, valueOf, CValue.normalize]
  | int n => simp [cellOf, valueOf, parseIntText_intText, CValue.normalize]
  | str s => simp [cellOf, valueOf, CValue.normalize]
  | list xs => simp [cellOf, valueOf, CValue.deserialize_serialize_eq]
  | obj fs => simp [cellOf, valueOf, CValue.deserialize_serialize_eq]

/-- Rows describing one input. -/
def inputRows (parent : String) (i : Input) : List Row :=
  [⟨i.id, "input", "name", i.name, "identifier", parent⟩,
   ⟨i.id, "input", "type", i.type, "string", parent⟩,
   ⟨i.id, "input", "value", (cellOf i.value).1, (cellOf i.value).2, parent⟩]

/-- Rows describing one output. -/
def outputRows (parent : String) (o : Output) : List Row :=
  [⟨o.id, "output", "name", o.name, "identifier", parent⟩,
   ⟨o.id, "output", "type", o.type, "string", parent⟩,
   ⟨o.id, "output", "value", (cellOf o.value).1, (cellOf o.value).2, parent⟩]

/-- The tabular projection of a proof object (SOP §14). -/
def toRows (p : ProofObject) : List Row :=
  [⟨p.id, "proof", "kind", p.kind, "string", ""⟩,
   ⟨p.id, "proof", "version", p.version, "string", ""⟩,
   ⟨p.id, "proof", "status", p.status.toName, "string", ""⟩] ++
  p.inputs.flatMap (inputRows p.id) ++
  p.outputs.flatMap (outputRows p.id)

/-- Read back the inputs written by `inputRows`, stopping at the first row that
does not continue the pattern. -/
def parseInputs : List Row → List Input × List Row
  | r1 :: r2 :: r3 :: rest =>
      if r1.object_type = "input" ∧ r1.field = "name" ∧
         r2.object_type = "input" ∧ r2.field = "type" ∧
         r3.object_type = "input" ∧ r3.field = "value" then
        let i : Input :=
          { id := r1.object_id, name := r1.value, type := r2.value,
            value := valueOf r3.value r3.value_type, encoding := none, units := none,
            constraints := [], provenance := none }
        let res := parseInputs rest
        (i :: res.1, res.2)
      else ([], r1 :: r2 :: r3 :: rest)
  | rs => ([], rs)

/-- Read back the outputs written by `outputRows`. -/
def parseOutputs : List Row → List Output × List Row
  | r1 :: r2 :: r3 :: rest =>
      if r1.object_type = "output" ∧ r1.field = "name" ∧
         r2.object_type = "output" ∧ r2.field = "type" ∧
         r3.object_type = "output" ∧ r3.field = "value" then
        let o : Output :=
          { id := r1.object_id, name := r1.value, type := r2.value,
            value := valueOf r3.value r3.value_type, encoding := none, claims := [],
            certificate := none, provenance := none }
        let res := parseOutputs rest
        (o :: res.1, res.2)
      else ([], r1 :: r2 :: r3 :: rest)
  | rs => ([], rs)

/-- Rebuild a proof object from a table. Only what the table can carry is
rebuilt; every other field takes its empty value. -/
def ofRows : List Row → Option ProofObject
  | rk :: rv :: rs :: rest =>
      if rk.object_type = "proof" ∧ rk.field = "kind" ∧
         rv.object_type = "proof" ∧ rv.field = "version" ∧
         rs.object_type = "proof" ∧ rs.field = "status" then
        match Status.ofName rs.value with
        | none => none
        | some st =>
            let ins := parseInputs rest
            let outs := parseOutputs ins.2
            if outs.2.isEmpty then
              some { (ProofObject.minimal rk.object_id rk.value st) with
                     version := rv.value, inputs := ins.1, outputs := outs.1 }
            else none
      else none
  | _ => none

/-! ## What the projection preserves -/

/-- The part of a proof object that the CSV projection carries. -/
structure View where
  /-- Identity. -/
  id : String
  /-- Kind. -/
  kind : String
  /-- Schema version. -/
  version : String
  /-- Status. -/
  status : Status
  /-- Inputs, as identifier, name, declared type and value. -/
  inputs : List (String × String × String × CValue)
  /-- Outputs, as identifier, name, declared type and value. -/
  outputs : List (String × String × String × CValue)
  deriving Repr, DecidableEq, Inhabited

/-- The CSV view of a proof object. -/
def view (p : ProofObject) : View :=
  { id := p.id, kind := p.kind, version := p.version, status := p.status,
    inputs := p.inputs.map (fun i => (i.id, i.name, i.type, CValue.normalize i.value)),
    outputs := p.outputs.map (fun o => (o.id, o.name, o.type, CValue.normalize o.value)) }

theorem parseInputs_of_outputRows (pid : String) (outs : List Output) :
    parseInputs (outs.flatMap (outputRows pid)) = ([], outs.flatMap (outputRows pid)) := by
  cases outs with
  | nil => simp [parseInputs]
  | cons o os => simp [outputRows, parseInputs, List.flatMap]

theorem parseInputs_app (pid : String) (ins : List Input) (tail : List Row)
    (htail : parseInputs tail = ([], tail)) :
    parseInputs (ins.flatMap (inputRows pid) ++ tail) =
      (ins.map (fun i =>
        (⟨i.id, i.name, i.type, CValue.normalize i.value, none, none, [], none⟩ : Input)),
       tail) := by
  induction ins with
  | nil => simpa using htail
  | cons i ins ih =>
      simp [inputRows, parseInputs, ih, valueOf_cellOf i.value]

theorem parseOutputs_app (pid : String) (outs : List Output) (tail : List Row)
    (htail : parseOutputs tail = ([], tail)) :
    parseOutputs (outs.flatMap (outputRows pid) ++ tail) =
      (outs.map (fun o =>
        (⟨o.id, o.name, o.type, CValue.normalize o.value, none, [], none, none⟩ : Output)),
       tail) := by
  induction outs with
  | nil => simpa using htail
  | cons o outs ih =>
      simp [outputRows, parseOutputs, ih, valueOf_cellOf o.value]

/-- The CSV projection preserves exactly the view: identity, kind, version,
status, and the inputs and outputs with their names, declared types and
values (SOP §14). -/
theorem csv_view_roundtrip (p : ProofObject) :
    ∃ q, ofRows (toRows p) = some q ∧ view q = view p := by
  have hA := parseInputs_app p.id p.inputs _ (parseInputs_of_outputRows p.id p.outputs)
  have hB := parseOutputs_app p.id p.outputs [] (by simp [parseOutputs])
  simp only [List.append_nil] at hB
  have key : ofRows (toRows p) = some
      { (ProofObject.minimal p.id p.kind p.status) with
            version := p.version,
            inputs := p.inputs.map (fun i =>
              (⟨i.id, i.name, i.type, CValue.normalize i.value, none, none, [], none⟩ : Input)),
            outputs := p.outputs.map (fun o =>
              (⟨o.id, o.name, o.type, CValue.normalize o.value, none, [], none, none⟩ :
                Output)) } := by
    simp [toRows, ofRows, Status.ofName_toName, hA, hB]
  refine ⟨_, key, ?_⟩
  simp [view, ProofObject.minimal, List.map_map]
  exact ⟨fun a _ => CValue.normalize_idem a.value, fun a _ => CValue.normalize_idem a.value⟩

/-- CSV is not a lossless projection: two proof objects that differ only in
material the table has no column for produce byte-identical CSV (SOP §9). -/
theorem csv_not_lossless :
    ∃ p₁ p₂ : ProofObject, p₁ ≠ p₂ ∧ toRows p₁ = toRows p₂ := by
  refine ⟨ProofObject.minimal "p1" "theorem" Status.VALID,
          { ProofObject.minimal "p1" "theorem" Status.VALID with
            metadata := [("author", .str "alice")] }, ?_, ?_⟩
  · intro h
    have := congrArg ProofObject.metadata h
    simp [ProofObject.minimal] at this
  · rfl

/-! ## Text level for the projection -/

/-- The whole projection as CSV text, with the standard header. -/
def toText (p : ProofObject) : String :=
  String.ofList (renderTable (header :: (toRows p).map Row.cells))

/-- Read a table of rows out of CSV text. -/
def rowsOfText (s : String) : Option (List Row) :=
  match parseTable 6 s.toList with
  | some (h :: rest) => if h = header then Enc.mapOpt Row.ofCells rest else none
  | _ => none

/-- Read a proof object out of CSV text. -/
def ofText (s : String) : Option ProofObject :=
  match rowsOfText s with
  | some rows => ofRows rows
  | none => none

theorem rowsOfText_toText (p : ProofObject) : rowsOfText (toText p) = some (toRows p) := by
  have hall : ∀ r ∈ header :: (toRows p).map Row.cells, r ≠ [] ∧ r.length = 6 := by
    intro r hr
    rcases List.mem_cons.mp hr with rfl | hr'
    · exact ⟨by simp [header], rfl⟩
    · obtain ⟨row, _, rfl⟩ := List.mem_map.mp hr'
      exact ⟨Row.cells_ne_nil row, Row.cells_length row⟩
  unfold rowsOfText toText
  rw [String.toList_ofList, parseTable_renderTable 6 _ hall]
  exact Enc.mapOpt_map Row.cells Row.ofCells Row.ofCells_cells (toRows p)

/-- End-to-end CSV exchange: a proof object written as CSV text and read back
yields a proof object with the same view (SOP §14, §17, preservation level
`PARTIAL`). -/
theorem csv_text_roundtrip (p : ProofObject) :
    ∃ q, ofText (toText p) = some q ∧ view q = view p := by
  obtain ⟨q, hq, hv⟩ := csv_view_roundtrip p
  exact ⟨q, by simp [ofText, rowsOfText_toText p, hq], hv⟩

end Csv
end Codec
