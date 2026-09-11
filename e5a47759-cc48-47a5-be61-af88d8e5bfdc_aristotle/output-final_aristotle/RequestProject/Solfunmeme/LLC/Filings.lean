/-
  Filings.lean — the filing calendar and the standing machine.

  A simulation, not legal advice.  Form names, fee amounts and due-date rules
  are *parameters of the model*: they are collected in `assumedFeeCents` and
  `dueDate` so that one edit changes them everywhere, and every theorem below
  says what follows from the model, never what a filing office will do.  Tax
  *liability* is not modelled at all — only the filing obligations and their
  filing fees.

  The catalogue covers the formation packet, the annual state filings, the
  ongoing tax filings of an LLC that has elected corporate treatment, the
  quarterly employment and sales filings, a private-offering notice pair, and
  the events that end or interrupt the entity's life (amendment, agent change,
  revocation, reinstatement, tax clearance, dissolution).

  The standing machine has four states — good standing, delinquent, revoked,
  dissolved — and three events: a filing is made, a deadline passes unfiled, or
  dissolution is moved.  What is proved:

    * `compliant_run_stays_good` — a run that files and never misses a deadline
      stays in good standing with nothing outstanding;
    * `one_missed_report_is_delinquent`, `two_missed_reports_revoke` — one
      missed annual report is delinquency, the second is revocation;
    * `revoked_needs_reinstatement` — from revocation nothing but a
      reinstatement restores good standing, and
      `reinstatement_needs_back_reports` — a reinstatement with reports still
      outstanding is refused outright;
    * `dissolution_needs_clearance` — dissolution takes effect only from good
      standing and only with a tax clearance on file, and
      `dissolved_is_absorbing` — after dissolution no event changes anything;
    * `fees_are_monotone`, `fees_only_for_accepted_filings` — the fee ledger
      moves only when a filing is accepted, and then by exactly that filing's
      fee.
-/

import RequestProject.Solfunmeme.LLC.Entity

namespace LLC

/-! ### The catalogue -/

/-- Who the filing goes to. -/
inductive Authority where
  /-- New Jersey Division of Revenue and Enterprise Services. -/
  | njRevenue
  /-- New Jersey Division of Taxation. -/
  | njTaxation
  /-- Internal Revenue Service. -/
  | irs
  /-- Securities regulator (federal notice and the matching state notice). -/
  | securities
  /-- Kept in the company's own records; not filed with anybody. -/
  | internal
deriving DecidableEq, Repr, Inhabited

/-- The filings the model knows about. -/
inductive Form where
  /-- Public Records Filing for a new business entity (the formation filing). -/
  | publicRecordsFiling
  /-- Designation of a registered agent and registered office. -/
  | registeredAgentDesignation
  /-- The operating agreement: adopted, not filed. -/
  | operatingAgreement
  /-- Application for a federal employer identification number. -/
  | einApplication
  /-- State business registration. -/
  | businessRegistration
  /-- The annual report. -/
  | annualReport
  /-- State corporation business tax return. -/
  | stateCorporateTaxReturn
  /-- Federal corporate income tax return. -/
  | federalCorporateTaxReturn
  /-- Quarterly federal employment tax return. -/
  | federalEmploymentQuarterly
  /-- Quarterly state employer report. -/
  | stateEmployerQuarterly
  /-- Quarterly sales and use tax return. -/
  | salesUseQuarterly
  /-- Federal notice of an exempt private offering. -/
  | privateOfferingNotice
  /-- The matching state notice for the same offering. -/
  | stateOfferingNotice
  /-- Certificate of amendment. -/
  | certificateOfAmendment
  /-- Change of registered agent or office. -/
  | changeOfAgent
  /-- Reinstatement after revocation. -/
  | reinstatement
  /-- Tax clearance certificate, a precondition of dissolution. -/
  | taxClearance
  /-- Certificate of dissolution. -/
  | certificateOfDissolution
deriving DecidableEq, Repr, Inhabited

namespace Form

/-- Where each filing goes. -/
def authority : Form → Authority
  | publicRecordsFiling | registeredAgentDesignation | annualReport
  | certificateOfAmendment | changeOfAgent | reinstatement
  | certificateOfDissolution | businessRegistration => .njRevenue
  | stateCorporateTaxReturn | stateEmployerQuarterly | salesUseQuarterly
  | taxClearance => .njTaxation
  | einApplication | federalCorporateTaxReturn | federalEmploymentQuarterly => .irs
  | privateOfferingNotice | stateOfferingNotice => .securities
  | operatingAgreement => .internal

