import RequestProject.Craft.Replicator

/-!
# Rendering and animating the replicator

The film of a replication, frame by frame, in three phases:

* **fabricating** — the machine runs one cycle per frame; the boxes on the floor
  fill up, one part at a time, until they hold exactly the copy's bill of materials;
* **assembling** — one part per frame leaves its box and is fitted into the copy;
  the boxes empty at exactly the rate the copy fills;
* **printing** — the copy stands beside the original, runs its press, and stacks up
  the deck it was built from, one tablet per frame.

Each frame is data (`Frame`), so the pictures can be checked rather than admired:

* `film_length` — how many frames a deck takes;
* `film_fab_step` — a fabrication frame adds exactly one part, the next one in the
  fabrication order, and changes nothing else;
* `film_asm_conserves` — during assembly nothing is created or destroyed: what is
  still in the boxes plus what is already installed is the full bill of materials;
* `film_asm_slots` — the elevation drawn at assembly frame `j` shows exactly `j`
  installed parts, and they are the first `j` parts of the fabrication order;
* `film_last` — the last frame has two machines standing and the whole deck printed;
* `boxStrip_faithful` — the strip of boxes drawn in a frame contains exactly the
  parts the frame says are on the floor, each counted once.

Both bodies are rendered: the fired-clay machine and **the pipe version**.
-/

namespace Replicate

open SelfCopy

/-! ## §1  Frames -/

inductive Phase | fabricating | assembling | printing
deriving DecidableEq, Repr

/-- One frame of the film. -/
structure Frame where
  /-- Which phase of the replication this frame belongs to. -/
  phase : Phase
  /-- The index of the frame inside its phase. -/
  step : Nat
  /-- What is in the boxes on the floor. -/
  boxes : Stock
  /-- What has been fitted into the copy. -/
  installed : Stock
  /-- The copy's elevation: one slot per part, `'.'` where the part is still missing. -/
  slots : List Char
  /-- The original machine's elevation: the same slots, all of them filled. -/
  origSlots : List Char
  /-- How many finished machines are standing. -/
  standing : Nat
  /-- The tablets printed so far. -/
  tablets : CardSet

/-- No part's glyph is the empty-slot marker, so a drawn slot is never ambiguous. -/
theorem glyph_ne_dot (p : Part) : Part.glyph p ≠ '.' := by cases p <;> decide

/-- The copy's elevation after `j` parts have been fitted. -/
def slotChars (order : List Part) (j : Nat) : List Char :=
  (order.take j).map Part.glyph ++ List.replicate (order.length - j) '.'

theorem slotChars_length {order : List Part} {j : Nat} (h : j ≤ order.length) :
    (slotChars order j).length = order.length := by
  simp [slotChars]
  omega

/-- **Exactly `j` parts are shown installed** at assembly frame `j`, and they are the
first `j` parts of the fabrication order. -/
theorem slotChars_filled (order : List Part) (j : Nat) :
    (slotChars order j).filter (fun c => decide (c ≠ '.')) = (order.take j).map Part.glyph := by
  simp only [slotChars, List.filter_append, List.filter_map]
  simp
  rw [List.filter_eq_self.mpr (by intro q _; simp [glyph_ne_dot q]), List.map_take]

/-! ## §2  The film -/

/-- The fabrication order of a deck: the parts, one by one, as they come off the
machine. -/
def order (cs : CardSet) : List Part := deckPartSeq cs

/-- The whole bill of materials of a deck, read off the fabrication order. -/
def fullStock (cs : CardSet) : Stock := fun p => countPart (order cs) p

theorem fullStock_eq (cs : CardSet) (p : Part) : fullStock cs p = deckBOM cs p :=
  countPart_deckPartSeq cs p

/-- What has been fabricated after `n` cycles never exceeds the full bill. -/
theorem fabricate_le_full (cs : CardSet) (n : Nat) (p : Part) :
    fabricate (order cs) n p ≤ fullStock cs p := by
  have : countPart (order cs) p =
      countPart ((order cs).take n) p + countPart ((order cs).drop n) p := by
    rw [← countPart_append, List.take_append_drop]
  simp only [fullStock, fabricate, this]
  omega

