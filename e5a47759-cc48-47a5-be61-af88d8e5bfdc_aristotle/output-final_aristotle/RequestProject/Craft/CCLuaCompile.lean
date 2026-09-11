import RequestProject.Craft.CCLuaCore

/-!
# The TS0 → Lua0 compiler and its correctness proof

The translation is the one a TypeScript-to-Lua toolchain has to perform:

* a TS0 condition `c` is *not* a Lua condition, because `0` is truthy in Lua,
  so it is emitted as `c ~= 0`;
* a TS0 comparison has to become a number, and Lua has no conditional
  expression, so it is emitted with the standard `cond and 1 or 0` idiom;
* TS0's `&&` and `||` return an operand and use TypeScript truthiness, while
  Lua's `and`/`or` return an operand and use Lua truthiness, so they are
  emitted as `(a ~= 0) and b or 0` and `(a ~= 0) and a or b`;
* `x++` becomes `x = x + 1`.

`toLua_eval` and `toLua_exec` say that the emitted Lua0 program computes what
the TS0 program computes, on the same inventory network.
-/

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace CCLua

open Hopper

/-! ## The translation -/

/-- Compilation of TS0 expressions to Lua0 expressions. -/
def cE : TExp → LExp
  | .lit n => .num n
  | .var x => .var x
  | .add a b => .add (cE a) (cE b)
  | .sub a b => .sub (cE a) (cE b)
  | .mul a b => .mul (cE a) (cE b)
  | .lt a b => .orE (.andE (.lt (cE a) (cE b)) (.num 1)) (.num 0)
  | .ne a b => .orE (.andE (.ne (cE a) (cE b)) (.num 1)) (.num 0)
  | .notE a => .orE (.andE (.eq (cE a) (.num 0)) (.num 1)) (.num 0)
  | .andT a b => .orE (.andE (.ne (cE a) (.num 0)) (cE b)) (.num 0)
  | .orT a b => .orE (.andE (.ne (cE a) (.num 0)) (cE a)) (cE b)
  | .size a b => .size (cE a) (cE b)

/-- Compilation of TS0 statements to Lua0 statements. -/
def cS : TStmt → LStmt
  | .skip => .skip
  | .seq s1 s2 => .seq (cS s1) (cS s2)
  | .letD x e => .localD x (cE e)
  | .assign x e => .assign x (cE e)
  | .incr x => .assign x (.add (.var x) (.num 1))
  | .ifElse c s1 s2 => .ifElse (.ne (cE c) (.num 0)) (cS s1) (cS s2)
  | .whileDo c body => .whileDo (.ne (cE c) (.num 0)) (cS body)
  | .push x es ed ei ej ea => .pushCall x (cE es) (cE ed) (cE ei) (cE ej) (cE ea)

/-- The Lua0 environment corresponding to a TS0 environment. -/
def toLEnv (env : TEnv) : LEnv := env.map (fun p => (p.1, LVal.num p.2))

/-- The Lua0 state corresponding to a TS0 state. -/
def toLState (st : TState) : LState := { env := toLEnv st.env, net := st.net }

/-! ## Environment lemmas -/

theorem lookup_toLEnv (env : TEnv) (x : Name) :
    (toLEnv env).lookup x = (env.lookup x).map LVal.num := by
  induction env with
  | nil => rfl
  | cons p rest ih =>
      obtain ⟨y, v⟩ := p
      simp only [toLEnv, List.map_cons, List.lookup]
      cases hxy : (x == y) with
      | true => simp
      | false => simpa [toLEnv] using ih

theorem setVar_toLEnv (env : TEnv) (x : Name) (v : Int) :
    setVar (toLEnv env) x (LVal.num v) = toLEnv (setVar env x v) := by
  induction env with
  | nil => rfl
  | cons p rest ih =>
      obtain ⟨y, w⟩ := p
      by_cases h : y = x
      · simp [toLEnv, setVar, h]
      · simp only [toLEnv, List.map_cons, setVar, h, if_false]
        simpa [toLEnv] using ih

/-! ## Correctness of expression compilation -/

