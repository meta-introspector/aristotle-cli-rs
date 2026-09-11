import RequestProject.Gvcs.Strategies
import RequestProject.Gvcs.Web.Html

/-!
# Pictures of the game, drawn from the play

Everything in this file is a function from a *position of the game* — an
`RState` that `Runtime.rstep` actually reached — to SVG source.  Nothing is
drawn by hand and nothing is drawn from a position the rule book did not
produce: the frames come from `Strategies.traceStates`, whose last state is the
one `rrun` ends on (`Strategies.traceStates_getLast`).

The file provides

* `frameSvg` — one frame: the head-up display, the yard with the machine, the
  shelf, the field, the script with a cursor on the move just played, and the
  cash curve so far;
* `storyboardSvg` — every frame of a play on one sheet;
* `animSvg` — the same frames as an animated SVG (SMIL), one after another,
  with the machine driving up and down the field;
* `compareSvg` — the cash of all the players against the calendar;
* `raceSvg` — an animated bar chart of the players' net worth.

`Media.lean` (`lake exe media`) writes them out.
-/

namespace LifeTrac
namespace Media

open Runtime Wasm Web Strategies

/-- A default position, so that the renderer can index into a trace. -/
instance : Inhabited RState := ⟨rstart⟩

/-! ## Text and shapes -/

/-- XML-escape a label. -/
def esc (s : String) : String :=
  s.foldl (fun acc c =>
    acc ++ (match c with
      | '&' => "&amp;"
      | '<' => "&lt;"
      | '>' => "&gt;"
      | '"' => "&quot;"
      | '\'' => "&apos;"
      | _ => c.toString)) ""

/-- An integer as a string, for attribute values. -/
def sn (n : Int) : String := toString n

/-- A thousandth, `0.xyz`, for `keyTimes`. -/
def frac3 (x : Int) : String :=
  let x := max 0 (min 999 x)
  "0." ++ (toString (1000 + x)).drop 1

/-- Digit groups: `1234567` as `1 234 567`. -/
def groups (n : Nat) : String :=
  let ds := (toString n).toList
  let l := ds.length
  String.join ((List.range l).map (fun k =>
    let c := ds[k]!.toString
    if k > 0 && (l - k) % 3 == 0 then " " ++ c else c))

/-- A micro-unit integer as a readable decimal with digit grouping. -/
def money (n : Int) : String :=
  let s := showMicro n
  match s.splitOn "." with
  | [] => s
  | w :: rest =>
      let neg := w.startsWith "-"
      let w' := if neg then w.drop 1 else w
      let head := (if neg then "-" else "") ++ groups w'.toNat!
      match rest with
      | [] => head
      | f :: _ => head ++ "." ++ f

/-- A rectangle. -/
def rect (x y w h : Int) (fill : String) (extra : String := "") : String :=
  "<rect x=\"" ++ sn x ++ "\" y=\"" ++ sn y ++ "\" width=\"" ++ sn w ++
  "\" height=\"" ++ sn h ++ "\" fill=\"" ++ fill ++ "\" " ++ extra ++ "/>"

/-- A rounded rectangle. -/
def rrect (x y w h r : Int) (fill : String) (extra : String := "") : String :=
  "<rect x=\"" ++ sn x ++ "\" y=\"" ++ sn y ++ "\" width=\"" ++ sn w ++
  "\" height=\"" ++ sn h ++ "\" rx=\"" ++ sn r ++ "\" fill=\"" ++ fill ++ "\" " ++ extra ++ "/>"

/-- A straight line. -/
def line (x1 y1 x2 y2 : Int) (col : String) (width : String := "1") : String :=
  "<line x1=\"" ++ sn x1 ++ "\" y1=\"" ++ sn y1 ++ "\" x2=\"" ++ sn x2 ++ "\" y2=\"" ++
  sn y2 ++ "\" stroke=\"" ++ col ++ "\" stroke-width=\"" ++ width ++ "\"/>"

/-- A line of text. -/
def text (x y size : Int) (fill : String) (s : String)
    (anchor : String := "start") (weight : String := "400") (mono : Bool := false) : String :=
  "<text x=\"" ++ sn x ++ "\" y=\"" ++ sn y ++ "\" font-size=\"" ++ sn size ++
  "\" fill=\"" ++ fill ++ "\" text-anchor=\"" ++ anchor ++ "\" font-weight=\"" ++ weight ++
  "\" font-family=\"" ++
  (if mono then "DejaVu Sans Mono, monospace" else "DejaVu Sans, Verdana, sans-serif") ++
  "\">" ++ esc s ++ "</text>"

