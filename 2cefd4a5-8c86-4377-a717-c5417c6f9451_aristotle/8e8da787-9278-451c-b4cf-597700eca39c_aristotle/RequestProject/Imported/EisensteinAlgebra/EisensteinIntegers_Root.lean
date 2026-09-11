import Mathlib

/-!
# Eisenstein integers `ℤ[ω]`

This file gives a concrete formalization of the Eisenstein integers
`ℤ[ω]`, where `ω = e^(2πi/3)` is a primitive cube root of unity
satisfying `ω² + ω + 1 = 0`.

## Why a concrete construction?

Mathlib provides `NumberField.RingOfIntegers (CyclotomicField 3 ℚ)`, which
abstractly gives the ring of integers in `ℚ(ω)`. That formulation is
correct but heavy: elements are equivalence classes of polynomials.

For the eventual Coxeter–Todd lattice construction, we need:
* explicit element-level computation (norms, products, reductions),
* decidable equality on elements,
* the ability to construct concrete `ℤ[ω]^6` and quotient maps.

We therefore define `Eisenstein` as a concrete record `⟨a, b⟩` representing
`a + b·ω`, with multiplication
`(a + b·ω)(c + d·ω) = (ac - bd) + (ad + bc - bd)·ω`,
derived from `ω² = -1 - ω`.

## What this file establishes

* `Eisenstein` is a commutative ring with explicit + and ·.
* The norm `N : Eisenstein → ℤ` defined by `N(a + b·ω) = a² - ab + b²`
  is a multiplicative monoid hom from `(Eisenstein, ·)` to `(ℤ, ·)`.
* The conjugation `conj : Eisenstein → Eisenstein` sending
  `a + b·ω ↦ (a - b) + (-b)·ω` is an additive group anti-homomorphism
  and a ring involution.
* `conj z * z = N(z)` for every `z`, expressing the norm-trace identity.
* The Eisenstein prime `θ := 1 - ω` has norm `N(θ) = 3`.
* The reduction map `redMod3 : Eisenstein → ZMod 3` sending
  `a + b·ω ↦ (a + b) mod 3` is a ring homomorphism with `redMod3 θ = 0`.
* Surjectivity of `redMod3`.

## What this file does not (yet) establish

* `Eisenstein` is a Euclidean domain (and hence a PID and UFD).
* The kernel of `redMod3` is exactly `(θ)`, i.e. `Eisenstein/(θ) ≅ 𝔽₃`.
  (We prove surjectivity and that `θ` is in the kernel; the full
  isomorphism would require characterizing the kernel.)
* The Coxeter–Todd lattice `K₁₂` itself.

These are deferred to follow-up files. No `sorry`s are used in this file
to gesture at unproven claims.
-/

noncomputable section

/-- The Eisenstein integers `ℤ[ω]`, represented as pairs `⟨a, b⟩` standing
for `a + b·ω` where `ω = e^(2πi/3)`. -/
structure Eisenstein where
  a : ℤ
  b : ℤ
  deriving DecidableEq, Repr

namespace Eisenstein

/-! ### Ring structure -/

instance : Zero Eisenstein := ⟨⟨0, 0⟩⟩
instance : One Eisenstein := ⟨⟨1, 0⟩⟩

/-- Addition: `(a + bω) + (c + dω) = (a+c) + (b+d)ω`. -/
instance : Add Eisenstein := ⟨fun z w => ⟨z.a + w.a, z.b + w.b⟩⟩

/-- Negation: `-(a + bω) = (-a) + (-b)ω`. -/
instance : Neg Eisenstein := ⟨fun z => ⟨-z.a, -z.b⟩⟩

/-- Subtraction. -/
instance : Sub Eisenstein := ⟨fun z w => z + (-w)⟩

/-- Multiplication derived from `ω² = -1 - ω`:
    `(a + bω)(c + dω) = (ac - bd) + (ad + bc - bd)ω`. -/
instance : Mul Eisenstein :=
  ⟨fun z w => ⟨z.a * w.a - z.b * w.b, z.a * w.b + z.b * w.a - z.b * w.b⟩⟩

/-- Helper: an Eisenstein integer is determined by its `a` and `b` parts. -/
@[ext] theorem ext {z w : Eisenstein} (ha : z.a = w.a) (hb : z.b = w.b) : z = w := by
  cases z; cases w; congr

