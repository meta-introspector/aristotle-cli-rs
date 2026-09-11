import RequestProject.Nix.NixWars.WellExperiment
import RequestProject.Nix.NixWars.Gl

/-!
# The film of the experiment: `www/well-video.svg`

An animated SVG — declarative SMIL, no script — of the experiment in
`WellExperiment.lean`. Seven Shard Invaders cabinets hang at radii
`72 … 143` above the horizon at `71`; the same autopilot plays all seven; each
screen advances on its own dilated clock. The film is exactly one room frame
long, `792` ticks at `25` ms a tick, so it loops seamlessly: `792` is the
least common multiple of the seven periods (`sunk_frame`), which is precisely
the statement that at the end of the film every cabinet is back on a step
boundary (`frame_whole_steps`).

Everything on the screen is computed here from the Lean model: the ten frames
of each cabinet's screen are the ten states the autopilot actually passes
through (`autoRun shardInvaders invadersAuto`), the times at which each frame
is shown are `k·p … (k+1)·p` for that cabinet's period `p` (`Well.period`),
the CLEARED flags appear at `clearTick r` (`clearTicks_eq`) and the ruler
marks are those same ticks laid out along the frame.

What the film shows is the whole content of the experiment: seven identical
plays of the same nine moves (`ai_final_screen_invariant`), finishing seventy
two ticks apart at one end and one tick apart at the other, with the only
difference in the wall clock along the bottom.
-/

namespace NixWars

namespace BlackHole

open NixWars.Controls

/-! ## Small string helpers -/

/-- Left-pad with zeros to width `w`. -/
def padZero (w n : Nat) : String :=
  let s := toString n
  String.ofList (List.replicate (w - s.length) '0') ++ s

/-- `num/den` as a four-decimal fraction, for SVG `keyTimes`. -/
def frac4 (num den : Nat) : String :=
  let sc := if den = 0 then 0 else num * 10000 / den
  toString (sc / 10000) ++ "." ++ padZero 4 (sc % 10000)

/-- Milliseconds as an SVG clock value. -/
def secsOf (ms : Nat) : String :=
  toString (ms / 1000) ++ "." ++ padZero 3 (ms % 1000) ++ "s"

/-! ## The film's constants -/

/-- Milliseconds of real time to one tick of the room clock. -/
def videoMs : Nat := 25

/-- The film is one room frame long: 792 ticks. -/
def videoTicks : Nat := frame sunkPeriods

/-- The film's duration as an SVG clock value. -/
def videoDur : String := secsOf (videoTicks * videoMs)

/-- Where the timeline column starts and how wide it is. -/
def barX : Nat := 372
/-- The width of the timeline column. -/
def barW : Nat := 300

/-- The `x` of tick `t` on the timeline. -/
def tickX (t : Nat) : Nat := barX + barW * t / videoTicks

/-- The `y` of the `i`-th cabinet's row. -/
def rowY (i : Nat) : Nat := 96 + i * 44

/-! ## Drawing one screen -/

/-- The ten screens the autopilot passes through on a fresh cabinet. -/
def videoTape : List Invaders :=
  (List.range 10).map (fun k => autoRun shardInvaders invadersAuto initialInvaders k)

/-- One frame of one cabinet's screen: the surviving invaders and the gun. -/
def screenGlyphs (s : Invaders) (y : Nat) : String :=
  let cell := 15
  let x0 := 150
  let alive := [s.a0, s.a1, s.a2, s.a3, s.a4]
  let inv := String.join ((List.range 5).map (fun j =>
    if alive.getD j 0 = 0 then "" else
      "<rect x=\"" ++ toString (x0 + (s.ox + j) * cell) ++ "\" y=\"" ++ toString y ++
      "\" width=\"11\" height=\"8\" fill=\"#8fffa5\"/>"))
  let gun :=
    "<rect x=\"" ++ toString (x0 + s.px * cell) ++ "\" y=\"" ++ toString (y + 16) ++
    "\" width=\"11\" height=\"5\" fill=\"#ffd27f\"/>" ++
    "<rect x=\"" ++ toString (x0 + s.px * cell + 4) ++ "\" y=\"" ++ toString (y + 12) ++
    "\" width=\"3\" height=\"4\" fill=\"#ffd27f\"/>"
  inv ++ gun

