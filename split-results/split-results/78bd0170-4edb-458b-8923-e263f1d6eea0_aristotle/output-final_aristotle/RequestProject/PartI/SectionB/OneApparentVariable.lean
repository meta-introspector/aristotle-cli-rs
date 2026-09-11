/-
∗10.  Theory of One Apparent Variable.

Formalization of chapter ∗10 ("Theory of one apparent variable") of Section B,
"Theory of Apparent Variables", of Part I of Whitehead & Russell's
*Principia Mathematica* (Volume I).

This is the first chapter that leaves pure propositional logic (Section A,
∗1–∗5) behind and introduces an *apparent variable* — i.e. a bound (quantified)
variable.  Russell writes `(x) . φx` for the universal quantification
`∀ x, φ x` and `(∃x) . φx` for the existential quantification `∃ x, φ x`.

Notation correspondence:
  * `(x) . φx`        ↦ `∀ x, P x`
  * `(∃x) . φx`       ↦ `∃ x, P x`
  * material implication `⊃` ↦ `→`
  * `∨`, `¬`, logical product `.` ↦ `∨`, `¬`, `∧`
  * formal equivalence `≡` ↦ `↔`
  * `φx ⊃ₓ ψx`  (∗10·02)  ↦ `∀ x, P x → Q x`
  * `φx ≡ₓ ψx`  (∗10·03)  ↦ `∀ x, P x ↔ Q x`

Here `P Q R S : α → Prop` play the role of Russell's propositional functions
`φ, ψ, χ, θ`, and `p q : Prop` are genuine (argument-free) propositions.

Faithfulness note on the empty domain.  Russell's individuals are tacitly
assumed to form a non-empty range of significance (an individual exists); the
quantifier laws ∗10·25, ∗10·33, ∗10·36 and ∗10·37 genuinely require this, so
those statements carry a `[Nonempty α]` hypothesis.  All other propositions hold
for every type `α`, including the empty one.

The metatheoretic propositions ∗10·11 (the rule of generalization), ∗10·121,
∗10·122 and ∗10·13 concern the *significance* of expressions and the rules of
inference rather than asserting object-level formulas; they are recorded as
comments where they occur and are not stated as Lean theorems.
-/

import Mathlib

namespace Principia.Part1.Section2

open Classical

variable {α : Type} (P Q R S : α → Prop) (p q : Prop)

-- ∗10·01  (∃x).φx .=. ¬{(x).¬φx}   Df
-- As an equivalence (the definition turned into the provable biconditional
-- `⊢ : (∃x).φx . ≡ . ¬(x).¬φx` of the alternative method):
theorem ast_10_01 : (∃ x, P x) ↔ ¬ ∀ x, ¬ P x := by
  simp [not_forall]

-- ∗10·02 and ∗10·03 are notational definitions for `⊃ₓ` and `≡ₓ`; they need no
-- separate statement since we write `∀ x, P x → Q x` and `∀ x, P x ↔ Q x`
-- directly.

-- ∗10·1  ⊢ : (x).φx .⊃. φy   — what is true of all is true of any.
theorem ast_10_1 (y : α) : (∀ x, P x) → P y := fun h => h y

-- ∗10·11 (rule of generalization) is a primitive proposition / rule of
-- inference, not an object-level theorem.

-- ∗10·12  ⊢ : (x).p ∨ φx .⊃. p ∨ (x).φx
theorem ast_10_12 : (∀ x, p ∨ P x) → (p ∨ ∀ x, P x) :=
  fun h => forall_or_left.mp h

-- ∗10·14  ⊢ : (x).φx : (x).ψx :⊃. φy . ψy
theorem ast_10_14 (y : α) : ((∀ x, P x) ∧ (∀ x, Q x)) → (P y ∧ Q y) :=
  fun h => ⟨h.1 y, h.2 y⟩

-- ∗10·2  ⊢ :. (x).p ∨ φx .≡: p .∨. (x).φx
theorem ast_10_2 : (∀ x, p ∨ P x) ↔ (p ∨ ∀ x, P x) := forall_or_left

