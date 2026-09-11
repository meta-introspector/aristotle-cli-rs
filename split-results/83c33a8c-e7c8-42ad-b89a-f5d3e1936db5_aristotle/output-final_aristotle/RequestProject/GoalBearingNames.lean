/-
# Goal-Bearing Names: Obstruction Theory for Self-Description

## The commuting diagram

Every expression `e` induces two maps into `ℤ/196883ℤ`:

```
    Expression ──E──→ ℤ/196883ℤ
        │                  │
       eval               id
        │                  │
        ℕ     ──S──→ ℤ/196883ℤ
```

where `E(e) = encodeString(e) mod 196883` (syntax map) and
`S(e) = eval(e) mod 196883` (semantic map).

The **obstruction** is `Δ(e) = S(e) - E(e)` in the field `𝔽₁₉₆₈₈₃`.

- `Δ(e) = 0` → expression is **self-locating** (encode and eval agree)
- `Δ(e) ≠ 0` → a suffix of length `suffixComplexity(Δ)` closes the gap

## The metric

`ℤ/196883ℤ` is a field — there's no canonical notion of "small" gap vs
"large" gap. The right metric is **suffix length**: the minimum number
of characters the `findSuffix` solver appends to close the gap.

This gives a discrete metric `{0, 1, 2}`:
- **0** characters: gap is zero (self-locating)
- **1** character: gap is nonzero, not in surrogate range
- **2** characters: gap falls in Unicode surrogate range [55296, 57343]

## Canonicity chain

The ontology primes are not intrinsically canonical — their necessity
is inherited:

    Monster → 196883 → {47, 59, 71} → encoding space

We make this dependency explicit via a `MonsterFactorization` structure.
-/

import Mathlib
import RequestProject.Bootstrap
import RequestProject.LandingInstruction

set_option maxHeartbeats 3200000
set_option maxRecDepth 4096

namespace GoalBearingNames

open LandingInstruction

/-! ## §1. The Canonicity Chain

The ontology primes inherit their necessity from the Monster group.
We make the dependency chain explicit. -/

/-- The canonicity chain: Monster → irrep dim → prime factorization → encoding space.
    Breaking any link makes the primes arbitrary. -/
structure MonsterFactorization where
  /-- The smallest nontrivial Monster irrep dimension. -/
  irrepDim : ℕ
  /-- Its prime factors (the "ontology primes"). -/
  factors : List ℕ
  /-- Each factor is prime. -/
  factors_prime : ∀ p ∈ factors, Nat.Prime p
  /-- The factors are pairwise distinct. -/
  factors_nodup : factors.Nodup
  /-- Their product equals the irrep dimension. -/
  product_eq : factors.prod = irrepDim
  /-- McKay's observation: the first j-coefficient is irrepDim + 1. -/
  mckay : irrepDim + 1 = 196884

/-- The concrete Monster factorization. -/
def monsterFact : MonsterFactorization where
  irrepDim := 196883
  factors := [47, 59, 71]
  factors_prime := by decide
  factors_nodup := by decide
  product_eq := by norm_num
  mckay := by norm_num

/-- The irrep dim is squarefree (consequence of distinct prime factors). -/
theorem irrepDim_squarefree : Squarefree (196883 : ℕ) := by native_decide

/-! ## §2. The Obstruction: Gap in the Field

The gap lives in `Fin 196883` (≅ 𝔽₁₉₆₈₈₃), not in ℕ.
It measures commutativity failure of the diagram:

    E(e) = encodeString(e) mod 196883
    S(e) = semanticValue mod 196883
    Δ(e) = S(e) - E(e)  in  ℤ/196883ℤ
-/

/-- The syntax map: string → field element. -/
def syntaxMap (e : String) : Fin 196883 :=
  ⟨encodeString e % 196883, Nat.mod_lt _ (by norm_num)⟩

/-- The semantic map: value → field element. -/
def semanticMap (v : ℕ) : Fin 196883 :=
  ⟨v % 196883, Nat.mod_lt _ (by norm_num)⟩

/-- The obstruction: commutativity failure of the diagram.
    `Δ(e, v) = S(v) - E(e)` in `ℤ/196883ℤ`. -/
