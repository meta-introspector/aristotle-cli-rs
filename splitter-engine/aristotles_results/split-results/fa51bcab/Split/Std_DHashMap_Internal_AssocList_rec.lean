import Split.Std_DHashMap_Internal_AssocList_nil
import Split.Std_DHashMap_Internal_AssocList
import Split.Std_DHashMap_Internal_AssocList_cons

-- Std.DHashMap.Internal.AssocList.rec from environment
-- recursor Std.DHashMap.Internal.AssocList.rec : forall {α : Type.{u}} {β : α -> Type.{v}} {motive : (Std.DHashMap.Internal.AssocList.{v, u} α β) -> Sort.{u_1}}, (motive (Std.DHashMap.Internal.AssocList.nil.{v, u} α β)) -> (forall (key : α) (value : β key) (tail : Std.DHashMap.Internal.AssocList.{v, u} α β), (motive tail) -> (motive (Std.DHashMap.Internal.AssocList.cons.{v, u} α β key value tail))) -> (forall (t : Std.DHashMap.Internal.AssocList.{v, u} α β), motive t)

-- Stub: this file represents the declaration `Std.DHashMap.Internal.AssocList.rec`.
-- In a full split, the body would be extracted from the environment.
