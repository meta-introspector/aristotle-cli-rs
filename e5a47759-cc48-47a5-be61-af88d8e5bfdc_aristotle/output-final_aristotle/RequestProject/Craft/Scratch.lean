import RequestProject.Craft.CCLuaCompile

/-!
# A Scratch-style block language for the ComputerCraft hopper

This file adds the *front end* that the GUI of `scratch.html` manipulates: a
Scratch-like block language, with

* **reporters** (`Rep`) — the oval and hexagonal blocks: numbers, variables,
  arithmetic, comparisons, `and`/`or`/`not`, and "items in slot `s` of chest
  `p`";
* **stack blocks** (`Blk`) — `set`, `change ... by`, the effectful
  `move ... items from ... to ...`, `if`, `if/else`, `repeat n` and
  `repeat until`;
* a **shape checker** (`wfR`, `wfB`, `wfS`) that is exactly the constraint a
  Scratch editor enforces by the *geometry* of its blocks: a hexagonal
  (boolean) slot only accepts a hexagonal block, a round slot only a round
  one;
* a **direct semantics** (`evalR`, `runBlk`, `runScript`), in Scratch's own
  terms — comparisons report `1`/`0`, `and`/`or` are the logical connectives
  (they are *not* the operand-returning operators of TypeScript or Lua), and
  `repeat n` means "do the body `n` times";
* a **compiler** (`cR`, `cB`, `cScript`) into the TS0 language of
  `RequestProject.CCLuaCore`, which the verified TS0 → Lua0 compiler of
  `RequestProject.CCLuaCompile` then turns into ComputerCraft Lua.

The main theorem, `cScript_exec`, says the compiler preserves the meaning of
every *shape-correct* script, and `scratch_toLua_exec` chains it with
`toLua_exec` to reach Lua.  The shape hypothesis is not decoration:
`andB_not_wf_differs` exhibits a script the shape checker rejects on which the
block semantics and the compiled code disagree.

Because the emitted code is Lua0 code, the block language inherits the
guarantees of the transfer model: `scratch_conserves` (no script creates or
destroys an item) and `scratch_valid` (no script overfills a slot).
-/

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace ScratchCC

open Hopper CCLua

/-! ## Syntax -/

/-- The two block shapes a Scratch editor distinguishes: round (numeric)
reporters and hexagonal (boolean) reporters. -/
inductive Shape where
  /-- A round slot, holding a number. -/
  | numS
  /-- A hexagonal slot, holding a boolean. -/
  | boolS
deriving Repr, DecidableEq, Inhabited

/-- Reporter blocks: the ovals and hexagons that get dropped into slots. -/
inductive Rep where
  /-- A number typed into a slot. -/
  | numB (n : Int)
  /-- The variable reporter `(x)`. -/
  | varB (x : Name)
  /-- `(a) + (b)` -/
  | addB (a b : Rep)
  /-- `(a) - (b)` -/
  | subB (a b : Rep)
  /-- `(a) * (b)` -/
  | mulB (a b : Rep)
  /-- `items in slot (s) of chest (p)` -/
  | countB (p s : Rep)
  /-- `(a) < (b)` -/
  | ltB (a b : Rep)
  /-- `(a) > (b)` -/
  | gtB (a b : Rep)
  /-- `(a) = (b)` -/
  | eqB (a b : Rep)
  /-- `not <a>` -/
  | notB (a : Rep)
  /-- `<a> and <b>` -/
  | andB (a b : Rep)
  /-- `<a> or <b>` -/
  | orB (a b : Rep)
deriving Repr, DecidableEq, Inhabited

