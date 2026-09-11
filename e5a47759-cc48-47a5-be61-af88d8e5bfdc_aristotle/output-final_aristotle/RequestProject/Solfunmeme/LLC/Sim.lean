/-
  Sim.lean — Introspector LLC, as a New Jersey company, and its filings,
  simulated.

  `RequestProject/LLC/Entity.lean` gives the shape of a New Jersey entity and
  `RequestProject/LLC/Filings.lean` gives the forms, the calendar and the
  standing machine.  This file instantiates them: one concrete company, one
  concrete five-year calendar, and the runs of the standing machine that the
  calendar induces.  Every fact below is checked by the kernel, so the numbers
  in the rendered packet are the numbers the model actually produces.

  What is checked:

    * `introspector_is_well_formed` — the formation packet passes the
      checklist: designator, New Jersey registered office, units outstanding,
      a valid formation date, a stated purpose;
    * `cap_table_*` — the cap table adds up, and the founder holds a majority
      in interest;
    * `plan_length`, `plan_fee_cents` — the five-year calendar is 80 filings
      costing $500.00 in the assumed fee schedule;
    * `plan_dates_are_valid` — every due date in it is a real date;
    * `compliant_plan_ends_in_good_standing` — filing the whole calendar on
      time leaves the company in good standing with nothing outstanding and
      the fees paid;
    * `two_lapses_revoke_the_charter` and `back_reports_then_reinstatement`
      — missing two annual reports revokes the charter, and the way back is
      the back reports and then the reinstatement, in that order;
    * `dissolution_needs_clearance_here` — a dissolution moved without a tax
      clearance on the record does nothing.

  This is a simulation.  The forms, the fee figures and the deadlines are
  parameters of the model, chosen to be plausible; they are not asserted to be
  the current requirements of any office, and nothing here is legal or tax
  advice.
-/

import RequestProject.Solfunmeme.LLC.Filings

set_option maxRecDepth 100000

namespace LLC.Sim

open LLC

/-! ### The company -/

/-- The principal office. -/
def office : Address :=
  { line1 := "1 Prospect Street, Suite 200", city := "Trenton", state := "NJ", postal := "08608" }

/-- The registered office, in New Jersey, where service of process is
accepted. -/
def registeredOffice : Address :=
  { line1 := "1 Prospect Street, Suite 200", city := "Trenton", state := "NJ", postal := "08608" }

/-- The members of the company.  The founder holds a majority in interest; the
two shard members hold the rest. -/
def members : List Member :=
  [ { name := "Meta Introspector Holdings", address := office,
      units := 6000, contributionCents := 6000000 },
    { name := "Shard: European Union", address := office,
      units := 2500, contributionCents := 2500000 },
    { name := "Shard: United Kingdom", address := office,
      units := 1500, contributionCents := 1500000 } ]

/-- The purposes stated in the formation packet, taken from the uploaded
business model. -/
def purposes : List String :=
  [ "operation of a zero-knowledge machine learning compliance platform",
    "subscription licensing of the ZKPML department in a box",
    "provision of hardware execution and resource access",
    "consulting, setup and support services",
    "operation of web services and application programming interfaces",
    "any lawful act or activity for which a limited liability company may be "
      ++ "organized under the laws of the State of New Jersey" ]

/-- **Introspector LLC**, as the filing record sees it. -/
def introspector : Entity :=
  { legalName := "Introspector LLC"
    state := "NJ"
    principalOffice := office
    agent := { name := "Registered Agents of New Jersey, Inc.", office := registeredOffice }
    formation := ⟨2026, 1, 15⟩
    fiscalYearEndMonth := 12
    management := .memberManaged
    taxElection := .corporation
    members := members
    purposes := purposes
    businessId := some "NJ-0450123456"
    ein := some "88-4501234" }

/-- **The formation packet passes the checklist.** -/
theorem introspector_is_well_formed : introspector.wellFormed = true := by decide +kernel

theorem cap_table_totals : introspector.totalUnits = 10000 := by decide

theorem cap_table_contributions : introspector.totalContributionCents = 10000000 := by decide

/-- **The founder holds a majority in interest**, so the operating agreement's
majority votes are decided by that member. -/
theorem founder_holds_majority :
    introspector.majorityInInterest "Meta Introspector Holdings" = true := by decide

theorem founder_holds_6000_bps : introspector.bps "Meta Introspector Holdings" = 6000 := by decide

theorem shards_hold_the_rest :
    introspector.bps "Shard: European Union" = 2500
      ∧ introspector.bps "Shard: United Kingdom" = 1500 := by decide

/-! ### The five-year filing calendar -/

