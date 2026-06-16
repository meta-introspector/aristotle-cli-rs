import Split.UmweltGodelTrust_MaximalUmwelt_mk
import Split.instOfNatNat
import Split.instHAdd
import Split.HAdd_hAdd
import Split.UmweltGodelTrust_MaximalUmwelt
import Split.Nat
import Split.SizeOf_sizeOf
import Split.instAddNat
import Split.Eq_refl
import Split.instSizeOfNat
import Split.OfNat_ofNat
import Split.Eq

-- UmweltGodelTrust.MaximalUmwelt.mk.sizeOf_spec from environment
-- theorem UmweltGodelTrust.MaximalUmwelt.mk.sizeOf_spec : forall (grades : Nat) (onJ_types : Nat) (shadow_types : Nat) (conj_classes : Nat) (genus_zero : Nat) (hash_fams : Nat) (codecs : Nat), Eq.{1} Nat (SizeOf.sizeOf.{1} UmweltGodelTrust.MaximalUmwelt UmweltGodelTrust.MaximalUmwelt._sizeOf_inst (UmweltGodelTrust.MaximalUmwelt.mk grades onJ_types shadow_types conj_classes genus_zero hash_fams codecs)) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)) (SizeOf.sizeOf.{1} Nat instSizeOfNat grades)) (SizeOf.sizeOf.{1} Nat instSizeOfNat onJ_types)) (SizeOf.sizeOf.{1} Nat instSizeOfNat shadow_types)) (SizeOf.sizeOf.{1} Nat instSizeOfNat conj_classes)) (SizeOf.sizeOf.{1} Nat instSizeOfNat genus_zero)) (SizeOf.sizeOf.{1} Nat instSizeOfNat hash_fams)) (SizeOf.sizeOf.{1} Nat instSizeOfNat codecs))

-- Stub: this file represents the declaration `UmweltGodelTrust.MaximalUmwelt.mk.sizeOf_spec`.
-- In a full split, the body would be extracted from the environment.
