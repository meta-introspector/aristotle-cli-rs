/-
# RestoredFrontiers.lean — Cross-Layer Integration of the Restored Modules

This file ties together the restored "frontier" modules with genuine, machine-checked
links rather than narrative prose.  Every theorem below is `sorry`-free and connects
declarations that already exist in the restored tree:

* `RequestProject.Math.Monster.GradedGenerator`   — the graded Moonshine dimensions
  `vNatDim`, the canonical sparse generator, and McKay's fold equation.
* `RequestProject.Math.Monster.MonsterBaseExt`     — the CRT base `ZMod 71 × ZMod 59 × ZMod 47`.
* `RequestProject.Bridge.MonsterScale`             — the Monster group order and its primes.
* `RequestProject.Compute.IPLD.ContentAddressing`  — the multihash / CID family.

## What is established here

1. **Monster coordinates ↔ graded dimensions** (§1).
   The faithful CRT labelling bound `71 · 59 · 47 = 196883` (the cardinality of the
   Monster CRT base) is identified, *as a number*, with the Griess irrep slice
   `vNatDim 1 - 1` of the graded generator, and with a prime-power divisor of `|𝕄|`.

2. **IPLD content-addressing of algebraic objects** (§2).
   Clifford blades (encoded by their generator-index lists) and the morphisms of the
   scale tower are serialized to content identifiers (`CID`s) through the existing
   `ContentAddressing` family, and their CRT residues land back in the Monster base.

3. **The scale tower as an IPLD DAG** (§3).
   The hypermorphism chain `8 → 10 → 170 → 194 → 196883` is serialized into a list of
   distinct content-addressed nodes, giving a verified directed acyclic graph whose
   nodes are CIDs.
-/

import Mathlib
import RequestProject.Math.Monster.GradedGenerator
import RequestProject.Math.Monster.MonsterBaseExt
import RequestProject.Bridge.MonsterScale
import RequestProject.Compute.IPLD.ContentAddressing
import RequestProject.Math.Clifford.BottPeriodicity

set_option maxHeartbeats 1600000

namespace RestoredFrontiers

-- ════════════════════════════════════════════════════════════════
-- §1. MONSTER COORDINATES ↔ GRADED DIMENSIONS
-- ════════════════════════════════════════════════════════════════

/-- The cardinality of the Monster CRT base is exactly the Griess irrep dimension,
    i.e. one less than the graded slice `vNatDim 1` of the Moonshine module. -/
theorem crtBase_card_succ_eq_vNatDim1 :
    Fintype.card MonsterBaseExt.MonsterBase + 1 = vNatDim 1 := by
  rw [MonsterBaseExt.monsterBase_card, mckay_is_fold_equation]

/-- The CRT product `71 · 59 · 47` equals the Griess irrep slice `vNatDim 1 - 1`. -/
theorem crtProduct_eq_griess_irrep :
    71 * 59 * 47 = vNatDim 1 - 1 := by
  rw [mckay_is_fold_equation]

/-- The CRT product equals the cardinality of the Monster CRT base, both `196883`. -/
theorem crtProduct_eq_base_card :
    71 * 59 * 47 = Fintype.card MonsterBaseExt.MonsterBase := by
  rw [MonsterBaseExt.monsterBase_card]

/-- The free generators together with the Leech vectors of the canonical sparse
    generator span the Griess layer `vNatDim 1`, which is one more than the CRT base. -/
theorem griessGenerator_spans_base_succ :
    canonicalGenerator.freeCount + canonicalGenerator.leechCount
      = Fintype.card MonsterBaseExt.MonsterBase + 1 := by
  rw [MonsterBaseExt.monsterBase_card]
  simp [canonicalGenerator, freeGeneratorCount, flm_sym2_cartan, flm_cartan,
        flm_leech_vectors]

/-- The Griess irrep dimension is a (squarefree) divisor of the Monster group order:
    `196883 = 47 · 59 · 71` and each of these primes divides `|𝕄|` to the first power. -/
