import Split.Int_instDiv
import Split.instHDiv
import Split.Exists
import Split.HDiv_hDiv
import Split.Int
import Split.LE_le
import Split.Nat_cast
import Split.Int_eq_ofNat_of_zero_le
import Split.instOfNat
import Split.Nat
import Split.Nat_instDiv
import Split.instNatCastInt
import Split.OfNat_ofNat
import Split.Eq
import Split.Int_instLEInt
import Split.Int_natCast_nonneg

-- Int.ediv_nonneg from environment
-- theorem Int.ediv_nonneg : forall {a : Int} {b : Int}, (LE.le.{0} Int Int.instLEInt (OfNat.ofNat.{0} Int 0 (instOfNat 0)) a) -> (LE.le.{0} Int Int.instLEInt (OfNat.ofNat.{0} Int 0 (instOfNat 0)) b) -> (LE.le.{0} Int Int.instLEInt (OfNat.ofNat.{0} Int 0 (instOfNat 0)) (HDiv.hDiv.{0, 0, 0} Int Int Int (instHDiv.{0} Int Int.instDiv) a b))

-- Stub: this file represents the declaration `Int.ediv_nonneg`.
-- In a full split, the body would be extracted from the environment.
