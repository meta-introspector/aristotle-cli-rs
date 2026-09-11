/-
∗20.  General Theory of Classes.

Formalization of chapter ∗20 ("General Theory of Classes"), the opening chapter
of Section C of Part I of Whitehead & Russell's *Principia Mathematica*
(Volume I).  This is the first chapter of the relation/class development that the
later cardinal-arithmetic, relation-arithmetic and series volumes are built on.

Modelling decision (recorded for faithfulness review).
------------------------------------------------------
*Principia* introduces classes by the "no-classes" device ∗20·01:

    f{ẑ(ψz)} . =: (∃φ): φ!x .≡ₓ. ψx : f{φ!ẑ}        Df

i.e. a statement *about a class* `ẑ(ψz)` is, by definition, an extensional
statement about its defining function `ψ`.  The whole point of ∗20 (its central
results ∗20·15, ∗20·31, ∗20·43) is that this device behaves exactly like an
*extensional* notion of class: two classes are identical iff their defining
functions are formally equivalent iff they have the same members.

In a modern type theory that extensionality is already available, so we render
the class abstraction directly:

  * class over individuals of type `α`      ↦ `Set α`
  * class abstraction  `ẑ(ψz)` = `{z | ψ z}` ↦ `setOf ψ`  (`{z | ψ z}`)
  * membership  `x ∈ ẑ(ψz)`                  ↦ `x ∈ setOf ψ`
  * class identity  `ẑ(ψz) = ẑ(χz)`          ↦ `setOf ψ = setOf χ`  (set equality)
  * non-membership  `x ~∈ a`                 ↦ `x ∉ a`               (∗20·06)

Greek class letters `a, b, …` of the book are arbitrary `a b : Set α`.

Metatheoretic items NOT rendered as object-level theorems
---------------------------------------------------------
The propositions whose entire content is the ramified-type / axiom-of-
reducibility bookkeeping of the no-classes device — ∗20·01 (the defining
convention itself), ∗20·02/∗20·03 (definitions of membership and of `Cls`),
∗20·04/∗20·05/∗20·07/∗20·071/∗20·072/∗20·08/∗20·081 (notational definitions and
extensions), and the predicative-function lemmas ∗20·1, ∗20·11, ∗20·111,
∗20·112, ∗20·12, ∗20·151 (which assert that every class arises from a
*predicative* function, i.e. the axiom of reducibility for classes) — are
absorbed into this extensional model and are recorded here as comments rather
than as Lean theorems, exactly as the metatheoretic generalization rules of ∗10
were in `SectionB/OneApparentVariable.lean`.

The genuine mathematical content of the chapter — the fundamental properties of
classes, ∗20·15 through ∗20·43 — is formalized below.
-/

import Mathlib

namespace Principia.Part1.Section3

variable {α : Type*}

/-! ### Definitions (∗20·02–∗20·06) -/

-- ∗20·02  x ∈ ẑ(φz) .≡. φx        (membership in the class determined by `φ`)
-- In the extensional model this is the defining property `Set.mem_setOf`.
theorem ast_20_02 (x : α) (P : α → Prop) : (x ∈ setOf P) ↔ P x := Iff.rfl

-- ∗20·06  x ~∈ a .=. ¬(x ∈ a)     Df
theorem ast_20_06 (x : α) (a : Set α) : (x ∉ a) ↔ ¬ (x ∈ a) := Iff.rfl

/-! ### Fundamental properties of classes (∗20·15–∗20·25) -/

-- ∗20·15  ⊢ :. ψx .≡ₓ. χx : ≡ . ẑ(ψz) = ẑ(χz)
-- "Two functions determine the same class when, and only when, they are
-- formally equivalent."  This is the essential property of classes and the
-- justification of the definition ∗20·01.
theorem ast_20_15 (P Q : α → Prop) :
    (∀ x, P x ↔ Q x) ↔ (setOf P = setOf Q) := by
  rw [Set.ext_iff]; rfl

-- ∗20·16  ⊢ : (∃φ). f{ẑ(ψz)} ≡ f{φ!ẑ}     (reducibility direction)
--   recorded as a comment (axiom-of-reducibility item, see header).
-- ∗20·17  ⊢ : (φ). f{φ!ẑ} ⊃ f{ẑ(ψz)}      (likewise).

-- ∗20·18  ⊢ :. ẑ(φz) = ẑ(ψz) .⊃: f{ẑ(φz)} ≡ f{ẑ(ψz)}
-- "If two classes are identical, any property of either belongs also to the
-- other."  This is the analogue, for classes, of ∗13·12.
theorem ast_20_18 (P Q : α → Prop) (f : Set α → Prop) :
    setOf P = setOf Q → (f (setOf P) ↔ f (setOf Q)) := by
  rintro h; rw [h]

-- ∗20·19  ⊢ :. ẑ(φz) = ẑ(χz) .≡: (f) : f!ẑ(φz) .⊃. f!ẑ(χz)
-- ∗20·191 ⊢ :. ẑ(φz) = ẑ(χz) .≡: (f) : f!ẑ(φz) .≡. f!ẑ(χz)
-- (Leibniz characterization of class identity; the `≡` form.)
theorem ast_20_191 (P Q : α → Prop) :
    (setOf P = setOf Q) ↔ ∀ f : Set α → Prop, f (setOf P) ↔ f (setOf Q) := by
  constructor
  · rintro h f; rw [h]
  · intro h; exact (h (fun s => setOf P = s)).mp rfl

