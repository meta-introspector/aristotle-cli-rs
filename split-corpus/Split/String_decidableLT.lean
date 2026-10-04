import Mathlib

set_option pp.all true
-- spec: String.decidableLT : forall (s₁ : [mdata borrowed:1 String]) (s₂ : [mdata borrowed:1 String]), Decidable (LT.lt.{0} ([mdata borrowed:1 String]) String.instLT s₁ s₂)
def String.decidableLT : forall (s₁ : [mdata borrowed:1 String]) (s₂ : [mdata borrowed:1 String]), Decidable (LT.lt.{0} ([mdata borrowed:1 String]) String.instLT s₁ s₂) :=
  fun (s₁ : String) (s₂ : String) => List.decidableLT.{0} Char instDecidableEqChar Char.instLT Char.instDecidableLt (String.toList s₁) (String.toList s₂)
