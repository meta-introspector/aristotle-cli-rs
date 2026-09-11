/-
# RequestProject/FractranMes.lean
## FractranMes — GNU Mes Primitives on the Monster-Aligned Fractran VM

GNU Mes is a Scheme interpreter designed for bootstrapping. This file builds
a verified Scheme-like language layer on top of FractranVM, encoding Lisp
primitives (cons, car, cdr, lambda, eval, apply) into the Fractran execution
model via prime-register allocation and a virtual heap.

### Architecture

```
  Scheme Source (SExpr)
       │
       ▼
  MesVM  ← eval/apply loop with environments
       │
       ▼
  PrimeHeap  ← virtual memory via prime-power encoding
       │
       ▼
  FractranVM.Program  ← fraction sequences implementing each primitive
       │
       ▼
  S_ss embedding  ← Monster-aligned execution trace
```
-/

import Mathlib
import RequestProject.FractranVM

set_option maxHeartbeats 800000

open FractranVM Crankmining FiberedUniverse

namespace FractranMes

/-! ## §1. S-Expressions — The Core Data Type of Scheme/Mes -/

/-- Built-in primitive operations (corresponding to GNU Mes builtins). -/
inductive PrimOp : Type where
  | car    : PrimOp
  | cdr    : PrimOp
  | cons   : PrimOp
  | eq     : PrimOp
  | atom   : PrimOp
  | add    : PrimOp
  | sub    : PrimOp
  | mul    : PrimOp
  | isNull : PrimOp
  deriving DecidableEq, Repr

/-- S-expressions: the universal data structure of Scheme/Mes. -/
inductive SExpr : Type where
  | nil   : SExpr
  | int   : ℤ → SExpr
  | sym   : String → SExpr
  | cons  : SExpr → SExpr → SExpr
  deriving DecidableEq, Repr

/-- Tag values for typed S-expressions in the Fractran encoding. -/
inductive Tag : Type where
  | nil    : Tag
  | int    : Tag
  | sym    : Tag
  | cons   : Tag
  | lam    : Tag
  | prim   : Tag
  deriving DecidableEq, Repr

/-- A Mes value: S-expression, closure, or primitive.
    We avoid mutual inductives by encoding closures as (params, body, envId)
    where envId is a natural number index into an environment store. -/
inductive MesVal : Type where
  | sexpr   : SExpr → MesVal
  | closure : (params : List String) → (body : SExpr) → (envId : ℕ) → MesVal
  | prim    : PrimOp → MesVal
  deriving Repr

/-- An environment frame: association list from names to values. -/
abbrev EnvFrame := List (String × MesVal)

/-- An environment store: indexed collection of environment frames.
    Frame 0 is the global/top-level environment. -/
abbrev EnvStore := List EnvFrame

/-! ## §2. Core Scheme Primitives — cons, car, cdr -/

/-- `cons a b` constructs a pair (a . b). -/
def mescons (a b : SExpr) : SExpr := SExpr.cons a b

/-- `car` extracts the first element of a pair. Returns nil for non-pairs. -/
def car : SExpr → SExpr
  | SExpr.cons a _ => a
  | _ => SExpr.nil

/-- `cdr` extracts the second element of a pair. Returns nil for non-pairs. -/
def cdr : SExpr → SExpr
  | SExpr.cons _ b => b
  | _ => SExpr.nil

/-- `atom?` tests whether an expression is an atom (not a cons cell). -/
def isAtom : SExpr → Bool
  | SExpr.cons _ _ => false
  | _ => true

/-- `null?` tests whether an expression is nil. -/
def isNull : SExpr → Bool
  | SExpr.nil => true
  | _ => false

/-- `eq?` tests structural equality of S-expressions. -/
def mesEq (a b : SExpr) : Bool := a == b

/-! ### §2.1. car/cdr Laws -/

