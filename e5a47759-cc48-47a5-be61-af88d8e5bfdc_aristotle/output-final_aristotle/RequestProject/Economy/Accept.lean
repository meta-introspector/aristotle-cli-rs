/-
# The accepted state

`globallyCompatible : Prop` is not a verification obligation: `True` inhabits
it.  Every field of `AcceptedState` below is a *proof of a named predicate
applied to this particular reconstruction*, and the running system decides
acceptance with `accepts`, a `Bool`, whose meaning is fixed by
`accepts_sound`.

What acceptance means: the state satisfies these formal predicates, under the
stated cryptographic and measurement assumptions.  What it does not mean: that
the state is physically true.
-/
import RequestProject.Economy.Evidence
import RequestProject.Economy.Quorum

namespace RequestProject.Economy

namespace Account

/-- The value of one account line. -/
def lineValue (a : Account) : Line → ℚ
  | Line.openingStock => a.openingStock.value
  | Line.production => a.production.value
  | Line.imports => a.imports.value
  | Line.otherSupply => a.otherSupply.value
  | Line.exports => a.exports.value
  | Line.intermediateUse => a.intermediateUse.value
  | Line.finalConsumption => a.finalConsumption.value
  | Line.losses => a.losses.value
  | Line.otherDisposition => a.otherDisposition.value
  | Line.closingStock => a.closingStock.value

/-- The account read as an assignment of values to cells. -/
def valueAt (a : Account) (c : Cell) : ℚ :=
  if c.commodity = a.commodity ∧ c.region = a.region ∧ c.period = a.period then
    a.lineValue c.line
  else 0

end Account

namespace IntervalAccount

/-- `Selects` as a single decidable proposition, so the checker can run. -/
def SelectsProp (A : IntervalAccount) (a : Account) : Prop :=
  a.commodity = A.commodity ∧ a.region = A.region ∧ a.period = A.period ∧
  a.openingStock ∈ A.openingStock ∧ a.production ∈ A.production ∧ a.imports ∈ A.imports ∧
  a.otherSupply ∈ A.otherSupply ∧ a.exports ∈ A.exports ∧
  a.intermediateUse ∈ A.intermediateUse ∧ a.finalConsumption ∈ A.finalConsumption ∧
  a.losses ∈ A.losses ∧ a.otherDisposition ∈ A.otherDisposition ∧
  a.closingStock ∈ A.closingStock ∧ (0 : Qty Dim.mass) ∈ A.unattributedResidual

theorem selects_iff (A : IntervalAccount) (a : Account) : A.Selects a ↔ A.SelectsProp a := by
  constructor
  · intro h
    exact ⟨h.commodity, h.region, h.period, h.openingStock, h.production, h.imports,
      h.otherSupply, h.exports, h.intermediateUse, h.finalConsumption, h.losses,
      h.otherDisposition, h.closingStock, h.unattributedResidual⟩
  · rintro ⟨h1, h2, h3, h4, h5, h6, h7, h8, h9, h10, h11, h12, h13, h14⟩
    exact ⟨h1, h2, h3, h4, h5, h6, h7, h8, h9, h10, h11, h12, h13, h14⟩

instance (A : IntervalAccount) (a : Account) : Decidable (A.SelectsProp a) := by
  unfold SelectsProp; infer_instance

instance (A : IntervalAccount) (a : Account) : Decidable (A.Selects a) :=
  decidable_of_iff _ (selects_iff A a).symm

end IntervalAccount

/-- Everything a published reconstruction consists of. -/
structure Reconstruction where
  /-- The local reports, one per site. -/
  cover : Cover
  /-- The cells the reconstruction claims to cover. -/
  cells : List Cell
  /-- Site identifier to the artifact it was extracted from. -/
  dossier : String → Option Artifact
  /-- The uncertainty-carrying account. -/
  intervalAccount : IntervalAccount
  /-- The point account published as the reconstruction. -/
  account : Account

namespace Reconstruction

/-- Every claimed cell is constrained by at least one report. -/
def SufficientCoverage (R : Reconstruction) : Prop :=
  ∀ c ∈ R.cells, constraintsAt R.cover c ≠ []

/-- Every report names an artifact in the dossier. -/
def CompleteProvenance (R : Reconstruction) : Prop :=
  ∀ s ∈ R.cover, (R.dossier s.site).isSome = true

instance (R : Reconstruction) : Decidable R.SufficientCoverage := by
  unfold SufficientCoverage; infer_instance

instance (R : Reconstruction) : Decidable R.CompleteProvenance := by
  unfold CompleteProvenance; infer_instance

instance (R : Reconstruction) : Decidable (IsGlobalSection R.cover R.cells R.account.valueAt) := by
  unfold IsGlobalSection; infer_instance

end Reconstruction

/-- **An accepted reconstruction.** Each field is a proof about *this*
reconstruction; none of them is an unparameterised `Prop`. -/
structure AcceptedState {NodeId : Type*} [DecidableEq NodeId] {com : Committee NodeId}
    {Signs : NodeId → StateHash → Prop} (R : Reconstruction) (cert : Certificate com Signs)
    (hashOf : Account → StateHash) where
  /-- The published point account is one of the possibilities the interval
  account declares. -/
  selects : R.intervalAccount.Selects R.account
  /-- Zero is a possible residual: the account balances within its own declared
  precision. -/
  balanced : R.intervalAccount.IntervalBalanced
  /-- The account is a global section of the cover over the claimed cells. -/
  glued : IsGlobalSection R.cover R.cells R.account.valueAt
  /-- No claimed cell rests on no evidence. -/
  covered : R.SufficientCoverage
  /-- Every report is traceable to an artifact. -/
  provenance : R.CompleteProvenance
  /-- The certificate is for this state. -/
  certified : cert.state = hashOf R.account

