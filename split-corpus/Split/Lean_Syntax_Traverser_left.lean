import Mathlib

set_option pp.all true
-- spec: Lean.Syntax.Traverser.left : Lean.Syntax.Traverser -> Lean.Syntax.Traverser
def Lean.Syntax.Traverser.left : Lean.Syntax.Traverser -> Lean.Syntax.Traverser :=
  fun (t : Lean.Syntax.Traverser) => ite.{1} Lean.Syntax.Traverser (GT.gt.{0} Nat instLTNat (Array.size.{0} Lean.Syntax (Lean.Syntax.Traverser.parents t)) (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) (Nat.decLt (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) (Array.size.{0} Lean.Syntax (Lean.Syntax.Traverser.parents t))) (Lean.Syntax.Traverser.down (Lean.Syntax.Traverser.up t) (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) (Array.back!.{0} Nat instInhabitedNat (Lean.Syntax.Traverser.idxs t)) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)))) t
