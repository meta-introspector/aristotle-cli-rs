import RequestProject.Gvcs.VoxelGame.Play
import RequestProject.Gvcs.Voxel.Render

/-!
# Drawing the voxel world

`RequestProject/Voxel/Render.lean` draws the machine: every occupied voxel
contributes the faces of its cube that no neighbour hides, painted back to
front.  Nothing about that is special to the machine — it only needs to know
where there is material and what colour it is — so this file lifts the same
renderer from a `Solid` to a `World`, which is a solid that also says *what*
each voxel is.

* `cellColour` — what each kind of cell looks like; a `body` voxel takes the
  colour the body already has in `Voxel/Parts.lean`, so the tractor looks the
  same in the game as in the model;
* `worldVoxels`, `worldFaces`, `worldSvg` — the picture, drawn straight from
  the occupancy function of the world;
* `worldJson` — the same window as plain data, for a shell that wants to build
  the world out of its own parts (the Roblox and browser clients of
  `GAMEPLAN.md`).
-/

namespace LifeTrac
namespace VoxelGame

open Voxel
open Build

/-! ## Colours -/

/-- Soil brown. -/
def soilC : Colour := ⟨122, 88, 58⟩
/-- Topsoil green. -/
def grassC : Colour := ⟨96, 148, 74⟩
/-- Bedrock. -/
def rockC : Colour := ⟨118, 118, 124⟩
/-- Ore. -/
def oreC : Colour := ⟨163, 116, 74⟩
/-- Water. -/
def waterC : Colour := ⟨74, 122, 196⟩
/-- Ripe crop. -/
def cropC : Colour := ⟨214, 178, 72⟩
/-- A pile of stock in the yard. -/
def stockC : Colour := ⟨150, 152, 158⟩
/-- A finished subassembly in the shed. -/
def shedC : Colour := ⟨188, 138, 68⟩
/-- Fuel. -/
def fuelC : Colour := ⟨198, 92, 44⟩
/-- Money. -/
def coinC : Colour := ⟨226, 190, 62⟩
/-- A creative-mode brick. -/
def brickC : Colour := ⟨86, 158, 196⟩

/-- The colour a body of the machine is drawn in, as `Voxel/Parts.lean` gives
it. -/
def bodyColour (nm : String) : Colour :=
  match bodies.find? (fun b => b.name == nm) with
  | some b => b.colour
  | none => steelC

/-- What each kind of voxel looks like. -/
def cellColour : Cell → Colour
  | .air => ⟨0, 0, 0⟩
  | .soil => soilC
  | .grass => grassC
  | .rock => rockC
  | .ore => oreC
  | .water => waterC
  | .crop _ => cropC
  | .stock _ => stockC
  | .shed _ => shedC
  | .body nm => bodyColour nm
  | .fuel => fuelC
  | .coin => coinC
  | .brick _ => brickC

/-- The name of a kind of voxel, for the data dump. -/
def cellName : Cell → String
  | .air => "air"
  | .soil => "soil"
  | .grass => "grass"
  | .rock => "rock"
  | .ore => "ore"
  | .water => "water"
  | .crop _ => "crop"
  | .stock m => "stock:" ++ reprStr m
  | .shed nm => "shed:" ++ nm
  | .body nm => "body:" ++ nm
  | .fuel => "fuel"
  | .coin => "coin"
  | .brick _ => "brick"

/-! ## The picture -/

/-- The occupied voxels of a world inside a window. -/
def worldVoxels (w : World) (lo hi : Vox) : List Vox :=
  (rowList lo.x hi.x).flatMap (fun x =>
    (rowList lo.y hi.y).flatMap (fun y =>
      (rowList lo.z hi.z).filterMap (fun z =>
        if w (x, y, z) = .air then none else some (x, y, z))))

theorem mem_worldVoxels {w : World} {lo hi v : Vox} :
    v ∈ worldVoxels w lo hi ↔
      ((lo.x ≤ v.x ∧ v.x ≤ hi.x) ∧ (lo.y ≤ v.y ∧ v.y ≤ hi.y) ∧
        (lo.z ≤ v.z ∧ v.z ≤ hi.z) ∧ w v ≠ .air) := by
  simp only [worldVoxels, List.mem_flatMap, List.mem_filterMap, mem_rowList]
  constructor
  · rintro ⟨x, hx, y, hy, z, hz, hv⟩
    by_cases h : w (x, y, z) = .air
    · rw [if_pos h] at hv; exact absurd hv (by simp)
    · rw [if_neg h] at hv
      cases hv
      exact ⟨hx, hy, hz, h⟩
  · rintro ⟨hx, hy, hz, hv⟩
    refine ⟨v.x, hx, v.y, hy, v.z, hz, ?_⟩
    have hvv : ((v.x, v.y, v.z) : Vox) = v := rfl
    rw [hvv, if_neg hv]

