import RequestProject.Solfunmeme.Codec.Model
import RequestProject.Solfunmeme.Codec.Escape

/-!
# The canonical tabular projection

§14 of the specification fixes a tabular convention

```text
object_id, object_type, field, value, value_type, parent_id
```

"so that nested objects can be represented without pretending that arbitrary
proof structures are inherently flat".  This file makes that convention the
*single* structural adapter of the whole codec: a canonical object becomes a
list of `Cell`s here, and every concrete syntax — IPDL, XML, CSV, YAML, raw
text — is then only a question of how one `Cell` is written on one line
(`Codec.Line`).

The result of the file is `decodeTable_encodeTable`: the table projection is
lossless, so every codec built on it is lossless too.

Three small pieces do all the work:

* `blockCells` / `takeBlock` — a record of named fields becomes consecutive
  rows and is read back positionally (`takeBlock_blockCells`);
* `decodeChildren` — a repeated block (the inputs, the outputs, the errors) is
  read until the rows stop matching (`decodeChildren_blocks`);
* per-object value lists, so that `Input`, `Output`, `Diagnostic`, `Provenance`
  and the proof header all reuse the same two lemmas.

Anything left over after the known blocks is *not* discarded (§30): it is
retained in the object's extension namespace under `codec.unparsed`.
-/

namespace Solfunmeme.Codec

/-! ## §14 The row -/

/-- One row of the canonical tabular projection. -/
structure Cell where
  objectId : String := ""
  objectType : String := ""
  field : String := ""
  value : String := ""
  valueType : String := "string"
  parentId : String := ""
  deriving DecidableEq, Repr, Inhabited

/-- A non-empty run of decimal digits. -/
def isDigits (s : String) : Bool :=
  !s.toList.isEmpty && s.toList.all (fun c => '0' ≤ c && c ≤ '9')

/-- §14: CSV import must infer types conservatively.  Only a non-empty run of
digits is called an integer; everything else stays a string. -/
def inferType (s : String) : String := if isDigits s then "integer" else "string"

/-- Conservative inference never calls a non-numeric value an integer. -/
theorem inferType_integer {s : String} (h : inferType s = "integer") :
    s.toList ≠ [] ∧ ∀ c ∈ s.toList, '0' ≤ c ∧ c ≤ '9' := by
  have hd : isDigits s = true := by
    unfold inferType at h
    split at h
    · assumption
    · exact absurd h (by decide)
  rw [isDigits, Bool.and_eq_true] at hd
  refine ⟨?_, ?_⟩
  · intro hs
    rw [hs] at hd
    simp at hd
  · intro c hc
    have := (List.all_eq_true.mp hd.2) c hc
    simpa using this

/-- Anything that is not inferred as an integer is declared a string: no third
possibility, so a reader always knows what it is being told. -/
theorem inferType_eq (s : String) : inferType s = "integer" ∨ inferType s = "string" := by
  unfold inferType; split <;> simp

/-! ## Records as consecutive rows -/

/-- The rows of one named record: `(field, value, value_type)` triples. -/
def blockCells (parent oid ot : String) : List (String × String × String) → List Cell
  | [] => []
  | t :: fs =>
    { objectId := oid, objectType := ot, field := t.1, value := t.2.1,
      valueType := t.2.2, parentId := parent } :: blockCells parent oid ot fs

/-- Read a record of the given type and field names, positionally. -/
def takeBlock (ot : String) : List String → List Cell → Option (List String × List Cell)
  | [], cs => some ([], cs)
  | _ :: _, [] => none
  | n :: ns, c :: cs =>
    if c.objectType == ot && c.field == n then
      (takeBlock ot ns cs).map (fun r => (c.value :: r.1, r.2))
    else none

