import RequestProject.Gvcs.Codec.Encode

/-!
# The CSV codec

CSV is a *tabular projection* of the canonical model, not a representation of it (§14).
The table uses the recommended convention

```text
object_id,object_type,field,value,value_type,parent_id
p1,proof,kind,theorem,string,
p1,proof,status,VALID,string,
i1,input,name,n,identifier,p1
i1,input,type,integer,identifier,p1
i1,input,value,144,integer,p1
```

so nested objects are addressed by `parent_id` rather than pretending that a proof is
flat.  Values are carried in their canonical IPDL rendering, so even a list- or
object-valued input survives the table; what does *not* survive is everything the
projection does not have a column for.

Because of that, this codec declares `PARTIAL` and never `LOSSLESS`:

* `Csv.decode_encode` — the projection `csvProject` survives the table exactly;
* `Csv.csvProject_idempotent` — the projection is a projection;
* `Csv.not_lossless` — two canonical objects that differ produce the same table, so no
  implementation may claim losslessness for CSV.
-/

namespace LifeTrac.Codec
namespace Csv

/-- One row of the tabular projection. -/
structure Row where
  /-- Identifier of the object this row is about. -/
  objectId : String
  /-- Kind of that object: `proof`, `input`, `output`. -/
  objectType : String
  /-- Field of the object the row carries. -/
  field : String
  /-- The value, as text. -/
  value : String
  /-- The declared type of the value. -/
  valueType : String
  /-- Identifier of the containing object, empty at the top level. -/
  parentId : String
  deriving DecidableEq, Repr, Inhabited

/-- The declared projection of a canonical object onto what the table can hold. -/
def csvInput (i : Input) : Input :=
  { id := i.id, name := i.name, type := i.type, value := i.value }

/-- The declared projection of an output. -/
def csvOutput (o : Output) : Output :=
  { id := o.id, name := o.name, type := o.type, value := o.value }

/-- The declared projection of a canonical object (§9: what CSV preserves). -/
def csvProject (p : ProofObject) : ProofObject :=
  { id := p.id, kind := p.kind, status := p.status,
    inputs := p.inputs.map csvInput, outputs := p.outputs.map csvOutput }

theorem csvProject_idempotent (p : ProofObject) : csvProject (csvProject p) = csvProject p := by
  simp [csvProject, csvInput, csvOutput, List.map_map, Function.comp_def]

/-! ## Rows -/

/-- Render a value into a cell: scalars go in plainly, structured values go in as their
canonical IPDL rendering, which is what the `value_type` column records. -/
def valueCell : Value → String
  | .str s => s
  | .int i => intAtom i
  | .bool b => boolAtom b
  | .null => ""
  | v => Ipdl.encode v.toDoc

/-- Read a value cell, guided by the declared `value_type`. -/
def valueOfCell (ty : String) (s : String) : Option Value :=
  if ty = "string" then some (.str s)
  else if ty = "integer" then (parseIntAtom? s).map .int
  else if ty = "boolean" then (parseBoolAtom? s).map .bool
  else if ty = "null" then some .null
  else (Ipdl.decode s).bind Value.ofDoc

@[simp] theorem valueOfCell_valueCell (v : Value) :
    valueOfCell v.kindName (valueCell v) = some v := by
  cases v <;>
    simp [valueCell, valueOfCell, Value.kindName, Ipdl.decode_encode, Value.ofDoc_toDoc]

/-- Rows describing one input. -/
def inputRows (parent : String) (i : Input) : List Row :=
  [{ objectId := i.id, objectType := "input", field := "name", value := i.name,
     valueType := "identifier", parentId := parent },
   { objectId := i.id, objectType := "input", field := "type", value := i.type,
     valueType := "identifier", parentId := parent },
   { objectId := i.id, objectType := "input", field := "value",
     value := valueCell i.value, valueType := i.value.kindName, parentId := parent }]

/-- Rows describing one output. -/
def outputRows (parent : String) (o : Output) : List Row :=
  [{ objectId := o.id, objectType := "output", field := "name", value := o.name,
     valueType := "identifier", parentId := parent },
   { objectId := o.id, objectType := "output", field := "type", value := o.type,
     valueType := "identifier", parentId := parent },
   { objectId := o.id, objectType := "output", field := "value",
     value := valueCell o.value, valueType := o.value.kindName, parentId := parent }]

/-- The table of a canonical object. -/
def toRows (p : ProofObject) : List Row :=
  [{ objectId := p.id, objectType := "proof", field := "kind", value := p.kind,
     valueType := "identifier", parentId := "" },
   { objectId := p.id, objectType := "proof", field := "status", value := p.status.toName,
     valueType := "identifier", parentId := "" }]
    ++ p.inputs.flatMap (inputRows p.id) ++ p.outputs.flatMap (outputRows p.id)

