/-
Generate `tests/data/kernel-golden.json`: a corpus of flattened programs and the
values the **Lean definitions** give for them.

    bash scripts/gen-kernel-golden.sh

Everything printed here is produced by running
`Hesper.Anim.Kernel.exec Hesper.Anim.Kernel.floatOps` — the same definition the
refinement theorems in `RequestProject/Anim/ExprKernel.lean` are about — over
programs produced by `Hesper.Anim.Kernel.Wire.encode (Hesper.Anim.Kernel.compile ·)`.
`tests/node/test_kernel.mjs` then replays the corpus through the WebAssembly
kernel and through the JavaScript reference evaluator and requires bit-for-bit
agreement, which is what "the shipped kernel is checked against the Lean
definition" means concretely.

The corpus deliberately contains the carve-out cases as named entries —
division by zero, comparisons at a tie, NaN inputs, a program at the stack
limit — rather than hoping random generation stumbles into them.  The random
part is a seeded LCG and the seed is in the file.
-/
import RequestProject.Anim.ExprFlat

open Hesper.Anim
open Hesper.Anim.Kernel

namespace KernelGolden

/-- Floats travel as their exact bit pattern, in decimal. -/
def bits (x : Float) : String := toString x.toBits.toNat

/-- A seeded LCG, so the corpus is reproducible from the seed alone. -/
abbrev R := StateM UInt64