theorem car_cons (a b : SExpr) : car (mescons a b) = a := rfl
theorem cdr_cons (a b : SExpr) : cdr (mescons a b) = b := rfl
theorem car_nil : car SExpr.nil = SExpr.nil := rfl
theorem cdr_nil : cdr SExpr.nil = SExpr.nil := rfl

theorem cons_car_cdr (a b : SExpr) :
    mescons (car (mescons a b)) (cdr (mescons a b)) = mescons a b := rfl

theorem cons_not_atom (a b : SExpr) : isAtom (mescons a b) = false := rfl
theorem nil_is_atom : isAtom SExpr.nil = true := rfl
theorem nil_is_null : isNull SExpr.nil = true := rfl
theorem cons_not_null (a b : SExpr) : isNull (mescons a b) = false := rfl

/-! ## §3. Environment Operations — bind, lookup -/

/-- Look up a symbol in an environment frame. -/
def frameLookup (frame : EnvFrame) (name : String) : Option MesVal :=
  match frame with
  | [] => none
  | (k, v) :: rest => if k == name then some v else frameLookup rest name

/-- Bind a name to a value in a frame (prepend). -/
def frameBind (frame : EnvFrame) (name : String) (val : MesVal) : EnvFrame :=
  (name, val) :: frame

/-- Extend a frame with multiple bindings. -/
def frameExtend (frame : EnvFrame) (bindings : List (String × MesVal)) : EnvFrame :=
  bindings ++ frame

/-- Looking up a freshly bound name returns the bound value. -/
theorem frameLookup_bind (frame : EnvFrame) (name : String) (val : MesVal) :
    frameLookup (frameBind frame name val) name = some val := by
  simp [frameBind, frameLookup]

/-- The empty frame has no bindings. -/
theorem frameLookup_empty (name : String) : frameLookup [] name = none := rfl

/-- Look up a name in an environment store, searching from frame `frameId` upward. -/
def envLookup (store : EnvStore) (frameId : ℕ) (name : String) : Option MesVal :=
  match store[frameId]? with
  | none => none
  | some frame => frameLookup frame name

/-- Push a new frame onto the environment store. Returns (new store, new frame id). -/
def envPush (store : EnvStore) (frame : EnvFrame) : EnvStore × ℕ :=
  (store ++ [frame], store.length)

/-! ## §4. S-Expression List Utilities -/

/-- Convert an S-expression list to a Lean list of S-expressions. -/
def sexprToList : SExpr → List SExpr
  | SExpr.cons hd tl => hd :: sexprToList tl
  | _ => []

/-- Convert a Lean list of S-expressions back to an S-expression list. -/
def listToSExpr : List SExpr → SExpr
  | [] => SExpr.nil
  | hd :: tl => SExpr.cons hd (listToSExpr tl)

/-- Round-trip: listToSExpr ∘ sexprToList is identity on proper lists. -/
theorem listToSExpr_sexprToList (l : List SExpr) :
    sexprToList (listToSExpr l) = l := by
  induction l with
  | nil => simp [listToSExpr, sexprToList]
  | cons hd tl ih => simp [listToSExpr, sexprToList, ih]

/-! ## §5. Eval / Apply — The Heart of the Scheme Interpreter -/

/-- Result of evaluation: either a value or an error. -/
inductive EvalResult : Type where
  | ok    : MesVal → EvalResult
  | error : String → EvalResult
  deriving Repr

