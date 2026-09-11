/-
# Context Windows as Typed Backpacks

Each task/thread carries a "backpack" — a context window of configurable
size and shape. The shape determines what kinds of information fit
(CRT coordinates, Bott class, resource claims, proof state, etc.),
while the size bounds how much can be carried simultaneously.

## Design

A context window is a dependent record indexed by:
  • `capacity : ℕ` — maximum number of items
  • `Shape` — a type describing the "slots" available

The backpack functor is comonadic: you can always `extract` the current
focus, and `extend` a contextual computation across all positions.
This mirrors the Store comonad in nix/comonad.nix.

## Integration

- **Paxos**: each proposal carries a context window of resource claims;
  the capacity bounds the plan phase.
- **Speculation**: speculative claims are window items with a stake field;
  the shape includes a `SpecSlot` variant.
- **CRT torus**: the window position is a `ResTriple` on the Monster torus;
  navigation shifts the window's focus without changing its contents.
-/

import Mathlib
import RequestProject.Compute.Cosmic.Bootstrap
import RequestProject.Agent.Consensus

set_option maxHeartbeats 400000

open Finset



/-! ## §1. Window Shape — What Kinds of Data Fit -/

/-- The shape of a context window slot.
    Each variant describes a different kind of information that can
    be packed into the backpack. -/
inductive SlotKind where
  | crt       : SlotKind   -- CRT residue triple
  | bott      : SlotKind   -- Bott/Clifford class (Fin 8)
  | resource  : SlotKind   -- resource claim (amount + stake)
  | proof     : SlotKind   -- proof state snapshot
  | trace     : SlotKind   -- syntactic trace step
  | agent     : SlotKind   -- agent identifier
  deriving DecidableEq, Repr

/-- A window shape is a multiset of slot kinds, describing what the
    backpack can hold. Different shapes support different tasks. -/
structure WindowShape where
  slots : List SlotKind
  deriving Repr

/-- The capacity of a shape is the number of slots. -/
def WindowShape.capacity (s : WindowShape) : ℕ := s.slots.length

/-- A narrow window: just CRT + Bott. Minimal context for navigation. -/
def WindowShape.narrow : WindowShape :=
  ⟨[.crt, .bott]⟩

/-- A standard window: CRT + Bott + resource + agent. -/
def WindowShape.standard : WindowShape :=
  ⟨[.crt, .bott, .resource, .agent]⟩

/-- A wide window: full context for consensus rounds. -/
def WindowShape.wide : WindowShape :=
  ⟨[.crt, .bott, .resource, .resource, .agent, .proof, .trace]⟩

/-! ## §2. Context Window — The Backpack -/

/-- A single item in the backpack, tagged by its slot kind. -/
structure BackpackItem where
  kind  : SlotKind
  value : ℕ          -- encoded value (everything is Gödel-encoded)
  deriving Repr

/-- A context window (backpack) with bounded capacity.
    Items are a list of `BackpackItem`s, length-bounded by the shape. -/
structure ContextWindow where
  shape    : WindowShape
  items    : List BackpackItem
  focus    : ℕ                   -- index of the current focus item
  position : ℕ                   -- CRT address on the Monster torus (mod 196883)
  deriving Repr

/-- A well-formed context window: items fit within the shape's capacity,
    and the focus index is valid. -/
def ContextWindow.wellFormed (w : ContextWindow) : Prop :=
  w.items.length ≤ w.shape.capacity ∧
  (w.items.length > 0 → w.focus < w.items.length) ∧
  w.position < 196883

/-- Create an empty context window at a given position. -/
def ContextWindow.empty (shape : WindowShape) (pos : ℕ) : ContextWindow :=
  { shape := shape, items := [], focus := 0, position := pos % 196883 }

/-- Pack an item into the backpack (if capacity allows). -/
def ContextWindow.pack (w : ContextWindow) (item : BackpackItem) : ContextWindow :=
  if w.items.length < w.shape.capacity then
    { w with items := w.items ++ [item] }
  else w  -- silently drop if full

/-- Extract the focused item (comonadic extract). -/
def ContextWindow.extract (w : ContextWindow) : Option BackpackItem :=
  w.items[w.focus]?

