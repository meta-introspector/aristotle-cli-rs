import Mathlib

/-!
# A WebAssembly core, and what its instructions mean

The game's rules are shipped to the player's phone as a WebAssembly module.  This
file is the machine those instructions run on: the fragment of Wasm the kernel uses
(`Instr`), and an interpreter for it (`exec`) written straight from the structured
control-flow rules of the specification — a block is left by branching out of it, a
loop is re-entered by branching back to it, and `br k` cuts through `k` enclosing
labels.

Everything is an unsigned 32-bit number held as a `Nat` below `2 ^ 32`; every
arithmetic operation wraps, exactly as `i32` does, and division by zero **traps**
rather than quietly returning something.

On top of the interpreter sit the two notions the kernel is written and verified in:

* `Pushes is v` — the instruction list `is` is a pure expression: from any stack it
  leaves exactly one new value `v` on top and changes nothing else;
* `Runs is f` — the instruction list `is` is a pure statement: it leaves the stack
  alone and transforms the store by `f`.

The combinator lemmas (`Pushes.bin`, `Runs.seq`, `Runs.ifte`, `Runs.whileLoop`, …)
are what let a program be assembled from pieces with its meaning assembled
alongside it.
-/

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace RigVM

/-! ## Values -/

/-- Two to the thirty-two: the `i32` modulus. -/
def W32 : Nat := 4294967296

/-- Reduce to an `i32`. -/
def wrap (n : Nat) : Nat := n % W32

theorem wrap_lt (n : Nat) : wrap n < W32 := Nat.mod_lt _ (by decide)

theorem wrap_eq_self {n : Nat} (h : n < W32) : wrap n = n := Nat.mod_eq_of_lt h

/-- The binary `i32` operators the kernel uses. -/
inductive Bin
  | add | sub | mul | divu | remu | and | or | xor | shl | shru
  | eq | ne | ltu | gtu | leu | geu
deriving DecidableEq, Repr, Inhabited

namespace Bin

/-- Does this operator trap on a zero right-hand side? -/
def divides : Bin → Bool
  | divu | remu => true
  | _ => false

/-- The result of an operator, given both operands are `i32`s. -/
def eval : Bin → Nat → Nat → Nat
  | add, a, b => wrap (a + b)
  | sub, a, b => wrap (a + W32 - b)
  | mul, a, b => wrap (a * b)
  | divu, a, b => a / b
  | remu, a, b => a % b
  | and, a, b => a &&& b
  | or, a, b => a ||| b
  | xor, a, b => a ^^^ b
  | shl, a, b => wrap (a * 2 ^ (b % 32))
  | shru, a, b => a / 2 ^ (b % 32)
  | eq, a, b => if a = b then 1 else 0
  | ne, a, b => if a = b then 0 else 1
  | ltu, a, b => if a < b then 1 else 0
  | gtu, a, b => if b < a then 1 else 0
  | leu, a, b => if a ≤ b then 1 else 0
  | geu, a, b => if b ≤ a then 1 else 0

end Bin

/-! ## Instructions -/

/-- The fragment of WebAssembly the kernel is written in. -/
inductive Instr
  | const (n : Nat)
  | localGet (i : Nat)
  | localSet (i : Nat)
  | drop
  | select
  | bin (o : Bin)
  | load (a : Nat)          -- `i32.load` at offset `a`
  | load8 (a : Nat)         -- `i32.load8_u` at offset `a`
  | store (a : Nat)         -- `i32.store` at offset `a`
  | store8 (a : Nat)        -- `i32.store8` at offset `a`
  | block (body : List Instr)
  | loop (body : List Instr)
  | ifElse (t e : List Instr)
  | br (k : Nat)
  | brIf (k : Nat)
  | ret
deriving Repr, Inhabited

/-! ## The store -/

/-- Linear memory: one byte per address. -/
abbrev Mem := Nat → Nat

/-- The locals of the running function.  Reading a local a function never declared
gives zero, which is what the format guarantees anyway. -/
abbrev Locals := Nat → Nat

