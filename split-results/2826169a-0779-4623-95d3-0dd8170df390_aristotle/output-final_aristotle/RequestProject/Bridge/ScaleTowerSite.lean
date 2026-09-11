/-
# ScaleTowerSite.lean — The Sheaf-Theoretic Edge-Restriction Site (Option B)

This file builds the sheaf-theoretic scaffolding requested as "Option B": a small
*site* over the scale-tower DAG, a *presheaf of Clifford grade-shifts* on it, and a
proof that the DAG's edge shifts function as genuine *restriction maps* of that
presheaf (i.e. they compose functorially), capped off by the fact that the presheaf
is a genuine *sheaf* for the chosen Grothendieck topology.

It builds directly on the already-verified Bott-grade verification functor of
`RequestProject.Bridge.RestoredFrontiers` (§4):

* the scale chain `8 → 10 → 170 → 194 → 196883` (`RestoredFrontiers.scaleChain`),
* its `ZMod 8` node grades (`RestoredFrontiers.nodeBottGrade`),
* its real Clifford Morita classes (`RestoredFrontiers.nodeCliffordClass`),
* and the telescoping edge shifts `[2, 0, 0, 1]`.

## What is established here

1. **The scale-tower category / site** (§1).
   The five nodes are indexed by `Fin 5`, whose `LinearOrder` supplies the canonical
   thin (poset) category: there is a morphism `i ⟶ j` precisely when `i ≤ j`, so the
   strictly-increasing chain is exactly the directed structure of the DAG. The site
   is this category equipped with the trivial (`⊥`) Grothendieck topology.

2. **The presheaf of Clifford grade-shifts** (§2).
   `gradePresheaf : (Fin 5)ᵒᵖ ⥤ SingleObj (Multiplicative (ZMod 8))` assigns to each
   inclusion `i ≤ j` the restriction map carrying the `ZMod 8` grade *down* from the
   larger node `j` to the smaller node `i`, namely `ofAdd (grade j - grade i)`.
   Functoriality of this presheaf is *exactly* the additive (telescoping) law of the
   grade, so the edge shifts are genuine restriction maps. A covariant transport
   functor `gradeTransport` records the same data along the forward DAG edges.

3. **Edge restriction maps and the terminal composite** (§3).
   The four consecutive restriction maps realize the verified edge shifts
   `[2, 0, 0, 1]`, and the composite restriction from the terminal Monster node down
   to the initial node realizes the total grade `3` — the Bott class `ℍ ⊕ ℍ`.

4. **The sheaf condition** (§4).
   `gradePresheaf` is a sheaf for the site, via `Presheaf.isSheaf_bot`.
-/

import Mathlib
import RequestProject.Bridge.RestoredFrontiers

open CategoryTheory

namespace ScaleTowerSite

-- ════════════════════════════════════════════════════════════════
-- §1. THE SCALE-TOWER CATEGORY / SITE
-- ════════════════════════════════════════════════════════════════

/-- The five scale-tower nodes indexed by `Fin 5`, carrying their chain values
    `8, 10, 170, 194, 196883`. -/
def scaleVal : Fin 5 → ℕ := ![8, 10, 170, 194, 196883]

/-- The node indexing recovers exactly the scale chain of the DAG. -/
theorem scaleVal_eq_chain : List.ofFn scaleVal = RestoredFrontiers.scaleChain := by decide

/-- The terminal node is the Monster irrep dimension `196883`. -/
theorem scaleVal_terminal : scaleVal 4 = 196883 := by decide

/-- The `ZMod 8` Bott grade carried by the node with index `i`. -/
def nodeGrade (i : Fin 5) : ZMod 8 := (scaleVal i : ZMod 8)

/-- The index-level grade agrees with the value-level grade of `RestoredFrontiers`. -/
theorem nodeGrade_eq (i : Fin 5) :
    nodeGrade i = RestoredFrontiers.nodeBottGrade (scaleVal i) := rfl

/-- The Clifford Morita class attached to the node with index `i`. -/
def nodeCliffordClass (i : Fin 5) : CliffordClass :=
  RestoredFrontiers.nodeCliffordClass (scaleVal i)

/-- The thin (poset) category structure on the nodes: a morphism `i ⟶ j` exists
    exactly when `i ≤ j`, so the category is the strictly-increasing scale DAG.
    (`Fin 5` carries the canonical preorder category from its `LinearOrder`.) -/
theorem hom_iff_le (i j : Fin 5) : Nonempty (i ⟶ j) ↔ i ≤ j :=
  ⟨fun ⟨h⟩ => leOfHom h, fun h => ⟨homOfLE h⟩⟩

/-- **The scale-tower site.** The node category equipped with the trivial
    Grothendieck topology, making it a genuine (small) site. -/
def scaleSite : GrothendieckTopology (Fin 5) := ⊥

-- ════════════════════════════════════════════════════════════════
-- §2. THE PRESHEAF OF CLIFFORD GRADE-SHIFTS
-- ════════════════════════════════════════════════════════════════

/-- **The presheaf of Clifford grade-shifts.** To each inclusion `i ≤ j` (a morphism
    `op j ⟶ op i` of the opposite category) it assigns the restriction map carrying
    the `ZMod 8` grade down from `j` to `i`, namely `ofAdd (grade j - grade i)` in the
    one-object category of `Multiplicative (ZMod 8)`. Functoriality is the additive
    telescoping law of the grade. -/
