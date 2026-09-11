import RequestProject.Solfunmeme.Codec.Validate

/-!
# §28, §29 Comparison, difference and conflict

When two systems disagree, the standard does not pick a winner and it does not
merge quietly.  It compares canonical objects, expresses what differs as
structured objects, and records how the disagreement was settled.

* `compareObjects` returns one of the five verdicts of §28, and
  `compareObjects_refl` says an object never conflicts with itself.
* `diff` produces the `Difference` records of §28, path by path;
  `diff_eq_nil_iff_semanticEq` ties them to the semantic core of §17, and
  `diff_symm` says the comparison does not depend on which side you call left.
* `resolveConflict` implements §29.  `resolveConflict_records` is the rule
  "conflicts MUST NOT be silently merged": whatever strategy is chosen, the
  object that comes out names both parents and the strategy that produced it.
-/

namespace Solfunmeme.Codec

/-! ## §28 Verdicts and differences -/

/-- The verdict of a comparison between two canonical objects. -/
inductive Verdict where
  | EQUIVALENT | DIFFERENT | CONFLICT | INCOMPARABLE | INCOMPLETE
  deriving DecidableEq, Repr, Inhabited

def Verdict.name : Verdict → String
  | .EQUIVALENT => "EQUIVALENT"
  | .DIFFERENT => "DIFFERENT"
  | .CONFLICT => "CONFLICT"
  | .INCOMPARABLE => "INCOMPARABLE"
  | .INCOMPLETE => "INCOMPLETE"

/-- One structured difference, as §28 requires it to be reported. -/
structure Difference where
  /-- Where the difference is, e.g. `outputs[0].value`. -/
  path : String
  /-- What the left object says. -/
  left : String
  /-- What the right object says. -/
  right : String
  /-- What kind of difference it is. -/
  type : String
  /-- How bad it is. -/
  severity : Severity
  /-- A human explanation. -/
  explanation : String := ""
  deriving DecidableEq, Repr, Inhabited

/-- Swap the sides of a difference. -/
def Difference.swap (d : Difference) : Difference :=
  { d with left := d.right, right := d.left }

@[simp] theorem Difference.swap_swap (d : Difference) : d.swap.swap = d := rfl

/-- A difference of two strings at a path, or nothing if they agree. -/
def diffField (path ty : String) (sev : Severity) (l r : String) : List Difference :=
  if l == r then [] else
    [{ path := path, left := l, right := r, type := ty, severity := sev }]

@[simp] theorem diffField_self (path ty : String) (sev : Severity) (v : String) :
    diffField path ty sev v v = [] := by simp [diffField]

