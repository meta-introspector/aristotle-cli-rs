import Mathlib

-- spec: opaque ST.Prim.mkRef : forall {σ : Type} {α : Type}, α -> (ST σ (ST.Ref σ α))
opaque ST.Prim.mkRef : forall {σ : Type} {α : Type}, α -> (ST σ (ST.Ref σ α)) :=
  fun {σ : Type} {α : Type} (a : α) => Pure.pure.{0, 0} (ST σ) (Applicative.toPure.{0, 0} (ST σ) (Monad.toApplicative.{0, 0} (ST σ) (instMonadST σ))) (ST.Ref σ α) (ST.Ref.mk σ α (Classical.choice.{1} (NonemptyType.type.{0} ST.RefPointed) _private.Init.System.ST.0.ST.Prim.mkRef._proof_1) (Nonempty.intro.{1} α a))