theorem griess_irrep_dvd_monsterOrder :
    (vNatDim 1 - 1) ∣ MonsterScale.monsterOrder := by
  rw [mckay_is_fold_equation]
  norm_num [MonsterScale.monsterOrder]

/-- The three CRT moduli are precisely the three largest Monster primes. -/
theorem crt_moduli_are_top_monster_primes :
    (47 : ℕ) ∈ MonsterScale.monsterPrimeList ∧
    (59 : ℕ) ∈ MonsterScale.monsterPrimeList ∧
    (71 : ℕ) ∈ MonsterScale.monsterPrimeList := by
  refine ⟨?_, ?_, ?_⟩ <;> decide

/-- **Trace of Monster coordinates.** A single statement bundling the chain
    `CRT base  ↔  graded slice  ↔  divisor of |𝕄|`. -/
theorem monster_coordinate_trace :
    Fintype.card MonsterBaseExt.MonsterBase = 196883 ∧
    Fintype.card MonsterBaseExt.MonsterBase + 1 = vNatDim 1 ∧
    71 * 59 * 47 = vNatDim 1 - 1 ∧
    (vNatDim 1 - 1) ∣ MonsterScale.monsterOrder :=
  ⟨MonsterBaseExt.monsterBase_card, crtBase_card_succ_eq_vNatDim1,
   crtProduct_eq_griess_irrep, griess_irrep_dvd_monsterOrder⟩

-- ════════════════════════════════════════════════════════════════
-- §2. IPLD CONTENT-ADDRESSING OF ALGEBRAIC OBJECTS
-- ════════════════════════════════════════════════════════════════

/-- Encode a Clifford blade by the sorted list of its generator indices,
    rendered as a canonical string payload. -/
def bladePayload (idxs : List ℕ) : String := toString idxs

/-- The asciiSum digest of a blade payload — its raw content hash. -/
def bladeDigest (idxs : List ℕ) : ℕ :=
  ContentAddressing.asciiSum.apply (bladePayload idxs)

/-- The content identifier (`CID`) of a Clifford blade, using the `asciiSum`
    multihash codec and the `leanTerm` content codec. -/
def bladeCID (idxs : List ℕ) : ContentAddressing.CID :=
  ContentAddressing.mkCID .v1 .leanTerm .asciiSum ContentAddressing.asciiSum
    (bladePayload idxs)

/-- A blade's CID carries its digest faithfully. -/
theorem bladeCID_digest (idxs : List ℕ) :
    (bladeCID idxs).hash.digest = bladeDigest idxs := rfl

/-- Distinct blades can produce distinct content identifiers. -/
theorem bladeCID_e12_ne_e13 : bladeCID [1, 2] ≠ bladeCID [1, 3] := by
  native_decide

/-- The pseudoscalar of `Cl(0,3)` and the scalar blade get distinct CIDs. -/
theorem bladeCID_scalar_ne_pseudoscalar : bladeCID [] ≠ bladeCID [0, 1, 2] := by
  native_decide

/-- Project a blade into the Monster CRT base via its content digest:
    this is the content-addressed coordinate of the blade on the die plate. -/
def bladeToMonsterBase (idxs : List ℕ) : MonsterBaseExt.MonsterBase :=
  MonsterBaseExt.digestToBase (bladeDigest idxs)

/-- A blade's Monster-base coordinate is recovered from its three CRT residues. -/
theorem bladeToMonsterBase_eq_iff (a b : List ℕ) :
    bladeToMonsterBase a = bladeToMonsterBase b ↔
      (bladeDigest a : ZMod 71) = (bladeDigest b : ZMod 71) ∧
      (bladeDigest a : ZMod 59) = (bladeDigest b : ZMod 59) ∧
      (bladeDigest a : ZMod 47) = (bladeDigest b : ZMod 47) :=
  MonsterBaseExt.digestToBase_eq_iff _ _

