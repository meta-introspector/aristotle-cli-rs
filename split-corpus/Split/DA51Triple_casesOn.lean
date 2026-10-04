import Mathlib

set_option pp.all true
-- spec: DA51Triple.casesOn : forall {motive : DA51Triple -> Sort.{u}} (t : DA51Triple), (forall (source : DA51Address) (target : DA51Address) (relation_op : DA51Address), motive (DA51Triple.mk source target relation_op)) -> (motive t)
def DA51Triple.casesOn : forall {motive : DA51Triple -> Sort.{u}} (t : DA51Triple), (forall (source : DA51Address) (target : DA51Address) (relation_op : DA51Address), motive (DA51Triple.mk source target relation_op)) -> (motive t) :=
  fun {motive : DA51Triple -> Sort.{u}} (t : DA51Triple) (mk : forall (source : DA51Address) (target : DA51Address) (relation_op : DA51Address), motive (DA51Triple.mk source target relation_op)) => DA51Triple.rec.{u} motive (fun (source : DA51Address) (target : DA51Address) (relation_op : DA51Address) => mk source target relation_op) t
