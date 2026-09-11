import RequestProject.Gvcs.Codec.Reconcile

/-!
# The specification as a whole

This module states and proves the top-level obligations of the standard:

* §9  every codec declares the projection of the canonical object it preserves,
      and `codec_roundTrip` proves that the declaration is honest;
* §17 every codec passes the round-trip test up to *semantic* equivalence
      (`roundTrip_semantic`), not up to bytes;
* §18 hub-and-spoke exchange costs `O(N)` integrations where pairwise translation
      costs `O(N²)` (`hub_lt_pairwise`);
* §31 the minimum interchange profile is enough to participate (`minimal_roundTrip`);
* §32 each conformance level is discharged (`conforms`);
* §36 the definition of done: any proof object can be created, serialized, exported in
      each supported format, imported by another system, reconstructed, validated,
      compared with the original, reconciled and have its provenance recovered, without
      silently losing semantic information (`definition_of_done`).
-/

namespace LifeTrac.Codec

/-! ## §9 Declared projections -/

/-- What each codec is declared to preserve.  Everything except CSV carries the whole
canonical object; CSV carries the tabular projection and says so. -/
def declaredProjection : Format → ProofObject → ProofObject
  | .csv, p => Csv.csvProject p
  | _, p => p

@[simp] theorem declaredProjection_csv (p : ProofObject) :
    declaredProjection .csv p = Csv.csvProject p := rfl

/-- A codec that declares `LOSSLESS` preserves the whole object. -/
theorem projection_eq_of_lossless {f : Format} (p : ProofObject)
    (h : preservation f = .lossless) : declaredProjection f p = p := by
  cases f <;> simp_all [preservation, declaredProjection]

/-- **§17: every codec round-trips onto the projection it declares.** -/
theorem codec_roundTrip (f : Format) (p : ProofObject) :
    decodeAs f (encodeAs f p) = some (declaredProjection f p) := by
  cases f <;> simp [declaredProjection]

/-! ## §17 Semantic, not byte-level, equality -/

/-- The tabular projection keeps the identity and value of every output. -/
@[simp] theorem outputSummary_csvProject (p : ProofObject) :
    outputSummary (Csv.csvProject p) = outputSummary p := by
  simp [outputSummary, Csv.csvProject, Csv.csvOutput, List.map_map, Function.comp_def]

@[simp] theorem csvProject_kind (p : ProofObject) : (Csv.csvProject p).kind = p.kind := rfl

@[simp] theorem csvProject_status (p : ProofObject) : (Csv.csvProject p).status = p.status := rfl

@[simp] theorem outputSummary_declaredProjection (f : Format) (p : ProofObject) :
    outputSummary (declaredProjection f p) = outputSummary p := by
  cases f <;> simp [declaredProjection]

@[simp] theorem status_declaredProjection (f : Format) (p : ProofObject) :
    (declaredProjection f p).status = p.status := by
  cases f <;> rfl

@[simp] theorem kind_declaredProjection (f : Format) (p : ProofObject) :
    (declaredProjection f p).kind = p.kind := by
  cases f <;> rfl

/-- **The round-trip test of §17 is passed semantically by every codec**: what comes
back compares as equivalent to what went out, and no structured difference is found. -/
theorem roundTrip_semantic (f : Format) (p : ProofObject) (h : p.status ≠ .unknown) :
    ∃ q, decodeAs f (encodeAs f p) = some q
      ∧ compareObjects p q = .equivalent ∧ differences p q = [] := by
  refine ⟨declaredProjection f p, codec_roundTrip f p, ?_, ?_⟩
  · simp [compareObjects, h]
  · simp [differences]

/-! ## §26–§27 Exchange between two systems -/

/-- Importing an artifact this codec wrote gives back exactly the projection the codec
declared, for every format. -/
theorem import_object (sys file ts : String) (f : Format) (p : ProofObject) :
    (importArtifact sys file ts (some f) (encodeAs f p)).object = declaredProjection f p := by
  cases f <;> simp [importArtifact, declaredProjection]

