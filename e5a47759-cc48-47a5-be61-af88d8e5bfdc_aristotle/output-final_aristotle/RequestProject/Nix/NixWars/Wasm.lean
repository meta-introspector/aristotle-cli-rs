import RequestProject.Nix.NixWars.Machine

/-!
# A verified WebAssembly backend for the door

`Machine.lean` compiles the game into a first-order expression language `Expr`
and proves the compiled table computes exactly what the game does. That table
still needs an interpreter in the page.

Here we go one step further down: `Expr` is compiled into the instruction set of
a wasm-style stack machine (`Wasm.Instr`), whose semantics — unsigned 32-bit
wrapping arithmetic, an operand stack, locals, and calls — is defined in Lean
(`Wasm.execWith`), and the compiler is proved correct against it
(`Wasm.exec_compile`, `Wasm.wasm_step_correct`). The resulting module is then
serialized to actual WebAssembly binary bytes in `WasmBinary.lean`.

Two wasm details need care, because the game's arithmetic is on `Nat`:

* `Nat` subtraction truncates at zero, while `i32.sub` wraps. So `Expr.sub` is
  compiled to a call of a helper function `$sub_sat`, and the helper's body is
  *proved* to compute truncated subtraction.
* `Nat` division by zero is zero, while `i32.div_u` traps. So `Expr.div` is
  compiled to a call of `$div_nat`, whose body is proved to return `0` on a zero
  divisor. Consequently the emitted code cannot trap at all, which is what makes
  the branch-free `select` used for `Expr.cond` safe.

The call graph of the emitted module has depth one (the exported step functions
call the two helpers, which call nothing), and the semantics below is exactly
that: a call handler runs the callee's body with a call-free executor.
-/

namespace NixWars
namespace Wasm

/-- `2 ^ 32`: the modulus of `i32` arithmetic. -/
def W : Nat := 4294967296

theorem W_pos : 0 < W := by decide

/-! ## Instructions -/

/-- The fragment of WebAssembly we emit. Values are `i32`, represented by
naturals below `W`. -/
inductive Instr
  | const (n : Nat)
  | localGet (i : Nat)
  | add
  | mul
  | sub
  | divU
  | leU
  | eqz
  | select
  | call (f : Nat)
  deriving Repr, DecidableEq, Inhabited

/-- A function of the module: how many parameters it takes, how many values it
returns, its export name, and its body. Our functions declare no extra locals. -/
structure Func where
  name : String
  arity : Nat
  results : Nat
  body : List Instr
  deriving Repr, Inhabited

/-- A module is a list of functions; `call i` refers to the `i`-th. -/
abbrev Module := List Func

/-- How a `call` instruction transforms the operand stack. -/
abbrev CallHandler := Nat → List Nat → Option (List Nat)

/-- The operand stack is written top-first. Executing a straight-line
instruction sequence in a frame with the given locals. `none` is a trap (stack
underflow, or a failed call). -/
def execWith (call : CallHandler) : List Instr → List Nat → List Nat → Option (List Nat)
  | [], _, st => some st
  | .const n :: is, loc, st => execWith call is loc (n % W :: st)
  | .localGet j :: is, loc, st => execWith call is loc (loc.getD j 0 :: st)
  | .add :: is, loc, b :: a :: st => execWith call is loc ((a + b) % W :: st)
  | .mul :: is, loc, b :: a :: st => execWith call is loc ((a * b) % W :: st)
  | .sub :: is, loc, b :: a :: st => execWith call is loc ((W + a - b) % W :: st)
  | .divU :: is, loc, b :: a :: st =>
      if b = 0 then none else execWith call is loc (a / b :: st)
  | .leU :: is, loc, b :: a :: st => execWith call is loc ((if a ≤ b then 1 else 0) :: st)
  | .eqz :: is, loc, a :: st => execWith call is loc ((if a = 0 then 1 else 0) :: st)
  | .select :: is, loc, c :: b :: a :: st =>
      execWith call is loc ((if c ≠ 0 then a else b) :: st)
  | .call f :: is, loc, st =>
      match call f st with
      | none => none
      | some st' => execWith call is loc st'
  | _ :: _, _, _ => none

