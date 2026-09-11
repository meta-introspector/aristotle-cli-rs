/-
# What the senator's wishes cost

`RequestProject/Market/Roadmap.lean` writes the report's asks down as sixteen
wishes, eleven granted and five open, and proves that the list is a correct
plan.  It says nothing about money.  This file prices it.

**How a wish is sized.**  The only thing about a granted wish that can be
*measured* is how many lines of Lean were retained to grant it, so that is what
is used: every line of `RequestProject/Market/` was counted on 2026-09-03 and
attributed to the wish whose evidence theorems it contains, a file shared by
several wishes being split as evenly as possible.  The five open wishes have no
lines yet, so their sizes are **estimates**, and they are flagged as such: no
theorem below claims an open wish has been measured.

**How a size becomes a bill.**  Through the pricing model in
`RequestProject/Pricing/Model.lean`, at the posted prices in
`RequestProject/Pricing/Prices.lean`: retained lines become billed prompt and
completion tokens at the three assumed rates, plus machine hours for the
repeated kernel checking a formal artifact needs.  Two rate cards are used, the
cheapest and the dearest thing on the retrieved price list, so every figure
comes as a range rather than a point.

What is proved:

* `pricing_covers_the_roadmap` — the priced list is exactly the roadmap's
  sixteen wishes, in the roadmap's order, so nothing is priced that was not
  asked for and nothing asked for goes unpriced;
* `measured_iff_granted` — a wish's size is a measurement exactly when the wish
  is granted; the open ones are estimates;
* `granted_lines`, `open_lines`, `attribution_exhausts_the_corpus` — 1,608
  measured lines attributed to wishes, 606 more of programme overhead, 2,214
  lines in the directory, and the three numbers agree;
* the bills themselves: `granted_bill_commodity`, `granted_bill_frontier`,
  `open_bill_commodity`, `open_bill_frontier`, `programme_bill_frontier`;
* `bill_is_additive` — the bill for a set of wishes is the sum of the bills of
  its wishes, with no discount for grouping;
* `open_dearer_than_granted` — the work still to do costs more than the work
  already done, at both rate cards;
* `frontier_over_commodity` — the same programme is 247.65 times dearer bought
  at the dearest posted offer than at the cheapest;
* `open_programme_in_h200_hours` — funding every remaining wish at frontier
  prices costs 284.49 hours of the dearest machine lease on the retrieved
  marketplace, about twelve days;
* `programme_share_of_marketplace` — the whole sixteen-wish programme, at
  frontier prices, is 0.028% of everything that marketplace has ever spent;
* `dearest_open_wish`, `ready_bill_frontier` — which wish costs most, and what
  the work that can start today costs.

Every figure is a theorem the kernel decides from the data; changing a price or
a line count changes the number or fails the build.
-/
import RequestProject.Solfunmeme.Market.Roadmap
import RequestProject.Solfunmeme.Pricing.Prices

namespace RequestProject.Pricing

open RequestProject.Market

/-! ## The sizes -/

/-- One priced wish: the roadmap's identifier, the lines of Lean it costs, and
whether that number was counted in the repository (a granted wish) or estimated
(an open one). -/
structure WishPrice where
  /-- The identifier of the wish in `RequestProject/Market/Roadmap.lean`. -/
  id : Nat
  /-- Lines of Lean retained, measured or estimated. -/
  lines : ℕ
  /-- Whether `lines` was counted rather than estimated. -/
  measured : Bool
  deriving DecidableEq, Repr

/-- **The sixteen wishes, sized.**  The eleven granted ones carry the line
counts of the files that discharge them, measured on 2026-09-03:
`Compute.lean` 203 lines (wishes 901 and 902), `Stake.lean` 147 (903),
`Challenge.lean` 422 (904, 905, 914), `Private.lean` 109 (906), `Supply.lean`
162 (907, 908), `Twin.lean` 185 (909), `Fit.lean` 380 (913).  The five open
ones carry estimates: two to four times the largest delivered module, which is
`Challenge.lean` at 422 lines. -/
def wishPrices : List WishPrice :=
  [ ⟨901, 102, true⟩, ⟨902, 101, true⟩, ⟨903, 147, true⟩, ⟨904, 141, true⟩
  , ⟨905, 141, true⟩, ⟨914, 140, true⟩, ⟨906, 109, true⟩, ⟨907, 81, true⟩
  , ⟨908, 81, true⟩, ⟨909, 185, true⟩, ⟨913, 380, true⟩
  , ⟨910, 1200, false⟩, ⟨911, 800, false⟩, ⟨912, 800, false⟩, ⟨916, 600, false⟩
  , ⟨915, 1600, false⟩ ]

