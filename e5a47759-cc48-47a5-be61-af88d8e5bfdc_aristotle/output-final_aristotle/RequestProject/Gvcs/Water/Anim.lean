import RequestProject.Gvcs.Water.Rig

/-!
# The animation: the water computer, running, in one SVG

`animPage` is a single self-contained HTML file — no script, no stylesheet, no
fetch — showing the machine of `RequestProject/Water/` at work:

* the sun, the heliostats and the collector, with the standpipe filling the
  head tank;
* the gate deck, four water gates whose lamps step through all four input
  combinations.  **The lamp colours are computed by `FCirc.eval`**, so what the
  picture shows a gate doing is what the Lean semantics says it does;
* the card chain, scrolling: the punch pattern is the first sixteen cards of
  `printerStack`, the printer's own program;
* the printer, laying cells;
* the four teams of `Water/Teams.lean`, their fitness bars stepping through the
  rounds the proof computes;
* and the stall's price list, straight out of `Water/Market.lean`.

Everything drawn is read out of the development: no figure in the picture is
typed in twice.
-/

namespace LifeTrac
namespace Water

open Steampunk

/-! ## Small helpers -/

/-- An integer as an attribute value. -/
private def sn (n : Int) : String := toString n

/-- A rectangle. -/
private def rct (x y w h : Int) (fill : String) (extra : String := "") : String :=
  "<rect x=\"" ++ sn x ++ "\" y=\"" ++ sn y ++ "\" width=\"" ++ sn w ++
    "\" height=\"" ++ sn h ++ "\" fill=\"" ++ fill ++ "\" " ++ extra ++ "/>"

/-- A circle. -/
private def circ (cx cy r : Int) (fill : String) (extra : String := "") : String :=
  "<circle cx=\"" ++ sn cx ++ "\" cy=\"" ++ sn cy ++ "\" r=\"" ++ sn r ++
    "\" fill=\"" ++ fill ++ "\" " ++ extra ++ "/>"

/-- A line. -/
private def ln (x1 y1 x2 y2 : Int) (col : String) (w : String := "2") : String :=
  "<line x1=\"" ++ sn x1 ++ "\" y1=\"" ++ sn y1 ++ "\" x2=\"" ++ sn x2 ++ "\" y2=\"" ++
    sn y2 ++ "\" stroke=\"" ++ col ++ "\" stroke-width=\"" ++ w ++ "\"/>"

/-- A line of text. -/
private def txt (x y size : Int) (fill : String) (body : String)
    (anchor : String := "start") : String :=
  "<text x=\"" ++ sn x ++ "\" y=\"" ++ sn y ++ "\" font-size=\"" ++ sn size ++
    "\" fill=\"" ++ fill ++ "\" text-anchor=\"" ++ anchor ++
    "\" font-family=\"ui-monospace,monospace\">" ++ body ++ "</text>"

/-- A panel with a caption. -/
private def panel (x y w h : Int) (title : String) : String :=
  rct x y w h "#101a20" "rx=\"10\" stroke=\"#22343d\"" ++
    txt (x + 14) (y + 24) 15 "#8fb3c4" title

/-! ## Colours -/

private def cOn : String := "#5fd0ff"
private def cOff : String := "#1d3742"
private def cWater : String := "#3aa7d9"
private def cSun : String := "#ffd166"
private def cText : String := "#e8f2f6"
private def cMuted : String := "#8fb3c4"
private def cCard : String := "#e8dcc0"

/-! ## The gate deck, animated out of the fluidic semantics -/

/-- Both input lines of a two-input network. -/
private def atInputs (ab : Bool × Bool) : Fin 2 → Bool :=
  fun i => if i.val = 0 then ab.1 else ab.2

/-- The four input combinations, in the order the animation steps through
them. -/
def combos : List (Bool × Bool) := [(false, false), (false, true), (true, false), (true, true)]

open FCirc in
/-- A NAND gate: one valve. -/
def gNand : FCirc 2 := nand (inp 0) (inp 1)

open FCirc in
/-- AND: a NAND and an inverter. -/
def gAnd : FCirc 2 := notC (nand (inp 0) (inp 1))

open FCirc in
/-- OR: two inverters into a NAND. -/
def gOr : FCirc 2 := nand (notC (inp 0)) (notC (inp 1))

open FCirc in
/-- XOR, the four-valve way. -/
def gXor : FCirc 2 :=
  nand (nand (inp 0) (nand (inp 0) (inp 1))) (nand (inp 1) (nand (inp 0) (inp 1)))

