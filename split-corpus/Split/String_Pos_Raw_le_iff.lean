import Mathlib

-- spec: theorem String.Pos.Raw.le_iff : forall {i₁ : String.Pos.Raw} {i₂ : String.Pos.Raw}, Iff (LE.le.{0} String.Pos.Raw String.instLERaw i₁ i₂) (LE.le.{0} Nat instLENat (String.Pos.Raw.byteIdx i₁) (String.Pos.Raw.byteIdx i₂))
theorem String.Pos.Raw.le_iff : forall {i₁ : String.Pos.Raw} {i₂ : String.Pos.Raw}, Iff (LE.le.{0} String.Pos.Raw String.instLERaw i₁ i₂) (LE.le.{0} Nat instLENat (String.Pos.Raw.byteIdx i₁) (String.Pos.Raw.byteIdx i₂)) :=
  fun {i₁ : String.Pos.Raw} {i₂ : String.Pos.Raw} => Iff.rfl (LE.le.{0} String.Pos.Raw String.instLERaw i₁ i₂)
