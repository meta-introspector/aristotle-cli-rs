import RequestProject.Craft.Main

/-!
# A verified TypeScript-to-Lua compiler for ComputerCraft item-moving programs

This file sets up the two languages used in `RequestProject.CCLuaCompile`:

* **TS0** — the minimal core of the TypeScript dialect used by the
  `cc-tstl-template` toolchain: integer expressions, `!`, `&&`, `||`, `<`,
  `!==`, `let`/assignment/`++`, `if`, `while`, and one effectful call,
  `pushItems`, which moves items between two peripherals of a network.
* **Lua0** — the modelled fragment of the Lua that runs on a ComputerCraft
  computer: the same statement forms, but with Lua's *values* (numbers,
  booleans, `nil`), Lua's *truthiness* (only `false` and `nil` are falsy — in
  particular `0` is **true**), and Lua's `and`/`or`, which return one of their
  operands rather than a boolean.

The machine state that both languages act on is the inventory network of
`RequestProject.Main` (namespace `Hopper`), so `pushItems` is literally the
verified transfer step of that development.

The two truthiness conventions disagree, and Lua's `and`/`or` are not the
boolean connectives, so the translation in `RequestProject.CCLuaCompile` is a
genuine translation and its correctness theorem has real content.
-/

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace CCLua

open Hopper

/-- Identifiers. -/
abbrev Name := String

/-! ## Source language: TS0 -/

/-- TS0 expressions.  All TS0 values are integers; `lt`, `ne` and `notE`
produce `1` or `0`, and `andT`/`orT` are TypeScript's `&&`/`||`, which return
one of their operands, `0` being the only falsy number. -/
inductive TExp where
  /-- Integer literal. -/
  | lit (n : Int)
  /-- Variable reference. -/
  | var (x : Name)
  /-- Addition. -/
  | add (a b : TExp)
  /-- Subtraction. -/
  | sub (a b : TExp)
  /-- Multiplication. -/
  | mul (a b : TExp)
  /-- `a < b`, as `1` or `0`. -/
  | lt (a b : TExp)
  /-- `a !== b`, as `1` or `0`. -/
  | ne (a b : TExp)
  /-- `!a`, as `1` or `0`. -/
  | notE (a : TExp)
  /-- `a && b`. -/
  | andT (a b : TExp)
  /-- `a || b`. -/
  | orT (a b : TExp)
  /-- `getItemCount(a, b)`: the number of items in slot `b` of network member
  `a`. -/
  | size (a b : TExp)
deriving Repr, DecidableEq, Inhabited

/-- TS0 statements. -/
inductive TStmt where
  /-- The empty statement. -/
  | skip
  /-- Sequential composition. -/
  | seq (s1 s2 : TStmt)
  /-- `let x = e;` — introduces a new binding. -/
  | letD (x : Name) (e : TExp)
  /-- `x = e;` — updates an existing binding. -/
  | assign (x : Name) (e : TExp)
  /-- `x++;` -/
  | incr (x : Name)
  /-- `if (c) { s1 } else { s2 }` -/
  | ifElse (c : TExp) (s1 s2 : TStmt)
  /-- `while (c) { body }` -/
  | whileDo (c : TExp) (body : TStmt)
  /-- `let x = pushItems(src, dst, i, j, amt);` -/
  | push (x : Name) (src dst i j amt : TExp)
deriving Repr, Inhabited

/-- A TS0 environment maps identifiers to integers; the head of the list is
the most recent binding. -/
abbrev TEnv := List (Name × Int)

/-- A TS0 machine state: the variable environment and the inventory network. -/
structure TState where
  /-- Variable environment. -/
  env : TEnv
  /-- The inventory network the program manipulates. -/
  net : Network
deriving Repr

/-- Update the value of an existing binding, or add one at the end. -/
def setVar {β : Type} (env : List (Name × β)) (x : Name) (v : β) :
    List (Name × β) :=
  match env with
  | [] => [(x, v)]
  | (y, w) :: rest => if y = x then (x, v) :: rest else (y, w) :: setVar rest x v

/-- The number of items in slot `j` of network member `a`. -/
def slotSizeAt (net : Network) (a j : ℕ) : ℕ :=
  slotSize ((net.getD a []).getD j none)

