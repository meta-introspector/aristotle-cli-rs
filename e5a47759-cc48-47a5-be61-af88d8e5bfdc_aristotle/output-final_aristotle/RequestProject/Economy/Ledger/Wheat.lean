/-
# Ledger layer: the wheat vertical slice, checked

The milestone list of the specification, restated as theorems about the
scenario in `Economy.Data.Wheat` — including the ones that say *no*:

* `baseline_is_accepted` — the five reconcilable sites produce an
  `AcceptedState`, and the decidable check agrees;
* `inflated_reconstruction_is_rejected` — overstating production by 300 000 t
  makes the check fail, so the predicates are not vacuous;
* `disputed_has_no_global_section` — with the sixth site there is *no*
  reconstruction at all, and the published `exportsConflict` witness proves it
  in a form a third party can recheck.

Nothing here is a claim about wheat in the world.  Every statement is about
this scenario and these declared intervals.
-/
import RequestProject.Economy.Data.Wheat

namespace RequestProject.Economy
namespace Wheat

/-! ### Units, dimensions and the satellite estimate -/

/-- The satellite production interval is `area × yield`, computed. -/
theorem satelliteProduction_iv : satelliteProduction.iv = iv 3300000 4420000 (by norm_num) := by
  have h := Interval.mul_of_nonneg (a := satelliteArea.iv) (b := yieldCalibration.iv)
    (by norm_num [satelliteArea, iv]) (by norm_num [yieldCalibration, iv])
  apply Interval.ext
  · rw [show satelliteProduction.iv = satelliteArea.iv * yieldCalibration.iv from rfl, h.1]
    norm_num [satelliteArea, yieldCalibration, iv]
  · rw [show satelliteProduction.iv = satelliteArea.iv * yieldCalibration.iv from rfl, h.2]
    norm_num [satelliteArea, yieldCalibration, iv]

/-- **`theorem satellite_estimate_is_interval_valid`.**  Acreage times yield is
a mass — the dimensions multiply — and the resulting interval encloses every
product of an admissible area with an admissible yield.  It does *not* say the
calibration is correct: the yield interval is an assumption with provenance. -/
theorem satellite_estimate_is_interval_valid :
    (∀ (a : Qty Dim.area) (y : Qty Dim.yield),
        a ∈ satelliteArea → y ∈ yieldCalibration → Qty.harvest a y ∈ satelliteProduction) ∧
      satelliteProduction.iv = iv 3300000 4420000 (by norm_num) :=
  ⟨fun _ _ ha hy => IQty.harvest_mem ha hy, satelliteProduction_iv⟩

/-- **`theorem units_are_compatible`.**  The lines of the account are all
masses and add at that single dimension; area and yield are different
dimensions whose product is mass.  The inequalities are what stops a volume or
a currency being added to a mass. -/
theorem units_are_compatible :
    Dim.area * Dim.yield = Dim.mass ∧ Dim.area ≠ Dim.mass ∧ Dim.currency ≠ Dim.mass :=
  ⟨Dim.area_mul_yield, by decide, Dim.currency_ne_mass⟩

/-! ### Periods -/

/-- **`theorem periods_are_aligned`.**  The four quarters are a consecutive
decomposition of 2023: pairwise disjoint, so no day is counted twice, and their
lengths sum to the 365 days of the year. -/
theorem periods_are_aligned :
    Period.Chain q1 quarters ∧
      List.Pairwise Period.Disjoint (q1 :: quarters) ∧
      q1.days + (quarters.map Period.days).sum = 365 := by
  have hchain : Period.Chain q1 quarters := ⟨rfl, rfl, rfl, trivial⟩
  refine ⟨hchain, Period.chain_pairwise_disjoint hchain, ?_⟩
  have := Period.chain_days_sum hchain
  simp [Period.lastStop, quarters, q1, q2, q3, q4, Period.days] at this ⊢

/-! ### Provenance -/

/-- **`theorem observations_have_provenance`.**  Every local report is traceable
to an artifact in the dossier.  A hash and a licence string are recorded per
artifact; neither makes the source truthful. -/
theorem observations_have_provenance : reconstruction.CompleteProvenance := by
  intro s hs
  simp only [reconstruction, baselineCover, List.mem_cons, List.not_mem_nil, or_false] at hs
  rcases hs with rfl | rfl | rfl | rfl | rfl <;> rfl

