import Mathlib

set_option pp.all true
-- spec: Std.Format.pretty : Std.Format -> (optParam.{1} Nat Std.Format.defWidth) -> (optParam.{1} Nat (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) -> (optParam.{1} Nat (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) -> String
def Std.Format.pretty : Std.Format -> (optParam.{1} Nat Std.Format.defWidth) -> (optParam.{1} Nat (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) -> (optParam.{1} Nat (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) -> String :=
  fun (f : Std.Format) (width : Nat) (indent : Nat) (column : Nat) => have act : StateM.{0} _private.Init.Data.Format.Basic.0.Std.Format.State Unit := Std.Format.prettyM (StateM.{0} _private.Init.Data.Format.Basic.0.Std.Format.State) f width indent (StateT.instMonad.{0, 0} _private.Init.Data.Format.Basic.0.Std.Format.State Id.{0} Id.instMonad.{0}) _private.Init.Data.Format.Basic.0.Std.Format.instMonadPrettyFormatStateMState; _private.Init.Data.Format.Basic.0.Std.Format.State.out (Prod.snd.{0, 0} Unit _private.Init.Data.Format.Basic.0.Std.Format.State (act (_private.Init.Data.Format.Basic.0.Std.Format.State.mk "" column)))