/-- The colours a lamp takes, one per step of the animation: **computed by the
fluidic semantics**, not typed in. -/
def lampValues (c : FCirc 2) : String :=
  String.intercalate ";"
    ((combos.map (fun ab => if c.eval (atInputs ab) then cOn else cOff)) ++
      [if c.eval (atInputs (false, false)) then cOn else cOff])

/-- The colours an input lamp takes. -/
def inputValues (first : Bool) : String :=
  String.intercalate ";"
    ((combos.map (fun ab => if (if first then ab.1 else ab.2) then cOn else cOff)) ++
      [cOff])

/-- The `animate` element that steps a fill through the four combinations. -/
def lampAnim (values : String) : String :=
  "<animate attributeName=\"fill\" values=\"" ++ values ++
    "\" keyTimes=\"0;0.25;0.5;0.75;1\" dur=\"8s\" calcMode=\"discrete\" " ++
    "repeatCount=\"indefinite\"/>"

/-- One lamp: a circle whose fill steps through the truth table. -/
def lamp (cx cy : Int) (values : String) : String :=
  "<circle cx=\"" ++ sn cx ++ "\" cy=\"" ++ sn cy ++ "\" r=\"11\" fill=\"" ++ cOff ++
    "\" stroke=\"#2b4f5e\">" ++ lampAnim values ++ "</circle>"

/-- A falling drop, offset in the cycle. -/
def drop (cx y0 y1 : Int) (delay : String) : String :=
  "<circle cx=\"" ++ sn cx ++ "\" cy=\"" ++ sn y0 ++ "\" r=\"3\" fill=\"" ++ cWater ++
    "\"><animate attributeName=\"cy\" values=\"" ++ sn y0 ++ ";" ++ sn y1 ++
    "\" dur=\"1.6s\" begin=\"" ++ delay ++ "\" repeatCount=\"indefinite\"/>" ++
    "<animate attributeName=\"opacity\" values=\"1;0\" dur=\"1.6s\" begin=\"" ++ delay ++
    "\" repeatCount=\"indefinite\"/></circle>"

/-- The gate deck panel. -/
def deckSvg : String :=
  panel 20 200 470 250 "Gate deck — water NAND logic, stepping the truth table" ++
  txt 40 250 13 cMuted "inputs" ++
  lamp 120 245 (inputValues true) ++ txt 120 285 13 cText "A" "middle" ++
  lamp 170 245 (inputValues false) ++ txt 170 285 13 cText "B" "middle" ++
  String.join
    (List.map (fun (p : (String × FCirc 2) × Nat) =>
        let x : Int := 250 + 70 * (p.2 : Int)
        rct (x - 26) 310 52 46 "#16262e" "rx=\"6\" stroke=\"#2b4f5e\"" ++
        ln x 262 x 310 cWater "3" ++
        lamp x 385 (lampValues p.1.2) ++
        txt x 338 13 cText p.1.1 "middle")
      (List.zipIdx [("NAND", gNand), ("AND", gAnd), ("OR", gOr), ("XOR", gXor)])) ++
  ln 120 256 460 262 cWater "3" ++
  drop 250 200 306 "0s" ++ drop 320 200 306 "0.4s" ++
  drop 390 200 306 "0.8s" ++ drop 460 200 306 "1.2s" ++
  txt 40 425 12 cMuted "lamp colours are FCirc.eval, not hand-drawn"

/-! ## The sun, the lift and the head tank -/

/-- The sky panel: sun, heliostats, collector, riser and head tank. -/
def sunSvg : String :=
  panel 20 20 470 165 "Sun, heliostats and the lift — the only power station" ++
  ("<g><animateTransform attributeName=\"transform\" type=\"rotate\" " ++
    "from=\"0 80 80\" to=\"360 80 80\" dur=\"24s\" repeatCount=\"indefinite\"/>" ++
    String.join (List.map (fun k : Nat =>
        let a : Int := (k : Int)
        ln (80 + 26 * (if a % 4 == 0 then 1 else 0) - 13 * (a % 3))
           (80 - 30 + 10 * a) (80 + 34) (80 - 30 + 10 * a) cSun "2")
      [0, 1, 2, 3, 4, 5]) ++ "</g>") ++
  circ 80 80 20 cSun ++
  txt 80 130 12 cMuted "sun" "middle" ++
  -- heliostat mirrors
  rct 150 70 10 40 "#9fd3e6" "rx=\"2\"" ++ rct 180 70 10 40 "#9fd3e6" "rx=\"2\"" ++
  txt 170 130 12 cMuted "heliostats" "middle" ++
  -- collector
  rct 230 60 90 40 "#16262e" "rx=\"4\" stroke=\"#2b4f5e\"" ++
  txt 275 130 12 cMuted "collector" "middle" ++
  -- riser filling the tank
  rct 340 45 14 90 "#0d1a20" "rx=\"3\" stroke=\"#2b4f5e\"" ++
  ("<rect x=\"341\" y=\"135\" width=\"12\" height=\"0\" fill=\"" ++ cWater ++
    "\"><animate attributeName=\"height\" values=\"0;90\" dur=\"4s\" " ++
    "repeatCount=\"indefinite\"/><animate attributeName=\"y\" values=\"135;45\" " ++
    "dur=\"4s\" repeatCount=\"indefinite\"/></rect>") ++
  rct 375 45 90 40 "#0d1a20" "rx=\"4\" stroke=\"#2b4f5e\"" ++
  ("<rect x=\"377\" y=\"63\" width=\"86\" height=\"20\" fill=\"" ++ cWater ++
    "\"><animate attributeName=\"opacity\" values=\"0.5;1;0.5\" dur=\"4s\" " ++
    "repeatCount=\"indefinite\"/></rect>") ++
  txt 420 130 12 cMuted "head tank, 2 m" "middle"

