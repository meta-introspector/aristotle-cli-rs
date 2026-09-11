import RequestProject.Solfunmeme.Domain.Data.Dataset

/-!
# What is true of the two emitted packages

Everything general — the round trip in each codec, the cross-representation
invariant, the canonical hash, the closure of the proof graph — is proved once
in `Domain.Emit`, `Domain.Hash` and `Domain.Ledger` and applies to *any*
package.  This file is what is true of the two packages this repository ships:

* they validate, so no object claims a proof it does not have, no reference
  dangles, and no `VALID` proof is uncertified;
* their coverage is what the reports say it is;
* the objects deliberately left unproven really are unproven, so the coverage
  figures are not vacuous;
* and both survive every codec unchanged, with the same canonical hash.
-/

namespace Solfunmeme.Domain.Data

open Solfunmeme.Codec
open Solfunmeme.Domain

/-! ## The dataset package -/

/-- The dataset package validates: every proof reference resolves, every
relation lands on something the package declares, no object calls itself
`PROVEN` without a `VALID` proof, and no `VALID` proof is uncertified. -/
theorem dataset_wellFormed : solfunmemeDataset.WellFormed := by native_decide

/-- Its size. -/
theorem dataset_size :
    solfunmemeDataset.objects.length = 52 ∧
      solfunmemeDataset.claims.length = 52 ∧
      solfunmemeDataset.proofs.length = 71 := by native_decide

/-- Its coverage, computed from the graph and not stored anywhere. -/
theorem dataset_coverage :
    solfunmemeDataset.coverageReport =
      { objects := 52, proven := 49, partiallyProven := 0, unproven := 3, contradicted := 0
        proofs := 71, validProofs := 71, machineChecked := 68, reproduced := 3 } := by
  native_decide

/-- The three unproven objects are the three the package deliberately declares
unproven: two assumptions and one thing this environment cannot exercise.  The
coverage figure is therefore not an accident of a missing reference. -/
theorem dataset_unproven_are_declared :
    (solfunmemeDataset.objects.filter
        (fun o => solfunmemeDataset.coverage o == .UNPROVEN)).map DomainObject.id
      = ["rpc.live", "programme.assumed_income", "market.star_ranking"] := by native_decide

/-- And those three do say so: `UNRESOLVED`, `ASSERTED`, `ASSERTED`.  Nothing
was upgraded on the way into the package. -/
theorem dataset_unproven_truth :
    (solfunmemeDataset.objects.filter
        (fun o => solfunmemeDataset.coverage o == .UNPROVEN)).map
      (fun o => o.truth.name) = ["UNRESOLVED", "ASSERTED", "ASSERTED"] := by native_decide

/-- Every object of the package that claims to be `PROVEN` has a `VALID` proof
in the package.  This is the general theorem applied to this package, so it is
not a separate finite check. -/
theorem dataset_proven_are_backed {o : DomainObject} (ho : o ∈ solfunmemeDataset.objects)
    (hp : o.truth = .PROVEN) : ∃ p ∈ solfunmemeDataset.proofsOf o, p.status = .VALID :=
  Domain.proven_has_valid_proof dataset_wellFormed ho hp

/-- The proof ledger has a line for every object. -/
theorem dataset_ledger_covers {o : DomainObject} (ho : o ∈ solfunmemeDataset.objects) :
    ∃ row ∈ solfunmemeDataset.ledgerRows, row.objectId = o.id :=
  Domain.ledger_covers_objects ho

/-- The four coverage classes account for every object. -/
theorem dataset_coverage_total :
    solfunmemeDataset.coverageReport.proven + solfunmemeDataset.coverageReport.partiallyProven
        + solfunmemeDataset.coverageReport.unproven
        + solfunmemeDataset.coverageReport.contradicted
      = solfunmemeDataset.coverageReport.objects :=
  Domain.coverageReport_total solfunmemeDataset

/-! ## The proof corpus package -/

/-- The corpus package validates too. -/
theorem corpus_wellFormed : proofCorpusDomain.WellFormed := by native_decide

/-- Its size is the size of the catalog, by construction rather than by a
recount. -/
theorem corpus_size :
    proofCorpusDomain.proofs.length = catalogProofCount ∧
      proofCorpusDomain.objects.length = catalogModuleCount ∧
      proofCorpusDomain.claims.length = catalogProofCount := by native_decide