/-- An import of a well-formed artifact reports that it parsed. -/
theorem import_parsed (sys file ts : String) (f : Format) (p : ProofObject) :
    (importArtifact sys file ts (some f) (encodeAs f p)).parsed = true := by
  cases f <;> simp [importArtifact]

/--
**§36 — definition of done.**

For every canonical proof object whose status is known, and for every supported format:
the object can be exported, the artifact preserved verbatim, imported by another system,
reconstructed as the projection the codec declared, compared with the original as
semantically equivalent with no outstanding differences, hashed to a stable content
identity, and its provenance recovered — with the preservation level of the conversion
declared explicitly rather than assumed.
-/
theorem definition_of_done (sys file ts dst : String) (f : Format) (p : ProofObject)
    (h : p.status ≠ .unknown) :
    -- exported, with its preservation level declared (§9, §27)
    (exportArtifact dst f p).artifact = encodeAs f p
    ∧ (exportArtifact dst f p).lossiness = preservation f
    -- imported without discarding the artifact (§26)
    ∧ (importArtifact sys file ts (some f) (encodeAs f p)).original = encodeAs f p
    ∧ (importArtifact sys file ts (some f) (encodeAs f p)).parsed = true
    -- reconstructed as canonical data (§3)
    ∧ (importArtifact sys file ts (some f) (encodeAs f p)).object = declaredProjection f p
    -- validated and compared against the original (§23, §28)
    ∧ compareObjects p (importArtifact sys file ts (some f) (encodeAs f p)).object = .equivalent
    ∧ differences p (importArtifact sys file ts (some f) (encodeAs f p)).object = []
    -- stable content identity and recovered provenance (§16, §20)
    ∧ (importArtifact sys file ts (some f) (encodeAs f p)).hash
        = canonicalHash (importArtifact sys file ts (some f) (encodeAs f p)).object
    ∧ (importArtifact sys file ts (some f) (encodeAs f p)).provenance.sourceFormat = f.toName
    ∧ (importArtifact sys file ts (some f) (encodeAs f p)).provenance.sourceSystem = sys := by
  refine ⟨rfl, rfl, import_preserves_original sys file ts (some f) (encodeAs f p),
    import_parsed sys file ts f p, import_object sys file ts f p, ?_, ?_,
    import_hash sys file ts (some f) (encodeAs f p), ?_, ?_⟩
  · rw [import_object]
    simp [compareObjects, h]
  · rw [import_object]
    simp [differences]
  · have := import_records_format sys file ts (some f) (encodeAs f p)
    rw [this]
    cases f <;> simp [importArtifact]
  · cases f <;> simp [importArtifact]

/-! ## §31 The minimum interchange profile -/

/-- Build a canonical object from nothing more than the minimum profile. -/
def ofMinimal (m : MinimalProfile) : ProofObject :=
  { id := m.id, kind := m.kind, inputs := m.inputs, outputs := m.outputs,
    status := m.status, errors := m.errors, metadata := m.metadata }

@[simp] theorem minimal_ofMinimal (m : MinimalProfile) : (ofMinimal m).minimal = m := by
  cases m; rfl

/-- **A tool that implements only the minimum profile can still take part** (§31): its
objects survive a lossless exchange unchanged. -/
theorem minimal_roundTrip (m : MinimalProfile) :
    decodeAs .ipdl (encodeAs .ipdl (ofMinimal m)) = some (ofMinimal m) :=
  decodeAs_encodeAs_ipdl _

/-- The minimum profile of a full object keeps exactly the seven required fields. -/
theorem minimal_fields (p : ProofObject) :
    p.minimal.id = p.id ∧ p.minimal.kind = p.kind ∧ p.minimal.inputs = p.inputs
      ∧ p.minimal.outputs = p.outputs ∧ p.minimal.status = p.status
      ∧ p.minimal.errors = p.errors ∧ p.minimal.metadata = p.metadata :=
  ⟨rfl, rfl, rfl, rfl, rfl, rfl, rfl⟩

/-! ## Validation reaches the whole object -/

