import Split.Decidable_isTrue
import Split.False
import Split.Decidable_casesOn
import Split.instDecidableTrue
import Split.eq_false
import Split.congrArg
import Split.Decidable_decide_congr_simp
import Split.Decidable
import Split.false_and
import Split.Bool_and
import Split.decide_false
import Split.Bool_true_and
import Split.decide_true
import Split.Bool_true
import Split.And
import Split.Bool_false_and
import Split.congr
import Split.True
import Split.eq_self
import Split.instDecidableFalse
import Split.eq_true
import Split.Bool
import Split.of_eq_true
import Split.Eq_ndrec
import Split.Eq_refl
import Split.congrFun'
import Split.Decidable_isFalse
import Split.Eq_symm
import Split.Bool_false
import Split.Decidable_decide
import Split.Eq
import Split.Not
import Split.true_and
import Split.Eq_trans

-- Bool.decide_and from environment
-- theorem Bool.decide_and : forall (p : Prop) (q : Prop) [dpq : Decidable (And p q)] [dp : Decidable p] [dq : Decidable q], Eq.{1} Bool (Decidable.decide (And p q) dpq) (Bool.and (Decidable.decide p dp) (Decidable.decide q dq))

-- Stub: this file represents the declaration `Bool.decide_and`.
-- In a full split, the body would be extracted from the environment.
