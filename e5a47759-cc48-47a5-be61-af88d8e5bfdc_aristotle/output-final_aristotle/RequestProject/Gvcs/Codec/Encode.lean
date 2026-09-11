import RequestProject.Gvcs.Codec.Model
import RequestProject.Gvcs.Codec.Ipdl

/-!
# The canonical object as a document

This is the one place where the proof model meets the document tree.  Every codec goes
through it, so a format adapter never has to know what an `Input` or a `Status` is; and
because the mapping is proved to be injective (`ProofObject.ofDoc_toDoc`), no codec can
lose canonical information that the document layer preserves.

Nothing is dropped on the way in: `metadata`, `extensions` (§30), the preserved
`sourceData` and the diagnostics all have a place in the document, and everything that
goes down comes back up.
-/

namespace LifeTrac.Codec

/-! ## Values -/

mutual

/-- Encode a value as a document. -/
def Value.toDoc : Value → Doc
  | .str s => .leaf "str" [] s
  | .int i => .leaf "int" [] (intAtom i)
  | .bool b => .leaf "bool" [] (boolAtom b)
  | .null => .leaf "null" [] ""
  | .list xs => .node "list" [] (Value.toDocs xs)
  | .obj fs => .node "obj" [] (Value.toFields fs)

/-- Encode a list of values. -/
def Value.toDocs : List Value → List Doc
  | [] => []
  | v :: t => Value.toDoc v :: Value.toDocs t

/-- Encode a list of named values. -/
def Value.toFields : List (String × Value) → List Doc
  | [] => []
  | (k, v) :: t => .node "entry" [("key", k)] [Value.toDoc v] :: Value.toFields t

end

mutual

/-- Decode a value from a document. -/
def Value.ofDoc : Doc → Option Value
  | .leaf "str" [] s => some (.str s)
  | .leaf "int" [] s => (parseIntAtom? s).map .int
  | .leaf "bool" [] s => (parseBoolAtom? s).map .bool
  | .leaf "null" [] _ => some .null
  | .node "list" [] ks => (Value.ofDocs ks).map .list
  | .node "obj" [] ks => (Value.ofFields ks).map .obj
  | _ => none

/-- Decode a list of values. -/
def Value.ofDocs : List Doc → Option (List Value)
  | [] => some []
  | d :: t =>
      match Value.ofDoc d, Value.ofDocs t with
      | some v, some vs => some (v :: vs)
      | _, _ => none

/-- Decode a list of named values. -/
def Value.ofFields : List Doc → Option (List (String × Value))
  | [] => some []
  | (.node "entry" [("key", k)] [v]) :: t =>
      match Value.ofDoc v, Value.ofFields t with
      | some x, some xs => some ((k, x) :: xs)
      | _, _ => none
  | _ => none

end

theorem Value.ofDoc_toDoc (v : Value) : Value.ofDoc v.toDoc = some v := by
  induction v using Value.rec
    (motive_2 := fun xs => Value.ofDocs (Value.toDocs xs) = some xs)
    (motive_3 := fun fs => Value.ofFields (Value.toFields fs) = some fs)
    (motive_4 := fun kv => Value.ofDoc (Value.toDoc kv.2) = some kv.2) with
  | str s => rfl
  | int i => simp [Value.toDoc, Value.ofDoc]
  | bool b => simp [Value.toDoc, Value.ofDoc]
  | null => rfl
  | list xs ih => simp [Value.toDoc, Value.ofDoc, ih]
  | obj fs ih => simp [Value.toDoc, Value.ofDoc, ih]
  | nil => rfl
  | cons v t ihv iht => simp [Value.toDocs, Value.ofDocs, ihv, iht]
  | _ => simp_all [Value.toFields, Value.ofFields]

/-- Name of the kind of a value, for tabular and diagnostic use. -/
def Value.kindName : Value → String
  | .str _ => "string"
  | .int _ => "integer"
  | .bool _ => "boolean"
  | .null => "null"
  | .list _ => "list"
  | .obj _ => "object"

theorem Value.toDoc_injective : Function.Injective Value.toDoc := by
  intro a b h
  have ha := Value.ofDoc_toDoc a
  rw [h, Value.ofDoc_toDoc b] at ha
  exact (Option.some_inj.mp ha).symm

/-! ## Decidable equality