/-- The `animate` element that shows the `k`th of `n` things during its share
of a cycle of `tenths` tenths of a second. -/
def slotAnim (k n : Nat) (tenths : Int) (attr : String := "opacity")
    (off : String := "0") (on : String := "1") : String :=
  if n ≤ 1 then "" else
  let t0 : Int := (k : Int) * 1000 / (n : Int)
  let t1 : Int := ((k : Int) + 1) * 1000 / (n : Int)
  let vals :=
    if k = 0 then on ++ ";" ++ off
    else if k + 1 = n then off ++ ";" ++ on
    else off ++ ";" ++ on ++ ";" ++ off
  let times :=
    if k = 0 then "0;" ++ frac3 t1
    else if k + 1 = n then "0;" ++ frac3 t0
    else "0;" ++ frac3 t0 ++ ";" ++ frac3 t1
  "<animate attributeName=\"" ++ attr ++ "\" values=\"" ++ vals ++ "\" keyTimes=\"" ++
  times ++ "\" calcMode=\"discrete\" dur=\"" ++ sn (tenths / 10) ++ "." ++
  sn (tenths % 10) ++ "s\" repeatCount=\"indefinite\"/>"

/-! ## The palette -/

/-- Page background. -/
def cBg : String := "#0e1512"
/-- Panel background. -/
def cPanel : String := "#16201b"
/-- Panel border. -/
def cLine : String := "#2b3a31"
/-- Body text. -/
def cText : String := "#e7f0e9"
/-- Secondary text. -/
def cMuted : String := "#8fa697"
/-- The green of a worked field. -/
def cGreen : String := "#79c98a"
/-- The gold of money. -/
def cGold : String := "#e8c46a"
/-- The blue of fuel. -/
def cBlue : String := "#6fb7e8"
/-- The red of a refused move. -/
def cRed : String := "#e0785f"
/-- Steel. -/
def cSteel : String := "#7f8d96"

/-- The colours the players are drawn in. -/
def playerColour : String → String
  | "ada" => cGold
  | "bo" => cBlue
  | "cleo" => "#d98cd0"
  | "dan" => "#f0a35a"
  | "eve" => cGreen
  | _ => cRed

/-- A panel with a title. -/
def panel (x y w h : Int) (title : String) (body : String) : String :=
  rrect x y w h 8 cPanel ("stroke=\"" ++ cLine ++ "\" stroke-width=\"1\"") ++
  text (x + 14) (y + 22) 13 cMuted title "start" "700" ++
  body

/-! ## Labels -/

/-- What the log calls a move. -/
def actionLabel : RAction → String
  | .buy m q => "buy " ++ toString q ++ " × " ++ matLabel m
  | .order a => "order kit · " ++ partLabel a
  | .sell m q => "sell " ++ toString q ++ " × " ++ matLabel m
  | .fabricate a => "build · " ++ partLabel a
  | .refuel l => "refuel " ++ toString l ++ " litres"
  | .farm c a => "farm " ++ toString a ++ " ha of " ++ cropLabel c

/-- The screen of the interface a move is made on. -/
def actionScreen : RAction → String
  | .buy _ _ | .order _ | .sell _ _ | .refuel _ => "MARKET"
  | .fabricate _ => "WORKBENCH"
  | .farm _ _ => "FIELD"

/-! ## The head-up display -/

/-- One reading of the head-up display. -/
def hudBox (x y w : Int) (label val unit colour : String) : String :=
  rrect x y w 62 6 "#1b2721" ("stroke=\"" ++ cLine ++ "\" stroke-width=\"1\"") ++
  text (x + 12) (y + 20) 11 cMuted label ++
  text (x + 12) (y + 46) 20 colour val "start" "700" ++
  text (x + w - 12) (y + 46) 10 cMuted unit "end"

/-- The head-up display of a position. -/
def hud (s : RState) : String :=
  let y : Int := 62
  hudBox 16 y 178 "CASH" (money s.cash) "units" cGold ++
  hudBox 204 y 178 "FUEL" (money s.fuel) "litres" cBlue ++
  hudBox 392 y 178 "DAY" (money s.day) "days" cText ++
  hudBox 580 y 178 "WORKED" (money s.hect) "hectares" cGreen ++
  hudBox 768 y 176 "NET WORTH" (money (rNetWorth s / SCALE)) "units" cGold

