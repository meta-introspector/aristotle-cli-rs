/-
The bootstrap plan for this project: thirteen stages, priced, and checked.
-/
import RequestProject.Solfunmeme.Bootstrap.Model
import RequestProject.Solfunmeme.Pricing.Infra
import RequestProject.Solfunmeme.Pricing.Wishes

/-!
# The bootstrap

`Model.lean` says what a bootstrap plan is.  This file writes one down for this
project and checks it.

The plan has **thirteen stages, one per month**.  The first seven are things
the repository can already do, in the order a bare machine has to do them: get
the source and the pinned toolchain, build the proofs, run a node, publish the
page and the badges, join a second node into the mesh, serve the index feed,
hold the senate's roll call.  The next five are the five wishes senator Vaicu's
report leaves open, in the order their prerequisites allow.  The last stage is
the one that closes the loop: a third party bootstraps a mirror *from what has
been published*, so the plan's own output supplies its opening requirements.

**Money.**  Everything is in whole cents, so every figure the kernel decides is
exact.  Each stage pays one month of the infrastructure bill, `monthlyRunCents`
— the commodity monthly bill of `Pricing/Infra.lean` rounded up to the cent
(`monthly_run_rounds_up_the_priced_bill`) — and the five wish stages also pay
that wish's frontier price from `Pricing/Wishes.lean`
(`wish_spend_is_the_open_programme`).  So the plan spends **$1,696.69**
(`total_cost`), of which $1,266.00 is the wish list and $430.69 is thirteen
months of running.

**Revenue is an assumption, and is labelled as one.**  Nothing in this
repository measures what a hosted node, an index subscription, senate dues or a
settled verification job earn; the `assumedIncome…` figures are stated, not
retrieved, and no theorem calls them anything else.  What the theorems do say
is what follows *from* them: the plan needs an opening float of **$1,069.56**
and not a cent less (`required_float`, `float_is_tight`); from the senate stage
on the standing revenue covers the standing bill (`self_funding_from_senate`),
so from there the operation survives every horizon
(`maintenance_solvent_for_ever`); and five months after the last stage the
float is back (`float_repaid_in_five_months`, `float_not_repaid_in_four`).

**Feasibility.**  `plan_feasible` checks, stage by stage, that nothing is
attempted before what it needs; `plan_needs_are_supplied_earlier` reads that
back as the general theorem.  `mirror_restarts_the_plan` is the bootstrap
proper: the capabilities the last stage publishes are enough to run every stage
after the first again, with no access to the original upstream.

**Checks.**  Every stage carries the command that certifies it
(`stage_checks_distinct`), and `scripts/bootstrap.sh` runs them in this order;
`scripts/bootstrap_check.py --check` verifies that the script and this file
agree on the commands.
-/

namespace SFM.Bootstrap

/-! ## The capabilities -/

namespace Cap

/-- The source tree. -/
abbrev source : Nat := 1
/-- The pinned Lean toolchain and the Mathlib revision. -/
abbrev toolchain : Nat := 2
/-- A clean `lake build`: every proof in the repository checked. -/
abbrev proofs : Nat := 3
/-- A running node. -/
abbrev node : Nat := 4
/-- The published single page. -/
abbrev page : Nat := 5
/-- The claimable badge pages. -/
abbrev badges : Nat := 6
/-- Two or more nodes gossiping. -/
abbrev mesh : Nat := 7
/-- The index feed, served. -/
abbrev index : Nat := 8
/-- The senate's roll call, taken. -/
abbrev senate : Nat := 9
/-- A verifier for model inference (wish 910). -/
abbrev verifier : Nat := 10
/-- Encrypted execution beyond additive masks (wish 911). -/
abbrev crypto : Nat := 11
/-- Toolchain semantics (wish 912). -/
abbrev semantics : Nat := 12
/-- Geometry and kinematics (wish 916). -/
abbrev geometry : Nat := 13
/-- The whole settlement loop, on chain (wish 915). -/
abbrev onchain : Nat := 14
/-- A market settling jobs. -/
abbrev market : Nat := 15
/-- A third party's mirror, bootstrapped from what was published. -/
abbrev mirror : Nat := 16

end Cap

/-! ## The money

Everything is in whole cents. -/

/-- One month of the whole infrastructure, at commodity token prices: the
monthly bill of `Pricing/Infra.lean`, rounded up to the cent. -/
abbrev monthlyRunCents : Int := 3313

/-- Wish 910, a verifier for model inference, at frontier prices. -/
abbrev wish910Cents : Int := 30384
/-- Wish 911, encrypted execution, at frontier prices. -/
abbrev wish911Cents : Int := 20256
/-- Wish 912, toolchain semantics, at frontier prices. -/
abbrev wish912Cents : Int := 20256
/-- Wish 916, geometry and kinematics, at frontier prices. -/
abbrev wish916Cents : Int := 15192
/-- Wish 915, the whole loop on chain, at frontier prices. -/
abbrev wish915Cents : Int := 40512