/-- The lines of `RequestProject/Market/` that grant no single wish: the
roadmap itself (307), the worked instance (177) and the axiom audit (122). -/
def programmeOverheadLines : ℕ := 606

/-- Every line of `RequestProject/Market/`, measured on 2026-09-03. -/
def marketCorpusLines : ℕ := 2214

/-- **Assumed.**  Machine hours of repeated kernel checking per retained line:
twenty hours per thousand lines. -/
def buildHours (lines : ℕ) : ℚ := (lines : ℚ) / 50

/-- What one wish consumes: billed tokens for the writing, machine hours for
the checking.  Stored bytes are priced in `RequestProject/Pricing/Infra.lean`,
not here. -/
def WishPrice.workload (w : WishPrice) : Workload :=
  ⟨(effortOf w.lines).split, buildHours w.lines, 0⟩

/-- The bill for a list of wishes at a rate card. -/
def billOf (r : RateCard) (ws : List WishPrice) : USD :=
  (ws.map (fun w => r.bill w.workload)).sum

/-- The granted wishes: the ones whose size is a measurement. -/
def grantedWishes : List WishPrice := wishPrices.filter (·.measured)

/-- The open wishes: the ones whose size is an estimate. -/
def openWishes : List WishPrice := wishPrices.filter (fun w => !w.measured)

/-- The wishes that can be started today — the roadmap's frontier, priced. -/
def readyWishes : List WishPrice := openWishes.filter (fun w => w.id != 915)

/-- Lines in a list of wishes. -/
def totalLines (ws : List WishPrice) : ℕ := (ws.map WishPrice.lines).sum