/-! ## The yard -/

/-- The machine, drawn in a 300 × 150 box.  `on` colours it in; an empty yard
shows the same outline in grey.  `inner` is dropped inside the group, for the
animation to hang off. -/
def tractorArt (on : Bool) (inner : String := "") : String :=
  let body := if on then "#c8531f" else "#243029"
  let dark := if on then "#93380f" else "#1d2822"
  let glass := if on then "#bfe4f2" else "#25322b"
  let tyre := if on then "#20262a" else "#1b2420"
  let rim := if on then cSteel else "#2b3a31"
  let stroke := "stroke=\"" ++ (if on then "#2b1a10" else cLine) ++ "\" stroke-width=\"2\""
  "<g>" ++ inner ++
    "<path d=\"M 150 62 L 60 40 L 34 52\" fill=\"none\" stroke=\"" ++ dark ++
      "\" stroke-width=\"9\" stroke-linejoin=\"round\" stroke-linecap=\"round\"/>" ++
    "<path d=\"M 40 44 L 16 52 L 26 88 L 62 78 Z\" fill=\"" ++ body ++ "\" " ++ stroke ++ "/>" ++
    rrect 92 62 176 42 6 body stroke ++
    rrect 176 24 78 42 5 body stroke ++
    rrect 186 32 58 26 3 glass ++
    rect 166 6 10 24 dark ++
    "<circle cx=\"128\" cy=\"112\" r=\"30\" fill=\"" ++ tyre ++ "\" stroke=\"" ++ rim ++
      "\" stroke-width=\"3\"/>" ++
    "<circle cx=\"128\" cy=\"112\" r=\"12\" fill=\"" ++ rim ++ "\"/>" ++
    "<circle cx=\"236\" cy=\"112\" r=\"30\" fill=\"" ++ tyre ++ "\" stroke=\"" ++ rim ++
      "\" stroke-width=\"3\"/>" ++
    "<circle cx=\"236\" cy=\"112\" r=\"12\" fill=\"" ++ rim ++ "\"/>" ++
  "</g>"

/-- The yard: the machine if it has been built, its ghost if it has not, and a
tally of what is on the stand. -/
def yardPanel (s : RState) : String :=
  let built := s.hasTractor
  let tally := String.intercalate "   " (allP.filterMap (fun p =>
    let n := s.built.count p
    if n = 0 then none else some (toString n ++ "× " ++ partLabel p)))
  panel 16 140 460 210 "YARD"
    ("<g transform=\"translate(96,176) scale(0.95)\">" ++ tractorArt built ++ "</g>" ++
      text 32 334 12 (if built then cGreen else cMuted)
        (if built then "LifeTrac · ready to work" else "no machine yet") "start" "700" ++
      text 220 334 10 cMuted tally)

/-! ## The shelf -/

/-- The shelf: one bar per material, filled to what the whole machine needs. -/
def shelfPanel (s : RState) : String :=
  let rows : List String := allM.map (fun m =>
    let k := idxM m
    let col : Int := if k < 12 then 0 else 1
    let row : Int := if k < 12 then k else k - 12
    let x : Int := 506 + col * 220
    let y : Int := 168 + row * 15
    let need := RPart.lifeTrac.req m
    let inStock := s.stock m
    let full : Int := if need ≤ 0 then 0 else min 88 (inStock * 88 / need)
    text x (y + 8) 9 cMuted (matLabel m) ++
    rect (x + 116) y 88 9 "#1e2a24" ++
    (if full > 0 then rect (x + 116) y full 9 (if full ≥ 88 then cGreen else cBlue) else ""))
  panel 492 140 452 210 "SHELF · against one machine's bill of materials"
    (String.join rows)

/-! ## The field -/

