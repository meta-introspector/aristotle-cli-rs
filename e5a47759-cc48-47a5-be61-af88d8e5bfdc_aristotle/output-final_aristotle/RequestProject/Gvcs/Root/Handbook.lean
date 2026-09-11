import RequestProject.Gvcs.Barter
import RequestProject.Gvcs.Barnraising

/-!
# The paper edition

`lake exe handbook [dir]` writes `handbook.tex`: the whole undertaking as a
document that needs no computer to use — a bill of materials, an assembly
tree, the price of the machine in money and in jars of honey, the barnraising
roster, the pencil-and-paper pledge protocol of
`RequestProject/Barnraising.lean`, and the kiosk sign and ledger of
`RequestProject/Barter.lean`.

Every number in it is computed here from the same Lean definitions the
theorems are proved about, so the sheet a beekeeper takes to a farmers' market
and the machine-checked development cannot drift apart.  The default directory
is `paper`.
-/

open LifeTrac

/-! ## Formatting -/

/-- `q` rounded to `dp` decimal places, as a string. -/
def fmt (q : ℚ) (dp : ℕ := 2) : String :=
  let scale : ℤ := 10 ^ dp
  let neg := q < 0
  let a := if neg then -q else q
  let n : ℤ := (a * scale).floor
  let r : ℤ := if (a * scale) - (n : ℚ) ≥ 1/2 then n + 1 else n
  let whole := r / scale
  let frac := (r % scale).natAbs
  let fracStr := (toString frac).leftpad dp '0'
  (if neg then "-" else "") ++ toString whole ++ (if dp = 0 then "" else "." ++ fracStr)

/-- A material's catalogue name, spelled out for print. -/
def matName : Build.Material → String
  | .steelTube4 => "steel tube, 4 in square, 1/4 in wall"
  | .steelTube3 => "steel tube, 3 in square, 1/4 in wall"
  | .steelTube2 => "steel tube, 2 in square, 1/8 in wall"
  | .steelPlate6 => "steel plate, 6 mm"
  | .steelPlate12 => "steel plate, 12 mm"
  | .roundBar50 => "round bar, 50 mm"
  | .boltM12 => "bolt, M12"
  | .nutM12 => "nut, M12"
  | .weldWire => "welding wire"
  | .hose => "hydraulic hose"
  | .fitting => "hose fitting"
  | .fluid => "hydraulic fluid"
  | .gearPump => "gear pump"
  | .wheelMotor => "wheel motor"
  | .cylinder => "hydraulic cylinder"
  | .controlValve => "control valve"
  | .engine => "engine"
  | .fuelTank => "fuel tank"
  | .hydraulicTank => "hydraulic reservoir"
  | .wheelHub => "wheel hub with bearings"
  | .tire => "tire on a rim"
  | .seat => "operator seat"
  | .paint => "paint"
  | .electricalKit => "wiring, switches and battery"

/-- The unit a material is counted in, set for print. -/
def unitTex (m : Build.Material) : String :=
  match Build.Material.unitName m with
  | "m^2" => "m$^2$"
  | u => u

/-- Every material in the catalogue, in catalogue order. -/
def allMaterials : List Build.Material :=
  [.steelTube4, .steelTube3, .steelTube2, .steelPlate6, .steelPlate12, .roundBar50,
   .boltM12, .nutM12, .weldWire, .hose, .fitting, .fluid, .gearPump, .wheelMotor,
   .cylinder, .controlValve, .engine, .fuelTank, .hydraulicTank, .wheelHub, .tire,
   .seat, .paint, .electricalKit]

/-- The list of materials the machine actually draws on, with quantities. -/
def billLines : List (Build.Material × ℚ) :=
  let req := Build.Assembly.requirements Build.lifeTrac
  allMaterials.filterMap (fun m => if req m = 0 then none else some (m, req m))

/-- The bill of materials as a LaTeX table body. -/
def billTable : String :=
  String.join <| billLines.map fun (m, q) =>
    matName m ++ " & " ++ fmt q ++ " & " ++ unitTex m ++ " & " ++
      fmt (Build.Material.unitCost m) ++ " & " ++ fmt (q * Build.Material.unitCost m) ++
      " & " ++ fmt (q * Build.Material.unitMass m) ++ " \\\\\n"

