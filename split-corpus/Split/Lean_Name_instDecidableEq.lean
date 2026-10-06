import Mathlib

set_option pp.all true
-- spec: Lean.Name.instDecidableEq : DecidableEq.{1} Lean.Name
def Lean.Name.instDecidableEq : DecidableEq.{1} Lean.Name :=
  fun (a : Lean.Name) (b : Lean.Name) => dite.{1} (Decidable (Eq.{1} Lean.Name a b)) (Eq.{1} Bool (BEq.beq.{0} Lean.Name Lean.Name.instBEq a b) Bool.true) (instDecidableEqBool (BEq.beq.{0} Lean.Name Lean.Name.instBEq a b) Bool.true) (fun (h : Eq.{1} Bool (BEq.beq.{0} Lean.Name Lean.Name.instBEq a b) Bool.true) => Decidable.isTrue (Eq.{1} Lean.Name a b) (Lean.Name.instDecidableEq._proof_1 a b h)) (fun (h : Not (Eq.{1} Bool (BEq.beq.{0} Lean.Name Lean.Name.instBEq a b) Bool.true)) => Decidable.isFalse (Eq.{1} Lean.Name a b) (Lean.Name.instDecidableEq._proof_2 a b h))