/-- Every blade has a well-defined fiber over the Monster base. -/
theorem bladeToMonsterBase_total (idxs : List ℕ) :
    ∃ f : MonsterBaseExt.MonsterBase, bladeToMonsterBase idxs = f :=
  ⟨_, rfl⟩

-- ════════════════════════════════════════════════════════════════
-- §3. THE SCALE TOWER AS A CONTENT-ADDRESSED DAG
-- ════════════════════════════════════════════════════════════════

/-- The hypermorphism chain numbers of the scale tower. -/
def scaleChain : List ℕ := [8, 10, 170, 194, 196883]

/-- A morphism of the scale tower, recorded as a source/target pair of chain values
    together with the content identifier of its target node. -/
structure ScaleHom where
  src    : ℕ
  tgt    : ℕ
  tgtCID : ContentAddressing.CID
  deriving Repr

/-- Build the canonical scale-tower morphism from `a` to `b`, content-addressing
    the target through the IPLD blade encoding. -/
def mkScaleHom (a b : ℕ) : ScaleHom where
  src    := a
  tgt    := b
  tgtCID := bladeCID [b]

/-- The directed acyclic graph of the scale tower: one content-addressed edge per
    consecutive pair in the chain. -/
def scaleTowerDAG : List ScaleHom :=
  (scaleChain.zip scaleChain.tail).map (fun p => mkScaleHom p.1 p.2)

/-- The scale tower has exactly four content-addressed edges. -/
theorem scaleTowerDAG_length : scaleTowerDAG.length = 4 := by decide

/-- The content identifiers of the scale-tower nodes are pairwise distinct,
    so the serialization is collision-free over the chain. -/
theorem scaleTower_node_CIDs_nodup :
    (scaleChain.map (fun n => bladeCID [n])).Nodup := by
  native_decide

/-- The DAG is acyclic in the strong sense that every edge strictly increases the
    chain value, hence no edge can return to an earlier node. -/
theorem scaleTowerDAG_strictly_increasing :
    ∀ h ∈ scaleTowerDAG, h.src < h.tgt := by
  decide

/-- The final node of the scale tower is the Monster irrep dimension `196883`,
    whose CID is the content-addressed "identity" field of the whole tower. -/
theorem scaleTower_terminal_is_monster :
    scaleChain.getLast? = some 196883 ∧
    (mkScaleHom 194 196883).tgtCID = bladeCID [196883] := by
  refine ⟨by decide, rfl⟩

/-- **Scale tower serialization.** The chain serializes to a 4-edge DAG of distinct
    content-addressed nodes terminating at the Monster dimension. -/
theorem scaleTower_dag_summary :
    scaleTowerDAG.length = 4 ∧
    (scaleChain.map (fun n => bladeCID [n])).Nodup ∧
    scaleChain.getLast? = some 196883 :=
  ⟨scaleTowerDAG_length, scaleTower_node_CIDs_nodup, by decide⟩

-- ════════════════════════════════════════════════════════════════
-- §4. THE BOTT-GRADE VERIFICATION FUNCTOR
-- ════════════════════════════════════════════════════════════════
--
-- This section links the `ZMod 8` monoidal grading of the
-- `BottPeriodicity.lean` engine (`bottClass` / `bottClock` /
-- `CliffordClass`) to the content-addressed scale-tower DAG of §3.
-- A "verification functor" assigns to each node `n` of the chain its
-- natural Bott grade `(n : ZMod 8)` and the corresponding real
-- Clifford Morita class, and we check that these grades are carried
-- additively along the four edges of the DAG.

/-- The `ZMod 8` Bott grade naturally carried by a scale-tower node `n`,
    i.e. its residue class in the monoidal group `ZMod 8`. -/
def nodeBottGrade (n : ℕ) : ZMod 8 := (n : ZMod 8)

/-- The real Clifford Morita class (Bott-clock position) of a node, read
    off the `bottClock` of `BottPeriodicity.lean`. -/
