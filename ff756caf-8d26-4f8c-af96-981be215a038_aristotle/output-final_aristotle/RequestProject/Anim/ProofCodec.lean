import Mathlib

/-!
# The Standard Proof Codec

The formal counterpart of `web/codec/`: the canonical proof object that every
adapter (IPDL, XML, CSV, YAML, raw text) decodes into and encodes out of, and
the rules the specification states about it.

What is modelled here is the *canonical* half — the part every codec must agree
on, and therefore the part whose laws decide whether an exchange preserves
meaning:

* `Value` is a canonical value: null, booleans, integers, strings, arrays and
  objects, exactly the shapes `web/codec/canonical/serializer.js` writes.
* `canon` is canonicalisation (§16): object keys are sorted, so the *content*
  of an object, not the order its fields happened to arrive in, determines what
  is written and hence what is hashed.
* `diff` is the semantic comparator of §28, and `differ` its verdict.
* `Status`, `Lossiness`, the import rule, the export claim, the extension
  namespace, the minimum interchange profile, the transformation ledger and the
  exchange envelope are the remaining normative pieces.

The main results:

* `canon_perm` — two objects that differ only in the order of their fields
  canonicalise to the *same* value, so `serialize` is deterministic and the
  content hash is a function of the content alone (`hash_perm`);
* `canon_idem` — canonicalising twice is canonicalising once;
* `diff_nil_iff` — the comparator reports no difference exactly when the two
  canonical objects are equal, and `differ_eq_equivalent_iff` lifts that to the
  verdict, so `EQUIVALENT` can neither be claimed for objects that differ nor
  withheld from objects that do not;
* `importStatus_never_invents` — a document that could not be read is `ERROR`,
  never `INVALID`, and never inherits the status it claimed;
* `declaredLossiness_lossless_iff` — a codec claims `LOSSLESS` exactly when the
  whole semantic object survived the round trip (§9, §17, §27);
* `mem_toFields_of_mem` — unknown fields survive decoding and re-encoding, in
  the extension namespace (§30);
* `minimal_keeps_required` — the minimum interchange profile keeps everything
  §31 requires;
* `worst_eq_lossless_iff` / `mem_worst` — the ledger's overall preservation
  level is the worst step in it, not the last one (§21);
* `check_sealEnvelope` / `sealEnvelope_tamper` — a sealed envelope checks out, and a changed
  payload does not (§19).
-/

namespace Hesper.ProofCodec

open scoped Classical

/-! ## Canonical values -/

/-- A canonical value: what every codec decodes into and encodes out of. -/
inductive Value where
  | null : Value
  | bool : Bool → Value
  | int : Int → Value
  | str : String → Value
  | arr : List Value → Value
  | obj : List (String × Value) → Value
  deriving Inhabited

/-- Key order used by canonicalisation: Unicode code-point order on the key. -/
def keyLE (a b : String × Value) : Bool := decide (a.1 ≤ b.1)

mutual

/-- Canonicalise a value (§16): every object's fields are sorted by key. -/
def canon : Value → Value
  | .null => .null
  | .bool b => .bool b
  | .int n => .int n
  | .str s => .str s
  | .arr xs => .arr (canonList xs)
  | .obj kvs => .obj ((canonPairs kvs).mergeSort keyLE)

/-- `canon`, mapped over a list of values. -/
def canonList : List Value → List Value
  | [] => []
  | v :: vs => canon v :: canonList vs

/-- `canon`, mapped over the values of a field list. -/
def canonPairs : List (String × Value) → List (String × Value)
  | [] => []
  | (k, v) :: kvs => (k, canon v) :: canonPairs kvs

end

/-! ## Serialisation and content identity -/

private def escape (s : String) : String :=
  "\"" ++ (s.replace "\\" "\\\\").replace "\"" "\\\"" ++ "\""

mutual

/-- Canonical serialisation: deterministic, compact text (§16). -/
def ser : Value → String
  | .null => "null"
  | .bool b => if b then "true" else "false"
  | .int n => toString n
  | .str s => escape s
  | .arr xs => "[" ++ serList xs ++ "]"
  | .obj kvs => "{" ++ serPairs kvs ++ "}"

