import Mathlib

set_option pp.all true
-- spec: instOfScientificFloat : OfScientific.{0} Float
def instOfScientificFloat : OfScientific.{0} Float :=
  OfScientific.mk.{0} Float Float.ofScientific