/-- The filing plan: the formation packet, then five annual cycles. -/
def plan : List Filing := introspector.calendar 5

theorem plan_length : plan.length = 80 := by decide

/-- **What the plan costs**, under the assumed fee schedule: the formation
filing and five annual reports. -/
theorem plan_fee_cents : introspector.calendarFeeCents 5 = 50000 := by decide

/-- **Every due date in the plan is a real date.** -/
theorem plan_dates_are_valid : ∀ f ∈ plan, f.due.valid = true :=
  Entity.calendar_dates_valid introspector 5 (by decide) (by decide) (by decide) (by decide)
    (by decide)

/-- The annual reports in the plan, one per year, each due on the last day of
January — the anniversary month. -/
theorem plan_annual_reports :
    (plan.filter (fun f => f.form == Form.annualReport)).map (fun f => (f.period, f.due))
      = [(2027, ⟨2027, 1, 31⟩), (2028, ⟨2028, 1, 31⟩), (2029, ⟨2029, 1, 31⟩),
         (2030, ⟨2030, 1, 31⟩), (2031, ⟨2031, 1, 31⟩)] := by decide

/-- The filings that are open to inspection, as against the returns and the
operating agreement, which are not. -/
theorem plan_public_records :
    (plan.filter (fun f => Form.isPublicRecord f.form)).length = 9 := by decide

/-! ### Running the calendar -/

/-- Filing everything in the plan, each on its due date. -/
def compliantEvents : List Event := plan.map (fun f => Event.file f f.due)

/-- **A company that files its calendar stays in good standing**, with nothing
outstanding, having paid exactly the calendar's fees. -/
theorem compliant_plan_ends_in_good_standing :
    (Record.opening.run compliantEvents).standing = Standing.good
      ∧ (Record.opening.run compliantEvents).outstandingReports = 0
      ∧ (Record.opening.run compliantEvents).feesPaidCents = 50000 := by decide

/-- The first two annual reports of the plan. -/
def report (n : Nat) : Filing :=
  ⟨Form.annualReport, 2026 + n, 0, Date.lastDay (2026 + n) 1, Form.assumedFeeCents .annualReport⟩

/-- A company that lets two annual reports lapse. -/
def lapsedEvents : List Event :=
  [Event.deadlineMissed (report 1), Event.deadlineMissed (report 2)]

/-- **Two lapses revoke the charter.** -/
theorem two_lapses_revoke_the_charter :
    (Record.opening.run lapsedEvents).standing = Standing.revoked
      ∧ (Record.opening.run lapsedEvents).outstandingReports = 2 := by decide

/-- The way back: the two back reports, then the reinstatement. -/
def cureEvents : List Event :=
  [ Event.file (report 1) ⟨2028, 6, 1⟩,
    Event.file (report 2) ⟨2028, 6, 1⟩,
    Event.file ⟨Form.reinstatement, 2028, 0, ⟨2028, 6, 1⟩,
      Form.assumedFeeCents .reinstatement⟩ ⟨2028, 6, 1⟩ ]

/-- **The back reports and then the reinstatement restore good standing.** -/
theorem back_reports_then_reinstatement :
    ((Record.opening.run lapsedEvents).run cureEvents).standing = Standing.good
      ∧ ((Record.opening.run lapsedEvents).run cureEvents).outstandingReports = 0 := by decide

/-- **A reinstatement presented before the back reports is refused**, and the
charter stays revoked. -/
theorem reinstatement_first_is_refused :
    ((Record.opening.run lapsedEvents).run
      [Event.file ⟨Form.reinstatement, 2028, 0, ⟨2028, 6, 1⟩,
        Form.assumedFeeCents .reinstatement⟩ ⟨2028, 6, 1⟩]).standing
      = Standing.revoked := by decide

/-- **Dissolution without a tax clearance does nothing**, on this record. -/
theorem dissolution_needs_clearance_here :
    (Record.opening.run compliantEvents).run [Event.dissolve ⟨2032, 3, 1⟩]
      = Record.opening.run compliantEvents := by decide

/-- Dissolution done properly: the clearance, then the certificate. -/
def windUpEvents : List Event :=
  [ Event.file ⟨Form.taxClearance, 2032, 0, ⟨2032, 2, 1⟩,
      Form.assumedFeeCents .taxClearance⟩ ⟨2032, 2, 1⟩,
    Event.file ⟨Form.certificateOfDissolution, 2032, 0, ⟨2032, 3, 1⟩,
      Form.assumedFeeCents .certificateOfDissolution⟩ ⟨2032, 3, 1⟩,
    Event.dissolve ⟨2032, 3, 1⟩ ]

