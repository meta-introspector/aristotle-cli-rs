import Mathlib

set_option pp.all true
-- spec: FloatSpec.decLt : forall (self : FloatSpec), DecidableRel.{1, 1} (FloatSpec.float self) (FloatSpec.float self) (FloatSpec.lt self)
def FloatSpec.decLt : forall (self : FloatSpec), DecidableRel.{1, 1} (FloatSpec.float self) (FloatSpec.float self) (FloatSpec.lt self) :=
  fun (self : FloatSpec) => self.5
