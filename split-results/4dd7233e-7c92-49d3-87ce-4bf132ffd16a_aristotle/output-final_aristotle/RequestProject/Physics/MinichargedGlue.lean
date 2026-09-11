/-
# Minicharged Sector as a Sheaf Section over the Moonshine Base

This file instantiates the abstract `MoonshineOntology.PhysSector` /
`MoonshineOntology.SheafSection` machinery with the *concrete* 4d minicharged
anomaly / Prouhet–Tarry–Escott theory of Lee–Takahashi–Tsai
(arXiv:2603.12320), glued to the existing Monster/moonshine archive.

## What this file does

It builds a single **sheaf section** `MinichargedSection` whose:

* **base** is the Monster VOA `V♮` (a `MonsterBasePoint`), and
* **fiber** is a `PhysSector` whose 4d part is the `U(1)_H × U(1)_X`
  minicharged gauge theory and whose worldsheet part is the Monster VOA,
  carrying the shared supersingular / `Cl(15)` arithmetic skeleton.

## Honesty / scope (per the request)

* **No new physical theorem is asserted.**  `PhysSector` and `SheafSection`
  are purely organizational `Type`-level structures.
* The gluing map `anomaly_to_VA` is a *defined* interpretive map (it sends every
  anomaly-free charge assignment to the chosen worldsheet sector `V♮`); it is
  **not** an axiom and carries no physical claim — see its doc-string.
* All genuinely *proved* content stays in the arithmetic/combinatorial layer:
  the PTE / anomaly data (`RequestProject.PTE`), the supersingular primes,
  the CRT orbifold datum, and the `Cl(15)` blade hypercube
  (`RequestProject.Moonshine`).  The lemmas at the end of this file only
  check that the section was assembled consistently with that layer.
-/

import Mathlib
import RequestProject.PTE
import RequestProject.Moonshine
import RequestProject.Math.Monster.VertexAlgebra
import RequestProject.Math.Monster.McKayThompsonAtlas
import RequestProject.Math.Monster.BorcherdsProducts
import RequestProject.Math.Monster.MoonshineOntology

namespace MinichargedGlue

open MoonshineOntology

/-! ## §1. The 4d data types -/

/-- The 4d gauge-theory model: a chiral `U(1)_H × U(1)_X` minicharged-particle
sector with `2n` left-handed Weyl fermions, carrying `U(1)_H` charges `qH`
(vector-like `±1`) and chiral `U(1)_X` charges `qX`.  This is the Lean type
encoding the model implicit in the PTE development. -/
structure U1H_U1X_Model where
  /-- Half the number of Weyl fermions (`n` Dirac-pairing slots). -/
  n  : ℕ
  /-- The `U(1)_H` charges of the `2n` Weyl fermions (vector-like `±1`). -/
  qH : Fin (2 * n) → ℤ
  /-- The chiral `U(1)_X` charges of the `2n` Weyl fermions. -/
  qX : Fin (2 * n) → ℤ

/-- The anomaly polynomial of the `U(1)_H × U(1)_X` sector: the triple of
anomaly-cancellation constraints (degrees 1, 2, 3) on the two charge multisets
`A = {aᵢ}` and `B = {bᵢ}`.  These are exactly the equations of the degree-3
Prouhet–Tarry–Escott problem. -/
structure AnomalyPoly_U1H_U1X where
  /-- The first charge multiset `A = {aᵢ}`. -/
  A : List ℤ
  /-- The second charge multiset `B = {bᵢ}`. -/
  B : List ℤ
  /-- `U(1)_X`–grav–grav anomaly (degree 1): `∑ aᵢ = ∑ bᵢ`. -/
  grav  : PTE.PowerSum A 1 = PTE.PowerSum B 1
  /-- `(U(1)_X)²`–`U(1)_H` anomaly (degree 2): `∑ aᵢ² = ∑ bᵢ²`. -/
  mixed : PTE.PowerSum A 2 = PTE.PowerSum B 2
  /-- `(U(1)_X)³` anomaly (degree 3): `∑ aᵢ³ = ∑ bᵢ³`. -/
  cubic : PTE.PowerSum A 3 = PTE.PowerSum B 3

