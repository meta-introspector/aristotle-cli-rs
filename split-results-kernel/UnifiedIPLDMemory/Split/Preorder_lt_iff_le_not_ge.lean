import Split.Preorder_toLT
import Split.Preorder_toLE
import Split.LE_le
import Split.And
import Split.Iff
import Split.LT_lt
import Split.Not
import Split.Preorder

-- Preorder.lt_iff_le_not_ge from environment
-- theorem Preorder.lt_iff_le_not_ge : forall {α : Type.{u_2}} [self : Preorder.{u_2} α] (a : α) (b : α), Iff (LT.lt.{u_2} α (Preorder.toLT.{u_2} α self) a b) (And (LE.le.{u_2} α (Preorder.toLE.{u_2} α self) a b) (Not (LE.le.{u_2} α (Preorder.toLE.{u_2} α self) b a)))

-- Stub: this file represents the declaration `Preorder.lt_iff_le_not_ge`.
-- In a full split, the body would be extracted from the environment.