/-- Stack blocks: the puzzle-piece blocks that snap under one another. -/
inductive Blk where
  /-- `set x to (e)` -/
  | setVar (x : Name) (e : Rep)
  /-- `change x by (e)` -/
  | changeVar (x : Name) (e : Rep)
  /-- `move (amt) items from chest (src) slot (i) to chest (dst) slot (j)`,
  reporting the number actually moved into the variable `x`. -/
  | move (x : Name) (src i dst j amt : Rep)
  /-- `if <c> then ...` -/
  | ifB (c : Rep) (body : List Blk)
  /-- `if <c> then ... else ...` -/
  | ifElseB (c : Rep) (yes no : List Blk)
  /-- `repeat n ...`, with the count typed into the block. -/
  | repeatB (n : ℕ) (body : List Blk)
  /-- `repeat until <c> ...` -/
  | repeatUntilB (c : Rep) (body : List Blk)
deriving Repr, Inhabited

/-- A script is a stack of blocks. -/
abbrev Script := List Blk

/-! ### Size measures, used only for termination -/

mutual

/-- Size of a block. -/
def bsize : Blk → ℕ
  | .setVar _ _ => 1
  | .changeVar _ _ => 1
  | .move _ _ _ _ _ _ => 1
  | .ifB _ body => 1 + ssize body
  | .ifElseB _ t e => 1 + ssize t + ssize e
  | .repeatB n body => 1 + n + ssize body
  | .repeatUntilB _ body => 1 + ssize body

/-- Size of a script. -/
def ssize : Script → ℕ
  | [] => 0
  | b :: r => 1 + bsize b + ssize r

end

/-! ## The shape checker

This is the Scratch editor's geometry, as a decidable predicate: you cannot
drop a round block into a hexagonal hole, and you cannot drop a hexagonal
block into a round hole. -/

/-- `wfR r σ` says the reporter `r` has shape `σ`. -/
def wfR : Rep → Shape → Bool
  | .numB _, .numS => true
  | .varB _, .numS => true
  | .addB a b, .numS => wfR a .numS && wfR b .numS
  | .subB a b, .numS => wfR a .numS && wfR b .numS
  | .mulB a b, .numS => wfR a .numS && wfR b .numS
  | .countB p s, .numS => wfR p .numS && wfR s .numS
  | .ltB a b, .boolS => wfR a .numS && wfR b .numS
  | .gtB a b, .boolS => wfR a .numS && wfR b .numS
  | .eqB a b, .boolS => wfR a .numS && wfR b .numS
  | .notB a, .boolS => wfR a .boolS
  | .andB a b, .boolS => wfR a .boolS && wfR b .boolS
  | .orB a b, .boolS => wfR a .boolS && wfR b .boolS
  | _, _ => false

mutual

/-- A block is shape-correct when every slot holds a block of the slot's
shape. -/
def wfB : Blk → Bool
  | .setVar _ e => wfR e .numS
  | .changeVar _ e => wfR e .numS
  | .move _ src i dst j amt =>
      wfR src .numS && wfR i .numS && wfR dst .numS && wfR j .numS && wfR amt .numS
  | .ifB c body => wfR c .boolS && wfS body
  | .ifElseB c t e => wfR c .boolS && wfS t && wfS e
  | .repeatB _ body => wfS body
  | .repeatUntilB c body => wfR c .boolS && wfS body

/-- A script is shape-correct when all of its blocks are. -/
def wfS : Script → Bool
  | [] => true
  | b :: r => wfB b && wfS r

end

/-! ## Direct semantics of blocks

Written in Scratch's own terms, not by translation: comparisons report `1` for
true and `0` for false, `and`/`or`/`not` are the logical connectives, and
`repeat n` runs the body `n` times. -/

