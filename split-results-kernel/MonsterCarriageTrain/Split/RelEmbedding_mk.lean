import Split.Function_Embedding
import Split.RelEmbedding
import Split.Iff
import Split.Function_instFunLikeEmbedding
import Split.DFunLike_coe

-- RelEmbedding.mk from environment
-- constructor RelEmbedding.mk : forall {α : Type.{u_5}} {β : Type.{u_6}} {r : α -> α -> Prop} {s : β -> β -> Prop} (toEmbedding : Function.Embedding.{succ u_5, succ u_6} α β), (forall {a : α} {b : α}, Iff (s (DFunLike.coe.{max (succ u_5) (succ u_6), succ u_5, succ u_6} (Function.Embedding.{succ u_5, succ u_6} α β) α (fun (x._@.Mathlib.Data.FunLike.Basic.2582841819._hygCtx._hyg.11 : α) => β) (Function.instFunLikeEmbedding.{succ u_5, succ u_6} α β) toEmbedding a) (DFunLike.coe.{max (succ u_5) (succ u_6), succ u_5, succ u_6} (Function.Embedding.{succ u_5, succ u_6} α β) α (fun (x._@.Mathlib.Data.FunLike.Basic.2582841819._hygCtx._hyg.11 : α) => β) (Function.instFunLikeEmbedding.{succ u_5, succ u_6} α β) toEmbedding b)) (r a b)) -> (RelEmbedding.{u_5, u_6} α β r s)

-- Stub: this file represents the declaration `RelEmbedding.mk`.
-- In a full split, the body would be extracted from the environment.
