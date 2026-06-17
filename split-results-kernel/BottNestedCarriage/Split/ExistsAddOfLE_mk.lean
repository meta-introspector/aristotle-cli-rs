import Split.Exists
import Split.LE_le
import Split.LE
import Split.ExistsAddOfLE
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Eq
import Split.Add

-- ExistsAddOfLE.mk from environment
-- constructor ExistsAddOfLE.mk : forall {α : Type.{u}} [inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.ExistsOfLE.3592962957._hygCtx._hyg.5 : Add.{u} α] [inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.ExistsOfLE.3592962957._hygCtx._hyg.8 : LE.{u} α], (forall {a : α} {b : α}, (LE.le.{u} α inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.ExistsOfLE.3592962957._hygCtx._hyg.8 a b) -> (Exists.{succ u} α (fun (c : α) => Eq.{succ u} α b (HAdd.hAdd.{u, u, u} α α α (instHAdd.{u} α inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.ExistsOfLE.3592962957._hygCtx._hyg.5) a c)))) -> (ExistsAddOfLE.{u} α inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.ExistsOfLE.3592962957._hygCtx._hyg.5 inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.ExistsOfLE.3592962957._hygCtx._hyg.8)

-- Stub: this file represents the declaration `ExistsAddOfLE.mk`.
-- In a full split, the body would be extracted from the environment.
