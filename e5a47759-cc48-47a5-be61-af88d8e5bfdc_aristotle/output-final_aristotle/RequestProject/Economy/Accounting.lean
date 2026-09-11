/-
# Supply/disposition accounts

Definitions first: `totalSupply` and `totalDisposition` are sums, not `sorry`s,
because a balance predicate about an unknown function is vacuous.

Two balance notions, in the right order:

* `ExactlyBalanced` — the strictly stronger predicate, true of no real dataset;
* `IntervalBalanced` — `0` lies in the residual *interval* of an account whose
  lines carry their declared precision.

The tolerance is then **derived**: `derivedTolerance` is read off the residual
interval, and `balancedWithin_derived` says every point account selected from
the interval account balances within it.  Nobody has to choose a τ that makes
the data pass.

Unattributed residual is an explicit interval-valued *line* of the interval
account, not a widening of τ: grain and oil balances carry systematic
revisions, and hiding them in a tolerance hides them from the reader.
-/
import RequestProject.Economy.Regions
import RequestProject.Economy.Intervals

namespace RequestProject.Economy

/-- The commodities the model knows about.  Commodity identity is separate from
physical dimension: a mass of wheat is not a mass of crude oil, and it is the
`Account` that keeps them apart, since all of its lines refer to its single
`commodity` field. -/
inductive Commodity where
  | wheat | maize | rice | crudeOil | naturalGas | coal | electricity | steel | fertilizer
deriving DecidableEq, Repr

/-- A supply/disposition account: one commodity, one region, one period, all
lines in mass. -/
structure Account where
  commodity : Commodity
  region : RegionCode
  period : Period
  openingStock : Qty Dim.mass
  production : Qty Dim.mass
  imports : Qty Dim.mass
  otherSupply : Qty Dim.mass
  exports : Qty Dim.mass
  intermediateUse : Qty Dim.mass
  finalConsumption : Qty Dim.mass
  losses : Qty Dim.mass
  otherDisposition : Qty Dim.mass
  closingStock : Qty Dim.mass

namespace Account

def totalSupply (a : Account) : Qty Dim.mass :=
  a.openingStock + a.production + a.imports + a.otherSupply

def totalDisposition (a : Account) : Qty Dim.mass :=
  a.exports + a.intermediateUse + a.finalConsumption + a.losses + a.otherDisposition +
    a.closingStock

def residual (a : Account) : Qty Dim.mass := a.totalSupply - a.totalDisposition

/-- The identity holds exactly. -/
def ExactlyBalanced (a : Account) : Prop := a.residual = 0

/-- The identity holds up to a tolerance. -/
def BalancedWithin (a : Account) (tol : Qty Dim.mass) : Prop := |a.residual.value| ≤ tol.value

instance (a : Account) : Decidable (ExactlyBalanced a) := by
  unfold ExactlyBalanced; infer_instance

instance (a : Account) (tol : Qty Dim.mass) : Decidable (BalancedWithin a tol) := by
  unfold BalancedWithin; infer_instance

theorem balancedWithin_of_exactlyBalanced {a : Account} {tol : Qty Dim.mass}
    (h : ExactlyBalanced a) (htol : 0 ≤ tol.value) : BalancedWithin a tol := by
  simp only [BalancedWithin]
  rw [show a.residual.value = 0 from congrArg Qty.value h]
  simpa using htol

theorem exactlyBalanced_iff (a : Account) :
    ExactlyBalanced a ↔ a.totalSupply.value = a.totalDisposition.value := by
  constructor
  · intro h
    have := congrArg Qty.value h
    simp only [residual, Qty.sub_value, Qty.zero_value] at this
    linarith
  · intro h
    apply Qty.ext
    simp only [residual, Qty.sub_value, Qty.zero_value]
    linarith

