import Mathlib

open scoped BigOperators
open scoped Real
open scoped Nat
open scoped Classical
open scoped Pointwise

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000

/-!
# Formalizations of mathematical statements from the Aristotle technical report

This file collects and proves several concrete mathematical statements appearing in the
Harmonic "Aristotle: IMO-level Automated Theorem Proving" report (arXiv:2510.01346v1):

* the propositional-logic example used to illustrate proof search (Figure 1):
  distributivity of `∧` over `∨` (`and_or_distrib_mp`, `and_or_distrib`);
* the generalized Pythagorean / perpendicularity identity used in the Yuclid geometry
  section (`perp_iff_sq_dist`);
* the short five lemma from the homological-algebra appendix (`short_five_lemma`);
* Tao *Analysis I* Exercise 9.1.7 — a finite union of closed subsets of `ℝ` is closed
  (`isClosed_iUnion_fin`);
* the order trichotomy for the integers (`int_order_trichotomy`).
-/

namespace ImoReport

/-- Figure 1 (single implication): distributivity of `∧` over `∨`. -/
theorem and_or_distrib_mp (p q r : Prop) :
    (p ∧ (q ∨ r)) → ((p ∧ q) ∨ (p ∧ r)) := by
  tauto

/-- Figure 1 (full biconditional): distributivity of `∧` over `∨`. -/
theorem and_or_distrib (p q r : Prop) :
    (p ∧ (q ∨ r)) ↔ ((p ∧ q) ∨ (p ∧ r)) := by
  tauto

/-
Generalized Pythagorean / perpendicularity criterion (Yuclid geometry section):
in a real inner product space, the segments `AB` and `CD` are perpendicular
(`⟨B - A, D - C⟩ = 0`) iff `AC² + BD² = AD² + BC²` (squared distances).
-/
theorem perp_iff_sq_dist {V : Type*} [NormedAddCommGroup V] [InnerProductSpace ℝ V]
    (A B C D : V) :
    (inner ℝ (B - A) (D - C) : ℝ) = 0 ↔
      dist A C ^ 2 + dist B D ^ 2 = dist A D ^ 2 + dist B C ^ 2 := by
  simp only [dist_eq_norm, norm_sub_sq_real, inner_sub_left, inner_sub_right]
  constructor <;> intro h <;>
    nlinarith [h, real_inner_comm A B, real_inner_comm C D, real_inner_comm A C,
      real_inner_comm A D, real_inner_comm B C, real_inner_comm B D]

/-
The short five lemma (homological-algebra appendix): given a morphism of short
exact sequences of abelian groups whose two outer vertical maps `α`, `γ` are
isomorphisms, the middle vertical map `β` is an isomorphism.
-/
theorem short_five_lemma
    {A B C A' B' C' : Type*}
    [AddCommGroup A] [AddCommGroup B] [AddCommGroup C]
    [AddCommGroup A'] [AddCommGroup B'] [AddCommGroup C']
    (f : A →+ B) (g : B →+ C) (f' : A' →+ B') (g' : B' →+ C')
    (α : A →+ A') (β : B →+ B') (γ : C →+ C')
    (hg : Function.Surjective g)
    (hfg : Function.Exact f g)
    (hf' : Function.Injective f')
    (hf'g' : Function.Exact f' g')
    (h1 : f'.comp α = β.comp f) (h2 : g'.comp β = γ.comp g)
    (hα : Function.Bijective α) (hγ : Function.Bijective γ) :
    Function.Bijective β := by
  refine' ⟨ _, _ ⟩;
  · intro x y hxy;
    -- Since γ is injective, we have g(x) = g(y).
    have hgy : g x = g y := by
      exact hγ.injective ( by have := congr_arg ( fun f => f x ) h2; have := congr_arg ( fun f => f y ) h2; simp_all +decide [ AddMonoidHom.ext_iff ] );
    obtain ⟨ a, ha ⟩ := hfg _ |>.1 ( show g ( x - y ) = 0 from by simp +decide [ hgy ] );
    -- Since $f'(α(a)) = β(f(a))$ and $β(f(a)) = β(x - y) = β(x) - β(y) = 0$, we have $f'(α(a)) = 0$.
    have hfa_zero : f' (α a) = 0 := by
      replace h1 := congr_arg ( fun f => f a ) h1; aesop;
    have := hf' ( show f' ( α a ) = f' 0 by simpa using hfa_zero ) ; simp_all +decide ;
    have := hα.1 ( show α a = α 0 by simp +decide [ this ] ) ; simp_all +decide ;
    exact eq_of_sub_eq_zero ha.symm;
  · intro b'
    obtain ⟨c, hc⟩ : ∃ c, γ c = g' b' := hγ.2 (g' b')
    obtain ⟨b, hb⟩ : ∃ b, g b = c := hg c;
    -- Since $g' (β b) = γ (g b) = γ c = g' b'$, we have $g' (b' - β b) = 0$.
    have h_g'_zero : g' (b' - β b) = 0 := by
      replace h2 := congr_arg ( fun f => f b ) h2; aesop;
    -- By exactness hf'g' at (b' - β b), there is a' with f' a' = b' - β b.
    obtain ⟨a', ha'⟩ : ∃ a', f' a' = b' - β b := by
      exact hf'g' _ |>.1 h_g'_zero;
    obtain ⟨ a, rfl ⟩ := hα.2 a';
    replace h1 := congr_arg ( fun f => f a ) h1; simp_all +decide [ sub_eq_iff_eq_add ] ;
    exact ⟨ f a + b, by simp +decide ⟩

/-- Tao *Analysis I* Exercise 9.1.7: a finite union of closed subsets of `ℝ` is closed
(stated, as the report notes, without the unnecessary hypothesis `n ≥ 1`). -/
theorem isClosed_iUnion_fin {n : ℕ} (F : Fin n → Set ℝ)
    (h : ∀ i, IsClosed (F i)) : IsClosed (⋃ i, F i) := by
  exact isClosed_iUnion_of_finite h

/-- Order trichotomy for the integers (Lemma 4.1.11(f) / Exercise 4.1.7). -/
theorem int_order_trichotomy (a b : ℤ) : a < b ∨ a = b ∨ b < a :=
  lt_trichotomy a b

end ImoReport