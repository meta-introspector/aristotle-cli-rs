import Mathlib

set_option pp.all true
-- spec: instReprSProof.repr : SProof -> Nat -> Std.Format
def instReprSProof.repr : SProof -> Nat -> Std.Format :=
  fun (x._@.RequestProject.MetaReflective.3262142183._hygCtx._hyg.11 : SProof) (prec._@.RequestProject.MetaReflective.3262142183._hygCtx._hyg.1 : Nat) => Std.Format.bracket "{ " (HAppend.hAppend.{0, 0, 0} Std.Format Std.Format Std.Format (instHAppendOfAppend.{0} Std.Format Std.Format.instAppend) (HAppend.hAppend.{0, 0, 0} Std.Format Std.Format Std.Format (instHAppendOfAppend.{0} Std.Format Std.Format.instAppend) (HAppend.hAppend.{0, 0, 0} Std.Format Std.Format Std.Format (instHAppendOfAppend.{0} Std.Format Std.Format.instAppend) Std.Format.nil (Std.Format.text "steps")) (Std.Format.text " := ")) (Std.Format.group (Std.Format.nest (OfNat.ofNat.{0} Int 9 (instOfNat 9)) (repr.{0} (List.{0} SRewrite) (instReprList.{0} SRewrite instReprSRewrite) (SProof.steps x._@.RequestProject.MetaReflective.3262142183._hygCtx._hyg.11))) Std.Format.FlattenBehavior.allOrNone)) " }"
