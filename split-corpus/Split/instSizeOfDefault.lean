import Mathlib

set_option pp.all true
-- spec: instSizeOfDefault : forall (α : Sort.{u}), SizeOf.{u} α
def instSizeOfDefault : forall (α : Sort.{u}), SizeOf.{u} α :=
  fun (α : Sort.{u}) => SizeOf.mk.{u} α (default.sizeOf.{u} α)
