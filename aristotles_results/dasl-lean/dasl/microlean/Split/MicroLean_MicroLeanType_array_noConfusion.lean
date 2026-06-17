import Mathlib

set_option pp.all true
-- spec: MicroLean.MicroLeanType.array.noConfusion : forall {P : Sort.{u}} {elem : MicroLean.MicroLeanType} {elem' : MicroLean.MicroLeanType}, (Eq.{1} MicroLean.MicroLeanType (MicroLean.MicroLeanType.array elem) (MicroLean.MicroLeanType.array elem')) -> ((Eq.{1} MicroLean.MicroLeanType elem elem') -> P) -> P
def MicroLean.MicroLeanType.array.noConfusion : forall {P : Sort.{u}} {elem : MicroLean.MicroLeanType} {elem' : MicroLean.MicroLeanType}, (Eq.{1} MicroLean.MicroLeanType (MicroLean.MicroLeanType.array elem) (MicroLean.MicroLeanType.array elem')) -> ((Eq.{1} MicroLean.MicroLeanType elem elem') -> P) -> P :=
  fun {P : Sort.{u}} {elem : MicroLean.MicroLeanType} {elem' : MicroLean.MicroLeanType} (eq : Eq.{1} MicroLean.MicroLeanType (MicroLean.MicroLeanType.array elem) (MicroLean.MicroLeanType.array elem')) (k : (Eq.{1} MicroLean.MicroLeanType elem elem') -> P) => id.{u} P (MicroLean.MicroLeanType.noConfusion.{u} P (MicroLean.MicroLeanType.array elem) (MicroLean.MicroLeanType.array elem') eq k)
