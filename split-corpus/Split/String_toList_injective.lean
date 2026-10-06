import Mathlib

-- spec: theorem String.toList_injective : forall {s₁ : String} {s₂ : String}, (Eq.{1} (List.{0} Char) (String.toList s₁) (String.toList s₂)) -> (Eq.{1} String s₁ s₂)
theorem String.toList_injective : forall {s₁ : String} {s₂ : String}, (Eq.{1} (List.{0} Char) (String.toList s₁) (String.toList s₂)) -> (Eq.{1} String s₁ s₂) :=
  fun {s₁ : String} {s₂ : String} (h : Eq.{1} (List.{0} Char) (String.toList s₁) (String.toList s₂)) => Eq.mp.{0} (Eq.{1} String (String.ofList (String.toList s₁)) (String.ofList (String.toList s₂))) (Eq.{1} String s₁ s₂) (congr.{1, 1} String Prop (Eq.{1} String (String.ofList (String.toList s₁))) (Eq.{1} String s₁) (String.ofList (String.toList s₂)) s₂ (congrArg.{1, 1} String (String -> Prop) (String.ofList (String.toList s₁)) s₁ (Eq.{1} String) (String.ofList_toList s₁)) (String.ofList_toList s₂)) (congrArg.{1, 1} (List.{0} Char) String (String.toList s₁) (String.toList s₂) String.ofList h)
