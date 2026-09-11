import RequestProject.Anim.ExprKernel

/-!
# The flat program the kernel actually runs

The WebAssembly kernel does not walk a tree: JavaScript flattens the parsed
formula once, into a stream of opcode words plus a pool of constants, and the
kernel runs that stream on a stack.  If the correspondence theorem in
`ExprKernel.lean` were stated only about the tree evaluator, the flattening step
would be unverified glue sitting exactly where the chain of custody is meant to
be.  So the flattening is defined here too, and the two theorems that close the
gap are:

* `Wire.decode_encode` — the wire format round-trips: the words and constants
  the JavaScript emits decode back to exactly the instruction list they came
  from, constant indices included;
* `run_compile` — running the compiled instruction list on a stack yields the
  tree's value, on top of whatever was already there.

Composed (`run_decode_encode_compile`), they say: *what the kernel executes is
what the formula means*, for any arithmetic, unconditionally.

## The one deliberate difference from `Expr.eval`

`if(c, a, b)` is lazy in the specification and in `web/js/expr.js`: only the
chosen branch is evaluated.  A stack machine without jumps evaluates both and
selects (`Instr.sel`).  Because every operation here is total — a `Float`
operation always returns a `Float`, there are no exceptions — this changes the
*cost* of an `if`, never its value, and `run_compile` proves exactly that: the
value obtained is `Tree.eval`'s, which is the lazy one.
-/

namespace Hesper.Anim
namespace Kernel

/-! ## Instructions -/

/-- One instruction of the stack machine. -/
inductive Instr (F : Type)
  /-- Push a literal. -/
  | push : F → Instr F
  /-- Push the value of a variable slot. -/
  | load : Nat → Instr F
  /-- Negate the top of the stack. -/
  | neg : Instr F
  /-- Apply a binary operator to the top two. -/
  | binop : BinOp → Instr F
  /-- `if`: pops `b`, `a`, `c` and pushes `a` or `b` according to `c`. -/
  | sel : Instr F
  /-- Apply a unary builtin. -/
  | un : Nat → Instr F
  /-- Apply a binary builtin. -/
  | bin : Nat → Instr F
  /-- Apply a ternary builtin. -/
  | tern : Nat → Instr F
  deriving Repr, DecidableEq

namespace Instr

variable {F : Type}

/-- Execute one instruction.  `none` is a stack underflow — a malformed
program, which the kernel reports rather than reading past its buffer. -/
def step (O : Ops F) (env : Nat → F) : Instr F → List F → Option (List F)
  | .push v, s => some (v :: s)
  | .load i, s => some (env i :: s)
  | .neg, a :: s => some (O.neg a :: s)
  | .binop op, b :: a :: s => some (O.binop op a b :: s)
  | .sel, b :: a :: c :: s => some ((if O.test c then a else b) :: s)
  | .un f, a :: s => some (O.un f a :: s)
  | .bin f, b :: a :: s => some (O.bin f a b :: s)
  | .tern f, c :: b :: a :: s => some (O.tern f a b c :: s)
  | _, _ => none

end Instr

/-- Run a program on a stack. -/
def run {F : Type} (O : Ops F) (env : Nat → F) : List (Instr F) → List F → Option (List F)
  | [], s => some s
  | i :: is, s => (Instr.step O env i s).bind (run O env is)

variable {F : Type}

@[simp] theorem run_nil (O : Ops F) (env : Nat → F) (s : List F) : run O env [] s = some s := rfl

theorem run_cons (O : Ops F) (env : Nat → F) (i : Instr F) (is : List (Instr F)) (s : List F) :
    run O env (i :: is) s = (Instr.step O env i s).bind (run O env is) := rfl

/-- Running a concatenation is running the parts in turn. -/
theorem run_append (O : Ops F) (env : Nat → F) (p q : List (Instr F)) (s : List F) :
    run O env (p ++ q) s = (run O env p s).bind (run O env q) := by
  induction p generalizing s with
  | nil => simp
  | cons i is ih =>
    simp only [List.cons_append, run_cons]
    cases Instr.step O env i s <;> simp [ih]

/-! ## Compilation -/

