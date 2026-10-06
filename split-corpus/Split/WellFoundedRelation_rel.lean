import Mathlib

set_option pp.all true
-- spec: WellFoundedRelation.rel : forall {α : Sort.{u}} [self : WellFoundedRelation.{u} α], α -> α -> Prop
def WellFoundedRelation.rel : forall {α : Sort.{u}} [self : WellFoundedRelation.{u} α], α -> α -> Prop :=
  fun (α : Sort.{u}) [self : WellFoundedRelation.{u} α] => self.1
