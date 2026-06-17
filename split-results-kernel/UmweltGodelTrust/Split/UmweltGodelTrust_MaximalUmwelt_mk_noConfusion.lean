import Split.UmweltGodelTrust_MaximalUmwelt_noConfusion
import Split.UmweltGodelTrust_MaximalUmwelt_mk
import Split.id
import Split.UmweltGodelTrust_MaximalUmwelt
import Split.Nat
import Split.Eq

-- UmweltGodelTrust.MaximalUmwelt.mk.noConfusion from environment
-- def UmweltGodelTrust.MaximalUmwelt.mk.noConfusion : forall {P : Sort.{u}} {grades : Nat} {onJ_types : Nat} {shadow_types : Nat} {conj_classes : Nat} {genus_zero : Nat} {hash_fams : Nat} {codecs : Nat} {grades' : Nat} {onJ_types' : Nat} {shadow_types' : Nat} {conj_classes' : Nat} {genus_zero' : Nat} {hash_fams' : Nat} {codecs' : Nat}, (Eq.{1} UmweltGodelTrust.MaximalUmwelt (UmweltGodelTrust.MaximalUmwelt.mk grades onJ_types shadow_types conj_classes genus_zero hash_fams codecs) (UmweltGodelTrust.MaximalUmwelt.mk grades' onJ_types' shadow_types' conj_classes' genus_zero' hash_fams' codecs')) -> ((Eq.{1} Nat grades grades') -> (Eq.{1} Nat onJ_types onJ_types') -> (Eq.{1} Nat shadow_types shadow_types') -> (Eq.{1} Nat conj_classes conj_classes') -> (Eq.{1} Nat genus_zero genus_zero') -> (Eq.{1} Nat hash_fams hash_fams') -> (Eq.{1} Nat codecs codecs') -> P) -> P
-- (definition body omitted)

-- Stub: this file represents the declaration `UmweltGodelTrust.MaximalUmwelt.mk.noConfusion`.
-- In a full split, the body would be extracted from the environment.