`Doc` and `Value` are nested inductives, so their equality is not derivable; it is
obtained instead from the injectivity of the encodings that were just proved.
-/

instance : DecidableEq Doc := fun a b =>
  decidable_of_iff (Ipdl.encode a = Ipdl.encode b) <| by
    constructor
    · intro h
      have ha := Ipdl.decode_encode a
      rw [h, Ipdl.decode_encode b] at ha
      exact (Option.some_inj.mp ha).symm
    · intro h; rw [h]

instance : DecidableEq Value := fun a b =>
  decidable_of_iff (a.toDoc = b.toDoc) ⟨fun h => Value.toDoc_injective h, fun h => by rw [h]⟩

deriving instance DecidableEq for Input
deriving instance DecidableEq for Output
deriving instance DecidableEq for ProofObject
deriving instance DecidableEq for MinimalProfile
deriving instance DecidableEq for Envelope

/-! ## Small encodings shared by the record types -/

/-- Encode a string as a document. -/
def strDoc (s : String) : Doc := .leaf "s" [] s

/-- Decode a string document. -/
def strOf? : Doc → Option String
  | .leaf "s" [] s => some s
  | _ => none

/-- Encode a list of strings under a given tag. -/
def strsDoc (tag : String) (xs : List String) : Doc := .node tag [] (xs.map strDoc)

/-- Decode a list of strings from a document with the given tag. -/
def strsOf? (tag : String) : Doc → Option (List String)
  | .node t [] ks => if t = tag then ks.mapM strOf? else none
  | _ => none

/-- Encode an optional string. -/
def optStrDoc : Option String → Doc
  | none => .node "opt" [] []
  | some s => .node "opt" [] [strDoc s]

/-- Decode an optional string. -/
def optStrOf? : Doc → Option (Option String)
  | .node "opt" [] [] => some none
  | .node "opt" [] [d] => (strOf? d).map some
  | _ => none

/-- Encode a list of named values under a given tag. -/
def fieldsDoc (tag : String) (fs : List (String × Value)) : Doc :=
  .node tag [] (Value.toFields fs)

/-- Decode a list of named values from a document with the given tag. -/
def fieldsOf? (tag : String) : Doc → Option (List (String × Value))
  | .node t [] ks => if t = tag then Value.ofFields ks else none
  | _ => none

theorem mapM_map_of_inv {α β : Type} {f : α → β} {g : β → Option α}
    (h : ∀ x, g (f x) = some x) (xs : List α) : (xs.map f).mapM g = some xs := by
  induction xs with
  | nil => rfl
  | cons x t ih => simp [List.mapM_cons, h x, ih]

@[simp] theorem strOf_strDoc (s : String) : strOf? (strDoc s) = some s := rfl

@[simp] theorem strsOf_strsDoc (tag : String) (xs : List String) :
    strsOf? tag (strsDoc tag xs) = some xs := by
  simp [strsDoc, strsOf?, mapM_map_of_inv strOf_strDoc xs]

@[simp] theorem optStrOf_optStrDoc (o : Option String) : optStrOf? (optStrDoc o) = some o := by
  cases o <;> rfl

@[simp] theorem fieldsOf_fieldsDoc (tag : String) (fs : List (String × Value)) :
    fieldsOf? tag (fieldsDoc tag fs) = some fs := by
  have h : Value.ofFields (Value.toFields fs) = some fs := by
    induction fs with
    | nil => rfl
    | cons kv t ih =>
      obtain ⟨k, v⟩ := kv
      simp [Value.toFields, Value.ofFields, Value.ofDoc_toDoc v, ih]
  simp [fieldsDoc, fieldsOf?, h]

/-! ## Provenance -/

/-- Encode provenance (§20). -/
def Provenance.toDoc (p : Provenance) : Doc :=
  .node "provenance"
    [("source_system", p.sourceSystem), ("source_file", p.sourceFile),
     ("source_format", p.sourceFormat), ("imported_at", p.importedAt),
     ("transformed_at", p.transformedAt)]
    [strsDoc "transformations" p.transformations, optStrDoc p.parent]

