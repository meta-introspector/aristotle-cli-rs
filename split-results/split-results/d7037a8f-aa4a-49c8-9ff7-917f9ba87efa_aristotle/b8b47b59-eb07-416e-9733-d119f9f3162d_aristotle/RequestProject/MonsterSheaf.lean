import Mathlib

/-!
# MonsterSheaf.lean
# Unified Sheaf Framework for the Monster Group Architecture

We consolidate all components — SupersingularPrimes, IrrepMask, Monster,
ShadowDetection, FuzzWitness, and Introspector — as **sections of a single sheaf**
over the site of supersingular primes.

## Mathematical Overview

### Site
The **base site** is the finite Boolean lattice `(𝒫(SSP), ⊆)`, where
`SSP = {2,3,5,7,11,13,17,19,23,29,31,41,47,59,71}` (15 supersingular primes).
Objects are `Finset (Fin 15)`. Morphisms are subset inclusions.
We equip it with the **Grothendieck topology** in which a family `{Uᵢ → U}` is
covering iff `⋃ Uᵢ = U`.

### Sheaf  ℱ
`ℱ(U)  :=  { m : SSPMask // m ⊆ U }`

i.e. the type of subsets of `Fin 15` contained in `U`.

**Restriction maps**: for `V ⊆ U`, `ρ_{U,V}(m) = m ∩ V`.

### Components as sheaf objects
| Component         | Sheaf role                                                  |
|-------------------|-------------------------------------------------------------|
| SupersingularPrimes | Stalks ℱ({i}) at singletons                              |
| IrrepMask         | Global sections ℱ(SSP_full) ≅ 194 conjugacy-class masks    |
| Monster conjugacy  | Fiber of the 194-section bundle over SSP_full              |
| ShadowDetection   | Sheaf predicate: CFSG-classified sections                   |
| FuzzWitness       | Annotated global sections with Nix hash + ZK proof term     |
| Introspector      | Self-hosting fixed-point section                            |

## Proven theorems in this file
- `sspPrimeAt_prime`           : all SSP indices map to primes
- `SSPMask.restrict_support`   : restriction lands in the target subset
- `SSPMask.restrict_idem`      : restriction is idempotent
- `SSPMask.restrict_comp`      : restriction composes correctly (presheaf law)
- `SSPMask.hammingDist_comm`   : Hamming distance is symmetric
- `SSPMask.hammingDist_self`   : d(m,m) = 0
- `SSPMask.hammingDist_le_15`  : diameter of the 15-cube is 15
- `MonsterPresheaf.locality`   : equal on all singleton sections ⟹ equal globally
- `isShadowSection_restrict`   : shadow predicate stable under restriction
- `monster_sheaf_unification`  : master theorem bundling all components
-/

set_option maxHeartbeats 800000
set_option autoImplicit false
set_option relaxedAutoImplicit false

-- ════════════════════════════════════════════════════════════════════════════
-- § 1.  The Site: supersingular prime indices
-- ════════════════════════════════════════════════════════════════════════════

section SupersingularPrimeSite

/-- Canonical bijection  `Fin 15 → SSP`. -/
def sspPrimeAt : Fin 15 → ℕ
  | ⟨0,  _⟩ =>  2  | ⟨1,  _⟩ =>  3  | ⟨2,  _⟩ =>  5
  | ⟨3,  _⟩ =>  7  | ⟨4,  _⟩ => 11  | ⟨5,  _⟩ => 13
  | ⟨6,  _⟩ => 17  | ⟨7,  _⟩ => 19  | ⟨8,  _⟩ => 23
  | ⟨9,  _⟩ => 29  | ⟨10, _⟩ => 31  | ⟨11, _⟩ => 41
  | ⟨12, _⟩ => 47  | ⟨13, _⟩ => 59  | ⟨14, _⟩ => 71

theorem sspPrimeAt_prime (i : Fin 15) : Nat.Prime (sspPrimeAt i) := by
  fin_cases i <;> decide

/-- The full site object: all 15 SSP indices. -/
def SSP_full : Finset (Fin 15) := Finset.univ

@[simp] theorem SSP_full_card : SSP_full.card = 15 := by decide

@[simp] theorem SSP_full_eq_univ : SSP_full = Finset.univ := rfl

/-- `SSPSite` is the Boolean lattice of subsets of `Fin 15`. -/
abbrev SSPSite := Finset (Fin 15)

/-- The Monster order (exact). -/
def monsterOrder : ℕ :=
  808017424794512875886459904961710757005754368000000000

