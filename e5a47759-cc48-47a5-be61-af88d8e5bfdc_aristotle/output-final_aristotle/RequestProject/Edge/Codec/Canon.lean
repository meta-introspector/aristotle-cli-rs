/-
# Canonicalization and content identity

Two systems that mean the same thing should agree on the bytes they hash.
`canon` is the normalizer that makes that true:

* object fields are put in a fixed order (by key, stably, so repeated
  keys keep their relative order rather than being silently dropped);
* decimals are normalized — trailing zeros of the mantissa move into the
  exponent, and zero is always `0e0`;
* everything else is already canonical.

`canon` is proved idempotent (`canon_idem`), so canonicalizing an object
that arrived from another system is a no-op, and

```text
CanonicalObject → CanonicalSerialize → Hash
```

is a stable content identity: `cid` hashes the canonical serialization of
the canonical form with the same FNV-1a the deployment tool already uses
for bundle assets.
-/
import RequestProject.Edge.Codec.Value
import RequestProject.Edge.Cf.Bundle

namespace CfDeploy
namespace Codec
namespace Canon

/-! ## A total order on keys -/

/-- Lexicographic order on character lists, by code point. -/
def clLe : List Char → List Char → Bool
  | [], _ => true
  | _ :: _, [] => false
  | a :: as, b :: bs =>
      if a.toNat < b.toNat then true
      else if b.toNat < a.toNat then false
      else clLe as bs

/-- Lexicographic order on strings, by code point. -/
def strLe (s t : String) : Bool := clLe s.toList t.toList

/-- Object fields are ordered by key. -/
def keyLe (a b : String × CVal) : Bool := strLe a.1 b.1

theorem clLe_total (a b : List Char) : (clLe a b || clLe b a) = true := by
  induction a generalizing b with
  | nil => simp [clLe]
  | cons x as ih =>
      cases b with
      | nil => simp [clLe]
      | cons y bs =>
          simp only [clLe]
          by_cases h1 : x.toNat < y.toNat
          · simp [h1]
          · by_cases h2 : y.toNat < x.toNat
            · simp [h1, h2]
            · simp [h1, h2, ih bs]