/-- The form's short name, as it appears on the packet. -/
def label : Form → String
  | publicRecordsFiling => "public-records-filing-new-business-entity"
  | registeredAgentDesignation => "registered-agent-designation"
  | operatingAgreement => "operating-agreement"
  | einApplication => "ein-application"
  | businessRegistration => "business-registration"
  | annualReport => "annual-report"
  | stateCorporateTaxReturn => "state-corporate-tax-return"
  | federalCorporateTaxReturn => "federal-corporate-tax-return"
  | federalEmploymentQuarterly => "federal-employment-quarterly"
  | stateEmployerQuarterly => "state-employer-quarterly"
  | salesUseQuarterly => "sales-use-quarterly"
  | privateOfferingNotice => "private-offering-notice"
  | stateOfferingNotice => "state-offering-notice"
  | certificateOfAmendment => "certificate-of-amendment"
  | changeOfAgent => "change-of-registered-agent"
  | reinstatement => "reinstatement"
  | taxClearance => "tax-clearance"
  | certificateOfDissolution => "certificate-of-dissolution"

/-- **Assumed** filing fees, in cents.  Simulation parameters, not a schedule
of the law: change them here and the whole calendar changes with them. -/
def assumedFeeCents : Form → Nat
  | publicRecordsFiling => 12500
  | annualReport => 7500
  | reinstatement => 7500
  | certificateOfAmendment => 10000
  | changeOfAgent => 2500
  | certificateOfDissolution => 12000
  | taxClearance => 20000
  | _ => 0

/-- Is the filing on the public record?  This is what the zero-knowledge schema
later has to respect: what is public may be revealed, what is not must be
proved about rather than shown. -/
def isPublicRecord : Form → Bool
  | operatingAgreement => false
  | stateCorporateTaxReturn | federalCorporateTaxReturn => false
  | federalEmploymentQuarterly | stateEmployerQuarterly | salesUseQuarterly => false
  | taxClearance => false
  | _ => true

end Form

/-- A filing: which form, for which period, when it is due, and what it costs
to file. -/
structure Filing where
  /-- The form. -/
  form : Form
  /-- The period it covers: a year, or 0 for a one-off filing. -/
  period : Nat
  /-- The quarter it covers, or 0. -/
  quarter : Nat
  /-- The due date. -/
  due : Date
  /-- The filing fee, in cents. -/
  feeCents : Nat
deriving DecidableEq, Repr, Inhabited

/-! ### The calendar -/

namespace Entity

/-- The formation packet: everything filed to bring the entity into
existence and register it. -/
def formationPacket (e : Entity) : List Filing :=
  let d := e.formation
  [ ⟨.publicRecordsFiling, d.year, 0, d, Form.assumedFeeCents .publicRecordsFiling⟩,
    ⟨.registeredAgentDesignation, d.year, 0, d, Form.assumedFeeCents .registeredAgentDesignation⟩,
    ⟨.operatingAgreement, d.year, 0, d, Form.assumedFeeCents .operatingAgreement⟩,
    ⟨.einApplication, d.year, 0, d, Form.assumedFeeCents .einApplication⟩,
    ⟨.businessRegistration, d.year, 0, Date.lastDay d.year d.month,
      Form.assumedFeeCents .businessRegistration⟩ ]

/-- The quarterly filings of one year: the employment and sales returns, due
in the month after each quarter closes. -/
def quarterlyFilings (year : Nat) : List Filing :=
  (List.range 4).flatMap fun q =>
    let dueMonth := 3 * q + 4
    let y := if dueMonth ≤ 12 then year else year + 1
    let m := if dueMonth ≤ 12 then dueMonth else dueMonth - 12
    [ ⟨.federalEmploymentQuarterly, year, q + 1, Date.lastDay y m,
        Form.assumedFeeCents .federalEmploymentQuarterly⟩,
      ⟨.stateEmployerQuarterly, year, q + 1, Date.lastDay y m,
        Form.assumedFeeCents .stateEmployerQuarterly⟩,
      ⟨.salesUseQuarterly, year, q + 1, ⟨y, m, 20⟩,
        Form.assumedFeeCents .salesUseQuarterly⟩ ]

