import RequestProject.Craft.Scratch
import RequestProject.Craft.CCLuaEmit

/-!
# Printing blocks, and the starter project of the block editor

This file closes the chain that `scratch.html` displays:

* `printScript` renders a block script the way a Scratch editor reads it, and
  `jsonScript` serialises it in the format the editor's project file uses.
  Both are transcriptions: nothing is proved about the *text*, only about the
  block syntax tree it renders.
* `starterScript` is the project the page opens with — a hopper built out of
  blocks — and `starterTSText` / `starterLuaText` are the TypeScript and the
  ComputerCraft Lua that the verified compilers produce from it.
* The payload travels encrypted with the cipher of `RequestProject.CCLuaEmit`,
  whose round trip is proved, and is decrypted by the page at load time.

Every theorem of `RequestProject.Scratch` applies to `starterScript`; in
particular it is shape-correct (`starter_wf`), so `scratch_toLua_exec`,
`scratch_conserves` and `scratch_valid` all apply to it, and its run on the
sample network is checked here by evaluation.
-/

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace ScratchCC

open Hopper CCLua

/-! ## Rendering blocks as Scratch-style text (a transcription) -/

/-- Render a reporter block: round brackets for numbers, angle brackets for
booleans. -/
def printRep : Rep → String
  | .numB n => "(" ++ toString n ++ ")"
  | .varB x => "(" ++ x ++ ")"
  | .addB a b => "(" ++ printRep a ++ " + " ++ printRep b ++ ")"
  | .subB a b => "(" ++ printRep a ++ " - " ++ printRep b ++ ")"
  | .mulB a b => "(" ++ printRep a ++ " * " ++ printRep b ++ ")"
  | .countB p s => "(items in slot " ++ printRep s ++ " of chest " ++ printRep p ++ ")"
  | .ltB a b => "<" ++ printRep a ++ " < " ++ printRep b ++ ">"
  | .gtB a b => "<" ++ printRep a ++ " > " ++ printRep b ++ ">"
  | .eqB a b => "<" ++ printRep a ++ " = " ++ printRep b ++ ">"
  | .notB a => "<not " ++ printRep a ++ ">"
  | .andB a b => "<" ++ printRep a ++ " and " ++ printRep b ++ ">"
  | .orB a b => "<" ++ printRep a ++ " or " ++ printRep b ++ ">"

mutual

/-- Render one stack block at the given indentation. -/
def printBlk (ind : ℕ) : Blk → String
  | .setVar x e => indentOf ind ++ "set " ++ x ++ " to " ++ printRep e ++ "\n"
  | .changeVar x e => indentOf ind ++ "change " ++ x ++ " by " ++ printRep e ++ "\n"
  | .move x src i dst j amt =>
      indentOf ind ++ "move " ++ printRep amt ++ " items from chest " ++ printRep src ++
      " slot " ++ printRep i ++ " to chest " ++ printRep dst ++ " slot " ++ printRep j ++
      " into " ++ x ++ "\n"
  | .ifB c body =>
      indentOf ind ++ "if " ++ printRep c ++ " then\n" ++ printScr (ind + 1) body ++
      indentOf ind ++ "end\n"
  | .ifElseB c t e =>
      indentOf ind ++ "if " ++ printRep c ++ " then\n" ++ printScr (ind + 1) t ++
      indentOf ind ++ "else\n" ++ printScr (ind + 1) e ++ indentOf ind ++ "end\n"
  | .repeatB n body =>
      indentOf ind ++ "repeat " ++ toString n ++ "\n" ++ printScr (ind + 1) body ++
      indentOf ind ++ "end\n"
  | .repeatUntilB c body =>
      indentOf ind ++ "repeat until " ++ printRep c ++ "\n" ++ printScr (ind + 1) body ++
      indentOf ind ++ "end\n"

/-- Render a stack of blocks. -/
def printScr (ind : ℕ) : Script → String
  | [] => ""
  | b :: r => printBlk ind b ++ printScr ind r

end

/-! ## Serialising blocks as the editor's project format (a transcription) -/

/-- Serialise a reporter block. -/
def jsonRep : Rep → String
  | .numB n => "[\"num\"," ++ toString n ++ "]"
  | .varB x => "[\"var\"," ++ jsonStr x ++ "]"
  | .addB a b => "[\"add\"," ++ jsonRep a ++ "," ++ jsonRep b ++ "]"
  | .subB a b => "[\"sub\"," ++ jsonRep a ++ "," ++ jsonRep b ++ "]"
  | .mulB a b => "[\"mul\"," ++ jsonRep a ++ "," ++ jsonRep b ++ "]"
  | .countB p s => "[\"count\"," ++ jsonRep p ++ "," ++ jsonRep s ++ "]"
  | .ltB a b => "[\"lt\"," ++ jsonRep a ++ "," ++ jsonRep b ++ "]"
  | .gtB a b => "[\"gt\"," ++ jsonRep a ++ "," ++ jsonRep b ++ "]"
  | .eqB a b => "[\"eq\"," ++ jsonRep a ++ "," ++ jsonRep b ++ "]"
  | .notB a => "[\"not\"," ++ jsonRep a ++ "]"
  | .andB a b => "[\"and\"," ++ jsonRep a ++ "," ++ jsonRep b ++ "]"
  | .orB a b => "[\"or\"," ++ jsonRep a ++ "," ++ jsonRep b ++ "]"