/-- Every catalogued proof is machine-checked, and the split between the
kernel and evaluation is the split the catalog records. -/
theorem corpus_coverage :
    proofCorpusDomain.coverageReport.proofs = catalogProofCount ∧
      proofCorpusDomain.coverageReport.validProofs = catalogProofCount ∧
      proofCorpusDomain.coverageReport.machineChecked = catalogProofCount ∧
      proofCorpusDomain.coverageReport.proven = catalogModuleCount ∧
      proofCorpusDomain.coverageReport.unproven = 0 := by native_decide

/-- Kernel-checked and evaluation-checked entries account for the whole
catalog, so nothing is quietly in a third state. -/
theorem corpus_certificates :
    catalogKernelCount + catalogNativeCount = catalogProofCount := by native_decide

/-! ## Both packages survive every representation -/

/-- The dataset package decodes back out of every one of the five codecs. -/
theorem dataset_roundTrip (r : RowSyntax) (hr : r ∈ codecs) :
    decodeDomain r (encodeDomain r solfunmemeDataset) = some solfunmemeDataset :=
  decodeDomain_of_codec r hr solfunmemeDataset

/-- Any two of the five representations decode to the same package. -/
theorem dataset_cross (r r' : RowSyntax) (hr : r ∈ codecs) (hr' : r' ∈ codecs) :
    decodeDomain r (encodeDomain r solfunmemeDataset)
      = decodeDomain r' (encodeDomain r' solfunmemeDataset) :=
  decodeDomain_cross r r' hr hr' solfunmemeDataset

/-- And they carry the same canonical hash. -/
theorem dataset_hash_stable (r : RowSyntax) (hr : r ∈ codecs) :
    (decodeDomain r (encodeDomain r solfunmemeDataset)).map domainHash
      = some (domainHash solfunmemeDataset) :=
  domainHash_of_any_codec r hr solfunmemeDataset

theorem corpus_roundTrip (r : RowSyntax) (hr : r ∈ codecs) :
    decodeDomain r (encodeDomain r proofCorpusDomain) = some proofCorpusDomain :=
  decodeDomain_of_codec r hr proofCorpusDomain

theorem corpus_hash_stable (r : RowSyntax) (hr : r ∈ codecs) :
    (decodeDomain r (encodeDomain r proofCorpusDomain)).map domainHash
      = some (domainHash proofCorpusDomain) :=
  domainHash_of_any_codec r hr proofCorpusDomain

/-! ## The graph of the dataset package is traversable in both directions -/

/-- DATA → PROOF, for every object and every proof it names. -/
theorem dataset_data_to_proof {o : DomainObject} (ho : o ∈ solfunmemeDataset.objects)
    {pid : String} (hp : pid ∈ o.proofRefs) :
    ({ sourceId := o.id, kind := .PROVEN_BY, targetId := pid, note := "object.proof_refs" } :
      Relation) ∈ solfunmemeDataset.graph :=
  Domain.data_to_proof ho hp

/-- PROOF → DATA, for the same pair. -/
theorem dataset_proof_to_data {o : DomainObject} (ho : o ∈ solfunmemeDataset.objects)
    {pid : String} (hp : pid ∈ o.proofRefs) :
    ({ sourceId := pid, kind := .PROVES, targetId := o.id, note := "object.proof_refs" } :
      Relation) ∈ solfunmemeDataset.graph :=
  Domain.proof_to_data ho hp

/-- PROOF → INPUTS and back. -/
theorem dataset_proof_to_input {p : ProofRecord} (hp : p ∈ solfunmemeDataset.proofs)
    {i : String} (hi : i ∈ p.inputRefs) :
    ({ sourceId := i, kind := .INPUT_TO, targetId := p.id, note := "proof.input_refs" } :
        Relation) ∈ solfunmemeDataset.graph ∧
      ({ sourceId := p.id, kind := .DEPENDS_ON, targetId := i, note := "proof.input_refs" } :
        Relation) ∈ solfunmemeDataset.graph :=
  Domain.proof_to_input hp hi

/-- PROOF → OUTPUTS and back. -/
theorem dataset_proof_to_output {p : ProofRecord} (hp : p ∈ solfunmemeDataset.proofs)
    {o : String} (ho : o ∈ p.outputRefs) :
    ({ sourceId := o, kind := .OUTPUT_OF, targetId := p.id, note := "proof.output_refs" } :
        Relation) ∈ solfunmemeDataset.graph ∧
      ({ sourceId := p.id, kind := .DERIVES, targetId := o, note := "proof.output_refs" } :
        Relation) ∈ solfunmemeDataset.graph :=
  Domain.proof_to_output hp ho

end Solfunmeme.Domain.Data