/-- The discrete opacity animation that shows frame `k` of a cabinet of period
`p` for exactly its own step, `k·p` to `(k+1)·p` ticks of the room clock. The
last frame is held to the end of the film. -/
def frameAnim (k p : Nat) : String :=
  let a := frac4 (k * p) videoTicks
  let b := frac4 ((k + 1) * p) videoTicks
  let vk :=
    if k = 0 then "values=\"1;0\" keyTimes=\"0;" ++ b ++ "\""
    else if k = 9 then "values=\"0;1\" keyTimes=\"0;" ++ a ++ "\""
    else "values=\"0;1;0\" keyTimes=\"0;" ++ a ++ ";" ++ b ++ "\""
  "<animate attributeName=\"opacity\" calcMode=\"discrete\" dur=\"" ++ videoDur ++
    "\" repeatCount=\"indefinite\" " ++ vk ++ "/>"

/-- One cabinet's row: label, screen, CLEARED flag, progress bar and the tick
at which it finishes. -/
def cabinetRow (i r : Nat) : String :=
  let p := sgrA.period 1 r
  let ct := clearTick r
  let y := rowY i
  let frames := String.join ((List.range 10).map (fun k =>
    let s := videoTape.getD k initialInvaders
    "<g opacity=\"0\">" ++ frameAnim k p ++ screenGlyphs s y ++ "</g>"))
  let label :=
    "<text x=\"12\" y=\"" ++ toString (y + 14) ++ "\" fill=\"#bfffd0\" font-size=\"11\">r=" ++
    toString r ++ "</text>" ++
    "<text x=\"62\" y=\"" ++ toString (y + 14) ++ "\" fill=\"#5f9c6f\" font-size=\"11\">" ++
    toString p ++ " tick" ++ (if p = 1 then "" else "s") ++ "/step</text>"
  let cleared :=
    "<text x=\"282\" y=\"" ++ toString (y + 14) ++
      "\" fill=\"#ffd27f\" font-size=\"10\" opacity=\"0\">CLEARED" ++
      "<animate attributeName=\"opacity\" calcMode=\"discrete\" dur=\"" ++ videoDur ++
      "\" repeatCount=\"indefinite\" values=\"0;1\" keyTimes=\"0;" ++
      frac4 ct videoTicks ++ "\"/></text>"
  let bar :=
    "<rect x=\"" ++ toString barX ++ "\" y=\"" ++ toString (y + 4) ++ "\" width=\"" ++
      toString barW ++ "\" height=\"11\" fill=\"#0a1a0e\" stroke=\"#16351d\"/>" ++
    "<rect x=\"" ++ toString barX ++ "\" y=\"" ++ toString (y + 4) ++
      "\" width=\"0\" height=\"11\" fill=\"#2aa843\">" ++
      "<animate attributeName=\"width\" dur=\"" ++ videoDur ++
      "\" repeatCount=\"indefinite\" values=\"0;" ++ toString barW ++ ";" ++ toString barW ++
      "\" keyTimes=\"0;" ++ frac4 ct videoTicks ++ ";1\"/></rect>"
  let stamp :=
    "<text x=\"" ++ toString (barX + barW + 10) ++ "\" y=\"" ++ toString (y + 14) ++
      "\" fill=\"#8fffa5\" font-size=\"11\">" ++ toString ct ++ "</text>"
  let steps :=
    "<text x=\"" ++ toString (barX + barW + 46) ++ "\" y=\"" ++ toString (y + 14) ++
      "\" fill=\"#4f8a5e\" font-size=\"11\">" ++ toString (aiSteps r videoTicks) ++
      " st</text>"
  "<g>" ++ label ++ frames ++ cleared ++ bar ++ stamp ++ steps ++ "</g>"

