/-
# Proof coverage, the proof ledger, and the discipline of truth

This file turns "the forms are proven" into a testable property.

* `objectCoverage` classifies every domain object as `PROVEN`,
  `PARTIALLY_PROVEN`, `UNPROVEN` or `CONTRADICTED` (SOP §15); the
  classification is a total, decidable function of the graph, and
  `coverage_proven_iff` states exactly what it means.
* `ledger` is the proof ledger (SOP §23): one row per (object, claim, proof)
  triple, carrying the proof status, the coverage verdict and the canonical
  hash of the object.
* `WellFormed` (SOP §20 step 4) says every reference in the graph resolves;
  under it the audit path of SOP §25 is traversable in both directions
  (`data_to_proof`, `proof_to_outputs`, `output_to_data`, `proof_to_inputs`).
* `TruthEvent` / `stepObject` are the only way a truth status changes, and
  `no_silent_upgrade` (SOP §22) shows nothing is ever promoted to `PROVEN`
  without a validation event naming a proof that the graph records as `VALID`;
  `contradiction_is_explicit` shows a `PROVEN → CONTRADICTED` transition always
  emits a diagnostic.
-/
import RequestProject.Craft.Domain.Formats

namespace Domain

/-! ## Coverage -/

/-- Proof-coverage verdict for a domain object (SOP §15). -/
inductive Coverage where
  | PROVEN | PARTIALLY_PROVEN | UNPROVEN | CONTRADICTED
  deriving Repr, DecidableEq, Inhabited

namespace Coverage

/-- The wire name of a coverage verdict. -/
def toName : Coverage → String
  | PROVEN => "PROVEN" | PARTIALLY_PROVEN => "PARTIALLY_PROVEN"
  | UNPROVEN => "UNPROVEN" | CONTRADICTED => "CONTRADICTED"

/-- The coverage verdict with a given wire name. -/
def ofName : String → Option Coverage
  | "PROVEN" => some PROVEN | "PARTIALLY_PROVEN" => some PARTIALLY_PROVEN
  | "UNPROVEN" => some UNPROVEN | "CONTRADICTED" => some CONTRADICTED
  | _ => none

theorem ofName_toName (c : Coverage) : ofName c.toName = some c := by cases c <;> rfl

end Coverage

/-- Resolve a proof identifier against the graph. -/
def lookupProof (g : DomainGraph) (pid : String) : Option DProof :=
  g.proofs.find? (fun p => p.id = pid)

/-- Resolve an object identifier against the graph. -/
def lookupObject (g : DomainGraph) (oid : String) : Option DomainObject :=
  g.objects.find? (fun o => o.id = oid)

/-- Does the object carry a contradiction: is it flagged `CONTRADICTED`, or
does one of its proofs report `INVALID` or `CONFLICT`? -/
def hasConflict (g : DomainGraph) (o : DomainObject) : Bool :=
  (o.truth == .CONTRADICTED) ||
    o.proofRefs.any (fun r =>
      match lookupProof g r with
      | some p => (p.status == .INVALID) || (p.status == .CONFLICT)
      | none => false)

/-- Do all the object's proof references resolve to proofs reported `VALID`? -/
def allValid (g : DomainGraph) (o : DomainObject) : Bool :=
  o.proofRefs.all (fun r =>
    match lookupProof g r with
    | some p => p.status == .VALID
    | none => false)

/-- Do none of the object's proof references resolve? -/
def noneResolve (g : DomainGraph) (o : DomainObject) : Bool :=
  o.proofRefs.all (fun r => (lookupProof g r).isNone)

/-- The proof-coverage verdict of a domain object (SOP §15).  The
classification is a decidable function of the graph, hence reproducible. -/
def objectCoverage (g : DomainGraph) (o : DomainObject) : Coverage :=
  if hasConflict g o then .CONTRADICTED
  else if o.proofRefs.isEmpty then .UNPROVEN
  else if allValid g o then .PROVEN
  else if noneResolve g o then .UNPROVEN
  else .PARTIALLY_PROVEN

