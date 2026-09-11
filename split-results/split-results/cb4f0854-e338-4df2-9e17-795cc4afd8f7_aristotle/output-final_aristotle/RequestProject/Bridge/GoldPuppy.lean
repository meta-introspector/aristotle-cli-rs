/-
# GoldPuppy — Lean 4 Formalization of the GoldPuppy UML Model

This module formalizes the GoldPuppy contribution-reward system,
originally modeled in Modelio UML (exported as XMI, dated March 2018).

GoldPuppy "biscuits" are tokens of appreciation earned by making quality
contributions to open source software and open knowledge projects.

## Model Overview

**Actors:**
- Contributor (base actor)
- QA (extends Contributor)
- Community Member (extends Contributor — "a contributor on a global scale")
- Supervisor
- Assessor (extends Contributor)
- Sponsor (extends Contributor)
- Non Member

**Use Cases:**
- Contribution to Project (central use case)
- Approval From Approver (extends Contribution, depends on it)
- Feedback about Contribution (extends Contribution)
- Assessment of value of contribution (extends Contribution)
- Supervisor Hires Staff
- Sponsor Dedicates Funds (extends Contribution)
- Sponsor works towards Goal
- Sponsor rewards contribution
- Sponsor defines Rules of rewards
- Users recruits new users (extends Contribution)

**Domain Classes:**
- Contribution (abstract)
- QAApproval (extends Contribution)
- Mining Contribution (extends Contribution)
- Project

**Deployment Nodes:**
- webserver, database, queuing system, project interface server,
  open streetmap server, goldpuppy miner nodes

## Design Principles (from goldpuppy README)
- Simple: python flask + react bootstrap, optimized parts in Go
- Modular: interchangeable parts with simple interfaces
- Lightweight: deployable on Raspberry Pi / small cloud / sdf.org
- Scalable: scales as more servers are added
- Trusted: only trusted known users interact

## Source
- XMI model name: "goldpuppy"
- Modelio project lock: mdupont@mdupont-Aspire-7750G, March 18, 2018
- Host: 192.168.1.79
-/

import Mathlib
import RequestProject.Compute.IPLD.IPLD
import RequestProject.Bridge.SelfModel

namespace GoldPuppy

-- ============================================================================
-- § 1  Actor Hierarchy
-- ============================================================================

/-- The role taxonomy in the GoldPuppy system.
    Mirrors the UML actor hierarchy with generalization relationships. -/
inductive ActorRole where
  | contributor      -- Base actor: anyone who contributes
  | qa               -- QA specialist (extends Contributor)
  | communityMember  -- Community member (extends Contributor, global scale)
  | supervisor       -- Supervises hiring
  | assessor         -- Assesses contribution value (extends Contributor)
  | sponsor          -- Provides funding (extends Contributor)
  | nonMember        -- External, not yet a member
  deriving DecidableEq, Repr, Inhabited

/-- An actor role extends Contributor if it inherits from Contributor in the UML model. -/
def ActorRole.extendsContributor : ActorRole → Prop
  | .contributor     => True
  | .qa              => True   -- generalization to Contributor
  | .communityMember => True   -- generalization to Contributor
  | .supervisor      => False
  | .assessor        => True   -- generalization to Contributor
  | .sponsor         => True   -- generalization to Contributor
  | .nonMember       => False

instance (r : ActorRole) : Decidable r.extendsContributor := by
  cases r <;> simp [ActorRole.extendsContributor] <;> exact inferInstance

-- ============================================================================
-- § 2  Use Case Taxonomy
-- ============================================================================

/-- The use cases in the GoldPuppy system.
    Generalization and dependency relationships are captured separately. -/
inductive UseCase where
  | contributionToProject       -- Central use case
  | approvalFromApprover        -- Extends & depends on contributionToProject
  | feedbackAboutContribution   -- Extends contributionToProject
  | assessmentOfValue           -- Extends contributionToProject
  | supervisorHiresStaff        -- Standalone
  | sponsorDedicatesFunds       -- Extends contributionToProject
  | sponsorWorksTowardsGoal     -- Standalone
  | sponsorRewardsContribution  -- Standalone
  | sponsorDefinesRules         -- Standalone
  | userRecruitsNewUsers        -- Extends contributionToProject
  deriving DecidableEq, Repr, Inhabited

/-- A use case extends "Contribution to Project" if the UML model
    has a generalization arrow from it to contributionToProject. -/
def UseCase.extendsContribution : UseCase → Prop
  | .contributionToProject      => False  -- It IS the base
  | .approvalFromApprover       => True
  | .feedbackAboutContribution  => True
  | .assessmentOfValue          => True
  | .supervisorHiresStaff       => False
  | .sponsorDedicatesFunds      => True
  | .sponsorWorksTowardsGoal    => False
  | .sponsorRewardsContribution => False
  | .sponsorDefinesRules        => False
  | .userRecruitsNewUsers       => True

