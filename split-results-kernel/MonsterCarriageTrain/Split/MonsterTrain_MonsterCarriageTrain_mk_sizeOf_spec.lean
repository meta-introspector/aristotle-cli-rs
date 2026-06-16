import Split.instOfNatNat
import Split.List
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Nat
import Split.SizeOf_sizeOf
import Split.instAddNat
import Split.Eq_refl
import Split.MonsterTrain_City
import Split.OfNat_ofNat
import Split.Eq
import Split.MonsterTrain_King
import Split.MonsterTrain_MonsterCarriageTrain
import Split.MonsterTrain_Carriage
import Split.MonsterTrain_MonsterCarriageTrain_mk

-- MonsterTrain.MonsterCarriageTrain.mk.sizeOf_spec from environment
-- theorem MonsterTrain.MonsterCarriageTrain.mk.sizeOf_spec : forall (king : MonsterTrain.King) (cars : List.{0} MonsterTrain.Carriage) (location : MonsterTrain.City), Eq.{1} Nat (SizeOf.sizeOf.{1} MonsterTrain.MonsterCarriageTrain MonsterTrain.MonsterCarriageTrain._sizeOf_inst (MonsterTrain.MonsterCarriageTrain.mk king cars location)) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)) (SizeOf.sizeOf.{1} MonsterTrain.King MonsterTrain.King._sizeOf_inst king)) (SizeOf.sizeOf.{1} (List.{0} MonsterTrain.Carriage) (List._sizeOf_inst.{0} MonsterTrain.Carriage MonsterTrain.Carriage._sizeOf_inst) cars)) (SizeOf.sizeOf.{1} MonsterTrain.City MonsterTrain.City._sizeOf_inst location))

-- Stub: this file represents the declaration `MonsterTrain.MonsterCarriageTrain.mk.sizeOf_spec`.
-- In a full split, the body would be extracted from the environment.