/-- An exactly balanced account is balanced within any nonnegative tolerance,
and the converse fails for a positive one: the two predicates are genuinely
different, so `ExactlyBalanced` is the strictly stronger contract. -/
theorem balancedWithin_not_exactlyBalanced :
    ∃ (a : Account) (tol : Qty Dim.mass), BalancedWithin a tol ∧ ¬ ExactlyBalanced a := by
  refine ⟨{ commodity := Commodity.wheat
            region := ⟨"ISO3166", "KAZ", "Kazakhstan"⟩
            period := ⟨0, 365, by decide⟩
            openingStock := ⟨0⟩, production := ⟨100⟩, imports := ⟨0⟩, otherSupply := ⟨0⟩
            exports := ⟨0⟩, intermediateUse := ⟨0⟩, finalConsumption := ⟨99⟩
            losses := ⟨0⟩, otherDisposition := ⟨0⟩, closingStock := ⟨0⟩ }, ⟨2⟩, ?_, ?_⟩
  · simp [BalancedWithin, residual, totalSupply, totalDisposition]
    norm_num
  · simp only [ExactlyBalanced, residual, totalSupply, totalDisposition]
    intro h
    have := congrArg Qty.value h
    norm_num at this

end Account

/-! ### Interval accounts

Every line carries its declared precision.  `unattributedResidual` is a
modelled line, not a fudge factor: it is published with the rest.
-/

/-- A supply/disposition account whose lines are intervals. -/
structure IntervalAccount where
  commodity : Commodity
  region : RegionCode
  period : Period
  openingStock : IQty Dim.mass
  production : IQty Dim.mass
  imports : IQty Dim.mass
  otherSupply : IQty Dim.mass
  exports : IQty Dim.mass
  intermediateUse : IQty Dim.mass
  finalConsumption : IQty Dim.mass
  losses : IQty Dim.mass
  otherDisposition : IQty Dim.mass
  closingStock : IQty Dim.mass
  /-- Systematic revisions and unexplained difference, published as a line with
  its own interval rather than absorbed into a tolerance. -/
  unattributedResidual : IQty Dim.mass

namespace IntervalAccount

def totalSupply (A : IntervalAccount) : IQty Dim.mass :=
  A.openingStock + A.production + A.imports + A.otherSupply

def totalDisposition (A : IntervalAccount) : IQty Dim.mass :=
  A.exports + A.intermediateUse + A.finalConsumption + A.losses + A.otherDisposition +
    A.closingStock + A.unattributedResidual

/-- The residual of an interval account is itself an interval: a published
quantity with its own uncertainty. -/
def residualInterval (A : IntervalAccount) : IQty Dim.mass := A.totalSupply - A.totalDisposition

/-- The account balances when zero is a possible residual. -/
def IntervalBalanced (A : IntervalAccount) : Prop :=
  (0 : ℚ) ∈ A.residualInterval.iv

instance (A : IntervalAccount) : Decidable (IntervalBalanced A) := by
  unfold IntervalBalanced; infer_instance

/-- The tolerance *derived* from the declared precision of the lines: the
largest residual the interval account admits. -/
def derivedTolerance (A : IntervalAccount) : Qty Dim.mass :=
  ⟨max |A.residualInterval.iv.lo| |A.residualInterval.iv.hi|⟩

/-- **The residual interval is exactly as wide as the declared precision.**
Its width is the sum of the widths of the eleven lines — nothing narrower is
claimed, and nothing wider is smuggled in. -/
theorem residualInterval_width_eq (A : IntervalAccount) :
    A.residualInterval.width
      = A.openingStock.width + A.production.width + A.imports.width + A.otherSupply.width +
        A.exports.width + A.intermediateUse.width + A.finalConsumption.width + A.losses.width +
        A.otherDisposition.width + A.closingStock.width + A.unattributedResidual.width := by
  simp only [IQty.width, Interval.width, residualInterval, totalSupply, totalDisposition,
    IQty.add_iv, IQty.sub_iv, Interval.add_lo, Interval.add_hi, Interval.sub_lo, Interval.sub_hi]
  ring