/-- Evaluation of TS0 expressions.  `none` means the program went wrong (an
unbound identifier). -/
def evalT (net : Network) (env : TEnv) : TExp → Option Int
  | .lit n => some n
  | .var x => env.lookup x
  | .add a b =>
      match evalT net env a, evalT net env b with
      | some x, some y => some (x + y)
      | _, _ => none
  | .sub a b =>
      match evalT net env a, evalT net env b with
      | some x, some y => some (x - y)
      | _, _ => none
  | .mul a b =>
      match evalT net env a, evalT net env b with
      | some x, some y => some (x * y)
      | _, _ => none
  | .lt a b =>
      match evalT net env a, evalT net env b with
      | some x, some y => some (if x < y then 1 else 0)
      | _, _ => none
  | .ne a b =>
      match evalT net env a, evalT net env b with
      | some x, some y => some (if x = y then 0 else 1)
      | _, _ => none
  | .notE a =>
      match evalT net env a with
      | some x => some (if x = 0 then 1 else 0)
      | none => none
  | .andT a b =>
      match evalT net env a with
      | some x => if x = 0 then some 0 else evalT net env b
      | none => none
  | .orT a b =>
      match evalT net env a with
      | some x => if x = 0 then evalT net env b else some x
      | none => none
  | .size a b =>
      match evalT net env a, evalT net env b with
      | some x, some y => some (slotSizeAt net x.toNat y.toNat : ℕ)
      | _, _ => none

/-- One `pushItems` call: it fails (as the ComputerCraft call does) when the
two peripherals coincide or an index is out of range, and otherwise returns the
number of items moved together with the updated network. -/
def pushStep (limit : Item → ℕ) (net : Network) (a i b j req : ℕ) :
    Option (ℕ × Network) :=
  if a = b then none
  else if a < net.length ∧ b < net.length ∧ i < (net.getD a []).length ∧
      j < (net.getD b []).length then
    some (amountMoved limit (net.getD a []) i (net.getD b []) j req,
      netTransfer limit net a i b j req)
  else none

/-- Execution of TS0 statements with a bound on the number of loop iterations.
`none` means the program went wrong or ran out of iterations. -/
def execT (limit : Item → ℕ) : ℕ → TStmt → TState → Option TState
  | _, .skip, st => some st
  | f, .seq s1 s2, st => (execT limit f s1 st).bind (fun st' => execT limit f s2 st')
  | _, .letD x e, st =>
      (evalT st.net st.env e).map (fun v => { st with env := (x, v) :: st.env })
  | _, .assign x e, st =>
      (evalT st.net st.env e).map (fun v => { st with env := setVar st.env x v })
  | _, .incr x, st =>
      (st.env.lookup x).map (fun v => { st with env := setVar st.env x (v + 1) })
  | f, .ifElse c s1 s2, st =>
      match evalT st.net st.env c with
      | none => none
      | some v => if v = 0 then execT limit f s2 st else execT limit f s1 st
  | 0, .whileDo _ _, _ => none
  | f + 1, .whileDo c body, st =>
      match evalT st.net st.env c with
      | none => none
      | some v =>
          if v = 0 then some st
          else (execT limit f body st).bind (fun st' => execT limit f (.whileDo c body) st')
  | _, .push x es ed ei ej ea, st =>
      match evalT st.net st.env es, evalT st.net st.env ed, evalT st.net st.env ei,
          evalT st.net st.env ej, evalT st.net st.env ea with
      | some a, some b, some i, some j, some r =>
          match pushStep limit st.net a.toNat i.toNat b.toNat j.toNat r.toNat with
          | none => none
          | some (k, net') => some { env := (x, (k : Int)) :: st.env, net := net' }
      | _, _, _, _, _ => none
  termination_by f s => (f, sizeOf s)

/-! ## Target language: Lua0 -/

/-- Lua0 values: numbers, booleans and `nil`. -/
inductive LVal where
  /-- A number. -/
  | num (n : Int)
  /-- A boolean. -/
  | bool (b : Bool)
  /-- `nil`. -/
  | nil
deriving Repr, DecidableEq, Inhabited

/-- Lua truthiness: everything except `false` and `nil` is true — in
particular the number `0` is **true**. -/
def truthy : LVal → Bool
  | .bool b => b
  | .nil => false
  | .num _ => true

/-- Lua0 expressions. -/
inductive LExp where
  /-- Numeric literal. -/
  | num (n : Int)
  /-- Boolean literal. -/
  | bool (b : Bool)
  /-- Variable reference. -/
  | var (x : Name)
  /-- `a + b`. -/
  | add (a b : LExp)
  /-- `a - b`. -/
  | sub (a b : LExp)
  /-- `a * b`. -/
  | mul (a b : LExp)
  /-- `a < b`, a boolean. -/
  | lt (a b : LExp)
  /-- `a == b`, a boolean. -/
  | eq (a b : LExp)
  /-- `a ~= b`, a boolean. -/
  | ne (a b : LExp)
  /-- `a and b`: `a` if `a` is falsy, else `b`. -/
  | andE (a b : LExp)
  /-- `a or b`: `a` if `a` is truthy, else `b`. -/
  | orE (a b : LExp)
  /-- `getItemCount(a, b)`. -/
  | size (a b : LExp)
