import Split.zero_le
import Split.PartialOrder_toPreorder
import Split.Preorder_toLE
import Split.AddZeroClass_toAddZero
import Split.PartialOrder
import Split.LE_le
import Split.CanonicallyOrderedAdd
import Split.LE_le_ge_iff_eq'
import Split.AddZero_toZero
import Split.AddZeroClass
import Split.Iff
import Split.AddZero_toAdd
import Split.Zero_toOfNat0
import Split.OfNat_ofNat
import Split.Eq

-- nonpos_iff_eq_zero from environment
-- theorem nonpos_iff_eq_zero : forall {α : Type.{u}} [inst._@.Mathlib.Algebra.Order.Monoid.Canonical.Defs.207308057._hygCtx._hyg.3 : AddZeroClass.{u} α] [inst._@.Mathlib.Algebra.Order.Monoid.Canonical.Defs.207308057._hygCtx._hyg.6 : PartialOrder.{u} α] [inst._@.Mathlib.Algebra.Order.Monoid.Canonical.Defs.207308057._hygCtx._hyg.9 : CanonicallyOrderedAdd.{u} α (AddZero.toAdd.{u} α (AddZeroClass.toAddZero.{u} α inst._@.Mathlib.Algebra.Order.Monoid.Canonical.Defs.207308057._hygCtx._hyg.3)) (Preorder.toLE.{u} α (PartialOrder.toPreorder.{u} α inst._@.Mathlib.Algebra.Order.Monoid.Canonical.Defs.207308057._hygCtx._hyg.6))] {a : α}, Iff (LE.le.{u} α (Preorder.toLE.{u} α (PartialOrder.toPreorder.{u} α inst._@.Mathlib.Algebra.Order.Monoid.Canonical.Defs.207308057._hygCtx._hyg.6)) a (OfNat.ofNat.{u} α 0 (Zero.toOfNat0.{u} α (AddZero.toZero.{u} α (AddZeroClass.toAddZero.{u} α inst._@.Mathlib.Algebra.Order.Monoid.Canonical.Defs.207308057._hygCtx._hyg.3))))) (Eq.{succ u} α a (OfNat.ofNat.{u} α 0 (Zero.toOfNat0.{u} α (AddZero.toZero.{u} α (AddZeroClass.toAddZero.{u} α inst._@.Mathlib.Algebra.Order.Monoid.Canonical.Defs.207308057._hygCtx._hyg.3)))))

-- Stub: this file represents the declaration `nonpos_iff_eq_zero`.
-- In a full split, the body would be extracted from the environment.
