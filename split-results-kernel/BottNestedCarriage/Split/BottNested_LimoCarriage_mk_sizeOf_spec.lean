import Split.instOfNatNat
import Split.BottNested_LimoCarriage
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Nat
import Split.SizeOf_sizeOf
import Split.instAddNat
import Split.Eq_refl
import Split.instSizeOfNat
import Split.BottNested_LimoCarriage_mk
import Split.OfNat_ofNat
import Split.Eq
import Split.BottNested_NestedCarriage

-- BottNested.LimoCarriage.mk.sizeOf_spec from environment
-- theorem BottNested.LimoCarriage.mk.sizeOf_spec : forall (grade : Nat) (nested : BottNested.NestedCarriage) (capacity : Nat), Eq.{1} Nat (SizeOf.sizeOf.{1} BottNested.LimoCarriage BottNested.LimoCarriage._sizeOf_inst (BottNested.LimoCarriage.mk grade nested capacity)) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)) (SizeOf.sizeOf.{1} Nat instSizeOfNat grade)) (SizeOf.sizeOf.{1} BottNested.NestedCarriage BottNested.NestedCarriage._sizeOf_inst nested)) (SizeOf.sizeOf.{1} Nat instSizeOfNat capacity))

-- Stub: this file represents the declaration `BottNested.LimoCarriage.mk.sizeOf_spec`.
-- In a full split, the body would be extracted from the environment.