-- ∗20·2  ⊢ . ẑ(φz) = ẑ(φz)        (identity of classes is reflexive)
theorem ast_20_2 (P : α → Prop) : setOf P = setOf P := rfl

-- ∗20·21  ⊢ : ẑ(φz) = ẑ(ψz) .≡. ẑ(ψz) = ẑ(φz)   (symmetric)
theorem ast_20_21 (P Q : α → Prop) :
    (setOf P = setOf Q) ↔ (setOf Q = setOf P) := eq_comm

-- ∗20·22  ⊢ : ẑ(φz) = ẑ(ψz) . ẑ(ψz) = ẑ(χz) .⊃. ẑ(φz) = ẑ(χz)  (transitive)
theorem ast_20_22 (P Q R : α → Prop) :
    setOf P = setOf Q → setOf Q = setOf R → setOf P = setOf R := fun h₁ h₂ => h₁.trans h₂

-- ∗20·23  ⊢ : ẑ(φz) = ẑ(ψz) . ẑ(φz) = ẑ(χz) .⊃. ẑ(ψz) = ẑ(χz)
theorem ast_20_23 (P Q R : α → Prop) :
    setOf P = setOf Q → setOf P = setOf R → setOf Q = setOf R := fun h₁ h₂ => h₁.symm.trans h₂

-- ∗20·24  ⊢ : ẑ(ψz) = ẑ(φz) . ẑ(χz) = ẑ(φz) .⊃. ẑ(ψz) = ẑ(χz)
theorem ast_20_24 (P Q R : α → Prop) :
    setOf Q = setOf P → setOf R = setOf P → setOf Q = setOf R := fun h₁ h₂ => h₁.trans h₂.symm

-- ∗20·25  ⊢ :. a = ẑ(φz) .≡ₐ. a = ẑ(ψz) : ≡ . ẑ(φz) = ẑ(ψz)
theorem ast_20_25 (P Q : α → Prop) :
    (∀ a : Set α, (a = setOf P) ↔ (a = setOf Q)) ↔ (setOf P = setOf Q) := by
  constructor
  · intro h; exact (h (setOf P)).mp rfl
  · rintro h a; rw [h]

/-! ### Membership and extensionality (∗20·3–∗20·43) -/

-- ∗20·3  ⊢ : x ∈ ẑ(ψz) .≡. ψx
-- "x is a member of the class determined by ψ when, and only when, x satisfies ψ."
theorem ast_20_3 (x : α) (P : α → Prop) : (x ∈ setOf P) ↔ P x := Iff.rfl

-- ∗20·31  ⊢ :. ẑ(ψz) = ẑ(χz) .≡: x ∈ ẑ(ψz) .≡ₓ. x ∈ ẑ(χz)
-- "Two classes are identical when, and only when, they have the same members."
theorem ast_20_31 (P Q : α → Prop) :
    (setOf P = setOf Q) ↔ (∀ x, x ∈ setOf P ↔ x ∈ setOf Q) := Set.ext_iff

-- ∗20·32  ⊢ . ẑ(x ∈ ẑ(φz)) = ẑ(φz)
theorem ast_20_32 (P : α → Prop) :
    setOf (fun x => x ∈ setOf P) = setOf P := rfl

-- ∗20·33  ⊢ :. a = ẑ(φz) .≡: x ∈ a .≡ₓ. φx
theorem ast_20_33 (a : Set α) (P : α → Prop) :
    (a = setOf P) ↔ (∀ x, x ∈ a ↔ P x) := Set.ext_iff

-- ∗20·34  ⊢ :. x ∈ a .⊃ₐ. y ∈ a : ≡ . x = y
theorem ast_20_34 (x y : α) :
    (∀ a : Set α, x ∈ a → y ∈ a) ↔ (x = y) := by
  constructor
  · intro h; exact (h {z | z = x} rfl).symm
  · rintro rfl a hx; exact hx

-- ∗20·35  ⊢ :. x = y .≡: x ∈ a .≡ₐ. y ∈ a
theorem ast_20_35 (x y : α) :
    (x = y) ↔ (∀ a : Set α, x ∈ a ↔ y ∈ a) := by
  constructor
  · rintro rfl a; rfl
  · intro h; exact ((h {z | z = x}).mp rfl).symm

-- ∗20·4  ⊢ : a ∈ Cls .≡. (∃φ). a = ẑ(φ!z)
-- In the extensional model `Cls` is the universe `Set α`, and every class is
-- the abstraction of its own membership predicate.
theorem ast_20_4 (a : Set α) : ∃ P : α → Prop, a = setOf P :=
  ⟨fun z => z ∈ a, rfl⟩

-- ∗20·41  ⊢ . ẑ(φz) ∈ Cls    (every abstraction is a class) — trivial in this
--   model since `setOf P : Set α`; recorded as a comment.

-- ∗20·42  ⊢ . ẑ(z ∈ a) = a
theorem ast_20_42 (a : Set α) : setOf (fun z => z ∈ a) = a := rfl

-- ∗20·43  ⊢ :. a = b .≡: x ∈ a .≡ₓ. x ∈ b
-- The same proposition as ∗20·31, written with Greek class letters.
theorem ast_20_43 (a b : Set α) :
    (a = b) ↔ (∀ x, x ∈ a ↔ x ∈ b) := Set.ext_iff

end Principia.Part1.Section3
