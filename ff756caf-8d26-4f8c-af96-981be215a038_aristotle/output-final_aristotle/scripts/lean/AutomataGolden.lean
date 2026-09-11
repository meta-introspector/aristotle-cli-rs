/-
Generate `tests/data/automata-golden.json`: a corpus of discrete automata runs
and the values the **Lean definitions** give for them.

    bash scripts/gen-automata-golden.sh

Everything printed here is produced by running the definitions of
`RequestProject/Anim/Automata.lean` — `Hesper.Automata.elemStep`,
`Hesper.Automata.lifeStep`, `Hesper.Automata.antStep` and
`Hesper.Automata.run` — the very definitions the theorems in that file are
about.  `tests/node/test_automata.mjs` then replays the corpus through
`web/js/automata.js` and requires exact agreement, which is what "the shipped
automata are checked against the Lean model" means concretely.

There is no floating point anywhere in this corpus: rows and boards are
booleans and FRACTRAN states are arbitrary-precision naturals, so the
comparison is exact rather than up to a tolerance.
-/
import RequestProject.Anim.Automata

open Hesper.Automata

namespace AutomataGolden

/-- A row of cells as a bit string, `1` for alive. -/
def bits (row : List Bool) : String :=
  String.ofList (row.map fun b => if b then '1' else '0')

def quoted (s : String) : String := "\"" ++ s ++ "\""

def joinWith (sep : String) (xs : List String) : String := String.intercalate sep xs

/-- A seeded LCG, so the corpus is reproducible from the seed alone; the same
generator the JavaScript runtime uses for a random seed row. -/
def lcg (s : Nat) : Nat := (1664525 * s + 1013904223) % 4294967296

/-- `n` pseudo-random bits from `seed`, alive when the draw is below a half —
exactly `HesperAutomata.seedRow(width, 'random', seed, 0.5)`. -/
def randomRow (n seed : Nat) : List Bool :=
  (List.range n).foldl (fun acc _ =>
    let s := lcg (acc.2)
    (acc.1 ++ [decide (s * 2 < 4294967296)], s)) ([], seed % 4294967296) |>.1

/-! ## Elementary automata -/

structure CaCase where
  name : String
  rule : Nat
  seed : List Bool
  gens : Nat

def caCases : List CaCase :=
  let single := fun (n : Nat) => (List.range n).map (fun i => i == n / 2)
  [ { name := "rule30-single", rule := 30, seed := single 41, gens := 20 },
    { name := "rule90-single", rule := 90, seed := single 41, gens := 20 },
    { name := "rule110-single", rule := 110, seed := single 41, gens := 20 },
    { name := "rule110-random", rule := 110, seed := randomRow 41 12345, gens := 20 },
    { name := "rule184-random", rule := 184, seed := randomRow 32 7, gens := 16 },
    { name := "rule54-random", rule := 54, seed := randomRow 32 999, gens := 16 },
    { name := "rule0-random", rule := 0, seed := randomRow 16 5, gens := 3 },
    { name := "rule255-random", rule := 255, seed := randomRow 16 5, gens := 3 },
    { name := "rule150-alt", rule := 150, seed := (List.range 24).map (fun i => i % 2 == 0), gens := 12 } ]

def renderCa (c : CaCase) : String :=
  let rows := evolve c.rule c.seed c.gens
  "{" ++ quoted "name" ++ ":" ++ quoted c.name ++
    "," ++ quoted "rule" ++ ":" ++ toString c.rule ++
    "," ++ quoted "seed" ++ ":" ++ quoted (bits c.seed) ++
    "," ++ quoted "gens" ++ ":" ++ toString c.gens ++
    "," ++ quoted "rows" ++ ":[" ++ joinWith "," (rows.map fun r => quoted (bits r)) ++ "]}"

/-! ## Life-like rules -/

structure LifeCase where
  name : String
  rule : LifeRule
  w : Nat
  h : Nat
  cells : List Bool
  gens : Nat

/-- The cells of a `w × h` board with the listed coordinates alive. -/
def board (w h : Nat) (live : List (Nat × Nat)) : List Bool :=
  (List.range (w * h)).map fun k => live.contains (k % w, k / w)

def lifeCases : List LifeCase :=
  [ { name := "block", rule := conway, w := 8, h := 8,
      cells := board 8 8 [(3,3),(4,3),(3,4),(4,4)], gens := 3 },
    { name := "blinker", rule := conway, w := 9, h := 9,
      cells := board 9 9 [(4,3),(4,4),(4,5)], gens := 4 },
    { name := "glider", rule := conway, w := 16, h := 16,
      cells := board 16 16 [(2,1),(3,2),(1,3),(2,3),(3,3)], gens := 8 },
    { name := "rpentomino", rule := conway, w := 20, h := 20,
      cells := board 20 20 [(9,8),(10,8),(8,9),(9,9),(9,10)], gens := 12 },
    { name := "highlife-soup", rule := highLife, w := 16, h := 16,
      cells := randomRow (16 * 16) 4242, gens := 6 },
    { name := "empty", rule := conway, w := 6, h := 6,
      cells := List.replicate 36 false, gens := 2 } ]

