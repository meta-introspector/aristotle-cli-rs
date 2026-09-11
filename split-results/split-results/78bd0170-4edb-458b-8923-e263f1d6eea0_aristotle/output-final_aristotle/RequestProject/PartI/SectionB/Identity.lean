/-
∗13.  Identity.

Formalization of chapter ∗13 ("Identity") of Section B, "Theory of Apparent
Variables", of Part I of Whitehead & Russell's *Principia Mathematica*
(Volume I).

Russell *defines* identity (∗13·01 of the book, his numbering ∗13·1 below) by
Leibniz's law: `x = y` means that every (predicative) propositional function
true of `x` is true of `y`.  In Lean identity is the primitive `Eq`; the content
of ∗13·1 and ∗13·11 is therefore the *theorem* that Lean's `=` coincides with
the Leibniz characterization

  `x = y  ↔  ∀ (f : α → Prop), f x → f y`.

Notation correspondence (in addition to that of ∗10):
  * `x = y`   ↦ `x = y`
  * `x ≠ y`   ↦ `x ≠ y`   (`= ¬ (x = y)`, this is ∗13·01)
  * `φ ! x`   ↦ `f x` for `f : α → Prop`

Here `P Q : α → Prop` are propositional functions and `x y z : α` are
individuals.
-/

import Mathlib

namespace Principia.Part1.Section2

variable {α : Type} (x y z : α) (P Q : α → Prop)

-- ∗13·01  x ≠ y .=. ¬(x = y)   Df
theorem ast_13_01 : (x ≠ y) ↔ ¬ (x = y) := Iff.rfl

-- ∗13·1  ⊢ :. x = y .≡: φ!x .⊃_φ. φ!y   (Leibniz's definition of identity)
theorem ast_13_1 : (x = y) ↔ ∀ (f : α → Prop), f x → f y := by
  constructor
  · rintro rfl f h; exact h
  · intro h; exact h (fun t => x = t) rfl

-- ∗13·101  ⊢ : x = y .⊃. φx ⊃ φy   (substitutivity of identity)
theorem ast_13_101 : x = y → P x → P y := by rintro rfl h; exact h

-- ∗13·11  ⊢ :. x = y .≡: φ!x .≡_φ. φ!y
theorem ast_13_11 : (x = y) ↔ ∀ (f : α → Prop), f x ↔ f y := by
  constructor
  · rintro rfl f; rfl
  · intro h; exact (h (fun t => x = t)).mp rfl

-- ∗13·12  ⊢ : x = y .⊃. ψx ≡ ψy
theorem ast_13_12 : x = y → (P x ↔ P y) := by rintro rfl; rfl

-- ∗13·13  ⊢ : ψx . x = y .⊃. ψy
theorem ast_13_13 : P x → x = y → P y := by rintro h rfl; exact h

-- ∗13·14  ⊢ : ψx . ¬ψy .⊃. x ≠ y
theorem ast_13_14 : (P x ∧ ¬ P y) → x ≠ y := by rintro ⟨h1, h2⟩ rfl; exact h2 h1

-- ∗13·15  ⊢ . x = x   (identity is reflexive)
theorem ast_13_15 : x = x := rfl

-- ∗13·16  ⊢ : x = y .≡. y = x   (identity is symmetrical)
theorem ast_13_16 : (x = y) ↔ (y = x) := eq_comm

-- ∗13·17  ⊢ : x = y . y = z .⊃. x = z   (identity is transitive)
theorem ast_13_17 : x = y → y = z → x = z := fun h1 h2 => h1.trans h2

-- ∗13·171  ⊢ : x = y . x = z .⊃. y = z
theorem ast_13_171 : x = y → x = z → y = z := fun h1 h2 => h1.symm.trans h2

-- ∗13·172  ⊢ : y = x . z = x .⊃. y = z
theorem ast_13_172 : y = x → z = x → y = z := fun h1 h2 => h1.trans h2.symm

-- ∗13·181  ⊢ : x = y . y ≠ z .⊃. x ≠ z
theorem ast_13_181 : x = y → y ≠ z → x ≠ z := by rintro rfl h; exact h

-- ∗13·182  ⊢ :. x = y .⊃: z = x .≡. z = y
theorem ast_13_182 : x = y → (z = x ↔ z = y) := by rintro rfl; rfl

-- ∗13·18  ⊢ :. z = x .≡_z. z = y :≡. x = y
theorem ast_13_18 : (∀ w, w = x ↔ w = y) ↔ (x = y) := by
  constructor
  · intro h; exact (h x).mp rfl
  · rintro rfl w; rfl

-- ∗13·19  ⊢ . (∃y) . y = x
theorem ast_13_19 : ∃ w, w = x := ⟨x, rfl⟩

-- ∗13·191  ⊢ :. y = x .⊃_y. φy :≡. φx
theorem ast_13_191 : (∀ w, w = x → P w) ↔ P x := by
  constructor
  · intro h; exact h x rfl
  · rintro h w rfl; exact h

-- ∗13·192  ⊢ :. (∃c) : x = b .≡_x. x = c : ψc :≡. ψb
theorem ast_13_192 (b : α) : (∃ c, (∀ w, w = b ↔ w = c) ∧ Q c) ↔ Q b := by
  constructor
  · rintro ⟨c, h, hc⟩; rwa [(h c).mpr rfl] at hc
  · intro h; exact ⟨b, fun _ => Iff.rfl, h⟩

-- ∗13·193  ⊢ : φx . x = y .≡. φy . x = y
theorem ast_13_193 : (P x ∧ x = y) ↔ (P y ∧ x = y) := by
  constructor <;> rintro ⟨h, rfl⟩ <;> exact ⟨h, rfl⟩

-- ∗13·194  ⊢ : φx . x = y .≡. φx . φy . x = y
theorem ast_13_194 : (P x ∧ x = y) ↔ (P x ∧ P y ∧ x = y) := by
  constructor
  · rintro ⟨h, rfl⟩; exact ⟨h, h, rfl⟩
  · rintro ⟨h, _, rfl⟩; exact ⟨h, rfl⟩

-- ∗13·195  ⊢ : (∃y) . y = x . φy .≡. φx
theorem ast_13_195 : (∃ w, w = x ∧ P w) ↔ P x := by
  constructor
  · rintro ⟨w, rfl, h⟩; exact h
  · intro h; exact ⟨x, rfl, h⟩

-- ∗13·196  ⊢ :. ¬φx .≡: φy .⊃_y. y ≠ x
theorem ast_13_196 : (¬ P x) ↔ (∀ w, P w → w ≠ x) := by
  constructor
  · rintro h w hw rfl; exact h hw
  · intro h hx; exact h x hx rfl

end Principia.Part1.Section2