/-- Everything an instruction can change. -/
structure Store where
  locals : Locals
  mem : Mem

/-- Read a local. -/
def Store.get (st : Store) (i : Nat) : Nat := st.locals i

/-- Write a local. -/
def Store.set (st : Store) (i v : Nat) : Store :=
  { st with locals := fun j => if j = i then v else st.locals j }

@[simp] theorem Store.get_set_self (st : Store) (i v : Nat) : (st.set i v).get i = v := by
  simp [Store.get, Store.set]

@[simp] theorem Store.get_set_ne (st : Store) {i j : Nat} (h : j ≠ i) (v : Nat) :
    (st.set i v).get j = st.get j := by
  simp [Store.get, Store.set, h]

@[simp] theorem Store.mem_set (st : Store) (i v : Nat) : (st.set i v).mem = st.mem := rfl

/-- One byte of memory. -/
def Mem.byte (m : Mem) (a : Nat) : Nat := m a % 256

/-- A little-endian 32-bit word. -/
def Mem.word (m : Mem) (a : Nat) : Nat :=
  m.byte a + 256 * m.byte (a + 1) + 65536 * m.byte (a + 2) + 16777216 * m.byte (a + 3)

/-- Write one byte. -/
def Mem.setByte (m : Mem) (a v : Nat) : Mem := fun i => if i = a then v % 256 else m i

/-- Write a little-endian 32-bit word. -/
def Mem.setWord (m : Mem) (a v : Nat) : Mem :=
  fun i =>
    if i = a then v % 256
    else if i = a + 1 then v / 256 % 256
    else if i = a + 2 then v / 65536 % 256
    else if i = a + 3 then v / 16777216 % 256
    else m i

@[simp] theorem Mem.byte_setByte_self (m : Mem) (a v : Nat) : (m.setByte a v).byte a = v % 256 := by
  simp [Mem.setByte, Mem.byte]

theorem Mem.byte_setByte_ne (m : Mem) {a b : Nat} (h : b ≠ a) (v : Nat) :
    (m.setByte a v).byte b = m.byte b := by
  simp [Mem.setByte, Mem.byte, h]

theorem Mem.word_setWord_self (m : Mem) (a v : Nat) : (m.setWord a v).word a = v % W32 := by
  simp only [Mem.word, Mem.setWord, Mem.byte, W32]
  have h1 : ¬a + 1 = a := by omega
  have h2 : ¬a + 2 = a := by omega
  have h3 : ¬a + 2 = a + 1 := by omega
  have h4 : ¬a + 3 = a := by omega
  have h5 : ¬a + 3 = a + 1 := by omega
  have h6 : ¬a + 3 = a + 2 := by omega
  simp only [if_neg h1, if_neg h2, if_neg h3, if_neg h4, if_neg h5, if_neg h6,
    if_true, Nat.mod_mod]
  have d1 : v / 256 / 256 = v / 65536 := by
    rw [Nat.div_div_eq_div_mul]
  have d2 : v / 65536 / 256 = v / 16777216 := by
    rw [Nat.div_div_eq_div_mul]
  have d3 : v / 16777216 / 256 = v / 4294967296 := by
    rw [Nat.div_div_eq_div_mul]
  have e0 := Nat.div_add_mod v 256
  have e1 := Nat.div_add_mod (v / 256) 256
  have e2 := Nat.div_add_mod (v / 65536) 256
  have e3 := Nat.div_add_mod (v / 16777216) 256
  rw [d1] at e1
  rw [d2] at e2
  rw [d3] at e3
  have e4 := Nat.div_add_mod v 4294967296
  have e5 : v % 4294967296 < 4294967296 := Nat.mod_lt _ (by omega)
  omega

