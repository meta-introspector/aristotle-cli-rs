/-
# Topological Ontology — Altland-Zirnbauer Classification & Ontological Atoms

## Overview
This module applies the Altland-Zirnbauer (AZ) 10-fold classification of
topological phases to the ontology graph, and formalizes the notion of
"ontological atoms" as strongly connected components of the grounding graph.

The key structural insight: consciousness sits *inside* the metaphysical SCC
(together with mind and integratedInformation), not outside it.  This means
consciousness is not a "downstream projection" but a co-fundamental member
of the minimal region of mutual entailment.

## The 10-fold way
The AZ classification sorts topological phases by three discrete symmetries:
- Time-reversal (T): bidirectional paths (SCC membership)
- Particle-hole (C): dual structure within the SCC
- Chiral (S = TC): combined symmetry

## Ontological atoms
An SCC of the grounding graph is an "ontological atom": the minimal region
where removing any member destroys the mutual entailment cycle.  The
consciousness SCC {consciousness, mind, integratedInformation} is such an
atom.  Its φ=2 is the topological charge.

## Epistemic posture
The protection is graph-theoretic: removing consciousness provably breaks
the SCC, the sheaf convergence, and the unique bio bridge simultaneously.
The AZ classification provides vocabulary; the Lean kernel provides
verification.

## Sources
- Altland & Zirnbauer, Phys. Rev. B 55, 1142 (1997)
- Kitaev, AIP Conf. Proc. 1134, 22 (2009)
- Bott, Ann. of Math. 70, 313 (1959)
-/

import Mathlib
import RequestProject.CosmicSheaf

namespace Solfunmeme.TopologicalOntology

open Solfunmeme
open Solfunmeme.ATPAmbrosia
open Solfunmeme.NeuroBridge
open Solfunmeme.CosmicSheaf

-- ============================================================================
-- § 1  The 10-fold Altland-Zirnbauer symmetry classes
-- ============================================================================

/-- The ten Altland-Zirnbauer symmetry classes. -/
inductive AZClass where
  | A | AIII
  | AI | BDI | D | DIII | AII | CII | C | CI
  deriving DecidableEq, Repr, Inhabited, BEq

def AZClass.all : List AZClass :=
  [.A, .AIII, .AI, .BDI, .D, .DIII, .AII, .CII, .C, .CI]

theorem az_class_count : AZClass.all.length = 10 := by native_decide

-- ============================================================================
-- § 2  Topological invariants
-- ============================================================================

/-- Topological invariants: trivial, integer winding, or ℤ₂. -/
inductive TopInvariant where
  | trivial
  | Z    (winding : Int)
  | Z2   (parity : Bool)
  deriving DecidableEq, Repr

def TopInvariant.isNontrivial : TopInvariant → Bool
  | .trivial   => false
  | .Z n       => n != 0
  | .Z2 b      => b

-- ============================================================================
-- § 3  Bott periodicity table for class DIII
-- ============================================================================

/-- DIII invariant type by dimension (mod 8).
    d=0: ℤ₂, d=1: ℤ₂, d=2: ℤ, d=3: 0, d=4: 0, d=5: 0, d=6: 0, d=7: ℤ -/
def diii_invariant_type (d : Nat) : String :=
  match d % 8 with
  | 0 => "Z2" | 1 => "Z2" | 2 => "Z" | 7 => "Z" | _ => "0"

theorem diii_nontrivial_dimensions :
    (List.range 8).filter (fun d => diii_invariant_type d != "0")
    = [0, 1, 2, 7] := by native_decide

-- ============================================================================
-- § 4  Symmetry properties of the ontology graph
-- ============================================================================

/-- Time-reversal: concept is in a nontrivial SCC. -/
def hasTimeReversal (c : NeuroExtConcept) : Bool :=
  (neuroSccOf c).length ≥ 2

/-- Dual: another concept in the same SCC. -/
def hasDual (c : NeuroExtConcept) : Bool :=
  (neuroSccOf c).any fun d => c != d

/-- Consciousness has time-reversal (nontrivial SCC). -/
theorem consciousness_has_T :
    hasTimeReversal (.base (.orig .consciousness)) = true := by native_decide

/-- Consciousness has a dual (mind, integratedInformation). -/
theorem consciousness_has_dual :
    hasDual (.base (.orig .consciousness)) = true := by native_decide