/-- **Expression correctness.**  If a TS0 expression evaluates to `n`, the
compiled Lua0 expression evaluates to the Lua number `n`. -/
theorem toLua_eval (net : Network) (env : TEnv) :
    ∀ (e : TExp) (n : Int), evalT net env e = some n →
      evalL net (toLEnv env) (cE e) = some (.num n) := by
  intro e
  induction e with
  | lit m => intro n h; simpa [evalT, cE, evalL] using h
  | var x =>
      intro n h
      simp [evalT] at h
      simp [cE, evalL, lookup_toLEnv, h]
  | add a b iha ihb =>
      intro n h
      simp only [evalT] at h
      cases ha : evalT net env a with
      | none => simp [ha] at h
      | some x =>
        cases hb : evalT net env b with
        | none => simp [ha, hb] at h
        | some y =>
          simp [ha, hb] at h
          simp [cE, evalL, iha x ha, ihb y hb, ← h]
  | sub a b iha ihb =>
      intro n h
      simp only [evalT] at h
      cases ha : evalT net env a with
      | none => simp [ha] at h
      | some x =>
        cases hb : evalT net env b with
        | none => simp [ha, hb] at h
        | some y =>
          simp [ha, hb] at h
          simp [cE, evalL, iha x ha, ihb y hb, ← h]
  | mul a b iha ihb =>
      intro n h
      simp only [evalT] at h
      cases ha : evalT net env a with
      | none => simp [ha] at h
      | some x =>
        cases hb : evalT net env b with
        | none => simp [ha, hb] at h
        | some y =>
          simp [ha, hb] at h
          simp [cE, evalL, iha x ha, ihb y hb, ← h]
  | lt a b iha ihb =>
      intro n h
      simp only [evalT] at h
      cases ha : evalT net env a with
      | none => simp [ha] at h
      | some x =>
        cases hb : evalT net env b with
        | none => simp [ha, hb] at h
        | some y =>
          simp [ha, hb] at h
          by_cases hxy : x < y
          · simp [cE, evalL, iha x ha, ihb y hb, hxy, truthy, ← h]
          · simp [cE, evalL, iha x ha, ihb y hb, hxy, truthy, ← h]
  | ne a b iha ihb =>
      intro n h
      simp only [evalT] at h
      cases ha : evalT net env a with
      | none => simp [ha] at h
      | some x =>
        cases hb : evalT net env b with
        | none => simp [ha, hb] at h
        | some y =>
          simp [ha, hb] at h
          by_cases hxy : x = y
          · simp [cE, evalL, iha x ha, ihb y hb, hxy, truthy, ← h]
          · simp [cE, evalL, iha x ha, ihb y hb, hxy, truthy, ← h]
  | notE a iha =>
      intro n h
      simp only [evalT] at h
      cases ha : evalT net env a with
      | none => simp [ha] at h
      | some x =>
        simp [ha] at h
        by_cases hx : x = 0
        · simp [cE, evalL, iha x ha, hx, truthy, ← h]
        · simp [cE, evalL, iha x ha, hx, truthy, ← h]
  | andT a b iha ihb =>
      intro n h
      simp only [evalT] at h
      cases ha : evalT net env a with
      | none => simp [ha] at h
      | some x =>
        simp [ha] at h
        by_cases hx : x = 0
        · simp [hx] at h
          simp [cE, evalL, iha x ha, hx, truthy, ← h]
        · simp [hx] at h
          simp [cE, evalL, iha x ha, hx, truthy, ihb n h]
  | orT a b iha ihb =>
      intro n h
      simp only [evalT] at h
      cases ha : evalT net env a with
      | none => simp [ha] at h
      | some x =>
        simp [ha] at h
        by_cases hx : x = 0
        · simp [hx] at h
          simp [cE, evalL, iha x ha, hx, truthy, ihb n h]
        · simp [hx] at h
          simp [cE, evalL, iha x ha, hx, truthy, ← h]
  | size a b iha ihb =>
      intro n h
      simp only [evalT] at h
      cases ha : evalT net env a with
      | none => simp [ha] at h
      | some x =>
        cases hb : evalT net env b with
        | none => simp [ha, hb] at h
        | some y =>
          simp [ha, hb] at h
          simp [cE, evalL, iha x ha, ihb y hb, ← h]

