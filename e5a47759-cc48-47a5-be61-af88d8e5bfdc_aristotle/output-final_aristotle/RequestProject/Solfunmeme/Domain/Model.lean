import RequestProject.Solfunmeme.Codec.Hash

/-!
# The canonical domain model

The proof codec (`RequestProject/Codec/`) answers the question *how does one
proof travel between systems*.  This package answers the larger one: *given a
domain, what are its data objects, what proofs establish them, and how is all
of that emitted so that every representation still points at the proof*.

The canonical unit is not a document but a graph:

```text
Domain
├── objects[]     the domain data
├── claims[]      what is asserted about it
├── proofs[]      what establishes the claims
├── relations[]   the typed edges between them
├── errors[]      diagnostics, attached rather than thrown away
└── provenance    where the whole package came from
```

This file fixes the vocabularies and the records.  Three of the vocabularies
are the heart of the contract and each gets the same treatment as the codec's
`Status`: a wire name, a reader, and a proof that the reader inverts the
writer, so that no representation can silently turn one status into another.

* `TruthStatus` — the provenance of a *value*.  `PROVEN` and `ASSERTED` are
  different data, and the codec must keep them different.
* `ProofStatus` — what a proof reports about itself.
* `Validation` — *a proof exists*, *a proof has been machine-checked* and *a
  proof has been independently reproduced* are three states, not one.

`Coverage` is derived, never stored: it is computed from the object's truth
status and the status of the proofs it references, so it cannot drift away
from them.
-/

namespace Solfunmeme.Domain

open Solfunmeme.Codec

/-! ## Truth / provenance status -/

/-- The provenance of truth of a domain value.  The distinction between
`PROVEN` and `ASSERTED` is the one the whole package exists to preserve. -/
inductive TruthStatus where
  | PROVEN | DERIVED | VERIFIED | ASSERTED | IMPORTED | INFERRED
  | UNRESOLVED | CONTRADICTED | INVALID
  deriving DecidableEq, Repr, Inhabited

def TruthStatus.name : TruthStatus → String
  | .PROVEN => "PROVEN"
  | .DERIVED => "DERIVED"
  | .VERIFIED => "VERIFIED"
  | .ASSERTED => "ASSERTED"
  | .IMPORTED => "IMPORTED"
  | .INFERRED => "INFERRED"
  | .UNRESOLVED => "UNRESOLVED"
  | .CONTRADICTED => "CONTRADICTED"
  | .INVALID => "INVALID"

def TruthStatus.ofName : String → Option TruthStatus
  | "PROVEN" => some .PROVEN
  | "DERIVED" => some .DERIVED
  | "VERIFIED" => some .VERIFIED
  | "ASSERTED" => some .ASSERTED
  | "IMPORTED" => some .IMPORTED
  | "INFERRED" => some .INFERRED
  | "UNRESOLVED" => some .UNRESOLVED
  | "CONTRADICTED" => some .CONTRADICTED
  | "INVALID" => some .INVALID
  | _ => none

@[simp] theorem TruthStatus.ofName_name (t : TruthStatus) :
    TruthStatus.ofName t.name = some t := by cases t <;> rfl

theorem TruthStatus.name_injective {s t : TruthStatus} (h : s.name = t.name) : s = t := by
  have := TruthStatus.ofName_name s
  rw [h, TruthStatus.ofName_name t] at this
  exact (Option.some.inj this).symm

/-- No representation may quietly read `ASSERTED` as `PROVEN`. -/
theorem TruthStatus.no_silent_conversion {s t : TruthStatus} (h : s ≠ t) :
    TruthStatus.ofName s.name ≠ some t := by
  rw [TruthStatus.ofName_name]
  intro hc
  exact h (Option.some.inj hc)

/-- A truth status that asserts the value is established by a proof.  `PROVEN`
is the only one of the nine that does. -/
def TruthStatus.claimsProof : TruthStatus → Bool
  | .PROVEN => true
  | _ => false

/-- A truth status that reports the value is wrong. -/
def TruthStatus.isNegative : TruthStatus → Bool
  | .CONTRADICTED => true
  | .INVALID => true
  | _ => false

/-! ## Proof status -/

/-- What a proof reports about itself. -/
inductive ProofStatus where
  | VALID | INVALID | PARTIAL | FAILED | UNKNOWN | CONFLICT
  deriving DecidableEq, Repr, Inhabited

def ProofStatus.name : ProofStatus → String
  | .VALID => "VALID"
  | .INVALID => "INVALID"
  | .PARTIAL => "PARTIAL"
  | .FAILED => "FAILED"
  | .UNKNOWN => "UNKNOWN"
  | .CONFLICT => "CONFLICT"

