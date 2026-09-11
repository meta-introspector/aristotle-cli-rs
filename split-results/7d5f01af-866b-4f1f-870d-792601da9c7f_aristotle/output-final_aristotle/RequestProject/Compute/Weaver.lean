import Mathlib

/-!
# The Unified Architectural Weaver Engine

This module collects a few self-contained, machine-checked threads into one place:

1. **Geometric bounding boxes** for the nodes of the "confluence diamond" layout, together
   with a strict coordinate-based spatial-disjointness predicate.
2. A **visual non-overlap theorem** (`branchGraph_layout_clean`) certifying that the
   14 nodes never collide, for any animation frame.
3. An **`ExtensionEngine`** abstraction (an "inexhaustible" step-wise extension process)
   and a concrete instance `attentionWalkEngine` built from a prime `P`.

## Notes on the formalization

The original design sketch imported several modules that do not exist in this repository
(`RequestProject.Compute.ScaleCategory`, `RequestProject.ExtensionEngine`,
`RequestProject.MonsterBaseWalk`, etc.); this file is therefore made **self-contained** on
top of `Mathlib`.

The original sketch also attempted to prove the layout theorem with `decide`. That cannot
work: the bounding-box coordinates are real numbers, and `<` on `ℝ` is not decidable by
kernel reduction (it gets stuck on `Classical.choice`). The theorem is instead proved by a
genuine finite case analysis over the node indices followed by `norm_num`.
-/

namespace RequestProject.Compute.Weaver

open Matrix

/-- Geometric Bounding Envelope for an SVG element within the SMIL animation frames. -/
structure BoundingBox where
  x : ℝ
  y : ℝ
  w : ℝ
  h : ℝ

/-- Strict coordinate-based spatial disjointness predicate: the two boxes are separated
    along at least one axis. -/
def DisjointBoxes (A B : BoundingBox) : Prop :=
  A.x + A.w < B.x ∨ B.x + B.w < A.x ∨
  A.y + A.h < B.y ∨ B.y + B.h < A.y

/-- A collision-free 2D bounding envelope for the 14 Confluence Diamond nodes.
    The horizontal spacing factor (`horizontalSpread = 180`) guarantees spatial isolation
    of the two prime branches; the vertical step (`80`) separates the descent layers.
    (The `frame` index is accepted for API uniformity; the layout is frame-independent.) -/
def confluenceNodeToBox (nodeId : ℕ) (_frame : ℕ) : BoundingBox :=
  let horizontalSpread : ℝ := 180.0
  let verticalStep     : ℝ := 80.0
  match nodeId with
  | 0  => ⟨400, 50, 60, 30⟩                        -- Root node (Oggorial)
  | 1  => ⟨400 - horizontalSpread, 130, 60, 30⟩    -- Prime-11 Left Branch
  | 2  => ⟨400 + horizontalSpread, 130, 60, 30⟩    -- Prime-23 Right Branch
  | 3  => ⟨400, 210, 70, 30⟩                        -- Irrep-161 Confluence Hub
  | n  => ⟨400, 210 + (sub_expr n * verticalStep), 60, 30⟩ -- Sequential Descent Layers
  where sub_expr n := (n : ℝ) - 3.0

/-- Certifies total visual separation across all 14 nodes of the confluence diamond
    for any given animation frame index. -/
def ConfluenceLayoutClean (frame : ℕ) : Prop :=
  ∀ u v : ℕ, u < 14 → v < 14 → u ≠ v →
    DisjointBoxes (confluenceNodeToBox u frame) (confluenceNodeToBox v frame)

/-- **Visual Non-Overlap Guard.**
    For every animation frame index `f < 13`, all 14 confluence-diamond nodes have pairwise
    disjoint bounding boxes, so the rendered layout has zero colliding/overlapping elements. -/
theorem branchGraph_layout_clean : ∀ f < 13, ConfluenceLayoutClean f := by
  intro f _ u v hu hv hne
  unfold DisjointBoxes confluenceNodeToBox
  interval_cases u <;> interval_cases v <;>
    norm_num [confluenceNodeToBox.sub_expr]
  all_goals contradiction

/-- The **Inexhaustible Extension Engine**: an abstract step-wise extension process over a
    type `α`. At each stage `N` it produces a "carrot" element distinct from the current
    finite approximation, that element is eventually *captured* by a later approximation, and
    the index advances strictly (so the process never stalls). -/
