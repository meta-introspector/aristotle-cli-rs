import Mathlib

-- spec: opaque Void.mk : forall {σ : Type}, σ -> (Void σ)
opaque Void.mk : forall {σ : Type}, σ -> (Void σ) :=
  fun {σ : Type} (x : σ) => Classical.ofNonempty.{1} (Void σ) (Void.instNonempty σ)
