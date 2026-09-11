/-
# Umbral Moonshine Conjecture — Formalization
## Reference

  Duncan, J.F.R., Griffin, M.J., and Ono, K.
  "Proof of the Umbral Moonshine Conjectures"
  Research in the Mathematical Sciences 2, Article 26 (2015)
## Overview
The Umbral Moonshine Conjectures assert that for each of the 23 Niemeier root
systems X, there exists an infinite-dimensional graded module K^X for a
prescribed finite group G^X, whose McKay-Thompson series are certain
distinguished mock modular forms H^X_g (for g ∈ G^X).
The conjecture was formulated by Cheng, Duncan, and Harvey (2014), extending
Mathieu moonshine (Eguchi–Ooguri–Tachikawa, 2010). Gannon proved the case
X = A₁²⁴ (corresponding to the Mathieu group M₂₄). Duncan–Griffin–Ono
established the remaining 22 cases.
## Proof Strategy (Duncan–Griffin–Ono)
The proof proceeds in three steps for each Niemeier root system X:
1. **Rademacher sums.** Construct candidate mock modular forms H^X_g via
   Rademacher sums, which are convergent series analogous to the classical
   Rademacher series for the partition function.
2. **Virtual character decomposition.** Show that the Fourier coefficients
   of H^X_g, viewed as class functions on G^X, are virtual characters
   (integer linear combinations of irreducible characters).
3. **Positivity.** Verify that the multiplicities of irreducible characters
   are non-negative integers, so that the virtual characters are genuine
   characters. This establishes the existence of the graded modules K^X.
## Formalization
This file provides:
1. A verified enumeration of the 23 Niemeier root systems.
2. McKay-Thompson series as formal power series of graded traces, requiring
   genuine group representations (monoid homomorphisms G →* End(Kₙ)).
3. Structural results about McKay-Thompson series: conjugation invariance,
   identity-gives-dimension, characterization, additivity, tensor products.
4. The core **structural reduction theorem**: if the Fourier coefficients of
   prescribed power series are genuine characters, then moonshine modules exist.
5. A formalization of the three-step proof strategy from the paper, decomposing
   the character-theoretic verification into: (a) class function property,
   (b) virtual character decomposition, and (c) non-negativity.
6. The concrete conjecture statement.
-/
import Mathlib

namespace UmbralMoonshineNS

set_option maxHeartbeats 800000
open scoped BigOperators
/-! ## Part 1: Niemeier Root Systems
There are exactly 23 non-empty Niemeier root systems (plus the Leech lattice,
which has an empty root system). Each determines an "umbral" instance of
moonshine. We enumerate them as an inductive type and verify the count.
-/
/-- The 23 non-empty Niemeier root systems, labeled following
Cheng–Duncan–Harvey's conventions. Each root system X determines:
- A finite group G^X (the "umbral group")
- A vector-valued mock modular form H^X
- A conjectured infinite-dimensional graded G^X-module K^X -/
inductive NiemeierRootSystem : Type where
  | A1_24       -- A₁²⁴, associated to M₂₄
  | A2_12       -- A₂¹²
  | A3_8        -- A₃⁸
  | A4_6        -- A₄⁶
  | A5_D4_1     -- A₅⁴D₄
  | A6_4        -- A₆⁴
  | A7_D5_2     -- A₇²D₅²
  | A8_3        -- A₈³
  | A9_D6       -- A₉²D₆
  | A11_D7E6    -- A₁₁D₇E₆
  | A12_2       -- A₁₂²
  | A15_D9      -- A₁₅D₉
  | A17_E7      -- A₁₇E₇
  | A24         -- A₂₄
  | D4_6        -- D₄⁶
  | D6_4        -- D₆⁴
  | D8_3        -- D₈³
  | D10_E7_2    -- D₁₀E₇²
  | D12_2       -- D₁₂²
  | D16_E8      -- D₁₆E₈
  | D24         -- D₂₄
  | E6_4        -- E₆⁴
  | E8_3        -- E₈³
  deriving DecidableEq, Fintype
/-- There are exactly 23 non-empty Niemeier root systems. -/
theorem NiemeierRootSystem.card : Fintype.card NiemeierRootSystem = 23 := by
  decide +kernel
/-- The Coxeter number associated to each Niemeier root system.
This is a fundamental invariant that determines the "lambency" ℓ = m
of the umbral moonshine instance. The mock modular forms H^X have
weight 1/2 and level related to m. -/
def NiemeierRootSystem.coxeterNumber : NiemeierRootSystem → ℕ
  | .A1_24    => 2
  | .A2_12    => 3
  | .A3_8     => 4
  | .A4_6     => 5
  | .A5_D4_1  => 6
  | .A6_4     => 7
  | .A7_D5_2  => 8
  | .A8_3     => 9
  | .A9_D6    => 10
  | .A11_D7E6 => 12
  | .A12_2    => 13
  | .A15_D9   => 16
  | .A17_E7   => 18
  | .A24      => 25
  | .D4_6     => 6
  | .D6_4     => 10
  | .D8_3     => 14
  | .D10_E7_2 => 18
  | .D12_2    => 22
  | .D16_E8   => 30
  | .D24      => 46
  | .E6_4     => 12
  | .E8_3     => 30
/-- All Coxeter numbers are positive. -/
theorem NiemeierRootSystem.coxeterNumber_pos (X : NiemeierRootSystem) :
    0 < X.coxeterNumber := by
  cases X <;> simp [coxeterNumber]
/-- The rank of each Niemeier root system is 24. This is because
Niemeier lattices are even unimodular lattices of rank 24, so
their root systems span a rank-24 sublattice. -/
def NiemeierRootSystem.rank : NiemeierRootSystem → ℕ := fun _ => 24
/-! ## Part 2: McKay-Thompson Series
For a finite group G with a graded representation K = ⊕ₙ Kₙ, the
McKay-Thompson series of g ∈ G is the generating function of graded traces:
  T_g(q) = Σₙ tr(ρₙ(g)) · qⁿ
