/-
The vocabulary of the SOLFUNMEME ticket ontology.
-/
import RequestProject.Solfunmeme.Tickets.DL

/-!
# Vocabulary

Atomic concepts (`CN`) and roles (`RN`) used to describe the ticket database at
<https://codeberg.org/introspector/SOLFUNMEME/issues>, plus the abbreviations
used everywhere else.

The atomic concepts fall into five groups:

* **structure** — `Ticket`, `Person`, and the state of a ticket;
* **labels** — one concept per codeberg label actually in use (`LBounty`, …);
* **kinds** — what the ticket *is* (a proposal, an idea, a question, a plan, a
  bounty offer, a request, a task), read off the wording of the ticket;
* **topics** — what the ticket is *about* (AI, agents, proofs, Solana,
  infrastructure, docs, networking, community, governance, security,
  installers, art);
* **defined concepts** — `WishListItem`, `Actionable`, `Wanted`, … which are
  not asserted of anything but *defined* by the TBox in `TBox.lean`.

Which concepts get asserted of which ticket is decided by
`scripts/codeberg_tickets.py`; the rules are listed there and the outcome is
tabulated in `CODEBERG-TICKETS.md`.
-/

namespace SFM.Tickets

open SFM.DL

/-- Atomic concept names of the SOLFUNMEME ticket ontology. -/
inductive CN where
  -- structure
  /-- A ticket in the codeberg database. -/
  | Ticket
  /-- A person who opened or was assigned a ticket. -/
  | Person
  /-- The maintainer account `introspector`. -/
  | CoreDev
  /-- A person other than the maintainer. -/
  | Outsider
  /-- The ticket is open. -/
  | StOpen
  /-- The ticket is closed. -/
  | StClosed
  /-- The ticket has an assignee. -/
  | Assigned
  /-- The ticket belongs to a milestone. -/
  | Milestoned
  /-- The ticket has at least one comment. -/
  | Discussed
  /-- The ticket was opened by somebody other than the maintainer. -/
  | FromOutside
  -- labels
  /-- Carries the `Bounty` label. -/
  | LBounty
  /-- Carries the `Kind/Feature` label. -/
  | LFeature
  /-- Carries the `Kind/Enhancement` label. -/
  | LEnhancement
  /-- Carries the `Kind/Documentation` label. -/
  | LDocumentation
  /-- Carries the `Kind/Security` label. -/
  | LSecurity
  /-- Carries the `Kind/Testing` label. -/
  | LTesting
  /-- Carries the `Kind/Bug` label. -/
  | LBug
  /-- Carries the `Priority/High` label. -/
  | LPriorityHigh
  /-- Carries the `skibidi` label. -/
  | LSkibidi
  -- kinds
  /-- Reads as a proposal. -/
  | KProposal
  /-- Reads as an idea. -/
  | KIdea
  /-- Reads as a question. -/
  | KQuestion
  /-- Reads as a plan or roadmap. -/
  | KPlan
  /-- Offers a bounty. -/
  | KBountyOffer
  /-- Reads as a request. -/
  | KRequest
  /-- Reads as a concrete task. -/
  | KTask
  -- topics
  /-- About AI and language models. -/
  | TAI
  /-- About agents and bots. -/
  | TAgent
  /-- About proofs, formal methods and ontology. -/
  | TProof
  /-- About Solana, tokens and wallets. -/
  | TSolana
  /-- About infrastructure and deployment. -/
  | TInfra
  /-- About documentation. -/
  | TDocs
  /-- About peer-to-peer networking. -/
  | TNetwork
  /-- About community and outreach. -/
  | TCommunity
  /-- About governance and funding. -/
  | TGovernance
  /-- About security, keys and signing. -/
  | TSecurity
  /-- About installers and packaging. -/
  | TInstaller
  /-- About memes, art and music. -/
  | TArt
  -- defined by the TBox
  /-- Something the project wants done: the wish list. -/
  | WishListItem
  /-- An open wish that nobody has taken. -/
  | Unclaimed
  /-- Wish items that can be worked on now. -/
  | Actionable
  /-- Wish items that are waiting on another open ticket. -/
  | Blocked
  /-- Wish items with a reward attached. -/
  | Rewarded
  /-- The formal-methods part of the wish list. -/
  | ProofWish
  /-- A wish item raised by somebody outside the core team. -/
  | CommunityWish
  -- discussion and activity, from the comment dump
  /-- The maintainer has answered on the ticket. -/
  | CoreAnswered
  /-- A busy thread: five comments or more. -/
  | HotTopic
  /-- Nothing has happened to the ticket for six months. -/
  | Stale
  -- size
  /-- A short ticket with little traffic. -/
  | EffSmall
  /-- A long ticket, or one with a long thread. -/
  | EffLarge
  /-- Neither small nor large. -/
  | EffMedium
  -- planning concepts, defined by the TBox
  /-- A wish with a declared prerequisite that is still open. -/
  | Waiting
  /-- A wish that can be started today. -/
  | Ready
  /-- A small wish that can be started today. -/
  | QuickWin
  /-- A large wish. -/
  | Epic
  /-- A wish written as an idea or a proposal, with no concrete task in it. -/
  | NeedsSpec
  /-- A wish that has gone quiet and never got an answer from the core team. -/
  | Dormant
  /-- A wish the core team has answered. -/
  | Answered
  /-- Somebody has reacted to the ticket. -/
  | Endorsed
  deriving DecidableEq, Repr

