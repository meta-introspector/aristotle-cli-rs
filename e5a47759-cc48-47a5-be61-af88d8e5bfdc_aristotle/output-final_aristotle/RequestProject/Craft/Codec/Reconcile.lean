/-
# Standard Proof Codec — comparison, differences and conflict resolution
(SOP §28, §29)

When two systems produce results for the same proof, both are decoded into the
canonical model and compared there, never pairwise in their native formats.

* `diffV` computes structured `Difference` objects with a path into the value,
  and `diff_nil_iff` proves it is exactly a decision procedure for canonical
  equality: the difference list is empty precisely when the values agree.
* `compareValues` and `compareObjects` produce the standard verdicts
  `EQUIVALENT`, `DIFFERENT`, `CONFLICT`, `INCOMPARABLE`, `INCOMPLETE`.
* `resolveConflict` applies a resolution strategy and — as the specification
  demands — always records what it did; `resolution_records_everything` proves
  no resolution can be silent.
-/
import RequestProject.Craft.Codec.Model

namespace Codec

/-- Verdict of the semantic comparator (SOP §28). -/
inductive Comparison where
  | EQUIVALENT | DIFFERENT | CONFLICT | INCOMPARABLE | INCOMPLETE
  deriving Repr, DecidableEq, Inhabited

/-- A structured difference between two canonical objects (SOP §28). -/
structure Difference where
  /-- Path into the object, e.g. `outputs[0].value`. -/
  path : String
  /-- The left-hand value. -/
  left : CValue
  /-- The right-hand value. -/
  right : CValue
  /-- What kind of difference this is. -/
  type : String
  /-- How serious it is. -/
  severity : Severity
  /-- Human-readable explanation. -/
  explanation : String
  deriving Repr, DecidableEq, Inhabited

namespace Reconcile

open CValue

/-- Append an index to a path. -/
def idxPath (path : String) (i : Nat) : String := path ++ "[" ++ intText (i : Int) ++ "]"

/-- Append a field name to a path. -/
def fieldPath (path : String) (k : String) : String :=
  if path = "" then k else path ++ "." ++ k

mutual

/-- Structured difference between two canonical values. -/
def diffV (path : String) : CValue → CValue → List Difference
  | .list xs, .list ys => diffL path 0 xs ys
  | .obj fs, .obj gs => diffF path fs gs
  | a, b =>
      if a = b then []
      else [{ path := path, left := a, right := b, type := "VALUE_MISMATCH",
              severity := Severity.ERROR, explanation := "values differ" }]

/-- Structured difference between two lists, element by element. -/
def diffL (path : String) (i : Nat) : List CValue → List CValue → List Difference
  | [], [] => []
  | x :: xs, y :: ys => diffV (idxPath path i) x y ++ diffL path (i + 1) xs ys
  | xs, ys =>
      [{ path := path, left := .list xs, right := .list ys, type := "LENGTH_MISMATCH",
         severity := Severity.ERROR, explanation := "sequences have different lengths" }]

/-- Structured difference between two field lists. -/
def diffF (path : String) :
    List (String × CValue) → List (String × CValue) → List Difference
  | [], [] => []
  | (k, x) :: fs, (l, y) :: gs =>
      (if k = l then diffV (fieldPath path k) x y
       else [{ path := fieldPath path k, left := .str k, right := .str l,
               type := "FIELD_MISMATCH", severity := Severity.ERROR,
               explanation := "different fields at the same position" }]) ++
      diffF path fs gs
  | fs, gs =>
      [{ path := path, left := .obj fs, right := .obj gs, type := "SHAPE_MISMATCH",
         severity := Severity.ERROR, explanation := "objects have different fields" }]

end