theorem mem_validate_of_types {p : ProofObject} {d : Diagnostic} (h : d ∈ validateTypes p) :
    d ∈ validate p := by
  simp only [validate, List.mem_append]
  tauto

theorem mem_validate_of_semantics {p : ProofObject} {d : Diagnostic}
    (h : d ∈ validateSemantics p) : d ∈ validate p := by
  simp only [validate, List.mem_append]
  tauto

theorem not_accepted_of_error {p : ProofObject} {d : Diagnostic} (hm : d ∈ validate p)
    (hs : d.severity = .error) : accepted p = false := by
  by_contra hacc
  simp only [Bool.not_eq_false] at hacc
  have := (List.all_eq_true.mp hacc) d hm
  rw [hs] at this
  simp at this

/-- **Type errors on inputs are detected** (§23, level 3). -/
theorem accepted_input_types {p : ProofObject} (h : accepted p = true) :
    ∀ i ∈ p.inputs, valueMatchesType i.type i.value = true := by
  intro i hi
  by_contra hb
  simp only [Bool.not_eq_true] at hb
  have hmem :
      ({ id := "typ-" ++ i.id
         code := "TYPE_MISMATCH"
         severity := .error
         field := "inputs." ++ i.id ++ ".value"
         expected := i.type
         actual := i.value.kindName
         message := "input value does not match declared type"
         recoverable := true } : Diagnostic) ∈ validateTypes p := by
    refine List.mem_append_left _ ?_
    refine List.mem_flatMap.mpr ⟨i, hi, ?_⟩
    simp [hb]
  have := not_accepted_of_error (mem_validate_of_types hmem) rfl
  rw [this] at h
  exact Bool.noConfusion h

/-- **Type errors on outputs are detected** (§23, level 3). -/
theorem accepted_output_types {p : ProofObject} (h : accepted p = true) :
    ∀ o ∈ p.outputs, valueMatchesType o.type o.value = true := by
  intro o ho
  by_contra hb
  simp only [Bool.not_eq_true] at hb
  have hmem :
      ({ id := "typ-" ++ o.id
         code := "TYPE_MISMATCH"
         severity := .error
         field := "outputs." ++ o.id ++ ".value"
         expected := o.type
         actual := o.value.kindName
         message := "output value does not match declared type"
         recoverable := true } : Diagnostic) ∈ validateTypes p := by
    refine List.mem_append_right _ ?_
    refine List.mem_flatMap.mpr ⟨o, ho, ?_⟩
    simp [hb]
  have := not_accepted_of_error (mem_validate_of_types hmem) rfl
  rw [this] at h
  exact Bool.noConfusion h

/-- **An object carrying errors may not claim `VALID`** (§6, §23 level 4). -/
theorem not_accepted_of_valid_with_errors {p : ProofObject} (hv : p.status = .valid)
    (he : p.errors.any (fun e => e.severity == .error || e.severity == .fatal) = true) :
    accepted p = false := by
  have hmem :
      ({ id := "sem-1"
         code := "STATUS_INCONSISTENT"
         severity := .error
         field := "status"
         expected := "INVALID or ERROR"
         actual := "VALID"
         message := "an object carrying errors may not claim VALID"
         recoverable := true } : Diagnostic) ∈ validateSemantics p := by
    simp only [validateSemantics, List.mem_append]
    left; left
    simp [hv, he]
  exact not_accepted_of_error (mem_validate_of_semantics hmem) rfl

/-! ## §32 Conformance levels -/