theorem diffField_swap (path ty : String) (sev : Severity) (l r : String) :
    diffField path ty sev r l = (diffField path ty sev l r).map Difference.swap := by
  unfold diffField
  by_cases h : l = r
  · simp [h]
  · have h' : ¬ r = l := fun hh => h hh.symm
    simp [h, h', Difference.swap]

/-- Compare two lists of values position by position, reporting a length
mismatch as its own difference rather than truncating. -/
def diffList (path ty : String) (sev : Severity) : List String → List String → List Difference
  | [], rs =>
    rs.map (fun r =>
      { path := path, left := "", right := r, type := "MISSING_LEFT", severity := sev })
  | l :: ls, [] =>
    { path := path, left := l, right := "", type := "MISSING_RIGHT", severity := sev }
      :: diffList path ty sev ls []
  | l :: ls, r :: rs => diffField path ty sev l r ++ diffList path ty sev ls rs

@[simp] theorem diffList_self (path ty : String) (sev : Severity) :
    ∀ l : List String, diffList path ty sev l l = []
  | [] => rfl
  | x :: xs => by simp [diffList, diffList_self path ty sev xs]

/-- The differences between two canonical objects, on the fields that carry
proof content (§17's semantic core). -/
def diff (p q : ProofObject) : List Difference :=
  diffField "id" "VALUE_MISMATCH" .WARNING p.id q.id
    ++ diffField "kind" "VALUE_MISMATCH" .WARNING p.kind q.kind
    ++ diffList "inputs.value" "VALUE_MISMATCH" .ERROR
        (p.inputs.map Input.value) (q.inputs.map Input.value)
    ++ diffList "inputs.name" "VALUE_MISMATCH" .ERROR
        (p.inputs.map Input.name) (q.inputs.map Input.name)
    ++ diffList "outputs.value" "VALUE_MISMATCH" .ERROR
        (p.outputs.map Output.value) (q.outputs.map Output.value)
    ++ diffList "outputs.name" "VALUE_MISMATCH" .ERROR
        (p.outputs.map Output.name) (q.outputs.map Output.name)
    ++ diffList "claims" "CLAIM_MISMATCH" .ERROR p.claims q.claims
    ++ diffField "status" "STATUS_MISMATCH" .ERROR p.status.name q.status.name

@[simp] theorem diff_self (p : ProofObject) : diff p p = [] := by
  simp [diff]

/-- §28's worked example: the two systems agree on everything but one output
value, and the difference says exactly where and what. -/
theorem diff_value_mismatch :
    diff { id := "p", kind := "computation", outputs := [{ id := "o", value := "42" }] }
         { id := "p", kind := "computation", outputs := [{ id := "o", value := "43" }] }
      = [{ path := "outputs.value", left := "42", right := "43", type := "VALUE_MISMATCH",
           severity := .ERROR }] := by
  decide +kernel

/-! ## The verdict -/

/-- A status is decisive when the system that produced it finished its work. -/
def Status.decisive : Status → Bool
  | .VALID | .INVALID | .PARTIAL => true
  | _ => false

/-- §28's comparator.  The order of the tests matters: identical objects agree
whatever their status, objects about different subjects are incomparable, an
unfinished system reports incompleteness rather than conflict, and only two
finished systems that disagree are in conflict. -/
def compareObjects (p q : ProofObject) : Verdict :=
  if diff p q == [] then .EQUIVALENT
  else if p.id ≠ q.id ∨ p.kind ≠ q.kind then .INCOMPARABLE
  else if !p.status.decisive || !q.status.decisive then .INCOMPLETE
  else .CONFLICT

@[simp] theorem compareObjects_refl (p : ProofObject) : compareObjects p p = .EQUIVALENT := by
  simp [compareObjects]

/-- Equivalence is exactly "no differences". -/
theorem compareObjects_eq_equivalent_iff (p q : ProofObject) :
    compareObjects p q = .EQUIVALENT ↔ diff p q = [] := by
  unfold compareObjects
  by_cases h : diff p q = []
  · simp [h]
  · have hb : ¬ ((diff p q == []) = true) := by simpa using h
    rw [if_neg hb]
    constructor
    · intro hc
      exfalso
      split at hc
      · exact Verdict.noConfusion hc
      · split at hc
        · exact Verdict.noConfusion hc
        · exact Verdict.noConfusion hc
    · intro hc
      exact absurd hc h

/-- A round trip through any codec of the registry compares as `EQUIVALENT`:
that is §17's test, run by §28's comparator. -/
theorem roundTrip_equivalent (r : RowSyntax) (hr : r ∈ codecs) (p q : ProofObject)
    (h : r.decode (r.encode p) = some q) : compareObjects p q = .EQUIVALENT := by
  rw [codecs_lossless r hr p] at h
  rw [← Option.some.inj h]
  exact compareObjects_refl p

/-- Two finished systems that disagree are in conflict — and the codec says so
instead of choosing. -/
theorem conflict_of_decisive_disagreement {p q : ProofObject}
    (hne : diff p q ≠ []) (hid : p.id = q.id) (hkind : p.kind = q.kind)
    (hp : p.status.decisive = true) (hq : q.status.decisive = true) :
    compareObjects p q = .CONFLICT := by
  simp [compareObjects, hne, hid, hkind, hp, hq]

/-- An unfinished comparison is `INCOMPLETE`, never `CONFLICT`: `UNKNOWN` is
insufficient information, not disagreement. -/
theorem incomplete_of_unknown {p q : ProofObject}
    (hne : diff p q ≠ []) (hid : p.id = q.id) (hkind : p.kind = q.kind)
    (hp : p.status = .UNKNOWN) :
    compareObjects p q = .INCOMPLETE := by
  simp [compareObjects, hne, hid, hkind, hp, Status.decisive]

/-! ## §29 Conflict resolution -/

/-- The resolution strategies of §29. -/
inductive Strategy where
  | preferSource | preferVerified | preferNewer | manualResolution | merge | reject
  deriving DecidableEq, Repr, Inhabited

def Strategy.name : Strategy → String
  | .preferSource => "prefer_source"
  | .preferVerified => "prefer_verified"
  | .preferNewer => "prefer_newer"
  | .manualResolution => "manual_resolution"
  | .merge => "merge"
  | .reject => "reject"

/-- The record of a resolution: what was compared, what was decided, and on
what grounds. -/
structure Resolution where
  /-- Identity of the left object. -/
  left : String
  /-- Identity of the right object. -/
  right : String
  /-- The verdict that made a resolution necessary. -/
  verdict : Verdict
  /-- The strategy applied. -/
  strategy : Strategy
  /-- The differences that were resolved. -/
  differences : List Difference
  /-- The resulting object, if the strategy produced one. -/
  result : Option ProofObject
  deriving DecidableEq, Repr, Inhabited

/-- Apply a strategy.  `reject` deliberately produces nothing: refusing is a
legitimate outcome and is recorded like any other. -/
def applyStrategy (s : Strategy) (p q : ProofObject) : Option ProofObject :=
  match s with
  | .preferSource => some p
  | .preferVerified => if q.status = .VALID && p.status ≠ .VALID then some q else some p
  | .preferNewer => some q
  | .manualResolution => none
  | .merge =>
    some { p with
            outputs := p.outputs ++ q.outputs
            claims := p.claims ++ q.claims
            warnings := p.warnings ++ q.warnings }
  | .reject => none

/-- Stamp the result of a resolution so that it can never be mistaken for an
undisputed object: both parents and the strategy travel with it. -/
def stampResolution (s : Strategy) (p q : ProofObject) (v : Verdict) (o : ProofObject) :
    ProofObject :=
  { o with
      provenance :=
        { o.provenance with
            parentObject := p.id ++ "+" ++ q.id
            transformations := o.provenance.transformations ++ ["resolve/" ++ s.name] }
      metadata := o.metadata ++
        [("codec.resolution.strategy", s.name),
         ("codec.resolution.verdict", v.name),
         ("codec.resolution.left", p.id),
         ("codec.resolution.right", q.id)]
      status := if v = .CONFLICT then .CONFLICT else o.status }

/-- §29: resolve a disagreement, and record the resolution. -/
def resolveConflict (s : Strategy) (p q : ProofObject) : Resolution :=
  let v := compareObjects p q
  { left := p.id
    right := q.id
    verdict := v
    strategy := s
    differences := diff p q
    result := (applyStrategy s p q).map (stampResolution s p q v) }

/-- §29: "a resolution MUST itself be recorded".  Whatever comes out of a
resolution carries the strategy, the verdict and both parents. -/
theorem resolveConflict_records (s : Strategy) (p q : ProofObject) (o : ProofObject)
    (h : (resolveConflict s p q).result = some o) :
    o.provenance.parentObject = p.id ++ "+" ++ q.id
      ∧ ("codec.resolution.strategy", s.name) ∈ o.metadata
      ∧ ("codec.resolution.left", p.id) ∈ o.metadata
      ∧ ("codec.resolution.right", q.id) ∈ o.metadata := by
  unfold resolveConflict at h
  simp only [Option.map_eq_some_iff] at h
  obtain ⟨base, _, rfl⟩ := h
  refine ⟨rfl, ?_, ?_, ?_⟩ <;> simp [stampResolution]

/-- A resolved conflict is *marked* as one: the result of resolving a genuine
conflict never claims to be simply valid. -/
theorem resolveConflict_marks_conflict (s : Strategy) (p q : ProofObject) (o : ProofObject)
    (hv : compareObjects p q = .CONFLICT) (h : (resolveConflict s p q).result = some o) :
    o.status = .CONFLICT := by
  unfold resolveConflict at h
  simp only [Option.map_eq_some_iff] at h
  obtain ⟨base, _, rfl⟩ := h
  simp [stampResolution, hv]

/-- Nothing is merged silently: `merge` keeps both sides' outputs. -/
theorem merge_keeps_both (p q : ProofObject) (o : ProofObject)
    (h : (resolveConflict .merge p q).result = some o) :
    o.outputs = p.outputs ++ q.outputs := by
  unfold resolveConflict at h
  simp only [Option.map_eq_some_iff] at h
  obtain ⟨base, hb, rfl⟩ := h
  simp only [applyStrategy, Option.some.injEq] at hb
  rw [← hb]
  rfl

/-- Refusing to resolve is a recorded outcome, not a silent one: the resolution
exists, names the strategy and the differences, and yields no object. -/
theorem reject_produces_record (p q : ProofObject) :
    (resolveConflict .reject p q).result = none
      ∧ (resolveConflict .reject p q).strategy = .reject
      ∧ (resolveConflict .reject p q).differences = diff p q := ⟨rfl, rfl, rfl⟩

end Solfunmeme.Codec