/-- The difference list is empty exactly when the two values agree: the
comparator is sound and complete for canonical equality (SOP §28). -/
theorem diff_nil_iff : ∀ (a b : CValue) (path : String), diffV path a b = [] ↔ a = b := by
  refine CValue.rec
    (motive_1 := fun a => ∀ b path, diffV path a b = [] ↔ a = b)
    (motive_2 := fun xs => ∀ ys path i, diffL path i xs ys = [] ↔ xs = ys)
    (motive_3 := fun fs => ∀ gs path, diffF path fs gs = [] ↔ fs = gs)
    (motive_4 := fun p => ∀ b path, diffV path p.2 b = [] ↔ p.2 = b)
    ?null ?bool ?int ?str ?list ?obj ?nil ?cons ?fnil ?fcons ?mk
  case null => intro b path; cases b <;> simp [diffV]
  case bool => intro x b path; cases b <;> simp [diffV]
  case int => intro x b path; cases b <;> simp [diffV]
  case str => intro x b path; cases b <;> simp [diffV]
  case list =>
    intro xs ih b path
    cases b <;> simp [diffV, ih]
  case obj =>
    intro fs ih b path
    cases b <;> simp [diffV, ih]
  case nil => intro ys path i; cases ys <;> simp [diffL]
  case cons =>
    intro x xs ihx ihxs ys path i
    cases ys with
    | nil => simp [diffL]
    | cons y ys => simp [diffL, ihx, ihxs]
  case fnil => intro gs path; cases gs <;> simp [diffF]
  case fcons =>
    rintro ⟨k, x⟩ fs ihp ihfs gs path
    cases gs with
    | nil => simp [diffF]
    | cons q gs =>
        obtain ⟨l, y⟩ := q
        by_cases hkl : k = l
        · subst hkl
          simp [diffF, ihp, ihfs]
        · simp [diffF, hkl]
  case mk => rintro k v ih b path; exact ih b path

/-- Compare two canonical values after normalization. -/
def compareValues (a b : CValue) : Comparison :=
  if diffV "" (normalize a) (normalize b) = [] then Comparison.EQUIVALENT
  else Comparison.DIFFERENT

/-- The comparator answers `EQUIVALENT` exactly on semantically equal values. -/
theorem compareValues_eq_iff (a b : CValue) :
    compareValues a b = Comparison.EQUIVALENT ↔ semEq a b := by
  unfold compareValues semEq
  constructor
  · intro h
    by_cases hd : diffV "" (normalize a) (normalize b) = []
    · exact (diff_nil_iff _ _ "").mp hd
    · simp [hd] at h
  · intro h
    rw [if_pos ((diff_nil_iff _ _ "").mpr h)]

theorem compareValues_refl (a : CValue) : compareValues a a = Comparison.EQUIVALENT :=
  (compareValues_eq_iff a a).mpr (semEq_refl a)

theorem compareValues_symm (a b : CValue) :
    compareValues a b = Comparison.EQUIVALENT ↔ compareValues b a = Comparison.EQUIVALENT := by
  rw [compareValues_eq_iff, compareValues_eq_iff]
  exact ⟨semEq_symm, semEq_symm⟩

/-! ## Comparing whole proof objects -/

/-- Is this status too uninformative to compare against? -/
def incompleteStatus (s : Status) : Bool :=
  s == Status.UNKNOWN || s == Status.PENDING

/-- Compare two proof objects (SOP §28). Objects about different questions are
`INCOMPARABLE`; objects that agree are `EQUIVALENT`; two objects that both
claim validity but disagree on their outputs are in `CONFLICT`; anything else
is merely `DIFFERENT`. -/
def compareObjects (a b : ProofObject) : Comparison :=
  if a.kind ≠ b.kind then Comparison.INCOMPARABLE
  else if compareValues (Enc.encL Input.toCValue a.inputs)
      (Enc.encL Input.toCValue b.inputs) ≠ Comparison.EQUIVALENT then
    Comparison.INCOMPARABLE
  else if incompleteStatus a.status || incompleteStatus b.status then Comparison.INCOMPLETE
  else if compareValues (Enc.encL Output.toCValue a.outputs)
      (Enc.encL Output.toCValue b.outputs) = Comparison.EQUIVALENT ∧ a.status = b.status then
    Comparison.EQUIVALENT
  else if a.status = Status.VALID ∧ b.status = Status.VALID then Comparison.CONFLICT
  else Comparison.DIFFERENT

/-- A complete object compares equivalent to itself. -/
theorem compareObjects_refl (p : ProofObject) (h : incompleteStatus p.status = false) :
    compareObjects p p = Comparison.EQUIVALENT := by
  simp [compareObjects, h, compareValues_refl]