/-- The call-free executor: a `call` in this position is a trap. -/
def execLeaf : List Instr → List Nat → List Nat → Option (List Nat) :=
  execWith (fun _ _ => none)

/-- Calling into a module: pop the arguments (the last argument is on top of the
stack), run the callee's body in a fresh frame whose locals are the arguments,
and push its results. -/
def moduleCall (M : Module) : CallHandler := fun f st =>
  match M[f]? with
  | none => none
  | some fn =>
      if fn.arity ≤ st.length then
        match execLeaf fn.body (st.take fn.arity).reverse [] with
        | some res => if res.length = fn.results then some (res ++ st.drop fn.arity) else none
        | none => none
      else none

/-- Executing inside a module. -/
def exec (M : Module) : List Instr → List Nat → List Nat → Option (List Nat) :=
  execWith (moduleCall M)

/-- Calling an exported function on a list of arguments, returning the result
vector in declaration order (`execWith` leaves it on the stack top-first). -/
def callExport (M : Module) (f : Nat) (args : List Nat) : Option (List Nat) :=
  match M[f]? with
  | none => none
  | some fn =>
      if args.length = fn.arity then
        match exec M fn.body args [] with
        | some res => if res.length = fn.results then some res.reverse else none
        | none => none
      else none

/-! ## The two helper functions -/

/-- Index of `$sub_sat` in the emitted module. -/
def SUBSAT : Nat := 0

/-- Index of `$div_nat` in the emitted module. -/
def DIVNAT : Nat := 1

/-- `$sub_sat a b = a - b` truncated at zero: compute the wrapping difference,
then select `0` unless `b ≤ a`. -/
def subSatBody : List Instr :=
  [.localGet 0, .localGet 1, .sub, .const 0, .localGet 1, .localGet 0, .leU, .select]

/-- `$div_nat a b = a / b`, with `0` for a zero divisor: divide by `max b 1`
(so the division never traps) and select `0` when `b = 0`. -/
def divNatBody : List Instr :=
  [.const 0, .localGet 0, .const 1, .localGet 1, .localGet 1, .eqz, .select, .divU,
   .localGet 1, .eqz, .select]

/-- The `$sub_sat` function. -/
def subSatFunc : Func := ⟨"sub_sat", 2, 1, subSatBody⟩

/-- The `$div_nat` function. -/
def divNatFunc : Func := ⟨"div_nat", 2, 1, divNatBody⟩

/-! ## Compiling `Expr` -/

/-- Locals of a step function: local `0` is the command argument, local `i+1` is
field `i` of the serialized state. -/
def compile : Expr → List Instr
  | .lit n => [.const n]
  | .fld i => [.localGet (i + 1)]
  | .arg => [.localGet 0]
  | .add a b => compile a ++ compile b ++ [.add]
  | .mul a b => compile a ++ compile b ++ [.mul]
  | .sub a b => compile a ++ compile b ++ [.call SUBSAT]
  | .div a b => compile a ++ compile b ++ [.call DIVNAT]
  | .le a b => compile a ++ compile b ++ [.leU]
  | .cond c a b => compile a ++ compile b ++ compile c ++ [.select]

/-- A whole program (one expression per field of the new state). -/
def compileProg (prog : List Expr) : List Instr := prog.flatMap compile

/-- A door on the board, as compiled code: its name, how many fields its
serialized state has, and one program per command. -/
structure DoorIR where
  /-- The prefix of the exported function names. -/
  name : String
  /-- Number of fields in the serialized state. -/
  fields : Nat
  /-- One program per command, with the command's name. -/
  table : List (String × List Expr)

/-- The functions a door contributes to the module: one per command, taking the
command argument and the state fields, and returning the new fields. -/
def doorFuncs (d : DoorIR) : List Func :=
  d.table.map (fun p => ⟨d.name ++ "_" ++ p.1, d.fields + 1, d.fields, compileProg p.2⟩)

/-- A module for a whole board of doors: the two arithmetic helpers, then every
door's commands. -/
def boardModule (ds : List DoorIR) : Module :=
  subSatFunc :: divNatFunc :: ds.flatMap doorFuncs

