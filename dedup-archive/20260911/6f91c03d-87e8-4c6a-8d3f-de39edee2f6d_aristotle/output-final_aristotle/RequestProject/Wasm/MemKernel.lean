/-
# The FNV-1a digest of a buffer, as a wasm function over linear memory

`RequestProject.Wasm.Kernel` exports one FNV-1a *step*; the fold over a
buffer had to be done by the caller.  With the loop and memory fragment of
`RequestProject.Wasm.Mem` the whole digest is one exported function:

```wat
(func (export "fnv1a_mem") (param $ptr i64) (param $len i64) (result i64)
  (local $acc i64) (local $i i64) (local $byte i64)
  … acc := 14695981039346656037 …
  (block (loop
    (br_if 1 (i64.ge_u (local.get $i) (local.get $len)))
    (local.set $byte (i64.load8_u (i32.wrap_i64 (i64.add (local.get $ptr) (local.get $i)))))
    (local.set $acc (i64.mul (i64.xor (local.get $acc) (local.get $byte))
                             (i64.const 1099511628211)))
    (local.set $i (i64.add (local.get $i) (i64.const 1)))
    (br 0)))
  (local.get $acc))
```

`RequestProject.Wasm.MemKernelSpec` proves that running it under the
semantics of `RequestProject.Wasm.Mem` returns `Kant.Bytes.fnv1a` of the
bytes in memory.

Mathlib-free by design.
-/
import RequestProject.Wasm.Mem

namespace Kant.Wasm.MemKernel

open Kant.Wasm
open Kant.Wasm.Expr

/-- The FNV-1a 64-bit prime. -/
def fnvPrimeConst : Nat := 1099511628211

/-- The FNV-1a offset basis `14695981039346656037`, written as `2·k + 1`
because `i64.const` is encoded with *signed* LEB128 and the basis exceeds
`2^63`. -/
def fnvInitE : Expr := add (mul (const 2) (const 7347990519673328018)) (const 1)

/-- The accumulator step: `acc := (acc ^ byte) * prime`, with `acc` in
local 2 and the byte just read in local 4. -/
def fnvBodyE : Expr := mul (Expr.xor (var 2) (var 4)) (const fnvPrimeConst)

theorem fnvInitE_wf : Expr.Wf 5 fnvInitE :=
  Expr.wf_of_wfb (by decide)

theorem fnvBodyE_wf : Expr.Wf 5 fnvBodyE :=
  Expr.wf_of_wfb (by decide)

/-- The instruction sequence of the exported `fnv1a_mem`. -/
def fnvMemProgram : List MInstr := Fold.program fnvInitE fnvBodyE

/-- Running `fnv1a_mem(ptr, len)` under the Lean semantics. -/
def runFnvMem (mem : Mem) (ptr len : Nat) : Option UInt64 :=
  Fold.run mem fnvInitE fnvBodyE ptr len

end Kant.Wasm.MemKernel