/-- The unfoldings the arithmetic below runs on: the sizing, the rate cards and
the posted prices. -/
local macro "price_calc" : tactic =>
  `(tactic| norm_num [billOf, wishPrices, grantedWishes, openWishes, readyWishes,
      WishPrice.workload, buildHours, effortOf, commodityRates, frontierRates, RateCard.bill,
      Offer.quote, cheapestOffer, dearestOffer, zAiGlm47Flash, openaiGpt55Pro,
      cheapestLeaseUSDPerHour, h100USDPerHour, h200USDPerHour, assumedStorageUSDPerGBMonth,
      Effort.split, Effort.outputTokens, assumedTokensPerLine, assumedDraftMultiplier,
      assumedContextRatio, marketplaceLifetimeSpendUSD])

/-! ## The priced list is the roadmap -/

/-- **Everything the report asked for is priced, and nothing else is.**  The
priced list is exactly the roadmap's wish list, in the roadmap's order. -/
theorem pricing_covers_the_roadmap :
    wishPrices.map WishPrice.id = vaicuWishes.map Wish.id := by decide

/-- **A size is a measurement exactly when the wish is granted.**  No open wish
is claimed to have been counted, and no granted wish is an estimate. -/
theorem measured_iff_granted :
    wishPrices.map WishPrice.measured = vaicuWishes.map Wish.done := by decide

/-- Eleven wishes are sized by measurement, five by estimate. -/
theorem sized_counts : grantedWishes.length = 11 ∧ openWishes.length = 5 := by decide

/-- Every wish has a positive size: nothing is priced at nothing. -/
theorem every_wish_costs_something : ∀ w ∈ wishPrices, 0 < w.lines := by decide

/-! ## The lines -/

/-- The granted wishes account for 1,608 measured lines of Lean. -/
theorem granted_lines : totalLines grantedWishes = 1608 := by decide

/-- The open wishes are estimated at 5,000 lines. -/
theorem open_lines : totalLines openWishes = 5000 := by decide

/-- The work that can start today is estimated at 3,400 lines. -/
theorem ready_lines : totalLines readyWishes = 3400 := by decide

/-- **The attribution is exhaustive and double-counts nothing**: the lines
attributed to granted wishes, plus the programme overhead, are exactly the
lines of the directory. -/
theorem attribution_exhausts_the_corpus :
    totalLines grantedWishes + programmeOverheadLines = marketCorpusLines := by decide

/-- **There is three times as much left to do as has been done**, by the only
measure available. -/
theorem open_lines_exceed_granted : 3 * totalLines grantedWishes < totalLines openWishes := by
  decide

/-! ## The bills -/

/-- Billing is additive over wishes: no discount and no penalty for grouping. -/
theorem bill_is_additive (r : RateCard) (ws vs : List WishPrice) :
    billOf r (ws ++ vs) = billOf r ws + billOf r vs := by
  simp [billOf, List.sum_append]

/-- **The eleven granted wishes cost $1.6440** at the cheapest posted route. -/
theorem granted_bill_commodity : billOf commodityRates grantedWishes = 128439 / 78125 := by
  price_calc

/-- **…and $407.15** at the dearest. -/
theorem granted_bill_frontier : billOf frontierRates grantedWishes = 254466 / 625 := by
  price_calc

/-- **The five open wishes cost $5.112** at the cheapest posted route. -/
theorem open_bill_commodity : billOf commodityRates openWishes = 639 / 125 := by
  price_calc

/-- **…and $1,266.00** at the dearest. -/
theorem open_bill_frontier : billOf frontierRates openWishes = 1266 := by
  price_calc

/-- The whole sixteen-wish programme, at the dearest posted route: $1,673.15. -/
theorem programme_bill_frontier : billOf frontierRates wishPrices = 1045716 / 625 := by
  price_calc

/-- The whole programme at the cheapest posted route: $6.756. -/
theorem programme_bill_commodity : billOf commodityRates wishPrices = 527814 / 78125 := by
  price_calc

/-- The programme's bill is the granted bill plus the open bill, at either card:
the split is a partition of the work, not an allocation convention. -/
theorem programme_splits :
    billOf frontierRates wishPrices = billOf frontierRates grantedWishes
        + billOf frontierRates openWishes ∧
      billOf commodityRates wishPrices = billOf commodityRates grantedWishes
        + billOf commodityRates openWishes := by
  constructor <;> price_calc

/-- **What is left to do costs more than what has been done**, at both cards. -/
theorem open_dearer_than_granted :
    billOf frontierRates grantedWishes < billOf frontierRates openWishes ∧
      billOf commodityRates grantedWishes < billOf commodityRates openWishes := by
  constructor <;> price_calc

/-- The work that can start today — the verifier, encrypted execution beyond
additive masks, toolchain semantics and geometry — costs $860.88 at the dearest
route. -/
theorem ready_bill_frontier : billOf frontierRates readyWishes = 21522 / 25 := by
  price_calc

/-- …and $3.4762 at the cheapest. -/
theorem ready_bill_commodity : billOf commodityRates readyWishes = 21726 / 6250 := by
  price_calc

/-- The dearest single wish is 915, the whole loop on chain, at $405.12 —
which is, to within $2, the price of everything already granted. -/
theorem dearest_open_wish :
    ∀ w ∈ openWishes, frontierRates.bill w.workload
      ≤ frontierRates.bill (WishPrice.mk 915 1600 false).workload := by
  intro w hw
  fin_cases hw <;> price_calc

/-! ## What the numbers mean

Three comparisons, all decided by the kernel from the same data. -/

/-- **The same programme is 247.65 times dearer at the dearest posted offer
than at the cheapest.**  Routing, not effort, is the biggest single lever on
this bill. -/
theorem frontier_over_commodity :
    billOf frontierRates wishPrices = (52750 / 213) * billOf commodityRates wishPrices := by
  price_calc

/-- **Funding every remaining wish at frontier prices costs 284.49 hours of the
dearest machine on the retrieved marketplace** — about twelve days of one
H200. -/
theorem open_programme_in_h200_hours :
    billOf frontierRates openWishes = (25320 / 89) * h200USDPerHour := by
  price_calc

/-- **The entire sixteen-wish programme, at frontier prices, is 0.028% of what
that marketplace has spent in its lifetime.** -/
theorem programme_share_of_marketplace :
    10000 * billOf frontierRates wishPrices < 3 * marketplaceLifetimeSpendUSD := by
  price_calc

/-- And at the cheapest route it is under seven dollars: less than three hours
of a single H100 lease. -/
theorem programme_under_three_h100_hours :
    billOf commodityRates wishPrices < 3 * h100USDPerHour := by
  price_calc

/-! ## The assumption that carries the weight

The sizing rests on one number nobody can measure — how many tokens are
generated per token retained.  It is assumed to be 40.  The theory says the
answer is exactly linear in it, so the ledger can say precisely what a
different assumption would cost. -/

/-- **Doubling the assumed discovery multiplier doubles the token half of the
bill and leaves the machine half alone.**  Stated for the open programme at the
frontier card: at twice the assumed waste, the token line goes from $1,008.00
to $2,016.00 while the machine line stays at $258.00. -/
theorem doubling_waste_doubles_tokens :
    dearestOffer.quote (Effort.mk 5000 assumedTokensPerLine (2 * assumedDraftMultiplier)
        assumedContextRatio).split
      = 2 * dearestOffer.quote (effortOf 5000).split ∧
    dearestOffer.quote (effortOf 5000).split = 1008 ∧
    frontierRates.machineUSDPerHour * buildHours 5000 = 258 := by
  refine ⟨Effort.quote_scale_draftMultiplier _ _ _ _ _ 2, ?_, ?_⟩ <;> price_calc

end RequestProject.Pricing
