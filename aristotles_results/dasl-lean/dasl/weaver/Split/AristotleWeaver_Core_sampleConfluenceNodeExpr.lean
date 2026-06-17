import Mathlib

set_option pp.all true
-- spec: AristotleWeaver.Core.sampleConfluenceNodeExpr : AristotleWeaver.Core.SimpleExpr
def AristotleWeaver.Core.sampleConfluenceNodeExpr : AristotleWeaver.Core.SimpleExpr :=
  AristotleWeaver.Core.SimpleExpr.app (AristotleWeaver.Core.SimpleExpr.const "OggorialHub" (List.nil.{0} Nat)) (AristotleWeaver.Core.SimpleExpr.bvar (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)))