/-- The decidable acceptance check the running system performs. -/
def accepts (R : Reconstruction) (certState : StateHash) (hashOf : Account → StateHash) : Bool :=
  decide (R.intervalAccount.Selects R.account) &&
  decide R.intervalAccount.IntervalBalanced &&
  decide (IsGlobalSection R.cover R.cells R.account.valueAt) &&
  decide R.SufficientCoverage &&
  decide R.CompleteProvenance &&
  decide (certState = hashOf R.account)

/-- **Soundness of the check.** If `accepts` says yes for the state a
certificate carries, the reconstruction really satisfies every predicate. -/
theorem accepts_sound {NodeId : Type*} [DecidableEq NodeId] {com : Committee NodeId}
    {Signs : NodeId → StateHash → Prop} (R : Reconstruction) (cert : Certificate com Signs)
    (hashOf : Account → StateHash) (h : accepts R cert.state hashOf = true) :
    Nonempty (AcceptedState R cert hashOf) := by
  simp only [accepts, Bool.and_eq_true, decide_eq_true_eq] at h
  obtain ⟨⟨⟨⟨⟨h1, h2⟩, h3⟩, h4⟩, h5⟩, h6⟩ := h
  exact ⟨{ selects := h1, balanced := h2, glued := h3, covered := h4, provenance := h5,
           certified := h6 }⟩

/-- …and completeness: an accepted state passes the check. -/
theorem accepts_complete {NodeId : Type*} [DecidableEq NodeId] {com : Committee NodeId}
    {Signs : NodeId → StateHash → Prop} {R : Reconstruction} {cert : Certificate com Signs}
    {hashOf : Account → StateHash} (h : AcceptedState R cert hashOf) :
    accepts R cert.state hashOf = true := by
  simp only [accepts, Bool.and_eq_true, decide_eq_true_eq]
  exact ⟨⟨⟨⟨⟨h.selects, h.balanced⟩, h.glued⟩, h.covered⟩, h.provenance⟩, h.certified⟩

/-- What a reconstruction is labelled when it is not accepted.  A failure is a
published result with a reason, not an absence of output. -/
inductive Verdict where
  | accepted
  | inconsistent (cell : Cell)
  | insufficientCoverage
  | unbalanced
  | notASection
  | provenanceIncomplete
  | certificateRejected
deriving Repr, DecidableEq

/-- Classify a reconstruction, reporting the first failure found. -/
def classify (R : Reconstruction) (certState : StateHash) (hashOf : Account → StateHash) :
    Verdict :=
  match R.cells.find? (fun c => glue R.cover c == GluingResult.inconsistent) with
  | some c => Verdict.inconsistent c
  | none =>
      if ¬ R.SufficientCoverage then Verdict.insufficientCoverage
      else if ¬ R.CompleteProvenance then Verdict.provenanceIncomplete
      else if ¬ (R.intervalAccount.Selects R.account ∧ R.intervalAccount.IntervalBalanced) then
        Verdict.unbalanced
      else if ¬ IsGlobalSection R.cover R.cells R.account.valueAt then Verdict.notASection
      else if certState ≠ hashOf R.account then Verdict.certificateRejected
      else Verdict.accepted

/-- The classification agrees with the check: a verdict of `accepted` means the
decidable check passes, hence an `AcceptedState` exists. -/
theorem classify_accepted {R : Reconstruction} {certState : StateHash}
    {hashOf : Account → StateHash} (h : classify R certState hashOf = Verdict.accepted) :
    accepts R certState hashOf = true := by
  unfold classify at h
  split at h
  · exact absurd h (by simp)
  · rename_i hfind
    by_cases h1 : R.SufficientCoverage
    · rw [if_neg (by simpa using h1)] at h
      by_cases h2 : R.CompleteProvenance
      · rw [if_neg (by simpa using h2)] at h
        by_cases h3 : R.intervalAccount.Selects R.account ∧ R.intervalAccount.IntervalBalanced
        · rw [if_neg (by simpa using h3)] at h
          by_cases h4 : IsGlobalSection R.cover R.cells R.account.valueAt
          · rw [if_neg (by simpa using h4)] at h
            by_cases h5 : certState = hashOf R.account
            · simp only [accepts, Bool.and_eq_true, decide_eq_true_eq]
              exact ⟨⟨⟨⟨⟨h3.1, h3.2⟩, h4⟩, h1⟩, h2⟩, h5⟩
            · rw [if_pos h5] at h; exact absurd h (by simp)
          · rw [if_pos (by simpa using h4)] at h; exact absurd h (by simp)
        · rw [if_pos (by simpa using h3)] at h; exact absurd h (by simp)
      · rw [if_pos (by simpa using h2)] at h; exact absurd h (by simp)
    · rw [if_pos (by simpa using h1)] at h; exact absurd h (by simp)

/-- A reconstruction that fails to glue somewhere is reported as inconsistent,
naming the cell — and the cell carries a checkable conflict witness. -/
theorem classify_inconsistent_witness {R : Reconstruction} {certState : StateHash}
    {hashOf : Account → StateHash} {c : Cell}
    (h : classify R certState hashOf = Verdict.inconsistent c) :
    ∃ a ∈ constraintsAt R.cover c, ∃ b ∈ constraintsAt R.cover c, Interval.Separated a b := by
  unfold classify at h
  split at h
  · rename_i c' hfind
    have hc : c' = c := by injection h
    subst hc
    have := List.find?_some hfind
    simp only [beq_iff_eq] at this
    exact glue_conflict_witness this
  · split_ifs at h

end RequestProject.Economy