theorem coverage_proven_iff (g : DomainGraph) (o : DomainObject) :
    objectCoverage g o = .PROVEN ↔
      (hasConflict g o = false ∧ o.proofRefs ≠ [] ∧ allValid g o = true) := by
  unfold objectCoverage
  split_ifs with h1 h2 h3 h4 <;> simp_all

theorem coverage_contradicted_iff (g : DomainGraph) (o : DomainObject) :
    objectCoverage g o = .CONTRADICTED ↔ hasConflict g o = true := by
  unfold objectCoverage
  split_ifs with h1 h2 h3 h4 <;> simp_all

theorem coverage_unproven_of_no_refs (g : DomainGraph) (o : DomainObject)
    (h : o.proofRefs = []) (hc : hasConflict g o = false) :
    objectCoverage g o = .UNPROVEN := by
  unfold objectCoverage
  simp [h, hc]

/-- A claim that a domain object is proven must be backed by proofs: an object
whose coverage is `PROVEN` has at least one proof, and every one of its proofs
is recorded in the graph with status `VALID`. -/
theorem proven_has_valid_proofs (g : DomainGraph) (o : DomainObject)
    (h : objectCoverage g o = .PROVEN) :
    o.proofRefs ≠ [] ∧ ∀ r ∈ o.proofRefs, ∃ p, lookupProof g r = some p ∧ p.status = .VALID := by
  rw [coverage_proven_iff] at h
  refine ⟨h.2.1, ?_⟩
  intro r hr
  have := (List.all_eq_true.1 h.2.2) r hr
  cases hp : lookupProof g r with
  | none => rw [hp] at this; simp at this
  | some p =>
      rw [hp] at this
      exact ⟨p, rfl, by simpa using this⟩

/-! ## Coverage summary -/

/-- The number of objects with each coverage verdict (SOP §15). -/
def coverageCounts (g : DomainGraph) : Nat × Nat × Nat × Nat :=
  ((g.objects.filter (fun o => objectCoverage g o == .PROVEN)).length,
   (g.objects.filter (fun o => objectCoverage g o == .PARTIALLY_PROVEN)).length,
   (g.objects.filter (fun o => objectCoverage g o == .UNPROVEN)).length,
   (g.objects.filter (fun o => objectCoverage g o == .CONTRADICTED)).length)

theorem counts_total (f : DomainObject → Coverage) (os : List DomainObject) :
    (os.filter (fun o => f o == .PROVEN)).length +
      (os.filter (fun o => f o == .PARTIALLY_PROVEN)).length +
      (os.filter (fun o => f o == .UNPROVEN)).length +
      (os.filter (fun o => f o == .CONTRADICTED)).length = os.length := by
  induction os with
  | nil => rfl
  | cons o os ih =>
      cases hc : f o <;> simp only [List.filter_cons, hc, beq_self_eq_true, beq_iff_eq,
        reduceCtorEq, List.length_cons, if_true, if_false] <;> omega

theorem coverageCounts_total (g : DomainGraph) :
    (coverageCounts g).1 + (coverageCounts g).2.1 + (coverageCounts g).2.2.1 +
      (coverageCounts g).2.2.2 = g.objects.length :=
  counts_total (objectCoverage g) g.objects

/-! ## The proof ledger -/

/-- One row of the proof ledger (SOP §23). -/
structure LedgerRow where
  objectId : String
  claimId : String
  proofId : String
  proofStatus : String
  coverage : Coverage
  canonicalHash : Nat
  deriving Repr, DecidableEq, Inhabited

/-- The ledger rows of one object: one per proof reference, or a single
`UNPROVEN` row when there is none. -/
def objectLedger (g : DomainGraph) (o : DomainObject) : List LedgerRow :=
  let cov := objectCoverage g o
  let cl := o.claimRefs.headD ""
  let h := o.canonicalHash
  match o.proofRefs with
  | [] => [⟨o.id, cl, "--", "NONE", cov, h⟩]
  | rs => rs.map (fun r =>
      ⟨o.id, cl, r,
        match lookupProof g r with
        | some p => p.status.toName
        | none => "UNRESOLVED",
        cov, h⟩)

/-- The proof ledger of the whole domain (SOP §23). -/
def ledger (g : DomainGraph) : List LedgerRow := g.objects.flatMap (objectLedger g)

