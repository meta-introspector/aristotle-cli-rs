import Split.List_foldlM
import Split.List_cons
import Split.List
import Split.eq_self
import Split.of_eq_true
import Split.Monad_toBind
import Split.Bind_bind
import Split.Monad
import Split.Eq

-- List.foldlM_cons from environment
-- theorem List.foldlM_cons : forall {m : Type.{u_1} -> Type.{u_2}} {β : Type.{u_1}} {α : Type.{u_3}} [inst._@.Init.Data.List.Control.968966917._hygCtx._hyg.17 : Monad.{u_1, u_2} m] {f : β -> α -> (m β)} {b : β} {a : α} {l : List.{u_3} α}, Eq.{succ u_2} (m β) (List.foldlM.{u_1, u_2, u_3} m inst._@.Init.Data.List.Control.968966917._hygCtx._hyg.17 β α f b (List.cons.{u_3} α a l)) (Bind.bind.{u_1, u_2} m (Monad.toBind.{u_1, u_2} m inst._@.Init.Data.List.Control.968966917._hygCtx._hyg.17) β β (f b a) (fun (init : β) => List.foldlM.{u_1, u_2, u_3} m inst._@.Init.Data.List.Control.968966917._hygCtx._hyg.17 β α f init l))

-- Stub: this file represents the declaration `List.foldlM_cons`.
-- In a full split, the body would be extracted from the environment.