def ProofStatus.ofName : String → Option ProofStatus
  | "VALID" => some .VALID
  | "INVALID" => some .INVALID
  | "PARTIAL" => some .PARTIAL
  | "FAILED" => some .FAILED
  | "UNKNOWN" => some .UNKNOWN
  | "CONFLICT" => some .CONFLICT
  | _ => none

@[simp] theorem ProofStatus.ofName_name (s : ProofStatus) :
    ProofStatus.ofName s.name = some s := by cases s <;> rfl

theorem ProofStatus.name_injective {s t : ProofStatus} (h : s.name = t.name) : s = t := by
  have := ProofStatus.ofName_name s
  rw [h, ProofStatus.ofName_name t] at this
  exact (Option.some.inj this).symm

/-! ## How strong the certificate is -/

/-- *A proof exists*, *a proof has been machine-validated* and *a proof has been
independently reproduced* are separate states. -/
inductive Validation where
  | NONE | EXISTS | MACHINE_CHECKED | REPRODUCED
  deriving DecidableEq, Repr, Inhabited

def Validation.name : Validation → String
  | .NONE => "NONE"
  | .EXISTS => "EXISTS"
  | .MACHINE_CHECKED => "MACHINE_CHECKED"
  | .REPRODUCED => "REPRODUCED"

def Validation.ofName : String → Option Validation
  | "NONE" => some .NONE
  | "EXISTS" => some .EXISTS
  | "MACHINE_CHECKED" => some .MACHINE_CHECKED
  | "REPRODUCED" => some .REPRODUCED
  | _ => none

@[simp] theorem Validation.ofName_name (v : Validation) :
    Validation.ofName v.name = some v := by cases v <;> rfl

theorem Validation.name_injective {u v : Validation} (h : u.name = v.name) : u = v := by
  have := Validation.ofName_name u
  rw [h, Validation.ofName_name v] at this
  exact (Option.some.inj this).symm

/-- Existence of a proof is weaker than machine validation, which is weaker
than independent reproduction. -/
def Validation.rank : Validation → Nat
  | .NONE => 0
  | .EXISTS => 1
  | .MACHINE_CHECKED => 2
  | .REPRODUCED => 3

theorem Validation.rank_injective {u v : Validation} (h : u.rank = v.rank) : u = v := by
  cases u <;> cases v <;> simp_all [Validation.rank]

/-- The three states are genuinely ordered, so "a proof exists" can never be
reported as "a proof has been reproduced". -/
theorem Validation.exists_lt_checked_lt_reproduced :
    Validation.rank .EXISTS < Validation.rank .MACHINE_CHECKED ∧
      Validation.rank .MACHINE_CHECKED < Validation.rank .REPRODUCED := by decide

/-! ## Relation kinds -/

/-- The typed edges of the proof-to-data graph. -/
inductive RelationKind where
  | INPUT_TO | OUTPUT_OF | PROVES | PROVEN_BY | DERIVES | VERIFIES | CONSTRAINS
  | DEPENDS_ON | REFERENCES | CONTRADICTS | REPRODUCES | ENCODES | DECODES
  deriving DecidableEq, Repr, Inhabited

def RelationKind.name : RelationKind → String
  | .INPUT_TO => "INPUT_TO"
  | .OUTPUT_OF => "OUTPUT_OF"
  | .PROVES => "PROVES"
  | .PROVEN_BY => "PROVEN_BY"
  | .DERIVES => "DERIVES"
  | .VERIFIES => "VERIFIES"
  | .CONSTRAINS => "CONSTRAINS"
  | .DEPENDS_ON => "DEPENDS_ON"
  | .REFERENCES => "REFERENCES"
  | .CONTRADICTS => "CONTRADICTS"
  | .REPRODUCES => "REPRODUCES"
  | .ENCODES => "ENCODES"
  | .DECODES => "DECODES"

def RelationKind.ofName : String → Option RelationKind
  | "INPUT_TO" => some .INPUT_TO
  | "OUTPUT_OF" => some .OUTPUT_OF
  | "PROVES" => some .PROVES
  | "PROVEN_BY" => some .PROVEN_BY
  | "DERIVES" => some .DERIVES
  | "VERIFIES" => some .VERIFIES
  | "CONSTRAINS" => some .CONSTRAINS
  | "DEPENDS_ON" => some .DEPENDS_ON
  | "REFERENCES" => some .REFERENCES
  | "CONTRADICTS" => some .CONTRADICTS
  | "REPRODUCES" => some .REPRODUCES
  | "ENCODES" => some .ENCODES
  | "DECODES" => some .DECODES
  | _ => none

@[simp] theorem RelationKind.ofName_name (k : RelationKind) :
    RelationKind.ofName k.name = some k := by cases k <;> rfl

