import RequestProject.ScratchEmit

/-!
Emits the payload of `scratch.html`: the starter block project, the blocks as
text, the TypeScript and Lua the verified compilers produce from them, the Lua
syntax tree the page interprets, and the encrypted forms of the project and of
the Lua text.
-/

open ScratchCC CCLua

def bytesLit (bs : List UInt8) : String :=
  "[" ++ String.intercalate "," (bs.map (fun b => toString b.toNat)) ++ "]"

def main : IO Unit := do
  IO.println "=== BLOCKS ==="
  IO.println starterBlockText
  IO.println "=== PROJECT ==="
  IO.println starterJson
  IO.println "=== TS ==="
  IO.println starterTSText
  IO.println "=== LUA ==="
  IO.println starterLuaText
  IO.println "=== LUAJSON ==="
  IO.println starterLuaJson
  IO.println "=== SEED ==="
  IO.println scratchSeed
  IO.println "=== PROJECTENC ==="
  IO.println (bytesLit starterJsonEnc)
  IO.println "=== LUAENC ==="
  IO.println (bytesLit starterLuaEnc)