structure ExtensionEngine (α : Type*) where
  /-- The finite approximation available at stage `N`. -/
  finiteApprox : ℕ → α
  /-- The fresh element produced at stage `N`. -/
  carrot : ℕ → α
  /-- The index advance from stage `N`. -/
  cart : ℕ → ℕ
  /-- The fresh element is genuinely new (not the current approximation). -/
  carrot_not_in : ∀ N, carrot N ≠ finiteApprox N
  /-- Every fresh element is eventually captured by some finite approximation. -/
  captures : ∀ N, ∃ M, finiteApprox M = carrot N
  /-- The index advances strictly, so the engine is inexhaustible. -/
  strict : ∀ N, N < cart N

/-- A concrete `ExtensionEngine` over `ℕ` driven by a prime `P`: stage `N` contributes the
    fresh element `N + P` (new because `P ≥ 2`), which is captured by the `(N + P)`-th
    approximation, while the index advances by one each step. -/
def attentionWalkEngine (P : ℕ) [hP : Fact P.Prime] : ExtensionEngine ℕ where
  finiteApprox N := N
  carrot N       := N + P
  cart N         := N + 1
  carrot_not_in  := fun N => by have := hP.out.two_le; omega
  captures       := fun N => ⟨N + P, rfl⟩
  strict         := fun N => Nat.lt_succ_self N

/-!
## Row-stochastic attention transitions over the confluence nodes

We equip the 14 confluence-diamond nodes with a concrete **attention transition matrix**
`attentionMatrix : Matrix (Fin 14) (Fin 14) ℝ`. Reading row `i` as the probability
distribution of where "attention" flows from node `i`, the matrix encodes the diamond:

* the root (node `0`) splits its attention evenly between the two prime branches
  (`1` and `2`), each receiving weight `1/2`;
* the two branches (`1`, `2`) reconverge on the hub (node `3`);
* the descent column (`3 ≤ i ≤ 12`) flows one step downward, `i ↦ i + 1`;
* the final node (`13`) is absorbing.

We then prove the two **stochastic conservation laws**: every entry is nonnegative and every
row sums to `1` (`attentionMatrix_rowSum`). Together these say the matrix is *row-stochastic*.
-/

/-- A real square matrix is **row-stochastic** when all entries are nonnegative and every
    row sums to `1`. -/
def IsRowStochastic {n : ℕ} (M : Matrix (Fin n) (Fin n) ℝ) : Prop :=
  (∀ i j, 0 ≤ M i j) ∧ ∀ i, ∑ j, M i j = 1

/-- The concrete attention transition matrix for the 14 confluence-diamond nodes. Row `i`
    is the distribution of attention leaving node `i` (see the module note above). -/
noncomputable def attentionMatrix : Matrix (Fin 14) (Fin 14) ℝ := fun i j =>
  if i = 0 then (if j = 1 then 1 / 2 else if j = 2 then 1 / 2 else 0)
  else if i = 1 then (if j = 3 then 1 else 0)
  else if i = 2 then (if j = 3 then 1 else 0)
  else if i = 13 then (if j = 13 then 1 else 0)
  else (if j = i + 1 then 1 else 0)

/-- Every attention weight is nonnegative. -/
lemma attentionMatrix_nonneg : ∀ i j, 0 ≤ attentionMatrix i j := by
  intro i j; unfold attentionMatrix; split_ifs <;> norm_num

/-- **Stochastic conservation law.** Every row of the attention matrix sums to `1`, i.e. the
    total outgoing attention from each node is conserved. -/
lemma attentionMatrix_rowSum : ∀ i, ∑ j, attentionMatrix i j = 1 := by
  intro i
  fin_cases i <;> simp +decide [Fin.sum_univ_succ, attentionMatrix]
  norm_num

/-- The attention transition matrix is row-stochastic. -/
theorem attentionMatrix_isRowStochastic : IsRowStochastic attentionMatrix :=
  ⟨attentionMatrix_nonneg, attentionMatrix_rowSum⟩

/-!
## Iterated path evaluation and convergence

We now study *multi-step* attention transitions, i.e. the matrix powers `attentionMatrix ^ t`
(equivalently, the evolution of a distribution vector `vₜ₊₁ = vₜ ᵥ* attentionMatrix`).

