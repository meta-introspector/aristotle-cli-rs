import Split.Nat_le_refl
import Split.List_foldlM
import Split.Array_foldlM_loop
import Split.LE_le
import Split.instLENat
import Split.Array_toList
import Split.Array
import Split.instHAdd
import Split.List_drop
import Split.HAdd_hAdd
import Split.Nat
import Split.PSigma_mk
import Split.instAddNat
import Split.Monad
import Split.PSigma
import Split.Eq
import Split.Array_size

-- Array.foldlM_toList.aux from environment
-- theorem Array.foldlM_toList.aux : forall {m : Type.{u_1} -> Type.{u_2}} {β : Type.{u_1}} {α : Type.{u_3}} [inst._@.Init.Data.Array.Bootstrap.3715277255._hygCtx._hyg.17 : Monad.{u_1, u_2} m] {f : β -> α -> (m β)} {xs : Array.{u_3} α} {i : Nat} {j : Nat}, (LE.le.{0} Nat instLENat (Array.size.{u_3} α xs) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) i j)) -> (forall {b : β}, Eq.{succ u_2} (m β) (Array.foldlM.loop.{u_3, u_1, u_2} α β m inst._@.Init.Data.Array.Bootstrap.3715277255._hygCtx._hyg.17 f xs (Array.size.{u_3} α xs) (Nat.le_refl (Array.size.{u_3} α xs)) i j b) (List.foldlM.{u_1, u_2, u_3} m inst._@.Init.Data.Array.Bootstrap.3715277255._hygCtx._hyg.17 β α f b (List.drop.{u_3} α j (Array.toList.{u_3} α xs))))

-- Stub: this file represents the declaration `Array.foldlM_toList.aux`.
-- In a full split, the body would be extracted from the environment.