/-- The ruler along the bottom, marked at the tick each cabinet finishes. -/
def videoRuler : String :=
  let y := rowY 7 + 6
  let axis :=
    "<line x1=\"" ++ toString barX ++ "\" y1=\"" ++ toString y ++ "\" x2=\"" ++
      toString (barX + barW) ++ "\" y2=\"" ++ toString y ++ "\" stroke=\"#1e5c2c\"/>"
  let marks := String.join (clearTicks.map (fun t =>
    "<line x1=\"" ++ toString (tickX t) ++ "\" y1=\"" ++ toString (y - 4) ++ "\" x2=\"" ++
      toString (tickX t) ++ "\" y2=\"" ++ toString (y + 4) ++ "\" stroke=\"#2aa843\"/>"))
  let ends :=
    "<text x=\"" ++ toString barX ++ "\" y=\"" ++ toString (y + 16) ++
      "\" fill=\"#4f8a5e\" font-size=\"10\">0</text>" ++
    "<text x=\"" ++ toString (barX + barW - 44) ++ "\" y=\"" ++ toString (y + 16) ++
      "\" fill=\"#4f8a5e\" font-size=\"10\">" ++ toString videoTicks ++ " ticks</text>"
  axis ++ marks ++ ends

/-- The playhead: the room clock, sweeping one frame and starting again. -/
def videoPlayhead : String :=
  let y0 := rowY 0 - 12
  let y1 := rowY 7 + 12
  "<line x1=\"" ++ toString barX ++ "\" y1=\"" ++ toString y0 ++ "\" x2=\"" ++
    toString barX ++ "\" y2=\"" ++ toString y1 ++ "\" stroke=\"#ffd27f\" opacity=\"0.8\">" ++
  "<animate attributeName=\"x1\" dur=\"" ++ videoDur ++ "\" repeatCount=\"indefinite\" from=\"" ++
    toString barX ++ "\" to=\"" ++ toString (barX + barW) ++ "\"/>" ++
  "<animate attributeName=\"x2\" dur=\"" ++ videoDur ++ "\" repeatCount=\"indefinite\" from=\"" ++
    toString barX ++ "\" to=\"" ++ toString (barX + barW) ++ "\"/></line>"

/-- **The film.** -/
def wellVideoSvg : String :=
  let rows := String.join ((List.range depths.length).map (fun i =>
    cabinetRow i (depths.getD i 0)))
  "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n" ++
  "<svg xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 760 470\" width=\"760\" " ++
    "height=\"470\" font-family=\"monospace\">\n" ++
  "<title>THE GRAVITY WELL &#8212; one AI, seven clocks, " ++ toString videoTicks ++
    " ticks</title>\n" ++
  "<rect width=\"760\" height=\"470\" fill=\"#050a06\"/>\n" ++
  "<text x=\"12\" y=\"26\" fill=\"#8fffa5\" font-size=\"15\" letter-spacing=\"3\">" ++
    "THE GRAVITY WELL</text>\n" ++
  "<text x=\"12\" y=\"46\" fill=\"#5f9c6f\" font-size=\"11\">Seven Shard Invaders cabinets " ++
    "above a horizon of " ++ toString sgrA.rs ++ " shards. One autopilot, one cartridge, " ++
    "nine moves &#8212; and seven clocks.</text>\n" ++
  "<text x=\"12\" y=\"62\" fill=\"#5f9c6f\" font-size=\"11\">The film is one room frame: " ++
    toString videoTicks ++ " ticks, the least common multiple of the periods, so it loops " ++
    "on a step boundary for every cabinet.</text>\n" ++
  "<line x1=\"0\" y1=\"76\" x2=\"760\" y2=\"76\" stroke=\"#16351d\"/>\n" ++
  "<text x=\"12\" y=\"90\" fill=\"#4f8a5e\" font-size=\"10\">RADIUS</text>" ++
  "<text x=\"150\" y=\"90\" fill=\"#4f8a5e\" font-size=\"10\">SCREEN</text>" ++
  "<text x=\"" ++ toString barX ++ "\" y=\"90\" fill=\"#4f8a5e\" font-size=\"10\">" ++
    "ROOM CLOCK</text>" ++
  "<text x=\"" ++ toString (barX + barW + 10) ++ "\" y=\"90\" fill=\"#4f8a5e\" font-size=\"10\">" ++
    "WON AT</text>\n" ++
  rows ++ "\n" ++ videoRuler ++ "\n" ++ videoPlayhead ++ "\n" ++
  "<text x=\"12\" y=\"452\" fill=\"#4f8a5e\" font-size=\"10\">" ++
    "Same nine moves at every depth; the only difference is when. " ++
    "Model and proofs: RequestProject/NixWars/WellExperiment.lean</text>\n" ++
  "</svg>\n"

