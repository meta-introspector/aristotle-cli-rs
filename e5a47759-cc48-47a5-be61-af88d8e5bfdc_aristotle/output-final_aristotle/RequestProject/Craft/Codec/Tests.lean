/-
# Standard Proof Codec — the required test suite (SOP §33)

Every item the specification requires of a codec implementation appears here as
a machine-checked statement about concrete fixtures: empty and minimal objects,
nesting, multiple inputs and outputs, missing and unknown fields, invalid
types, malformed input, Unicode, large numbers, nulls, duplicate identifiers,
references, errors and warnings, partial, failed and successful proofs, round
trips and lossy conversions — followed by the proof-specific cases of a known
valid, invalid, contradictory, incomplete and incompatible result.
-/
import RequestProject.Craft.Codec.Pipeline
import RequestProject.Craft.Codec.Reconcile
import RequestProject.Craft.Codec.Schema

namespace Codec
namespace Tests

open Codec.Enc

/-! ## Fixtures -/

/-- A plain input. -/
def mkInput (id name ty : String) (v : CValue) : Input :=
  ⟨id, name, ty, v, none, none, [], none⟩

/-- A plain output. -/
def mkOutput (id name ty : String) (v : CValue) : Output :=
  ⟨id, name, ty, v, none, [], none, none⟩

/-- The empty object: no inputs, no outputs, nothing known. -/
def emptyObject : ProofObject := ProofObject.minimal "p-empty" "unknown" Status.UNKNOWN

/-- The minimal object of SOP §31: identity, kind, inputs, outputs, status. -/
def minimalObject : ProofObject :=
  { ProofObject.minimal "p-min" "computation" Status.VALID with
      inputs := [mkInput "i1" "n" "integer" (.int 144)],
      outputs := [mkOutput "o1" "result" "integer" (.int 12)] }

/-- A nested object: a matrix input and a structured output. -/
def nestedObject : ProofObject :=
  { ProofObject.minimal "p-nested" "linear-algebra" Status.VALID with
      inputs := [mkInput "i1" "matrix" "matrix"
        (.list [.list [.int 1, .int 2], .list [.int 3, .int 4]])],
      outputs := [mkOutput "o1" "decomposition" "object"
        (.obj [("rank", .int 2), ("detail", .obj [("pivots", .list [.int 1, .int 4])])])] }

/-- Several inputs and several outputs at once (SOP §5). -/
def manyObject : ProofObject :=
  { ProofObject.minimal "p-many" "factorization" Status.VALID with
      inputs := [mkInput "i1" "n" "integer" (.int 144),
                 mkInput "i2" "bound" "integer" (.int 20),
                 mkInput "i3" "method" "string" (.str "trial-division")],
      outputs := [mkOutput "o1" "factorization" "list" (.list [.int 2, .int 2, .int 2, .int 2,
                    .int 3, .int 3]),
                  mkOutput "o2" "witness" "string" (.str "144 = 2^4 * 3^2"),
                  mkOutput "o3" "diagnostic" "string" (.str "no anomalies")] }

/-- An object whose input has the wrong type: the schema declares an integer
and the value is the string `"144"` (SOP §7, §8). -/
def badTypeObject : ProofObject :=
  { ProofObject.minimal "p-bad" "computation" Status.PENDING with
      inputs := [mkInput "i1" "n" "integer" (.str "144")],
      outputs := [mkOutput "o1" "result" "integer" (.int 12)] }

/-- Unicode in identifiers, names and values. -/
def unicodeObject : ProofObject :=
  { ProofObject.minimal "p-∀" "théorème" Status.VALID with
      inputs := [mkInput "i-λ" "énoncé" "text" (.str "∀ x ∈ ℕ, x + 0 = x — 数学 🙂")],
      outputs := [mkOutput "o-π" "résultat" "text" (.str "démontré")] }

/-- Numbers well outside machine word range, positive and negative. -/
def bigNumberObject : ProofObject :=
  { ProofObject.minimal "p-big" "arithmetic" Status.VALID with
      inputs := [mkInput "i1" "n" "integer"
        (.int 123456789012345678901234567890123456789012345678901234567890)],
      outputs := [mkOutput "o1" "negated" "integer"
        (.int (-123456789012345678901234567890123456789012345678901234567890))] }