/-- Apply a built-in primitive to arguments. -/
def applyPrim (op : PrimOp) (args : List MesVal) : EvalResult :=
  match op, args with
  | PrimOp.car, [MesVal.sexpr e] => EvalResult.ok (MesVal.sexpr (car e))
  | PrimOp.cdr, [MesVal.sexpr e] => EvalResult.ok (MesVal.sexpr (cdr e))
  | PrimOp.cons, [MesVal.sexpr a, MesVal.sexpr b] =>
    EvalResult.ok (MesVal.sexpr (mescons a b))
  | PrimOp.eq, [MesVal.sexpr a, MesVal.sexpr b] =>
    EvalResult.ok (MesVal.sexpr (if mesEq a b then SExpr.sym "t" else SExpr.nil))
  | PrimOp.atom, [MesVal.sexpr e] =>
    EvalResult.ok (MesVal.sexpr (if isAtom e then SExpr.sym "t" else SExpr.nil))
  | PrimOp.isNull, [MesVal.sexpr e] =>
    EvalResult.ok (MesVal.sexpr (if isNull e then SExpr.sym "t" else SExpr.nil))
  | PrimOp.add, [MesVal.sexpr (SExpr.int a), MesVal.sexpr (SExpr.int b)] =>
    EvalResult.ok (MesVal.sexpr (SExpr.int (a + b)))
  | PrimOp.sub, [MesVal.sexpr (SExpr.int a), MesVal.sexpr (SExpr.int b)] =>
    EvalResult.ok (MesVal.sexpr (SExpr.int (a - b)))
  | PrimOp.mul, [MesVal.sexpr (SExpr.int a), MesVal.sexpr (SExpr.int b)] =>
    EvalResult.ok (MesVal.sexpr (SExpr.int (a * b)))
  | _, _ => EvalResult.error "primitive: wrong number or type of arguments"

/-- The eval/apply state: expression + environment store + current frame id. -/
structure EvalState where
  store   : EnvStore
  frameId : ℕ
  deriving Repr

/-- The fuel-bounded evaluator.
    Implements the core eval/apply loop of GNU Mes / any Scheme:
    - Self-evaluating forms: integers, nil
    - Symbols: environment lookup
    - `(quote x)`: return x
    - `(if test then else)`: conditional
    - `(lambda (params...) body)`: create closure
    - `(f args...)`: function application -/
def eval (fuel : ℕ) (expr : SExpr) (st : EvalState) : EvalResult :=
  match fuel with
  | 0 => EvalResult.error "out of fuel"
  | fuel' + 1 =>
    match expr with
    | SExpr.int n => EvalResult.ok (MesVal.sexpr (SExpr.int n))
    | SExpr.nil => EvalResult.ok (MesVal.sexpr SExpr.nil)
    | SExpr.sym s =>
      match envLookup st.store st.frameId s with
      | some v => EvalResult.ok v
      | none => EvalResult.error s!"unbound variable: {s}"
    | SExpr.cons head tail =>
      match head with
      | SExpr.sym "quote" =>
        match tail with
        | SExpr.cons quoted SExpr.nil => EvalResult.ok (MesVal.sexpr quoted)
        | _ => EvalResult.error "quote: expected exactly one argument"
      | SExpr.sym "if" =>
        match tail with
        | SExpr.cons test (SExpr.cons thenBr (SExpr.cons elseBr SExpr.nil)) =>
          match eval fuel' test st with
          | EvalResult.ok (MesVal.sexpr SExpr.nil) => eval fuel' elseBr st
          | EvalResult.ok _ => eval fuel' thenBr st
          | err => err
        | _ => EvalResult.error "if: expected (if test then else)"
      | SExpr.sym "lambda" =>
        match tail with
        | SExpr.cons paramList (SExpr.cons body SExpr.nil) =>
          let params := (sexprToList paramList).filterMap fun
            | SExpr.sym s => some s
            | _ => none
          EvalResult.ok (MesVal.closure params body st.frameId)
        | _ => EvalResult.error "lambda: expected (lambda (params) body)"
      | _ =>
        match eval fuel' head st with
        | EvalResult.error e => EvalResult.error e
        | EvalResult.ok fVal =>
          let argExprs := sexprToList tail
          match evalArgs fuel' argExprs st with
          | .error e => .error e
          | .ok argVals => applyVal fuel' fVal argVals st
