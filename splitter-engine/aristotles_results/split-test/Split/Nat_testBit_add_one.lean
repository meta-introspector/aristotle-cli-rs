import Split.bne
import Split.instHDiv
import Split.Nat_instAndOp
import Split.congrArg
import Split.id
import Split.HDiv_hDiv
import Split.Nat_instMod
import Split.instHMod
import Split.instOfNatNat
import Split.instBEqOfDecidableEq
import Split.instHShiftRightOfShiftRight
import Split.Nat_one_and_eq_mod_two
import Split.instHAdd
import Split.HMod_hMod
import Split.BEq_beq
import Split.Nat_instShiftRight
import Split.HAdd_hAdd
import Split.HShiftRight_hShiftRight
import Split.Nat
import Split.congr
import Split.Nat_mod_two_bne_zero
import Split.True
import Split.Nat_testBit
import Split.eq_self
import Split.Nat_instDiv
import Split.Bool
import Split.of_eq_true
import Split.instAddNat
import Split.congrFun'
import Split.instDecidableEqNat
import Split.HAnd_hAnd
import Split.OfNat_ofNat
import Split.Eq
import Split.instHAndOfAndOp
import Split.Eq_trans
import Split.Nat_shiftRight_succ_inside

-- Nat.testBit_add_one from environment
-- theorem Nat.testBit_add_one : forall (x : Nat) (i : Nat), Eq.{1} Bool (Nat.testBit x (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) i (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)))) (Nat.testBit (HDiv.hDiv.{0, 0, 0} Nat Nat Nat (instHDiv.{0} Nat Nat.instDiv) x (OfNat.ofNat.{0} Nat 2 (instOfNatNat 2))) i)

-- Stub: this file represents the declaration `Nat.testBit_add_one`.
-- In a full split, the body would be extracted from the environment.
