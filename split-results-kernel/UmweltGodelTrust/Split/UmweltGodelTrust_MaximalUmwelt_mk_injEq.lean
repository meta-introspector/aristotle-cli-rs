import Split.UmweltGodelTrust_MaximalUmwelt_mk_inj
import Split.Eq_propIntro
import Split.Lean_injEq_helper
import Split.UmweltGodelTrust_MaximalUmwelt_mk
import Split.And
import Split.UmweltGodelTrust_MaximalUmwelt
import Split.Nat
import Split.Eq_ndrec
import Split.Eq_refl
import Split.Eq

-- UmweltGodelTrust.MaximalUmwelt.mk.injEq from environment
-- theorem UmweltGodelTrust.MaximalUmwelt.mk.injEq : forall (grades : Nat) (onJ_types : Nat) (shadow_types : Nat) (conj_classes : Nat) (genus_zero : Nat) (hash_fams : Nat) (codecs : Nat) (grades_1 : Nat) (onJ_types_1 : Nat) (shadow_types_1 : Nat) (conj_classes_1 : Nat) (genus_zero_1 : Nat) (hash_fams_1 : Nat) (codecs_1 : Nat), Eq.{1} Prop (Eq.{1} UmweltGodelTrust.MaximalUmwelt (UmweltGodelTrust.MaximalUmwelt.mk grades onJ_types shadow_types conj_classes genus_zero hash_fams codecs) (UmweltGodelTrust.MaximalUmwelt.mk grades_1 onJ_types_1 shadow_types_1 conj_classes_1 genus_zero_1 hash_fams_1 codecs_1)) (And (Eq.{1} Nat grades grades_1) (And (Eq.{1} Nat onJ_types onJ_types_1) (And (Eq.{1} Nat shadow_types shadow_types_1) (And (Eq.{1} Nat conj_classes conj_classes_1) (And (Eq.{1} Nat genus_zero genus_zero_1) (And (Eq.{1} Nat hash_fams hash_fams_1) (Eq.{1} Nat codecs codecs_1)))))))

-- Stub: this file represents the declaration `UmweltGodelTrust.MaximalUmwelt.mk.injEq`.
-- In a full split, the body would be extracted from the environment.
