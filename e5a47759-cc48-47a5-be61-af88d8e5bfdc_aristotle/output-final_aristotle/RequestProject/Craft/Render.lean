import RequestProject.Craft.Voxel

/-!
# The renderer: micro voxels to SVG

Every micro voxel of a scene is projected isometrically onto the screen and
drawn as a cube (three shaded faces).  The list of screen quads is sorted by
*depth* `x + y + z`, which is the painter's algorithm for this projection, and
the SVG document is the concatenation of the quads in that order.

Two things are proved about the renderer:

* `render_cells_perm` — the picture is **faithful**: the micro voxels it draws
  are exactly the micro voxels the scene occupies, each drawn once.
* `occlusion_geometry` together with `render_occlusion` — the picture is
  **correctly occluded**: two voxels land on the same screen position only when
  one is directly behind the other, and in that case the nearer one is drawn
  later, so it covers the one behind it.
-/

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace Tycoon

/-! ## Isometric projection -/

/-- Screen-space width of one micro voxel step in `x`/`z`. -/
def isoW : Int := 16
/-- Screen-space height of one micro voxel step in `x`/`z`. -/
def isoH : Int := 8
/-- Screen-space height of one micro voxel step in `y`. -/
def isoV : Int := 16
/-- Horizontal origin of the projection. -/
def isoOX : Int := 320
/-- Vertical origin of the projection. -/
def isoOY : Int := 80

/-- A projected micro voxel: where it lands on screen, how near the camera it
is, and what colour to paint it. -/
structure Quad where
  /-- The micro voxel this quad came from. -/
  cell : V3
  /-- Screen `x` of the voxel's top corner. -/
  sx : Int
  /-- Screen `y` of the voxel's top corner. -/
  sy : Int
  /-- Painter's-algorithm depth: larger is nearer the camera. -/
  depth : Nat
  /-- Base fill colour, `0xRRGGBB`. -/
  color : Nat
deriving DecidableEq, Repr, Inhabited

/-- Screen `x` of a micro voxel. -/
def projX (c : V3) : Int := ((c.x : Int) - (c.z : Int)) * isoW + isoOX

/-- Screen `y` of a micro voxel. -/
def projY (c : V3) : Int := ((c.x : Int) + (c.z : Int)) * isoH - (c.y : Int) * isoV + isoOY

/-- Painter depth of a micro voxel. -/
def depthOf (c : V3) : Nat := c.x + c.y + c.z

/-- Project one micro voxel. -/
def project (color : Nat) (c : V3) : Quad :=
  { cell := c, sx := projX c, sy := projY c, depth := depthOf c, color := color }

/-- The quads of a single placed part, unsorted. -/
def Part.quads (p : Part) : List Quad := p.cells.map (project p.kind.color)

/-- All the quads of a scene, in scene order. -/
def Scene.quadsRaw (s : Scene) : List Quad := s.flatMap Part.quads

/-- Depth comparison used by the painter's algorithm. -/
def quadLe (a b : Quad) : Bool := decide (a.depth ≤ b.depth)

/-- **The renderer**: project every micro voxel and sort back to front. -/
def render (s : Scene) : List Quad := (Scene.quadsRaw s).mergeSort quadLe

/-! ## Faithfulness -/

theorem quadsRaw_cells (s : Scene) :
    (Scene.quadsRaw s).map Quad.cell = Scene.cells s := by
  induction s with
  | nil => rfl
  | cons p t ih =>
      simp only [Scene.quadsRaw, List.flatMap_cons, List.map_append, Scene.cells_cons] at *
      rw [ih]
      congr 1
      simp [Part.quads, List.map_map, Function.comp_def, project]

theorem render_perm (s : Scene) : (render s).Perm (Scene.quadsRaw s) :=
  List.mergeSort_perm _ _

/-- **The picture is faithful**: the quads the renderer emits are exactly the
micro voxels the scene occupies, each of them drawn exactly once. -/
theorem render_cells_perm (s : Scene) :
    ((render s).map Quad.cell).Perm (Scene.cells s) := by
  have := (render_perm s).map Quad.cell
  rwa [quadsRaw_cells] at this

/-- The renderer draws one cube per occupied micro voxel. -/
theorem render_length (s : Scene) : (render s).length = (Scene.cells s).length := by
  have := (render_cells_perm s).length_eq
  simpa using this

/-- Nothing is drawn for an empty factory. -/
@[simp] theorem render_nil : render [] = [] := by
  simp [render, Scene.quadsRaw]

/-! ## Occlusion -/

theorem quadLe_trans : ∀ a b c : Quad, quadLe a b = true → quadLe b c = true → quadLe a c = true := by
  intro a b c h1 h2
  simp only [quadLe, decide_eq_true_eq] at *
  omega

