/-!
# A small WebAssembly subset, with a semantics

This is the target language of the extraction pipeline: a loop-free fragment of
WebAssembly over the single value type `i64`, with locals and a linear memory.
Everything the game's rule book needs (integer arithmetic, comparisons, table
lookups in memory, conditionals) is expressible in it, and because there are no
loops the semantics is a *total* function — no fuel, no partiality — which is
what makes the compiler correctness proofs in `RequestProject/Wasm/Compile.lean`
go through by plain evaluation.

* `Instr` is the instruction set.
* `Cfg` is a machine configuration: an operand stack, the locals of the
  function being run, and the memory.
* `exec` / `execs` are the semantics, and `runFun` runs a function body on
  given arguments.

The memory is modelled as a map from byte addresses to 64-bit words, i.e. as
the cells of an 8-byte-aligned array; the code generated in `Compile.lean` only
ever loads and stores 8-aligned addresses, so this agrees with a real
WebAssembly linear memory.  Arithmetic here is on `Int` rather than on `2^64`
residues: `RequestProject/Wasm/Bounds.lean` records what has to be true of the
numbers for that to be faithful.
-/

namespace LifeTrac
namespace Wasm

/-- The instruction set: a loop-free, `i64`-only fragment of WebAssembly.
Comparisons push `1` or `0`. -/
inductive Instr where
  /-- `i64.const n` -/
  | const (n : Int) : Instr
  /-- `local.get i` -/
  | localGet (i : Nat) : Instr
  /-- `local.set i` -/
  | localSet (i : Nat) : Instr
  /-- `local.tee i` -/
  | localTee (i : Nat) : Instr
  /-- `i64.load` — pops an address, pushes the word stored there. -/
  | load : Instr
  /-- `i64.store` — pops a value and an address (address pushed first). -/
  | store : Instr
  /-- `i64.add` -/
  | add : Instr
  /-- `i64.sub` -/
  | sub : Instr
  /-- `i64.mul` -/
  | mul : Instr
  /-- `i64.div_s` — signed division, truncating towards zero.  A real engine
  traps when the divisor is zero; the code generator never emits a division
  whose divisor can be zero, and the semantics here answers `0` in that case so
  that `exec` stays total. -/
  | divs : Instr
  /-- `i64.lt_s` -/
  | lt : Instr
  /-- `i64.le_s` -/
  | le : Instr
  /-- `i64.gt_s` -/
  | gt : Instr
  /-- `i64.ge_s` -/
  | ge : Instr
  /-- `i64.eq` -/
  | eq : Instr
  /-- `i64.ne` -/
  | ne : Instr
  /-- `i64.and` -/
  | and : Instr
  /-- `i64.or` -/
  | or : Instr
  /-- `i64.eqz` -/
  | eqz : Instr
  /-- `drop` -/
  | drop : Instr
  /-- `if (result i64) … else … end` — both arms leave one value. -/
  | ifte (t e : List Instr) : Instr
  /-- `if … else … end` — a conditional statement, leaving nothing. -/
  | ifstmt (t e : List Instr) : Instr
  deriving Repr, Inhabited

/-- A machine configuration. -/
structure Cfg where
  /-- The operand stack, top of stack first. -/
  stack : List Int
  /-- The locals of the function currently running. -/
  locals : List Int
  /-- The linear memory, as 64-bit words at 8-aligned byte addresses. -/
  mem : Int → Int

/-- Writing one word of memory. -/
def store1 (m : Int → Int) (a v : Int) : Int → Int := fun x => if x = a then v else m x

@[simp] theorem store1_same (m : Int → Int) (a v : Int) : store1 m a v a = v := by
  simp [store1]

@[simp] theorem store1_other {m : Int → Int} {a v x : Int} (h : x ≠ a) :
    store1 m a v x = m x := by simp [store1, h]

/-- A boolean as the `i64` WebAssembly uses for one. -/
def ofBool (b : Bool) : Int := if b then 1 else 0

@[simp] theorem ofBool_true : ofBool true = 1 := rfl
@[simp] theorem ofBool_false : ofBool false = 0 := rfl