/-- Frame `i` of the fabrication phase: `i` parts made, nothing assembled yet. -/
def fabFrame (cs : CardSet) (i : Nat) : Frame :=
  { phase := .fabricating, step := i,
    boxes := fabricate (order cs) i, installed := Stock.empty,
    slots := List.replicate (order cs).length '.',
    origSlots := slotChars (order cs) (order cs).length, standing := 1, tablets := [] }

/-- Frame `j` of the assembly phase: `j` parts fitted, the rest still in their boxes. -/
def asmFrame (cs : CardSet) (j : Nat) : Frame :=
  { phase := .assembling, step := j,
    boxes := Stock.sub (fullStock cs) (fabricate (order cs) j),
    installed := fabricate (order cs) j,
    slots := slotChars (order cs) j,
    origSlots := slotChars (order cs) (order cs).length, standing := 1, tablets := [] }

/-- Frame `k` of the printing phase: the copy stands, and has printed `k` tablets. -/
def printFrame (cs : CardSet) (k : Nat) : Frame :=
  { phase := .printing, step := k,
    boxes := Stock.empty, installed := fullStock cs,
    slots := slotChars (order cs) (order cs).length,
    origSlots := slotChars (order cs) (order cs).length, standing := 2,
    tablets := cs.take k }

/-- **The film.**  Fabricate, assemble, print. -/
def film (cs : CardSet) : List Frame :=
  ((List.range ((order cs).length + 1)).map (fabFrame cs)) ++
  ((List.range ((order cs).length + 1)).map (asmFrame cs)) ++
  ((List.range (cs.length + 1)).map (printFrame cs))

/-- **Frame count.**  Two frames per part (one to make it, one to fit it), one per
tablet printed, plus the three still frames that open each phase. -/
theorem film_length (cs : CardSet) :
    (film cs).length = 2 * (order cs).length + cs.length + 3 := by
  simp [film]
  omega

/-- **One cycle, one part.**  Between consecutive fabrication frames exactly one part
appears — the next one in the fabrication order — and nothing else changes. -/
theorem film_fab_step (cs : CardSet) (i : Nat) (p : Part) :
    (fabFrame cs (i + 1)).boxes p =
      (fabFrame cs i).boxes p + (if (order cs)[i]? = some p then 1 else 0) :=
  fabricate_succ (order cs) i p

/-- **Assembly conserves parts.**  At every assembly frame, what is left in the boxes
plus what is already built into the copy is exactly the bill of materials. -/
theorem film_asm_conserves (cs : CardSet) (j : Nat) (p : Part) :
    (asmFrame cs j).boxes p + (asmFrame cs j).installed p = deckBOM cs p := by
  have h := fabricate_le_full cs j p
  simp only [asmFrame, Stock.sub, ← fullStock_eq]
  omega

/-- The elevation at assembly frame `j` shows exactly the `j` parts the frame says are
installed, in fabrication order. -/
theorem film_asm_slots (cs : CardSet) (j : Nat) :
    (asmFrame cs j).slots.filter (fun c => decide (c ≠ '.')) =
      ((order cs).take j).map Part.glyph :=
  slotChars_filled (order cs) j

/-- The copy is complete at the end of the assembly phase: every part is installed and
the floor is clear. -/
theorem film_asm_complete (cs : CardSet) (p : Part) :
    (asmFrame cs (order cs).length).installed p = deckBOM cs p ∧
    (asmFrame cs (order cs).length).boxes p = 0 := by
  have h : fabricate (order cs) (order cs).length p = deckBOM cs p := fabricate_deck cs p
  refine ⟨h, ?_⟩
  simp only [asmFrame, Stock.sub, h, ← fullStock_eq] at *
  omega

/-- **The last frame.**  Two machines standing and the whole deck printed: the
original, its copy, and the deck the copy made. -/
theorem film_last (cs : CardSet) : (film cs).getLast? = some (printFrame cs cs.length) := by
  simp [film, List.getLast?_append, List.getLast?_map, List.getLast?_range]