/-- **With a clearance on the record, the company can be dissolved.** -/
theorem wind_up_dissolves :
    ((Record.opening.run compliantEvents).run windUpEvents).standing
      = Standing.dissolved := by decide

/-! ### The business model, instantiated -/

/-- A quarter of revenue across the four streams the business model names, in
cents. -/
def quarterRevenue : Revenue :=
  { subscriptionCents := 48000000, hardwareCents := 12500000,
    consultingCents := 21000000, webServiceCents := 6500000 }

theorem quarter_revenue_total : quarterRevenue.total = 88000000 := by decide

/-- The jurisdictional shards, weighted by contribution. -/
def shards : List Shard :=
  [ ⟨"New Jersey", 6000⟩, ⟨"European Union", 2500⟩, ⟨"United Kingdom", 1500⟩ ]

/-- **The quarter's profit pool is shared out to the cent** among the shards,
by the same largest-remainder rule the federal model apportions seats with. -/
theorem shard_split_of_the_quarter :
    shardSplit shards quarterRevenue.total
      = [("New Jersey", 52800000), ("European Union", 22000000),
         ("United Kingdom", 13200000)] := by decide

theorem shard_split_is_exact_here :
    ((shardSplit shards quarterRevenue.total).map Prod.snd).sum = quarterRevenue.total := by decide

/-! ### Rendering the packet -/

private def line (label value : String) : String := label ++ ": " ++ value ++ "\n"

/-- An address on one line. -/
def renderAddress (a : Address) : String :=
  a.line1 ++ ", " ++ a.city ++ ", " ++ a.state ++ " " ++ a.postal

/-- A date as `YYYY-MM-DD`. -/
def renderDate (d : Date) : String :=
  let pad (n : Nat) : String := if n < 10 then "0" ++ toString n else toString n
  toString d.year ++ "-" ++ pad d.month ++ "-" ++ pad d.day

/-- Cents as dollars. -/
def renderCents (c : Nat) : String :=
  let d := c / 100
  let r := c % 100
  "$" ++ toString d ++ "." ++ (if r < 10 then "0" ++ toString r else toString r)

/-- The formation packet, as text. -/
def packetText (e : Entity) : String :=
  line "entity" e.legalName
    ++ line "state" e.state
    ++ line "principal-office" (renderAddress e.principalOffice)
    ++ line "registered-agent" e.agent.name
    ++ line "registered-office" (renderAddress e.agent.office)
    ++ line "formation" (renderDate e.formation)
    ++ line "fiscal-year-end-month" (toString e.fiscalYearEndMonth)
    ++ line "management" (match e.management with
        | .memberManaged => "member-managed" | .managerManaged => "manager-managed")
    ++ line "tax-election" (match e.taxElection with
        | .partnership => "partnership" | .corporation => "corporation")
    ++ line "business-id" (e.businessId.getD "(pending)")
    ++ line "ein" (e.ein.getD "(pending)")
    ++ line "units-outstanding" (toString e.totalUnits)
    ++ line "capital-contributed" (renderCents e.totalContributionCents)
    ++ String.join (e.members.map fun m =>
        line "member" (m.name ++ " — " ++ toString m.units ++ " units ("
          ++ toString (e.bps m.name) ++ " bps), " ++ renderCents m.contributionCents))
    ++ String.join (e.purposes.map fun p => line "purpose" p)

/-- One filing, as a line. -/
def renderFiling (f : Filing) : String :=
  renderDate f.due ++ "  " ++ Form.label f.form
    ++ (if f.period == 0 then "" else "  period=" ++ toString f.period)
    ++ (if f.quarter == 0 then "" else " q" ++ toString f.quarter)
    ++ "  fee=" ++ renderCents f.feeCents
    ++ (if Form.isPublicRecord f.form then "  [public record]" else "  [not public]")

/-- The whole calendar, as text. -/
def calendarText (e : Entity) (years : Nat) : String :=
  "# filing calendar (simulated)\n"
    ++ line "entity" e.legalName
    ++ line "years" (toString years)
    ++ line "filings" (toString (e.calendar years).length)
    ++ line "total-fees" (renderCents (e.calendarFeeCents years))
    ++ "\n"
    ++ String.join ((e.calendar years).map (fun f => renderFiling f ++ "\n"))

/-- The whole simulated packet: the entity, then its calendar. -/
def simulationText : String :=
  "# introspector llc — new jersey formation packet (simulated)\n"
    ++ "# not legal or tax advice; fees and deadlines are model parameters\n\n"
    ++ packetText introspector ++ "\n"
    ++ calendarText introspector 5

end LLC.Sim