/-- The elements of an array, comma separated. -/
def serList : List Value → String
  | [] => ""
  | [v] => ser v
  | v :: vs => ser v ++ "," ++ serList vs

/-- The fields of an object, comma separated. -/
def serPairs : List (String × Value) → String
  | [] => ""
  | [kv] => escape kv.1 ++ ":" ++ ser kv.2
  | kv :: kvs => escape kv.1 ++ ":" ++ ser kv.2 ++ "," ++ serPairs kvs

end

/-- Canonical serialisation of a value: `CanonicalSerialize` of §16. -/
def serialize (v : Value) : String := ser (canon v)

/-- Content identity: a hash of the canonical serialisation (§16). -/
def contentId (hash : String → String) (v : Value) : String := hash (serialize v)

/-! ## The comparator (§28) -/

/-- One structured difference: where, what each side had, and of what kind. -/
structure Difference where
  path : String
  left : Value
  right : Value
  kind : String

/-- The verdicts a comparator may return. -/
inductive Verdict where
  | EQUIVALENT | DIFFERENT | CONFLICT | INCOMPARABLE | INCOMPLETE
  deriving DecidableEq, Repr

mutual

/-- The structured differences between two canonical values (§28). -/
noncomputable def diff (path : String) : Value → Value → List Difference
  | .arr xs, .arr ys => diffList path 0 xs ys
  | .obj a, .obj b => diffPairs path a b
  | x, y => if x = y then [] else [⟨path, x, y, "VALUE_MISMATCH"⟩]
termination_by x y => sizeOf x + sizeOf y

/-- Differences between two arrays, index by index. -/
noncomputable def diffList (path : String) (i : Nat) : List Value → List Value → List Difference
  | [], [] => []
  | x :: xs, [] => ⟨path ++ "[" ++ toString i ++ "]", x, .null, "MISSING_RIGHT"⟩ ::
      diffList path (i + 1) xs []  -- one side ran out
  | [], y :: ys => ⟨path ++ "[" ++ toString i ++ "]", .null, y, "MISSING_LEFT"⟩ ::
      diffList path (i + 1) [] ys
  | x :: xs, y :: ys => diff (path ++ "[" ++ toString i ++ "]") x y ++ diffList path (i + 1) xs ys
termination_by xs ys => sizeOf xs + sizeOf ys

/-- Differences between two field lists, field by field. -/
noncomputable def diffPairs (path : String) : List (String × Value) → List (String × Value) → List Difference
  | [], [] => []
  | (k, v) :: a, [] => ⟨path ++ "." ++ k, v, .null, "MISSING_RIGHT"⟩ :: diffPairs path a []
  | [], (k, v) :: b => ⟨path ++ "." ++ k, .null, v, "MISSING_LEFT"⟩ :: diffPairs path [] b
  | (k, v) :: a, (k', v') :: b =>
      if k = k' then diff (path ++ "." ++ k) v v' ++ diffPairs path a b
      else ⟨path ++ "." ++ k, v, v', "FIELD_MISMATCH"⟩ :: diffPairs path a b
termination_by a b => sizeOf a + sizeOf b

end

/-- The comparator of §28, run on the canonical forms of its two arguments. -/
noncomputable def compareValues (a b : Value) : Verdict :=
  if diff "" (canon a) (canon b) = [] then .EQUIVALENT else .DIFFERENT

/-! ## Status (§6) -/

/-- The standard status vocabulary. -/
inductive Status where
  | UNKNOWN | PENDING | VALID | INVALID | PARTIAL | ERROR | CONFLICT | UNSUPPORTED
  deriving DecidableEq, Repr

/-- The import rule of §6/§26: a document that could not be interpreted in full
carries the status `ERROR`, whatever status it declared. -/
def importStatus (declared : Status) (brokenSyntax : Bool) : Status :=
  if brokenSyntax then .ERROR else declared

/-! ## Lossiness (§9, §21) -/

/-- The preservation level a conversion declares. -/
inductive Lossiness where
  | LOSSLESS | PARTIAL | LOSSY | FAILED
  deriving DecidableEq, Repr