def rnd : R Nat := do
  let s ← get
  let s' := s * 6364136223846793005 + 1442695040888963407
  set s'
  return (s' >>> 33).toNat

def rndRange (n : Nat) : R Nat := do
  if n == 0 then return 0
  let v ← rnd
  return v % n

/-- Literals: a mix of small integers and simple fractions, plus the odd
awkward value. -/
def rndFloat : R Float := do
  let a ← rndRange 401
  let b ← rndRange 8
  let n := Float.ofInt ((a : Int) - 200)
  return if b == 0 then n else n / Float.ofNat (b + 1)

def allBinOps : List BinOp :=
  [.add, .sub, .mul, .div, .mod, .pow, .lt, .le, .gt, .ge, .eq, .ne, .and, .or]

/-- A random expression of bounded depth over `nvars` variables. -/
def randTree (nvars : Nat) : Nat → R (Kernel.Tree Float)
  | 0 => do
      let c ← rndRange 3
      if c == 0 then return .num (← rndFloat) else return .var (← rndRange nvars)
  | fuel + 1 => do
      let c ← rndRange 11
      match c with
      | 0 => return .num (← rndFloat)
      | 1 => return .var (← rndRange nvars)
      | 2 => return .neg (← randTree nvars fuel)
      | 3 | 4 | 5 =>
          return .bin (allBinOps.getD (← rndRange allBinOps.length) .add)
            (← randTree nvars fuel) (← randTree nvars fuel)
      | 6 => return .cond (← randTree nvars fuel) (← randTree nvars fuel) (← randTree nvars fuel)
      | 7 => return .un (← rndRange unaryNames.length) (← randTree nvars fuel)
      | 8 => return .bin₂ (← rndRange binaryNames.length)
              (← randTree nvars fuel) (← randTree nvars fuel)
      | 9 => return .tern (← rndRange ternaryNames.length)
              (← randTree nvars fuel) (← randTree nvars fuel) (← randTree nvars fuel)
      | _ => return .bin .mul (← randTree nvars fuel) (← randTree nvars fuel)

/-- One corpus entry. -/
structure Case where
  name : String
  tree : Kernel.Tree Float
  nvars : Nat
  envs : List (List Float)

/-- The environments most random cases are evaluated at. -/
def stdEnvs : List (List Float) :=
  [ [0.0, 0.0, 0.0],
    [1.0, -1.0, 0.5],
    [2.5, 3.25, -0.75],
    [-4.0, 0.125, 7.0],
    [1e8, -1e-8, 3.0],
    [0.0, 1.0, 0.0 / 0.0],
    [1.0 / 0.0, -1.0 / 0.0, 1.0] ]

/-- The named carve-outs: the cases a random generator would rarely reach and
that a backend disagreement is most likely to hide in. -/
def carveOuts : List Case :=
  let x : Kernel.Tree Float := .var 0
  let y : Kernel.Tree Float := .var 1
  [ { name := "div-by-zero", tree := .bin .div x y, nvars := 2,
      envs := [[1.0, 0.0], [-1.0, 0.0], [0.0, 0.0], [1.0, 1.0]] },
    { name := "mod-by-zero", tree := .bin .mod x y, nvars := 2,
      envs := [[5.0, 0.0], [5.0, 3.0], [-5.0, 3.0]] },
    { name := "compare-at-a-tie", tree := .bin .lt x y, nvars := 2,
      envs := [[1.0, 1.0], [1.0, 1.0000000000000002], [0.1 + 0.2, 0.3],
               [0.0 / 0.0, 1.0], [1.0, 0.0 / 0.0]] },
    { name := "equality-of-a-rounded-sum", tree := .bin .eq (.bin .add x y) (.num 0.3), nvars := 2,
      envs := [[0.1, 0.2], [0.15, 0.15], [0.3, 0.0]] },
    { name := "nan-propagation", tree := .bin .add (.un 0 x) (.un 9 y), nvars := 2,
      envs := [[0.0 / 0.0, 1.0], [1.0, 0.0 / 0.0], [1.0 / 0.0, 1.0]] },
    { name := "signed-zero", tree := .bin₂ 3 x y, nvars := 2,
      envs := [[0.0, -0.0], [-0.0, 0.0], [0.0 / 0.0, 1.0]] },
    { name := "round-half", tree := .un 16 x, nvars := 1,
      envs := [[-0.5], [0.5], [2.5], [-2.5], [1.5]] },
    { name := "pow-edge", tree := .bin .pow x y, nvars := 2,
      envs := [[-8.0, 1.0 / 3.0], [0.0, 0.0], [-1.0, 0.5], [2.0, 1024.0]] },
    { name := "if-takes-one-branch", tree := .cond x (.bin .div (.num 1.0) y) (.num 7.0), nvars := 2,
      envs := [[0.0, 0.0], [1.0, 0.0], [1.0, 2.0], [0.0 / 0.0, 2.0], [1.0 / 0.0, 2.0]] },
    { name := "sqrt-of-negative", tree := .un 10 x, nvars := 1,
      envs := [[-1.0], [0.0], [-0.0], [2.0]] },
    { name := "log-of-zero", tree := .un 17 x, nvars := 1,
      envs := [[0.0], [-1.0], [1.0]] },
    { name := "smoothstep-degenerate", tree := .tern 1 x y (.var 2), nvars := 3,
      envs := [[1.0, 1.0, 0.5], [0.0, 1.0, 0.5], [1.0, 0.0, 0.25]] },
    { name := "deep-left-spine", tree := deepSpine 40, nvars := 1,
      envs := [[1.5], [-1.0], [0.0]] } ]
where
  /-- `((((x+1)+1)+1)…)`: a program whose stack stays shallow but whose word
  count is large. -/
  deepSpine : Nat → Kernel.Tree Float
    | 0 => .var 0
    | n + 1 => .bin .add (deepSpine n) (.num 1.0)

def randomCases (n : Nat) (seed : UInt64) : List Case :=
  let rec go : Nat → UInt64 → List Case → List Case
    | 0, _, acc => acc.reverse
    | k + 1, s, acc =>
        let (t, s') := (randTree 3 4).run s
        go k s' ({ name := s!"random-{n - k}", tree := t, nvars := 3, envs := stdEnvs } :: acc)
  go n seed []

/-- Emit one case as JSON: the wire program, the environments and the values
`Kernel.exec` gives for them. -/
def render (c : Case) : String :=
  let code := compile c.tree
  let w := Wire.encode code
  let words := String.intercalate "," (w.words.map fun p => s!"[{p.1},{p.2}]")
  let consts := String.intercalate "," (w.consts.map fun v => "\"" ++ bits v ++ "\"")
  let envRow (row : List Float) : String :=
    "[" ++ String.intercalate "," (row.map fun v => "\"" ++ bits v ++ "\"") ++ "]"
  let envs := String.intercalate "," (c.envs.map envRow)
  let resultOf (row : List Float) : String :=
    match exec floatOps (fun i => row.getD i 0.0) code with
    | some v => "\"" ++ bits v ++ "\""
    | none => "null"
  let results := String.intercalate "," (c.envs.map resultOf)
  "{\"name\":\"" ++ c.name ++ "\",\"nvars\":" ++ toString c.nvars ++
    ",\"words\":[" ++ words ++ "],\"consts\":[" ++ consts ++
    "],\"envs\":[" ++ envs ++ "],\"results\":[" ++ results ++ "]}"

def seed : UInt64 := 0x5265734859

def corpus : List Case := carveOuts ++ randomCases 240 seed

def document : String :=
  "{\n  \"note\": \"Generated by scripts/lean/KernelGolden.lean. Every result is the value of Hesper.Anim.Kernel.exec Hesper.Anim.Kernel.floatOps, as a decimal IEEE-754 bit pattern. Do not edit by hand.\",\n" ++
  "  \"seed\": \"" ++ toString seed.toNat ++ "\",\n" ++
  "  \"unaryNames\": [" ++ String.intercalate "," (unaryNames.map fun s => "\"" ++ s ++ "\"") ++ "],\n" ++
  "  \"binaryNames\": [" ++ String.intercalate "," (binaryNames.map fun s => "\"" ++ s ++ "\"") ++ "],\n" ++
  "  \"ternaryNames\": [" ++ String.intercalate "," (ternaryNames.map fun s => "\"" ++ s ++ "\"") ++ "],\n" ++
  "  \"cases\": [\n    " ++ String.intercalate ",\n    " (corpus.map render) ++ "\n  ]\n}\n"

def write : IO Unit := do
  IO.FS.createDirAll "tests/data"
  IO.FS.writeFile "tests/data/kernel-golden.json" document
  IO.println s!"wrote tests/data/kernel-golden.json ({corpus.length} cases)"

end KernelGolden

#eval KernelGolden.write