theorem Mem.word_setWord_ne (m : Mem) {a b : Nat} (v : Nat) (h : b + 4 ≤ a ∨ a + 4 ≤ b) :
    (m.setWord a v).word b = m.word b := by
  simp only [Mem.word, Mem.setWord, Mem.byte]
  have e0 : ¬b = a ∧ ¬b = a + 1 ∧ ¬b = a + 2 ∧ ¬b = a + 3 := by omega
  have e1 : ¬b + 1 = a ∧ ¬b + 1 = a + 1 ∧ ¬b + 1 = a + 2 ∧ ¬b + 1 = a + 3 := by omega
  have e2 : ¬b + 2 = a ∧ ¬b + 2 = a + 1 ∧ ¬b + 2 = a + 2 ∧ ¬b + 2 = a + 3 := by omega
  have e3 : ¬b + 3 = a ∧ ¬b + 3 = a + 1 ∧ ¬b + 3 = a + 2 ∧ ¬b + 3 = a + 3 := by omega
  simp only [if_neg e0.1, if_neg e0.2.1, if_neg e0.2.2.1, if_neg e0.2.2.2,
    if_neg e1.1, if_neg e1.2.1, if_neg e1.2.2.1, if_neg e1.2.2.2,
    if_neg e2.1, if_neg e2.2.1, if_neg e2.2.2.1, if_neg e2.2.2.2,
    if_neg e3.1, if_neg e3.2.1, if_neg e3.2.2.1, if_neg e3.2.2.2]

theorem Mem.byte_setWord_ne (m : Mem) {a b : Nat} (v : Nat) (h : b < a ∨ a + 4 ≤ b) :
    (m.setWord a v).byte b = m.byte b := by
  simp only [Mem.byte, Mem.setWord]
  have e0 : ¬b = a ∧ ¬b = a + 1 ∧ ¬b = a + 2 ∧ ¬b = a + 3 := by omega
  simp only [if_neg e0.1, if_neg e0.2.1, if_neg e0.2.2.1, if_neg e0.2.2.2]

theorem Mem.byte_setByte_ne' (m : Mem) {a b : Nat} (v : Nat) (h : b < a ∨ a < b) :
    (m.setByte a v).byte b = m.byte b :=
  Mem.byte_setByte_ne m (by omega) v

/-- A running configuration: the operand stack and the store. -/
structure Cfg where
  stack : List Nat
  st : Store

/-- What running a list of instructions can do. -/
inductive Res
  | normal (c : Cfg)
  | br (k : Nat) (c : Cfg)
  | ret (c : Cfg)
  | trap
  | oom
deriving Inhabited

/-! ## The interpreter -/

mutual

/-- Execute a list of instructions.  `fuel` bounds the number of loop iterations;
running out is reported as `oom` and never mistaken for success. -/
def exec (is : List Instr) (c : Cfg) (fuel : Nat) : Res :=
  match is with
  | [] => .normal c
  | i :: rest =>
      match step1 i c fuel with
      | .normal c' => exec rest c' fuel
      | r => r
  termination_by (fuel, sizeOf is, 1)

