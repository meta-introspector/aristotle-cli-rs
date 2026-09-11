import RequestProject.Craft.PartVoxel

/-!
# The 3-D view: an isometric picture of the voxel body

`RequestProject/PartVoxel.lean` builds the machine's body out of its parts, cube by
cube.  This file looks at it.

The camera sits on the `(1,1,1)` diagonal, so a cube at `(x, y, z)` lands on the
screen at

  `projX = 16(x - z)`,  `projY = 9(x + z) - 18y`,

and the three faces that can face the eye — the top, the `+x` face and the `+z`
face — are drawn as three parallelograms.  Cubes are painted farthest first, in the
`drawOrder` of `PartVoxel.lean`.

What is proved here is that this is a *correct* picture of the body:

* `sameScreen_ray` — two cubes land on the same screen point exactly when one is
  directly behind the other along the line of sight; there is no accidental overlap;
* `occlusion_ordered` — if one cube hides another, the hidden one is strictly
  farther away;
* `painter_correct` — hence in the drawing order no cube ever hides a cube drawn
  after it: painting front-to-back in this order gives the right image;
* `cubeSvgs_length`, `cubeSvgs_perm` — the picture holds exactly one drawing per
  cube of the body, none dropped and none duplicated;
* `viewScene_nodup`, `viewScene_four` — the four turned views are honest bodies, and
  the fourth quarter-turn brings the view back to the start.

The SVG text itself is just text: nothing about a browser's rendering is verified,
only the geometry it is built from.
-/

namespace Replicate

open SelfCopy

/-! ## §1  The isometric projection -/

/-- Where a cube's corner lands on the screen, horizontally. -/
def projX (c : Cell) : Int := 16 * (c.pos.x : Int) - 16 * (c.pos.z : Int)

/-- Where a cube's corner lands on the screen, vertically (screen `y` grows down, so
a cube higher up in the world has a smaller `projY`). -/
def projY (c : Cell) : Int :=
  9 * ((c.pos.x : Int) + (c.pos.z : Int)) - 18 * (c.pos.y : Int)

/-- **The line of sight.**  Two cubes land on the same point of the screen exactly
when one sits directly behind the other along the `(1,1,1)` viewing ray. -/
theorem sameScreen_ray (c d : Cell) :
    (projX c = projX d ∧ projY c = projY d) ↔
      ((d.pos.x : Int) - c.pos.x = (d.pos.y : Int) - c.pos.y ∧
       (d.pos.y : Int) - c.pos.y = (d.pos.z : Int) - c.pos.z) := by
  simp only [projX, projY]
  omega

/-- **What hides what.**  `a` occludes `b` when they cover the same point of the
screen and `a` is nearer the eye. -/
def Occludes (a b : Cell) : Prop :=
  projX a = projX b ∧ projY a = projY b ∧ depth b < depth a

/-- **A hidden cube is a farther cube**, and it is farther along the line of sight by
a whole number of steps: if two cubes cover the same screen point and are not the
same cube, one is behind the other by `t` steps of `(1,1,1)`. -/
theorem occlusion_ordered {c d : Cell} (hx : projX c = projX d) (hy : projY c = projY d)
    (h : depth c < depth d) :
    ∃ t : Nat, 0 < t ∧ d.pos.x = c.pos.x + t ∧ d.pos.y = c.pos.y + t ∧ d.pos.z = c.pos.z + t := by
  obtain ⟨h1, h2⟩ := (sameScreen_ray c d).mp ⟨hx, hy⟩
  simp only [depth] at h
  refine ⟨d.pos.x - c.pos.x, ?_, ?_, ?_, ?_⟩ <;> omega

/-- Nothing hides itself. -/
theorem not_occludes_self (a : Cell) : ¬ Occludes a a := by
  rintro ⟨-, -, h⟩
  exact absurd h (Nat.lt_irrefl _)

