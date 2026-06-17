import Split.SemilatticeSup_mk
import Split.Set_univ
import Split.PartialOrder_toPreorder
import Split.setOf
import Split.Preorder_toLE
import Split.PartialOrder
import Split.InfSet
import Split.Set_instSingletonSet
import Split.SupSet_mk
import Split.Insert_insert
import Split.upperBounds
import Split.Top_mk
import Split.LE_le
import Split.OrderTop_mk
import Split.Lattice_mk
import Split.And
import Split.Set_instInsert
import Split.OrderBot_mk
import Split.IsGLB
import Split.Set_instEmptyCollection
import Split.BoundedOrder_mk
import Split.EmptyCollection_emptyCollection
import Split.Singleton_singleton
import Split.CompleteLattice
import Split.CompleteLattice_mk
import Split.Bot_mk
import Split.InfSet_sInf
import Split.Set

-- completeLatticeOfInf from environment
-- def completeLatticeOfInf : forall (α : Type.{u_8}) [H1 : PartialOrder.{u_8} α] [H2 : InfSet.{u_8} α], (forall (s : Set.{u_8} α), IsGLB.{u_8} α (Preorder.toLE.{u_8} α (PartialOrder.toPreorder.{u_8} α H1)) s (InfSet.sInf.{u_8} α H2 s)) -> (CompleteLattice.{u_8} α)
-- (definition body omitted)

-- Stub: this file represents the declaration `completeLatticeOfInf`.
-- In a full split, the body would be extracted from the environment.