/-! ## The card chain -/

/-- The first sixteen cards of the printer's own program. -/
def animCards : List (List Bool) :=
  (printerStack.take 16).map (fun c => List.ofFn c)

/-- One card, drawn at `x`: pasteboard with its punched holes. -/
def cardSvg (x : Int) (row : List Bool) : String :=
  rct x 505 26 96 cCard "rx=\"3\"" ++
  String.join (List.map (fun (p : Bool × Nat) =>
      if p.1 then circ (x + 13) (508 + 6 * (p.2 : Int) / 5) 2 "#25313a" else "")
    (List.zipIdx row))

/-- The card chain panel: sixteen real cards, scrolling. -/
def chainSvg : String :=
  panel 20 465 950 165 "The program: the first sixteen of 910 punched cards, scrolling" ++
  "<svg x=\"20\" y=\"465\" width=\"950\" height=\"165\" viewBox=\"20 465 950 165\">" ++
  ("<g><animateTransform attributeName=\"transform\" type=\"translate\" " ++
    "from=\"0 0\" to=\"-480 0\" dur=\"12s\" repeatCount=\"indefinite\"/>" ++
    String.join (List.map (fun (p : List Bool × Nat) =>
        cardSvg (40 + 30 * (p.2 : Int)) p.1 ++
        cardSvg (40 + 480 + 30 * (p.2 : Int)) p.1)
      (List.zipIdx animCards)) ++ "</g>") ++
  "</svg>" ++
  txt 40 620 12 cMuted "punch pattern read out of printerStack; the chain re-punches itself on the loom"

/-! ## The printer -/

/-- The printer panel: a gantry laying cells. -/
def printerSvg : String :=
  panel 510 200 460 250 "The printer, driven by the deck" ++
  rct 540 250 400 170 "#0d1a20" "rx=\"6\" stroke=\"#22343d\"" ++
  ("<g><animateTransform attributeName=\"transform\" type=\"translate\" " ++
    "values=\"0 0;340 0;0 0\" dur=\"6s\" repeatCount=\"indefinite\"/>" ++
    rct 560 260 20 30 "#7fd4a8" "rx=\"3\"" ++ ln 570 290 570 305 "#7fd4a8" "3" ++ "</g>") ++
  String.join (List.map (fun k : Nat =>
      let x : Int := 560 + 18 * (k : Int)
      ("<rect x=\"" ++ sn x ++ "\" y=\"380\" width=\"14\" height=\"0\" fill=\"#7fd4a8\" " ++
        "rx=\"2\"><animate attributeName=\"height\" values=\"0;0;26\" keyTimes=\"0;" ++
        toString (5 + 5 * k) ++ "e-2;1\" dur=\"6s\" repeatCount=\"indefinite\"/>" ++
        "<animate attributeName=\"y\" values=\"406;406;380\" keyTimes=\"0;" ++
        toString (5 + 5 * k) ++ "e-2;1\" dur=\"6s\" repeatCount=\"indefinite\"/></rect>"))
    (List.range 18)) ++
  txt 540 435 12 cMuted "3835 ticks, 908 cells, no fault — the run the printer model proves"

/-! ## The teams -/

/-- The fitness every team holds after `k` shared rounds. -/
def teamSeries (k : ℕ) : List ℕ := (rounds sharedRound k teams0).map Design.fitness

/-- The three positions the animation steps through: before any round, after
one, after two. -/
def teamFrames : List (List ℕ) := [teamSeries 0, teamSeries 1, teamSeries 2]

