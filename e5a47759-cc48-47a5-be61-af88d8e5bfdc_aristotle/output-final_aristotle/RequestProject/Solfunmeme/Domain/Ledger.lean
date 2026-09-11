import RequestProject.Solfunmeme.Domain.Hash

/-!
# Validation, the proof graph, the ledger and coverage

This is the part of the package that makes *"the forms are proven"* a testable
property rather than a sentence in a README.

* `validate` walks the graph and returns diagnostics: an unresolved proof
  reference, a dangling relation, and — the important one — an object that
  calls itself `PROVEN` without a `VALID` proof to point at.  Every check is
  stated twice: once as *the failure is reported* (a membership theorem, so the
  check cannot be vacuous) and once as *a clean package therefore has the
  property* (`proven_has_valid_proof`).
* `graph` closes the object/claim/proof references into typed edges and adds
  every converse, so the four legs

  ```text
  DATA → PROOF   PROOF → INPUTS   PROOF → OUTPUTS   OUTPUT → DATA
  ```

  are all traversable; `graph_closed_under_converse` is the general statement.
* `ledgerRows` is the proof ledger: object, claim, proof, status, coverage and
  canonical hash — one authoritative index from a data value to its evidence.
  It is a *lossy* projection and says so: `ledgerRows_not_injective` proves the
  declaration honest.
* `coverageReport` counts the classification, and `coverageReport_total` proves
  the four classes partition the objects, so the summary cannot double count.
-/

namespace Solfunmeme.Domain

open Solfunmeme.Codec

/-! ## Validation -/

/-- The identifiers a relation may point at: the objects, claims and proofs of
the package, together with the external inputs and sources they declare.  An
external input — a source file a proof consumes, say — is a legitimate endpoint
of an edge without being an object of the package, but it must have been
declared by something in the package first. -/
def Domain.knownIds (d : Domain) : List String :=
  d.objects.map DomainObject.id ++ d.claims.map DomainClaim.id ++ d.proofs.map ProofRecord.id
    ++ d.proofs.flatMap ProofRecord.inputRefs ++ d.proofs.flatMap ProofRecord.outputRefs
    ++ d.objects.flatMap DomainObject.sourceRefs ++ d.objects.flatMap DomainObject.inputRefs
    ++ d.objects.flatMap DomainObject.outputRefs

/-- An object claims a proof it can point at. -/
def Domain.justifiedProven (d : Domain) (o : DomainObject) : Bool :=
  (d.proofsOf o).any (fun p => p.status == .VALID)

/-- A validation diagnostic. -/
def diagnostic (code sev objectId message : String) : Diagnostic :=
  { id := code ++ ":" ++ objectId
    code := code
    severity := if sev = "FATAL" then .FATAL else .ERROR
    message := message
    objectId := objectId
    sourceSystem := "solfunmeme-domain" }

/-- Diagnostics for one object. -/
def Domain.objectDiagnostics (d : Domain) (o : DomainObject) : List Diagnostic :=
  (o.proofRefs.filter (fun r => (d.findProof r).isNone)).map
      (fun r => diagnostic "UNRESOLVED_PROOF_REF" "ERROR" o.id ("no proof " ++ r))
    ++ (o.claimRefs.filter (fun r => (d.findClaim r).isNone)).map
        (fun r => diagnostic "UNRESOLVED_CLAIM_REF" "ERROR" o.id ("no claim " ++ r))
    ++ (if o.truth = .PROVEN ∧ d.justifiedProven o = false then
          [diagnostic "UNJUSTIFIED_PROVEN" "FATAL" o.id "PROVEN without a VALID proof"] else [])
    ++ (if o.truth = .PROVEN ∧
          (d.proofsOf o).any (fun p => p.status == .INVALID || p.status == .CONFLICT) = true then
          [diagnostic "CONTRADICTION" "FATAL" o.id "PROVEN with an INVALID or CONFLICT proof"]
        else [])

/-- Diagnostics for one claim. -/
def Domain.claimDiagnostics (d : Domain) (c : DomainClaim) : List Diagnostic :=
  (if c.objectRef ≠ "" ∧ (d.findObject c.objectRef).isNone = true then
      [diagnostic "UNRESOLVED_OBJECT_REF" "ERROR" c.id ("no object " ++ c.objectRef)] else [])
    ++ (c.proofRefs.filter (fun r => (d.findProof r).isNone)).map
        (fun r => diagnostic "UNRESOLVED_PROOF_REF" "ERROR" c.id ("no proof " ++ r))

