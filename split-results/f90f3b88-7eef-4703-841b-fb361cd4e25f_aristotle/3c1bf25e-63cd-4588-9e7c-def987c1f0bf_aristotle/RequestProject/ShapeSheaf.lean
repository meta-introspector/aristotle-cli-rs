import Mathlib
import RequestProject.ShapeBase

/-!
# The Shape-Sheaf: Algebraic Structure and Fibers

This file extends the base four-element classification with:

1. **Klein four-group structure**: `BaseElement` carries a group operation
   isomorphic to ℤ/2 × ℤ/2 (the Klein four-group V₄).

2. **Exact counting**: Among `{1, ..., 6}`, the element classes have exact sizes
   `2` (void), `2` (fire), `1` (water), `1` (air), reflecting densities 1/3, 1/3, 1/6, 1/6.

3. **Shadow prime fibers**: The "sheaf" structure — each shape decomposes into a
   base element and a shadow-prime fiber (23-bit vector for primes 5..97).

4. **RDF/Sheaf block formalization**: The eigenspace/Hecke/orbifold structure.

5. **Hamming distance** on shapes with basic metric properties.
-/

open scoped BigOperators Classical
open BaseElement

set_option maxHeartbeats 800000

/-! ## Part 1: Klein Four-Group Structure on BaseElement -/

namespace BaseElement

/-- The group operation on base elements (componentwise XOR). -/
def gmul : BaseElement → BaseElement → BaseElement
  | .void, x => x
  | x, .void => x
  | .fire, .fire => .void
  | .fire, .water => .air
  | .fire, .air => .water
  | .water, .fire => .air
  | .water, .water => .void
  | .water, .air => .fire
  | .air, .fire => .water
  | .air, .water => .fire
  | .air, .air => .void

theorem gmul_comm (a b : BaseElement) : gmul a b = gmul b a := by
  cases a <;> cases b <;> rfl

theorem gmul_assoc (a b c : BaseElement) : gmul (gmul a b) c = gmul a (gmul b c) := by
  cases a <;> cases b <;> cases c <;> rfl

theorem gmul_void (a : BaseElement) : gmul .void a = a := by
  cases a <;> rfl

theorem void_gmul (a : BaseElement) : gmul a .void = a := by
  cases a <;> rfl

theorem gmul_self (a : BaseElement) : gmul a a = .void := by
  cases a <;> rfl

/-- The Klein four-group has order 4. -/
theorem card_baseElement : Fintype.card BaseElement = 4 := by decide

/-- The isomorphism to ℤ/2 × ℤ/2. -/
def toZMod2Prod : BaseElement → ZMod 2 × ZMod 2
  | .void  => (0, 0)
  | .fire  => (1, 0)
  | .water => (0, 1)
  | .air   => (1, 1)

def fromZMod2Prod : ZMod 2 × ZMod 2 → BaseElement
  | (0, 0) => .void
  | (1, 0) => .fire
  | (0, 1) => .water
  | (1, 1) => .air

/-- The map to ℤ/2 × ℤ/2 is injective. -/
theorem toZMod2Prod_injective : Function.Injective toZMod2Prod := by
  intro a b h; cases a <;> cases b <;> simp_all [toZMod2Prod]

/-- The map to ℤ/2 × ℤ/2 is surjective. -/
theorem toZMod2Prod_surjective : Function.Surjective toZMod2Prod := by
  intro ⟨a, b⟩
  fin_cases a <;> fin_cases b
  · exact ⟨.void, rfl⟩
  · exact ⟨.water, rfl⟩
  · exact ⟨.fire, rfl⟩
  · exact ⟨.air, rfl⟩

/-- Round-trip: fromZMod2Prod ∘ toZMod2Prod = id. -/
theorem fromZMod2Prod_toZMod2Prod (e : BaseElement) :
    fromZMod2Prod (toZMod2Prod e) = e := by cases e <;> rfl

/-- Round-trip: toZMod2Prod ∘ fromZMod2Prod = id. -/
theorem toZMod2Prod_fromZMod2Prod (p : ZMod 2 × ZMod 2) :
    toZMod2Prod (fromZMod2Prod p) = p := by
  obtain ⟨a, b⟩ := p; fin_cases a <;> fin_cases b <;> rfl

/-- The bijection between BaseElement and ℤ/2 × ℤ/2. -/
def equivZMod2Prod : BaseElement ≃ ZMod 2 × ZMod 2 where
  toFun := toZMod2Prod
  invFun := fromZMod2Prod
  left_inv := fromZMod2Prod_toZMod2Prod
  right_inv := toZMod2Prod_fromZMod2Prod

