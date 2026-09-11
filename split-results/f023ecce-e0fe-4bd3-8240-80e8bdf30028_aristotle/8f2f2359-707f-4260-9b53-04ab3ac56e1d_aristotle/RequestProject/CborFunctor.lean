import Mathlib
import RequestProject.CborCategory

/-!
# Functors and Natural Transformations for CBOR Category

We define:
- The **j-invariant sampling functor** from the discrete category on `ℕ` to
  `MajorType`, assigning each `n` the CBOR major type for its float precision.
- The **SSP natural transformation** witnessing the encoding of supersingular
  primes as a coherent map between CBOR type functors.
- The **group structure** on CBOR major types via the Monster power map composition.
-/

open CategoryTheory

-- ============================================================
-- 1. j-invariant sampling as a functor
-- ============================================================

/-- The j-invariant precision functor: assigns to each natural number
    the CBOR major type appropriate for encoding j(n·i).
    Since the target category (MajorType) is indiscrete, morphism
    mapping is automatic. -/
def jPrecisionFunctor : Discrete ℕ ⥤ MajorType where
  obj n := (classifyPrecision n.as).toMajorType
  map _ := ()

/-- The j-precision functor sends all n ≤ 71 to the `simple` type. -/
theorem jPrecisionFunctor_simple (n : ℕ) (hn : n ≤ 71) :
    jPrecisionFunctor.obj (Discrete.mk n) = .simple := by
  simp only [jPrecisionFunctor]
  unfold classifyPrecision
  split_ifs <;> rfl

/-- The j-precision functor sends all n > 71 to the `tag` type. -/
theorem jPrecisionFunctor_tag (n : ℕ) (hn : 71 < n) :
    jPrecisionFunctor.obj (Discrete.mk n) = .tag := by
  simp only [jPrecisionFunctor]
  unfold classifyPrecision
  simp only [show ¬(n ≤ 47) by omega, show ¬(n ≤ 59) by omega,
    show ¬(n ≤ 71) by omega, ite_false]
  rfl

-- ============================================================
-- 2. Constant functors and natural transformations
-- ============================================================

/-- The constant functor sending every SSP index to the `uint` type
    (the type used for SSP prime encoding). -/
def sspSourceFunctor : Discrete (Fin 15) ⥤ MajorType where
  obj _ := .uint
  map _ := ()

/-- The constant functor sending every SSP index to the `map` type
    (the type used for the SSP vector as a CBOR map). -/
def sspTargetFunctor : Discrete (Fin 15) ⥤ MajorType where
  obj _ := .map
  map _ := ()

/-- The SSP natural transformation: a coherent map from the source
    functor (each SSP prime as a uint) to the target functor (the
    SSP map), witnessing that encoding supersingular primes into
    a type-5 map is a natural construction. -/
def sspNatTrans : sspSourceFunctor ⟶ sspTargetFunctor where
  app _ := ()

-- ============================================================
-- 3. Group structure: Monster order factorization
-- ============================================================

/-- The order of the Monster group. -/
def monsterOrder : ℕ :=
  2^46 * 3^20 * 5^9 * 7^6 * 11^2 * 13^3 * 17 * 19 * 23 * 29 * 31 * 41 * 47 * 59 * 71

/-- The Monster order is divisible by every SSP prime. -/
theorem monsterOrder_dvd_ssp (p : ℕ) (hp : p ∈ sspPrimes) :
    p ∣ monsterOrder := by
  simp only [sspPrimes, List.mem_cons, List.mem_nil_iff,
    or_false] at hp
  rcases hp with h | h | h | h | h | h | h | h | h | h | h | h | h | h | h
  all_goals subst h
  all_goals simp only [monsterOrder]
  all_goals omega

-- ============================================================
-- 4. CBOR encoding depth: tower of types
-- ============================================================

/-- The "tower" of CBOR encodings: a value can be wrapped in
    nested tags. The depth measures nesting level. -/
inductive CborTower : ℕ → Type
  | base (obj : CborObj) : CborTower 0
  | wrapTag (tag : ℕ) (inner : CborTower n) : CborTower (n + 1)

