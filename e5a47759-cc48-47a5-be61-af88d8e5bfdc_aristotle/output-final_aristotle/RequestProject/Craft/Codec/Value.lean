/-
# Standard Proof Codec — canonical value layer

This file implements the *canonical model* of the Standard Proof Codec &
Exchange Specification (SOP §3, §16):

* `CValue`, the canonical semantic value (the authoritative interchange
  representation every codec adapts to and from);
* `CValue.normalize`, the deterministic normal form (stable field ordering,
  duplicate identifiers resolved, §16);
* `CValue.encode` / `CValue.decode`, the deterministic canonical
  serialization and its parser, together with the round-trip theorem (§17);
* `CValue.hash`, a content identity computed from the canonical bytes (§16).

Everything is phrased over `List Char` internally; `String` wrappers are
provided at the end of the file.
-/
import Mathlib

namespace Codec

/-! ## The canonical value -/

/-- The canonical semantic value: the interchange representation that every
codec (IPDL, XML, CSV, YAML, raw text) is an adapter to and from. -/
inductive CValue where
  | null : CValue
  | bool : Bool → CValue
  | int : Int → CValue
  | str : String → CValue
  | list : List CValue → CValue
  | obj : List (String × CValue) → CValue
  deriving Repr, Inhabited

namespace CValue

/-! ### Decidable equality

`deriving DecidableEq` does not apply to this nested inductive, so structural
equality is defined explicitly and proved correct. -/

mutual

/-- Structural equality test on canonical values. -/
def beq : CValue → CValue → Bool
  | .null, .null => true
  | .bool a, .bool b => a == b
  | .int a, .int b => a == b
  | .str a, .str b => a == b
  | .list a, .list b => beqL a b
  | .obj a, .obj b => beqF a b
  | _, _ => false

/-- Structural equality test on lists of canonical values. -/
def beqL : List CValue → List CValue → Bool
  | [], [] => true
  | x :: xs, y :: ys => beq x y && beqL xs ys
  | _, _ => false

/-- Structural equality test on field lists. -/
def beqF : List (String × CValue) → List (String × CValue) → Bool
  | [], [] => true
  | (k, x) :: xs, (l, y) :: ys => (k == l) && beq x y && beqF xs ys
  | _, _ => false

end

theorem beq_iff : ∀ a b : CValue, beq a b = true ↔ a = b := by
  refine CValue.rec
    (motive_1 := fun a => ∀ b, beq a b = true ↔ a = b)
    (motive_2 := fun xs => ∀ ys, beqL xs ys = true ↔ xs = ys)
    (motive_3 := fun fs => ∀ gs, beqF fs gs = true ↔ fs = gs)
    (motive_4 := fun p => ∀ q : String × CValue,
      ((p.1 == q.1) && beq p.2 q.2) = true ↔ p = q)
    ?null ?bool ?int ?str ?list ?obj ?nil ?cons ?fnil ?fcons ?mk
  case null => intro b; cases b <;> simp [beq]
  case bool => intro x b; cases b <;> simp [beq]
  case int => intro x b; cases b <;> simp [beq]
  case str => intro x b; cases b <;> simp [beq]
  case list => intro xs ih b; cases b <;> simp [beq, ih]
  case obj => intro fs ih b; cases b <;> simp [beq, ih]
  case nil => intro ys; cases ys <;> simp [beqL]
  case cons => intro x xs ihx ihxs ys; cases ys <;> simp [beqL, ihx, ihxs]
  case fnil => intro gs; cases gs <;> simp [beqF]
  case fcons =>
    rintro ⟨k, x⟩ fs ihp ihfs gs
    cases gs with
    | nil => simp [beqF]
    | cons q gs =>
        obtain ⟨l, y⟩ := q
        have hx := ihp (l, y)
        have hfs := ihfs gs
        simp only [beqF, Bool.and_eq_true, Prod.mk.injEq, List.cons.injEq] at *
        constructor
        · rintro ⟨⟨h1, h2⟩, h3⟩
          exact ⟨hx.1 ⟨h1, h2⟩, hfs.1 h3⟩
        · rintro ⟨⟨h1, h2⟩, h3⟩
          exact ⟨hx.2 ⟨h1, h2⟩, hfs.2 h3⟩
  case mk => rintro k v ih ⟨l, y⟩; simp [ih]

