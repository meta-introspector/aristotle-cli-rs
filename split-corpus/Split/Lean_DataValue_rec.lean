import Mathlib

-- spec: recursor Lean.DataValue.rec : forall {motive : Lean.DataValue -> Sort.{u}}, (forall (v : String), motive (Lean.DataValue.ofString v)) -> (forall (v : Bool), motive (Lean.DataValue.ofBool v)) -> (forall (v : Lean.Name), motive (Lean.DataValue.ofName v)) -> (forall (v : Nat), motive (Lean.DataValue.ofNat v)) -> (forall (v : Int), motive (Lean.DataValue.ofInt v)) -> (forall (v : Lean.Syntax), motive (Lean.DataValue.ofSyntax v)) -> (forall (t : Lean.DataValue), motive t)
