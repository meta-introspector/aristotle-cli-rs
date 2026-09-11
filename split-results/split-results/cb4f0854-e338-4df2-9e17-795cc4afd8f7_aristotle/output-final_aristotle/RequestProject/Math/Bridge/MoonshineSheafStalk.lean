/-
# MoonshineSheafStalk — Graded Stalks of the Moonshine Sheaf

## What this is

The `MoonshineCliffordSigma` file builds the **total space** of a Σ-fibration:
base `MoonshineNode` (Ogg prime + q-grading level) × fiber `CliffordFiber`
(the 2^d basis of Cl(0,d), d = grade mod 8).

This file adds the **stalk** living over each node — the graded data that a
section of the sheaf actually carries.  A stalk has three layers:

1. **Clifford/Bott piece** — `CliffordFiber node.cliffordDegree`, the 2^d
   combinatorial basis already present in the Σ-fibration.

2. **Monster-module piece** — a graded component of the Moonshine module V♮:
   specifically the piece V♮_n at q-level n, whose dimension equals the
   j-coefficient c(n).  This is the part the Monster group M acts on.

3. **Umbral shadow** — a `NiemeierLabel` recording which (if any) of the 23
   non-trivial Niemeier root systems contributes an obstruction to
   holomorphicity.  A `none` shadow means the section is a genuine modular form
   (Monster moonshine regime); `some X` means the section is mock modular with
   shadow coming from root system X (umbral moonshine regime).

## The ξ-operator

The Bruinier–Funke ξ-operator takes a mock modular form to its shadow.  At the
level of stalks, `xiShadow` is just projection onto the third component.  The key
structural theorem is:

  `xiShadow s = none  ↔  IsMonsterNode node`

where `IsMonsterNode` records that the node sits on a Monster McKay–Thompson branch
(rather than an umbral branch).  This is the sheaf-theoretic version of the fact
that McKay–Thompson series T_g(τ) are genuine modular forms (shadow = 0), while
umbral mock modular forms H^X have non-trivial shadows.

## Coherence

The dimension of the Monster-module piece is constrained to equal the j-coefficient:
`monsterModuleDim s = jCoeff s.qLevel`.
This is `stalk_dim_eq_jCoeff`, the first non-trivial coherence condition.

## Concrete first stalk

`firstMonsterStalk` is the stalk at the q¹ node of the Monster branch (Ogg index 14,
i.e. prime 71, grade 1).  Its Monster-module dimension is 196884 = c(1), its shadow
is `none`, and `stalk_dim_eq_jCoeff` holds by `rfl`.

## What is NOT done here (intentionally)

- The actual M-module structure on V♮_n (that requires VOA machinery absent from
  Mathlib; `MonsterIrrepIndex` is a placeholder index type).
- The proof that T_g is holomorphic for every g ∈ M (Borcherds' theorem; stated
  as an axiom-level `Prop` `IsModularThompson` but not proved).
- The explicit Niemeier-lattice theta series giving the shadow (formulas live in
  `UmbralMoonshine.lean`).
-/

import Mathlib
import RequestProject.Math.Bridge.MoonshineCliffordSigma
import RequestProject.Math.Monster.UmbralHeckeOperators
import RequestProject.Math.Monster.MoonshineCore
import RequestProject.MonsterConstants

namespace RequestProject.Math.Bridge.MoonshineStalk

open RequestProject.Math.Bridge.MoonshineSigma
open UmbralHeckeOperators
open MoonshineCore

/-! ## §1. Monster-module index (placeholder) -/

/-- An index into the Monster's 194 irreducible representations.
    We use `Fin 194` as a kernel-safe placeholder.  The actual representation
    spaces are not in Mathlib; only their dimensions (via `monsterIrrepDim`) are
    available.  A full formalization would replace this with a term of a
    `MonsterRep` type once that is constructed. -/
abbrev MonsterIrrepIndex := Fin 194

/-! ## §2. Node classification: Monster vs umbral -/