/-- The field: a hundred squares, shaded as they are worked, with the machine
driving up and down them in the animated version. -/
def fieldPanel (s : RState) (finalHect : Int) (moving : Bool) : String :=
  let perCell : Int := if finalHect ≤ 100 * SCALE then SCALE else (finalHect + 99 * SCALE) / 100
  let filled : Int := min 100 (s.hect / perCell)
  let cells : List String := (List.range 100).map (fun k =>
    let kk : Int := k
    let cx : Int := 30 + (kk % 50) * 17
    let cy : Int := 398 + (kk / 50) * 20
    rrect cx cy 14 16 2 (if kk < filled then cGreen else "#1d2a23")
      ("stroke=\"" ++ cLine ++ "\" stroke-width=\"1\""))
  let mover :=
    if moving && s.hasTractor then
      "<g transform=\"translate(24,384) scale(0.26)\">" ++
        tractorArt true
          ("<animateTransform attributeName=\"transform\" type=\"translate\" " ++
           "values=\"0,0; 2900,0; 2900,76; 0,76; 0,0\" keyTimes=\"0;0.45;0.5;0.95;1\" " ++
           "dur=\"6s\" repeatCount=\"indefinite\"/>") ++
      "</g>"
    else ""
  panel 16 368 928 100 "FIELD"
    (String.join cells ++ mover ++
      text 928 384 10 cMuted ("one square = " ++ money perCell ++ " ha") "end")

/-! ## The script and the chart -/

/-- The script, with the move just played under the cursor. -/
def movesPanel (script : List RAction) (played : Nat) (refusedAt : Option Nat) : String :=
  let n := script.length
  let shown := min 10 n
  let firstShown := if n ≤ 10 then 0 else min (n - 10) (max 5 played - 5)
  let rows : List String := (List.range shown).map (fun k =>
    let j := firstShown + k
    match script[j]? with
    | none => ""
    | some a =>
        let y : Int := 528 + (k : Int) * 17
        let isRefused := refusedAt = some j
        let done := j + 1 ≤ played
        let cur := j + 1 = played
        let col := if isRefused then cRed else if done then cText else cMuted
        (if cur then rrect 24 (y - 12) 444 17 3 "#23322b" else "") ++
        text 32 y 11 (if isRefused then cRed else if done then cGreen else cLine)
          (if isRefused then "✗" else if done then "✓" else "•") ++
        text 48 y 10 cMuted (toString (j + 1) ++ ".") ++
        text 72 y 11 col (actionLabel a) ++
        text 460 y 9 cMuted (actionScreen a) "end")
  panel 16 486 460 224 "SCRIPT"
    (String.join rows ++
      (if n > 10 then
        text 32 702 9 cMuted
          ("showing moves " ++ toString (firstShown + 1) ++ "–" ++ toString (firstShown + shown) ++
           " of " ++ toString n)
       else ""))

/-- The cash and net worth so far, as a chart. -/
def chartPanel (cash worth : List Int) : String :=
  let n := cash.length
  let hi := (cash ++ worth).foldl max 1
  let px : Int := 528
  let py : Int := 528
  let pw : Int := 384
  let ph : Int := 140
  let xy (l : List Int) (k : Nat) : Int × Int :=
    let v := l[k]!
    (px + (if n ≤ 1 then pw / 2 else (k : Int) * pw / ((n : Int) - 1)),
     py + ph - v * ph / hi)
  let poly (l : List Int) (col : String) : String :=
    "<polyline fill=\"none\" stroke=\"" ++ col ++ "\" stroke-width=\"2\" points=\"" ++
    String.intercalate " " ((List.range n).map (fun k =>
      let (x, y) := xy l k; sn x ++ "," ++ sn y)) ++ "\"/>" ++
    String.join ((List.range n).map (fun k =>
      let (x, y) := xy l k
      "<circle cx=\"" ++ sn x ++ "\" cy=\"" ++ sn y ++ "\" r=\"2.5\" fill=\"" ++ col ++ "\"/>"))
  panel 492 486 452 224 "CASH (gold) AND NET WORTH (green), MOVE BY MOVE"
    (String.join ((List.range 5).map (fun k =>
        line px (py + (k : Int) * ph / 4) (px + pw) (py + (k : Int) * ph / 4) cLine)) ++
      poly worth cGreen ++ poly cash cGold ++
      text (px + pw) (py - 8) 10 cMuted ("top of scale: " ++ money hi ++ " units") "end" ++
      text px 700 9 cMuted "one point per move played")

/-! ## A whole frame -/