/-- How bad a preservation level is; `LOSSLESS` is the best. -/
def rank : Lossiness → Nat
  | .LOSSLESS => 0
  | .PARTIAL => 1
  | .LOSSY => 2
  | .FAILED => 3

/-- The worst preservation level in a ledger (§21). -/
def worst : List Lossiness → Lossiness
  | [] => .LOSSLESS
  | l :: ls => if rank l ≥ rank (worst ls) then l else worst ls

/-- A codec: text in, text out, through the canonical model. -/
structure Codec where
  encode : Value → String
  decode : String → Value

/-- The claim an export may make (§9, §27): a codec declares `LOSSLESS` only
when the complete semantic object survived the round trip. -/
noncomputable def declaredLossiness (c : Codec) (v : Value) : Lossiness :=
  if canon (c.decode (c.encode v)) = canon v then .LOSSLESS else .PARTIAL

/-! ## Fields, extensions and the minimum profile (§3, §30, §31) -/

/-- The field names the canonical model knows. -/
def knownFields : List String :=
  ["schema_version", "id", "version", "kind", "inputs", "assumptions", "parameters",
   "procedure", "intermediate", "outputs", "claims", "certificates", "errors",
   "warnings", "provenance", "metadata", "source_format", "source_data", "status"]

/-- The fields §3 requires. -/
def requiredFields : List String := ["id", "kind", "inputs", "outputs", "status"]

/-- The minimum interchange profile of §31. -/
def minimalFields : List String := ["id", "kind", "inputs", "outputs", "status", "errors", "metadata"]

/-- A decoded object: the fields the model names, and everything else. -/
structure Decoded where
  known : List (String × Value)
  extensions : List (String × Value)

/-- Decode a field list: unknown fields go to the extension namespace (§30). -/
def ofFields (fs : List (String × Value)) : Decoded :=
  ⟨fs.filter (fun kv => kv.1 ∈ knownFields), fs.filter (fun kv => kv.1 ∉ knownFields)⟩

/-- Encode a decoded object back to a field list. -/
def toFields (d : Decoded) : List (String × Value) := d.known ++ d.extensions

/-- The §31 projection of a field list. -/
def minimalProfile (fs : List (String × Value)) : List (String × Value) :=
  fs.filter (fun kv => kv.1 ∈ minimalFields)

/-! ## The ledger and the envelope (§19, §21) -/

/-- One entry of the transformation ledger (§21). -/
structure Transformation where
  operation : String
  source : String
  destination : String
  inputHash : String
  outputHash : String
  lossiness : Lossiness

/-- Append a transformation to a ledger: the record is never rewritten. -/
def record (ledger : List Transformation) (t : Transformation) : List Transformation :=
  ledger ++ [t]

/-- The chain of formats an object has passed through. -/
def chain : List Transformation → List String
  | [] => []
  | t :: ts => t.source :: t.destination :: chain ts

/-- A proof exchange envelope (§19), reduced to what its integrity block covers. -/
structure Envelope where
  payload : Value
  header : Value
  payloadHash : String
  envelopeHash : String

/-- Seal an envelope around a payload. -/
def sealEnvelope (hash : String → String) (payload header : Value) : Envelope :=
  { payload := payload, header := header,
    payloadHash := contentId hash payload,
    envelopeHash := contentId hash header }

/-- Check an envelope's integrity block against what it carries. -/
noncomputable def check (hash : String → String) (e : Envelope) : Bool :=
  decide (e.payloadHash = contentId hash e.payload ∧ e.envelopeHash = contentId hash e.header)

/-! ## Canonicalisation is deterministic -/

theorem canonList_eq_map (xs : List Value) : canonList xs = xs.map canon := by
  induction xs with
  | nil => rfl
  | cons v vs ih => simp [canonList, ih]

theorem canonPairs_eq_map (kvs : List (String × Value)) :
    canonPairs kvs = kvs.map (fun kv => (kv.1, canon kv.2)) := by
  induction kvs with
  | nil => rfl
  | cons kv kvs ih => obtain ⟨k, v⟩ := kv; simp [canonPairs, ih]

