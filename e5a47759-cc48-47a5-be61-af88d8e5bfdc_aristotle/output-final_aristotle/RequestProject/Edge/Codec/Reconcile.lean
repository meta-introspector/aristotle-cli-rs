/-
# Reconciliation between systems

Two systems, two canonical objects.  §28 asks for a semantic comparator
that produces a verdict and structured differences rather than a boolean,
and §29 forbids silently merging a conflict away.

```text
Canonical A
      ↕
Semantic Comparator
      ↕
Canonical B
```

Comparison is *semantic*: it is done on the canonical forms, so field
order and numeric spelling do not count as differences.  That is what
makes §17 a statement about meaning rather than about bytes.
-/
import RequestProject.Edge.Codec.Validate

namespace CfDeploy
namespace Codec
namespace Reconcile

/-! ## Verdicts -/

/-- The comparator's verdict (§28). -/
inductive Verdict where
  | equivalent
  | different
  | conflict
  | incomparable
  | incomplete
  deriving DecidableEq, Repr, Inhabited

def Verdict.name : Verdict → String
  | .equivalent => "EQUIVALENT"
  | .different => "DIFFERENT"
  | .conflict => "CONFLICT"
  | .incomparable => "INCOMPARABLE"
  | .incomplete => "INCOMPLETE"

/-! ## Differences -/

/-- A structured difference, as §28 requires: where, what, how bad. -/
structure Difference where
  path : String
  left : CVal
  right : CVal
  type : String
  severity : Severity
  explanation : String
  deriving Repr, Inhabited

def Difference.toVal (d : Difference) : CVal :=
  .obj [ ("explanation", .str d.explanation), ("left", d.left), ("path", .str d.path)
       , ("right", d.right), ("severity", .str d.severity.toString)
       , ("type", .str d.type) ]

private def valueMismatch (path : String) (a b : CVal) : Difference :=
  { path := path, left := a, right := b, type := "VALUE_MISMATCH", severity := .error
  , explanation := "the two systems produced different values at this path" }

private def missingRight (path : String) (a : CVal) : Difference :=
  { path := path, left := a, right := .null, type := "MISSING_RIGHT", severity := .error
  , explanation := "the right object has nothing at this path" }

private def missingLeft (path : String) (b : CVal) : Difference :=
  { path := path, left := .null, right := b, type := "MISSING_LEFT", severity := .error
  , explanation := "the left object has nothing at this path" }

/-! ## The comparator -/

mutual

/-- Every place where two values differ. -/
def diff (path : String) (a b : CVal) : List Difference :=
  match a, b with
  | .list xs, .list ys => diffItems path 0 xs ys
  | .obj fs, .obj gs => diffFields path fs gs
  | x, y => if x = y then [] else [valueMismatch path x y]

def diffItems (path : String) (i : Nat) : List CVal → List CVal → List Difference
  | [], [] => []
  | x :: xs, y :: ys =>
      diff (path ++ "[" ++ Parse.intStr i ++ "]") x y ++ diffItems path (i + 1) xs ys
  | x :: _, [] => [missingRight (path ++ "[" ++ Parse.intStr i ++ "]") x]
  | [], y :: _ => [missingLeft (path ++ "[" ++ Parse.intStr i ++ "]") y]

