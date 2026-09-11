/-
# Standard Proof Codec — validation and error resolution (SOP §7, §8, §23, §24)

Validation happens at four levels: syntax, structure, type and semantics.  A
syntactically valid object is not a valid proof, so the levels are kept apart
and each produces first-class `ErrorObj` diagnostics rather than a bare
failure.

The error-resolution protocol of SOP §8 is implemented by `resolveObject`:
recoverable type problems are repaired by coercion, and **every automatic
repair is recorded** — `resolveInputs_repairs_recorded` proves that a value can
never change without a matching entry in the repair ledger, and the ledger
keeps the original value, so nothing is silently discarded.
-/
import RequestProject.Craft.Codec.Canonical
import RequestProject.Craft.Codec.Model

namespace Codec
namespace Validate

open Codec.Enc

/-! ## The four validation levels (SOP §23) -/

/-- The level at which a diagnostic was raised. -/
inductive Level where
  | SYNTAX | STRUCTURE | TYPE | SEMANTICS
  deriving Repr, DecidableEq, Inhabited

namespace Level

/-- Name of a validation level. -/
def toName : Level → String
  | .SYNTAX => "SYNTAX"
  | .STRUCTURE => "STRUCTURE"
  | .TYPE => "TYPE"
  | .SEMANTICS => "SEMANTICS"

end Level

/-! ## Types (SOP §4, §7) -/

/-- The canonical type of a value. -/
def typeName : CValue → String
  | .null => "null"
  | .bool _ => "boolean"
  | .int _ => "integer"
  | .str _ => "string"
  | .list _ => "list"
  | .obj _ => "object"

/-- Normalise a declared type name to a canonical type. Unknown names are kept
as they are rather than being coerced to something else. -/
def canonicalType : String → String
  | "integer" | "int" | "number" | "natural" => "integer"
  | "string" | "text" | "identifier" => "string"
  | "boolean" | "bool" => "boolean"
  | "list" | "array" | "matrix" | "vector" => "list"
  | "object" | "record" | "map" => "object"
  | "null" | "none" => "null"
  | t => t

/-- Whether a value is of the declared type. `any` accepts everything. -/
def typeMatches (declared : String) (v : CValue) : Bool :=
  declared == "any" || canonicalType declared == typeName v

/-! ## Diagnostics -/

/-- A path of the form `inputs[3].value`. -/
def slotPath (collection : String) (n : Nat) (field : String) : String :=
  collection ++ "[" ++ String.ofList (CValue.encNat n) ++ "]." ++ field

/-- The `TYPE_MISMATCH` diagnostic of SOP §7. -/
def typeError (objId path declared : String) (v : CValue) (recoverable : Bool) : ErrorObj :=
  { id := objId ++ ":" ++ path,
    code := "TYPE_MISMATCH",
    severity := if recoverable then Severity.WARNING else Severity.ERROR,
    message := "declared type does not match the value",
    location := none,
    field := some path,
    object_id := some objId,
    source_system := none,
    source_format := none,
    expected := some (canonicalType declared),
    actual := some (typeName v),
    cause := some "the value does not have the declared type",
    resolution := none,
    recoverable := recoverable }

/-- The diagnostic raised when a required field of the minimal interchange
profile is absent (SOP §31). -/
def missingFieldError (objId field : String) : ErrorObj :=
  { id := objId ++ ":missing:" ++ field,
    code := "MISSING_FIELD",
    severity := Severity.ERROR,
    message := "required field is absent",
    location := none,
    field := some field,
    object_id := some objId,
    source_system := none,
    source_format := none,
    expected := some field,
    actual := none,
    cause := some "the minimal interchange profile requires this field",
    resolution := none,
    recoverable := false }

/-- The diagnostic raised when a document cannot be parsed at all. This is an
`ERROR`, never an `INVALID` verdict: the system could not interpret the input,
which is not the same as an input that failed validation (SOP §6). -/
def syntaxError (objId : String) : ErrorObj :=
  { id := objId ++ ":syntax",
    code := "PARSE_FAILURE",
    severity := Severity.FATAL,
    message := "the document could not be parsed",
    location := none,
    field := none,
    object_id := some objId,
    source_system := none,
    source_format := none,
    expected := some "canonical serialization",
    actual := none,
    cause := some "unsupported syntax, partial or corrupted document",
    resolution := some "preserved as raw text",
    recoverable := true }

/-! ## Level 1 — syntax -/

