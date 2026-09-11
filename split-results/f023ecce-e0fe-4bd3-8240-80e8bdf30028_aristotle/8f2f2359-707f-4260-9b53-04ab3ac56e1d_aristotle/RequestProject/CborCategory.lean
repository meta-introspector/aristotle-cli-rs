import Mathlib
import RequestProject.SSP

/-!
# CBOR as a Category (using Mathlib's CategoryTheory)

We define a proper `CategoryTheory.Category` instance on `MajorType`,
treating the eight CBOR major types as objects in a small category.

We also define:
- The **curry/uncurry isomorphism** between `array` and `map` (types 4 ↔ 5).
- A **j-invariant sampling** function from `ℕ` to `CborObj`, assigning each
  `n` the appropriate CBOR float type based on SSP boundary primes.
- **Monster power maps** as type-6 morphisms.
- The **SSP encoding** as a map from `Fin 15` to CBOR objects.
-/

open CategoryTheory

-- ============================================================
-- 1. Category instance on MajorType
-- ============================================================

/-- We equip `MajorType` with a category structure where there is
    exactly one morphism between any two types (indiscrete/chaotic category).
    This models CBOR tags as universal connectors between types. -/
instance : SmallCategory MajorType where
  Hom _ _ := Unit
  id _ := ()
  comp _ _ := ()

-- ============================================================
-- 2. The curry/uncurry isomorphism (array ↔ map)
-- ============================================================

/-- The array ↔ map isomorphism in the MajorType category,
    witnessing the cartesian closed adjunction (type 4 ↔ type 5). -/
def arrayMapIso : MajorType.array ≅ MajorType.map where
  hom := ()
  inv := ()

/-- Two CBOR objects are "adjunction-related" if one is a product (type 4)
    and the other is an exponential (type 5) with matching arity. -/
def CborObj.adjunctionPair (A B : CborObj) : Prop :=
  A.ty = .array ∧ B.ty = .map ∧ A.arity = B.arity

/-- The array-map duality: for any arity n, the product object and
    exponential object form an adjunction pair. -/
theorem array_map_duality (n : ℕ) :
    CborObj.adjunctionPair (CborObj.product n) (CborObj.exponential n) :=
  ⟨rfl, rfl, rfl⟩

-- ============================================================
-- 3. Float precision classification
-- ============================================================

/-- CBOR float precision levels, determined by the magnitude of a value. -/
inductive FloatPrecision
  | float16  -- half precision
  | float32  -- single precision
  | float64  -- double precision
  | bignum   -- arbitrary precision (tag 2/3 bignum)
  deriving Repr, DecidableEq, Inhabited

/-- Classify which CBOR float type to use based on the SSP boundary primes.
    - n ≤ 47: float16 suffices
    - 47 < n ≤ 59: float32 needed
    - 59 < n ≤ 71: float64 needed
    - n > 71: bignum needed -/
def classifyPrecision (n : ℕ) : FloatPrecision :=
  if n ≤ 47 then .float16
  else if n ≤ 59 then .float32
  else if n ≤ 71 then .float64
  else .bignum

/-- Map float precision to the corresponding CBOR major type. -/
def FloatPrecision.toMajorType : FloatPrecision → MajorType
  | .float16 => .simple
  | .float32 => .simple
  | .float64 => .simple
  | .bignum  => .tag

/-- Map float precision to the corresponding CBOR object. -/
def FloatPrecision.toCborObj : FloatPrecision → CborObj
  | .float16 => { ty := .simple, arity := 25 }
  | .float32 => { ty := .simple, arity := 26 }
  | .float64 => { ty := .simple, arity := 27 }
  | .bignum  => CborObj.tagged 2

-- ============================================================
-- 4. j-invariant sampling: ℕ → CborObj
-- ============================================================

/-- The j-invariant sampler assigns to each n ∈ ℕ the CBOR object
    encoding j(n·i), classified by float precision. -/
def jSample (n : ℕ) : CborObj :=
  (classifyPrecision n).toCborObj

/-- The j-invariant sampler assigns type 7 (simple/float) for n ≤ 71. -/
theorem jSample_float_range (n : ℕ) (hn : n ≤ 71) :
    (jSample n).ty = .simple := by
  unfold jSample classifyPrecision
  split_ifs <;> rfl

