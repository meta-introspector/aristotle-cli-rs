import Split.congrArg
import Split.Eq_rec
import Split.True
import Split.eq_self
import Split.Eq_substr
import Split.of_eq_true
import Split.Eq_refl
import Split.Eq_symm
import Split.Eq
import Split.Eq_trans
import Split.forall_congr

-- forall_prop_domain_congr from environment
-- theorem forall_prop_domain_congr : forall {p₁ : Prop} {p₂ : Prop} {q₁ : p₁ -> Prop} {q₂ : p₂ -> Prop} (h₁ : Eq.{1} Prop p₁ p₂), (forall (a : p₂), Eq.{1} Prop (q₁ (Eq.substr.{1} Prop (fun (x._@.Init.SimpLemmas.4067317009._hygCtx._hyg.27 : Prop) => x._@.Init.SimpLemmas.4067317009._hygCtx._hyg.27) p₂ p₁ h₁ a)) (q₂ a)) -> (Eq.{1} Prop (forall (a : p₁), q₁ a) (forall (a : p₂), q₂ a))

-- Stub: this file represents the declaration `forall_prop_domain_congr`.
-- In a full split, the body would be extracted from the environment.