theorem film_last_standing (cs : CardSet) : (printFrame cs cs.length).standing = 2 := rfl

/-- **The copy is the original, drawn.**  In the last frame the two elevations are the
same list of characters slot for slot: what you see on the right is what you see on the
left. -/
theorem film_last_bodies_identical (cs : CardSet) :
    (printFrame cs cs.length).slots = (printFrame cs cs.length).origSlots := rfl

/-- What the copy printed in the last frame is the deck itself. -/
theorem film_last_tablets (cs : CardSet) : (printFrame cs cs.length).tablets = cs := by
  simp [printFrame]

/-! ## §3  Drawing a frame -/

private def padTo (s : String) (n : Nat) : String :=
  s ++ String.ofList (List.replicate (n - s.length) ' ')

/-- Pad or truncate to an exact width, so the ASCII boxes always line up. -/
private def fit (s : String) (n : Nat) : String :=
  if s.length ≤ n then padTo s n else String.ofList (s.toList.take n)

/-- The boxes drawn in a frame: one crate per part present, in `Part.all` order. -/
def boxStrip (f : Frame) : List Box := boxesOf f.boxes

/-- **The drawn boxes are faithful.**  The crates in the picture hold exactly the
parts the frame says are on the floor — none missing, none double-counted. -/
theorem boxStrip_faithful (f : Frame) (p : Part) : stockOfBoxes (boxStrip f) p = f.boxes p :=
  stockOfBoxes_boxesOf f.boxes p

private def chunkAux : Nat → Nat → List Char → List (List Char)
  | 0, _, _ => []
  | _ + 1, _, [] => []
  | fuel + 1, n, l => l.take (max n 1) :: chunkAux fuel n (l.drop (max n 1))

/-- Split a list into rows of a given width. -/
def chunk (n : Nat) (l : List Char) : List (List Char) := chunkAux l.length n l

/-- One crate, drawn. -/
def boxArt (b : Box) : List String :=
  let label := fit b.part.name 13
  ["+---------------+",
   "| " ++ label ++ " |",
   "| x" ++ fit (toString b.count) 12 ++ " |",
   "+---------------+"]

/-- Glue blocks of text side by side. -/
def beside (a b : List String) (gap : Nat) : List String :=
  let h := max a.length b.length
  let w := (a.map String.length).foldr max 0
  (List.range h).map (fun i =>
    padTo (a[i]?.getD "") (w + gap) ++ (b[i]?.getD ""))

/-- The row of crates on the floor. -/
def boxStripArt (f : Frame) : List String :=
  (boxStrip f).foldl (fun acc b => beside acc (boxArt b) 1) []

/-- The machine's elevation: the slot grid inside a housing. -/
def bodyArt (title : String) (slots : List Char) : List String :=
  let rows := chunk 6 slots
  let inner := 13
  let bar := "  +" ++ String.ofList (List.replicate inner '-') ++ "+"
  [bar, "  | " ++ fit title (inner - 2) ++ " |", bar] ++
  rows.map (fun r => "  | " ++ fit (String.ofList (r.intersperse ' ')) (inner - 2) ++ " |") ++
  [bar]

/-- A printed tablet, drawn small. -/
def tabletMini (c : Card) : String := "  [" ++ fit c.name 20 ++ "]"

/-- The title of a frame. -/
def frameCaption (f : Frame) : String :=
  match f.phase with
  | .fabricating => "fabricating  — cycle " ++ toString f.step
  | .assembling  => "assembling   — part  " ++ toString f.step
  | .printing    => "printing     — tablet " ++ toString f.step

/-- **Draw a frame** as an ASCII elevation: caption, machines standing, the copy under
construction, the crates on the floor, and the tablets printed so far. -/
def frameArt (title : String) (f : Frame) : String :=
  let machines :=
    if f.standing ≥ 2 then
      beside (bodyArt title f.origSlots) (bodyArt (title ++ " (copy)") f.slots) 3
    else
      bodyArt title f.origSlots
  let underway := if f.standing ≥ 2 then [] else bodyArt "copy" f.slots
  String.intercalate "\n"
    ([frameCaption f, ""] ++ machines ++ [""] ++ underway ++ [""] ++ boxStripArt f ++
     f.tablets.map tabletMini)