/-- Role names of the SOLFUNMEME ticket ontology. -/
inductive RN where
  /-- Ticket to the person who opened it. -/
  | RauthoredBy
  /-- Ticket to the person it is assigned to. -/
  | RassignedTo
  /-- Ticket to another ticket it links to. -/
  | Rreferences
  /-- Ticket to a person who commented on it. -/
  | RdiscussedBy
  /-- Ticket to a ticket its thread declares to be a prerequisite. -/
  | RdependsOn
  /-- Ticket to a ticket linked from its comments. -/
  | Rmentions
  /-- Ticket to a person who reacted to it. -/
  | RendorsedBy
  deriving DecidableEq, Repr

/-- Individual names are natural numbers: a ticket is its codeberg issue
number, a person gets a key from 1000 upwards (see `Corpus.lean`). -/
abbrev Ind := Nat

/-- Concept expressions over the ticket vocabulary. -/
abbrev TConcept := Concept CN RN

/-- Inclusions over the ticket vocabulary. -/
abbrev TGCI := GCI CN RN

/-- Assertions over the ticket vocabulary. -/
abbrev TAssertion := Assertion CN RN Ind

/-- Knowledge bases over the ticket vocabulary. -/
abbrev TKB := KB CN RN Ind

/-- An atomic concept as a concept expression. -/
abbrev cn (c : CN) : TConcept := Concept.atom c

/-- Index of an atomic concept, used to pack concept sets into a bitmask. -/
def CN.idx : CN → Nat
  | Ticket => 0 | Person => 1 | CoreDev => 2 | Outsider => 3
  | StOpen => 4 | StClosed => 5 | Assigned => 6 | Milestoned => 7
  | Discussed => 8 | FromOutside => 9
  | LBounty => 10 | LFeature => 11 | LEnhancement => 12 | LDocumentation => 13
  | LSecurity => 14 | LTesting => 15 | LBug => 16 | LPriorityHigh => 17
  | LSkibidi => 18
  | KProposal => 19 | KIdea => 20 | KQuestion => 21 | KPlan => 22
  | KBountyOffer => 23 | KRequest => 24 | KTask => 25
  | TAI => 26 | TAgent => 27 | TProof => 28 | TSolana => 29 | TInfra => 30
  | TDocs => 31 | TNetwork => 32 | TCommunity => 33 | TGovernance => 34
  | TSecurity => 35 | TInstaller => 36 | TArt => 37
  | WishListItem => 38 | Unclaimed => 39 | Actionable => 40 | Blocked => 41
  | Rewarded => 42 | ProofWish => 43 | CommunityWish => 44
  | CoreAnswered => 45 | HotTopic => 46 | Stale => 47
  | EffSmall => 48 | EffLarge => 49 | EffMedium => 50
  | Waiting => 51 | Ready => 52 | QuickWin => 53 | Epic => 54
  | NeedsSpec => 55 | Dormant => 56 | Answered => 57 | Endorsed => 58

end SFM.Tickets
