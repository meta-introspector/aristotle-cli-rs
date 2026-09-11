/-
  Entity.lean — Introspector LLC as a New Jersey entity.

  This is a *model*, for simulation.  It is not legal advice, and no figure
  here is a representation about the law: fee amounts, deadlines and form names
  are parameters of the simulation, named so that they can be changed in one
  place, and the theorems say what follows *from the model*, never what a
  filing office will do.

  The company modelled is the one described in the uploaded documents: an
  AI/ZKP company selling a "ZKPML department in a box", organised as a New
  Jersey domestic limited liability company with a corporate tax election, with
  jurisdictional shards that pool revenue and share it out by contribution.

  What this file provides:

    * `Entity` — legal name, registered agent and office, principal address,
      formation date, fiscal year, management form, members, purposes, and the
      identifiers a filing gets back (business ID, EIN);
    * `wellFormed` — the checklist a formation packet has to pass before it can
      be filed at all: a name with a statutory designator, a registered agent
      with a New Jersey street address, at least one member, units outstanding,
      a real formation date;
    * the cap table: units, ownership in basis points, majority in interest,
      and transfers;
    * the business model of the uploaded README as data: the four revenue
      streams and the shards, with the pooled revenue shared out exactly.

  What is proved:

    * ownership in basis points never exceeds the whole (`bps_le_10000`), and a
      member holding more than half the units holds a majority in interest
      (`majority_in_interest_iff`), which no two members can hold at once
      (`majority_in_interest_unique`);
    * a transfer of units moves ownership without creating or destroying it
      (`transfer_conserves_units`), and a transfer of units the member does not
      hold is refused outright (`transfer_of_too_much_is_refused`);
    * pooled shard revenue is shared out to the cent — the shares sum to the
      pool, nothing lost and nothing conjured (`shard_split_is_exact`), reusing
      the apportionment proved in `RequestProject/Federal/Apportion.lean`;
    * revenue is the sum of the four streams of the uploaded business model and
      is monotone in each (`revenue_total`, `revenue_monotone`).
-/

import RequestProject.Solfunmeme.LLC.Date
import RequestProject.Solfunmeme.Federal.Apportion

namespace LLC

/-! ### Addresses and people -/

/-- A postal address. -/
structure Address where
  /-- Street address, first line. -/
  line1 : String
  /-- Municipality. -/
  city : String
  /-- Two-letter state code. -/
  state : String
  /-- Postal code. -/
  postal : String
deriving DecidableEq, Repr, Inhabited

/-- Registered agent: who accepts service of process, and where. -/
structure Agent where
  /-- The agent's name. -/
  name : String
  /-- The registered office.  A street address in the state of organisation. -/
  office : Address
deriving DecidableEq, Repr, Inhabited

/-- How the company is managed. -/
inductive Management where
  /-- Managed by its members. -/
  | memberManaged
  /-- Managed by named managers. -/
  | managerManaged
deriving DecidableEq, Repr, Inhabited

/-- How the company is taxed.  A New Jersey LLC is a partnership for tax
purposes by default; it may elect to be treated as a corporation, which is what
this model assumes, so the calendar carries corporate returns. -/
inductive TaxElection where
  /-- Default: partnership. -/
  | partnership
  /-- Elected: corporation. -/
  | corporation
deriving DecidableEq, Repr, Inhabited

/-- A member of the company. -/
structure Member where
  /-- Legal name. -/
  name : String
  /-- Notice address. -/
  address : Address
  /-- Membership units held. -/
  units : Nat
  /-- Capital contributed, in cents. -/
  contributionCents : Nat
deriving DecidableEq, Repr, Inhabited

/-! ### The entity -/

/-- A New Jersey business entity, as the filing record sees it. -/
structure Entity where
  /-- The legal name, including its designator. -/
  legalName : String
  /-- State of organisation. -/
  state : String
  /-- Main business address. -/
  principalOffice : Address
  /-- Registered agent and registered office. -/
  agent : Agent
  /-- Date of formation. -/
  formation : Date
  /-- Month the fiscal year ends in. -/
  fiscalYearEndMonth : Nat
  /-- Management form. -/
  management : Management
  /-- Tax treatment. -/
  taxElection : TaxElection
  /-- The members. -/
  members : List Member
  /-- The stated purposes. -/
  purposes : List String
  /-- The state business identification number, once the formation is filed. -/
  businessId : Option String
  /-- The federal employer identification number, once issued. -/
  ein : Option String