-- ∗10·21  ⊢ :. (x).p ⊃ φx .≡: p .⊃. (x).φx
theorem ast_10_21 : (∀ x, p → P x) ↔ (p → ∀ x, P x) := by tauto

-- ∗10·22  ⊢ :. (x).φx . ψx .≡: (x).φx : (x).ψx
theorem ast_10_22 : (∀ x, P x ∧ Q x) ↔ ((∀ x, P x) ∧ (∀ x, Q x)) := forall_and

-- ∗10·23  ⊢ :. (x).φx ⊃ p .≡: (∃x).φx .⊃. p
theorem ast_10_23 : (∀ x, P x → p) ↔ ((∃ x, P x) → p) := by tauto

-- ∗10·24  ⊢ : φy .⊃. (∃x).φx   — the sole method of proving existence-theorems.
theorem ast_10_24 (y : α) : P y → ∃ x, P x := fun h => ⟨y, h⟩

-- ∗10·25  ⊢ : (x).φx .⊃. (∃x).φx   (requires the domain to be non-empty)
theorem ast_10_25 [Nonempty α] : (∀ x, P x) → ∃ x, P x :=
  fun h => ⟨Classical.arbitrary α, h _⟩

-- ∗10·252  ⊢ : ¬{(∃x).φx} .≡. (x).¬φx
theorem ast_10_252 : (¬ ∃ x, P x) ↔ (∀ x, ¬ P x) := by tauto

-- ∗10·253  ⊢ : ¬{(x).φx} .≡. (∃x).¬φx
theorem ast_10_253 : (¬ ∀ x, P x) ↔ (∃ x, ¬ P x) := not_forall

-- ∗10·26  ⊢ :. (z).φz ⊃ ψz : φx .⊃. ψx   — syllogism in Barbara.
theorem ast_10_26 (y : α) : (∀ z, P z → Q z) → P y → Q y := fun h hy => h y hy

-- ∗10·27  ⊢ :. (z).φz ⊃ ψz .⊃: (z).φz .⊃. (z).ψz
theorem ast_10_27 : (∀ z, P z → Q z) → ((∀ z, P z) → (∀ z, Q z)) :=
  fun h hP z => h z (hP z)

-- ∗10·271  ⊢ :. (z).φz ≡ ψz .⊃: (z).φz .≡. (z).ψz
theorem ast_10_271 : (∀ z, P z ↔ Q z) → ((∀ z, P z) ↔ (∀ z, Q z)) :=
  fun h => forall_congr' h

-- ∗10·28  ⊢ :. (x).φx ⊃ ψx .⊃: (∃x).φx .⊃. (∃x).ψx
theorem ast_10_28 : (∀ x, P x → Q x) → ((∃ x, P x) → (∃ x, Q x)) :=
  fun h => fun ⟨x, hx⟩ => ⟨x, h x hx⟩

-- ∗10·281  ⊢ :. (x).φx ≡ ψx .⊃: (∃x).φx .≡. (∃x).ψx
theorem ast_10_281 : (∀ x, P x ↔ Q x) → ((∃ x, P x) ↔ (∃ x, Q x)) :=
  fun h => exists_congr h

-- ∗10·29  ⊢ :. (x).φx ⊃ ψx : (x).φx ⊃ χx :≡: (x): φx .⊃. ψx . χx
theorem ast_10_29 :
    ((∀ x, P x → Q x) ∧ (∀ x, P x → R x)) ↔ (∀ x, P x → (Q x ∧ R x)) := by
  constructor
  · rintro ⟨h1, h2⟩ x hx; exact ⟨h1 x hx, h2 x hx⟩
  · intro h; exact ⟨fun x hx => (h x hx).1, fun x hx => (h x hx).2⟩

-- ∗10·3  ⊢ :. (x).φx ⊃ ψx : (x).ψx ⊃ χx :⊃. (x).φx ⊃ χx
--        (the second form of the syllogism in Barbara; transitivity of `⊃ₓ`)
theorem ast_10_3 :
    ((∀ x, P x → Q x) ∧ (∀ x, Q x → R x)) → (∀ x, P x → R x) :=
  fun h x hx => h.2 x (h.1 x hx)

