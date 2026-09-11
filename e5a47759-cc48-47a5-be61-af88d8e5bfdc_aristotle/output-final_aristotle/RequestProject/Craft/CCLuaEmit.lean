import RequestProject.Craft.CCLuaRename

/-!
# Printing, ciphering and the demo program

This file closes the chain that `cclua.html` displays:

* `printS` turns a Lua0 program into Lua source text.  It is a transcription:
  there is no semantics of real Lua in this development, so nothing is proved
  about the *text* — only about the Lua0 syntax tree it prints.
* `jsonS` serialises the same tree, so that the page can run it with a
  transcription of `execL`.  Also unverified for the same reason.
* `cipher` is an XOR stream cipher driven by a linear congruential generator;
  `cipher_involutive` proves its round trip, which is what lets the page ship
  the emitted code encrypted and decrypt it at load time.
* `demoTS` is a hopper-style TS0 program — sweep the slots of one peripheral
  and push their contents into another — and `demoLua`, `demoObf`, `demoText`
  are its compilation, its obfuscation, and the text the page carries.

Every theorem of `RequestProject.CCLuaCompile` and `RequestProject.CCLuaRename`
applies to `demoObf`, in particular `emitted_exec` and `emitted_conserves`.
-/

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace CCLua

open Hopper

/-! ## Printing Lua0 as Lua text (a transcription) -/

/-- Print a Lua0 expression, fully parenthesised. -/
def printE : LExp → String
  | .num n => toString n
  | .bool b => if b then "true" else "false"
  | .var x => x
  | .add a b => "(" ++ printE a ++ " + " ++ printE b ++ ")"
  | .sub a b => "(" ++ printE a ++ " - " ++ printE b ++ ")"
  | .mul a b => "(" ++ printE a ++ " * " ++ printE b ++ ")"
  | .lt a b => "(" ++ printE a ++ " < " ++ printE b ++ ")"
  | .eq a b => "(" ++ printE a ++ " == " ++ printE b ++ ")"
  | .ne a b => "(" ++ printE a ++ " ~= " ++ printE b ++ ")"
  | .andE a b => "(" ++ printE a ++ " and " ++ printE b ++ ")"
  | .orE a b => "(" ++ printE a ++ " or " ++ printE b ++ ")"
  | .size a b => "getItemCount(" ++ printE a ++ ", " ++ printE b ++ ")"

/-- Two spaces per indentation level. -/
def indentOf (n : ℕ) : String := String.ofList (List.replicate (2 * n) ' ')

/-- Print a Lua0 statement as Lua source text. -/
def printS (ind : ℕ) : LStmt → String
  | .skip => ""
  | .seq s1 s2 => printS ind s1 ++ printS ind s2
  | .localD x e => indentOf ind ++ "local " ++ x ++ " = " ++ printE e ++ "\n"
  | .assign x e => indentOf ind ++ x ++ " = " ++ printE e ++ "\n"
  | .ifElse c s1 s2 =>
      indentOf ind ++ "if " ++ printE c ++ " then\n" ++ printS (ind + 1) s1 ++
      indentOf ind ++ "else\n" ++ printS (ind + 1) s2 ++ indentOf ind ++ "end\n"
  | .whileDo c body =>
      indentOf ind ++ "while " ++ printE c ++ " do\n" ++ printS (ind + 1) body ++
      indentOf ind ++ "end\n"
  | .pushCall x es ed ei ej ea =>
      indentOf ind ++ "local " ++ x ++ " = pushItems(" ++ printE es ++ ", " ++
      printE ed ++ ", " ++ printE ei ++ ", " ++ printE ej ++ ", " ++ printE ea ++ ")\n"

/-! ## Printing TS0 as TypeScript text (a transcription) -/

/-- Print a TS0 expression, fully parenthesised. -/
def printTE : TExp → String
  | .lit n => toString n
  | .var x => x
  | .add a b => "(" ++ printTE a ++ " + " ++ printTE b ++ ")"
  | .sub a b => "(" ++ printTE a ++ " - " ++ printTE b ++ ")"
  | .mul a b => "(" ++ printTE a ++ " * " ++ printTE b ++ ")"
  | .lt a b => "(" ++ printTE a ++ " < " ++ printTE b ++ ")"
  | .ne a b => "(" ++ printTE a ++ " !== " ++ printTE b ++ ")"
  | .notE a => "(!" ++ printTE a ++ ")"
  | .andT a b => "(" ++ printTE a ++ " && " ++ printTE b ++ ")"
  | .orT a b => "(" ++ printTE a ++ " || " ++ printTE b ++ ")"
  | .size a b => "getItemCount(" ++ printTE a ++ ", " ++ printTE b ++ ")"