/-- Diagnostics for one proof record. -/
def Domain.proofDiagnostics (d : Domain) (p : ProofRecord) : List Diagnostic :=
  (p.claimRefs.filter (fun r => (d.findClaim r).isNone)).map
      (fun r => diagnostic "UNRESOLVED_CLAIM_REF" "ERROR" p.id ("no claim " ++ r))
    ++ (p.dependencies.filter (fun r => (d.findProof r).isNone)).map
        (fun r => diagnostic "UNRESOLVED_DEPENDENCY" "ERROR" p.id ("no proof " ++ r))
    ++ (if p.status = .VALID ∧ p.validation = .NONE then
          [diagnostic "UNCERTIFIED_VALID" "ERROR" p.id "VALID with no validation state"] else [])

/-- Diagnostics for one relation. -/
def Domain.relationDiagnostics (d : Domain) (r : Relation) : List Diagnostic :=
  (if d.knownIds.contains r.sourceId then [] else
      [diagnostic "DANGLING_RELATION" "ERROR" r.sourceId ("unknown source " ++ r.sourceId)])
    ++ (if d.knownIds.contains r.targetId then [] else
        [diagnostic "DANGLING_RELATION" "ERROR" r.targetId ("unknown target " ++ r.targetId)])

/-- The whole validation pass.  Errors are attached to the package, never
thrown away. -/
def Domain.validate (d : Domain) : List Diagnostic :=
  d.objects.flatMap d.objectDiagnostics
    ++ d.claims.flatMap d.claimDiagnostics
    ++ d.proofs.flatMap d.proofDiagnostics
    ++ d.relations.flatMap d.relationDiagnostics

/-- A package whose validation is empty. -/
def Domain.WellFormed (d : Domain) : Prop := d.validate = []

instance (d : Domain) : Decidable d.WellFormed := by
  unfold Domain.WellFormed; infer_instance

theorem Domain.mem_validate_of_object {d : Domain} {o : DomainObject} {e : Diagnostic}
    (ho : o ∈ d.objects) (he : e ∈ d.objectDiagnostics o) : e ∈ d.validate := by
  unfold Domain.validate
  exact List.mem_append_left _ (List.mem_append_left _ (List.mem_append_left _
    (List.mem_flatMap.mpr ⟨o, ho, he⟩)))

theorem Domain.mem_validate_of_proof {d : Domain} {p : ProofRecord} {e : Diagnostic}
    (hp : p ∈ d.proofs) (he : e ∈ d.proofDiagnostics p) : e ∈ d.validate := by
  unfold Domain.validate
  exact List.mem_append_left _ (List.mem_append_right _ (List.mem_flatMap.mpr ⟨p, hp, he⟩))

/-- The unjustified `PROVEN` check is not vacuous: when it fails, it is
reported. -/
theorem Domain.unjustified_is_reported {d : Domain} {o : DomainObject} (ho : o ∈ d.objects)
    (hp : o.truth = .PROVEN) (hj : d.justifiedProven o = false) :
    diagnostic "UNJUSTIFIED_PROVEN" "FATAL" o.id "PROVEN without a VALID proof" ∈ d.validate := by
  refine Domain.mem_validate_of_object ho ?_
  unfold Domain.objectDiagnostics
  refine List.mem_append_left _ (List.mem_append_right _ ?_)
  simp [hp, hj]

/-- So is the contradiction check. -/
theorem Domain.contradiction_is_reported {d : Domain} {o : DomainObject} (ho : o ∈ d.objects)
    (hp : o.truth = .PROVEN)
    (hc : (d.proofsOf o).any (fun p => p.status == .INVALID || p.status == .CONFLICT) = true) :
    diagnostic "CONTRADICTION" "FATAL" o.id "PROVEN with an INVALID or CONFLICT proof"
      ∈ d.validate := by
  refine Domain.mem_validate_of_object ho ?_
  unfold Domain.objectDiagnostics
  refine List.mem_append_right _ ?_
  simp [hp, hc]

