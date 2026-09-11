import RequestProject.Gvcs.Voxel.Lua

/-!
# Drawing the voxel model

An isometric picture of the machine, drawn straight from the occupancy
functions of `RequestProject/Voxel/Parts.lean`: every occupied voxel of the
model contributes the faces of its cube that no neighbouring voxel hides, and
the faces are painted back to front.  Nothing here is drawn by hand — the
picture is a function of the same `machine` the proofs are about, so a change
to a part shows up in the picture.
-/

namespace LifeTrac
namespace Voxel

open Solid

/-- Half the width of a voxel on screen, in pixels. -/
def isoScale : ℤ := 8

/-- Isometric projection of a lattice point: `x` goes right and down, `y` left
and down, `z` straight up. -/
def project (v : Vox) : ℤ × ℤ :=
  ((v.x - v.y) * isoScale, (v.x + v.y) * (isoScale / 2) - v.z * isoScale)

/-- A point of an SVG polygon. -/
def pointStr (p : ℤ × ℤ) : String := toString p.1 ++ "," ++ toString p.2

/-- Scale a colour channel by a percentage. -/
def shade (c : ℤ) (pct : ℤ) : ℤ := max 0 (min 255 (c * pct / 100))

/-- An SVG `fill` for a colour at a shading percentage. -/
def fillOf (c : Colour) (pct : ℤ) : String :=
  "rgb(" ++ toString (shade c.r pct) ++ "," ++ toString (shade c.g pct) ++ "," ++
    toString (shade c.b pct) ++ ")"

/-- Which body owns a voxel — the first one in `bodies` that occupies it. -/
def voxelColour (lift : ℤ) (v : Vox) : Colour :=
  match bodies.find? (fun b => b.shape lift v) with
  | some b => b.colour
  | none => steelC

/-- One polygon of the picture. -/
def polygon (pts : List Vox) (fill : String) : String :=
  "<polygon points=\"" ++ String.intercalate " " (pts.map (fun v => pointStr (project v))) ++
    "\" fill=\"" ++ fill ++ "\" stroke=\"rgb(20,20,25)\" stroke-width=\"0.4\"/>"

/-- The visible faces of one voxel: the top and the two sides that face the
camera, each drawn only when no neighbouring voxel hides it. -/
def voxelFaces (s : Solid) (col : Colour) (v : Vox) : List String :=
  let x := v.x; let y := v.y; let z := v.z
  let top : List String :=
    if s (x, y, z + 1) then [] else
      [polygon [(x, y, z + 1), (x + 1, y, z + 1), (x + 1, y + 1, z + 1), (x, y + 1, z + 1)]
        (fillOf col 100)]
  let sideX : List String :=
    if s (x + 1, y, z) then [] else
      [polygon [(x + 1, y, z), (x + 1, y + 1, z), (x + 1, y + 1, z + 1), (x + 1, y, z + 1)]
        (fillOf col 72)]
  let sideY : List String :=
    if s (x, y + 1, z) then [] else
      [polygon [(x, y + 1, z), (x + 1, y + 1, z), (x + 1, y + 1, z + 1), (x, y + 1, z + 1)]
        (fillOf col 52)]
  top ++ sideX ++ sideY

/-- The occupied voxels of one keyframe, sorted back to front. -/
def isoOrdered (lift : ℤ) : List Vox :=
  (occupiedVoxels lift).mergeSort (fun a b => a.x + a.y + a.z ≤ b.x + b.y + b.z)

/-- Every visible face of the machine at one lift, painted back to front. -/
def isoFaces (lift : ℤ) : List String :=
  let s := machine ⟨lift, 0⟩
  (isoOrdered lift).flatMap (fun v => voxelFaces s (voxelColour lift v) v)

/-- The screen extent `(minX, minY, maxX, maxY)` of a list of lattice points,
with a three-voxel margin. -/
def isoExtent (pts : List (ℤ × ℤ)) : ℤ × ℤ × ℤ × ℤ :=
  let xs := pts.map (·.1)
  let ys := pts.map (·.2)
  ((xs.foldl min 0) - 3 * isoScale, (ys.foldl min 0) - 3 * isoScale,
    (xs.foldl max 0) + 3 * isoScale, (ys.foldl max 0) + 3 * isoScale)