/-! ### Compatibility and gluing -/

/-- **`theorem local_sections_are_compatible`.**  On every cell the reports of
the five baseline sites pairwise overlap. -/
theorem local_sections_are_compatible : ∀ c ∈ cells, CompatibleAt baselineCover c := by
  intro c hc
  fin_cases hc <;>
    simp [CompatibleAt, constraintsAt, baselineCover, faoSection, satelliteSection,
      customsSection, osmSection, fieldSection, LocalSection.value?, cell, iv, Interval.Overlaps,
      satelliteProduction_iv] <;>
    norm_num

/-- **`theorem trade_flows_are_accounted`.**  The two independent trade sources
glue to the intersection `[950 000, 1 000 000]`, and the published export
figure lies in it. -/
theorem trade_flows_are_accounted :
    ∃ I, glue baselineCover (cell Line.exports) = GluingResult.glued I ∧
      (∀ x : ℚ, x ∈ I ↔ (950000 ≤ x ∧ x ≤ 1000000)) ∧
      account.valueAt (cell Line.exports) ∈ I := by
  have hpair : ∀ a ∈ constraintsAt baselineCover (cell Line.exports),
      ∀ b ∈ constraintsAt baselineCover (cell Line.exports), Interval.Overlaps a b :=
    local_sections_are_compatible _ (by simp [cells])
  have hlist : constraintsAt baselineCover (cell Line.exports)
      = [iv 900000 1000000 (by norm_num), iv 950000 1050000 (by norm_num)] := rfl
  rw [hlist] at hpair
  obtain ⟨I, hI⟩ := glueAt_glued_of_pairwise hpair
  refine ⟨I, by rw [glue, hlist]; exact hI, ?_, ?_⟩
  · intro x
    rw [glueAt_glued_iff hI x]
    simp only [List.mem_cons, List.not_mem_nil, or_false, forall_eq_or_imp, forall_eq, iv,
      Interval.mem_iff]
    constructor
    · rintro ⟨⟨a1, a2⟩, b1, b2⟩
      exact ⟨by linarith, by linarith⟩
    · rintro ⟨h1, h2⟩
      exact ⟨⟨by linarith, by linarith⟩, by linarith, by linarith⟩
  · rw [glueAt_glued_iff hI]
    simp only [List.mem_cons, List.not_mem_nil, or_false, forall_eq_or_imp, forall_eq, iv,
      Interval.mem_iff]
    norm_num [Account.valueAt, Account.lineValue, account, cell]

/-! ### Accounting -/

/-- The published point account is one of the possibilities the interval
account declares. -/
theorem account_selects : intervalAccount.Selects account :=
  (IntervalAccount.selects_iff _ _).mpr <| by
    refine ⟨rfl, rfl, rfl, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩ <;>
      norm_num [intervalAccount, account, iv]

/-- **`theorem account_balance_is_verified`.**  The identity holds exactly for
the published point account; therefore zero lies in the residual interval of
the uncertainty-carrying account; therefore the point account balances within
the tolerance *derived* from the declared precision — a tolerance nobody had to
choose. -/
theorem account_balance_is_verified :
    account.ExactlyBalanced ∧ intervalAccount.IntervalBalanced ∧
      account.BalancedWithin intervalAccount.derivedTolerance := by
  have hexact : account.ExactlyBalanced := by
    apply Qty.ext
    norm_num [Account.residual, Account.totalSupply, Account.totalDisposition, account]
  exact ⟨hexact, IntervalAccount.intervalBalanced_of_exact account_selects hexact,
    IntervalAccount.balancedWithin_derived account_selects⟩

/-! ### Quorum -/

/-- **`theorem quorum_certificate_is_valid`.**  Any two quorums of this
committee share at least `f + 1 = 2` members; the certificate is for the
published state; and no two certificates of this committee can disagree, given
that its members do not equivocate.  None of this says the state is true. -/
theorem quorum_certificate_is_valid :
    (∀ Q₁ Q₂ : Quorum committee, committee.faultBound + 1 ≤ (Q₁.voters ∩ Q₂.voters).card) ∧
      certificate.state = hashOf account ∧
      (∀ cert₁ cert₂ : Certificate committee Signs, cert₁.state = cert₂.state) := by
  refine ⟨fun Q₁ Q₂ => Quorum.card_inter_gt_faultBound Q₁ Q₂, rfl, ?_⟩
  intro cert₁ cert₂
  have hne : NoEquivocation Signs (∅ : Finset Nat) := by
    intro v _ s t hs ht
    simp only [Signs] at hs ht
    rw [hs, ht]
  exact certificate_agreement cert₁ cert₂ ∅ (by simp) hne