/-- One instruction. -/
def step1 (i : Instr) (c : Cfg) (fuel : Nat) : Res :=
  match i with
    | .const n => .normal { c with stack := wrap n :: c.stack }
    | .localGet i => .normal { c with stack := c.st.get i :: c.stack }
    | .localSet i =>
        match c.stack with
        | v :: s => .normal ⟨s, c.st.set i v⟩
        | [] => .trap
    | .drop =>
        match c.stack with
        | _ :: s => .normal { c with stack := s }
        | [] => .trap
    | .select =>
        match c.stack with
        | k :: b :: a :: s => .normal { c with stack := (if k = 0 then b else a) :: s }
        | _ => .trap
    | .bin o =>
        match c.stack with
        | b :: a :: s =>
            if o.divides && b = 0 then .trap
            else .normal { c with stack := o.eval a b :: s }
        | _ => .trap
    | .load a =>
        match c.stack with
        | p :: s => .normal { c with stack := c.st.mem.word (p + a) :: s }
        | [] => .trap
    | .load8 a =>
        match c.stack with
        | p :: s => .normal { c with stack := c.st.mem.byte (p + a) :: s }
        | [] => .trap
    | .store a =>
        match c.stack with
        | v :: p :: s => .normal ⟨s, { c.st with mem := c.st.mem.setWord (p + a) v }⟩
        | _ => .trap
    | .store8 a =>
        match c.stack with
        | v :: p :: s => .normal ⟨s, { c.st with mem := c.st.mem.setByte (p + a) v }⟩
        | _ => .trap
    | .br k => .br k c
    | .brIf k =>
        match c.stack with
        | v :: s => if v = 0 then .normal { c with stack := s } else .br k { c with stack := s }
        | [] => .trap
    | .ret => .ret c
    | .block body =>
        match exec body c fuel with
        | .br 0 c' => .normal c'
        | .br (k + 1) c' => .br k c'
        | r => r
    | .ifElse t e =>
        match c.stack with
        | v :: s =>
            match (if v = 0 then exec e ⟨s, c.st⟩ fuel else exec t ⟨s, c.st⟩ fuel) with
            | .br 0 c' => .normal c'
            | .br (k + 1) c' => .br k c'
            | r => r
        | [] => .trap
    | .loop body =>
        match fuel with
        | 0 => .oom
        | fuel' + 1 =>
            match exec body c fuel' with
            | .br 0 c' => step1 (.loop body) c' fuel'
            | .br (k + 1) c' => .br k c'
            | r => r
  termination_by (fuel, sizeOf i, 0)

end

/-- Call a function body: run it with the given locals over the given memory and
read off the value it returns. -/
def call (body : List Instr) (locals : Locals) (m : Mem) (fuel : Nat) : Option (Nat × Mem) :=
  match exec body ⟨[], ⟨locals, m⟩⟩ fuel with
  | .normal c => match c.stack with
      | v :: _ => some (v, c.st.mem)
      | [] => none
  | .ret c => match c.stack with
      | v :: _ => some (v, c.st.mem)
      | [] => none
  | _ => none

/-- Call a function body that returns nothing. -/
def callVoid (body : List Instr) (locals : Locals) (m : Mem) (fuel : Nat) : Option Mem :=
  match exec body ⟨[], ⟨locals, m⟩⟩ fuel with
  | .normal c => some c.st.mem
  | .ret c => some c.st.mem
  | _ => none

/-! ## Expressions and statements

The two shapes of instruction list the kernel is built from. -/

/-- Running one list and then another. -/
theorem exec_append (a b : List Instr) (c : Cfg) (fuel : Nat) :
    exec (a ++ b) c fuel =
      match exec a c fuel with
      | .normal c' => exec b c' fuel
      | r => r := by
  induction a generalizing c with
  | nil => simp [exec]
  | cons i rest ih =>
      rw [List.cons_append, exec, exec]
      cases h : step1 i c fuel <;> simp [ih]

/-- `Pushes is f` : `is` is an expression that pushes `f`'s value and touches
nothing else, whatever is already on the stack. -/
def Pushes (is : List Instr) (f : Store → Nat) : Prop :=
  ∀ (c : Cfg) (fuel : Nat), exec is c fuel = .normal ⟨f c.st :: c.stack, c.st⟩

/-- `Runs is f` : `is` is a statement that leaves the stack alone and changes the
store by `f`. -/
def Runs (is : List Instr) (f : Store → Store) : Prop :=
  ∀ (c : Cfg) (fuel : Nat), exec is c fuel = .normal ⟨c.stack, f c.st⟩

/-! ### Building expressions -/

theorem Pushes.const (n : Nat) (h : n < W32) : Pushes [.const n] (fun _ => n) := by
  intro c fuel; simp [exec, step1, wrap_eq_self h]

theorem Pushes.localGet (i : Nat) : Pushes [.localGet i] (fun st => st.get i) := by
  intro c fuel; simp [exec, step1]