/-- Decode provenance. -/
def Provenance.ofDoc : Doc → Option Provenance
  | .node "provenance"
      [("source_system", ss), ("source_file", sf), ("source_format", sfm),
       ("imported_at", ia), ("transformed_at", ta)] [ts, par] => do
      let transformations ← strsOf? "transformations" ts
      let parent ← optStrOf? par
      some { sourceSystem := ss, sourceFile := sf, sourceFormat := sfm, importedAt := ia,
             transformedAt := ta, transformations := transformations, parent := parent }
  | _ => none

@[simp] theorem Provenance.ofDoc_toDoc (p : Provenance) :
    Provenance.ofDoc p.toDoc = some p := by
  cases p; simp [Provenance.toDoc, Provenance.ofDoc]

/-- Encode an optional provenance record. -/
def optProvDoc : Option Provenance → Doc
  | none => .node "opt" [] []
  | some p => .node "opt" [] [p.toDoc]

/-- Decode an optional provenance record. -/
def optProvOf? : Doc → Option (Option Provenance)
  | .node "opt" [] [] => some none
  | .node "opt" [] [d] => (Provenance.ofDoc d).map some
  | _ => none

@[simp] theorem optProvOf_optProvDoc (o : Option Provenance) :
    optProvOf? (optProvDoc o) = some o := by
  cases o <;> simp [optProvDoc, optProvOf?]

/-! ## Inputs and outputs -/

/-- Encode an input (§4). -/
def Input.toDoc (i : Input) : Doc :=
  .node "input"
    [("id", i.id), ("name", i.name), ("type", i.type), ("encoding", i.encoding),
     ("units", i.units)]
    [.node "value" [] [i.value.toDoc], strsDoc "constraints" i.constraints,
     optProvDoc i.provenance]

/-- Decode an input. -/
def Input.ofDoc : Doc → Option Input
  | .node "input" [("id", id), ("name", nm), ("type", ty), ("encoding", en), ("units", un)]
      [.node "value" [] [vd], cs, pv] => do
      let value ← Value.ofDoc vd
      let constraints ← strsOf? "constraints" cs
      let provenance ← optProvOf? pv
      some { id := id, name := nm, type := ty, value := value, encoding := en, units := un,
             constraints := constraints, provenance := provenance }
  | _ => none

@[simp] theorem Input.ofDoc_toDoc (i : Input) : Input.ofDoc i.toDoc = some i := by
  cases i; simp [Input.toDoc, Input.ofDoc, Value.ofDoc_toDoc]

/-- Encode an output (§5). -/
def Output.toDoc (o : Output) : Doc :=
  .node "output"
    [("id", o.id), ("name", o.name), ("type", o.type), ("encoding", o.encoding)]
    [.node "value" [] [o.value.toDoc], strsDoc "claims" o.claims,
     optStrDoc o.certificate, optProvDoc o.provenance]

/-- Decode an output. -/
def Output.ofDoc : Doc → Option Output
  | .node "output" [("id", id), ("name", nm), ("type", ty), ("encoding", en)]
      [.node "value" [] [vd], cl, ce, pv] => do
      let value ← Value.ofDoc vd
      let claims ← strsOf? "claims" cl
      let certificate ← optStrOf? ce
      let provenance ← optProvOf? pv
      some { id := id, name := nm, type := ty, value := value, encoding := en,
             claims := claims, certificate := certificate, provenance := provenance }
  | _ => none

@[simp] theorem Output.ofDoc_toDoc (o : Output) : Output.ofDoc o.toDoc = some o := by
  cases o; simp [Output.toDoc, Output.ofDoc, Value.ofDoc_toDoc]

/-! ## Diagnostics -/

/-- Encode a diagnostic (§7). -/
def Diagnostic.toDoc (e : Diagnostic) : Doc :=
  .node "diagnostic"
    [("id", e.id), ("code", e.code), ("severity", e.severity.toName), ("message", e.message),
     ("location", e.location), ("field", e.field), ("object_id", e.objectId),
     ("source_system", e.sourceSystem), ("source_format", e.sourceFormat),
     ("expected", e.expected), ("actual", e.actual), ("cause", e.cause),
     ("resolution", e.resolution), ("recoverable", boolAtom e.recoverable)] []