/-- Parse a document at the syntax level. Failure is reported as a diagnostic
and the original text is never discarded by this function: the caller keeps it
in `source_data`. -/
def validateSyntax (objId text : String) : Except ErrorObj CValue :=
  match CValue.deserialize text with
  | some v => .ok v
  | none => .error (syntaxError objId)

/-- Canonical text always passes syntax validation, and yields the normalised
value it was written from. -/
theorem validateSyntax_serialize (objId : String) (v : CValue) :
    validateSyntax objId (CValue.serialize v) = .ok (CValue.normalize v) := by
  simp [validateSyntax, CValue.deserialize_serialize_eq]

/-- A parse failure is an `ERROR`, not an `INVALID`: they are different
statuses and the codec must not convert one into the other (SOP §6). -/
theorem parse_failure_is_error_not_invalid : Status.ERROR ≠ Status.INVALID := by decide

/-! ## Level 2 — structure -/

/-- Structural validation: the minimal interchange profile of SOP §31. -/
def validateStructure (objId : String) (v : CValue) : List ErrorObj :=
  (["id", "kind", "inputs", "outputs", "status", "errors", "metadata"].filter
    (fun f => (fld v f).isNone)).map (missingFieldError objId)

/-- Every encoded proof object is structurally valid. -/
theorem validateStructure_toCValue (objId : String) (p : ProofObject) :
    validateStructure objId (ProofObject.toCValue p) = [] := by
  simp [validateStructure, ProofObject.toCValue, fld, CValue.get?]

/-! ## Level 3 — types -/

/-- Type diagnostics for a list of inputs, indexed from `n`. -/
def inputErrors (objId : String) : Nat → List Input → List ErrorObj
  | _, [] => []
  | n, i :: rest =>
      (if typeMatches i.type i.value then []
        else [typeError objId (slotPath "inputs" n "value") i.type i.value true]) ++
      inputErrors objId (n + 1) rest

/-- Type diagnostics for a list of outputs, indexed from `n`. -/
def outputErrors (objId : String) : Nat → List Output → List ErrorObj
  | _, [] => []
  | n, o :: rest =>
      (if typeMatches o.type o.value then []
        else [typeError objId (slotPath "outputs" n "value") o.type o.value true]) ++
      outputErrors objId (n + 1) rest

/-- Type validation of a whole proof object. -/
def validateTypes (p : ProofObject) : List ErrorObj :=
  inputErrors p.id 0 p.inputs ++ outputErrors p.id 0 p.outputs

theorem inputErrors_nil_iff (objId : String) :
    ∀ (n : Nat) (is : List Input),
      inputErrors objId n is = [] ↔ ∀ i ∈ is, typeMatches i.type i.value = true := by
  intro n is
  induction is generalizing n with
  | nil => simp [inputErrors]
  | cons i rest ih =>
      by_cases h : typeMatches i.type i.value = true
      · simp [inputErrors, h, ih]
      · simp [inputErrors, h]

theorem outputErrors_nil_iff (objId : String) :
    ∀ (n : Nat) (os : List Output),
      outputErrors objId n os = [] ↔ ∀ o ∈ os, typeMatches o.type o.value = true := by
  intro n os
  induction os generalizing n with
  | nil => simp [outputErrors]
  | cons o rest ih =>
      by_cases h : typeMatches o.type o.value = true
      · simp [outputErrors, h, ih]
      · simp [outputErrors, h]

/-- Type validation is exact: it reports no diagnostic precisely when every
input and output has its declared type. -/
theorem validateTypes_nil_iff (p : ProofObject) :
    validateTypes p = [] ↔
      (∀ i ∈ p.inputs, typeMatches i.type i.value = true) ∧
      (∀ o ∈ p.outputs, typeMatches o.type o.value = true) := by
  simp [validateTypes, List.append_eq_nil_iff, inputErrors_nil_iff, outputErrors_nil_iff]

/-! ## Error resolution (SOP §8) -/

/-- A record of one automatic repair. The original value is kept, so a repair
never destroys information. -/
structure Repair where
  /-- Which field was repaired. -/
  field : String
  /-- The value as it was found. -/
  original : CValue
  /-- The value after repair. -/
  resolved : CValue
  /-- What was done. -/
  resolution : String
  /-- Why it was allowed. -/
  reason : String
  deriving Repr, DecidableEq, Inhabited

namespace Repair