/-- The degree-3 PTE solution data: an `IsPTE` witness for two charge multisets. -/
structure PTE_Degree3_Data where
  /-- The first charge multiset `A`. -/
  A : List ℤ
  /-- The second charge multiset `B`. -/
  B : List ℤ
  /-- The degree-3 PTE / anomaly-cancellation witness. -/
  isPTE : PTE.IsPTE A B 3

/-- A reference to a worldsheet vertex-algebra / CFT sector, here the Monster
VOA `V♮`.  We record the light-weight invariants (central charge and graded
dimensions) of `V♮` so that this sits in `Type` (the universe expected by
`PhysSector.worldsheet_VA`); the full VOA datum lives in
`VertexAlgebra.moonshineModule`. -/
structure Vnat where
  /-- The central charge `c = 24` of `V♮`. -/
  centralCharge : ℚ
  /-- The graded dimensions of `V♮` (`j(τ) - 744` coefficients). -/
  gradedDim : ℤ → ℕ

/-- The canonical `V♮` reference, recording the Moonshine-module invariants. -/
def VnatRef : Vnat := ⟨24, VertexAlgebra.moonshineGradedDim⟩

/-! ## §2. The interpretive gluing map

`anomaly_to_VA` sends anomaly data to the chosen worldsheet sector `V♮`.

**This is an interpretive map, not a physical theorem.**  It encodes only the
organizational statement "an anomaly-free charge assignment is *interpreted* as
living over the `V♮` sector"; it makes no assertion about an actual
vertex-algebra realization of the 4d theory and is deliberately *defined*
(here, as the constant map to `V♮`) rather than axiomatized. -/
def anomaly_to_VA : AnomalyPoly_U1H_U1X → Vnat :=
  fun _ => VnatRef

/-! ## §3. The minicharged `PhysSector` and `SheafSection` -/

/-- The minicharged sector as a `PhysSector`: its 4d part is the
`U(1)_H × U(1)_X` model, its anomaly part is the degree-1/2/3 constraint triple,
its PTE part is the degree-3 PTE solution data, its worldsheet part is `V♮`, and
it carries the shared supersingular / `Cl(15)` arithmetic (the 15 supersingular
primes, the blade hypercube, and the CRT orbifold lift `116427`). -/
def MinichargedSector : PhysSector where
  dim4_QFT      := U1H_U1X_Model
  anomaly_poly  := AnomalyPoly_U1H_U1X
  pte_data      := PTE_Degree3_Data
  worldsheet_VA := Vnat
  ss_primes     := Moonshine.ssPrimes.toFinset
  blade_space   := Moonshine.Blade
  crt_orbifold  := 116427
  glue_map      := anomaly_to_VA

/-- The minicharged sector as a sheaf section over the moonshine base, with base
point the Monster VOA `V♮`. -/
def MinichargedSection : SheafSection where
  base_point := MonsterBasePoint.Vnat
  fiber      := MinichargedSector

/-! ## §4. Concrete anomaly / PTE witnesses

These pin the abstract fiber to honest, machine-checked solutions from the PTE
layer (Table I and the Landau-pole-minimal solution). -/

/-- The Landau-pole-minimal solution `A = {-3,0,1,4}`, `B = {-2,-2,3,3}` as
concrete anomaly-polynomial data (all three constraints verified). -/
def landauAnomaly : AnomalyPoly_U1H_U1X where
  A := [-3, 0, 1, 4]
  B := [-2, -2, 3, 3]
  grav  := by decide
  mixed := by decide
  cubic := by decide

/-- The Landau-pole-minimal solution as a `PTE_Degree3_Data` witness. -/
def landauPTE : PTE_Degree3_Data := ⟨_, _, PTE.landau_minimal⟩

/-- Table I solution No. 1 as a `PTE_Degree3_Data` witness. -/
def tableNo1PTE : PTE_Degree3_Data := ⟨_, _, PTE.table_no1⟩

/-! ## §5. Consistency checks (arithmetic layer)

The only theorems here verify that the section was assembled consistently with
the proved arithmetic/combinatorial layer.  No physical claim is made. -/