theorem objectLedger_ne_nil (g : DomainGraph) (o : DomainObject) :
    objectLedger g o ≠ [] := by
  unfold objectLedger
  cases h : o.proofRefs with
  | nil => simp
  | cons r rs => simp

/-- **Every object is in the ledger.** -/
theorem ledger_covers (g : DomainGraph) (o : DomainObject) (ho : o ∈ g.objects) :
    ∃ row ∈ ledger g, row.objectId = o.id := by
  have h := objectLedger_ne_nil g o
  cases hl : objectLedger g o with
  | nil => exact absurd hl h
  | cons row rows =>
      refine ⟨row, ?_, ?_⟩
      · exact List.mem_flatMap.2 ⟨o, ho, by rw [hl]; simp⟩
      · unfold objectLedger at hl
        cases hr : o.proofRefs with
        | nil => rw [hr] at hl; simp at hl; simp [← hl.1]
        | cons r rs => rw [hr] at hl; simp at hl; simp [← hl.1]

/-- **Every ledger row belongs to an object of the graph**, and reports that
object's coverage verdict and canonical hash. -/
theorem ledger_sound (g : DomainGraph) (row : LedgerRow) (h : row ∈ ledger g) :
    ∃ o ∈ g.objects, row.objectId = o.id ∧ row.coverage = objectCoverage g o ∧
      row.canonicalHash = o.canonicalHash := by
  obtain ⟨o, ho, hrow⟩ := List.mem_flatMap.1 h
  refine ⟨o, ho, ?_⟩
  unfold objectLedger at hrow
  cases hr : o.proofRefs with
  | nil =>
      rw [hr] at hrow
      simp only [List.mem_singleton] at hrow
      subst hrow
      exact ⟨rfl, rfl, rfl⟩
  | cons r rs =>
      rw [hr] at hrow
      simp only [List.mem_map] at hrow
      obtain ⟨x, _, hx⟩ := hrow
      subst hx
      exact ⟨rfl, rfl, rfl⟩

/-! ## Well-formedness and the audit path -/

/-- Every reference in the graph resolves (SOP §20 step 4). -/
def WellFormed (g : DomainGraph) : Prop :=
  (∀ o ∈ g.objects, ∀ r ∈ o.proofRefs, ∃ p ∈ g.proofs, p.id = r) ∧
  (∀ p ∈ g.proofs, ∀ x ∈ p.outputs, ∃ o ∈ g.objects, o.id = x) ∧
  (∀ p ∈ g.proofs, ∀ x ∈ p.inputs, ∃ o ∈ g.objects, o.id = x) ∧
  (∀ o ∈ g.objects, o.truth = .PROVEN →
      ∃ p ∈ g.proofs, p.status = .VALID ∧ o.id ∈ p.outputs ∧ p.id ∈ o.proofRefs)

/-- `DATA → PROOF`: a proof reference of an object resolves to a proof. -/
theorem data_to_proof {g : DomainGraph} (hw : WellFormed g) {o : DomainObject}
    (ho : o ∈ g.objects) {r : String} (hr : r ∈ o.proofRefs) :
    ∃ p ∈ g.proofs, p.id = r := hw.1 o ho r hr

/-- `PROOF → OUTPUTS`: every output of a proof is a domain object. -/
theorem proof_to_outputs {g : DomainGraph} (hw : WellFormed g) {p : DProof}
    (hp : p ∈ g.proofs) {x : String} (hx : x ∈ p.outputs) :
    ∃ o ∈ g.objects, o.id = x := hw.2.1 p hp x hx

/-- `PROOF → INPUTS`: every input of a proof is a domain object. -/
theorem proof_to_inputs {g : DomainGraph} (hw : WellFormed g) {p : DProof}
    (hp : p ∈ g.proofs) {x : String} (hx : x ∈ p.inputs) :
    ∃ o ∈ g.objects, o.id = x := hw.2.2.1 p hp x hx