/-! ### Acceptance -/

theorem baseline_is_global_section :
    IsGlobalSection baselineCover cells account.valueAt := by
  intro c hc
  fin_cases hc <;>
    simp [constraintsAt, baselineCover, faoSection, satelliteSection, customsSection,
      osmSection, fieldSection, LocalSection.value?, cell, iv, satelliteProduction_iv,
      Account.valueAt, Account.lineValue, account, Interval.mem_iff] <;>
    norm_num

theorem baseline_has_sufficient_coverage : reconstruction.SufficientCoverage := by
  intro c hc
  fin_cases hc <;>
    exact fun h => by
      simp [reconstruction, constraintsAt, baselineCover, faoSection, satelliteSection,
        customsSection, osmSection, fieldSection, LocalSection.value?, cell, iv] at h

/-- **The accepted state.**  Every field is a proof about this reconstruction:
the point account is selected from the declared intervals, zero is a possible
residual, the account is a global section of the cover, every claimed cell rests
on evidence, every report is traceable, and the certificate is for this state. -/
def baselineAccepted : AcceptedState reconstruction certificate hashOf :=
  { selects := account_selects
    balanced := account_balance_is_verified.2.1
    glued := baseline_is_global_section
    covered := baseline_has_sufficient_coverage
    provenance := observations_have_provenance
    certified := rfl }

/-- …and the decidable check the running system performs agrees. -/
theorem baseline_is_accepted : accepts reconstruction certificate.state hashOf = true :=
  accepts_complete baselineAccepted

/-! ### The check can say no

Each guard below shows that an acceptance field is not vacuous: it fails for a
deliberately wrong account.
-/

theorem inflated_account_is_not_balanced : ¬ inflatedAccount.ExactlyBalanced := by
  intro h
  have := congrArg Qty.value h
  norm_num [Account.residual, Account.totalSupply, Account.totalDisposition, inflatedAccount,
    account] at this

theorem inflated_account_is_not_selected : ¬ intervalAccount.Selects inflatedAccount := by
  intro h
  have := h.production
  norm_num [intervalAccount, inflatedAccount, account, iv] at this

theorem inflated_reconstruction_is_not_accepted :
    ¬ Nonempty (AcceptedState inflatedReconstruction certificate hashOf) := by
  rintro ⟨h⟩
  exact inflated_account_is_not_selected h.selects

theorem inflated_reconstruction_is_rejected :
    accepts inflatedReconstruction certificate.state hashOf = false := by
  rw [Bool.eq_false_iff]
  intro h
  exact inflated_reconstruction_is_not_accepted
    (accepts_sound inflatedReconstruction certificate hashOf h)

/-- A report from a site with no artifact in the dossier fails the provenance
field, so `provenance` is not vacuous either. -/
theorem unlisted_site_fails_provenance :
    ¬ ({ reconstruction with
          cover := baselineCover ++ [{ site := "unknown-site", constraints := [] }]
        } : Reconstruction).CompleteProvenance := by
  intro h
  have := h { site := "unknown-site", constraints := [] } (by simp)
  simp [reconstruction, dossier] at this

/-- A claimed cell that no report constrains fails the coverage field: here the
maize production of the same basin, which no site reports. -/
theorem uncovered_cell_fails_coverage :
    ¬ ({ reconstruction with
          cells := cells ++ [⟨Commodity.maize, basin, year2023, Line.production⟩]
        } : Reconstruction).SufficientCoverage := by
  intro h
  have := h ⟨Commodity.maize, basin, year2023, Line.production⟩ (by simp)
  exact this (by decide)

/-! ### The negative result

With the mirror-trade site added, the reports on exports are separated.  There
is then no reconstruction at all — not a widened interval, not an average.
-/

/-- The published conflict: customs against the mirror estimate. -/
def exportsConflict : ConflictWitness :=
  { cell := cell Line.exports
    leftSite := "customs"
    rightSite := "mirror-trade"
    left := iv 950000 1050000 (by norm_num)
    right := iv 1200000 1300000 (by norm_num)
    separated := Or.inr (by norm_num [iv]) }