/-- Read the input and output rows of a table.  The row layout is the one `toRows`
emits: three consecutive rows per object, tagged by `object_type` and `field`. -/
def rowsToIO : List Row → Option (List Input × List Output)
  | [] => some ([], [])
  | ⟨i1, "input", "name", nm, _, _⟩ :: ⟨_, "input", "type", ty, _, _⟩ ::
      ⟨_, "input", "value", vc, vt, _⟩ :: t =>
      match valueOfCell vt vc, rowsToIO t with
      | some v, some (ins, outs) =>
          some ({ id := i1, name := nm, type := ty, value := v } :: ins, outs)
      | _, _ => none
  | ⟨o1, "output", "name", nm, _, _⟩ :: ⟨_, "output", "type", ty, _, _⟩ ::
      ⟨_, "output", "value", vc, vt, _⟩ :: t =>
      match valueOfCell vt vc, rowsToIO t with
      | some v, some (ins, outs) =>
          some (ins, { id := o1, name := nm, type := ty, value := v } :: outs)
      | _, _ => none
  | _ => none

/-- Rebuild the projected canonical object from a table. -/
def ofRows : List Row → Option ProofObject
  | ⟨pid, "proof", "kind", kd, _, _⟩ :: ⟨_, "proof", "status", st, _, _⟩ :: t =>
      match Status.ofName? st, rowsToIO t with
      | some s, some (ins, outs) =>
          some { id := pid, kind := kd, inputs := ins, outputs := outs, status := s }
      | _, _ => none
  | _ => none

theorem rowsToIO_inputs (ins : List Input) (parent : String) (X : List Row)
    (A : List Input) (B : List Output) (hX : rowsToIO X = some (A, B)) :
    rowsToIO (ins.flatMap (inputRows parent) ++ X) = some (ins.map csvInput ++ A, B) := by
  induction ins with
  | nil => simpa using hX
  | cons i t ih =>
    simp only [List.flatMap_cons, inputRows, List.cons_append, List.nil_append, rowsToIO,
      valueOfCell_valueCell, ih]
    simp [csvInput]

theorem rowsToIO_outputs (outs : List Output) (parent : String) :
    rowsToIO (outs.flatMap (outputRows parent)) = some ([], outs.map csvOutput) := by
  induction outs with
  | nil => rfl
  | cons o t ih =>
    simp only [List.flatMap_cons, outputRows, List.cons_append, List.nil_append, rowsToIO,
      valueOfCell_valueCell, ih]
    simp [csvOutput]

/-- **The table carries exactly the declared projection.** -/
theorem ofRows_toRows (p : ProofObject) : ofRows (toRows p) = some (csvProject p) := by
  have hio : rowsToIO (p.inputs.flatMap (inputRows p.id) ++ p.outputs.flatMap (outputRows p.id))
      = some (p.inputs.map csvInput, p.outputs.map csvOutput) := by
    rw [rowsToIO_inputs p.inputs p.id _ [] (p.outputs.map csvOutput)
      (rowsToIO_outputs p.outputs p.id)]
    simp
  simp only [toRows, List.cons_append, List.nil_append, ofRows,
    Status.ofName_toName, hio]
  rfl

/-! ## Text -/

/-- The header line of the table. -/
def header : List Char :=
  ['o','b','j','e','c','t','_','i','d',',','o','b','j','e','c','t','_','t','y','p','e',',',
   'f','i','e','l','d',',','v','a','l','u','e',',','v','a','l','u','e','_','t','y','p','e',
   ',','p','a','r','e','n','t','_','i','d','\n']

/-- Render one row; every cell is an atom, so no cell can contain a comma or a newline. -/
def renderRow (r : Row) : List Char :=
  (esc r.objectId).toList ++ ',' :: (esc r.objectType).toList ++ ',' :: (esc r.field).toList
    ++ ',' :: (esc r.value).toList ++ ',' :: (esc r.valueType).toList
    ++ ',' :: (esc r.parentId).toList ++ ['\n']

/-- Render all rows, header first. -/
def renderRows (rs : List Row) : List Char := header ++ rs.flatMap renderRow

/-- Encode a canonical object as CSV text. -/
def encode (p : ProofObject) : String := String.ofList (renderRows (toRows p))

/-- Read one cell followed by its delimiter. -/
def parseCell (delim : Char) (l : List Char) : Option (String × List Char) :=
  let r := unesc l
  match r.2 with
  | c :: t => if c = delim then some (r.1, t) else none
  | [] => none