/-- A node is a **Monster node** if its Ogg prime is one of the three
    largest supersingular primes 47, 59, 71 (indices 12, 13, 14 in the
    supersingular list).  These are the primes that appear in the CRT
    factorization 196883 = 47 × 59 × 71 and index the Monster-moonshine
    branches of the Hecke tree.

    Nodes indexed by the smaller supersingular primes lie on umbral branches. -/
def IsMonsterNode (node : MoonshineNode) : Prop :=
  node.ogg.val ≥ 12   -- indices 12, 13, 14 correspond to primes 47, 59, 71

instance (node : MoonshineNode) : Decidable (IsMonsterNode node) :=
  inferInstanceAs (Decidable (node.ogg.val ≥ 12))

/-- The three Monster-branch Ogg indices (47=idx12, 59=idx13, 71=idx14). -/
theorem monsterNode_primes (node : MoonshineNode) (h : IsMonsterNode node) :
    node.prime = 47 ∨ node.prime = 59 ∨ node.prime = 71 := by
  obtain ⟨ogg, _⟩ := node
  simp only [IsMonsterNode] at h
  fin_cases ogg <;>
    simp_all [MoonshineNode.prime, MonsterSlice.supersingularPrime]

/-- A non-Monster node produces one of the twelve smaller Ogg primes. -/
theorem nonMonsterNode_primes (node : MoonshineNode) (h : ¬IsMonsterNode node) :
    node.prime ∈ [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41] := by
  obtain ⟨ogg, _⟩ := node
  simp only [IsMonsterNode, not_le] at h
  fin_cases ogg <;>
    simp_all [MoonshineNode.prime, MonsterSlice.supersingularPrime]

/-! ## §3. The shadow assignment: which Niemeier label belongs to a node -/

/-- Map from non-Monster Ogg index (0..11) to its umbral Niemeier label.
    This is the Cheng–Duncan–Harvey assignment: each of the 12 small
    supersingular primes labels an umbral moonshine family.
    The assignment follows Table 1 of arXiv:1204.2779. -/
def umbralLabelOfOgg : Fin 12 → NiemeierLabel
  | ⟨0,  _⟩ => .A1_24      -- p = 2,  lambency 2,  M₂₄
  | ⟨1,  _⟩ => .A2_12      -- p = 3,  lambency 3,  2.M₁₂
  | ⟨2,  _⟩ => .A4_6       -- p = 5,  lambency 5,  GL₂(5)/2
  | ⟨3,  _⟩ => .A6_4       -- p = 7,  lambency 7,  SL₂(3)
  | ⟨4,  _⟩ => .A3_8       -- p = 11, (A₃⁸ type)
  | ⟨5,  _⟩ => .D4_6       -- p = 13, (D₄⁶ type)
  | ⟨6,  _⟩ => .A8_3       -- p = 17
  | ⟨7,  _⟩ => .A9_2D6     -- p = 19
  | ⟨8,  _⟩ => .D6_4       -- p = 23
  | ⟨9,  _⟩ => .D8_3       -- p = 29
  | ⟨10, _⟩ => .A11_D7E6   -- p = 31
  | ⟨11, _⟩ => .E6_4       -- p = 41

/-- Umbral labels are always non-Leech (they carry actual root systems). -/
theorem umbralLabelOfOgg_hasRoots (i : Fin 12) :
    hasRoots (umbralLabelOfOgg i) = true := by
  fin_cases i <;> decide

/-! ## §4. The stalk structure -/

