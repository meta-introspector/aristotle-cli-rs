import Mathlib

set_option pp.all true
-- spec: DA51Triple.source : DA51Triple -> DA51Address
def DA51Triple.source : DA51Triple -> DA51Address :=
  fun (self : DA51Triple) => self.1