/-- The module has the two arithmetic helpers where `compile` expects them. -/
def HasHelpers (M : Module) : Prop :=
  M[SUBSAT]? = some subSatFunc ∧ M[DIVNAT]? = some divNatFunc

theorem boardModule_hasHelpers (ds : List DoorIR) : HasHelpers (boardModule ds) :=
  ⟨rfl, rfl⟩

/-! ## The machine semantics of `Expr`

`Expr.eval32` is `Expr.eval` with `i32` arithmetic: addition wraps and literals
are reduced modulo `W`. Everything else already agrees, because truncated
subtraction and `x / 0 = 0` are exactly what the helper functions implement. -/

end Wasm

namespace Expr

open Wasm

/-- `Expr.eval` in 32-bit arithmetic. -/
def eval32 (st : List Nat) (v : Nat) : Expr → Nat
  | .lit n => n % W
  | .fld i => st.getD i 0
  | .arg => v
  | .add a b => (a.eval32 st v + b.eval32 st v) % W
  | .mul a b => (a.eval32 st v * b.eval32 st v) % W
  | .sub a b => a.eval32 st v - b.eval32 st v
  | .div a b => a.eval32 st v / b.eval32 st v
  | .le a b => if a.eval32 st v ≤ b.eval32 st v then 1 else 0
  | .cond c a b => if c.eval32 st v ≠ 0 then a.eval32 st v else b.eval32 st v

/-- Machine values stay in range. -/
theorem eval32_lt (fields : List Nat) (arg : Nat) (hf : ∀ x ∈ fields, x < W) (ha : arg < W) :
    ∀ e : Expr, e.eval32 fields arg < W := by
  intro e
  induction e with
  | lit n => exact Nat.mod_lt _ W_pos
  | fld i =>
      show fields.getD i 0 < W
      rcases lt_or_ge i fields.length with h | h
      · rw [List.getD_eq_getElem _ _ h]; exact hf _ (List.getElem_mem h)
      · rw [List.getD_eq_default _ _ h]; exact W_pos
  | arg => exact ha
  | add a b _ _ => exact Nat.mod_lt _ W_pos
  | mul a b _ _ => exact Nat.mod_lt _ W_pos
  | sub a b iha _ => exact lt_of_le_of_lt (Nat.sub_le _ _) iha
  | div a b iha _ => exact lt_of_le_of_lt (Nat.div_le_self _ _) iha
  | le a b _ _ => by_cases h : a.eval32 fields arg ≤ b.eval32 fields arg <;> simp [eval32, h] <;> decide
  | cond c a b _ iha ihb =>
      by_cases h : c.eval32 fields arg ≠ 0 <;> simp [eval32, h, iha, ihb]

/-- A static over-approximation of `Expr.eval`, given a bound `B` on the state
fields and on the command argument. -/
def bnd (B : Nat) : Expr → Nat
  | .lit n => n
  | .fld _ => B
  | .arg => B
  | .add a b => a.bnd B + b.bnd B
  | .mul a b => max (a.bnd B * b.bnd B) (max (a.bnd B) (b.bnd B))
  | .sub a b => max (a.bnd B) (b.bnd B)
  | .div a b => max (a.bnd B) (b.bnd B)
  | .le a b => max (max (a.bnd B) (b.bnd B)) 1
  | .cond c a b => max (c.bnd B) (max (a.bnd B) (b.bnd B))