/-- Encode a repair so it can travel with the object. -/
def toCValue (r : Repair) : CValue :=
  .obj [("field", .str r.field), ("original", r.original), ("resolved", r.resolved),
        ("resolution", .str r.resolution), ("reason", .str r.reason)]

/-- Decode a repair. -/
def ofCValue (v : CValue) : Option Repair := do
  let f ← decStr (← fld v "field")
  let o ← fld v "original"
  let s ← fld v "resolved"
  let rs ← decStr (← fld v "resolution")
  let rn ← decStr (← fld v "reason")
  some ⟨f, o, s, rs, rn⟩

theorem ofCValue_toCValue (r : Repair) : ofCValue (toCValue r) = some r := by
  obtain ⟨f, o, s, rs, rn⟩ := r
  simp [ofCValue, toCValue, fld, CValue.get?, decStr]

end Repair

/-- Conservative type coercion: only conversions that cannot lose information
are performed, and only towards the declared type. -/
def coerce (declared : String) (v : CValue) : Option CValue :=
  let t := canonicalType declared
  match v with
  | .str s =>
      if t = "integer" then (CValue.parseIntText s).map CValue.int
      else if t = "boolean" then
        (if s = "true" then some (.bool true)
          else if s = "false" then some (.bool false) else none)
      else none
  | .int n => if t = "string" then some (.str (CValue.intText n)) else none
  | .null => if t = "list" then some (.list []) else none
  | .bool _ => none
  | .list _ => none
  | .obj _ => none

/-- A coercion, when it succeeds, produces a value of the declared type: a
repair always fixes the problem it was applied to. -/
theorem coerce_typeMatches {declared : String} {v w : CValue} (h : coerce declared v = some w) :
    typeMatches declared w = true := by
  cases v with
  | str s =>
      simp only [coerce] at h
      by_cases h1 : canonicalType declared = "integer"
      · rw [if_pos h1] at h
        cases hp : CValue.parseIntText s with
        | none => rw [hp] at h; simp at h
        | some n =>
            rw [hp] at h
            simp only [Option.map_some, Option.some.injEq] at h
            subst h
            simp [typeMatches, typeName, h1]
      · rw [if_neg h1] at h
        by_cases h2 : canonicalType declared = "boolean"
        · rw [if_pos h2] at h
          by_cases h3 : s = "true"
          · rw [if_pos h3] at h
            simp only [Option.some.injEq] at h
            subst h
            simp [typeMatches, typeName, h2]
          · rw [if_neg h3] at h
            by_cases h4 : s = "false"
            · rw [if_pos h4] at h
              simp only [Option.some.injEq] at h
              subst h
              simp [typeMatches, typeName, h2]
            · rw [if_neg h4] at h; simp at h
        · rw [if_neg h2] at h; simp at h
  | int n =>
      simp only [coerce] at h
      by_cases h1 : canonicalType declared = "string"
      · rw [if_pos h1] at h
        simp only [Option.some.injEq] at h
        subst h
        simp [typeMatches, typeName, h1]
      · rw [if_neg h1] at h; simp at h
  | null =>
      simp only [coerce] at h
      by_cases h1 : canonicalType declared = "list"
      · rw [if_pos h1] at h
        simp only [Option.some.injEq] at h
        subst h
        simp [typeMatches, typeName, h1]
      · rw [if_neg h1] at h; simp at h
  | bool b => simp [coerce] at h
  | list xs => simp [coerce] at h
  | obj fs => simp [coerce] at h

/-- The example of SOP §8: the string `"144"` is coerced to the integer `144`
because the schema declares an integer. -/
theorem coerce_string_to_integer : coerce "integer" (.str "144") = some (.int 144) := by
  decide

/-- The repair-ledger entry produced by a successful coercion. -/
def coercionRepair (n : Nat) (i : Input) (w : CValue) : Repair :=
  { field := slotPath "inputs" n "value",
    original := i.value,
    resolved := w,
    resolution := typeName i.value ++ " → " ++ canonicalType i.type ++ " coercion",
    reason := "schema declares " ++ canonicalType i.type }

/-- The diagnostic that accompanies a successful coercion: the problem is
recorded even though it was repaired. -/
def coercionWarning (objId : String) (n : Nat) (i : Input) : ErrorObj :=
  { typeError objId (slotPath "inputs" n "value") i.type i.value true with
      resolution := some (typeName i.value ++ " → " ++ canonicalType i.type ++ " coercion") }

