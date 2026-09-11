import RequestProject.Gvcs.Codec.Sop

/-!
# Reconciliation between systems

Two systems that both claim to have proved something have to be compared as canonical
objects, not as text (§28), and where they disagree the disagreement has to be recorded
rather than smoothed over (§29).

* `compareObjects` is the semantic comparator, returning the standard verdict
  vocabulary.  It is reflexive on objects that say enough to be compared
  (`compare_self`) and symmetric (`compare_symm`).
* `differences` reports the disagreement as structured `Difference` objects rather than
  as prose.
* `resolveConflict` applies a resolution strategy, and `resolution_is_recorded` proves
  that no resolution is silent: it always carries a diagnostic, a ledger entry naming
  the operation, and the strategy it used.
-/

namespace LifeTrac.Codec

/-- The externally visible content of the outputs: identifier and value. -/
def outputSummary (p : ProofObject) : List (String × Value) :=
  p.outputs.map (fun o => (o.id, o.value))

/-- The semantic comparator of §28. -/
def compareObjects (a b : ProofObject) : Verdict :=
  if a.kind ≠ b.kind then .incomparable
  else if a.status = .unknown ∨ b.status = .unknown then .incomplete
  else if outputSummary a = outputSummary b ∧ a.status = b.status then .equivalent
  else if a.status = .valid ∧ b.status = .valid then .conflict
  else .different

/-- The comparator is reflexive on objects that carry enough information to compare. -/
theorem compare_self (p : ProofObject) (h : p.status ≠ .unknown) :
    compareObjects p p = .equivalent := by
  simp [compareObjects, h]

/-- The comparator does not depend on which object is called the left one. -/
theorem compare_symm (a b : ProofObject) : compareObjects a b = compareObjects b a := by
  simp only [compareObjects]
  split_ifs <;> tauto

/-- Objects the comparator calls equivalent really do carry the same outputs. -/
theorem compare_equivalent_outputs {a b : ProofObject}
    (h : compareObjects a b = .equivalent) : outputSummary a = outputSummary b := by
  unfold compareObjects at h
  split at h
  · exact absurd h (by simp)
  · split at h
    · exact absurd h (by simp)
    · split at h
      · next hc => exact hc.1
      · split at h <;> exact absurd h (by simp)

/-- A conflict is only ever reported when both systems claim validity and disagree. -/
theorem compare_conflict {a b : ProofObject} (h : compareObjects a b = .conflict) :
    a.status = .valid ∧ b.status = .valid ∧ outputSummary a ≠ outputSummary b := by
  unfold compareObjects at h
  split at h
  · exact absurd h (by simp)
  · split at h
    · exact absurd h (by simp)
    · split at h
      · exact absurd h (by simp)
      · next hne =>
        split at h
        · next hv =>
          refine ⟨hv.1, hv.2, ?_⟩
          intro hout
          exact hne ⟨hout, hv.1.trans hv.2.symm⟩
        · exact absurd h (by simp)

/-! ## Structured differences -/

/-- The outputs of an object, rendered on their own, so a difference report shows the
outputs that disagree rather than the whole object. -/
def outputsText (p : ProofObject) : String :=
  Ipdl.encode (.node "outputs" [] (p.outputs.map Output.toDoc))

/-- Differences between two canonical objects, as structured objects (§28). -/
def differences (a b : ProofObject) : List Difference :=
  (if a.status = b.status then []
    else
      [{ path := "status"
         left := a.status.toName
         right := b.status.toName
         type := "STATUS_MISMATCH"
         severity := .error
         explanation := "the two systems report different statuses" }]) ++
  (if outputSummary a = outputSummary b then []
    else
      [{ path := "outputs"
         left := outputsText a
         right := outputsText b
         type := "VALUE_MISMATCH"
         severity := .error
         explanation := "the two systems produced different outputs" }])

theorem differences_self (p : ProofObject) : differences p p = [] := by
  simp [differences]

/-- No differences reported means the compared content really does agree. -/
theorem agree_of_differences_nil {a b : ProofObject} (h : differences a b = []) :
    a.status = b.status ∧ outputSummary a = outputSummary b := by
  unfold differences at h
  by_cases hs : a.status = b.status
  · by_cases ho : outputSummary a = outputSummary b
    · exact ⟨hs, ho⟩
    · rw [if_pos hs, if_neg ho] at h; simp at h
  · rw [if_neg hs] at h; simp at h

/-! ## §29 Conflict resolution -/

/-- A recorded resolution of a disagreement. -/
structure Resolution where
  /-- The strategy applied. -/
  strategy : Strategy
  /-- Canonical hash of the left object. -/
  left : String
  /-- Canonical hash of the right object. -/
  right : String
  /-- The object the resolution produced. -/
  result : ProofObject
  /-- The ledger entry recording the resolution. -/
  recorded : Transformation
  /-- Diagnostics explaining what was done and why. -/
  diagnostics : List Diagnostic
  deriving Repr, Inhabited