/-- The over-approximation is sound. -/
theorem eval_le_bnd (B : Nat) (fields : List Nat) (arg : Nat)
    (hf : ∀ x ∈ fields, x ≤ B) (ha : arg ≤ B) :
    ∀ e : Expr, e.eval fields arg ≤ e.bnd B := by
  intro e
  induction e with
  | lit n => exact le_rfl
  | fld i =>
      show fields.getD i 0 ≤ B
      rcases lt_or_ge i fields.length with h | h
      · rw [List.getD_eq_getElem _ _ h]; exact hf _ (List.getElem_mem h)
      · rw [List.getD_eq_default _ _ h]; exact Nat.zero_le _
  | arg => exact ha
  | add a b iha ihb => exact Nat.add_le_add iha ihb
  | mul a b iha ihb => exact le_trans (Nat.mul_le_mul iha ihb) (le_max_left _ _)
  | sub a b iha _ => exact le_trans (le_trans (Nat.sub_le _ _) iha) (le_max_left _ _)
  | div a b iha _ => exact le_trans (le_trans (Nat.div_le_self _ _) iha) (le_max_left _ _)
  | le a b _ _ =>
      by_cases h : a.eval fields arg ≤ b.eval fields arg <;>
        simp [NixWars.Expr.eval, bnd, h]
  | cond c a b _ iha ihb =>
      by_cases h : c.eval fields arg ≠ 0 <;>
        simp [NixWars.Expr.eval, bnd, h] <;> [exact Or.inr (Or.inl iha); exact Or.inr (Or.inr ihb)]