/-- The film with its caption, as a page. -/
def wellVideoPage : String :=
  "<!doctype html>\n<html lang=\"en\">\n<head>\n<meta charset=\"utf-8\">\n" ++
  "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">\n" ++
  "<title>THE GRAVITY WELL &#8212; the film</title>\n<style>\n" ++
  "html, body { margin: 0; background: #050a06; color: #bfffd0;\n" ++
  "  font-family: ui-monospace, Menlo, Consolas, monospace; }\n" ++
  "header { padding: 18px 22px; border-bottom: 1px solid #16351d; }\n" ++
  "h1 { margin: 0; font-size: 18px; letter-spacing: 0.4em; color: #8fffa5; }\n" ++
  "p { font-size: 12px; color: #5f9c6f; max-width: 80ch; line-height: 1.6; }\n" ++
  "main { padding: 18px 22px 32px; }\n" ++
  "svg { max-width: 100%; height: auto; border: 1px solid #1e5c2c; }\n" ++
  "a { color: #8fffa5; }\n" ++
  "table { border-collapse: collapse; font-size: 12px; margin-top: 14px; }\n" ++
  "th, td { border: 1px solid #16351d; padding: 4px 10px; text-align: right; }\n" ++
  "th { color: #6fbc82; font-weight: normal; }\n" ++
  Gl.responsiveCss ++
  "</style>\n</head>\n<body>\n<header>\n<h1>THE GRAVITY WELL &#8212; THE FILM</h1>\n" ++
  "<p>The experiment, run and recorded. Seven cabinets hang above the hole at " ++
  "the centre of the ring of 71 shards. Each carries the same Shard Invaders " ++
  "cartridge and the same autopilot, which clears the sky in nine moves and " ++
  "provably cannot do it in eight. The cabinets differ only in how many ticks " ++
  "of the room clock one of their steps costs. Watch the screens: the nine " ++
  "moves are identical everywhere. Watch the bars: they are not.</p>\n" ++
  "</header>\n<main>\n" ++ wellVideoSvg ++ "\n" ++
  "<table>\n<tr><th>radius</th><th>ticks/step</th><th>steps in a frame</th>" ++
  "<th>won at tick</th><th>Monster Dash score</th></tr>\n" ++
  String.join (frameLog.map (fun e =>
    "<tr><td>" ++ toString e.1 ++ "</td><td>" ++ toString e.2.1 ++ "</td><td>" ++
    toString e.2.2.1 ++ "</td><td>" ++ toString e.2.2.2.1 ++ "</td><td>" ++
    toString e.2.2.2.2 ++ "</td></tr>\n")) ++
  "</table>\n" ++
  "<p>Every number above was computed in Lean and is the subject of a theorem " ++
  "there: the periods in <code>sunkPeriods_eq</code>, the frame in " ++
  "<code>sunk_frame</code>, the winning ticks in <code>clearTicks_eq</code>, the " ++
  "whole log in <code>frameLog_eq</code>, and the scores in " ++
  "<code>dash_scores_eq</code>. The clock the film runs on is the subject of " ++
  "<code>one_scale_iff_uniform</code>: a floor with more than one speed on it " ++
  "needs an instrument that resolves the greatest common divisor of the periods " ++
  "and counts as far as their least common multiple &#8212; here 1 tick and 792 " ++
  "ticks, a range of 792:1. And you can only tell the difference by watching two " ++
  "cabinets at once: one screen alone shows the same tape at every depth " ++
  "(<code>no_local_test</code>).</p>\n" ++
  "<p>Back to <a href=\"blackhole.html\">the experiment</a> or " ++
  "<a href=\"arcade.html\">the arcade room</a>.</p>\n" ++
  "</main>\n</body>\n</html>\n"

/-- Write the film and its page. -/
def writeWellVideo : IO Unit := do
  IO.FS.createDirAll "www"
  IO.FS.writeFile "www/well-video.svg" wellVideoSvg
  IO.FS.writeFile "www/well-video.html" wellVideoPage

#eval writeWellVideo

end BlackHole

end NixWars
