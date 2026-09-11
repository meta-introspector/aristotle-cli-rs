import RequestProject.Gvcs.Printer.Gcode

/-!
# Watching the print happen

Pictures of the print of `RequestProject/Printer/SelfPrint.lean` in progress,
drawn from the toolpath itself: the state after `k` extrusions is the first `k`
voxels of `enum`, which is precisely what the interpreter has on the bed after
`k` extrusion instructions (`run_extrudes`).  Nothing is drawn by hand.

`frameSvg k` is the bed after `k` cells, with the cell just laid down marked in
orange; `progressSvg` is the whole print as one animated picture.
`lake exe printer` writes them out.
-/

namespace LifeTrac
namespace Printer

open Voxel

/-- Half the width of a cell on screen, in pixels. -/
def isoScale : ℤ := 8

/-- Isometric projection: `x` right and down, `y` left and down, `z` up. -/
def isoProject (v : Vox) : ℤ × ℤ :=
  ((v.x - v.y) * isoScale, (v.x + v.y) * (isoScale / 2) - v.z * isoScale)

/-- A point of an SVG polygon. -/
def isoPoint (p : ℤ × ℤ) : String := toString p.1 ++ "," ++ toString p.2

/-- One polygon of the picture. -/
def isoPolygon (pts : List Vox) (fill : String) : String :=
  "<polygon points=\"" ++ String.intercalate " " (pts.map fun v => isoPoint (isoProject v)) ++
    "\" fill=\"" ++ fill ++ "\" stroke=\"rgb(30,30,35)\" stroke-width=\"0.4\"/>"

/-- The three visible faces of one cell: top, then the two sides. -/
def cellFaces (v : Vox) (top side1 side2 : String) : List String :=
  let x := v.x; let y := v.y; let z := v.z
  [ isoPolygon [(x, y, z + 1), (x + 1, y, z + 1), (x + 1, y + 1, z + 1), (x, y + 1, z + 1)] top,
    isoPolygon [(x + 1, y, z), (x + 1, y + 1, z), (x + 1, y + 1, z + 1), (x + 1, y, z + 1)] side1,
    isoPolygon [(x, y + 1, z), (x + 1, y + 1, z), (x + 1, y + 1, z + 1), (x, y + 1, z + 1)] side2 ]

/-- Plastic already laid down. -/
def plasticFaces (v : Vox) : List String :=
  cellFaces v "rgb(110,190,130)" "rgb(80,140,95)" "rgb(58,102,70)"

/-- The cell the nozzle has just laid down. -/
def hotFaces (v : Vox) : List String :=
  cellFaces v "rgb(240,170,80)" "rgb(200,130,55)" "rgb(160,100,40)"

/-- The outline of the bed. -/
def bedFaces (e : Envelope) : String :=
  isoPolygon [(0, 0, 0), (e.sx, 0, 0), (e.sx, e.sy, 0), (0, e.sy, 0)] "rgb(48,58,54)"

/-- The screen extent of a list of points, with a margin. -/
def isoExtent (pts : List (ℤ × ℤ)) : ℤ × ℤ × ℤ × ℤ :=
  let xs := pts.map (·.1)
  let ys := pts.map (·.2)
  ((xs.foldl min 0) - 3 * isoScale, (ys.foldl min 0) - 4 * isoScale,
    (xs.foldl max 0) + 3 * isoScale, (ys.foldl max 0) + 3 * isoScale)

/-- The opening tag and background. -/
def isoHeader (e : ℤ × ℤ × ℤ × ℤ) : String :=
  let minX := e.1; let minY := e.2.1
  let w := e.2.2.1 - minX; let h := e.2.2.2 - minY
  "<svg xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"" ++ toString minX ++ " " ++
    toString minY ++ " " ++ toString w ++ " " ++ toString h ++ "\" width=\"" ++
    toString (w / 2) ++ "\" height=\"" ++ toString (h / 2) ++ "\">\n" ++
    "<rect x=\"" ++ toString minX ++ "\" y=\"" ++ toString minY ++ "\" width=\"" ++
    toString w ++ "\" height=\"" ++ toString h ++ "\" fill=\"rgb(14,21,18)\"/>"