/-- Where nothing can overflow, the machine agrees with the mathematics. -/
theorem eval32_eq_eval (B : Nat) (fields : List Nat) (arg : Nat)
    (hf : ∀ x ∈ fields, x ≤ B) (ha : arg ≤ B) :
    ∀ e : Expr, e.bnd B < W → e.eval32 fields arg = e.eval fields arg := by
  intro e
  induction e with
  | lit n =>
      intro h
      have h' : n < W := h
      simp [eval32, NixWars.Expr.eval, Nat.mod_eq_of_lt h']
  | fld i => intro _; rfl
  | arg => intro _; rfl
  | add a b iha ihb =>
      intro h
      have hab : a.bnd B + b.bnd B < W := h
      have ha' := iha (lt_of_le_of_lt (Nat.le_add_right _ _) hab)
      have hb' := ihb (lt_of_le_of_lt (Nat.le_add_left _ _) hab)
      have hsum : a.eval fields arg + b.eval fields arg < W :=
        lt_of_le_of_lt (Nat.add_le_add (eval_le_bnd B fields arg hf ha a)
          (eval_le_bnd B fields arg hf ha b)) hab
      simp [eval32, NixWars.Expr.eval, ha', hb', Nat.mod_eq_of_lt hsum]
  | mul a b iha ihb =>
      intro h
      have h' : max (a.bnd B * b.bnd B) (max (a.bnd B) (b.bnd B)) < W := h
      have hab : a.bnd B * b.bnd B < W := lt_of_le_of_lt (le_max_left _ _) h'
      have hmax : max (a.bnd B) (b.bnd B) < W := lt_of_le_of_lt (le_max_right _ _) h'
      have hbnda := eval_le_bnd B fields arg hf ha a
      have hbndb := eval_le_bnd B fields arg hf ha b
      have ha' := iha (lt_of_le_of_lt (le_max_left _ _) hmax)
      have hb' := ihb (lt_of_le_of_lt (le_max_right _ _) hmax)
      have hprod : a.eval fields arg * b.eval fields arg < W :=
        lt_of_le_of_lt (Nat.mul_le_mul hbnda hbndb) hab
      simp [eval32, NixWars.Expr.eval, ha', hb', Nat.mod_eq_of_lt hprod]
  | sub a b iha ihb =>
      intro h
      have h' : max (a.bnd B) (b.bnd B) < W := h
      simp [eval32, NixWars.Expr.eval, iha (lt_of_le_of_lt (le_max_left _ _) h'),
        ihb (lt_of_le_of_lt (le_max_right _ _) h')]
  | div a b iha ihb =>
      intro h
      have h' : max (a.bnd B) (b.bnd B) < W := h
      simp [eval32, NixWars.Expr.eval, iha (lt_of_le_of_lt (le_max_left _ _) h'),
        ihb (lt_of_le_of_lt (le_max_right _ _) h')]
  | le a b iha ihb =>
      intro h
      have h' : max (max (a.bnd B) (b.bnd B)) 1 < W := h
      have h'' : max (a.bnd B) (b.bnd B) < W := lt_of_le_of_lt (le_max_left _ _) h'
      simp [eval32, NixWars.Expr.eval, iha (lt_of_le_of_lt (le_max_left _ _) h''),
        ihb (lt_of_le_of_lt (le_max_right _ _) h'')]
  | cond c a b ihc iha ihb =>
      intro h
      have h' : max (c.bnd B) (max (a.bnd B) (b.bnd B)) < W := h
      have hc : c.bnd B < W := lt_of_le_of_lt (le_max_left _ _) h'
      have hab : max (a.bnd B) (b.bnd B) < W := lt_of_le_of_lt (le_max_right _ _) h'
      simp [eval32, NixWars.Expr.eval, ihc hc, iha (lt_of_le_of_lt (le_max_left _ _) hab),
        ihb (lt_of_le_of_lt (le_max_right _ _) hab)]

end Expr

namespace Wasm

/-! ## The helper functions do what their names say -/

theorem execLeaf_subSatBody (a b : Nat) (ha : a < W) (hb : b < W) :
    execLeaf subSatBody [a, b] [] = some [a - b] := by
  simp only [execLeaf, subSatBody, execWith, List.getD_cons_zero, List.getD_cons_succ]
  by_cases h : b ≤ a
  · have h1 : (W + a - b) % W = a - b := by simp only [W] at *; omega
    simp [h, h1]
  · have h3 : a - b = 0 := by omega
    simp [h, h3]

theorem execLeaf_divNatBody (a b : Nat) :
    execLeaf divNatBody [a, b] [] = some [a / b] := by
  have h0 : (0 : Nat) % W = 0 := Nat.zero_mod _
  have h1 : (1 : Nat) % W = 1 := Nat.mod_eq_of_lt (by simp only [W]; omega)
  simp only [execLeaf, divNatBody, execWith, List.getD_cons_zero, List.getD_cons_succ, h0, h1]
  by_cases h : b = 0
  · subst h; simp
  · simp [h]

theorem moduleCall_subSat {M : Module} (hM : HasHelpers M) (st : List Nat) (a b : Nat)
    (ha : a < W) (hb : b < W) :
    moduleCall M SUBSAT (b :: a :: st) = some ((a - b) :: st) := by
  simp [moduleCall, hM.1, subSatFunc, execLeaf_subSatBody a b ha hb]

theorem moduleCall_divNat {M : Module} (hM : HasHelpers M) (st : List Nat) (a b : Nat) :
    moduleCall M DIVNAT (b :: a :: st) = some ((a / b) :: st) := by
  simp [moduleCall, hM.2, divNatFunc, execLeaf_divNatBody a b]

/-! ## Compiler correctness -/

/-- **Compiling an expression is correct**: the emitted instructions push
exactly the machine value of the expression, leaving the rest of the stack and
the locals alone. -/
theorem exec_compile {M : Module} (hM : HasHelpers M) (fields : List Nat) (arg : Nat)
    (hf : ∀ x ∈ fields, x < W) (ha : arg < W) :
    ∀ (e : Expr) (is : List Instr) (st : List Nat),
      exec M (compile e ++ is) (arg :: fields) st
        = exec M is (arg :: fields) (e.eval32 fields arg :: st) := by
  intro e
  induction e with
  | lit n =>
      intro is st
      have hlit : n % W = Expr.eval32 fields arg (.lit n) := rfl
      simp [compile, exec, execWith, hlit]
  | fld i =>
      intro is st
      simp [compile, exec, execWith, Expr.eval32, List.getD]
  | arg => intro is st; simp [compile, exec, execWith, Expr.eval32, List.getD]
  | add a b iha ihb =>
      intro is st
      simp only [compile, List.append_assoc, iha, ihb]
      simp [exec, execWith, Expr.eval32]
  | mul a b iha ihb =>
      intro is st
      simp only [compile, List.append_assoc, iha, ihb]
      simp [exec, execWith, Expr.eval32]
  | sub a b iha ihb =>
      intro is st
      simp only [compile, List.append_assoc, iha, ihb]
      have hA := Expr.eval32_lt fields arg hf ha a
      have hB := Expr.eval32_lt fields arg hf ha b
      simp [exec, execWith, Expr.eval32, moduleCall_subSat hM st _ _ hA hB]
  | div a b iha ihb =>
      intro is st
      simp only [compile, List.append_assoc, iha, ihb]
      simp [exec, execWith, Expr.eval32, moduleCall_divNat hM st]
  | le a b iha ihb =>
      intro is st
      simp only [compile, List.append_assoc, iha, ihb]
      simp [exec, execWith, Expr.eval32]
  | cond c a b ihc iha ihb =>
      intro is st
      simp only [compile, List.append_assoc, iha, ihb, ihc]
      simp [exec, execWith, Expr.eval32]

/-- Compiling a whole program pushes the new state vector, first field deepest. -/
theorem exec_compileProg {M : Module} (hM : HasHelpers M) (fields : List Nat) (arg : Nat)
    (hf : ∀ x ∈ fields, x < W) (ha : arg < W) :
    ∀ (prog : List Expr) (is : List Instr) (st : List Nat),
      exec M (compileProg prog ++ is) (arg :: fields) st
        = exec M is (arg :: fields)
            ((prog.map (fun e => e.eval32 fields arg)).reverse ++ st) := by
  intro prog
  induction prog with
  | nil => intro is st; simp [compileProg]
  | cons e prog ih =>
      intro is st
      simp only [compileProg, List.flatMap_cons, List.append_assoc,
        exec_compile hM fields arg hf ha e, List.map_cons, List.reverse_cons,
        List.append_assoc, List.singleton_append]
      exact ih is _

/-- Calling a compiled command: the exported function returns the new state
vector, in 32-bit arithmetic. -/
theorem callExport_compileProg {M : Module} (hM : HasHelpers M) {f : Nat} {fn : Func}
    {prog : List Expr} (hfn : M[f]? = some fn) (hbody : fn.body = compileProg prog)
    (hres : fn.results = prog.length) (fields : List Nat) (arg : Nat)
    (harity : fn.arity = fields.length + 1)
    (hf : ∀ x ∈ fields, x < W) (ha : arg < W) :
    callExport M f (arg :: fields) = some (prog.map (fun e => e.eval32 fields arg)) := by
  have hexec : exec M fn.body (arg :: fields) []
      = some ((prog.map (fun e => e.eval32 fields arg)).reverse) := by
    rw [hbody]
    simpa [exec, execWith] using exec_compileProg hM fields arg hf ha prog [] []
  have hlen : ((prog.map (fun e => e.eval32 fields arg)).reverse).length = fn.results := by
    simp [hres]
  simp only [callExport, hfn]
  rw [if_pos (by simp [harity])]
  rw [hexec]
  dsimp only
  rw [if_pos hlen, List.reverse_reverse]

/-! ## From the machine back to the game

`B = 2 ^ 30` is the range the board operates in: state fields and the command
argument are at most `B`, which leaves room for everything the games compute
from them — counters that get incremented, and the `3 * (turn / 3)` inside
Monster Dash's `turn % 3` — without wrapping. -/

/-- The bound the board keeps its values under. -/
def B : Nat := 1073741824

theorem B_lt_W : B < W := by decide

/-- **A compiled command is its program.** When nothing can overflow, calling
the exported function computes exactly `runIR` — the table `Machine.lean`
reasons about — on the state fields. -/
theorem callExport_runIR {M : Module} (hM : HasHelpers M) {f : Nat} {fn : Func}
    {prog : List Expr} (hfn : M[f]? = some fn) (hbody : fn.body = compileProg prog)
    (hres : fn.results = prog.length) (fields : List Nat) (arg : Nat)
    (harity : fn.arity = fields.length + 1)
    (hf : ∀ x ∈ fields, x ≤ B) (ha : arg ≤ B)
    (hbnd : ∀ e ∈ prog, e.bnd B < W) :
    callExport M f (arg :: fields) = some (runIR prog fields arg) := by
  have hfW : ∀ x ∈ fields, x < W := fun x hx => lt_of_le_of_lt (hf x hx) B_lt_W
  have haW : arg < W := lt_of_le_of_lt ha B_lt_W
  rw [callExport_compileProg hM hfn hbody hres fields arg harity hfW haW]
  unfold runIR
  exact congrArg some (List.map_congr_left fun e he =>
    Expr.eval32_eq_eval B fields arg hf ha e (hbnd e he))

end Wasm
end NixWars
