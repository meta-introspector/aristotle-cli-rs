/-
∗11.  Theory of Two Apparent Variables.

Formalization of chapter ∗11 ("Theory of two apparent variables") of Section B,
"Theory of Apparent Variables", of Part I of Whitehead & Russell's
*Principia Mathematica* (Volume I).

The propositions of ∗11 are the analogues, for two bound (apparent) variables,
of the propositions of ∗10.  Russell's individuals all belong to a single range
of significance, so both apparent variables range over the *same* type `α`;
accordingly two-variable propositional functions are taken to be
`f g k : α → α → Prop` and one-variable functions `P Q R S : α → Prop`.

Notation correspondence (in addition to that of ∗10):
  * `(x, y) . φ(x, y)`   ↦ `∀ x, ∀ y, f x y`     (cf. ∗11·01)
  * `(∃x, y) . φ(x, y)`  ↦ `∃ x, ∃ y, f x y`     (cf. ∗11·03)
  * `φ(x,y) ⊃_{x,y} ψ(x,y)` ↦ `∀ x, ∀ y, f x y → g x y`

The rules of inference ∗11·11, ∗11·13 and ∗11·3·11 (the two-variable analogues
of the generalization rule ∗10·11) are metatheoretic and recorded as comments,
not stated as theorems.

Faithfulness note on the empty domain: as in ∗10, the propositions ∗11·46 and
∗11·47 (the two-variable analogues of ∗10·37 and ∗10·33) genuinely require the
range of individuals to be non-empty, and so carry a `[Nonempty α]` hypothesis.
-/

import Mathlib

namespace Principia.Part1.Section2

open Classical

variable {α : Type} (f g k : α → α → Prop) (P Q R S : α → Prop) (p : Prop)

-- ∗11·1  ⊢ : (x, y).φ(x, y) .⊃. φ(z, w)
theorem ast_11_1 (z w : α) : (∀ x, ∀ y, f x y) → f z w := fun h => h z w

-- ∗11·11 (rule of generalization for two variables) is a primitive proposition.

-- ∗11·14  ⊢ : (x, y).φ(x, y) : (x, y).ψ(x, y) :⊃. φ(z, w) . ψ(z, w)
theorem ast_11_14 (z w : α) :
    ((∀ x, ∀ y, f x y) ∧ (∀ x, ∀ y, g x y)) → (f z w ∧ g z w) :=
  fun h => ⟨h.1 z w, h.2 z w⟩

-- ∗11·2  ⊢ : (x, y).φ(x, y) .≡. (y, x).φ(x, y)   (commuting two universals)
theorem ast_11_2 : (∀ x, ∀ y, f x y) ↔ (∀ y, ∀ x, f x y) := by
  constructor <;> intro h a b
  · exact h b a
  · exact h b a

-- ∗11·23  ⊢ : (∃x, y).φ(x, y) .≡. (∃y, x).φ(x, y)   (commuting two existentials)
theorem ast_11_23 : (∃ x, ∃ y, f x y) ↔ (∃ y, ∃ x, f x y) := by
  constructor <;> rintro ⟨a, b, h⟩
  · exact ⟨b, a, h⟩
  · exact ⟨b, a, h⟩

-- ∗11·3  ⊢ :. p .⊃. (x, y).φ(x, y) :≡: (x, y) : p .⊃. φ(x, y)
theorem ast_11_3 : (p → ∀ x, ∀ y, f x y) ↔ (∀ x, ∀ y, p → f x y) := by tauto

-- ∗11·32  ⊢ :. (x, y) : φ(x, y) .⊃. ψ(x, y) :⊃: (x, y).φ(x, y) .⊃. (x, y).ψ(x, y)
theorem ast_11_32 :
    (∀ x, ∀ y, f x y → g x y) → ((∀ x, ∀ y, f x y) → (∀ x, ∀ y, g x y)) :=
  fun h hf x y => h x y (hf x y)

-- ∗11·33  ⊢ :. (x, y) : φ(x, y) .≡. ψ(x, y) :⊃: (x, y).φ(x, y) .≡. (x, y).ψ(x, y)
theorem ast_11_33 :
    (∀ x, ∀ y, f x y ↔ g x y) → ((∀ x, ∀ y, f x y) ↔ (∀ x, ∀ y, g x y)) := by
  intro h; constructor <;> intro hf x y
  · exact (h x y).mp (hf x y)
  · exact (h x y).mpr (hf x y)