mutual
/-- The semantics of one instruction.  A stack underflow (which the code
generator never produces) leaves the configuration alone. -/
def exec (c : Cfg) : Instr → Cfg
  | .const n => { c with stack := n :: c.stack }
  | .localGet i => { c with stack := c.locals.getD i 0 :: c.stack }
  | .localSet i => match c.stack with
      | v :: s => { c with stack := s, locals := c.locals.set i v }
      | [] => c
  | .localTee i => match c.stack with
      | v :: _ => { c with locals := c.locals.set i v }
      | [] => c
  | .load => match c.stack with
      | a :: s => { c with stack := c.mem a :: s }
      | [] => c
  | .store => match c.stack with
      | v :: a :: s => { c with stack := s, mem := store1 c.mem a v }
      | _ => c
  | .add => match c.stack with
      | b :: a :: s => { c with stack := (a + b) :: s }
      | _ => c
  | .sub => match c.stack with
      | b :: a :: s => { c with stack := (a - b) :: s }
      | _ => c
  | .mul => match c.stack with
      | b :: a :: s => { c with stack := (a * b) :: s }
      | _ => c
  | .divs => match c.stack with
      | b :: a :: s => { c with stack := a.tdiv b :: s }
      | _ => c
  | .lt => match c.stack with
      | b :: a :: s => { c with stack := ofBool (decide (a < b)) :: s }
      | _ => c
  | .le => match c.stack with
      | b :: a :: s => { c with stack := ofBool (decide (a ≤ b)) :: s }
      | _ => c
  | .gt => match c.stack with
      | b :: a :: s => { c with stack := ofBool (decide (b < a)) :: s }
      | _ => c
  | .ge => match c.stack with
      | b :: a :: s => { c with stack := ofBool (decide (b ≤ a)) :: s }
      | _ => c
  | .eq => match c.stack with
      | b :: a :: s => { c with stack := ofBool (decide (a = b)) :: s }
      | _ => c
  | .ne => match c.stack with
      | b :: a :: s => { c with stack := ofBool (decide (a ≠ b)) :: s }
      | _ => c
  | .and => match c.stack with
      | b :: a :: s => { c with stack := ofBool (decide (a ≠ 0 ∧ b ≠ 0)) :: s }
      | _ => c
  | .or => match c.stack with
      | b :: a :: s => { c with stack := ofBool (decide (a ≠ 0 ∨ b ≠ 0)) :: s }
      | _ => c
  | .eqz => match c.stack with
      | a :: s => { c with stack := ofBool (decide (a = 0)) :: s }
      | _ => c
  | .drop => match c.stack with
      | _ :: s => { c with stack := s }
      | _ => c
  | .ifte t e => match c.stack with
      | v :: s => if v ≠ 0 then execs { c with stack := s } t else execs { c with stack := s } e
      | [] => c
  | .ifstmt t e => match c.stack with
      | v :: s => if v ≠ 0 then execs { c with stack := s } t else execs { c with stack := s } e
      | [] => c

/-- The semantics of a straight-line block. -/
def execs (c : Cfg) : List Instr → Cfg
  | [] => c
  | i :: is => execs (exec c i) is
end

@[simp] theorem execs_nil (c : Cfg) : execs c [] = c := rfl

@[simp] theorem execs_cons (c : Cfg) (i : Instr) (is : List Instr) :
    execs c (i :: is) = execs (exec c i) is := rfl

theorem execs_append (c : Cfg) (l₁ l₂ : List Instr) :
    execs c (l₁ ++ l₂) = execs (execs c l₁) l₂ := by
  induction l₁ generalizing c with
  | nil => rfl
  | cons i is ih => simp [ih]

/-- Running a function body: `args` are the initial locals (parameters first,
then `extra` scratch locals initialised to zero), `mem` the memory it starts
from.  The result is the value on top of the stack at the end, together with
the memory as the call left it. -/
def runFun (body : List Instr) (args : List Int) (extra : Nat) (mem : Int → Int) :
    Int × (Int → Int) :=
  let c := execs ⟨[], args ++ List.replicate extra 0, mem⟩ body
  (c.stack.headD 0, c.mem)

/-- The value a function body returns. -/
def callFun (body : List Instr) (args : List Int) (extra : Nat) (mem : Int → Int) : Int :=
  (runFun body args extra mem).1

/-- The memory a function body leaves behind. -/
def memAfter (body : List Instr) (args : List Int) (extra : Nat) (mem : Int → Int) : Int → Int :=
  (runFun body args extra mem).2