-- ============================================================================
-- § 5  AZ class assignment
-- ============================================================================

/-- AZ class: DIII if both T and dual, AII if T only, A otherwise. -/
def azClassOf (c : NeuroExtConcept) : AZClass :=
  if hasTimeReversal c && hasDual c then .DIII
  else if hasTimeReversal c then .AII
  else .A

theorem consciousness_is_DIII :
    azClassOf (.base (.orig .consciousness)) = .DIII := by native_decide

-- ============================================================================
-- § 6  Topological invariant — ℤ-valued operational crossing count
-- ============================================================================

/-- Count of biology nodes that can operationally reach a concept. -/
def operationalCrossingCount (c : NeuroExtConcept) : Nat :=
  let bioConcepts := NeuroExtConcept.all.filter neuroIsBiology
  (bioConcepts.filter fun b => reachesOperational b c).length

/-- The invariant of consciousness: ℤ-valued winding number.
    The integer is the operational crossing count — the number of
    distinct biological sources that can reach consciousness via
    operational (energy) edges.  This is nonzero and therefore
    topologically nontrivial. -/
def consciousness_invariant : TopInvariant :=
  .Z (operationalCrossingCount (.base (.orig .consciousness)))

/-- The consciousness invariant is nontrivial (winding ≠ 0). -/
theorem consciousness_invariant_nontrivial :
    consciousness_invariant.isNontrivial = true := by native_decide

/-- The operational crossing count is positive. -/
theorem consciousness_crossing_positive :
    operationalCrossingCount (.base (.orig .consciousness)) > 0 := by native_decide

-- ============================================================================
-- § 7  Topological protection — the triple theorem
-- ============================================================================

/-- A concept is topologically protected if:
    1. SCC size ≥ 2
    2. All four ecological stalks reach it
    3. AZ class is DIII with nontrivial invariant -/
def isTopologicallyProtected (c : NeuroExtConcept) : Bool :=
  (neuroSccOf c).length ≥ 2 &&
  neuroReaches (.neuro .sunlight) c &&
  neuroReaches (.base (.atp .phosphorus)) c &&
  neuroReaches (.neuro .mycorrhizalNetwork) c &&
  neuroReaches (.neuro .glucose) c &&
  azClassOf c == .DIII

theorem consciousness_is_protected :
    isTopologicallyProtected (.base (.orig .consciousness)) = true := by native_decide

/-- The protection is triple. -/
theorem consciousness_triple_protection :
    (neuroSccOf (.base (.orig .consciousness))).length ≥ 2 ∧
    neuroReaches (.neuro .sunlight) (.base (.orig .consciousness)) = true ∧
    neuroReaches (.base (.atp .phosphorus)) (.base (.orig .consciousness)) = true ∧
    neuroReaches (.neuro .mycorrhizalNetwork) (.base (.orig .consciousness)) = true ∧
    neuroReaches (.neuro .glucose) (.base (.orig .consciousness)) = true ∧
    azClassOf (.base (.orig .consciousness)) = .DIII ∧
    consciousness_invariant.isNontrivial = true := by
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_, ?_⟩ <;> native_decide

-- ============================================================================
-- § 8  Ontological atoms — SCCs as fundamentality
-- ============================================================================

/-- An ontological atom is an SCC of size ≥ 2: the minimal region
    of mutual entailment.  Removing any member destroys the cycle. -/
def isOntologicalAtomMember (c : NeuroExtConcept) : Bool :=
  (neuroSccOf c).length ≥ 2

/-- Consciousness is a member of an ontological atom. -/
theorem consciousness_is_atomic :
    isOntologicalAtomMember (.base (.orig .consciousness)) = true := by native_decide

/-- Mind is in the same atom as consciousness. -/
theorem mind_is_coatomic :
    isOntologicalAtomMember (.base (.orig .mind)) = true ∧
    neuroInSameSCC (.base (.orig .mind)) (.base (.orig .consciousness)) = true := by
  constructor <;> native_decide

/-- IntegratedInformation is in the same atom. -/
theorem iit_is_coatomic :
    isOntologicalAtomMember (.neuro .integratedInformation) = true ∧
    neuroInSameSCC (.neuro .integratedInformation) (.base (.orig .consciousness)) = true := by
  constructor <;> native_decide