/-- Value of a reporter block.  `none` is "this block cannot report" — in
practice, a variable slot naming a variable that does not exist. -/
def evalR (net : Network) (env : TEnv) : Rep → Option Int
  | .numB n => some n
  | .varB x => env.lookup x
  | .addB a b =>
      match evalR net env a, evalR net env b with
      | some x, some y => some (x + y)
      | _, _ => none
  | .subB a b =>
      match evalR net env a, evalR net env b with
      | some x, some y => some (x - y)
      | _, _ => none
  | .mulB a b =>
      match evalR net env a, evalR net env b with
      | some x, some y => some (x * y)
      | _, _ => none
  | .countB p s =>
      match evalR net env p, evalR net env s with
      | some x, some y => some (slotSizeAt net x.toNat y.toNat : ℕ)
      | _, _ => none
  | .ltB a b =>
      match evalR net env a, evalR net env b with
      | some x, some y => some (if x < y then 1 else 0)
      | _, _ => none
  | .gtB a b =>
      match evalR net env a, evalR net env b with
      | some x, some y => some (if y < x then 1 else 0)
      | _, _ => none
  | .eqB a b =>
      match evalR net env a, evalR net env b with
      | some x, some y => some (if x = y then 1 else 0)
      | _, _ => none
  | .notB a =>
      match evalR net env a with
      | some x => some (if x = 0 then 1 else 0)
      | none => none
  | .andB a b =>
      match evalR net env a, evalR net env b with
      | some x, some y => some (if x ≠ 0 ∧ y ≠ 0 then 1 else 0)
      | _, _ => none
  | .orB a b =>
      match evalR net env a, evalR net env b with
      | some x, some y => some (if x ≠ 0 ∨ y ≠ 0 then 1 else 0)
      | _, _ => none

mutual

/-- Running one stack block.  `f` bounds the iterations of `repeat until`,
exactly as in `execT`. -/
def runBlk (limit : Item → ℕ) : ℕ → Blk → TState → Option TState
  | _, .setVar x e, st =>
      (evalR st.net st.env e).map (fun v => { st with env := setVar st.env x v })
  | _, .changeVar x e, st =>
      match st.env.lookup x, evalR st.net st.env e with
      | some w, some v => some { st with env := setVar st.env x (w + v) }
      | _, _ => none
  | _, .move x es ei ed ej ea, st =>
      match evalR st.net st.env es, evalR st.net st.env ed, evalR st.net st.env ei,
          evalR st.net st.env ej, evalR st.net st.env ea with
      | some a, some b, some i, some j, some r =>
          match pushStep limit st.net a.toNat i.toNat b.toNat j.toNat r.toNat with
          | none => none
          | some (k, net') => some { env := (x, (k : Int)) :: st.env, net := net' }
      | _, _, _, _, _ => none
  | f, .ifB c body, st =>
      match evalR st.net st.env c with
      | none => none
      | some v => if v = 0 then some st else runScript limit f body st
  | f, .ifElseB c t e, st =>
      match evalR st.net st.env c with
      | none => none
      | some v => if v = 0 then runScript limit f e st else runScript limit f t st
  | f, .repeatB n body, st => runTimes limit f n body st
  | 0, .repeatUntilB _ _, _ => none
  | f + 1, .repeatUntilB c body, st =>
      match evalR st.net st.env c with
      | none => none
      | some v =>
          if v = 0 then
            (runScript limit f body st).bind
              (fun st' => runBlk limit f (.repeatUntilB c body) st')
          else some st
  termination_by f b _ => (f, 2 * bsize b + 1)
  decreasing_by all_goals simp [bsize]; omega

/-- Running a stack of blocks, one after another. -/
def runScript (limit : Item → ℕ) : ℕ → Script → TState → Option TState
  | _, [], st => some st
  | f, b :: r, st => (runBlk limit f b st).bind (fun st' => runScript limit f r st')
  termination_by f s _ => (f, 2 * ssize s)
  decreasing_by all_goals simp [ssize]; omega

/-- Running a script `n` times in a row: the meaning of `repeat n`. -/
def runTimes (limit : Item → ℕ) : ℕ → ℕ → Script → TState → Option TState
  | _, 0, _, st => some st
  | f, n + 1, body, st =>
      (runScript limit f body st).bind (fun st' => runTimes limit f n body st')
  termination_by f n body _ => (f, 2 * ssize body + 2 * n + 1)
  decreasing_by all_goals omega

