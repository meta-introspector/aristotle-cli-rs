/-
# The looping kernel computes the Lean digest

`RequestProject.Wasm.MemKernel` gives the wasm function `fnv1a_mem(ptr,
len)`; `RequestProject.Wasm.Mem` proves that its loop iterates the body
over the bytes of memory.  This module closes the circle: the value the
function returns is `Kant.Bytes.fnv1a` of exactly those bytes, so the
digest the browser client used to fold in JavaScript is now a single
verified WebAssembly call.
-/
import Mathlib
import RequestProject.Wasm.MemKernel
import RequestProject.Kant.Bytes

namespace Kant.Wasm.MemKernel

open Kant.Wasm

/-- The `len` bytes of memory starting at `ptr`, as a `Kant.Bytes.Blob`. -/
def bytesAt (mem : Mem) (ptr len : Nat) : Kant.Bytes.Blob :=
  (List.range len).map fun k => mem (ptr + k)

@[simp] theorem bytesAt_length (mem : Mem) (ptr len : Nat) :
    (bytesAt mem ptr len).length = len := by
  simp [bytesAt]

/-- The initialiser evaluates to the FNV-1a offset basis. -/
theorem eval_fnvInitE (ptr len : Nat) :
    Expr.eval (Fold.initLocals ptr len) fnvInitE = some Kant.Bytes.fnvOffset := by
  simp [fnvInitE, Expr.add, Expr.mul, Expr.eval, BinOp.apply, Kant.Bytes.fnvOffset,
    Fold.initLocals]

/-- The loop body is one FNV-1a round on the byte just read. -/
theorem stepVal_fnvBodyE (mem : Mem) (ptr len i : Nat) (acc : UInt64) :
    Fold.stepVal mem fnvBodyE ptr len i acc = Kant.Bytes.fnvStep acc (mem (ptr + i)) := by
  simp [Fold.stepVal, fnvBodyE, Expr.mul, Expr.xor, Expr.eval, BinOp.apply,
    Kant.Bytes.fnvStep, Kant.Bytes.fnvPrime, fnvPrimeConst]

/-- Iterating the FNV-1a round over indices is the left fold over the
bytes. -/
theorem iterate_fnvStep (mem : Mem) (ptr : Nat) :
    ∀ (n i : Nat) (acc : UInt64),
      Fold.iterate (fun j a => Kant.Bytes.fnvStep a (mem (ptr + j))) n i acc =
        (bytesAt mem (ptr + i) n).foldl Kant.Bytes.fnvStep acc := by
  intro n
  induction n with
  | zero => intro i acc; simp [Fold.iterate, bytesAt]
  | succ n ih =>
      intro i acc
      rw [Fold.iterate, ih (i + 1) _]
      simp [bytesAt, List.range_succ_eq_map, Function.comp_def, Nat.succ_eq_add_one,
        Nat.add_comm, Nat.add_left_comm]

/-- **The exported `fnv1a_mem` computes `Kant.Bytes.fnv1a`.**  For any
buffer that fits in a 32-bit address space, running the emitted function
under the wasm semantics terminates and returns the FNV-1a digest of the
`len` bytes at `ptr`. -/
theorem runFnvMem_eq_fnv1a (mem : Mem) (ptr len : Nat) (hptr : ptr + len < 2 ^ 32) :
    runFnvMem mem ptr len = some (Kant.Bytes.fnv1a (bytesAt mem ptr len)) := by
  have hlen : len < 2 ^ 64 := by
    have : (2 : Nat) ^ 32 < 2 ^ 64 := by norm_num
    omega
  rw [runFnvMem, Fold.exec_program mem fnvInitE fnvBodyE fnvInitE_wf fnvBodyE_wf ptr len
    hptr hlen, eval_fnvInitE]
  have hstep : (fun (j : Nat) (a : UInt64) => Fold.stepVal mem fnvBodyE ptr len j a) =
      fun (j : Nat) (a : UInt64) => Kant.Bytes.fnvStep a (mem (ptr + j)) := by
    funext j a; exact stepVal_fnvBodyE mem ptr len j a
  simp only [Option.getD, hstep]
  rw [iterate_fnvStep mem ptr len 0 Kant.Bytes.fnvOffset]
  simp [Kant.Bytes.fnv1a]

end Kant.Wasm.MemKernel