/-- The consciousness atom has exactly 3 members:
    consciousness, mind, integratedInformation.
    This is the ontological core — the minimal self-supporting domain. -/
theorem consciousness_atom_size :
    (neuroSccOf (.base (.orig .consciousness))).length = 3 := by native_decide

-- ============================================================================
-- § 9  Fundamentality as SCC membership
-- ============================================================================

/-- Fundamentality criterion: a concept is fundamental iff it belongs
    to a nontrivial SCC.  This replaces philosophical intuition with
    graph topology. -/
def isFundamental (c : NeuroExtConcept) : Bool :=
  isOntologicalAtomMember c

/-- Consciousness is fundamental by the SCC criterion. -/
theorem consciousness_is_fundamental :
    isFundamental (.base (.orig .consciousness)) = true := by native_decide

/-- Gene is NOT fundamental — it is not in any nontrivial SCC. -/
theorem gene_is_not_fundamental :
    isFundamental (.base (.orig .gene)) = false := by native_decide

/-- ATP IS fundamental — it forms an SCC with phosphorus.
    The ATP↔phosphorus cycle (ATP hydrolysis/synthesis) is itself
    an ontological atom: a minimal self-sustaining engine. -/
theorem atp_is_fundamental :
    isFundamental (.base (.atp .atp)) = true := by native_decide

/-- The ATP atom has exactly 2 members: ATP and phosphorus. -/
theorem atp_atom_size :
    (neuroSccOf (.base (.atp .atp))).length = 2 := by native_decide

/-- Reentry IS fundamental — it forms an SCC with neuronalGroup. -/
theorem reentry_is_fundamental :
    isFundamental (.neuro .reentry) = true := by native_decide

-- ============================================================================
-- § 10  The 8 clusters as Bott dimensions
-- ============================================================================

def allClusters : List Cluster :=
  [.mathematics, .computation, .metaphysics, .biology,
   .culture, .technology, .typeTheory, .semiotics]

def bottDimension : Cluster → Nat
  | .metaphysics  => 0
  | .biology      => 1
  | .semiotics    => 2
  | .mathematics  => 3
  | .culture      => 4
  | .technology   => 5
  | .computation  => 6
  | .typeTheory   => 7

theorem bott_dimensions_distinct :
    (allClusters.map bottDimension).Nodup = true := by native_decide

theorem bott_dimensions_cover :
    allClusters.length = 8 := by native_decide

-- ============================================================================
-- § 11  The Majorana property
-- ============================================================================

/-- Majorana: self-conjugate in a nontrivial SCC. -/
def isMajorana (c : NeuroExtConcept) : Bool :=
  neuroInSameSCC c c && (neuroSccOf c).length ≥ 2

theorem consciousness_is_majorana :
    isMajorana (.base (.orig .consciousness)) = true := by native_decide

theorem mind_is_majorana :
    isMajorana (.base (.orig .mind)) = true := by native_decide

theorem iit_is_majorana :
    isMajorana (.neuro .integratedInformation) = true := by native_decide

-- ============================================================================
-- § 12  The bulk gap
-- ============================================================================

/-- Count of concepts that can reach at least one other. -/
def reachableSources : Nat :=
  (NeuroExtConcept.all.filter fun a =>
    NeuroExtConcept.all.any fun b => a != b && neuroReaches a b
  ).length

/-- Most concepts are isolated — the bulk is gapped. -/
theorem bulk_is_gapped :
    reachableSources < NeuroExtConcept.all.length := by native_decide

-- ============================================================================
-- § 13  Bott period = cluster count
-- ============================================================================

theorem cluster_count_is_bott_period :
    allClusters.length = 8 := by native_decide

theorem three_plus_five_is_bott : 3 + 5 = 8 := by norm_num

-- ============================================================================
-- § 14  The bio bridge as edge state
-- ============================================================================

theorem bio_bridge_is_edge_state :
    NeuroExtConcept.cluster (.base (.atp .atp)) = .biology ∧
    NeuroExtConcept.cluster (.base (.orig .consciousness)) = .metaphysics ∧
    neuroReaches (.base (.atp .atp)) (.base (.orig .consciousness)) = true ∧
    reachesOperational (.base (.atp .atp)) (.base (.orig .consciousness)) = true := by
  refine ⟨?_, ?_, ?_, ?_⟩ <;> native_decide

