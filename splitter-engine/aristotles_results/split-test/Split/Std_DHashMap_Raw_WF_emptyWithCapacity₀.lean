import Split.Std_DHashMap_Raw_WF
import Split.Std_DHashMap_Raw
import Split.instOfNatNat
import Split.Std_DHashMap_Internal_Raw₀_emptyWithCapacity
import Split.Nat
import Split.Std_DHashMap_Raw_buckets
import Split.LT_lt
import Split.Std_DHashMap_Internal_AssocList
import Split.Hashable
import Split.instLTNat
import Split.OfNat_ofNat
import Split.Subtype_val
import Split.BEq
import Split.Array_size

-- Std.DHashMap.Raw.WF.emptyWithCapacity₀ from environment
-- constructor Std.DHashMap.Raw.WF.emptyWithCapacity₀ : forall {α : Type.{u}} {β : α -> Type.{v}} [inst._@.Std.Data.DHashMap.Raw.1514113539._hygCtx._hyg.77 : BEq.{u} α] [inst._@.Std.Data.DHashMap.Raw.1514113539._hygCtx._hyg.80 : Hashable.{succ u} α] {c : Nat}, Std.DHashMap.Raw.WF.{u, v} α β inst._@.Std.Data.DHashMap.Raw.1514113539._hygCtx._hyg.77 inst._@.Std.Data.DHashMap.Raw.1514113539._hygCtx._hyg.80 (Subtype.val.{max (succ u) (succ v)} (Std.DHashMap.Raw.{u, v} α β) (fun (m : Std.DHashMap.Raw.{u, v} α β) => LT.lt.{0} Nat instLTNat (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) (Array.size.{max u v} (Std.DHashMap.Internal.AssocList.{v, u} α β) (Std.DHashMap.Raw.buckets.{u, v} α β m))) (Std.DHashMap.Internal.Raw₀.emptyWithCapacity.{u, v} α β c))

-- Stub: this file represents the declaration `Std.DHashMap.Raw.WF.emptyWithCapacity₀`.
-- In a full split, the body would be extracted from the environment.