/-- Shift focus to a different item. -/
def ContextWindow.shift (w : ContextWindow) (newFocus : ℕ) : ContextWindow :=
  { w with focus := newFocus % (max w.items.length 1) }

/-- Navigate: change the torus position without altering contents. -/
def ContextWindow.navigate (w : ContextWindow) (newPos : ℕ) : ContextWindow :=
  { w with position := newPos % 196883 }

/-! ## §3. Backpack Functor — Comonadic Structure -/

/-- Map a function over all items in the backpack. -/
def ContextWindow.map (f : BackpackItem → BackpackItem) (w : ContextWindow) : ContextWindow :=
  { w with items := w.items.map f }

/-- Extend: apply a contextual computation at every position.
    Given `f : ContextWindow → BackpackItem`, produce a new window where
    each slot contains the result of `f` focused on that slot. -/
def ContextWindow.extend (f : ContextWindow → BackpackItem)
    (w : ContextWindow) : ContextWindow :=
  let newItems := List.ofFn (fun (i : Fin w.items.length) =>
    f { w with focus := i.val })
  { w with items := newItems }

/-- Duplicate: each slot becomes a window focused on that slot. -/
-- (Type-erased version: we store the focus index as encoded value.)
def ContextWindow.duplicate (w : ContextWindow) : ContextWindow :=
  let newItems := List.ofFn (fun (i : Fin w.items.length) =>
    { kind := SlotKind.trace, value := i.val : BackpackItem })
  { w with items := newItems }

/-! ## §4. Resource Claims in Context Windows -/

/-- A resource claim packed into a backpack item. -/
def packResourceClaim (amount stake : ℕ) : BackpackItem :=
  { kind := .resource, value := amount * 196883 + stake }

/-- Unpack a resource claim. -/
def unpackResourceClaim (item : BackpackItem) : ℕ × ℕ :=
  (item.value / 196883, item.value % 196883)

/-- A speculative claim: resource + stake + epoch, CRT-addressed. -/
structure SpeculativeClaim where
  agent      : ℕ      -- agent encoding
  resourceId : ℕ
  amount     : ℕ
  stake      : ℕ
  epoch      : ℕ
  deriving Repr

/-- Pack a speculative claim into the backpack. -/
def SpeculativeClaim.toItem (c : SpeculativeClaim) : BackpackItem :=
  { kind := .resource, value := c.amount * 1000 + c.stake }

/-- Create a proposal window: a context window pre-loaded with claims. -/
def proposalWindow (claims : List SpeculativeClaim) (pos : ℕ) : ContextWindow :=
  let shape : WindowShape := ⟨claims.map (fun _ => SlotKind.resource)⟩
  let items := claims.map SpeculativeClaim.toItem
  { shape := shape, items := items, focus := 0, position := pos % 196883 }

/-! ## §5. Window Size Classes -/

/-- Size class taxonomy for context windows. -/
inductive SizeClass where
  | micro  : SizeClass   -- 1-2 slots (single navigation)
  | small  : SizeClass   -- 3-4 slots (standard task)
  | medium : SizeClass   -- 5-8 slots (consensus round)
  | large  : SizeClass   -- 9-16 slots (full boardroom)
  | jumbo  : SizeClass   -- 17+ slots (bulk operations)
  deriving DecidableEq, Repr

/-- Classify a window by its capacity. -/
def classifyWindow (w : ContextWindow) : SizeClass :=
  let cap := w.shape.capacity
  if cap ≤ 2 then .micro
  else if cap ≤ 4 then .small
  else if cap ≤ 8 then .medium
  else if cap ≤ 16 then .large
  else .jumbo

/-! ## §6. Theorems -/

/-- An empty window is well-formed. -/
theorem empty_wellFormed (shape : WindowShape) (pos : ℕ) :
    (ContextWindow.empty shape pos).wellFormed := by
  unfold ContextWindow.empty ContextWindow.wellFormed
  simp [List.length]
  omega

/-- Packing into a non-full window increases length by 1. -/
theorem pack_length (w : ContextWindow) (item : BackpackItem)
    (h : w.items.length < w.shape.capacity) :
    (w.pack item).items.length = w.items.length + 1 := by
  unfold ContextWindow.pack
  simp [h, List.length_append]