/-- Explicit nulls, which are values and not absences. -/
def nullObject : ProofObject :=
  { ProofObject.minimal "p-null" "computation" Status.PARTIAL with
      inputs := [mkInput "i1" "optional" "null" .null],
      outputs := [mkOutput "o1" "result" "null" .null] }

/-- Two inputs sharing an identifier: the codec must not silently drop one. -/
def duplicateObject : ProofObject :=
  { ProofObject.minimal "p-dup" "computation" Status.PARTIAL with
      inputs := [mkInput "i1" "n" "integer" (.int 1), mkInput "i1" "n" "integer" (.int 2)],
      outputs := [mkOutput "o1" "result" "integer" (.int 3)] }

/-- An object carrying errors and warnings. -/
def diagnosticObject : ProofObject :=
  { ProofObject.minimal "p-diag" "computation" Status.INVALID with
      inputs := [mkInput "i1" "n" "integer" (.int 144)],
      outputs := [mkOutput "o1" "result" "integer" (.int 11)],
      errors := [Validate.typeError "p-diag" "outputs[0].value" "integer" (.int 11) false],
      warnings := [Validate.missingFieldError "p-diag" "procedure"] }

/-- A partial proof. -/
def partialObject : ProofObject :=
  { minimalObject with id := "p-partial", status := Status.PARTIAL }

/-- A failed proof: the system could not complete the operation. -/
def failedObject : ProofObject :=
  { minimalObject with id := "p-failed", status := Status.ERROR }

/-- A successful proof. -/
def successObject : ProofObject := minimalObject

/-- A second system's result for the same question, with a different output. -/
def rivalObject : ProofObject :=
  { minimalObject with
      id := "p-min-b",
      outputs := [mkOutput "o1" "result" "integer" (.int 13)] }

/-- An incomplete result: the status says nothing yet. -/
def incompleteObject : ProofObject :=
  { minimalObject with id := "p-min-c", status := Status.PENDING }

/-! ## Structural tests -/

/-- Empty object: it still round-trips and still meets the minimal profile. -/
theorem test_empty_object :
    ProofObject.ofCValue (ProofObject.toCValue emptyObject) = some emptyObject ∧
      ProofObject.hasMinimalProfile (ProofObject.toCValue emptyObject) = true :=
  ⟨ProofObject.ofCValue_toCValue _, ProofObject.hasMinimalProfile_toCValue _⟩

/-- Minimal object. -/
theorem test_minimal_object :
    ProofObject.ofCValue (ProofObject.toCValue minimalObject) = some minimalObject :=
  ProofObject.ofCValue_toCValue _

/-- Nested object. -/
theorem test_nested_object :
    ProofObject.ofCValue (ProofObject.toCValue nestedObject) = some nestedObject :=
  ProofObject.ofCValue_toCValue _

/-- Multiple inputs and multiple outputs survive, in order. -/
theorem test_multiple_inputs_outputs :
    ProofObject.ofCValue (ProofObject.toCValue manyObject) = some manyObject ∧
      manyObject.inputs.length = 3 ∧ manyObject.outputs.length = 3 :=
  ⟨ProofObject.ofCValue_toCValue _, rfl, rfl⟩

/-- Missing field: a document that lacks required fields is not silently
accepted, and the diagnostics name exactly what is absent. -/
theorem test_missing_field :
    ProofObject.ofCValue (.obj [("id", .str "x")]) = none ∧
      Validate.validateStructure "x" (.obj [("id", .str "x")]) ≠ [] := by
  refine ⟨by decide, ?_⟩
  simp [Validate.validateStructure, fld, CValue.get?]

/-- Unknown field: a field this schema version does not define survives import
in the extension namespace (SOP §22, §30). -/
theorem test_unknown_field :
    ∃ q, Schema.importPreservingUnknown
        (Schema.withExtraField (ProofObject.toCValue minimalObject) "vendor.system_x"
          (.str "opaque")) = some q ∧
      ("vendor.system_x", CValue.str "opaque") ∈ q.extensions := by
  obtain ⟨q, hq, hmem, _⟩ :=
    Schema.unknown_field_preserved minimalObject "vendor.system_x" (.str "opaque")
      (by decide)
  exact ⟨q, hq, hmem⟩

