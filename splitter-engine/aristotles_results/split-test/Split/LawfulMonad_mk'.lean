import Split.Applicative_toSeqLeft
import Split.Pure_pure
import Split.LawfulFunctor_mk
import Split.Eq_mpr
import Split.LawfulApplicative_mk
import Split.congrArg
import Split.Monad_toApplicative
import Split.Function_comp
import Split.id
import Split.LawfulMonad
import Split.Seq_seq
import Split.Applicative_toPure
import Split.autoParam
import Split.funext
import Split.Unit
import Split.SeqLeft_seqLeft
import Split.congr
import Split.True
import Split.Functor_mapConst
import Split.eq_self
import Split.Function_const
import Split.of_eq_true
import Split.Applicative_toFunctor
import Split.Monad_toBind
import Split.Bind_bind
import Split.congrFun'
import Split.implies_true
import Split.Applicative_toSeq
import Split.Applicative_toSeqRight
import Split.Eq_symm
import Split.Monad
import Split.SeqRight_seqRight
import Split.Eq
import Split.Functor_map
import Split.Eq_trans
import Split.LawfulMonad_mk
import Split.forall_congr

-- LawfulMonad.mk' from environment
-- theorem LawfulMonad.mk' : forall (m : Type.{u} -> Type.{v}) [inst._@.Init.Control.Lawful.Basic.156091895._hygCtx._hyg.5 : Monad.{u, v} m], (forall {α : Type.{u}} (x : m α), Eq.{succ v} (m α) (Functor.map.{u, v} m (Applicative.toFunctor.{u, v} m (Monad.toApplicative.{u, v} m inst._@.Init.Control.Lawful.Basic.156091895._hygCtx._hyg.5)) α α (id.{succ u} α) x) x) -> (forall {α : Type.{u}} {β : Type.{u}} (x : α) (f : α -> (m β)), Eq.{succ v} (m β) (Bind.bind.{u, v} m (Monad.toBind.{u, v} m inst._@.Init.Control.Lawful.Basic.156091895._hygCtx._hyg.5) α β (Pure.pure.{u, v} m (Applicative.toPure.{u, v} m (Monad.toApplicative.{u, v} m inst._@.Init.Control.Lawful.Basic.156091895._hygCtx._hyg.5)) α x) f) (f x)) -> (forall {α : Type.{u}} {β : Type.{u}} {γ : Type.{u}} (x : m α) (f : α -> (m β)) (g : β -> (m γ)), Eq.{succ v} (m γ) (Bind.bind.{u, v} m (Monad.toBind.{u, v} m inst._@.Init.Control.Lawful.Basic.156091895._hygCtx._hyg.5) β γ (Bind.bind.{u, v} m (Monad.toBind.{u, v} m inst._@.Init.Control.Lawful.Basic.156091895._hygCtx._hyg.5) α β x f) g) (Bind.bind.{u, v} m (Monad.toBind.{u, v} m inst._@.Init.Control.Lawful.Basic.156091895._hygCtx._hyg.5) α γ x (fun (x : α) => Bind.bind.{u, v} m (Monad.toBind.{u, v} m inst._@.Init.Control.Lawful.Basic.156091895._hygCtx._hyg.5) β γ (f x) g))) -> (autoParam.{0} (forall {α : Type.{u}} {β : Type.{u}} (x : α) (y : m β), Eq.{succ v} (m α) (Functor.mapConst.{u, v} m (Applicative.toFunctor.{u, v} m (Monad.toApplicative.{u, v} m inst._@.Init.Control.Lawful.Basic.156091895._hygCtx._hyg.5)) α β x y) (Functor.map.{u, v} m (Applicative.toFunctor.{u, v} m (Monad.toApplicative.{u, v} m inst._@.Init.Control.Lawful.Basic.156091895._hygCtx._hyg.5)) β α (Function.const.{succ u, succ u} α β x) y)) LawfulMonad.mk'._auto_1) -> (autoParam.{0} (forall {α : Type.{u}} {β : Type.{u}} (x : m α) (y : m β), Eq.{succ v} (m α) (SeqLeft.seqLeft.{u, v} m (Applicative.toSeqLeft.{u, v} m (Monad.toApplicative.{u, v} m inst._@.Init.Control.Lawful.Basic.156091895._hygCtx._hyg.5)) α β x (fun (x._@.Init.Control.Lawful.Basic.156091895._hygCtx._hyg.120 : Unit) => y)) (Bind.bind.{u, v} m (Monad.toBind.{u, v} m inst._@.Init.Control.Lawful.Basic.156091895._hygCtx._hyg.5) α α x (fun (a : α) => Bind.bind.{u, v} m (Monad.toBind.{u, v} m inst._@.Init.Control.Lawful.Basic.156091895._hygCtx._hyg.5) β α y (fun (x._@.Init.Control.Lawful.Basic.156091895._hygCtx._hyg.135 : β) => Pure.pure.{u, v} m (Applicative.toPure.{u, v} m (Monad.toApplicative.{u, v} m inst._@.Init.Control.Lawful.Basic.156091895._hygCtx._hyg.5)) α a)))) LawfulMonad.mk'._auto_3) -> (autoParam.{0} (forall {α : Type.{u}} {β : Type.{u}} (x : m α) (y : m β), Eq.{succ v} (m β) (SeqRight.seqRight.{u, v} m (Applicative.toSeqRight.{u, v} m (Monad.toApplicative.{u, v} m inst._@.Init.Control.Lawful.Basic.156091895._hygCtx._hyg.5)) α β x (fun (x._@.Init.Control.Lawful.Basic.156091895._hygCtx._hyg.160 : Unit) => y)) (Bind.bind.{u, v} m (Monad.toBind.{u, v} m inst._@.Init.Control.Lawful.Basic.156091895._hygCtx._hyg.5) α β x (fun (x._@.Init.Control.Lawful.Basic.156091895._hygCtx._hyg.168 : α) => y))) LawfulMonad.mk'._auto_5) -> (autoParam.{0} (forall {α : Type.{u}} {β : Type.{u}} (f : α -> β) (x : m α), Eq.{succ v} (m β) (Bind.bind.{u, v} m (Monad.toBind.{u, v} m inst._@.Init.Control.Lawful.Basic.156091895._hygCtx._hyg.5) α β x (fun (y : α) => Pure.pure.{u, v} m (Applicative.toPure.{u, v} m (Monad.toApplicative.{u, v} m inst._@.Init.Control.Lawful.Basic.156091895._hygCtx._hyg.5)) β (f y))) (Functor.map.{u, v} m (Applicative.toFunctor.{u, v} m (Monad.toApplicative.{u, v} m inst._@.Init.Control.Lawful.Basic.156091895._hygCtx._hyg.5)) α β f x)) LawfulMonad.mk'._auto_7) -> (autoParam.{0} (forall {α : Type.{u}} {β : Type.{u}} (f : m (α -> β)) (x : m α), Eq.{succ v} (m β) (Bind.bind.{u, v} m (Monad.toBind.{u, v} m inst._@.Init.Control.Lawful.Basic.156091895._hygCtx._hyg.5) (α -> β) β f (fun (x._@.Init.Control.Lawful.Basic.156091895._hygCtx._hyg.226 : α -> β) => Functor.map.{u, v} m (Applicative.toFunctor.{u, v} m (Monad.toApplicative.{u, v} m inst._@.Init.Control.Lawful.Basic.156091895._hygCtx._hyg.5)) α β x._@.Init.Control.Lawful.Basic.156091895._hygCtx._hyg.226 x)) (Seq.seq.{u, v} m (Applicative.toSeq.{u, v} m (Monad.toApplicative.{u, v} m inst._@.Init.Control.Lawful.Basic.156091895._hygCtx._hyg.5)) α β f (fun (x._@.Init.Control.Lawful.Basic.156091895._hygCtx._hyg.242 : Unit) => x))) LawfulMonad.mk'._auto_9) -> (LawfulMonad.{u, v} m inst._@.Init.Control.Lawful.Basic.156091895._hygCtx._hyg.5)

-- Stub: this file represents the declaration `LawfulMonad.mk'`.
-- In a full split, the body would be extracted from the environment.
