import Split.Std_DTreeMap_Internal_Impl_Balanced
import Split.Std_DTreeMap_Internal_Impl_size
import Split.Std_DTreeMap_Internal_Impl_SizedBalancedTree
import Split.instOfNatNat
import Split.LE_le
import Split.instLENat
import Split.instHAdd
import Split.Std_DTreeMap_Internal_Impl_SizedBalancedTree_casesOn
import Split.HAdd_hAdd
import Split.Nat
import Split.instAddNat
import Split.Std_DTreeMap_Internal_Impl_SizedBalancedTree_mk
import Split.OfNat_ofNat
import Split.Std_DTreeMap_Internal_Impl

-- Std.DTreeMap.Internal.Impl.insert.match_1 from environment
-- def Std.DTreeMap.Internal.Impl.insert.match_1 : forall {α : Type.{u_1}} {β : α -> Type.{u_2}} (l' : Std.DTreeMap.Internal.Impl.{u_1, u_2} α β) (motive : (Std.DTreeMap.Internal.Impl.SizedBalancedTree.{u_1, u_2} α β (Std.DTreeMap.Internal.Impl.size.{u_1, u_2} α β l') (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (Std.DTreeMap.Internal.Impl.size.{u_1, u_2} α β l') (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)))) -> Sort.{u_3}) (x._@.Std.Data.DTreeMap.Internal.Operations.2613969841._hygCtx._hyg.107 : Std.DTreeMap.Internal.Impl.SizedBalancedTree.{u_1, u_2} α β (Std.DTreeMap.Internal.Impl.size.{u_1, u_2} α β l') (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (Std.DTreeMap.Internal.Impl.size.{u_1, u_2} α β l') (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)))), (forall (d : Std.DTreeMap.Internal.Impl.{u_1, u_2} α β) (hd : Std.DTreeMap.Internal.Impl.Balanced.{u_1, u_2} α β d) (hd₁ : LE.le.{0} Nat instLENat (Std.DTreeMap.Internal.Impl.size.{u_1, u_2} α β l') (Std.DTreeMap.Internal.Impl.size.{u_1, u_2} α β d)) (hd₂ : LE.le.{0} Nat instLENat (Std.DTreeMap.Internal.Impl.size.{u_1, u_2} α β d) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (Std.DTreeMap.Internal.Impl.size.{u_1, u_2} α β l') (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)))), motive (Std.DTreeMap.Internal.Impl.SizedBalancedTree.mk.{u_1, u_2} α β (Std.DTreeMap.Internal.Impl.size.{u_1, u_2} α β l') (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (Std.DTreeMap.Internal.Impl.size.{u_1, u_2} α β l') (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))) d hd hd₁ hd₂)) -> (motive x._@.Std.Data.DTreeMap.Internal.Operations.2613969841._hygCtx._hyg.107)
-- (definition body omitted)

-- Stub: this file represents the declaration `Std.DTreeMap.Internal.Impl.insert.match_1`.
-- In a full split, the body would be extracted from the environment.
