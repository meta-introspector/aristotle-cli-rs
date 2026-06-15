import Split.Nat_instAndOp
import Split.congrArg
import Split.Nat_testBit_bitwise
import Split.Bool_and
import Split.Bool_and_self
import Split.Nat
import Split.True
import Split.Nat_testBit
import Split.eq_self
import Split.Bool
import Split.of_eq_true
import Split.congrFun'
import Split.HAnd_hAnd
import Split.Bool_false
import Split.Eq
import Split.instHAndOfAndOp
import Split.Eq_trans

-- Nat.testBit_and from environment
-- theorem Nat.testBit_and : forall (x : Nat) (y : Nat) (i : Nat), Eq.{1} Bool (Nat.testBit (HAnd.hAnd.{0, 0, 0} Nat Nat Nat (instHAndOfAndOp.{0} Nat Nat.instAndOp) x y) i) (Bool.and (Nat.testBit x i) (Nat.testBit y i))

-- Stub: this file represents the declaration `Nat.testBit_and`.
-- In a full split, the body would be extracted from the environment.
