import Mathlib

set_option pp.all true
-- spec: AristotleWeaver.Core.layoutClean : Nat -> Bool
def AristotleWeaver.Core.layoutClean : Nat -> Bool :=
  fun (frame : Nat) => have nodes : List.{0} Nat := List.range (OfNat.ofNat.{0} Nat 14 (instOfNatNat 14)); List.all.{0} Nat nodes (fun (u : Nat) => List.all.{0} Nat nodes (fun (v : Nat) => ite.{1} Bool (Eq.{1} Bool (BEq.beq.{0} Nat (instBEqOfDecidableEq.{0} Nat instDecidableEqNat) u v) Bool.true) (instDecidableEqBool (BEq.beq.{0} Nat (instBEqOfDecidableEq.{0} Nat instDecidableEqNat) u v) Bool.true) Bool.true (AristotleWeaver.Core.disjointBoxes (AristotleWeaver.Core.nodeToBox u frame) (AristotleWeaver.Core.nodeToBox v frame))))
