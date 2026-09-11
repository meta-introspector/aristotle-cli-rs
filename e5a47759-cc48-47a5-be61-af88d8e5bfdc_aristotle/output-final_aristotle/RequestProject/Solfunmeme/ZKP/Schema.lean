/-
  Schema.lean — the zero-knowledge proof schema.

  One schema, four families of statement, each about something this repository
  already models and can decide:

      corporate   the company's standing, its filings, its cap table
      portfolio   whether a company meets the open-source criteria
      badge       what a senator may prove about a badge they have redacted
      feed        what the holders' own data says

  The shape is the usual one.  A *statement* is public.  An *instance* adds the
  public inputs a verifier needs — a commitment to the private data, and the
  root of whatever register the statement is about.  A *witness* is the private
  data.  `check` is the constraint system: it opens the commitment, checks any
  membership path, and then decides the fact using the very same functions the
  rest of the project uses, so a proof cannot mean something subtly different
  from the model it is about.

  What is proved:

    * `complete` — an honest prover with a true witness always passes: for
      every statement, if the fact holds of the witness then the honest
      instance checks;
    * `sound` — a passing proof implies the fact, of the committed witness:
      under `Binding`, `check` succeeding means the witness really does satisfy
      the statement, and (for the membership statements) really is in the
      register (`roster_membership_sound`);
    * `standing_threshold_hides_the_value` — the proof reveals no more than the
      statement: for `standingAtLeast t` there are always two different
      token-day figures with the *same* instance, so a verifier who accepts it
      cannot tell which the holder holds;
    * `ownership_threshold_hides_the_cap_table` — the same for a member proving
      they hold at least so many basis points;
    * `statements_are_decidable` — every statement in the schema is decided by
      a function, so a prover can always tell whether it has a proof to make.

  What is *not* claimed: this is a specification of the statements and their
  constraint systems, with binding and hiding named as hypotheses.  It is not
  an implementation of a proof system, and no theorem here says anything about
  the security of a deployed one.
-/

import RequestProject.Solfunmeme.ZKP.Merkle
import RequestProject.Solfunmeme.LLC.Filings
import RequestProject.Solfunmeme.LLC.Portfolio
import RequestProject.Solfunmeme.Badges.Disclosure
import RequestProject.Solfunmeme.Quotes.Feed
import RequestProject.Solfunmeme.Chamber.Model

namespace ZKP

open LLC Badges.Claim Badges.Disclose

/-! ### The statements -/

/-- What a proof in this schema can assert.  Everything here is public. -/
inductive Statement where
  /-- The company was in good standing on the public record. -/
  | goodStanding
  /-- A registered agent was on file. -/
  | agentOnFile
  /-- The annual report for a year had been accepted. -/
  | annualReportFiled (year : Nat)
  /-- The prover holds at least this many basis points of the company. -/
  | ownershipAtLeast (bps : Nat)
  /-- A named company meets the open-source portfolio criteria. -/
  | portfolioEligible (company : String)
  /-- A named company's fitness score is at least this. -/
  | portfolioScoreAtLeast (company : String) (threshold : Nat)
  /-- The prover holds a badge on the roster committed to by the register root
  — without saying which. -/
  | rosterMember
  /-- The prover's token-day standing is at least this, without saying what it
  is. -/
  | standingAtLeast (tokenDays : Nat)
  /-- The reading of a round of the holders' feed lay in a band. -/
  | feedInBand (subject : String) (lo hi : Nat)
deriving DecidableEq, Repr, Inhabited

/-- The private data a proof is about.  A prover supplies whichever parts the
statement needs; the rest are ignored. -/
structure Witness where
  /-- The company. -/
  entity : Entity
  /-- The public record of its filings. -/
  record : LLC.Record
  /-- The member the prover is. -/
  memberName : String
  /-- The candidate company being assessed for the portfolio. -/
  candidate : Portfolio.Candidate
  /-- The badge page the prover holds. -/
  page : ClaimPage
  /-- The feed round. -/
  round : Quotes.Round
  /-- The submissions to it. -/
  submissions : List Quotes.Observation
  /-- The roster the feed and the badge are drawn from. -/
  roster : List String
  /-- The signature verifier in force. -/
  verifier : Verifier
  /-- The salt of the commitment. -/
  salt : String
  /-- The membership path, for statements that need one. -/
  path : Path