/-- Navigation preserves items. -/
theorem navigate_preserves_items (w : ContextWindow) (pos : ℕ) :
    (w.navigate pos).items = w.items := by
  unfold ContextWindow.navigate
  rfl

/-- Navigation preserves shape. -/
theorem navigate_preserves_shape (w : ContextWindow) (pos : ℕ) :
    (w.navigate pos).shape = w.shape := by
  unfold ContextWindow.navigate
  rfl

/-- The position after navigation is in range. -/
theorem navigate_position_bounded (w : ContextWindow) (pos : ℕ) :
    (w.navigate pos).position < 196883 := by
  unfold ContextWindow.navigate
  simp
  omega

/-- A proposal window has as many items as claims. -/
theorem proposalWindow_length (claims : List SpeculativeClaim) (pos : ℕ) :
    (proposalWindow claims pos).items.length = claims.length := by
  unfold proposalWindow
  simp [List.length_map]

/-- Quorum intersection ensures no conflicting context windows
    can be committed simultaneously (links to Consensus.lean). -/
theorem context_quorum_safety (n : ℕ) (Q₁ Q₂ : Finset (Fin n))
    (h₁ : IsQuorum n Q₁) (h₂ : IsQuorum n Q₂) :
    (Q₁ ∩ Q₂).Nonempty :=
  quorum_intersection n Q₁ Q₂ h₁ h₂



/-! ## ════════════════════════════════════════════════════════
   Merged from ContextWindowAlgebra.lean (semantic dedup: same prime invariant — context window functor)
   ════════════════════════════════════════════════════════ -/

/-
# Context Windows as Functorial Backpacks — Algebraic Formalization

Each task/thread carries a **context-window object**
  C_τ : Task → Backpack
whose shape, capacity, and semantic curvature depend on the task's
resource profile (memory, CPU, network, disk), and whose contents are
selected by a context-selection functor extracting only the relevant
semantic fibers.

## Structures

- **ResourceSig** — the tuple (M, C, N, D) for memory/CPU/network/disk
- **SemanticGeometry** — the shape class induced by a task type
- **ContextFunctor** — the functorial assignment Task ⟶ Backpack
- **VoxelSpace** — voxelized thought coordinates
- **MonsterSlice** — q-expansion strata of the Monster lattice
- **TileProduct** — Monster-slice × Tile tensor product

## Theorems

- Resource-to-shape functor is well-defined
- Context merging is associative and unital
- Voxel space has finite measure
- Monster-slice tensor is compatible with window structure
-/


set_option maxHeartbeats 800000

open Finset

/-! ## §1. Resource Signature — The (M, C, N, D) Tuple -/

/-- A resource signature encodes a thread's available resources.
    Each component is a natural number representing a quantized level. -/
structure ResourceSig where
  mem  : ℕ   -- memory (RAM budget, in units)
  cpu  : ℕ   -- compute (CPU cycles budget)
  net  : ℕ   -- network (bandwidth budget)
  disk : ℕ   -- storage (persistent disk budget)
  deriving DecidableEq, Repr

/-- Total resource budget: the sum of all resource dimensions. -/
def ResourceSig.total (r : ResourceSig) : ℕ :=
  r.mem + r.cpu + r.net + r.disk

/-- Resource dominance: one signature dominates another componentwise. -/
def ResourceSig.dominates (r s : ResourceSig) : Prop :=
  s.mem ≤ r.mem ∧ s.cpu ≤ r.cpu ∧ s.net ≤ r.net ∧ s.disk ≤ r.disk

instance : LE ResourceSig where
  le r s := ResourceSig.dominates s r

/-- Resource signature addition (parallel composition of budgets). -/
def ResourceSig.add (r s : ResourceSig) : ResourceSig :=
  ⟨r.mem + s.mem, r.cpu + s.cpu, r.net + s.net, r.disk + s.disk⟩

instance : Add ResourceSig where
  add := ResourceSig.add

/-- The zero resource signature. -/
def ResourceSig.zero : ResourceSig := ⟨0, 0, 0, 0⟩