theorem takeBlock_blockCells (parent oid ot : String) (fs : List (String × String × String))
    (rest : List Cell) :
    takeBlock ot (fs.map Prod.fst) (blockCells parent oid ot fs ++ rest)
      = some (fs.map (fun t => t.2.1), rest) := by
  induction fs with
  | nil => simp [blockCells, takeBlock]
  | cons t fs ih => simp [blockCells, takeBlock, ih]

/-- A record of a different type is not mistaken for this one, and neither is
the end of the table. -/
theorem takeBlock_none_of_blocks {α : Type} (ot ot' parent : String) (names : List String)
    (fs : α → List (String × String × String)) (oid : α → String) (xs : List α)
    (rest : List Cell) (hne : names ≠ []) (hot : ot ≠ ot')
    (hblock : ∀ x, (fs x) ≠ []) (hrest : takeBlock ot names rest = none) :
    takeBlock ot names
        (xs.flatMap (fun x => blockCells parent (oid x) ot' (fs x)) ++ rest) = none := by
  cases xs with
  | nil => simpa using hrest
  | cons x xs =>
    cases hn : names with
    | nil => exact absurd hn hne
    | cons n ns =>
      cases hf : fs x with
      | nil => exact absurd hf (hblock x)
      | cons t ts =>
        simp [blockCells, hf, takeBlock, Ne.symm hot]

/-- Read a repeated block until the rows stop matching. -/
def decodeChildren (ot : String) (names : List String) :
    Nat → List Cell → List (List String) × List Cell
  | 0, cs => ([], cs)
  | fuel + 1, cs =>
    match takeBlock ot names cs with
    | some (vs, cs') =>
      let r := decodeChildren ot names fuel cs'
      (vs :: r.1, r.2)
    | none => ([], cs)

theorem decodeChildren_blocks {α : Type} (ot parent : String) (names : List String)
    (fs : α → List (String × String × String)) (oid : α → String)
    (hnames : ∀ x, (fs x).map Prod.fst = names) :
    ∀ (xs : List α) (rest : List Cell) (fuel : Nat), xs.length ≤ fuel →
      takeBlock ot names rest = none →
      decodeChildren ot names fuel
          (xs.flatMap (fun x => blockCells parent (oid x) ot (fs x)) ++ rest)
        = (xs.map (fun x => (fs x).map (fun t => t.2.1)), rest) := by
  intro xs
  induction xs with
  | nil =>
    intro rest fuel _ hrest
    cases fuel with
    | zero => simp [decodeChildren]
    | succ f => simp [decodeChildren, hrest]
  | cons x xs ih =>
    intro rest fuel hfuel hrest
    cases fuel with
    | zero => simp at hfuel
    | succ f =>
      have hlen : xs.length ≤ f := by
        simp at hfuel; omega
      have htake : takeBlock ot names
          (blockCells parent (oid x) ot (fs x) ++
            (xs.flatMap (fun y => blockCells parent (oid y) ot (fs y)) ++ rest))
          = some ((fs x).map (fun t => t.2.1),
              xs.flatMap (fun y => blockCells parent (oid y) ot (fs y)) ++ rest) := by
        rw [← hnames x]; exact takeBlock_blockCells parent (oid x) ot (fs x) _
      simp only [List.flatMap_cons, List.append_assoc, decodeChildren, htake,
        ih rest f hlen hrest, List.map_cons]

/-! ## The five record layouts -/

def boolName (b : Bool) : String := if b then "true" else "false"

def boolOfName : String → Option Bool
  | "true" => some true
  | "false" => some false
  | _ => none

@[simp] theorem boolOfName_boolName (b : Bool) : boolOfName (boolName b) = some b := by
  cases b <;> rfl

/-! ### §4 Input -/

def inputTriples (i : Input) : List (String × String × String) :=
  [ ("id", i.id, "identifier")
  , ("name", i.name, "identifier")
  , ("type", i.type, "type")
  , ("value", i.value, inferType i.value)
  , ("encoding", i.encoding, "string")
  , ("units", i.units, "string")
  , ("constraints", i.constraints, "string")
  , ("extensions", encPairs false i.extensions, "pairs")
  , ("provenance", i.provenance, "string") ]

def inputFieldNames : List String :=
  ["id", "name", "type", "value", "encoding", "units", "constraints", "extensions", "provenance"]

theorem inputTriples_names (i : Input) : (inputTriples i).map Prod.fst = inputFieldNames := rfl

theorem inputTriples_ne_nil (i : Input) : inputTriples i ≠ [] := by simp [inputTriples]

def inputOfValues : List String → Option Input
  | [a, b, c, d, e, f, g, h, k] =>
    (decPairs h).map (fun ext =>
      { id := a, name := b, type := c, value := d, encoding := e, units := f,
        constraints := g, extensions := ext, provenance := k })
  | _ => none

@[simp] theorem inputOfValues_triples (i : Input) :
    inputOfValues ((inputTriples i).map (fun t => t.2.1)) = some i := by
  simp [inputTriples, inputOfValues]

/-! ### §5 Output -/

def outputTriples (o : Output) : List (String × String × String) :=
  [ ("id", o.id, "identifier")
  , ("name", o.name, "identifier")
  , ("type", o.type, "type")
  , ("value", o.value, inferType o.value)
  , ("encoding", o.encoding, "string")
  , ("claims", encList false o.claims, "list")
  , ("certificate", o.certificate, "string")
  , ("provenance", o.provenance, "string")
  , ("extensions", encPairs false o.extensions, "pairs") ]

def outputFieldNames : List String :=
  ["id", "name", "type", "value", "encoding", "claims", "certificate", "provenance", "extensions"]

theorem outputTriples_names (o : Output) : (outputTriples o).map Prod.fst = outputFieldNames := rfl

theorem outputTriples_ne_nil (o : Output) : outputTriples o ≠ [] := by simp [outputTriples]

def outputOfValues : List String → Option Output
  | [a, b, c, d, e, f, g, h, k] =>
    match decList f, decPairs k with
    | some cls, some ext =>
      some { id := a, name := b, type := c, value := d, encoding := e, claims := cls,
             certificate := g, provenance := h, extensions := ext }
    | _, _ => none
  | _ => none

@[simp] theorem outputOfValues_triples (o : Output) :
    outputOfValues ((outputTriples o).map (fun t => t.2.1)) = some o := by
  simp [outputTriples, outputOfValues]

/-! ### §7 Diagnostic -/

def diagTriples (d : Diagnostic) : List (String × String × String) :=
  [ ("id", d.id, "identifier")
  , ("code", d.code, "identifier")
  , ("severity", d.severity.name, "severity")
  , ("message", d.message, "string")
  , ("location", d.location, "string")
  , ("field", d.field, "path")
  , ("object_id", d.objectId, "identifier")
  , ("source_system", d.sourceSystem, "string")
  , ("source_format", d.sourceFormat, "string")
  , ("expected", d.expected, "string")
  , ("actual", d.actual, "string")
  , ("cause", d.cause, "string")
  , ("resolution", d.resolution, "string")
  , ("recoverable", boolName d.recoverable, "boolean")
  , ("extensions", encPairs false d.extensions, "pairs") ]

def diagFieldNames : List String :=
  ["id", "code", "severity", "message", "location", "field", "object_id", "source_system",
   "source_format", "expected", "actual", "cause", "resolution", "recoverable", "extensions"]

theorem diagTriples_names (d : Diagnostic) : (diagTriples d).map Prod.fst = diagFieldNames := rfl

theorem diagTriples_ne_nil (d : Diagnostic) : diagTriples d ≠ [] := by simp [diagTriples]

def diagOfValues : List String → Option Diagnostic
  | [a, b, c, d, e, f, g, h, k, l, m, n, o, r, x] =>
    match Severity.ofName c, boolOfName r, decPairs x with
    | some sev, some rec, some ext =>
      some { id := a, code := b, severity := sev, message := d, location := e, field := f,
             objectId := g, sourceSystem := h, sourceFormat := k, expected := l, actual := m,
             cause := n, resolution := o, recoverable := rec, extensions := ext }
    | _, _, _ => none
  | _ => none

@[simp] theorem diagOfValues_triples (d : Diagnostic) :
    diagOfValues ((diagTriples d).map (fun t => t.2.1)) = some d := by
  simp [diagTriples, diagOfValues]

/-! ### §20 Provenance -/

def provTriples (v : Provenance) : List (String × String × String) :=
  [ ("source_system", v.sourceSystem, "string")
  , ("source_file", v.sourceFile, "string")
  , ("source_format", v.sourceFormat, "identifier")
  , ("imported_at", v.importedAt, "timestamp")
  , ("transformed_at", v.transformedAt, "timestamp")
  , ("parent_object", v.parentObject, "identifier")
  , ("transformations", encList false v.transformations, "list") ]

def provFieldNames : List String :=
  ["source_system", "source_file", "source_format", "imported_at", "transformed_at",
   "parent_object", "transformations"]

theorem provTriples_names (v : Provenance) : (provTriples v).map Prod.fst = provFieldNames := rfl

def provOfValues : List String → Option Provenance
  | [a, b, c, d, e, f, g] =>
    (decList g).map (fun ts =>
      { sourceSystem := a, sourceFile := b, sourceFormat := c, importedAt := d,
        transformedAt := e, parentObject := f, transformations := ts })
  | _ => none

@[simp] theorem provOfValues_triples (v : Provenance) :
    provOfValues ((provTriples v).map (fun t => t.2.1)) = some v := by
  simp [provTriples, provOfValues]

/-! ### §3 The proof header -/

def headerTriples (p : ProofObject) : List (String × String × String) :=
  [ ("id", p.id, "identifier")
  , ("version", p.version, "string")
  , ("kind", p.kind, "identifier")
  , ("procedure", p.procedure, "string")
  , ("status", p.status.name, "status")
  , ("source_format", p.sourceFormat, "identifier")
  , ("source_data", p.sourceData, "text")
  , ("assumptions", encList false p.assumptions, "list")
  , ("parameters", encPairs false p.parameters, "pairs")
  , ("intermediate", encList false p.intermediate, "list")
  , ("claims", encList false p.claims, "list")
  , ("certificates", encList false p.certificates, "list")
  , ("warnings", encList false p.warnings, "list")
  , ("metadata", encPairs false p.metadata, "pairs")
  , ("extensions", encPairs false p.extensions, "pairs") ]

def headerFieldNames : List String :=
  ["id", "version", "kind", "procedure", "status", "source_format", "source_data", "assumptions",
   "parameters", "intermediate", "claims", "certificates", "warnings", "metadata", "extensions"]

theorem headerTriples_names (p : ProofObject) :
    (headerTriples p).map Prod.fst = headerFieldNames := rfl

/-- Rebuild the scalar part of the object from its header row values. -/
def headerOfValues (vs : List String) (inputs : List Input) (outputs : List Output)
    (errors : List Diagnostic) (prov : Provenance) (leftover : List Cell) :
    Option ProofObject :=
  match vs with
  | [a, b, c, d, e, f, g, h, k, l, m, n, o, q, r] =>
    match Status.ofName e, decList h, decPairs k, decList l, decList m, decList n, decList o,
        decPairs q, decPairs r with
    | some st, some asm, some par, some inter, some cls, some certs, some warns, some mta,
      some ext =>
      some { id := a, version := b, kind := c, procedure := d, status := st, sourceFormat := f,
             sourceData := g, assumptions := asm, parameters := par, intermediate := inter,
             claims := cls, certificates := certs, warnings := warns, metadata := mta,
             extensions := ext ++ leftover.map (fun cl =>
               ("codec.unparsed." ++ cl.objectType ++ "." ++ cl.objectId ++ "." ++ cl.field,
                 cl.value)),
             inputs := inputs, outputs := outputs, errors := errors, provenance := prov }
    | _, _, _, _, _, _, _, _, _ => none
  | _ => none

/-! ## Encoding and decoding a whole object -/

/-- §14: the canonical object as rows. -/
def encodeTable (p : ProofObject) : List Cell :=
  blockCells "" p.id "proof" (headerTriples p)
    ++ blockCells p.id (p.id ++ "/provenance") "provenance" (provTriples p.provenance)
    ++ p.inputs.flatMap (fun i => blockCells p.id i.id "input" (inputTriples i))
    ++ p.outputs.flatMap (fun o => blockCells p.id o.id "output" (outputTriples o))
    ++ p.errors.flatMap (fun d => blockCells p.id d.id "error" (diagTriples d))

/-- Read a repeated block with the remaining table as the fuel: a block never
consumes fewer than one row, so this cannot stop early. -/
def decodeChildrenAll (ot : String) (names : List String) (cs : List Cell) :
    List (List String) × List Cell :=
  decodeChildren ot names cs.length cs

/-- Read rows back into a canonical object.  Rows that belong to no known block
are kept in the extension namespace rather than dropped. -/
def decodeTable (cs : List Cell) : Option ProofObject :=
  match takeBlock "proof" headerFieldNames cs with
  | none => none
  | some (hv, cs₁) =>
    match takeBlock "provenance" provFieldNames cs₁ with
    | none => none
    | some (pv, cs₂) =>
      let iv := decodeChildrenAll "input" inputFieldNames cs₂
      let ov := decodeChildrenAll "output" outputFieldNames iv.2
      let ev := decodeChildrenAll "error" diagFieldNames ov.2
      match mapOpt inputOfValues iv.1, mapOpt outputOfValues ov.1, mapOpt diagOfValues ev.1,
          provOfValues pv with
      | some inputs, some outputs, some errors, some prov =>
        headerOfValues hv inputs outputs errors prov ev.2
      | _, _, _, _ => none

/-! ## §17 The projection is lossless -/

theorem length_flatMap_blocks {α : Type} (parent ot : String)
    (fs : α → List (String × String × String)) (oid : α → String) (xs : List α)
    (rest : List Cell) (h : ∀ x, (fs x) ≠ []) :
    xs.length ≤ (xs.flatMap (fun x => blockCells parent (oid x) ot (fs x)) ++ rest).length := by
  induction xs with
  | nil => simp
  | cons x xs ih =>
    have hx : 1 ≤ (blockCells parent (oid x) ot (fs x)).length := by
      cases hf : fs x with
      | nil => exact absurd hf (h x)
      | cons t ts => simp [blockCells]
    simp only [List.flatMap_cons, List.append_assoc, List.length_cons, List.length_append] at ih ⊢
    omega

theorem decodeChildrenAll_blocks {α : Type} (ot parent : String) (names : List String)
    (fs : α → List (String × String × String)) (oid : α → String)
    (hnames : ∀ x, (fs x).map Prod.fst = names) (hne : ∀ x, (fs x) ≠ [])
    (xs : List α) (rest : List Cell) (hrest : takeBlock ot names rest = none) :
    decodeChildrenAll ot names (xs.flatMap (fun x => blockCells parent (oid x) ot (fs x)) ++ rest)
      = (xs.map (fun x => (fs x).map (fun t => t.2.1)), rest) :=
  decodeChildren_blocks ot parent names fs oid hnames xs rest _
    (length_flatMap_blocks parent ot fs oid xs rest hne) hrest

set_option maxHeartbeats 1000000 in
theorem decodeTable_encodeTable (p : ProofObject) : decodeTable (encodeTable p) = some p := by
  have hnil_error : takeBlock "error" diagFieldNames [] = none := by
    simp [takeBlock, diagFieldNames]
  have hnil_output : takeBlock "output" outputFieldNames [] = none := by
    simp [takeBlock, outputFieldNames]
  have hnil_input : takeBlock "input" inputFieldNames [] = none := by
    simp [takeBlock, inputFieldNames]
  have hbound_out : takeBlock "output" outputFieldNames
      (p.errors.flatMap (fun d => blockCells p.id d.id "error" (diagTriples d))) = none := by
    have := takeBlock_none_of_blocks (α := Diagnostic) "output" "error" p.id outputFieldNames
      diagTriples Diagnostic.id p.errors [] (by simp [outputFieldNames]) (by decide)
      diagTriples_ne_nil hnil_output
    simpa using this
  have hbound_in : takeBlock "input" inputFieldNames
      (p.outputs.flatMap (fun o => blockCells p.id o.id "output" (outputTriples o))
        ++ p.errors.flatMap (fun d => blockCells p.id d.id "error" (diagTriples d))) = none := by
    refine takeBlock_none_of_blocks (α := Output) "input" "output" p.id inputFieldNames
      outputTriples Output.id p.outputs _ (by simp [inputFieldNames]) (by decide)
      outputTriples_ne_nil ?_
    have := takeBlock_none_of_blocks (α := Diagnostic) "input" "error" p.id inputFieldNames
      diagTriples Diagnostic.id p.errors [] (by simp [inputFieldNames]) (by decide)
      diagTriples_ne_nil hnil_input
    simpa using this
  have hheader := takeBlock_blockCells "" p.id "proof" (headerTriples p)
    (blockCells p.id (p.id ++ "/provenance") "provenance" (provTriples p.provenance)
      ++ (p.inputs.flatMap (fun i => blockCells p.id i.id "input" (inputTriples i))
        ++ (p.outputs.flatMap (fun o => blockCells p.id o.id "output" (outputTriples o))
          ++ p.errors.flatMap (fun d => blockCells p.id d.id "error" (diagTriples d)))))
  rw [headerTriples_names] at hheader
  have hprov := takeBlock_blockCells p.id (p.id ++ "/provenance") "provenance"
    (provTriples p.provenance)
    (p.inputs.flatMap (fun i => blockCells p.id i.id "input" (inputTriples i))
      ++ (p.outputs.flatMap (fun o => blockCells p.id o.id "output" (outputTriples o))
        ++ p.errors.flatMap (fun d => blockCells p.id d.id "error" (diagTriples d))))
  rw [provTriples_names] at hprov
  have hin := decodeChildrenAll_blocks "input" p.id inputFieldNames inputTriples Input.id
    inputTriples_names inputTriples_ne_nil p.inputs _ hbound_in
  have hout := decodeChildrenAll_blocks "output" p.id outputFieldNames outputTriples Output.id
    outputTriples_names outputTriples_ne_nil p.outputs _ hbound_out
  have herr := decodeChildrenAll_blocks "error" p.id diagFieldNames diagTriples Diagnostic.id
    diagTriples_names diagTriples_ne_nil p.errors [] hnil_error
  rw [List.append_nil] at herr
  have hmi : mapOpt inputOfValues (p.inputs.map (fun i => (inputTriples i).map (fun t => t.2.1)))
      = some p.inputs := mapOpt_map _ _ inputOfValues_triples p.inputs
  have hmo : mapOpt outputOfValues
      (p.outputs.map (fun o => (outputTriples o).map (fun t => t.2.1)))
      = some p.outputs := mapOpt_map _ _ outputOfValues_triples p.outputs
  have hme : mapOpt diagOfValues (p.errors.map (fun d => (diagTriples d).map (fun t => t.2.1)))
      = some p.errors := mapOpt_map _ _ diagOfValues_triples p.errors
  simp only [encodeTable, decodeTable, List.append_assoc, hheader, hprov, hin, hout, herr,
    hmi, hmo, hme, provOfValues_triples]
  simp [headerTriples, headerOfValues]

end Solfunmeme.Codec
