/-!
# The canonical proof object

This is §3–§7 and §30–§31 of the standard proof codec specification: the one
semantic object every codec in this package decodes into and encodes out of.
Nothing here mentions IPDL, XML, CSV, YAML or text — that is the whole point of
§2, *never make one external format the canonical representation*.

* `Status` (§6) is the exchange status vocabulary.  `statusName` is injective
  and `statusOfName` inverts it, which is the formal content of "a system MUST
  NOT silently convert one status into another": a decoder cannot turn
  `INVALID` into `ERROR` and still claim to have read the same name.
* `Input` (§4), `Output` (§5), `Diagnostic` (§7, the specification's *Error*
  object), `Provenance` (§20) and `ProofObject` (§3).
* Every object carries an `extensions` list (§30): unknown data is *not*
  discardable, so anything a decoder cannot place goes there and travels on.
* `MinimalProfile` (§31) and `semanticCore` (§17, §28) — the latter is what the
  round-trip and reconciliation results actually compare.
-/

namespace Solfunmeme.Codec

/-! ## §6 Status vocabulary -/

/-- The standard proof status vocabulary. -/
inductive Status where
  | UNKNOWN | PENDING | VALID | INVALID | PARTIAL | ERROR | CONFLICT | UNSUPPORTED
  deriving DecidableEq, Repr, Inhabited

/-- The wire name of a status. -/
def Status.name : Status → String
  | .UNKNOWN => "UNKNOWN"
  | .PENDING => "PENDING"
  | .VALID => "VALID"
  | .INVALID => "INVALID"
  | .PARTIAL => "PARTIAL"
  | .ERROR => "ERROR"
  | .CONFLICT => "CONFLICT"
  | .UNSUPPORTED => "UNSUPPORTED"

/-- Read a status name.  An unknown name is *not* silently mapped to `UNKNOWN`;
it is rejected, and the caller records the failure as a diagnostic. -/
def Status.ofName : String → Option Status
  | "UNKNOWN" => some .UNKNOWN
  | "PENDING" => some .PENDING
  | "VALID" => some .VALID
  | "INVALID" => some .INVALID
  | "PARTIAL" => some .PARTIAL
  | "ERROR" => some .ERROR
  | "CONFLICT" => some .CONFLICT
  | "UNSUPPORTED" => some .UNSUPPORTED
  | _ => none

@[simp] theorem Status.ofName_name (s : Status) : Status.ofName s.name = some s := by
  cases s <;> rfl

/-- Status names are distinct, so the vocabulary cannot collapse in transit. -/
theorem Status.name_injective {s t : Status} (h : s.name = t.name) : s = t := by
  have := Status.ofName_name s
  rw [h, Status.ofName_name t] at this
  exact (Option.some.inj this).symm

/-- §6: `INVALID ≠ ERROR`, and no other pair of statuses is confusable either —
reading back the name of `s` never yields a different status `t`. -/
theorem Status.no_silent_conversion {s t : Status} (h : s ≠ t) :
    Status.ofName s.name ≠ some t := by
  rw [Status.ofName_name]
  intro hc
  exact h (Option.some.inj hc)

/-! ## §7 Severity -/

/-- Diagnostic severity. -/
inductive Severity where
  | INFO | WARNING | ERROR | FATAL
  deriving DecidableEq, Repr, Inhabited

def Severity.name : Severity → String
  | .INFO => "INFO"
  | .WARNING => "WARNING"
  | .ERROR => "ERROR"
  | .FATAL => "FATAL"

def Severity.ofName : String → Option Severity
  | "INFO" => some .INFO
  | "WARNING" => some .WARNING
  | "ERROR" => some .ERROR
  | "FATAL" => some .FATAL
  | _ => none

@[simp] theorem Severity.ofName_name (s : Severity) : Severity.ofName s.name = some s := by
  cases s <;> rfl

theorem Severity.name_injective {s t : Severity} (h : s.name = t.name) : s = t := by
  have := Severity.ofName_name s
  rw [h, Severity.ofName_name t] at this
  exact (Option.some.inj this).symm

/-! ## §9 Preservation level -/

/-- How much of the canonical object a conversion keeps. -/
inductive Lossiness where
  | LOSSLESS | LOSSY | PARTIAL | FAILED
  deriving DecidableEq, Repr, Inhabited