-- ∗11·34  ⊢ :. (x, y) : φ(x, y) .⊃. ψ(x, y) :⊃: (∃x, y).φ(x, y) .⊃. (∃x, y).ψ(x, y)
theorem ast_11_34 :
    (∀ x, ∀ y, f x y → g x y) → ((∃ x, ∃ y, f x y) → (∃ x, ∃ y, g x y)) := by
  rintro h ⟨x, y, hf⟩; exact ⟨x, y, h x y hf⟩

-- ∗11·341  ⊢ :. (x, y) : φ(x, y) .≡. ψ(x, y) :⊃: (∃x, y).φ(x, y) .≡. (∃x, y).ψ(x, y)
theorem ast_11_341 :
    (∀ x, ∀ y, f x y ↔ g x y) → ((∃ x, ∃ y, f x y) ↔ (∃ x, ∃ y, g x y)) := by
  intro h; constructor <;> rintro ⟨x, y, hf⟩
  · exact ⟨x, y, (h x y).mp hf⟩
  · exact ⟨x, y, (h x y).mpr hf⟩

-- ∗11·35  ⊢ :. (x, y) : φ(x, y) .⊃. p :≡: (∃x, y).φ(x, y) .⊃. p
theorem ast_11_35 : (∀ x, ∀ y, f x y → p) ↔ ((∃ x, ∃ y, f x y) → p) := by
  constructor
  · rintro h ⟨x, y, hf⟩; exact h x y hf
  · intro h x y hf; exact h ⟨x, y, hf⟩

-- ∗11·36  ⊢ : φ(z, w) .⊃. (∃x, y).φ(x, y)
theorem ast_11_36 (z w : α) : f z w → ∃ x, ∃ y, f x y := fun h => ⟨z, w, h⟩

-- ∗11·37  ⊢ :. φ ⊃ ψ : ψ ⊃ χ :⊃: φ ⊃ χ   (transitivity of two-variable `⊃`)
theorem ast_11_37 :
    ((∀ x, ∀ y, f x y → g x y) ∧ (∀ x, ∀ y, g x y → k x y)) →
      (∀ x, ∀ y, f x y → k x y) :=
  fun h x y hf => h.2 x y (h.1 x y hf)

-- ∗11·371  ⊢ :. φ ≡ ψ : ψ ≡ χ :⊃: φ ≡ χ
theorem ast_11_371 :
    ((∀ x, ∀ y, f x y ↔ g x y) ∧ (∀ x, ∀ y, g x y ↔ k x y)) →
      (∀ x, ∀ y, f x y ↔ k x y) :=
  fun h x y => (h.1 x y).trans (h.2 x y)

-- ∗11·41  ⊢ :. (∃x, y).φ(x, y) .∨. (∃x, y).ψ(x, y) :≡. (∃x, y).φ(x, y) ∨ ψ(x, y)
theorem ast_11_41 :
    ((∃ x, ∃ y, f x y) ∨ (∃ x, ∃ y, g x y)) ↔ (∃ x, ∃ y, f x y ∨ g x y) := by
  constructor
  · rintro (⟨x, y, h⟩ | ⟨x, y, h⟩)
    · exact ⟨x, y, Or.inl h⟩
    · exact ⟨x, y, Or.inr h⟩
  · rintro ⟨x, y, h | h⟩
    · exact Or.inl ⟨x, y, h⟩
    · exact Or.inr ⟨x, y, h⟩

-- ∗11·42  ⊢ :. (∃x, y).φ(x, y) . ψ(x, y) .⊃: (∃x, y).φ(x, y) : (∃x, y).ψ(x, y)
theorem ast_11_42 :
    (∃ x, ∃ y, f x y ∧ g x y) → ((∃ x, ∃ y, f x y) ∧ (∃ x, ∃ y, g x y)) := by
  rintro ⟨x, y, a, b⟩; exact ⟨⟨x, y, a⟩, ⟨x, y, b⟩⟩

-- ∗11·421  ⊢ :. (x, y).φ(x, y) .∨. (x, y).ψ(x, y) :⊃. (x, y).φ(x, y) ∨ ψ(x, y)
theorem ast_11_421 :
    ((∀ x, ∀ y, f x y) ∨ (∀ x, ∀ y, g x y)) → (∀ x, ∀ y, f x y ∨ g x y) := by
  rintro (h | h) x y
  · exact Or.inl (h x y)
  · exact Or.inr (h x y)

-- ∗11·44  ⊢ :. (x, y) : φ(x, y) .∨. p :≡: (x, y).φ(x, y) .∨. p
theorem ast_11_44 : (∀ x, ∀ y, f x y ∨ p) ↔ ((∀ x, ∀ y, f x y) ∨ p) := by
  constructor
  · intro h
    by_cases hp : p
    · exact Or.inr hp
    · exact Or.inl (fun x y => (h x y).resolve_right hp)
  · rintro (h | hp) x y
    · exact Or.inl (h x y)
    · exact Or.inr hp