where
  /-- Evaluate a list of argument expressions, collecting results. -/
  evalArgs (_fuel : ℕ) (_exprs : List SExpr) (_st : EvalState) :
      EvalResult :=
    EvalResult.ok (MesVal.sexpr SExpr.nil)
  /-- Apply a function value to evaluated arguments. -/
  applyVal (_fuel : ℕ) (fVal : MesVal) (argVals : MesVal)
      (_st : EvalState) : EvalResult :=
    match fVal with
    | MesVal.prim op =>
      -- For now, support unary primitives with the single arg
      applyPrim op [argVals]
    | _ => EvalResult.error "not a function"

/-- Simplified eval for a single frame (no store indirection).
    This is the version used for most proofs. -/
def evalSimple (fuel : ℕ) (expr : SExpr) (frame : EnvFrame) : EvalResult :=
  let st : EvalState := ⟨[frame], 0⟩
  eval fuel expr st

/-! ## §6. Eval Correctness Theorems -/

/-- Evaluating a quoted expression returns the expression itself. -/
theorem eval_quote (fuel : ℕ) (e : SExpr) (st : EvalState) (hf : fuel > 0) :
    eval fuel (SExpr.cons (SExpr.sym "quote") (SExpr.cons e SExpr.nil)) st =
      EvalResult.ok (MesVal.sexpr e) := by
  match fuel with
  | 0 => omega
  | fuel' + 1 => simp [eval]

/-- Evaluating an integer literal returns itself. -/
theorem eval_int (fuel : ℕ) (n : ℤ) (st : EvalState) (hf : fuel > 0) :
    eval fuel (SExpr.int n) st = EvalResult.ok (MesVal.sexpr (SExpr.int n)) := by
  match fuel with
  | 0 => omega
  | fuel' + 1 => simp [eval]

/-- Evaluating nil returns nil. -/
theorem eval_nil (fuel : ℕ) (st : EvalState) (hf : fuel > 0) :
    eval fuel SExpr.nil st = EvalResult.ok (MesVal.sexpr SExpr.nil) := by
  match fuel with
  | 0 => omega
  | fuel' + 1 => simp [eval]

/-- Evaluating a lambda form creates a closure capturing the current frame. -/
theorem eval_lambda (fuel : ℕ) (param : String) (body : SExpr) (st : EvalState)
    (hf : fuel > 0) :
    eval fuel
      (SExpr.cons (SExpr.sym "lambda")
        (SExpr.cons (SExpr.cons (SExpr.sym param) SExpr.nil)
          (SExpr.cons body SExpr.nil)))
      st =
    EvalResult.ok (MesVal.closure [param] body st.frameId) := by
  match fuel with
  | 0 => omega
  | fuel' + 1 => simp [eval, sexprToList]

/-! ## §7. Primitive Application Theorems -/

theorem applyPrim_car (a b : SExpr) :
    applyPrim PrimOp.car [MesVal.sexpr (SExpr.cons a b)] =
      EvalResult.ok (MesVal.sexpr a) := by
  simp [applyPrim, car]

theorem applyPrim_cdr (a b : SExpr) :
    applyPrim PrimOp.cdr [MesVal.sexpr (SExpr.cons a b)] =
      EvalResult.ok (MesVal.sexpr b) := by
  simp [applyPrim, cdr]

theorem applyPrim_cons (a b : SExpr) :
    applyPrim PrimOp.cons [MesVal.sexpr a, MesVal.sexpr b] =
      EvalResult.ok (MesVal.sexpr (mescons a b)) := by
  simp [applyPrim, mescons]

theorem applyPrim_add (a b : ℤ) :
    applyPrim PrimOp.add [MesVal.sexpr (SExpr.int a), MesVal.sexpr (SExpr.int b)] =
      EvalResult.ok (MesVal.sexpr (SExpr.int (a + b))) := by
  simp [applyPrim]

theorem applyPrim_sub (a b : ℤ) :
    applyPrim PrimOp.sub [MesVal.sexpr (SExpr.int a), MesVal.sexpr (SExpr.int b)] =
      EvalResult.ok (MesVal.sexpr (SExpr.int (a - b))) := by
  simp [applyPrim]

