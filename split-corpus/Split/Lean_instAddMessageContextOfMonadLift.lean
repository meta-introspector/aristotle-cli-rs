import Mathlib

set_option pp.all true
-- spec: Lean.instAddMessageContextOfMonadLift : forall (m : Type -> Type) (n : Type -> Type) [inst._@.Lean.Message.2658944991._hygCtx._hyg.4 : MonadLift.{0, 0, 0} m n] [inst._@.Lean.Message.2658944991._hygCtx._hyg.8 : Lean.AddMessageContext m], Lean.AddMessageContext n
def Lean.instAddMessageContextOfMonadLift : forall (m : Type -> Type) (n : Type -> Type) [inst._@.Lean.Message.2658944991._hygCtx._hyg.4 : MonadLift.{0, 0, 0} m n] [inst._@.Lean.Message.2658944991._hygCtx._hyg.8 : Lean.AddMessageContext m], Lean.AddMessageContext n :=
  fun (m : Type -> Type) (n : Type -> Type) [inst._@.Lean.Message.2658944991._hygCtx._hyg.4 : MonadLift.{0, 0, 0} m n] [inst._@.Lean.Message.2658944991._hygCtx._hyg.8 : Lean.AddMessageContext m] => Lean.AddMessageContext.mk n (fun (msg : Lean.MessageData) => liftM.{0, 0, 0} m n (instMonadLiftTOfMonadLift.{0, 0, 0, 0} m m n inst._@.Lean.Message.2658944991._hygCtx._hyg.4 (instMonadLiftT.{0, 0} m)) Lean.MessageData (Lean.AddMessageContext.addMessageContext m inst._@.Lean.Message.2658944991._hygCtx._hyg.8 msg))
