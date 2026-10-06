import Mathlib

set_option pp.all true
-- spec: Array.toVector : forall {α : Type.{u_1}} (xs : Array.{u_1} α), Vector.{u_1} α (Array.size.{u_1} α xs)
def Array.toVector : forall {α : Type.{u_1}} (xs : Array.{u_1} α), Vector.{u_1} α (Array.size.{u_1} α xs) :=
  fun {α : Type.{u_1}} (xs : Array.{u_1} α) => Vector.mk.{u_1} α (Array.size.{u_1} α xs) xs (Array.toVector._proof_1.{u_1} α xs)
