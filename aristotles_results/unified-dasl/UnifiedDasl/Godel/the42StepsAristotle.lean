import Mathlib

set_option pp.all true
-- spec: the42StepsAristotle : List.{0} SRewrite
def the42StepsAristotle : List.{0} SRewrite :=
  HAppend.hAppend.{0, 0, 0} (List.{0} SRewrite) (List.{0} SRewrite) (List.{0} SRewrite) (instHAppendOfAppend.{0} (List.{0} SRewrite) (List.instAppend.{0} SRewrite)) (List.cons.{0} SRewrite aristotleQuineToGccAst (List.cons.{0} SRewrite aristotleGccAstToTypescript (List.cons.{0} SRewrite aristotleTypescriptStep (List.cons.{0} SRewrite aristotleTypescriptToOrderBook (List.cons.{0} SRewrite aristotleOrderBookToCringe (List.cons.{0} SRewrite aristotleCringeToGodel (List.cons.{0} SRewrite aristotleGodelToQuine (List.nil.{0} SRewrite)))))))) (List.replicate.{0} SRewrite (OfNat.ofNat.{0} Nat 35 (instOfNatNat 35)) trivialQuineStep)
