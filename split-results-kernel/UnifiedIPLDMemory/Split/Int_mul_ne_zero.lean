import Split.False
import Split.HMul_hMul
import Split.Or_rec
import Split.Function_comp
import Split.Ne
import Split.Int
import Split.Int_mul_eq_zero
import Split.Int_instMul
import Split.instOfNat
import Split.Iff_mp
import Split.Or
import Split.OfNat_ofNat
import Split.Eq
import Split.instHMul

-- Int.mul_ne_zero from environment
-- theorem Int.mul_ne_zero : forall {a : Int} {b : Int}, (Ne.{1} Int a (OfNat.ofNat.{0} Int 0 (instOfNat 0))) -> (Ne.{1} Int b (OfNat.ofNat.{0} Int 0 (instOfNat 0))) -> (Ne.{1} Int (HMul.hMul.{0, 0, 0} Int Int Int (instHMul.{0} Int Int.instMul) a b) (OfNat.ofNat.{0} Int 0 (instOfNat 0)))

-- Stub: this file represents the declaration `Int.mul_ne_zero`.
-- In a full split, the body would be extracted from the environment.
