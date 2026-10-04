import Mathlib

set_option pp.all true
-- spec: FloatSpec.lt : forall (self : FloatSpec), (FloatSpec.float self) -> (FloatSpec.float self) -> Prop
def FloatSpec.lt : forall (self : FloatSpec), (FloatSpec.float self) -> (FloatSpec.float self) -> Prop :=
  fun (self : FloatSpec) => self.3