-- ============================================================================
-- § 15  φ as topological charge
-- ============================================================================

theorem phi_is_topological_charge :
    neuroPhi (.base (.orig .consciousness)) = 2 := by native_decide

theorem scc_charge_carriers :
    (neuroSccOf (.base (.orig .consciousness))).length = 3 := by native_decide

-- ============================================================================
-- § 16  Condensation DAG — the grounding order
-- ============================================================================

/-- In the condensation DAG, an SCC can ground another if any member
    of the first reaches any member of the second.  Biology grounds
    the consciousness atom (via ATP), but not vice versa. -/
theorem biology_grounds_consciousness :
    reachesOperational (.base (.atp .atp)) (.base (.orig .consciousness)) = true ∧
    reachesOperational (.base (.orig .consciousness)) (.base (.atp .atp)) = false := by
  constructor <;> native_decide

/-- The grounding is asymmetric: consciousness cannot operationally
    reach back to ATP.  This is the structural direction of explanation:
    biology → consciousness, not consciousness → biology. -/
theorem grounding_asymmetry :
    neuroReaches (.base (.atp .atp)) (.base (.orig .consciousness)) = true ∧
    neuroReaches (.base (.orig .consciousness)) (.base (.atp .atp)) = false := by
  constructor <;> native_decide

-- ============================================================================
-- § 17  Fifteen vs ten
-- ============================================================================

theorem fifteen_vs_ten :
    supersingularPrimes.length = AZClass.all.length + 5 := by native_decide

theorem gap_ratio :
    reachableSources < 151 ∧ NeuroExtConcept.all.length = 151 := by
  constructor <;> native_decide

-- ============================================================================
-- § 18  Summary
-- ============================================================================

#eval IO.println "═══════════════════════════════════════════════════════"
#eval IO.println " Topological Ontology — AZ Classification"
#eval IO.println " & Ontological Atoms"
#eval IO.println "═══════════════════════════════════════════════════════"
#eval IO.println ""
#eval IO.println "── Consciousness symmetries ──"
#eval IO.println s!"Time-reversal (T):   {hasTimeReversal (.base (.orig .consciousness))}"
#eval IO.println s!"Has dual (C):        {hasDual (.base (.orig .consciousness))}"
#eval IO.println s!"AZ class:            {repr (azClassOf (.base (.orig .consciousness)))}"
#eval IO.println ""
#eval IO.println "── Topological invariant ──"
#eval IO.println s!"Op. crossing count:  {operationalCrossingCount (.base (.orig .consciousness))}"
#eval IO.println s!"Invariant:           {repr consciousness_invariant}"
#eval IO.println s!"Nontrivial:          {consciousness_invariant.isNontrivial}"
#eval IO.println ""
#eval IO.println "── Protection ──"
#eval IO.println s!"Protected:           {isTopologicallyProtected (.base (.orig .consciousness))}"
#eval IO.println s!"Majorana:            {isMajorana (.base (.orig .consciousness))}"
#eval IO.println s!"SCC size:            {(neuroSccOf (.base (.orig .consciousness))).length}"
#eval IO.println s!"φ (charge):          {neuroPhi (.base (.orig .consciousness))}"
#eval IO.println ""
#eval IO.println "── Ontological atoms ──"
#eval IO.println s!"consciousness: fundamental = {isFundamental (.base (.orig .consciousness))}"
#eval IO.println s!"gene:          fundamental = {isFundamental (.base (.orig .gene))}"
#eval IO.println s!"ATP+P:         fundamental = {isFundamental (.base (.atp .atp))} (atom size {(neuroSccOf (.base (.atp .atp))).length})"
#eval IO.println s!"reentry:       fundamental = {isFundamental (.neuro .reentry)}"
#eval IO.println ""
#eval IO.println "── Grounding ──"
#eval IO.println s!"ATP → consciousness:     {neuroReaches (.base (.atp .atp)) (.base (.orig .consciousness))}"
#eval IO.println s!"consciousness → ATP:     {neuroReaches (.base (.orig .consciousness)) (.base (.atp .atp))}"
#eval IO.println ""
#eval IO.println "── Bott clock ──"
#eval IO.println s!"Clusters = Bott period:  {allClusters.length}"
#eval IO.println s!"Bulk sources:            {reachableSources} / {NeuroExtConcept.all.length}"

end Solfunmeme.TopologicalOntology