/-- The compiled form of a TS0 condition is truthy in Lua exactly when the TS0
condition is nonzero — the point of the `~= 0` that the compiler inserts. -/
theorem toLua_cond (net : Network) (env : TEnv) (c : TExp) (v : Int)
    (h : evalT net env c = some v) :
    evalL net (toLEnv env) (.ne (cE c) (.num 0)) = some (.bool (decide (v ≠ 0))) := by
  simp [evalL, toLua_eval net env c v h]

/-! ## Correctness of statement compilation -/

/-- **Compiler correctness.**  Whenever the TS0 program runs successfully, the
compiled Lua0 program runs successfully with the same iteration bound, and
produces the corresponding environment and the same inventory network. -/
theorem toLua_exec (limit : Item → ℕ) (f : ℕ) (s : TStmt) (st : TState) :
    ∀ st' : TState, execT limit f s st = some st' →
      execL limit f (cS s) (toLState st) = some (toLState st') := by
  induction f, s, st using execT.induct (limit := limit) with
  | case1 f st =>
      intro st' h
      simp only [execT, Option.some.injEq] at h
      subst h
      simp [cS, execL]
  | case2 f s1 s2 st ih1 ih2 =>
      intro st' h
      simp only [execT] at h
      cases h1 : execT limit f s1 st with
      | none => rw [h1] at h; simp at h
      | some stm =>
          rw [h1] at h
          simp only [Option.bind_some] at h
          simp only [cS, execL, ih1 stm h1, Option.bind_some]
          exact ih2 stm st' h
  | case3 f x e st =>
      intro st' h
      simp only [execT] at h
      cases he : evalT st.net st.env e with
      | none => rw [he] at h; simp at h
      | some v =>
          rw [he] at h
          simp only [Option.map_some, Option.some.injEq] at h
          subst h
          simp only [cS, execL, toLState, toLua_eval st.net st.env e v he,
            Option.map_some]
          simp [toLEnv]
  | case4 f x e st =>
      intro st' h
      simp only [execT] at h
      cases he : evalT st.net st.env e with
      | none => rw [he] at h; simp at h
      | some v =>
          rw [he] at h
          simp only [Option.map_some, Option.some.injEq] at h
          subst h
          simp [cS, execL, toLState, toLua_eval st.net st.env e v he, setVar_toLEnv]
  | case5 f x st =>
      intro st' h
      simp only [execT] at h
      cases he : st.env.lookup x with
      | none => rw [he] at h; simp at h
      | some v =>
          rw [he] at h
          simp only [Option.map_some, Option.some.injEq] at h
          subst h
          simp [cS, execL, toLState, evalL, lookup_toLEnv, he, setVar_toLEnv]
  | case6 f c s1 s2 st hc =>
      intro st' h
      simp [execT, hc] at h
  | case7 f c s1 s2 st hc ih =>
      intro st' h
      simp only [execT, hc] at h
      simp only [cS, execL, toLState, toLua_cond st.net st.env c 0 hc, truthy,
        ne_eq, not_true_eq_false, decide_false]
      exact ih st' h
  | case8 f c s1 s2 st v hc hv ih =>
      intro st' h
      simp only [execT, hc, if_neg hv] at h
      simp only [cS, execL, toLState, toLua_cond st.net st.env c v hc, truthy,
        ne_eq, hv, not_false_eq_true, decide_true, if_true]
      exact ih st' h
  | case9 c body st =>
      intro st' h
      simp [execT] at h
  | case10 f c body st hc =>
      intro st' h
      simp [execT, hc] at h
  | case11 f c body st hc =>
      intro st' h
      simp only [execT, hc, if_true, Option.some.injEq] at h
      subst h
      simp [cS, execL, toLState, toLua_cond st.net st.env c 0 hc, truthy]
  | case12 f c body st v hc hv ihbody ihrest =>
      intro st' h
      simp only [execT, hc, if_neg hv] at h
      cases hb : execT limit f body st with
      | none => rw [hb] at h; simp at h
      | some stm =>
          rw [hb] at h
          simp only [Option.bind_some] at h
          have hcond := toLua_cond st.net st.env c v hc
          simp only [cS, execL, toLState, hcond, truthy, ne_eq, hv,
            not_false_eq_true, decide_true, if_true]
          have hbody := ihbody stm hb
          simp only [toLState] at hbody
          rw [hbody]
          simpa only [cS, toLState] using ihrest stm st' h
  | case13 f x es ed ei ej ea st a b i j r h5 h4 h3 h2 h1 hp =>
      intro st' h
      simp [execT, h1, h2, h3, h4, h5, hp] at h
  | case14 f x es ed ei ej ea st a b i j r h5 h4 h3 h2 h1 k net' hp =>
      intro st' h
      simp only [execT, h1, h2, h3, h4, h5, hp, Option.some.injEq] at h
      subst h
      simp only [cS, execL, toLState, hp,
        toLua_eval st.net st.env es a h1, toLua_eval st.net st.env ed b h2,
        toLua_eval st.net st.env ei i h3, toLua_eval st.net st.env ej j h4,
        toLua_eval st.net st.env ea r h5]
      simp [toLEnv]
  | case15 f x es ed ei ej ea st hno =>
      intro st' h
      simp [execT] at h

/-! ## Consequences for the compiled code

The compiled program inherits the guarantees of the transfer model of
`RequestProject.Main`: it never creates or destroys an item, and it never
overfills a slot. -/

/-- A successful `pushItems` call is one network transfer step between two
distinct, in-range peripherals. -/
theorem pushStep_eq (limit : Item → ℕ) (net : Network) (a i b j r k : ℕ)
    (net' : Network) (h : pushStep limit net a i b j r = some (k, net')) :
    a ≠ b ∧ a < net.length ∧ b < net.length ∧ i < (net.getD a []).length ∧
      j < (net.getD b []).length ∧ net' = netTransfer limit net a i b j r := by
  unfold pushStep at h
  split at h
  · exact absurd h (by simp)
  · rename_i hab
    split at h
    · rename_i hbounds
      simp only [Option.some.injEq, Prod.mk.injEq] at h
      exact ⟨hab, hbounds.1, hbounds.2.1, hbounds.2.2.1, hbounds.2.2.2, h.2.symm⟩
    · exact absurd h (by simp)