deriving DecidableEq, Repr, Inhabited

/-! ### Sums over the cap table -/

/-- Units held by a list of members. -/
def sumUnits (l : List Member) : Nat := (l.map (fun m => m.units)).foldl (· + ·) 0

private theorem foldl_add_eq (l : List Nat) (a : Nat) :
    l.foldl (· + ·) a = a + l.foldl (· + ·) 0 := by
  induction l generalizing a with
  | nil => simp
  | cons x t ih => simp only [List.foldl_cons]; rw [ih (a + x), ih (0 + x)]; omega

theorem sumUnits_cons (m : Member) (t : List Member) :
    sumUnits (m :: t) = m.units + sumUnits t := by
  simp only [sumUnits, List.map_cons, List.foldl_cons, Nat.zero_add]
  exact foldl_add_eq _ _

theorem sumUnits_filter_le (p : Member → Bool) (l : List Member) :
    sumUnits (l.filter p) ≤ sumUnits l := by
  induction l with
  | nil => simp [sumUnits]
  | cons x t ih =>
      by_cases h : p x
      · rw [List.filter_cons_of_pos h, sumUnits_cons, sumUnits_cons]; omega
      · rw [List.filter_cons_of_neg (by simp [h]), sumUnits_cons]; omega

private theorem count_zero_iff (p : Member → Bool) (l : List Member) :
    (l.filter p).length = 0 ↔ ∀ x ∈ l, p x = false := by
  rw [List.length_eq_zero_iff, List.filter_eq_nil_iff]
  simp

/-! ### The cap table -/

namespace Entity

/-- Does the name end in one of the designators a limited liability company
may use? -/
def hasDesignator (nm : String) : Bool :=
  ["LLC", "L.L.C.", "Limited Liability Company", "Limited Liability Co."].any
    (fun d => nm.endsWith d)

/-- Units outstanding. -/
def totalUnits (e : Entity) : Nat := sumUnits e.members

/-- Capital contributed, in cents. -/
def totalContributionCents (e : Entity) : Nat :=
  (e.members.map (fun m => m.contributionCents)).foldl (· + ·) 0

/-- Units held by a named member. -/
def unitsOf (e : Entity) (nm : String) : Nat :=
  sumUnits (e.members.filter (fun m => m.name == nm))

/-- **The checklist a formation packet must pass before it is filed.** -/
def wellFormed (e : Entity) : Bool :=
  !e.legalName.isEmpty
    && hasDesignator e.legalName
    && e.state == "NJ"
    && e.agent.office.state == "NJ"
    && !e.agent.name.isEmpty
    && !e.agent.office.line1.isEmpty
    && !e.agent.office.postal.isEmpty
    && !e.members.isEmpty
    && 0 < e.totalUnits
    && e.formation.valid
    && 1 ≤ e.fiscalYearEndMonth && e.fiscalYearEndMonth ≤ 12
    && !e.purposes.isEmpty

/-- A member's interest, in basis points of the units outstanding. -/
def bps (e : Entity) (nm : String) : Nat :=
  if e.totalUnits = 0 then 0 else e.unitsOf nm * 10000 / e.totalUnits

/-- Does this member hold a majority in interest? -/
def majorityInInterest (e : Entity) (nm : String) : Bool :=
  decide (e.totalUnits < 2 * e.unitsOf nm)

theorem unitsOf_le_totalUnits (e : Entity) (nm : String) : e.unitsOf nm ≤ e.totalUnits :=
  sumUnits_filter_le _ _

/-- **Ownership never exceeds the whole.** -/
theorem bps_le_10000 (e : Entity) (nm : String) : e.bps nm ≤ 10000 := by
  unfold bps
  split
  · omega
  · rename_i h
    have hpos : 0 < e.totalUnits := Nat.pos_of_ne_zero h
    calc e.unitsOf nm * 10000 / e.totalUnits
        ≤ e.totalUnits * 10000 / e.totalUnits :=
          Nat.div_le_div_right (Nat.mul_le_mul_right _ (unitsOf_le_totalUnits e nm))
      _ = 10000 := by rw [Nat.mul_comm]; exact Nat.mul_div_cancel _ hpos

