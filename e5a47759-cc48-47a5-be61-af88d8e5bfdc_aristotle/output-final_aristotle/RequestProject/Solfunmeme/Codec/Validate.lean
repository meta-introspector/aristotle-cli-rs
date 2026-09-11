import RequestProject.Solfunmeme.Codec.Formats

/-!
# §7, §8, §23, §24, §25 Validation, resolution and contracts

Validation happens at four levels (§23) and they are genuinely different
questions:

```text
1. Syntax      does it parse?
2. Structure   are the required fields there?
3. Type        do the values match their declared types?
4. Semantics   is the proof actually valid?
```

`validate` runs the first three and stops: the codec is not the proof engine
(§24).  Level 4 is a *hook*, `validateWith`, which takes the verdict of an
external engine and records it — and `validateWith_records_engine` says the
codec reports what the engine said and nothing else.

§8 asks that errors be retained rather than discarded and that "every automatic
repair MUST be recorded".  `resolve` is the repair pass, and
`resolve_records_every_repair` is that rule as a theorem: the number of
diagnostics it emits is exactly the number of fields it changed.
-/

namespace Solfunmeme.Codec

/-! ## §23 The four levels -/

/-- The four levels of validation. -/
inductive Level where
  | SYNTAX | STRUCTURE | TYPE | SEMANTICS
  deriving DecidableEq, Repr, Inhabited

def Level.name : Level → String
  | .SYNTAX => "SYNTAX"
  | .STRUCTURE => "STRUCTURE"
  | .TYPE => "TYPE"
  | .SEMANTICS => "SEMANTICS"

/-- What a validation pass found. -/
structure Report where
  /-- The deepest level that was reached without a fatal finding. -/
  reached : Level
  /-- Everything that was found, at every level. -/
  diagnostics : List Diagnostic := []
  deriving DecidableEq, Repr, Inhabited

/-- A report is clean when nothing at all was found. -/
def Report.clean (r : Report) : Bool := r.diagnostics.isEmpty

/-! ## Level 1: syntax -/

/-- Level 1 for a document in a known codec: does it parse into rows? -/
def validateSyntax (r : RowSyntax) (s : String) : Option (List Cell) := r.parse s

/-- §11: a failed parse is a fact about this parser, not a verdict on the data,
so the diagnostic it produces is recoverable and its severity is `WARNING`. -/
def syntaxDiagnostic (fmt : String) : Diagnostic :=
  { id := "diag-syntax"
    code := "PARSE_FAILED"
    severity := .WARNING
    message := "the document did not parse in the declared syntax"
    sourceFormat := fmt
    cause := "unsupported syntax, partial document, mixed-format document or unknown dialect"
    resolution := "retained as raw text"
    recoverable := true }

theorem syntaxDiagnostic_recoverable (fmt : String) : (syntaxDiagnostic fmt).recoverable = true :=
  rfl

theorem syntaxDiagnostic_not_invalid (fmt : String) :
    (syntaxDiagnostic fmt).severity ≠ .FATAL := by
  intro h; exact Severity.noConfusion h

/-! ## Level 2: structure -/

/-- Level 2: the fields §3 requires.  `inputs`, `outputs` and `status` are
present in every `ProofObject` by construction, so what is left to check is
that the object has an identity and a kind — the minimal profile of §31. -/
def validateStructure (p : ProofObject) : List Diagnostic :=
  (if p.id = "" then
    [{ id := "diag-structure-id", code := "MISSING_FIELD", severity := .ERROR,
       field := "id", expected := "identifier", actual := "",
       message := "the object has no identity", recoverable := true : Diagnostic }]
  else []) ++
  (if p.kind = "" then
    [{ id := "diag-structure-kind", code := "MISSING_FIELD", severity := .ERROR,
       field := "kind", expected := "identifier", actual := "",
       message := "the object has no kind", recoverable := true : Diagnostic }]
  else [])

theorem validateStructure_nil_iff (p : ProofObject) :
    validateStructure p = [] ↔ p.minimalProfile = true := by
  unfold validateStructure ProofObject.minimalProfile
  by_cases h1 : p.id = "" <;> by_cases h2 : p.kind = "" <;> simp [h1, h2]

/-! ## Level 3: types -/

/-- Does a value match a declared type?  Only the types this codec can check
are checked; an unknown type name is not a failure, it is simply not checked
(§30: unknown does not mean wrong). -/
def typeMatches (ty v : String) : Bool :=
  if ty = "integer" then isDigits v
  else true

/-- §7's worked example, generated: a type mismatch names the field, what was
expected, what was found, and that it can be repaired. -/
def typeMismatch (path ty v : String) : Diagnostic :=
  { id := "diag-type-" ++ path
    code := "TYPE_MISMATCH"
    severity := .ERROR
    field := path
    expected := ty
    actual := inferType v
    message := "the value does not match its declared type"
    recoverable := true }

