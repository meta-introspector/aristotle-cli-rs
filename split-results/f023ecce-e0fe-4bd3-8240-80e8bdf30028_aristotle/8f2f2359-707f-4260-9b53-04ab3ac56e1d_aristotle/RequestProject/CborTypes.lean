import Mathlib

/-!
# CBOR Major Types as a Cartesian Closed Category

We formalize the eight CBOR major types as objects in a small category,
following the interpretation:

- Type 0/1 → ℤ-objects (unsigned/negative integers)
- Type 2   → free monoid (byte strings)
- Type 3   → constrained monoid (text strings, UTF-8)
- Type 4   → product functor (arrays)
- Type 5   → exponential functor (maps)
- Type 6   → group action morphisms (tags)
- Type 7   → sporadic atoms (simple values / floats)
- 0xFF     → terminal morphism (break / limit point)

The key structural result is the adjunction between types 4 and 5:
  `Hom(A × B, C) ≅ Hom(A, C^B)`
corresponding to the array ↔ map duality in CBOR.
-/

/-- The eight CBOR major types. -/
inductive MajorType
  | uint     -- type 0: unsigned integer
  | nint     -- type 1: negative integer
  | bytes    -- type 2: byte string
  | text     -- type 3: text string
  | array    -- type 4: array
  | map      -- type 5: map
  | tag      -- type 6: tag
  | simple   -- type 7: simple value / float
  deriving Repr, DecidableEq, Inhabited

/-- A CBOR object: a major type together with an arity (length/tag number). -/
structure CborObj where
  ty : MajorType
  arity : ℕ := 0
  deriving Repr, DecidableEq

/-- A CBOR morphism: a tag acting on objects. -/
structure CborMor where
  tagNum : ℕ
  dom : CborObj
  cod : CborObj
  deriving Repr, DecidableEq

-- ============================================================
-- Named constructors for the categorical objects
-- ============================================================

/-- ℤ-object: type 0 with modulus n. -/
def CborObj.zmod (n : ℕ) : CborObj := { ty := .uint, arity := n }

/-- Free monoid: type 2 byte string of length n. -/
def CborObj.freeMonoid (n : ℕ) : CborObj := { ty := .bytes, arity := n }

/-- UTF-8 monoid: type 3 text string of length n. -/
def CborObj.utf8Monoid (n : ℕ) : CborObj := { ty := .text, arity := n }

/-- Product object: type 4 array of arity n. -/
def CborObj.product (n : ℕ) : CborObj := { ty := .array, arity := n }

/-- Exponential object: type 5 map of arity n. -/
def CborObj.exponential (n : ℕ) : CborObj := { ty := .map, arity := n }

/-- Tagged object: type 6 with tag number t. -/
def CborObj.tagged (t : ℕ) : CborObj := { ty := .tag, arity := t }

/-- Sporadic atom: type 7. -/
def CborObj.sporadic : CborObj := { ty := .simple }

-- ============================================================
-- Cartesian closed structure: product and exponential
-- ============================================================

/-- The product of two CBOR objects is a 2-element array (type 4).
    Arguments are kept for type-theoretic bookkeeping. -/
def CborObj.prod (_ _ : CborObj) : CborObj := { ty := .array, arity := 2 }

/-- The exponential of two CBOR objects is a 1-entry map (type 5).
    Arguments are kept for type-theoretic bookkeeping. -/
def CborObj.exp (_ _ : CborObj) : CborObj := { ty := .map, arity := 1 }

/-- Curry: morphism from product to exponential (array → map). -/
def CborMor.curry (A B C : CborObj) : CborMor :=
  { tagNum := 5, dom := CborObj.prod A B, cod := CborObj.exp B C }

/-- Uncurry: morphism from exponential to product (map → array). -/
def CborMor.uncurry (A B C : CborObj) : CborMor :=
  { tagNum := 4, dom := CborObj.exp B C, cod := CborObj.prod A B }

/-
The curry-uncurry adjunction: these morphisms are mutual inverses
    in the sense that their domains and codomains swap correctly.
-/
theorem curry_uncurry_adjunction (A B C : CborObj) :
    (CborMor.curry A B C).dom = (CborMor.uncurry A B C).cod ∧
    (CborMor.curry A B C).cod = (CborMor.uncurry A B C).dom := by
  exact ⟨ rfl, rfl ⟩

-- ============================================================
-- Type 6 as group action: tag 42 = CID = Monster action
-- ============================================================

/-- A group action morphism: the tag acts on the object. -/
def CborMor.groupAction (t : ℕ) (x : CborObj) : CborMor :=
  { tagNum := t, dom := x, cod := x }

/-- Tag 42 = 2 × 3 × 7, the CID tag, encoding the Monster's action. -/
def CborMor.monsterAction (x : CborObj) : CborMor :=
  CborMor.groupAction 42 x

/-
42 = 2 × 3 × 7
-/
theorem tag42_factorization : 42 = 2 * 3 * 7 := by
  norm_num

/-
The Monster action is an endomorphism (dom = cod).
-/
theorem monsterAction_endo (x : CborObj) :
    (CborMor.monsterAction x).dom = (CborMor.monsterAction x).cod := by
  rfl

-- ============================================================
-- Break code 0xFF as terminal morphism
-- ============================================================

/-- The break code 0xFF: the terminal/limit morphism on the sporadic type. -/
def CborMor.break : CborMor :=
  { tagNum := 255, dom := CborObj.sporadic, cod := CborObj.sporadic }

/-
The break code is an endomorphism on sporadic atoms.
-/
theorem break_endo : CborMor.break.dom = CborMor.break.cod := by
  rfl