/-- One frame of a play: the position, and everything on screen around it. -/
def frameBody (p : Player) (shotIdx total played : Nat) (last : Option RAction)
    (s : RState) (cash worth : List Int) (finalHect : Int) (refusedAt : Option Nat)
    (moving : Bool) : String :=
  rect 0 0 960 720 cBg ++
  rect 0 0 960 48 "#122a1e" ++
  text 16 31 18 cText "LifeTrac" "start" "700" ++
  text 100 31 12 cMuted "· the tractor game, played through the verified rule book" ++
  text 944 22 14 (playerColour p.key) p.name "end" "700" ++
  text 944 40 10 cMuted p.tagline "end" ++
  hud s ++
  (match last with
    | none => text 16 136 11 cMuted "opening position · nothing played yet"
    | some a =>
        text 16 136 11 cGreen
          ("move " ++ toString played ++ " of " ++ toString p.script.length ++ ": " ++
            actionLabel a)) ++
  yardPanel s ++
  shelfPanel s ++
  fieldPanel s finalHect moving ++
  movesPanel p.script played refusedAt ++
  chartPanel cash worth ++
  (match refusedAt with
    | some j =>
        rrect 290 236 380 96 8 "#2c1512" ("stroke=\"" ++ cRed ++ "\" stroke-width=\"2\"") ++
        text 480 272 16 cRed "MOVE REFUSED" "middle" "700" ++
        text 480 300 11 cText (actionLabel p.script[j]!) "middle" ++
        text 480 318 10 cMuted "rstep returns none: the position is unreachable" "middle"
    | none => "") ++
  text 16 716 9 cMuted
    ("frame " ++ toString (shotIdx + 1) ++ " of " ++ toString total ++
     " · drawn from RequestProject/Strategies.lean by `lake exe media`") ++
  text 944 716 9 cMuted
    "every figure on this frame comes from a state Runtime.rstep reached" "end"

/-- The SVG header. -/
def svgOpen (w h : Int) : String :=
  "<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"" ++ sn w ++ "\" height=\"" ++ sn h ++
  "\" viewBox=\"0 0 " ++ sn w ++ " " ++ sn h ++ "\">\n"

/-! ## The frames of a play -/

/-- One position of a play, with the move that produced it. -/
structure Shot where
  /-- Its place in the play. -/
  idx : Nat
  /-- The move that produced it, if any. -/
  last : Option RAction
  /-- The position itself. -/
  state : RState
  deriving Inhabited

/-- The positions a player passes through, as shots. -/
def shotsOf (p : Player) : List Shot :=
  let states := traceStates rstart p.script
  let moves := playedMoves rstart p.script
  (List.range states.length).map (fun k =>
    ⟨k, if k = 0 then none else moves[k - 1]?, states[k]!⟩)

/-- Where a play is stopped, if it is. -/
def refusalOf (p : Player) : Option Nat :=
  let played := (playedMoves rstart p.script).length
  if played < p.script.length then some played else none

/-- The last position a play reaches. -/
def finalOf (p : Player) : RState :=
  (traceStates rstart p.script).getLast!

/-- The frame at a given shot of a play. -/
def frameOf (p : Player) (k : Nat) (moving : Bool) : String :=
  let shots := shotsOf p
  let total := shots.length
  let sh := shots[k]!
  let cash := (shots.take (k + 1)).map (fun t => t.state.cash)
  let worth := (shots.take (k + 1)).map (fun t => rNetWorth t.state / SCALE)
  let refused := match refusalOf p with
    | some j => if k + 1 = total then some j else none
    | none => none
  frameBody p k total sh.idx sh.last sh.state cash worth (finalOf p).hect refused moving

/-- A frame as a standalone SVG. -/
def frameSvg (p : Player) (k : Nat) : String :=
  svgOpen 960 720 ++ frameOf p k false ++ "\n</svg>\n"

/-! ## The storyboard -/