/-- The opening tag and background of a picture of the given extent. -/
def isoHeader (e : ℤ × ℤ × ℤ × ℤ) : String :=
  let minX := e.1; let minY := e.2.1
  let w := e.2.2.1 - minX; let h := e.2.2.2 - minY
  "<svg xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"" ++ toString minX ++ " " ++
    toString minY ++ " " ++ toString w ++ " " ++ toString h ++ "\" width=\"" ++
    toString (w / 2) ++ "\" height=\"" ++ toString (h / 2) ++ "\">\n" ++
    "<rect x=\"" ++ toString minX ++ "\" y=\"" ++ toString minY ++ "\" width=\"" ++
    toString w ++ "\" height=\"" ++ toString h ++ "\" fill=\"rgb(245,245,240)\"/>"

/-- The caption of a frame. -/
def isoCaption (e : ℤ × ℤ × ℤ × ℤ) (lift : ℤ) : String :=
  "<text x=\"" ++ toString (e.1 + 12) ++ "\" y=\"" ++ toString (e.2.1 + 28) ++
    "\" font-family=\"sans-serif\" font-size=\"20\" fill=\"rgb(40,40,45)\">LifeTrac — lift " ++
    toString lift ++ " of " ++ toString liftMax ++ "</text>"

/-- The machine at one lift, as an isometric SVG. -/
def isoSvg (lift : ℤ) : String :=
  let e := isoExtent ((isoOrdered lift).map project)
  isoHeader e ++ "\n" ++ String.intercalate "\n" (isoFaces lift) ++ "\n" ++
    isoCaption e lift ++ "\n</svg>\n"

/-! ## The lift cycle, animated -/

/-- The keyframes of the animation: the loader goes up and comes back down. -/
def animLifts : List ℤ := keyLifts ++ (keyLifts.reverse.drop 1).dropLast

/-- `m` padded with leading zeros to three digits. -/
def pad3 (m : ℕ) : String :=
  let s := toString m
  "".pushn '0' (3 - s.length) ++ s

/-- The fraction `j / n` as a decimal string, for SVG `keyTimes`. -/
def fracStr (j n : ℕ) : String :=
  if j = 0 then "0" else if j = n then "1" else "0." ++ pad3 (j * 1000 / n)

/-- `0;0.125;…;1` for `n` slots. -/
def keyTimesStr (n : ℕ) : String :=
  String.intercalate ";" ((List.range (n + 1)).map (fun j => fracStr j n))

/-- The opacity of the frame drawn at lift `l` over the slots of the cycle. -/
def opacityValues (l : ℤ) : String :=
  let slots := animLifts.map (fun m => if m = l then "1" else "0")
  String.intercalate ";" (slots ++ [slots.headD "0"])

/-- The whole lift cycle as one animated isometric SVG: each keyframe is a
group, and the groups are switched on in turn. -/
def isoAnimSvg : String :=
  let e := isoExtent (keyLifts.flatMap (fun l => (isoOrdered l).map project))
  let n := animLifts.length
  let group := fun (l : ℤ) =>
    -- the first keyframe is the one a viewer that cannot animate will show
    "<g opacity=\"" ++ (if l = animLifts.headD 0 then "1" else "0") ++ "\">\n" ++
      "<animate attributeName=\"opacity\" calcMode=\"discrete\" " ++
      "values=\"" ++ opacityValues l ++ "\" keyTimes=\"" ++ keyTimesStr n ++
      "\" dur=\"4s\" repeatCount=\"indefinite\"/>\n" ++
      String.intercalate "\n" (isoFaces l) ++ "\n" ++ isoCaption e l ++ "\n</g>"
  isoHeader e ++ "\n" ++ String.intercalate "\n" (keyLifts.map group) ++ "\n</svg>\n"

end Voxel
end LifeTrac
