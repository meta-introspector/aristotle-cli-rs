import Split.Real
import Split.Real_rec
import Split.abs
import Split.IsAbsoluteValue_abs_isAbsoluteValue
import Split.Rat
import Split.CauSeq_Completion_Cauchy
import Split.Rat_linearOrder
import Split.Real_ofCauchy
import Split.Rat_instLattice
import Split.Rat_instDivisionRing
import Split.DivisionRing_toRing
import Split.Rat_instField
import Split.Rat_instIsStrictOrderedRing
import Split.Rat_addGroup

-- Real.casesOn from environment
-- def Real.casesOn : forall {motive : Real -> Sort.{u}} (t : Real), (forall (cauchy : CauSeq.Completion.Cauchy.{0, 0} Rat Rat.instField Rat.linearOrder Rat.instIsStrictOrderedRing Rat (DivisionRing.toRing.{0} Rat Rat.instDivisionRing) (abs.{0} Rat Rat.instLattice Rat.addGroup) (IsAbsoluteValue.abs_isAbsoluteValue.{0} Rat (DivisionRing.toRing.{0} Rat Rat.instDivisionRing) Rat.linearOrder Rat.instIsStrictOrderedRing)), motive (Real.ofCauchy cauchy)) -> (motive t)
-- (definition body omitted)

-- Stub: this file represents the declaration `Real.casesOn`.
-- In a full split, the body would be extracted from the environment.
