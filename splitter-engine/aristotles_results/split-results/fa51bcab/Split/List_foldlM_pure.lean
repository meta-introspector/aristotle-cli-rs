import Split.Pure_pure
import Split.List_foldlM
import Split.congrArg
import Split.List_foldlM_cons
import Split.Monad_toApplicative
import Split.LawfulMonad_bind_pure_comp
import Split.LawfulMonad
import Split.List_rec
import Split.List_foldl
import Split.Applicative_toPure
import Split.List_cons
import Split.funext
import Split.List
import Split.True
import Split.eq_self
import Split.of_eq_true
import Split.Applicative_toFunctor
import Split.Monad_toBind
import Split.Bind_bind
import Split.congrFun'
import Split.LawfulMonad_toLawfulApplicative
import Split.LawfulApplicative_map_pure
import Split.Monad
import Split.Eq
import Split.Functor_map
import Split.Eq_trans

-- List.foldlM_pure from environment
-- theorem List.foldlM_pure : forall {m : Type.{u_1} -> Type.{u_2}} {β : Type.{u_1}} {α : Type.{u_3}} [inst._@.Init.Data.List.Lemmas.1665132910._hygCtx._hyg.23 : Monad.{u_1, u_2} m] [inst._@.Init.Data.List.Lemmas.1665132910._hygCtx._hyg.26 : LawfulMonad.{u_1, u_2} m inst._@.Init.Data.List.Lemmas.1665132910._hygCtx._hyg.23] {f : β -> α -> β} {b : β} {l : List.{u_3} α}, Eq.{succ u_2} (m β) (List.foldlM.{u_1, u_2, u_3} m inst._@.Init.Data.List.Lemmas.1665132910._hygCtx._hyg.23 β α (fun (x1._@.Init.Data.List.Lemmas.1665132910._hygCtx._hyg.44 : β) (x2._@.Init.Data.List.Lemmas.1665132910._hygCtx._hyg.44 : α) => Pure.pure.{u_1, u_2} m (Applicative.toPure.{u_1, u_2} m (Monad.toApplicative.{u_1, u_2} m inst._@.Init.Data.List.Lemmas.1665132910._hygCtx._hyg.23)) β (f x1._@.Init.Data.List.Lemmas.1665132910._hygCtx._hyg.44 x2._@.Init.Data.List.Lemmas.1665132910._hygCtx._hyg.44)) b l) (Pure.pure.{u_1, u_2} m (Applicative.toPure.{u_1, u_2} m (Monad.toApplicative.{u_1, u_2} m inst._@.Init.Data.List.Lemmas.1665132910._hygCtx._hyg.23)) β (List.foldl.{u_1, u_3} β α f b l))

-- Stub: this file represents the declaration `List.foldlM_pure`.
-- In a full split, the body would be extracted from the environment.
