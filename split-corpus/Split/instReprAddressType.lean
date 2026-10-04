import Mathlib

set_option pp.all true
-- spec: instReprAddressType : Repr.{0} AddressType
def instReprAddressType : Repr.{0} AddressType :=
  Repr.mk.{0} AddressType instReprAddressType.repr
