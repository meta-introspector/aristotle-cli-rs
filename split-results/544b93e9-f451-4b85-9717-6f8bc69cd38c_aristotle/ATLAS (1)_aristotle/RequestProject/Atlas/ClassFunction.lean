/-
# Class Functions and Character Theory

This file formalizes class functions on finite groups and the notion of
(ordinary) characters, which are the foundation of character tables in
the ATLAS of Finite Groups.
-/
import Mathlib

set_option maxHeartbeats 800000

open scoped BigOperators Classical

noncomputable section

/-- A class function on a group `G` over a commutative ring `k` is a function
    that is constant on conjugacy classes. -/
structure ClassFunction (k : Type*) (G : Type*) [CommRing k] [Group G] where
  /-- The underlying function. -/
  toFun : G → k
  /-- The function is constant on conjugacy classes. -/
  conj_invariant : ∀ g h : G, toFun (h * g * h⁻¹) = toFun g

namespace ClassFunction

variable {k : Type*} {G : Type*} [CommRing k] [Group G]

instance : FunLike (ClassFunction k G) G k where
  coe := ClassFunction.toFun
  coe_injective' f g h := by cases f; cases g; simp_all

@[ext]
theorem ext {f g : ClassFunction k G} (h : ∀ x, f x = g x) : f = g :=
  DFunLike.ext f g h

@[simp]
theorem toFun_eq_coe (f : ClassFunction k G) : f.toFun = f := rfl

instance : Zero (ClassFunction k G) :=
  ⟨⟨0, fun _ _ => rfl⟩⟩

instance : Add (ClassFunction k G) :=
  ⟨fun f g => ⟨fun x => f x + g x, fun a b => by
    show f.toFun (b * a * b⁻¹) + g.toFun (b * a * b⁻¹) = f.toFun a + g.toFun a
    rw [f.conj_invariant, g.conj_invariant]⟩⟩

instance : Neg (ClassFunction k G) :=
  ⟨fun f => ⟨fun x => -f x, fun a b => by
    show -f.toFun (b * a * b⁻¹) = -f.toFun a
    rw [f.conj_invariant]⟩⟩

instance : SMul k (ClassFunction k G) :=
  ⟨fun c f => ⟨fun x => c * f x, fun a b => by
    show c * f.toFun (b * a * b⁻¹) = c * f.toFun a
    rw [f.conj_invariant]⟩⟩

/-- The inner product of class functions on a finite group. -/
def innerProduct [Fintype G] [Field k] (f g : ClassFunction k G) : k :=
  (Fintype.card G : k)⁻¹ * ∑ x : G, f x * g x

/-- A class function is irreducible if ⟨χ, χ⟩ = 1. -/
def IsIrreducible [Fintype G] [Field k] (f : ClassFunction k G) : Prop :=
  innerProduct f f = 1

end ClassFunction

/-
The character of a finite-dimensional representation over a field,
    as a class function.
-/
def Representation.character' {k G V : Type*} [Field k] [Group G] [Fintype G]
    [AddCommGroup V] [Module k V] [Module.Free k V] [Module.Finite k V]
    (ρ : Representation k G V) : ClassFunction k G where
  toFun g := LinearMap.trace k V (ρ g)
  conj_invariant g h := by
    show LinearMap.trace k V (ρ (h * g * h⁻¹)) = LinearMap.trace k V (ρ g)
    simp only [map_mul]
    -- The trace is invariant under cyclic permutations of the product.
    have h_trace_cyclic : ∀ (A B C : V →ₗ[k] V),
        LinearMap.trace k V (A * B * C) = LinearMap.trace k V (B * C * A) :=
      fun A B C => Eq.symm (LinearMap.trace_mul_cycle k B C A)
    convert h_trace_cyclic (ρ h) (ρ g) (ρ h⁻¹) using 1
    simp +decide [← map_mul]

/-- The degree of a character is its value at the identity. -/
def ClassFunction.degree' {k G : Type*} [CommRing k] [Group G] [Fintype G]
    (χ : ClassFunction k G) : k := χ 1

end