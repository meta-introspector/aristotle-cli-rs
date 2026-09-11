import Mathlib

open scoped BigOperators
open scoped Real
open scoped Nat
open scoped Classical
open scoped Pointwise

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000
set_option synthInstance.maxHeartbeats 20000
set_option synthInstance.maxSize 128

set_option relaxedAutoImplicit false
set_option autoImplicit false

set_option grind.warning false

/-!
# Formalizing core claims of a Univalent Proof Architecture

This file extracts and formally verifies the genuinely checkable mathematical
content of the accompanying technical specification on Homotopy Type Theory
(HoTT) / Univalent Foundations.

The objects discussed in the specification — contractible types, mere
propositions, sets, the canonical map `(A = B) → (A ≃ B)` of the Univalence
Axiom, path induction (the `J`-rule), and the apartness relation — are all
formalized below as Lean definitions, and the stated relationships between them
are proved.

**Foundational caveat.** Lean's type theory is *not* univalent: it validates
the principle of Uniqueness of Identity Proofs (UIP, available here via
definitional proof irrelevance for `Prop`). Consequently the higher levels of
the `n`-type hierarchy collapse — *every* type is automatically a "set"
(`everything_isSet`). We record this fact explicitly; it is precisely the
phenomenon that distinguishes Lean's foundation from the univalent foundation
described in the specification, where these levels are genuinely distinct. The
implications between the levels (contractible ⟹ proposition ⟹ set) nonetheless
hold and are proved here exactly as stated.
-/

universe u v

namespace UnivalentArchitecture

/-! ## §2. The hierarchy of `n`-types -/

/-- A type is **contractible** (a `(-2)`-type) when it has a center of
contraction to which every point is equal. This is the "singleton at the
highest level of rigor" of the specification. -/
def IsContr (A : Sort u) : Sort (max 1 u) := Σ' a : A, ∀ b : A, a = b

/-- A type is a **mere proposition** (a `(-1)`-type) when any two of its
inhabitants are equal: `isProp(P) ≡ ∏ (x y : P), x = y`. -/
def IsProp (A : Sort u) : Prop := ∀ x y : A, x = y

/-- A type is a **set** (a `0`-type) when its identity types are mere
propositions, i.e. all parallel paths are equal. -/
def IsSet (A : Sort u) : Prop := ∀ x y : A, IsProp (x = y)

/-- A type is a **`1`-type** when its identity types are sets. -/
def IsOneType (A : Sort u) : Prop := ∀ x y : A, IsSet (x = y)

/-- **Hierarchy step (-2 ⟹ -1):** every contractible type is a mere
proposition. -/
theorem IsContr.toIsProp {A : Sort u} (h : IsContr A) : IsProp A := by
  exact fun x y => h.2 x ▸ h.2 y ▸ rfl

/-- **Hierarchy step (-1 ⟹ 0):** every mere proposition is a set. -/
theorem IsProp.toIsSet {A : Sort u} (_h : IsProp A) : IsSet A := by
  intro x y;
  exact fun p q => Subsingleton.elim p q

/-- **Hierarchy step (0 ⟹ 1):** every set is a `1`-type. -/
theorem IsSet.toIsOneType {A : Sort u} (_h : IsSet A) : IsOneType A := by
  intro x y;
  convert Subsingleton.intro;
  swap;
  exact x = y;
  exact ⟨ fun h => fun _ => ⟨ fun a b => by tauto ⟩, fun h => by tauto ⟩

/-- An inhabited mere proposition is contractible: a proposition with a point
is a "singleton". -/
def IsProp.toIsContr {A : Sort u} (a : A) (h : IsProp A) : IsContr A :=
  ⟨a, fun b => h a b⟩

/-- `IsProp` agrees with Mathlib's `Subsingleton`. -/
theorem isProp_iff_subsingleton {A : Sort u} : IsProp A ↔ Subsingleton A := by
  exact ⟨ fun h => ⟨ h ⟩, fun h => fun x y => h.elim x y ⟩

/-- Being a mere proposition is itself a mere proposition. -/
theorem isProp_isProp {A : Sort u} : IsProp (IsProp A) := by
  exact fun p q => Subsingleton.elim p q

/-- **The UIP collapse.** Because Lean's foundation validates Uniqueness of
Identity Proofs, *every* type is a set. This is the precise sense in which
Lean's foundation differs from the univalent one of the specification, where
the levels of the `n`-type hierarchy are genuinely distinct. -/
theorem everything_isSet {A : Sort u} : IsSet A := by
  intro x y; exact fun p q => Subsingleton.elim p q;

/-! ## §2/§4. The Univalence map and Path Induction (the `J`-rule) -/

/-- The canonical map `(A = B) → (A ≃ B)` whose being an equivalence is the
content of the **Univalence Axiom**. It transports a path between types into an
equivalence of types. (Univalence — that this map is itself an equivalence — is
*not* provable in Lean and is not asserted here.) -/
def idToEquiv {A B : Type u} (p : A = B) : A ≃ B := Equiv.cast p

/-- The canonical map sends the reflexivity path to the identity equivalence,
the basic coherence of `idToEquiv`. -/
theorem idToEquiv_refl {A : Type u} : idToEquiv (rfl : A = A) = Equiv.refl A := by
  ext; simp [idToEquiv]

/-- **Path induction (the `J`-rule).** To prove a property `P` of all paths
`p : a = b` it suffices to prove it for the reflexivity path. This is the
universal eliminator for identity types. -/
theorem path_induction {A : Sort u} {a : A}
    (P : ∀ b : A, a = b → Prop) (h : P a rfl) :
    ∀ (b : A) (p : a = b), P b p := by
  grind

/-! ## §3. Apartness relation on a linear order (`0`-type arithmetic) -/

/-- The **apartness relation** `x # y ⇔ x < y ∨ y < x` on a linear order, the
constructive notion of inequality used for real-number arithmetic. -/
def Apart {α : Type u} [LinearOrder α] (x y : α) : Prop := x < y ∨ y < x

@[inherit_doc] infix:50 " # " => Apart

/-- Apartness is irreflexive: nothing is apart from itself. -/
theorem apart_irrefl {α : Type u} [LinearOrder α] (x : α) : ¬ (x # x) := by
  exact fun h => h.elim ( lt_irrefl _ ) ( lt_irrefl _ )

/-- Apartness is symmetric. -/
theorem apart_symm {α : Type u} [LinearOrder α] {x y : α} (h : x # y) : y # x := by
  exact h.symm

/-- Apartness is **tight**: failure to be apart is exactly equality. -/
theorem apart_tight {α : Type u} [LinearOrder α] {x y : α} :
    ¬ (x # y) ↔ x = y := by
  constructor <;> intro h <;> simp_all +decide [ Apart ]

/-- Apartness is **cotransitive**: if `x` and `y` are apart then any third point
`z` is apart from at least one of them. -/
theorem apart_cotrans {α : Type u} [LinearOrder α] {x y : α} (h : x # y) (z : α) :
    (x # z) ∨ (z # y) := by
  cases' lt_trichotomy x z with hxz hxz <;> cases' lt_trichotomy z y with hzy hzy <;> simp_all +decide [Apart];
  grind

end UnivalentArchitecture
