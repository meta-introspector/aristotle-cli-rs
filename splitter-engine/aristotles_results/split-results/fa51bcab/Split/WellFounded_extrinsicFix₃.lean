import Split.PSigma_snd
import Split.WellFounded_extrinsicFix
import Split.PSigma_mk
import Split.Nonempty
import Split.PSigma_fst
import Split.PSigma

-- WellFounded.extrinsicFix₃ from environment
-- def WellFounded.extrinsicFix₃ : forall {α : Sort.{u_1}} {β : α -> Sort.{u_2}} {γ : forall (a : α), (β a) -> Sort.{u_3}} {C₃ : forall (a : α) (b : β a), (γ a b) -> Sort.{u_4}} [inst._@.Init.WFExtrinsicFix.3550613034._hygCtx._hyg.31 : forall (a : α) (b : β a) (c : γ a b), Nonempty.{u_4} (C₃ a b c)] (R : (PSigma.{u_1, max (max 1 u_3) u_2} α (fun (a : α) => PSigma.{u_2, u_3} (β a) (fun (b : β a) => γ a b))) -> (PSigma.{u_1, max (max 1 u_3) u_2} α (fun (a : α) => PSigma.{u_2, u_3} (β a) (fun (b : β a) => γ a b))) -> Prop), (forall (a : α) (b : β a) (c : γ a b), (forall (a' : α) (b' : β a') (c' : γ a' b'), (R (PSigma.mk.{u_1, max (max 1 u_2) u_3} α (fun (a : α) => PSigma.{u_2, u_3} (β a) (fun (b : β a) => γ a b)) a' (PSigma.mk.{u_2, u_3} (β a') (fun (b : β a') => γ a' b) b' c')) (PSigma.mk.{u_1, max (max 1 u_2) u_3} α (fun (a : α) => PSigma.{u_2, u_3} (β a) (fun (b : β a) => γ a b)) a (PSigma.mk.{u_2, u_3} (β a) (fun (b : β a) => γ a b) b c))) -> (C₃ a' b' c')) -> (C₃ a b c)) -> (forall (a : α) (b : β a) (c : γ a b), C₃ a b c)
-- (definition body omitted)

-- Stub: this file represents the declaration `WellFounded.extrinsicFix₃`.
-- In a full split, the body would be extracted from the environment.