end

/-! ## The compiler into TS0 -/

/-- Compilation of reporter blocks.  `=` is `!(a !== b)`, `>` is a flipped
`<`, and `and`/`or` become TypeScript's `&&`/`||` — which agree with the
logical connectives only on `0`/`1`, which is what the shape checker
guarantees. -/
def cR : Rep → TExp
  | .numB n => .lit n
  | .varB x => .var x
  | .addB a b => .add (cR a) (cR b)
  | .subB a b => .sub (cR a) (cR b)
  | .mulB a b => .mul (cR a) (cR b)
  | .countB p s => .size (cR p) (cR s)
  | .ltB a b => .lt (cR a) (cR b)
  | .gtB a b => .lt (cR b) (cR a)
  | .eqB a b => .notE (.ne (cR a) (cR b))
  | .notB a => .notE (cR a)
  | .andB a b => .andT (cR a) (cR b)
  | .orB a b => .orT (cR a) (cR b)

/-- `n` copies of a statement, in sequence: how `repeat n` is compiled. -/
def unrollTS (body : TStmt) : ℕ → TStmt
  | 0 => .skip
  | n + 1 => .seq body (unrollTS body n)

mutual

/-- Compilation of one stack block. -/
def cB : Blk → TStmt
  | .setVar x e => .assign x (cR e)
  | .changeVar x e => .assign x (.add (.var x) (cR e))
  | .move x src i dst j amt => .push x (cR src) (cR dst) (cR i) (cR j) (cR amt)
  | .ifB c body => .ifElse (cR c) (cScript body) .skip
  | .ifElseB c t e => .ifElse (cR c) (cScript t) (cScript e)
  | .repeatB n body => unrollTS (cScript body) n
  | .repeatUntilB c body => .whileDo (.notE (cR c)) (cScript body)

/-- Compilation of a stack of blocks. -/
def cScript : Script → TStmt
  | [] => .skip
  | b :: r => .seq (cB b) (cScript r)

end

/-! ## Correctness of reporter compilation -/

/-- A hexagonal (boolean) reporter really does report `0` or `1`. -/
theorem evalR_bool (net : Network) (env : TEnv) :
    ∀ (r : Rep) (v : Int), wfR r .boolS = true → evalR net env r = some v →
      v = 0 ∨ v = 1 := by
  intro r v hw hv
  cases r with
  | numB n => simp [wfR] at hw
  | varB x => simp [wfR] at hw
  | addB a b => simp [wfR] at hw
  | subB a b => simp [wfR] at hw
  | mulB a b => simp [wfR] at hw
  | countB p s => simp [wfR] at hw
  | ltB a b =>
      simp only [evalR] at hv
      split at hv <;> simp_all
      all_goals (split at hv <;> simp_all)
  | gtB a b =>
      simp only [evalR] at hv
      split at hv <;> simp_all
      all_goals (split at hv <;> simp_all)
  | eqB a b =>
      simp only [evalR] at hv
      split at hv <;> simp_all
      all_goals (split at hv <;> simp_all)
  | notB a =>
      simp only [evalR] at hv
      split at hv <;> simp_all
      all_goals (split at hv <;> simp_all)
  | andB a b =>
      simp only [evalR] at hv
      split at hv <;> simp_all
      all_goals (split at hv <;> simp_all)
  | orB a b =>
      simp only [evalR] at hv
      split at hv <;> simp_all
      all_goals (split at hv <;> simp_all)

