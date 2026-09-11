import RequestProject.CCLuaEmit

/-!
Emits the payload of `cclua.html`: the Lua text the verified compiler produced,
its JSON syntax tree, and both of them encrypted with the Lean cipher.
-/

open CCLua

def bytesLit (bs : List UInt8) : String :=
  "[" ++ String.intercalate "," (bs.map (fun b => toString b.toNat)) ++ "]"

def main : IO Unit := do
  IO.println "=== TS ==="
  IO.println (printTS 0 demoTS)
  IO.println "=== SOURCE ==="
  IO.println (printS 0 demoLua)
  IO.println "=== TEXT ==="
  IO.println demoText
  IO.println "=== JSON ==="
  IO.println demoJson
  IO.println "=== SEED ==="
  IO.println demoSeed
  IO.println "=== TEXTENC ==="
  IO.println (bytesLit demoTextEnc)
  IO.println "=== JSONENC ==="
  IO.println (bytesLit demoJsonEnc)