-- ∗10·301  ⊢ :. (x).φx ≡ ψx : (x).ψx ≡ χx :⊃. (x).φx ≡ χx
--        (transitivity of formal equivalence `≡ₓ`)
theorem ast_10_301 :
    ((∀ x, P x ↔ Q x) ∧ (∀ x, Q x ↔ R x)) → (∀ x, P x ↔ R x) :=
  fun h x => (h.1 x).trans (h.2 x)

-- ∗10·31  ⊢ :. (x).φx ⊃ ψx .⊃: (x): φx . χx .⊃. ψx . χx
theorem ast_10_31 : (∀ x, P x → Q x) → (∀ x, (P x ∧ R x) → (Q x ∧ R x)) :=
  fun h x hx => ⟨h x hx.1, hx.2⟩

-- ∗10·311  ⊢ :. (x).φx ≡ ψx .⊃: (x): φx . χx .≡. ψx . χx
theorem ast_10_311 : (∀ x, P x ↔ Q x) → (∀ x, (P x ∧ R x) ↔ (Q x ∧ R x)) := by
  intro h x; rw [h x]

-- ∗10·32  ⊢ : φx ≡ₓ ψx .⊃. ψx ≡ₓ φx   (symmetry of formal equivalence)
theorem ast_10_32 : (∀ x, P x ↔ Q x) → (∀ x, Q x ↔ P x) :=
  fun h x => (h x).symm

-- ∗10·321  ⊢ : φx ≡ₓ ψx . φx ≡ₓ χx .⊃. ψx ≡ₓ χx
theorem ast_10_321 :
    ((∀ x, P x ↔ Q x) ∧ (∀ x, P x ↔ R x)) → (∀ x, Q x ↔ R x) :=
  fun h x => (h.1 x).symm.trans (h.2 x)

-- ∗10·322  ⊢ : ψx ≡ₓ φx . χx ≡ₓ φx .⊃. ψx ≡ₓ χx
theorem ast_10_322 :
    ((∀ x, Q x ↔ P x) ∧ (∀ x, R x ↔ P x)) → (∀ x, Q x ↔ R x) :=
  fun h x => (h.1 x).trans (h.2 x).symm

-- ∗10·33  ⊢ :. (x): φx . p :≡: (x).φx : p   (requires the domain to be non-empty)
theorem ast_10_33 [Nonempty α] : (∀ x, P x ∧ p) ↔ ((∀ x, P x) ∧ p) := by
  constructor
  · intro h; exact ⟨fun x => (h x).1, (h (Classical.arbitrary α)).2⟩
  · intro h x; exact ⟨h.1 x, h.2⟩

-- ∗10·35  ⊢ :. (∃x).p . φx .≡: p : (∃x).φx
theorem ast_10_35 : (∃ x, p ∧ P x) ↔ (p ∧ ∃ x, P x) := by tauto

-- ∗10·36  ⊢ :. (∃x).φx ∨ p .≡: (∃x).φx .∨. p   (requires the domain non-empty)
theorem ast_10_36 [Nonempty α] : (∃ x, P x ∨ p) ↔ ((∃ x, P x) ∨ p) := by
  constructor
  · rintro ⟨x, hx | hp⟩
    · exact Or.inl ⟨x, hx⟩
    · exact Or.inr hp
  · rintro (⟨x, hx⟩ | hp)
    · exact ⟨x, Or.inl hx⟩
    · exact ⟨Classical.arbitrary α, Or.inr hp⟩

-- ∗10·37  ⊢ :. (∃x).p ⊃ φx .≡: p .⊃. (∃x).φx   (requires the domain non-empty)
theorem ast_10_37 [Nonempty α] : (∃ x, p → P x) ↔ (p → ∃ x, P x) := by
  constructor
  · rintro ⟨x, hx⟩ hp; exact ⟨x, hx hp⟩
  · intro h
    by_cases hp : p
    · obtain ⟨x, hx⟩ := h hp; exact ⟨x, fun _ => hx⟩
    · exact ⟨Classical.arbitrary α, fun hp' => absurd hp' hp⟩