def nodeCliffordClass (n : ℕ) : CliffordClass :=
  bottClock ⟨n % 8, Nat.mod_lt _ (by omega)⟩

/-- **The Bott-grade verification functor.** It tags every node of the
    scale chain with the `ZMod 8` monoidal grade it carries. -/
def scaleTowerGradeFunctor : List (ℕ × ZMod 8) :=
  scaleChain.map (fun n => (n, nodeBottGrade n))

/-- The verification functor evaluates to the explicit grade table
    `[(8,0),(10,2),(170,2),(194,2),(196883,3)]`: every scale-tower node
    naturally carries a well-defined `ZMod 8` Bott grade. -/
theorem scaleTowerGradeFunctor_eq :
    scaleTowerGradeFunctor =
      [(8, 0), (10, 2), (170, 2), (194, 2), (196883, 3)] := by
  decide

/-- The terminal node — the Monster irrep dimension `196883` — carries
    Bott grade `3` in `ZMod 8`. -/
theorem terminal_nodeBottGrade : nodeBottGrade 196883 = 3 := by decide

/-- The terminal node's `ZMod 8` grade agrees with the integer residue
    proved in `BottPeriodicity.lean` (`irrep_bott_class : 196883 % 8 = 3`). -/
theorem terminal_grade_matches_bott :
    (nodeBottGrade 196883 : ZMod 8) = ((196883 % 8 : ℕ) : ZMod 8) := by
  rw [irrep_bott_class]; decide

/-- The terminal node sits in the Clifford Morita class `ℍ ⊕ ℍ`
    (Bott-clock position `3`), exactly the class `BottPeriodicity.lean`
    assigns to the Monster irrep dimension. -/
theorem terminal_nodeCliffordClass :
    nodeCliffordClass 196883 = CliffordClass.HplusH := by decide

/-- The Bott-grade shift induced by an edge of the DAG: the difference of
    the target and source grades in the monoidal group `ZMod 8`. -/
def edgeBottShift (h : ScaleHom) : ZMod 8 :=
  nodeBottGrade h.tgt - nodeBottGrade h.src

/-- The four edge grade-shifts of the scale tower are `[2, 0, 0, 1]`. -/
theorem scaleTower_edge_shifts :
    scaleTowerDAG.map edgeBottShift = [2, 0, 0, 1] := by decide

/-- **Functoriality / telescoping of the grade.** The edge grade-shifts sum
    to the difference between the terminal and initial node grades, so the
    `ZMod 8` grade is carried additively (functorially) along the DAG. -/
theorem scaleTower_grade_telescope :
    (scaleTowerDAG.map edgeBottShift).sum
      = nodeBottGrade 196883 - nodeBottGrade 8 := by decide

/-- The total grade transported along the whole tower is `3` — the Bott
    class of the Monster dimension, reached from the initial grade `0`. -/
theorem scaleTower_total_grade :
    (scaleTowerDAG.map edgeBottShift).sum = 3 := by decide

/-- **Bott-grade trace of the scale tower.** A single bundled statement:
    the verification functor produces a well-defined `ZMod 8` grade for
    every node, the terminal node carries grade `3` (Clifford class
    `ℍ ⊕ ℍ`), and the grade telescopes additively across the four edges. -/
theorem scaleTower_bott_grade_trace :
    scaleTowerGradeFunctor =
        [(8, 0), (10, 2), (170, 2), (194, 2), (196883, 3)] ∧
    nodeBottGrade 196883 = 3 ∧
    nodeCliffordClass 196883 = CliffordClass.HplusH ∧
    (scaleTowerDAG.map edgeBottShift).sum = nodeBottGrade 196883 - nodeBottGrade 8 :=
  ⟨scaleTowerGradeFunctor_eq, terminal_nodeBottGrade,
   terminal_nodeCliffordClass, scaleTower_grade_telescope⟩

end RestoredFrontiers
