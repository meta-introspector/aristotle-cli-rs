import Mathlib

set_option pp.all true
-- spec: MicroLean.MutLinearType.noConfusionType : Sort.{u} -> MicroLean.MutLinearType -> MicroLean.MutLinearType -> Sort.{u}
def MicroLean.MutLinearType.noConfusionType : Sort.{u} -> MicroLean.MutLinearType -> MicroLean.MutLinearType -> Sort.{u} :=
  fun (P : Sort.{u}) (t : MicroLean.MutLinearType) (t' : MicroLean.MutLinearType) => MicroLean.MutLinearType.casesOn.{succ u} (fun (t : MicroLean.MutLinearType) => Sort.{u}) t (fun (mode : MicroLean.MutMode) (type : MicroLean.MicroLeanType) => MicroLean.MutLinearType.casesOn.{succ u} (fun (t : MicroLean.MutLinearType) => Sort.{u}) t' (fun (mode_1 : MicroLean.MutMode) (type_1 : MicroLean.MicroLeanType) => ((Eq.{1} MicroLean.MutMode mode mode_1) -> (Eq.{1} MicroLean.MicroLeanType type type_1) -> P) -> P))