/-- Print a TS0 statement as TypeScript source text. -/
def printTS (ind : ℕ) : TStmt → String
  | .skip => ""
  | .seq s1 s2 => printTS ind s1 ++ printTS ind s2
  | .letD x e => indentOf ind ++ "let " ++ x ++ " = " ++ printTE e ++ ";\n"
  | .assign x e => indentOf ind ++ x ++ " = " ++ printTE e ++ ";\n"
  | .incr x => indentOf ind ++ x ++ "++;\n"
  | .ifElse c s1 s2 =>
      indentOf ind ++ "if (" ++ printTE c ++ ") {\n" ++ printTS (ind + 1) s1 ++
      indentOf ind ++ "} else {\n" ++ printTS (ind + 1) s2 ++ indentOf ind ++ "}\n"
  | .whileDo c body =>
      indentOf ind ++ "while (" ++ printTE c ++ ") {\n" ++ printTS (ind + 1) body ++
      indentOf ind ++ "}\n"
  | .push x es ed ei ej ea =>
      indentOf ind ++ "let " ++ x ++ " = pushItems(" ++ printTE es ++ ", " ++
      printTE ed ++ ", " ++ printTE ei ++ ", " ++ printTE ej ++ ", " ++ printTE ea ++ ");\n"

/-! ## Serialising Lua0 as JSON (a transcription) -/

/-- A JSON string literal for an identifier (identifiers here contain no
characters needing an escape). -/
def jsonStr (x : String) : String := "\"" ++ x ++ "\""

/-- Serialise a Lua0 expression. -/
def jsonE : LExp → String
  | .num n => "[\"num\"," ++ toString n ++ "]"
  | .bool b => "[\"bool\"," ++ (if b then "true" else "false") ++ "]"
  | .var x => "[\"var\"," ++ jsonStr x ++ "]"
  | .add a b => "[\"add\"," ++ jsonE a ++ "," ++ jsonE b ++ "]"
  | .sub a b => "[\"sub\"," ++ jsonE a ++ "," ++ jsonE b ++ "]"
  | .mul a b => "[\"mul\"," ++ jsonE a ++ "," ++ jsonE b ++ "]"
  | .lt a b => "[\"lt\"," ++ jsonE a ++ "," ++ jsonE b ++ "]"
  | .eq a b => "[\"eq\"," ++ jsonE a ++ "," ++ jsonE b ++ "]"
  | .ne a b => "[\"ne\"," ++ jsonE a ++ "," ++ jsonE b ++ "]"
  | .andE a b => "[\"and\"," ++ jsonE a ++ "," ++ jsonE b ++ "]"
  | .orE a b => "[\"or\"," ++ jsonE a ++ "," ++ jsonE b ++ "]"
  | .size a b => "[\"size\"," ++ jsonE a ++ "," ++ jsonE b ++ "]"

/-- Serialise a Lua0 statement. -/
def jsonS : LStmt → String
  | .skip => "[\"skip\"]"
  | .seq s1 s2 => "[\"seq\"," ++ jsonS s1 ++ "," ++ jsonS s2 ++ "]"
  | .localD x e => "[\"local\"," ++ jsonStr x ++ "," ++ jsonE e ++ "]"
  | .assign x e => "[\"assign\"," ++ jsonStr x ++ "," ++ jsonE e ++ "]"
  | .ifElse c s1 s2 => "[\"if\"," ++ jsonE c ++ "," ++ jsonS s1 ++ "," ++ jsonS s2 ++ "]"
  | .whileDo c body => "[\"while\"," ++ jsonE c ++ "," ++ jsonS body ++ "]"
  | .pushCall x es ed ei ej ea =>
      "[\"push\"," ++ jsonStr x ++ "," ++ jsonE es ++ "," ++ jsonE ed ++ "," ++
      jsonE ei ++ "," ++ jsonE ej ++ "," ++ jsonE ea ++ "]"

/-! ## A stream cipher with a proved round trip -/

/-- The linear congruential generator driving the key stream. -/
def lcgNext (seed : ℕ) : ℕ := (1103515245 * seed + 12345) % 2147483648

/-- The key byte extracted from a generator state. -/
def keyByte (seed : ℕ) : UInt8 := UInt8.ofNat ((seed / 65536) % 256)

/-- Encrypt (equivalently, decrypt) a byte string with the key stream started
at `seed`. -/
def cipher (seed : ℕ) : List UInt8 → List UInt8
  | [] => []
  | b :: bs => (b ^^^ keyByte seed) :: cipher (lcgNext seed) bs

