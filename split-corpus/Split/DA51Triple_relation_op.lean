import Mathlib

set_option pp.all true
-- spec: DA51Triple.relation_op : DA51Triple -> DA51Address
def DA51Triple.relation_op : DA51Triple -> DA51Address :=
  fun (self : DA51Triple) => self.3