/-- And so is the dangling proof reference check. -/
theorem Domain.unresolved_proofRef_is_reported {d : Domain} {o : DomainObject}
    (ho : o ∈ d.objects) {r : String} (hr : r ∈ o.proofRefs) (hn : d.findProof r = none) :
    diagnostic "UNRESOLVED_PROOF_REF" "ERROR" o.id ("no proof " ++ r) ∈ d.validate := by
  refine Domain.mem_validate_of_object ho ?_
  unfold Domain.objectDiagnostics
  refine List.mem_append_left _ (List.mem_append_left _ (List.mem_append_left _ ?_))
  exact List.mem_map.mpr ⟨r, List.mem_filter.mpr ⟨hr, by simp [hn]⟩, rfl⟩

/-- A `VALID` proof with no validation state is reported: *a proof exists* is
never silently read as *a proof has been checked*. -/
theorem Domain.uncertified_valid_is_reported {d : Domain} {p : ProofRecord} (hp : p ∈ d.proofs)
    (hs : p.status = .VALID) (hv : p.validation = .NONE) :
    diagnostic "UNCERTIFIED_VALID" "ERROR" p.id "VALID with no validation state"
      ∈ d.validate := by
  refine Domain.mem_validate_of_proof hp ?_
  unfold Domain.proofDiagnostics
  refine List.mem_append_right _ ?_
  simp [hs, hv]

/-! ### What a clean validation therefore guarantees -/

/-- **No silent claims.**  In a well-formed package an object that says
`PROVEN` really does point at a proof the package contains, and that proof
reports `VALID`. -/
theorem Domain.proven_has_valid_proof {d : Domain} (h : d.WellFormed) {o : DomainObject}
    (ho : o ∈ d.objects) (hp : o.truth = .PROVEN) : ∃ p ∈ d.proofsOf o, p.status = .VALID := by
  have hv : d.validate = [] := h
  by_cases hj : d.justifiedProven o = true
  · obtain ⟨p, hpm, hps⟩ := List.any_eq_true.mp hj
    exact ⟨p, hpm, by simpa using hps⟩
  · have hmem := Domain.unjustified_is_reported ho hp (by simpa using hj)
    rw [hv] at hmem
    exact absurd hmem List.not_mem_nil

/-- In a well-formed package no proven object is contradicted by one of its own
proofs. -/
theorem Domain.no_contradicted_proven {d : Domain} (h : d.WellFormed) {o : DomainObject}
    (ho : o ∈ d.objects) (hp : o.truth = .PROVEN) :
    (d.proofsOf o).any (fun p => p.status == .INVALID || p.status == .CONFLICT) = false := by
  have hv : d.validate = [] := h
  cases hc : (d.proofsOf o).any (fun p => p.status == .INVALID || p.status == .CONFLICT) with
  | false => rfl
  | true =>
    have hmem := Domain.contradiction_is_reported ho hp hc
    rw [hv] at hmem
    exact absurd hmem List.not_mem_nil

/-- Every proof reference of a well-formed package resolves. -/
theorem Domain.proofRefs_resolve {d : Domain} (h : d.WellFormed) {o : DomainObject}
    (ho : o ∈ d.objects) {r : String} (hr : r ∈ o.proofRefs) : (d.findProof r).isSome := by
  have hv : d.validate = [] := h
  cases hf : d.findProof r with
  | some p => rfl
  | none =>
    have hmem := Domain.unresolved_proofRef_is_reported ho hr hf
    rw [hv] at hmem
    exact absurd hmem List.not_mem_nil

/-- The coverage computation agrees with the recorded status: a well-formed
package that says `PROVEN` is classified `PROVEN`. -/
theorem Domain.coverage_of_proven {d : Domain} (h : d.WellFormed) {o : DomainObject}
    (ho : o ∈ d.objects) (hp : o.truth = .PROVEN) : d.coverage o = .PROVEN := by
  obtain ⟨p, hpm, hps⟩ := d.proven_has_valid_proof h ho hp
  have hneg := d.no_contradicted_proven h ho hp
  have hnotneg : o.truth.isNegative = false := by rw [hp]; rfl
  have hvalid : (d.proofsOf o).any (fun q => q.status == .VALID) = true :=
    List.any_eq_true.mpr ⟨p, hpm, by simp [hps]⟩
  unfold Domain.coverage
  simp [hnotneg, hneg, hvalid]

/-! ## Promotion: a status may only be raised by an event -/

/-- Raise an object's truth status.  A promotion to `PROVEN` is refused unless
the package can point at a `VALID` proof. -/
def Domain.promote (d : Domain) (o : DomainObject) (t : TruthStatus) : DomainObject :=
  if t = .PROVEN ∧ d.justifiedProven o = false then o else { o with truth := t }

