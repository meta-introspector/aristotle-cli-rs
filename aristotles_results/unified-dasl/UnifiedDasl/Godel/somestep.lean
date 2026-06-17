import Mathlib

set_option pp.all true
-- spec: somestep : SProof
def somestep : SProof :=
  SProof.mk (List.cons.{0} SRewrite (SRewrite.mk Something.SomeTypescriptClient Something.SomeLLMQuery (Option.some.{0} Something Something.ThatLLModel) Something.SomeTypescriptClient) (List.nil.{0} SRewrite))