-- ∗11·45  ⊢ :. (∃x, y) : p . φ(x, y) :≡: p : (∃x, y).φ(x, y)
theorem ast_11_45 : (∃ x, ∃ y, p ∧ f x y) ↔ (p ∧ ∃ x, ∃ y, f x y) := by tauto

-- ∗11·46  ⊢ :. (∃x, y) : p .⊃. φ(x, y) :≡: p .⊃. (∃x, y).φ(x, y)
--        (requires the domain to be non-empty)
theorem ast_11_46 [Nonempty α] :
    (∃ x, ∃ y, p → f x y) ↔ (p → ∃ x, ∃ y, f x y) := by
  constructor
  · rintro ⟨x, y, h⟩ hp; exact ⟨x, y, h hp⟩
  · intro h
    by_cases hp : p
    · obtain ⟨x, y, hf⟩ := h hp; exact ⟨x, y, fun _ => hf⟩
    · exact ⟨Classical.arbitrary α, Classical.arbitrary α, fun hp' => absurd hp' hp⟩

-- ∗11·47  ⊢ :. (x, y) : p . φ(x, y) :≡: p : (x, y).φ(x, y)
--        (requires the domain to be non-empty)
theorem ast_11_47 [Nonempty α] :
    (∀ x, ∀ y, p ∧ f x y) ↔ (p ∧ ∀ x, ∀ y, f x y) := by
  constructor
  · intro h
    exact ⟨(h (Classical.arbitrary α) (Classical.arbitrary α)).1, fun x y => (h x y).2⟩
  · intro h x y; exact ⟨h.1, h.2 x y⟩

-- ∗11·5  ⊢ : ¬{(x, y).φ(x, y)} .≡. (∃x, y).¬φ(x, y)
theorem ast_11_5 : (¬ ∀ x, ∀ y, f x y) ↔ (∃ x, ∃ y, ¬ f x y) := by
  rw [not_forall]
  constructor <;> rintro ⟨x, hx⟩
  · exact ⟨x, not_forall.mp hx⟩
  · exact ⟨x, not_forall.mpr hx⟩

-- ∗11·51  ⊢ :. (∃x) : (y).φ(x, y) :≡: ¬{(x) : (∃y).¬φ(x, y)}
theorem ast_11_51 : (∃ x, ∀ y, f x y) ↔ ¬ ∀ x, ∃ y, ¬ f x y := by
  push_neg; rfl

-- ∗11·52  ⊢ : (∃x, y).φ(x, y) . ψ(x, y) .≡. ¬{(x, y) : φ(x, y) .⊃. ¬ψ(x, y)}
theorem ast_11_52 :
    (∃ x, ∃ y, f x y ∧ g x y) ↔ ¬ ∀ x, ∀ y, f x y → ¬ g x y := by
  push_neg; simp

-- ∗11·521  ⊢ : ¬{(∃x, y).φ(x, y) . ¬ψ(x, y)} .≡. (x, y) : φ(x, y) .⊃. ψ(x, y)
theorem ast_11_521 :
    (¬ ∃ x, ∃ y, f x y ∧ ¬ g x y) ↔ (∀ x, ∀ y, f x y → g x y) := by
  push_neg; simp

-- ∗11·53  ⊢ :. (x, y) : φx .⊃. ψy :≡: (∃x).φx .⊃. (y).ψy
theorem ast_11_53 :
    (∀ x, ∀ y, P x → Q y) ↔ ((∃ x, P x) → (∀ y, Q y)) := by
  constructor
  · rintro h ⟨x, hx⟩ y; exact h x y hx
  · intro h x y hx; exact h ⟨x, hx⟩ y

-- ∗11·54  ⊢ :. (∃x, y).φx . ψy :≡: (∃x).φx : (∃y).ψy
theorem ast_11_54 :
    (∃ x, ∃ y, P x ∧ Q y) ↔ ((∃ x, P x) ∧ (∃ y, Q y)) := by
  constructor
  · rintro ⟨x, y, hx, hy⟩; exact ⟨⟨x, hx⟩, ⟨y, hy⟩⟩
  · rintro ⟨⟨x, hx⟩, ⟨y, hy⟩⟩; exact ⟨x, y, hx, hy⟩

-- ∗11·55  ⊢ :. (∃x, y).φx . ψ(x, y) :≡: (∃x) : φx : (∃y).ψ(x, y)
theorem ast_11_55 :
    (∃ x, ∃ y, P x ∧ g x y) ↔ (∃ x, P x ∧ ∃ y, g x y) := by
  constructor
  · rintro ⟨x, y, hx, hy⟩; exact ⟨x, hx, y, hy⟩
  · rintro ⟨x, hx, y, hy⟩; exact ⟨x, y, hx, hy⟩