/-- Two systems that report `VALID` with different outputs are in conflict, and
the comparator says so rather than merging them (SOP §28, §29). -/
theorem compareObjects_conflict (a b : ProofObject)
    (hkind : a.kind = b.kind)
    (hin : compareValues (Enc.encL Input.toCValue a.inputs)
      (Enc.encL Input.toCValue b.inputs) = Comparison.EQUIVALENT)
    (hout : compareValues (Enc.encL Output.toCValue a.outputs)
      (Enc.encL Output.toCValue b.outputs) ≠ Comparison.EQUIVALENT)
    (hva : a.status = Status.VALID) (hvb : b.status = Status.VALID) :
    compareObjects a b = Comparison.CONFLICT := by
  simp [compareObjects, hkind, hin, hout, hva, hvb, incompleteStatus]

/-- An object whose status is `UNKNOWN` or `PENDING` cannot be judged: the
comparator reports `INCOMPLETE` rather than guessing (SOP §28). -/
theorem compareObjects_incomplete (a b : ProofObject)
    (hkind : a.kind = b.kind)
    (hin : compareValues (Enc.encL Input.toCValue a.inputs)
      (Enc.encL Input.toCValue b.inputs) = Comparison.EQUIVALENT)
    (hst : incompleteStatus a.status = true) :
    compareObjects a b = Comparison.INCOMPLETE := by
  simp [compareObjects, hkind, hin, hst]

/-- Differences between two proof objects, as structured objects (SOP §28). -/
def differences (a b : ProofObject) : List Difference :=
  diffV "" (normalize (ProofObject.toCValue a)) (normalize (ProofObject.toCValue b))

/-- There are no differences exactly when the two objects are canonically the
same. -/
theorem differences_nil_iff (a b : ProofObject) :
    differences a b = [] ↔ semEq (ProofObject.toCValue a) (ProofObject.toCValue b) := by
  unfold differences semEq
  exact diff_nil_iff _ _ ""

/-! ## Conflict resolution (SOP §29) -/

/-- Resolution strategies. -/
inductive Strategy where
  | prefer_source | prefer_verified | prefer_newer | manual_resolution | merge | reject
  deriving Repr, DecidableEq, Inhabited

/-- The record a resolution must leave behind. -/
structure Resolution where
  /-- Identifier of the resolution record. -/
  id : String
  /-- Strategy applied. -/
  strategy : Strategy
  /-- Identifier of the left object. -/
  left_id : String
  /-- Identifier of the right object. -/
  right_id : String
  /-- Verdict that triggered the resolution. -/
  verdict : Comparison
  /-- Differences that were found. -/
  differences : List Difference
  /-- Identifier of the object that was chosen, if any. -/
  chosen : Option String
  /-- Explanation. -/
  note : String
  deriving Repr, DecidableEq, Inhabited

/-- The record every resolution starts from: who was compared, what the
verdict was and what the differences were (SOP §29). -/
def baseResolution (rid : String) (s : Strategy) (a b : ProofObject)
    (verdict : Comparison) (diffs : List Difference) : Resolution :=
  { id := rid, strategy := s, left_id := a.id, right_id := b.id,
    verdict := verdict, differences := diffs, chosen := none, note := "" }

/-- The object produced by merging two conflicting results: everything of both
is kept and the result is marked `CONFLICT`, never `VALID`. -/
def mergeObjects (a b : ProofObject) : ProofObject :=
  { a with
        status := Status.CONFLICT,
        errors := a.errors ++ b.errors,
        warnings := a.warnings ++ b.warnings,
        extensions := a.extensions ++ b.extensions }

/-- Apply a resolution strategy to two objects. The result is the new canonical
object — `none` when the conflict is rejected or handed to a human — together
with the record of what was done, which is never optional (SOP §29). -/
def resolveWith (rid : String) (s : Strategy) (a b : ProofObject)
    (verdict : Comparison) (diffs : List Difference) : Option ProofObject × Resolution :=
  match s with
  | .prefer_source =>
      (some a, { baseResolution rid .prefer_source a b verdict diffs with
                    chosen := some a.id, note := "kept the source" })
  | .prefer_verified =>
      if a.status = Status.VALID ∧ b.status ≠ Status.VALID then
        (some a, { baseResolution rid .prefer_verified a b verdict diffs with
                      chosen := some a.id, note := "kept the verified result" })
      else if b.status = Status.VALID ∧ a.status ≠ Status.VALID then
        (some b, { baseResolution rid .prefer_verified a b verdict diffs with
                      chosen := some b.id, note := "kept the verified result" })
      else
        (none, { baseResolution rid .prefer_verified a b verdict diffs with
                    note := "both or neither verified; needs a human" })
  | .prefer_newer =>
      (some b, { baseResolution rid .prefer_newer a b verdict diffs with
                    chosen := some b.id, note := "kept the newer result" })
  | .manual_resolution =>
      (none, { baseResolution rid .manual_resolution a b verdict diffs with
                  note := "referred to a human" })
  | .merge =>
      (some (mergeObjects a b), { baseResolution rid .merge a b verdict diffs with
                  chosen := some (mergeObjects a b).id,
                  note := "merged, and marked CONFLICT" })
  | .reject =>
      (none, { baseResolution rid .reject a b verdict diffs with note := "rejected" })