/-! ## Reasoning about generated code

Two predicates carry all the compiler correctness proofs.  `Computes L mem e v`
says that the block `e` is a pure expression: from any stack it leaves exactly
`v` on top and touches nothing else.  `Effects L mem mem' e` says that `e` is a
statement: it leaves the stack alone and turns the memory `mem` into `mem'`.
Both compose, so a proof about a generated function is assembled from proofs
about its pieces rather than by unfolding a hundred instructions. -/

/-- `e` computes the value `v`, changing nothing else. -/
def Computes (L : List Int) (mem : Int → Int) (e : List Instr) (v : Int) : Prop :=
  ∀ s : List Int, execs ⟨s, L, mem⟩ e = ⟨v :: s, L, mem⟩

/-- `e` turns the memory `mem` into `mem'`, leaving the stack alone. -/
def Effects (L : List Int) (mem mem' : Int → Int) (e : List Instr) : Prop :=
  ∀ s : List Int, execs ⟨s, L, mem⟩ e = ⟨s, L, mem'⟩

namespace Computes

variable {L : List Int} {mem : Int → Int}

theorem const (n : Int) : Computes L mem [.const n] n := by
  intro s; rfl

theorem localGet (i : Nat) : Computes L mem [.localGet i] (L.getD i 0) := by
  intro s; rfl

theorem load {e : List Instr} {a : Int} (h : Computes L mem e a) :
    Computes L mem (e ++ [.load]) (mem a) := by
  intro s; rw [execs_append, h]; rfl

theorem bin {e₁ e₂ : List Instr} {a b : Int} (h₁ : Computes L mem e₁ a)
    (h₂ : Computes L mem e₂ b) (i : Instr) {v : Int}
    (hv : ∀ s : List Int, exec ⟨b :: a :: s, L, mem⟩ i = ⟨v :: s, L, mem⟩) :
    Computes L mem (e₁ ++ e₂ ++ [i]) v := by
  intro s
  rw [execs_append, execs_append, h₁, h₂]
  simpa using hv s

theorem add {e₁ e₂ : List Instr} {a b : Int} (h₁ : Computes L mem e₁ a)
    (h₂ : Computes L mem e₂ b) : Computes L mem (e₁ ++ e₂ ++ [.add]) (a + b) :=
  bin h₁ h₂ _ (fun _ => rfl)

theorem sub {e₁ e₂ : List Instr} {a b : Int} (h₁ : Computes L mem e₁ a)
    (h₂ : Computes L mem e₂ b) : Computes L mem (e₁ ++ e₂ ++ [.sub]) (a - b) :=
  bin h₁ h₂ _ (fun _ => rfl)

theorem mul {e₁ e₂ : List Instr} {a b : Int} (h₁ : Computes L mem e₁ a)
    (h₂ : Computes L mem e₂ b) : Computes L mem (e₁ ++ e₂ ++ [.mul]) (a * b) :=
  bin h₁ h₂ _ (fun _ => rfl)

theorem divs {e₁ e₂ : List Instr} {a b : Int} (h₁ : Computes L mem e₁ a)
    (h₂ : Computes L mem e₂ b) : Computes L mem (e₁ ++ e₂ ++ [.divs]) (a.tdiv b) :=
  bin h₁ h₂ _ (fun _ => rfl)

theorem le {e₁ e₂ : List Instr} {a b : Int} (h₁ : Computes L mem e₁ a)
    (h₂ : Computes L mem e₂ b) :
    Computes L mem (e₁ ++ e₂ ++ [.le]) (ofBool (decide (a ≤ b))) :=
  bin h₁ h₂ _ (fun _ => rfl)

theorem eq {e₁ e₂ : List Instr} {a b : Int} (h₁ : Computes L mem e₁ a)
    (h₂ : Computes L mem e₂ b) :
    Computes L mem (e₁ ++ e₂ ++ [.eq]) (ofBool (decide (a = b))) :=
  bin h₁ h₂ _ (fun _ => rfl)

theorem and' {e₁ e₂ : List Instr} {p q : Bool} (h₁ : Computes L mem e₁ (ofBool p))
    (h₂ : Computes L mem e₂ (ofBool q)) :
    Computes L mem (e₁ ++ e₂ ++ [.and]) (ofBool (p && q)) := by
  refine bin h₁ h₂ _ (fun s => ?_)
  cases p <;> cases q <;> simp [exec, ofBool]

/-- A conditional expression. -/
theorem ifte {c t e : List Instr} {p : Bool} {v : Int}
    (hc : Computes L mem c (ofBool p))
    (ht : p = true → Computes L mem t v) (he : p = false → Computes L mem e v) :
    Computes L mem (c ++ [.ifte t e]) v := by
  intro s
  rw [execs_append, hc]
  cases p with
  | false => simpa [exec, ofBool] using he rfl s
  | true => simpa [exec, ofBool] using ht rfl s

end Computes

namespace Effects

variable {L : List Int}

theorem nil (mem : Int → Int) : Effects L mem mem [] := fun _ => rfl

theorem trans {mem mem₁ mem₂ : Int → Int} {e₁ e₂ : List Instr}
    (h₁ : Effects L mem mem₁ e₁) (h₂ : Effects L mem₁ mem₂ e₂) :
    Effects L mem mem₂ (e₁ ++ e₂) := by
  intro s; rw [execs_append, h₁, h₂]

/-- Storing the value of an expression at a fixed address. -/
theorem put {mem : Int → Int} {a v : Int} {e : List Instr} (h : Computes L mem e v) :
    Effects L mem (store1 mem a v) (Instr.const a :: e ++ [.store]) := by
  intro s
  have : execs ⟨s, L, mem⟩ (Instr.const a :: e ++ [.store])
      = execs ⟨a :: s, L, mem⟩ (e ++ [.store]) := rfl
  rw [this, execs_append, h]
  rfl

/-- Storing at an address that is itself computed. -/
theorem putAt {mem : Int → Int} {a v : Int} {ea e : List Instr}
    (ha : Computes L mem ea a) (h : Computes L mem e v) :
    Effects L mem (store1 mem a v) (ea ++ e ++ [.store]) := by
  intro s
  rw [execs_append, execs_append, ha, h]
  rfl

/-- A conditional statement. -/
theorem ifstmt {mem mem' : Int → Int} {c t e : List Instr} {p : Bool}
    (hcc : Computes L mem c (ofBool p))
    (ht : p = true → Effects L mem mem' t) (he : p = false → Effects L mem mem' e) :
    Effects L mem mem' (c ++ [.ifstmt t e]) := by
  intro s
  rw [execs_append, hcc]
  cases p with
  | false => simpa [exec, ofBool] using he rfl s
  | true => simpa [exec, ofBool] using ht rfl s

end Effects

/-- An expression followed by a statement-with-value: the shape every generated
entry point has, `guard` then `if effect; 1 else 0`. -/
theorem computes_guarded {L : List Int} {mem mem' : Int → Int} {c t : List Instr}
    {p : Bool} (hc : Computes L mem c (ofBool p))
    (ht : p = true → Effects L mem mem' t) (hm : p = false → mem' = mem) :
    ∀ s : List Int,
      execs ⟨s, L, mem⟩ (c ++ [.ifte (t ++ [.const 1]) [.const 0]])
        = ⟨ofBool p :: s, L, mem'⟩ := by
  intro s
  rw [execs_append, hc]
  cases p with
  | false =>
      rw [hm rfl]
      simp [ofBool, exec]
  | true =>
      have h := ht rfl
      simp only [show ofBool true = (1 : Int) from rfl, execs_cons, execs_nil]
      rw [show exec ⟨(1 : Int) :: s, L, mem⟩
              (Instr.ifte (t ++ [Instr.const 1]) [Instr.const 0])
            = execs ⟨s, L, mem⟩ (t ++ [Instr.const 1]) from by simp [exec],
        execs_append, h]
      rfl

/-! ## Convenient combinators for the code generator -/

/-- Load the word at a constant address. -/
def loadAt (a : Int) : List Instr := [.const a, .load]

/-- Store the result of `v` at a constant address. -/
def storeAt (a : Int) (v : List Instr) : List Instr := (.const a) :: v ++ [.store]

@[simp] theorem exec_loadAt (c : Cfg) (a : Int) :
    execs c (loadAt a) = { c with stack := c.mem a :: c.stack } := rfl

end Wasm
end LifeTrac