theorem canonPairs_perm {a b : List (String × Value)} (h : a.Perm b) :
    (canonPairs a).Perm (canonPairs b) := by
  simpa only [canonPairs_eq_map] using h.map _

theorem canonPairs_map_fst (kvs : List (String × Value)) :
    (canonPairs kvs).map Prod.fst = kvs.map Prod.fst := by
  simp [canonPairs_eq_map, List.map_map, Function.comp]

theorem keyLE_trans (a b c : String × Value) (hab : keyLE a b = true) (hbc : keyLE b c = true) :
    keyLE a c = true := by
  simp only [keyLE, decide_eq_true_eq] at *
  exact le_trans hab hbc

theorem keyLE_total (a b : String × Value) : (keyLE a b || keyLE b a) = true := by
  simp only [keyLE, Bool.or_eq_true, decide_eq_true_eq]
  exact le_total a.1 b.1

theorem sorted_mergeSort_keyLE (l : List (String × Value)) :
    List.Pairwise (fun a b => keyLE a b = true) (l.mergeSort keyLE) :=
  List.pairwise_mergeSort keyLE_trans keyLE_total l

/-- **Canonicalisation depends on content, not on field order.**  Two objects
whose fields are a permutation of one another — with distinct keys, as the
model requires — canonicalise to the very same value.  (§16) -/
theorem canon_perm {a b : List (String × Value)} (hp : a.Perm b)
    (hnd : (a.map Prod.fst).Nodup) : canon (.obj a) = canon (.obj b) := by
  have hpc : (canonPairs a).Perm (canonPairs b) := canonPairs_perm hp
  set A := (canonPairs a).mergeSort keyLE with hA
  set B := (canonPairs b).mergeSort keyLE with hB
  have hPA : A.Perm (canonPairs a) := List.mergeSort_perm _ _
  have hPB : B.Perm (canonPairs b) := List.mergeSort_perm _ _
  have hAB : A.Perm B := hPA.trans (hpc.trans hPB.symm)
  -- the keys of `A` are the keys of `a`, up to order, so they are distinct
  have hkeys : (A.map Prod.fst).Nodup := by
    have : (A.map Prod.fst).Perm (a.map Prod.fst) := by
      simpa only [canonPairs_map_fst] using (hPA.map Prod.fst)
    exact this.nodup_iff.2 hnd
  have hanti : ∀ x y : String × Value, x ∈ A → y ∈ B → keyLE x y = true → keyLE y x = true →
      x = y := by
    intro x y hx hy hxy hyx
    have hk : x.1 = y.1 := by
      simp only [keyLE, decide_eq_true_eq] at hxy hyx
      exact le_antisymm hxy hyx
    have hyA : y ∈ A := (hAB.mem_iff).2 hy
    exact List.inj_on_of_nodup_map hkeys hx hyA hk
  have : A = B :=
    List.Perm.eq_of_pairwise hanti (sorted_mergeSort_keyLE _) (sorted_mergeSort_keyLE _) hAB
  simp only [canon, ← hA, ← hB, this]

/-- Serialisation, and therefore the content hash, is a function of the content
alone: field order cannot change the bytes. -/
theorem serialize_perm {a b : List (String × Value)} (hp : a.Perm b)
    (hnd : (a.map Prod.fst).Nodup) : serialize (.obj a) = serialize (.obj b) := by
  simp only [serialize, canon_perm hp hnd]

theorem hash_perm (hash : String → String) {a b : List (String × Value)} (hp : a.Perm b)
    (hnd : (a.map Prod.fst).Nodup) : contentId hash (.obj a) = contentId hash (.obj b) := by
  simp only [contentId, serialize_perm hp hnd]