/-- On the round (numeric) fragment the compiler changes nothing at all: the
block and the TypeScript it compiles to have the very same value, including
when neither reports. -/
theorem cR_eval_num (net : Network) (env : TEnv) :
    ∀ r : Rep, wfR r .numS = true → evalT net env (cR r) = evalR net env r := by
  intro r
  induction r with
  | numB n => intro _; rfl
  | varB x => intro _; rfl
  | addB a b iha ihb =>
      intro hw
      simp only [wfR, Bool.and_eq_true] at hw
      cases ha : evalR net env a <;> cases hb : evalR net env b <;>
        simp [cR, evalT, evalR, iha hw.1, ihb hw.2, ha, hb]
  | subB a b iha ihb =>
      intro hw
      simp only [wfR, Bool.and_eq_true] at hw
      cases ha : evalR net env a <;> cases hb : evalR net env b <;>
        simp [cR, evalT, evalR, iha hw.1, ihb hw.2, ha, hb]
  | mulB a b iha ihb =>
      intro hw
      simp only [wfR, Bool.and_eq_true] at hw
      cases ha : evalR net env a <;> cases hb : evalR net env b <;>
        simp [cR, evalT, evalR, iha hw.1, ihb hw.2, ha, hb]
  | countB p s ihp ihs =>
      intro hw
      simp only [wfR, Bool.and_eq_true] at hw
      cases ha : evalR net env p <;> cases hb : evalR net env s <;>
        simp [cR, evalT, evalR, ihp hw.1, ihs hw.2, ha, hb]
  | ltB a b _ _ => intro hw; simp [wfR] at hw
  | gtB a b _ _ => intro hw; simp [wfR] at hw
  | eqB a b _ _ => intro hw; simp [wfR] at hw
  | notB a _ => intro hw; simp [wfR] at hw
  | andB a b _ _ => intro hw; simp [wfR] at hw
  | orB a b _ _ => intro hw; simp [wfR] at hw

