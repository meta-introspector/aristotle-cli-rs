import Split.dite_cond_eq_true
import Split.List_foldlM
import Split.congrArg
import Split.HSub_hSub
import Split.Array_foldlM_loop
import Split.instSubNat
import Split.instOfNatNat
import Split.LE_le
import Split.instLENat
import Split.Array_toList
import Split.dite
import Split.Array
import Split.Array_foldlM
import Split.instHSub
import Split.List_drop
import Split.Nat
import Split.True
import Split.eq_self
import Split.of_eq_true
import Split.Array_foldlM_toList_aux
import Split.OfNat_ofNat
import Split.Monad
import Split.Eq
import Split.Array_size
import Split.Not
import Split.Nat_decLe
import Split.Eq_trans

-- Array.foldlM_toList from environment
-- theorem Array.foldlM_toList : forall {m : Type.{u_1} -> Type.{u_2}} {β : Type.{u_1}} {α : Type.{u_3}} [inst._@.Init.Data.Array.Bootstrap.432132530._hygCtx._hyg.17 : Monad.{u_1, u_2} m] {f : β -> α -> (m β)} {init : β} {xs : Array.{u_3} α}, Eq.{succ u_2} (m β) (List.foldlM.{u_1, u_2, u_3} m inst._@.Init.Data.Array.Bootstrap.432132530._hygCtx._hyg.17 β α f init (Array.toList.{u_3} α xs)) (Array.foldlM.{u_3, u_1, u_2} α β m inst._@.Init.Data.Array.Bootstrap.432132530._hygCtx._hyg.17 f init xs (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) (Array.size.{u_3} α xs))

-- Stub: this file represents the declaration `Array.foldlM_toList`.
-- In a full split, the body would be extracted from the environment.
