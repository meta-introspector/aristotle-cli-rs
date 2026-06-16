import Split.UmweltGodelTrust_MaximalUmwelt_shadow_types
import Split.HMul_hMul
import Split.Mathlib_Meta_NormNum_isNat_eq_true
import Split.of_decide_eq_true
import Split.UmweltGodelTrust_DMZLayer_bedrock_trust
import Split.HSub_hSub
import Split.UmweltGodelTrust_instFintypeDMZLayer
import Split.Fintype_card
import Split.UmweltGodelTrust_loopSuccessor
import Split.id
import Split.instDecidableEqBool
import Split.instSubNat
import Split.instMulNat
import Split.instOfNatNat
import Split.Mathlib_Meta_NormNum_isNat_ofNat
import Split.UmweltGodelTrust_trustworthy
import Split.UmweltGodelTrust_MaximalUmwelt_conj_classes
import Split.Nat_instAddMonoidWithOne
import Split.UmweltGodelTrust_niemeier_count
import Split.UmweltGodelTrust_dmzUmwelt
import Split.Bool_true
import Split.UmweltGodelTrust_DMZLayer_grade0_void
import Split.UmweltGodelTrust_MaximalUmwelt_onJ_types
import Split.instHAdd
import Split.And
import Split.instHSub
import Split.Distrib_toMul
import Split.HAdd_hAdd
import Split.UmweltGodelTrust_jCoeff
import Split.NonAssocSemiring_toNonUnitalNonAssocSemiring
import Split.Nat
import Split.And_intro
import Split.Finset_card
import Split.Bool
import Split.Mathlib_Meta_NormNum_isNat_mul
import Split.NonUnitalNonAssocSemiring_toDistrib
import Split.instAddNat
import Split.Nat_instSemiring
import Split.Eq_refl
import Split.instDecidableEqNat
import Split.UmweltGodelTrust_instDecidableEqDMZLayer
import Split.OfNat_ofNat
import Split.UmweltGodelTrust_DMZLayer
import Split.Decidable_decide
import Split.Semiring_toNonAssocSemiring
import Split.Eq
import Split.UmweltGodelTrust_SSP_card
import Split.UmweltGodelTrust_layerDimension
import Split.UmweltGodelTrust_SSP
import Split.rfl
import Split.UmweltGodelTrust_MaximalUmwelt_genus_zero
import Split.instHMul
import Split.UmweltGodelTrust_dmzTrust

-- UmweltGodelTrust.architecture_consistent from environment
-- theorem UmweltGodelTrust.architecture_consistent : And (Eq.{1} Nat (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (UmweltGodelTrust.MaximalUmwelt.onJ_types UmweltGodelTrust.dmzUmwelt) (UmweltGodelTrust.MaximalUmwelt.shadow_types UmweltGodelTrust.dmzUmwelt)) UmweltGodelTrust.niemeier_count) (And (Eq.{1} Nat (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) (UmweltGodelTrust.MaximalUmwelt.conj_classes UmweltGodelTrust.dmzUmwelt) (UmweltGodelTrust.MaximalUmwelt.genus_zero UmweltGodelTrust.dmzUmwelt)) (UmweltGodelTrust.MaximalUmwelt.shadow_types UmweltGodelTrust.dmzUmwelt)) (And (Eq.{1} Nat (UmweltGodelTrust.jCoeff (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)) (OfNat.ofNat.{0} Nat 196883 (instOfNatNat 196883)))) (And (Eq.{1} Nat (UmweltGodelTrust.jCoeff (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (OfNat.ofNat.{0} Nat 196560 (instOfNatNat 196560)) (OfNat.ofNat.{0} Nat 300 (instOfNatNat 300))) (OfNat.ofNat.{0} Nat 24 (instOfNatNat 24)))) (And (Eq.{1} Nat (Finset.card.{0} Nat UmweltGodelTrust.SSP) (OfNat.ofNat.{0} Nat 15 (instOfNatNat 15))) (And (Eq.{1} Nat (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47)) (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59))) (OfNat.ofNat.{0} Nat 71 (instOfNatNat 71))) (OfNat.ofNat.{0} Nat 196883 (instOfNatNat 196883))) (And (Eq.{1} Bool (UmweltGodelTrust.trustworthy UmweltGodelTrust.dmzTrust) Bool.true) (And (Eq.{1} UmweltGodelTrust.DMZLayer (UmweltGodelTrust.loopSuccessor (UmweltGodelTrust.loopSuccessor (UmweltGodelTrust.loopSuccessor (UmweltGodelTrust.loopSuccessor (UmweltGodelTrust.loopSuccessor (UmweltGodelTrust.loopSuccessor UmweltGodelTrust.DMZLayer.grade0_void)))))) UmweltGodelTrust.DMZLayer.grade0_void) (And (Eq.{1} Nat (Fintype.card.{0} UmweltGodelTrust.DMZLayer UmweltGodelTrust.instFintypeDMZLayer) (OfNat.ofNat.{0} Nat 6 (instOfNatNat 6))) (And (Eq.{1} Nat (UmweltGodelTrust.layerDimension UmweltGodelTrust.DMZLayer.grade0_void) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))) (Eq.{1} Nat (UmweltGodelTrust.layerDimension UmweltGodelTrust.DMZLayer.bedrock_trust) (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))))))))))))

-- Stub: this file represents the declaration `UmweltGodelTrust.architecture_consistent`.
-- In a full split, the body would be extracted from the environment.
