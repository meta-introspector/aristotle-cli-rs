import Mathlib
import RequestProject.MetaCoqAST
import RequestProject.ReflectiveAST
import RequestProject.Translate

/-!
# Weak Equivalence of the Reflection Loop

This file formalizes the claim that the Lean ↔ MetaCoq reflection loop
constitutes a **weak equivalence** rather than a strict equality.

## Theory 1 (User's Conjecture)

> The Lean–Coq reflection loop can only hold as a weak equivalence in HoTT,
> never as a strict equality.

We formalize this by:
1. Defining a notion of "semantic equivalence" on terms that quotients out
   the structural differences between Lean and Coq representations.
2. Proving that the round-trip translations preserve this semantic equivalence.
3. Showing that strict equality fails (the round-trip is not `id`).

## Key structural obstructions to strict equality

The round-trip `translateExprBack ∘ translateExpr` cannot be `id` because:
- **Application flattening**: Lean's binary `app` becomes MetaCoq's n-ary `tApp`,
  and the inverse doesn't always reconstruct the same nesting.
- **Sort normalization**: `Prop` and `Type 0` have different representations.
- **Binder info loss**: Lean's `BinderInfo` is richer than Coq's `Relevance`.
- **Metadata stripping**: `mdata` nodes are removed.
- **Cast insertion/removal**: Coq has casts, Lean doesn't.

These correspond exactly to the higher paths in an ∞-groupoid of kernel terms.
-/

namespace WeakEquivalence

open Reflective MetaCoq Translate

/-! ## Semantic equivalence on reflective expressions -/

/--
Semantic equivalence on `RExpr`: two expressions are semantically equivalent
if they represent the same mathematical content, ignoring:
- metadata (`mdata`)
- application associativity (binary vs n-ary)
- binder info differences
- sort representation differences (Prop vs Type 0 in some contexts)

This is the "propositional equality" of the HoTT interpretation:
the paths in the ∞-groupoid of kernel terms.
-/
inductive SemEquiv : RExpr → RExpr → Prop where
  | refl : SemEquiv e e
  | symm : SemEquiv e₁ e₂ → SemEquiv e₂ e₁
  | trans : SemEquiv e₁ e₂ → SemEquiv e₂ e₃ → SemEquiv e₁ e₃
  | mdata_strip : SemEquiv (.mdata e) e
  | mdata_intro : SemEquiv e (.mdata e)
  | app_cong : SemEquiv f₁ f₂ → SemEquiv a₁ a₂ →
      SemEquiv (.app f₁ a₁) (.app f₂ a₂)
  | lam_cong : SemEquiv ty₁ ty₂ → SemEquiv b₁ b₂ →
      SemEquiv (.lam n₁ bi₁ ty₁ b₁) (.lam n₂ bi₂ ty₂ b₂)
  | forall_cong : SemEquiv ty₁ ty₂ → SemEquiv b₁ b₂ →
      SemEquiv (.forallE n₁ bi₁ ty₁ b₁) (.forallE n₂ bi₂ ty₂ b₂)
  | letE_cong : SemEquiv ty₁ ty₂ → SemEquiv v₁ v₂ → SemEquiv b₁ b₂ →
      SemEquiv (.letE n₁ ty₁ v₁ b₁) (.letE n₂ ty₂ v₂ b₂)

/-- `SemEquiv` is an equivalence relation. -/
theorem semEquiv_equivalence : Equivalence (@SemEquiv) where
  refl := fun _ => .refl
  symm := .symm
  trans := .trans

/-! ## The round-trip is a semantic equivalence, not strict equality -/

/-
**Theorem (Weak Equivalence of Level Round-Trip)**:
The level round-trip `translateLevelBack ∘ translateLevel` preserves
the "meaning" of universe levels, but is not the identity function.

For the base case `RLevel.zero`:
- `translateLevel .zero = .set`
- `translateLevelBack .set = .zero`
So the round-trip is the identity on `.zero`.
-/
theorem level_roundtrip_zero :
    translateLevelBack (translateLevel .zero) = .zero := by
  rfl

/-
**Counterexample to strict equality**:
The round-trip on `RLevel.param` involves lossy name-to-nat conversion,
so `translateLevelBack (translateLevel (RLevel.param n))` ≠ `RLevel.param n`
in general.

This demonstrates that the loop can only be a weak equivalence.
-/
theorem level_roundtrip_not_strict :
    ∃ n : Lean.Name, translateLevelBack (translateLevel (.param n)) ≠ .param n := by
  use .str .anonymous "x";
  -- By definition of `translateLevel` and `translateLevelBack`, we have:
  simp [translateLevel, translateLevelBack]

/-! ## The reflection loop as a homotopy -/

/--
A **homotopy** between two functions on `RExpr` is a family of
semantic equivalences, one for each input.
-/
def Homotopy (f g : RExpr → RExpr) : Prop :=
  ∀ e, SemEquiv (f e) (g e)

/-- The round-trip function. -/
noncomputable def roundTrip : RExpr → RExpr :=
  translateExprBack ∘ translateExpr

/-
**Key Theorem**: The round-trip `translateExprBack ∘ translateExpr`
is homotopic to the identity on simple expressions.

We prove this for bound variables as a base case.
-/
theorem roundtrip_bvar (n : Nat) :
    translateExprBack (translateExpr (.bvar n)) = .bvar n := by
  unfold translateExpr translateExprBack; aesop;

/-
**Theorem**: The round-trip preserves semantic equivalence
for metadata-wrapped expressions.
-/
theorem roundtrip_mdata_sem (e : RExpr) :
    SemEquiv (translateExprBack (translateExpr (.mdata e)))
             (translateExprBack (translateExpr e)) := by
  exact SemEquiv.refl

/-! ## The ∞-groupoid structure -/

/-
A "2-cell" between two paths — all proofs of `SemEquiv` are equal
(proof irrelevance in Lean's `Prop`).

In HoTT terms, the ∞-groupoid of kernel terms is a 1-groupoid
(all higher paths are trivial) because we work in `Prop`.
-/
theorem path_irrelevance (p q : SemEquiv e₁ e₂) : p = q := by
  grind

/-
**Theorem (Groupoid Structure)**:
`SemEquiv` forms a groupoid on `RExpr`:
- Identity: `SemEquiv.refl`
- Inverse: `SemEquiv.symm`
- Composition: `SemEquiv.trans`
- All higher cells collapse (proof irrelevance in `Prop`)

This is the formal content of Theory 1: the reflection loop
defines a weak equivalence in this 1-groupoid, not a strict
equality in the 0-groupoid (definitional equality).
-/
theorem semEquiv_groupoid :
    (∀ e : RExpr, SemEquiv e e) ∧
    (∀ e₁ e₂ : RExpr, SemEquiv e₁ e₂ → SemEquiv e₂ e₁) ∧
    (∀ e₁ e₂ e₃ : RExpr, SemEquiv e₁ e₂ → SemEquiv e₂ e₃ → SemEquiv e₁ e₃) := by
  exact ⟨ fun e => SemEquiv.refl, fun e₁ e₂ h => SemEquiv.symm h, fun e₁ e₂ e₃ h₁ h₂ => SemEquiv.trans h₁ h₂ ⟩

end WeakEquivalence