def obstruction (e : String) (v : ℕ) : Fin 196883 :=
  semanticMap v - syntaxMap e

/-- An expression is **self-locating** when the diagram commutes: Δ = 0. -/
def isSelfLocating (e : String) (v : ℕ) : Prop :=
  obstruction e v = 0

instance (e : String) (v : ℕ) : Decidable (isSelfLocating e v) :=
  inferInstanceAs (Decidable (_ = _))

/-! ## §3. The Discrete Metric: Suffix Length

The canonical distance is not in ℤ/196883ℤ (which has no metric) but in ℕ:
the number of characters `findSuffix` appends to close the gap.

This gives a discrete metric `{0, 1, 2}`:
- 0: self-locating (Δ = 0)
- 1: generic gap (crtReconstruct(Δ) ∉ [55296, 57343] and ≠ 0)
- 2: surrogate-range gap (crtReconstruct(Δ) ∈ [55296, 57343])
-/

/-- The suffix complexity: number of characters needed to close a gap.
    This is the canonical discrete metric. -/
def suffixComplexity (delta : ResTriple) : ℕ :=
  (findSuffix delta).length

/-- The full obstruction complexity for an expression/value pair. -/
def obstructionComplexity (e : String) (v : ℕ) : ℕ :=
  let obs := obstruction e v
  let triple : ResTriple :=
    (⟨obs.val % 47, Nat.mod_lt _ (by norm_num)⟩,
     ⟨obs.val % 59, Nat.mod_lt _ (by norm_num)⟩,
     ⟨obs.val % 71, Nat.mod_lt _ (by norm_num)⟩)
  suffixComplexity triple

/-- Zero obstruction implies zero suffix complexity. -/
theorem zero_obstruction_zero_complexity :
    suffixComplexity (0, 0, 0) = 0 := by native_decide

/-- Suffix complexity is at most 2 for any gap.
    Proof: `mkSuffixString d` produces "" (0 chars) if d=0,
    a 1-char string if d ∉ [55296,57343], else a 2-char string. -/
theorem suffixComplexity_le_two (delta : ResTriple) :
    suffixComplexity delta ≤ 2 := by
  unfold suffixComplexity findSuffix mkSuffixString
  split
  · -- d = 0: ""
    decide
  · split
    · -- d < 55296: single character
      rw [String.length_ofList]; simp
    · split
      · -- 55296 ≤ d ≤ 57343: two characters (surrogate workaround)
        rw [String.length_ofList]; simp
      · -- d > 57343: single character
        rw [String.length_ofList]; simp

/-! ## §4. Key Computations: The Obstruction Spectrum -/

/-- "bootstrap_self_encodes" referring to value 2343: obstruction = 0.
    This is the Gödelian fixed point — perfectly self-locating. -/
theorem bootstrap_self_locating :
    isSelfLocating "bootstrap_self_encodes" 2343 := by native_decide

/-- "bootstrap_self_encodes" has zero suffix complexity. -/
theorem bootstrap_complexity_zero :
    obstructionComplexity "bootstrap_self_encodes" 2343 = 0 := by native_decide

/-- "prime_47" referring to value 47: obstruction ≠ 0. -/
theorem prime47_not_self_locating :
    ¬ isSelfLocating "prime_47" 47 := by native_decide

/-- "prime_47" has obstruction complexity 1. -/
theorem prime47_complexity_one :
    obstructionComplexity "prime_47" 47 = 1 := by native_decide

/-- The concrete obstruction for "prime_47":
    E = 743, S = 47, Δ = (47 - 743) mod 196883 = 196187. -/
theorem prime47_obstruction :
    obstruction "prime_47" 47 = ⟨196187, by omega⟩ := by native_decide

/-- "prime_59" has complexity 1. -/
theorem prime59_complexity_one :
    obstructionComplexity "prime_59" 59 = 1 := by native_decide

/-- "prime_71" has complexity 1. -/
theorem prime71_complexity_one :
    obstructionComplexity "prime_71" 71 = 1 := by native_decide

/-! ## §5. McKay Expression: Trajectory vs Landing

The expression `1 + (71 × 59 × 47)` is a **trajectory** — it carries
structural meaning. The number 196884 is where it lands. -/

