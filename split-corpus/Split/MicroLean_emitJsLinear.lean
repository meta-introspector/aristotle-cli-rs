import Mathlib

set_option pp.all true
-- spec: MicroLean.emitJsLinear : MicroLean.LinearMicroType -> String
def MicroLean.emitJsLinear : MicroLean.LinearMicroType -> String :=
  fun (x._@.RequestProject.MicroLean.2597033912._hygCtx._hyg.5 : MicroLean.LinearMicroType) => MicroLean.emitRustLinear.match_1.{1} (fun (x._@.RequestProject.MicroLean.2597033912._hygCtx.5.RequestProject.MicroLean.2597033912._hygCtx._hyg.16 : MicroLean.LinearMicroType) => String) x._@.RequestProject.MicroLean.2597033912._hygCtx._hyg.5 (fun (t : MicroLean.MicroLeanType) => HAppend.hAppend.{0, 0, 0} String String String (instHAppendOfAppend.{0} String instAppendString) (ToString.toString.{0} String instToStringString (MicroLean.emitJs t)) (ToString.toString.{0} String instToStringString " /* borrowed: no finally-dec */")) (fun (t : MicroLean.MicroLeanType) => HAppend.hAppend.{0, 0, 0} String String String (instHAppendOfAppend.{0} String instAppendString) (ToString.toString.{0} String instToStringString (MicroLean.emitJs t)) (ToString.toString.{0} String instToStringString " /* owned: dec in finally */"))
