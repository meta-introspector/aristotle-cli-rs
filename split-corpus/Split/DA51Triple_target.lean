import Mathlib

set_option pp.all true
-- spec: DA51Triple.target : DA51Triple -> DA51Address
def DA51Triple.target : DA51Triple -> DA51Address :=
  fun (self : DA51Triple) => self.2
