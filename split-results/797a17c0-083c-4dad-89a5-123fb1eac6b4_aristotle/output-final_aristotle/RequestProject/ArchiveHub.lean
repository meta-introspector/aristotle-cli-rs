/-
  Main.lean — Hub file importing all formalized modules.

  Reorganized into 10 merged groups:
    • Math.Monster    — Monster group / Moonshine mathematics
    • Math.Clifford   — Clifford algebras and Bott periodicity
    • Math.DASHI      — DASHI mathematical specifications
    • Compute.FRACTRAN — FRACTRAN virtual machines
    • Compute.IPLD    — IPLD content addressing
    • Compute.Cosmic  — Cosmic pipeline and bootstrap
    • Governance      — Senate procedures and governance
    • Agent           — Multi-agent systems and DAO
    • Solfunmeme      — Solfunmeme ontology
    • Bridge          — Cross-cluster bridges and ontology
-/

-- § Shared constants and structures
import RequestProject.MonsterConstants
import RequestProject.SharedStructures

-- § Meta-generated tests
import RequestProject.MetaTests

-- § Group 1 — Math.Monster
import RequestProject.Math.Monster.ATLASGroups
import RequestProject.Math.Monster.AlternatingGroups
import RequestProject.Math.Monster.AtlasSheaf
import RequestProject.Math.Monster.SporadicAtlas
import RequestProject.Math.Monster.MoonshineTheory
import RequestProject.Math.Monster.CTblLibDifferences
import RequestProject.Math.Monster.CambridgeAnomaly
import RequestProject.Math.Monster.Cyclic
import RequestProject.Math.Monster.Dasein15
import RequestProject.Math.Monster.GolayTower
import RequestProject.Math.Monster.GradedGenerator
import RequestProject.Math.Monster.GriessAlgebra
import RequestProject.Math.Monster.InvolutionTest2E6
import RequestProject.Math.Monster.LeechLattice
import RequestProject.Math.Monster.McKayThompsonAtlas
import RequestProject.Math.Monster.ModularForms
import RequestProject.Math.Monster.MonsterBaseExt
import RequestProject.Math.Monster.MonsterCarriageTrain
import RequestProject.Math.Monster.MonsterConjugacy
import RequestProject.Math.Monster.MonsterMask
import RequestProject.Math.Monster.MoonshineCore
import RequestProject.Math.Monster.MonsterMycology
import RequestProject.Math.Monster.MonsterRepCategory
import RequestProject.Math.Monster.MonsterWalkZKP
import RequestProject.Math.Monster.MonsterLogWalk
import RequestProject.Math.Monster.MonstrousMoonshineSheaf
import RequestProject.Math.Monster.Moonshine
import RequestProject.Math.Monster.MoonshineEarn
import RequestProject.Math.Monster.PSL
import RequestProject.Math.Monster.SporadicGroups
import RequestProject.Math.Monster.Rho17ResourceLattice
import RequestProject.Math.Monster.SonnenlichtCore

import RequestProject.Math.Monster.UmbralHeckeOperators

-- § Group 1c — Math.Monster (merged moonshine / vertex-algebra theories)
import RequestProject.Math.Monster.MoonshineBlade
import RequestProject.Math.Monster.MoonshineOntology
import RequestProject.Math.Monster.MoonshineTheorem
import RequestProject.Math.Monster.MonsterAdjacentPrimes
import RequestProject.Math.Monster.MoonshineFacts
import RequestProject.Math.Monster.MonsterLieAlgebra
import RequestProject.Math.Monster.VertexAlgebra
import RequestProject.Math.Monster.UmbralMoonshine
import RequestProject.Math.Monster.PTE
import RequestProject.Math.Monster.Divisors
import RequestProject.Math.Monster.Synthesis

-- § Group 1b — Math.Monster.Slice (Cl(1–15) Monster slice formalization)
import RequestProject.Math.Monster.Slice.SupersingularPrimes
import RequestProject.Math.Monster.Slice.MonsterOrder
import RequestProject.Math.Monster.Slice.CliffordDefs
import RequestProject.Math.Monster.Slice.GermVials
import RequestProject.Math.Monster.Slice.MonsterSlice

-- § Group 2 — Math.Clifford
import RequestProject.Math.Clifford.BottMoonshineExperiment
import RequestProject.Math.Clifford.BottNestedCarriage
import RequestProject.Math.Clifford.BottPeriodicity
import RequestProject.Math.Clifford.CliffordBitBasis
import RequestProject.Math.Clifford.CliffordBase
import RequestProject.Math.Clifford.CliffordCanonical
import RequestProject.Math.Clifford.CliffordCl03
import RequestProject.Math.Clifford.CliffordCl04
import RequestProject.Math.Clifford.CliffordCl04Finite
import RequestProject.Math.Clifford.CliffordCl05
import RequestProject.Math.Clifford.CliffordCl06
import RequestProject.Math.Clifford.CliffordCl07
import RequestProject.Math.Clifford.CliffordMonster
import RequestProject.Math.Clifford.CliffordMonsterQExp
import RequestProject.Math.Clifford.CliffordTemplate
import RequestProject.Math.Clifford.TenfoldBridges
import RequestProject.Math.Clifford.ExteriorFinrank