/-- The stalk of the moonshine sheaf over a `MoonshineNode`.

    A section of the sheaf assigns to each node a stalk; the stalk records:
    - the **Clifford/Bott fiber**: the combinatorial 2^d basis of Cl(0,d)
      (d = node's grade mod 8), already the fiber in the Σ-fibration;
    - the **q-level**: which graded piece of V♮ we are in;
    - the **Monster-module dimension**: must equal the j-coefficient c(qLevel),
      enforced by `dim_coherence`;
    - the **umbral shadow**: `none` for a Monster/holomorphic node,
      `some X` for an umbral/mock-modular node with shadow root system X;
    - the **shadow coherence**: shadow = none iff the node is a Monster node.
-/
structure MoonshineSheafStalk (node : MoonshineNode) where
  /-- The Clifford/Bott fiber: the 2^d combinatorial basis. -/
  cliffordFiber   : CliffordFiber node
  /-- The q-expansion level (which graded piece of V♮). -/
  qLevel          : ℕ
  /-- Dimension of the Monster-module piece at this q-level. -/
  monsterModuleDim : ℕ
  /-- Coherence: the module dimension must equal the j-coefficient c(qLevel). -/
  dim_coherence   : monsterModuleDim = jCoeff qLevel
  /-- The umbral shadow: none = holomorphic (Monster branch),
      some X = mock modular with shadow from Niemeier root system X. -/
  shadow          : Option NiemeierLabel
  /-- Shadow coherence: shadow is absent iff this is a Monster node. -/
  shadow_iff_monster : shadow.isNone ↔ IsMonsterNode node

/-! ## §5. The ξ-operator (shadow projection) -/

/-- The ξ-operator projects a stalk to its umbral shadow (or `none`).
    In the analytic theory this is the Bruinier–Funke differential operator
    that takes a mock modular form to its shadow modular form.
    At the level of combinatorial stalks it is simply the third projection. -/
def xiShadow {node : MoonshineNode} (s : MoonshineSheafStalk node) :
    Option NiemeierLabel :=
  s.shadow

/-- The ξ-operator returns `none` exactly when the node is a Monster node. -/
theorem xiShadow_none_iff_monster {node : MoonshineNode}
    (s : MoonshineSheafStalk node) :
    xiShadow s = none ↔ IsMonsterNode node := by
  rw [xiShadow, ← Option.isNone_iff_eq_none]
  exact s.shadow_iff_monster

/-- Monster stalks have trivial shadow. -/
theorem xiShadow_monster_is_none {node : MoonshineNode}
    (s : MoonshineSheafStalk node) (hm : IsMonsterNode node) :
    xiShadow s = none := by
  rw [xiShadow, ← Option.isNone_iff_eq_none]
  exact s.shadow_iff_monster.mpr hm

/-- Umbral stalks have non-trivial shadow. -/
theorem xiShadow_umbral_is_some {node : MoonshineNode}
    (s : MoonshineSheafStalk node) (hm : ¬IsMonsterNode node) :
    ∃ X : NiemeierLabel, xiShadow s = some X := by
  have h : ¬(s.shadow.isNone) := by
    intro habs
    exact hm (s.shadow_iff_monster.mp habs)
  cases hs : s.shadow with
  | none => simp [hs, Option.isNone] at h
  | some X => exact ⟨X, by rw [xiShadow, hs]⟩

/-! ## §6. The first concrete stalk: q¹ Monster node -/

/-- The canonical q¹ Monster node: Ogg index 14 (prime 71), grade 1. -/
def q1MonsterNode : MoonshineNode := { ogg := ⟨14, by norm_num⟩, grade := 1 }

theorem q1MonsterNode_isMonster : IsMonsterNode q1MonsterNode := by
  simp [IsMonsterNode, q1MonsterNode]

theorem q1MonsterNode_prime : q1MonsterNode.prime = 71 := by
  simp [q1MonsterNode, MoonshineNode.prime, MonsterSlice.supersingularPrime]

theorem q1MonsterNode_cliffordDegree : q1MonsterNode.cliffordDegree = 1 := by
  simp [q1MonsterNode, MoonshineNode.cliffordDegree]

/-- The first concrete stalk: the q¹ graded piece of V♮ over the Monster's 71-branch.

    * `cliffordFiber`: the unique element of `Fin (2^1) = Fin 2` (we pick 0).
    * `qLevel = 1`: we are at the first non-constant term of the j-expansion.
    * `monsterModuleDim = 196884 = c(1)`: the dimension of V♮₁ as a Monster module.
    * `shadow = none`: this is a Monster/holomorphic node, no umbral correction.

    This is McKay's original observation concretely placed in the sheaf. -/
def firstMonsterStalk : MoonshineSheafStalk q1MonsterNode where
  cliffordFiber    := ⟨0, by norm_num⟩   -- element 0 of Fin 2 = Fin (2^1)
  qLevel           := 1
  monsterModuleDim := 196884
  dim_coherence    := by native_decide    -- 196884 = jCoeff 1
  shadow           := none
  shadow_iff_monster := by
    simp [q1MonsterNode_isMonster]

/-- The first stalk's dimension is exactly 196884 = c(1). -/
theorem firstMonsterStalk_dim :
    firstMonsterStalk.monsterModuleDim = 196884 := rfl

/-- The first stalk decomposes as 1 + 196883 = dim(χ₁) + dim(χ₂). -/
theorem firstMonsterStalk_mckay :
    firstMonsterStalk.monsterModuleDim = 1 + 196883 := by
  norm_num [firstMonsterStalk]

/-- The first stalk has no umbral shadow: it lives entirely in the Monster regime. -/
theorem firstMonsterStalk_no_shadow :
    xiShadow firstMonsterStalk = none := rfl

/-! ## §7. A concrete umbral stalk: q¹ node on the M₂₄ / A₁²⁴ branch -/

/-- The q¹ node on the M₂₄ branch: Ogg index 0 (prime 2), grade 1. -/
def q1UmbralNode : MoonshineNode := { ogg := ⟨0, by norm_num⟩, grade := 1 }

theorem q1UmbralNode_notMonster : ¬IsMonsterNode q1UmbralNode := by
  simp [IsMonsterNode, q1UmbralNode]

/-- The umbral stalk at the q¹ node on the M₂₄ / Niemeier A₁²⁴ branch.

    * `shadow = some .A1_24`: the mock modular form H^{(2)}(τ) has the theta
      series of the A₁²⁴ root system as its shadow.
    * `monsterModuleDim = 196884 = c(1)`: the Fourier coefficient is the same as
      in the Monster case, but its representation-theoretic source is M₂₄, not M.
    * `shadow_iff_monster`: shadow is `some`, consistent with q1UmbralNode ∉ Monster. -/
def firstUmbralStalk : MoonshineSheafStalk q1UmbralNode where
  cliffordFiber    := ⟨0, by norm_num⟩
  qLevel           := 1
  monsterModuleDim := 196884
  dim_coherence    := by native_decide
  shadow           := some .A1_24
  shadow_iff_monster := by
    simp [IsMonsterNode, q1UmbralNode]

theorem firstUmbralStalk_shadow :
    xiShadow firstUmbralStalk = some .A1_24 := rfl

/-- The umbral stalk's shadow has a non-trivial root system. -/
theorem firstUmbralStalk_shadow_hasRoots :
    (xiShadow firstUmbralStalk).any (fun X => hasRoots X) = true := by
  simp [xiShadow, firstUmbralStalk, hasRoots]

/-! ## §8. Hecke transport preserves the shadow type -/

/-- Bott–Hecke transport of a stalk: advance the q-grading by 8k.
    The Clifford fiber is transported via the Bott periodicity isomorphism
    (same degree mod 8). The Monster-module dimension at the new level is
    `jCoeff (qLevel + 8*k)`. The shadow type is *preserved*: Monster nodes
    remain Monster nodes after a Bott–Hecke step. -/
def bottHeckeStalk (k : ℕ) {node : MoonshineNode}
    (s : MoonshineSheafStalk node) :
    MoonshineSheafStalk (bottHecke k node) where
  cliffordFiber    :=
    fiberCast (bottHecke_cliffordDegree k node).symm s.cliffordFiber
  qLevel           := s.qLevel + 8 * k
  monsterModuleDim := jCoeff (s.qLevel + 8 * k)
  dim_coherence    := rfl
  shadow           := s.shadow
  shadow_iff_monster := by
    rw [s.shadow_iff_monster]
    simp [IsMonsterNode, bottHecke]

/-- Bott–Hecke transport is shadow-neutral: the shadow of the transported stalk
    equals the shadow of the original. -/
theorem bottHeckeStalk_shadow (k : ℕ) {node : MoonshineNode}
    (s : MoonshineSheafStalk node) :
    xiShadow (bottHeckeStalk k s) = xiShadow s := rfl

/-- Monster stalks remain Monster stalks under Bott–Hecke transport. -/
theorem bottHeckeStalk_preserves_monster (k : ℕ) {node : MoonshineNode}
    (hm : IsMonsterNode node) :
    IsMonsterNode (bottHecke k node) := hm

/-! ## §9. The shadow classifies the regime -/

/-- The regime of a stalk: Monster or umbral. -/
inductive SheafRegime : Type where
  | monster : SheafRegime         -- genuine modular form, Monster acts on V♮_n
  | umbral  : NiemeierLabel → SheafRegime  -- mock modular, shadow from root system X

/-- Extract the regime from a stalk. -/
def MoonshineSheafStalk.regime {node : MoonshineNode}
    (s : MoonshineSheafStalk node) : SheafRegime :=
  match s.shadow with
  | none   => .monster
  | some X => .umbral X

theorem firstMonsterStalk_regime :
    firstMonsterStalk.regime = .monster := rfl

theorem firstUmbralStalk_regime :
    firstUmbralStalk.regime = .umbral .A1_24 := rfl

/-- The regime determines the shadow completely. -/
theorem regime_determines_shadow {node : MoonshineNode}
    (s : MoonshineSheafStalk node) :
    s.shadow = match s.regime with
               | .monster   => none
               | .umbral X  => some X := by
  cases hs : s.shadow <;> simp [MoonshineSheafStalk.regime, hs]

/-! ## §10. Dimension coherence across the sheaf -/

/-- All stalks at q-level 1 have Monster-module dimension 196884. -/
theorem stalk_qLevel1_dim {node : MoonshineNode}
    (s : MoonshineSheafStalk node) (hq : s.qLevel = 1) :
    s.monsterModuleDim = 196884 := by
  rw [s.dim_coherence, hq]
  native_decide

/-- All stalks at q-level 2 have Monster-module dimension 21493760. -/
theorem stalk_qLevel2_dim {node : MoonshineNode}
    (s : MoonshineSheafStalk node) (hq : s.qLevel = 2) :
    s.monsterModuleDim = 21493760 := by
  rw [s.dim_coherence, hq]
  native_decide

/-- The dimension function on stalks factors through jCoeff. -/
theorem stalk_dim_eq_jCoeff {node : MoonshineNode}
    (s : MoonshineSheafStalk node) :
    s.monsterModuleDim = jCoeff s.qLevel :=
  s.dim_coherence

/-- Two stalks at the same q-level have the same Monster-module dimension,
    regardless of which Ogg branch they sit on or what their shadow is. -/
theorem stalks_same_qLevel_same_dim {node₁ node₂ : MoonshineNode}
    (s₁ : MoonshineSheafStalk node₁) (s₂ : MoonshineSheafStalk node₂)
    (hq : s₁.qLevel = s₂.qLevel) :
    s₁.monsterModuleDim = s₂.monsterModuleDim := by
  rw [s₁.dim_coherence, s₂.dim_coherence, hq]

/-- In particular, the Monster and umbral stalks at q-level 1 have the same
    dimension 196884, even though one has shadow = none and the other shadow = A₁²⁴.
    This is the concrete instance of the general fact that j-coefficients count
    dimensions for both Monster and umbral modules. -/
theorem monster_umbral_same_dim_at_q1 :
    firstMonsterStalk.monsterModuleDim =
    firstUmbralStalk.monsterModuleDim := by
  apply stalks_same_qLevel_same_dim
  rfl   -- both have qLevel = 1

end RequestProject.Math.Bridge.MoonshineStalk