/-- **Assumed**, not measured: what hosting nodes for others earns in a month
once the mesh has more than one node. -/
abbrev assumedIncomeMesh : Int := 1200
/-- **Assumed**, not measured: what serving the index feed earns in a month. -/
abbrev assumedIncomeIndex : Int := 2000
/-- **Assumed**, not measured: senate dues, per month. -/
abbrev assumedIncomeSenate : Int := 1000
/-- **Assumed**, not measured: what settled verification jobs earn in a
month. -/
abbrev assumedIncomeVerifier : Int := 6000
/-- **Assumed**, not measured: what private jobs add, per month. -/
abbrev assumedIncomeCrypto : Int := 2000
/-- **Assumed**, not measured: what checked toolchain semantics add, per
month. -/
abbrev assumedIncomeSemantics : Int := 1500
/-- **Assumed**, not measured: what kinematic jobs add, per month. -/
abbrev assumedIncomeGeometry : Int := 1000
/-- **Assumed**, not measured: the gateway's fee on the on-chain loop, per
month. -/
abbrev assumedIncomeOnchain : Int := 8000

/-! ## The plan -/

/-- The thirteen stages, in order, one per month. -/
def plan : Plan :=
  [ { name := "seed"
      needs := []
      gives := [Cap.source, Cap.toolchain]
      cost := monthlyRunCents
      income := 0
      check := "cat lean-toolchain" },
    { name := "proofs"
      needs := [Cap.source, Cap.toolchain]
      gives := [Cap.proofs]
      cost := monthlyRunCents
      income := 0
      check := "lake build" },
    { name := "node"
      needs := [Cap.proofs]
      gives := [Cap.node]
      cost := monthlyRunCents
      income := 0
      check := "cd node && python3 -m unittest discover -s tests" },
    { name := "publish"
      needs := [Cap.proofs, Cap.node]
      gives := [Cap.page, Cap.badges]
      cost := monthlyRunCents
      income := 0
      check := "python3 web/build.py --out dist && node --test web/test-page.mjs" },
    { name := "mesh"
      needs := [Cap.node, Cap.page]
      gives := [Cap.mesh]
      cost := monthlyRunCents
      income := assumedIncomeMesh
      check := "node --test scripts/test_mesh_node.mjs" },
    { name := "index"
      needs := [Cap.proofs, Cap.mesh]
      gives := [Cap.index]
      cost := monthlyRunCents
      income := assumedIncomeIndex
      check := "python3 scripts/index_facts.py --check" },
    { name := "senate"
      needs := [Cap.badges, Cap.index]
      gives := [Cap.senate]
      cost := monthlyRunCents
      income := assumedIncomeSenate
      check := "python3 scripts/gen_desk_page.py --check" },
    { name := "wish 910 verifier"
      needs := [Cap.proofs, Cap.index]
      gives := [Cap.verifier]
      cost := monthlyRunCents + wish910Cents
      income := assumedIncomeVerifier
      check := "lake build RequestProject.Market.Verifier" },
    { name := "wish 911 encrypted execution"
      needs := [Cap.verifier]
      gives := [Cap.crypto]
      cost := monthlyRunCents + wish911Cents
      income := assumedIncomeCrypto
      check := "lake build RequestProject.Market.Encrypted" },
    { name := "wish 912 toolchain semantics"
      needs := [Cap.proofs, Cap.verifier]
      gives := [Cap.semantics]
      cost := monthlyRunCents + wish912Cents
      income := assumedIncomeSemantics
      check := "lake build RequestProject.Market.Toolchain" },
    { name := "wish 916 geometry and kinematics"
      needs := [Cap.verifier]
      gives := [Cap.geometry]
      cost := monthlyRunCents + wish916Cents
      income := assumedIncomeGeometry
      check := "lake build RequestProject.Market.Kinematics" },
    { name := "wish 915 the whole loop on chain"
      needs := [Cap.verifier, Cap.crypto, Cap.semantics, Cap.senate]
      gives := [Cap.onchain, Cap.market]
      cost := monthlyRunCents + wish915Cents
      income := assumedIncomeOnchain
      check := "lake build RequestProject.Market.Onchain" },
    { name := "mirror"
      needs := [Cap.page, Cap.mesh, Cap.index, Cap.onchain]
      gives := [Cap.source, Cap.toolchain, Cap.mirror]
      cost := monthlyRunCents
      income := 0
      check := "bash scripts/bootstrap.sh --from-mirror" } ]

/-- The float the plan opens with: $1,069.56, in cents. -/
abbrev openingFloat : Int := 106956