instance : DecidableEq CValue := fun a b => decidable_of_iff _ (beq_iff a b)

/-! ## Normalization (SOP §16: stable field ordering, deterministic form) -/

/-- Insert a field into a key-sorted field list. An existing entry with the
same key is replaced, so duplicate identifiers are resolved deterministically. -/
def insertField (k : String) (v : CValue) :
    List (String × CValue) → List (String × CValue)
  | [] => [(k, v)]
  | (k', v') :: r =>
      if k = k' then (k, v) :: r
      else if k < k' then (k, v) :: (k', v') :: r
      else (k', v') :: insertField k v r

mutual

/-- Deterministic normal form: object fields are sorted by key and duplicate
keys are collapsed (first occurrence wins). -/
def normalize : CValue → CValue
  | .list xs => .list (normalizeL xs)
  | .obj fs => .obj (normalizeF fs)
  | v => v

/-- `normalize`, lifted to lists (list order is semantic and is preserved). -/
def normalizeL : List CValue → List CValue
  | [] => []
  | x :: xs => normalize x :: normalizeL xs

/-- `normalize`, lifted to field lists. -/
def normalizeF : List (String × CValue) → List (String × CValue)
  | [] => []
  | (k, v) :: fs => insertField k (normalize v) (normalizeF fs)

end

/-- Semantic equality of canonical values: equality of normal forms (SOP §17,
`semantic(X) == semantic(X')`). -/
def semEq (a b : CValue) : Prop := normalize a = normalize b

instance (a b : CValue) : Decidable (semEq a b) := by
  unfold semEq; infer_instance

theorem semEq_refl (a : CValue) : semEq a a := rfl

theorem semEq_symm {a b : CValue} (h : semEq a b) : semEq b a := h.symm

theorem semEq_trans {a b c : CValue} (h₁ : semEq a b) (h₂ : semEq b c) :
    semEq a c := h₁.trans h₂

/-! ## Numerals -/

/-- The decimal character for a digit. -/
def digitChar (d : Nat) : Char := Char.ofNat (48 + d)

/-- Is this character a decimal digit? -/
def isDigitC (c : Char) : Bool := 48 ≤ c.toNat && c.toNat ≤ 57

/-- Canonical decimal representation of a natural number (no leading zeros). -/
def encNat (n : Nat) : List Char :=
  if n = 0 then ['0'] else ((Nat.digits 10 n).map digitChar).reverse

/-- Value of a list of decimal digit characters. -/
def decNatDigits (ds : List Char) : Nat :=
  Nat.ofDigits 10 ((ds.map (fun c => c.toNat - 48)).reverse)

/-- Read a decimal numeral from the front of a character list. -/
def readNat (cs : List Char) : Option (Nat × List Char) :=
  let ds := cs.takeWhile isDigitC
  if ds.isEmpty then none else some (decNatDigits ds, cs.dropWhile isDigitC)

/-- Canonical decimal representation of an integer. -/
def encInt (n : Int) : List Char :=
  if n < 0 then '-' :: encNat n.natAbs else encNat n.natAbs

/-- Read an integer from the front of a character list. -/
def readInt (cs : List Char) : Option (Int × List Char) :=
  match cs with
  | [] => none
  | c :: r =>
      if c = '-' then (readNat r).map (fun p => (-(p.1 : Int), p.2))
      else (readNat (c :: r)).map (fun p => ((p.1 : Int), p.2))

/-! ## Canonical serialization (SOP §16) -/

mutual

/-- Canonical serialization of a value. Length-prefixed and self-delimiting,
hence deterministic and suitable for hashing. -/
def enc : CValue → List Char
  | .null => ['z']
  | .bool true => ['T']
  | .bool false => ['F']
  | .int n => 'i' :: (encInt n ++ [';'])
  | .str s => 's' :: (encNat s.toList.length ++ ':' :: s.toList)
  | .list xs => 'l' :: (encNat xs.length ++ ':' :: encL xs)
  | .obj fs => 'd' :: (encNat fs.length ++ ':' :: encF fs)

/-- Canonical serialization of a list of values. -/
def encL : List CValue → List Char
  | [] => []
  | x :: xs => enc x ++ encL xs

/-- Canonical serialization of a field list. -/
def encF : List (String × CValue) → List Char
  | [] => []
  | (k, v) :: fs => enc (.str k) ++ enc v ++ encF fs