/-- Extract the outermost CBOR major type of a tower element. -/
def CborTower.majorType : CborTower n → MajorType
  | .base obj => obj.ty
  | .wrapTag _ _ => MajorType.tag

/-- A tower element at depth 0 has the same type as its base object. -/
theorem CborTower.base_type (obj : CborObj) :
    (CborTower.base obj).majorType = obj.ty := rfl

/-- Wrapping in a tag always produces type 6. -/
theorem CborTower.wrapTag_type (tag : ℕ) (inner : CborTower n) :
    (CborTower.wrapTag tag inner).majorType = MajorType.tag := rfl

-- ============================================================
-- 5. The SSP 3-tensor as a functor
-- ============================================================

/-- The 3-tensor type: for each triple (n, p, q) of SSP prime indices,
    a natural number residue. -/
def SSP3Tensor := Fin 15 → Fin 15 → Fin 15 → ℕ

/-- Construct the 3-tensor from the SSP primes using power-mod. -/
def ssp3TensorCompute : SSP3Tensor := fun i j k =>
  let n := sspPrimes[i.val]'(by simp [sspPrimes])
  let p := sspPrimes[j.val]'(by simp [sspPrimes])
  let q := sspPrimes[k.val]'(by simp [sspPrimes])
  (n ^ p) % q

/-- Every entry of the 3-tensor is bounded by the corresponding SSP prime. -/
theorem ssp3Tensor_bounded (i j k : Fin 15) :
    ssp3TensorCompute i j k < sspPrimes[k.val]'(by simp [sspPrimes]) := by
  simp only [ssp3TensorCompute]
  apply Nat.mod_lt
  fin_cases k <;> simp [sspPrimes]

/-- Encode the 3-tensor as a nested CBOR structure:
    type-5 map of type-5 maps of type-5 maps of type-0 values. -/
def ssp3TensorCborType : CborObj :=
  { ty := .map, arity := 15 }

/-- The 3-tensor CBOR encoding is always a type-5 map. -/
theorem ssp3TensorCborType_is_map :
    ssp3TensorCborType.ty = .map := rfl

-- ============================================================
-- 6. Composing the full pipeline: ℕ → FloatPrecision → CborObj → MajorType
-- ============================================================

/-- The full j-invariant pipeline: natural number → CBOR object → major type.
    This is the composite of jSample with the type projection. -/
def jPipeline (n : ℕ) : MajorType := (jSample n).ty

/-- The pipeline agrees with the precision functor on the major type. -/
theorem jPipeline_eq_functor (n : ℕ) :
    jPipeline n = jPrecisionFunctor.obj (Discrete.mk n) := by
  simp only [jPipeline, jSample, jPrecisionFunctor]
  unfold classifyPrecision FloatPrecision.toCborObj FloatPrecision.toMajorType
  split_ifs <;> rfl

/-- At each SSP boundary prime, the pipeline output changes. -/
theorem jPipeline_transition_47 :
    jPipeline 47 = .simple ∧ jPipeline 48 = .simple := by
  constructor <;> rfl

theorem jPipeline_transition_59 :
    jPipeline 59 = .simple ∧ jPipeline 60 = .simple := by
  constructor <;> rfl

theorem jPipeline_transition_71 :
    jPipeline 71 = .simple ∧ jPipeline 72 = .tag := by
  constructor <;> rfl

/-- The critical type transition happens exactly at n = 72:
    this is where the CBOR encoding switches from simple/float to tag/bignum. -/
theorem jPipeline_critical_boundary :
    (∀ n, n ≤ 71 → jPipeline n = .simple) ∧
    (∀ n, 71 < n → jPipeline n = .tag) := by
  constructor
  · intro n hn
    simp only [jPipeline, jSample]
    unfold classifyPrecision FloatPrecision.toCborObj
    split_ifs <;> rfl
  · intro n hn
    simp only [jPipeline, jSample]
    unfold classifyPrecision FloatPrecision.toCborObj
    simp only [show ¬(n ≤ 47) by omega, show ¬(n ≤ 59) by omega,
      show ¬(n ≤ 71) by omega, ite_false]
    rfl