/-- The fiber's supersingular primes are exactly the 15 Ogg primes. -/
theorem minicharged_ss_eq :
    MinichargedSector.ss_primes = Moonshine.ssPrimes.toFinset := rfl

/-- There are 15 supersingular primes in the fiber. -/
theorem minicharged_ss_card : MinichargedSector.ss_primes.card = 15 := by
  rw [minicharged_ss_eq]; native_decide

/-- The fiber's blade space is the `Cl(15)` blade hypercube. -/
theorem minicharged_blade_eq :
    MinichargedSector.blade_space = Moonshine.Blade := rfl

/-- The fiber's CRT orbifold lift is `116427`, the unique residue realizing the
metadata triple `(8 mod 47, 20 mod 59, 58 mod 71)` below `196883`. -/
theorem minicharged_crt : MinichargedSector.crt_orbifold = 116427 := rfl

/-- The CRT orbifold lift is consistent with the proved CRT datum. -/
theorem minicharged_crt_consistent :
    MinichargedSector.crt_orbifold < 196883 ∧
    MinichargedSector.crt_orbifold % 47 = 8 ∧
    MinichargedSector.crt_orbifold % 59 = 20 ∧
    MinichargedSector.crt_orbifold % 71 = 58 := by
  rw [minicharged_crt]; exact Moonshine.orbifold_crt

/-- The section sits over the Monster VOA `V♮`. -/
theorem minicharged_base : MinichargedSection.base_point = MonsterBasePoint.Vnat := rfl

/-- The section's fiber is the minicharged sector. -/
theorem minicharged_fiber : MinichargedSection.fiber = MinichargedSector := rfl

/-! ## §6. Read-only links to the Monster / moonshine layer

These are *read-only* references (aliases) to existing, already-proved data in
the Borcherds / McKay–Thompson archive.  They add **no new mathematical
content** — they only make the connection points explicit so the glue layer can
cite them.  Nothing here is a new physical claim. -/

/-- Read-only link: the McKay–Thompson series `T_{71A}` (largest supersingular
prime class), reused verbatim from `McKayThompsonAtlas`. -/
def linkT71A : List ℤ := McKayThompsonAtlas.T71A

/-- Read-only link: the McKay–Thompson series `T_{1A}` (the `j`-function),
reused verbatim from `McKayThompsonAtlas`. -/
def linkT1A : List ℤ := McKayThompsonAtlas.T1A

/-- Read-only link: the cross-file Borcherds "master" moonshine theorem.  This
is a definitional alias of `BorcherdsProducts.moonshine_master`; it re-states no
new fact. -/
theorem moonshine_master_link :
    BorcherdsProducts.c 1 = BorcherdsProducts.chi1 + BorcherdsProducts.chi2 ∧
    BorcherdsProducts.c 2 =
      BorcherdsProducts.chi1 + BorcherdsProducts.chi2 + BorcherdsProducts.chi3 ∧
    BorcherdsProducts.c 3 =
      2 * BorcherdsProducts.chi1 + 2 * BorcherdsProducts.chi2 +
        BorcherdsProducts.chi3 + BorcherdsProducts.chi4 ∧
    BorcherdsProducts.c 1 = 196560 + 300 + 24 ∧
    BorcherdsProducts.genus_zero_count = 171 ∧
    MonsterConstants.M_order =
      2 * BorcherdsProducts.num_axes * MonsterConstants.B_order :=
  BorcherdsProducts.moonshine_master

/-! ## §7. The interpretive `sectorToMcKay` map

`sectorToMcKay` chooses a `MonsterBasePoint` for a glued section based on its
arithmetic skeleton.  It is **interpretive, not physically derived**: the
choice below indexes the base point by the section's CRT orbifold residue (an
Atlas-style label), purely so that sections can be organized over the Monster /
moonshine layer.  It is a *defined* total function, not an axiom. -/

/-- Interpretive assignment of a Monster/moonshine base point to a section,
indexed by its CRT orbifold residue.  Not physically derived — organizational
glue only. -/
def sectorToMcKay (s : SheafSection) : MonsterBasePoint :=
  MonsterBasePoint.ConjClass (toString s.fiber.crt_orbifold)

/-! ## §8. A second example sector