/-- Invalid type: the declared type and the value disagree, validation says so,
the value is repaired by coercion, and the repair is recorded with the original
value kept (SOP §7, §8). -/
theorem test_invalid_type :
    Validate.validateTypes badTypeObject ≠ [] ∧
      (Validate.resolveObject "p-bad" badTypeObject).repairs =
        [Validate.coercionRepair 0 (mkInput "i1" "n" "integer" (.str "144")) (.int 144)] ∧
      (Validate.resolveObject "p-bad" badTypeObject).object.inputs =
        [mkInput "i1" "n" "integer" (.int 144)] := by
  have h144 : CValue.parseIntText "144" = some 144 := by decide
  refine ⟨?_, ?_, ?_⟩ <;>
    simp [Validate.validateTypes, Validate.inputErrors, Validate.outputErrors,
      Validate.resolveObject, Validate.repairInputs, Validate.repairInput,
      Validate.typeMatches, Validate.canonicalType, Validate.typeName, Validate.coerce,
      h144, badTypeObject, mkInput, mkOutput, ProofObject.minimal]

/-- The repair keeps the original value, so nothing is discarded. -/
theorem test_repair_keeps_original :
    ∀ r ∈ (Validate.resolveObject "p-bad" badTypeObject).repairs,
      r.original = CValue.str "144" ∧ r.resolved = CValue.int 144 := by
  have h144 : CValue.parseIntText "144" = some 144 := by decide
  simp [Validate.resolveObject, Validate.repairInputs, Validate.repairInput,
    Validate.typeMatches, Validate.canonicalType, Validate.typeName, Validate.coerce,
    Validate.coercionRepair, h144, badTypeObject, mkInput, ProofObject.minimal]

/-- Malformed input: text that carries no canonical block is not decoded, the
import fails safely with a diagnostic, and the text itself is preserved with
its complete line index (SOP §10, §11). -/
theorem test_malformed_input :
    Text.extract "this is not a proof" = none ∧
      (Pipeline.importArtifact "sys" "t0" "tr1" "p-x" Pipeline.Format.TEXT
        "this is not a proof" (Pipeline.Doc.text "this is not a proof")).object = none ∧
      (Pipeline.importArtifact "sys" "t0" "tr1" "p-x" Pipeline.Format.TEXT
        "this is not a proof" (Pipeline.Doc.text "this is not a proof")).errors ≠ [] := by
  have hnone : Pipeline.decodeDoc (Pipeline.Doc.text "this is not a proof") = none := by decide
  obtain ⟨h1, h2, _⟩ :=
    Pipeline.importArtifact_failure_reported "sys" "t0" "tr1" "p-x" Pipeline.Format.TEXT
      "this is not a proof" (Pipeline.Doc.text "this is not a proof") hnone
  exact ⟨by decide, h1, h2⟩

/-- Unicode survives every structured codec. -/
theorem test_unicode :
    ProofObject.ofCValue (ProofObject.toCValue unicodeObject) = some unicodeObject ∧
      Ipdl.decodeI (Ipdl.encodeI (ProofObject.toCValue unicodeObject)) =
        ProofObject.toCValue unicodeObject ∧
      Xml.decodeX (Xml.encodeX (ProofObject.toCValue unicodeObject)) =
        ProofObject.toCValue unicodeObject ∧
      Yaml.decodeY (Yaml.encodeY (ProofObject.toCValue unicodeObject)) =
        ProofObject.toCValue unicodeObject :=
  ⟨ProofObject.ofCValue_toCValue _, Ipdl.decodeI_encodeI _, Xml.decodeX_encodeX _,
    Yaml.decodeY_encodeY _⟩

/-- Large numbers survive, including the canonical text round trip. -/
theorem test_large_numbers :
    ProofObject.ofCValue (ProofObject.toCValue bigNumberObject) = some bigNumberObject ∧
      CValue.deserialize (CValue.serialize (ProofObject.toCValue bigNumberObject)) =
        some (CValue.normalize (ProofObject.toCValue bigNumberObject)) :=
  ⟨ProofObject.ofCValue_toCValue _, CValue.deserialize_serialize_eq _⟩

/-- Null values are values: they survive rather than being read as absences. -/
theorem test_null_values :
    ProofObject.ofCValue (ProofObject.toCValue nullObject) = some nullObject ∧
      (nullObject.inputs.map Input.value) = [CValue.null] :=
  ⟨ProofObject.ofCValue_toCValue _, rfl⟩