/-- The filings of the `n`-th year after formation: the annual report, due on
the last day of the anniversary month, and the two corporate returns, due in
the fourth month after the fiscal year closes. -/
def annualCycle (e : Entity) (n : Nat) : List Filing :=
  let year := e.formation.year + n
  let reportDue := Date.lastDay year e.formation.month
  let taxMonth := e.fiscalYearEndMonth + 4
  let taxYear := if taxMonth ≤ 12 then year + 1 else year + 2
  let taxM := if taxMonth ≤ 12 then taxMonth else taxMonth - 12
  [ ⟨.annualReport, year, 0, reportDue, Form.assumedFeeCents .annualReport⟩,
    ⟨.stateCorporateTaxReturn, year, 0, ⟨taxYear, taxM, 15⟩,
      Form.assumedFeeCents .stateCorporateTaxReturn⟩,
    ⟨.federalCorporateTaxReturn, year, 0, ⟨taxYear, taxM, 15⟩,
      Form.assumedFeeCents .federalCorporateTaxReturn⟩ ]
    ++ quarterlyFilings year

/-- The whole calendar: the formation packet, then `years` annual cycles
starting with the first anniversary. -/
def calendar (e : Entity) (years : Nat) : List Filing :=
  formationPacket e ++ (List.range years).flatMap (fun n => annualCycle e (n + 1))

/-- What the calendar costs to file, in cents. -/
def calendarFeeCents (e : Entity) (years : Nat) : Nat :=
  ((calendar e years).map (fun f => f.feeCents)).foldl (· + ·) 0

/-- **Every annual report falls in the anniversary month**, on its last day. -/
theorem annual_report_in_anniversary_month (e : Entity) (n : Nat) :
    ∀ f ∈ annualCycle e n, f.form = Form.annualReport →
      f.due = Date.lastDay (e.formation.year + n) e.formation.month := by
  intro f hf hform
  simp only [annualCycle, quarterlyFilings, List.mem_append, List.mem_cons,
    List.mem_flatMap, List.not_mem_nil, or_false] at hf
  rcases hf with (rfl | rfl | rfl) | ⟨a, _, (rfl | rfl | rfl)⟩
  · rfl
  · exact Form.noConfusion hform
  · exact Form.noConfusion hform
  · exact Form.noConfusion hform
  · exact Form.noConfusion hform
  · exact Form.noConfusion hform

/-- **Every due date in the calendar is a date on the calendar.** -/
theorem calendar_dates_valid (e : Entity) (years : Nat) (hm1 : 1 ≤ e.formation.month)
    (hm2 : e.formation.month ≤ 12) (hf1 : 1 ≤ e.fiscalYearEndMonth)
    (hf2 : e.fiscalYearEndMonth ≤ 12) (hform : e.formation.valid = true) :
    ∀ f ∈ calendar e years, f.due.valid = true := by
  intro f hf
  simp only [calendar, List.mem_append, List.mem_flatMap, List.mem_range] at hf
  rcases hf with h | ⟨n, _, h⟩
  · simp only [formationPacket, List.mem_cons, List.not_mem_nil, or_false] at h
    rcases h with rfl | rfl | rfl | rfl | rfl
    · exact hform
    · exact hform
    · exact hform
    · exact hform
    · exact Date.lastDay_valid hm1 hm2
  · simp only [annualCycle, quarterlyFilings, List.mem_append, List.mem_cons,
      List.mem_flatMap, List.mem_range, List.not_mem_nil, or_false] at h
    rcases h with (rfl | rfl | rfl) | ⟨a, ha, (rfl | rfl | rfl)⟩
    · exact Date.lastDay_valid hm1 hm2
    · exact Date.valid_of_day_le_28 (by split <;> omega) (by split <;> omega) (by omega)
        (by omega)
    · exact Date.valid_of_day_le_28 (by split <;> omega) (by split <;> omega) (by omega)
        (by omega)
    · exact Date.lastDay_valid (by split <;> omega) (by split <;> omega)
    · exact Date.lastDay_valid (by split <;> omega) (by split <;> omega)
    · exact Date.valid_of_day_le_28 (by split <;> omega) (by split <;> omega) (by omega)
        (by omega)

end Entity

/-! ### Standing -/

/-- The entity's standing on the public record. -/
inductive Standing where
  /-- In good standing. -/
  | good
  /-- A report is outstanding. -/
  | delinquent
  /-- The charter has been revoked for failure to file. -/
  | revoked
  /-- Wound up. -/
  | dissolved
deriving DecidableEq, Repr, Inhabited

/-- What the record office knows about the entity. -/
structure Record where
  /-- Current standing. -/
  standing : Standing
  /-- Filings accepted, as form and period. -/
  filed : List (Form × Nat)
  /-- Annual reports outstanding. -/
  outstandingReports : Nat
  /-- Filing fees paid, in cents. -/
  feesPaidCents : Nat
deriving DecidableEq, Repr, Inhabited

/-- The opening record: nothing filed, nothing outstanding. -/
def Record.opening : Record := ⟨.good, [], 0, 0⟩

