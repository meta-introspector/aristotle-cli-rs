import Mathlib

set_option pp.all true
-- spec: FloatSpec.float : FloatSpec -> Type
def FloatSpec.float : FloatSpec -> Type :=
  fun (self : FloatSpec) => self.1
