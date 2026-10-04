import Mathlib

set_option pp.all true
-- spec: FloatSpec.val : forall (self : FloatSpec), FloatSpec.float self
def FloatSpec.val : forall (self : FloatSpec), FloatSpec.float self :=
  fun (self : FloatSpec) => self.2