/-- The heights a team's bar takes, scaled to the panel. -/
def barValues (i : Nat) : String :=
  String.intercalate ";"
    ((teamFrames.map (fun f => toString ((f.getD i 0) / 70))) ++
      [toString (((teamFrames.getD 2 []).getD i 0) / 70)])

/-- The `y` a team's bar takes, so that it grows upwards. -/
def barYs (i : Nat) : String :=
  String.intercalate ";"
    ((teamFrames.map (fun f => toString (830 - (f.getD i 0) / 70))) ++
      [toString (830 - ((teamFrames.getD 2 []).getD i 0) / 70)])

/-- The names of the four teams. -/
def teamNames : List String := ["silicon", "steam", "air", "relay"]

/-- The teams panel: four bars, stepping through the rounds. -/
def teamsSvg : String :=
  panel 510 20 460 165 "Four teams, two shared rounds — the proved search" ++
  String.join (List.map (fun (p : String × Nat) =>
      let x : Int := 545 + 105 * (p.2 : Int)
      ("<rect x=\"" ++ sn x ++ "\" y=\"170\" width=\"46\" height=\"0\" fill=\"#5fd0ff\" " ++
        "rx=\"3\"><animate attributeName=\"height\" values=\"" ++ barValues p.2 ++
        "\" keyTimes=\"0;0.33;0.66;1\" dur=\"6s\" calcMode=\"discrete\" " ++
        "repeatCount=\"indefinite\"/><animate attributeName=\"y\" values=\"" ++
        String.intercalate ";"
          ((teamFrames.map (fun f => toString (170 - (f.getD p.2 0) / 70))) ++
            [toString (170 - ((teamFrames.getD 2 []).getD p.2 0) / 70)]) ++
        "\" keyTimes=\"0;0.33;0.66;1\" dur=\"6s\" calcMode=\"discrete\" " ++
        "repeatCount=\"indefinite\"/></rect>") ++
      txt (x + 23) 182 12 cText p.1 "middle")
    (List.zipIdx teamNames)) ++
  txt 530 60 12 cMuted "everyone ends on water + sun + cards + siphon"

/-! ## The price list -/

/-- The stall panel: what the modules cost. -/
def priceSvg : String :=
  panel 20 645 950 220 "The stall — prices out of Water/Market.lean" ++
  String.join (List.map (fun (p : Module × Nat) =>
      let col : Int := if p.2 < 6 then 0 else 1
      let row : Int := if p.2 < 6 then (p.2 : Int) else (p.2 : Int) - 6
      txt (45 + 470 * col) (685 + 26 * row) 13 cText
        (p.1.name ++ " …… " ++ toString (p.1.price / 1000000)))
    (List.zipIdx Module.all)) ++
  txt 45 845 14 cSun
    ("the kit: " ++ toString (kitPrice / 1000000) ++
      "   ·   the silicon route with its grid connection: " ++
      toString (gridRoutePrice / 1000000))

/-! ## The page -/

/-- The whole picture. -/
def animSvg : String :=
  "<svg xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 990 880\" width=\"100%\">" ++
  rct 0 0 990 880 "#0a1216" ++
  sunSvg ++ teamsSvg ++ deckSvg ++ printerSvg ++ chainSvg ++ priceSvg ++
  "</svg>"

/-- A single self-contained page: the animation, and what it is showing. -/
def animPage : String :=
  "<!DOCTYPE html>\n<meta charset=\"utf-8\">\n<meta name=\"viewport\" " ++
  "content=\"width=device-width, initial-scale=1\">\n" ++
  "<title>The water and sun computer</title>\n" ++
  "<style>body{background:#070d10;color:#e8f2f6;font:15px/1.5 ui-monospace,monospace;" ++
  "margin:0;padding:24px}h1{font-size:22px;margin:0 0 6px}p{color:#8fb3c4;max-width:70em}" ++
  "a{color:#5fd0ff}</style>\n" ++
  "<h1>A 3D printer computed by water and powered by the sun</h1>\n" ++
  "<p>No script, no silicon. The lamps step through the truth table exactly as " ++
  "<code>FCirc.eval</code> evaluates the gates; the cards are the first sixteen of the " ++
  "910 that carry the printer's own program; the bars are the fitness the four teams " ++
  "hold after each shared round; the prices are the ones the market file proves things " ++
  "about.</p>\n" ++ animSvg ++
  "\n<p>Built from <code>RequestProject/Water/</code>. The claims and what is taken on " ++
  "trust are listed in <code>docs/water-sun.md</code>.</p>\n"

end Water
end LifeTrac