/-- gmul corresponds to componentwise addition in ℤ/2 × ℤ/2. -/
theorem toZMod2Prod_gmul (a b : BaseElement) :
    toZMod2Prod (gmul a b) =
      ((toZMod2Prod a).1 + (toZMod2Prod b).1,
       (toZMod2Prod a).2 + (toZMod2Prod b).2) := by
  cases a <;> cases b <;> rfl

/-! ## Part 2: Exact Counting in Residue Classes -/

/-- The elements of {1,...,6} classified as void are {1, 5}. -/
theorem void_in_range6 :
    (Finset.Icc 1 6).filter (fun n => classify n = .void) = {1, 5} := by decide

/-- The elements of {1,...,6} classified as fire are {2, 4}. -/
theorem fire_in_range6 :
    (Finset.Icc 1 6).filter (fun n => classify n = .fire) = {2, 4} := by decide

/-- The elements of {1,...,6} classified as water are {3}. -/
theorem water_in_range6 :
    (Finset.Icc 1 6).filter (fun n => classify n = .water) = {3} := by decide

/-- The elements of {1,...,6} classified as air are {6}. -/
theorem air_in_range6 :
    (Finset.Icc 1 6).filter (fun n => classify n = .air) = {6} := by decide

/-- Among {1,...,6}, void has exactly 2 elements. -/
theorem count_void_6 :
    ((Finset.Icc 1 6).filter (fun n => classify n = .void)).card = 2 := by decide

/-- Among {1,...,6}, fire has exactly 2 elements. -/
theorem count_fire_6 :
    ((Finset.Icc 1 6).filter (fun n => classify n = .fire)).card = 2 := by decide

/-- Among {1,...,6}, water has exactly 1 element. -/
theorem count_water_6 :
    ((Finset.Icc 1 6).filter (fun n => classify n = .water)).card = 1 := by decide

/-- Among {1,...,6}, air has exactly 1 element. -/
theorem count_air_6 :
    ((Finset.Icc 1 6).filter (fun n => classify n = .air)).card = 1 := by decide

/-- The four counts sum to 6 (a complete partition of {1,...,6}). -/
theorem count_total_6 :
    ((Finset.Icc 1 6).filter (fun n => classify n = .void)).card +
    ((Finset.Icc 1 6).filter (fun n => classify n = .fire)).card +
    ((Finset.Icc 1 6).filter (fun n => classify n = .water)).card +
    ((Finset.Icc 1 6).filter (fun n => classify n = .air)).card = 6 := by decide

/-- The periodicity of classification mod 6: classify is periodic with period 6. -/
theorem classify_periodic (n : ℕ) :
    classify (n + 6) = classify n := by
  unfold classify; simp [Nat.add_mod]

/-! ## Part 3: Shadow Prime Fibers -/

/-- A shadow fiber is a 23-bit vector (bits for primes 5, 7, 11, ..., 97). -/
abbrev ShadowFiber := Fin 23 → Bool

/-- Extract the base element from a shape. -/
def shapeBase (s : Shape) : BaseElement := classifyShape s

/-- Extract the shadow fiber from a shape (bits 2..24). -/
def shapeFiber (s : Shape) : ShadowFiber := fun i => s ⟨i.val + 2, by omega⟩

/-- A shape is completely determined by its base element and shadow fiber. -/
def shapeFromParts (e : BaseElement) (f : ShadowFiber) : Shape := fun i =>
  if i.val = 0 then
    match e with | .fire | .air => true | .void | .water => false
  else if i.val = 1 then
    match e with | .water | .air => true | .void | .fire => false
  else
    f ⟨i.val - 2, by omega⟩

/-- The base of a reconstructed shape matches the given element. -/
theorem shapeFromParts_base (e : BaseElement) (f : ShadowFiber) :
    shapeBase (shapeFromParts e f) = e := by
  cases e <;> simp [shapeBase, classifyShape, shapeFromParts]

/-
The fiber of a reconstructed shape matches the given fiber.
-/
theorem shapeFromParts_fiber (e : BaseElement) (f : ShadowFiber) :
    shapeFiber (shapeFromParts e f) = f := by
      funext i; simp [shapeFiber, shapeFromParts]

/-
Reconstruction from parts is a right inverse of the decomposition.
-/
theorem shape_decompose_recompose (s : Shape) :
    shapeFromParts (shapeBase s) (shapeFiber s) = s := by
      unfold shapeBase shapeFiber;
      unfold classifyShape shapeFromParts;
      grind

/-- The shape space decomposes as BaseElement × ShadowFiber. -/
noncomputable def shapeEquiv : Shape ≃ BaseElement × ShadowFiber where
  toFun s := (shapeBase s, shapeFiber s)
  invFun p := shapeFromParts p.1 p.2
  left_inv := shape_decompose_recompose
  right_inv := fun ⟨e, f⟩ => by
    simp only [Prod.mk.injEq]
    exact ⟨shapeFromParts_base e f, shapeFromParts_fiber e f⟩