instance (uc : UseCase) : Decidable uc.extendsContribution := by
  cases uc <;> simp [UseCase.extendsContribution] <;> exact inferInstance

/-- A use case has a dependency on "Contribution to Project". -/
def UseCase.dependsOnContribution : UseCase → Prop
  | .approvalFromApprover       => True   -- «contribution that is approved»
  | .feedbackAboutContribution  => True   -- unnamed dependency
  | .assessmentOfValue          => True   -- unnamed dependency
  | _                           => False

-- ============================================================================
-- § 3  Actor–UseCase Associations
-- ============================================================================

/-- An actor is associated with a use case in the UML model. -/
def actorParticipates : ActorRole → UseCase → Prop
  | .sponsor,          .contributionToProject      => True  -- via contributions assoc
  | .contributor,      .contributionToProject      => True  -- via contributions assoc
  | .qa,               .approvalFromApprover       => True  -- approves assoc
  | .qa,               .supervisorHiresStaff       => True  -- assoc
  | .communityMember,  .feedbackAboutContribution  => True  -- gives_feedback assoc
  | .supervisor,       .supervisorHiresStaff       => True  -- assoc
  | .assessor,         .assessmentOfValue          => True  -- assessor assoc
  | .assessor,         .supervisorHiresStaff       => True  -- assoc
  | .sponsor,          .sponsorDedicatesFunds      => True  -- assoc
  | .sponsor,          .sponsorWorksTowardsGoal    => True  -- assoc
  | .sponsor,          .sponsorRewardsContribution => True  -- assoc (via Sponsor rewards)
  | .sponsor,          .sponsorDefinesRules        => True  -- assoc (via goals)
  | .contributor,      .userRecruitsNewUsers       => True  -- assoc
  | .nonMember,        .userRecruitsNewUsers       => True  -- assoc (recruited)
  | _,                 _                           => False

-- ============================================================================
-- § 4  Domain Classes
-- ============================================================================

/-- Contribution kinds — the class hierarchy rooted at abstract Contribution. -/
inductive ContributionKind where
  | qaApproval          -- QAApproval extends Contribution
  | miningContribution  -- Mining Contribution extends Contribution
  | generic             -- Any other Contribution subclass
  deriving DecidableEq, Repr, Inhabited

/-- A contribution in the system. -/
structure Contribution where
  id      : Nat
  kind    : ContributionKind
  author  : ActorRole  -- must extend Contributor
  project : Nat        -- project ID
  deriving Repr

/-- A project in the system. -/
structure Project where
  id       : Nat
  name     : String
  deriving Repr

-- ============================================================================
-- § 5  Deployment Architecture
-- ============================================================================

/-- Deployment nodes from the UML deployment diagram. -/
inductive DeploymentNode where
  | webserver
  | database
  | queuingSystem
  | projectInterfaceServer
  | openStreetmapServer
  | goldpuppyMinerNodes
  deriving DecidableEq, Repr, Inhabited

-- ============================================================================
-- § 6  Sequence Diagram — Interaction Protocol
-- ============================================================================

/-- Messages from the UML sequence diagram "Interaction".
    These represent the protocol flow for contribution processing. -/
inductive ProtocolMessage where
  | requestsProject         -- Sponsor → Supervisor (args: Funding, Goals, Timeline)
  | createProject           -- Supervisor → Project (createMessage)
  | joinProject             -- Contributor → Project
  | createContribution      -- Contributor → Contribution (createMessage)
  | projectNumber           -- Supervisor → Sponsor (reply)
  | submitContribution      -- Contribution → Project
  | pays                    -- Sponsor → Project
  | payContribution         -- Project → Contribution
  | payContributor          -- Contribution → Contributor
  | joinProjectQA           -- QA → Project
  | qualityCheck            -- QA → Contribution
  | payQA                   -- Contribution → QA
  | payAssessor             -- Contribution → Assessor
  deriving DecidableEq, Repr, Inhabited

/-- A step in the interaction protocol. -/
structure ProtocolStep where
  seqNum  : Nat
  message : ProtocolMessage
  sender  : ActorRole ⊕ UseCase  -- Actor or system element
  deriving Repr

/-- The canonical interaction flow from the sequence diagram. -/
def canonicalFlow : List ProtocolMessage :=
  [ .requestsProject,      -- Sponsor requests project creation
    .createProject,         -- Supervisor creates project
    .joinProject,           -- Contributor joins project
    .createContribution,    -- Contributor creates contribution
    .projectNumber,         -- Supervisor returns project number to Sponsor
    .submitContribution,    -- Contribution submitted to project
    .pays,                  -- Sponsor pays project
    .payContribution,       -- Project pays for contribution
    .payContributor,        -- Contribution payment goes to contributor
    .joinProjectQA,         -- QA joins project
    .qualityCheck,          -- QA does quality check on contribution
    .payQA,                 -- Contribution pays QA
    .payAssessor ]          -- Contribution pays assessor

