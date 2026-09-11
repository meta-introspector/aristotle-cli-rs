/-
# Geography: coordinates, tiles and bounding boxes

The upstream Rust pastebin has a *gallery* of NFT enrichments keyed by
Wikidata entity (`src/gallery.rs`), and a plugin system whose units are
called *tiles* (`src/tiles.rs`).  Neither of them places anything on a
map.  This module is the arithmetic a map view needs, done in exact
integer arithmetic so that it is decidable and identical in Lean and in
the browser.

Positions are integers in **micro-degrees** (1 µ° ≈ 11 cm), never floats:
two devices that compute the same pin agree bit for bit, and a pin can be
put in a paste, a QR code or a picture without a rounding question.

Proved here:

* `wrapLon_mem` / `wrapLon_eq_self` / `wrapLon_idem` / `wrapLon_period` —
  longitudes wrap onto the half-open range `[-180°, 180°)` exactly once,
  the wrap is the identity on values already in range, and it is
  invariant under whole turns;
* `clampLat_mem` / `clampLat_eq_self` / `clampLat_idem` — latitudes clamp
  to `[-90°, 90°]`;
* `norm_valid` / `norm_eq_self_of_valid` / `norm_idem` — every coordinate,
  however it arrived, normalises to a valid one, and valid ones are
  untouched;
* `tileX_lt` / `tileY_lt` — the tile indices of a valid coordinate at
  zoom `z` are inside the `2^z × 2^z` grid;
* `tileOf_contains` — the tile a coordinate is assigned to really does
  cover it;
* `contains_unique` — a coordinate is covered by at most one tile per
  zoom level, so the assignment above is *the* tile;
* `parent_tileOf` — zooming out one level maps a tile to the tile that
  contains it: clusters merge, they never split;
* `quadkey_length` / `quadkey_roundTrip` — a tile is faithfully named by
  its quadkey, and the name recovers the tile;
* `hull_contains` / `hull_perm` — the bounding box of a list of positions
  contains all of them and does not depend on the order they arrived in.

The grid is the equirectangular (plate-carrée) quadtree: `x` splits
longitude and `y` splits latitude uniformly.  It is what the pins are
indexed and clustered by.  A Web-Mercator basemap (OpenStreetMap raster
tiles) is a *display* choice made by the viewer, and `Kant.GeoRef`
records the attribution such a basemap requires.
-/
import Mathlib

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace Kant.Geo

/-! ## Coordinates -/

/-- 90° in micro-degrees. -/
def latMax : Int := 90000000

/-- 180° in micro-degrees. -/
def lonMax : Int := 180000000

theorem latMax_pos : 0 < latMax := by decide

theorem lonMax_pos : 0 < lonMax := by decide

/-- A position on the Earth, in micro-degrees. -/
structure Coord where
  /-- Latitude in micro-degrees, north positive. -/
  lat : Int
  /-- Longitude in micro-degrees, east positive. -/
  lon : Int
deriving DecidableEq, Repr

/-- A coordinate is valid when the latitude is in `[-90°, 90°]` and the
longitude in the half-open range `[-180°, 180°)`. -/
def Coord.Valid (c : Coord) : Prop :=
  -latMax ≤ c.lat ∧ c.lat ≤ latMax ∧ -lonMax ≤ c.lon ∧ c.lon < lonMax

instance (c : Coord) : Decidable c.Valid := by
  unfold Coord.Valid; infer_instance

/-- Wrap a longitude onto `[-180°, 180°)`. -/
def wrapLon (x : Int) : Int := (x + lonMax) % (2 * lonMax) - lonMax

/-- Clamp a latitude to `[-90°, 90°]`. -/
def clampLat (x : Int) : Int := max (-latMax) (min latMax x)

/-- Normalise an arbitrary pair of numbers into a valid coordinate. -/
def Coord.norm (c : Coord) : Coord := ⟨clampLat c.lat, wrapLon c.lon⟩

theorem wrapLon_mem (x : Int) : -lonMax ≤ wrapLon x ∧ wrapLon x < lonMax := by
  have h2 : (0 : Int) < 2 * lonMax := by decide
  have h0 : 0 ≤ (x + lonMax) % (2 * lonMax) := Int.emod_nonneg _ (by decide)
  have h1 : (x + lonMax) % (2 * lonMax) < 2 * lonMax := Int.emod_lt_of_pos _ h2
  constructor <;> simp only [wrapLon] <;> omega