deriving Repr, DecidableEq, Inhabited

/-- Lua0 statements. -/
inductive LStmt where
  /-- The empty statement. -/
  | skip
  /-- Sequential composition. -/
  | seq (s1 s2 : LStmt)
  /-- `local x = e` — introduces a new binding. -/
  | localD (x : Name) (e : LExp)
  /-- `x = e` — updates an existing binding. -/
  | assign (x : Name) (e : LExp)
  /-- `if c then s1 else s2 end` -/
  | ifElse (c : LExp) (s1 s2 : LStmt)
  /-- `while c do body end` -/
  | whileDo (c : LExp) (body : LStmt)
  /-- `local x = pushItems(src, dst, i, j, amt)` -/
  | pushCall (x : Name) (src dst i j amt : LExp)
deriving Repr, Inhabited

/-- A Lua0 environment. -/
abbrev LEnv := List (Name × LVal)

/-- A Lua0 machine state. -/
structure LState where
  /-- Variable environment. -/
  env : LEnv
  /-- The inventory network the program manipulates. -/
  net : Network
deriving Repr

/-- Evaluation of Lua0 expressions.  `none` is a runtime error (an unbound
name used as a number, or arithmetic on a non-number). -/
def evalL (net : Network) (env : LEnv) : LExp → Option LVal
  | .num n => some (.num n)
  | .bool b => some (.bool b)
  | .var x => env.lookup x
  | .add a b =>
      match evalL net env a, evalL net env b with
      | some (.num x), some (.num y) => some (.num (x + y))
      | _, _ => none
  | .sub a b =>
      match evalL net env a, evalL net env b with
      | some (.num x), some (.num y) => some (.num (x - y))
      | _, _ => none
  | .mul a b =>
      match evalL net env a, evalL net env b with
      | some (.num x), some (.num y) => some (.num (x * y))
      | _, _ => none
  | .lt a b =>
      match evalL net env a, evalL net env b with
      | some (.num x), some (.num y) => some (.bool (decide (x < y)))
      | _, _ => none
  | .eq a b =>
      match evalL net env a, evalL net env b with
      | some x, some y => some (.bool (decide (x = y)))
      | _, _ => none
  | .ne a b =>
      match evalL net env a, evalL net env b with
      | some x, some y => some (.bool (decide (x ≠ y)))
      | _, _ => none
  | .andE a b =>
      match evalL net env a with
      | some x => if truthy x then evalL net env b else some x
      | none => none
  | .orE a b =>
      match evalL net env a with
      | some x => if truthy x then some x else evalL net env b
      | none => none
  | .size a b =>
      match evalL net env a, evalL net env b with
      | some (.num x), some (.num y) => some (.num (slotSizeAt net x.toNat y.toNat : ℕ))
      | _, _ => none

/-- Execution of Lua0 statements with a bound on the number of loop
iterations. -/
def execL (limit : Item → ℕ) : ℕ → LStmt → LState → Option LState
  | _, .skip, st => some st
  | f, .seq s1 s2, st => (execL limit f s1 st).bind (fun st' => execL limit f s2 st')
  | _, .localD x e, st =>
      (evalL st.net st.env e).map (fun v => { st with env := (x, v) :: st.env })
  | _, .assign x e, st =>
      (evalL st.net st.env e).map (fun v => { st with env := setVar st.env x v })
  | f, .ifElse c s1 s2, st =>
      match evalL st.net st.env c with
      | none => none
      | some v => if truthy v then execL limit f s1 st else execL limit f s2 st
  | 0, .whileDo _ _, _ => none
  | f + 1, .whileDo c body, st =>
      match evalL st.net st.env c with
      | none => none
      | some v =>
          if truthy v then
            (execL limit f body st).bind (fun st' => execL limit f (.whileDo c body) st')
          else some st
  | _, .pushCall x es ed ei ej ea, st =>
      match evalL st.net st.env es, evalL st.net st.env ed, evalL st.net st.env ei,
          evalL st.net st.env ej, evalL st.net st.env ea with
      | some (.num a), some (.num b), some (.num i), some (.num j), some (.num r) =>
          match pushStep limit st.net a.toNat i.toNat b.toNat j.toNat r.toNat with
          | none => none
          | some (k, net') => some { env := (x, .num (k : Int)) :: st.env, net := net' }
      | _, _, _, _, _ => none
  termination_by f s => (f, sizeOf s)

end CCLua