-- ============================================================================
-- § 7  Reward Rules & Association with Contributions
-- ============================================================================

/-- A reward rule defined by a Sponsor.
    This captures the "Sponsor defines Rules of rewards" use case. -/
structure RewardRule where
  ruleId      : Nat
  description : String
  deriving Repr

/-- The association between contributions and reward rules.
    From the UML: "rules" association with "applied_rules" and
    "associated_contributions" ends (many-to-many, aggregation=shared). -/
structure RuleApplication where
  contribution : Nat  -- contribution ID
  rule         : Nat  -- rule ID
  deriving Repr

-- ============================================================================
-- § 8  System Properties
-- ============================================================================

/-- Every use case that extends Contribution is itself a form of contribution. -/
theorem extension_is_contribution (uc : UseCase) :
    uc.extendsContribution → uc ≠ UseCase.contributionToProject := by
  cases uc <;> simp [UseCase.extendsContribution]

/-- The canonical flow is non-empty. -/
theorem canonicalFlow_nonempty : canonicalFlow ≠ [] := by
  simp [canonicalFlow]

/-- Every actor that participates in the assessment must be an Assessor. -/
theorem assessment_requires_assessor (r : ActorRole) :
    actorParticipates r .assessmentOfValue → r = .assessor := by
  cases r <;> simp [actorParticipates]

/-- QA is the only actor that directly approves contributions. -/
theorem approval_requires_qa (r : ActorRole) :
    actorParticipates r .approvalFromApprover → r = .qa := by
  cases r <;> simp [actorParticipates]

/-- Sponsors participate in at least 5 use cases. -/
theorem sponsor_participates_widely :
    actorParticipates .sponsor .contributionToProject ∧
    actorParticipates .sponsor .sponsorDedicatesFunds ∧
    actorParticipates .sponsor .sponsorWorksTowardsGoal ∧
    actorParticipates .sponsor .sponsorRewardsContribution ∧
    actorParticipates .sponsor .sponsorDefinesRules := by
  simp [actorParticipates]

-- ============================================================================
-- § 9  IPLD Integration — Encoding GoldPuppy entities as IPLD nodes
-- ============================================================================

/-- An IPLD-compatible representation of a GoldPuppy entity. -/
inductive GoldPuppyNode where
  | actorNode      : ActorRole → GoldPuppyNode
  | useCaseNode    : UseCase → GoldPuppyNode
  | contribNode    : Contribution → GoldPuppyNode
  | projectNode    : Project → GoldPuppyNode
  | deployNode     : DeploymentNode → GoldPuppyNode
  | ruleNode       : RewardRule → GoldPuppyNode
  | messageNode    : ProtocolMessage → GoldPuppyNode
  deriving Repr

/-- The GoldPuppy system as a whole — a collection of entities and relationships. -/
structure GoldPuppySystem where
  projects      : List Project
  contributions : List Contribution
  rules         : List RewardRule
  applications  : List RuleApplication
  deriving Repr

-- ============================================================================
-- § 10  Modelio Project Metadata (2018 legacy model)
-- ============================================================================

/-- Metadata from the 2018 Modelio project lock file. -/
structure ModelioLockInfo where
  user     : String := "mdupont"
  hostName : String := "192.168.1.79"
  vmId     : String := "27721@mdupont-Aspire-7750G"
  date     : String := "Sunday, March 18, 2018 11:09:15 AM EDT"
  version  : Nat    := 1
  deriving Repr

/-- The 2018 goldpuppy project lock. -/
def legacyLock : ModelioLockInfo := {}

-- ============================================================================
-- § 11  Audit Rule Configuration (from 2018 model)
-- ============================================================================

/-- Severity levels for Modelio audit rules. -/
inductive AuditSeverity where
  | tip | warning | error
  deriving DecidableEq, Repr, Inhabited

/-- Status of an audit rule. -/
inductive AuditStatus where
  | enabled | disabled | obsolete
  deriving DecidableEq, Repr, Inhabited

/-- An audit rule configuration entry. -/
structure AuditRule where
  ruleId   : String
  status   : AuditStatus
  severity : AuditSeverity
  deriving Repr

/-- Count of audit rules by severity in the 2018 configuration.
    The original config has ~200 rules, mostly error-level. -/
def auditRuleSummary : String :=
  "Total rules: ~200, Error: ~150, Warning: ~35, Tip: ~8, Disabled: 1 (R1530)"

end GoldPuppy
