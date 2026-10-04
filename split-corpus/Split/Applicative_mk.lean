import Mathlib

-- spec: constructor Applicative.mk : forall {f : Type.{u} -> Type.{v}} [toFunctor : Functor.{u, v} f] [toPure : Pure.{u, v} f] [toSeq : Seq.{u, v} f] [toSeqLeft : SeqLeft.{u, v} f] [toSeqRight : SeqRight.{u, v} f], Applicative.{u, v} f