def renderLife (c : LifeCase) : String :=
  let g₀ : Grid := ⟨c.w, c.h, c.cells⟩
  let rec go (g : Grid) : Nat → List Grid
    | 0 => [g]
    | n + 1 => g :: go (lifeStep c.rule g) n
  let gs := go g₀ c.gens
  "{" ++ quoted "name" ++ ":" ++ quoted c.name ++
    "," ++ quoted "rule" ++ ":" ++ quoted ("B" ++ String.join (c.rule.birth.map toString) ++
      "/S" ++ String.join (c.rule.survive.map toString)) ++
    "," ++ quoted "w" ++ ":" ++ toString c.w ++
    "," ++ quoted "h" ++ ":" ++ toString c.h ++
    "," ++ quoted "start" ++ ":" ++ quoted (bits c.cells) ++
    "," ++ quoted "gens" ++ ":" ++ toString c.gens ++
    "," ++ quoted "boards" ++ ":[" ++ joinWith "," (gs.map fun g => quoted (bits g.cells)) ++ "]}"

/-! ## Langton's ant -/

structure AntCase where
  name : String
  w : Nat
  h : Nat
  steps : Nat

def antCases : List AntCase :=
  [ { name := "ant-16", w := 16, h := 16, steps := 40 },
    { name := "ant-24", w := 24, h := 24, steps := 200 },
    { name := "ant-9", w := 9, h := 9, steps := 97 } ]

def renderAnt (c : AntCase) : String :=
  let s₀ : AntState := ⟨⟨c.w, c.h, List.replicate (c.w * c.h) false⟩, ⟨c.w / 2, c.h / 2, 0⟩⟩
  let rec go (s : AntState) : Nat → AntState
    | 0 => s
    | n + 1 => go (antStep s) n
  let s := go s₀ c.steps
  -- the inverse step really does undo the last one, checked here as data
  let back := antStepInv s
  let backOne := go s₀ (c.steps - 1)
  "{" ++ quoted "name" ++ ":" ++ quoted c.name ++
    "," ++ quoted "w" ++ ":" ++ toString c.w ++
    "," ++ quoted "h" ++ ":" ++ toString c.h ++
    "," ++ quoted "steps" ++ ":" ++ toString c.steps ++
    "," ++ quoted "cells" ++ ":" ++ quoted (bits s.grid.cells) ++
    "," ++ quoted "head" ++ ":[" ++ toString s.head.x ++ "," ++ toString s.head.y ++
      "," ++ toString s.head.dir ++ "]" ++
    "," ++ quoted "reversible" ++ ":" ++ (if back == backOne then "true" else "false") ++ "}"

/-! ## FRACTRAN -/

structure FracCase where
  name : String
  prog : List Frac
  start : Nat
  fuel : Nat

def primegame : List Frac :=
  [⟨17,91⟩, ⟨78,85⟩, ⟨19,51⟩, ⟨23,38⟩, ⟨29,33⟩, ⟨77,29⟩, ⟨95,23⟩, ⟨77,19⟩,
   ⟨1,17⟩, ⟨11,13⟩, ⟨13,11⟩, ⟨15,2⟩, ⟨1,7⟩, ⟨55,1⟩]

def multiply : List Frac :=
  [⟨455,33⟩, ⟨11,13⟩, ⟨1,11⟩, ⟨3,7⟩, ⟨11,2⟩, ⟨1,3⟩]

def fracCases : List FracCase :=
  [ { name := "add-2^5*3^2", prog := [⟨3,2⟩], start := 2^5 * 3^2, fuel := 12 },
    { name := "add-2^0*3^4", prog := [⟨3,2⟩], start := 3^4, fuel := 4 },
    { name := "multiply-3x4", prog := multiply, start := 2^3 * 3^4, fuel := 200 },
    { name := "primegame", prog := primegame, start := 2, fuel := 120 } ]

def renderFrac (c : FracCase) : String :=
  let states := run c.prog c.start c.fuel
  "{" ++ quoted "name" ++ ":" ++ quoted c.name ++
    "," ++ quoted "program" ++ ":" ++
      quoted (joinWith " " (c.prog.map fun f => toString f.num ++ "/" ++ toString f.den)) ++
    "," ++ quoted "start" ++ ":" ++ quoted (toString c.start) ++
    "," ++ quoted "fuel" ++ ":" ++ toString c.fuel ++
    "," ++ quoted "halted" ++ ":" ++
      (match states.getLast? with
       | some n => if (step c.prog n).isNone then "true" else "false"
       | none => "true") ++
    "," ++ quoted "states" ++ ":[" ++
      joinWith "," (states.map fun n => quoted (toString n)) ++ "]}"

def document : String :=
  "{\n  " ++ quoted "note" ++ ": " ++ quoted
    ("Generated by scripts/lean/AutomataGolden.lean from the definitions of " ++
     "Hesper.Automata. Every row, board, ant and FRACTRAN state here is the value " ++
     "of the Lean definition. Do not edit by hand.") ++ ",\n" ++
  "  " ++ quoted "ca" ++ ": [\n    " ++ joinWith ",\n    " (caCases.map renderCa) ++ "\n  ],\n" ++
  "  " ++ quoted "life" ++ ": [\n    " ++ joinWith ",\n    " (lifeCases.map renderLife) ++ "\n  ],\n" ++
  "  " ++ quoted "ant" ++ ": [\n    " ++ joinWith ",\n    " (antCases.map renderAnt) ++ "\n  ],\n" ++
  "  " ++ quoted "fractran" ++ ": [\n    " ++ joinWith ",\n    " (fracCases.map renderFrac) ++ "\n  ]\n}\n"

def write : IO Unit := do
  IO.FS.createDirAll "tests/data"
  IO.FS.writeFile "tests/data/automata-golden.json" document
  IO.println s!"wrote tests/data/automata-golden.json ({caCases.length} ca, {lifeCases.length} life, {antCases.length} ant, {fracCases.length} fractran)"

end AutomataGolden

#eval AutomataGolden.write
