import Split.Prod_mk
import Split.instOfNatNat
import Split.List_cons
import Split.List
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Nat
import Split.instAddNat
import Split.Prod
import Split.OfNat_ofNat
import Split.List_zipIdx
import Split.Eq
import Split.rfl

-- List.zipIdx_cons from environment
-- theorem List.zipIdx_cons : forall {α._@.Init.Data.List.Basic.3205159353._hygCtx._hyg.65 : Type.{u_1}} {a : α._@.Init.Data.List.Basic.3205159353._hygCtx._hyg.65} {as : List.{u_1} α._@.Init.Data.List.Basic.3205159353._hygCtx._hyg.65} {i : Nat}, Eq.{succ u_1} (List.{u_1} (Prod.{u_1, 0} α._@.Init.Data.List.Basic.3205159353._hygCtx._hyg.65 Nat)) (List.zipIdx.{u_1} α._@.Init.Data.List.Basic.3205159353._hygCtx._hyg.65 (List.cons.{u_1} α._@.Init.Data.List.Basic.3205159353._hygCtx._hyg.65 a as) i) (List.cons.{u_1} (Prod.{u_1, 0} α._@.Init.Data.List.Basic.3205159353._hygCtx._hyg.65 Nat) (Prod.mk.{u_1, 0} α._@.Init.Data.List.Basic.3205159353._hygCtx._hyg.65 Nat a i) (List.zipIdx.{u_1} α._@.Init.Data.List.Basic.3205159353._hygCtx._hyg.65 as (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) i (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)))))

-- Stub: this file represents the declaration `List.zipIdx_cons`.
-- In a full split, the body would be extracted from the environment.