We clone `MinichargedSector` into a second `PhysSector` carrying a *different*
PTE solution (Table I, No. 2: `A = {0,6,7,13}`, `B = {1,3,10,12}`), and place it
over a different base point.  This gives a small *family* of glued sections to
compare.  The shared arithmetic skeleton (supersingular primes, blade space,
CRT lift) is identical by construction. -/

/-- Table I solution No. 2 as a `PTE_Degree3_Data` witness. -/
def tableNo2PTE : PTE_Degree3_Data := ⟨_, _, PTE.table_no2⟩

/-- Table I solution No. 2 as concrete anomaly-polynomial data. -/
def tableNo2Anomaly : AnomalyPoly_U1H_U1X where
  A := [0, 6, 7, 13]
  B := [1, 3, 10, 12]
  grav  := by decide
  mixed := by decide
  cubic := by decide

/-- A second minicharged sector, structurally identical to `MinichargedSector`
but associated with the Table I No. 2 PTE solution.  The arithmetic skeleton is
the same shared supersingular / `Cl(15)` data. -/
def AltMinichargedSector : PhysSector where
  dim4_QFT      := U1H_U1X_Model
  anomaly_poly  := AnomalyPoly_U1H_U1X
  pte_data      := PTE_Degree3_Data
  worldsheet_VA := Vnat
  ss_primes     := Moonshine.ssPrimes.toFinset
  blade_space   := Moonshine.Blade
  crt_orbifold  := 116427
  glue_map      := anomaly_to_VA

/-- The second sheaf section, placed over the Monster conjugacy class `2A`
(the Baby-Monster class) instead of the bare VOA base point. -/
def AltMinichargedSection : SheafSection where
  base_point := MonsterBasePoint.ConjClass "2A"
  fiber      := AltMinichargedSector

/-! ### §8.1 A third example sector (for the sheaf triangle)

We add a *third* `PhysSector` carrying yet another PTE solution (Table I,
No. 3: `A = {0,5,10,15}`, `B = {1,3,12,14}`), placed over the Monster
conjugacy class `3A`.  Together with `MinichargedSection` and
`AltMinichargedSection` this gives three sections that share one and the same
arithmetic fiber but sit over three distinct Monster/moonshine base points —
the nodes of a nontrivial sheaf loop. -/

/-- Table I solution No. 3 as a `PTE_Degree3_Data` witness. -/
def tableNo3PTE : PTE_Degree3_Data := ⟨_, _, PTE.table_no3⟩

/-- Table I solution No. 3 as concrete anomaly-polynomial data. -/
def tableNo3Anomaly : AnomalyPoly_U1H_U1X where
  A := [0, 5, 10, 15]
  B := [1, 3, 12, 14]
  grav  := by decide
  mixed := by decide
  cubic := by decide

/-- A third minicharged sector, structurally identical to `MinichargedSector`
but associated with the Table I No. 3 PTE solution.  The arithmetic skeleton is
the same shared supersingular / `Cl(15)` data. -/
def NewMinichargedSector : PhysSector where
  dim4_QFT      := U1H_U1X_Model
  anomaly_poly  := AnomalyPoly_U1H_U1X
  pte_data      := PTE_Degree3_Data
  worldsheet_VA := Vnat
  ss_primes     := Moonshine.ssPrimes.toFinset
  blade_space   := Moonshine.Blade
  crt_orbifold  := 116427
  glue_map      := anomaly_to_VA

/-- The third sheaf section, placed over the Monster conjugacy class `3A`
(a different VOA grade / base point). -/
def NewMinichargedSection : SheafSection where
  base_point := MonsterBasePoint.ConjClass "3A"
  fiber      := NewMinichargedSector

/-! ## §9. Sector comparison (arithmetic layer)

The two sections share the same arithmetic skeleton; these lemmas verify it via
the query API. -/

/-- Both example sections have the same supersingular-prime product (the
Oggorial). -/
theorem sections_same_ss_product :
    sectorSupersingularProduct MinichargedSection =
      sectorSupersingularProduct AltMinichargedSection := rfl

/-- Both example sections have the same blade count `2 ^ 15`. -/
theorem sections_same_blade_card :
    sectorBladeCard MinichargedSection = sectorBladeCard AltMinichargedSection := rfl