/-- **A majority in interest is a majority of the units.** -/
theorem majority_in_interest_iff (e : Entity) (nm : String) :
    e.majorityInInterest nm = true ↔ e.totalUnits < 2 * e.unitsOf nm := by
  simp [majorityInInterest]

/-- **A majority in interest is unique**: two members whose holdings are
disjoint cannot both have one. -/
theorem majority_in_interest_unique (e : Entity) (a b : String)
    (hdisjoint : e.unitsOf a + e.unitsOf b ≤ e.totalUnits)
    (ha : e.majorityInInterest a = true) (hb : e.majorityInInterest b = true) : False := by
  rw [majority_in_interest_iff] at ha hb
  omega

/-! ### Transfers -/

/-- The effect of a transfer on one member's line of the cap table. -/
def moveUnits (src dest : String) (n : Nat) (m : Member) : Member :=
  if m.name == src then { m with units := m.units - n }
  else if m.name == dest then { m with units := m.units + n } else m

/-- Move `n` units from one member to another.  A transfer of more units than
the transferor holds is refused, and the cap table is returned unchanged. -/
def transfer (e : Entity) (src dest : String) (n : Nat) : Entity :=
  if e.unitsOf src < n then e
  else { e with members := e.members.map (moveUnits src dest n) }

private theorem map_moveUnits_id (src dest : String) (n : Nat) (l : List Member)
    (h : ∀ x ∈ l, x.name ≠ src ∧ x.name ≠ dest) : l.map (moveUnits src dest n) = l := by
  induction l with
  | nil => rfl
  | cons x t ih =>
      have hx := h x (by simp)
      have hu : moveUnits src dest n x = x := by simp [moveUnits, hx.1, hx.2]
      simp [hu, ih (fun y hy => h y (by simp [hy]))]

private theorem credit_only (src dest : String) (n : Nat) (l : List Member)
    (hnosrc : ∀ x ∈ l, x.name ≠ src) (hdest : (l.filter (fun m => m.name == dest)).length = 1) :
    sumUnits (l.map (moveUnits src dest n)) = sumUnits l + n := by
  induction l with
  | nil => simp at hdest
  | cons x t ih =>
      have hxs : x.name ≠ src := hnosrc x (by simp)
      by_cases hxd : x.name = dest
      · have htd : (t.filter (fun m => m.name == dest)).length = 0 := by
          rw [List.filter_cons_of_pos (by simp [hxd])] at hdest; simpa using hdest
        have hid : t.map (moveUnits src dest n) = t := by
          refine map_moveUnits_id _ _ _ _ (fun y hy => ⟨hnosrc y (by simp [hy]), ?_⟩)
          have := (count_zero_iff _ _).mp htd y hy
          simpa using this
        have hu : moveUnits src dest n x = { x with units := x.units + n } := by
          unfold moveUnits
          rw [if_neg (by simpa using hxs), if_pos (by simpa using hxd)]
        rw [List.map_cons, sumUnits_cons, hu, hid, sumUnits_cons]
        show x.units + n + sumUnits t = x.units + sumUnits t + n
        omega
      · have htd : (t.filter (fun m => m.name == dest)).length = 1 := by
          rwa [List.filter_cons_of_neg (by simp [hxd])] at hdest
        have hu : moveUnits src dest n x = x := by
          unfold moveUnits
          rw [if_neg (by simpa using hxs), if_neg (by simpa using hxd)]
        rw [List.map_cons, sumUnits_cons, hu, sumUnits_cons,
          ih (fun y hy => hnosrc y (by simp [hy])) htd]
        omega

