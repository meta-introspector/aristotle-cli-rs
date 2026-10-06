import Mathlib

set_option pp.all true
-- spec: instDecidableEqChar : DecidableEq.{1} Char
def instDecidableEqChar : DecidableEq.{1} Char :=
  fun (c : Char) (d : Char) => instDecidableEqChar.match_1.{1} c d (fun (x._@.Init.Prelude.2769770332._hygCtx._hyg.17 : Decidable (Eq.{1} UInt32 (Char.val c) (Char.val d))) => Decidable (Eq.{1} Char c d)) (decEq.{1} UInt32 instDecidableEqUInt32 (Char.val c) (Char.val d)) (fun (h : Eq.{1} UInt32 (Char.val c) (Char.val d)) => Decidable.isTrue (Eq.{1} Char c d) (Char.ext c d h)) (fun (h : Not (Eq.{1} UInt32 (Char.val c) (Char.val d))) => Decidable.isFalse (Eq.{1} Char c d) (Char.ne_of_val_ne c d h))
