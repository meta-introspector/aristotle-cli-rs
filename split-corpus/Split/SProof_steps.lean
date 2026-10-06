import Mathlib

set_option pp.all true
-- spec: SProof.steps : SProof -> (List.{0} SRewrite)
def SProof.steps : SProof -> (List.{0} SRewrite) :=
  fun (self : SProof) => self.1