/-- Canonicalising a canonical value changes nothing. -/
theorem canon_idem (v : Value) : canon (canon v) = canon v := by
  refine Value.rec (motive_1 := fun v => canon (canon v) = canon v)
    (motive_2 := fun xs => ∀ w ∈ xs, canon (canon w) = canon w)
    (motive_3 := fun kvs => ∀ kv ∈ kvs, canon (canon kv.2) = canon kv.2)
    (motive_4 := fun kv => canon (canon kv.2) = canon kv.2)
    rfl (fun _ => rfl) (fun _ => rfl) (fun _ => rfl) ?_ ?_ ?_ ?_ ?_ ?_ ?_ v
  · intro xs ih
    have h : canonList (canonList xs) = canonList xs := by
      simp only [canonList_eq_map, List.map_map]
      exact List.map_congr_left (fun w hw => ih w hw)
    simp only [canon, h]
  · intro kvs ih
    have hmem : ∀ kv ∈ (canonPairs kvs).mergeSort keyLE, (kv.1, canon kv.2) = kv := by
      intro kv hkv
      have hk : kv ∈ canonPairs kvs := (List.mergeSort_perm _ _).mem_iff.1 hkv
      rw [canonPairs_eq_map, List.mem_map] at hk
      obtain ⟨w, hw, rfl⟩ := hk
      simpa using ih w hw
    have hfix : canonPairs ((canonPairs kvs).mergeSort keyLE) = (canonPairs kvs).mergeSort keyLE := by
      rw [canonPairs_eq_map]
      exact (List.map_congr_left hmem).trans (List.map_id _)
    simp only [canon, hfix,
      List.mergeSort_of_pairwise (sorted_mergeSort_keyLE (canonPairs kvs))]
  · intro w hw; cases hw
  · intro v vs ihv ihvs w hw
    rcases List.mem_cons.1 hw with rfl | hw
    · exact ihv
    · exact ihvs w hw
  · intro kv hkv; cases hkv
  · intro kv kvs ihkv ihkvs x hx
    rcases List.mem_cons.1 hx with rfl | hx
    · exact ihkv
    · exact ihkvs x hx
  · intro _ v ihv; exact ihv

/-! ## The comparator is sound and complete -/

/-- **The comparator reports no difference exactly when the values are equal.**
So `EQUIVALENT` can neither be claimed for two objects that differ, nor withheld
from two that do not.  (§28) -/
theorem diff_nil_iff (path : String) (a b : Value) : diff path a b = [] ↔ a = b := by
  revert path b
  refine Value.rec (motive_1 := fun a => ∀ path b, diff path a b = [] ↔ a = b)
    (motive_2 := fun xs => ∀ path i ys, diffList path i xs ys = [] ↔ xs = ys)
    (motive_3 := fun kvs => ∀ path b, diffPairs path kvs b = [] ↔ kvs = b)
    (motive_4 := fun kv => ∀ path b, diff path kv.2 b = [] ↔ kv.2 = b)
    ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_ a
  · intro path b; cases b <;> simp [diff]
  · intro _ path b; cases b <;> simp [diff]
  · intro _ path b; cases b <;> simp [diff]
  · intro _ path b; cases b <;> simp [diff]
  · intro xs ih path b
    cases b with
    | arr ys => simpa [diff] using ih path 0 ys
    | _ => simp [diff]
  · intro kvs ih path b
    cases b with
    | obj c => simpa [diff] using ih path c
    | _ => simp [diff]
  · intro path i ys
    cases ys with
    | nil => simp [diffList]
    | cons y ys => simp [diffList]
  · intro x xs ihx ihxs path i ys
    cases ys with
    | nil => simp [diffList]
    | cons y ys =>
      rw [diffList, List.append_eq_nil_iff, ihx, ihxs]
      simp
  · intro path b
    cases b with
    | nil => simp [diffPairs]
    | cons kv b => obtain ⟨k, v⟩ := kv; simp [diffPairs]
  · intro kv kvs ihkv ihkvs path b
    obtain ⟨k, v⟩ := kv
    have ihv : ∀ p (w : Value), diff p v w = [] ↔ v = w := ihkv
    cases b with
    | nil => simp [diffPairs]
    | cons kv' b =>
      obtain ⟨k', v'⟩ := kv'
      rw [diffPairs]
      by_cases hk : k = k'
      · subst hk
        simp only [if_true, List.append_eq_nil_iff, ihv, ihkvs, Prod.mk.injEq,
          List.cons.injEq, true_and]
      · simp [hk]
  · intro _ v ihv path b; exact ihv path b

