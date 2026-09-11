import RequestProject.Gvcs.TechTree.Slice
import RequestProject.Gvcs.Steampunk.Stonehenge

/-!
# The observatory: standing infrastructure, and what it is honestly worth

A megalithic observatory is not an ordinary node.  Its value is not consumed
once: it is a service that stands, and that other nodes may consult.  §3a asks
for three outputs, and this file gives each one a definition and a theorem:

1. **Timing and calendar.**  `observatoryTime` maps a day number to a season by
   the quarter days the sightlines mark.  `observatoryTime_periodic` — the
   signal repeats with the year; `observatoryTime_quarters` — the four quarter
   days read as the four seasons; `observatoryTime_total` — every day of the
   year gets an answer.
2. **A coordinate and survey reference.**  `observatoryBearing` is the marker's
   hole on a ring of fifty-six, stepped three a year.  `observatory_survey_full`
   — the marker stands in every one of the fifty-six holes before repeating, so
   the ring is a genuine reference frame and not a handful of directions; it is
   `Steampunk.aubrey_full_cycle` applied here.
3. **A cost reduction for other nodes**, which is where the honesty is needed.

## Is it a dependency or an optimisation?  An optimisation, and a dear one.

* `observatory_not_a_tool` — no node in the slice catalogue lists the
  observatory among its tools, so nothing is gated on it.
* `slice_selfHosting_without_observatory` and `observatory_never_required` —
  the slice is self-hosting with it and without it.
* `observatory_costs_labor_in_the_slice` — and within the slice it is a **net
  loss**: 653 units of labour with it against 553 without.  It saves twenty
  units on final assembly and costs a hundred and twenty to raise.
* `observatory_breaks_even_at_six` — it pays for itself on the sixth machine
  and not before.

Exactly one node in the slice takes a discount, `complete_machine`, and it
takes it for a stated reason: setting the machine square and level against a
fixed survey reference instead of striking a baseline from scratch.  A blanket
discount, on the grounds that the observatory is thematically central, would be
the same unearned move the exceptions list exists to prevent.
-/

namespace LifeTrac
namespace TechTree

/-! ## The calendar oracle -/

/-- The four seasons the sightlines divide the year into. -/
inductive Season where
  /-- Equinox to solstice, days 80–171. -/
  | spring : Season
  /-- Midsummer to the autumn equinox, days 172–265. -/
  | summer : Season
  /-- Equinox to midwinter, days 266–354. -/
  | autumn : Season
  /-- Midwinter to the spring equinox. -/
  | winter : Season
  deriving DecidableEq, Repr, Inhabited

/-- Days in the calendar year the observatory keeps. -/
def yearDays : ℕ := 365

/-- **The timing and calendar query.**  Which season day `d` falls in, read off
the quarter days the stones mark. -/
def observatoryTime (d : ℕ) : Season :=
  let k := d % yearDays
  if k < 80 then .winter
  else if k < 172 then .spring
  else if k < 266 then .summer
  else if k < 355 then .autumn
  else .winter

/-- **The calendar signal repeats with the year.** -/
theorem observatoryTime_periodic (d : ℕ) : observatoryTime (d + yearDays) = observatoryTime d := by
  simp [observatoryTime, Nat.add_mod_right]

/-- The four quarter days read as the four seasons: spring equinox, midsummer,
autumn equinox, midwinter. -/
theorem observatoryTime_quarters :
    observatoryTime 80 = Season.spring ∧ observatoryTime 172 = Season.summer ∧
      observatoryTime 266 = Season.autumn ∧ observatoryTime 355 = Season.winter := by
  refine ⟨by decide, by decide, by decide, by decide⟩

set_option maxRecDepth 20000 in
/-- Every day of the year gets an answer, and the seasons partition the year. -/
theorem observatoryTime_total :
    ((List.range yearDays).filter (fun d => observatoryTime d == Season.winter)).length +
      ((List.range yearDays).filter (fun d => observatoryTime d == Season.spring)).length +
      ((List.range yearDays).filter (fun d => observatoryTime d == Season.summer)).length +
      ((List.range yearDays).filter (fun d => observatoryTime d == Season.autumn)).length
        = yearDays := by
  decide

