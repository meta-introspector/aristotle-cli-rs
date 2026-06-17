import Split.Eq_mpr
import Split.CauSeq_instLTAbs
import Split.Real
import Split.abs
import Split.congrArg
import Split.IsAbsoluteValue_abs_isAbsoluteValue
import Split.Iff_rfl
import Split.Rat
import Split.CauSeq_Completion_Cauchy
import Split.Rat_linearOrder
import Split.Real_instLT
import Split.Real_ofCauchy
import Split.id
import Split.Rat_instLattice
import Split.Rat_instDivisionRing
import Split.DivisionRing_toRing
import Split.Quotient_mk
import Split.Iff
import Split.Rat_instField
import Split.LT_lt
import Split.CauSeq
import Split.Rat_instIsStrictOrderedRing
import Split.CauSeq_equiv
import Split.Rat_addGroup
import Split.Eq
import Split.Quotient_liftOn₂

-- Real.lt_cauchy from environment
-- theorem Real.lt_cauchy : forall {f : CauSeq.{0, 0} Rat Rat.instField Rat.linearOrder Rat.instIsStrictOrderedRing Rat (DivisionRing.toRing.{0} Rat Rat.instDivisionRing) (abs.{0} Rat Rat.instLattice Rat.addGroup)} {g : CauSeq.{0, 0} Rat Rat.instField Rat.linearOrder Rat.instIsStrictOrderedRing Rat (DivisionRing.toRing.{0} Rat Rat.instDivisionRing) (abs.{0} Rat Rat.instLattice Rat.addGroup)}, Iff (LT.lt.{0} Real Real.instLT (Real.ofCauchy (Quotient.mk.{1} (CauSeq.{0, 0} Rat Rat.instField Rat.linearOrder Rat.instIsStrictOrderedRing Rat (DivisionRing.toRing.{0} Rat Rat.instDivisionRing) (abs.{0} Rat Rat.instLattice Rat.addGroup)) (CauSeq.equiv.{0, 0} Rat Rat Rat.instField Rat.linearOrder Rat.instIsStrictOrderedRing (DivisionRing.toRing.{0} Rat Rat.instDivisionRing) (abs.{0} Rat Rat.instLattice Rat.addGroup) (IsAbsoluteValue.abs_isAbsoluteValue.{0} Rat (DivisionRing.toRing.{0} Rat Rat.instDivisionRing) Rat.linearOrder Rat.instIsStrictOrderedRing)) f)) (Real.ofCauchy (Quotient.mk.{1} (CauSeq.{0, 0} Rat Rat.instField Rat.linearOrder Rat.instIsStrictOrderedRing Rat (DivisionRing.toRing.{0} Rat Rat.instDivisionRing) (abs.{0} Rat Rat.instLattice Rat.addGroup)) (CauSeq.equiv.{0, 0} Rat Rat Rat.instField Rat.linearOrder Rat.instIsStrictOrderedRing (DivisionRing.toRing.{0} Rat Rat.instDivisionRing) (abs.{0} Rat Rat.instLattice Rat.addGroup) (IsAbsoluteValue.abs_isAbsoluteValue.{0} Rat (DivisionRing.toRing.{0} Rat Rat.instDivisionRing) Rat.linearOrder Rat.instIsStrictOrderedRing)) g))) (LT.lt.{0} (CauSeq.{0, 0} Rat Rat.instField Rat.linearOrder Rat.instIsStrictOrderedRing Rat (DivisionRing.toRing.{0} Rat Rat.instDivisionRing) (abs.{0} Rat Rat.instLattice Rat.addGroup)) (CauSeq.instLTAbs.{0} Rat Rat.instField Rat.linearOrder Rat.instIsStrictOrderedRing) f g)

-- Stub: this file represents the declaration `Real.lt_cauchy`.
-- In a full split, the body would be extracted from the environment.