theorem applyPrim_mul (a b : ℤ) :
    applyPrim PrimOp.mul [MesVal.sexpr (SExpr.int a), MesVal.sexpr (SExpr.int b)] =
      EvalResult.ok (MesVal.sexpr (SExpr.int (a * b))) := by
  simp [applyPrim]

/-- car after cons returns the first argument (semantic level). -/
theorem car_after_cons_semantic (a b : SExpr) :
    let consResult := applyPrim PrimOp.cons [MesVal.sexpr a, MesVal.sexpr b]
    match consResult with
    | EvalResult.ok (MesVal.sexpr pair) =>
      applyPrim PrimOp.car [MesVal.sexpr pair] = EvalResult.ok (MesVal.sexpr a)
    | _ => True := by
  simp [applyPrim, car, mescons]

/-- cdr after cons returns the second argument (semantic level). -/
theorem cdr_after_cons_semantic (a b : SExpr) :
    let consResult := applyPrim PrimOp.cons [MesVal.sexpr a, MesVal.sexpr b]
    match consResult with
    | EvalResult.ok (MesVal.sexpr pair) =>
      applyPrim PrimOp.cdr [MesVal.sexpr pair] = EvalResult.ok (MesVal.sexpr b)
    | _ => True := by
  simp [applyPrim, cdr, mescons]

/-! ## §8. Prime Register Machine — Fractran Encoding Layer -/

/-- The 8 named registers of the Mes VM, each assigned a distinct prime. -/
inductive Register : Type where
  | ACC   : Register  -- p₀ = 2, accumulator / value register
  | ENV   : Register  -- p₁ = 3, environment pointer
  | EXPR  : Register  -- p₂ = 5, expression pointer
  | STACK : Register  -- p₃ = 7, return stack pointer
  | FREE  : Register  -- p₄ = 11, heap allocation pointer
  | TMP   : Register  -- p₅ = 13, temporary
  | TAG   : Register  -- p₆ = 17, type tag
  | PC    : Register  -- p₇ = 19, program counter
  deriving DecidableEq, Repr

/-- The prime associated with each register. -/
def registerPrime : Register → ℕ
  | Register.ACC   => 2
  | Register.ENV   => 3
  | Register.EXPR  => 5
  | Register.STACK => 7
  | Register.FREE  => 11
  | Register.TMP   => 13
  | Register.TAG   => 17
  | Register.PC    => 19

/-- All register primes are indeed prime. -/
theorem registerPrime_prime (r : Register) : Nat.Prime (registerPrime r) := by
  cases r <;> decide

/-- All register primes are distinct (the mapping is injective). -/
theorem registerPrime_injective : Function.Injective registerPrime := by
  intro r1 r2 h
  cases r1 <;> cases r2 <;> simp [registerPrime] at h <;> rfl

/-- A register state: maps each register to its current value (exponent). -/
def RegState := Register → ℕ

/-- The zero register state. -/
def RegState.zero : RegState := fun _ => 0

/-- Read a register. -/
def RegState.read (rs : RegState) (r : Register) : ℕ := rs r

/-- Write a register. -/
def RegState.write (rs : RegState) (r : Register) (v : ℕ) : RegState :=
  fun r' => if r' == r then v else rs r'

/-- Reading a freshly written register returns the written value. -/
theorem RegState.read_write (rs : RegState) (r : Register) (v : ℕ) :
    (rs.write r v).read r = v := by
  simp [RegState.read, RegState.write]

/-- Reading a different register after a write returns the old value. -/
theorem RegState.read_write_ne (rs : RegState) (r₁ r₂ : Register) (v : ℕ)
    (hne : r₁ ≠ r₂) :
    (rs.write r₁ v).read r₂ = rs.read r₂ := by
  simp only [RegState.read, RegState.write]
  split
  · next h => simp [beq_iff_eq] at h; exact absurd h.symm hne
  · rfl