/-- The month that is repeated for ever once the plan is done: the standing
bill, and nothing new. -/
def maintenance : Stage :=
  { name := "maintenance"
    needs := [Cap.proofs, Cap.node]
    gives := []
    cost := monthlyRunCents
    income := 0
    check := "lake build" }

/-! ## What the plan is

Structural facts, decided from the plan itself. -/

/-- The plan has thirteen stages. -/
theorem plan_length : plan.length = 13 := by decide

/-- **Nothing is attempted before what it needs**, starting from a bare machine
that holds nothing at all. -/
theorem plan_feasible : FeasibleFrom [] plan = true := by decide

/-- The general reading of `plan_feasible`: every need of every stage is
supplied by a strictly earlier stage. -/
theorem plan_needs_are_supplied_earlier
    {pre : Plan} {s : Stage} {post : Plan} (hsplit : plan = pre ++ s :: post)
    {c : Nat} (hc : c ∈ s.needs) : c ∈ caps [] pre :=
  needs_supplied (hsplit ▸ plan_feasible) hc

/-- The plan ends holding all sixteen capabilities. -/
theorem plan_gives_everything :
    ∀ c ∈ [Cap.source, Cap.toolchain, Cap.proofs, Cap.node, Cap.page, Cap.badges, Cap.mesh,
      Cap.index, Cap.senate, Cap.verifier, Cap.crypto, Cap.semantics, Cap.geometry,
      Cap.onchain, Cap.market, Cap.mirror], c ∈ caps [] plan := by decide

/-- **The bootstrap closes.**  The last stage publishes the source and the
pinned toolchain, so everything after the opening fetch can be done again from
a mirror alone, with no access to the original upstream. -/
theorem mirror_restarts_the_plan :
    FeasibleFrom [Cap.source, Cap.toolchain] (plan.drop 1) = true := by decide

/-- …and the mirror's capabilities really are what the last stage gives. -/
theorem mirror_publishes_the_seed :
    (plan.getLast (by decide)).gives = [Cap.source, Cap.toolchain, Cap.mirror] := by decide

/-- The general fixed point, instantiated here: the plan runs again on its own
output. -/
theorem plan_reruns_on_its_own_output : FeasibleFrom (caps [] plan) plan = true :=
  feasible_from_caps plan_feasible

/-- Every stage carries a command that checks it. -/
theorem stage_checks_nonempty : ∀ s ∈ plan, s.check ≠ "" := by decide

/-- No two stages are checked by the same command. -/
theorem stage_checks_distinct : (plan.map Stage.check).Nodup := by decide

/-- No two stages have the same name. -/
theorem stage_names_distinct : (plan.map Stage.name).Nodup := by decide

/-! ## What the plan costs -/

/-- The five stages that buy a wish, and what they pay for it. -/
def wishSpendCents : Int :=
  wish910Cents + wish911Cents + wish912Cents + wish916Cents + wish915Cents

/-- **The plan spends $1,696.69**: thirteen months of running and the five open
wishes. -/
theorem total_cost : totalCost plan = 169669 := by decide

/-- …which is exactly thirteen monthly bills plus the wish list. -/
theorem total_cost_splits : totalCost plan = 13 * monthlyRunCents + wishSpendCents := by decide

/-- Every stage pays its month of the standing bill. -/
theorem every_stage_pays_the_month : ∀ s ∈ plan, monthlyRunCents ≤ s.cost := by decide

/-- The eight stages that need no wish cost exactly the standing bill. -/
theorem eight_stages_cost_only_the_month :
    (plan.filter (fun s => decide (s.cost = monthlyRunCents))).length = 8 := by decide

/-- **The budget line is the priced bill, rounded up to the cent.**  The
commodity monthly bill of `Pricing/Infra.lean` is under `monthlyRunCents` and
over one cent less. -/
theorem monthly_run_rounds_up_the_priced_bill :
    RequestProject.Pricing.monthlyBill RequestProject.Pricing.cheapestOffer 1
        ≤ (monthlyRunCents : ℚ) / 100 ∧
      (monthlyRunCents - 1 : ℚ) / 100
        < RequestProject.Pricing.monthlyBill RequestProject.Pricing.cheapestOffer 1 := by
  rw [RequestProject.Pricing.monthly_bill_commodity]
  norm_num

/-- **The wish spending is exactly the open programme at frontier prices**, as
priced in `Pricing/Wishes.lean`: $1,266.00. -/
theorem wish_spend_is_the_open_programme :
    (wishSpendCents : ℚ) / 100
      = RequestProject.Pricing.billOf RequestProject.Pricing.frontierRates
          RequestProject.Pricing.openWishes := by
  rw [RequestProject.Pricing.open_bill_frontier]
  norm_num [wishSpendCents]