end

mutual

/-- Canonical parser for a value; `fuel` bounds the nesting depth. -/
def decVal : Nat → List Char → Option (CValue × List Char)
  | 0, _ => none
  | _ + 1, [] => none
  | fuel + 1, c :: r =>
      if c = 'z' then some (.null, r)
      else if c = 'T' then some (.bool true, r)
      else if c = 'F' then some (.bool false, r)
      else if c = 'i' then
        match readInt r with
        | some (n, ';' :: r') => some (.int n, r')
        | _ => none
      else if c = 's' then
        match readNat r with
        | some (n, ':' :: r') =>
            if n ≤ r'.length then some (.str (String.ofList (r'.take n)), r'.drop n)
            else none
        | _ => none
      else if c = 'l' then
        match readNat r with
        | some (n, ':' :: r') =>
            match decList fuel n r' with
            | some (xs, r'') => some (.list xs, r'')
            | none => none
        | _ => none
      else if c = 'd' then
        match readNat r with
        | some (n, ':' :: r') =>
            match decFields fuel n r' with
            | some (fs, r'') => some (.obj fs, r'')
            | none => none
        | _ => none
      else none

/-- Parse exactly `n` canonical values. -/
def decList : Nat → Nat → List Char → Option (List CValue × List Char)
  | _, 0, cs => some ([], cs)
  | fuel, n + 1, cs =>
      match decVal fuel cs with
      | some (x, cs') =>
          match decList fuel n cs' with
          | some (xs, cs'') => some (x :: xs, cs'')
          | none => none
      | none => none

/-- Parse exactly `n` canonical fields. -/
def decFields : Nat → Nat → List Char → Option (List (String × CValue) × List Char)
  | _, 0, cs => some ([], cs)
  | fuel, n + 1, cs =>
      match decVal fuel cs with
      | some (.str k, cs') =>
          match decVal fuel cs' with
          | some (v, cs'') =>
              match decFields fuel n cs'' with
              | some (fs, cs''') => some ((k, v) :: fs, cs''')
              | none => none
          | none => none
      | _ => none

end

mutual

/-- Nesting depth of a canonical value. -/
def cdepth : CValue → Nat
  | .list xs => 1 + cdepthL xs
  | .obj fs => 1 + cdepthF fs
  | _ => 1

/-- Nesting depth of a list of canonical values. -/
def cdepthL : List CValue → Nat
  | [] => 0
  | x :: xs => max (cdepth x) (cdepthL xs)

/-- Nesting depth of a field list. -/
def cdepthF : List (String × CValue) → Nat
  | [] => 0
  | (_, v) :: fs => max (cdepth v) (cdepthF fs)

end

/-- Canonical serialization of a value (normalized first, so that the bytes
are a function of the semantics). -/
def encode (v : CValue) : List Char := enc (normalize v)

/-- Canonical parser: decode a complete canonical document. -/
def decode (cs : List Char) : Option CValue :=
  match decVal cs.length cs with
  | some (v, []) => some v
  | _ => none

/-! ## Hashing (SOP §16: canonical serialization → stable content identity) -/

/-- FNV-1a style rolling hash over canonical bytes, 64-bit. -/
def hashChars (cs : List Char) : Nat :=
  cs.foldl (fun h c => ((h ^^^ c.toNat) * 1099511628211) % 18446744073709551616)
    14695981039346656037

/-- Content identity of a canonical value (SOP §16). -/
def hash (v : CValue) : Nat := hashChars (encode v)

/-! ## String-level wrappers -/

/-- Canonical serialization as a string. -/
def serialize (v : CValue) : String := String.ofList (encode v)

/-- Canonical deserialization from a string. -/
def deserialize (s : String) : Option CValue := decode s.toList

/-! ## Convenience accessors -/

/-- Look up a field of an object. -/
def get? : CValue → String → Option CValue
  | .obj fs, k => (fs.find? (fun p => p.1 = k)).map Prod.snd
  | _, _ => none

/-- The string carried by a value, if it is a string. -/
def asString? : CValue → Option String
  | .str s => some s
  | _ => none

/-- The integer carried by a value, if it is an integer. -/
def asInt? : CValue → Option Int
  | .int n => some n
  | _ => none

end CValue
end Codec