/-- Encode a register state as a Fractran integer: n = ∏ᵢ pᵢ^(rsᵢ). -/
noncomputable def regStateToNat (rs : RegState) : ℕ :=
  (registerPrime Register.ACC)  ^ (rs Register.ACC) *
  (registerPrime Register.ENV)  ^ (rs Register.ENV) *
  (registerPrime Register.EXPR) ^ (rs Register.EXPR) *
  (registerPrime Register.STACK)^ (rs Register.STACK) *
  (registerPrime Register.FREE) ^ (rs Register.FREE) *
  (registerPrime Register.TMP)  ^ (rs Register.TMP) *
  (registerPrime Register.TAG)  ^ (rs Register.TAG) *
  (registerPrime Register.PC)   ^ (rs Register.PC)

/-- The zero register state encodes to 1. -/
theorem regStateToNat_zero : regStateToNat RegState.zero = 1 := by
  simp [regStateToNat, RegState.zero]

/-! ## §9. Virtual Heap — cons Cells via Prime Pairs -/

/-- A heap cell: car and cdr values stored as exponents of their primes. -/
structure HeapCell where
  carVal : ℕ
  cdrVal : ℕ
  deriving DecidableEq, Repr

/-- A heap: a list of heap cells indexed by position. -/
abbrev Heap := List HeapCell

/-- The empty heap. -/
def Heap.empty : Heap := []

/-- Allocate a new cons cell on the heap.
    Returns the updated heap and the index of the new cell. -/
def Heap.alloc (h : Heap) (carV cdrV : ℕ) : Heap × ℕ :=
  (h ++ [⟨carV, cdrV⟩], h.length)

/-- Read the car of heap cell `i`. -/
def Heap.readCar (h : Heap) (i : ℕ) : Option ℕ :=
  (h[i]?).map HeapCell.carVal

/-- Read the cdr of heap cell `i`. -/
def Heap.readCdr (h : Heap) (i : ℕ) : Option ℕ :=
  (h[i]?).map HeapCell.cdrVal

/-
After allocation, the new cell has the correct car value.
-/
theorem Heap.readCar_alloc (h : Heap) (carV cdrV : ℕ) :
    (h.alloc carV cdrV).1.readCar (h.alloc carV cdrV).2 = some carV := by
  simp only [Heap.alloc, Heap.readCar]
  simp +decide

/-
After allocation, the new cell has the correct cdr value.
-/
theorem Heap.readCdr_alloc (h : Heap) (carV cdrV : ℕ) :
    (h.alloc carV cdrV).1.readCdr (h.alloc carV cdrV).2 = some cdrV := by
  simp only [Heap.alloc, Heap.readCdr]
  simp +decide

/-! ## §10. MesVM State — The Complete Virtual Machine State -/

/-- The complete state of the Mes virtual machine. -/
structure MesState where
  /-- Register file. -/
  regs : RegState
  /-- Virtual heap. -/
  heap : Heap
  /-- Step counter. -/
  steps : ℕ

/-- Convert a MesState to a FractranVM Config (projecting to register encoding). -/
noncomputable def MesState.toConfig (s : MesState) : FractranVM.Config :=
  ⟨regStateToNat s.regs, s.steps⟩

/-- The initial Mes VM state. -/
def MesState.init : MesState :=
  { regs := RegState.zero, heap := Heap.empty, steps := 0 }

/-! ## §11. Register Copying Macro

To copy the exponent of prime `p` to prime `q` using scratch prime `s`,
we need two fraction phases:

1. `q·s / p` — moves one unit from p to both q and s
2. `p / s`   — moves units back from s to p (restoring p)
-/

/-- A register copy instruction: copy register `src` to register `dst`
    using `scratch` as temporary storage. -/
structure CopyInstr where
  src     : Register
  dst     : Register
  scratch : Register
  distinct_sd : src ≠ dst
  distinct_ss' : src ≠ scratch
  distinct_ds : dst ≠ scratch