/-- Repair one input. Returns the (possibly repaired) input, the repair ledger
entry when a repair was made, and the diagnostics — which are retained in both
cases, exactly as SOP §8 requires. -/
def repairInput (objId : String) (n : Nat) (i : Input) :
    Input × List Repair × List ErrorObj :=
  if typeMatches i.type i.value then (i, [], [])
  else
    match coerce i.type i.value with
    | some w => ({ i with value := w }, [coercionRepair n i w], [coercionWarning objId n i])
    | none => (i, [], [typeError objId (slotPath "inputs" n "value") i.type i.value false])

/-- Repairing never changes an input except by a recorded repair. -/
theorem repairInput_recorded (objId : String) (n : Nat) (i : Input) :
    (repairInput objId n i).1 = i ∨
      ∃ r ∈ (repairInput objId n i).2.1,
        r.original = i.value ∧ r.resolved = (repairInput objId n i).1.value := by
  unfold repairInput
  split
  · exact Or.inl rfl
  · split
    · rename_i w _
      exact Or.inr ⟨coercionRepair n i w, List.mem_singleton_self _, rfl, rfl⟩
    · exact Or.inl rfl

/-- After repair an input either has its declared type or a diagnostic was
recorded: no problem is ever dropped. -/
theorem repairInput_typed_or_reported (objId : String) (n : Nat) (i : Input) :
    typeMatches (repairInput objId n i).1.type (repairInput objId n i).1.value = true ∨
      ∃ e ∈ (repairInput objId n i).2.2, e.code = "TYPE_MISMATCH" := by
  unfold repairInput
  split
  · rename_i h; exact Or.inl h
  · split
    · rename_i w hc
      exact Or.inl (coerce_typeMatches hc)
    · exact Or.inr ⟨typeError objId (slotPath "inputs" n "value") i.type i.value false,
        List.mem_singleton_self _, rfl⟩

/-- Repair a list of inputs. -/
def repairInputs (objId : String) : Nat → List Input →
    List Input × List Repair × List ErrorObj
  | _, [] => ([], [], [])
  | n, i :: rest =>
      ((repairInput objId n i).1 :: (repairInputs objId (n + 1) rest).1,
        (repairInput objId n i).2.1 ++ (repairInputs objId (n + 1) rest).2.1,
        (repairInput objId n i).2.2 ++ (repairInputs objId (n + 1) rest).2.2)

/-- Every automatic repair is recorded: each input is either unchanged, or the
repair ledger contains an entry holding both the original and the repaired
value (SOP §8). -/
theorem resolveInputs_repairs_recorded (objId : String) :
    ∀ (n : Nat) (is : List Input),
      List.Forall₂
        (fun old new => new = old ∨
          ∃ r ∈ (repairInputs objId n is).2.1,
            r.original = old.value ∧ r.resolved = new.value)
        is (repairInputs objId n is).1 := by
  intro n is
  induction is generalizing n with
  | nil => simp [repairInputs]
  | cons i rest ih =>
      have hi := repairInput_recorded objId n i
      have htail := ih (n + 1)
      simp only [repairInputs]
      refine List.Forall₂.cons ?_ (htail.imp ?_)
      · rcases hi with h | ⟨r, hr, h1, h2⟩
        · exact Or.inl h
        · exact Or.inr ⟨r, by simp [hr], h1, h2⟩
      · rintro old new (h | ⟨r, hr, h1, h2⟩)
        · exact Or.inl h
        · exact Or.inr ⟨r, by simp [hr], h1, h2⟩

/-- An object whose inputs already have their declared types is left exactly
as it is: repair is never gratuitous. -/
theorem repairInputs_of_typed (objId : String) :
    ∀ (n : Nat) (is : List Input), (∀ i ∈ is, typeMatches i.type i.value = true) →
      repairInputs objId n is = (is, [], []) := by
  intro n is
  induction is generalizing n with
  | nil => intro _; simp [repairInputs]
  | cons i rest ih =>
      intro h
      have hi : typeMatches i.type i.value = true := h i (by simp)
      have hrest : ∀ j ∈ rest, typeMatches j.type j.value = true :=
        fun j hj => h j (by simp [hj])
      simp [repairInputs, repairInput, hi, ih (n + 1) hrest]

