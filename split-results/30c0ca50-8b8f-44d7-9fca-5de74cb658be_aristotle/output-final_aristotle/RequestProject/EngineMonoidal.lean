import Mathlib
import RequestProject.ScaleTower

/-!
# A monoidal structure for the cart: composing & synchronizing parallel engines

This module answers the *third* proposed direction: equip the functorial advance
step `cartFunctor : ℕ ⥤ ℕ` (the successor endofunctor of
`RequestProject/ScaleTower.lean`) with a **monoidal structure** that models the
**composition and synchronization of multiple parallel extension engines**.

The natural home is the monoidal category of endofunctors
`endofunctorMonoidalCategory` from Mathlib, whose tensor product is *functor
composition* and whose unit is the *identity functor*.  Read in the cart–carrot
metaphor:

* The **monoidal unit** `𝟙_ (ℕ ⥤ ℕ)` is the *idle* engine: advancing by `0`
  (`cart_unit_obj`).
* The **tensor product** `cartFunctor ⊗ cartFunctor` *synchronizes* two carts run
  in parallel: it advances by `2` (`cart_tensor_obj`).
* The **tensor power** `cartPow n` synchronizes `n` parallel carts and advances by
  exactly `n` (`cartPow_obj`).
* This synchronization is **additive**: composing an `a`-cart with a `b`-cart
  agrees on objects with the single `(a+b)`-cart (`cartPow_add_obj`) — the formal
  sense in which parallel extension engines *add up*.

Everything compiles and every `theorem` is fully proved (no `sorry`).
-/

open CategoryTheory CategoryTheory.MonoidalCategory

namespace Aristotle.Extension

/- The category of endofunctors `ℕ ⥤ ℕ` of the index category is **monoidal**,
with tensor product given by functor composition and unit the identity functor.
This is the arena in which the cart is given its monoidal life. -/
attribute [local instance] endofunctorMonoidalCategory

/-! ## The unit and binary tensor of the cart -/

/-- **The idle engine.**  The monoidal unit of `ℕ ⥤ ℕ` is the identity functor:
running no cart advances by `0`. -/
theorem cart_unit_obj (k : ℕ) : (𝟙_ (ℕ ⥤ ℕ)).obj k = k := rfl

/-- **Synchronizing two parallel carts.**  The monoidal product of two cart steps
is their composite: two carts run in parallel advance the index by `2`. -/
theorem cart_tensor_obj (k : ℕ) : (cartFunctor ⊗ cartFunctor).obj k = k + 2 := by
  simp [endofunctorMonoidalCategory_tensorObj_obj, cartFunctor_obj]

/-! ## Tensor powers: synchronizing `n` parallel carts -/

/-- The **`n`-fold parallel cart**: the `n`-th tensor power of `cartFunctor` in the
monoidal endofunctor category, i.e. `n` cart steps synchronized in parallel. -/
noncomputable def cartPow : ℕ → (ℕ ⥤ ℕ)
  | 0 => 𝟙_ (ℕ ⥤ ℕ)
  | (n + 1) => cartFunctor ⊗ cartPow n

@[simp] theorem cartPow_zero : cartPow 0 = 𝟙_ (ℕ ⥤ ℕ) := rfl

@[simp] theorem cartPow_succ (n : ℕ) : cartPow (n + 1) = cartFunctor ⊗ cartPow n := rfl

/-- **The `n`-fold parallel cart advances by `n`.**  Synchronizing `n` cart steps
through the monoidal product advances the global index by exactly `n`: the monoidal
structure faithfully records parallel composition of extension-engine advances. -/
theorem cartPow_obj (n k : ℕ) : (cartPow n).obj k = k + n := by
  induction n generalizing k with
  | zero => rfl
  | succ m ih =>
    show (cartFunctor ⊗ cartPow m).obj k = k + (m + 1)
    rw [endofunctorMonoidalCategory_tensorObj_obj, cartFunctor_obj, ih]
    omega

/-- In particular the single cart is the first tensor power. -/
theorem cartPow_one_obj (k : ℕ) : (cartPow 1).obj k = (cartFunctor).obj k := by
  rw [cartPow_obj, cartFunctor_obj]

/-- **Additivity of synchronization.**  Composing an `a`-fold parallel cart with a
`b`-fold one advances by `a + b`, agreeing on objects with the single
`(a + b)`-fold cart.  Parallel extension engines therefore *add up*: tensoring
them in the monoidal endofunctor category is, at the level of advance, ordinary
addition of step counts. -/
theorem cartPow_add_obj (a b k : ℕ) :
    (cartPow (a + b)).obj k = (cartPow a ⊗ cartPow b).obj k := by
  rw [endofunctorMonoidalCategory_tensorObj_obj, cartPow_obj, cartPow_obj, cartPow_obj]
  omega

/-- **The synchronized cart never stalls.**  For any positive number of parallel
carts, the synchronized advance strictly increases the index — the monoidal
product preserves the inexhaustibility of the cart–carrot motion. -/
theorem cartPow_strict (n k : ℕ) (hn : 0 < n) : k < (cartPow n).obj k := by
  rw [cartPow_obj]; omega

end Aristotle.Extension
