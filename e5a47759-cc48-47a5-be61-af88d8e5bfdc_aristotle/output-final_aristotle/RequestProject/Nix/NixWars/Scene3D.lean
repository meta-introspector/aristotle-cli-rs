import RequestProject.Nix.NixWars.Emit

/-!
# Every cabinet in three dimensions

The fifteen doors of the board are state vectors: `Emit.lean` ships, for each
one, its field names, the state it starts in and the compiled transition table
that the page steps it with.  Nothing in that pipeline says how a state should
*look*.  This file says it, once, for all of them.

A **scene** is a list of gadgets, and a gadget turns fields of the state vector
into voxels of a `16 × 16 × 16` arena:

* `Gadget.bar f cap col row colour` is a column of `min (state[f]) cap` cubes
  standing on the floor tile `(col, row)` — one field, drawn as a tower;
* `Gadget.cube fx fy fz colour` is a single cube at
  `(state[fx], state[fy], state[fz])` — three fields read as a position, which
  is what the ship of the Frontier Run and the probe of 8D Hyperspace are.

`sceneVoxels` renders a scene against a state, and that function — not a
hand-written shader — is what the WebGL pages draw.  Three things are proved
about it:

* **nothing escapes the arena** (`doorScene_in_arena`): whatever the state, and
  for every one of the fifteen doors, every voxel of the scene has all three
  coordinates below `16`, so the renderer's box never has to grow;
* **nothing is hidden** (`doorScenes_cover_fields`): for every door, every field
  of its state vector is drawn by some gadget of its scene.  The 3D view of a
  cabinet shows the whole of its state, not a summary of it;
* **the scenes are the doors** (`doorScenes_fields_correct`): the field counts
  the scenes are built from are the lengths of the doors' own serialized
  states, taken from the game modules, so a scene cannot drift from the cabinet
  it draws.  (A door's state vector carries the three session fields — caller,
  shard, game — in front of the game's own fields, and the scene draws those
  too.)

The bound `sceneVoxels_length_le` sizes the buffer the page allocates.
-/

namespace NixWars

namespace Scene3D

/-! ## Voxels and gadgets -/

/-- The side of the arena every cabinet is drawn in. -/
def arena : Nat := 16

/-- A drawn cube. -/
structure Voxel where
  /-- Cell along the first axis. -/
  x : Nat
  /-- Height. -/
  y : Nat
  /-- Cell along the third axis. -/
  z : Nat
  /-- Index into the palette. -/
  colour : Nat
  deriving DecidableEq, Repr, Inhabited

/-- A piece of a cabinet's 3D scene. -/
inductive Gadget
  | /-- A tower of cubes whose height is the field's value, capped. -/
    bar (field cap col row colour : Nat)
  | /-- One cube, at the position three fields give. -/
    cube (fx fy fz colour : Nat)
  deriving DecidableEq, Repr, Inhabited

/-- A value, cut down to the arena. -/
def clampTo (cap v : Nat) : Nat := min v cap

theorem clampTo_le (cap v : Nat) : clampTo cap v ≤ cap := Nat.min_le_right _ _

/-- The fields a gadget reads. -/
def Gadget.fields : Gadget → List Nat
  | .bar f _ _ _ _ => [f]
  | .cube a b c _ => [a, b, c]

/-- A gadget is well formed when it draws inside the arena. -/
def Gadget.wf : Gadget → Bool
  | .bar _ cap col row _ => decide (cap ≤ arena ∧ col < arena ∧ row < arena)
  | .cube _ _ _ _ => true

/-- The cubes a gadget puts on the screen, in a given state. -/
def gadgetVoxels (st : List Nat) : Gadget → List Voxel
  | .bar f cap col row colour =>
      (List.range (clampTo cap (st.getD f 0))).map (fun h => ⟨col, h, row, colour⟩)
  | .cube fx fy fz colour =>
      [⟨clampTo (arena - 1) (st.getD fx 0), clampTo (arena - 1) (st.getD fy 0),
        clampTo (arena - 1) (st.getD fz 0), colour⟩]

/-- The cubes a whole scene puts on the screen. -/
def sceneVoxels (sc : List Gadget) (st : List Nat) : List Voxel :=
  sc.flatMap (gadgetVoxels st)

/-- The fields a whole scene reads. -/
def sceneFields (sc : List Gadget) : List Nat := sc.flatMap Gadget.fields

/-! ## Nothing escapes the arena -/

theorem gadgetVoxels_in_arena {g : Gadget} (h : g.wf = true) (st : List Nat) :
    ∀ v ∈ gadgetVoxels st g, v.x < arena ∧ v.y < arena ∧ v.z < arena := by
  cases g with
  | bar f cap col row colour =>
    simp only [Gadget.wf, decide_eq_true_eq] at h
    obtain ⟨hcap, hcol, hrow⟩ := h
    intro v hv
    simp only [gadgetVoxels, List.mem_map, List.mem_range] at hv
    obtain ⟨k, hk, rfl⟩ := hv
    have hkc : k < cap := lt_of_lt_of_le hk (clampTo_le _ _)
    exact ⟨hcol, show k < arena by omega, hrow⟩
  | cube fx fy fz colour =>
    intro v hv
    simp only [gadgetVoxels, List.mem_singleton] at hv
    subst hv
    refine ⟨?_, ?_, ?_⟩ <;>
      exact lt_of_le_of_lt (clampTo_le _ _) (by decide)