/-- Resolve a conflict between two proof objects, comparing them first. -/
def resolveConflict (rid : String) (s : Strategy) (a b : ProofObject) :
    Option ProofObject × Resolution :=
  resolveWith rid s a b (compareObjects a b) (differences a b)

/-- Every resolution records the strategy, both inputs, the verdict and the
differences: no conflict can be resolved silently (SOP §29). -/
theorem resolveWith_records_everything (rid : String) (s : Strategy) (a b : ProofObject)
    (verdict : Comparison) (diffs : List Difference) :
    (resolveWith rid s a b verdict diffs).2.id = rid ∧
      (resolveWith rid s a b verdict diffs).2.strategy = s ∧
      (resolveWith rid s a b verdict diffs).2.left_id = a.id ∧
      (resolveWith rid s a b verdict diffs).2.right_id = b.id ∧
      (resolveWith rid s a b verdict diffs).2.verdict = verdict ∧
      (resolveWith rid s a b verdict diffs).2.differences = diffs := by
  cases s
  case prefer_verified =>
      by_cases h1 : a.status = Status.VALID ∧ b.status ≠ Status.VALID
      · simp only [resolveWith, if_pos h1]
        exact ⟨rfl, rfl, rfl, rfl, rfl, rfl⟩
      · by_cases h2 : b.status = Status.VALID ∧ a.status ≠ Status.VALID
        · simp only [resolveWith, if_neg h1, if_pos h2]
          exact ⟨rfl, rfl, rfl, rfl, rfl, rfl⟩
        · simp only [resolveWith, if_neg h1, if_neg h2]
          exact ⟨rfl, rfl, rfl, rfl, rfl, rfl⟩
  all_goals exact ⟨rfl, rfl, rfl, rfl, rfl, rfl⟩

theorem resolution_records_everything (rid : String) (s : Strategy) (a b : ProofObject) :
    (resolveConflict rid s a b).2.id = rid ∧
      (resolveConflict rid s a b).2.strategy = s ∧
      (resolveConflict rid s a b).2.left_id = a.id ∧
      (resolveConflict rid s a b).2.right_id = b.id ∧
      (resolveConflict rid s a b).2.verdict = compareObjects a b ∧
      (resolveConflict rid s a b).2.differences = differences a b :=
  resolveWith_records_everything rid s a b (compareObjects a b) (differences a b)

/-- Merging never claims agreement: a merged object is marked `CONFLICT`. -/
theorem merge_marks_conflict (rid : String) (a b : ProofObject) :
    ((resolveConflict rid Strategy.merge a b).1.map ProofObject.status) =
      some Status.CONFLICT := by
  simp [resolveConflict, resolveWith, mergeObjects]

/-- Rejecting produces no object, only a record. -/
theorem reject_produces_no_object (rid : String) (a b : ProofObject) :
    (resolveConflict rid Strategy.reject a b).1 = none := by
  simp [resolveConflict, resolveWith]

/-- `prefer_verified` keeps the verified side when exactly one side is verified. -/
theorem prefer_verified_keeps_valid (rid : String) (a b : ProofObject)
    (ha : a.status = Status.VALID) (hb : b.status ≠ Status.VALID) :
    (resolveConflict rid Strategy.prefer_verified a b).1 = some a := by
  simp [resolveConflict, resolveWith, ha, hb]

/-- `prefer_verified` refuses to choose when both sides claim validity. -/
theorem prefer_verified_refuses_double_valid (rid : String) (a b : ProofObject)
    (ha : a.status = Status.VALID) (hb : b.status = Status.VALID) :
    (resolveConflict rid Strategy.prefer_verified a b).1 = none := by
  simp [resolveConflict, resolveWith, ha, hb]

end Reconcile
end Codec