/-- Flatten a tree into a postfix program. -/
def compile : Tree F → List (Instr F)
  | .num v => [.push v]
  | .var i => [.load i]
  | .neg a => compile a ++ [.neg]
  | .bin op a b => compile a ++ compile b ++ [.binop op]
  | .cond c a b => compile c ++ compile a ++ compile b ++ [.sel]
  | .un f a => compile a ++ [.un f]
  | .bin₂ f a b => compile a ++ compile b ++ [.bin f]
  | .tern f a b c => compile a ++ compile b ++ compile c ++ [.tern f]

/-- **The compiled program computes the tree's value**, whatever is already on
the stack and whatever follows.  Unconditional, for every arithmetic. -/
theorem run_compile (O : Ops F) (env : Nat → F) (t : Tree F) (rest : List (Instr F))
    (s : List F) : run O env (compile t ++ rest) s = run O env rest (Tree.eval O env t :: s) := by
  induction t generalizing rest s with
  | num v => rfl
  | var i => rfl
  | neg a ih => simp only [compile, List.append_assoc, ih]; rfl
  | bin op a b iha ihb => simp only [compile, List.append_assoc, iha, ihb]; rfl
  | cond c a b ihc iha ihb => simp only [compile, List.append_assoc, ihc, iha, ihb]; rfl
  | un f a ih => simp only [compile, List.append_assoc, ih]; rfl
  | bin₂ f a b iha ihb => simp only [compile, List.append_assoc, iha, ihb]; rfl
  | tern f a b c iha ihb ihc => simp only [compile, List.append_assoc, iha, ihb, ihc]; rfl

/-- The kernel's entry point: run the whole program on an empty stack and read
the single value it leaves. -/
def exec (O : Ops F) (env : Nat → F) (code : List (Instr F)) : Option F :=
  match run O env code [] with
  | some [v] => some v
  | _ => none

theorem exec_compile (O : Ops F) (env : Nat → F) (t : Tree F) :
    exec O env (compile t) = some (Tree.eval O env t) := by
  have := run_compile O env t [] []
  simp only [List.append_nil, run_nil] at this
  simp [exec, this]

/-! ## Batching

The kernel is called once per field, not once per sample: one program, many
environments, one crossing of the WebAssembly boundary.  The batched entry
point is pointwise the scalar one. -/

/-- Run one program over many environments. -/
def execMany (O : Ops F) (code : List (Instr F)) (envs : List (Nat → F)) : List (Option F) :=
  envs.map fun env => exec O env code

/-- **Batched evaluation is pointwise evaluation.** -/
theorem execMany_compile (O : Ops F) (t : Tree F) (envs : List (Nat → F)) :
    execMany O (compile t) envs = envs.map fun env => some (Tree.eval O env t) := by
  simp [execMany, exec_compile]

/-! ## The wire format

The buffer JavaScript hands the kernel: a list of `(opcode, argument)` words
and a pool of constants.  `push` carries the index of its constant. -/

/-- Wire code of a binary operator. -/
def binOpToCode : BinOp → Nat
  | .add => 0 | .sub => 1 | .mul => 2 | .div => 3 | .mod => 4 | .pow => 5
  | .lt => 6 | .le => 7 | .gt => 8 | .ge => 9 | .eq => 10 | .ne => 11
  | .and => 12 | .or => 13

/-- Binary operator of a wire code. -/
def binOpOfCode : Nat → Option BinOp
  | 0 => some .add | 1 => some .sub | 2 => some .mul | 3 => some .div
  | 4 => some .mod | 5 => some .pow | 6 => some .lt | 7 => some .le
  | 8 => some .gt | 9 => some .ge | 10 => some .eq | 11 => some .ne
  | 12 => some .and | 13 => some .or
  | _ => none

@[simp] theorem binOpOfCode_toCode (op : BinOp) : binOpOfCode (binOpToCode op) = some op := by
  cases op <;> rfl

/-- A flattened program as it crosses the boundary. -/
structure Wire (F : Type) where
  /-- `(opcode, argument)` words, in order. -/
  words : List (Nat × Nat)
  /-- The constant pool, in order of first appearance. -/
  consts : List F
  deriving Repr

namespace Wire

/-- The constants a program pushes, in order. -/
def constsOf : List (Instr F) → List F
  | [] => []
  | .push v :: is => v :: constsOf is
  | _ :: is => constsOf is