instance : Zero ResourceSig where
  zero := ResourceSig.zero

/-! ## §2. Semantic Geometry — Task-Induced Window Shapes -/

/-- The semantic geometry of a task determines the *shape* of its
    context window. Different task types need fundamentally different
    information layouts. -/
inductive SemanticGeometry where
  | chain      : SemanticGeometry   -- sequential reasoning: long thin window
  | grid       : SemanticGeometry   -- spatial reasoning: 2D/3D voxel window
  | tree       : SemanticGeometry   -- symbolic manipulation: tree-shaped
  | hypergraph : SemanticGeometry   -- multi-agent negotiation: hypergraph
  | compressed : SemanticGeometry   -- resource-constrained: low-entropy
  deriving DecidableEq, Repr

/-- Each geometry has a characteristic dimension count. -/
def SemanticGeometry.dimensions : SemanticGeometry → ℕ
  | .chain      => 1
  | .grid       => 3
  | .tree       => 2   -- depth + branching
  | .hypergraph => 4   -- agent × topic × time × rank
  | .compressed => 1

/-- A task descriptor: what a thread is trying to accomplish. -/
structure TaskDescriptor where
  taskId    : ℕ
  geometry  : SemanticGeometry
  priority  : ℕ
  resources : ResourceSig
  deriving Repr

/-! ## §3. The Resource-to-Shape Functor Φ -/

/-- The resource-to-shape functor: given a resource signature,
    determine the appropriate window shape.

    High memory → wide window (many slots)
    Low CPU → shallow window (few processing slots)
    High network → porous window (external fiber slots)
    High disk → persistent window (trace slots) -/
def shapeFromResources (r : ResourceSig) : WindowShape :=
  let baseSlots := [SlotKind.crt, SlotKind.bott]
  let memSlots := List.replicate (min r.mem 4) SlotKind.resource
  let netSlots := List.replicate (min r.net 2) SlotKind.agent
  let diskSlots := List.replicate (min r.disk 3) SlotKind.trace
  let proofSlots := if r.cpu > 2 then [SlotKind.proof] else []
  ⟨baseSlots ++ memSlots ++ netSlots ++ diskSlots ++ proofSlots⟩

/-- The full task-to-shape functor: combines geometry and resources. -/
def taskShape (t : TaskDescriptor) : WindowShape :=
  let base := shapeFromResources t.resources
  match t.geometry with
  | .chain      => base
  | .grid       => ⟨base.slots ++ [.crt, .crt, .crt]⟩
  | .tree       => ⟨base.slots ++ [.proof, .proof]⟩
  | .hypergraph => ⟨base.slots ++ [.agent, .agent, .agent]⟩
  | .compressed => ⟨base.slots.take (min 4 base.slots.length)⟩

/-! ## §4. Thread Identity and Context Selection -/

/-- A thread is an agent-local execution context with a task and
    an identity on the Monster torus. -/
structure ThreadId where
  agentId  : ℕ
  threadNo : ℕ
  torusPos : ℕ
  task     : TaskDescriptor
  deriving Repr

/-- The context-selection functor: given a thread, construct its
    context window (the "backpack").
    C(τ) = ∫ F_τ(x) dx   (relevance-weighted selection) -/
def contextSelect (τ : ThreadId) : ContextWindow :=
  let shape := taskShape τ.task
  { shape    := shape
    items    := []
    focus    := 0
    position := τ.torusPos % 196883 }

/-- The context functor assigns each thread a well-formed empty window. -/
theorem contextSelect_wellFormed (τ : ThreadId) :
    (contextSelect τ).wellFormed := by
  simp only [contextSelect, ContextWindow.wellFormed]
  refine ⟨?_, ?_, ?_⟩
  · simp [List.length]
  · simp [List.length]
  · omega

/-! ## §5. Context Merging — Multi-Agent Window Algebra -/

/-- Merge two context windows (e.g. when agents share information).
    The merged window has the union of shapes and concatenated items,
    focused at position 0, at the first window's torus position. -/
def ContextWindow.merge (w₁ w₂ : ContextWindow) : ContextWindow :=
  { shape    := ⟨w₁.shape.slots ++ w₂.shape.slots⟩
    items    := w₁.items ++ w₂.items
    focus    := 0
    position := w₁.position }