/-- **`ASSERTED → PROVEN` cannot happen without a proof.** -/
theorem Domain.promote_not_proven {d : Domain} {o : DomainObject}
    (h : d.justifiedProven o = false) (hne : o.truth ≠ .PROVEN) :
    (d.promote o .PROVEN).truth ≠ .PROVEN := by
  simp [Domain.promote, h, hne]

/-- And a promotion that *is* justified goes through. -/
theorem Domain.promote_proven {d : Domain} {o : DomainObject}
    (h : d.justifiedProven o = true) : (d.promote o .PROVEN).truth = .PROVEN := by
  simp [Domain.promote, h]

/-- Any other status may be recorded freely: only `PROVEN` is guarded. -/
theorem Domain.promote_other {d : Domain} {o : DomainObject} {t : TruthStatus}
    (h : t ≠ .PROVEN) : (d.promote o t).truth = t := by simp [Domain.promote, h]

/-! ## The graph -/

/-- Turn an edge round. -/
def Relation.reverse (r : Relation) (k : RelationKind) : Relation :=
  { sourceId := r.targetId, kind := k, targetId := r.sourceId, note := r.note }

/-- Add every converse edge that exists. -/
def withConverses (rs : List Relation) : List Relation :=
  rs.flatMap (fun r =>
    match r.kind.converse with
    | some k => [r, r.reverse k]
    | none => [r])

theorem mem_withConverses {rs : List Relation} {r : Relation} (h : r ∈ rs) :
    r ∈ withConverses rs := by
  refine List.mem_flatMap.mpr ⟨r, h, ?_⟩
  cases r.kind.converse <;> simp

/-- **The graph is walkable in both directions.**  Whenever an edge is present
and its kind has a converse, the reversed edge is present too. -/
theorem withConverses_closed {rs : List Relation} {r : Relation} {k : RelationKind}
    (hr : r ∈ withConverses rs) (hk : r.kind.converse = some k) :
    r.reverse k ∈ withConverses rs := by
  rw [withConverses, List.mem_flatMap] at hr
  obtain ⟨r₀, hr₀, hmem⟩ := hr
  refine List.mem_flatMap.mpr ⟨r₀, hr₀, ?_⟩
  cases hc : r₀.kind.converse with
  | none =>
    rw [hc] at hmem
    simp only [List.mem_singleton] at hmem
    subst hmem
    rw [hc] at hk
    exact absurd hk (by simp)
  | some k₀ =>
    rw [hc] at hmem
    simp only [List.mem_cons, List.not_mem_nil, or_false] at hmem
    rcases hmem with rfl | rfl
    · have hkk : k = k₀ := by rw [hc] at hk; exact (Option.some.inj hk).symm
      subst hkk
      simp
    · have hk' : k₀.converse = some k := hk
      have hinv : k₀.converse = some r₀.kind := RelationKind.converse_involutive hc
      have hk0 : k = r₀.kind := by rw [hinv] at hk'; exact (Option.some.inj hk').symm
      subst hk0
      have hrr : (r₀.reverse k₀).reverse r₀.kind = r₀ := rfl
      rw [hrr]
      simp

/-- The edges implied by the objects', claims' and proofs' own references. -/
def Domain.derivedRelations (d : Domain) : List Relation :=
  d.objects.flatMap (fun o =>
      o.proofRefs.map (fun pid =>
        { sourceId := o.id, kind := .PROVEN_BY, targetId := pid, note := "object.proof_refs" }))
    ++ d.objects.flatMap (fun o =>
        o.claimRefs.map (fun cid =>
          { sourceId := o.id, kind := .REFERENCES, targetId := cid, note := "object.claim_refs" }))
    ++ d.proofs.flatMap (fun p =>
        p.inputRefs.map (fun i =>
          { sourceId := i, kind := .INPUT_TO, targetId := p.id, note := "proof.input_refs" }))
    ++ d.proofs.flatMap (fun p =>
        p.outputRefs.map (fun o =>
          { sourceId := o, kind := .OUTPUT_OF, targetId := p.id, note := "proof.output_refs" }))
    ++ d.proofs.flatMap (fun p =>
        p.dependencies.map (fun q =>
          { sourceId := p.id, kind := .DEPENDS_ON, targetId := q, note := "proof.dependencies" }))
    ++ d.claims.flatMap (fun c =>
        c.proofRefs.map (fun pid =>
          { sourceId := c.id, kind := .PROVEN_BY, targetId := pid, note := "claim.proof_refs" }))