/-- **The derived tolerance is bounded by the declared precision.**  For a
balanced interval account, the tolerance read off the residual interval never
exceeds the total width of the declared inputs: it is a consequence of how
precisely the sources report, not a number chosen to make the data pass. -/
theorem derivedTolerance_le_declared_precision (A : IntervalAccount) (h : A.IntervalBalanced) :
    A.derivedTolerance.value ≤ A.residualInterval.width := by
  obtain ⟨hlo, hhi⟩ := h
  simp only [derivedTolerance, IQty.width, Interval.width]
  refine max_le ?_ ?_
  · rw [abs_of_nonpos hlo]; linarith
  · rw [abs_of_nonneg hhi]; linarith

/-- A point account is *selected from* an interval account when it describes
the same cell and each of its lines lies in the corresponding interval.  The
unattributed residual line is selected too, as the difference the point account
leaves unexplained. -/
structure Selects (A : IntervalAccount) (a : Account) : Prop where
  commodity : a.commodity = A.commodity
  region : a.region = A.region
  period : a.period = A.period
  openingStock : a.openingStock ∈ A.openingStock
  production : a.production ∈ A.production
  imports : a.imports ∈ A.imports
  otherSupply : a.otherSupply ∈ A.otherSupply
  exports : a.exports ∈ A.exports
  intermediateUse : a.intermediateUse ∈ A.intermediateUse
  finalConsumption : a.finalConsumption ∈ A.finalConsumption
  losses : a.losses ∈ A.losses
  otherDisposition : a.otherDisposition ∈ A.otherDisposition
  closingStock : a.closingStock ∈ A.closingStock
  unattributedResidual : (0 : Qty Dim.mass) ∈ A.unattributedResidual

theorem totalSupply_mem {A : IntervalAccount} {a : Account} (h : Selects A a) :
    a.totalSupply ∈ A.totalSupply :=
  IQty.add_mem (IQty.add_mem (IQty.add_mem h.openingStock h.production) h.imports) h.otherSupply

theorem totalDisposition_mem {A : IntervalAccount} {a : Account} (h : Selects A a) :
    a.totalDisposition ∈ A.totalDisposition := by
  have base :=
    IQty.add_mem (IQty.add_mem (IQty.add_mem (IQty.add_mem (IQty.add_mem h.exports
      h.intermediateUse) h.finalConsumption) h.losses) h.otherDisposition) h.closingStock
  have := IQty.add_mem base h.unattributedResidual
  simpa [Account.totalDisposition, totalDisposition] using this

/-- **Soundness of the interval account.** The residual of any point account
selected from it lies in the published residual interval. -/
theorem residual_mem {A : IntervalAccount} {a : Account} (h : Selects A a) :
    a.residual ∈ A.residualInterval :=
  IQty.sub_mem (totalSupply_mem h) (totalDisposition_mem h)

/-- **Exact balance implies interval balance.** If any selection of point
values from the declared intervals balances exactly, then the interval account
balances. -/
theorem intervalBalanced_of_exact {A : IntervalAccount} {a : Account} (h : Selects A a)
    (hbal : a.ExactlyBalanced) : IntervalBalanced A := by
  have hmem := residual_mem h
  have hzero : a.residual.value = 0 := congrArg Qty.value hbal
  simpa [IntervalBalanced, hzero] using hmem

/-- **The tolerance is a consequence, not a knob.** Every point account
selected from an interval account balances within the tolerance derived from
that account's declared precision. -/
theorem balancedWithin_derived {A : IntervalAccount} {a : Account} (h : Selects A a) :
    a.BalancedWithin A.derivedTolerance := by
  obtain ⟨h1, h2⟩ := residual_mem h
  simp only [Account.BalancedWithin, derivedTolerance, abs_le]
  constructor
  · have : -|A.residualInterval.iv.lo| ≤ A.residualInterval.iv.lo := neg_abs_le _
    have hmax : -max |A.residualInterval.iv.lo| |A.residualInterval.iv.hi|
        ≤ -|A.residualInterval.iv.lo| := by
      simp
    linarith
  · have : A.residualInterval.iv.hi ≤ |A.residualInterval.iv.hi| := le_abs_self _
    have hmax : |A.residualInterval.iv.hi|
        ≤ max |A.residualInterval.iv.lo| |A.residualInterval.iv.hi| := le_max_right _ _
    linarith

end IntervalAccount

end RequestProject.Economy