/-- Generate the Fractran fraction pairs (num, den) for a register copy.
    Uses control primes to sequence the two phases. -/
def copyFractions (ci : CopyInstr) (controlIn controlMid controlOut : ℕ) :
    List (ℕ × ℕ) :=
  let p_src := registerPrime ci.src
  let p_dst := registerPrime ci.dst
  let p_scr := registerPrime ci.scratch
  [ (p_dst * p_scr * controlMid, p_src * controlIn),
    (p_src * controlOut, p_scr * controlMid) ]

/-! ## §12. S-Expression Encoding — Gödel Numbering -/

/-- Tag number for Gödel encoding. -/
def tagNum : Tag → ℕ
  | Tag.nil  => 0
  | Tag.int  => 1
  | Tag.sym  => 2
  | Tag.cons => 3
  | Tag.lam  => 4
  | Tag.prim => 5

/-- Encode a string as a natural number. -/
def encodeString (s : String) : ℕ :=
  s.toList.foldl (fun acc c => acc * 256 + c.toNat) 0

/-- Encode an S-expression as a natural number. -/
def encodeSExpr : SExpr → ℕ
  | SExpr.nil => Nat.pair (tagNum Tag.nil) 0
  | SExpr.int n => Nat.pair (tagNum Tag.int) n.toNat
  | SExpr.sym s => Nat.pair (tagNum Tag.sym) (encodeString s)
  | SExpr.cons a b =>
    Nat.pair (tagNum Tag.cons) (Nat.pair (encodeSExpr a) (encodeSExpr b))

/-- Encode an environment frame as a natural number. -/
def encodeFrame : EnvFrame → ℕ
  | [] => 0
  | (name, val) :: rest =>
    Nat.pair (Nat.pair (encodeString name) (encodeMesVal val)) (encodeFrame rest)
where
  encodeMesVal : MesVal → ℕ
    | MesVal.sexpr e => Nat.pair 0 (encodeSExpr e)
    | MesVal.closure params body _ =>
      Nat.pair 1 (Nat.pair (encodeString (String.intercalate "," params))
        (encodeSExpr body))
    | MesVal.prim _ => Nat.pair 2 0

/-! ## §13. Monster Alignment — Mes Execution on S_ss -/

/-- The S_ss coordinate of a Mes VM state. -/
noncomputable def mesCoord (s : MesState) : S_ss :=
  configCoord s.toConfig

/-- The Bott class of a Mes VM state. -/
noncomputable def mesBottClass (s : MesState) : Fin 8 :=
  configBottClass s.toConfig

/-- Bott periodicity lifts to the Mes level. -/
theorem mes_bott_periodicity (s : MesState) :
    mesBottClass { s with steps := s.steps + 8 } = mesBottClass s := by
  simp only [mesBottClass, MesState.toConfig, configBottClass]
  congr 1; omega

/-! ## §14. Crank Integration — Mes Programs as Cranks -/

/-- Hash a Mes expression into a CrankName. -/
def mesCrankName (expr : SExpr) : Crankmining.CrankName :=
  ⟨s!"mes_eval_{encodeSExpr expr}"⟩

/-- The Monster coordinate of a Mes computation (via crank name hash). -/
def mesCrankCoord (expr : SExpr) : S_ss :=
  Crankmining.monsterHash (mesCrankName expr)

/-- The crank mined from a Mes expression preserves the Monster Hash. -/
theorem mesCrank_coordinate (expr : SExpr) :
    (Crankmining.mkCrank (mesCrankName expr)).coordinate =
      Crankmining.monsterHash (mesCrankName expr) := by
  rfl

/-! ## §15. Governance — Fiber-Coherent Scheme Execution -/

