import Mathlib

set_option pp.all true
-- spec: DA51Triple.noConfusionType : Sort.{u} -> DA51Triple -> DA51Triple -> Sort.{u}
def DA51Triple.noConfusionType : Sort.{u} -> DA51Triple -> DA51Triple -> Sort.{u} :=
  fun (P : Sort.{u}) (t : DA51Triple) (t' : DA51Triple) => DA51Triple.casesOn.{succ u} (fun (t : DA51Triple) => Sort.{u}) t (fun (source : DA51Address) (target : DA51Address) (relation_op : DA51Address) => DA51Triple.casesOn.{succ u} (fun (t : DA51Triple) => Sort.{u}) t' (fun (source_1 : DA51Address) (target_1 : DA51Address) (relation_op_1 : DA51Address) => ((Eq.{1} DA51Address source source_1) -> (Eq.{1} DA51Address target target_1) -> (Eq.{1} DA51Address relation_op relation_op_1) -> P) -> P))