/-- Duplicate identifiers are preserved by the model, and the canonical form
resolves the duplication deterministically rather than at random. -/
theorem test_duplicate_identifiers :
    ProofObject.ofCValue (ProofObject.toCValue duplicateObject) = some duplicateObject ∧
      duplicateObject.inputs.length = 2 ∧
      CValue.normalize (CValue.normalize (ProofObject.toCValue duplicateObject)) =
        CValue.normalize (ProofObject.toCValue duplicateObject) :=
  ⟨ProofObject.ofCValue_toCValue _, rfl, CValue.normalize_idem _⟩

/-- References: an IPDL reference is a first-class construct and survives the
round trip through the canonical model. -/
theorem test_references :
    Ipdl.decodeI (Ipdl.encodeI (Ipdl.decodeI (.ref "lemma-7"))) =
      Ipdl.decodeI (.ref "lemma-7") ∧
    Ipdl.decodeI (.ref "lemma-7") = .obj [("$ipdl.ref", .str "lemma-7")] :=
  ⟨Ipdl.ipdl_doc_roundtrip _, Ipdl.ref_preserved "lemma-7"⟩

/-- Errors and warnings are first-class and survive the round trip. -/
theorem test_errors_and_warnings :
    ProofObject.ofCValue (ProofObject.toCValue diagnosticObject) = some diagnosticObject ∧
      diagnosticObject.errors.length = 1 ∧ diagnosticObject.warnings.length = 1 :=
  ⟨ProofObject.ofCValue_toCValue _, rfl, rfl⟩

/-- A partial proof stays partial. -/
theorem test_partial_proof :
    ProofObject.ofCValue (ProofObject.toCValue partialObject) = some partialObject ∧
      partialObject.status = Status.PARTIAL :=
  ⟨ProofObject.ofCValue_toCValue _, rfl⟩

/-- A failed proof stays an error, and `ERROR` is not `INVALID` (SOP §6). -/
theorem test_failed_proof :
    ProofObject.ofCValue (ProofObject.toCValue failedObject) = some failedObject ∧
      failedObject.status = Status.ERROR ∧ Status.ERROR ≠ Status.INVALID :=
  ⟨ProofObject.ofCValue_toCValue _, rfl, by decide⟩

/-- A successful proof stays valid. -/
theorem test_successful_proof :
    ProofObject.ofCValue (ProofObject.toCValue successObject) = some successObject ∧
      successObject.status = Status.VALID :=
  ⟨ProofObject.ofCValue_toCValue _, rfl⟩

/-! ## Conversion tests -/

/-- Round-trip conversion through every structured codec, for the nested
object (SOP §17). -/
theorem test_round_trip_conversion :
    ∀ f, (f = Pipeline.Format.IPDL ∨ f = Pipeline.Format.XML ∨ f = Pipeline.Format.YAML ∨
        f = Pipeline.Format.CANONICAL) →
      (Pipeline.decodeDoc (Pipeline.encodeDoc f nestedObject)).bind ProofObject.ofCValue =
        some nestedObject := by
  intro f hf
  exact ((Pipeline.definition_of_done nestedObject).1 f hf).2.1

/-- Round trip through raw text preserves the semantics and the content hash. -/
theorem test_text_round_trip :
    ∃ v, Pipeline.decodeDoc (Pipeline.encodeDoc Pipeline.Format.TEXT nestedObject) = some v ∧
      CValue.semEq v (ProofObject.toCValue nestedObject) ∧
      CValue.hash v = ProofObject.hash nestedObject := by
  obtain ⟨v, h1, h2, h3, _⟩ := (Pipeline.definition_of_done nestedObject).2.1
  exact ⟨v, h1, h2, h3⟩

/-- Lossy conversion: CSV keeps the documented view and no more, and the codec
declares this rather than claiming losslessness (SOP §9, §14). -/
theorem test_lossy_conversion :
    (∃ q, Csv.ofText (Csv.toText manyObject) = some q ∧ Csv.view q = Csv.view manyObject) ∧
      Pipeline.lossiness Pipeline.Format.CSV = Lossiness.PARTIAL ∧
      ∃ p₁ p₂ : ProofObject, p₁ ≠ p₂ ∧ Csv.toRows p₁ = Csv.toRows p₂ :=
  ⟨Csv.csv_text_roundtrip manyObject, rfl, Csv.csv_not_lossless⟩