/-- The blade count of the minicharged section is `2 ^ 15 = 32768`. -/
theorem minicharged_blade_card : sectorBladeCard MinichargedSection = 32768 := by
  unfold sectorBladeCard MinichargedSection
  rw [minicharged_ss_eq]; native_decide

/-- The supersingular-prime product of the minicharged section is the
Oggorial `1618964990108856390`. -/
theorem minicharged_ss_product :
    sectorSupersingularProduct MinichargedSection = 1618964990108856390 := by
  unfold sectorSupersingularProduct MinichargedSection
  rw [minicharged_ss_eq]; native_decide

/-- `sectorToMcKay` sends the minicharged section to the conjugacy-class base
point labelled by its CRT residue `116427`. -/
theorem sectorToMcKay_minicharged :
    sectorToMcKay MinichargedSection = MonsterBasePoint.ConjClass "116427" := rfl

/-! ## §10. Projection to Moonshine and lift to arithmetic

The two interpretive directions of the glue, specialized to the concrete
minicharged sections.  Neither is physically derived. -/

/-- Projection to the Monster/VOA layer: a section's base point as chosen by the
interpretive `sectorToMcKay` map.  "This 4d anomaly/PTE sector corresponds to
this Monster/VOA base point." -/
def projectToVOA (s : SheafSection) : MonsterBasePoint :=
  sectorToMcKay s

/-- The minicharged section projects to the `116427` Monster base point. -/
theorem projectToVOA_minicharged :
    projectToVOA MinichargedSection = MonsterBasePoint.ConjClass "116427" := rfl

/-- The minicharged section lifts to its CRT arithmetic label `116427`. -/
theorem liftToArithmetic_minicharged :
    liftToArithmetic MinichargedSection = 116427 := rfl

/-! ## §11. The minicharged section family

The two example sectors collected as a `SectionFamily`, with its query API. -/

/-- The family of the three example sections
(Minicharged + AltMinicharged + NewMinicharged). -/
def MinichargedFamily : SectionFamily :=
  [MinichargedSection, AltMinichargedSection, NewMinichargedSection]

/-- All family members carry the Oggorial as supersingular product. -/
theorem family_ss_products :
    familySupersingularProduct MinichargedFamily =
      [1618964990108856390, 1618964990108856390, 1618964990108856390] := by
  unfold familySupersingularProduct MinichargedFamily
     sectorSupersingularProduct MinichargedSection AltMinichargedSection
     NewMinichargedSection MinichargedSector AltMinichargedSector
     NewMinichargedSector
  native_decide

/-- All family members carry the `2 ^ 15` blade count. -/
theorem family_blade_cards :
    familyBladeCard MinichargedFamily = [32768, 32768, 32768] := by
  unfold familyBladeCard MinichargedFamily
     sectorBladeCard MinichargedSection AltMinichargedSection
     NewMinichargedSection MinichargedSector AltMinichargedSector
     NewMinichargedSector
  native_decide

/-- The base points of the family: the bare VOA `V♮`, the `2A` conjugacy class,
and the `3A` conjugacy class. -/
theorem family_base_points :
    familyBasePoints MinichargedFamily =
      [MonsterBasePoint.Vnat, MonsterBasePoint.ConjClass "2A",
       MonsterBasePoint.ConjClass "3A"] := rfl

/-! ## §12. The minicharged sheaf triangle

The three sections collected into a `SheafDiagram`, wired with three explicit
Hecke-labelled edges that close a *triangle*

```
  MinichargedSection ──T₅₉──▶ AltMinichargedSection
         ▲                              │
         │ T₄₇                          │ T₂
         │                              ▼
  NewMinichargedSection ◀────────────────
```

All three sectors carry the same anomaly fiber type (`AnomalyPoly_U1H_U1X`), so
the natural arrow on the fibers is the identity, documented here as the
*interpretive* glue map.  As elsewhere in this layer, no new physical theorem is
asserted: the edges only record which sections are connected and by which Hecke
navigation operator.  The mathematical content is the *coherence* of the loop
(`triangle_coherent`): one arithmetic fiber, three distinct Monster/moonshine
base points, joined into a closed cycle. -/