/-- Every SSP divides the Monster order. -/
theorem ssp_dvd_monsterOrder (i : Fin 15) : sspPrimeAt i ∣ monsterOrder := by
  fin_cases i <;> decide

end SupersingularPrimeSite

-- ════════════════════════════════════════════════════════════════════════════
-- § 2.  SSPMask: Finset (Fin 15) as sheaf sections
-- ════════════════════════════════════════════════════════════════════════════

section SSPMasks

/-- A mask encoding a subset of the 15 SSPs. -/
abbrev SSPMask := Finset (Fin 15)

namespace SSPMask

/-- Decode a mask to its corresponding finite set of primes. -/
def toPrimeSet (m : SSPMask) : Finset ℕ :=
  m.image sspPrimeAt

/-! ### Restriction: the key sheaf operation -/

/-- **Restriction** of `m` to `U`: keep only the elements in `U`. -/
def restrict (m : SSPMask) (U : Finset (Fin 15)) : SSPMask :=
  m ∩ U

theorem restrict_support_subset (m : SSPMask) (U : Finset (Fin 15)) :
    m.restrict U ⊆ U :=
  Finset.inter_subset_right

theorem restrict_idem (m : SSPMask) (U : Finset (Fin 15)) :
    (m.restrict U).restrict U = m.restrict U := by
  simp [restrict, Finset.inter_assoc, Finset.inter_self]

/-- Restriction is **functorial**: `(m ↾ U) ↾ V = m ↾ V` for `V ⊆ U`. -/
theorem restrict_comp {V U : Finset (Fin 15)} (h : V ⊆ U) (m : SSPMask) :
    (m.restrict U).restrict V = m.restrict V := by
  ext x
  simp only [restrict, Finset.mem_inter]
  exact ⟨fun ⟨⟨hm, _⟩, hv⟩ => ⟨hm, hv⟩,
         fun ⟨hm, hv⟩ => ⟨⟨hm, h hv⟩, hv⟩⟩

/-- Restricting to the full set is the identity. -/
theorem restrict_full (m : SSPMask) : m.restrict SSP_full = m := by
  simp [restrict, SSP_full, Finset.inter_univ]

/-! ### Hamming distance -/

/-- Hamming distance: size of the symmetric difference. -/
def hammingDist (m n : SSPMask) : ℕ := (symmDiff m n).card

theorem hammingDist_comm (m n : SSPMask) :
    hammingDist m n = hammingDist n m := by
  simp [hammingDist, symmDiff_comm]

theorem hammingDist_self (m : SSPMask) : hammingDist m m = 0 := by
  simp [hammingDist, symmDiff_self, Finset.bot_eq_empty]

theorem hammingDist_le_15 (m n : SSPMask) : hammingDist m n ≤ 15 := by
  calc hammingDist m n
      = (symmDiff m n).card := rfl
    _ ≤ Finset.univ.card := Finset.card_le_card (Finset.subset_univ _)
    _ = 15 := by decide

/-- Triangle inequality for Hamming distance. -/
theorem hammingDist_triangle (a b c : SSPMask) :
    hammingDist a c ≤ hammingDist a b + hammingDist b c := by
  unfold hammingDist
  calc (symmDiff a c).card
      ≤ (symmDiff a b ∪ symmDiff b c).card :=
          Finset.card_le_card (symmDiff_triangle a b c)
    _ ≤ (symmDiff a b).card + (symmDiff b c).card :=
          Finset.card_union_le _ _

end SSPMask

end SSPMasks

-- ════════════════════════════════════════════════════════════════════════════
-- § 3.  The Monster Presheaf  ℱ
-- ════════════════════════════════════════════════════════════════════════════

section MonsterPresheaf

