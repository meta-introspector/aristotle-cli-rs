import Mathlib

set_option pp.all true
-- spec: instReprRoutingStrategy : Repr.{0} RoutingStrategy
def instReprRoutingStrategy : Repr.{0} RoutingStrategy :=
  Repr.mk.{0} RoutingStrategy instReprRoutingStrategy.repr
