import Split.Option_casesOn
import Split.Option_some
import Split.Function_comp
import Split.Option_none
import Split.Option_map
import Split.eq_self
import Split.of_eq_true
import Split.Eq_ndrec
import Split.Eq_refl
import Split.Eq_symm
import Split.Eq
import Split.Option

-- Option.map_map from environment
-- theorem Option.map_map : forall {β : Type.{u_1}} {γ : Type.{u_2}} {α : Type.{u_3}} (h : β -> γ) (g : α -> β) (x : Option.{u_3} α), Eq.{succ u_2} (Option.{u_2} γ) (Option.map.{u_1, u_2} β γ h (Option.map.{u_3, u_1} α β g x)) (Option.map.{u_3, u_2} α γ (Function.comp.{succ u_3, succ u_1, succ u_2} α β γ h g) x)

-- Stub: this file represents the declaration `Option.map_map`.
-- In a full split, the body would be extracted from the environment.