/-- Read one row. -/
def parseRow (l : List Char) : Option (Row × List Char) :=
  match parseCell ',' l with
  | none => none
  | some (a, l1) =>
      match parseCell ',' l1 with
      | none => none
      | some (b, l2) =>
          match parseCell ',' l2 with
          | none => none
          | some (c, l3) =>
              match parseCell ',' l3 with
              | none => none
              | some (d, l4) =>
                  match parseCell ',' l4 with
                  | none => none
                  | some (e, l5) =>
                      match parseCell '\n' l5 with
                      | none => none
                      | some (g, l6) =>
                          some ({ objectId := a, objectType := b, field := c, value := d,
                                  valueType := e, parentId := g }, l6)

/-- Read all rows. -/
def parseRows : Nat → List Char → Option (List Row)
  | _, [] => some []
  | 0, _ => none
  | f + 1, l =>
      match parseRow l with
      | none => none
      | some (r, l1) => (parseRows f l1).map (r :: ·)

/-- Decode CSV text into the projected canonical object. -/
def decode (s : String) : Option ProofObject :=
  match expect header s.toList with
  | none => none
  | some l => (parseRows s.toList.length l).bind ofRows

theorem parseCell_render (delim : Char) (hd : isAtomChar delim = false) (s : String)
    (rest : List Char) : parseCell delim ((esc s).toList ++ delim :: rest) = some (s, rest) := by
  simp only [parseCell]
  rw [unesc_esc_append s (delim :: rest) (by
    simp only [List.head?_cons, Option.mem_def, Option.some.injEq]
    rintro c rfl; exact hd)]
  simp

theorem parseRow_render (r : Row) (rest : List Char) :
    parseRow (renderRow r ++ rest) = some (r, rest) := by
  simp only [renderRow, List.cons_append, List.append_assoc, parseRow]
  rw [parseCell_render ',' (by decide) r.objectId]
  simp only
  rw [parseCell_render ',' (by decide) r.objectType]
  simp only
  rw [parseCell_render ',' (by decide) r.field]
  simp only
  rw [parseCell_render ',' (by decide) r.value]
  simp only
  rw [parseCell_render ',' (by decide) r.valueType]
  simp only
  rw [parseCell_render '\n' (by decide) r.parentId]
  simp

theorem renderRow_ne_nil (r : Row) : renderRow r ≠ [] := by
  simp [renderRow]

theorem length_le_render (rs : List Row) : rs.length ≤ (rs.flatMap renderRow).length := by
  induction rs with
  | nil => simp
  | cons r t ih =>
    have h1 : 1 ≤ (renderRow r).length := by simp [renderRow]; omega
    simp only [List.flatMap_cons, List.length_append, List.length_cons]
    omega

theorem parseRows_render (rs : List Row) (f : Nat) (hf : rs.length ≤ f) :
    parseRows f (rs.flatMap renderRow) = some rs := by
  induction rs generalizing f with
  | nil => cases f <;> rfl
  | cons r t ih =>
    obtain ⟨g, rfl⟩ : ∃ g, f = g + 1 := by
      cases f with
      | zero => simp at hf
      | succ g => exact ⟨g, rfl⟩
    have hne : (renderRow r ++ t.flatMap renderRow) ≠ [] := by
      intro h
      exact renderRow_ne_nil r (List.append_eq_nil_iff.mp h).1
    obtain ⟨x, xs, hx⟩ := List.exists_cons_of_ne_nil hne
    simp only [List.flatMap_cons]
    rw [show renderRow r ++ t.flatMap renderRow = x :: xs from hx]
    rw [parseRows]
    · rw [show (x :: xs) = renderRow r ++ t.flatMap renderRow from hx.symm]
      rw [parseRow_render]
      simp only
      rw [ih g (by simpa using Nat.le_of_succ_le_succ (by simpa using hf))]
      simp
    · simp

/-- **The CSV codec carries the declared projection through text.** -/
theorem decode_encode (p : ProofObject) : decode (encode p) = some (csvProject p) := by
  simp only [decode, encode, String.toList_ofList, renderRows, expect_append]
  rw [parseRows_render (toRows p) _ (by
    have := length_le_render (toRows p)
    simp only [List.length_append, header, List.length_cons, List.length_nil]
    omega)]
  simpa using ofRows_toRows p

/-- CSV is not lossless: distinct canonical objects can produce the same table, which is
why the codec declares `PARTIAL`. -/
theorem not_lossless :
    ∃ p q : ProofObject, p ≠ q ∧ toRows p = toRows q := by
  refine ⟨{ id := "p", kind := "theorem", inputs := [], outputs := [], status := .valid,
            version := "1.0" },
          { id := "p", kind := "theorem", inputs := [], outputs := [], status := .valid,
            version := "2.0" }, ?_, rfl⟩
  intro h
  simpa using congrArg ProofObject.version h

/-- The preservation level this codec is allowed to declare (§9). -/
def lossiness : Lossiness := .partialConv

end Csv
end LifeTrac.Codec
