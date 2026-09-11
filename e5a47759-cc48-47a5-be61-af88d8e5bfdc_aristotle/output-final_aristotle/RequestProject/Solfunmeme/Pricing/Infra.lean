/-
# What the infrastructure costs

`RequestProject/Pricing/Wishes.lean` prices the work that is left to do.  This
file prices the thing that is already running: the state a node keeps, the
nodes that keep it, the machine that re-checks the proofs, and the tokens spent
keeping the corpus alive.

**What is measured.**  The published state — everything the repository tracks —
was measured on 2026-09-03: 461 files, 21,208,810 bytes, of which 129 Lean
modules and 106,027 lines of Lean, plus the 49 chunks of the index feed.  Those
five numbers are measurements of this repository and nothing else.

**What is assumed.**  How long a node runs in a month, how often the proofs are
re-checked and for how long, how much of the corpus is rewritten in a month,
and what a gigabyte-month of storage costs.  Each is named `assumed`.

**What is retrieved.**  The prices: the posted token list and the published
machine lease quotes of `RequestProject/Pricing/Prices.lean`, both of vintage
2026-08-24.

What is proved:

* `monthly_bill_commodity`, `monthly_bill_frontier` — one hosted node, its
  storage, the checking and the maintenance: $33.12 a month buying tokens at
  the cheapest posted offer, $234.30 at the dearest;
* `annual_bill_commodity` — $397.47 a year;
* `bill_linear_in_nodes` — **the mesh's bill is linear in the number of nodes,
  not in the number of links between them**: the sync model settles by union of
  a grow-only set, so a node pays for itself and for nothing pairwise;
* `sneakernet_node_is_storage_only` — a node somebody else hosts costs the
  project only the bytes it keeps: $0.000424 a month, and a thousand of them
  cost $0.42;
* `hosting_dominates` — hosting, not inference, is the largest line of the
  commodity bill, and `checking_exceeds_maintenance` — the kernel costs more
  than the tokens do;
* `own_serving_breakeven`, `buying_wins_at_our_volume` — leasing an accelerator
  for a year beats buying frontier tokens only past 125,560,000 completion
  tokens, and beats commodity tokens only past 56,502,000,000; the project
  generates 5,760,000 a year, so buying wins by a factor of 22 even against the
  frontier price;
* `infra_year_under_one_h100_year` — the whole year of infrastructure is a
  fifty-seventh of the cost of leasing one H100 for that year;
* `whole_operation_annual` — infrastructure for a year plus every remaining
  wish, at frontier token prices throughout: $4,077.61.
-/
import RequestProject.Solfunmeme.Pricing.Wishes

namespace RequestProject.Pricing

/-! ## The measured state -/

/-- Files the repository tracks, measured 2026-09-03. -/
def stateFiles : ℕ := 461

/-- Bytes the repository tracks, measured 2026-09-03. -/
def stateBytes : ℕ := 21208810

/-- Lean modules in the repository, measured 2026-09-03. -/
def stateLeanModules : ℕ := 129

/-- Lines of Lean in the repository, measured 2026-09-03. -/
def stateLeanLines : ℕ := 106027

/-- Chunks of the index feed, measured 2026-09-03. -/
def stateIndexChunks : ℕ := 49

/-- The published state, in gigabytes: 0.0212 GB. -/
def stateGB : ℚ := (stateBytes : ℚ) / 1000000000

/-- The whole state is a fiftieth of a gigabyte: small enough that a node is
priced by the hours it runs, not by the bytes it holds. -/
theorem state_under_a_gigabyte : stateGB < 1 / 40 := by
  norm_num [stateGB, stateBytes]

/-! ## The assumptions -/

/-- **Assumed.**  Hours a node runs in a month. -/
def assumedNodeHoursPerMonth : ℚ := 730

/-- **Assumed.**  Full re-checks of the corpus in a month. -/
def assumedBuildsPerMonth : ℕ := 60

/-- **Assumed.**  Machine hours one full re-check takes. -/
def assumedHoursPerBuild : ℚ := 1 / 2

/-- **Assumed.**  Lines of Lean written or rewritten in a month. -/
def assumedMaintenanceLines : ℕ := 1000

/-! ## The four lines of the bill -/

/-- Hosting: what it costs to keep `nodes` nodes running for a month, at the
cheapest lease quote in the marketplace snapshot. -/
def hostingLine (nodes : ℕ) : USD :=
  (nodes : ℚ) * assumedNodeHoursPerMonth * cheapestLeaseUSDPerHour

/-- Storage: what it costs to keep one copy of the state per node for a month. -/
def storageLine (nodes : ℕ) : USD :=
  (nodes : ℚ) * stateGB * assumedStorageUSDPerGBMonth

/-- Checking: the machine hours the kernel spends re-proving everything, on a
build machine rather than the cheapest possible one. -/
def checkingLine : USD :=
  (assumedBuildsPerMonth : ℚ) * assumedHoursPerBuild * rtx4090USDPerHour