private theorem debit_only (src dest : String) (n : Nat) (l : List Member)
    (hnodest : ∀ x ∈ l, x.name ≠ dest) (hsrc : (l.filter (fun m => m.name == src)).length = 1)
    (hn : ∀ m ∈ l, m.name = src → n ≤ m.units) :
    sumUnits (l.map (moveUnits src dest n)) + n = sumUnits l := by
  induction l with
  | nil => simp at hsrc
  | cons x t ih =>
      have hxd : x.name ≠ dest := hnodest x (by simp)
      by_cases hxs : x.name = src
      · have hts : (t.filter (fun m => m.name == src)).length = 0 := by
          rw [List.filter_cons_of_pos (by simp [hxs])] at hsrc; simpa using hsrc
        have hid : t.map (moveUnits src dest n) = t := by
          refine map_moveUnits_id _ _ _ _ (fun y hy => ⟨?_, hnodest y (by simp [hy])⟩)
          have := (count_zero_iff _ _).mp hts y hy
          simpa using this
        have hu : moveUnits src dest n x = { x with units := x.units - n } := by
          unfold moveUnits; rw [if_pos (by simpa using hxs)]
        have hle : n ≤ x.units := hn x (by simp) hxs
        rw [List.map_cons, sumUnits_cons, hu, hid]
        show x.units - n + sumUnits t + n = sumUnits (x :: t)
        rw [sumUnits_cons]
        omega
      · have hts : (t.filter (fun m => m.name == src)).length = 1 := by
          rwa [List.filter_cons_of_neg (by simp [hxs])] at hsrc
        have hu : moveUnits src dest n x = x := by
          unfold moveUnits; rw [if_neg (by simpa using hxs), if_neg (by simpa using hxd)]
        rw [List.map_cons, sumUnits_cons, hu, sumUnits_cons,
          ← ih (fun y hy => hnodest y (by simp [hy])) hts (fun y hy => hn y (by simp [hy]))]
        omega

private theorem sumUnits_transfer (src dest : String) (n : Nat) (l : List Member)
    (hne : src ≠ dest)
    (hsrc : (l.filter (fun m => m.name == src)).length = 1)
    (hdest : (l.filter (fun m => m.name == dest)).length = 1)
    (hn : ∀ m ∈ l, m.name = src → n ≤ m.units) :
    sumUnits (l.map (moveUnits src dest n)) = sumUnits l := by
  induction l with
  | nil => simp at hsrc
  | cons x t ih =>
      by_cases hxs : x.name = src
      · have hxd : x.name ≠ dest := by rw [hxs]; exact hne
        have hts : (t.filter (fun m => m.name == src)).length = 0 := by
          rw [List.filter_cons_of_pos (by simp [hxs])] at hsrc; simpa using hsrc
        have htd : (t.filter (fun m => m.name == dest)).length = 1 := by
          rwa [List.filter_cons_of_neg (by simp [hxd])] at hdest
        have hnosrc : ∀ y ∈ t, y.name ≠ src := by
          intro y hy
          have := (count_zero_iff _ _).mp hts y hy
          simpa using this
        have hc := credit_only src dest n t hnosrc htd
        have hu : moveUnits src dest n x = { x with units := x.units - n } := by
          unfold moveUnits; rw [if_pos (by simpa using hxs)]
        have hle : n ≤ x.units := hn x (by simp) hxs
        rw [List.map_cons, sumUnits_cons, hu, hc, sumUnits_cons]
        show x.units - n + (sumUnits t + n) = x.units + sumUnits t
        omega
      · by_cases hxd : x.name = dest
        · have htd : (t.filter (fun m => m.name == dest)).length = 0 := by
            rw [List.filter_cons_of_pos (by simp [hxd])] at hdest; simpa using hdest
          have hts : (t.filter (fun m => m.name == src)).length = 1 := by
            rwa [List.filter_cons_of_neg (by simp [hxs])] at hsrc
          have hnodest : ∀ y ∈ t, y.name ≠ dest := by
            intro y hy
            have := (count_zero_iff _ _).mp htd y hy
            simpa using this
          have hd := debit_only src dest n t hnodest hts (fun y hy => hn y (by simp [hy]))
          have hu : moveUnits src dest n x = { x with units := x.units + n } := by
            unfold moveUnits; rw [if_neg (by simpa using hxs), if_pos (by simpa using hxd)]
          rw [List.map_cons, sumUnits_cons, hu, sumUnits_cons]
          show x.units + n + sumUnits (t.map (moveUnits src dest n)) = x.units + sumUnits t
          omega
        · have hts : (t.filter (fun m => m.name == src)).length = 1 := by
            rwa [List.filter_cons_of_neg (by simp [hxs])] at hsrc
          have htd : (t.filter (fun m => m.name == dest)).length = 1 := by
            rwa [List.filter_cons_of_neg (by simp [hxd])] at hdest
          have hu : moveUnits src dest n x = x := by
            unfold moveUnits; rw [if_neg (by simpa using hxs), if_neg (by simpa using hxd)]
          rw [List.map_cons, sumUnits_cons, hu, sumUnits_cons,
            ih hts htd (fun y hy => hn y (by simp [hy]))]

