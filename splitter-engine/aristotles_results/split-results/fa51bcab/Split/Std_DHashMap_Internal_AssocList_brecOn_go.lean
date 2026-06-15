import Split.Std_DHashMap_Internal_AssocList_below
import Split.PProd_mk
import Split.Std_DHashMap_Internal_AssocList_nil
import Split.Std_DHashMap_Internal_AssocList_rec
import Split.PProd
import Split.PUnit
import Split.Std_DHashMap_Internal_AssocList
import Split.PUnit_unit
import Split.Std_DHashMap_Internal_AssocList_cons

-- Std.DHashMap.Internal.AssocList.brecOn.go from environment
-- def Std.DHashMap.Internal.AssocList.brecOn.go : forall {α : Type.{u}} {β : α -> Type.{v}} {motive : (Std.DHashMap.Internal.AssocList.{v, u} α β) -> Sort.{u_1}} (t : Std.DHashMap.Internal.AssocList.{v, u} α β), (forall (t : Std.DHashMap.Internal.AssocList.{v, u} α β), (Std.DHashMap.Internal.AssocList.below.{u_1, v, u} α β motive t) -> (motive t)) -> (PProd.{u_1, max (max (succ u) (succ v)) u_1} (motive t) (Std.DHashMap.Internal.AssocList.below.{u_1, v, u} α β motive t))
-- (definition body omitted)

-- Stub: this file represents the declaration `Std.DHashMap.Internal.AssocList.brecOn.go`.
-- In a full split, the body would be extracted from the environment.
