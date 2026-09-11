import RequestProject.Gvcs.Web.Svg

/-!
# The picture extractor

`lake exe media [dir]` plays every script of `RequestProject/Strategies.lean`
through the rule book of `RequestProject/Runtime.lean` and writes out what it
sees:

* `frames/<player>-NN.svg` — one static frame per position of the play;
* `<player>-storyboard.svg` — all of a play's frames on one sheet;
* `<player>-anim.svg` — the play as an animated SVG;
* `compare.svg` — the cash of all the players against the calendar;
* `race.svg` — an animated bar chart of net worth, move by move;
* `plays.json` — the positions themselves, for anything else that wants them;
* `figures.tex` — the same figures as LaTeX macros, so that the brochure
  quotes the play rather than a typist.

The default directory is `media`.  `tools/rasterize.py` turns the SVGs into
PNGs and the frames of each play into an animated PNG.
-/

open LifeTrac Runtime Wasm Media Strategies

/-- A two-digit frame number. -/
def pad2 (n : Nat) : String :=
  if n < 10 then "0" ++ toString n else toString n

/-- One position, as JSON. -/
def stateJson (s : RState) : String :=
  "{\"cash\":" ++ toString s.cash ++ ",\"fuel\":" ++ toString s.fuel ++
  ",\"day\":" ++ toString s.day ++ ",\"hect\":" ++ toString s.hect ++
  ",\"netWorth\":" ++ toString (rNetWorth s / SCALE) ++
  ",\"tractor\":" ++ (if s.hasTractor then "true" else "false") ++
  ",\"stock\":[" ++ String.intercalate "," (allM.map (fun m => toString (s.stock m))) ++ "]}"

/-- One play, as JSON. -/
def playJson (p : Player) : String :=
  "{\"key\":\"" ++ p.key ++ "\",\"name\":\"" ++ p.name ++ "\",\"tagline\":\"" ++ p.tagline ++
  "\",\"moves\":[" ++
    String.intercalate "," (p.script.map (fun a => "\"" ++ actionLabel a ++ "\"")) ++
  "],\"allowed\":" ++ toString (playedMoves rstart p.script).length ++
  ",\"states\":[\n    " ++
    String.intercalate ",\n    " ((traceStates rstart p.script).map stateJson) ++
  "\n  ]}"

/-- Every play, as JSON. -/
def playsJson : String :=
  "[\n  " ++ String.intercalate ",\n  " (players.map playJson) ++ "\n]\n"

/-! ## A page to look at them on -/

/-- A gallery of everything this program writes. -/
def galleryHtml : String :=
  "<!doctype html>\n<html lang=\"en\"><head><meta charset=\"utf-8\">\n" ++
  "<title>LifeTrac · the gameplay gallery</title>\n" ++
  "<style>body{background:#0e1512;color:#e7f0e9;font-family:system-ui,sans-serif;" ++
  "margin:0 auto;max-width:1100px;padding:24px}h1{color:#79c98a}h2{color:#e8c46a;" ++
  "border-bottom:1px solid #2b3a31;padding-bottom:4px;margin-top:36px}" ++
  "img{max-width:100%;border:1px solid #2b3a31;border-radius:6px}" ++
  "p{color:#8fa697}a{color:#6fb7e8}" ++
  ".row{display:flex;gap:12px;flex-wrap:wrap}.row img{max-width:340px}</style>\n" ++
  "</head><body>\n<h1>LifeTrac · the gameplay gallery</h1>\n" ++
  "<p>Every picture on this page is drawn from a position the rule book of " ++
  "<code>RequestProject/Runtime.lean</code> actually reached, by " ++
  "<code>lake exe media</code>. The PNGs beside them are written by " ++
  "<code>tools/rasterize.py</code>.</p>\n" ++
  "<h2>The players against each other</h2>\n" ++
  "<img src=\"compare.svg\" alt=\"cash of every player, move by move\">\n" ++
  "<p>Animated: the net worth of all six, move by move.</p>\n" ++
  "<img src=\"race.svg\" alt=\"net worth of every player, animated\">\n" ++
  String.join (players.map (fun p =>
    let f := finalOf p
    "<h2>" ++ p.name ++ " · " ++ p.tagline ++ "</h2>\n<p>" ++
    toString (playedMoves rstart p.script).length ++ " of " ++
    toString p.script.length ++ " moves allowed · finished on " ++ money f.cash ++
    " in cash, " ++ money (rNetWorth f / SCALE) ++ " net worth, day " ++ money f.day ++
    ", " ++ money f.hect ++ " hectares · " ++
    "<a href=\"" ++ p.key ++ "-storyboard.svg\">storyboard</a> · " ++
    "<a href=\"" ++ p.key ++ "-animated.png\">animated PNG</a> · " ++
    "<a href=\"png/frames/\">frames</a></p>\n" ++
    "<img src=\"" ++ p.key ++ "-anim.svg\" alt=\"" ++ p.name ++ "'s play, animated\">\n")) ++
  "<h2>Everything at once</h2>\n<p>All " ++
  toString ((players.map (fun p => (shotsOf p).length)).foldl (· + ·) 0) ++
  " frames of all six plays, as one animated PNG: " ++
  "<a href=\"all-animated.png\">all-animated.png</a>.</p>\n" ++
  "</body></html>\n"