@[simp] theorem zero_a : (0 : Eisenstein).a = 0 := rfl
@[simp] theorem zero_b : (0 : Eisenstein).b = 0 := rfl
@[simp] theorem one_a  : (1 : Eisenstein).a = 1 := rfl
@[simp] theorem one_b  : (1 : Eisenstein).b = 0 := rfl
@[simp] theorem add_a (z w : Eisenstein) : (z + w).a = z.a + w.a := rfl
@[simp] theorem add_b (z w : Eisenstein) : (z + w).b = z.b + w.b := rfl
@[simp] theorem neg_a (z : Eisenstein) : (-z).a = -z.a := rfl
@[simp] theorem neg_b (z : Eisenstein) : (-z).b = -z.b := rfl
@[simp] theorem mul_a (z w : Eisenstein) : (z * w).a = z.a * w.a - z.b * w.b := rfl
@[simp] theorem mul_b (z w : Eisenstein) :
    (z * w).b = z.a * w.b + z.b * w.a - z.b * w.b := rfl

/-- `Eisenstein` is a commutative ring. -/
instance : CommRing Eisenstein where
  add_assoc a b c := by ext <;> simp [add_assoc]
  zero_add z := by ext <;> simp
  add_zero z := by ext <;> simp
  add_comm a b := by ext <;> simp [add_comm]
  neg_add_cancel z := by ext <;> simp
  mul_assoc a b c := by ext <;> simp <;> ring
  one_mul z := by ext <;> simp
  mul_one z := by ext <;> simp
  left_distrib a b c := by ext <;> simp <;> ring
  right_distrib a b c := by ext <;> simp <;> ring
  mul_comm a b := by ext <;> simp <;> ring
  zsmul := zsmulRec
  nsmul := nsmulRec
  sub_eq_add_neg a b := rfl
  zero_mul z := by ext <;> simp
  mul_zero z := by ext <;> simp

/-! ### The element `ω` -/

/-- The primitive cube root of unity `ω = 0 + 1·ω`. -/
def ω : Eisenstein := ⟨0, 1⟩

@[simp] theorem ω_a : ω.a = 0 := rfl
@[simp] theorem ω_b : ω.b = 1 := rfl

/-- The defining relation: `ω² + ω + 1 = 0`. Equivalently `ω² = -1 - ω`. -/
theorem ω_sq_add_ω_add_one : ω * ω + ω + 1 = 0 := by
  ext <;> simp

/-- The explicit value of `ω²`. -/
theorem ω_sq : ω * ω = ⟨-1, -1⟩ := by ext <;> simp

/-- Every Eisenstein integer is `a + b·ω` for some `a, b : ℤ`. -/
theorem eq_a_add_b_omega (z : Eisenstein) :
    z = ⟨z.a, 0⟩ + ⟨0, z.b⟩ := by ext <;> simp

/-! ### The norm `N(a + b·ω) = a² - ab + b²` -/

/-- The norm map `N : Eisenstein → ℤ`, defined by `N(a + b·ω) = a² - ab + b²`.
    Equivalently, `N(z) = |z|²` viewing `z` as a complex number. -/
def norm (z : Eisenstein) : ℤ := z.a^2 - z.a * z.b + z.b^2

@[simp] theorem norm_zero : norm 0 = 0 := by simp [norm]

@[simp] theorem norm_one : norm 1 = 1 := by simp [norm]

/-- The norm is non-negative. -/
theorem norm_nonneg (z : Eisenstein) : 0 ≤ norm z := by
  have h : 4 * norm z = (2 * z.a - z.b)^2 + 3 * z.b^2 := by ring_nf; simp [norm]; ring
  have h_pos : 0 ≤ (2 * z.a - z.b)^2 + 3 * z.b^2 := by positivity
  linarith

/-- The norm is multiplicative: `N(zw) = N(z) · N(w)`. -/
theorem norm_mul (z w : Eisenstein) : norm (z * w) = norm z * norm w := by
  simp [norm]; ring

/-- The norm packaged as a multiplicative monoid hom. -/
def normHom : Eisenstein →* ℤ where
  toFun := norm
  map_one' := norm_one
  map_mul' := norm_mul

/-! ### Conjugation `a + b·ω ↦ (a-b) - b·ω` -/

/-- Complex conjugation on `Eisenstein`: send `a + b·ω` to `(a - b) - b·ω`.
    Algebraically, `bar(ω) = ω² = -1 - ω`, so
    `bar(a + b·ω) = a + b·(-1 - ω) = (a - b) + (-b)·ω`. -/
def conj (z : Eisenstein) : Eisenstein := ⟨z.a - z.b, -z.b⟩

@[simp] theorem conj_a (z : Eisenstein) : (conj z).a = z.a - z.b := rfl
@[simp] theorem conj_b (z : Eisenstein) : (conj z).b = -z.b := rfl

@[simp] theorem conj_zero : conj 0 = 0 := by ext <;> simp [conj]
@[simp] theorem conj_one : conj 1 = 1 := by ext <;> simp [conj]

/-- Conjugation is involutive: `bar(bar(z)) = z`. -/
theorem conj_conj (z : Eisenstein) : conj (conj z) = z := by ext <;> simp [conj]