theorem quadLe_total : ∀ a b : Quad, (quadLe a b || quadLe b a) = true := by
  intro a b
  simp only [quadLe, Bool.or_eq_true, decide_eq_true_eq]
  omega

/-- The renderer's output is sorted back to front. -/
theorem render_sorted (s : Scene) :
    (render s).Pairwise (fun a b => a.depth ≤ b.depth) := by
  have := List.pairwise_mergeSort quadLe_trans quadLe_total (Scene.quadsRaw s)
  simpa [render, quadLe] using this

/-- **The geometry behind the painter's algorithm.** If two micro voxels land
on the same screen position, then the one with the greater depth is nearer the
camera in every axis — it stands directly in front of the other, so painting it
later is exactly right. -/
theorem occlusion_geometry {a b : V3} (hx : projX a = projX b) (hy : projY a = projY b)
    (hd : depthOf a < depthOf b) : a.x < b.x ∧ a.y < b.y ∧ a.z < b.z := by
  simp only [projX, projY, depthOf, isoW, isoH, isoV, isoOX, isoOY] at *
  omega

/-- **The picture is correctly occluded**: a quad that is nearer the camera is
drawn later, hence on top. -/
theorem render_occlusion (s : Scene) (i j : Nat) (hi : i < (render s).length)
    (hj : j < (render s).length)
    (h : ((render s)[j]'hj).depth < ((render s)[i]'hi).depth) : j < i := by
  rcases lt_trichotomy j i with hlt | heq | hgt
  · exact hlt
  · subst heq; exact absurd h (lt_irrefl _)
  · have := (List.pairwise_iff_get.mp (render_sorted s)) ⟨i, hi⟩ ⟨j, hj⟩ (by simpa using hgt)
    simp only [List.get_eq_getElem] at this
    omega

/-! ## SVG output -/

private def hexDigit (n : Nat) : Char :=
  if n < 10 then Char.ofNat (48 + n) else Char.ofNat (87 + n)

/-- Two hex digits of a byte. -/
def hex2 (n : Nat) : String :=
  String.ofList [hexDigit (n / 16 % 16), hexDigit (n % 16)]

/-- An `#rrggbb` colour literal. -/
def colorHex (c : Nat) : String :=
  "#" ++ hex2 (c / 65536 % 256) ++ hex2 (c / 256 % 256) ++ hex2 (c % 256)

/-- Darken a colour to `num/den` of its brightness, channel by channel. -/
def shade (c num den : Nat) : Nat :=
  let r := c / 65536 % 256
  let g := c / 256 % 256
  let b := c % 256
  (r * num / den) * 65536 + (g * num / den) * 256 + (b * num / den)

private def pt (x y : Int) : String := toString x ++ "," ++ toString y ++ " "

private def poly (pts : String) (col : Nat) : String :=
  "<polygon points=\"" ++ pts ++ "\" fill=\"" ++ colorHex col ++ "\"/>"

/-- One isometric cube: top, left and right faces, shaded. -/
def svgQuad (q : Quad) : String :=
  let x := q.sx
  let y := q.sy
  poly (pt x y ++ pt (x + isoW) (y + isoH) ++ pt x (y + 2 * isoH) ++ pt (x - isoW) (y + isoH))
      q.color
  ++ poly (pt (x - isoW) (y + isoH) ++ pt x (y + 2 * isoH) ++ pt x (y + 2 * isoH + isoV)
      ++ pt (x - isoW) (y + isoH + isoV)) (shade q.color 7 10)
  ++ poly (pt x (y + 2 * isoH) ++ pt (x + isoW) (y + isoH) ++ pt (x + isoW) (y + isoH + isoV)
      ++ pt x (y + 2 * isoH + isoV)) (shade q.color 1 2)

/-- The opening tag of a rendered frame. -/
def svgHeader : String :=
  "<svg xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 640 480\" width=\"640\" height=\"480\">" ++
  "<rect width=\"640\" height=\"480\" fill=\"#10141a\"/>"

/-- The closing tag of a rendered frame. -/
def svgFooter : String := "</svg>"

/-- **The rendered frame**: one SVG document for a factory. -/
def renderSVG (s : Scene) : String :=
  svgHeader ++ String.join ((render s).map svgQuad) ++ svgFooter

/-- A rendered frame is a well-formed SVG document: header, body, footer. -/
theorem renderSVG_wraps (s : Scene) :
    ∃ body, renderSVG s = svgHeader ++ body ++ svgFooter :=
  ⟨String.join ((render s).map svgQuad), rfl⟩

/-- The body of a frame is one cube per occupied micro voxel, in painter
order. -/
theorem renderSVG_body_length (s : Scene) :
    ((render s).map svgQuad).length = (Scene.cells s).length := by
  simpa using render_length s

end Tycoon