/-- Triangle edge 1, a Hecke-labelled edge
`MinichargedSection → AltMinichargedSection`.  Identity on the shared anomaly
fiber, interpreted as the Hecke (`T₅₉`) move from the bare-VOA base point to the
`2A` conjugacy-class base point. -/
def edge_Hecke_p1 : SectionMorph where
  src := MinichargedSection
  dst := AltMinichargedSection
  map := fun ap => ap

/-- Triangle edge 2, a Hecke-labelled edge
`AltMinichargedSection → NewMinichargedSection`.  Identity on the shared anomaly
fiber, interpreted as the Hecke (`T₂`) move from the `2A` base point to the `3A`
base point. -/
def edge_Hecke_p2 : SectionMorph where
  src := AltMinichargedSection
  dst := NewMinichargedSection
  map := fun ap => ap

/-- Triangle edge 3, a Hecke-labelled edge
`NewMinichargedSection → MinichargedSection`.  Identity on the shared anomaly
fiber, interpreted as the Hecke (`T₄₇`) move from the `3A` base point back to the
bare-VOA base point, closing the loop. -/
def edge_Hecke_p3 : SectionMorph where
  src := NewMinichargedSection
  dst := MinichargedSection
  map := fun ap => ap

/-- The minicharged sheaf triangle: the three example sections as nodes, with
the three Hecke-labelled edges that close the loop. -/
def MinichargedDiagram : SheafDiagram where
  nodes := [MinichargedSection, AltMinichargedSection, NewMinichargedSection]
  edges := [edge_Hecke_p1, edge_Hecke_p2, edge_Hecke_p3]

/-- The diagram has three nodes. -/
theorem minichargedDiagram_numNodes : MinichargedDiagram.numNodes = 3 := rfl

/-- The diagram has three edges (the closed triangle). -/
theorem minichargedDiagram_numEdges : MinichargedDiagram.numEdges = 3 := rfl

/-- The three edges meet head-to-tail and close the loop: edge 1 ends where
edge 2 begins, edge 2 ends where edge 3 begins, and edge 3 ends where edge 1
begins. -/
theorem triangle_edges_chain :
    edge_Hecke_p1.dst = edge_Hecke_p2.src ∧
      edge_Hecke_p2.dst = edge_Hecke_p3.src ∧
      edge_Hecke_p3.dst = edge_Hecke_p1.src := ⟨rfl, rfl, rfl⟩

/-! ## §13. Navigation and comparison sanity checks -/

/-- `heckeStep` keeps the minicharged fiber fixed while moving the base point
`V♮` to the graded sector `V♮₁₃` (`T₁₃`, from the supplied metadata). -/
theorem hecke_minicharged_base :
    (heckeStep 13 MinichargedSection).base_point = MonsterBasePoint.voaSector 13 := rfl

/-- `heckeStep` does not touch the fiber of the minicharged section. -/
theorem hecke_minicharged_fiber :
    (heckeStep 13 MinichargedSection).fiber = MinichargedSector := rfl

/-- The three example sections are pairwise arithmetically equivalent (same
supersingular primes and blade space). -/
theorem triangle_arithEq :
    arithEq MinichargedSection AltMinichargedSection ∧
      arithEq AltMinichargedSection NewMinichargedSection ∧
      arithEq NewMinichargedSection MinichargedSection :=
  ⟨⟨rfl, rfl⟩, ⟨rfl, rfl⟩, ⟨rfl, rfl⟩⟩

/-- The three example sections are pairwise PTE-equivalent (same PTE data type). -/
theorem triangle_pteEq :
    pteEq MinichargedSection AltMinichargedSection ∧
      pteEq AltMinichargedSection NewMinichargedSection ∧
      pteEq NewMinichargedSection MinichargedSection :=
  ⟨rfl, rfl, rfl⟩

/-- The three example sections sit over *pairwise distinct* base points
(`V♮`, `2A`, `3A`). -/
theorem triangle_distinct_base :
    ¬ baseEq MinichargedSection AltMinichargedSection ∧
      ¬ baseEq AltMinichargedSection NewMinichargedSection ∧
      ¬ baseEq NewMinichargedSection MinichargedSection := by
  refine ⟨?_, ?_, ?_⟩ <;> decide

