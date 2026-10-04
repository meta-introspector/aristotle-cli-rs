import Mathlib

-- spec: theorem AristotleWeaver.Core.sample_size_pos : Eq.{1} Nat (AristotleWeaver.Core.SimpleExpr.size AristotleWeaver.Core.sampleConfluenceNodeExpr) (OfNat.ofNat.{0} Nat 3 (instOfNatNat 3))
theorem AristotleWeaver.Core.sample_size_pos : Eq.{1} Nat (AristotleWeaver.Core.SimpleExpr.size AristotleWeaver.Core.sampleConfluenceNodeExpr) (OfNat.ofNat.{0} Nat 3 (instOfNatNat 3)) :=
  Eq.refl.{1} Nat (AristotleWeaver.Core.SimpleExpr.size AristotleWeaver.Core.sampleConfluenceNodeExpr)
