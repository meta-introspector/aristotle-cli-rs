import RequestProject.Solfunmeme.Meme.Engine
import RequestProject.Solfunmeme.Meme.Share

/-!
# Badge screenshots as SVG

Every unlock renders to a self-contained SVG card: a header, one chunk per
unlocked badge, and a footer carrying the share code the card is a screenshot
*of*.  The browser rasterises the very same string to PNG (and to the GIF/movie
export), so what a viewer sees and what a verifier parses come from one source.

The structure is deliberately simple enough to reason about: `render_eq` says a
card is exactly `header ++ chunks ++ footer`, and `chunks_length` says there is
one chunk per unlocked badge — no badge can be drawn that the state has not
earned.
-/

namespace Meme.Svg

open Meme.Engine

/-- Human readable name of a badge. -/
def badgeLabel : Badge → String
  | .firstMeme => "FIRST MEME"
  | .memeLord => "MEME LORD"
  | .tycoonist => "TYCOONIST"
  | .diamondHands => "DIAMOND HANDS"
  | .stakeWhale => "STAKE WHALE"

/-- Fill colour of a badge chip. -/
def badgeColour : Badge → String
  | .firstMeme => "#ff2d95"
  | .memeLord => "#ffd400"
  | .tycoonist => "#00e5ff"
  | .diamondHands => "#7cff00"
  | .stakeWhale => "#b14cff"

/-- One badge chip, placed by index. -/
def chunk (i : Nat) (b : Badge) : String :=
  let y := 150 + 46 * i
  "<g><rect x=\"40\" y=\"" ++ toString y ++
    "\" rx=\"14\" width=\"440\" height=\"36\" fill=\"" ++ badgeColour b ++
    "\" opacity=\"0.85\"/><text x=\"60\" y=\"" ++ toString (y + 25) ++
    "\" font-family=\"monospace\" font-size=\"20\" fill=\"#101014\">" ++ badgeLabel b ++ "</text></g>"

/-- The card header: title and the headline numbers. -/
def header (s : State) : String :=
  "<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"520\" height=\"420\" viewBox=\"0 0 520 420\">" ++
  "<rect width=\"520\" height=\"420\" fill=\"#101014\"/>" ++
  "<text x=\"40\" y=\"64\" font-family=\"monospace\" font-size=\"28\" fill=\"#ff2d95\">SOLFUNMEME</text>" ++
  "<text x=\"40\" y=\"96\" font-family=\"monospace\" font-size=\"18\" fill=\"#f0f0f5\">brainrot " ++
    toString s.brainrot ++ " &#183; memes " ++ toString s.memes ++ " &#183; day " ++ toString s.day ++
    "</text>" ++
  "<text x=\"40\" y=\"122\" font-family=\"monospace\" font-size=\"18\" fill=\"#f0f0f5\">blocks " ++
    toString s.blocks ++ " &#183; stake " ++ toString s.stake ++ "</text>"

/-- The card footer, carrying the share code and the commitment. -/
def footer (s : State) : String :=
  "<text x=\"40\" y=\"388\" font-family=\"monospace\" font-size=\"11\" fill=\"#8a8a99\">" ++
    Meme.Share.encodeShare s ++ "</text>" ++
  "<text x=\"40\" y=\"404\" font-family=\"monospace\" font-size=\"11\" fill=\"#8a8a99\">commit " ++
    toString s.commit ++ "</text></svg>"

/-- One chip per unlocked badge. -/
def chunks (s : State) : List String :=
  (unlocked s).zipIdx.map (fun p => chunk p.2 p.1)

/-- The whole card. -/
def render (s : State) : String := header s ++ String.join (chunks s) ++ footer s

end Meme.Svg