/-- **Reporter compilation is correct.**  A shape-correct reporter that
reports `v` compiles to a TS0 expression that evaluates to `v`. -/
theorem cR_eval (net : Network) (env : TEnv) :
    ∀ (r : Rep) (σ : Shape) (v : Int), wfR r σ = true → evalR net env r = some v →
      evalT net env (cR r) = some v := by
  intro r
  induction r with
  | numB n =>
      intro σ v hw hv
      cases σ
      · rw [cR_eval_num net env _ hw]; exact hv
      · simp [wfR] at hw
  | varB x =>
      intro σ v hw hv
      cases σ
      · rw [cR_eval_num net env _ hw]; exact hv
      · simp [wfR] at hw
  | addB a b _ _ =>
      intro σ v hw hv
      cases σ
      · rw [cR_eval_num net env _ hw]; exact hv
      · simp [wfR] at hw
  | subB a b _ _ =>
      intro σ v hw hv
      cases σ
      · rw [cR_eval_num net env _ hw]; exact hv
      · simp [wfR] at hw
  | mulB a b _ _ =>
      intro σ v hw hv
      cases σ
      · rw [cR_eval_num net env _ hw]; exact hv
      · simp [wfR] at hw
  | countB p s _ _ =>
      intro σ v hw hv
      cases σ
      · rw [cR_eval_num net env _ hw]; exact hv
      · simp [wfR] at hw
  | ltB a b _ _ =>
      intro σ v hw hv
      cases σ
      · simp [wfR] at hw
      · simp only [wfR, Bool.and_eq_true] at hw
        simp only [evalR, ← cR_eval_num net env a hw.1, ← cR_eval_num net env b hw.2] at hv
        simp only [cR, evalT]
        cases ha : evalT net env (cR a) <;> cases hb : evalT net env (cR b) <;>
          rw [ha, hb] at hv <;> simp_all
  | gtB a b _ _ =>
      intro σ v hw hv
      cases σ
      · simp [wfR] at hw
      · simp only [wfR, Bool.and_eq_true] at hw
        simp only [evalR, ← cR_eval_num net env a hw.1, ← cR_eval_num net env b hw.2] at hv
        simp only [cR, evalT]
        cases ha : evalT net env (cR a) <;> cases hb : evalT net env (cR b) <;>
          rw [ha, hb] at hv <;> simp_all
  | eqB a b _ _ =>
      intro σ v hw hv
      cases σ
      · simp [wfR] at hw
      · simp only [wfR, Bool.and_eq_true] at hw
        simp only [evalR, ← cR_eval_num net env a hw.1, ← cR_eval_num net env b hw.2] at hv
        simp only [cR, evalT]
        cases ha : evalT net env (cR a) <;> cases hb : evalT net env (cR b) <;>
          rw [ha, hb] at hv <;> simp_all
  | notB a iha =>
      intro σ v hw hv
      cases σ
      · simp [wfR] at hw
      · simp only [wfR] at hw
        simp only [evalR] at hv
        cases ha : evalR net env a with
        | none => rw [ha] at hv; simp at hv
        | some x =>
            rw [ha] at hv
            simp only [Option.some.injEq] at hv
            simp [cR, evalT, iha .boolS x hw ha, ← hv]
  | andB a b iha ihb =>
      intro σ v hw hv
      cases σ
      · simp [wfR] at hw
      · simp only [wfR, Bool.and_eq_true] at hw
        simp only [evalR] at hv
        cases ha : evalR net env a with
        | none => rw [ha] at hv; simp at hv
        | some x =>
            cases hb : evalR net env b with
            | none => rw [ha, hb] at hv; simp at hv
            | some y =>
                rw [ha, hb] at hv
                simp only [Option.some.injEq] at hv
                have hx := evalR_bool net env a x hw.1 ha
                have hy := evalR_bool net env b y hw.2 hb
                simp only [cR, evalT, iha .boolS x hw.1 ha, ihb .boolS y hw.2 hb]
                rcases hx with rfl | rfl <;> rcases hy with rfl | rfl <;> simp_all
  | orB a b iha ihb =>
      intro σ v hw hv
      cases σ
      · simp [wfR] at hw
      · simp only [wfR, Bool.and_eq_true] at hw
        simp only [evalR] at hv
        cases ha : evalR net env a with
        | none => rw [ha] at hv; simp at hv
        | some x =>
            cases hb : evalR net env b with
            | none => rw [ha, hb] at hv; simp at hv
            | some y =>
                rw [ha, hb] at hv
                simp only [Option.some.injEq] at hv
                have hx := evalR_bool net env a x hw.1 ha
                have hy := evalR_bool net env b y hw.2 hb
                simp only [cR, evalT, iha .boolS x hw.1 ha, ihb .boolS y hw.2 hb]
                rcases hx with rfl | rfl <;> rcases hy with rfl | rfl <;> simp_all

/-! ## Correctness of script compilation -/

mutual

