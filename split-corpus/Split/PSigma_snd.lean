import Mathlib

set_option pp.all true
-- spec: PSigma.snd : forall {α : Sort.{u}} {β : α -> Sort.{v}} (self : PSigma.{u, v} α β), β (PSigma.fst.{u, v} α β self)
def PSigma.snd : forall {α : Sort.{u}} {β : α -> Sort.{v}} (self : PSigma.{u, v} α β), β (PSigma.fst.{u, v} α β self) :=
  fun (α : Sort.{u}) (β : α -> Sort.{v}) (self : PSigma.{u, v} α β) => self.2