/-- Every frame of a play on one sheet, two to a row. -/
def storyboardSvg (p : Player) : String :=
  let n := (shotsOf p).length
  let cols : Nat := 2
  let rows : Nat := (n + cols - 1) / cols
  let tw : Int := 600
  let th : Int := 450
  let w : Int := 60 + (cols : Int) * (tw + 24)
  let h : Int := 130 + (rows : Int) * (th + 24)
  svgOpen w h ++
  rect 0 0 w h cBg ++
  text 30 52 26 cText ("LifeTrac · " ++ p.name ++ "'s play, frame by frame") "start" "700" ++
  text 30 78 14 cMuted p.tagline ++
  text (w - 30) 52 12 cMuted
    (toString n ++ " positions · " ++ toString (playedMoves rstart p.script).length ++
     " of " ++ toString p.script.length ++ " moves allowed") "end" ++
  String.join ((List.range n).map (fun k =>
    let c : Int := (k % cols : Nat)
    let r : Int := (k / cols : Nat)
    let x : Int := 30 + c * (tw + 24)
    let y : Int := 110 + r * (th + 24)
    "<g transform=\"translate(" ++ sn x ++ "," ++ sn y ++ ") scale(0.625)\">" ++
      frameOf p k false ++ "</g>" ++
    rrect x y tw th 6 "none" ("stroke=\"" ++ cLine ++ "\" stroke-width=\"1\""))) ++
  "\n</svg>\n"

/-! ## The animation -/

/-- A play as an animated SVG: the frames in order, each held for `hold`
tenths of a second, looping for ever. -/
def animSvg (p : Player) (hold : Int := 18) : String :=
  let n := (shotsOf p).length
  let total := (n : Int) * hold
  svgOpen 960 720 ++
  rect 0 0 960 720 cBg ++
  String.join ((List.range n).map (fun k =>
    if n ≤ 1 then frameOf p k true
    else
      "<g opacity=\"" ++ (if k + 1 = n then "1" else "0") ++ "\">" ++
      slotAnim k n total ++ frameOf p k true ++ "</g>")) ++
  "\n</svg>\n"

/-! ## The players against each other -/

/-- A chart of `(x, y)` series, one to a player, each with its own dash
pattern so that players who play the same opening still show through each
other. -/
def xyChart (x0 y0 w h : Int) (title xlabel : String) (xIsMoney : Bool)
    (series : List (String × String × String × List (Int × Int))) : String :=
  let pointsAll : List (Int × Int) := series.flatMap (fun s => s.2.2.2)
  let maxX : Int := pointsAll.foldl (fun a q => max a q.1) 1
  let maxY : Int := pointsAll.foldl (fun a q => max a q.2) 1
  let px := x0 + 92
  let py := y0 + 40
  let pw := w - 120
  let ph := h - 92
  let sx (v : Int) : Int := px + v * pw / maxX
  let sy (v : Int) : Int := py + ph - v * ph / maxY
  panel x0 y0 w h title
    (String.join ((List.range 5).map (fun k =>
      let y := py + (k : Int) * ph / 4
      line px y (px + pw) y cLine ++
      text (px - 8) (y + 4) 9 cMuted (money ((4 - (k : Int)) * maxY / 4)) "end")) ++
     String.join ((List.range 5).map (fun k =>
      let x := px + (k : Int) * pw / 4
      let v := (k : Int) * maxX / 4
      line x (py + ph) x (py + ph + 5) cLine ++
      text x (py + ph + 18) 9 cMuted (if xIsMoney then money v else sn v) "middle")) ++
     text (px + pw / 2) (py + ph + 34) 10 cMuted xlabel "middle" ++
     String.join (series.map (fun (nm, col, dash, pts) =>
       "<polyline fill=\"none\" stroke=\"" ++ col ++ "\" stroke-width=\"2.5\"" ++
       (if dash = "" then "" else " stroke-dasharray=\"" ++ dash ++ "\"") ++
       " points=\"" ++
       String.intercalate " " (pts.map (fun q => sn (sx q.1) ++ "," ++ sn (sy q.2))) ++
       "\"/>" ++
       String.join (pts.map (fun q =>
         "<circle cx=\"" ++ sn (sx q.1) ++ "\" cy=\"" ++ sn (sy q.2) ++
         "\" r=\"3\" fill=\"" ++ col ++ "\"/>")) ++
       (match pts.getLast? with
        | none => ""
        | some q =>
            let far := sx q.1 > px + pw * 3 / 4
            text (if far then sx q.1 - 8 else sx q.1 + 8) (sy q.2 + 4) 11 col
              (nm ++ " · " ++ money q.2) (if far then "end" else "start") "700"))))

/-- The dash pattern a player's curve is drawn with. -/
def playerDash : String → String
  | "ada" => ""
  | "bo" => "9,5"
  | "cleo" => "3,4"
  | "dan" => "14,6"
  | "eve" => "2,6"
  | _ => "1,3"