/-- Conjugation is additive. -/
theorem conj_add (z w : Eisenstein) : conj (z + w) = conj z + conj w := by
  ext <;> simp [conj] <;> ring

/-- Conjugation respects multiplication. -/
theorem conj_mul (z w : Eisenstein) : conj (z * w) = conj z * conj w := by
  ext <;> simp [conj] <;> ring

/-- The norm-trace identity: `bar(z) · z = N(z)`, viewing `N(z)` as an
    Eisenstein integer with zero `b`-component. -/
theorem conj_mul_self (z : Eisenstein) :
    conj z * z = ⟨norm z, 0⟩ := by
  ext
  · simp [conj, norm]; ring
  · simp [conj]; ring

/-! ### The Eisenstein prime `θ = 1 - ω` -/

/-- The Eisenstein prime above the rational prime 3: `θ := 1 - ω`. -/
def θ : Eisenstein := ⟨1, -1⟩

@[simp] theorem θ_a : θ.a = 1 := rfl
@[simp] theorem θ_b : θ.b = -1 := rfl

/-- `θ = 1 - ω`. -/
theorem θ_eq : θ = 1 - ω := by
  show θ = (1 : Eisenstein) + (-ω)
  ext <;> simp [ω]

/-- The defining property: `N(θ) = 3`. -/
theorem norm_θ : norm θ = 3 := by simp [norm]

/-! ### Reduction modulo `θ` to `ZMod 3`

Since `θ = 1 - ω`, we have `ω ≡ 1 (mod θ)`, so the map
`a + b·ω ↦ (a + b) mod 3` is a ring homomorphism `Eisenstein → ZMod 3`
that sends `θ` to `0`. -/

/-- Reduction map `Eisenstein → ZMod 3` defined by `a + b·ω ↦ (a + b) mod 3`. -/
def redMod3 (z : Eisenstein) : ZMod 3 := ((z.a + z.b : ℤ) : ZMod 3)

@[simp] theorem redMod3_zero : redMod3 0 = 0 := by simp [redMod3]

@[simp] theorem redMod3_one : redMod3 1 = 1 := by simp [redMod3]

/-- `θ` reduces to zero mod 3. -/
@[simp] theorem redMod3_θ : redMod3 θ = 0 := by simp [redMod3, θ]

/-- `ω` reduces to `1` mod 3 (because `ω ≡ 1 (mod θ)`). -/
@[simp] theorem redMod3_ω : redMod3 ω = 1 := by simp [redMod3, ω]

/-- `redMod3` is additive. -/
theorem redMod3_add (z w : Eisenstein) :
    redMod3 (z + w) = redMod3 z + redMod3 w := by
  simp only [redMod3, add_a, add_b]
  push_cast
  ring

/-- `redMod3` is multiplicative. -/
theorem redMod3_mul (z w : Eisenstein) :
    redMod3 (z * w) = redMod3 z * redMod3 w := by
  simp only [redMod3, mul_a, mul_b]
  push_cast
  have h3 : (3 : ZMod 3) = 0 := by decide
  ring_nf
  linear_combination (-(z.b : ZMod 3) * (w.b : ZMod 3)) * h3

/-- `redMod3` packaged as a ring homomorphism. -/
def redMod3Hom : Eisenstein →+* ZMod 3 where
  toFun := redMod3
  map_one' := redMod3_one
  map_zero' := redMod3_zero
  map_add' := redMod3_add
  map_mul' := redMod3_mul

/-- `redMod3` is surjective. The integers `0, 1, -1` map to `0, 1, 2`
    respectively, hitting all of `ZMod 3`. -/
theorem redMod3_surjective : Function.Surjective redMod3 := by
  intro x
  fin_cases x
  · exact ⟨0, by simp⟩
  · exact ⟨1, by simp⟩
  · exact ⟨⟨-1, 0⟩, by simp [redMod3]; decide⟩

/-! ### A few corollaries -/

/-- The norm is preserved under conjugation: `N(bar(z)) = N(z)`. -/
theorem norm_conj (z : Eisenstein) : norm (conj z) = norm z := by
  simp [norm, conj]; ring

/-- If `N(z) = 1`, then `z` is a unit (in fact, one of the six sixth roots
    of unity), since `bar(z) · z = N(z) = 1` makes `bar(z)` an inverse. -/
theorem isUnit_of_norm_one (z : Eisenstein) (h : norm z = 1) : IsUnit z := by
  refine ⟨⟨z, conj z, ?_, ?_⟩, rfl⟩
  · rw [show z * conj z = conj z * z from by rw [mul_comm], conj_mul_self]
    simp [h]; ext <;> simp
  · rw [conj_mul_self]
    simp [h]; ext <;> simp

end Eisenstein

end