def diffFields (path : String) :
    List (String × CVal) → List (String × CVal) → List Difference
  | [], [] => []
  | (k, v) :: fs, (k', w) :: gs =>
      (if k = k' then diff (path ++ "." ++ k) v w
       else [{ path := path ++ "." ++ k, left := v, right := w, type := "KEY_MISMATCH"
             , severity := .error
             , explanation := "the two objects have different keys at this position: "
                 ++ k ++ " vs " ++ k' }]) ++ diffFields path fs gs
  | (k, v) :: _, [] => [missingRight (path ++ "." ++ k) v]
  | [], (k, w) :: _ => [missingLeft (path ++ "." ++ k) w]

end

/-- **No differences means equal.**  The comparator is sound: if it
reports nothing, the two values really are the same. -/
theorem diff_all_nil_imp_eq :
    (∀ (path : String) (a b : CVal), diff path a b = [] → a = b) ∧
    (∀ (path : String) (fs gs : List (String × CVal)), diffFields path fs gs = [] → fs = gs) ∧
    (∀ (path : String) (i : Nat) (xs ys : List CVal), diffItems path i xs ys = [] → xs = ys) := by
  refine @diff.mutual_induct
    (fun path a b => diff path a b = [] → a = b)
    (fun path fs gs => diffFields path fs gs = [] → fs = gs)
    (fun path i xs ys => diffItems path i xs ys = [] → xs = ys)
    ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ <;> intros <;>
    simp_all [diff, diffItems, diffFields] <;>
    (try (split at * <;> simp_all)) <;>
    (try assumption) <;>
    (try (intros; simp_all)) <;>
    (try (intros; refine ⟨?_, ?_⟩ <;> simp_all))

theorem diff_nil_imp_eq {path : String} {a b : CVal} (h : diff path a b = []) : a = b :=
  diff_all_nil_imp_eq.1 path a b h

/-- **Equal values have no differences.** -/
theorem diff_all_self :
    (∀ (path : String) (a b : CVal), a = b → diff path a b = []) ∧
    (∀ (path : String) (fs gs : List (String × CVal)), fs = gs → diffFields path fs gs = []) ∧
    (∀ (path : String) (i : Nat) (xs ys : List CVal), xs = ys → diffItems path i xs ys = []) := by
  refine @diff.mutual_induct
    (fun path a b => a = b → diff path a b = [])
    (fun path fs gs => fs = gs → diffFields path fs gs = [])
    (fun path i xs ys => xs = ys → diffItems path i xs ys = [])
    ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ <;> intros <;>
    simp_all [diff, diffItems, diffFields] <;>
    (try assumption) <;>
    (try (intros; simp_all))

theorem diff_self (path : String) (v : CVal) : diff path v v = [] :=
  diff_all_self.1 path v v rfl

/-! ## Semantic equality -/

/-- Two values mean the same thing when their canonical forms agree —
field order and numeric spelling do not count. -/
def semanticEq (a b : CVal) : Bool := Canon.canon a = Canon.canon b

@[simp] theorem semanticEq_self (v : CVal) : semanticEq v v = true := by
  simp [semanticEq]

theorem semanticEq_iff {a b : CVal} : semanticEq a b = true ↔ Canon.canon a = Canon.canon b := by
  simp [semanticEq]

/-- Semantically equal objects have the same content identity, so the
comparison agrees with the hash-based one. -/
theorem cid_eq_of_semanticEq {a b : CVal} (h : semanticEq a b = true) :
    Canon.cid a = Canon.cid b :=
  Canon.cid_eq_of_canon_eq (semanticEq_iff.mp h)

/-- The differences between two objects, compared semantically. -/
def differences (a b : CVal) : List Difference := diff "$" (Canon.canon a) (Canon.canon b)

/-- **Semantically equal objects have no differences.** -/
theorem differences_nil_of_semanticEq {a b : CVal} (h : semanticEq a b = true) :
    differences a b = [] := by
  rw [differences, semanticEq_iff.mp h, diff_self]

/-- **And no differences means semantically equal.** -/
theorem semanticEq_of_differences_nil {a b : CVal} (h : differences a b = []) :
    semanticEq a b = true :=
  semanticEq_iff.mpr (diff_nil_imp_eq h)

/-! ## The verdict -/

/-- Compare two results.  `incomplete` when either side has nothing to
say; `conflict` when both sides claim to be complete and disagree;
`different` when they merely differ. -/
def verdict (a b : CVal) (aComplete bComplete : Bool) : Verdict :=
  if !aComplete || !bComplete then .incomplete
  else if semanticEq a b then .equivalent
  else if a.tag ≠ b.tag then .incomparable
  else .conflict

/-- **A result never conflicts with itself.** -/
@[simp] theorem verdict_self (v : CVal) : verdict v v true true = .equivalent := by
  simp [verdict]

/-- **A conflict is a real disagreement**: the comparator only says
`CONFLICT` when the two objects are of the same shape, both complete, and
genuinely not equal. -/
theorem verdict_conflict_imp {a b : CVal} {p q : Bool} (h : verdict a b p q = .conflict) :
    p = true ∧ q = true ∧ semanticEq a b = false ∧ a.tag = b.tag := by
  simp only [verdict] at h
  split at h
  · simp at h
  · rename_i hpq
    split at h
    · simp at h
    · rename_i heq
      split at h
      · simp at h
      · rename_i htag
        simp only [Bool.not_eq_true', Bool.or_eq_true] at hpq
        refine ⟨?_, ?_, by simpa using heq, by simpa using htag⟩ <;>
          (cases p <;> cases q <;> simp_all)

/-! ## Conflict resolution (§29) -/

/-- How a conflict was settled. -/
inductive Strategy where
  | preferSource
  | preferVerified
  | preferNewer
  | manual
  | reject
  deriving DecidableEq, Repr, Inhabited

def Strategy.name : Strategy → String
  | .preferSource => "prefer_source"
  | .preferVerified => "prefer_verified"
  | .preferNewer => "prefer_newer"
  | .manual => "manual_resolution"
  | .reject => "reject"

/-- A recorded resolution: what was compared, how it was settled, and
what came out.  A conflict is never merged away silently — either one
side is chosen, or the resolution is `reject`, and in both cases the
record says so. -/
structure Resolved where
  strategy : Strategy
  verdict : Verdict
  differences : List Difference
  left : CVal
  right : CVal
  /-- `none` for `reject`: no object is produced, and that is recorded -/
  outcome : Option CVal
  deriving Repr, Inhabited

/-- Settle a conflict.  `preferVerified` takes the side that is marked
verified, falling back to the left one; `reject` produces nothing. -/
def resolveConflict (s : Strategy) (a b : CVal) (aComplete bComplete : Bool)
    (bVerified : Bool := false) : Resolved :=
  let v := verdict a b aComplete bComplete
  let d := differences a b
  match s with
  | .preferSource => ⟨s, v, d, a, b, some a⟩
  | .preferVerified => ⟨s, v, d, a, b, some (if bVerified then b else a)⟩
  | .preferNewer => ⟨s, v, d, a, b, some b⟩
  | .manual => ⟨s, v, d, a, b, none⟩
  | .reject => ⟨s, v, d, a, b, none⟩

/-- **A resolution never invents an object.**  Whatever comes out is one
of the two inputs, or nothing at all. -/
theorem resolveConflict_outcome (s : Strategy) (a b : CVal) (p q r : Bool) :
    (resolveConflict s a b p q r).outcome = none ∨
    (resolveConflict s a b p q r).outcome = some a ∨
    (resolveConflict s a b p q r).outcome = some b := by
  cases s <;> simp [resolveConflict] <;> (try cases r) <;> simp

/-- **The resolution records what it settled.** -/
@[simp] theorem resolveConflict_records (s : Strategy) (a b : CVal) (p q r : Bool) :
    (resolveConflict s a b p q r).strategy = s ∧
    (resolveConflict s a b p q r).verdict = verdict a b p q ∧
    (resolveConflict s a b p q r).differences = differences a b ∧
    (resolveConflict s a b p q r).left = a ∧
    (resolveConflict s a b p q r).right = b := by
  cases s <;> exact ⟨rfl, rfl, rfl, rfl, rfl⟩

/-! ## §17: the round trip is semantic -/

/-- Encode with a codec and read the result back, then compare
*meanings* rather than bytes. -/
def roundTripSemantic (c : StringCodec) (v : CVal) : Bool :=
  match c.decode (c.encode v) with
  | some w => semanticEq v w
  | none => false

/-- **§17 holds for every codec that declares itself lossless.** -/
theorem roundTripSemantic_of_lossless (c : StringCodec) (h : c.lossiness = .lossless)
    (v : CVal) (hv : c.domain v = true) : roundTripSemantic c v = true := by
  simp [roundTripSemantic, c.lossless_on_domain h v hv]

end Reconcile
end Codec
end CfDeploy
