import Mathlib

set_option pp.all true
-- spec: the42Steps : List.{0} SRewrite
def the42Steps : List.{0} SRewrite :=
  HAppend.hAppend.{0, 0, 0} (List.{0} SRewrite) (List.{0} SRewrite) (List.{0} SRewrite) (instHAppendOfAppend.{0} (List.{0} SRewrite) (List.instAppend.{0} SRewrite)) (List.cons.{0} SRewrite quineToGccAst (List.cons.{0} SRewrite gccAstToTypescript (List.cons.{0} SRewrite typescriptStep (List.cons.{0} SRewrite typescriptToOrderBook (List.cons.{0} SRewrite orderBookToCringe (List.cons.{0} SRewrite cringeToGodel (List.cons.{0} SRewrite godelToQuine (List.nil.{0} SRewrite)))))))) (List.replicate.{0} SRewrite (OfNat.ofNat.{0} Nat 35 (instOfNatNat 35)) trivialQuineStep)