/-- The occupied voxels of several windows.  A world is mostly air and its
districts are far apart, so a picture is drawn from a few tight windows rather
than from one enormous one. -/
def worldVoxelsIn (w : World) (boxes : List (Vox × Vox)) : List Vox :=
  boxes.flatMap (fun b => worldVoxels w b.1 b.2)

theorem mem_worldVoxelsIn {w : World} {boxes : List (Vox × Vox)} {v : Vox} :
    v ∈ worldVoxelsIn w boxes ↔
      ∃ b ∈ boxes, ((b.1.x ≤ v.x ∧ v.x ≤ b.2.x) ∧ (b.1.y ≤ v.y ∧ v.y ≤ b.2.y) ∧
        (b.1.z ≤ v.z ∧ v.z ≤ b.2.z) ∧ w v ≠ .air) := by
  simp only [worldVoxelsIn, List.mem_flatMap, mem_worldVoxels]

/-- The occupied voxels of a window, sorted back to front. -/
def worldOrdered (w : World) (lo hi : Vox) : List Vox :=
  (worldVoxels w lo hi).mergeSort (fun a b => a.x + a.y + a.z ≤ b.x + b.y + b.z)

/-- The occupied voxels of several windows, sorted back to front. -/
def worldOrderedIn (w : World) (boxes : List (Vox × Vox)) : List Vox :=
  (worldVoxelsIn w boxes).mergeSort (fun a b => a.x + a.y + a.z ≤ b.x + b.y + b.z)

/-- Every visible face of a world in a window, painted back to front. -/
def worldFaces (w : World) (lo hi : Vox) : List String :=
  let s := World.solid w
  (worldOrdered w lo hi).flatMap (fun v => voxelFaces s (cellColour (w v)) v)

/-- A caption for the picture. -/
def worldCaption (e : ℤ × ℤ × ℤ × ℤ) (text : String) : String :=
  "<text x=\"" ++ toString (e.1 + 12) ++ "\" y=\"" ++ toString (e.2.1 + 28) ++
    "\" font-family=\"sans-serif\" font-size=\"20\" fill=\"rgb(40,40,45)\">" ++ text ++ "</text>"

/-- A world in a window, as an isometric SVG. -/
def worldSvg (text : String) (w : World) (lo hi : Vox) : String :=
  let vs := worldOrdered w lo hi
  let e := isoExtent (vs.map project)
  let s := World.solid w
  isoHeader e ++ "\n" ++
    String.intercalate "\n" (vs.flatMap (fun v => voxelFaces s (cellColour (w v)) v)) ++
    "\n" ++ worldCaption e text ++ "\n</svg>\n"

/-- Several windows of a world, as one isometric SVG. -/
def worldSvgIn (text : String) (w : World) (boxes : List (Vox × Vox)) : String :=
  let vs := worldOrderedIn w boxes
  let e := isoExtent (vs.map project)
  let s := World.solid w
  isoHeader e ++ "\n" ++
    String.intercalate "\n" (vs.flatMap (fun v => voxelFaces s (cellColour (w v)) v)) ++
    "\n" ++ worldCaption e text ++ "\n</svg>\n"

/-- One voxel of the world, as JSON. -/
def cellJson (w : World) (v : Vox) : String :=
  "[" ++ toString v.x ++ "," ++ toString v.y ++ "," ++ toString v.z ++ ",\"" ++
    cellName (w v) ++ "\"]"

/-- A window of the world, as plain data: the same list the picture is drawn
from, for a shell that builds its own parts. -/
def worldJson (w : World) (lo hi : Vox) : String :=
  "[" ++ String.intercalate ",\n " ((worldVoxels w lo hi).map (cellJson w)) ++ "]"

/-- Several windows of the world, as plain data. -/
def worldJsonIn (w : World) (boxes : List (Vox × Vox)) : String :=
  "[" ++ String.intercalate ",\n " ((worldVoxelsIn w boxes).map (cellJson w)) ++ "]"

end VoxelGame
end LifeTrac
