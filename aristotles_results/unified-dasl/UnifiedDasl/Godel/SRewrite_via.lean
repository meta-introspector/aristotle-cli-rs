import Mathlib

set_option pp.all true
-- spec: SRewrite.via : SRewrite -> (Option.{0} Something)
def SRewrite.via : SRewrite -> (Option.{0} Something) :=
  fun (self : SRewrite) => self.3