-- § Group 2b — Math.Bridge (moonshine ↔ Clifford Σ-fibration)
import RequestProject.Math.Bridge.MoonshineCliffordSigma

-- § Group 2c — Physics (string-descent / minicharged-glue theories)
import RequestProject.Physics.MinichargedGlue
import RequestProject.Physics.BosonicStringDescent
import RequestProject.Physics.SuperstringDescent

-- § Group 3 — Math.DASHI
import RequestProject.Math.DASHI.Base369
import RequestProject.Math.DASHI.DashiAdmissibility
import RequestProject.Math.DASHI.DashiAnnihilation
import RequestProject.Math.DASHI.DashiCarrier
import RequestProject.Math.DASHI.DashiDefect
import RequestProject.Math.DASHI.DashiHierarchy
import RequestProject.Math.DASHI.DashiKernel
import RequestProject.Math.DASHI.FascisticSystem
import RequestProject.Math.DASHI.KernelAlgebra
import RequestProject.Math.DASHI.LogicTlurey
import RequestProject.Math.DASHI.Overflow
import RequestProject.Math.DASHI.UltrametricSpace

-- § Group 4 — Compute.FRACTRAN
import RequestProject.Compute.FRACTRAN.FractranBBf
import RequestProject.Compute.FRACTRAN.FractranCRTMerger
import RequestProject.Compute.FRACTRAN.FractranMes
import RequestProject.Compute.FRACTRAN.FractranMonster
import RequestProject.Compute.FRACTRAN.FractranVM

-- § Group 5 — Compute.IPLD
import RequestProject.Compute.IPLD.ContentAddressing
import RequestProject.Compute.IPLD.DA51
import RequestProject.Compute.IPLD.IPLD
import RequestProject.Compute.IPLD.IPLDCodeGen
import RequestProject.Compute.IPLD.IPLDCodec
import RequestProject.Compute.IPLD.IPLDMeta
import RequestProject.Compute.IPLD.IPLDMonsterSchema
import RequestProject.Compute.IPLD.IPLDRust
import RequestProject.Compute.IPLD.IPLDRustCoreMapping
import RequestProject.Compute.IPLD.IPLDSelfDescribe
import RequestProject.Compute.IPLD.MultiHashCID
import RequestProject.Compute.IPLD.UnifiedIPLDMemory
import RequestProject.Compute.IPLD.VibeRegister

-- § Group 6 — Governance
import RequestProject.Governance.ArcadeGovernance
import RequestProject.Governance.Basic
import RequestProject.Governance.Committees
import RequestProject.Governance.Enforcement
import RequestProject.Governance.FederalConstitution
import RequestProject.Governance.FiberCoherentHash
import RequestProject.Governance.GovernanceInvariant
import RequestProject.Governance.KernelGovernance
import RequestProject.Governance.PassiveLeakExt
import RequestProject.Governance.PrecedentLog
import RequestProject.Governance.Riddick
import RequestProject.Governance.RulemakingStatutes
import RequestProject.Governance.SenateGuide
import RequestProject.Governance.SenateMonster
import RequestProject.Governance.SenateTelegram
import RequestProject.Governance.TypedDMZ
import RequestProject.Governance.UCagreements
import RequestProject.Governance.Voting

-- § Group 7 — Agent
import RequestProject.Agent.Agents
import RequestProject.Agent.BoardroomTopology
import RequestProject.Agent.Consensus
import RequestProject.Agent.ContextFusion
import RequestProject.Agent.ContextWindow
import RequestProject.Agent.DaoOrganism
import RequestProject.Agent.LangAgentSecurity
import RequestProject.Agent.Reflection
import RequestProject.Agent.SearchLayerSemantics
import RequestProject.Agent.SelfModifyingContext
import RequestProject.Agent.Session
import RequestProject.Agent.SessionModel
import RequestProject.Agent.SporeLifecycle