/-- `OUTPUT → DATA`: the object produced by a proof is in the ledger, so the
audit path from a proof back to the data it establishes is traversable. -/
theorem output_to_data {g : DomainGraph} (hw : WellFormed g) {p : DProof}
    (hp : p ∈ g.proofs) {x : String} (hx : x ∈ p.outputs) :
    ∃ row ∈ ledger g, row.objectId = x := by
  obtain ⟨o, ho, rfl⟩ := proof_to_outputs hw hp hx
  exact ledger_covers g o ho

/-- **No unbacked `PROVEN`.**  In a well-formed graph an object marked `PROVEN`
is the output of a proof that the graph records as `VALID`, and that proof is
among the object's proof references. -/
theorem proven_is_backed {g : DomainGraph} (hw : WellFormed g) {o : DomainObject}
    (ho : o ∈ g.objects) (h : o.truth = .PROVEN) :
    ∃ p ∈ g.proofs, p.status = .VALID ∧ o.id ∈ p.outputs ∧ p.id ∈ o.proofRefs :=
  hw.2.2.2 o ho h

/-! ### Deciding well-formedness -/

/-- A decidable check of well-formedness, used to validate an emitted package. -/
def wellFormedB (g : DomainGraph) : Bool :=
  g.objects.all (fun o => o.proofRefs.all (fun r => g.proofs.any (fun p => p.id == r))) &&
  g.proofs.all (fun p => p.outputs.all (fun x => g.objects.any (fun o => o.id == x))) &&
  g.proofs.all (fun p => p.inputs.all (fun x => g.objects.any (fun o => o.id == x))) &&
  g.objects.all (fun o => (o.truth != .PROVEN) ||
    g.proofs.any (fun p => (p.status == .VALID) && o.id ∈ p.outputs && p.id ∈ o.proofRefs))

theorem wellFormedB_iff (g : DomainGraph) : wellFormedB g = true ↔ WellFormed g := by
  unfold wellFormedB WellFormed
  simp only [Bool.and_eq_true, List.all_eq_true, List.any_eq_true, beq_iff_eq,
    bne_iff_ne, ne_eq, Bool.or_eq_true, decide_eq_true_eq]
  constructor
  · rintro ⟨⟨⟨h1, h2⟩, h3⟩, h4⟩
    refine ⟨fun o ho r hr => ?_, fun p hp x hx => ?_, fun p hp x hx => ?_, fun o ho h => ?_⟩
    · obtain ⟨p, hp, hpr⟩ := h1 o ho r hr
      exact ⟨p, hp, hpr⟩
    · obtain ⟨o, ho, hox⟩ := h2 p hp x hx
      exact ⟨o, ho, hox⟩
    · obtain ⟨o, ho, hox⟩ := h3 p hp x hx
      exact ⟨o, ho, hox⟩
    · rcases h4 o ho with hne | ⟨p, hp, hst⟩
      · exact absurd h hne
      · exact ⟨p, hp, hst.1.1, hst.1.2, hst.2⟩
  · rintro ⟨h1, h2, h3, h4⟩
    refine ⟨⟨⟨fun o ho r hr => ?_, fun p hp x hx => ?_⟩, fun p hp x hx => ?_⟩, fun o ho => ?_⟩
    · obtain ⟨p, hp, hpr⟩ := h1 o ho r hr
      exact ⟨p, hp, hpr⟩
    · obtain ⟨o, ho, hox⟩ := h2 p hp x hx
      exact ⟨o, ho, hox⟩
    · obtain ⟨o, ho, hox⟩ := h3 p hp x hx
      exact ⟨o, ho, hox⟩
    · by_cases h : o.truth = .PROVEN
      · obtain ⟨p, hp, hs, hout, href⟩ := h4 o ho h
        exact Or.inr ⟨p, hp, ⟨hs, hout⟩, href⟩
      · exact Or.inl h

instance (g : DomainGraph) : Decidable (WellFormed g) :=
  decidable_of_iff _ (wellFormedB_iff g)

/-! ## Derived relations

The proof-to-data edges implied by the objects and proofs of the graph.  A
package is *relation-complete* when its relation list contains all of them. -/