/-- The whole proof-to-data graph: what the package declares, what its
references imply, and every converse of both. -/
def Domain.graph (d : Domain) : List Relation :=
  withConverses (d.relations ++ d.derivedRelations)

theorem Domain.graph_closed_under_converse {d : Domain} {r : Relation} {k : RelationKind}
    (hr : r ∈ d.graph) (hk : r.kind.converse = some k) : r.reverse k ∈ d.graph :=
  withConverses_closed hr hk

private theorem mem_derived_of_objects {d : Domain} {o : DomainObject} (ho : o ∈ d.objects)
    {pid : String} (hp : pid ∈ o.proofRefs) :
    ({ sourceId := o.id, kind := .PROVEN_BY, targetId := pid, note := "object.proof_refs" } :
      Relation) ∈ d.derivedRelations := by
  unfold Domain.derivedRelations
  refine List.mem_append_left _ (List.mem_append_left _ (List.mem_append_left _
    (List.mem_append_left _ (List.mem_append_left _ ?_))))
  exact List.mem_flatMap.mpr ⟨o, ho, List.mem_map.mpr ⟨pid, hp, rfl⟩⟩

/-- **DATA → PROOF.**  Every proof an object references is an edge of the
graph. -/
theorem Domain.data_to_proof {d : Domain} {o : DomainObject} (ho : o ∈ d.objects)
    {pid : String} (hp : pid ∈ o.proofRefs) :
    ({ sourceId := o.id, kind := .PROVEN_BY, targetId := pid, note := "object.proof_refs" } :
      Relation) ∈ d.graph :=
  mem_withConverses (List.mem_append_right _ (mem_derived_of_objects ho hp))

/-- **PROOF → DATA.**  And so is the reverse edge. -/
theorem Domain.proof_to_data {d : Domain} {o : DomainObject} (ho : o ∈ d.objects)
    {pid : String} (hp : pid ∈ o.proofRefs) :
    ({ sourceId := pid, kind := .PROVES, targetId := o.id, note := "object.proof_refs" } :
      Relation) ∈ d.graph :=
  Domain.graph_closed_under_converse (Domain.data_to_proof ho hp) rfl

private theorem mem_derived_of_inputs {d : Domain} {p : ProofRecord} (hp : p ∈ d.proofs)
    {i : String} (hi : i ∈ p.inputRefs) :
    ({ sourceId := i, kind := .INPUT_TO, targetId := p.id, note := "proof.input_refs" } :
      Relation) ∈ d.derivedRelations := by
  unfold Domain.derivedRelations
  refine List.mem_append_left _ (List.mem_append_left _ (List.mem_append_left _
    (List.mem_append_right _ ?_)))
  exact List.mem_flatMap.mpr ⟨p, hp, List.mem_map.mpr ⟨i, hi, rfl⟩⟩

/-- **PROOF → INPUTS**, in both directions. -/
theorem Domain.proof_to_input {d : Domain} {p : ProofRecord} (hp : p ∈ d.proofs)
    {i : String} (hi : i ∈ p.inputRefs) :
    ({ sourceId := i, kind := .INPUT_TO, targetId := p.id, note := "proof.input_refs" } :
        Relation) ∈ d.graph ∧
      ({ sourceId := p.id, kind := .DEPENDS_ON, targetId := i, note := "proof.input_refs" } :
        Relation) ∈ d.graph := by
  have h := mem_withConverses (List.mem_append_right d.relations (mem_derived_of_inputs hp hi))
  exact ⟨h, Domain.graph_closed_under_converse h rfl⟩

private theorem mem_derived_of_outputs {d : Domain} {p : ProofRecord} (hp : p ∈ d.proofs)
    {o : String} (ho : o ∈ p.outputRefs) :
    ({ sourceId := o, kind := .OUTPUT_OF, targetId := p.id, note := "proof.output_refs" } :
      Relation) ∈ d.derivedRelations := by
  unfold Domain.derivedRelations
  refine List.mem_append_left _ (List.mem_append_left _ (List.mem_append_right _ ?_))
  exact List.mem_flatMap.mpr ⟨p, hp, List.mem_map.mpr ⟨o, ho, rfl⟩⟩

