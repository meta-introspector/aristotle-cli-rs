/-
# Linear memory and loops: the digest fold inside WebAssembly

`RequestProject.Wasm.Syntax` and `RequestProject.Wasm.Semantics` cover a
straight-line, memory-free fragment: every kernel function there is a tree
of `i64` operations over its parameters.  That is enough for one FNV-1a
*step*, but not for the digest of a whole buffer, which the browser client
therefore had to fold caller-side.

This module closes that gap.  It adds

* `MInstr` — the straight-line instructions plus `i32.wrap_i64`,
  `i64.load8_u`, `local.set`, `br`, `br_if`, `block` and `loop`;
* `execM` — a structured operational semantics for them, with a linear
  memory `Mem := Nat → UInt8`, branching modelled by an `Outcome` and
  looping bounded by fuel (a `loop` that runs out of fuel is `none`, so a
  result of `some` is a proof of termination);
* `Fold.program` — the standard "fold a byte buffer" loop, `block (loop
  (guard; load; body; bump; br))`, over locals `ptr, len, acc, i, byte`;
* `Fold.exec_program` — **the loop computes the fold**: running the
  program is `Fold.iterate` of the body over the `len` bytes at `ptr`.

`RequestProject.Wasm.MemKernel` instantiates this with the FNV-1a body and
proves the resulting export equals `Kant.Bytes.fnv1a` of the buffer, and
`RequestProject.Wasm.MemEncode` emits it as a real `.wasm` module with an
exported memory.

Mathlib-free by design, like the rest of the extraction core.
-/
import RequestProject.Wasm.Semantics

namespace Kant.Wasm

/-- A linear memory: a total map from byte address to byte.  A wasm memory
of `n` pages is the special case that is zero outside `[0, 65536·n)`. -/
abbrev Mem := Nat → UInt8

/-- Instructions of the extended fragment.  `plain` re-uses the
straight-line instruction set of `RequestProject.Wasm.Syntax`; the rest are
the memory and control instructions the fold needs. -/
inductive MInstr where
  /-- a straight-line instruction: `i64.const`, `local.get`, arithmetic,
  comparison, `i64.extend_i32_u` -/
  | plain (i : Instr)
  /-- `i32.wrap_i64`, used to turn a computed `i64` address into the `i32`
  a memory access takes -/
  | wrap
  /-- `i64.load8_u` (align 0, offset 0) -/
  | load8
  /-- `local.set i` -/
  | localSet (i : Nat)
  /-- `br l` -/
  | br (l : Nat)
  /-- `br_if l` -/
  | brIf (l : Nat)
  /-- `block … end`, with empty block type -/
  | block (body : List MInstr)
  /-- `loop … end`, with empty block type -/
  | loop (body : List MInstr)
  deriving Inhabited, Repr

/-- The result of running an instruction sequence: either it fell off the
end, or it branched out to the `l`-th enclosing label. -/
inductive Outcome where
  | next (locals stack : List UInt64)
  | brk (l : Nat) (locals stack : List UInt64)
  deriving Repr, DecidableEq

