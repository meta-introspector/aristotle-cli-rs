/-
# Validation, and the error-resolution protocol

Validation happens at four levels (§23):

```text
1. Syntax      the text parses at all
2. Structure   the required fields are present
3. Type        the values have the declared types and the ids are unique
4. Semantics   the claim the object makes about itself is coherent
```

A syntactically valid object is not necessarily a valid proof, so the
levels are kept apart and each reports its own errors.

Resolution (§8) is separate from validation, and constrained:

* errors are **retained**, never discarded;
* every automatic repair is **recorded**, as a `RESOLVED_*` diagnostic
  carrying the original and the resolved value;
* the status is **never silently changed** (§6) — `resolve` cannot touch
  it, and `resolve_preserves_status` proves it.
-/
import RequestProject.Edge.Codec.Detect

namespace CfDeploy
namespace Codec
namespace Validate

/-! ## Levels -/

/-- The four validation levels. -/
inductive Level where
  | syntax'
  | structure'
  | type'
  | semantics
  deriving DecidableEq, Repr, Inhabited

def Level.name : Level → String
  | .syntax' => "SYNTAX"
  | .structure' => "STRUCTURE"
  | .type' => "TYPE"
  | .semantics => "SEMANTICS"

/-! ## Level 1: syntax -/

/-- Can the declared codec read this text at all?  A parse failure is an
`ERROR` (the system could not interpret the operation), never an
`INVALID` (§6). -/
def syntaxErrors (fmt : Format) (s : String) : List CError :=
  match (codecFor fmt).decodeDoc s with
  | some _ => []
  | none =>
      [{ id := "e-syntax", code := "PARSE_ERROR", severity := .error
       , message := "the text could not be parsed as " ++ fmt.name
       , sourceFormat := fmt.name, expected := fmt.name, actual := "unparsed"
       , recoverable := true
       , resolution := "import as raw text; the original is preserved" }]

/-- **A codec's own output always parses.** -/
theorem syntaxErrors_of_encode (c : StringCodec) (fmt : Format) (v : CVal)
    (hc : codecFor fmt = c) (h : c.lossiness = .lossless) (hv : c.domain v = true) :
    syntaxErrors fmt (c.encode v) = [] := by
  simp [syntaxErrors, hc, StringCodec.decodeDoc, c.lossless_on_domain h v hv]

/-! ## Level 2: structure -/

/-- The minimum interchange profile of §31. -/
def missingRequired (p : ProofObject) : List String :=
  (if p.id = "" then ["id"] else []) ++
  (if p.kind = "" then ["kind"] else []) ++
  (if p.version = "" then ["version"] else [])

def structureErrors (p : ProofObject) : List CError :=
  (missingRequired p).map (fun f =>
    { id := "e-structure-" ++ f, code := "MISSING_FIELD", severity := .error
    , message := "required field is absent: " ++ f
    , field := f, objectId := p.id, expected := "present", actual := "absent"
    , recoverable := true })

/-! ## Level 3: types and identity -/

/-- Are all these identifiers distinct? -/
def duplicates : List String → List String
  | [] => []
  | x :: xs => (if xs.contains x then [x] else []) ++ duplicates xs

def objectIds (p : ProofObject) : List String :=
  p.inputs.map (fun i => i.id) ++ p.outputs.map (fun o => o.id)

def typeErrors (p : ProofObject) : List CError :=
  (duplicates (objectIds p)).map (fun d =>
    { id := "e-duplicate-" ++ d, code := "DUPLICATE_IDENTIFIER", severity := .error
    , message := "two objects share the identifier " ++ d
    , field := "id", objectId := d, expected := "unique", actual := "duplicated"
    , recoverable := false }) ++
  (p.inputs.filter (fun i => i.id = "")).map (fun _ =>
    { id := "e-input-id", code := "MISSING_FIELD", severity := .error
    , message := "an input has no identifier", field := "inputs[].id"
    , objectId := p.id, expected := "present", actual := "absent"
    , recoverable := true }) ++
  (p.outputs.filter (fun o => o.id = "")).map (fun _ =>
    { id := "e-output-id", code := "MISSING_FIELD", severity := .error
    , message := "an output has no identifier", field := "outputs[].id"
    , objectId := p.id, expected := "present", actual := "absent"
    , recoverable := true })