/-- The diagnostic that records a resolution. -/
def resolutionNote (strategyName : String) (a b : ProofObject) : Diagnostic :=
  { id := "res-" ++ a.id
    code := "CONFLICT_RESOLVED"
    severity := .warning
    message := "a disagreement was resolved by " ++ strategyName ++ "; both parents are recorded"
    field := "outputs"
    expected := canonicalHash a
    actual := canonicalHash b
    cause := "conflicting results for the same subject"
    resolution := strategyName
    recoverable := true }

/-- Merge two objects by keeping the left object's outputs and recording the right
object's outputs as an extension, so nothing is thrown away. -/
def mergeObjects (a b : ProofObject) : ProofObject :=
  { a with
    status := .conflict
    extensions := a.extensions ++
      [("reconcile.other_hash", .str (canonicalHash b)),
       ("reconcile.other_outputs",
         .list (b.outputs.map (fun o => .obj [("id", .str o.id), ("value", o.value)])))] }

/-- Apply a resolution strategy to a disagreement (§29).  `manual` and `reject` produce
no object: they escalate rather than inventing one. -/
def resolveConflict (strategy : Strategy) (a b : ProofObject) : Option Resolution :=
  let note := fun (name : String) => resolutionNote name a b
  let ledger := fun (name : String) (out : ProofObject) =>
    transformation ("resolve-" ++ a.id) "resolve" name (canonicalHash a) (canonicalHash b)
      .lossy (canonicalHash a) (canonicalHash out)
  match strategy with
  | .preferSource =>
      some { strategy := strategy, left := canonicalHash a, right := canonicalHash b,
             result := a, recorded := ledger "prefer_source" a,
             diagnostics := [note "prefer_source"] }
  | .preferVerified =>
      if a.status = .valid ∧ b.status ≠ .valid then
        some { strategy := strategy, left := canonicalHash a, right := canonicalHash b,
               result := a, recorded := ledger "prefer_verified" a,
               diagnostics := [note "prefer_verified"] }
      else if b.status = .valid ∧ a.status ≠ .valid then
        some { strategy := strategy, left := canonicalHash a, right := canonicalHash b,
               result := b, recorded := ledger "prefer_verified" b,
               diagnostics := [note "prefer_verified"] }
      else none
  | .preferNewer =>
      let ta := (a.provenance.map Provenance.transformedAt).getD ""
      let tb := (b.provenance.map Provenance.transformedAt).getD ""
      if ta = tb then none
      else if tb < ta then
        some { strategy := strategy, left := canonicalHash a, right := canonicalHash b,
               result := a, recorded := ledger "prefer_newer" a,
               diagnostics := [note "prefer_newer"] }
      else
        some { strategy := strategy, left := canonicalHash a, right := canonicalHash b,
               result := b, recorded := ledger "prefer_newer" b,
               diagnostics := [note "prefer_newer"] }
  | .merge =>
      some { strategy := strategy, left := canonicalHash a, right := canonicalHash b,
             result := mergeObjects a b, recorded := ledger "merge" (mergeObjects a b),
             diagnostics := [note "merge"] }
  | .manual => none
  | .reject => none

/-- **A resolution is never silent** (§29): it records the strategy, a ledger entry and
a diagnostic naming both parents. -/
theorem resolution_is_recorded {st : Strategy} {a b : ProofObject} {r : Resolution}
    (h : resolveConflict st a b = some r) :
    r.strategy = st ∧ r.recorded.operation = "resolve" ∧ r.diagnostics ≠ []
      ∧ r.left = canonicalHash a ∧ r.right = canonicalHash b := by
  cases st <;> simp only [resolveConflict] at h
  · cases h; exact ⟨rfl, rfl, by simp, rfl, rfl⟩
  · split at h
    · cases h; exact ⟨rfl, rfl, by simp, rfl, rfl⟩
    · split at h
      · cases h; exact ⟨rfl, rfl, by simp, rfl, rfl⟩
      · exact absurd h (by simp)
  · split at h
    · exact absurd h (by simp)
    · split at h
      · cases h; exact ⟨rfl, rfl, by simp, rfl, rfl⟩
      · cases h; exact ⟨rfl, rfl, by simp, rfl, rfl⟩
  · exact absurd h (by simp)
  · cases h; exact ⟨rfl, rfl, by simp, rfl, rfl⟩
  · exact absurd h (by simp)

/-- Merging keeps the other system's outputs instead of discarding them (§30). -/
theorem merge_keeps_other (a b : ProofObject) :
    ("reconcile.other_hash", Value.str (canonicalHash b)) ∈ (mergeObjects a b).extensions := by
  simp [mergeObjects]

/-- A merge is marked as a conflict rather than being presented as agreement. -/
theorem merge_status (a b : ProofObject) : (mergeObjects a b).status = .conflict := rfl

end LifeTrac.Codec