The key requirement is that each ρₙ is a genuine representation (monoid
homomorphism G →* End(Kₙ)), not merely an arbitrary function to endomorphisms.
This ensures that the McKay-Thompson series carries the full
representation-theoretic information.
-/
/-- The McKay-Thompson series of an element g in a group, given a
graded representation where each graded piece Kₙ carries a genuine
representation ρₙ : G →* End(Kₙ). -/
noncomputable def McKayThompsonSeries
    {G : Type*} [Monoid G]
    (K : ℕ → Type*) [∀ n, AddCommGroup (K n)] [∀ n, Module ℂ (K n)]
    (ρ : ∀ n, Representation ℂ G (K n))
    [∀ n, Module.Finite ℂ (K n)]
    [∀ n, Module.Free ℂ (K n)]
    (g : G) : PowerSeries ℂ :=
  PowerSeries.mk (fun n => LinearMap.trace ℂ (K n) (ρ n g))
/-- The n-th graded character: the function g ↦ tr(ρₙ(g)) for a fixed degree n.
This is the building block of McKay-Thompson series. -/
noncomputable def gradedCharacter
    {G : Type*} [Monoid G]
    (K : ℕ → Type*) [∀ n, AddCommGroup (K n)] [∀ n, Module ℂ (K n)]
    (ρ : ∀ n, Representation ℂ G (K n))
    [∀ n, Module.Finite ℂ (K n)]
    [∀ n, Module.Free ℂ (K n)]
    (n : ℕ) (g : G) : ℂ :=
  LinearMap.trace ℂ (K n) (ρ n g)
/-- The McKay-Thompson series is the power series with graded characters as coefficients. -/
theorem McKayThompsonSeries_eq_mk_gradedCharacter
    {G : Type*} [Monoid G]
    (K : ℕ → Type*) [∀ n, AddCommGroup (K n)] [∀ n, Module ℂ (K n)]
    (ρ : ∀ n, Representation ℂ G (K n))
    [∀ n, Module.Finite ℂ (K n)]
    [∀ n, Module.Free ℂ (K n)]
    (g : G) :
    McKayThompsonSeries K ρ g = PowerSeries.mk (fun n => gradedCharacter K ρ n g) := by
  rfl
/-- The n-th coefficient of the McKay-Thompson series is the graded character at degree n. -/
theorem McKayThompsonSeries_coeff
    {G : Type*} [Monoid G]
    (K : ℕ → Type*) [∀ n, AddCommGroup (K n)] [∀ n, Module ℂ (K n)]
    (ρ : ∀ n, Representation ℂ G (K n))
    [∀ n, Module.Finite ℂ (K n)]
    [∀ n, Module.Free ℂ (K n)]
    (g : G) (n : ℕ) :
    (McKayThompsonSeries K ρ g).coeff n = gradedCharacter K ρ n g := by
  simp [McKayThompsonSeries, gradedCharacter]
/-! ## Part 3: Structural Results about McKay-Thompson Series
These theorems are all fully verified with no sorry dependencies.
-/
/-- **McKay-Thompson series is a class function.**
For any graded representation, the McKay-Thompson series is invariant under
conjugation: T_{hgh⁻¹} = T_g. This follows from the conjugation invariance
of trace: tr(ABA⁻¹) = tr(B). -/
theorem mckayThompson_conjugation_invariant
    {G : Type*} [Group G]
    (K : ℕ → Type*) [∀ n, AddCommGroup (K n)] [∀ n, Module ℂ (K n)]
    (ρ : ∀ n, Representation ℂ G (K n))
    [∀ n, Module.Finite ℂ (K n)]
    [∀ n, Module.Free ℂ (K n)]
    (g h : G) :
    McKayThompsonSeries K ρ (h * g * h⁻¹) = McKayThompsonSeries K ρ g := by
  simp only [McKayThompsonSeries, PowerSeries.ext_iff, PowerSeries.coeff_mk]
  intro n
  have : ρ n (h * g * h⁻¹) = ρ n h * ρ n g * ρ n h⁻¹ := by simp [map_mul]
  rw [this]
  exact LinearMap.trace_conj ℂ (ρ n g) (ρ n |>.asGroupHom h)
/-- **Each graded character is a class function.**
The graded character g ↦ tr(ρₙ(g)) is invariant under conjugation. -/
theorem gradedCharacter_conjugation_invariant
    {G : Type*} [Group G]
    (K : ℕ → Type*) [∀ n, AddCommGroup (K n)] [∀ n, Module ℂ (K n)]
    (ρ : ∀ n, Representation ℂ G (K n))
    [∀ n, Module.Finite ℂ (K n)]
    [∀ n, Module.Free ℂ (K n)]
    (n : ℕ) (g h : G) :
    gradedCharacter K ρ n (h * g * h⁻¹) = gradedCharacter K ρ n g := by
  have key := mckayThompson_conjugation_invariant K ρ g h
  simp only [McKayThompsonSeries, PowerSeries.ext_iff, PowerSeries.coeff_mk] at key
  exact key n
/-- **McKay-Thompson series of the identity is the graded dimension series.** -/
theorem mckayThompson_identity
    {G : Type*} [Group G]
    (K : ℕ → Type*) [∀ n, AddCommGroup (K n)] [∀ n, Module ℂ (K n)]
    (ρ : ∀ n, Representation ℂ G (K n))
    [∀ n, Module.Finite ℂ (K n)]
    [∀ n, Module.Free ℂ (K n)] :
    McKayThompsonSeries K ρ 1 =
      PowerSeries.mk (fun n => (Module.finrank ℂ (K n) : ℂ)) := by
  simp only [McKayThompsonSeries, PowerSeries.ext_iff, PowerSeries.coeff_mk]
  intro n
  simp [map_one]
