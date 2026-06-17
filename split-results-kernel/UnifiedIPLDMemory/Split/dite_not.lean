import Split.Decidable_isTrue
import Split.dite_cond_eq_true
import Split.of_eq_false
import Split.False
import Split.Decidable_casesOn
import Split.eq_false
import Split.congrArg
import Split.Decidable
import Split.not_true_eq_false
import Split.not_not_intro
import Split.dite
import Split.congr
import Split.True
import Split.eq_self
import Split.eq_true
import Split.of_eq_true
import Split.Eq_ndrec
import Split.Eq_refl
import Split.Decidable_isFalse
import Split.dite_cond_eq_false
import Split.Eq_symm
import Split.not_false_eq_true
import Split.Eq
import Split.Not
import Split.Eq_trans

-- dite_not from environment
-- theorem dite_not : forall {p : Prop} {α : Sort.{u_1}} [hn : Decidable (Not p)] [h : Decidable p] (x : (Not p) -> α) (y : (Not (Not p)) -> α), Eq.{u_1} α (dite.{u_1} α (Not p) hn x y) (dite.{u_1} α p h (fun (h : p) => y (not_not_intro p h)) x)

-- Stub: this file represents the declaration `dite_not`.
-- In a full split, the body would be extracted from the environment.