/-- Correctness of the compilation of one stack block. -/
theorem cB_exec (limit : Item → ℕ) (f : ℕ) (b : Blk) :
    ∀ st st' : TState, wfB b = true →
      runBlk limit f b st = some st' → execT limit f (cB b) st = some st' := by
  intro st st' hw h
  match b with
  | .setVar x e =>
      simp only [wfB] at hw
      simp only [runBlk] at h
      cases he : evalR st.net st.env e with
      | none => rw [he] at h; simp at h
      | some v =>
          rw [he] at h
          simp only [Option.map_some, Option.some.injEq] at h
          simp [cB, execT, cR_eval st.net st.env e .numS v hw he, ← h]
  | .changeVar x e =>
      simp only [wfB] at hw
      simp only [runBlk] at h
      cases hx : st.env.lookup x with
      | none => rw [hx] at h; simp at h
      | some w =>
          cases he : evalR st.net st.env e with
          | none => rw [hx, he] at h; simp at h
          | some v =>
              rw [hx, he] at h
              simp only [Option.some.injEq] at h
              simp [cB, execT, evalT, hx, cR_eval st.net st.env e .numS v hw he, ← h]
  | .move x es ei ed ej ea =>
      simp only [wfB, Bool.and_eq_true] at hw
      obtain ⟨⟨⟨⟨h1, h2⟩, h3⟩, h4⟩, h5⟩ := hw
      simp only [runBlk] at h
      cases hs : evalR st.net st.env es with
      | none => rw [hs] at h; simp at h
      | some a =>
      cases hd : evalR st.net st.env ed with
      | none => rw [hs, hd] at h; simp at h
      | some bb =>
      cases hi : evalR st.net st.env ei with
      | none => rw [hs, hd, hi] at h; simp at h
      | some i =>
      cases hj : evalR st.net st.env ej with
      | none => rw [hs, hd, hi, hj] at h; simp at h
      | some j =>
      cases haa : evalR st.net st.env ea with
      | none => rw [hs, hd, hi, hj, haa] at h; simp at h
      | some r =>
          rw [hs, hd, hi, hj, haa] at h
          simp only [cB, execT,
            cR_eval st.net st.env es .numS a h1 hs,
            cR_eval st.net st.env ed .numS bb h3 hd,
            cR_eval st.net st.env ei .numS i h2 hi,
            cR_eval st.net st.env ej .numS j h4 hj,
            cR_eval st.net st.env ea .numS r h5 haa]
          exact h
  | .ifB c body =>
      simp only [wfB, Bool.and_eq_true] at hw
      simp only [runBlk] at h
      cases hc : evalR st.net st.env c with
      | none => rw [hc] at h; simp at h
      | some v =>
          rw [hc] at h
          simp only [cB, execT, cR_eval st.net st.env c .boolS v hw.1 hc]
          by_cases hv : v = 0
          · subst hv
            simpa [execT] using h
          · simp only [if_neg hv] at h ⊢
            exact cScript_exec limit f body st st' hw.2 h
  | .ifElseB c t e =>
      simp only [wfB, Bool.and_eq_true] at hw
      simp only [runBlk] at h
      cases hc : evalR st.net st.env c with
      | none => rw [hc] at h; simp at h
      | some v =>
          rw [hc] at h
          simp only [cB, execT, cR_eval st.net st.env c .boolS v hw.1.1 hc]
          by_cases hv : v = 0
          · subst hv
            simp only [reduceIte] at h ⊢
            exact cScript_exec limit f e st st' hw.2 h
          · simp only [if_neg hv] at h ⊢
            exact cScript_exec limit f t st st' hw.1.2 h
  | .repeatB n body =>
      simp only [wfB] at hw
      simp only [runBlk] at h
      exact cTimes_exec limit f n body st st' hw h
  | .repeatUntilB c body =>
      simp only [wfB, Bool.and_eq_true] at hw
      match f with
      | 0 => simp [runBlk] at h
      | f + 1 =>
          simp only [runBlk] at h
          cases hc : evalR st.net st.env c with
          | none => rw [hc] at h; simp at h
          | some v =>
              rw [hc] at h
              simp only [cB, execT, evalT, cR_eval st.net st.env c .boolS v hw.1 hc]
              by_cases hv : v = 0
              · subst hv
                simp only [reduceIte] at h
                simp only [reduceIte]
                cases hb : runScript limit f body st with
                | none => rw [hb] at h; simp at h
                | some stm =>
                    rw [hb] at h
                    simp only [Option.bind_some] at h
                    rw [cScript_exec limit f body st stm hw.2 hb]
                    simp only [Option.bind_some]
                    have := cB_exec limit f (.repeatUntilB c body) stm st'
                      (by simp [wfB, hw]) h
                    simpa only [cB] using this
              · simp only [if_neg hv] at h
                simp only [if_neg hv, reduceIte]
                simpa using h
  termination_by (f, 2 * bsize b + 1)
  decreasing_by all_goals simp [bsize]; omega