/-- The edges implied by the graph's objects and proofs (SOP §6). -/
def derivedRelations (g : DomainGraph) : List Relation :=
  g.objects.flatMap (fun o => o.proofRefs.map (fun r => ⟨o.id, .PROVEN_BY, r⟩)) ++
  g.proofs.flatMap (fun p =>
    p.outputs.map (fun x => ⟨p.id, .PROVES, x⟩) ++
    p.inputs.map (fun x => ⟨x, .INPUT_TO, p.id⟩) ++
    p.dependencies.map (fun d => ⟨p.id, .DEPENDS_ON, d⟩))

/-- Are all implied edges present in the emitted relation list? -/
def relationComplete (g : DomainGraph) : Bool :=
  (derivedRelations g).all (fun r => g.relations.contains r)

theorem relationComplete_iff (g : DomainGraph) :
    relationComplete g = true ↔ ∀ r ∈ derivedRelations g, r ∈ g.relations := by
  unfold relationComplete
  simp [List.all_eq_true]

/-- In a relation-complete package, every proof reference of every object is
also present as a `PROVEN_BY` edge of the relation graph. -/
theorem provenBy_edge_present {g : DomainGraph} (h : relationComplete g = true)
    {o : DomainObject} (ho : o ∈ g.objects) {r : String} (hr : r ∈ o.proofRefs) :
    (⟨o.id, .PROVEN_BY, r⟩ : Relation) ∈ g.relations := by
  rw [relationComplete_iff] at h
  refine h _ ?_
  refine List.mem_append_left _ ?_
  exact List.mem_flatMap.2 ⟨o, ho, List.mem_map.2 ⟨r, hr, rfl⟩⟩

/-- In a relation-complete package, every output of every proof is present as a
`PROVES` edge. -/
theorem proves_edge_present {g : DomainGraph} (h : relationComplete g = true)
    {p : DProof} (hp : p ∈ g.proofs) {x : String} (hx : x ∈ p.outputs) :
    (⟨p.id, .PROVES, x⟩ : Relation) ∈ g.relations := by
  rw [relationComplete_iff] at h
  refine h _ ?_
  refine List.mem_append_right _ ?_
  refine List.mem_flatMap.2 ⟨p, hp, ?_⟩
  exact List.mem_append_left _ (List.mem_append_left _ (List.mem_map.2 ⟨x, hx, rfl⟩))

/-! ## No silent claims -/

/-- The events that may change the truth status of a domain object (SOP §22). -/
inductive TruthEvent where
  /-- A named proof has been validated. -/
  | validated : String → TruthEvent
  /-- The value was derived from other data. -/
  | derived : String → TruthEvent
  /-- The value was asserted by a human. -/
  | asserted : TruthEvent
  /-- The value was imported from another system. -/
  | imported : String → TruthEvent
  /-- The value was inferred. -/
  | inferred : String → TruthEvent
  /-- A named proof contradicts the value. -/
  | contradicted : String → TruthEvent
  deriving Repr, DecidableEq, Inhabited

/-- Apply one truth event to an object, returning the updated object and, when
a previously proven value is contradicted, an explicit diagnostic. -/
def stepObject (g : DomainGraph) (o : DomainObject) (e : TruthEvent) :
    DomainObject × Option DError :=
  match e with
  | .validated pid =>
      match lookupProof g pid with
      | some p =>
          if p.status = .VALID ∧ o.id ∈ p.outputs then
            ({ o with
                truth := .PROVEN,
                proofRefs := (if o.proofRefs.contains pid then o.proofRefs
                  else o.proofRefs ++ [pid]) },
              none)
          else
            (o, some ⟨"err-" ++ o.id ++ "-" ++ pid, o.id, "PROOF_NOT_VALID",
              "validation event refused: the proof does not establish this object",
              "ERROR", "", false⟩)
      | none =>
          (o, some ⟨"err-" ++ o.id ++ "-" ++ pid, o.id, "PROOF_UNRESOLVED",
            "validation event refused: no such proof", "ERROR", "", false⟩)
  | .derived _ => ({ o with truth := .DERIVED }, none)
  | .asserted => ({ o with truth := .ASSERTED }, none)
  | .imported _ => ({ o with truth := .IMPORTED }, none)
  | .inferred _ => ({ o with truth := .INFERRED }, none)
  | .contradicted pid =>
      ({ o with truth := .CONTRADICTED },
        some ⟨"err-" ++ o.id ++ "-" ++ pid, o.id, "PROOF_CONFLICT",
          "a proof contradicts a previously established value", "CRITICAL", "", false⟩)

