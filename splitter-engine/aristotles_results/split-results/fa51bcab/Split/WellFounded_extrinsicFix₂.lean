import Split.PSigma_snd
import Split.WellFounded_extrinsicFix
import Split.PSigma_mk
import Split.Nonempty
import Split.PSigma_fst
import Split.PSigma

-- WellFounded.extrinsicFix₂ from environment
-- def WellFounded.extrinsicFix₂ : forall {α : Sort.{u_1}} {β : α -> Sort.{u_2}} {C₂ : forall (a : α), (β a) -> Sort.{u_3}} [inst._@.Init.WFExtrinsicFix.3009905724._hygCtx._hyg.31 : forall (a : α) (b : β a), Nonempty.{u_3} (C₂ a b)] (R : (PSigma.{u_1, u_2} α (fun (a : α) => β a)) -> (PSigma.{u_1, u_2} α (fun (a : α) => β a)) -> Prop), (forall (a : α) (b : β a), (forall (a' : α) (b' : β a'), (R (PSigma.mk.{u_1, u_2} α (fun (a : α) => β a) a' b') (PSigma.mk.{u_1, u_2} α (fun (a : α) => β a) a b)) -> (C₂ a' b')) -> (C₂ a b)) -> (forall (a : α) (b : β a), C₂ a b)
-- (definition body omitted)

-- Stub: this file represents the declaration `WellFounded.extrinsicFix₂`.
-- In a full split, the body would be extracted from the environment.