/-- Level 3 over every input and output. -/
def validateTypes (p : ProofObject) : List Diagnostic :=
  p.inputs.flatMap (fun i =>
      if typeMatches i.type i.value then [] else [typeMismatch ("inputs." ++ i.id) i.type i.value])
    ++ p.outputs.flatMap (fun o =>
      if typeMatches o.type o.value then [] else
        [typeMismatch ("outputs." ++ o.id) o.type o.value])

theorem flatMap_nil_of_all {α β : Type} (l : List α) (f : α → List β) (h : ∀ x ∈ l, f x = []) :
    l.flatMap f = [] := by
  induction l with
  | nil => rfl
  | cons a as ih => simp [h a (by simp), ih (fun x hx => h x (by simp [hx]))]

theorem validateTypes_nil_of_all_match {p : ProofObject}
    (hi : ∀ i ∈ p.inputs, typeMatches i.type i.value = true)
    (ho : ∀ o ∈ p.outputs, typeMatches o.type o.value = true) :
    validateTypes p = [] := by
  unfold validateTypes
  rw [flatMap_nil_of_all _ _ (fun i hii => by simp [hi i hii]),
    flatMap_nil_of_all _ _ (fun o hoo => by simp [ho o hoo])]
  rfl

/-! ## §23 The pass -/

/-- Levels 2 and 3, in order.  Level 1 has already happened by the time an
object exists; level 4 is not the codec's business. -/
def validate (p : ProofObject) : Report :=
  let structural := validateStructure p
  if structural.isEmpty then
    { reached := .TYPE, diagnostics := validateTypes p }
  else
    { reached := .STRUCTURE, diagnostics := structural ++ validateTypes p }

theorem validate_clean_of_minimal {p : ProofObject} (hm : p.minimalProfile = true)
    (hi : ∀ i ∈ p.inputs, typeMatches i.type i.value = true)
    (ho : ∀ o ∈ p.outputs, typeMatches o.type o.value = true) :
    (validate p).clean = true := by
  have hs : validateStructure p = [] := (validateStructure_nil_iff p).2 hm
  simp [validate, Report.clean, hs, validateTypes_nil_of_all_match hi ho]

/-- §23: "a syntactically valid object is not necessarily a valid proof".  Here
is one: it parses, it has every required field, its types check — and its
status is `UNKNOWN`, because none of that says anything about the proof. -/
def wellFormedButUnproved : ProofObject :=
  { id := "p-unproved", kind := "theorem",
    inputs := [{ id := "i1", name := "n", type := "integer", value := "144" }],
    outputs := [{ id := "o1", name := "result", type := "integer", value := "12" }],
    status := .UNKNOWN }

theorem validation_is_not_proof :
    (validate wellFormedButUnproved).clean = true
      ∧ wellFormedButUnproved.status = .UNKNOWN := by
  constructor
  · decide +kernel
  · rfl

/-! ## §8 Error resolution -/

/-- One automatic repair, as §8 requires it to be recorded: what was there,
what it became, and why. -/
def coercionRecord (path original resolved reason : String) : Diagnostic :=
  { id := "diag-resolve-" ++ path
    code := "TYPE_COERCED"
    severity := .INFO
    field := path
    actual := original
    expected := resolved
    cause := reason
    resolution := original ++ " → " ++ resolved
    recoverable := true }

/-- Repair one input: an input whose type was never declared gets the type its
value conservatively supports (§8, "infer missing metadata").  Nothing else is
touched, and the original value is never rewritten. -/
def resolveInput (i : Input) : Input × List Diagnostic :=
  if i.type = "" then
    ({ i with type := inferType i.value },
      [coercionRecord ("inputs." ++ i.id) "" (inferType i.value)
        "schema declares a type; the value supports one"])
  else (i, [])

/-- Repair every input of an object. -/
def resolve (p : ProofObject) : ProofObject × List Diagnostic :=
  let rs := p.inputs.map resolveInput
  ({ p with inputs := rs.map Prod.fst, errors := p.errors ++ rs.flatMap Prod.snd },
    rs.flatMap Prod.snd)

/-- §8: every automatic repair is recorded — one diagnostic for every input
that changed, and none for an input that did not. -/
theorem resolveInput_records (i : Input) :
    ((resolveInput i).1 = i ∧ (resolveInput i).2 = [])
      ∨ ((resolveInput i).1 ≠ i ∧ (resolveInput i).2.length = 1) := by
  unfold resolveInput
  by_cases h : i.type = ""
  · refine Or.inr ⟨?_, by simp [h]⟩
    simp only [h, if_pos]
    intro hcon
    have hty : inferType i.value = i.type := congrArg Input.type hcon
    rw [h] at hty
    rcases inferType_eq i.value with hh | hh <;> rw [hh] at hty <;> exact absurd hty (by decide)
  · exact Or.inl ⟨by simp [h], by simp [h]⟩

/-- §8: the repaired object keeps every diagnostic that was already there and
adds exactly the repairs it made — nothing is discarded. -/
theorem resolve_retains_errors (p : ProofObject) :
    (resolve p).1.errors = p.errors ++ (resolve p).2 := rfl