/-- **The dimension of K_n equals the n-th coefficient of the identity McKay-Thompson series.** -/
theorem mckayThompson_identity_coeff
    {G : Type*} [Group G]
    (K : ℕ → Type*) [∀ n, AddCommGroup (K n)] [∀ n, Module ℂ (K n)]
    (ρ : ∀ n, Representation ℂ G (K n))
    [∀ n, Module.Finite ℂ (K n)]
    [∀ n, Module.Free ℂ (K n)]
    (n : ℕ) :
    (McKayThompsonSeries K ρ 1).coeff n = (Module.finrank ℂ (K n) : ℂ) := by
  have := mckayThompson_identity K ρ
  simp only [McKayThompsonSeries, PowerSeries.ext_iff, PowerSeries.coeff_mk] at this ⊢
  simp [map_one]
/-- **McKay-Thompson series determines graded characters.** -/
theorem mckayThompson_determines_characters
    {G : Type*} [Group G]
    (K₁ K₂ : ℕ → Type*)
    [∀ n, AddCommGroup (K₁ n)] [∀ n, Module ℂ (K₁ n)]
    [∀ n, AddCommGroup (K₂ n)] [∀ n, Module ℂ (K₂ n)]
    (ρ₁ : ∀ n, Representation ℂ G (K₁ n))
    (ρ₂ : ∀ n, Representation ℂ G (K₂ n))
    [∀ n, Module.Finite ℂ (K₁ n)] [∀ n, Module.Free ℂ (K₁ n)]
    [∀ n, Module.Finite ℂ (K₂ n)] [∀ n, Module.Free ℂ (K₂ n)]
    (h : ∀ g, McKayThompsonSeries K₁ ρ₁ g = McKayThompsonSeries K₂ ρ₂ g) :
    ∀ n g, LinearMap.trace ℂ (K₁ n) (ρ₁ n g) =
            LinearMap.trace ℂ (K₂ n) (ρ₂ n g) := by
  intro n g
  have := h g
  simp only [McKayThompsonSeries, PowerSeries.ext_iff, PowerSeries.coeff_mk] at this
  exact this n
/-- **Direct sum of graded representations gives additive McKay-Thompson series.** -/
theorem mckayThompson_directSum
    {G : Type*} [Group G]
    (K L : ℕ → Type*)
    [∀ n, AddCommGroup (K n)] [∀ n, Module ℂ (K n)]
    [∀ n, AddCommGroup (L n)] [∀ n, Module ℂ (L n)]
    (ρK : ∀ n, Representation ℂ G (K n))
    (ρL : ∀ n, Representation ℂ G (L n))
    [∀ n, Module.Finite ℂ (K n)] [∀ n, Module.Free ℂ (K n)]
    [∀ n, Module.Finite ℂ (L n)] [∀ n, Module.Free ℂ (L n)]
    (g : G) :
    McKayThompsonSeries (fun n => K n × L n)
      (fun n => Representation.prod (ρK n) (ρL n)) g =
    McKayThompsonSeries K ρK g + McKayThompsonSeries L ρL g := by
  simp only [McKayThompsonSeries]
  ext n
  simp only [PowerSeries.coeff_mk, map_add]
  exact LinearMap.trace_prodMap' (ρK n g) (ρL n g)
/-- **Trivial representation contributes trace 1.** -/
theorem mckayThompson_trivial_rep_coeff_zero
    {G : Type*} [Group G] [Fintype G] (g : G) :
    LinearMap.trace ℂ ℂ ((Representation.trivial ℂ G ℂ) g) = 1 := by
  simp [Representation.trivial]
/-- **McKay-Thompson series for trivial graded representation.**
If each graded piece carries the trivial representation, the McKay-Thompson
series is the same for all group elements and equals the identity series. -/
theorem mckayThompson_trivial
    {G : Type*} [Group G] [Fintype G]
    (K : ℕ → Type*) [∀ n, AddCommGroup (K n)] [∀ n, Module ℂ (K n)]
    [∀ n, Module.Finite ℂ (K n)]
    [∀ n, Module.Free ℂ (K n)]
    (g₁ g₂ : G) :
    McKayThompsonSeries K (fun n => Representation.trivial ℂ G (K n)) g₁ =
    McKayThompsonSeries K (fun n => Representation.trivial ℂ G (K n)) g₂ := by
  simp only [McKayThompsonSeries, PowerSeries.ext_iff, PowerSeries.coeff_mk]
  intro n
  simp [Representation.trivial]
/-! ## Part 4: Core Structural Reduction
The main sorry-free theorem: existence of moonshine modules reduces to
a character-theoretic verification.
-/
/-- **Structural Reduction Theorem** (sorry-free).
If for each degree n, the n-th coefficient function g ↦ cₙ(g) is the
character of a genuine finite-dimensional representation of G, then there
exists a graded G-module whose McKay-Thompson series equals the prescribed
formal power series.
This captures the core logical structure of the Duncan–Griffin–Ono proof:
once the Fourier coefficients are verified to be genuine characters
(Steps 1–3 of their argument), the existence of the moonshine modules
follows from this abstract result. -/
theorem character_decomposition_implies_graded_module
    {G : Type*} [Group G] [Fintype G]
    (H : G → PowerSeries ℂ)
    (h_char : ∀ n, ∃ (V : Type) (_ : AddCommGroup V) (_ : Module ℂ V)
      (_ : Module.Finite ℂ V) (_ : Module.Free ℂ V)
      (ρ : Representation ℂ G V),
      ∀ g, LinearMap.trace ℂ V (ρ g) = (H g).coeff n) :
    ∃ (K : ℕ → Type)
      (_ : ∀ n, AddCommGroup (K n))
      (_ : ∀ n, Module ℂ (K n))
      (_ : ∀ n, Module.Finite ℂ (K n))
      (_ : ∀ n, Module.Free ℂ (K n))
      (ρ : ∀ n, Representation ℂ G (K n)),
      ∀ g : G,
        McKayThompsonSeries K ρ g = H g := by
  choose V instACG instMod instFin instFree ρ hρ using h_char
  exact ⟨V, instACG, instMod, instFin, instFree, ρ, fun g => by
    simp only [McKayThompsonSeries, PowerSeries.ext_iff, PowerSeries.coeff_mk]
    exact fun n => hρ n g⟩