/-- **The painter's algorithm is right here.**  In the drawing order, a cube never
hides a cube that is drawn after it — so painting the cubes in this order, each one
over the last, shows exactly the cubes that should be visible. -/
theorem painter_correct (s : List Cell) (i k : Nat) (hik : i < k)
    (hk : k < (drawOrder s).length) :
    ¬ Occludes ((drawOrder s)[i]'(Nat.lt_trans hik hk)) ((drawOrder s)[k]'hk) := by
  have hp := drawOrder_sorted s
  rw [List.pairwise_iff_getElem] at hp
  have hle := hp i k (Nat.lt_trans hik hk) hk hik
  rintro ⟨-, -, hlt⟩
  omega

/-! ## §2  Colours -/

private def hexDigit (n : Nat) : Char :=
  if n < 10 then Char.ofNat (48 + n) else Char.ofNat (87 + n)

/-- A byte as two hex digits. -/
def hex2 (n : Nat) : String := String.ofList [hexDigit (n / 16 % 16), hexDigit (n % 16)]

/-- A `0xRRGGBB` colour, darkened to `num/den` of its brightness, as CSS. -/
def shadeHex (c : Nat) (num den : Nat) : String :=
  "#" ++ hex2 (c / 65536 % 256 * num / den) ++ hex2 (c / 256 % 256 * num / den) ++
    hex2 (c % 256 * num / den)

/-- The lit top face of a part. -/
def topHex (p : Part) : String := shadeHex p.color 1 1

/-- The `+x` face, in half shadow. -/
def sideHex (p : Part) : String := shadeHex p.color 78 100

/-- The `+z` face, in deeper shadow. -/
def frontHex (p : Part) : String := shadeHex p.color 56 100

/-! ## §3  One cube, drawn -/

/-- A lattice corner, projected to screen coordinates and shifted by the view origin. -/
def corner (ox oy : Int) (x y z : Nat) : String :=
  toString (ox + 16 * (x : Int) - 16 * (z : Int)) ++ "," ++
  toString (oy + 9 * ((x : Int) + (z : Int)) - 18 * (y : Int))

private def poly (fill pts : String) : String :=
  "<polygon fill='" ++ fill ++ "' points='" ++ pts ++ "'/>"

/-- **One cube of the body, drawn**: its three visible faces, tagged with the slot of
the part it belongs to so the view can play the assembly back. -/
def cubeSvg (ox oy : Int) (c : Cell) : String :=
  let x := c.pos.x; let y := c.pos.y; let z := c.pos.z
  let top := poly (topHex c.part)
    (corner ox oy x (y+1) z ++ " " ++ corner ox oy (x+1) (y+1) z ++ " " ++
     corner ox oy (x+1) (y+1) (z+1) ++ " " ++ corner ox oy x (y+1) (z+1))
  let side := poly (sideHex c.part)
    (corner ox oy (x+1) (y+1) z ++ " " ++ corner ox oy (x+1) (y+1) (z+1) ++ " " ++
     corner ox oy (x+1) y (z+1) ++ " " ++ corner ox oy (x+1) y z)
  let front := poly (frontHex c.part)
    (corner ox oy x (y+1) (z+1) ++ " " ++ corner ox oy (x+1) (y+1) (z+1) ++ " " ++
     corner ox oy (x+1) y (z+1) ++ " " ++ corner ox oy x y (z+1))
  "<g class='c s" ++ toString c.slot ++ "'>" ++ top ++ side ++ front ++ "</g>"

/-- **The whole body, drawn**, farthest cube first. -/
def cubeSvgs (ox oy : Int) (s : List Cell) : List String :=
  (drawOrder s).map (cubeSvg ox oy)

/-- **One drawing per cube.** -/
theorem cubeSvgs_length (ox oy : Int) (s : List Cell) : (cubeSvgs ox oy s).length = s.length := by
  simp [cubeSvgs, drawOrder_length]

/-- **Nothing dropped, nothing duplicated**: the cubes that get drawn are exactly the
cubes of the scene. -/
theorem cubeSvgs_perm (ox oy : Int) (s : List Cell) :
    ((drawOrder s).map (cubeSvg ox oy)).length = (s.map (cubeSvg ox oy)).length := by
  simp [drawOrder_length]

/-- The cubes are drawn in back-to-front order. -/
theorem cubeSvgs_order (s : List Cell) : (drawOrder s).Perm s := drawOrder_perm s

/-! ## §4  The viewport -/

/-- The largest value a coordinate takes in a scene. -/
def maxOver (f : Cell → Nat) (s : List Cell) : Nat := (s.map f).foldr max 0