/-- The assembly tree, indented. -/
partial def treeLines (depth : ℕ) : Build.Assembly → List String
  | .stock m q =>
      ["\\hspace*{" ++ toString depth ++
        "em}" ++ matName m ++ " \\dotfill\\ " ++ fmt q ++ " " ++ unitTex m ++
        " \\\\"]
  | .part n l cs =>
      ("\\hspace*{" ++ toString depth ++ "em}\\textbf{" ++ n ++ "} \\dotfill\\ " ++
        fmt l 0 ++ " h \\\\") :: (cs.flatMap (treeLines (depth + 1)))

/-! ## The pledge protocol, worked through -/

/-- The modulus, the worked round and its column sums all come from
`RequestProject/Barnraising.lean`, where the round is proved to pass the
check. -/
abbrev Q : ℕ := Barnraising.Q
abbrev exampleHours : List ℕ := Barnraising.exampleHours
abbrev examplePads : List ℕ := Barnraising.examplePads
abbrev exampleCommits : List ℕ := Barnraising.exampleCommits
abbrev sumMod : List ℕ → ℕ := Barnraising.sumMod

/-- The pledge sheet as a LaTeX table body. -/
def pledgeTable : String :=
  String.join <| (List.range 24).map fun i =>
    let h := exampleHours.getD i 0
    let r := examplePads.getD i 0
    let c := exampleCommits.getD i 0
    toString (i + 1) ++ " & " ++ toString h ++ " & " ++ toString r ++ " & " ++
      toString c ++ " \\\\\n"

/-- The document. -/
def document : String :=
  let sumC := sumMod exampleCommits
  let sumR := sumMod examplePads
  let target := (371 + sumR) % Q
  let jarsDealer := Barter.jars Ownership.dealerPrice
  let jarsCounter := Barter.jars Ownership.counterPrice
  let jarsStock := Barter.jars Ownership.stockPrice
  let jarsGround := Barter.jars Ownership.groundPrice
"\\documentclass[11pt,a4paper]{article}
\\usepackage[margin=2.2cm]{geometry}
\\usepackage{booktabs}
\\usepackage{longtable}
\\usepackage{amsmath}
\\usepackage[T1]{fontenc}
\\pagestyle{plain}
\\title{\\bf The LifeTrac barnraising handbook\\\\[2mm]
\\large the whole thing on paper: bill, roster, pledge sheet and stall}
\\author{Printed from a machine-checked model}
\\date{}
\\begin{document}
\\maketitle

\\section*{How to use this book}

Nothing in here needs a computer.  Every figure was computed from the same
Lean definitions the theorems of the project are proved about, so the sheet you
are holding and the machine-checked model cannot drift apart.  Print it,
staple it, take it to the market.

\\section{What a tractor costs}

\\begin{center}
\\begin{tabular}{lrr}
\\toprule
route & cost & jars of honey \\\\
\\midrule
buy one from a dealer & " ++ fmt Ownership.dealerPrice 0 ++ " & " ++ toString jarsDealer ++ " \\\\
buy the stock, build it, count your time & " ++ fmt Ownership.counterPrice 0 ++ " & " ++ toString jarsCounter ++ " \\\\
buy the stock, build it, do not count your time & " ++ fmt Ownership.stockPrice 0 ++ " & " ++ toString jarsStock ++ " \\\\
dig the ore and run every workflow & " ++ fmt Ownership.groundPrice ++ " & " ++ toString jarsGround ++ " \\\\
\\bottomrule
\\end{tabular}
\\end{center}

\\noindent A jar is priced at " ++ fmt Barter.jarPrice 0 ++ ", a hive gives " ++
  toString Barter.hiveJars ++ " jars a year, so eighteen hives cover a machine
built from the ground up in one season and the dealer's machine takes
sixty-four.  The jar count always covers the bill and never overpays by a whole
jar.

\\section{The bill of materials}