/-- What can happen. -/
inductive Event where
  /-- A filing is presented on a date. -/
  | file (f : Filing) (on : Date)
  /-- A due date passes with the filing not made. -/
  | deadlineMissed (f : Filing)
  /-- Dissolution is moved. -/
  | dissolve (on : Date)
deriving DecidableEq, Repr, Inhabited

namespace Record

/-- Will the office accept this filing?  Nothing is accepted from a dissolved
entity; a revoked entity may file its outstanding annual reports, and may file
a reinstatement once none are outstanding, and nothing else. -/
def accepts (r : Record) (f : Filing) : Bool :=
  match r.standing with
  | .dissolved => false
  | .revoked =>
      (f.form == Form.annualReport)
        || (f.form == Form.reinstatement && r.outstandingReports == 0)
  | _ => true

/-- One event. -/
def step (r : Record) (ev : Event) : Record :=
  match ev with
  | .file f _ =>
      if r.accepts f then
        let r1 : Record :=
          { r with filed := (f.form, f.period) :: r.filed,
                   feesPaidCents := r.feesPaidCents + f.feeCents }
        if f.form == Form.annualReport then
          let m := r.outstandingReports - 1
          { r1 with outstandingReports := m,
                    standing := if r.standing == Standing.delinquent && m == 0 then
                      Standing.good else r.standing }
        else if f.form == Form.reinstatement then { r1 with standing := Standing.good }
        else r1
      else r
  | .deadlineMissed f =>
      if f.form == Form.annualReport
          && (r.standing == Standing.good || r.standing == Standing.delinquent) then
        let m := r.outstandingReports + 1
        { r with outstandingReports := m,
                 standing := if 2 ≤ m then Standing.revoked else Standing.delinquent }
      else r
  | .dissolve _ =>
      if r.standing == Standing.good && r.filed.any (fun p => p.1 == Form.taxClearance) then
        { r with standing := Standing.dissolved }
      else r

/-- A run of events. -/
def run (r : Record) (evs : List Event) : Record := evs.foldl step r

theorem run_nil (r : Record) : r.run [] = r := rfl

theorem run_cons (r : Record) (ev : Event) (evs : List Event) :
    r.run (ev :: evs) = (r.step ev).run evs := rfl

/-! ### What the machine guarantees -/

/-- **A compliant run stays in good standing.**  If every event is a filing —
no deadline is ever missed — then from good standing with nothing outstanding
the entity is still in good standing with nothing outstanding. -/
theorem compliant_run_stays_good (r : Record) (evs : List Event)
    (hgood : r.standing = Standing.good) (hout : r.outstandingReports = 0)
    (honly : ∀ ev ∈ evs, ∃ f d, ev = Event.file f d) :
    (r.run evs).standing = Standing.good ∧ (r.run evs).outstandingReports = 0 := by
  induction evs generalizing r with
  | nil => exact ⟨hgood, hout⟩
  | cons ev t ih =>
      obtain ⟨f, d, rfl⟩ := honly ev (by simp)
      have hstep : (r.step (Event.file f d)).standing = Standing.good ∧
          (r.step (Event.file f d)).outstandingReports = 0 := by
        simp only [step, accepts, hgood]
        by_cases h1 : f.form = Form.annualReport
        · simp [h1, hout]
        · by_cases h2 : f.form = Form.reinstatement
          · simp [h2, hout]
          · simp [h1, h2, hout]
      rw [run_cons]
      exact ih _ hstep.1 hstep.2 (fun x hx => honly x (by simp [hx]))

/-- **One missed annual report is delinquency, not revocation.** -/
theorem one_missed_report_is_delinquent (r : Record) (f : Filing)
    (hgood : r.standing = Standing.good) (hout : r.outstandingReports = 0)
    (hform : f.form = Form.annualReport) :
    (r.step (Event.deadlineMissed f)).standing = Standing.delinquent := by
  simp [step, hform, hgood, hout]

/-- **The second missed annual report revokes the charter.** -/
theorem two_missed_reports_revoke (r : Record) (f g : Filing)
    (hgood : r.standing = Standing.good) (hout : r.outstandingReports = 0)
    (hf : f.form = Form.annualReport) (hg : g.form = Form.annualReport) :
    ((r.step (Event.deadlineMissed f)).step (Event.deadlineMissed g)).standing
      = Standing.revoked := by
  simp [step, hf, hg, hgood, hout]