deriving Inhabited

/-- How a witness is serialised before being committed to.  Only the parts a
statement can be about are included; the point is that the commitment binds
them. -/
def encode (w : Witness) : String :=
  w.entity.legalName ++ "|" ++ w.memberName ++ "|" ++ w.candidate.name ++ "|"
    ++ w.page.address ++ "|" ++ toString w.page.tokenDaysLower ++ "|"
    ++ toString (w.entity.unitsOf w.memberName) ++ "|" ++ toString w.entity.totalUnits

/-- What the verifier sees. -/
structure Instance where
  /-- The statement being proved. -/
  statement : Statement
  /-- The commitment to the private data. -/
  commitment : String
  /-- The root of the register the statement is about (the roster, for a
  membership statement). -/
  registerRoot : String
deriving DecidableEq, Repr, Inhabited

/-! ### The constraint system -/

/-- Does the witness satisfy the statement itself, ignoring the commitment?
Every clause is decided by the same function the rest of the project uses. -/
def holds (st : Statement) (w : Witness) : Bool :=
  match st with
  | .goodStanding => w.record.standing == LLC.Standing.good
  | .agentOnFile => !w.entity.agent.name.isEmpty && !w.entity.agent.office.line1.isEmpty
  | .annualReportFiled year =>
      w.record.filed.any (fun p => p.1 == LLC.Form.annualReport && p.2 == year)
  | .ownershipAtLeast bps => decide (bps ≤ w.entity.bps w.memberName)
  | .portfolioEligible company =>
      (w.candidate.name == company) && Portfolio.eligible w.candidate
  | .portfolioScoreAtLeast company t =>
      (w.candidate.name == company) && decide (t ≤ w.candidate.scores.total)
  | .rosterMember => w.roster.contains w.page.address
  | .standingAtLeast t => decide (t ≤ w.page.tokenDaysLower)
  | .feedInBand subject lo hi =>
      (w.round.subject == subject)
        && decide (lo ≤ Quotes.feedValue w.roster w.round w.verifier w.submissions)
        && decide (Quotes.feedValue w.roster w.round w.verifier w.submissions ≤ hi)

/-- The full constraint system: the commitment opens to this witness, the fact
holds, and — for a membership statement — the path proves the prover's address
is in the committed register. -/
def check (S : Scheme) (inst : Instance) (w : Witness) : Bool :=
  (S.commit (encode w) w.salt == inst.commitment)
    && holds inst.statement w
    && (match inst.statement with
        | .rosterMember => verify S inst.registerRoot w.page.address w.path
        | _ => true)

/-- The instance an honest prover publishes. -/
def honestInstance (S : Scheme) (st : Statement) (w : Witness) (root : String) : Instance :=
  { statement := st, commitment := S.commit (encode w) w.salt, registerRoot := root }

/-! ### Completeness -/

/-- **An honest prover with a true witness passes**, for every statement that
needs no membership path. -/
theorem complete (S : Scheme) (st : Statement) (w : Witness) (root : String)
    (hne : st ≠ Statement.rosterMember) (h : holds st w = true) :
    check S (honestInstance S st w root) w = true := by
  cases st <;> simp_all [check, honestInstance]

/-- **And a member of the register can always produce a passing membership
proof.**  The path is the one the tree itself provides. -/
theorem complete_rosterMember (S : Scheme) (w : Witness) (t : Tree)
    (hmem : w.page.address ∈ t.leaves) (h : holds Statement.rosterMember w = true) :
    ∃ p : Path,
      check S (honestInstance S Statement.rosterMember { w with path := p } (t.root S))
        { w with path := p } = true := by
  obtain ⟨p, hp⟩ := verify_of_mem S t hmem
  refine ⟨p, ?_⟩
  have hh : holds Statement.rosterMember { w with path := p } = true := by
    simpa [holds] using h
  simp [check, honestInstance, hh, hp]

/-! ### Soundness -/

/-- **A passing proof implies the fact.** -/
theorem sound (S : Scheme) (inst : Instance) (w : Witness) (h : check S inst w = true) :
    holds inst.statement w = true := by
  simp only [check, Bool.and_eq_true] at h
  exact h.1.2