/-- The total number of shapes is 2²⁵. -/
theorem shape_card : Fintype.card Shape = 2 ^ 25 := by
  simp [Shape, Fintype.card_fun, Fintype.card_fin, Fintype.card_bool]

/-- Each shadow fiber has cardinality 2²³. -/
theorem stalk_card : Fintype.card ShadowFiber = 2 ^ 23 := by
  simp [ShadowFiber, Fintype.card_fun, Fintype.card_fin, Fintype.card_bool]

/-! ## Part 4: The RDF/Sheaf Block Formalization -/

/-- An RDF observation record, capturing the sheaf-theoretic data. -/
structure RDFRecord where
  /-- The base element (eigenspace). -/
  eigenspace : BaseElement
  /-- Bott periodicity index (mod 8, from the 8 D₄ symmetries). -/
  bottIndex : Fin 8
  /-- The shadow prime direction (a Hecke operator label). -/
  heckePrime : ℕ
  heckePrime_ge : heckePrime ≥ 5
  /-- Orbifold coordinates: residues modulo shadow primes. -/
  orbifoldCoords : List (ℕ × ℕ)
  /-- Shape class index. -/
  shapeClass : ℕ

/-- The example RDF record from the original system. -/
def exampleRDF : RDFRecord where
  eigenspace := .void
  bottIndex := ⟨2, by omega⟩
  heckePrime := 7
  heckePrime_ge := by omega
  orbifoldCoords := [(36, 71), (50, 59), (39, 47)]
  shapeClass := 5

/-- All orbifold moduli in the example are primes. -/
theorem exampleRDF_moduli_prime :
    ∀ p ∈ exampleRDF.orbifoldCoords, Nat.Prime p.2 := by decide

/-- All orbifold moduli in the example are shadow primes (≥ 5). -/
theorem exampleRDF_moduli_shadow :
    ∀ p ∈ exampleRDF.orbifoldCoords, p.2 ≥ 5 := by decide

/-- The Hecke prime in the example is indeed prime. -/
theorem exampleRDF_hecke_prime : Nat.Prime exampleRDF.heckePrime := by decide

/-- All orbifold residues are properly reduced (less than their modulus). -/
theorem exampleRDF_residues_reduced :
    ∀ p ∈ exampleRDF.orbifoldCoords, p.1 < p.2 := by decide

/-! ## Part 5: Hamming Distance on Shapes -/

/-- The Hamming distance between two shapes: count positions where bits differ. -/
def hammingDistance (s₁ s₂ : Shape) : ℕ :=
  ((Finset.univ : Finset (Fin 25)).filter (fun i => s₁ i ≠ s₂ i)).card

/-
Hamming distance is symmetric.
-/
theorem hammingDistance_comm (s₁ s₂ : Shape) :
    hammingDistance s₁ s₂ = hammingDistance s₂ s₁ := by
      exact congr_arg Finset.card ( Finset.filter_congr fun i _ => ne_comm )

/-
Hamming distance is zero iff shapes are equal.
-/
theorem hammingDistance_eq_zero (s₁ s₂ : Shape) :
    hammingDistance s₁ s₂ = 0 ↔ s₁ = s₂ := by
      simp +decide [ hammingDistance, funext_iff ]

/-- Hamming distance is bounded by 25. -/
theorem hammingDistance_le (s₁ s₂ : Shape) :
    hammingDistance s₁ s₂ ≤ 25 := by
  calc ((Finset.univ : Finset (Fin 25)).filter (fun i => s₁ i ≠ s₂ i)).card
      ≤ (Finset.univ : Finset (Fin 25)).card := Finset.card_filter_le _ _
    _ = 25 := by simp

/-! ## Part 6: Element-Preserving Symmetries -/

/-- A shape transformation preserves the base element. -/
def preservesBase (f : Shape → Shape) : Prop :=
  ∀ s, shapeBase (f s) = shapeBase s

/-
A shape transformation that fixes bits 0 and 1 preserves the base element.
-/
theorem fixes_first_two_preserves_base (f : Shape → Shape)
    (h0 : ∀ s, f s ⟨0, by omega⟩ = s ⟨0, by omega⟩)
    (h1 : ∀ s, f s ⟨1, by omega⟩ = s ⟨1, by omega⟩) :
    preservesBase f := by
      intro s;
      cases h : f s ⟨ 0, by decide ⟩ <;> cases h' : s ⟨ 0, by decide ⟩ <;> cases h'' : f s ⟨ 1, by decide ⟩ <;> cases h''' : s ⟨ 1, by decide ⟩ <;> simp_all +decide only [shapeBase];
      · unfold classifyShape; aesop;
      · unfold classifyShape; aesop;
      · unfold classifyShape; aesop;
      · unfold classifyShape; aesop;

end BaseElement