theorem diff_self (path : String) (v : Value) : diff path v v = [] :=
  (diff_nil_iff path v v).2 rfl

/-- The verdict `EQUIVALENT` is returned exactly for objects with the same
canonical form. -/
theorem compareValues_eq_equivalent_iff (a b : Value) :
    compareValues a b = .EQUIVALENT ↔ canon a = canon b := by
  rw [compareValues]
  by_cases h : canon a = canon b
  · simp [h, diff_self]
  · rw [if_neg (by simp [diff_nil_iff, h])]
    simp [h]

theorem compareValues_self (v : Value) : compareValues v v = .EQUIVALENT :=
  (compareValues_eq_equivalent_iff v v).2 rfl

/-! ## Status is never invented -/

theorem invalid_ne_error : Status.INVALID ≠ Status.ERROR := by decide

/-- A document that could not be read is `ERROR` — it does not become `INVALID`,
and it does not inherit the status it claimed. -/
theorem importStatus_broken (d : Status) : importStatus d true = .ERROR := rfl

theorem importStatus_intact (d : Status) : importStatus d false = d := rfl

/-- `VALID` is only ever reported for a document that both declared it and could
be read to the end. -/
theorem importStatus_never_invents {d : Status} {b : Bool} (h : importStatus d b = .VALID) :
    d = .VALID ∧ b = false := by
  cases b with
  | true => simp [importStatus] at h
  | false => simpa [importStatus] using h

/-! ## Lossiness claims are earned -/

/-- A codec claims `LOSSLESS` exactly when the whole canonical object survived. -/
theorem declaredLossiness_lossless_iff (c : Codec) (v : Value) :
    declaredLossiness c v = .LOSSLESS ↔ canon (c.decode (c.encode v)) = canon v := by
  unfold declaredLossiness
  by_cases h : canon (c.decode (c.encode v)) = canon v <;> simp [h]

/-- What that claim buys the reader: the comparator finds nothing to report
between what went in and what came back (§17). -/
theorem roundTrip_of_lossless {c : Codec} {v : Value}
    (h : declaredLossiness c v = .LOSSLESS) :
    diff "" (canon (c.decode (c.encode v))) (canon v) = [] := by
  rw [(declaredLossiness_lossless_iff c v).1 h]
  exact diff_self _ _

/-- The ledger's overall level is `LOSSLESS` only when every step was. -/
theorem worst_eq_lossless_iff (ls : List Lossiness) :
    worst ls = .LOSSLESS ↔ ∀ l ∈ ls, l = .LOSSLESS := by
  induction ls with
  | nil => simp [worst]
  | cons l ls ih =>
    constructor
    · intro h x hx
      rw [worst] at h
      by_cases hle : rank l ≥ rank (worst ls)
      · simp only [hle, if_pos] at h
        subst h
        have hw : worst ls = .LOSSLESS := by
          cases hws : worst ls with
          | LOSSLESS => rfl
          | PARTIAL => rw [hws] at hle; simp [rank] at hle
          | LOSSY => rw [hws] at hle; simp [rank] at hle
          | FAILED => rw [hws] at hle; simp [rank] at hle
        rcases List.mem_cons.1 hx with rfl | hx
        · rfl
        · exact (ih.1 hw) x hx
      · simp only [hle, if_false] at h
        rcases List.mem_cons.1 hx with rfl | hx
        · rw [h] at hle; simp [rank] at hle
        · exact (ih.1 h) x hx
    · intro h
      have hl : l = .LOSSLESS := h l (by simp)
      have hw : worst ls = .LOSSLESS := ih.2 (fun x hx => h x (by simp [hx]))
      rw [worst, hl, hw]
      simp

/-- And it is always a level that actually occurred (or the empty default). -/
theorem mem_worst {ls : List Lossiness} (h : ls ≠ []) : worst ls ∈ ls := by
  induction ls with
  | nil => exact absurd rfl h
  | cons l ls ih =>
    rw [worst]
    by_cases hle : rank l ≥ rank (worst ls)
    · simp [hle]
    · simp only [hle, if_false]
      rcases ls with _ | ⟨m, ms⟩
      · simp [worst, rank] at hle
      · exact List.mem_cons_of_mem _ (ih (by simp))

