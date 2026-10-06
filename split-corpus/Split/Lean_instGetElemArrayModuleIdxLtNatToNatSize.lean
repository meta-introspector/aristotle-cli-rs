import Mathlib

set_option pp.all true
-- spec: Lean.instGetElemArrayModuleIdxLtNatToNatSize : forall {α : Type.{u_1}}, GetElem.{u_1, 0, u_1} (Array.{u_1} α) Lean.ModuleIdx α (fun (a : Array.{u_1} α) (i : Lean.ModuleIdx) => LT.lt.{0} Nat instLTNat (Lean.ModuleIdx.toNat i) (Array.size.{u_1} α a))
def Lean.instGetElemArrayModuleIdxLtNatToNatSize : forall {α : Type.{u_1}}, GetElem.{u_1, 0, u_1} (Array.{u_1} α) Lean.ModuleIdx α (fun (a : Array.{u_1} α) (i : Lean.ModuleIdx) => LT.lt.{0} Nat instLTNat (Lean.ModuleIdx.toNat i) (Array.size.{u_1} α a)) :=
  fun {α : Type.{u_1}} => GetElem.mk.{u_1, 0, u_1} (Array.{u_1} α) Lean.ModuleIdx α (fun (a : Array.{u_1} α) (i : Lean.ModuleIdx) => LT.lt.{0} Nat instLTNat (Lean.ModuleIdx.toNat i) (Array.size.{u_1} α a)) (fun (a : Array.{u_1} α) (i : Lean.ModuleIdx) (h : LT.lt.{0} Nat instLTNat (Lean.ModuleIdx.toNat i) (Array.size.{u_1} α a)) => GetElem.getElem.{u_1, 0, u_1} (Array.{u_1} α) Nat α (fun (xs : Array.{u_1} α) (i : Nat) => LT.lt.{0} Nat instLTNat i (Array.size.{u_1} α xs)) (Array.instGetElemNatLtSize.{u_1} α) a (Lean.ModuleIdx.toNat i) h)