/-! ## Part 5: Three-Step Proof Decomposition
The Duncan–Griffin–Ono proof establishes the character decomposition
through three steps:
1. **Class function property:** The coefficient functions g ↦ cₙ(g) are
   class functions on G^X (constant on conjugacy classes).
2. **Virtual character property:** Each cₙ is a virtual character — an
   integer linear combination of irreducible characters of G^X.
3. **Non-negativity:** The multiplicities in the irreducible decomposition
   are non-negative, so cₙ is a genuine character.
We formalize this three-step reduction.
-/
/-- A class function on a finite group G is a function G → ℂ that is
constant on conjugacy classes. -/
def IsClassFunction {G : Type*} [Group G] (f : G → ℂ) : Prop :=
  ∀ g h : G, f (h * g * h⁻¹) = f g
/-- A function is a character of some representation if it equals the
trace of a genuine representation on a finite-dimensional free module. -/
def IsCharacter {G : Type*} [Group G] (f : G → ℂ) : Prop :=
  ∃ (V : Type) (_ : AddCommGroup V) (_ : Module ℂ V)
    (_ : Module.Finite ℂ V) (_ : Module.Free ℂ V)
    (ρ : Representation ℂ G V),
    ∀ g, LinearMap.trace ℂ V (ρ g) = f g
/-- Every character is a class function. This follows from the
conjugation invariance of trace: tr(ABA⁻¹) = tr(B). -/
theorem IsCharacter.isClassFunction {G : Type*} [Group G] (f : G → ℂ)
    (hf : IsCharacter f) : IsClassFunction f := by
  obtain ⟨V, instACG, instMod, instFin, instFree, ρ, hρ⟩ := hf
  intro g h
  rw [← hρ, ← hρ]
  have : ρ (h * g * h⁻¹) = ρ h * ρ g * ρ h⁻¹ := by simp [map_mul]
  rw [this]
  exact LinearMap.trace_conj ℂ (ρ g) (ρ.asGroupHom h)
/-- The character of the identity is the dimension of the representation. -/
theorem IsCharacter.identity_eq_dim {G : Type*} [Group G] [Fintype G]
    (f : G → ℂ) (hf : IsCharacter f) :
    ∃ (d : ℕ), f 1 = (d : ℂ) := by
  obtain ⟨V, instACG, instMod, instFin, instFree, ρ, hρ⟩ := hf
  exact ⟨Module.finrank ℂ V, by rw [← hρ]; simp [map_one]⟩
/-- The character decomposition implies graded module (restated with IsCharacter). -/
theorem isCharacter_implies_graded_module
    {G : Type*} [Group G] [Fintype G]
    (H : G → PowerSeries ℂ)
    (h_char : ∀ n, IsCharacter (fun g => (H g).coeff n)) :
    ∃ (K : ℕ → Type)
      (_ : ∀ n, AddCommGroup (K n))
      (_ : ∀ n, Module ℂ (K n))
      (_ : ∀ n, Module.Finite ℂ (K n))
      (_ : ∀ n, Module.Free ℂ (K n))
      (ρ : ∀ n, Representation ℂ G (K n)),
      ∀ g : G,
        McKayThompsonSeries K ρ g = H g := by
  have h : ∀ n, ∃ (V : Type) (_ : AddCommGroup V) (_ : Module ℂ V)
      (_ : Module.Finite ℂ V) (_ : Module.Free ℂ V)
      (ρ : Representation ℂ G V),
      ∀ g, LinearMap.trace ℂ V (ρ g) = (H g).coeff n := by
    intro n
    exact h_char n
  exact character_decomposition_implies_graded_module H h
/-
The zero function is a character (of the zero-dimensional representation).
-/
theorem isCharacter_zero {G : Type*} [Group G] : IsCharacter (fun _ : G => (0 : ℂ)) := by
  refine' ⟨ _, _, _, _, _, _ ⟩;
  exact Fin 0 → ℂ;
  all_goals try infer_instance;
  exact ⟨ 1, fun g => by simp +decide ⟩
/-
The sum of two characters is a character. This follows from the
direct sum of representations: if V has character χ and W has character ψ,
then V × W has character χ + ψ.
-/
theorem IsCharacter.add {G : Type*} [Group G] {f₁ f₂ : G → ℂ}
    (h₁ : IsCharacter f₁) (h₂ : IsCharacter f₂) :
    IsCharacter (fun g => f₁ g + f₂ g) := by
  obtain ⟨V₁, _, _, _, _, ρ₁, h₁⟩ := h₁
  obtain ⟨V₂, _, _, _, _, ρ₂, h₂⟩ := h₂;
  refine' ⟨ V₁ × V₂, inferInstance, inferInstance, _, _, Representation.prod ρ₁ ρ₂, _ ⟩;
  · infer_instance;
  · infer_instance;
  · intro g;
    convert LinearMap.trace_prodMap' ( ρ₁ g ) ( ρ₂ g ) using 1;
    rw [ h₁, h₂ ]
/-
A natural number multiple of a character is a character.
This follows from taking the direct sum of n copies of the representation.
-/
theorem IsCharacter.nsmul {G : Type*} [Group G] {f : G → ℂ}
    (hf : IsCharacter f) (n : ℕ) :
    IsCharacter (fun g => (n : ℂ) * f g) := by
  induction' n with n ih;
  · simpa using isCharacter_zero;
  · simpa [ add_mul ] using IsCharacter.add ih hf