/-- The final standings: cash and net worth, side by side. -/
def standings (x0 y0 w h : Int) : String :=
  let maxV := (players.map (fun p => rNetWorth (finalOf p) / SCALE)).foldl max 1
  let barX := x0 + 92
  let barW := w - 470
  panel x0 y0 w h "WHERE THEY FINISHED · cash (solid) inside net worth (outline)"
    (String.join ((List.range players.length).map (fun (k : Nat) =>
      let p := players[k]!
      let f := finalOf p
      let y := y0 + 44 + (k : Int) * 30
      let wCash := max 2 (f.cash * barW / maxV)
      let wWorth := max 2 (rNetWorth f / SCALE * barW / maxV)
      text (x0 + 20) (y + 15) 12 (playerColour p.key) p.name "start" "700" ++
      rrect barX y wWorth 20 3 "none"
        ("stroke=\"" ++ playerColour p.key ++ "\" stroke-width=\"1.5\"") ++
      rrect barX y wCash 20 3 (playerColour p.key) "fill-opacity=\"0.55\"" ++
      text (barX + barW + 14) (y + 15) 10 cText
        (money f.cash ++ " cash · " ++ money (rNetWorth f / SCALE) ++ " net worth · day " ++
          money f.day ++ " · " ++ money f.hect ++ " ha"))))

/-- The players against each other: cash move by move, and where they
finished. -/
def compareSvg : String :=
  let w : Int := 1040
  let h : Int := 700
  let curve (p : Player) : String × String × String × List (Int × Int) :=
    let sts := traceStates rstart p.script
    (p.name, playerColour p.key, playerDash p.key,
      (List.range sts.length).map (fun (k : Nat) => ((k : Int), sts[k]!.cash)))
  svgOpen w h ++
  rect 0 0 w h cBg ++
  text 30 44 22 cText "Six players, one rule book" "start" "700" ++
  text 30 68 12 cMuted
    "every point is a position Runtime.rstep reached; the dashes tell apart players who open alike" ++
  xyChart 20 88 (w - 40) 340 "CASH, MOVE BY MOVE" "moves played" false
    (players.map curve) ++
  standings 20 440 (w - 40) 236 ++
  "\n</svg>\n"

/-- An animated bar chart: the players' net worth, growing move by move.  A
viewer that does not animate shows the finish. -/
def raceSvg : String :=
  let ps := players
  let w : Int := 1000
  let h : Int := 470
  let steps := (ps.map (fun p => (traceStates rstart p.script).length)).foldl max 1
  let maxW := (ps.map (fun p => rNetWorth (finalOf p) / SCALE)).foldl max 1
  let hold : Int := 180
  let barX : Int := 250
  let barW : Int := 490
  let bars := (List.range ps.length).map (fun (k : Nat) =>
    let p := ps[k]!
    let y : Int := 118 + (k : Int) * 54
    let sts := traceStates rstart p.script
    let col := playerColour p.key
    let stAt (j : Nat) : RState := sts[min j (sts.length - 1)]!
    text 20 (y + 15) 13 (playerColour p.key) p.name "start" "700" ++
    text 20 (y + 30) 8 cMuted p.tagline ++
    rect barX y barW 32 "#1a2620" ++
    String.join ((List.range steps).map (fun j =>
      let v := max 2 (rNetWorth (stAt j) / SCALE * barW / maxW)
      "<g opacity=\"" ++ (if j + 1 = steps then "1" else "0") ++ "\">" ++
      slotAnim j steps hold ++
      rrect barX y v 32 3 col ++
      text (barX + v + 10) (y + 21) 11 cText
        (money (rNetWorth (stAt j) / SCALE) ++
          (if j + 1 > sts.length then " · finished" else "")) ++
      "</g>")))
  svgOpen w h ++
  rect 0 0 w h cBg ++
  text 30 44 22 cText "Net worth, move by move" "start" "700" ++
  text 30 68 12 cMuted
    "the six players replayed side by side; each bar is the net worth of the position after that move" ++
  text 30 90 10 cMuted
    ("full scale = " ++ money maxW ++ " units · a player who has finished holds the last position") ++
  String.join bars ++
  text 30 (h - 22) 10 cMuted
    "Fay never moves: the rule book refuses her first click, so her bar never leaves the opening position." ++
  "\n</svg>\n"

end Media
end LifeTrac