/-- **A passing proof is a proof about the committed data.**  Under binding, a
witness that passes is the one the instance commits to: nobody can pass with a
witness other than the one they committed. -/
theorem sound_binds (S : Scheme) (hB : Binding S) (inst : Instance) (w w' : Witness)
    (h : check S inst w = true) (h' : check S inst w' = true) : encode w = encode w' := by
  simp only [check, Bool.and_eq_true, beq_iff_eq] at h h'
  exact hB.commit_inj _ _ _ _ (h.1.1.trans h'.1.1.symm)

/-- **A membership proof really proves membership.**  Under binding, a passing
`rosterMember` proof means the prover's address is a leaf of the committed
register — so the presenter is one of the roster, though the verifier is never
told which. -/
theorem roster_membership_sound (S : Scheme) (hB : Binding S) (t : Tree) (w : Witness)
    (inst : Instance) (hst : inst.statement = Statement.rosterMember)
    (hroot : inst.registerRoot = t.root S) (h : check S inst w = true) :
    w.page.address ∈ t.leaves := by
  simp only [check, hst, Bool.and_eq_true] at h
  exact mem_of_verify S hB t (by rw [← hroot]; exact h.2)

/-! ### What a proof does not reveal -/

/-- **A threshold proof about the standing hides the standing.**  For any
threshold the holder can meet, there are two different token-day figures whose
proofs are the *same* instance: same statement, same commitment, same root.  A
verifier who accepts the proof therefore cannot tell which of them is true. -/
theorem standing_threshold_hides_the_value (S : Scheme) (hH : Hiding S) (t : Nat)
    (w : Witness) (a b : Nat) (ha : t ≤ a) (hb : t ≤ b) (root : String) :
    ∃ (wa wb : Witness),
      wa.page.tokenDaysLower = a ∧ wb.page.tokenDaysLower = b
        ∧ holds (Statement.standingAtLeast t) wa = true
        ∧ holds (Statement.standingAtLeast t) wb = true
        ∧ honestInstance S (Statement.standingAtLeast t) wa root
            = honestInstance S (Statement.standingAtLeast t) wb root := by
  classical
  let wa : Witness := { w with page := { w.page with tokenDaysLower := a } }
  obtain ⟨s, hs⟩ := hH (encode wa) (encode { w with
      page := { w.page with tokenDaysLower := b } }) w.salt
  let wb : Witness := { w with page := { w.page with tokenDaysLower := b }, salt := s }
  refine ⟨wa, wb, rfl, rfl, by simp [holds, wa, ha], by simp [holds, wb, hb], ?_⟩
  simp only [honestInstance, Instance.mk.injEq, true_and, and_true]
  exact hs

/-- **A threshold proof about ownership hides the cap table.**  Two members with
different holdings, both above the threshold, produce the same instance. -/
theorem ownership_threshold_hides_the_cap_table (S : Scheme) (hH : Hiding S) (bps : Nat)
    (w w' : Witness) (root : String)
    (hw' : holds (Statement.ownershipAtLeast bps) w' = true) :
    ∃ w'' : Witness, encode w'' = encode w'
      ∧ holds (Statement.ownershipAtLeast bps) w'' = true
      ∧ honestInstance S (Statement.ownershipAtLeast bps) w root
          = honestInstance S (Statement.ownershipAtLeast bps) w'' root := by
  obtain ⟨s, hs⟩ := hH (encode w) (encode w') w.salt
  refine ⟨{ w' with salt := s }, rfl, ?_, ?_⟩
  · simpa [holds] using hw'
  · simp only [honestInstance, Instance.mk.injEq, true_and, and_true]
    exact hs

/-! ### The schema is decidable -/

/-- **Every statement in the schema is decided by a function**, so a prover can
always tell whether they have a proof to make, and a verifier's check
terminates. -/
theorem statements_are_decidable (st : Statement) (w : Witness) :
    holds st w = true ∨ holds st w = false := by
  cases h : holds st w
  · exact Or.inr rfl
  · exact Or.inl rfl

/-! ### The schema, as data

The same schema, written out as a table, so that it can be emitted for
consumers that are not Lean: each statement's name, its public inputs, the
private inputs it needs, and the constraint it imposes. -/

/-- One line of the published schema. -/
structure Entry where
  /-- The statement's name in the schema. -/
  name : String
  /-- The family it belongs to. -/
  family : String
  /-- The public inputs. -/
  publicInputs : List String
  /-- The private inputs (the witness fields the constraint reads). -/
  privateInputs : List String
  /-- The constraint, in words, and the Lean function that decides it. -/
  constraint : String
deriving DecidableEq, Repr, Inhabited

/-- The published schema. -/
def schema : List Entry :=
  [ { name := "good-standing", family := "corporate",
      publicInputs := ["commitment"],
      privateInputs := ["record.standing"],
      constraint := "record.standing = good (LLC.Record.standing)" },
    { name := "agent-on-file", family := "corporate",
      publicInputs := ["commitment"],
      privateInputs := ["entity.agent"],
      constraint := "agent name and registered office are non-empty (LLC.Entity.agent)" },
    { name := "annual-report-filed", family := "corporate",
      publicInputs := ["commitment", "year"],
      privateInputs := ["record.filed"],
      constraint := "(annualReport, year) ∈ record.filed (LLC.Record.filed)" },
    { name := "ownership-at-least", family := "corporate",
      publicInputs := ["commitment", "bps"],
      privateInputs := ["entity.members", "memberName"],
      constraint := "bps ≤ entity.bps memberName (LLC.Entity.bps)" },
    { name := "portfolio-eligible", family := "portfolio",
      publicInputs := ["commitment", "company"],
      privateInputs := ["candidate"],
      constraint := "LLC.Portfolio.eligible candidate" },
    { name := "portfolio-score-at-least", family := "portfolio",
      publicInputs := ["commitment", "company", "threshold"],
      privateInputs := ["candidate.scores"],
      constraint := "threshold ≤ candidate.scores.total (LLC.Portfolio.Scores.total)" },
    { name := "roster-member", family := "badge",
      publicInputs := ["commitment", "register-root"],
      privateInputs := ["page.address", "path"],
      constraint := "ZKP.verify register-root page.address path" },
    { name := "standing-at-least", family := "badge",
      publicInputs := ["commitment", "token-days"],
      privateInputs := ["page.tokenDaysLower"],
      constraint := "token-days ≤ page.tokenDaysLower (redacted by Badges.Disclose.Policy)" },
    { name := "feed-in-band", family := "feed",
      publicInputs := ["commitment", "subject", "lo", "hi"],
      privateInputs := ["round", "submissions", "roster"],
      constraint := "lo ≤ Quotes.feedValue ≤ hi (Quotes.median of admitted values)" } ]

theorem schema_length : schema.length = 9 := by decide

theorem schema_names_nodup : (schema.map (fun e => e.name)).Nodup := by decide

/-- Every statement of the inductive type has a line in the published schema. -/
def entryName : Statement → String
  | .goodStanding => "good-standing"
  | .agentOnFile => "agent-on-file"
  | .annualReportFiled _ => "annual-report-filed"
  | .ownershipAtLeast _ => "ownership-at-least"
  | .portfolioEligible _ => "portfolio-eligible"
  | .portfolioScoreAtLeast _ _ => "portfolio-score-at-least"
  | .rosterMember => "roster-member"
  | .standingAtLeast _ => "standing-at-least"
  | .feedInBand _ _ _ => "feed-in-band"

/-- **The published schema documents every statement the checker accepts.** -/
theorem schema_covers_every_statement (st : Statement) :
    (schema.map (fun e => e.name)).contains (entryName st) = true := by
  cases st <;> rfl

/-- Render the schema as JSON, for consumers that are not Lean. -/
def schemaJson : String :=
  let quote (s : String) : String := "\"" ++ s ++ "\""
  let arr (xs : List String) : String := "[" ++ String.intercalate ", " (xs.map quote) ++ "]"
  let entry (e : Entry) : String :=
    "    {\n      \"name\": " ++ quote e.name ++ ",\n      \"family\": " ++ quote e.family
      ++ ",\n      \"public_inputs\": " ++ arr e.publicInputs
      ++ ",\n      \"private_inputs\": " ++ arr e.privateInputs
      ++ ",\n      \"constraint\": " ++ quote e.constraint ++ "\n    }"
  "{\n  \"schema\": \"solfunmeme-zkp-v1\",\n  \"statements\": [\n"
    ++ String.intercalate ",\n" (schema.map entry) ++ "\n  ]\n}\n"

end ZKP