/-! ## The survey reference -/

/-- Holes in the reference ring. -/
def surveyHoles : ℕ := Steampunk.aubreyHoles

/-- **The coordinate query.**  The hole the marker stands in after `y` years,
stepped three holes a year: a fixed, shared reference frame that other
construction nodes can sight against instead of deriving their own. -/
def observatoryBearing (y : ℕ) : ZMod surveyHoles := ((y * Steampunk.aubreyStep : ℕ) : ZMod surveyHoles)

/-- **The reference frame is genuinely a frame.**  The marker stands in every
one of the fifty-six holes before it repeats — this is
`Steampunk.aubrey_full_cycle`, which is proved from `gcd(3, 56) = 1`. -/
theorem observatory_survey_full :
    (∀ y ∈ Finset.Ico 1 surveyHoles, observatoryBearing y ≠ observatoryBearing 0) ∧
      observatoryBearing surveyHoles = observatoryBearing 0 := by
  have h := Steampunk.aubrey_full_cycle
  constructor
  · intro y hy
    simpa [observatoryBearing, surveyHoles] using h.1 y hy
  · simp [observatoryBearing, surveyHoles]

/-! ## Dependency or optimisation -/

/-- **Nothing is gated on the observatory.**  No node in the catalogue lists it
as a tool, so no step can fail for want of a survey reference. -/
theorem observatory_not_a_tool : ∀ t ∈ sliceCatalog, observatoryId ∉ t.tools := by decide

/-- The slice with the observatory left out is still valid. -/
theorem sliceNoObs_valid : ValidSequence sliceSeqNoObs rawSite := by decide

/-- **And still self-hosting.** -/
theorem slice_selfHosting_without_observatory :
    SelfHosting sliceSeqNoObs rawSite BootstrapExceptions := by decide

/-- **The observatory is never required** (§3a.3), for this slice: the tree is
self-hosting with it and without it.  The statement is about this sequence,
proved by running both; it is not a claim about every possible sequence, and it
would be false for one whose labour budget was tight enough that the
observatory's own hundred and twenty units broke it. -/
theorem observatory_never_required :
    SelfHosting sliceSeq rawSite BootstrapExceptions ↔
      SelfHosting sliceSeqNoObs rawSite BootstrapExceptions :=
  iff_of_true slice_selfHosting slice_selfHosting_without_observatory

/-- **And within the slice it does not pay.**  A hundred more units of labour
with it than without. -/
theorem observatory_costs_labor_in_the_slice :
    totalLabor rawSite sliceSeqNoObs + 100 = totalLabor rawSite sliceSeq := by decide

theorem slice_labor_figures :
    totalLabor rawSite sliceSeq = 653 ∧ totalLabor rawSite sliceSeqNoObs = 553 := by
  refine ⟨by decide, by decide⟩

/-- What raising the observatory costs. -/
def observatoryLabor : ℕ := observatory.baseLabor

/-- What final assembly costs with and without it. -/
def machineLabor : ℕ := completeMachine.baseLabor

/-- What final assembly costs with it. -/
def machineLaborDiscounted : ℕ := completeMachine.baseLabor - completeMachine.obsDiscount

/-- **It pays for itself on the sixth machine, and not before.**  Twenty units
saved per assembly against a hundred and twenty to raise. -/
theorem observatory_breaks_even_at_six (k : ℕ) :
    observatoryLabor + k * machineLaborDiscounted ≤ k * machineLabor ↔ 6 ≤ k := by
  simp only [observatoryLabor, machineLabor, machineLaborDiscounted, observatory,
    completeMachine]
  omega

/-- Only one node in the slice takes the discount, and it is the one that
sights against the reference frame. -/
theorem only_assembly_is_discounted :
    ∀ t ∈ sliceCatalog, 0 < t.obsDiscount → t.id = "complete_machine" := by decide

end TechTree
end LifeTrac