/-- **From revocation, nothing but a reinstatement restores good standing.** -/
theorem revoked_needs_reinstatement (r : Record) (ev : Event)
    (hrev : r.standing = Standing.revoked)
    (hnot : ∀ f d, ev = Event.file f d → f.form ≠ Form.reinstatement) :
    (r.step ev).standing = Standing.revoked := by
  cases ev with
  | file f d =>
      have hform : f.form ≠ Form.reinstatement := hnot f d rfl
      by_cases hacc : r.accepts f
      · have hann : f.form = Form.annualReport := by
          simp only [accepts, hrev, Bool.or_eq_true, beq_iff_eq, Bool.and_eq_true] at hacc
          rcases hacc with h | ⟨h, _⟩
          · exact h
          · exact absurd h hform
        simp [step, hacc, hann, hrev]
      · simp [step, hacc, hrev]
  | deadlineMissed f => simp [step, hrev]
  | dissolve d => simp [step, hrev]

/-- **A reinstatement with reports still outstanding is refused outright.** -/
theorem reinstatement_needs_back_reports (r : Record) (f : Filing) (d : Date)
    (hrev : r.standing = Standing.revoked) (hform : f.form = Form.reinstatement)
    (hout : 0 < r.outstandingReports) : r.step (Event.file f d) = r := by
  have hacc : r.accepts f = false := by
    unfold accepts
    rw [hrev]
    simp only [hform, beq_self_eq_true, Bool.true_and, Bool.or_eq_false_iff]
    refine ⟨by decide, ?_⟩
    simp only [beq_eq_false_iff_ne, ne_eq]
    omega
  simp [step, hacc]

/-- **A reinstatement with everything filed restores good standing.** -/
theorem reinstatement_restores_good_standing (r : Record) (f : Filing) (d : Date)
    (hrev : r.standing = Standing.revoked) (hform : f.form = Form.reinstatement)
    (hout : r.outstandingReports = 0) :
    (r.step (Event.file f d)).standing = Standing.good := by
  have hacc : r.accepts f = true := by simp [accepts, hrev, hform, hout]
  simp [step, hacc, hform]

/-- **Dissolution takes effect only from good standing and only with a tax
clearance on file.** -/
theorem dissolution_needs_clearance (r : Record) (d : Date)
    (h : (r.step (Event.dissolve d)).standing = Standing.dissolved)
    (hnot : r.standing ≠ Standing.dissolved) :
    r.standing = Standing.good ∧ r.filed.any (fun p => p.1 == Form.taxClearance) = true := by
  simp only [step] at h
  by_cases hc : (r.standing == Standing.good
      && r.filed.any (fun p => p.1 == Form.taxClearance)) = true
  · simp only [Bool.and_eq_true, beq_iff_eq] at hc
    exact ⟨hc.1, hc.2⟩
  · rw [if_neg hc] at h
    exact absurd h hnot

/-- **Dissolution is the end**: no event changes a dissolved record. -/
theorem dissolved_is_absorbing (r : Record) (ev : Event)
    (h : r.standing = Standing.dissolved) : r.step ev = r := by
  cases ev with
  | file f d => simp [step, accepts, h]
  | deadlineMissed f => simp [step, h]
  | dissolve d => simp [step, h]

theorem dissolved_run_is_absorbing (r : Record) (evs : List Event)
    (h : r.standing = Standing.dissolved) : r.run evs = r := by
  induction evs generalizing r with
  | nil => rfl
  | cons ev t ih => rw [run_cons, dissolved_is_absorbing r ev h]; exact ih r h

/-- **The fee ledger never falls.** -/
theorem fees_are_monotone (r : Record) (ev : Event) :
    r.feesPaidCents ≤ (r.step ev).feesPaidCents := by
  cases ev with
  | file f d =>
      by_cases hacc : r.accepts f
      · by_cases h1 : f.form = Form.annualReport
        · simp [step, hacc, h1]
        · by_cases h2 : f.form = Form.reinstatement <;> simp [step, hacc, h1, h2]
      · simp [step, hacc]
  | deadlineMissed f =>
      by_cases h : f.form = Form.annualReport <;> simp only [step, h] <;> split <;> simp
  | dissolve d => simp only [step]; split <;> simp

/-- **A refused filing costs nothing**, and an accepted one costs exactly its
fee. -/
theorem fees_only_for_accepted_filings (r : Record) (f : Filing) (d : Date) :
    (r.step (Event.file f d)).feesPaidCents =
      if r.accepts f then r.feesPaidCents + f.feeCents else r.feesPaidCents := by
  by_cases hacc : r.accepts f
  · by_cases h1 : f.form = Form.annualReport
    · simp [step, hacc, h1]
    · by_cases h2 : f.form = Form.reinstatement <;> simp [step, hacc, h1, h2]
  · simp [step, hacc]

end Record

end LLC