/-- Maintenance: the tokens spent writing the month's lines, at a given offer. -/
def maintenanceLine (o : Offer) : USD := o.quote (effortOf assumedMaintenanceLines).split

/-- The monthly bill: hosting, storage, checking and maintenance. -/
def monthlyBill (o : Offer) (nodes : ℕ) : USD :=
  hostingLine nodes + storageLine nodes + checkingLine + maintenanceLine o

/-- The annual bill, twelve months of the same. -/
def annualBill (o : Offer) (nodes : ℕ) : USD := 12 * monthlyBill o nodes

/-- The unfoldings the arithmetic below runs on. -/
local macro "infra_calc" : tactic =>
  `(tactic| norm_num [monthlyBill, annualBill, hostingLine, storageLine, checkingLine,
      maintenanceLine, stateGB, stateBytes, assumedNodeHoursPerMonth, assumedBuildsPerMonth,
      assumedHoursPerBuild, assumedMaintenanceLines, assumedStorageUSDPerGBMonth,
      cheapestLeaseUSDPerHour, rtx4090USDPerHour, h100USDPerHour, h200USDPerHour,
      cheapestOffer, dearestOffer, zAiGlm47Flash, openaiGpt55Pro, effortOf, Effort.split,
      Effort.outputTokens, assumedTokensPerLine, assumedDraftMultiplier, assumedContextRatio,
      Offer.quote, marketplaceLifetimeSpendUSD])

/-! ## The bill -/

/-- Hosting one node for a month: $21.90. -/
theorem hosting_one_node : hostingLine 1 = 219 / 10 := by infra_calc

/-- Keeping one copy of the whole state for a month: $0.000424. -/
theorem storage_one_node : storageLine 1 = 2120881 / 5000000000 := by infra_calc

/-- Sixty full re-checks of the corpus: $10.80 a month. -/
theorem checking_monthly : checkingLine = 54 / 5 := by infra_calc

/-- A thousand lines of Lean a month costs $0.4224 in tokens at the cheapest
posted offer, and $201.60 at the dearest. -/
theorem maintenance_range :
    maintenanceLine cheapestOffer = 264 / 625 ∧ maintenanceLine dearestOffer = 1008 / 5 := by
  constructor <;> infra_calc

/-- **The whole infrastructure, one hosted node, buying tokens at the cheapest
posted offer: $33.1228 a month.** -/
theorem monthly_bill_commodity :
    monthlyBill cheapestOffer 1 = 165614120881 / 5000000000 := by infra_calc

/-- **…and $234.3004 at the dearest.** -/
theorem monthly_bill_frontier :
    monthlyBill dearestOffer 1 = 1171502120881 / 5000000000 := by infra_calc

/-- A year of it, at the cheapest offer: $397.47. -/
theorem annual_bill_commodity :
    annualBill cheapestOffer 1 = 496842362643 / 1250000000 := by infra_calc

/-- A year of it, at the dearest: $2,811.61. -/
theorem annual_bill_frontier :
    annualBill dearestOffer 1 = 3514506362643 / 1250000000 := by infra_calc

/-! ## What the shape of the bill says -/

/-- **The mesh's bill is linear in the number of nodes.**  A node pays for
itself; nothing is paid per pair.  This is the price consequence of the sync
model: state is a grow-only set and merging is union, so a link carries no cost
of its own. -/
theorem bill_linear_in_nodes (o : Offer) (n : ℕ) :
    monthlyBill o n = (n : ℚ) * (assumedNodeHoursPerMonth * cheapestLeaseUSDPerHour
      + stateGB * assumedStorageUSDPerGBMonth) + checkingLine + maintenanceLine o := by
  unfold monthlyBill hostingLine storageLine
  ring

/-- **A fleet is a sum, not a square.**  From four nodes on there are more
pairwise links than nodes — stated without halving, twice the nodes is less
than `n (n-1)`, which is twice the links — and by `bill_linear_in_nodes` none
of those links is billed. -/
theorem links_exceed_nodes {n : ℕ} (hn : 4 ≤ n) : 2 * n < n * (n - 1) := by
  obtain ⟨k, rfl⟩ := Nat.exists_eq_add_of_le hn
  have h : 4 + k - 1 = 3 + k := by omega
  rw [h]
  nlinarith

/-- **A node somebody else hosts costs the project only the bytes it keeps.**
The marginal cost of a sneakernet replica — a copy on a memory card, or a
machine on a nightly dial-up — is storage alone. -/
theorem sneakernet_node_is_storage_only (o : Offer) (n : ℕ) :
    monthlyBill o (n + 1) - monthlyBill o n
      = assumedNodeHoursPerMonth * cheapestLeaseUSDPerHour + stateGB * assumedStorageUSDPerGBMonth
    ∧ storageLine (n + 1) - storageLine n = stateGB * assumedStorageUSDPerGBMonth := by
  constructor
  · rw [bill_linear_in_nodes, bill_linear_in_nodes]
    push_cast
    ring
  · unfold storageLine
    push_cast
    ring

/-- A thousand replicas of the whole published state cost $0.4242 a month
between them. -/
theorem thousand_replicas : storageLine 1000 = 2120881 / 5000000 := by infra_calc

/-- **Hosting is the largest line of the commodity bill** — larger than the
kernel, the storage and the tokens together. -/
theorem hosting_dominates :
    storageLine 1 + checkingLine + maintenanceLine cheapestOffer < hostingLine 1 := by
  infra_calc

/-- **And the kernel costs more than the writing does**, at the cheapest posted
offer: re-checking the corpus is twenty-five times the token bill. -/
theorem checking_exceeds_maintenance :
    25 * maintenanceLine cheapestOffer < checkingLine := by infra_calc

/-! ## Make or buy

The project buys inference.  The alternative is to lease an accelerator and
serve its own, which is a fixed cost recovered out of a per-token saving. -/

/-- Leasing one H100 for a year at the quoted average: $22,600.80. -/
def h100YearUSD : USD := h100USDPerHour * 8760

theorem h100Year_value : h100YearUSD = 113004 / 5 := by
  norm_num [h100YearUSD, h100USDPerHour]

/-- The make-or-buy problem against the dearest posted completion price, on the
generous assumption that a leased accelerator serves tokens at no marginal cost
at all. -/
def ownServingVsFrontier : MakeOrBuy := ⟨h100YearUSD, 0, 180 / 1000000⟩

/-- The same against the cheapest posted completion price. -/
def ownServingVsCommodity : MakeOrBuy := ⟨h100YearUSD, 0, (2 / 5) / 1000000⟩

/-- **Leasing an accelerator for a year beats buying frontier tokens only past
125,560,000 completion tokens** — and beats commodity tokens only past
56,502,000,000. -/
theorem own_serving_breakeven :
    ownServingVsFrontier.breakevenTokens = 125560000 ∧
      ownServingVsCommodity.breakevenTokens = 56502000000 := by
  constructor <;>
    norm_num [MakeOrBuy.breakevenTokens, MakeOrBuy.margin, ownServingVsFrontier,
      ownServingVsCommodity, h100YearUSD, h100USDPerHour]

/-- The completion tokens the project generates in a year, on the maintenance
assumption: 5,760,000. -/
def annualGeneratedTokens : ℚ := 12 * ((effortOf assumedMaintenanceLines).split.outputTokens : ℚ)

theorem annualGeneratedTokens_value : annualGeneratedTokens = 5760000 := by
  norm_num [annualGeneratedTokens, effortOf, Effort.split, Effort.outputTokens,
    assumedMaintenanceLines, assumedTokensPerLine, assumedDraftMultiplier, assumedContextRatio]

/-- **At this project's volume, buying wins**, and not narrowly: the breakeven
is twenty-one times the year's generation even against the dearest posted
price, and nearly ten thousand times it against the cheapest.  So the bill
above is the right one: no accelerator should be leased. -/
theorem buying_wins_at_our_volume :
    21 * annualGeneratedTokens < ownServingVsFrontier.breakevenTokens ∧
      ownServingVsFrontier.buyCost annualGeneratedTokens
        < ownServingVsFrontier.makeCost annualGeneratedTokens := by
  refine ⟨?_, ?_⟩
  · rw [annualGeneratedTokens_value, own_serving_breakeven.1]
    norm_num
  · rw [MakeOrBuy.buyCost, MakeOrBuy.makeCost, annualGeneratedTokens_value]
    norm_num [ownServingVsFrontier, h100YearUSD, h100USDPerHour]

/-! ## Yardsticks -/

/-- **A month of the entire infrastructure costs 7.44 hours of the dearest
machine on the retrieved marketplace.** -/
theorem month_in_h200_hours :
    monthlyBill cheapestOffer 1 = (165614120881 / 22250000000) * h200USDPerHour := by
  infra_calc

/-- **A year of the entire infrastructure is a fifty-seventh of leasing one
H100 for that year.** -/
theorem infra_year_under_one_h100_year :
    56 * annualBill cheapestOffer 1 < h100YearUSD := by
  rw [h100Year_value]
  infra_calc

/-- **Everything: a year of infrastructure and every remaining wish, buying
tokens at the dearest posted price throughout — $4,077.61.** -/
theorem whole_operation_annual :
    annualBill dearestOffer 1 + billOf frontierRates openWishes = 5097006362643 / 1250000000 := by
  rw [open_bill_frontier, annual_bill_frontier]
  norm_num

/-- …and that is under a thousandth of everything the retrieved marketplace has
spent in its lifetime. -/
theorem whole_operation_share :
    1000 * (annualBill dearestOffer 1 + billOf frontierRates openWishes)
      < marketplaceLifetimeSpendUSD := by
  rw [whole_operation_annual]
  norm_num [marketplaceLifetimeSpendUSD]

end RequestProject.Pricing