/-- The number of inputs never changes under repair. -/
theorem repairInputs_length (objId : String) :
    ∀ (n : Nat) (is : List Input), (repairInputs objId n is).1.length = is.length := by
  intro n is
  induction is generalizing n with
  | nil => simp [repairInputs]
  | cons i rest ih => simp [repairInputs, ih]


/-! ## Resolution of a whole object -/

/-- The result of running the import-time resolution protocol on an object. -/
structure Report where
  /-- The object after resolution. -/
  object : ProofObject
  /-- Everything that was repaired automatically. -/
  repairs : List Repair
  /-- Everything that could not be repaired. -/
  unresolved : List ErrorObj
  deriving Repr, DecidableEq, Inhabited

/-- Run the resolution protocol: repair what can be repaired, record the
repairs, keep the diagnostics, and preserve the original values in the
extension namespace so that nothing is lost (SOP §8, §30). -/
def resolveObject (objId : String) (p : ProofObject) : Report :=
  let (is, rs, es) := repairInputs p.id 0 p.inputs
  let unresolved := es.filter (fun e => !e.recoverable)
  let recovered := es.filter (fun e => e.recoverable)
  let structural := validateStructure objId (ProofObject.toCValue p)
  { object :=
      { p with
          inputs := is,
          errors := p.errors ++ unresolved ++ structural,
          warnings := p.warnings ++ recovered,
          extensions := p.extensions ++
            [("$repairs", .list (rs.map Repair.toCValue))] },
    repairs := rs,
    unresolved := unresolved ++ structural }

/-- Resolution never discards the preserved source text. -/
theorem resolveObject_preserves_source (objId : String) (p : ProofObject) :
    (resolveObject objId p).object.source_data = p.source_data ∧
      (resolveObject objId p).object.source_format = p.source_format := ⟨rfl, rfl⟩

/-- Resolution never discards diagnostics that were already present. -/
theorem resolveObject_keeps_errors (objId : String) (p : ProofObject) :
    ∀ e ∈ p.errors, e ∈ (resolveObject objId p).object.errors := by
  intro e he
  simp [resolveObject]
  exact Or.inl he

/-- Every repair travels with the object: the ledger is attached in the
extension namespace, so an importer that does not understand repairs still
receives them (SOP §30). -/
theorem resolveObject_ledger_attached (objId : String) (p : ProofObject) :
    ("$repairs", CValue.list ((resolveObject objId p).repairs.map Repair.toCValue)) ∈
      (resolveObject objId p).object.extensions := by
  simp [resolveObject]

/-! ## Level 4 — semantics, and the overall verdict (SOP §24) -/

/-- The overall verdict. The codec does not decide validity itself: the proof
engine is passed in, and the codec only transports and combines verdicts. -/
def outcome (engine : ProofObject → Bool) (p : ProofObject) : Status :=
  if !(validateStructure p.id (ProofObject.toCValue p)).isEmpty then Status.INVALID
  else if !(validateTypes p).isEmpty then Status.INVALID
  else if p.inputs.isEmpty && p.outputs.isEmpty then Status.UNKNOWN
  else if engine p then Status.VALID else Status.INVALID

/-- The codec never certifies a proof the engine rejected. -/
theorem outcome_valid_implies_engine (engine : ProofObject → Bool) (p : ProofObject)
    (h : outcome engine p = Status.VALID) : engine p = true := by
  unfold outcome at h
  split at h
  · exact absurd h (by decide)
  · split at h
    · exact absurd h (by decide)
    · split at h
      · exact absurd h (by decide)
      · split at h
        · assumption
        · exact absurd h (by decide)

/-- A well-typed object with a satisfied engine is `VALID`. -/
theorem outcome_valid_of_engine (engine : ProofObject → Bool) (p : ProofObject)
    (hstruct : validateStructure p.id (ProofObject.toCValue p) = [])
    (htype : validateTypes p = [])
    (hne : ¬ (p.inputs.isEmpty && p.outputs.isEmpty))
    (heng : engine p = true) : outcome engine p = Status.VALID := by
  simp [outcome, hstruct, htype, hne, heng]

/-- Type failures produce `INVALID`, never `ERROR`: the operation completed and
the result failed validation (SOP §6). -/
theorem outcome_invalid_of_type_failure (engine : ProofObject → Bool) (p : ProofObject)
    (hstruct : validateStructure p.id (ProofObject.toCValue p) = [])
    (htype : validateTypes p ≠ []) : outcome engine p = Status.INVALID := by
  simp [outcome, hstruct, htype]

end Validate
end Codec