/-- Decode a diagnostic. -/
def Diagnostic.ofDoc : Doc → Option Diagnostic
  | .node "diagnostic"
      [("id", id), ("code", code), ("severity", sev), ("message", msg), ("location", loc),
       ("field", fld), ("object_id", oid), ("source_system", ss), ("source_format", sf),
       ("expected", exp), ("actual", act), ("cause", cau), ("resolution", res),
       ("recoverable", recov)] [] => do
      let severity ← Severity.ofName? sev
      let recoverable ← parseBoolAtom? recov
      some { id := id, code := code, severity := severity, message := msg, location := loc,
             field := fld, objectId := oid, sourceSystem := ss, sourceFormat := sf,
             expected := exp, actual := act, cause := cau, resolution := res,
             recoverable := recoverable }
  | _ => none

@[simp] theorem Diagnostic.ofDoc_toDoc (e : Diagnostic) : Diagnostic.ofDoc e.toDoc = some e := by
  cases e; simp [Diagnostic.toDoc, Diagnostic.ofDoc]

/-! ## The canonical object -/

/-- Encode a canonical proof object (§3). -/
def ProofObject.toDoc (p : ProofObject) : Doc :=
  .node "proof"
    [("id", p.id), ("version", p.version), ("kind", p.kind), ("procedure", p.procedure),
     ("source_format", p.sourceFormat), ("source_data", p.sourceData),
     ("status", p.status.toName)]
    [.node "inputs" [] (p.inputs.map Input.toDoc),
     strsDoc "assumptions" p.assumptions,
     fieldsDoc "parameters" p.parameters,
     .node "intermediate" [] (p.intermediate.map Output.toDoc),
     .node "outputs" [] (p.outputs.map Output.toDoc),
     strsDoc "claims" p.claims,
     strsDoc "certificates" p.certificates,
     .node "errors" [] (p.errors.map Diagnostic.toDoc),
     .node "warnings" [] (p.warnings.map Diagnostic.toDoc),
     optProvDoc p.provenance,
     fieldsDoc "metadata" p.metadata,
     fieldsDoc "extensions" p.extensions]

/-- Decode a canonical proof object. -/
def ProofObject.ofDoc : Doc → Option ProofObject
  | .node "proof" [("id", id), ("version", ver), ("kind", kind), ("procedure", proc),
      ("source_format", sf), ("source_data", sd), ("status", st)]
      [.node "inputs" [] ins, asm, par, .node "intermediate" [] inter,
       .node "outputs" [] outs, cl, cert, .node "errors" [] errs,
       .node "warnings" [] warns, prov, metaD, extD] => do
      let inputs ← ins.mapM Input.ofDoc
      let assumptions ← strsOf? "assumptions" asm
      let parameters ← fieldsOf? "parameters" par
      let intermediate ← inter.mapM Output.ofDoc
      let outputs ← outs.mapM Output.ofDoc
      let claims ← strsOf? "claims" cl
      let certificates ← strsOf? "certificates" cert
      let errors ← errs.mapM Diagnostic.ofDoc
      let warnings ← warns.mapM Diagnostic.ofDoc
      let provenance ← optProvOf? prov
      let metadata ← fieldsOf? "metadata" metaD
      let extensions ← fieldsOf? "extensions" extD
      let status ← Status.ofName? st
      some { id := id, version := ver, kind := kind, inputs := inputs,
             assumptions := assumptions, parameters := parameters, procedure := proc,
             intermediate := intermediate, outputs := outputs, claims := claims,
             certificates := certificates, errors := errors, warnings := warnings,
             provenance := provenance, metadata := metadata, sourceFormat := sf,
             sourceData := sd, status := status, extensions := extensions }
  | _ => none

/-- **The canonical object survives the document layer.** -/
@[simp] theorem ProofObject.ofDoc_toDoc (p : ProofObject) :
    ProofObject.ofDoc p.toDoc = some p := by
  cases p
  simp [ProofObject.toDoc, ProofObject.ofDoc,
    mapM_map_of_inv Input.ofDoc_toDoc, mapM_map_of_inv Output.ofDoc_toDoc,
    mapM_map_of_inv Diagnostic.ofDoc_toDoc]

theorem ProofObject.toDoc_injective : Function.Injective ProofObject.toDoc := by
  intro a b h
  have ha := ProofObject.ofDoc_toDoc a
  rw [h, ProofObject.ofDoc_toDoc b] at ha
  exact (Option.some_inj.mp ha).symm

end LifeTrac.Codec