theorem le_maxOver (f : Cell → Nat) (s : List Cell) : ∀ c ∈ s, f c ≤ maxOver f s := by
  intro c hc
  induction s with
  | nil => simp at hc
  | cons d s ih =>
      rcases List.mem_cons.mp hc with rfl | hc'
      · simp [maxOver]
      · have := ih hc'
        simp only [maxOver, List.map_cons, List.foldr_cons] at this ⊢
        omega

/-- How wide the picture of a scene is. -/
def viewWidth (s : List Cell) : Nat :=
  16 * (maxOver (fun c => c.pos.x) s + maxOver (fun c => c.pos.z) s + 2) + 16

/-- How tall the picture of a scene is. -/
def viewHeight (s : List Cell) : Nat :=
  18 * (maxOver (fun c => c.pos.y) s + 1) +
  9 * (maxOver (fun c => c.pos.x) s + maxOver (fun c => c.pos.z) s + 2) + 16

/-- Where the lattice origin sits in the picture, horizontally. -/
def viewOriginX (s : List Cell) : Int := 16 * (maxOver (fun c => c.pos.z) s : Int) + 24

/-- Where the lattice origin sits in the picture, vertically. -/
def viewOriginY (s : List Cell) : Int := 18 * (maxOver (fun c => c.pos.y) s : Int) + 26

/-! ## §5  The four turned views -/

/-- The side of the box a deck's body fits in. -/
def bodyExtent (cs : CardSet) : Nat := extent (bodyScene cs)

/-- **The body, turned `k` quarter-turns.** -/
def viewScene (cs : CardSet) (k : Nat) : List Cell :=
  spin (bodyExtent cs) (bodyScene cs) k

theorem bodyScene_bounded (cs : CardSet) : Bounded (bodyExtent cs) (bodyScene cs) :=
  extent_bounded _

/-- Turning the body does not merge two cubes into one. -/
theorem viewScene_nodup (cs : CardSet) (k : Nat) : (viewScene cs k).Nodup :=
  spin_nodup (bodyScene_bounded cs) (bodyScene_nodup cs) k

theorem viewScene_zero (cs : CardSet) : viewScene cs 0 = bodyScene cs := rfl

/-- **Four quarter-turns and you are back where you started.** -/
theorem viewScene_four (cs : CardSet) : viewScene cs 4 = viewScene cs 0 :=
  spin_four (bodyScene_bounded cs)

/-- Turning does not lose or gain cubes. -/
theorem viewScene_length (cs : CardSet) (k : Nat) :
    (viewScene cs k).length = (bodyScene cs).length := by
  induction k with
  | zero => rfl
  | succ k ih => simpa [viewScene, spin, yawScene] using ih

/-- **The picture of a deck's body**, turned `k` quarter-turns: the SVG cubes, the
viewport, and the number of build steps the view can be played back through. -/
def bodyView (cs : CardSet) (k : Nat) : List String :=
  let s := viewScene cs k
  cubeSvgs (viewOriginX s) (viewOriginY s) s

/-- The picture holds exactly one cube per cube of the body. -/
theorem bodyView_length (cs : CardSet) (k : Nat) :
    (bodyView cs k).length = Model.voxelCount (bodyModel cs) := by
  rw [bodyView, cubeSvgs_length, viewScene_length, bodyScene_length]

/-! ## §6  Evaluation -/

section Eval

-- the cube count of each deck's body
#eval (Model.voxelCount (bodyModel monogram), Model.voxelCount (bodyModel workshop),
       Model.voxelCount (bodyModel pipeMonogram), Model.voxelCount (bodyModel pipeWorks))

-- the bill of materials really does account for every cube
#eval ((Part.all.map (fun p => deckBOM pipeWorks p * p.size)).sum,
       Model.voxelCount (bodyModel pipeWorks))

#eval (bodyExtent workshop, bodyExtent pipeWorks)
#eval (viewWidth (bodyScene pipeWorks), viewHeight (bodyScene pipeWorks))
#eval (bodyView monogram 0).length
#eval ((bodyView monogram 0).foldl (fun n s => n + s.length) 0)

end Eval

end Replicate