/-! ## The same figures, for the brochure -/

/-- A number for LaTeX: digit groups separated by thin spaces. -/
def moneyTex (n : Int) : String :=
  String.intercalate "\\," ((money n).splitOn " ")

/-- One macro. -/
def texMacro (nm val : String) : String :=
  "\\newcommand{\\fig" ++ nm ++ "}{" ++ val ++ "}\n"

/-- Every figure of a play, as LaTeX macros. -/
def playTex (p : Player) : String :=
  let f := finalOf p
  let k := p.key
  texMacro (k ++ "Name") p.name ++
  texMacro (k ++ "Tagline") p.tagline ++
  texMacro (k ++ "Moves") (toString p.script.length) ++
  texMacro (k ++ "Allowed") (toString (playedMoves rstart p.script).length) ++
  texMacro (k ++ "Cash") (moneyTex f.cash) ++
  texMacro (k ++ "Fuel") (moneyTex f.fuel) ++
  texMacro (k ++ "Day") (moneyTex f.day) ++
  texMacro (k ++ "Hect") (moneyTex f.hect) ++
  texMacro (k ++ "Worth") (moneyTex (rNetWorth f / SCALE)) ++
  texMacro (k ++ "Frames") (toString (shotsOf p).length)

/-- The standings, as the body of a LaTeX table. -/
def standingsTex : String :=
  String.intercalate "\n" (players.map (fun p =>
    let f := finalOf p
    p.name ++ " & " ++ toString (playedMoves rstart p.script).length ++ "/" ++
      toString p.script.length ++ " & " ++ moneyTex f.cash ++ " & " ++
      moneyTex (rNetWorth f / SCALE) ++ " & " ++ moneyTex f.day ++ " & " ++
      moneyTex f.hect ++ " \\\\"))

/-- Everything the brochure quotes. -/
def figuresTex : String :=
  "% Written by `lake exe media` from the plays of RequestProject/Strategies.lean.\n" ++
  "% Do not edit: every figure here is a position Runtime.rstep reached.\n" ++
  String.join (players.map playTex) ++
  "\\newcommand{\\figStandings}{%\n" ++ standingsTex ++ "\n}\n"

def main (args : List String) : IO Unit := do
  let out := args.headD "media"
  IO.FS.createDirAll out
  IO.FS.createDirAll (out ++ "/frames")
  for p in players do
    let n := (shotsOf p).length
    for k in List.range n do
      IO.FS.writeFile (out ++ "/frames/" ++ p.key ++ "-" ++ pad2 k ++ ".svg") (frameSvg p k)
    IO.FS.writeFile (out ++ "/" ++ p.key ++ "-storyboard.svg") (storyboardSvg p)
    IO.FS.writeFile (out ++ "/" ++ p.key ++ "-anim.svg") (animSvg p)
    IO.println s!"{p.name}: {n} frames"
  IO.FS.writeFile (out ++ "/compare.svg") compareSvg
  IO.FS.writeFile (out ++ "/race.svg") raceSvg
  IO.FS.writeFile (out ++ "/plays.json") playsJson
  IO.FS.writeFile (out ++ "/figures.tex") figuresTex
  IO.FS.writeFile (out ++ "/index.html") galleryHtml
  IO.println s!"wrote {out}/frames, {out}/*-storyboard.svg, {out}/*-anim.svg, \
{out}/compare.svg, {out}/race.svg, {out}/plays.json"