/-- The witness is sound: no export figure satisfies both reports. -/
theorem exportsConflict_sound : ¬ ∃ x, x ∈ exportsConflict.left ∧ x ∈ exportsConflict.right :=
  conflictWitness_sound exportsConflict

/-- Both conflicting intervals really are among the constraints of the disputed
cover on that cell. -/
theorem exportsConflict_is_in_cover :
    exportsConflict.left ∈ constraintsAt disputedCover (cell Line.exports) ∧
      exportsConflict.right ∈ constraintsAt disputedCover (cell Line.exports) := by
  constructor <;> simp [constraintsAt, disputedCover, baselineCover, faoSection, satelliteSection,
    customsSection, osmSection, fieldSection, mirrorSection, LocalSection.value?, cell, iv,
    exportsConflict]

/-- **The gluing fails, and reports that it failed.** -/
theorem disputed_fails_to_glue :
    glue disputedCover (cell Line.exports) = GluingResult.inconsistent := by
  have hlist : constraintsAt disputedCover (cell Line.exports)
      = [iv 900000 1000000 (by norm_num), iv 950000 1050000 (by norm_num),
         iv 1200000 1300000 (by norm_num)] := rfl
  rw [glue, hlist, glueAt, dif_neg]
  norm_num [Interval.maxLo, Interval.minHi, iv]

/-- **No global section exists.**  This is the strongest form of the negative
result: not "we could not find one", but "there is none". -/
theorem disputed_has_no_global_section :
    ¬ ∃ f : Cell → ℚ, IsGlobalSection disputedCover [cell Line.exports] f := by
  rintro ⟨f, hf⟩
  have hleft := hf (cell Line.exports) (by simp) exportsConflict.left
    exportsConflict_is_in_cover.1
  have hright := hf (cell Line.exports) (by simp) exportsConflict.right
    exportsConflict_is_in_cover.2
  exact exportsConflict_sound ⟨f (cell Line.exports), hleft, hright⟩

/-- Hence the disputed reconstruction cannot be accepted, whatever account is
published with it. -/
theorem disputed_is_not_accepted :
    ¬ Nonempty (AcceptedState disputedReconstruction certificate hashOf) := by
  rintro ⟨h⟩
  refine disputed_has_no_global_section ⟨disputedReconstruction.account.valueAt, ?_⟩
  intro c hc i hi
  rcases List.mem_singleton.mp hc with rfl
  exact h.glued (cell Line.exports) (by simp [cells, reconstruction, disputedReconstruction]) i hi

/-! ### Settlement of the paid samples -/

/-- The ten compensated samples settle at 1.2 t/ha. -/
theorem samples_settle :
    Obs.settle settlementRule samples (12/10) = Obs.SettlementOutcome.settled (12/10) := by
  rw [Obs.settle]
  rw [if_neg (by norm_num [samples, honestSamples, adversarialSamples, settlementRule])]
  rw [if_neg (by norm_num [Obs.totalWeight, samples, honestSamples, adversarialSamples,
    settlementRule])]
  rw [if_pos (by constructor <;> norm_num [Obs.totalWeight, Obs.weightAtMost, Obs.weightAtLeast,
    samples, honestSamples, adversarialSamples])]

/-- **Robust settlement.**  Three of the ten samples report 5.0 t/ha — more
than four times the honest reports — and every weighted median still lies
inside the honest range.  The weighted *mean* of the same samples does not. -/
theorem settled_yield_is_robust :
    ∀ m, Obs.IsWeightedMedian samples m → 11/10 ≤ m ∧ m ≤ 13/10 := by
  intro m hm
  refine Obs.median_mem_range (honest := honestSamples) (adv := adversarialSamples) ?_ ?_ ?_ hm
  · intro o ho
    fin_cases ho <;> norm_num
  · intro o ho
    fin_cases ho <;> norm_num
  · norm_num [Obs.totalWeight, honestSamples, adversarialSamples]

theorem mean_of_samples_is_outside_the_honest_range :
    Obs.weightedMean samples = 117/50 := by
  norm_num [Obs.weightedMean, Obs.totalWeight, samples, honestSamples, adversarialSamples]

end Wheat
end RequestProject.Economy