theorem RelationKind.name_injective {j k : RelationKind} (h : j.name = k.name) : j = k := by
  have := RelationKind.ofName_name j
  rw [h, RelationKind.ofName_name k] at this
  exact (Option.some.inj this).symm

/-- The opposite edge, where there is one, so that the graph can be walked in
either direction.  `VERIFIES` and `CONSTRAINS` have no converse: an
independent check of an object is not a relation the object has to its checker,
and saying otherwise would invent an edge. -/
def RelationKind.converse : RelationKind → Option RelationKind
  | .INPUT_TO => some .DEPENDS_ON
  | .DEPENDS_ON => some .INPUT_TO
  | .OUTPUT_OF => some .DERIVES
  | .DERIVES => some .OUTPUT_OF
  | .PROVES => some .PROVEN_BY
  | .PROVEN_BY => some .PROVES
  | .ENCODES => some .DECODES
  | .DECODES => some .ENCODES
  | .REFERENCES => some .REFERENCES
  | .CONTRADICTS => some .CONTRADICTS
  | .REPRODUCES => some .REPRODUCES
  | .VERIFIES => none
  | .CONSTRAINS => none

/-- Where a converse exists it is an involution, which is what makes the graph
walkable in both directions rather than merely twice. -/
theorem RelationKind.converse_involutive {j k : RelationKind} (h : j.converse = some k) :
    k.converse = some j := by
  revert h; cases j <;> cases k <;> decide

/-- `PROVES` and `PROVEN_BY` are exact opposites, and so are `ENCODES` and
`DECODES`: the data → proof and proof → data directions are inverse. -/
theorem RelationKind.converse_on_proof :
    (RelationKind.PROVES.converse = some .PROVEN_BY ∧
        RelationKind.PROVEN_BY.converse = some .PROVES) ∧
      (RelationKind.ENCODES.converse = some .DECODES ∧
        RelationKind.DECODES.converse = some .ENCODES) := by
  decide

/-! ## The records -/

/-- A domain object: one piece of the domain's data, with everything needed to
say where it came from and what establishes it. -/
structure DomainObject where
  id : String := ""
  kind : String := ""
  name : String := ""
  claim : String := ""
  value : String := ""
  valueType : String := "string"
  inputRefs : List String := []
  parameters : List (String × String) := []
  transformations : List String := []
  outputRefs : List String := []
  claimRefs : List String := []
  evidence : List String := []
  proofRefs : List String := []
  errorRefs : List String := []
  truth : TruthStatus := .UNRESOLVED
  sourceRefs : List String := []
  provenance : Provenance := {}
  extensions : List (String × String) := []
  deriving DecidableEq, Repr, Inhabited

/-- A claim: what is asserted about an object.  Keeping claims separate from
objects is what lets one object carry several independently proved claims. -/
structure DomainClaim where
  id : String := ""
  text : String := ""
  objectRef : String := ""
  proofRefs : List String := []
  truth : TruthStatus := .UNRESOLVED
  extensions : List (String × String) := []
  deriving DecidableEq, Repr, Inhabited

/-- A proof, as a catalog entry.  It says what it consumes, what it produces,
what it establishes, what it depends on, where it lives and how strongly it
has been checked. -/
structure ProofRecord where
  id : String := ""
  name : String := ""
  kind : String := ""
  sourceFile : String := ""
  sourceLocation : String := ""
  inputRefs : List String := []
  assumptions : List String := []
  procedure : String := ""
  outputRefs : List String := []
  claimRefs : List String := []
  dependencies : List String := []
  status : ProofStatus := .UNKNOWN
  certificateKind : String := ""
  certificateDigest : String := ""
  certificateLocation : String := ""
  validation : Validation := .NONE
  provenance : Provenance := {}
  extensions : List (String × String) := []
  deriving DecidableEq, Repr, Inhabited

/-- One typed edge of the graph. -/
structure Relation where
  sourceId : String := ""
  kind : RelationKind := .REFERENCES
  targetId : String := ""
  note : String := ""
  deriving DecidableEq, Repr, Inhabited

/-- The whole domain: the canonical object every emitted representation is a
projection of. -/
structure Domain where
  id : String := ""
  name : String := ""
  version : String := ""
  description : String := ""
  objects : List DomainObject := []
  claims : List DomainClaim := []
  proofs : List ProofRecord := []
  relations : List Relation := []
  errors : List Diagnostic := []
  provenance : Provenance := {}
  extensions : List (String × String) := []
  deriving DecidableEq, Repr, Inhabited

/-! ## Lookup -/

def Domain.findObject (d : Domain) (id : String) : Option DomainObject :=
  d.objects.find? (fun o => o.id == id)