/-- McKay's expression: defined by structure, not by value. -/
def mckay_expression : ℕ := 1 + (71 * 59 * 47)

/-- The landing: the trajectory arrives at 196884. -/
theorem mckay_expression_eq : mckay_expression = 196884 := by
  norm_num [mckay_expression]

/-- The obstruction of "mckay_expression" relative to 196884.
    E = 1732, S = 196884 mod 196883 = 1. Δ = (1 − 1732) mod 196883. -/
theorem mckay_expr_obstruction :
    obstruction "mckay_expression" 196884 = ⟨195152, by omega⟩ := by native_decide

/-- The obstruction of "1 + (71 * 59 * 47)" relative to 196884. -/
theorem mckay_literal_obstruction :
    obstruction "1 + (71 * 59 * 47)" 196884 = ⟨196114, by omega⟩ := by native_decide

/-- Both McKay representations have complexity 1. -/
theorem mckay_expr_complexity :
    obstructionComplexity "mckay_expression" 196884 = 1 := by native_decide

theorem mckay_literal_complexity :
    obstructionComplexity "1 + (71 * 59 * 47)" 196884 = 1 := by native_decide

/-! ## §6. Goal-Bearing Names

A **goal-bearing name** is `(identity, target)` — a value paired with
a continuation. In CS terms: not just "I am X" but "I want to be at Y."

The suffix is the **witness** that the goal can be achieved. -/

/-- A goal-bearing name: identity + desired destination. -/
structure GoalBearingName where
  /-- Current identity. -/
  identity : String
  /-- Desired target in the CRT torus. -/
  target : ResTriple

/-- Current position of a goal-bearing name. -/
def GoalBearingName.currentPos (g : GoalBearingName) : ResTriple :=
  encodeResidue g.identity

/-- The navigation delta. -/
def GoalBearingName.delta (g : GoalBearingName) : ResTriple :=
  g.target - g.currentPos

/-- The witness suffix: a constructive proof that the goal is achievable. -/
def GoalBearingName.witness (g : GoalBearingName) : String :=
  findSuffix g.delta

/-- The realized name: identity + witness. -/
def GoalBearingName.realize (g : GoalBearingName) : String :=
  g.identity ++ g.witness

/-- Every goal-bearing name reaches its target. -/
theorem GoalBearingName.reaches_target (g : GoalBearingName) :
    encodeResidue g.realize = g.target := by
  simp only [realize, witness, delta, currentPos]
  exact findSuffix_lands g.identity g.target

/-- The complexity of achieving the goal. -/
def GoalBearingName.complexity (g : GoalBearingName) : ℕ :=
  suffixComplexity g.delta

/-- Goal complexity is at most 2. -/
theorem GoalBearingName.complexity_le_two (g : GoalBearingName) :
    g.complexity ≤ 2 :=
  suffixComplexity_le_two g.delta

/-! ## §7. The Declarative Registry

The shift from static to declarative:

    Current:   name → address
    Next:      name → goal
    Solver:    goal → landing instruction
    Result:    name → address satisfying goal -/

/-- A goal specification for the declarative registry. -/
inductive GoalSpec where
  /-- Navigate to a specific CRT coordinate. -/
  | navigateTo (target : ResTriple)
  /-- Become invisible in the 71-chart (vanish mod 71). -/
  | stealth71
  /-- Achieve a specific Bott class. -/
  | bottClass (cls : Fin 8)
  deriving DecidableEq

/-- Whether a string satisfies a goal. -/
def satisfies (s : String) : GoalSpec → Prop
  | .navigateTo t => encodeResidue s = t
  | .stealth71 => encodeString s % 71 = 0
  | .bottClass c => encodeString s % 8 = c.val

instance (s : String) (g : GoalSpec) : Decidable (satisfies s g) := by
  cases g with
  | navigateTo t => exact decEq _ _
  | stealth71 => exact decEq _ _
  | bottClass c => exact decEq _ _

/-- A certified solution: name + goal + suffix + proof. -/
structure CertifiedSolution where
  name : String
  goal : GoalSpec
  suffix : String
  certified : satisfies (name ++ suffix) goal