The key structural facts are:

* **Closure of row-stochasticity.** The identity matrix is row-stochastic, the product of two
  row-stochastic matrices is row-stochastic, and hence every power of a row-stochastic matrix
  is row-stochastic. In particular every `attentionMatrix ^ t` is a genuine transition matrix.
* **Conservation along the walk.** A *stochastic vector* (nonnegative, entries summing to `1`)
  stays stochastic after one transition step, hence after arbitrarily many steps.
* **Absorption / stationarity.** Node `13` is absorbing: the point distribution `Pi.single 13 1`
  is a stationary distribution, fixed by `attentionMatrix` and therefore by every power.
* **Global convergence.** After `12` steps every starting node has its entire mass at node `13`:
  `(attentionMatrix ^ 12) i 13 = 1` for all `i`. (Twelve is sharp: node `0` needs all 12 steps.)
-/

/-- The identity matrix is row-stochastic. -/
lemma isRowStochastic_one {n : ℕ} : IsRowStochastic (1 : Matrix (Fin n) (Fin n) ℝ) := by
  constructor <;> intro i <;> simp +decide [Matrix.one_apply]
  exact fun j => by split_ifs <;> norm_num

/-- Row-stochasticity is preserved by matrix multiplication. -/
lemma IsRowStochastic.mul {n : ℕ} {A B : Matrix (Fin n) (Fin n) ℝ}
    (hA : IsRowStochastic A) (hB : IsRowStochastic B) : IsRowStochastic (A * B) := by
  constructor
  · exact fun i j => by
      rw [Matrix.mul_apply]; exact Finset.sum_nonneg fun k _ => mul_nonneg (hA.1 i k) (hB.1 k j)
  · simp_all +decide [Matrix.mul_apply, IsRowStochastic]
    exact fun i => by rw [Finset.sum_comm]; simp +decide [← Finset.mul_sum _ _ _, hA.2, hB.2]

/-- Row-stochasticity is preserved by taking powers. -/
lemma IsRowStochastic.pow {n : ℕ} {A : Matrix (Fin n) (Fin n) ℝ}
    (hA : IsRowStochastic A) (k : ℕ) : IsRowStochastic (A ^ k) := by
  induction' k with k ih
  · convert isRowStochastic_one
  · simpa only [pow_succ] using IsRowStochastic.mul ih hA

/-- Every multi-step attention transition matrix is row-stochastic. -/
theorem attentionMatrix_pow_isRowStochastic (k : ℕ) :
    IsRowStochastic (attentionMatrix ^ k) :=
  attentionMatrix_isRowStochastic.pow k

/-- A **stochastic vector**: a probability distribution over the states (nonnegative entries
    summing to `1`). -/
def IsStochasticVector {n : ℕ} (v : Fin n → ℝ) : Prop :=
  (∀ i, 0 ≤ v i) ∧ ∑ i, v i = 1

/-- One transition step by a row-stochastic matrix sends a stochastic vector to a stochastic
    vector: the total probability mass is conserved along the walk. -/
lemma IsStochasticVector.vecMul {n : ℕ} {v : Fin n → ℝ} {M : Matrix (Fin n) (Fin n) ℝ}
    (hv : IsStochasticVector v) (hM : IsRowStochastic M) : IsStochasticVector (v ᵥ* M) := by
  constructor
  · intro i
    rw [Matrix.vecMul, dotProduct]
    exact Finset.sum_nonneg fun j _ => mul_nonneg (hv.1 j) (hM.1 j i)
  · simp_all +decide [Matrix.vecMul, dotProduct]
    rw [Finset.sum_comm]
    simp +decide [← Finset.mul_sum _ _ _, hM.2, hv.2]

/-- The point distribution at node `13` is stationary for one attention step: node `13`
    is absorbing. -/
theorem attentionMatrix_absorbing :
    (Pi.single (13 : Fin 14) (1 : ℝ)) ᵥ* attentionMatrix = Pi.single 13 1 := by
  ext j
  fin_cases j <;> simp +decide [Matrix.vecMul, dotProduct]
  all_goals simp +decide [Fin.sum_univ_succ, attentionMatrix]