/-- Repair leaves no input without a type. -/
theorem resolve_no_missing_type (p : ProofObject) :
    ∀ i ∈ (resolve p).1.inputs, i.type ≠ "" := by
  intro i hi
  simp only [resolve, List.map_map] at hi
  obtain ⟨j, _, rfl⟩ := List.mem_map.mp hi
  simp only [Function.comp_apply, resolveInput]
  by_cases h : j.type = ""
  · simp only [h, if_pos]
    rcases inferType_eq j.value with hh | hh <;> rw [hh] <;> exact (by decide)
  · simp [h]

/-- Repair is idempotent: running it again changes nothing and records
nothing, so a repaired object is stable. -/
theorem resolveInput_idem (i : Input) :
    resolveInput (resolveInput i).1 = ((resolveInput i).1, []) := by
  unfold resolveInput
  by_cases h : i.type = ""
  · simp only [h, if_pos]
    have : inferType i.value ≠ "" := by
      rcases inferType_eq i.value with hh | hh <;> rw [hh] <;> exact (by decide)
    simp [this]
  · simp [h]

/-! ## §24 The proof engine is not the codec -/

/-- Level 4: hand the object to a proof engine and record what it says.  The
codec transports the verdict; it does not form one. -/
def validateWith (engine : ProofObject → Status) (certificate : ProofObject → String)
    (p : ProofObject) : ProofObject :=
  { p with
      status := engine p
      certificates := p.certificates ++ [certificate p] }

theorem validateWith_records_engine (engine : ProofObject → Status)
    (certificate : ProofObject → String) (p : ProofObject) :
    (validateWith engine certificate p).status = engine p := rfl

theorem validateWith_keeps_certificates (engine : ProofObject → Status)
    (certificate : ProofObject → String) (p : ProofObject) :
    (validateWith engine certificate p).certificates = p.certificates ++ [certificate p] := rfl

/-- The codec changes nothing else: inputs, outputs and claims are untouched by
validation. -/
theorem validateWith_preserves_content (engine : ProofObject → Status)
    (certificate : ProofObject → String) (p : ProofObject) :
    (validateWith engine certificate p).inputs = p.inputs
      ∧ (validateWith engine certificate p).outputs = p.outputs
      ∧ (validateWith engine certificate p).claims = p.claims := ⟨rfl, rfl, rfl⟩

/-! ## §25 The input/output contract -/

/-- What a proof implementation publishes about itself: the names and types it
consumes, the names and types it produces, and the error codes it may raise. -/
structure Contract where
  /-- The name of the proof this contract belongs to. -/
  name : String
  /-- `(name, type)` of each required input. -/
  inputSchema : List (String × String)
  /-- `(name, type)` of each promised output. -/
  outputSchema : List (String × String)
  /-- The error codes this proof may raise. -/
  errorSchema : List String
  deriving DecidableEq, Repr, Inhabited

/-- Is a required `(name, type)` present in a list of inputs? -/
def hasInput (is : List Input) (nt : String × String) : Bool :=
  is.any (fun i => i.name == nt.1 && i.type == nt.2)

/-- Is a promised `(name, type)` present in a list of outputs? -/
def hasOutput (os : List Output) (nt : String × String) : Bool :=
  os.any (fun o => o.name == nt.1 && o.type == nt.2)

/-- Check an object against a contract. -/
def checkContract (c : Contract) (p : ProofObject) : List Diagnostic :=
  c.inputSchema.flatMap (fun nt =>
      if hasInput p.inputs nt then [] else
        [{ id := "diag-contract-in-" ++ nt.1, code := "MISSING_INPUT", severity := .ERROR,
           field := "inputs." ++ nt.1, expected := nt.2, message := c.name,
           recoverable := false : Diagnostic }])
    ++ c.outputSchema.flatMap (fun nt =>
      if hasOutput p.outputs nt then [] else
        [{ id := "diag-contract-out-" ++ nt.1, code := "MISSING_OUTPUT", severity := .ERROR,
           field := "outputs." ++ nt.1, expected := nt.2, message := c.name,
           recoverable := false : Diagnostic }])

/-- §25's worked example: `n : Integer` in, `factorization : List Integer` out,
`FactorizationError` on failure. -/
def factorisationContract : Contract where
  name := "factorisation"
  inputSchema := [("n", "integer")]
  outputSchema := [("factorization", "list-integer")]
  errorSchema := ["FactorizationError"]

/-- An object built to the contract satisfies it. -/
theorem factorisation_conforms :
    checkContract factorisationContract
      { id := "p-144", kind := "computation",
        inputs := [{ id := "i1", name := "n", type := "integer", value := "144" }],
        outputs := [{ id := "o1", name := "factorization", type := "list-integer",
                      value := "2;2;2;2;3;3;" }],
        status := .VALID } = [] := by
  decide +kernel

/-- An object missing the promised output does not, and the diagnostic says
which output and of what type. -/
theorem factorisation_missing_output :
    (checkContract factorisationContract
      { id := "p-144", kind := "computation",
        inputs := [{ id := "i1", name := "n", type := "integer", value := "144" }],
        status := .ERROR }).map Diagnostic.code = ["MISSING_OUTPUT"] := by
  decide +kernel

end Solfunmeme.Codec