/-! ## Nothing is discarded -/

/-- **Unknown data survives.**  Every field of the source document — named by
the schema or not — is still there after decoding and re-encoding.  (§30) -/
theorem mem_toFields_of_mem {fs : List (String × Value)} {kv : String × Value}
    (h : kv ∈ fs) : kv ∈ toFields (ofFields fs) := by
  simp only [toFields, ofFields, List.mem_append, List.mem_filter]
  by_cases hk : kv.1 ∈ knownFields
  · exact Or.inl ⟨h, by simpa using hk⟩
  · exact Or.inr ⟨h, by simpa using hk⟩

/-- Nothing is invented either: re-encoding produces only fields of the source. -/
theorem mem_of_mem_toFields {fs : List (String × Value)} {kv : String × Value}
    (h : kv ∈ toFields (ofFields fs)) : kv ∈ fs := by
  simp only [toFields, ofFields, List.mem_append, List.mem_filter] at h
  rcases h with ⟨h, _⟩ | ⟨h, _⟩ <;> exact h

/-- An unknown field is kept in the extension namespace, not among the named
fields, so a later reader can tell them apart. -/
theorem unknown_goes_to_extensions {fs : List (String × Value)} {kv : String × Value}
    (h : kv ∈ fs) (hk : kv.1 ∉ knownFields) : kv ∈ (ofFields fs).extensions := by
  simp only [ofFields, List.mem_filter]
  exact ⟨h, by simpa using hk⟩

/-- The minimum interchange profile keeps every required field the source had. -/
theorem minimal_keeps_required {fs : List (String × Value)} {kv : String × Value}
    (h : kv ∈ fs) (hr : kv.1 ∈ requiredFields) : kv ∈ minimalProfile fs := by
  have : kv.1 ∈ minimalFields := by
    simp only [requiredFields, List.mem_cons, List.not_mem_nil, or_false] at hr
    rcases hr with h | h | h | h | h <;> simp [minimalFields, h]
  simp only [minimalProfile, List.mem_filter]
  exact ⟨h, by simpa using this⟩

theorem minimalProfile_subset (fs : List (String × Value)) :
    ∀ kv ∈ minimalProfile fs, kv ∈ fs := by
  intro kv h
  simpa only [minimalProfile, List.mem_filter] using (List.mem_filter.1 h).1

/-! ## The ledger and the envelope -/

theorem record_append (ledger : List Transformation) (t : Transformation) :
    record ledger t = ledger ++ [t] := rfl

/-- A ledger entry is never overwritten: everything recorded before is still
recorded after. -/
theorem mem_record {ledger : List Transformation} {t s : Transformation} (h : s ∈ ledger) :
    s ∈ record ledger t := by
  simp [record, h]

/-- The chain of formats grows by exactly the step that was recorded. -/
theorem chain_record (ledger : List Transformation) (t : Transformation) :
    chain (record ledger t) = chain ledger ++ [t.source, t.destination] := by
  induction ledger with
  | nil => simp [record, chain]
  | cons u us ih => simpa [record, chain] using congrArg (fun l => u.source :: u.destination :: l) ih

/-- A sealed envelope checks out. -/
theorem check_sealEnvelope (hash : String → String) (payload header : Value) :
    check hash (sealEnvelope hash payload header) = true := by
  simp [check, sealEnvelope]

/-- A changed payload does not, provided the hash separates canonical objects —
which is what a content hash is for. -/
theorem sealEnvelope_tamper {hash : String → String} {payload header payload' : Value}
    (hinj : ∀ x y : Value, contentId hash x = contentId hash y → canon x = canon y)
    (hne : canon payload' ≠ canon payload) :
    check hash { sealEnvelope hash payload header with payload := payload' } = false := by
  have hne' : contentId hash payload ≠ contentId hash payload' := fun h =>
    hne (hinj payload' payload h.symm)
  simp [check, sealEnvelope, hne']

end Hesper.ProofCodec