-- ∗10·39  ⊢ :. φx ⊃ₓ ψx : χx ⊃ₓ θx :⊃: φx . χx .⊃ₓ. ψx . θx
theorem ast_10_39 :
    ((∀ x, P x → Q x) ∧ (∀ x, R x → S x)) →
      (∀ x, (P x ∧ R x) → (Q x ∧ S x)) :=
  fun h x hx => ⟨h.1 x hx.1, h.2 x hx.2⟩

-- ∗10·4  ⊢ :. φx ≡ₓ χx : ψx ≡ₓ θx :⊃: φx . ψx .≡ₓ. χx . θx
theorem ast_10_4 :
    ((∀ x, P x ↔ R x) ∧ (∀ x, Q x ↔ S x)) →
      (∀ x, (P x ∧ Q x) ↔ (R x ∧ S x)) := by
  rintro ⟨h1, h2⟩ x; rw [h1 x, h2 x]

-- ∗10·41  ⊢ :. (x).φx .∨. (x).ψx :⊃. (x).φx ∨ ψx
theorem ast_10_41 : ((∀ x, P x) ∨ (∀ x, Q x)) → (∀ x, P x ∨ Q x) := by
  rintro (h | h) x
  · exact Or.inl (h x)
  · exact Or.inr (h x)

-- ∗10·411  ⊢ :. φx ≡ₓ χx : ψx ≡ₓ θx :⊃: φx ∨ ψx .≡ₓ. χx ∨ θx
theorem ast_10_411 :
    ((∀ x, P x ↔ R x) ∧ (∀ x, Q x ↔ S x)) →
      (∀ x, (P x ∨ Q x) ↔ (R x ∨ S x)) := by
  rintro ⟨h1, h2⟩ x; rw [h1 x, h2 x]

-- ∗10·412  ⊢ : φx ≡ₓ ψx .≡. ¬φx ≡ₓ ¬ψx
theorem ast_10_412 : (∀ x, P x ↔ Q x) ↔ (∀ x, ¬ P x ↔ ¬ Q x) := by
  constructor <;> intro h x
  · rw [h x]
  · exact not_iff_not.mp (h x)

-- ∗10·413  ⊢ : φx ≡ₓ χx : ψx ≡ₓ θx :⊃: (φx ⊃ ψx) ≡ₓ (χx ⊃ θx)
theorem ast_10_413 :
    ((∀ x, P x ↔ R x) ∧ (∀ x, Q x ↔ S x)) →
      (∀ x, (P x → Q x) ↔ (R x → S x)) := by
  rintro ⟨h1, h2⟩ x; rw [h1 x, h2 x]

-- ∗10·414  ⊢ : φx ≡ₓ χx : ψx ≡ₓ θx :⊃: (φx ≡ ψx) ≡ₓ (χx ≡ θx)
theorem ast_10_414 :
    ((∀ x, P x ↔ R x) ∧ (∀ x, Q x ↔ S x)) →
      (∀ x, (P x ↔ Q x) ↔ (R x ↔ S x)) := by
  rintro ⟨h1, h2⟩ x; rw [h1 x, h2 x]

-- ∗10·42  ⊢ :. (∃x).φx .∨. (∃x).ψx :≡. (∃x).φx ∨ ψx
theorem ast_10_42 : ((∃ x, P x) ∨ (∃ x, Q x)) ↔ (∃ x, P x ∨ Q x) := by
  constructor
  · rintro (⟨x, h⟩ | ⟨x, h⟩)
    · exact ⟨x, Or.inl h⟩
    · exact ⟨x, Or.inr h⟩
  · rintro ⟨x, h | h⟩
    · exact Or.inl ⟨x, h⟩
    · exact Or.inr ⟨x, h⟩

-- ∗10·43  ⊢ : φz ≡_z ψz . φx .≡. φz ≡_z ψz . ψx
theorem ast_10_43 (y : α) :
    ((∀ z, P z ↔ Q z) ∧ P y) ↔ ((∀ z, P z ↔ Q z) ∧ Q y) := by
  constructor
  · rintro ⟨h, hy⟩; exact ⟨h, (h y).mp hy⟩
  · rintro ⟨h, hy⟩; exact ⟨h, (h y).mpr hy⟩