/-- The whole film, drawn. -/
def filmArt (title : String) (cs : CardSet) : String :=
  String.intercalate "\n\n" ((film cs).map (frameArt title))

/-! ## §4  SVG rendering, for the animated page -/

private def esc (s : String) : String :=
  (s.replace "&" "&amp;").replace "<" "&lt;" |>.replace ">" "&gt;"

private def rect (x y w h : Nat) (cls : String) : String :=
  "<rect x='" ++ toString x ++ "' y='" ++ toString y ++ "' width='" ++ toString w ++
  "' height='" ++ toString h ++ "' class='" ++ cls ++ "'/>"

private def text (x y : Nat) (cls s : String) : String :=
  "<text x='" ++ toString x ++ "' y='" ++ toString y ++ "' class='" ++ cls ++ "'>" ++
  esc s ++ "</text>"

/-- One installed-or-missing slot, as a small square. -/
private def slotSvg (x y : Nat) (c : Char) : String :=
  if c = '.' then rect x y 14 14 "slot empty"
  else rect x y 14 14 "slot filled"

/-- Draw a machine body at `(x, y)`: a housing and its grid of part slots. -/
def bodySvg (x y : Nat) (title : String) (slots : List Char) : String :=
  let rows := chunk 6 slots
  let cells := (rows.zipIdx.map (fun (r, ri) =>
      String.join ((r.zipIdx.map (fun (c, ci) =>
        slotSvg (x + 10 + 18 * ci) (y + 30 + 18 * ri) c)))))
  rect x y 130 (40 + 18 * rows.length) "body" ++
  text (x + 8) (y + 18) "label" title ++ String.join cells

/-- Draw the crates of a frame. -/
def boxesSvg (x y : Nat) (f : Frame) : String :=
  String.join ((boxStrip f).zipIdx.map (fun (b, i) =>
    rect (x + 90 * i) y 80 46 "crate" ++
    text (x + 90 * i + 6) (y + 18) "small" b.part.name ++
    text (x + 90 * i + 6) (y + 36) "count" ("x" ++ toString b.count)))

/-- Draw the tablets the copy has printed. -/
def tabletsSvg (x y : Nat) (f : Frame) : String :=
  String.join (f.tablets.zipIdx.map (fun (c, i) =>
    rect x (y + 34 * i) 210 28 "tablet" ++ text (x + 8) (y + 34 * i + 19) "small" c.name))

/-- **One frame of the animation, as an SVG group.** -/
def frameSvg (title : String) (f : Frame) : String :=
  let orig := bodySvg 20 60 title f.origSlots
  let copyBody :=
    if f.standing ≥ 2 then bodySvg 190 60 (title ++ " · copy") f.slots
    else bodySvg 190 60 "copy (assembling)" f.slots
  "<g class='frame'>" ++
  text 20 30 "caption" (frameCaption f) ++
  orig ++ copyBody ++ boxesSvg 20 240 f ++ tabletsSvg 390 60 f ++
  "</g>"

/-- The whole film as a list of SVG groups. -/
def filmSvg (title : String) (cs : CardSet) : List String :=
  (film cs).map (frameSvg title)

/-! ## §5  Evaluation: show it -/

section Eval

-- The clay machine, its parts, its assembly, its copy.
#eval IO.println (filmArt "clay press" monogram)

-- The pipe version.
#eval IO.println (filmArt "pipe press" pipeMonogram)

-- The three-machine pipe network, last frame only: two networks standing and the
-- whole deck printed.
#eval IO.println (frameArt "pipe works" (printFrame pipeWorks pipeWorks.length))

#eval ((film monogram).length, (film pipeMonogram).length, (film pipeWorks).length)
#eval (filmSvg "clay press" monogram).length

end Eval

end Replicate