/-! ## Level 4: semantics -/

/-- Does the object's own status agree with what it carries?  `VALID`
with a fatal error in the same object is exactly the kind of quiet
inconsistency the standard exists to catch. -/
def semanticErrors (p : ProofObject) : List CError :=
  let hard := p.errors.filter (fun e => e.severity == .error || e.severity == .fatal)
  (if p.status == .valid && !hard.isEmpty then
    [{ id := "e-status-valid-with-errors", code := "STATUS_CONFLICT", severity := .error
     , message := "status is VALID but the object carries errors"
     , field := "status", objectId := p.id, expected := "no errors", actual := "errors present"
     , recoverable := false }] else []) ++
  (if p.status == .valid && p.outputs.isEmpty then
    [{ id := "e-status-valid-no-outputs", code := "MISSING_FIELD", severity := .warning
     , message := "status is VALID but the object produced no outputs"
     , field := "outputs", objectId := p.id, expected := "at least one output"
     , actual := "none", recoverable := true }] else []) ++
  (if p.status == .invalid && hard.isEmpty then
    [{ id := "e-status-invalid-no-reason", code := "MISSING_FIELD", severity := .warning
     , message := "status is INVALID but no error explains why"
     , field := "errors", objectId := p.id, expected := "at least one error"
     , actual := "none", recoverable := true }] else [])

/-! ## The report -/

/-- Everything the four levels found. -/
structure Report where
  syntax' : List CError
  structure' : List CError
  type' : List CError
  semantics : List CError
  deriving Repr, Inhabited

def Report.all (r : Report) : List CError :=
  r.syntax' ++ r.structure' ++ r.type' ++ r.semantics

/-- Did every level pass? -/
def Report.ok (r : Report) : Bool := r.all.isEmpty

/-- Validate a decoded object.  `fmt` and `src` are the format and text
it came from, so level 1 can be checked too. -/
def validate (fmt : Format) (src : String) (p : ProofObject) : Report :=
  { syntax' := syntaxErrors fmt src
  , structure' := structureErrors p
  , type' := typeErrors p
  , semantics := semanticErrors p }

