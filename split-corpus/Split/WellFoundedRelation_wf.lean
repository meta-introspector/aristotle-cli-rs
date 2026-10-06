import Mathlib

-- spec: theorem WellFoundedRelation.wf : forall {α : Sort.{u}} [self : WellFoundedRelation.{u} α], WellFounded.{u} α (WellFoundedRelation.rel.{u} α self)
theorem WellFoundedRelation.wf : forall {α : Sort.{u}} [self : WellFoundedRelation.{u} α], WellFounded.{u} α (WellFoundedRelation.rel.{u} α self) :=
  fun (α : Sort.{u}) [self : WellFoundedRelation.{u} α] => self.2