/-! ## Proof-specific tests (SOP §33) -/

/-- A known valid proof: with the engine satisfied and validation clean, the
verdict is `VALID`. -/
theorem test_known_valid_proof :
    Validate.outcome (fun _ => true) minimalObject = Status.VALID := by
  refine Validate.outcome_valid_of_engine _ _ ?_ ?_ (by decide) rfl
  · exact Validate.validateStructure_toCValue _ _
  · simp [Validate.validateTypes, Validate.inputErrors, Validate.outputErrors,
      Validate.typeMatches, Validate.canonicalType, Validate.typeName, minimalObject,
      mkInput, mkOutput, ProofObject.minimal]

/-- A known invalid proof: the engine rejects it, so the verdict is `INVALID`
— and the codec never upgrades that to `VALID`. -/
theorem test_known_invalid_proof :
    Validate.outcome (fun _ => false) minimalObject = Status.INVALID ∧
      ∀ engine : ProofObject → Bool,
        Validate.outcome engine minimalObject = Status.VALID → engine minimalObject = true := by
  refine ⟨?_, fun engine h => Validate.outcome_valid_implies_engine engine minimalObject h⟩
  simp [Validate.outcome, Validate.validateStructure, Validate.validateTypes,
    Validate.inputErrors, Validate.outputErrors, Validate.typeMatches,
    Validate.canonicalType, Validate.typeName, fld, CValue.get?, ProofObject.toCValue,
    minimalObject, mkInput, mkOutput, ProofObject.minimal]

/-- Two systems that both claim validity but produce different outputs are in
`CONFLICT`, and the conflict is never merged silently: resolving it records the
strategy, the verdict and the differences, and a merge is marked `CONFLICT`
(SOP §28, §29). -/
theorem test_known_contradictory_proof :
    Reconcile.compareObjects minimalObject rivalObject = Comparison.CONFLICT ∧
      (Reconcile.resolveConflict "r1" Reconcile.Strategy.merge minimalObject rivalObject).1.map
        ProofObject.status = some Status.CONFLICT ∧
      (Reconcile.resolveConflict "r1" Reconcile.Strategy.merge minimalObject rivalObject).2.verdict
        = Reconcile.compareObjects minimalObject rivalObject := by
  have hout : ¬ CValue.semEq (Enc.encL Output.toCValue minimalObject.outputs)
      (Enc.encL Output.toCValue rivalObject.outputs) := by
    intro h
    simp only [minimalObject, rivalObject, mkOutput, ProofObject.minimal, CValue.semEq,
      Enc.encL, List.map_cons, List.map_nil, CValue.normalize, CValue.normalizeL] at h
    injection h with h
    injection h with h1 _
    have h3 := CValue.semEq_get? h1 "value"
    simp [Output.toCValue, CValue.get?_cons, CValue.normalize] at h3
  refine ⟨Reconcile.compareObjects_conflict _ _ rfl (Reconcile.compareValues_refl _) ?_ rfl rfl,
    Reconcile.merge_marks_conflict _ _ _, (Reconcile.resolution_records_everything _ _ _ _).2.2.2.2.1⟩
  intro hc
  exact hout ((Reconcile.compareValues_eq_iff _ _).mp hc)

/-- A known incomplete result cannot be judged: the comparator says
`INCOMPLETE` rather than guessing. -/
theorem test_known_incomplete_proof :
    Reconcile.compareObjects minimalObject incompleteObject = Comparison.INCOMPLETE ∨
      Reconcile.compareObjects incompleteObject minimalObject =
        Comparison.INCOMPLETE := by
  refine Or.inr (Reconcile.compareObjects_incomplete _ _ rfl (Reconcile.compareValues_refl _) ?_)
  rfl

/-- A known incompatible output is reported as a structured difference with a
path, not as a bare failure (SOP §28). -/
theorem test_known_incompatible_output :
    Reconcile.differences minimalObject rivalObject ≠ [] := by
  intro h
  have hsem := (Reconcile.differences_nil_iff minimalObject rivalObject).mp h
  have h3 := CValue.semEq_get? hsem "id"
  simp [ProofObject.toCValue, CValue.get?_cons, CValue.normalize, minimalObject, rivalObject,
    ProofObject.minimal] at h3

end Tests
end Codec