/-- The structured semantics.  `fuel` bounds the number of loop
iterations; `none` means the program trapped, was malformed, or ran out of
fuel, so `some` is a termination proof. -/
def execM (mem : Mem) (fuel : Nat) (is : List MInstr)
    (locals stack : List UInt64) : Option Outcome :=
  match fuel, is with
  | _, [] => some (.next locals stack)
  | fuel, .plain i :: rest =>
      match step locals i stack with
      | some st' => execM mem fuel rest locals st'
      | none => none
  | fuel, .wrap :: rest =>
      match stack with
      | v :: st' => execM mem fuel rest locals (UInt64.ofNat (v.toNat % 2 ^ 32) :: st')
      | [] => none
  | fuel, .load8 :: rest =>
      match stack with
      | a :: st' => execM mem fuel rest locals ((mem a.toNat).toUInt64 :: st')
      | [] => none
  | fuel, .localSet i :: rest =>
      match stack with
      | v :: st' =>
          if i < locals.length then execM mem fuel rest (locals.set i v) st' else none
      | [] => none
  | _, .br l :: _ => some (.brk l locals stack)
  | fuel, .brIf l :: rest =>
      match stack with
      | v :: st' =>
          if v ≠ 0 then some (.brk l locals st') else execM mem fuel rest locals st'
      | [] => none
  | fuel, .block b :: rest =>
      match execM mem fuel b locals stack with
      | some (.next locals' st') => execM mem fuel rest locals' st'
      | some (.brk 0 locals' st') => execM mem fuel rest locals' st'
      | some (.brk (l + 1) locals' st') => some (.brk l locals' st')
      | none => none
  | 0, .loop _ :: _ => none
  | fuel + 1, .loop b :: rest =>
      match execM mem (fuel + 1) b locals stack with
      | some (.next locals' st') => execM mem (fuel + 1) rest locals' st'
      | some (.brk 0 locals' st') => execM mem fuel (.loop b :: rest) locals' st'
      | some (.brk (l + 1) locals' st') => some (.brk l locals' st')
      | none => none
  termination_by (fuel, sizeOf is)

/-! ### One-instruction laws

The semantics is defined by well-founded recursion, so these are the
equations a proof steps through; each is a direct instance of the
definition. -/

theorem execM_nil (mem : Mem) (fuel : Nat) (locals stack : List UInt64) :
    execM mem fuel [] locals stack = some (.next locals stack) := by
  simp [execM]

theorem execM_const (mem : Mem) (fuel n : Nat) (rest : List MInstr) (locals stack : List UInt64) :
    execM mem fuel (.plain (.i64const n) :: rest) locals stack =
      execM mem fuel rest locals (UInt64.ofNat n :: stack) := by
  simp [execM, step]

theorem execM_localGet (mem : Mem) (fuel k : Nat) (rest : List MInstr)
    (locals stack : List UInt64) (v : UInt64) (h : locals[k]? = some v) :
    execM mem fuel (.plain (.localGet k) :: rest) locals stack =
      execM mem fuel rest locals (v :: stack) := by
  simp [execM, step, h]

theorem execM_binop (mem : Mem) (fuel : Nat) (op : BinOp) (rest : List MInstr)
    (locals stack : List UInt64) (a b : UInt64) :
    execM mem fuel (.plain (.binop op) :: rest) locals (b :: a :: stack) =
      match op.apply a b with
      | some v => execM mem fuel rest locals (v :: stack)
      | none => none := by
  cases h : op.apply a b <;> simp [execM, step, h]

theorem execM_cmpop (mem : Mem) (fuel : Nat) (op : CmpOp) (rest : List MInstr)
    (locals stack : List UInt64) (a b : UInt64) :
    execM mem fuel (.plain (.cmpop op) :: rest) locals (b :: a :: stack) =
      execM mem fuel rest locals (op.apply a b :: stack) := by
  simp [execM, step]

theorem execM_wrap (mem : Mem) (fuel : Nat) (rest : List MInstr)
    (locals stack : List UInt64) (v : UInt64) :
    execM mem fuel (.wrap :: rest) locals (v :: stack) =
      execM mem fuel rest locals (UInt64.ofNat (v.toNat % 2 ^ 32) :: stack) := by
  simp [execM]

theorem execM_load8 (mem : Mem) (fuel : Nat) (rest : List MInstr)
    (locals stack : List UInt64) (a : UInt64) :
    execM mem fuel (.load8 :: rest) locals (a :: stack) =
      execM mem fuel rest locals ((mem a.toNat).toUInt64 :: stack) := by
  simp [execM]

theorem execM_localSet (mem : Mem) (fuel k : Nat) (rest : List MInstr)
    (locals stack : List UInt64) (v : UInt64) (h : k < locals.length) :
    execM mem fuel (.localSet k :: rest) locals (v :: stack) =
      execM mem fuel rest (locals.set k v) stack := by
  simp [execM, h]

theorem execM_br (mem : Mem) (fuel l : Nat) (rest : List MInstr) (locals stack : List UInt64) :
    execM mem fuel (.br l :: rest) locals stack = some (.brk l locals stack) := by
  simp [execM]

theorem execM_brIf_pos (mem : Mem) (fuel l : Nat) (rest : List MInstr)
    (locals stack : List UInt64) (v : UInt64) (h : v ≠ 0) :
    execM mem fuel (.brIf l :: rest) locals (v :: stack) = some (.brk l locals stack) := by
  simp [execM, h]

theorem execM_brIf_zero (mem : Mem) (fuel l : Nat) (rest : List MInstr)
    (locals stack : List UInt64) :
    execM mem fuel (.brIf l :: rest) locals (0 :: stack) = execM mem fuel rest locals stack := by
  simp [execM]

theorem execM_block (mem : Mem) (fuel : Nat) (b rest : List MInstr) (locals stack : List UInt64) :
    execM mem fuel (.block b :: rest) locals stack =
      match execM mem fuel b locals stack with
      | some (.next locals' st') => execM mem fuel rest locals' st'
      | some (.brk 0 locals' st') => execM mem fuel rest locals' st'
      | some (.brk (l + 1) locals' st') => some (.brk l locals' st')
      | none => none := by
  rw [execM]

theorem execM_loop (mem : Mem) (fuel : Nat) (b rest : List MInstr) (locals stack : List UInt64) :
    execM mem (fuel + 1) (.loop b :: rest) locals stack =
      match execM mem (fuel + 1) b locals stack with
      | some (.next locals' st') => execM mem (fuel + 1) rest locals' st'
      | some (.brk 0 locals' st') => execM mem fuel (.loop b :: rest) locals' st'
      | some (.brk (l + 1) locals' st') => some (.brk l locals' st')
      | none => none := by
  rw [execM]

/-- A prefix of straight-line instructions runs on the plain stack machine
of `RequestProject.Wasm.Semantics`. -/
theorem execM_plain (mem : Mem) (fuel : Nat) (is : List Instr) (rest : List MInstr)
    (locals stack : List UInt64) :
    execM mem fuel (is.map MInstr.plain ++ rest) locals stack =
      match exec locals is stack with
      | some st' => execM mem fuel rest locals st'
      | none => none := by
  induction is generalizing stack with
  | nil => simp [exec]
  | cons i is ih =>
      simp only [List.map_cons, List.cons_append, execM, exec]
      cases hstep : step locals i stack with
      | none => simp
      | some st' => simp [ih]

namespace Fold

/-! ## The fold program

Locals: `0 = ptr`, `1 = len` (the two parameters), `2 = acc`, `3 = i`,
`4 = byte` (three declared `i64` locals). -/

/-- `if i ≥ len then break out of the block`. -/
def guardOut : List MInstr :=
  [.plain (.localGet 3), .plain (.localGet 1), .plain (.cmpop .geu), .brIf 1]

/-- `byte := mem[ptr + i]`. -/
def loadByte : List MInstr :=
  [.plain (.localGet 0), .plain (.localGet 3), .plain (.binop .add), .wrap, .load8,
    .localSet 4]

/-- `i := i + 1`. -/
def bump : List MInstr :=
  [.plain (.localGet 3), .plain (.i64const 1), .plain (.binop .add), .localSet 3]

/-- The body of the `loop`: guard, load, accumulate, advance, repeat. -/
def loopBody (bodyE : Expr) : List MInstr :=
  guardOut ++ loadByte ++ (bodyE.compile.map MInstr.plain) ++ [.localSet 2] ++ bump ++ [.br 0]

/-- The whole function body: initialise the accumulator and the index, run
the loop, return the accumulator. -/
def program (initE bodyE : Expr) : List MInstr :=
  (initE.compile.map MInstr.plain) ++ [.localSet 2] ++
    [.plain (.i64const 0), .localSet 3] ++
    [.block [.loop (loopBody bodyE)]] ++
    [.plain (.localGet 2)]

/-- The initial locals of a call: the two arguments and three zeroed locals. -/
def initLocals (ptr len : Nat) : List UInt64 :=
  [UInt64.ofNat ptr, UInt64.ofNat len, 0, 0, 0]

/-- The accumulator step the wasm body computes at index `i`: the value of
`bodyE` with `acc` in local 2 and `mem[ptr+i]` in local 4. -/
def stepVal (mem : Mem) (bodyE : Expr) (ptr len i : Nat) (acc : UInt64) : UInt64 :=
  (Expr.eval [UInt64.ofNat ptr, UInt64.ofNat len, acc, UInt64.ofNat i,
    (mem (ptr + i)).toUInt64] bodyE).getD 0

/-- `n` steps of `f`, starting at index `i`. -/
def iterate (f : Nat → UInt64 → UInt64) : Nat → Nat → UInt64 → UInt64
  | 0, _, acc => acc
  | n + 1, i, acc => iterate f n (i + 1) (f i acc)

/-- Running the emitted function: the value it leaves on the stack. -/
def run (mem : Mem) (initE bodyE : Expr) (ptr len : Nat) : Option UInt64 :=
  match execM mem (len + 1) (program initE bodyE) (initLocals ptr len) [] with
  | some (.next _ (v :: _)) => some v
  | _ => none

/-! ### The loop computes the fold -/

/-- The last pass through the loop body: the index has reached the length,
so the guard branches out of the enclosing block. -/
theorem exec_loopBody_done (mem : Mem) (bodyE : Expr) (fuel : Nat) (p acc bl : UInt64)
    (i len : Nat) (hlen : len < 2 ^ 64) (hi : i < 2 ^ 64) (h : len ≤ i) :
    execM mem fuel (loopBody bodyE) [p, UInt64.ofNat len, acc, UInt64.ofNat i, bl] [] =
      some (.brk 1 [p, UInt64.ofNat len, acc, UInt64.ofNat i, bl] []) := by
  have hle : (UInt64.ofNat len) ≤ (UInt64.ofNat i) := by
    rw [UInt64.le_iff_toNat_le, UInt64.toNat_ofNat_of_lt' hlen, UInt64.toNat_ofNat_of_lt' hi]
    exact h
  rw [loopBody, guardOut]
  simp only [List.cons_append, List.nil_append]
  rw [execM_localGet (v := UInt64.ofNat i) (h := by rfl),
    execM_localGet (v := UInt64.ofNat len) (h := by rfl), execM_cmpop,
    execM_brIf_pos (v := CmpOp.apply .geu (UInt64.ofNat i) (UInt64.ofNat len))
      (h := by simp [CmpOp.apply, hle])]

/-- One pass through the loop body: it reads `mem[ptr+i]`, replaces the
accumulator by the value of the body expression, advances the index and
branches back to the top of the loop. -/
theorem exec_loopBody_step (mem : Mem) (bodyE : Expr) (hb : Expr.Wf 5 bodyE) (fuel : Nat)
    (acc bl : UInt64) (ptr len i : Nat) (hptr : ptr + i < 2 ^ 32) (hlen : len < 2 ^ 64)
    (h : i < len) :
    execM mem fuel (loopBody bodyE)
        [UInt64.ofNat ptr, UInt64.ofNat len, acc, UInt64.ofNat i, bl] [] =
      some (.brk 0 [UInt64.ofNat ptr, UInt64.ofNat len,
        stepVal mem bodyE ptr len i acc, UInt64.ofNat (i + 1),
        (mem (ptr + i)).toUInt64] []) := by
  have hi : i < 2 ^ 64 := by omega
  have hnle : ¬ (UInt64.ofNat len) ≤ (UInt64.ofNat i) := by
    rw [UInt64.le_iff_toNat_le, UInt64.toNat_ofNat_of_lt' hlen, UInt64.toNat_ofNat_of_lt' hi]
    omega
  have hcmp : CmpOp.apply .geu (UInt64.ofNat i) (UInt64.ofNat len) = 0 := by
    simp [CmpOp.apply, hnle]
  have hadd : (UInt64.ofNat ptr + UInt64.ofNat i) = UInt64.ofNat (ptr + i) := by
    apply UInt64.toNat_inj.mp
    rw [UInt64.toNat_add, UInt64.toNat_ofNat_of_lt' (by omega : ptr < 2 ^ 64),
      UInt64.toNat_ofNat_of_lt' hi, UInt64.toNat_ofNat_of_lt' (by omega : ptr + i < 2 ^ 64)]
    exact Nat.mod_eq_of_lt (by omega)
  have haddr : UInt64.ofNat ((UInt64.ofNat ptr + UInt64.ofNat i).toNat % 2 ^ 32)
      = UInt64.ofNat (ptr + i) := by
    rw [hadd, UInt64.toNat_ofNat_of_lt' (by omega : ptr + i < 2 ^ 64),
      Nat.mod_eq_of_lt (by omega : ptr + i < 2 ^ 32)]
  have hmem : (UInt64.ofNat (ptr + i)).toNat = ptr + i :=
    UInt64.toNat_ofNat_of_lt' (by omega : ptr + i < 2 ^ 64)
  have hbump : (UInt64.ofNat i + UInt64.ofNat 1) = UInt64.ofNat (i + 1) := by
    apply UInt64.toNat_inj.mp
    rw [UInt64.toNat_add, UInt64.toNat_ofNat_of_lt' hi,
      UInt64.toNat_ofNat_of_lt' (by omega : (1 : Nat) < 2 ^ 64),
      UInt64.toNat_ofNat_of_lt' (by omega : i + 1 < 2 ^ 64)]
    exact Nat.mod_eq_of_lt (by omega)
  have hev : (Expr.eval [UInt64.ofNat ptr, UInt64.ofNat len, acc, UInt64.ofNat i,
      (mem (ptr + i)).toUInt64] bodyE) = some (stepVal mem bodyE ptr len i acc) := by
    obtain ⟨v, hv⟩ := Option.isSome_iff_exists.mp
      (Expr.eval_isSome_of_wf (arity := 5)
        (locals := [UInt64.ofNat ptr, UInt64.ofNat len, acc, UInt64.ofNat i,
          (mem (ptr + i)).toUInt64]) (by simp) hb)
    rw [hv]; unfold stepVal; rw [hv]; rfl
  rw [loopBody, guardOut, loadByte, bump]
  simp only [List.cons_append, List.nil_append, List.append_assoc]
  rw [execM_localGet (v := UInt64.ofNat i) (h := by rfl),
    execM_localGet (v := UInt64.ofNat len) (h := by rfl), execM_cmpop, hcmp, execM_brIf_zero,
    execM_localGet (v := UInt64.ofNat ptr) (h := by rfl),
    execM_localGet (v := UInt64.ofNat i) (h := by rfl), execM_binop]
  simp only [BinOp.apply]
  rw [execM_wrap, haddr, execM_load8, hmem, execM_localSet (h := by simp)]
  simp only [List.set]
  rw [execM_plain, Expr.exec_compile, hev]
  simp only [Option.map]
  rw [execM_localSet (h := by simp)]
  simp only [List.set]
  rw [execM_localGet (v := UInt64.ofNat i) (h := by rfl), execM_const, execM_binop]
  simp only [BinOp.apply]
  rw [hbump, execM_localSet (h := by simp)]
  simp only [List.set]
  rw [execM_br]

/-- **The loop terminates and iterates the body.**  From index `i` with
`n` bytes left, `n+1` units of fuel suffice, and the loop leaves
`iterate` of the body over those `n` bytes in the accumulator. -/
theorem exec_loop (mem : Mem) (bodyE : Expr) (hb : Expr.Wf 5 bodyE) (ptr len : Nat)
    (hptr : ptr + len < 2 ^ 32) (hlen : len < 2 ^ 64) :
    ∀ (n i : Nat) (acc bl : UInt64), i + n = len →
      ∃ bl', execM mem (n + 1) [.loop (loopBody bodyE)]
          [UInt64.ofNat ptr, UInt64.ofNat len, acc, UInt64.ofNat i, bl] [] =
        some (.brk 0 [UInt64.ofNat ptr, UInt64.ofNat len,
          iterate (stepVal mem bodyE ptr len) n i acc, UInt64.ofNat len, bl'] []) := by
  intro n
  induction n with
  | zero =>
      intro i acc bl hi
      refine ⟨bl, ?_⟩
      have hieq : i = len := by omega
      subst hieq
      rw [execM_loop, exec_loopBody_done (h := Nat.le_refl i) (hlen := hlen) (hi := by omega)]
      simp [iterate]
  | succ n ih =>
      intro i acc bl hi
      have hlt : i < len := by omega
      rw [execM_loop, exec_loopBody_step (hb := hb) (hptr := by omega) (hlen := hlen) (h := hlt)]
      obtain ⟨bl', hbl'⟩ := ih (i + 1) (stepVal mem bodyE ptr len i acc)
        ((mem (ptr + i)).toUInt64) (by omega)
      exact ⟨bl', by simpa [iterate] using hbl'⟩

/-- **The emitted function computes the fold.**  For a well-formed
initialiser and body, the call `f(ptr, len)` returns `iterate` of the body
over the `len` bytes of memory at `ptr`, starting from the value of the
initialiser — no trap, and no fuel exhaustion. -/
theorem exec_program (mem : Mem) (initE bodyE : Expr) (hinit : Expr.Wf 5 initE)
    (hb : Expr.Wf 5 bodyE) (ptr len : Nat) (hptr : ptr + len < 2 ^ 32) (hlen : len < 2 ^ 64) :
    run mem initE bodyE ptr len =
      some (iterate (stepVal mem bodyE ptr len) len 0
        ((Expr.eval (initLocals ptr len) initE).getD 0)) := by
  obtain ⟨v, hv⟩ := Option.isSome_iff_exists.mp
    (Expr.eval_isSome_of_wf (arity := 5) (locals := initLocals ptr len)
      (by simp [initLocals]) hinit)
  obtain ⟨bl', hbl'⟩ := exec_loop mem bodyE hb ptr len hptr hlen len 0 v 0 (by omega)
  unfold run
  rw [program]
  simp only [List.cons_append, List.nil_append, List.append_assoc]
  rw [execM_plain, Expr.exec_compile]
  simp only [initLocals] at hv ⊢
  rw [hv]
  simp only [Option.map]
  rw [execM_localSet (h := by simp)]
  simp only [List.set]
  rw [execM_const, execM_localSet (h := by simp)]
  simp only [List.set]
  rw [execM_block, hbl']
  dsimp only
  rw [execM_localGet (v := iterate (stepVal mem bodyE ptr len) len 0 v) (h := by rfl), execM_nil]
  simp

end Fold

end Kant.Wasm