/-- Solve any `navigateTo` goal. -/
def solveNavigateTo (name : String) (target : ResTriple) : CertifiedSolution where
  name := name
  goal := .navigateTo target
  suffix := findSuffix (target - encodeResidue name)
  certified := findSuffix_lands name target

/-! ## §8. Higher-Order Addressability

Functions, proposals, governance rules — all higher-order objects — live
in the same 𝔽₄₇ × 𝔽₅₉ × 𝔽₇₁ address space via their canonical
string representations. -/

/-- Level of a symbolic object in the type hierarchy. -/
inductive ObjectLevel where
  | value | morphism | twoMorphism | governance
  deriving DecidableEq, Repr

/-- A symbolic object with its level and canonical representation. -/
structure SymbolicObject where
  level : ObjectLevel
  repr : String

/-- Address of a symbolic object in the torus. -/
def SymbolicObject.address (obj : SymbolicObject) : ResTriple :=
  encodeResidue obj.repr

/-- Concrete objects at each level. -/
def obj_value : SymbolicObject := ⟨.value, "bootstrap_self_encodes"⟩
def obj_morphism : SymbolicObject := ⟨.morphism, "encodeString:String→ℕ"⟩
def obj_twoMorphism : SymbolicObject := ⟨.twoMorphism, "tower_shift::level_k⇒level_k+1"⟩
def obj_governance : SymbolicObject := ⟨.governance, "rename_bootstrap@proposal:move_to_prime47"⟩

/-- All four levels occupy distinct addresses — no collisions across the hierarchy. -/
theorem levels_distinct :
    let objs := [obj_value, obj_morphism, obj_twoMorphism, obj_governance]
    (objs.map (fun o => encodeString o.repr % 196883)).Nodup := by native_decide

/-! ## §9. The Obstruction Spectrum

The full spectrum of obstructions across key expressions.
This is the project's main computational invariant. -/

/-- The obstruction spectrum: (expression, semantic value, obstruction, complexity). -/
def obstructionSpectrum : List (String × ℕ × Fin 196883 × ℕ) :=
  let entries := [
    ("bootstrap_self_encodes", 2343),
    ("prime_47", 47),
    ("prime_59", 59),
    ("prime_71", 71),
    ("mckay_expression", 196884),
    ("1 + (71 * 59 * 47)", 196884)
  ]
  entries.map fun (e, v) =>
    (e, v, obstruction e v, obstructionComplexity e v)

/-- Only "bootstrap_self_encodes" has zero obstruction in the spectrum. -/
theorem unique_self_locating :
    ∀ p ∈ obstructionSpectrum,
      p.2.2.1 = 0 → p.1 = "bootstrap_self_encodes" := by native_decide

/-- All non-self-locating entries have complexity exactly 1. -/
theorem nonzero_obstruction_complexity_one :
    ∀ p ∈ obstructionSpectrum,
      p.2.2.1 ≠ 0 → p.2.2.2 = 1 := by native_decide

/-! ## §10. Summary Theorem -/

/-- The paper, stated cleanly:
    1. The diagram commutes for "bootstrap_self_encodes" (Δ = 0)
    2. For key expressions, Δ ≠ 0 but suffix length = 1
    3. Suffix length ≤ 2 universally
    4. Every goal-bearing name reaches its target
    5. The canonicity chain is: 196883 = 47 × 59 × 71, all prime -/
theorem main_theorem :
    isSelfLocating "bootstrap_self_encodes" 2343 ∧
    ¬ isSelfLocating "prime_47" 47 ∧
    ¬ isSelfLocating "prime_59" 59 ∧
    ¬ isSelfLocating "prime_71" 71 ∧
    mckay_expression = 196884 ∧
    (∀ (s : String) (t : ResTriple),
      encodeResidue (s ++ findSuffix (t - encodeResidue s)) = t) ∧
    monsterFact.irrepDim = 196883 ∧
    monsterFact.factors = [47, 59, 71] ∧
    (∀ p ∈ monsterFact.factors, Nat.Prime p) := by
  refine ⟨by native_decide, by native_decide, by native_decide, by native_decide,
          by norm_num [mckay_expression],
          fun s t => findSuffix_lands s t,
          rfl, rfl, monsterFact.factors_prime⟩

end GoalBearingNames
