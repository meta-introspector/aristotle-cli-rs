import Split.Option_casesOn
import Split.Option_some
import Split.Option_bind
import Split.Option_none
import Split.Eq_ndrec
import Split.Eq_refl
import Split.Eq_symm
import Split.Eq
import Split.Option

-- Option.bind_assoc from environment
-- theorem Option.bind_assoc : forall {α : Type.{u_1}} {β : Type.{u_2}} {γ : Type.{u_3}} (x : Option.{u_1} α) (f : α -> (Option.{u_2} β)) (g : β -> (Option.{u_3} γ)), Eq.{succ u_3} (Option.{u_3} γ) (Option.bind.{u_2, u_3} β γ (Option.bind.{u_1, u_2} α β x f) g) (Option.bind.{u_1, u_3} α γ x (fun (y : α) => Option.bind.{u_2, u_3} β γ (f y) g))

-- Stub: this file represents the declaration `Option.bind_assoc`.
-- In a full split, the body would be extracted from the environment.
