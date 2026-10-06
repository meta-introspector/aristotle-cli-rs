import Mathlib

-- spec: theorem MicroLean.elaboration_path_total : forall (name : String) (o : Option.{0} MicroLean.MicroLeanType), Ne.{1} String (MicroLean.genFFI name (MicroLean.projectOr o)) ""
theorem MicroLean.elaboration_path_total : forall (name : String) (o : Option.{0} MicroLean.MicroLeanType), Ne.{1} String (MicroLean.genFFI name (MicroLean.projectOr o)) "" :=
  fun (name : String) (o : Option.{0} MicroLean.MicroLeanType) => MicroLean.genFFI_ne name (MicroLean.projectOr o)
