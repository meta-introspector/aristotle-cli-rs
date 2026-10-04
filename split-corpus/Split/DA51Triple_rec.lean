import Mathlib

-- spec: recursor DA51Triple.rec : forall {motive : DA51Triple -> Sort.{u}}, (forall (source : DA51Address) (target : DA51Address) (relation_op : DA51Address), motive (DA51Triple.mk source target relation_op)) -> (forall (t : DA51Triple), motive t)