/-- The caption of a frame. -/
def isoCaption (e : ℤ × ℤ × ℤ × ℤ) (k n : ℕ) : String :=
  "<text x=\"" ++ toString (e.1 + 12) ++ "\" y=\"" ++ toString (e.2.1 + 26) ++
    "\" font-family=\"sans-serif\" font-size=\"18\" fill=\"rgb(231,240,233)\">" ++
    toString k ++ " of " ++ toString n ++ " cells printed</text>"

/-- The full toolpath of the self-print job. -/
def selfPath : List Vox := enum d3d.env printerParts

/-- The cells on the bed after `k` extrusions, back to front. -/
def printedAfter (k : ℕ) : List Vox :=
  (selfPath.take k).mergeSort fun a b => a.x + a.y + a.z ≤ b.x + b.y + b.z

/-- The faces of the bed after `k` extrusions, the newest cell highlighted. -/
def frameFaces (k : ℕ) : List String :=
  let last := (selfPath.take k).getLast?
  bedFaces d3d.env ::
    (printedAfter k).flatMap fun v =>
      if some v = last then hotFaces v else plasticFaces v

/-- The extent that holds every frame. -/
def selfExtent : ℤ × ℤ × ℤ × ℤ :=
  isoExtent (((0, 0, 0) :: (d3d.env.sx, d3d.env.sy, 0) :: (d3d.env.sx, 0, 0) ::
    (0, d3d.env.sy, 0) :: selfPath).map isoProject)

/-- The bed after `k` cells, as an SVG. -/
def frameSvg (k : ℕ) : String :=
  isoHeader selfExtent ++ "\n" ++ String.intercalate "\n" (frameFaces k) ++ "\n" ++
    isoCaption selfExtent k selfPath.length ++ "\n</svg>\n"

/-- The progress points the animation steps through: every eighth of the job,
and the finished plate. -/
def frameSteps : List ℕ :=
  (List.range 9).map fun j => selfPath.length * j / 8

/-- `m` padded with leading zeros to three digits. -/
def pad3 (m : ℕ) : String :=
  let s := toString m
  "".pushn '0' (3 - s.length) ++ s

/-- The fraction `j / n` as a decimal string, for SVG `keyTimes`. -/
def fracStr (j n : ℕ) : String :=
  if j = 0 then "0" else if j = n then "1" else "0." ++ pad3 (j * 1000 / n)

/-- `0;0.125;…;1` for `n` slots. -/
def keyTimesStr (n : ℕ) : String :=
  String.intercalate ";" ((List.range (n + 1)).map fun j => fracStr j n)

/-- The opacity of the `i`-th frame over the slots of the animation. -/
def opacityValues (i n : ℕ) : String :=
  let slots := (List.range n).map fun j => if j = i then "1" else "0"
  String.intercalate ";" (slots ++ ["0"])

/-- **The print, from bare bed to finished plate**, as one animated SVG. -/
def progressSvg : String :=
  let n := frameSteps.length
  let group := fun (i : ℕ) (k : ℕ) =>
    "<g opacity=\"" ++ (if i = 0 then "1" else "0") ++ "\">\n" ++
      "<animate attributeName=\"opacity\" calcMode=\"discrete\" values=\"" ++
      opacityValues i n ++ "\" keyTimes=\"" ++ keyTimesStr n ++
      "\" dur=\"6s\" repeatCount=\"indefinite\"/>\n" ++
      String.intercalate "\n" (frameFaces k) ++ "\n" ++
      isoCaption selfExtent k selfPath.length ++ "\n</g>"
  isoHeader selfExtent ++ "\n" ++
    String.intercalate "\n" ((frameSteps.zipIdx.map fun (k, i) => group i k)) ++ "\n</svg>\n"

end Printer
end LifeTrac