theorem wrapLon_eq_self {x : Int} (h : -lonMax ≤ x) (h' : x < lonMax) : wrapLon x = x := by
  have : (x + lonMax) % (2 * lonMax) = x + lonMax := Int.emod_eq_of_lt (by omega) (by omega)
  simp [wrapLon, this]

theorem wrapLon_idem (x : Int) : wrapLon (wrapLon x) = wrapLon x :=
  wrapLon_eq_self (wrapLon_mem x).1 (wrapLon_mem x).2

theorem wrapLon_period (x : Int) : wrapLon (x + 2 * lonMax) = wrapLon x := by
  simp [wrapLon, show x + 2 * lonMax + lonMax = x + lonMax + 1 * (2 * lonMax) by ring]

theorem clampLat_mem (x : Int) : -latMax ≤ clampLat x ∧ clampLat x ≤ latMax := by
  unfold clampLat
  constructor
  · exact le_max_left _ _
  · exact max_le (by decide) (min_le_left _ _)

theorem clampLat_eq_self {x : Int} (h : -latMax ≤ x) (h' : x ≤ latMax) : clampLat x = x := by
  unfold clampLat
  rw [min_eq_right h', max_eq_right h]

theorem clampLat_idem (x : Int) : clampLat (clampLat x) = clampLat x :=
  clampLat_eq_self (clampLat_mem x).1 (clampLat_mem x).2

theorem norm_valid (c : Coord) : (Coord.norm c).Valid := by
  refine ⟨(clampLat_mem c.lat).1, (clampLat_mem c.lat).2, (wrapLon_mem c.lon).1, (wrapLon_mem c.lon).2⟩

theorem norm_eq_self_of_valid {c : Coord} (h : c.Valid) : Coord.norm c = c := by
  obtain ⟨h1, h2, h3, h4⟩ := h
  simp [Coord.norm, clampLat_eq_self h1 h2, wrapLon_eq_self h3 h4]

theorem norm_idem (c : Coord) : Coord.norm (Coord.norm c) = Coord.norm c :=
  norm_eq_self_of_valid (norm_valid c)

/-! ## Tiles

The quadtree grid: at zoom `z` the world is a `2^z × 2^z` array of tiles,
`x` running east from `-180°` and `y` running south from `+90°`.
-/

/-- One cell of the quadtree grid. -/
structure Tile where
  /-- Zoom level: the grid is `2^zoom` cells on a side. -/
  zoom : Nat
  /-- Column, counted east from `-180°`. -/
  x : Nat
  /-- Row, counted south from `+90°`. -/
  y : Nat
deriving DecidableEq, Repr

/-- Column of a longitude at a zoom level. -/
def tileX (z : Nat) (lon : Int) : Nat := ((lon + lonMax) * (2 ^ z) / (2 * lonMax)).toNat

/-- Row of a latitude at a zoom level.  The south pole belongs to the
last row rather than to a row that does not exist. -/
def tileY (z : Nat) (lat : Int) : Nat :=
  min (((latMax - lat) * (2 ^ z) / (2 * latMax)).toNat) (2 ^ z - 1)

/-- The tile a coordinate falls in. -/
def tileOf (z : Nat) (c : Coord) : Tile := ⟨z, tileX z c.lon, tileY z c.lat⟩

@[simp] theorem tileOf_zoom (z : Nat) (c : Coord) : (tileOf z c).zoom = z := rfl

theorem tileX_lt {z : Nat} {c : Coord} (h : c.Valid) : tileX z c.lon < 2 ^ z := by
  obtain ⟨-, -, h3, h4⟩ := h
  have hp : (0 : Int) < 2 ^ z := by positivity
  have hd : (0 : Int) < 2 * lonMax := by decide
  have hnum : (c.lon + lonMax) * (2 ^ z) < (2 ^ z) * (2 * lonMax) := by nlinarith
  have hlt := Int.ediv_lt_of_lt_mul hd hnum
  have hcast : ((2 ^ z : Nat) : Int) = (2 : Int) ^ z := by push_cast; ring
  unfold tileX
  omega

/-- The clamped floor of `B / D` is a cell index whose cell contains `B`,
with the last cell closed at its far edge. -/
theorem clamped_floor_bounds {B D : Int} {N : Nat} (hB : 0 ≤ B) (hD : 0 < D)
    (hBN : B ≤ (N : Int) * D) (hN : 0 < N) :
    ((min (B / D).toNat (N - 1) : Nat) : Int) * D ≤ B ∧
      B ≤ (((min (B / D).toNat (N - 1) : Nat) : Int) + 1) * D := by
  have hq0 : 0 ≤ B / D := Int.ediv_nonneg hB (le_of_lt hD)
  have hq1 : (B / D) * D ≤ B := Int.ediv_mul_le _ (ne_of_gt hD)
  have hq2 : B < (B / D + 1) * D := Int.lt_ediv_add_one_mul_self _ hD
  have hqn : (((B / D).toNat : Nat) : Int) = B / D := Int.toNat_of_nonneg hq0
  have hqN : B / D ≤ (N : Int) := Int.ediv_le_of_le_mul hD (by linarith)
  by_cases hc : (B / D).toNat ≤ N - 1
  · rw [min_eq_left hc, hqn]
    exact ⟨hq1, le_of_lt hq2⟩
  · have hEq : (B / D).toNat = N := by omega
    have hmin : min (B / D).toNat (N - 1) = N - 1 := by omega
    have hcast : (((N - 1 : Nat)) : Int) = (N : Int) - 1 := by omega
    rw [hmin, hcast]
    have hqe : B / D = (N : Int) := by omega
    constructor
    · have : (N : Int) * D ≤ B := by rw [← hqe]; exact hq1
      nlinarith
    · have : ((N : Int) - 1 + 1) * D = (N : Int) * D := by ring
      rw [this]; exact hBN

theorem tileY_lt (z : Nat) (lat : Int) : tileY z lat < 2 ^ z := by
  have h : 0 < 2 ^ z := Nat.two_pow_pos z
  have := min_le_right (((latMax - lat) * (2 ^ z) / (2 * latMax)).toNat) (2 ^ z - 1)
  unfold tileY
  omega

/-- A tile covers a coordinate: written without division so that it is an
exact statement about integers. -/
def Tile.Contains (t : Tile) (c : Coord) : Prop :=
  (t.x : Int) * (2 * lonMax) ≤ (c.lon + lonMax) * 2 ^ t.zoom ∧
  (c.lon + lonMax) * 2 ^ t.zoom < ((t.x : Int) + 1) * (2 * lonMax) ∧
  (t.y : Int) * (2 * latMax) ≤ (latMax - c.lat) * 2 ^ t.zoom ∧
  (latMax - c.lat) * 2 ^ t.zoom ≤ ((t.y : Int) + 1) * (2 * latMax)

theorem tileOf_contains {z : Nat} {c : Coord} (h : c.Valid) : (tileOf z c).Contains c := by
  obtain ⟨h1, h2, h3, h4⟩ := h
  have hp : (0 : Int) < 2 ^ z := by positivity
  have hdlon : (0 : Int) < 2 * lonMax := by decide
  have hdlat : (0 : Int) < 2 * latMax := by decide
  -- longitude
  have hxnum : 0 ≤ (c.lon + lonMax) * (2 ^ z) := by
    have : (0 : Int) ≤ c.lon + lonMax := by omega
    positivity
  have hxq : ((c.lon + lonMax) * (2 ^ z) / (2 * lonMax)) * (2 * lonMax) ≤ (c.lon + lonMax) * (2 ^ z) :=
    Int.ediv_mul_le _ (by decide)
  have hxq' : (c.lon + lonMax) * (2 ^ z) <
      ((c.lon + lonMax) * (2 ^ z) / (2 * lonMax) + 1) * (2 * lonMax) :=
    Int.lt_ediv_add_one_mul_self _ hdlon
  have hxnn : 0 ≤ (c.lon + lonMax) * (2 ^ z) / (2 * lonMax) := Int.ediv_nonneg hxnum (by decide)
  have hxcast : ((tileX z c.lon : Nat) : Int) = (c.lon + lonMax) * (2 ^ z) / (2 * lonMax) := by
    unfold tileX; omega
  -- latitude
  have hynum : 0 ≤ (latMax - c.lat) * (2 ^ z) := by
    have : (0 : Int) ≤ latMax - c.lat := by omega
    positivity
  have hyq : ((latMax - c.lat) * (2 ^ z) / (2 * latMax)) * (2 * latMax) ≤ (latMax - c.lat) * (2 ^ z) :=
    Int.ediv_mul_le _ (by decide)
  have hyq' : (latMax - c.lat) * (2 ^ z) <
      ((latMax - c.lat) * (2 ^ z) / (2 * latMax) + 1) * (2 * latMax) :=
    Int.lt_ediv_add_one_mul_self _ hdlat
  have hynn : 0 ≤ (latMax - c.lat) * (2 ^ z) / (2 * latMax) := Int.ediv_nonneg hynum (by decide)
  have hyle : (latMax - c.lat) * (2 ^ z) ≤ (2 ^ z) * (2 * latMax) := by nlinarith
  have hqle : (latMax - c.lat) * (2 ^ z) / (2 * latMax) ≤ (2 : Int) ^ z :=
    Int.ediv_le_of_le_mul hdlat (by linarith)
  have hcast : ((2 ^ z : Nat) : Int) = (2 : Int) ^ z := by push_cast; ring
  have hp1 : 0 < 2 ^ z := Nat.two_pow_pos z
  have hy := clamped_floor_bounds (B := (latMax - c.lat) * (2 ^ z)) (D := 2 * latMax)
    (N := 2 ^ z) hynum hdlat (by rw [hcast]; linarith [hyle]) hp1
  rw [show min (((latMax - c.lat) * (2 ^ z) / (2 * latMax)).toNat) (2 ^ z - 1) = tileY z c.lat from rfl] at hy
  refine ⟨?_, ?_, hy.1, hy.2⟩
  · rw [tileOf, hxcast]; exact hxq
  · rw [tileOf, hxcast]; exact hxq'

/-- Two integers that both floor-divide to the same value are equal:
the helper behind tile uniqueness. -/
theorem cell_unique {A D : Int} {m n : Nat} (hD : 0 < D)
    (h1 : (m : Int) * D ≤ A) (h2 : A < ((m : Int) + 1) * D)
    (h3 : (n : Int) * D ≤ A) (h4 : A < ((n : Int) + 1) * D) : m = n := by
  by_contra hne
  rcases Nat.lt_or_ge m n with h | h
  · have hmn : ((m : Int) + 1) ≤ (n : Int) := by exact_mod_cast h
    nlinarith
  · have hmn : ((n : Int) + 1) ≤ (m : Int) := by
      have : n < m := by omega
      exact_mod_cast this
    nlinarith

/-- At one zoom level a coordinate lies in at most one column: the tile a
pin is put in is *the* tile covering it.  (Rows carry a closed upper
edge, so a pin exactly on a parallel between two rows belongs to both;
`tileOf` picks the northern one.) -/
theorem contains_unique {t t' : Tile} {c : Coord} (hz : t.zoom = t'.zoom)
    (h : t.Contains c) (h' : t'.Contains c) : t.x = t'.x := by
  obtain ⟨h1, h2, -, -⟩ := h
  obtain ⟨h3, h4, -, -⟩ := h'
  rw [hz] at h1 h2
  exact cell_unique (D := 2 * lonMax) (by decide) h1 h2 h3 h4

/-! ## Zooming out -/

/-- The tile one zoom level out that covers this one. -/
def Tile.parent (t : Tile) : Tile := ⟨t.zoom - 1, t.x / 2, t.y / 2⟩

theorem tileX_parent (z : Nat) (lon : Int) : tileX (z + 1) lon / 2 = tileX z lon := by
  have hkey : (lon + lonMax) * (2 ^ (z + 1)) / (2 * lonMax) / 2
      = (lon + lonMax) * (2 ^ z) / (2 * lonMax) := by
    rw [Int.ediv_ediv_of_nonneg (by decide)]
    have h1 : (lon + lonMax) * (2 : Int) ^ (z + 1) = 2 * ((lon + lonMax) * 2 ^ z) := by ring
    have h2 : (2 * lonMax) * (2 : Int) = 2 * (2 * lonMax) := by ring
    rw [h1, h2, Int.mul_ediv_mul_of_pos _ _ (by decide)]
  unfold tileX
  omega

theorem tileY_parent (z : Nat) (lat : Int) : tileY (z + 1) lat / 2 = tileY z lat := by
  have hkey : (latMax - lat) * (2 ^ (z + 1)) / (2 * latMax) / 2
      = (latMax - lat) * (2 ^ z) / (2 * latMax) := by
    rw [Int.ediv_ediv_of_nonneg (by decide)]
    have h1 : (latMax - lat) * (2 : Int) ^ (z + 1) = 2 * ((latMax - lat) * 2 ^ z) := by ring
    have h2 : (2 * latMax) * (2 : Int) = 2 * (2 * latMax) := by ring
    rw [h1, h2, Int.mul_ediv_mul_of_pos _ _ (by decide)]
  have hpow : (2 : Nat) ^ (z + 1) = 2 * 2 ^ z := by ring
  have hp1 : 0 < 2 ^ z := Nat.two_pow_pos z
  unfold tileY
  omega

/-- Zooming out one level sends a tile to the tile that contains it: as
the map is zoomed out clusters merge, and never split. -/
theorem parent_tileOf {z : Nat} (c : Coord) (hz : 0 < z) :
    (tileOf z c).parent = tileOf (z - 1) c := by
  obtain ⟨w, rfl⟩ : ∃ w, z = w + 1 := ⟨z - 1, by omega⟩
  simp [Tile.parent, tileOf, tileX_parent, tileY_parent]

/-! ## Quadkeys

The standard name of a tile: one digit per zoom level, `0` north-west,
`1` north-east, `2` south-west, `3` south-east.
-/

/-- The digit for one level. -/
def quadDigit (bx by_ : Nat) : Char :=
  match by_, bx with
  | 0, 0 => '0'
  | 0, _ => '1'
  | _, 0 => '2'
  | _, _ => '3'

/-- The quadkey of the tile `(x, y)` at zoom `z`, most significant digit
first. -/
def quadkeyAux : Nat → Nat → Nat → List Char
  | 0, _, _ => []
  | z + 1, x, y => quadDigit ((x >>> z) % 2) ((y >>> z) % 2) :: quadkeyAux z x y

/-- The quadkey naming a tile. -/
def Tile.quadkey (t : Tile) : List Char := quadkeyAux t.zoom t.x t.y

/-- Read a quadkey back as a tile. -/
def ofQuadkey : List Char → Option Tile
  | [] => some ⟨0, 0, 0⟩
  | d :: rest => do
      let t ← ofQuadkey rest
      let (bx, by_) ←
        match d with
        | '0' => some (0, 0)
        | '1' => some (1, 0)
        | '2' => some (0, 1)
        | '3' => some (1, 1)
        | _ => none
      some ⟨t.zoom + 1, t.x + bx * 2 ^ t.zoom, t.y + by_ * 2 ^ t.zoom⟩

theorem quadkeyAux_length (z x y : Nat) : (quadkeyAux z x y).length = z := by
  induction z generalizing x y with
  | zero => rfl
  | succ n ih => simp [quadkeyAux, ih]

theorem quadkey_length (t : Tile) : t.quadkey.length = t.zoom := quadkeyAux_length _ _ _

theorem ofQuadkey_quadkeyAux (z x y : Nat) :
    ofQuadkey (quadkeyAux z x y) = some ⟨z, x % 2 ^ z, y % 2 ^ z⟩ := by
  induction z generalizing x y with
  | zero => simp [quadkeyAux, ofQuadkey, Nat.mod_one]
  | succ n ih =>
    have hx : x % 2 ^ (n + 1) = x % 2 ^ n + 2 ^ n * (x / 2 ^ n % 2) := by
      rw [pow_succ, mul_comm ((2 : Nat) ^ n) 2, ← Nat.mod_mul]
      ring_nf
    have hy : y % 2 ^ (n + 1) = y % 2 ^ n + 2 ^ n * (y / 2 ^ n % 2) := by
      rw [pow_succ, mul_comm ((2 : Nat) ^ n) 2, ← Nat.mod_mul]
      ring_nf
    have hxs : x >>> n % 2 = x / 2 ^ n % 2 := by rw [Nat.shiftRight_eq_div_pow]
    have hys : y >>> n % 2 = y / 2 ^ n % 2 := by rw [Nat.shiftRight_eq_div_pow]
    rcases Nat.mod_two_eq_zero_or_one (x / 2 ^ n) with hbx | hbx <;>
      rcases Nat.mod_two_eq_zero_or_one (y / 2 ^ n) with hby | hby <;>
      simp [quadkeyAux, ofQuadkey, ih, quadDigit, hxs, hys, hbx, hby, hx, hy]

/-- A tile is faithfully named by its quadkey. -/
theorem quadkey_roundTrip {t : Tile} (hx : t.x < 2 ^ t.zoom) (hy : t.y < 2 ^ t.zoom) :
    ofQuadkey t.quadkey = some t := by
  obtain ⟨z, x, y⟩ := t
  simp only at hx hy
  rw [Tile.quadkey, ofQuadkey_quadkeyAux, Nat.mod_eq_of_lt hx, Nat.mod_eq_of_lt hy]

/-! ## Bounding boxes -/

/-- A rectangle of the grid, inclusive on all four sides. -/
structure BBox where
  /-- Southern edge. -/
  south : Int
  /-- Western edge. -/
  west : Int
  /-- Northern edge. -/
  north : Int
  /-- Eastern edge. -/
  east : Int
deriving DecidableEq, Repr

/-- Is a coordinate inside the box? -/
def BBox.contains (b : BBox) (c : Coord) : Bool :=
  decide (b.south ≤ c.lat) && decide (c.lat ≤ b.north) &&
  decide (b.west ≤ c.lon) && decide (c.lon ≤ b.east)

/-- The one-point box. -/
def BBox.point (c : Coord) : BBox := ⟨c.lat, c.lon, c.lat, c.lon⟩

/-- Grow a box to include a coordinate. -/
def BBox.extend (b : BBox) (c : Coord) : BBox :=
  ⟨min b.south c.lat, min b.west c.lon, max b.north c.lat, max b.east c.lon⟩

/-- The bounding box of a non-empty list of positions. -/
def hull (c : Coord) (cs : List Coord) : BBox :=
  cs.foldl BBox.extend (BBox.point c)

theorem contains_extend_self (b : BBox) (c : Coord) : (b.extend c).contains c = true := by
  simp [BBox.contains, BBox.extend]

theorem contains_extend_of_contains {b : BBox} {c d : Coord} (h : b.contains c = true) :
    (b.extend d).contains c = true := by
  simp only [BBox.contains, BBox.extend, Bool.and_eq_true, decide_eq_true_eq] at h ⊢
  obtain ⟨⟨⟨h1, h2⟩, h3⟩, h4⟩ := h
  refine ⟨⟨⟨?_, ?_⟩, ?_⟩, ?_⟩ <;> simp <;> omega

theorem contains_foldl_of_contains {b : BBox} {c : Coord} (cs : List Coord)
    (h : b.contains c = true) : (cs.foldl BBox.extend b).contains c = true := by
  induction cs generalizing b with
  | nil => simpa using h
  | cons d ds ih => exact ih (contains_extend_of_contains h)

theorem hull_contains_head (c : Coord) (cs : List Coord) : (hull c cs).contains c = true := by
  refine contains_foldl_of_contains cs ?_
  simp [BBox.contains, BBox.point]

theorem contains_foldl_of_mem {b : BBox} {d : Coord} {cs : List Coord} (h : d ∈ cs) :
    (cs.foldl BBox.extend b).contains d = true := by
  induction cs generalizing b with
  | nil => simp at h
  | cons e es ih =>
    rcases List.mem_cons.1 h with rfl | h'
    · exact contains_foldl_of_contains es (contains_extend_self _ _)
    · exact ih h'

theorem hull_contains_mem {c d : Coord} {cs : List Coord} (h : d ∈ cs) :
    (hull c cs).contains d = true :=
  contains_foldl_of_mem h

instance : RightCommutative BBox.extend where
  right_comm b c d := by
    simp only [BBox.extend, BBox.mk.injEq]
    refine ⟨?_, ?_, ?_, ?_⟩ <;> omega

/-- The bounding box of a set of pins does not depend on the order the
pins arrived in. -/
theorem hull_perm {c : Coord} {cs cs' : List Coord} (h : cs.Perm cs') : hull c cs = hull c cs' :=
  h.foldl_eq _

end Kant.Geo
