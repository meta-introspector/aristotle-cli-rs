import RequestProject.Nix.NixWars.Holo.Overlay

/-!
# A concrete holographic archive, and `M₁₁` as its discovered coordinate system

Eleven concepts, laid out as one static file of 99 bytes:

```
[offset 00]  PRIME_NUMBER
[offset 09]  EUCLID
[offset 18]  FUNDAMENTAL_THEOREM_OF_ARITHMETIC
[offset 27]  RING_THEORY
[offset 36]  ALGEBRAIC_NUMBER_THEORY
[offset 45]  RIEMANN_ZETA_FUNCTION
[offset 54]  RIEMANN_HYPOTHESIS
[offset 63]  MODULAR_FORM
[offset 72]  J_INVARIANT
[offset 81]  MONSTROUS_MOONSHINE
[offset 90]  MONSTER_GROUP
```

Each cell carries four items of supporting material of its own and names its
two neighbours in the chain, which closes up (`MONSTER_GROUP` back to
`PRIME_NUMBER`: the order of the Monster is a product of primes).  Everything
about the layout is checked here rather than assumed:

* `holoArchive_keys_nodup`, `holoArchive_links_closed` — one cell per concept,
  every reference resolvable;
* `holoArchive_duplication` — **zero overlap**: no fact is stored twice;
* `holoArchive_mutual`, `holoArchive_layout` — neighbours support each other,
  and cells adjacent in the file are neighbours in the concept graph, so
  `window_within_depth` applies to this archive;
* `holoArchive_bytes_length`, `holoArchive_offsets`, `holoArchive_seek_moonshine`
  and `holoArchive_fetch_moonshine` — the file is 99 bytes, the offsets are the
  ones in the table, and the range request at offset 81 returns the
  `MONSTROUS_MOONSHINE` cell and nothing else;
* `holoArchive_is_bytes` — every value written is a byte, so the archive is a
  real file.

The overlay: give concept `i` the `M₁₁` element `a¹¹ⁱ` and predict a link
exactly when two concepts differ by a generator of `M₁₁`.  Then

* `m11Model_residual_nil` — the residual is **empty**: the group explains every
  link of the archive and predicts no link that is not there;
* `m11Model_best` — among the candidate models the `M₁₁` overlay has the
  smallest description length (64 bits against 180 and 708), so on this corpus
  `M₁₁` is not imposed but *selected*;
* `holoArchive_coords` — the eleven addresses are distinct injective 4-tuples,
  each naming its group element uniquely by sharp 4-transitivity.
-/

set_option maxRecDepth 100000

namespace NixWars
namespace Holo
namespace Instance

open Archive M11

/-- The concepts of the archive, in the order they are laid out. -/
def conceptNames : List String :=
  ["PRIME_NUMBER", "EUCLID", "FUNDAMENTAL_THEOREM_OF_ARITHMETIC", "RING_THEORY",
   "ALGEBRAIC_NUMBER_THEORY", "RIEMANN_ZETA_FUNCTION", "RIEMANN_HYPOTHESIS", "MODULAR_FORM",
   "J_INVARIANT", "MONSTROUS_MOONSHINE", "MONSTER_GROUP"]

/-- The cell of concept `i`: four items of supporting material of its own, and
its two neighbours in the chain. -/
def conceptCell (i : Nat) : Cell :=
  { key := i,
    payload := [20 + 4 * i, 21 + 4 * i, 22 + 4 * i, 23 + 4 * i],
    links := [(i + 10) % 11, (i + 1) % 11] }

/-- The archive itself. -/
def holoArchive : Archive := (List.range 11).map conceptCell

/-! ## The layout -/

theorem holoArchive_length : holoArchive.length = 11 := by decide

theorem holoArchive_bytes_length : holoArchive.bytes.length = 99 := by decide

theorem holoArchive_offsets :
    (List.range 12).map holoArchive.offset = [0, 9, 18, 27, 36, 45, 54, 63, 72, 81, 90, 99] := by
  decide

/-- Every value in the file is a byte: the archive is a real static file. -/
theorem holoArchive_is_bytes : ∀ b ∈ holoArchive.bytes, b < 256 := by decide

theorem holoArchive_keys_nodup : (holoArchive.map Cell.key).Nodup := by decide

theorem holoArchive_links_closed : LinksClosed holoArchive := by decide

/-- **Zero overlap**: no item of supporting material is stored in two cells. -/
theorem holoArchive_duplication : holoArchive.duplication = 0 := by decide

/-- Hence the facts of the archive are held exactly once. -/
theorem holoArchive_facts_nodup : holoArchive.facts.Nodup :=
  (duplication_eq_zero_iff holoArchive).mp holoArchive_duplication

/-- **Neighbours are mutually supportive.** -/
theorem holoArchive_mutual : MutualSupport holoArchive :=
  mutualSupport_of_cells holoArchive_keys_nodup holoArchive_links_closed (by decide)

/-- **Cells adjacent in the file are neighbours in the concept graph.** -/
theorem holoArchive_layout : LayoutNeighbourly holoArchive :=
  layoutNeighbourly_of_check (by decide)