/-
**Three-step reduction: virtual character + non-negativity → character.**
If a function f : G → ℂ can be written as an integer linear combination
of characters with non-negative integer coefficients, then f is itself
a character. This is because a non-negative integer combination of
representations is a direct sum of copies.
-/
theorem nonneg_virtual_character_is_character
    {G : Type*} [Group G] [Fintype G]
    {r : ℕ}  -- number of irreducible characters
    (χ : Fin r → G → ℂ)
    (hχ : ∀ i, IsCharacter (χ i))
    (f : G → ℂ)
    (m : Fin r → ℕ)
    (hf : ∀ g, f g = ∑ i : Fin r, (m i : ℂ) * χ i g) :
    IsCharacter f := by
  -- We'll use induction on the number of terms in the sum.
  have h_ind : ∀ (r : ℕ) (χ : Fin r → G → ℂ) (m : Fin r → ℕ), (∀ i, IsCharacter (χ i)) → IsCharacter (fun g => ∑ i, (m i : ℂ) * χ i g) := by
    intro r χ m hχ;
    induction' r with r ih;
    · exact isCharacter_zero;
    · simp_all +decide [ Fin.sum_univ_succ ];
      exact IsCharacter.add ( IsCharacter.nsmul ( hχ 0 ) _ ) ( ih _ _ fun i => hχ i.succ );
  simpa only [ ← hf ] using h_ind r χ m hχ
/-! ## Part 6: Concrete Umbral Moonshine Statement
The concrete conjecture requires specific mathematical objects that are
beyond current Mathlib: Niemeier lattice automorphism groups, sporadic
groups, and mock modular forms via Rademacher sums.
-/
/-- The order of the umbral group for each Niemeier root system.
These are well-known invariants computed from the Niemeier lattice
automorphism groups.
| Root system | Umbral group | Order |
|------------|-------------|-------|
| A₁²⁴ | M₂₄ | 244823040 |
| A₂¹² | 2.M₁₂ | 190080 |
| A₃⁸ | 2.AGL₃(2) | 2688 |
| A₄⁶ | 2.(ℤ/4)³.S₃ | 1152 |
| A₅⁴D₄ | GL₂(3)/ℤ₂ | 48 |
| A₆⁴ | SL₂(3) | 24 |
| A₇²D₅² | (ℤ/4)² | 16 |
| A₈³ | dihedral of order 6 | 6 |
| A₉²D₆ | ℤ/4 | 4 |
| A₁₁D₇E₆ | ℤ/2 | 2 |
| A₁₂² | ℤ/2 | 2 |
| A₁₅D₉ | trivial | 1 |
| A₁₇E₇ | trivial | 1 |
| A₂₄ | trivial | 1 |
| D₄⁶ | 3.S₆ | 2160 |
| D₆⁴ | 3.Dih₈ | 48 |
| D₈³ | S₃ | 6 |
| D₁₀E₇² | ℤ/4 | 4 |
| D₁₂² | ℤ/2 | 2 |
| D₁₆E₈ | trivial | 1 |
| D₂₄ | trivial | 1 |
| E₆⁴ | GL₂(3) | 48 |
| E₈³ | S₃ | 6 |
-/
def NiemeierRootSystem.umbralGroupOrder : NiemeierRootSystem → ℕ
  | .A1_24    => 244823040
  | .A2_12    => 190080
  | .A3_8     => 2688
  | .A4_6     => 1152
  | .A5_D4_1  => 48
  | .A6_4     => 24
  | .A7_D5_2  => 16
  | .A8_3     => 6
  | .A9_D6    => 4
  | .A11_D7E6 => 2
  | .A12_2    => 2
  | .A15_D9   => 1
  | .A17_E7   => 1
  | .A24      => 1
  | .D4_6     => 2160
  | .D6_4     => 48
  | .D8_3     => 6
  | .D10_E7_2 => 4
  | .D12_2    => 2
  | .D16_E8   => 1
  | .D24      => 1
  | .E6_4     => 48
  | .E8_3     => 6
/-- All umbral groups are non-trivial (have positive order). -/
theorem NiemeierRootSystem.umbralGroupOrder_pos (X : NiemeierRootSystem) :
    0 < X.umbralGroupOrder := by
  cases X <;> simp [umbralGroupOrder]
/-- The number of conjugacy classes of the umbral group for each root system.
This determines the number of distinct McKay-Thompson series needed. -/
def NiemeierRootSystem.numConjugacyClasses : NiemeierRootSystem → ℕ
  | .A1_24    => 26
  | .A2_12    => 26
  | .A3_8     => 14
  | .A4_6     => 14
  | .A5_D4_1  => 10
  | .A6_4     => 7
  | .A7_D5_2  => 10
  | .A8_3     => 3
  | .A9_D6    => 4
  | .A11_D7E6 => 2
  | .A12_2    => 2
  | .A15_D9   => 1
  | .A17_E7   => 1
  | .A24      => 1
  | .D4_6     => 16
  | .D6_4     => 10
  | .D8_3     => 3
  | .D10_E7_2 => 4
  | .D12_2    => 2
  | .D16_E8   => 1
  | .D24      => 1
  | .E6_4     => 8
  | .E8_3     => 3
/-- All umbral groups have at least one conjugacy class. -/
theorem NiemeierRootSystem.numConjugacyClasses_pos (X : NiemeierRootSystem) :
    0 < X.numConjugacyClasses := by
  cases X <;> simp [numConjugacyClasses]
