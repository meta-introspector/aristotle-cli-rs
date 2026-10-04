import Mathlib

set_option pp.all true
-- spec: Trinity.noConfusionType : Sort.{u} -> Trinity -> Trinity -> Sort.{u}
def Trinity.noConfusionType : Sort.{u} -> Trinity -> Trinity -> Sort.{u} :=
  fun (P : Sort.{u}) (t : Trinity) (t' : Trinity) => Trinity.casesOn.{succ u} (fun (t : Trinity) => Sort.{u}) t (Trinity.casesOn.{succ u} (fun (t : Trinity) => Sort.{u}) t' (P -> P) (fun (a._@._internal._hyg.0 : Something) (a._@._internal._hyg.0 : Something) (a._@._internal._hyg.0 : Something) => P)) (fun (a._@._internal._hyg.0 : Something) (a_1._@._internal._hyg.0 : Something) (a_2._@._internal._hyg.0 : Something) => Trinity.casesOn.{succ u} (fun (t : Trinity) => Sort.{u}) t' P (fun (a_3._@._internal._hyg.0 : Something) (a_4._@._internal._hyg.0 : Something) (a_5._@._internal._hyg.0 : Something) => ((Eq.{1} Something a._@._internal._hyg.0 a_3._@._internal._hyg.0) -> (Eq.{1} Something a_1._@._internal._hyg.0 a_4._@._internal._hyg.0) -> (Eq.{1} Something a_2._@._internal._hyg.0 a_5._@._internal._hyg.0) -> P) -> P))