/-- Looking `MONSTROUS_MOONSHINE` up gives the byte range `[81, 90)`. -/
theorem holoArchive_seek_moonshine : holoArchive.seek 9 = some (81, 9) := by decide

/-- **And that range request returns exactly that cell.**  Nine bytes of a
99-byte file, decoded on their own. -/
theorem holoArchive_fetch_moonshine :
    decodeCell ((holoArchive.bytes.drop 81).take 9) = some (conceptCell 9, []) := by
  decide

/-- One request around `RIEMANN_ZETA_FUNCTION` brings back five cells, and every
one of them is within two links of it. -/
theorem holoArchive_window :
    ∀ c ∈ ((holoArchive.drop 3).take 5), c.key ∈ holoArchive.ball 5 2 :=
  window_within_depth holoArchive_layout holoArchive_mutual 3 2 (by decide) (by decide)

/-! ## The `M₁₁` overlay -/

/-- The `i`-th power of the 11-cycle. -/
def cycleElem : Nat → Perm11
  | 0 => idPerm
  | n + 1 => comp (cycleElem n) a11

/-- The `M₁₁` address of concept `i`: the coordinate of `a¹¹ⁱ`. -/
def conceptCoord (i : Nat) : List Nat := coord (cycleElem i)

/-- Every concept sits on a genuine element of the group. -/
theorem conceptElem_mem : ∀ i ∈ List.range 11, cycleElem i ∈ m11 := by native_decide

/-- The eleven addresses, all distinct injective 4-tuples of the eleven
points. -/
theorem holoArchive_coords :
    ((List.range 11).map conceptCoord).Nodup ∧
      ∀ i ∈ List.range 11, (conceptCoord i).length = 4 ∧ (conceptCoord i).Nodup ∧
        ∀ x ∈ conceptCoord i, x < 11 := by
  native_decide

/-- Each address names exactly one element of `M₁₁`. -/
theorem conceptCoord_unique (i : Nat) (hi : i ∈ List.range 11) :
    ∃! p, p ∈ m11 ∧ coord p = conceptCoord i := by
  obtain ⟨h4, hnd, hlt⟩ := holoArchive_coords.2 i hi
  exact m11_coord_unique h4 hnd hlt

/-- The generators and their inverses: the steps of the Cayley graph. -/
def cayleySteps : List Perm11 := [a11, b11, invPerm a11, invPerm b11]

/-- The overlay: two concepts are predicted to be linked when their group
elements differ by one generator. -/
def m11Pred (i j : Nat) : Bool :=
  cayleySteps.any fun g => comp (cycleElem i) g == cycleElem j

/-- The `M₁₁` model of the archive's links. -/
def m11Model : Model := { name := "M11 Cayley", pred := m11Pred, cost := 64 }

/-- A model that predicts no links at all. -/
def nullModel : Model := { name := "no links", pred := fun _ _ => false, cost := 4 }

/-- A model that predicts every link. -/
def fullModel : Model := { name := "all links", pred := fun i j => i != j, cost := 4 }

/-- The candidates. -/
def candidates : List Model := [nullModel, m11Model, fullModel]

/-- **The residual is empty**: the group structure explains every link of the
archive, and predicts no link the archive does not have. -/
theorem m11Model_residual_nil : m11Model.residual holoArchive = [] := by native_decide

/-- So the model reproduces the archive's own links on the nose. -/
theorem m11Model_exact :
    ∀ p ∈ Model.pairs holoArchive, m11Model.pred p.1 p.2 = Model.actual holoArchive p.1 p.2 :=
  (Model.residual_eq_nil_iff m11Model holoArchive).mp m11Model_residual_nil

/-- The two rival models are wrong about 22 and 88 pairs respectively. -/
theorem rival_residuals :
    (nullModel.residual holoArchive).length = 22 ∧
      (fullModel.residual holoArchive).length = 88 := by
  native_decide

/-- The description lengths, at eight bits a corrected pair. -/
theorem descriptionLengths :
    m11Model.descriptionLength holoArchive 8 = 64 ∧
      nullModel.descriptionLength holoArchive 8 = 180 ∧
        fullModel.descriptionLength holoArchive 8 = 708 := by
  native_decide

/-- **`M₁₁` is selected, not imposed**: of the candidates the minimum
description length picks out the `M₁₁` overlay. -/
theorem m11Model_best :
    (Model.bestModel candidates holoArchive 8).map Model.name = some "M11 Cayley" := by
  native_decide

/-- And no candidate is cheaper. -/
theorem m11Model_min :
    ∀ N ∈ candidates,
      m11Model.descriptionLength holoArchive 8 ≤ N.descriptionLength holoArchive 8 := by
  obtain ⟨hm, hn, hf⟩ := descriptionLengths
  intro N hN
  rcases List.mem_cons.mp hN with rfl | hN
  · omega
  rcases List.mem_cons.mp hN with rfl | hN
  · omega
  rcases List.mem_cons.mp hN with rfl | hN
  · omega
  · cases hN

end Instance
end Holo
end NixWars