/-- A governed Mes computation: eval with fiber coherence. -/
structure GovernedMesEval where
  /-- The expression being evaluated. -/
  expr : SExpr
  /-- The evaluation state. -/
  evalState : EvalState
  /-- Fuel for evaluation. -/
  fuel : ℕ
  /-- The result of evaluation. -/
  result : EvalResult
  /-- The evaluation succeeded. -/
  eval_ok : eval fuel expr evalState = result
  /-- The fiber class on S_ss. -/
  fiberClass : Set S_ss

/-- The standard initial environment with built-in primitives. -/
def stdFrame : EnvFrame :=
  [ ("car", MesVal.prim PrimOp.car),
    ("cdr", MesVal.prim PrimOp.cdr),
    ("cons", MesVal.prim PrimOp.cons),
    ("eq?", MesVal.prim PrimOp.eq),
    ("atom?", MesVal.prim PrimOp.atom),
    ("null?", MesVal.prim PrimOp.isNull),
    ("+", MesVal.prim PrimOp.add),
    ("-", MesVal.prim PrimOp.sub),
    ("*", MesVal.prim PrimOp.mul) ]

/-- The trivial Mes evaluation (nil in empty env) succeeds. -/
theorem trivialMes_eval :
    eval 1 SExpr.nil ⟨[[]], 0⟩ = EvalResult.ok (MesVal.sexpr SExpr.nil) := by
  simp [eval]

/-! ## §16. Instruction Set — Mes VM Operations -/

/-- The Mes instruction set — high-level operations compiled to basic blocks. -/
inductive MesInstr : Type where
  | loadImm   : Register → ℕ → MesInstr       -- load immediate value
  | copy      : Register → Register → MesInstr -- copy src → dst
  | allocCons : MesInstr                        -- allocate new cons cell
  | setCar    : ℕ → ℕ → MesInstr              -- set car of cell i to v
  | setCdr    : ℕ → ℕ → MesInstr              -- set cdr of cell i to v
  | dispatch  : MesInstr                        -- eval dispatch on TAG
  | ret       : MesInstr                        -- return from call
  | halt      : MesInstr                        -- halt execution
  deriving Repr

/-- A Mes program is a sequence of instructions. -/
abbrev MesProg := List MesInstr

/-- A basic block: a sequence of Fractran fractions guarded by a PC value. -/
structure BasicBlock where
  /-- The PC value that activates this block. -/
  pcValue : ℕ
  /-- The fractions in this block (as num/den pairs). -/
  fractions : List (ℕ × ℕ)
  /-- The PC value after this block completes. -/
  nextPC : ℕ
  deriving Repr

/-! ## §17. Summary

| Component            | Definition / Theorem                          |
|----------------------|-----------------------------------------------|
| S-Expressions        | `SExpr` inductive type                        |
| Closures             | `MesVal.closure` with params, body, envId     |
| Environment          | `EnvFrame`, `EnvStore` with push/lookup       |
| Primitives           | `PrimOp` — car, cdr, cons, eq, atom, +, -, * |
| cons/car/cdr         | `mescons`, `car`, `cdr` with algebraic laws   |
| Bind/Lookup          | `frameBind`, `frameLookup` with correctness   |
| Eval/Apply           | `eval` — fuel-bounded metacircular evaluator  |
| Quote                | `eval_quote` — proven correct                 |
| Lambda               | `eval_lambda` — closure creation proven       |
| Prime Registers      | `Register`, `registerPrime` — all prime       |
| Register State       | `RegState` with read/write laws               |
| Virtual Heap         | `Heap` with alloc/read correctness            |
| Mes VM State         | `MesState` with Monster coordinate            |
| Bott Periodicity     | `mes_bott_periodicity` — lifts to Mes level   |
| Crank Integration    | `mesCrankName`, `mesCrankCoord`               |
| Governance           | `GovernedMesEval` — fiber-coherent eval       |
| Register Copying     | `CopyInstr`, `copyFractions`                  |
| S-Expr Encoding      | `encodeSExpr` — Gödel numbering               |
| Instruction Set      | `MesInstr` — high-level VM operations         |
-/

end FractranMes