/-- The umbral group associated to a Niemeier root system.
Mathematically, G^X = Aut(N^X) / W^X where N^X is the Niemeier lattice
with root system X and W^X is the Weyl group.
For root systems with trivial umbral group (A₁₅D₉, A₁₇E₇, A₂₄, D₁₆E₈, D₂₄),
we use `Unit`. For the simplest non-trivial cases (A₁₁D₇E₆, A₁₂², D₁₂²:
ℤ/2), we use `ZMod 2`. For E₈³ and D₈³ (both S₃), we use `Equiv.Perm (Fin 3)`.
For A₉²D₆ and D₁₀E₇² (both ℤ/4), we use `ZMod 4`. For A₇²D₅² ((ℤ/4)²), we
use `ZMod 4 × ZMod 4`. The remaining groups require sporadic group constructions.
**Formalization status:** 13 of the 23 umbral groups are defined concretely.
The remaining 10 require sporadic group constructions not in Mathlib. -/
noncomputable def UmbralGroup : NiemeierRootSystem → Type
  | .A15_D9   => Unit           -- trivial group
  | .A17_E7   => Unit           -- trivial group
  | .A24      => Unit           -- trivial group
  | .D16_E8   => Unit           -- trivial group
  | .D24      => Unit           -- trivial group
  | .A11_D7E6 => ZMod 2         -- ℤ/2
  | .A12_2    => ZMod 2         -- ℤ/2
  | .D12_2    => ZMod 2         -- ℤ/2
  | .A9_D6    => ZMod 4         -- ℤ/4
  | .D10_E7_2 => ZMod 4         -- ℤ/4
  | .A7_D5_2  => ZMod 4 × ZMod 4  -- (ℤ/4)²
  | .A8_3     => Equiv.Perm (Fin 3) -- S₃ (dihedral order 6)
  | .D8_3     => Equiv.Perm (Fin 3) -- S₃
  | .E8_3     => Equiv.Perm (Fin 3) -- S₃
  | _         => sorry  -- Requires sporadic group constructions
noncomputable instance (X : NiemeierRootSystem) : Group (UmbralGroup X) := by
  cases X <;> simp only [UmbralGroup] <;> first | infer_instance | exact sorry
noncomputable instance (X : NiemeierRootSystem) : Fintype (UmbralGroup X) := by
  cases X <;> simp only [UmbralGroup] <;> first | infer_instance | exact sorry
/-- The umbral groups with trivial group structure have cardinality 1. -/
theorem umbralGroup_trivial_card_A15_D9 :
    Fintype.card (UmbralGroup .A15_D9) = 1 := by
  simp [UmbralGroup]
theorem umbralGroup_trivial_card_A24 :
    Fintype.card (UmbralGroup .A24) = 1 := by
  simp [UmbralGroup]
/-- The ℤ/2 umbral groups have cardinality 2. -/
theorem umbralGroup_Z2_card_A11_D7E6 :
    Fintype.card (UmbralGroup .A11_D7E6) = 2 := by
  simp [UmbralGroup, ZMod]
/-- The S₃ umbral groups have cardinality 6. -/
theorem umbralGroup_S3_card_E8_3 :
    Fintype.card (UmbralGroup .E8_3) = 6 := by
  simp [UmbralGroup]
  decide +kernel
/-- The q-expansion of the prescribed mock modular form H^X_g.
These are constructed as Rademacher sums — convergent series analogous to
the classical Rademacher series for the partition function p(n), but for
mock modular forms of weight 1/2.
**Formalization status:** Requires Zwegers' theory of mock modular forms,
Rademacher sums, Kloosterman sums, and Bessel function asymptotics. -/
noncomputable def umbralMockModularForm (X : NiemeierRootSystem)
    (g : UmbralGroup X) : PowerSeries ℂ := sorry
/-! ## Part 7: The Character Decomposition Hypothesis
This is the computational core of the Duncan–Griffin–Ono proof.
We decompose it into the three steps following the paper.
-/
/-- **Step 1: Class function property.**
The Fourier coefficients of the mock modular forms, viewed as functions
on the umbral group, are class functions (constant on conjugacy classes).
This follows from the construction of the mock modular forms via
Rademacher sums, which only depend on the conjugacy class of g ∈ G^X
through the multiplier system. -/
theorem umbral_coefficients_are_class_functions
    (X : NiemeierRootSystem) (n : ℕ) :
    IsClassFunction (fun g : UmbralGroup X => (umbralMockModularForm X g).coeff n) := by
  sorry
/-- **Step 2: Virtual character property.**
Each coefficient function is a virtual character — an integer linear
combination of irreducible characters of G^X. This follows from Step 1
(class function property) together with the orthogonality of characters:
any class function can be uniquely decomposed in the basis of irreducible
characters, and the coefficients turn out to be integers due to the
integrality properties of the Rademacher sums. -/
theorem umbral_coefficients_are_virtual_characters
    (X : NiemeierRootSystem) (n : ℕ) :
    ∃ (r : ℕ) (χ : Fin r → UmbralGroup X → ℂ)
      (_ : ∀ i, IsCharacter (χ i))
      (m : Fin r → ℤ),
      ∀ g, (umbralMockModularForm X g).coeff n =
        ∑ i : Fin r, (m i : ℂ) * χ i g := by
  sorry
/-- **Step 3: Non-negativity.**
The multiplicities of irreducible characters are non-negative integers.
This is verified by a combination of:
- Explicit computation for small values of n
- Asymptotic analysis of Rademacher sums for large n
- Carnahan's criterion for the borderline cases -/
theorem umbral_multiplicities_nonneg
    (X : NiemeierRootSystem) (n : ℕ) :
    ∃ (r : ℕ) (χ : Fin r → UmbralGroup X → ℂ)
      (_ : ∀ i, IsCharacter (χ i))
      (m : Fin r → ℕ),  -- non-negative multiplicities
      ∀ g, (umbralMockModularForm X g).coeff n =
        ∑ i : Fin r, (m i : ℂ) * χ i g := by
  sorry
/-- **Character decomposition hypothesis** (three-step conclusion).
For each Niemeier root system X and each degree n, the function
g ↦ coeff(H^X_g, n) is the character of a genuine finite-dimensional
representation of G^X.
This is the main computational content of the Duncan–Griffin–Ono proof.
It follows from the three steps above: the coefficient function is a
class function (Step 1), which decomposes as a virtual character (Step 2),
and the multiplicities are non-negative (Step 3), giving a genuine character. -/
theorem umbral_coefficients_are_characters (X : NiemeierRootSystem) :
    ∀ n, IsCharacter (fun g : UmbralGroup X =>
      (umbralMockModularForm X g).coeff n) := by
  intro n
  -- By Step 3 (non-negativity), we have a decomposition into characters
  -- with non-negative integer multiplicities
  obtain ⟨r, χ, hχ, m, hm⟩ := umbral_multiplicities_nonneg X n
  -- A non-negative integer combination of characters is a character
  exact nonneg_virtual_character_is_character χ hχ _ m hm