/-- The point distribution at node `13` is fixed by every multi-step transition: the walk,
    once at node `13`, stays there forever. -/
theorem attentionMatrix_pow_absorbing (k : ℕ) :
    (Pi.single (13 : Fin 14) (1 : ℝ)) ᵥ* attentionMatrix ^ k = Pi.single 13 1 := by
  induction' k with k ih
  · exact Matrix.vecMul_one _
  · rw [pow_succ', ← Matrix.vecMul_vecMul, attentionMatrix_absorbing, ih]

/-- **Global convergence to the absorbing node.** After `12` transition steps, every starting
    node has all of its probability mass concentrated at node `13`. (The exponent `12` is
    sharp: node `0` needs the full twelve steps `0 → {1,2} → 3 → 4 → ⋯ → 13`.) -/
theorem attentionMatrix_converges (i : Fin 14) : (attentionMatrix ^ 12) i 13 = 1 := by
  unfold attentionMatrix
  simp +decide [Fin.sum_univ_succ, Matrix.mul_apply, pow_succ] at *
  fin_cases i <;> simp +decide at *
  all_goals norm_num at *

/-!
## A bridge into Mathlib's fibred-categories framework

The final thread weaves the project's *scale tower* picture into Mathlib's formal theory of
fibred categories (`CategoryTheory.Functor.IsFibered`, Grothendieck/SGA 1 VI.6.1).

The organising idea is the **product (scale) fibration**: over a base category `𝒮` (the
"scale levels"), the total category `𝒞 × 𝒮` of *fibre-decorated scales* projects to the base
via `CategoryTheory.Prod.snd 𝒞 𝒮 : 𝒞 × 𝒮 ⥤ 𝒮`. We show:

* **`scaleProjection_isStronglyCartesian`** — for every fibre object `c` and base morphism
  `f : R ⟶ S`, the arrow `(𝟙 c, f) : (c, R) ⟶ (c, S)` is a *strongly Cartesian* lift of `f`.
  This is the cartesian-lift data underlying the fibration.
* **`scaleProjection_isFibered`** — consequently `CategoryTheory.Prod.snd 𝒞 𝒮` is a genuine
  fibered category (this product fibration is not in Mathlib).
* **`scaleTowerBased`** — packages the projection as a `BasedCategory 𝒮`, i.e. an object of
  Mathlib's based/fibred-category bicategory.
* **`scaleBridgeFunctor`** — the **bridge functor**: a `BasedFunctor` from the base `𝒮`
  (viewed over itself via `𝟭 𝒮`) into the scale tower, given by the constant-fibre section
  `S ↦ (c₀, S)`. By construction it commutes with the projections, exhibiting `𝒮` as a
  section of the fibration.

Finally we instantiate the construction on the project's own data: the base `ℕ` of scale
levels and the discrete category of the 14 confluence-diamond nodes as the fibre.
-/

section Fibred

open CategoryTheory CategoryTheory.Functor

universe v₁ v₂ u₁ u₂

variable {𝒞 : Type u₂} [Category.{v₂} 𝒞] {𝒮 : Type u₁} [Category.{v₁} 𝒮]

/-- For a fibre object `c` and a base morphism `f : R ⟶ S`, the arrow `(𝟙 c, f)` is a strongly
Cartesian lift of `f` along the projection `𝒞 × 𝒮 ⥤ 𝒮`. The induced map out of any competing
lift `φ'` (lying over `g ≫ f`) is `(φ'.1, g)`, and it is the unique such lift over `g`. -/
lemma scaleProjection_isStronglyCartesian {R S : 𝒮} (c : 𝒞) (f : R ⟶ S) :
    (CategoryTheory.Prod.snd 𝒞 𝒮).IsStronglyCartesian f ((𝟙 c, f) : (c, R) ⟶ (c, S)) where
  toIsHomLift := by
    simpa using IsHomLift.map (CategoryTheory.Prod.snd 𝒞 𝒮) ((𝟙 c, f) : (c, R) ⟶ (c, S))
  universal_property' {a'} g φ' hφ' := by
    refine ⟨(φ'.1, g), ⟨?_, ?_⟩, ?_⟩
    · simpa using IsHomLift.map (CategoryTheory.Prod.snd 𝒞 𝒮) ((φ'.1, g) : a' ⟶ (c, R))
    · have hg : φ'.2 = g ≫ f := by
        simpa using IsHomLift.fac' (CategoryTheory.Prod.snd 𝒞 𝒮) (g ≫ f) φ'
      exact Prod.hom_ext (by simp) (by simp [hg])
    · rintro χ ⟨hχ, hχ2⟩
      have hχg : χ.2 = g := by
        simpa using IsHomLift.fac' (CategoryTheory.Prod.snd 𝒞 𝒮) g χ
      exact Prod.hom_ext (by simpa using congrArg Prod.fst hχ2) (by simpa using hχg)

/-- **The product (scale) fibration is fibered.** The projection `𝒞 × 𝒮 ⥤ 𝒮` forgetting the
fibre coordinate is a fibered category in the sense of SGA 1 VI.6.1. -/
instance scaleProjection_isFibered : (CategoryTheory.Prod.snd 𝒞 𝒮).IsFibered :=
  IsFibered.of_exists_isStronglyCartesian fun a R f =>
    ⟨(a.1, R), (𝟙 a.1, f), scaleProjection_isStronglyCartesian a.1 f⟩

/-- The scale tower packaged as an object of Mathlib's bicategory of based categories over
`𝒮`: the total category `𝒞 × 𝒮` together with the (fibered) projection to the base. -/
def scaleTowerBased (𝒞 : Type u₂) [Category.{v₂} 𝒞] (𝒮 : Type u₁) [Category.{v₁} 𝒮] :
    BasedCategory 𝒮 :=
  BasedCategory.ofFunctor (CategoryTheory.Prod.snd 𝒞 𝒮)

/-- **The bridge functor.** A based functor from the base category `𝒮` (regarded as a based
category over itself via `𝟭 𝒮`) into the scale tower, given by the constant-fibre section
`S ↦ (c₀, S)`. Its `w` field records that the section is genuinely a section of the
fibration (it commutes with the projections to `𝒮`). -/
def scaleBridgeFunctor (𝒞 : Type u₂) [Category.{v₂} 𝒞] (𝒮 : Type u₁) [Category.{v₁} 𝒮]
    (c₀ : 𝒞) : (BasedCategory.ofFunctor (𝟭 𝒮)) ⥤ᵇ (scaleTowerBased 𝒞 𝒮) where
  toFunctor := CategoryTheory.Prod.sectR c₀ 𝒮
  w := rfl

/-- The bridge functor is a section of the scale fibration: post-composing with the
projection recovers the identity functor on the base. -/
lemma scaleBridgeFunctor_isSection (c₀ : 𝒞) :
    (scaleBridgeFunctor 𝒞 𝒮 c₀).toFunctor ⋙ CategoryTheory.Prod.snd 𝒞 𝒮 = 𝟭 𝒮 :=
  (scaleBridgeFunctor 𝒞 𝒮 c₀).w

/-!
### Concrete instantiation on the confluence diamond

We instantiate the bridge on the project's own data: the base `ℕ` of *scale levels*
(the index advanced by `attentionWalkEngine`/`ExtensionEngine`) and the discrete category of
the 14 confluence-diamond nodes as the fibre. The root node `0` ("Oggorial") provides the
canonical constant-fibre section.
-/

/-- The fibre of the confluence diamond: its 14 nodes as a discrete category. -/
abbrev ConfluenceFiber : Type := Discrete (Fin 14)

/-- The confluence scale tower: the 14 confluence nodes fibred over the `ℕ`-tower of scale
levels, as a based (in fact fibered) category over `ℕ`. -/
def confluenceScaleTower : BasedCategory ℕ := scaleTowerBased ConfluenceFiber ℕ

/-- The confluence scale tower is a fibered category over the scale base `ℕ`. -/
lemma confluenceScaleTower_isFibered :
    (CategoryTheory.Prod.snd ConfluenceFiber ℕ).IsFibered := scaleProjection_isFibered

/-- The concrete bridge functor for the confluence diamond, sectioning the scale base `ℕ`
into the tower at the root node `0`. -/
def confluenceBridge : (BasedCategory.ofFunctor (𝟭 ℕ)) ⥤ᵇ confluenceScaleTower :=
  scaleBridgeFunctor ConfluenceFiber ℕ ⟨0⟩

end Fibred

end RequestProject.Compute.Weaver