/-- **A transfer of more units than the transferor holds changes nothing.** -/
theorem transfer_of_too_much_is_refused (e : Entity) (src dest : String) (n : Nat)
    (h : e.unitsOf src < n) : e.transfer src dest n = e := by
  simp [transfer, h]

/-- **A transfer moves ownership; it does not create or destroy it.**  For a
cap table listing each of the two members once, the units outstanding after the
transfer are the units outstanding before. -/
theorem transfer_conserves_units (e : Entity) (src dest : String) (n : Nat)
    (hne : src ≠ dest)
    (hsrc : (e.members.filter (fun m => m.name == src)).length = 1)
    (hdest : (e.members.filter (fun m => m.name == dest)).length = 1)
    (hn : ∀ m ∈ e.members, m.name = src → n ≤ m.units) :
    (e.transfer src dest n).totalUnits = e.totalUnits := by
  unfold transfer
  split
  · rfl
  · exact sumUnits_transfer src dest n e.members hne hsrc hdest hn

end Entity

/-! ### The business model of the uploaded README -/

/-- The four revenue streams the business model names. -/
structure Revenue where
  /-- Subscriptions to the ZKPML department in a box, in cents. -/
  subscriptionCents : Nat
  /-- Hardware execution and resource access, in cents. -/
  hardwareCents : Nat
  /-- Consulting, setup and support, in cents. -/
  consultingCents : Nat
  /-- Web service and API fees, in cents. -/
  webServiceCents : Nat
deriving DecidableEq, Repr, Inhabited

namespace Revenue

/-- Total revenue for the period, in cents. -/
def total (r : Revenue) : Nat :=
  r.subscriptionCents + r.hardwareCents + r.consultingCents + r.webServiceCents

theorem revenue_total (r : Revenue) :
    r.total = r.subscriptionCents + r.hardwareCents + r.consultingCents + r.webServiceCents := rfl

/-- **Revenue is monotone in every stream.** -/
theorem revenue_monotone {r s : Revenue}
    (h1 : r.subscriptionCents ≤ s.subscriptionCents)
    (h2 : r.hardwareCents ≤ s.hardwareCents)
    (h3 : r.consultingCents ≤ s.consultingCents)
    (h4 : r.webServiceCents ≤ s.webServiceCents) : r.total ≤ s.total := by
  simp only [total]; omega

end Revenue

/-- A jurisdictional shard: a name and the contribution it made to the pool,
in whatever unit the operating agreement measures contribution in. -/
structure Shard where
  /-- The jurisdiction. -/
  name : String
  /-- Contribution: the weight this shard is paid by. -/
  contribution : Nat
deriving DecidableEq, Repr, Inhabited

/-- Share a pool of cents out among the shards in proportion to contribution,
by the same largest-remainder rule the federal model apportions seats with. -/
def shardSplit (shards : List Shard) (poolCents : Nat) : List (String × Nat) :=
  Federal.houseSeats (shards.map (fun s => Federal.Division.mk s.name s.contribution)) poolCents

/-- **The pool is shared out to the cent**: the shares add up to exactly the
pool, so nothing is lost in the split and nothing is conjured. -/
theorem shard_split_is_exact (shards : List Shard) (poolCents : Nat)
    (h : 0 < Federal.totalPop (shards.map (fun s => Federal.Division.mk s.name s.contribution))) :
    ((shardSplit shards poolCents).map Prod.snd).sum = poolCents :=
  Federal.apportion_total _ poolCents h

end LLC
