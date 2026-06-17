import Split.Pure_pure
import Split.List_foldlM
import Split.congrArg
import Split.Monad_toApplicative
import Split.List_foldl
import Split.Id_run
import Split.Id
import Split.Applicative_toPure
import Split.List
import Split.True
import Split.eq_self
import Split.of_eq_true
import Split.Id_instMonad
import Split.Eq
import Split.Eq_trans
import Split.Id_instLawfulMonad
import Split.List_foldlM_pure

-- List.foldl_eq_foldlM from environment
-- theorem List.foldl_eq_foldlM : forall {β : Type.{u_1}} {α : Type.{u_2}} {f : β -> α -> β} {b : β} {l : List.{u_2} α}, Eq.{succ u_1} β (List.foldl.{u_1, u_2} β α f b l) (Id.run.{u_1} β (List.foldlM.{u_1, u_1, u_2} Id.{u_1} Id.instMonad.{u_1} β α (fun (x1._@.Init.Data.List.Lemmas.2279346586._hygCtx._hyg.29 : β) (x2._@.Init.Data.List.Lemmas.2279346586._hygCtx._hyg.29 : α) => Pure.pure.{u_1, u_1} Id.{u_1} (Applicative.toPure.{u_1, u_1} Id.{u_1} (Monad.toApplicative.{u_1, u_1} Id.{u_1} Id.instMonad.{u_1})) β (f x1._@.Init.Data.List.Lemmas.2279346586._hygCtx._hyg.29 x2._@.Init.Data.List.Lemmas.2279346586._hygCtx._hyg.29)) b l))

-- Stub: this file represents the declaration `List.foldl_eq_foldlM`.
-- In a full split, the body would be extracted from the environment.