theorem clLe_trans (a b c : List Char) (hab : clLe a b = true) (hbc : clLe b c = true) :
    clLe a c = true := by
  induction a generalizing b c with
  | nil => simp [clLe]
  | cons x as ih =>
      cases b with
      | nil => simp [clLe] at hab
      | cons y bs =>
          cases c with
          | nil => simp [clLe] at hbc
          | cons z cs =>
              simp only [clLe] at *
              by_cases h1 : x.toNat < y.toNat
              · by_cases h2 : y.toNat < z.toNat
                · simp only [h1, if_pos] at hab
                  have : x.toNat < z.toNat := by omega
                  simp [this]
                · by_cases h3 : z.toNat < y.toNat
                  · simp [h2, h3] at hbc
                  · have : x.toNat < z.toNat := by omega
                    simp [this]
              · by_cases h1' : y.toNat < x.toNat
                · simp [h1, h1'] at hab
                · -- x and y have the same code point
                  have hxy : x.toNat = y.toNat := by omega
                  simp only [h1, h1', if_false] at hab
                  by_cases h2 : y.toNat < z.toNat
                  · have : x.toNat < z.toNat := by omega
                    simp [this]
                  · by_cases h3 : z.toNat < y.toNat
                    · simp [h2, h3] at hbc
                    · have hxz : ¬ x.toNat < z.toNat := by omega
                      have hzx : ¬ z.toNat < x.toNat := by omega
                      simp only [h2, h3, if_false] at hbc
                      simp [hxz, hzx, ih bs cs hab hbc]

theorem keyLe_total (a b : String × CVal) : (keyLe a b || keyLe b a) = true :=
  clLe_total _ _

theorem keyLe_trans (a b c : String × CVal) (hab : keyLe a b = true) (hbc : keyLe b c = true) :
    keyLe a c = true :=
  clLe_trans _ _ _ hab hbc

/-! ## Normalized decimals -/

/-- Strip trailing zeros of a decimal mantissa into the exponent; zero is
always `0e0`. -/
def normNum (m e : Int) : Int × Int :=
  if m = 0 then (0, 0)
  else if m % 10 = 0 then normNum (m / 10) (e + 1)
  else (m, e)
termination_by m.natAbs
decreasing_by omega

/-- A decimal is normalized when it is `0e0` or its mantissa is not a
multiple of ten. -/
def NormNum (m e : Int) : Prop := (m = 0 ∧ e = 0) ∨ m % 10 ≠ 0

theorem normNum_spec (m e : Int) : NormNum (normNum m e).1 (normNum m e).2 := by
  induction m, e using normNum.induct with
  | case1 e => rw [normNum, if_pos rfl]; exact Or.inl ⟨rfl, rfl⟩
  | case2 m e h1 h2 ih => rw [normNum, if_neg h1, if_pos h2]; exact ih
  | case3 m e h1 h2 => rw [normNum, if_neg h1, if_neg h2]; exact Or.inr h2

theorem normNum_of_norm {m e : Int} (h : NormNum m e) : normNum m e = (m, e) := by
  rcases h with ⟨hm, he⟩ | hm
  · subst hm; subst he; rw [normNum, if_pos rfl]
  · have hm0 : m ≠ 0 := by intro h; subst h; simp at hm
    rw [normNum, if_neg hm0, if_neg hm]

@[simp] theorem normNum_idem (m e : Int) :
    normNum (normNum m e).1 (normNum m e).2 = normNum m e :=
  normNum_of_norm (normNum_spec m e)

/-- The value a normalized decimal denotes is unchanged: `m * 10 ^ e` is
preserved by every step of the normalization. -/
theorem normNum_value (m e : Int) (he0 : 0 ≤ e) :
    (normNum m e).1 * 10 ^ ((normNum m e).2).toNat = m * 10 ^ e.toNat := by
  induction m, e using normNum.induct with
  | case1 e => rw [normNum, if_pos rfl]; simp
  | case2 m e h1 h2 ih =>
      rw [normNum, if_neg h1, if_pos h2]
      rw [ih (by omega)]
      have hm : m / 10 * 10 = m := by omega
      have he : (e + 1).toNat = e.toNat + 1 := by omega
      rw [he, Int.pow_succ, ← Int.mul_assoc, Int.mul_right_comm, hm]
  | case3 m e h1 h2 => rw [normNum, if_neg h1, if_neg h2]

/-! ## The canonical form -/

/-- The canonical decimal value. -/
def normVal (m e : Int) : CVal := CVal.num (normNum m e).1 (normNum m e).2

mutual

/-- Put a value into canonical form. -/
def canon : CVal → CVal
  | .num m e => normVal m e
  | .list xs => .list (canonItems xs)
  | .obj fs => .obj ((canonFields fs).mergeSort keyLe)
  | v => v

def canonItems : List CVal → List CVal
  | [] => []
  | x :: xs => canon x :: canonItems xs

def canonFields : List (String × CVal) → List (String × CVal)
  | [] => []
  | (k, v) :: fs => (k, canon v) :: canonFields fs

end

theorem canonItems_eq (xs : List CVal) : canonItems xs = xs.map canon := by
  induction xs with
  | nil => rfl
  | cons x xs ih => simp [canonItems, ih]

theorem canonFields_eq (fs : List (String × CVal)) :
    canonFields fs = fs.map (fun p => (p.1, canon p.2)) := by
  induction fs with
  | nil => rfl
  | cons p fs ih => cases p; simp [canonFields, ih]

theorem canonFields_id {fs : List (String × CVal)} (h : ∀ p ∈ fs, canon p.2 = p.2) :
    canonFields fs = fs := by
  rw [canonFields_eq]
  induction fs with
  | nil => rfl
  | cons p fs ih =>
      have hp : canon p.2 = p.2 := h p (by simp)
      have : ∀ q ∈ fs, canon q.2 = q.2 := fun q hq => h q (by simp [hq])
      simp [hp, ih this]

theorem canonItems_id {xs : List CVal} (h : ∀ x ∈ xs, canon x = x) : canonItems xs = xs := by
  rw [canonItems_eq]
  induction xs with
  | nil => rfl
  | cons x xs ih =>
      have hx : canon x = x := h x (by simp)
      have : ∀ y ∈ xs, canon y = y := fun y hy => h y (by simp [hy])
      simp [hx, ih this]

/-- **Idempotence.**  Canonicalizing a canonical object changes nothing,
so the canonical form is a genuine normal form and the content hash of an
imported object equals the content hash of the object that was sent. -/
theorem canon_idem_all :
    (∀ v : CVal, canon (canon v) = canon v) ∧
    (∀ fs : List (String × CVal), ∀ p ∈ fs, canon (canon p.2) = canon p.2) ∧
    (∀ xs : List CVal, ∀ x ∈ xs, canon (canon x) = canon x) := by
  refine @canon.mutual_induct
    (fun v => canon (canon v) = canon v)
    (fun fs => ∀ p ∈ fs, canon (canon p.2) = canon p.2)
    (fun xs => ∀ x ∈ xs, canon (canon x) = canon x)
    ?_ ?_ ?_ ?_ ?_ ?_ ?_ ?_
  -- a decimal: normalization is idempotent
  · intro m e; simp [canon, normVal]
  -- a list: canonicalize the elements
  · intro xs ih
    have hxs : ∀ x ∈ canonItems xs, canon x = x := by
      intro x hx
      rw [canonItems_eq] at hx
      obtain ⟨y, hy, rfl⟩ := List.mem_map.mp hx
      exact ih y hy
    simp [canon, canonItems_id hxs]
  -- an object: canonicalize the values and sort by key
  · intro fs ih
    have hmem : ∀ p ∈ (canonFields fs).mergeSort keyLe, canon p.2 = p.2 := by
      intro p hp
      have hp' : p ∈ canonFields fs :=
        (List.mergeSort_perm (canonFields fs) keyLe).mem_iff.mp hp
      rw [canonFields_eq] at hp'
      obtain ⟨q, hq, rfl⟩ := List.mem_map.mp hp'
      exact ih q hq
    have hsorted : List.Pairwise (fun a b => keyLe a b = true)
        ((canonFields fs).mergeSort keyLe) :=
      List.pairwise_mergeSort keyLe_trans keyLe_total _
    simp only [canon, canonFields_id hmem, List.mergeSort_of_pairwise hsorted]
  -- every other value is already canonical
  · intro v h1 h2 h3
    cases v with
    | num m e => exact absurd rfl (h1 m e)
    | list xs => exact absurd rfl (h2 xs)
    | obj fs => exact absurd rfl (h3 fs)
    | _ => rfl
  · intro x hx; simp at hx
  · intro x xs ihx ihxs y hy
    rcases List.mem_cons.mp hy with rfl | hy'
    · exact ihx
    · exact ihxs y hy'
  · intro p hp; simp at hp
  · intro k v fs ihv ihfs p hp
    rcases List.mem_cons.mp hp with rfl | hp'
    · exact ihv
    · exact ihfs p hp'

theorem canon_idem (v : CVal) : canon (canon v) = canon v := canon_idem_all.1 v

/-! ## Content identity -/

/-- The canonical serialization of the canonical form: the bytes that are
hashed. -/
def canonicalString (v : CVal) : String := CVal.encode (canon v)

/-- The 64-bit FNV-1a content hash of a value — the same hash the
deployment side of this project uses for bundle assets. -/
def contentHash (v : CVal) : UInt64 :=
  Bundle.fnv1a64 (canonicalString v).toUTF8

/-- The content identifier: `cpo1-` and sixteen hex digits. -/
def cid (v : CVal) : String := "cpo1-" ++ Bundle.hex16 (contentHash v)

/-- Canonicalizing before hashing is a no-op: the identity of an object is
the identity of its canonical form. -/
@[simp] theorem cid_canon (v : CVal) : cid (canon v) = cid v := by
  simp [cid, contentHash, canonicalString, canon_idem]

/-- Objects with the same canonical form have the same identity. -/
theorem cid_eq_of_canon_eq {v w : CVal} (h : canon v = canon w) : cid v = cid w := by
  simp [cid, contentHash, canonicalString, h]

/-- Distinct canonical forms have distinct canonical serializations; the
identity can therefore only collide through the hash itself. -/
theorem canonicalString_inj {v w : CVal} (h : canonicalString v = canonicalString w) :
    canon v = canon w :=
  CVal.encode_injective h

end Canon
end Codec
end CfDeploy