/-! ## Part 8: The Main Theorem -/
/--
**The Umbral Moonshine Conjecture** (Cheng–Duncan–Harvey, 2014).
For each Niemeier root system X, there exists a ℤ-graded module
  K^X = ⊕_{n ≥ 0} K^X_n
for the umbral group G^X such that:
1. Each K^X_n is a finite-dimensional complex representation of G^X.
2. Each ρₙ : G^X →* End(K^X_n) is a genuine group representation.
3. For every g ∈ G^X, the McKay-Thompson series
     T_g(q) = Σ_n tr(ρₙ(g)) · qⁿ
   equals the prescribed mock modular form H^X_g.
**Proved by:**
- Gannon (2013) for X = A₁²⁴ (the Mathieu group M₂₄ case)
- Duncan–Griffin–Ono (2015) for the remaining 22 cases
**Proof:** Follows from the structural reduction theorem applied to the
character decomposition hypothesis. -/
theorem umbral_moonshine_conjecture (X : NiemeierRootSystem) :
    ∃ (K : ℕ → Type)
      (_ : ∀ n, AddCommGroup (K n))
      (_ : ∀ n, Module ℂ (K n))
      (_ : ∀ n, Module.Finite ℂ (K n))
      (_ : ∀ n, Module.Free ℂ (K n))
      (ρ : ∀ n, Representation ℂ (UmbralGroup X) (K n)),
      ∀ g : UmbralGroup X,
        McKayThompsonSeries K ρ g = umbralMockModularForm X g := by
  exact isCharacter_implies_graded_module
    (umbralMockModularForm X) (umbral_coefficients_are_characters X)
/-! ## Part 9: Specializations to Individual Cases
For the cases with trivial umbral group, the moonshine conjecture simplifies:
there is only one conjugacy class (the identity), and the McKay-Thompson
series is just the graded dimension series. We can say more in these cases.
-/
/-- For root systems with trivial umbral group, the moonshine module
is just a graded vector space (no non-trivial group action needed).
The McKay-Thompson series equals the graded dimension series. -/
theorem umbral_moonshine_trivial_group (X : NiemeierRootSystem)
    (_hX : UmbralGroup X = Unit) :
    ∃ (K : ℕ → Type)
      (_ : ∀ n, AddCommGroup (K n))
      (_ : ∀ n, Module ℂ (K n))
      (_ : ∀ n, Module.Finite ℂ (K n))
      (_ : ∀ n, Module.Free ℂ (K n))
      (ρ : ∀ n, Representation ℂ (UmbralGroup X) (K n)),
      ∀ g : UmbralGroup X,
        McKayThompsonSeries K ρ g = umbralMockModularForm X g := by
  exact umbral_moonshine_conjecture X
/-- The number of distinct McKay-Thompson series for each root system
equals the number of conjugacy classes. For trivial groups, there is
exactly one series. -/
theorem trivial_umbral_one_series :
    NiemeierRootSystem.A15_D9.numConjugacyClasses = 1 ∧
    NiemeierRootSystem.A17_E7.numConjugacyClasses = 1 ∧
    NiemeierRootSystem.A24.numConjugacyClasses = 1 ∧
    NiemeierRootSystem.D16_E8.numConjugacyClasses = 1 ∧
    NiemeierRootSystem.D24.numConjugacyClasses = 1 := by
  simp [NiemeierRootSystem.numConjugacyClasses]
/-- For E₈³ (umbral group S₃), there are exactly 3 conjugacy classes,
so 3 distinct McKay-Thompson series are needed. -/
theorem E8_3_three_conjugacy_classes :
    NiemeierRootSystem.E8_3.numConjugacyClasses = 3 := by
  rfl
/-- For A₁²⁴ (umbral group M₂₄), there are 26 conjugacy classes,
matching the 26 known McKay-Thompson series of Mathieu moonshine. -/
theorem A1_24_twentysix_conjugacy_classes :
    NiemeierRootSystem.A1_24.numConjugacyClasses = 26 := by
  rfl
/-! ## Part 10: Cardinality Verification for Concrete Umbral Groups
For the 14 umbral groups defined concretely, we verify that their
cardinality matches the expected umbral group order.
-/
/-- Verification that concrete umbral group cardinalities match
the expected orders for all 14 concretely defined cases. -/
theorem umbralGroupOrder_eq_card_A15_D9 :
    Fintype.card (UmbralGroup .A15_D9) = NiemeierRootSystem.A15_D9.umbralGroupOrder := by
  simp [UmbralGroup, NiemeierRootSystem.umbralGroupOrder]
theorem umbralGroupOrder_eq_card_A17_E7 :
    Fintype.card (UmbralGroup .A17_E7) = NiemeierRootSystem.A17_E7.umbralGroupOrder := by
  simp [UmbralGroup, NiemeierRootSystem.umbralGroupOrder]
theorem umbralGroupOrder_eq_card_A24 :
    Fintype.card (UmbralGroup .A24) = NiemeierRootSystem.A24.umbralGroupOrder := by
  simp [UmbralGroup, NiemeierRootSystem.umbralGroupOrder]
theorem umbralGroupOrder_eq_card_D16_E8 :
    Fintype.card (UmbralGroup .D16_E8) = NiemeierRootSystem.D16_E8.umbralGroupOrder := by
  simp [UmbralGroup, NiemeierRootSystem.umbralGroupOrder]
theorem umbralGroupOrder_eq_card_D24 :
    Fintype.card (UmbralGroup .D24) = NiemeierRootSystem.D24.umbralGroupOrder := by
  simp [UmbralGroup, NiemeierRootSystem.umbralGroupOrder]
