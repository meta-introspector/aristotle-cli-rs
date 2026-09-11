/-
# Machine-checked facts about the catalogue

The catalogue in `RequestProject.Domain.Instance` is data; these are the facts
about it.  Each is decided by evaluating a decidable predicate on the whole
graph (2568 objects, 1252 proofs, 9642 relations).

* `corpus_wellFormed` — every reference in the package resolves: every proof
  reference of every object names a proof of the package, every input and
  output of every proof names an object of the package, and every object
  marked `PROVEN` is the output of a proof recorded as `VALID` and listed among
  that object's proof references.
* `corpus_relationComplete` — every implied proof-to-data edge is present in
  the emitted relation list.
* `corpus_coverage` — the coverage census: 1252 proven, 0 partially proven,
  1316 unproven, 0 contradicted.
* `corpus_no_contradiction` — no object of the corpus is contradicted.
* `corpus_proven_backed` — every `PROVEN` object of the corpus is backed by a
  `VALID` proof that produces it.
-/
import RequestProject.Craft.Domain.Instance

set_option maxRecDepth 4000

namespace Domain
namespace Corpus

theorem corpus_wellFormed : WellFormed graph := by native_decide

theorem corpus_relationComplete : relationComplete graph = true := by native_decide

theorem corpus_coverage : coverageCounts graph = (1252, 0, 1316, 0) := by native_decide

theorem corpus_objects_count : graph.objects.length = 2568 := by native_decide

theorem corpus_proofs_count : graph.proofs.length = 1252 := by native_decide

theorem corpus_coverage_total :
    (1252 : Nat) + 0 + 1316 + 0 = graph.objects.length := by
  rw [corpus_objects_count]

/-- No object of the corpus is contradicted. -/
theorem corpus_no_contradiction (o : DomainObject) (ho : o ∈ graph.objects) :
    objectCoverage graph o ≠ .CONTRADICTED := by
  have hc : (graph.objects.filter (fun o => objectCoverage graph o == .CONTRADICTED)).length = 0 := by
    have hcov := corpus_coverage
    simp only [coverageCounts, Prod.mk.injEq] at hcov
    exact hcov.2.2.2
  have h : (graph.objects.filter (fun o => objectCoverage graph o == .CONTRADICTED)) = [] :=
    List.length_eq_zero_iff.mp hc
  intro hcon
  have : o ∈ graph.objects.filter (fun o => objectCoverage graph o == .CONTRADICTED) :=
    List.mem_filter.2 ⟨ho, by simp [hcon]⟩
  rw [h] at this
  exact absurd this (by simp)

/-- Every object of the corpus that is marked `PROVEN` is the output of a proof
the package records as `VALID`, and that proof is among the object's proof
references. -/
theorem corpus_proven_backed (o : DomainObject) (ho : o ∈ graph.objects)
    (h : o.truth = .PROVEN) :
    ∃ p ∈ graph.proofs, p.status = .VALID ∧ o.id ∈ p.outputs ∧ p.id ∈ o.proofRefs :=
  proven_is_backed corpus_wellFormed ho h

/-- Every object of the corpus appears in the proof ledger. -/
theorem corpus_ledger_covers (o : DomainObject) (ho : o ∈ graph.objects) :
    ∃ row ∈ ledger graph, row.objectId = o.id := ledger_covers graph o ho

/-- Every proof of the corpus produces an object that the ledger records. -/
theorem corpus_output_to_data (p : DProof) (hp : p ∈ graph.proofs) (x : String)
    (hx : x ∈ p.outputs) : ∃ row ∈ ledger graph, row.objectId = x :=
  output_to_data corpus_wellFormed hp hx

end Corpus
end Domain
