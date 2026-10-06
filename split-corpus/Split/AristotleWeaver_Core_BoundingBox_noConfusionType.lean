import Mathlib

set_option pp.all true
-- spec: AristotleWeaver.Core.BoundingBox.noConfusionType : Sort.{u} -> AristotleWeaver.Core.BoundingBox -> AristotleWeaver.Core.BoundingBox -> Sort.{u}
def AristotleWeaver.Core.BoundingBox.noConfusionType : Sort.{u} -> AristotleWeaver.Core.BoundingBox -> AristotleWeaver.Core.BoundingBox -> Sort.{u} :=
  fun (P : Sort.{u}) (t : AristotleWeaver.Core.BoundingBox) (t' : AristotleWeaver.Core.BoundingBox) => AristotleWeaver.Core.BoundingBox.casesOn.{succ u} (fun (t : AristotleWeaver.Core.BoundingBox) => Sort.{u}) t (fun (x : Float) (y : Float) (w : Float) (h : Float) => AristotleWeaver.Core.BoundingBox.casesOn.{succ u} (fun (t : AristotleWeaver.Core.BoundingBox) => Sort.{u}) t' (fun (x_1 : Float) (y_1 : Float) (w_1 : Float) (h_1 : Float) => ((Eq.{1} Float x x_1) -> (Eq.{1} Float y y_1) -> (Eq.{1} Float w w_1) -> (Eq.{1} Float h h_1) -> P) -> P))