/-- **No silent upgrade** (SOP §22).  A truth status can only become `PROVEN`
through a validation event that names a proof the graph records as `VALID` and
whose outputs contain the object; assertion, import, inference and derivation
never produce `PROVEN`. -/
theorem no_silent_upgrade (g : DomainGraph) (o : DomainObject) (e : TruthEvent)
    (hold : o.truth ≠ .PROVEN) (hnew : (stepObject g o e).1.truth = .PROVEN) :
    ∃ pid, e = .validated pid ∧ ∃ p, lookupProof g pid = some p ∧
      p.status = .VALID ∧ o.id ∈ p.outputs := by
  cases e with
  | validated pid =>
      refine ⟨pid, rfl, ?_⟩
      simp only [stepObject] at hnew
      split at hnew
      next p heq =>
        split at hnew
        next hc => exact ⟨p, heq, hc.1, hc.2⟩
        next => exact absurd hnew hold
      next => exact absurd hnew hold
  | derived s => exact absurd hnew (by simp [stepObject])
  | asserted => exact absurd hnew (by simp [stepObject])
  | imported s => exact absurd hnew (by simp [stepObject])
  | inferred s => exact absurd hnew (by simp [stepObject])
  | contradicted s => exact absurd hnew (by simp [stepObject])

/-- An event that does not validate a proof never raises the status to
`PROVEN`: `ASSERTED`, `IMPORTED`, `INFERRED` and `DERIVED` are terminal. -/
theorem non_validation_never_proven (g : DomainGraph) (o : DomainObject) (s : String) :
    (stepObject g o .asserted).1.truth = .ASSERTED ∧
    (stepObject g o (.imported s)).1.truth = .IMPORTED ∧
    (stepObject g o (.inferred s)).1.truth = .INFERRED ∧
    (stepObject g o (.derived s)).1.truth = .DERIVED :=
  ⟨rfl, rfl, rfl, rfl⟩

/-- A refused validation event changes nothing (SOP §22: no silent upgrade) and
records why. -/
theorem refused_validation_inert (g : DomainGraph) (o : DomainObject) (pid : String)
    (h : ∀ p, lookupProof g pid = some p → ¬(p.status = .VALID ∧ o.id ∈ p.outputs)) :
    (stepObject g o (.validated pid)).1 = o ∧ (stepObject g o (.validated pid)).2.isSome := by
  simp only [stepObject]
  split
  next p heq =>
    rw [if_neg (h p heq)]
    exact ⟨rfl, rfl⟩
  next => exact ⟨rfl, rfl⟩

/-- **A contradiction is explicit** (SOP §22): moving a value away from
`PROVEN` always emits a diagnostic, which stays attached to the graph. -/
theorem contradiction_is_explicit (g : DomainGraph) (o : DomainObject) (pid : String) :
    (stepObject g o (.contradicted pid)).1.truth = .CONTRADICTED ∧
    ∃ err, (stepObject g o (.contradicted pid)).2 = some err ∧ err.code = "PROOF_CONFLICT" ∧
      err.subject = o.id := by
  exact ⟨rfl, ⟨_, rfl, rfl, rfl⟩⟩

/-- A successful validation event leaves the object referencing the proof that
established it, so the emitted object always points at its proof (SOP §14). -/
theorem validated_records_proof (g : DomainGraph) (o : DomainObject) (pid : String)
    (p : DProof) (hp : lookupProof g pid = some p) (hv : p.status = .VALID)
    (hout : o.id ∈ p.outputs) :
    (stepObject g o (.validated pid)).1.truth = .PROVEN ∧
      pid ∈ (stepObject g o (.validated pid)).1.proofRefs := by
  simp only [stepObject, hp]
  rw [if_pos ⟨hv, hout⟩]
  refine ⟨rfl, ?_⟩
  by_cases hc : pid ∈ o.proofRefs
  · simp [hc]
  · simp [hc]

end Domain