/-- **Each wish stage pays that wish's price**, not just the right total: the
five open wishes of `Pricing/Wishes.lean`, in the plan's order, priced at the
frontier card, are the five figures the wish stages carry. -/
theorem wish_stages_are_the_open_wishes :
    RequestProject.Pricing.openWishes.map
        (fun w => (w.id, 100 * RequestProject.Pricing.frontierRates.bill w.workload))
      = [(910, (wish910Cents : ℚ)), (911, (wish911Cents : ℚ)), (912, (wish912Cents : ℚ)),
         (916, (wish916Cents : ℚ)), (915, (wish915Cents : ℚ))] := by
  norm_num [RequestProject.Pricing.openWishes, RequestProject.Pricing.wishPrices,
    RequestProject.Pricing.WishPrice.workload, RequestProject.Pricing.buildHours,
    RequestProject.Pricing.effortOf, RequestProject.Pricing.frontierRates,
    RequestProject.Pricing.RateCard.bill, RequestProject.Pricing.Offer.quote,
    RequestProject.Pricing.dearestOffer, RequestProject.Pricing.openaiGpt55Pro,
    RequestProject.Pricing.h100USDPerHour, RequestProject.Pricing.assumedStorageUSDPerGBMonth,
    RequestProject.Pricing.Effort.split, RequestProject.Pricing.Effort.outputTokens,
    RequestProject.Pricing.assumedTokensPerLine, RequestProject.Pricing.assumedDraftMultiplier,
    RequestProject.Pricing.assumedContextRatio]

/-! ## Whether the plan can be paid for -/

/-- **The plan needs an opening float of $1,069.56.** -/
theorem required_float : requiredFloat 0 plan = openingFloat := by decide

/-- With that float, and no revenue to begin with, the plan is solvent
throughout. -/
theorem plan_solvent : Solvent ⟨openingFloat, 0⟩ plan = true := by decide

/-- **And not a cent less**: a dollar short of the float, the plan goes
under. -/
theorem float_is_tight : Solvent ⟨openingFloat - 1, 0⟩ plan ≠ true := by decide

/-- The general threshold theorem, instantiated: affordable exactly at or above
`openingFloat`. -/
theorem affordable_iff {f : Int} : Solvent ⟨f, 0⟩ plan = true ↔ openingFloat ≤ f := by
  rw [solvent_iff_requiredFloat_le, required_float]

/-- The worst month is the twelfth, the on-chain loop: that is where the hole
is deepest. -/
theorem deepest_month :
    (run ⟨openingFloat, 0⟩ (plan.take 12)).cash = 0 := by decide

/-- **From the senate stage on, the standing revenue covers the standing
bill.**  It does not yet cover the wishes, which is what the float is for. -/
theorem self_funding_from_senate :
    monthlyRunCents ≤ (run ⟨openingFloat, 0⟩ (plan.take 7)).rate := by decide

/-- …and not before: after six stages the standing revenue is still short of a
month's bill. -/
theorem not_self_funding_before_senate :
    (run ⟨openingFloat, 0⟩ (plan.take 6)).rate < monthlyRunCents := by decide

/-- The plan ends with $193.87 in hand and $227.00 a month coming in. -/
theorem end_state : run ⟨openingFloat, 0⟩ plan = ⟨19387, 22700⟩ := by decide

/-- **Once the plan is done, the operation survives every horizon**: the
standing revenue covers the standing bill, so maintenance can be repeated for
ever without going under. -/
theorem maintenance_solvent_for_ever (n : ℕ) :
    Solvent (run ⟨openingFloat, 0⟩ plan) (List.replicate n maintenance) = true := by
  refine solvent_replicate_of_selfFunding ?_ ?_ ?_ n
  · rw [end_state]
    decide
  · rw [end_state]
    decide
  · decide

/-- **Five months after the last stage the float is back.** -/
theorem float_repaid_in_five_months :
    openingFloat ≤ (run (run ⟨openingFloat, 0⟩ plan) (List.replicate 5 maintenance)).cash := by
  decide

/-- …and four are not enough. -/
theorem float_not_repaid_in_four :
    (run (run ⟨openingFloat, 0⟩ plan) (List.replicate 4 maintenance)).cash < openingFloat := by
  decide

/-! ## What is assumed

The revenue figures are assumptions.  This is what the plan would look like if
none of them held: with no revenue at all, the float required is the whole
spend. -/

/-- The same plan with every revenue set to zero. -/
def planNoRevenue : Plan := plan.map (fun s => { s with income := 0 })

/-- **With no revenue at all, the float required is the entire spend** —
$1,696.69 instead of $1,069.56, so the assumed revenue is carrying $627.13 of
the programme. -/
theorem no_revenue_float :
    requiredFloat 0 planNoRevenue = totalCost plan ∧
      requiredFloat 0 planNoRevenue - requiredFloat 0 plan = 62713 := by
  decide

end SFM.Bootstrap
