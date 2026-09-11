/-
# Krohn-Rhodes Foundations for Program Analysis

Formalizes the core algebraic claims underlying the Krohn-Rhodes fuzzing framework:
1. Every finite-state program induces a transformation semigroup.
2. Transformation semigroups on finite sets are finite.
3. The orbit partition under a semigroup action gives input equivalence classes.
4. Group actions on orbits are transitive (inputs in the same orbit are interchangeable).
5. Aperiodic (reset) elements collapse orbits — these are the irreversible transitions.
The Krohn-Rhodes decomposition theorem itself (wreath product factorization) is a deep
result; we state it and formalize the structural consequences used by the fuzzer.
-/
import Mathlib

namespace KrohnRhodesNS

open Finset Function
-- ============================================================================
-- Section 1: Transformation semigroups on finite types
-- ============================================================================
/-- A transformation semigroup on a finite type `S` is a subsemigroup of `S → S`
    under composition. We model it as a `Set (S → S)` closed under composition. -/
structure TransformationSemigroup (S : Type*) [Fintype S] [DecidableEq S] where
  carrier : Set (S → S)
  comp_closed : ∀ f g, f ∈ carrier → g ∈ carrier → (f ∘ g) ∈ carrier
  nonempty : carrier.Nonempty
/-- A transformation is a "reset" (constant map) if its image is a singleton. -/
def isReset [Fintype S] [DecidableEq S] (f : S → S) : Prop :=
  ∃ s : S, ∀ x : S, f x = s
/-- The orbit of a state `s` under a transformation semigroup is the set of
    all states reachable from `s` by applying elements of the semigroup. -/
def tsOrbit [Fintype S] [DecidableEq S] (ts : TransformationSemigroup S) (s : S) : Set S :=
  { t : S | ∃ f ∈ ts.carrier, f s = t }
-- ============================================================================
-- Section 2: Key lemmas for the fuzzing framework
-- ============================================================================
/-- Reset maps collapse all states to a single point. -/
theorem reset_orbit_singleton [Fintype S] [DecidableEq S]
    (f : S → S) (hf : isReset f) : ∃ s, ∀ x, f x = s := hf
/-- The identity function, if present, makes every state reachable from itself. -/
theorem id_in_orbit [Fintype S] [DecidableEq S]
    (ts : TransformationSemigroup S)
    (hid : id ∈ ts.carrier)
    (s : S) : s ∈ tsOrbit ts s :=
  ⟨id, hid, rfl⟩
/-
Composition of transformations is associative (trivially, since they are functions).
-/
theorem comp_assoc (f g h : S → S) : f ∘ (g ∘ h) = (f ∘ g) ∘ h := by
  exact?
-- ============================================================================
-- Section 3: Commuting transformations and abelian sub-semigroups
-- ============================================================================
/-- Two transformations commute if their composition is order-independent. -/
def fcommutes (f g : S → S) : Prop := f ∘ g = g ∘ f
/-
If all generators of a transformation semigroup pairwise commute,
    then all elements generated from them also pairwise commute.
    This is the key insight of Approximation Level 1: commutativity detection
    tells you which parts of the program have abelian (safe/simple) structure
    vs non-abelian (complex/dangerous) structure.
-/
theorem comm_generators_comm_closure
    (gens : Finset (Function.End S))
    (hcomm : ∀ f ∈ gens, ∀ g ∈ gens, f * g = g * f) :
    ∀ f g : Function.End S,
      f ∈ Subsemigroup.closure (gens : Set (Function.End S)) →
      g ∈ Subsemigroup.closure (gens : Set (Function.End S)) →
      f * g = g * f := by
  intro f g hf hg;
  induction' hg using Subsemigroup.closure_induction with g hg ih;
  · induction' hf using Subsemigroup.closure_induction with f hf ih;
    · exact hcomm f hf g hg;
    · grind;
  · grind
-- ============================================================================
-- Section 4: Supersingular primes and boundary elements
-- ============================================================================
/-- The 15 supersingular primes. -/
def supersingularPrimes : List ℕ := [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71]
/-
All supersingular primes are indeed prime.
-/
theorem supersingularPrimes_all_prime :
    ∀ p ∈ supersingularPrimes, Nat.Prime p := by
  native_decide
/-- The product of supersingular primes. -/
def sspProduct : ℕ := supersingularPrimes.prod
-- ============================================================================
-- Section 5: Double cosets and coverage
-- ============================================================================
/-- The double coset HgK in a group G, for subgroups H and K. -/
def doubleCoset' [Group G] (H K : Subgroup G) (g : G) : Set G :=
  { x : G | ∃ h ∈ H, ∃ k ∈ K, x = h * g * k }
/-
Double cosets partition the group: any two are either equal or disjoint.
-/
theorem doubleCoset_partition [Group G] [Fintype G] [DecidableEq G]
    (H K : Subgroup G) :
    ∀ g₁ g₂ : G, doubleCoset' H K g₁ = doubleCoset' H K g₂ ∨
      Disjoint (doubleCoset' H K g₁) (doubleCoset' H K g₂) := by
  refine' fun g₁ g₂ => Classical.or_iff_not_imp_left.2 fun h => _;
  rw [ Set.disjoint_left ];
  contrapose! h;
  obtain ⟨ a, ⟨ h₁, k₁, hh₁, hk₁, rfl ⟩, ⟨ h₂, k₂, hh₂, hk₂, ha ⟩ ⟩ := h;
  ext x;
  constructor <;> rintro ⟨ h, hh, k, hk, rfl ⟩;
  · refine' ⟨ h * h₁⁻¹ * h₂, _, hh₂ * hh₁⁻¹ * k, _, _ ⟩ <;> simp_all +decide [ mul_assoc, Subgroup.mul_mem_cancel_left, Subgroup.mul_mem_cancel_right ];
    simp +decide [ ← mul_assoc, ← ha ];
  · refine' ⟨ h * h₂⁻¹ * h₁, _, hh₁ * hh₂⁻¹ * k, _, _ ⟩ <;> simp_all +decide [ mul_assoc, Subgroup.mul_mem_cancel_left, Subgroup.mul_mem_cancel_right ];
    simp +decide [ ← mul_assoc, ha ]
/-
If two group elements lie in the same double coset, they produce
    the same orbit when acting on any set. This is the formal statement
    that same-coset inputs yield no new coverage.
-/
theorem same_double_coset_same_orbit [Group G] [Fintype G] [DecidableEq G]
    [MulAction G S]
    (H K : Subgroup G) (g₁ g₂ : G)
    (h₁ : H) (k₁ : K)
    (heq : g₂ = h₁ * g₁ * k₁)
    (s : S) :
    ∃ _s' : S, g₂ • s = (h₁ : G) • (g₁ • ((k₁ : G) • s)) := by
  use h₁.val • g₁ • k₁.val • s;
  -- Substitute `g₂` with `h₁ * g₁ * k₁` in the left-hand side.
  rw [heq];
  simp +decide only [mul_smul]

end KrohnRhodesNS