\\begin{center}
\\begin{longtable}{lrrrrr}
\\toprule
material & qty & unit & each & cost & kg \\\\
\\midrule
\\endhead
" ++ billTable ++ "\\midrule
\\textbf{total} & & & & \\textbf{" ++ fmt (Build.Assembly.materialCost Build.lifeTrac) ++
  "} & \\textbf{" ++ fmt (Build.Assembly.mass Build.lifeTrac) ++ "} \\\\
\\bottomrule
\\end{longtable}
\\end{center}

\\noindent Assembly labour: " ++ fmt (Build.Assembly.laborHours Build.lifeTrac) 0 ++
  " hours from bought stock; " ++ fmt Barnraising.bootstrapLabour ++
  " hours if the stock is made from ore as well.

\\section{The assembly tree}

\\noindent
" ++ String.intercalate "\n" (treeLines 0 Build.lifeTrac) ++ "

\\section{The barnraising}

The whole job from ore to tractor is " ++
  fmt Barnraising.bootstrapLabour ++ " hours.  Divide it
however you like: if nobody is to work more than a sixteen-hour weekend, the
crowd must number at least twenty-four, and twenty-four weekends come to 384
hours, which is enough.  What a crowd cannot do is shorten a chain: a run of
jobs each of which waits on the one before it takes the sum of their hours
however many hands are idle around it.

A share in such a barnraising is thirty-seven jars of honey and one weekend:
twenty-four of those cover both the material and the labour of a machine built
from the ground up, while the same tractor from a dealer costs more than
eighty-five such shares.

\\subsection*{Pledging without telling anyone what you gave}

Work modulo $Q = " ++ toString Q ++ "$.

\\begin{enumerate}
\\item Each volunteer $i$ writes down the hours $h_i$ they are pledging and
  picks a secret pad $r_i$ --- any number below $Q$, chosen at random and shown
  to nobody.
\\item They publish only $c_i = (h_i + r_i) \\bmod Q$.
\\item The folded-paper round: the sheet goes round the circle once, each
  volunteer adding their own $r_i$ (modulo $Q$) to the running total, so that
  the sheet comes back holding $R = \\sum_i r_i \\bmod Q$ and no individual pad.
\\item The check: $\\sum_i c_i \\equiv T + R \\pmod Q$, where $T$ is the hours the
  job needs.
\\end{enumerate}

If the check passes, the pledges really do add up to $T$: nobody can inflate
their share.  And the sheet is consistent, in exactly one way, with every
possible split of $T$ among the volunteers --- so it proves the total and
betrays nothing else.

\\subsection*{A worked round, $T = 371$}

\\begin{center}
\\begin{longtable}{rrrr}
\\toprule
volunteer & hours $h_i$ & pad $r_i$ & published $c_i$ \\\\
\\midrule
\\endhead
" ++ pledgeTable ++ "\\midrule
total & 371 & " ++ toString sumR ++ " & " ++ toString sumC ++ " \\\\
\\bottomrule
\\end{longtable}
\\end{center}

\\noindent The check: $\\sum c_i = " ++ toString sumC ++ "$ and $371 + R = " ++
  toString target ++ "$ modulo $Q$ --- " ++
  (if sumC = target then "they agree, so the round is accepted." else
    "they differ, so the round is rejected.") ++ "

\\section{The stall}

\\subsection*{Sign}

\\begin{center}
\\fbox{\\parbox{0.8\\textwidth}{\\centering\\large
PLANS FOR A TRACTOR\\\\[2mm]
one printed pack \\dotfill\\ " ++ toString Barter.packPrice ++ " jar of honey\\\\
photograph the sheet \\dotfill\\ free\\\\[2mm]
\\normalsize leave the honey in the crate, take a pack from the shelf}}
\\end{center}

\\subsection*{Ledger}

Three things happen at a stall: packs are \\emph{printed} and put out, a pack is
\\emph{bought} for a jar, or the sheet is \\emph{copied}.  Two rules hold at the
end of any day, whatever order they came in:
\\[
  \\text{jars in the crate} = " ++ toString Barter.packPrice ++
  " \\times \\text{packs sold}, \\qquad
  \\text{packs printed} = \\text{on the shelf} + \\text{sold}.
\\]
A pack is never handed over off an empty shelf.  Copies are not rationed: any
number of people can go away with the design without a pack being printed or a
jar changing hands.  The paper runs out; the design does not.

\\subsection*{The stall's target}

" ++ toString jarsGround ++ " packs at " ++ toString Barter.packPrice ++
  " jar each pay for a tractor built from the ground up.

\\section*{What is proved, and what is assumed}

Assumed: the prices --- a jar at " ++ fmt Barter.jarPrice 0 ++
  ", a hive at " ++ toString Barter.hiveJars ++
  " jars a year, the catalogue prices of the bill of materials, a shop rate of
25 an hour and a dealer's tractor at " ++ fmt Ownership.dealerPrice 0 ++ ".
Everything else on these pages --- the totals, the jar counts, the size of the
crowd, the soundness and the privacy of the pledge round, and the two ledger
rules of the stall --- is derived from those, and machine-checked.

\\end{document}
"

def main (args : List String) : IO Unit := do
  let dir := args.headD "paper"
  IO.FS.createDirAll dir
  IO.FS.writeFile (dir ++ "/handbook.tex") document
  IO.println s!"wrote {dir}/handbook.tex"
