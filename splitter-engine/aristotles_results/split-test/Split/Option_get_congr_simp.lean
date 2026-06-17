import Split.Eq_rec
import Split.Bool_true
import Split.Option_get
import Split.Bool
import Split.Eq_ndrec
import Split.Eq_refl
import Split.Option_isSome
import Split.Eq
import Split.Option

-- Option.get.congr_simp from environment
-- theorem Option.get.congr_simp : forall {α : Type.{u}} (o : Option.{u} α) (o_1 : Option.{u} α) (e_o : Eq.{succ u} (Option.{u} α) o o_1) (a._@._internal._hyg.0 : Eq.{1} Bool (Option.isSome.{u} α o) Bool.true), Eq.{succ u} α (Option.get.{u} α o a._@._internal._hyg.0) (Option.get.{u} α o_1 (Eq.ndrec.{0, succ u} (Option.{u} α) o (fun (o : Option.{u} α) => Eq.{1} Bool (Option.isSome.{u} α o) Bool.true) a._@._internal._hyg.0 o_1 e_o))

-- Stub: this file represents the declaration `Option.get.congr_simp`.
-- In a full split, the body would be extracted from the environment.