/-- **Block compilation is correct.**  A shape-correct script that runs to a
state runs to the same state after compilation to TS0. -/
theorem cScript_exec (limit : Item → ℕ) (f : ℕ) (s : Script) :
    ∀ st st' : TState, wfS s = true →
      runScript limit f s st = some st' → execT limit f (cScript s) st = some st' := by
  intro st st' hw h
  match s with
  | [] =>
      simp only [runScript, Option.some.injEq] at h
      simp [cScript, execT, h]
  | b :: r =>
      simp only [wfS, Bool.and_eq_true] at hw
      simp only [runScript] at h
      cases hb : runBlk limit f b st with
      | none => rw [hb] at h; simp at h
      | some stm =>
          rw [hb] at h
          simp only [Option.bind_some] at h
          simp only [cScript, execT, cB_exec limit f b st stm hw.1 hb, Option.bind_some]
          exact cScript_exec limit f r stm st' hw.2 h
  termination_by (f, 2 * ssize s)
  decreasing_by all_goals simp [ssize]; omega

/-- Correctness of the compilation of `repeat n`: the unrolled code does the
body `n` times. -/
theorem cTimes_exec (limit : Item → ℕ) (f n : ℕ) (body : Script) :
    ∀ st st' : TState, wfS body = true →
      runTimes limit f n body st = some st' →
        execT limit f (unrollTS (cScript body) n) st = some st' := by
  intro st st' hw h
  match n with
  | 0 =>
      simp only [runTimes, Option.some.injEq] at h
      simp [unrollTS, execT, h]
  | n + 1 =>
      simp only [runTimes] at h
      cases hb : runScript limit f body st with
      | none => rw [hb] at h; simp at h
      | some stm =>
          rw [hb] at h
          simp only [Option.bind_some] at h
          simp only [unrollTS, execT, cScript_exec limit f body st stm hw hb,
            Option.bind_some]
          exact cTimes_exec limit f n body stm st' hw h
  termination_by (f, 2 * ssize body + 2 * n + 1)
  decreasing_by all_goals omega

end

/-- **Blocks to Lua.**  Chaining `cScript_exec` with the verified TS0 → Lua0
compiler: the Lua a shape-correct script compiles to computes exactly what the
blocks say. -/
theorem scratch_toLua_exec (limit : Item → ℕ) (f : ℕ) (s : Script) (st st' : TState)
    (hw : wfS s = true) (h : runScript limit f s st = some st') :
    execL limit f (cS (cScript s)) (toLState st) = some (toLState st') :=
  toLua_exec limit f (cScript s) st st' (cScript_exec limit f s st st' hw h)

/-- **Conservation.**  No script built out of these blocks can create or
destroy an item. -/
theorem scratch_conserves (limit : Item → ℕ) (f : ℕ) (s : Script) (st st' : TState)
    (hw : wfS s = true) (h : runScript limit f s st = some st') (it : Item) :
    netCount st'.net it = netCount st.net it :=
  execL_conserves limit f (cS (cScript s)) (toLState st) (toLState st')
    (scratch_toLua_exec limit f s st st' hw h) it

/-- **Safety.**  No script built out of these blocks can fill a slot past the
stack limit of its item. -/
theorem scratch_valid (limit : Item → ℕ) (f : ℕ) (s : Script) (st st' : TState)
    (hw : wfS s = true) (h : runScript limit f s st = some st')
    (hv : NetValid limit st.net) : NetValid limit st'.net :=
  execL_valid limit f (cS (cScript s)) (toLState st) (toLState st')
    (scratch_toLua_exec limit f s st st' hw h) hv

/-! ## The shape checker is load-bearing -/

/-- Without the shape check the compiler would be *wrong*: `<2> and <3>` is not
a legal Scratch condition, and on it the block semantics (which reports `1`)
and the compiled TypeScript (`2 && 3`, which is `3`) disagree. -/
theorem andB_not_wf_differs :
    wfR (.andB (.numB 2) (.numB 3)) .boolS = false ∧
    evalR [] [] (.andB (.numB 2) (.numB 3)) = some 1 ∧
    evalT [] [] (cR (.andB (.numB 2) (.numB 3))) = some 3 := by
  refine ⟨by decide, by decide, by decide⟩

end ScratchCC