/-- **Triangle coherence lemma.**  The first nontrivial sheaf loop: the three
nodes share one and the same arithmetic fiber (pairwise `arithEq` and `pteEq`)
yet sit over three pairwise-distinct Monster/moonshine base points, and the
diagram joining them has exactly three edges forming a closed triangle. -/
theorem triangle_coherent :
    (arithEq MinichargedSection AltMinichargedSection ∧
       arithEq AltMinichargedSection NewMinichargedSection ∧
       arithEq NewMinichargedSection MinichargedSection) ∧
    (pteEq MinichargedSection AltMinichargedSection ∧
       pteEq AltMinichargedSection NewMinichargedSection ∧
       pteEq NewMinichargedSection MinichargedSection) ∧
    (¬ baseEq MinichargedSection AltMinichargedSection ∧
       ¬ baseEq AltMinichargedSection NewMinichargedSection ∧
       ¬ baseEq NewMinichargedSection MinichargedSection) ∧
    MinichargedDiagram.numEdges = 3 :=
  ⟨triangle_arithEq, triangle_pteEq, triangle_distinct_base, rfl⟩

/-! ## §14. Walking the triangle

We now make the loop *concrete and walkable*.  Fix a single PTE solution — Table I
No. 1, `A = {0,4,7,11}`, `B = {1,2,9,10}` — and carry it around the triangle.

A `TriangleWalker` records the (fixed) anomaly/PTE charge multisets together with
the current Monster/moonshine base point.  Each Hecke step applies the
corresponding triangle edge: it transports the charges along the edge's fiber map
(which is the identity, since all three sectors share the anomaly fiber) and moves
the base point to the edge's target.  Thus *nothing changes in the 4d theory* —
only the moonshine base point moves — and walking all three edges returns the
walker to its starting state:

```
  V♮ ──T₅₉──▶ 2A ──T₂──▶ 3A ──T₄₇──▶ V♮
```

This is the explicit form of the "commutative glue": a closed loop in Monster
space over a fixed 4d anomaly/PTE fiber. -/

/-- Table I solution No. 1 as concrete anomaly-polynomial data
(`A = {0,4,7,11}`, `B = {1,2,9,10}`).  This is the charge multiset we carry
around the triangle. -/
def tableNo1Anomaly : AnomalyPoly_U1H_U1X where
  A := [0, 4, 7, 11]
  B := [1, 2, 9, 10]
  grav  := by decide
  mixed := by decide
  cubic := by decide

/-- A walker on the sheaf triangle: the (fixed) anomaly/PTE charge data it carries
together with its current Monster/moonshine base point. -/
structure TriangleWalker where
  /-- The anomaly/PTE charge data carried around the loop. -/
  charges : AnomalyPoly_U1H_U1X
  /-- The current Monster/moonshine base point. -/
  base : MonsterBasePoint

/-- Edge 1 step (`T₅₉`): transport the charges along `edge_Hecke_p1` and move the
base point to its target (`V♮ → 2A`). -/
def stepHecke59 (w : TriangleWalker) : TriangleWalker where
  charges := edge_Hecke_p1.map w.charges
  base := edge_Hecke_p1.dst.base_point

/-- Edge 2 step (`T₂`): transport the charges along `edge_Hecke_p2` and move the
base point to its target (`2A → 3A`). -/
def stepHecke2 (w : TriangleWalker) : TriangleWalker where
  charges := edge_Hecke_p2.map w.charges
  base := edge_Hecke_p2.dst.base_point

/-- Edge 3 step (`T₄₇`): transport the charges along `edge_Hecke_p3` and move the
base point to its target (`3A → V♮`), closing the loop. -/
def stepHecke47 (w : TriangleWalker) : TriangleWalker where
  charges := edge_Hecke_p3.map w.charges
  base := edge_Hecke_p3.dst.base_point

/-- The starting walker: Table I No. 1 charges, sitting over the bare VOA base
point `V♮` (the base point of `MinichargedSection`). -/
def startWalker : TriangleWalker where
  charges := tableNo1Anomaly
  base := MinichargedSection.base_point