/-- Merge is associative on items. -/
theorem merge_items_assoc (a b c : ContextWindow) :
    ((a.merge b).merge c).items = (a.merge (b.merge c)).items := by
  simp [ContextWindow.merge, List.append_assoc]

/-- Merge is associative on shapes. -/
theorem merge_shape_assoc (a b c : ContextWindow) :
    ((a.merge b).merge c).shape.slots = (a.merge (b.merge c)).shape.slots := by
  simp [ContextWindow.merge, List.append_assoc]

/-- Merging with an empty window on the right preserves items. -/
theorem merge_empty_right (w : ContextWindow) (s : WindowShape) (p : ℕ) :
    (w.merge (ContextWindow.empty s p)).items = w.items := by
  simp [ContextWindow.merge, ContextWindow.empty, List.append_nil]

/-- Merging preserves total item count. -/
theorem merge_item_count (w₁ w₂ : ContextWindow) :
    (w₁.merge w₂).items.length = w₁.items.length + w₂.items.length := by
  simp [ContextWindow.merge, List.length_append]

/-! ## §6. Voxelized Thought Space -/

/-- A voxel coordinate in a d-dimensional semantic space.
    Each thought occupies a cell in a shaped semantic region. -/
structure Voxel (d : ℕ) where
  coords : Fin d → ℕ

/-- The volume of a voxel region: product of extents along each axis. -/
def voxelVolume (d : ℕ) (extents : Fin d → ℕ) : ℕ :=
  Finset.prod Finset.univ extents

/-- A voxelized thought space: a bounded d-dimensional grid. -/
structure VoxelSpace (d : ℕ) where
  extents : Fin d → ℕ

/-- The number of cells in a voxel space. -/
def VoxelSpace.cellCount {d : ℕ} (v : VoxelSpace d) : ℕ :=
  voxelVolume d v.extents

/-- A voxel is in-bounds if each coordinate is less than the extent. -/
def VoxelSpace.inBounds {d : ℕ} (v : VoxelSpace d) (x : Voxel d) : Prop :=
  ∀ i : Fin d, x.coords i < v.extents i

/-- A semantic geometry induces a voxel space with uniform scale. -/
def semanticVoxelSpace (g : SemanticGeometry) (scale : ℕ) : VoxelSpace g.dimensions :=
  ⟨fun _ => scale⟩

/-- The cell count of a uniform voxel space is scale^d. -/
theorem uniform_voxel_count (g : SemanticGeometry) (scale : ℕ) :
    (semanticVoxelSpace g scale).cellCount = scale ^ g.dimensions := by
  unfold semanticVoxelSpace VoxelSpace.cellCount voxelVolume
  simp [Finset.prod_const]

/-! ## §7. Monster-Slice Context Schema -/

/-- A Monster slice at q-expansion level k.
    Represents the k-th stratum of the Monster lattice,
    indexed by a residue mod 196883 (the Monster's smallest
    faithful representation dimension). -/
structure MonsterSlice where
  level   : ℕ
  residue : ℕ
  h_bound : residue < 196883

/-- A tile: an agent-local piece of the semantic lattice. -/
structure Tile where
  agentId  : ℕ
  tileData : List ℕ

/-- The Monster-slice × Tile tensor product.
    C_τ = Slice_{q_k}(M) ⊗ Tile_τ

    This is the fundamental context object: a Monster-lattice
    stratum tensored with the agent's local tile. -/
structure SliceTileProduct where
  slice : MonsterSlice
  tile  : Tile

/-- Convert a SliceTileProduct to a ContextWindow.
    The window shape is determined by the tile data length
    plus standard Monster navigation slots. -/
def SliceTileProduct.toContextWindow (st : SliceTileProduct) : ContextWindow :=
  let monsterSlots := [SlotKind.crt, SlotKind.bott]
  let tileSlots := st.tile.tileData.map (fun _ => SlotKind.resource)
  let shape : WindowShape := ⟨monsterSlots ++ tileSlots⟩
  let monsterItems : List BackpackItem :=
    [ ⟨.crt, st.slice.residue⟩, ⟨.bott, st.slice.level % 8⟩ ]
  let tileItems := st.tile.tileData.map (fun v => (⟨.resource, v⟩ : BackpackItem))
  { shape    := shape
    items    := monsterItems ++ tileItems
    focus    := 0
    position := st.slice.residue }