/-- **PROOF → OUTPUTS → DATA**, in both directions. -/
theorem Domain.proof_to_output {d : Domain} {p : ProofRecord} (hp : p ∈ d.proofs)
    {o : String} (ho : o ∈ p.outputRefs) :
    ({ sourceId := o, kind := .OUTPUT_OF, targetId := p.id, note := "proof.output_refs" } :
        Relation) ∈ d.graph ∧
      ({ sourceId := p.id, kind := .DERIVES, targetId := o, note := "proof.output_refs" } :
        Relation) ∈ d.graph := by
  have h := mem_withConverses (List.mem_append_right d.relations (mem_derived_of_outputs hp ho))
  exact ⟨h, Domain.graph_closed_under_converse h rfl⟩

/-- Materialise the references into declared edges.  The *closure* under
converse is not materialised: it is `Domain.graph`, a function of the package,
proved to contain both directions.  Writing both directions into the data would
store what is already derivable, so the emitted `relations` are the base edges
and `relations.csv` reports the closed graph. -/
def Domain.linked (d : Domain) : Domain :=
  { d with relations := d.relations ++ d.derivedRelations }

/-- Linking loses nothing: every edge of the original graph is still an edge of
the linked package's graph. -/
theorem Domain.graph_subset_linked {d : Domain} {r : Relation} (h : r ∈ d.graph) :
    r ∈ d.linked.graph := by
  unfold Domain.graph withConverses at h ⊢
  rw [List.mem_flatMap] at h ⊢
  obtain ⟨r₀, hr₀, hmem⟩ := h
  exact ⟨r₀, List.mem_append_left _ hr₀, hmem⟩

/-! ## The proof ledger -/

/-- One line of the ledger: a data value, what is claimed of it, the proof, and
the canonical identity of the object the line is about. -/
structure LedgerRow where
  objectId : String := ""
  claimId : String := ""
  proofId : String := ""
  proofStatus : String := ""
  truth : String := ""
  coverage : String := ""
  validation : String := ""
  canonicalHash : String := ""
  deriving DecidableEq, Repr, Inhabited

/-- The ledger lines of one object: one per proof it references, or a single
line recording that it has none. -/
def Domain.ledgerBase (d : Domain) (o : DomainObject) : LedgerRow :=
  { objectId := o.id
    claimId := o.claimRefs.headD ""
    truth := o.truth.name
    coverage := (d.coverage o).name
    canonicalHash := objectHash o.unstamped }

def Domain.objectLedger (d : Domain) (o : DomainObject) : List LedgerRow :=
  let base : LedgerRow := d.ledgerBase o
  match o.proofRefs with
  | [] => [{ base with proofId := "--", proofStatus := "NONE", validation := "NONE" }]
  | refs => refs.map (fun r =>
      match d.findProof r with
      | some p =>
        { base with proofId := p.id, proofStatus := p.status.name, validation := p.validation.name }
      | none => { base with proofId := r, proofStatus := "UNRESOLVED", validation := "NONE" })

theorem Domain.objectLedger_objectId {d : Domain} {o : DomainObject} {row : LedgerRow}
    (h : row ∈ d.objectLedger o) : row.objectId = o.id := by
  unfold Domain.objectLedger at h
  cases hp : o.proofRefs with
  | nil =>
    rw [hp] at h
    simp only [List.mem_singleton] at h
    subst h
    rfl
  | cons a l =>
    rw [hp] at h
    simp only [List.mem_map] at h
    obtain ⟨r, _, hr⟩ := h
    subst hr
    cases hf : d.findProof r <;> simp [Domain.ledgerBase]

theorem Domain.objectLedger_coverage {d : Domain} {o : DomainObject} {row : LedgerRow}
    (h : row ∈ d.objectLedger o) : row.coverage = (d.coverage o).name := by
  unfold Domain.objectLedger at h
  cases hp : o.proofRefs with
  | nil =>
    rw [hp] at h
    simp only [List.mem_singleton] at h
    subst h
    rfl
  | cons a l =>
    rw [hp] at h
    simp only [List.mem_map] at h
    obtain ⟨r, _, hr⟩ := h
    subst hr
    cases hf : d.findProof r <;> simp [Domain.ledgerBase]

/-- The proof ledger of the package. -/
def Domain.ledgerRows (d : Domain) : List LedgerRow := d.objects.flatMap d.objectLedger