def Lossiness.name : Lossiness → String
  | .LOSSLESS => "LOSSLESS"
  | .LOSSY => "LOSSY"
  | .PARTIAL => "PARTIAL"
  | .FAILED => "FAILED"

def Lossiness.ofName : String → Option Lossiness
  | "LOSSLESS" => some .LOSSLESS
  | "LOSSY" => some .LOSSY
  | "PARTIAL" => some .PARTIAL
  | "FAILED" => some .FAILED
  | _ => none

@[simp] theorem Lossiness.ofName_name (l : Lossiness) : Lossiness.ofName l.name = some l := by
  cases l <;> rfl

/-- The preservation level of a chain of conversions is the worst of its links:
`lossless` is the identity and anything worse dominates. -/
def Lossiness.worse : Lossiness → Lossiness → Lossiness
  | .FAILED, _ => .FAILED
  | _, .FAILED => .FAILED
  | .LOSSY, _ => .LOSSY
  | _, .LOSSY => .LOSSY
  | .PARTIAL, _ => .PARTIAL
  | _, .PARTIAL => .PARTIAL
  | .LOSSLESS, .LOSSLESS => .LOSSLESS

@[simp] theorem Lossiness.worse_lossless_left (l : Lossiness) :
    Lossiness.worse .LOSSLESS l = l := by cases l <;> rfl

@[simp] theorem Lossiness.worse_lossless_right (l : Lossiness) :
    Lossiness.worse l .LOSSLESS = l := by cases l <;> rfl

theorem Lossiness.worse_comm (a b : Lossiness) :
    Lossiness.worse a b = Lossiness.worse b a := by cases a <;> cases b <;> rfl

theorem Lossiness.worse_assoc (a b c : Lossiness) :
    Lossiness.worse (Lossiness.worse a b) c = Lossiness.worse a (Lossiness.worse b c) := by
  cases a <;> cases b <;> cases c <;> rfl

/-- A chain is lossless exactly when every link is. -/
theorem Lossiness.worse_eq_lossless {a b : Lossiness} :
    Lossiness.worse a b = .LOSSLESS ↔ a = .LOSSLESS ∧ b = .LOSSLESS := by
  cases a <;> cases b <;> simp [Lossiness.worse]

/-! ## §4 Inputs -/

/-- An explicitly identified object consumed by a proof.  `value` keeps the
*original representation* as text (§4): the codec never reinterprets a number,
it records the characters that were there and the declared `type`. -/
structure Input where
  id : String := ""
  name : String := ""
  type : String := ""
  value : String := ""
  encoding : String := ""
  units : String := ""
  constraints : String := ""
  provenance : String := ""
  extensions : List (String × String) := []
  deriving DecidableEq, Repr, Inhabited

/-! ## §5 Outputs -/

/-- An object produced by a proof or computation. -/
structure Output where
  id : String := ""
  name : String := ""
  type : String := ""
  value : String := ""
  encoding : String := ""
  claims : List String := []
  certificate : String := ""
  provenance : String := ""
  extensions : List (String × String) := []
  deriving DecidableEq, Repr, Inhabited

/-! ## §7 Errors are first-class exchange objects -/

/-- The specification's `Error` object.  It is called `Diagnostic` here to keep
the name `Error` free, but the fields are exactly §7. -/
structure Diagnostic where
  id : String := ""
  code : String := ""
  severity : Severity := .ERROR
  message : String := ""
  location : String := ""
  field : String := ""
  objectId : String := ""
  sourceSystem : String := ""
  sourceFormat : String := ""
  expected : String := ""
  actual : String := ""
  cause : String := ""
  resolution : String := ""
  recoverable : Bool := false
  extensions : List (String × String) := []
  deriving DecidableEq, Repr, Inhabited

/-! ## §20 Provenance -/

/-- Where an object came from and what has been done to it. -/
structure Provenance where
  sourceSystem : String := ""
  sourceFile : String := ""
  sourceFormat : String := ""
  importedAt : String := ""
  transformedAt : String := ""
  parentObject : String := ""
  transformations : List String := []
  deriving DecidableEq, Repr, Inhabited

/-! ## §3 The canonical proof object -/