/-- Any relation between networks that is reflexive, transitive and preserved
by a single `pushItems` call is preserved by running a whole Lua0 program. -/
theorem execL_net_rel (limit : Item → ℕ) (R : Network → Network → Prop)
    (hrefl : ∀ n, R n n) (htrans : ∀ n1 n2 n3, R n1 n2 → R n2 n3 → R n1 n3)
    (hpush : ∀ net a i b j r k net', pushStep limit net a i b j r = some (k, net') →
      R net net') :
    ∀ (f : ℕ) (s : LStmt) (st st' : LState), execL limit f s st = some st' →
      R st.net st'.net := by
  intro f s st
  induction f, s, st using execL.induct (limit := limit) with
  | case1 f st =>
      intro st' h
      simp only [execL, Option.some.injEq] at h
      subst h; exact hrefl _
  | case2 f s1 s2 st ih1 ih2 =>
      intro st' h
      simp only [execL] at h
      cases h1 : execL limit f s1 st with
      | none => rw [h1] at h; simp at h
      | some stm =>
          rw [h1] at h
          simp only [Option.bind_some] at h
          exact htrans _ _ _ (ih1 stm h1) (ih2 stm st' h)
  | case3 f x e st =>
      intro st' h
      simp only [execL] at h
      cases he : evalL st.net st.env e with
      | none => rw [he] at h; simp at h
      | some v =>
          rw [he] at h
          simp only [Option.map_some, Option.some.injEq] at h
          subst h; exact hrefl _
  | case4 f x e st =>
      intro st' h
      simp only [execL] at h
      cases he : evalL st.net st.env e with
      | none => rw [he] at h; simp at h
      | some v =>
          rw [he] at h
          simp only [Option.map_some, Option.some.injEq] at h
          subst h; exact hrefl _
  | case5 f c s1 s2 st hc => intro st' h; simp [execL, hc] at h
  | case6 f c s1 s2 st v hc hv ih =>
      intro st' h
      simp only [execL, hc, hv, if_true] at h
      exact ih st' h
  | case7 f c s1 s2 st v hc hv ih =>
      intro st' h
      simp only [execL, hc, if_neg hv] at h
      exact ih st' h
  | case8 c body st => intro st' h; simp [execL] at h
  | case9 f c body st hc => intro st' h; simp [execL, hc] at h
  | case10 f c body st v hc hv ihbody ihrest =>
      intro st' h
      simp only [execL, hc, hv, if_true] at h
      cases hb : execL limit f body st with
      | none => rw [hb] at h; simp at h
      | some stm =>
          rw [hb] at h
          simp only [Option.bind_some] at h
          exact htrans _ _ _ (ihbody stm hb) (ihrest stm st' h)
  | case11 f c body st v hc hv =>
      intro st' h
      simp only [execL, hc, if_neg hv, Option.some.injEq] at h
      subst h; exact hrefl _
  | case12 f x es ed ei ej ea st a b i j r h5 h4 h3 h2 h1 hp =>
      intro st' h
      simp [execL, h1, h2, h3, h4, h5, hp] at h
  | case13 f x es ed ei ej ea st a b i j r h5 h4 h3 h2 h1 k net' hp =>
      intro st' h
      simp only [execL, h1, h2, h3, h4, h5, hp, Option.some.injEq] at h
      subst h
      exact hpush _ _ _ _ _ _ _ _ hp
  | case14 f x es ed ei ej ea st hno =>
      intro st' h
      simp [execL] at h

/-- **Conservation.**  Any Lua0 program — in particular any program the
compiler emits — leaves the total amount of every item in the network
unchanged. -/
theorem execL_conserves (limit : Item → ℕ) (f : ℕ) (s : LStmt) (st st' : LState)
    (h : execL limit f s st = some st') (it : Item) :
    netCount st'.net it = netCount st.net it := by
  refine execL_net_rel limit (fun n n' => ∀ it, netCount n' it = netCount n it)
    (fun _ _ => rfl) (fun n1 n2 n3 h12 h23 it => by rw [h23 it, h12 it]) ?_ f s st st' h it
  intro net a i b j r k net' hp
  obtain ⟨hab, ha, hb, hi, hj, rfl⟩ := pushStep_eq limit net a i b j r k net' hp
  intro it
  exact netTransfer_conserves limit net a i b j r it hab ha hb hi hj

/-- **Safety.**  Any Lua0 program preserves the stack-limit invariant: no slot
of the network is ever filled beyond the stack limit of its item. -/
theorem execL_valid (limit : Item → ℕ) (f : ℕ) (s : LStmt) (st st' : LState)
    (h : execL limit f s st = some st') (hv : NetValid limit st.net) :
    NetValid limit st'.net := by
  refine execL_net_rel limit (fun n n' => NetValid limit n → NetValid limit n')
    (fun _ h => h) (fun _ _ _ h12 h23 h => h23 (h12 h)) ?_ f s st st' h hv
  intro net a i b j r k net' hp
  obtain ⟨_, _, _, _, _, rfl⟩ := pushStep_eq limit net a i b j r k net' hp
  intro hnet
  exact netTransfer_valid limit net a i b j r hnet

/-- **The compiled program is safe.**  Combining `toLua_exec` with
`execL_conserves`: running the Lua0 code emitted for a TS0 program conserves
every item of the network. -/
theorem toLua_exec_conserves (limit : Item → ℕ) (f : ℕ) (s : TStmt)
    (st st' : TState) (h : execT limit f s st = some st') (it : Item) :
    netCount (toLState st').net it = netCount (toLState st).net it :=
  execL_conserves limit f (cS s) (toLState st) (toLState st') (toLua_exec limit f s st st' h) it

end CCLua