theorem xor_self_cancel (b k : UInt8) : (b ^^^ k) ^^^ k = b := by
  refine UInt8.toBitVec_injective ?_
  simp only [UInt8.toBitVec_xor, BitVec.xor_assoc, BitVec.xor_self, BitVec.xor_zero]

/-- **The cipher round trip.**  Applying the cipher twice with the same seed
returns the original bytes, so the page recovers exactly the emitted text. -/
theorem cipher_involutive (seed : ℕ) (bs : List UInt8) :
    cipher seed (cipher seed bs) = bs := by
  induction bs generalizing seed with
  | nil => rfl
  | cons b bs ih => simp only [cipher, xor_self_cancel, ih]

/-- The cipher never changes the length of its input. -/
theorem cipher_length (seed : ℕ) (bs : List UInt8) :
    (cipher seed bs).length = bs.length := by
  induction bs generalizing seed with
  | nil => rfl
  | cons b bs ih => simp only [cipher, List.length_cons, ih]

/-! ## The demo program

A hopper: walk the slots of peripheral `0` and push whatever is there into the
matching slot of peripheral `1`, accumulating the number of items moved.  The
condition `if (getItemCount(0, i))` is exactly the place where TypeScript and
Lua truthiness disagree: in Lua, `0` is true. -/

/-- The number of slots the demo program sweeps. -/
def demoSlots : Int := 4

/-- The demo TS0 program. -/
def demoTS : TStmt :=
  .seq (.letD "i" (.lit 0)) <|
  .seq (.letD "moved" (.lit 0)) <|
  .whileDo (.lt (.var "i") (.lit demoSlots)) <|
    .seq (.ifElse (.size (.lit 0) (.var "i"))
            (.seq (.push "k" (.lit 0) (.lit 1) (.var "i") (.var "i") (.lit 64))
                  (.assign "moved" (.add (.var "moved") (.var "k"))))
            .skip)
         (.incr "i")

/-- Its compilation to Lua0. -/
def demoLua : LStmt := cS demoTS

/-- The identifiers the obfuscation renumbers. -/
def demoNames : List Name := ["i", "moved", "k"]

/-- The compiled program after the identifier-destroying pass. -/
def demoObf : LStmt := renS (obfWith demoNames) demoLua

/-- The Lua text the page carries. -/
def demoText : String := printS 0 demoObf

/-- The JSON syntax tree the page runs. -/
def demoJson : String := jsonS demoObf

/-- The seed of the key stream used for the page payload. -/
def demoSeed : ℕ := 20260831

/-- The encrypted Lua text. -/
def demoTextEnc : List UInt8 := cipher demoSeed demoText.toUTF8.toList

/-- The encrypted syntax tree. -/
def demoJsonEnc : List UInt8 := cipher demoSeed demoJson.toUTF8.toList

/-- **What the page decrypts is what Lean printed.** -/
theorem demoTextEnc_decrypt : cipher demoSeed demoTextEnc = demoText.toUTF8.toList :=
  cipher_involutive demoSeed _

/-- **What the page runs is the tree Lean serialised.** -/
theorem demoJsonEnc_decrypt : cipher demoSeed demoJsonEnc = demoJson.toUTF8.toList :=
  cipher_involutive demoSeed _

/-! ## Sanity checks by evaluation -/

/-- A stack limit of 64 for every item. -/
def demoLimit : Item → ℕ := fun _ => 64

/-- A small example network: peripheral `0` holds some cobblestone and dirt,
peripheral `1` is empty. -/
def demoNet : Network :=
  [[some ⟨"minecraft:cobblestone", 50⟩, none, some ⟨"minecraft:dirt", 12⟩, none],
   [none, none, none, none]]

/-- The starting state. -/
def demoState : TState := { env := [], net := demoNet }

-- The source program and the emitted program agree, and nothing is lost.
#guard (execT demoLimit 100 demoTS demoState).map (fun st => st.net) =
  some [[none, none, none, none],
        [some ⟨"minecraft:cobblestone", 50⟩, none, some ⟨"minecraft:dirt", 12⟩, none]]

#guard (execL demoLimit 100 demoObf (renState (obfWith demoNames) (toLState demoState))).map
    (fun st => st.net) = (execT demoLimit 100 demoTS demoState).map (fun st => st.net)

#guard (execT demoLimit 100 demoTS demoState).map
    (fun st => netCount st.net "minecraft:cobblestone") = some 50

#guard (execT demoLimit 100 demoTS demoState).map
    (fun st => (st.env.lookup "moved").getD 0) = some 62

end CCLua