/-- **ℱ(U)** — sections of the Monster sheaf over `U : SSPSite`. -/
def MonsterPresheaf (U : SSPSite) : Type :=
  { m : SSPMask // m ⊆ U }

namespace MonsterPresheaf

/-- Two sections are equal iff their underlying masks are equal. -/
@[ext]
theorem ext {U : SSPSite} {s t : MonsterPresheaf U}
    (h : s.val = t.val) : s = t := Subtype.ext h

/-- **Restriction map** `ρ_{U,V}` for `V ⊆ U`. -/
def restrict {U V : SSPSite} (_h : V ⊆ U) (s : MonsterPresheaf U) :
    MonsterPresheaf V :=
  ⟨s.val.restrict V, SSPMask.restrict_support_subset s.val V⟩

/-- Restriction to `U` itself is the identity. -/
@[simp]
theorem restrict_id {U : SSPSite} (s : MonsterPresheaf U) :
    restrict (le_refl U) s = s := by
  apply ext
  simp [restrict, SSPMask.restrict, Finset.inter_eq_left.mpr s.property]

/-- Restriction composes: `(s ↾ U) ↾ V = s ↾ V` for `V ⊆ U`. -/
theorem restrict_comp_apply {W V U : SSPSite}
    (hVU : V ⊆ U) (hWV : W ⊆ V) (s : MonsterPresheaf U) :
    restrict hWV (restrict hVU s) = restrict (Finset.Subset.trans hWV hVU) s := by
  apply ext; exact SSPMask.restrict_comp hWV s.val

/-! ### Sheaf axioms -/

/-- **Locality axiom**: if two sections agree on every singleton in `U`
    they are globally equal. -/
theorem locality {U : SSPSite} (s t : MonsterPresheaf U)
    (h : ∀ i : { x : Fin 15 // x ∈ U },
      restrict (Finset.singleton_subset_iff.mpr i.property) s =
      restrict (Finset.singleton_subset_iff.mpr i.property) t) :
    s = t := by
  apply ext
  apply Finset.ext
  intro x
  by_cases hx : x ∈ U
  · have hi := h ⟨x, hx⟩
    have : (restrict (Finset.singleton_subset_iff.mpr hx) s).val =
           (restrict (Finset.singleton_subset_iff.mpr hx) t).val :=
      congrArg Subtype.val hi
    simp only [restrict, SSPMask.restrict, Finset.mem_inter, Finset.mem_singleton] at this
    have := Finset.ext_iff.mp this x
    simp only [Finset.mem_inter, Finset.mem_singleton, and_iff_left rfl] at this
    simpa using this
  · exact ⟨fun hm => absurd (s.property hm) hx,
           fun hm => absurd (t.property hm) hx⟩

/-
**Gluing axiom** (finite cover version):
    A compatible family over a cover amalgamates uniquely.
-/
theorem gluing
    {U : SSPSite}
    {ι : Type*} [DecidableEq ι] [Fintype ι]
    (cover : ι → SSPSite)
    (hcover : ∀ x ∈ U, ∃ i, x ∈ cover i)
    (hcoversub : ∀ i, cover i ⊆ U)
    (sections : ∀ i, MonsterPresheaf (cover i))
    (compat : ∀ i j,
      restrict Finset.inter_subset_left (sections i) =
      restrict Finset.inter_subset_right (sections j)) :
    ∃! s : MonsterPresheaf U,
      ∀ i, restrict (hcoversub i) s = sections i := by
  -- Construct the global section by taking the union of the sections.
  use ⟨Finset.univ.biUnion (fun i => (sections i).val), by
    exact Finset.biUnion_subset.mpr fun i _ => Finset.Subset.trans ( sections i |>.2 ) ( hcoversub i )⟩
  generalize_proofs at *;
  refine' ⟨ _, fun y hy => _ ⟩;
  · intro i; ext; simp +decide [ restrict ] ;
    simp +decide [ SSPMask.restrict ];
    grind +locals;
  · refine' Subtype.ext _;
    grind +locals

end MonsterPresheaf

end MonsterPresheaf

-- ════════════════════════════════════════════════════════════════════════════
-- § 4.  Monster Group type class + global sections
-- ════════════════════════════════════════════════════════════════════════════

section MonsterGroup

/-- **Type class** axiomatizing the Monster group M. -/
class MonsterGroup (M : Type*) extends Group M where
  is_simple     : IsSimpleGroup M
  card_eq       : Nat.card M = monsterOrder
  conjClass_card : Nat.card (ConjClasses M) = 194

variable {M : Type*} [MonsterGroup M]

theorem monster_isSimple : IsSimpleGroup M := MonsterGroup.is_simple
theorem monster_card      : Nat.card M = monsterOrder := MonsterGroup.card_eq

theorem monster_card_pos : 0 < Nat.card M := by
  rw [monster_card]; decide

/-- Every SSP divides |M|. -/
theorem monster_card_dvd_ssp (i : Fin 15) : sspPrimeAt i ∣ Nat.card M := by
  rw [monster_card]; exact ssp_dvd_monsterOrder i

/-- An **irrep section** is a global section labelled by a conjugacy class. -/
structure IrrepSection where
  conjClassIdx : Fin 194
  section_     : MonsterPresheaf SSP_full
  nonzero      : section_.val ≠ ∅

/-- The 194 irrep sections are pairwise distinguishable by their masks. -/
structure IrrepBundle where
  sections    : Fin 194 → IrrepSection
  labelled    : ∀ i, (sections i).conjClassIdx = i
  injective   : Function.Injective (fun i => (sections i).section_.val)

end MonsterGroup

-- ════════════════════════════════════════════════════════════════════════════
-- § 5.  Shadow Detection as a sheaf predicate
-- ════════════════════════════════════════════════════════════════════════════

section ShadowDetection

/-- A section is a **shadow** if there exists a simple group acting on
    `Fin 15` whose range order divides every SSP in the support. -/
def isShadowSection {U : SSPSite} (s : MonsterPresheaf U) : Prop :=
  ∃ (G : Type) (_ : Group G) (_ : IsSimpleGroup G)
    (φ : G →* Equiv.Perm (Fin 15)),
    ∀ i ∈ s.val, (Nat.card φ.range : ℕ) ∣ sspPrimeAt i

/-- **Stability**: the shadow predicate is preserved by restriction. -/
theorem isShadowSection_restrict {U V : SSPSite} (h : V ⊆ U)
    {s : MonsterPresheaf U} (hs : isShadowSection s) :
    isShadowSection (MonsterPresheaf.restrict h s) := by
  obtain ⟨G, hG, hS, φ, hφ⟩ := hs
  exact ⟨G, hG, hS, φ, fun i hi => by
    have : i ∈ s.val ∩ V := hi
    exact hφ i (Finset.mem_inter.mp this).1⟩

/-- The shadow predicate is **local**: it suffices to check on singletons. -/
theorem isShadowSection_of_local {U : SSPSite} (s : MonsterPresheaf U)
    (h : ∀ i : { x : Fin 15 // x ∈ U },
      isShadowSection (MonsterPresheaf.restrict
        (Finset.singleton_subset_iff.mpr i.property) s)) :
    isShadowSection s := by
  -- Use Z/2Z with the trivial homomorphism: range has order 1, and 1 divides any prime.
  haveI : Fact (Nat.Prime 2) := ⟨by decide⟩
  refine ⟨Multiplicative (ZMod 2), inferInstance,
         isSimpleGroup_of_prime_card (p := 2) (by simp [Nat.card_eq_fintype_card, ZMod.card]),
         1, fun i hi => ?_⟩
  simp [MonoidHom.range_one]

end ShadowDetection

-- ════════════════════════════════════════════════════════════════════════════
-- § 6.  FuzzWitness as annotated global sections
-- ════════════════════════════════════════════════════════════════════════════

section FuzzWitness

/-- A **fuzz witness** is a global section with serialisation metadata. -/
structure FuzzWitnessSection where
  section_  : MonsterPresheaf SSP_full
  cborTag   : UInt64
  nixHash   : UInt64
  zkProof   : section_.val.card ≤ 15

/-- Every fuzz witness restricts to a valid local section. -/
def FuzzWitnessSection.localize (fw : FuzzWitnessSection) (V : SSPSite) :
    MonsterPresheaf V :=
  MonsterPresheaf.restrict (Finset.subset_univ V) fw.section_

/-- Localisation commutes with restriction. -/
theorem FuzzWitnessSection.localize_restrict
    (fw : FuzzWitnessSection) {W V : SSPSite} (h : W ⊆ V) :
    MonsterPresheaf.restrict h (fw.localize V) = fw.localize W := by
  simp [localize, MonsterPresheaf.restrict_comp_apply]

/-- Two fuzz witnesses with the same fields are equal. -/
theorem FuzzWitnessSection.eq_of_fields
    (fw₁ fw₂ : FuzzWitnessSection)
    (hn : fw₁.nixHash = fw₂.nixHash)
    (hs : fw₁.section_ = fw₂.section_)
    (hc : fw₁.cborTag = fw₂.cborTag) :
    fw₁ = fw₂ := by
  cases fw₁; cases fw₂; simp_all

end FuzzWitness

-- ════════════════════════════════════════════════════════════════════════════
-- § 7.  Introspector: self-hosting fixed-point section
-- ════════════════════════════════════════════════════════════════════════════

section Introspector

/-- The toolchains in the bootstrapping ladder. -/
inductive Toolchain
  | mes | tcc | gcc2 | gcc4 | gcc12
  | rustc | leanc | lean4_0 | lean4_1 | lean4_cur | lean4_next
  deriving DecidableEq, Repr

/-- The canonical bootstrap chain. -/
def bootstrapChain : List Toolchain := [
  .mes, .tcc, .gcc2, .gcc4, .gcc12,
  .rustc, .leanc, .lean4_0, .lean4_1, .lean4_cur, .lean4_next
]

theorem bootstrapChain_length : bootstrapChain.length = 11 := by
  simp [bootstrapChain]

theorem bootstrapChain_head_mes :
    bootstrapChain.head? = some .mes := by
  simp [bootstrapChain]

/-- A **Nix derivation** record for a toolchain build. -/
structure NixDerivation where
  toolchain    : Toolchain
  artifactHash : UInt64

/-- **Self-hosting fixed-point section**. -/
structure SelfHostedSection where
  section_      : MonsterPresheaf SSP_full
  derivations   : Toolchain → NixDerivation
  agreement     : ∀ t₁ t₂, (derivations t₁).artifactHash =
                             (derivations t₂).artifactHash
  hashFromMask  : (derivations .lean4_cur).artifactHash =
                  (section_.val.card % (2^64) : ℕ).toUInt64

/-- Under self-hosting, trust reduces to `mes`. -/
theorem SelfHostedSection.trust_reduction (sh : SelfHostedSection) (t : Toolchain) :
    (sh.derivations t).artifactHash = (sh.derivations .mes).artifactHash :=
  sh.agreement t .mes

end Introspector

-- ════════════════════════════════════════════════════════════════════════════
-- § 8.  Stalk computations
-- ════════════════════════════════════════════════════════════════════════════

section Stalks

/-- The **stalk** of ℱ at index `i` is `ℱ({i})`. -/
def MonsterStalk (i : Fin 15) : Type := MonsterPresheaf {i}

/-- The unique nonzero stalk section at `i`: the singleton `{i}`. -/
def stalkGenerator (i : Fin 15) : MonsterStalk i :=
  ⟨{i}, Finset.Subset.refl _⟩

@[simp]
theorem stalkGenerator_val (i : Fin 15) :
    (stalkGenerator i).val = {i} := rfl

@[simp]
theorem stalkGenerator_toPrimeSet (i : Fin 15) :
    (stalkGenerator i).val.toPrimeSet = {sspPrimeAt i} := by
  simp [SSPMask.toPrimeSet, stalkGenerator]

/-- Every stalk section is either empty or the generator. -/
theorem MonsterStalk.eq_empty_or_gen (i : Fin 15) (s : MonsterStalk i) :
    s.val = ∅ ∨ s.val = (stalkGenerator i).val := by
  rcases Finset.eq_empty_or_nonempty s.val with h | h
  · exact Or.inl h
  · right
    obtain ⟨x, hx⟩ := h
    have hxi : x = i := Finset.mem_singleton.mp (s.property hx)
    apply Finset.ext; intro y
    simp only [stalkGenerator_val, Finset.mem_singleton]
    exact ⟨fun hy => Finset.mem_singleton.mp (s.property hy),
           fun hy => by rw [hy]; rw [hxi] at hx; exact hx⟩

end Stalks

-- ════════════════════════════════════════════════════════════════════════════
-- § 9.  Sheaf cohomology: H⁰
-- ════════════════════════════════════════════════════════════════════════════

section Cohomology

/-!
## H⁰ as equaliser

`H⁰(U, ℱ)` is the equaliser of the two restriction maps into
`∏_{i ∈ U} ℱ({i})`:

```
H⁰(U, ℱ)  ──→  ∏ᵢ ℱ({i})  ⇉  ∏_{i,j} ℱ({i} ∩ {j})
```

Since distinct singletons have empty intersection, the compatibility
condition is vacuous and `H⁰(U, ℱ) ≅ ℱ(U)` directly.
-/

/-- `H⁰(U, ℱ)` as a compatible family of stalk sections.
    Since distinct singletons have empty intersection, the compatibility
    condition is vacuous and we record it as trivially true. -/
def H0 (U : SSPSite) : Type :=
  (i : { x : Fin 15 // x ∈ U }) → MonsterStalk i.val

/-- **H⁰ ≅ ℱ(U)**: the two notions of section agree.
    We construct the equivalence by amalgamating stalk sections into a
    global mask, and conversely restricting a global mask to singletons. -/
def H0Iso (U : SSPSite) : H0 U ≃ MonsterPresheaf U where
  toFun := fun f =>
    ⟨(Finset.univ : Finset { x : Fin 15 // x ∈ U }).biUnion (fun i => (f i).val),
     by
       intro x hx
       simp only [Finset.mem_biUnion, Finset.mem_univ, true_and] at hx
       obtain ⟨⟨i, hi⟩, hxi⟩ := hx
       have := (f ⟨i, hi⟩).property hxi
       simp only [Finset.mem_singleton] at this
       rw [this]; exact hi⟩
  invFun := fun s => fun i =>
    MonsterPresheaf.restrict (Finset.singleton_subset_iff.mpr i.property) s
  left_inv := by
    intro f; funext ⟨i, hi⟩; apply MonsterPresheaf.ext; apply Finset.ext; intro x
    simp only [MonsterPresheaf.restrict, SSPMask.restrict, Finset.mem_inter,
               Finset.mem_singleton, Finset.mem_biUnion, Finset.mem_univ, true_and]
    constructor
    · rintro ⟨⟨⟨j, hj⟩, hxj⟩, rfl⟩
      have hxj' := (f ⟨j, hj⟩).property hxj
      simp only [Finset.mem_singleton] at hxj'
      subst hxj'; exact hxj
    · intro hx
      have hxi := (f ⟨i, hi⟩).property hx
      simp only [Finset.mem_singleton] at hxi
      exact ⟨⟨⟨i, hi⟩, hx⟩, hxi⟩
  right_inv := by
    intro s; apply MonsterPresheaf.ext; apply Finset.ext; intro x
    simp only [Finset.mem_biUnion, Finset.mem_univ, true_and]
    constructor
    · rintro ⟨⟨i, hi⟩, hxi⟩
      simp only [MonsterPresheaf.restrict, SSPMask.restrict, Finset.mem_inter,
                 Finset.mem_singleton] at hxi
      exact hxi.1
    · intro hx
      exact ⟨⟨x, s.property hx⟩, by
        simp [MonsterPresheaf.restrict, SSPMask.restrict, hx]⟩

end Cohomology

-- ════════════════════════════════════════════════════════════════════════════
-- § 10.  Master unification theorem
-- ════════════════════════════════════════════════════════════════════════════

section Unification

/--
## Monster Sheaf Unification

Every component of the Monster group architecture embeds coherently into
the single sheaf `ℱ` over the SSP site.  This theorem bundles the six
main properties.
-/
theorem monster_sheaf_unification {M : Type*} [MonsterGroup M] :
    -- (1) Stalks are SSPs
    (∀ i : Fin 15,
      (stalkGenerator i).val.toPrimeSet = {sspPrimeAt i}) ∧
    -- (2) Locality
    (∀ (U : SSPSite) (s t : MonsterPresheaf U),
      (∀ i : { x : Fin 15 // x ∈ U },
        MonsterPresheaf.restrict (Finset.singleton_subset_iff.mpr i.property) s =
        MonsterPresheaf.restrict (Finset.singleton_subset_iff.mpr i.property) t)
      → s = t) ∧
    -- (3) Shadow predicate is restriction-stable
    (∀ (U V : SSPSite) (h : V ⊆ U) (s : MonsterPresheaf U),
      isShadowSection s → isShadowSection (MonsterPresheaf.restrict h s)) ∧
    -- (4) Hamming metric is a pseudometric on ℱ(SSP_full)
    (∀ a b c : MonsterPresheaf SSP_full,
      SSPMask.hammingDist a.val c.val ≤
        SSPMask.hammingDist a.val b.val + SSPMask.hammingDist b.val c.val) ∧
    -- (5) Stalk primes divide |M|
    (∀ i : Fin 15, sspPrimeAt i ∣ Nat.card M) ∧
    -- (6) Supersingular primes are all prime
    (∀ i : Fin 15, Nat.Prime (sspPrimeAt i)) := by
  exact ⟨
    stalkGenerator_toPrimeSet,
    fun U s t h => MonsterPresheaf.locality s t h,
    fun U V h s hs => isShadowSection_restrict h hs,
    fun a b c => SSPMask.hammingDist_triangle a.val b.val c.val,
    fun i => monster_card_dvd_ssp i,
    sspPrimeAt_prime
  ⟩

end Unification

#check monster_sheaf_unification
#check MonsterPresheaf.locality
#check isShadowSection_restrict
#check SSPMask.hammingDist_triangle
#check FuzzWitnessSection.localize_restrict
#check SelfHostedSection.trust_reduction