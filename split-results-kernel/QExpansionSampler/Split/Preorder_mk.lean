import Split.LE_le
import Split.autoParam
import Split.LE
import Split.And
import Split.Iff
import Split.LT_lt
import Split.Not
import Split.Preorder
import Split.LT

-- Preorder.mk from environment
-- constructor Preorder.mk : forall {α : Type.{u_2}} [toLE : LE.{u_2} α] [toLT : LT.{u_2} α], (forall (a : α), LE.le.{u_2} α toLE a a) -> (forall (a : α) (b : α) (c : α), (LE.le.{u_2} α toLE a b) -> (LE.le.{u_2} α toLE b c) -> (LE.le.{u_2} α toLE a c)) -> (autoParam.{0} (forall (a : α) (b : α), Iff (LT.lt.{u_2} α toLT a b) (And (LE.le.{u_2} α toLE a b) (Not (LE.le.{u_2} α toLE b a)))) Preorder.lt_iff_le_not_ge._autoParam) -> (Preorder.{u_2} α)

-- Stub: this file represents the declaration `Preorder.mk`.
-- In a full split, the body would be extracted from the environment.