/-- Walk the full triangle: apply `T₅₉`, then `T₂`, then `T₄₇`. -/
def walkTriangle (w : TriangleWalker) : TriangleWalker :=
  stepHecke47 (stepHecke2 (stepHecke59 w))

/-- The itinerary of base points visited while walking from `startWalker`:
`V♮, 2A, 3A, V♮`. -/
def walkItinerary : List MonsterBasePoint :=
  [ startWalker.base,
    (stepHecke59 startWalker).base,
    (stepHecke2 (stepHecke59 startWalker)).base,
    (walkTriangle startWalker).base ]

/-- The base point sequence traced by the walk is exactly
`V♮ → 2A → 3A → V♮`. -/
theorem walkItinerary_eq :
    walkItinerary =
      [ MonsterBasePoint.Vnat,
        MonsterBasePoint.ConjClass "2A",
        MonsterBasePoint.ConjClass "3A",
        MonsterBasePoint.Vnat ] := rfl

/-- At every step of the walk, the carried charge data is unchanged: it stays
exactly `tableNo1Anomaly`. -/
theorem walk_charges_const :
    (stepHecke59 startWalker).charges = tableNo1Anomaly ∧
    (stepHecke2 (stepHecke59 startWalker)).charges = tableNo1Anomaly ∧
    (walkTriangle startWalker).charges = tableNo1Anomaly := ⟨rfl, rfl, rfl⟩

/-- The carried `A` multiset stays `{0,4,7,11}` at every node of the walk. -/
theorem walk_charges_A :
    startWalker.charges.A = [0, 4, 7, 11] ∧
    (stepHecke59 startWalker).charges.A = [0, 4, 7, 11] ∧
    (stepHecke2 (stepHecke59 startWalker)).charges.A = [0, 4, 7, 11] ∧
    (walkTriangle startWalker).charges.A = [0, 4, 7, 11] := ⟨rfl, rfl, rfl, rfl⟩

/-- The carried `B` multiset stays `{1,2,9,10}` at every node of the walk. -/
theorem walk_charges_B :
    startWalker.charges.B = [1, 2, 9, 10] ∧
    (stepHecke59 startWalker).charges.B = [1, 2, 9, 10] ∧
    (stepHecke2 (stepHecke59 startWalker)).charges.B = [1, 2, 9, 10] ∧
    (walkTriangle startWalker).charges.B = [1, 2, 9, 10] := ⟨rfl, rfl, rfl, rfl⟩

/-- The charges carried around the loop remain a genuine degree-3 PTE /
anomaly-free solution (here Table I No. 1) — anomaly cancellation is preserved at
every node. -/
theorem walk_isPTE :
    PTE.IsPTE (walkTriangle startWalker).charges.A
      (walkTriangle startWalker).charges.B 3 := PTE.table_no1

/-- The three edge maps compose to the identity on the carried charge data:
transporting `tableNo1Anomaly` around the full triangle returns it unchanged. -/
theorem edge_maps_preserve_charges :
    edge_Hecke_p3.map (edge_Hecke_p2.map (edge_Hecke_p1.map tableNo1Anomaly))
      = tableNo1Anomaly := rfl

/-- **The walk closes.**  Walking the full triangle returns the walker to its
exact starting state. -/
theorem walk_returns_home : walkTriangle startWalker = startWalker := rfl

/-- **Walk coherence.**  Putting it together: walking `V♮ → 2A → 3A → V♮` keeps
the carried PTE charge data fixed (`tableNo1Anomaly`), traces the base-point
itinerary `V♮, 2A, 3A, V♮`, and returns home — a closed loop in Monster space over
a fixed 4d anomaly/PTE fiber. -/
theorem walk_coherent :
    walkTriangle startWalker = startWalker ∧
    (walkTriangle startWalker).charges = tableNo1Anomaly ∧
    walkItinerary =
      [ MonsterBasePoint.Vnat,
        MonsterBasePoint.ConjClass "2A",
        MonsterBasePoint.ConjClass "3A",
        MonsterBasePoint.Vnat ] :=
  ⟨rfl, rfl, rfl⟩

end MinichargedGlue