/-- The opcode words of a program, given how many constants precede it. -/
def wordsFrom (n : Nat) : List (Instr F) → List (Nat × Nat)
  | [] => []
  | .push _ :: is => (0, n) :: wordsFrom (n + 1) is
  | .load i :: is => (1, i) :: wordsFrom n is
  | .neg :: is => (2, 0) :: wordsFrom n is
  | .binop op :: is => (3, binOpToCode op) :: wordsFrom n is
  | .sel :: is => (4, 0) :: wordsFrom n is
  | .un f :: is => (5, f) :: wordsFrom n is
  | .bin f :: is => (6, f) :: wordsFrom n is
  | .tern f :: is => (7, f) :: wordsFrom n is

/-- Encode a program for the boundary. -/
def encode (code : List (Instr F)) : Wire F :=
  { words := wordsFrom 0 code, consts := constsOf code }

/-- Decode one word against the constant pool. -/
def decodeWord (cs : List F) : Nat × Nat → Option (Instr F)
  | (0, i) => (cs[i]?).map Instr.push
  | (1, i) => some (.load i)
  | (2, _) => some .neg
  | (3, c) => (binOpOfCode c).map Instr.binop
  | (4, _) => some .sel
  | (5, f) => some (.un f)
  | (6, f) => some (.bin f)
  | (7, f) => some (.tern f)
  | _ => none

/-- Decode a word list against a constant pool. -/
def decodeWords (cs : List F) : List (Nat × Nat) → Option (List (Instr F))
  | [] => some []
  | w :: ws =>
    match decodeWord cs w with
    | none => none
    | some i => (decodeWords cs ws).map (i :: ·)

/-- Decode a wire program. -/
def decode (w : Wire F) : Option (List (Instr F)) := decodeWords w.consts w.words

private theorem decodeWords_wordsFrom (pre : List F) :
    ∀ code : List (Instr F),
      decodeWords (pre ++ constsOf code) (wordsFrom pre.length code) = some code
  | [] => rfl
  | .push v :: is => by
      have ih := decodeWords_wordsFrom (pre ++ [v]) is
      simp only [List.length_append, List.length_cons, List.length_nil, List.append_assoc,
        List.cons_append, List.nil_append] at ih
      simp [constsOf, wordsFrom, decodeWords, decodeWord, ih]
  | .load i :: is => by
      simp [constsOf, wordsFrom, decodeWords, decodeWord, decodeWords_wordsFrom pre is]
  | .neg :: is => by
      simp [constsOf, wordsFrom, decodeWords, decodeWord, decodeWords_wordsFrom pre is]
  | .binop op :: is => by
      simp [constsOf, wordsFrom, decodeWords, decodeWord, decodeWords_wordsFrom pre is]
  | .sel :: is => by
      simp [constsOf, wordsFrom, decodeWords, decodeWord, decodeWords_wordsFrom pre is]
  | .un f :: is => by
      simp [constsOf, wordsFrom, decodeWords, decodeWord, decodeWords_wordsFrom pre is]
  | .bin f :: is => by
      simp [constsOf, wordsFrom, decodeWords, decodeWord, decodeWords_wordsFrom pre is]
  | .tern f :: is => by
      simp [constsOf, wordsFrom, decodeWords, decodeWord, decodeWords_wordsFrom pre is]

/-- **The wire format round-trips.**  Nothing is lost, and no constant index is
off by one, in the step that crosses the boundary. -/
theorem decode_encode (code : List (Instr F)) : decode (encode code) = some code := by
  have := decodeWords_wordsFrom ([] : List F) code
  simpa [decode, encode] using this

end Wire

/-- **End to end.**  Encode the flattened formula, decode it the way the kernel
does, run it: the answer is the value of the formula.  No floating-point
assumption is involved — this holds for every arithmetic, the real one
included. -/
theorem run_decode_encode_compile (O : Ops F) (env : Nat → F) (t : Tree F) :
    (Wire.decode (Wire.encode (compile t))).map (exec O env) = some (some (Tree.eval O env t)) := by
  simp [Wire.decode_encode, exec_compile]

/-- The real instance of the end-to-end statement, stated against the studio's
own specification: the program the kernel runs computes `Expr.eval`. -/
theorem exec_compile_toExpr (I : Interp) (vn fn : Nat → String) (env : String → ℝ) (t : Tree ℝ) :
    exec (realOps I fn) (fun i => env (vn i)) (compile t) = some (Expr.eval I env (t.toExpr vn fn)) := by
  rw [Tree.eval_toExpr]
  exact exec_compile _ _ t

end Kernel
end Hesper.Anim