noncomputable def gradePresheaf : (Fin 5)ᵒᵖ ⥤ SingleObj (Multiplicative (ZMod 8)) where
  obj _ := SingleObj.star _
  map {X Y} _ :=
    (Multiplicative.ofAdd (nodeGrade (Opposite.unop X) - nodeGrade (Opposite.unop Y)) :
      (SingleObj.star (Multiplicative (ZMod 8))) ⟶ SingleObj.star _)
  map_id i := by
    change Multiplicative.ofAdd (nodeGrade _ - nodeGrade _) = (1 : Multiplicative (ZMod 8))
    simp
  map_comp {X Y Z} f g := by
    change Multiplicative.ofAdd (nodeGrade (Opposite.unop X) - nodeGrade (Opposite.unop Z))
        = (Multiplicative.ofAdd (nodeGrade (Opposite.unop Y) - nodeGrade (Opposite.unop Z)))
          * (Multiplicative.ofAdd (nodeGrade (Opposite.unop X) - nodeGrade (Opposite.unop Y)))
    rw [← ofAdd_add]; congr 1; ring

/-- **The covariant transport functor.** The same grade data read along the forward
    edges of the DAG: to `i ≤ j` it assigns `ofAdd (grade j - grade i)`. -/
noncomputable def gradeTransport : Fin 5 ⥤ SingleObj (Multiplicative (ZMod 8)) where
  obj _ := SingleObj.star _
  map {i j} _ :=
    (Multiplicative.ofAdd (nodeGrade j - nodeGrade i) :
      (SingleObj.star (Multiplicative (ZMod 8))) ⟶ SingleObj.star _)
  map_id i := by
    change Multiplicative.ofAdd (nodeGrade i - nodeGrade i) = (1 : Multiplicative (ZMod 8))
    simp
  map_comp {i j k} f g := by
    change Multiplicative.ofAdd (nodeGrade k - nodeGrade i)
        = (Multiplicative.ofAdd (nodeGrade k - nodeGrade j))
          * (Multiplicative.ofAdd (nodeGrade j - nodeGrade i))
    rw [← ofAdd_add]; congr 1; ring

/-- The restriction map of the presheaf attached to an inclusion `i ≤ j`. -/
noncomputable def restr {i j : Fin 5} (h : i ≤ j) :
    gradePresheaf.obj (Opposite.op j) ⟶ gradePresheaf.obj (Opposite.op i) :=
  gradePresheaf.map (Quiver.Hom.op (homOfLE h))

/-- Each restriction map is the `ofAdd` of the grade difference — the genuine grade
    shift carried from `j` down to `i`. -/
theorem restr_eq {i j : Fin 5} (h : i ≤ j) :
    restr h = Multiplicative.ofAdd (nodeGrade j - nodeGrade i) := rfl

-- ════════════════════════════════════════════════════════════════
-- §3. EDGE RESTRICTION MAPS AND THE TERMINAL COMPOSITE
-- ════════════════════════════════════════════════════════════════

/-- The four consecutive edge restriction maps realize exactly the verified edge
    shifts `[2, 0, 0, 1]` of the Bott-grade functor. -/
theorem edge_restr_shifts :
    List.ofFn (fun i : Fin 4 => nodeGrade i.succ - nodeGrade i.castSucc) = [2, 0, 0, 1] := by
  decide

/-- The list of edge shifts agrees with `RestoredFrontiers.scaleTower_edge_shifts`. -/
theorem edge_restr_shifts_eq_restored :
    List.ofFn (fun i : Fin 4 => nodeGrade i.succ - nodeGrade i.castSucc)
      = RestoredFrontiers.scaleTowerDAG.map RestoredFrontiers.edgeBottShift := by
  decide

/-- **The terminal composite restriction.** Restricting from the terminal Monster
    node (index `4`) down to the initial node (index `0`) realizes the total grade
    `3` — the Bott class transported across the whole tower. -/
theorem terminal_restr :
    restr (show (0 : Fin 5) ≤ 4 by decide) = Multiplicative.ofAdd (3 : ZMod 8) := by
  show Multiplicative.ofAdd (nodeGrade 4 - nodeGrade 0) = Multiplicative.ofAdd (3 : ZMod 8)
  decide

/-- The terminal node sits in the Clifford Morita class `ℍ ⊕ ℍ`. -/
theorem terminal_nodeCliffordClass : nodeCliffordClass 4 = CliffordClass.HplusH := by decide

-- ════════════════════════════════════════════════════════════════
-- §4. THE SHEAF CONDITION
-- ════════════════════════════════════════════════════════════════

/-- **The grade-shift presheaf is a sheaf for the scale-tower site.** -/
theorem gradePresheaf_isSheaf : Presheaf.IsSheaf scaleSite gradePresheaf :=
  Presheaf.isSheaf_bot gradePresheaf

/-- The grade-shift presheaf, bundled as an object of the category of sheaves on the
    scale-tower site. -/
noncomputable def gradeSheaf : Sheaf scaleSite (SingleObj (Multiplicative (ZMod 8))) :=
  ⟨gradePresheaf, gradePresheaf_isSheaf⟩

/-- **Edge-restriction site trace.** A single bundled statement: the node category is
    the strictly-increasing scale DAG, the presheaf restriction maps realize the
    verified edge shifts `[2, 0, 0, 1]`, the terminal composite realizes grade `3`
    (Clifford class `ℍ ⊕ ℍ`), and the presheaf is a sheaf for the site. -/
theorem scaleTower_site_trace :
    List.ofFn (fun i : Fin 4 => nodeGrade i.succ - nodeGrade i.castSucc) = [2, 0, 0, 1] ∧
    restr (show (0 : Fin 5) ≤ 4 by decide) = Multiplicative.ofAdd (3 : ZMod 8) ∧
    nodeCliffordClass 4 = CliffordClass.HplusH ∧
    Presheaf.IsSheaf scaleSite gradePresheaf :=
  ⟨edge_restr_shifts, terminal_restr, terminal_nodeCliffordClass, gradePresheaf_isSheaf⟩


end ScaleTowerSite
