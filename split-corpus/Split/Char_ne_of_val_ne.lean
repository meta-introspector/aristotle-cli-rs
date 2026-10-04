import Mathlib

-- spec: theorem Char.ne_of_val_ne : forall {c : Char} {d : Char}, (Not (Eq.{1} UInt32 (Char.val c) (Char.val d))) -> (Not (Eq.{1} Char c d))
theorem Char.ne_of_val_ne : forall {c : Char} {d : Char}, (Not (Eq.{1} UInt32 (Char.val c) (Char.val d))) -> (Not (Eq.{1} Char c d)) :=
  fun {c : Char} {d : Char} (h : Not (Eq.{1} UInt32 (Char.val c) (Char.val d))) (h' : Eq.{1} Char c d) => absurd.{0} (Eq.{1} UInt32 (Char.val c) (Char.val d)) False (Char.val_eq_of_eq c d h') h