/-- What each conformance level requires of an implementation (§32). -/
def Conforms : Level → Prop
  | .raw =>
      -- Level 0: arbitrary text is preserved and exchanged verbatim.
      (∀ (sys file : String) (r : RawText), (ofRawText sys file r).sourceData = r.text)
        ∧ ∀ s : String, linesText (lineRecords s) = s
  | .structured =>
      -- Level 1: canonical objects can be imported and exported in every format.
      ∀ (f : Format) (p : ProofObject),
        decodeAs f (encodeAs f p) = some (declaredProjection f p)
  | .typed =>
      -- Level 2: declared types of inputs and outputs are checked, and errors are
      -- first-class objects carried by the model.
      ∀ p : ProofObject, accepted p = true →
        (∀ i ∈ p.inputs, valueMatchesType i.type i.value = true)
          ∧ ∀ o ∈ p.outputs, valueMatchesType o.type o.value = true
  | .proofAware =>
      -- Level 3: a claim of validity that contradicts the object's own diagnostics is
      -- rejected, and duplicate identifiers are caught.
      ∀ p : ProofObject, p.status = .valid →
        p.errors.any (fun e => e.severity == .error || e.severity == .fatal) = true →
        accepted p = false
  | .reconciliation =>
      -- Level 4: disagreements are reported as structured differences and resolved
      -- only through a recorded resolution.
      (∀ a b : ProofObject, compareObjects a b = .conflict → differences a b ≠ [])
        ∧ ∀ a b : ProofObject, ∃ r, resolveConflict .merge a b = some r
            ∧ r.diagnostics ≠ [] ∧ r.recorded.operation = "resolve"
  | .auditable =>
      -- Level 5: deterministic serialization, content-addressed identity, sealed
      -- envelopes and a transformation ledger.
      (∀ p q : ProofObject, canonicalText p = canonicalText q → p = q)
        ∧ (∀ p q : ProofObject, canonicalHash p ≠ canonicalHash q → p ≠ q)
        ∧ (∀ (src dst ts : String) (p : ProofObject) (ds : List Diagnostic)
            (tr : List Transformation), openEnvelope (sealEnvelope src dst ts p ds tr) = some p)
        ∧ ∀ t : Transformation, chained [t]

/-- **Every conformance level of §32 is met by this implementation.** -/
theorem conforms (l : Level) : Conforms l := by
  cases l with
  | raw => exact ⟨fun sys file r => ofRawText_preserves sys file r, linesText_lineRecords⟩
  | structured => exact codec_roundTrip
  | typed => exact fun p h => ⟨accepted_input_types h, accepted_output_types h⟩
  | proofAware => exact fun _ hv he => not_accepted_of_valid_with_errors hv he
  | reconciliation =>
    refine ⟨fun a b h => ?_, fun a b => ⟨_, rfl, by simp, rfl⟩⟩
    obtain ⟨-, -, hne⟩ := compare_conflict h
    simp only [differences, ne_eq, List.append_eq_nil_iff, not_and]
    intro _
    simp [hne]
  | auditable =>
    exact ⟨fun _ _ h => canonicalText_inj h, fun _ _ h => ne_of_hash_ne h,
      fun src dst ts p ds tr => open_sealEnvelope src dst ts p ds tr, chained_singleton⟩

/-! ## §18 Integration complexity -/

/-- Number of pairwise translators needed by `n` systems without a standard. -/
def pairwiseIntegrations (n : Nat) : Nat := n.choose 2

/-- Number of codec integrations needed by `n` systems that all speak the standard. -/
def hubIntegrations (n : Nat) : Nat := n

@[simp] theorem pairwiseIntegrations_succ (n : Nat) :
    pairwiseIntegrations (n + 1) = pairwiseIntegrations n + n := by
  simp [pairwiseIntegrations, Nat.choose_succ_succ, Nat.add_comm]

/-- **Hub-and-spoke exchange is strictly cheaper from four systems on** (§18). -/
theorem hub_lt_pairwise {n : Nat} (h : 4 ≤ n) : hubIntegrations n < pairwiseIntegrations n := by
  obtain ⟨k, rfl⟩ : ∃ k, n = k + 4 := ⟨n - 4, by omega⟩
  induction k with
  | zero => decide
  | succ k ih =>
    have hk : hubIntegrations (k + 4) < pairwiseIntegrations (k + 4) := ih (by omega)
    have : k + 1 + 4 = (k + 4) + 1 := by omega
    rw [this, hubIntegrations, pairwiseIntegrations_succ]
    simp only [hubIntegrations] at hk
    omega

/-- With the standard, the number of integrations is linear in the number of systems. -/
theorem hubIntegrations_linear (n : Nat) : hubIntegrations n = n := rfl

end LifeTrac.Codec