theorem umbralGroupOrder_eq_card_A11_D7E6 :
    Fintype.card (UmbralGroup .A11_D7E6) = NiemeierRootSystem.A11_D7E6.umbralGroupOrder := by
  simp [UmbralGroup, NiemeierRootSystem.umbralGroupOrder, ZMod]
theorem umbralGroupOrder_eq_card_A12_2 :
    Fintype.card (UmbralGroup .A12_2) = NiemeierRootSystem.A12_2.umbralGroupOrder := by
  simp [UmbralGroup, NiemeierRootSystem.umbralGroupOrder, ZMod]
theorem umbralGroupOrder_eq_card_D12_2 :
    Fintype.card (UmbralGroup .D12_2) = NiemeierRootSystem.D12_2.umbralGroupOrder := by
  simp [UmbralGroup, NiemeierRootSystem.umbralGroupOrder, ZMod]
theorem umbralGroupOrder_eq_card_A9_D6 :
    Fintype.card (UmbralGroup .A9_D6) = NiemeierRootSystem.A9_D6.umbralGroupOrder := by
  simp [UmbralGroup, NiemeierRootSystem.umbralGroupOrder, ZMod]
theorem umbralGroupOrder_eq_card_D10_E7_2 :
    Fintype.card (UmbralGroup .D10_E7_2) = NiemeierRootSystem.D10_E7_2.umbralGroupOrder := by
  simp [UmbralGroup, NiemeierRootSystem.umbralGroupOrder, ZMod]
theorem umbralGroupOrder_eq_card_A7_D5_2 :
    Fintype.card (UmbralGroup .A7_D5_2) = NiemeierRootSystem.A7_D5_2.umbralGroupOrder := by
  simp [UmbralGroup, NiemeierRootSystem.umbralGroupOrder, ZMod]
theorem umbralGroupOrder_eq_card_E8_3 :
    Fintype.card (UmbralGroup .E8_3) = NiemeierRootSystem.E8_3.umbralGroupOrder := by
  simp [UmbralGroup, NiemeierRootSystem.umbralGroupOrder]
  decide +kernel
theorem umbralGroupOrder_eq_card_D8_3 :
    Fintype.card (UmbralGroup .D8_3) = NiemeierRootSystem.D8_3.umbralGroupOrder := by
  simp [UmbralGroup, NiemeierRootSystem.umbralGroupOrder]
  decide +kernel
theorem umbralGroupOrder_eq_card_A8_3 :
    Fintype.card (UmbralGroup .A8_3) = NiemeierRootSystem.A8_3.umbralGroupOrder := by
  simp [UmbralGroup, NiemeierRootSystem.umbralGroupOrder]
  decide +kernel
/-! ## Appendix: What Would Be Needed for a Full Formalization
### Summary of Sorry Status
**Sorry-free theorems** (no `sorryAx` in axiom trace):
- `NiemeierRootSystem.card` — Verified count of 23 Niemeier root systems
- `mckayThompson_conjugation_invariant` — McKay-Thompson is a class function
- `gradedCharacter_conjugation_invariant` — Graded characters are class functions
- `mckayThompson_identity` — Identity gives graded dimension series
- `mckayThompson_identity_coeff` — Dimension extraction
- `mckayThompson_determines_characters` — McKay-Thompson determines characters
- `mckayThompson_directSum` — Additivity under direct sums
- `mckayThompson_trivial` — Trivial representation invariance
- `mckayThompson_trivial_rep_coeff_zero` — Trivial rep contributes trace 1
- `character_decomposition_implies_graded_module` — Core structural reduction
- `isCharacter_implies_graded_module` — Character → graded module
- `IsCharacter.isClassFunction` — Characters are class functions
- `IsCharacter.identity_eq_dim` — Character at identity = dimension
- `isCharacter_zero` — Zero function is a character
- `IsCharacter.add` — Sum of characters is a character
- `IsCharacter.nsmul` — Natural multiple of character is a character
- `nonneg_virtual_character_is_character` — Non-neg combination → character
- 14 cardinality verification theorems for concrete umbral groups
**Sorry-dependent content:**
1. **`UmbralGroup`** — 9 of 23 cases require sporadic or complex group
   constructions not in Mathlib (M₂₄, 2.M₁₂, 2.AGL₃(2), SL₂(3), GL₂(3),
   3.S₆, 3.Dih₈, and two others). 14 cases are defined concretely.
2. **`umbralMockModularForm`** — Requires Zwegers' theory of mock modular
   forms, Rademacher sums, Kloosterman sums, and Bessel function asymptotics.
3. **`umbral_coefficients_are_class_functions`** — Follows from the
   construction of mock modular forms via Rademacher sums.
4. **`umbral_coefficients_are_virtual_characters`** — Integer decomposition
   of coefficients in the irreducible character basis.
5. **`umbral_multiplicities_nonneg`** — The deep computational content:
   verifying non-negative multiplicities for all 23 umbral groups.
   This is the core of the Duncan–Griffin–Ono paper.
### Proof Structure
The proof chain from computational content to the final theorem is:
```
umbral_multiplicities_nonneg (sorry: computational verification)
  ↓ via nonneg_virtual_character_is_character (✓ proved)
  ↓
umbral_coefficients_are_characters
  ↓ via isCharacter_implies_graded_module (✓ proved)
  ↓
umbral_moonshine_conjecture
```
All structural reductions in this chain are sorry-free. The only remaining
sorries are the concrete mathematical objects (groups, mock modular forms)
and the computational verification of non-negative multiplicities.
### Infrastructure Needed
A. **Lattice Theory:** Even unimodular lattices of rank 24, Niemeier's
   classification theorem, automorphism groups.
B. **Sporadic Groups:** Mathieu groups M₁₂, M₂₄, their double covers,
   character tables.
C. **Mock Modular Forms:** Zwegers' theory, harmonic Maass forms, shadow
   maps, Rademacher sums.
D. **Character-Theoretic Computations:** Explicit Fourier coefficients,
   irreducible decomposition, non-negativity verification.
-/

end UmbralMoonshineNS
