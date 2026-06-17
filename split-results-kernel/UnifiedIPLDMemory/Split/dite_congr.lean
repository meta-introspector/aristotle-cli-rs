import Split.Eq_mpr
import Split.congrArg
import Split.Decidable
import Split.Eq_rec
import Split.dif_pos
import Split.id
import Split.dif_neg
import Split.dite
import Split.Or_casesOn
import Split.Decidable_em
import Split.Eq_mpr_not
import Split.Eq_refl
import Split.Or_inl
import Split.Or
import Split.Eq_symm
import Split.Eq_mpr_prop
import Split.Eq
import Split.Not
import Split.Or_inr

-- dite_congr from environment
-- theorem dite_congr : forall {b : Prop} {c : Prop} {α : Sort.{u_1}} {x._@.Init.SimpLemmas.3800155434._hygCtx._hyg.20 : Decidable b} [inst._@.Init.SimpLemmas.3800155434._hygCtx._hyg.23 : Decidable c] {x : b -> α} {u : c -> α} {y : (Not b) -> α} {v : (Not c) -> α} (h₁ : Eq.{1} Prop b c), (forall (h : c), Eq.{u_1} α (x (Eq.mpr_prop b c h₁ h)) (u h)) -> (forall (h : Not c), Eq.{u_1} α (y (Eq.mpr_not b c h₁ h)) (v h)) -> (Eq.{u_1} α (dite.{u_1} α b x._@.Init.SimpLemmas.3800155434._hygCtx._hyg.20 x y) (dite.{u_1} α c inst._@.Init.SimpLemmas.3800155434._hygCtx._hyg.23 u v))

-- Stub: this file represents the declaration `dite_congr`.
-- In a full split, the body would be extracted from the environment.