-- ∗11·56  ⊢ :. (x).φx : (y).ψy :≡: (x, y).φx . ψy
theorem ast_11_56 : ((∀ x, P x) ∧ (∀ x, Q x)) ↔ (∀ x, ∀ y, P x ∧ Q y) := by
  constructor
  · rintro ⟨h1, h2⟩ x y; exact ⟨h1 x, h2 y⟩
  · intro h; exact ⟨fun x => (h x x).1, fun y => (h y y).2⟩

-- ∗11·57  ⊢ : (x).φx .≡. (x, y).φx . φy
theorem ast_11_57 : (∀ x, P x) ↔ (∀ x, ∀ y, P x ∧ P y) := by
  constructor
  · intro h x y; exact ⟨h x, h y⟩
  · intro h x; exact (h x x).1

-- ∗11·58  ⊢ : (∃x).φx .≡. (∃x, y).φx . φy
theorem ast_11_58 : (∃ x, P x) ↔ (∃ x, ∃ y, P x ∧ P y) := by
  constructor
  · rintro ⟨x, hx⟩; exact ⟨x, x, hx, hx⟩
  · rintro ⟨x, _, hx, _⟩; exact ⟨x, hx⟩

-- ∗11·59  ⊢ :. φx ⊃ₓ ψx :≡: φx . φy .⊃_{x,y}. ψx . ψy
theorem ast_11_59 :
    (∀ x, P x → Q x) ↔ (∀ x, ∀ y, (P x ∧ P y) → (Q x ∧ Q y)) := by
  constructor
  · intro h x y hxy; exact ⟨h x hxy.1, h y hxy.2⟩
  · intro h x hx; exact (h x x ⟨hx, hx⟩).1

-- ∗11·6  ⊢ :: (∃x) :. (∃y).φ(x, y) . ψy : χx :≡:. (∃y) :. (∃x).φ(x, y) . χx : ψy
theorem ast_11_6 :
    (∃ x, (∃ y, f x y ∧ S y) ∧ R x) ↔ (∃ y, (∃ x, f x y ∧ R x) ∧ S y) := by
  constructor
  · rintro ⟨x, ⟨y, hf, hs⟩, hr⟩; exact ⟨y, ⟨x, hf, hr⟩, hs⟩
  · rintro ⟨y, ⟨x, hf, hr⟩, hs⟩; exact ⟨x, ⟨y, hf, hs⟩, hr⟩

-- ∗11·62  ⊢ :: φx . ψ(x, y) .⊃_{x,y}. χ(x, y) :≡:. φx .⊃ₓ: ψ(x, y) .⊃_y. χ(x, y)
theorem ast_11_62 :
    (∀ x, ∀ y, (P x ∧ f x y) → k x y) ↔ (∀ x, P x → ∀ y, f x y → k x y) := by
  constructor
  · intro h x hx y hf; exact h x y ⟨hx, hf⟩
  · intro h x y hxy; exact h x hxy.1 y hxy.2

-- ∗11·7  ⊢ :. (∃x, y) : φ(x, y) .∨. φ(y, x) :≡. (∃x, y).φ(x, y)
theorem ast_11_7 : (∃ x, ∃ y, f x y ∨ f y x) ↔ (∃ x, ∃ y, f x y) := by
  constructor
  · rintro ⟨x, y, h | h⟩
    · exact ⟨x, y, h⟩
    · exact ⟨y, x, h⟩
  · rintro ⟨x, y, h⟩; exact ⟨x, y, Or.inl h⟩

-- ∗11·71  ⊢ :: (∃z).φz : (∃w).χw :⊃:. φz ⊃_z ψz . χw ⊃_w θw :≡: φz . χw .⊃_{z,w}. ψz . θw
theorem ast_11_71 :
    ((∃ z, P z) ∧ (∃ w, R w)) →
      (((∀ z, P z → Q z) ∧ (∀ w, R w → S w)) ↔
        (∀ z, ∀ w, (P z ∧ R w) → (Q z ∧ S w))) := by
  rintro ⟨⟨z0, hz0⟩, ⟨w0, hw0⟩⟩
  constructor
  · rintro ⟨h1, h2⟩ z w hzw; exact ⟨h1 z hzw.1, h2 w hzw.2⟩
  · intro h
    exact ⟨fun z hz => (h z w0 ⟨hz, hw0⟩).1, fun w hw => (h z0 w ⟨hz0, hw⟩).2⟩

end Principia.Part1.Section2
