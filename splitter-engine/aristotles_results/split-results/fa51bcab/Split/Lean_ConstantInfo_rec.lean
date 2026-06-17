import Split.Lean_ConstantInfo_recInfo
import Split.Lean_ConstantInfo_defnInfo
import Split.Lean_ConstructorVal
import Split.Lean_QuotVal
import Split.Lean_ConstantInfo_inductInfo
import Split.Lean_ConstantInfo_opaqueInfo
import Split.Lean_ConstantInfo_thmInfo
import Split.Lean_ConstantInfo_axiomInfo
import Split.Lean_OpaqueVal
import Split.Lean_ConstantInfo_ctorInfo
import Split.Lean_RecursorVal
import Split.Lean_ConstantInfo_quotInfo
import Split.Lean_ConstantInfo
import Split.Lean_DefinitionVal
import Split.Lean_TheoremVal
import Split.Lean_InductiveVal
import Split.Lean_AxiomVal

-- Lean.ConstantInfo.rec from environment
-- recursor Lean.ConstantInfo.rec : forall {motive : Lean.ConstantInfo -> Sort.{u}}, (forall (val : Lean.AxiomVal), motive (Lean.ConstantInfo.axiomInfo val)) -> (forall (val : Lean.DefinitionVal), motive (Lean.ConstantInfo.defnInfo val)) -> (forall (val : Lean.TheoremVal), motive (Lean.ConstantInfo.thmInfo val)) -> (forall (val : Lean.OpaqueVal), motive (Lean.ConstantInfo.opaqueInfo val)) -> (forall (val : Lean.QuotVal), motive (Lean.ConstantInfo.quotInfo val)) -> (forall (val : Lean.InductiveVal), motive (Lean.ConstantInfo.inductInfo val)) -> (forall (val : Lean.ConstructorVal), motive (Lean.ConstantInfo.ctorInfo val)) -> (forall (val : Lean.RecursorVal), motive (Lean.ConstantInfo.recInfo val)) -> (forall (t : Lean.ConstantInfo), motive t)

-- Stub: this file represents the declaration `Lean.ConstantInfo.rec`.
-- In a full split, the body would be extracted from the environment.
