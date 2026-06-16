import Split.Eq_mpr
import Split.congrArg
import Split.Decidable
import Split.id
import Split.if_pos
import Split.Or_casesOn
import Split.Decidable_em
import Split.Eq_ndrec
import Split.Eq_refl
import Split.Or_inl
import Split.Or
import Split.Eq_symm
import Split.Eq
import Split.if_neg
import Split.Not
import Split.Or_inr
import Split.ite

-- ite_congr from environment
-- theorem ite_congr : forall {α : Sort.{u_1}} {b : Prop} {c : Prop} {x : α} {y : α} {u : α} {v : α} {s : Decidable b} [inst._@.Init.SimpLemmas.1298252226._hygCtx._hyg.24 : Decidable c], (Eq.{1} Prop b c) -> (c -> (Eq.{u_1} α x u)) -> ((Not c) -> (Eq.{u_1} α y v)) -> (Eq.{u_1} α (ite.{u_1} α b s x y) (ite.{u_1} α c inst._@.Init.SimpLemmas.1298252226._hygCtx._hyg.24 u v))

-- Stub: this file represents the declaration `ite_congr`.
-- In a full split, the body would be extracted from the environment.