def Domain.findClaim (d : Domain) (id : String) : Option DomainClaim :=
  d.claims.find? (fun c => c.id == id)

def Domain.findProof (d : Domain) (id : String) : Option ProofRecord :=
  d.proofs.find? (fun p => p.id == id)

theorem Domain.findObject_mem {d : Domain} {id : String} {o : DomainObject}
    (h : d.findObject id = some o) : o ∈ d.objects := List.mem_of_find?_eq_some h

theorem Domain.findProof_mem {d : Domain} {id : String} {p : ProofRecord}
    (h : d.findProof id = some p) : p ∈ d.proofs := List.mem_of_find?_eq_some h

theorem Domain.findObject_id {d : Domain} {id : String} {o : DomainObject}
    (h : d.findObject id = some o) : o.id = id := by
  have := List.find?_some h
  simpa using this

theorem Domain.findProof_id {d : Domain} {id : String} {p : ProofRecord}
    (h : d.findProof id = some p) : p.id = id := by
  have := List.find?_some h
  simpa using this

/-! ## Coverage, derived and never stored -/

/-- How well an object is proved. -/
inductive Coverage where
  | PROVEN | PARTIALLY_PROVEN | UNPROVEN | CONTRADICTED
  deriving DecidableEq, Repr, Inhabited

def Coverage.name : Coverage → String
  | .PROVEN => "PROVEN"
  | .PARTIALLY_PROVEN => "PARTIALLY_PROVEN"
  | .UNPROVEN => "UNPROVEN"
  | .CONTRADICTED => "CONTRADICTED"

def Coverage.ofName : String → Option Coverage
  | "PROVEN" => some .PROVEN
  | "PARTIALLY_PROVEN" => some .PARTIALLY_PROVEN
  | "UNPROVEN" => some .UNPROVEN
  | "CONTRADICTED" => some .CONTRADICTED
  | _ => none

@[simp] theorem Coverage.ofName_name (c : Coverage) : Coverage.ofName c.name = some c := by
  cases c <;> rfl

/-- The proofs an object actually resolves to. -/
def Domain.proofsOf (d : Domain) (o : DomainObject) : List ProofRecord :=
  o.proofRefs.filterMap d.findProof

/-- The objects a proof establishes, read from the objects' own references. -/
def Domain.objectsProvedBy (d : Domain) (p : ProofRecord) : List DomainObject :=
  d.objects.filter (fun o => o.proofRefs.contains p.id)

/-- An object is covered when it has at least one `VALID` proof, partially
covered when it has a `PARTIAL` one, contradicted when it or one of its proofs
says so, and unproven otherwise.  Nothing here reads a stored coverage field:
there is none. -/
def Domain.coverage (d : Domain) (o : DomainObject) : Coverage :=
  let ps := d.proofsOf o
  if o.truth.isNegative || ps.any (fun p => p.status == .INVALID || p.status == .CONFLICT) then
    .CONTRADICTED
  else if ps.any (fun p => p.status == .VALID) then
    .PROVEN
  else if ps.any (fun p => p.status == .PARTIAL) then
    .PARTIALLY_PROVEN
  else
    .UNPROVEN

/-- Coverage is reproducible: a function of the domain and the object, with no
hidden state. -/
theorem Domain.coverage_congr {d e : Domain} {o q : DomainObject} (hd : d = e) (ho : o = q) :
    d.coverage o = e.coverage q := by rw [hd, ho]

/-- An object with no resolvable proof is never reported as proven. -/
theorem Domain.coverage_of_no_proofs {d : Domain} {o : DomainObject}
    (h : d.proofsOf o = []) : d.coverage o = .UNPROVEN ∨ d.coverage o = .CONTRADICTED := by
  unfold Domain.coverage
  simp only [h]
  by_cases hneg : o.truth.isNegative = true <;> simp [hneg]

/-- A proven object really does have a valid proof in the package. -/
theorem Domain.exists_valid_proof_of_coverage {d : Domain} {o : DomainObject}
    (h : d.coverage o = .PROVEN) : ∃ p ∈ d.proofsOf o, p.status = .VALID := by
  unfold Domain.coverage at h
  by_cases hc : (o.truth.isNegative ||
      (d.proofsOf o).any (fun p => p.status == .INVALID || p.status == .CONFLICT)) = true
  · simp [hc] at h
  · simp only [hc, Bool.false_eq_true, if_false] at h
    by_cases hv : (d.proofsOf o).any (fun p => p.status == .VALID) = true
    · obtain ⟨p, hp, hps⟩ := List.any_eq_true.mp hv
      exact ⟨p, hp, by simpa using hps⟩
    · simp only [hv, Bool.false_eq_true, if_false] at h
      split at h <;> simp at h

end Solfunmeme.Domain