-- § Group 8 — Compute.Cosmic
import RequestProject.Compute.Cosmic.Bootstrap
import RequestProject.Compute.Cosmic.CategoricalSuccessor
import RequestProject.Compute.Cosmic.CelestialShell
import RequestProject.Compute.Cosmic.CosmicSynthesis
import RequestProject.Compute.Cosmic.CrankToRamanujan
import RequestProject.Compute.Cosmic.Crankmining
import RequestProject.Compute.Cosmic.FiberedUniverse
import RequestProject.Compute.Cosmic.Gearbox
import RequestProject.Compute.Cosmic.GoalBearingNames
import RequestProject.Compute.Cosmic.GradedFiberedUniverse
import RequestProject.Compute.Cosmic.HubGeometry
import RequestProject.Compute.Cosmic.KTheoryMeta
import RequestProject.Compute.Cosmic.LandingInstruction
import RequestProject.Compute.Cosmic.MinimalViableSelfRef
import RequestProject.Compute.Cosmic.OracleMonad
import RequestProject.Compute.Cosmic.PadicEntropyDAG
import RequestProject.Compute.Cosmic.QExpansion
import RequestProject.Compute.Cosmic.RamanujanCrankAPI
import RequestProject.Compute.Cosmic.RamanujanCrankBridge
import RequestProject.Compute.Cosmic.SectorMap
import RequestProject.Compute.Cosmic.StarshipLaunch

-- § Group 9 — Solfunmeme
import RequestProject.Solfunmeme.CrossClusterOntology
import RequestProject.Solfunmeme.Solfunmeme
import RequestProject.Solfunmeme.SolfunmemeCategorical
import RequestProject.Solfunmeme.SolfunmemeCodeGen
import RequestProject.Solfunmeme.SolfunmemeEnriched
import RequestProject.Solfunmeme.SolfunmemeOntology
import RequestProject.Solfunmeme.SolfunmemeReachability
import RequestProject.Solfunmeme.SolfunmemeSchema
import RequestProject.Solfunmeme.SolfunmemeTypes
import RequestProject.Solfunmeme.SolfunmemeWikipedia

-- § Group 10 — Bridge
import RequestProject.Bridge.ATPAmbrosia
import RequestProject.Bridge.ATPPhiBridge
import RequestProject.Bridge.BridgeGeneralized
import RequestProject.Bridge.BulkBoundaryMapping
import RequestProject.Bridge.CRTPeriod
import RequestProject.Bridge.CanonicalOntology
import RequestProject.Bridge.CharTableHypermorphism
import RequestProject.Bridge.ConformalArrows
import RequestProject.Bridge.CosmicSheaf
import RequestProject.Bridge.DependencyDAG
import RequestProject.Bridge.EmojiNotation
import RequestProject.Bridge.EntityBridge
import RequestProject.Bridge.Extruder
import RequestProject.Bridge.FixedPointOntology
import RequestProject.Bridge.FungalExtruder
import RequestProject.Bridge.GlobalCertificate
import RequestProject.Bridge.GoldPuppy
import RequestProject.Bridge.GödelMoonshine
import RequestProject.Bridge.HarmonicTransport
import RequestProject.Bridge.HeroMonsterSynthesis
import RequestProject.Bridge.Historical
import RequestProject.Bridge.HypermorphicCID
import RequestProject.Bridge.HyphaCore
import RequestProject.Bridge.JitterDynamics
import RequestProject.Bridge.JourneyUniversalBridge
import RequestProject.Bridge.LatticeInvariants
import RequestProject.Bridge.MetaCoqKernel
import RequestProject.Bridge.Metameme
import RequestProject.Bridge.Monodromy
import RequestProject.Bridge.NeuroBridge
import RequestProject.Bridge.OODABridge
import RequestProject.Bridge.PartialPropagation
import RequestProject.Bridge.PathHeroJourneyCongruence
import RequestProject.Bridge.QuasifiberConsciousness
import RequestProject.Bridge.Recognition
import RequestProject.Bridge.SelfModel
import RequestProject.Bridge.SelfPartition
import RequestProject.Bridge.Sheaf
import RequestProject.Bridge.SystemProfile
import RequestProject.Bridge.TentacleCore
import RequestProject.Bridge.TopologicalOntology
import RequestProject.Bridge.TowerComposition
import RequestProject.Bridge.TransportMorphism
import RequestProject.Bridge.TwoChannelEvolution
import RequestProject.Bridge.UmweltGodelTrust
import RequestProject.Bridge.UnifiedConcepts
import RequestProject.Bridge.WitnessLayer

-- § Group 10b — Bridge (quasifiber-gate / hero-journey ontology cluster)
import RequestProject.Bridge.OntologyPrimes
import RequestProject.Bridge.Symbol
import RequestProject.Bridge.MusePrime
import RequestProject.Bridge.Quasifibration
import RequestProject.Bridge.HeroJourney
import RequestProject.Bridge.StructuralSpine
import RequestProject.Bridge.QuasifibrationGate
import RequestProject.Bridge.GateScan
import RequestProject.Bridge.MonsterScale