-- ∗10·5  ⊢ :. (∃x).φx . ψx .⊃: (∃x).φx : (∃x).ψx
--        (only an implication, not — as for ∗10·42 — an equivalence)
theorem ast_10_5 : (∃ x, P x ∧ Q x) → ((∃ x, P x) ∧ (∃ x, Q x)) := by
  rintro ⟨x, a, b⟩; exact ⟨⟨x, a⟩, ⟨x, b⟩⟩

-- ∗10·51  ⊢ :. ¬{(∃x).φx . ψx} .≡: φx .⊃ₓ. ¬ψx
theorem ast_10_51 : (¬ ∃ x, P x ∧ Q x) ↔ (∀ x, P x → ¬ Q x) := by
  constructor
  · intro h x hx hy; exact h ⟨x, hx, hy⟩
  · rintro h ⟨x, hx, hy⟩; exact h x hx hy

-- ∗10·52  ⊢ :. (∃x).φx .⊃: (x).φx ⊃ p .≡. p
theorem ast_10_52 : (∃ x, P x) → ((∀ x, P x → p) ↔ p) := by
  rintro ⟨x, hx⟩
  constructor
  · intro h; exact h x hx
  · intro hp _ _; exact hp

-- ∗10·53  ⊢ :. ¬(∃x).φx .⊃: φx .⊃ₓ. ψx
theorem ast_10_53 : (¬ ∃ x, P x) → (∀ x, P x → Q x) := by
  intro h x hx; exact absurd ⟨x, hx⟩ h

-- ∗10·541  ⊢ :. φy .⊃_y. p ∨ ψy :≡: p .∨. φy ⊃_y ψy
theorem ast_10_541 : (∀ y, P y → (p ∨ Q y)) ↔ (p ∨ ∀ y, P y → Q y) := by
  constructor
  · intro h
    by_cases hp : p
    · exact Or.inl hp
    · exact Or.inr (fun y hy => (h y hy).resolve_left hp)
  · rintro (hp | h) y hy
    · exact Or.inl hp
    · exact Or.inr (h y hy)

-- ∗10·542  ⊢ :. φy .⊃_y. p ⊃ ψy :≡: p .⊃. φy ⊃_y ψy
theorem ast_10_542 : (∀ y, P y → (p → Q y)) ↔ (p → ∀ y, P y → Q y) := by
  constructor
  · intro h hp y hy; exact h y hy hp
  · intro h y hy hp; exact h hp y hy

-- ∗10·55  ⊢ :. (∃x).φx . ψx : φx ⊃ₓ ψx :≡: (∃x).φx : φx ⊃ₓ ψx
theorem ast_10_55 :
    ((∃ x, P x ∧ Q x) ∧ (∀ x, P x → Q x)) ↔
      ((∃ x, P x) ∧ (∀ x, P x → Q x)) := by
  constructor
  · rintro ⟨⟨x, a, b⟩, h⟩; exact ⟨⟨x, a⟩, h⟩
  · rintro ⟨⟨x, a⟩, h⟩; exact ⟨⟨x, a, h x a⟩, h⟩

-- ∗10·56  ⊢ :. φx ⊃ₓ ψx : (∃x).φx . χx :⊃. (∃x).ψx . χx
theorem ast_10_56 :
    ((∀ x, P x → Q x) ∧ (∃ x, P x ∧ R x)) → (∃ x, Q x ∧ R x) := by
  rintro ⟨h, x, a, c⟩; exact ⟨x, h x a, c⟩

-- ∗10·57  ⊢ :. φx .⊃ₓ. ψx ∨ χx :⊃: φx ⊃ₓ ψx .∨. (∃x).φx . χx
theorem ast_10_57 :
    (∀ x, P x → (Q x ∨ R x)) → ((∀ x, P x → Q x) ∨ (∃ x, P x ∧ R x)) := by
  intro h
  by_cases hc : ∃ x, P x ∧ R x
  · exact Or.inr hc
  · exact Or.inl (fun x hx => (h x hx).resolve_right (fun hcx => hc ⟨x, hx, hcx⟩))

end Principia.Part1.Section2