/-- A SliceTileProduct produces a well-formed context window. -/
theorem sliceTile_wellFormed (st : SliceTileProduct) :
    (st.toContextWindow).wellFormed := by
  simp only [SliceTileProduct.toContextWindow, ContextWindow.wellFormed]
  simp [WindowShape.capacity, List.length_append, List.length_map,
        List.length_cons]
  exact st.slice.h_bound

/-! ## §8. Context-Window Algebra -/

/-- A context algebra bundles windows with merge and identity,
    forming a monoid on items. -/
structure ContextAlgebra where
  identity : ContextWindow
  merge    : ContextWindow → ContextWindow → ContextWindow
  assoc    : ∀ a b c, (merge (merge a b) c).items = (merge a (merge b c)).items
  right_id : ∀ w, (merge w identity).items = w.items

/-- The standard context algebra using ContextWindow.merge. -/
noncomputable def standardContextAlgebra : ContextAlgebra where
  identity := ContextWindow.empty ⟨[]⟩ 0
  merge    := ContextWindow.merge
  assoc    := merge_items_assoc
  right_id := fun w => merge_empty_right w ⟨[]⟩ 0

/-! ## §9. Resource Dominance Theorems -/

/-- Resource dominance is reflexive. -/
theorem resource_dominates_refl (r : ResourceSig) :
    r.dominates r := by
  exact ⟨le_refl _, le_refl _, le_refl _, le_refl _⟩

/-- Resource dominance is transitive. -/
theorem resource_dominates_trans (a b c : ResourceSig)
    (h₁ : a.dominates b) (h₂ : b.dominates c) :
    a.dominates c := by
  exact ⟨le_trans h₂.1 h₁.1, le_trans h₂.2.1 h₁.2.1,
         le_trans h₂.2.2.1 h₁.2.2.1, le_trans h₂.2.2.2 h₁.2.2.2⟩

/-
More resources → larger or equal window capacity.
-/
theorem more_resources_bigger_window (r s : ResourceSig)
    (h : r.dominates s) :
    (shapeFromResources s).capacity ≤ (shapeFromResources r).capacity := by
  unfold shapeFromResources;
  rcases h with ⟨ h₁, h₂, h₃, h₄ ⟩;
  unfold WindowShape.capacity; simp +decide [ * ];
  grind

/-! ## §10. Functoriality of Context Selection -/

/-- Two threads with the same task get the same shape. -/
theorem same_task_same_shape (τ₁ τ₂ : ThreadId)
    (h : τ₁.task = τ₂.task) :
    (contextSelect τ₁).shape = (contextSelect τ₂).shape := by
  simp [contextSelect, h]

/-- The context window position is bounded by 196883. -/
theorem contextSelect_position_bounded (τ : ThreadId) :
    (contextSelect τ).position < 196883 := by
  simp [contextSelect]
  omega

/-! ## §11. Computational Demonstrations -/

/-- Example: a high-memory sequential task. -/
def exampleTask : TaskDescriptor where
  taskId := 1
  geometry := .chain
  priority := 5
  resources := ⟨4, 2, 1, 1⟩

/-- Example thread. -/
def exampleThread : ThreadId where
  agentId := 42
  threadNo := 0
  torusPos := 12345
  task := exampleTask

#eval (contextSelect exampleThread).shape
#eval (contextSelect exampleThread).shape.capacity
#eval classifyWindow (contextSelect exampleThread)

/-- Example: Monster-slice tensor product. -/
def exampleSliceTile : SliceTileProduct where
  slice := ⟨3, 42, by omega⟩
  tile  := ⟨1, [10, 20, 30]⟩

#eval exampleSliceTile.toContextWindow.shape.capacity
#eval exampleSliceTile.toContextWindow.items.length
#eval classifyWindow exampleSliceTile.toContextWindow

#eval (semanticVoxelSpace .grid 4).cellCount