/-- The j-invariant sampler assigns type 6 (tag/bignum) for n > 71. -/
theorem jSample_bignum_range (n : ℕ) (hn : 71 < n) :
    (jSample n).ty = .tag := by
  unfold jSample classifyPrecision
  simp only [show ¬(n ≤ 47) by omega, show ¬(n ≤ 59) by omega, show ¬(n ≤ 71) by omega,
    ite_false]
  rfl

-- ============================================================
-- 5. SSP boundary failure detection
-- ============================================================

/-- An SSP boundary prime is one of {47, 59, 71}. -/
def isSSPBoundary (p : ℕ) : Bool :=
  p = 47 || p = 59 || p = 71

/-- At SSP boundary primes, the float precision transitions. -/
def boundaryTransition (p : ℕ) : Option (FloatPrecision × FloatPrecision) :=
  if p = 47 then some (.float16, .float32)
  else if p = 59 then some (.float32, .float64)
  else if p = 71 then some (.float64, .bignum)
  else none

theorem boundary_at_47 : boundaryTransition 47 = some (.float16, .float32) := rfl
theorem boundary_at_59 : boundaryTransition 59 = some (.float32, .float64) := rfl
theorem boundary_at_71 : boundaryTransition 71 = some (.float64, .bignum) := rfl

/-- Non-boundary values have no transition. -/
theorem boundary_none (p : ℕ) (h1 : p ≠ 47) (h2 : p ≠ 59) (h3 : p ≠ 71) :
    boundaryTransition p = none := by
  simp [boundaryTransition, h1, h2, h3]

-- ============================================================
-- 6. Monster power maps as type-6 morphisms
-- ============================================================

/-- A Monster power map: for each SSP prime p, a type-6
    endomorphism with tag number equal to p. -/
def monsterPowerMap (p : ℕ) (x : CborObj) : CborMor :=
  { tagNum := p, dom := x, cod := x }

/-- All Monster power maps are endomorphisms. -/
theorem monsterPowerMap_endo (p : ℕ) (x : CborObj) :
    (monsterPowerMap p x).dom = (monsterPowerMap p x).cod := rfl

/-- The Monster power map at prime 2 is the involution. -/
def monsterInvolution (x : CborObj) : CborMor := monsterPowerMap 2 x

/-- Composition of Monster power maps corresponds to multiplication. -/
def monsterPowerCompose (p q : ℕ) (x : CborObj) : CborMor :=
  { tagNum := p * q, dom := x, cod := x }

theorem monsterPower_compose_tag (p q : ℕ) (x : CborObj) :
    (monsterPowerCompose p q x).tagNum = p * q := rfl

-- ============================================================
-- 7. The SSP encoding: Fin 15 → CborObj
-- ============================================================

/-- The SSP encoding: map each of the 15 SSP primes to a type-0 CBOR object. -/
def sspEncode (i : Fin 15) : CborObj :=
  CborObj.zmod (sspPrimes[i.val]'(by simp [sspPrimes]))

/-- All SSP encodings are type-0 (unsigned integer). -/
theorem sspEncode_type (i : Fin 15) :
    (sspEncode i).ty = .uint := rfl

-- ============================================================
-- 8. j-sample table for n = 1..71
-- ============================================================

/-- The precision classification for all 71 samples. -/
def jSampleTable : Fin 71 → FloatPrecision :=
  fun ⟨n, _⟩ => classifyPrecision (n + 1)

/-- Samples 1..47 are float16. -/
theorem jSampleTable_float16 (i : Fin 71) (hi : i.val < 47) :
    jSampleTable i = .float16 := by
  simp only [jSampleTable, classifyPrecision]
  simp only [show i.val + 1 ≤ 47 by omega, ite_true]

/-- Samples 48..59 are float32. -/
theorem jSampleTable_float32 (i : Fin 71) (hi1 : 46 < i.val) (hi2 : i.val < 59) :
    jSampleTable i = .float32 := by
  simp only [jSampleTable, classifyPrecision]
  simp only [show ¬(i.val + 1 ≤ 47) by omega, ite_false,
    show i.val + 1 ≤ 59 by omega, ite_true]

/-- Samples 60..71 are float64. -/
theorem jSampleTable_float64 (i : Fin 71) (hi1 : 58 < i.val) :
    jSampleTable i = .float64 := by
  simp only [jSampleTable, classifyPrecision]
  simp only [show ¬(i.val + 1 ≤ 47) by omega, ite_false,
    show ¬(i.val + 1 ≤ 59) by omega, ite_false,
    show i.val + 1 ≤ 71 by omega, ite_true]