theorem sceneVoxels_in_arena {sc : List Gadget} (h : ∀ g ∈ sc, g.wf = true) (st : List Nat) :
    ∀ v ∈ sceneVoxels sc st, v.x < arena ∧ v.y < arena ∧ v.z < arena := by
  intro v hv
  simp only [sceneVoxels, List.mem_flatMap] at hv
  obtain ⟨g, hg, hvg⟩ := hv
  exact gadgetVoxels_in_arena (h g hg) st v hvg

/-! ## How much is drawn -/

theorem gadgetVoxels_length_le {g : Gadget} (h : g.wf = true) (st : List Nat) :
    (gadgetVoxels st g).length ≤ arena := by
  cases g with
  | bar f cap col row colour =>
    simp only [Gadget.wf, decide_eq_true_eq] at h
    simpa [gadgetVoxels] using le_trans (clampTo_le cap (st.getD f 0)) h.1
  | cube fx fy fz colour => simp [gadgetVoxels, arena]

theorem sceneVoxels_length_le {sc : List Gadget} (h : ∀ g ∈ sc, g.wf = true) (st : List Nat) :
    (sceneVoxels sc st).length ≤ arena * sc.length := by
  induction sc with
  | nil => simp [sceneVoxels]
  | cons g gs ih =>
    have hg := gadgetVoxels_length_le (h g (by simp)) st
    have hrest := ih (fun x hx => h x (by simp [hx]))
    simp only [sceneVoxels, List.flatMap_cons, List.length_append, List.length_cons]
    calc (gadgetVoxels st g).length + (gs.flatMap (gadgetVoxels st)).length
        ≤ arena + arena * gs.length := by
          exact Nat.add_le_add hg hrest
      _ = arena * (gs.length + 1) := by ring

/-! ## The scenes of the fifteen doors -/

/-- The default scene of a door with `n` fields: a skyline, one tower per
field, on a four-by-four floor. -/
def barScene (n : Nat) : List Gadget :=
  (List.range n).map (fun i => Gadget.bar i 12 (1 + 3 * (i % 4)) (1 + 3 * (i / 4)) (i % 8))

/-- **Every door, in three dimensions.**  Each entry is the door's name, the
number of fields in its state vector, and the scene that draws it.  The Frontier
Run and 8D Hyperspace get a ship as well as a skyline: their first three fields
are a position. -/
def doorScenes : List (String × Nat × List Gadget) :=
  [ ("nixwars", 8, barScene 8),
    ("dash", 7, barScene 7),
    ("market", 7, barScene 7),
    ("lord", 8, barScene 8),
    ("hunt", 8, barScene 8),
    ("zx81", 5, barScene 5),
    ("frens", 8, barScene 8),
    ("tycoon", 8, barScene 8),
    ("meme", 8, barScene 8),
    ("hyper", 11, Gadget.cube 3 4 5 9 :: barScene 11),
    ("oracle", 7, barScene 7),
    ("vote", 7, barScene 7),
    ("qbert", 16, Gadget.cube 4 3 3 9 :: barScene 16),
    ("frontier", 11, Gadget.cube 3 4 5 9 :: barScene 11),
    ("invaders", 13, Gadget.cube 3 6 4 9 :: barScene 13) ]

/-- All fifteen cabinets have a scene. -/
theorem doorScenes_length : doorScenes.length = 15 := by decide

/-- **The scenes are the doors**: the field counts they are built from are the
field counts of the doors, as the game modules define them. -/
theorem doorScenes_fields_correct :
    doorScenes.map (fun p => (p.1, p.2.1)) =
      [ ("nixwars", (sessionSerialize initialSession).length),
        ("dash", (gsSerialize initialDashSession).length),
        ("market", (gsSerialize initialMarketSession).length),
        ("lord", (gsSerialize initialLordSession).length),
        ("hunt", (gsSerialize initialHuntSession).length),
        ("zx81", (gsSerialize initialZx81Session).length),
        ("frens", (gsSerialize initialLobbySession).length),
        ("tycoon", (gsSerialize initialTycoonSession).length),
        ("meme", (gsSerialize initialMemeSession).length),
        ("hyper", (gsSerialize initialHyperSession).length),
        ("oracle", (gsSerialize initialOracleSession).length),
        ("vote", (gsSerialize initialVoteSession).length),
        ("qbert", (gsSerialize initialQbertSession).length),
        ("frontier", (gsSerialize initialFrontierSession).length),
        ("invaders", (gsSerialize initialInvadersSession).length) ] := by decide

/-- Every gadget of every scene draws inside the arena. -/
theorem doorScenes_wf : ∀ p ∈ doorScenes, ∀ g ∈ p.2.2, g.wf = true := by decide

/-- **Nothing escapes the arena**, whatever state a cabinet is in. -/
theorem doorScene_in_arena (p : String × Nat × List Gadget) (hp : p ∈ doorScenes)
    (st : List Nat) : ∀ v ∈ sceneVoxels p.2.2 st, v.x < arena ∧ v.y < arena ∧ v.z < arena :=
  sceneVoxels_in_arena (doorScenes_wf p hp) st

/-- **Nothing is hidden**: every field of every door's state vector is drawn by
some gadget of its scene. -/
theorem doorScenes_cover_fields :
    ∀ p ∈ doorScenes, ∀ i ∈ List.range p.2.1, i ∈ sceneFields p.2.2 := by decide

/-- The arena needs room for at most this many cubes. -/
theorem doorScene_size (p : String × Nat × List Gadget) (hp : p ∈ doorScenes) (st : List Nat) :
    (sceneVoxels p.2.2 st).length ≤ arena * p.2.2.length :=
  sceneVoxels_length_le (doorScenes_wf p hp) st

end Scene3D

end NixWars