mutual

/-- Serialise one stack block. -/
def jsonBlk : Blk → String
  | .setVar x e => "[\"set\"," ++ jsonStr x ++ "," ++ jsonRep e ++ "]"
  | .changeVar x e => "[\"change\"," ++ jsonStr x ++ "," ++ jsonRep e ++ "]"
  | .move x src i dst j amt =>
      "[\"move\"," ++ jsonStr x ++ "," ++ jsonRep src ++ "," ++ jsonRep i ++ "," ++
      jsonRep dst ++ "," ++ jsonRep j ++ "," ++ jsonRep amt ++ "]"
  | .ifB c body => "[\"if\"," ++ jsonRep c ++ "," ++ jsonScr body ++ "]"
  | .ifElseB c t e =>
      "[\"ifelse\"," ++ jsonRep c ++ "," ++ jsonScr t ++ "," ++ jsonScr e ++ "]"
  | .repeatB n body => "[\"repeat\"," ++ toString n ++ "," ++ jsonScr body ++ "]"
  | .repeatUntilB c body => "[\"until\"," ++ jsonRep c ++ "," ++ jsonScr body ++ "]"

/-- Serialise a stack of blocks as a JSON array. -/
def jsonScr : Script → String
  | [] => "[]"
  | b :: r => "[" ++ jsonBlk b ++ String.join ((r.map (fun c => "," ++ jsonBlk c))) ++ "]"

end

/-! ## The starter project

A hopper, built out of blocks: sweep the four slots of chest `0` and move
whatever is there into the matching slot of chest `1`, adding up what moved. -/

/-- The block script the editor opens with. -/
def starterScript : Script :=
  [ .setVar "i" (.numB 0),
    .setVar "moved" (.numB 0),
    .repeatB 4
      [ .ifB (.gtB (.countB (.numB 0) (.varB "i")) (.numB 0))
          [ .move "k" (.numB 0) (.varB "i") (.numB 1) (.varB "i") (.numB 64),
            .setVar "moved" (.addB (.varB "moved") (.varB "k")) ],
        .changeVar "i" (.numB 1) ] ]

/-- The starter project is shape-correct, so every theorem of
`RequestProject.Scratch` applies to it. -/
theorem starter_wf : wfS starterScript = true := by decide

/-- The TS0 program the blocks compile to. -/
def starterTS : TStmt := cScript starterScript

/-- The Lua0 program that the verified TS0 → Lua0 compiler then produces. -/
def starterLua : LStmt := cS starterTS

/-- The blocks, as the editor shows them. -/
def starterBlockText : String := printScr 0 starterScript

/-- The blocks, as the editor's project file. -/
def starterJson : String := jsonScr starterScript

/-- The TypeScript text. -/
def starterTSText : String := printTS 0 starterTS

/-- The ComputerCraft Lua text. -/
def starterLuaText : String := printS 0 starterLua

/-- The Lua syntax tree, for the in-page interpreter. -/
def starterLuaJson : String := jsonS starterLua

/-- The seed of the key stream used for the block editor payload. -/
def scratchSeed : ℕ := 20260904

/-- The encrypted project file. -/
def starterJsonEnc : List UInt8 := cipher scratchSeed starterJson.toUTF8.toList

/-- The encrypted Lua text. -/
def starterLuaEnc : List UInt8 := cipher scratchSeed starterLuaText.toUTF8.toList

/-- **What the editor opens is the project Lean serialised.** -/
theorem starterJsonEnc_decrypt : cipher scratchSeed starterJsonEnc = starterJson.toUTF8.toList :=
  cipher_involutive scratchSeed _

/-- **What the page shows is the Lua Lean printed.** -/
theorem starterLuaEnc_decrypt :
    cipher scratchSeed starterLuaEnc = starterLuaText.toUTF8.toList :=
  cipher_involutive scratchSeed _

/-! ## Sanity checks by evaluation -/

/-- The starting state of the sample run: the sample network of
`RequestProject.CCLuaEmit`. -/
def starterState : TState := { env := [], net := demoNet }

-- The blocks empty chest `0` into chest `1`.
#guard (runScript demoLimit 100 starterScript starterState).map (fun st => st.net) =
  some [[none, none, none, none],
        [some ⟨"minecraft:cobblestone", 50⟩, none, some ⟨"minecraft:dirt", 12⟩, none]]

-- The blocks and the Lua the page runs agree, as `scratch_toLua_exec` says.
#guard (execL demoLimit 100 starterLua (toLState starterState)).map (fun st => st.net) =
  (runScript demoLimit 100 starterScript starterState).map (fun st => st.net)

-- 62 items move, and none is created or destroyed.
#guard (runScript demoLimit 100 starterScript starterState).map
    (fun st => (st.env.lookup "moved").getD 0) = some 62

#guard (runScript demoLimit 100 starterScript starterState).map
    (fun st => netCount st.net "minecraft:cobblestone") = some 50

end ScratchCC