/-- Every object appears in the ledger: nothing can be proved by omission. -/
theorem Domain.ledger_covers_objects {d : Domain} {o : DomainObject} (ho : o ∈ d.objects) :
    ∃ row ∈ d.ledgerRows, row.objectId = o.id := by
  have hne : d.objectLedger o ≠ [] := by
    unfold Domain.objectLedger
    cases o.proofRefs with
    | nil => simp
    | cons a l => simp
  obtain ⟨row, hrow⟩ := List.exists_mem_of_ne_nil _ hne
  exact ⟨row, List.mem_flatMap.mpr ⟨o, ho, hrow⟩, Domain.objectLedger_objectId hrow⟩

/-- A ledger line that reports `PROVEN` coverage is backed by a valid proof in
the package: the ledger cannot overstate the evidence. -/
theorem Domain.ledger_proven_is_backed {d : Domain} {o : DomainObject} {row : LedgerRow}
    (hrow : row ∈ d.objectLedger o) (hcov : row.coverage = Coverage.PROVEN.name) :
    ∃ p ∈ d.proofsOf o, p.status = .VALID := by
  have hname : (d.coverage o).name = Coverage.PROVEN.name := by
    rw [← Domain.objectLedger_coverage hrow, hcov]
  have h1 := Coverage.ofName_name (d.coverage o)
  rw [hname, Coverage.ofName_name] at h1
  exact Domain.exists_valid_proof_of_coverage (Option.some.inj h1.symm)

/-- The ledger is a summary and declares itself lossy: two different packages
can have the same ledger, so no decoder can invert it. -/
def ledgerLossiness : Lossiness := .LOSSY

theorem ledgerRows_not_injective :
    ∃ d e : Domain, d ≠ e ∧ d.ledgerRows = e.ledgerRows := by
  refine ⟨{ id := "a" }, { id := "b" }, ?_, rfl⟩
  intro h
  exact absurd (congrArg Domain.id h) (by decide)

theorem ledger_no_decoder :
    ¬ ∃ dec : List LedgerRow → Option Domain, ∀ d : Domain, dec d.ledgerRows = some d := by
  rintro ⟨dec, hdec⟩
  obtain ⟨d, e, hne, heq⟩ := ledgerRows_not_injective
  have hd := hdec d
  rw [heq, hdec e] at hd
  exact hne (Option.some.inj hd).symm

/-! ## Coverage -/

/-- The coverage summary. -/
structure CoverageReport where
  objects : Nat := 0
  proven : Nat := 0
  partiallyProven : Nat := 0
  unproven : Nat := 0
  contradicted : Nat := 0
  proofs : Nat := 0
  validProofs : Nat := 0
  machineChecked : Nat := 0
  reproduced : Nat := 0
  deriving DecidableEq, Repr, Inhabited

def Domain.coverageReport (d : Domain) : CoverageReport :=
  { objects := d.objects.length
    proven := d.objects.countP (fun o => d.coverage o == .PROVEN)
    partiallyProven := d.objects.countP (fun o => d.coverage o == .PARTIALLY_PROVEN)
    unproven := d.objects.countP (fun o => d.coverage o == .UNPROVEN)
    contradicted := d.objects.countP (fun o => d.coverage o == .CONTRADICTED)
    proofs := d.proofs.length
    validProofs := d.proofs.countP (fun p => p.status == .VALID)
    machineChecked := d.proofs.countP (fun p => p.validation == .MACHINE_CHECKED)
    reproduced := d.proofs.countP (fun p => p.validation == .REPRODUCED) }

/-- The four classes partition the objects, so the summary cannot double count
or lose an object. -/
theorem Domain.coverageReport_total (d : Domain) :
    d.coverageReport.proven + d.coverageReport.partiallyProven + d.coverageReport.unproven
      + d.coverageReport.contradicted = d.coverageReport.objects := by
  unfold Domain.coverageReport
  simp only
  induction d.objects with
  | nil => rfl
  | cons o os ih =>
    cases h : d.coverage o <;> simp only [List.countP_cons, List.length_cons, h] <;>
      simp <;> omega

/-- No proof is counted as validated unless it is: the counts are bounded by
the number of proofs. -/
theorem Domain.coverageReport_bounds (d : Domain) :
    d.coverageReport.validProofs ≤ d.coverageReport.proofs ∧
      d.coverageReport.machineChecked ≤ d.coverageReport.proofs ∧
      d.coverageReport.reproduced ≤ d.coverageReport.proofs :=
  ⟨List.countP_le_length, List.countP_le_length, List.countP_le_length⟩

end Solfunmeme.Domain