/-- Every proof with inputs and outputs is representable as one of these.  The
five fields of the minimum profile (§3) are `id`, `kind`, `inputs`, `outputs`
and `status`; everything else may be left at its default. -/
structure ProofObject where
  id : String := ""
  version : String := ""
  kind : String := ""
  inputs : List Input := []
  assumptions : List String := []
  parameters : List (String × String) := []
  procedure : String := ""
  intermediate : List String := []
  outputs : List Output := []
  claims : List String := []
  certificates : List String := []
  errors : List Diagnostic := []
  warnings : List String := []
  provenance : Provenance := {}
  metadata : List (String × String) := []
  sourceFormat : String := ""
  sourceData : String := ""
  status : Status := .UNKNOWN
  extensions : List (String × String) := []
  deriving DecidableEq, Repr, Inhabited

/-! ## §31 Minimal interchange profile -/

/-- The minimum a system must be able to say about an object: it has an
identity and a kind.  Inputs, outputs, status, errors and metadata are present
structurally in every `ProofObject`. -/
def ProofObject.minimalProfile (p : ProofObject) : Bool := p.id ≠ "" && p.kind ≠ ""

/-- §26 step 5: a decoder that had no identity to read assigns one, and the
result satisfies the minimal profile. -/
def ProofObject.withIdentity (p : ProofObject) (fallbackId fallbackKind : String) :
    ProofObject :=
  { p with
      id := if p.id = "" then fallbackId else p.id
      kind := if p.kind = "" then fallbackKind else p.kind }

theorem ProofObject.minimalProfile_withIdentity (p : ProofObject) {i k : String}
    (hi : i ≠ "") (hk : k ≠ "") : (p.withIdentity i k).minimalProfile = true := by
  simp [ProofObject.minimalProfile, ProofObject.withIdentity]
  constructor
  · by_cases h : p.id = "" <;> simp [h, hi]
  · by_cases h : p.kind = "" <;> simp [h, hk]

/-- Supplying an identity never overwrites one that is already there. -/
theorem ProofObject.withIdentity_id_of_ne (p : ProofObject) (i k : String) (h : p.id ≠ "") :
    (p.withIdentity i k).id = p.id := by simp [ProofObject.withIdentity, h]

/-! ## §30 Unknown data -/

/-- Look up an extension.  Extensions are namespaced by vendor, as in
`vendor.system_x`. -/
def ProofObject.extension (p : ProofObject) (key : String) : Option String :=
  (p.extensions.find? (fun kv => kv.1 == key)).map Prod.snd

/-- Recording an unknown field keeps it retrievable: unknown is not
discardable. -/
def ProofObject.withExtension (p : ProofObject) (key value : String) : ProofObject :=
  { p with extensions := p.extensions ++ [(key, value)] }

theorem ProofObject.extension_withExtension (p : ProofObject) (key value : String)
    (h : p.extension key = none) : (p.withExtension key value).extension key = some value := by
  simp [ProofObject.extension, ProofObject.withExtension, List.find?_append]
  cases hf : p.extensions.find? (fun kv => kv.1 == key) with
  | none => simp
  | some kv => simp [ProofObject.extension, hf] at h

/-! ## §17, §28 Semantic identity -/

/-- What a conversion must preserve: identity, kind, the inputs, the outputs,
the claims, the status and the diagnostic codes.  Provenance, metadata and the
retained source text describe the *journey*, not the proof, so two objects that
differ only there are the same proof. -/
def ProofObject.semanticCore (p : ProofObject) :
    String × String × List Input × List Output × List String × Status × List String :=
  (p.id, p.kind, p.inputs, p.outputs, p.claims, p.status, p.errors.map Diagnostic.code)

/-- Semantic equivalence of two canonical objects. -/
abbrev SemanticEq (p q : ProofObject) : Prop := p.semanticCore = q.semanticCore

@[refl] theorem SemanticEq.refl (p : ProofObject) : SemanticEq p p := rfl

theorem SemanticEq.symm {p q : ProofObject} (h : SemanticEq p q) : SemanticEq q p := Eq.symm h

theorem SemanticEq.trans {p q r : ProofObject} (h : SemanticEq p q) (h' : SemanticEq q r) :
    SemanticEq p r := Eq.trans h h'

/-- Equal objects are semantically equal; the converse fails exactly on the
journey fields, which is what makes `SemanticEq` the right test for §17. -/
theorem SemanticEq.of_eq {p q : ProofObject} (h : p = q) : SemanticEq p q := by rw [h]

end Solfunmeme.Codec