theorem Pushes.load {a : List Instr} {fa : Store → Nat} (ha : Pushes a fa) (off : Nat) :
    Pushes (a ++ [.load off]) (fun st => st.mem.word (fa st + off)) := by
  intro c fuel
  rw [exec_append, ha]
  simp [exec, step1]

theorem Pushes.load8 {a : List Instr} {fa : Store → Nat} (ha : Pushes a fa) (off : Nat) :
    Pushes (a ++ [.load8 off]) (fun st => st.mem.byte (fa st + off)) := by
  intro c fuel
  rw [exec_append, ha]
  simp [exec, step1]

theorem Pushes.bin {a b : List Instr} {fa fb : Store → Nat} (o : Bin)
    (ha : Pushes a fa) (hb : Pushes b fb) (hz : ∀ st, o.divides = true → fb st ≠ 0) :
    Pushes (a ++ b ++ [.bin o]) (fun st => o.eval (fa st) (fb st)) := by
  intro c fuel
  rw [List.append_assoc, exec_append, ha]
  simp only []
  rw [exec_append, hb]
  simp only [exec, step1]
  cases hd : o.divides
  · simp
  · simp [hz c.st hd]

/-- The three-argument `select`: the condition is on top. -/
theorem Pushes.select {x y k : List Instr} {fx fy fk : Store → Nat}
    (hx : Pushes x fx) (hy : Pushes y fy) (hk : Pushes k fk) :
    Pushes (x ++ y ++ k ++ [.select]) (fun st => if fk st = 0 then fy st else fx st) := by
  intro c fuel
  rw [List.append_assoc, List.append_assoc, exec_append, hx]
  simp only []
  rw [exec_append, hy]
  simp only []
  rw [exec_append, hk]
  simp [exec, step1]

/-! ### Building statements -/

theorem Runs.nil : Runs [] id := by
  intro c fuel; cases c; simp [exec]

theorem Runs.seq {a b : List Instr} {fa fb : Store → Store} (ha : Runs a fa) (hb : Runs b fb) :
    Runs (a ++ b) (fun st => fb (fa st)) := by
  intro c fuel
  rw [exec_append, ha]
  simpa using hb ⟨c.stack, fa c.st⟩ fuel

theorem Runs.localSet {a : List Instr} {fa : Store → Nat} (ha : Pushes a fa) (i : Nat) :
    Runs (a ++ [.localSet i]) (fun st => st.set i (fa st)) := by
  intro c fuel
  rw [exec_append, ha]
  simp [exec, step1]

theorem Runs.store {a v : List Instr} {fa fv : Store → Nat}
    (ha : Pushes a fa) (hv : Pushes v fv) (off : Nat) :
    Runs (a ++ v ++ [.store off])
      (fun st => { st with mem := st.mem.setWord (fa st + off) (fv st) }) := by
  intro c fuel
  rw [List.append_assoc, exec_append, ha]
  simp only []
  rw [exec_append, hv]
  simp [exec, step1]

theorem Runs.store8 {a v : List Instr} {fa fv : Store → Nat}
    (ha : Pushes a fa) (hv : Pushes v fv) (off : Nat) :
    Runs (a ++ v ++ [.store8 off])
      (fun st => { st with mem := st.mem.setByte (fa st + off) (fv st) }) := by
  intro c fuel
  rw [List.append_assoc, exec_append, ha]
  simp only []
  rw [exec_append, hv]
  simp [exec, step1]

theorem Runs.ifte {k t e : List Instr} {fk : Store → Nat} {ft fe : Store → Store}
    (hk : Pushes k fk) (ht : Runs t ft) (he : Runs e fe) :
    Runs (k ++ [.ifElse t e]) (fun st => if fk st = 0 then fe st else ft st) := by
  intro c fuel
  rw [exec_append, hk]
  simp only [exec, step1]
  by_cases h : fk c.st = 0 <;> simp only [h, if_true, if_false] <;>
    simp [ht ((⟨c.stack, c.st⟩ : Cfg)) fuel, he ((⟨c.stack, c.st⟩ : Cfg)) fuel]

end RigVM