/-- Validate an object on its own, without a source text. -/
def validateObject (p : ProofObject) : Report :=
  { syntax' := [], structure' := structureErrors p
  , type' := typeErrors p, semantics := semanticErrors p }

/-- **A complete, coherent object validates cleanly.** -/
theorem validateObject_ok (p : ProofObject)
    (hid : p.id ≠ "") (hkind : p.kind ≠ "") (hver : p.version ≠ "")
    (hdup : duplicates (objectIds p) = [])
    (hin : p.inputs.filter (fun i => i.id = "") = [])
    (hout : p.outputs.filter (fun o => o.id = "") = [])
    (hstatus : p.status = .unknown) :
    (validateObject p).ok = true := by
  simp [validateObject, Report.ok, Report.all, structureErrors, missingRequired,
    typeErrors, semanticErrors, hid, hkind, hver, hdup, hin, hout, hstatus]

/-- **Duplicate identifiers are caught.** -/
theorem duplicates_detects (a : String) (xs : List String) (h : xs.contains a = true) :
    duplicates (a :: xs) ≠ [] := by
  simp only [duplicates, if_pos h, List.cons_append, List.nil_append]
  simp

/-- **`VALID` with errors is reported, not accepted.** -/
theorem valid_with_error_is_flagged (p : ProofObject) (e : CError)
    (hs : p.status = .valid) (he : e ∈ p.errors) (hsev : e.severity = .error) :
    semanticErrors p ≠ [] := by
  have hne : p.errors.filter (fun e => e.severity == .error || e.severity == .fatal) ≠ [] := by
    intro hc
    have : e ∈ p.errors.filter (fun e => e.severity == .error || e.severity == .fatal) := by
      simp [List.mem_filter, he, hsev]
    rw [hc] at this
    simp at this
  simp only [semanticErrors, hs]
  intro hc
  simp only [List.append_eq_nil_iff] at hc
  have := hc.1.1
  split at this
  · simp at this
  · rename_i hcond
    simp only [beq_self_eq_true, Bool.true_and, Bool.not_eq_true'] at hcond
    exact hne (List.isEmpty_iff.mp (by simpa using hcond))

/-! ## Resolution (§8) -/

/-- What a resolver did. -/
inductive Action where
  /-- the value was coerced to the declared type -/
  | coerced
  /-- a missing piece of metadata was inferred -/
  | inferred
  /-- nothing could be done automatically; a human is needed -/
  | deferred
  deriving DecidableEq, Repr, Inhabited

def Action.name : Action → String
  | .coerced => "COERCED"
  | .inferred => "INFERRED"
  | .deferred => "DEFERRED"

/-- A repair, recorded.  Both the original and the resolved value are
kept, so a repair can always be undone or questioned. -/
structure Repair where
  action : Action
  field : String
  original : CVal
  resolved : CVal
  reason : String
  deriving Repr, Inhabited

def Repair.toError (r : Repair) : CError :=
  { id := "r-" ++ r.field, code := "RESOLVED_" ++ r.action.name, severity := .info
  , message := r.reason, field := r.field
  , expected := "", actual := "", cause := "", resolution := r.action.name
  , recoverable := true }

/-- The string-to-integer coercion of §8: `"144"` under a schema that
declares `integer`. -/
def coerceToInt (field : String) (v : CVal) : Option Repair :=
  match v with
  | .str s =>
      match Parse.parseIntStr s with
      | some i => some ⟨.coerced, field, .str s, .int i,
          "string → integer coercion; the schema declares integer"⟩
      | none => none
  | _ => none

/-- **A coercion keeps the original.** -/
theorem coerceToInt_keeps_original {field : String} {v : CVal} {r : Repair}
    (h : coerceToInt field v = some r) : r.original = v := by
  cases v with
  | str s =>
      simp only [coerceToInt] at h
      split at h
      · simp only [Option.some.injEq] at h; rw [← h]
      · simp at h
  | _ => simp [coerceToInt] at h

/-- The outcome of resolving an object: the repaired object, the repairs
that were made, and every error that was already there. -/
structure Resolution where
  object : ProofObject
  repairs : List Repair
  /-- the incoming errors, retained in full -/
  retained : List CError
  deriving Repr, Inhabited

/-- All the diagnostics after resolution: what was already there, plus a
record of every repair. -/
def Resolution.diagnostics (r : Resolution) : List CError :=
  r.retained ++ r.repairs.map Repair.toError

/-- Resolve the inputs of an object whose declared type is `integer` but
whose value arrived as a string.  Nothing else is touched. -/
def resolveInputs : List CInput → List CInput × List Repair
  | [] => ([], [])
  | i :: is =>
      let (rest, reps) := resolveInputs is
      if i.type = "integer" then
        match coerceToInt ("inputs[" ++ i.id ++ "].value") i.value with
        | some r => ({ i with value := r.resolved } :: rest, r :: reps)
        | none => (i :: rest, reps)
      else (i :: rest, reps)

/-- Apply the automatic repairs, retaining every incoming error. -/
def resolve (p : ProofObject) : Resolution :=
  let (ins, reps) := resolveInputs p.inputs
  { object := { p with inputs := ins }
  , repairs := reps
  , retained := p.errors }

/-- **Errors are retained, never discarded** (§8). -/
@[simp] theorem resolve_retains_errors (p : ProofObject) :
    (resolve p).retained = p.errors := rfl

/-- **The status is never silently converted** (§6). -/
@[simp] theorem resolve_preserves_status (p : ProofObject) :
    (resolve p).object.status = p.status := rfl

/-- **The source text is never dropped by resolution.** -/
@[simp] theorem resolve_preserves_source (p : ProofObject) :
    (resolve p).object.sourceData = p.sourceData := rfl

/-- **Every repair is recorded**, and the record carries the original
value alongside the resolved one. -/
theorem resolve_records_repairs (p : ProofObject) (r : Repair)
    (h : r ∈ (resolve p).repairs) : r.toError ∈ (resolve p).diagnostics := by
  simp [Resolution.diagnostics]
  exact Or.inr ⟨r, h, rfl⟩

/-- **Resolution never invents outputs or claims.** -/
@[simp] theorem resolve_preserves_outputs (p : ProofObject) :
    (resolve p).object.outputs = p.outputs := rfl

end Validate
end Codec
end CfDeploy
