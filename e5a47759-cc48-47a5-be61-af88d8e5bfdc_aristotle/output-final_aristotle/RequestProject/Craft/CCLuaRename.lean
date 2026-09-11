import RequestProject.Craft.CCLuaCompile

/-!
# The identifier-destroying pass

Minifiers shipped with ComputerCraft toolchains rename every local of the
emitted Lua.  This file models that pass: `renS r` renames every identifier of
a Lua0 program by `r`, and `ren_exec` says that as long as `r` is injective the
renamed program means exactly what the original meant.

`obfWith ns` is a concrete such renaming — it replaces the identifiers in the
list `ns` by `_l`, `_ll`, `_lll`, … and prefixes anything else — and
`obfWith_injective` shows that it is injective, so `ren_exec` applies to it.
-/

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace CCLua

open Hopper

/-! ## Renaming -/

/-- Rename every identifier of a Lua0 expression. -/
def renE (r : Name → Name) : LExp → LExp
  | .num n => .num n
  | .bool b => .bool b
  | .var x => .var (r x)
  | .add a b => .add (renE r a) (renE r b)
  | .sub a b => .sub (renE r a) (renE r b)
  | .mul a b => .mul (renE r a) (renE r b)
  | .lt a b => .lt (renE r a) (renE r b)
  | .eq a b => .eq (renE r a) (renE r b)
  | .ne a b => .ne (renE r a) (renE r b)
  | .andE a b => .andE (renE r a) (renE r b)
  | .orE a b => .orE (renE r a) (renE r b)
  | .size a b => .size (renE r a) (renE r b)

/-- Rename every identifier of a Lua0 statement. -/
def renS (r : Name → Name) : LStmt → LStmt
  | .skip => .skip
  | .seq s1 s2 => .seq (renS r s1) (renS r s2)
  | .localD x e => .localD (r x) (renE r e)
  | .assign x e => .assign (r x) (renE r e)
  | .ifElse c s1 s2 => .ifElse (renE r c) (renS r s1) (renS r s2)
  | .whileDo c body => .whileDo (renE r c) (renS r body)
  | .pushCall x es ed ei ej ea =>
      .pushCall (r x) (renE r es) (renE r ed) (renE r ei) (renE r ej) (renE r ea)

/-- Rename the identifiers of an environment. -/
def renEnv (r : Name → Name) (env : LEnv) : LEnv := env.map (fun p => (r p.1, p.2))

/-- Rename the identifiers of a machine state. -/
def renState (r : Name → Name) (st : LState) : LState :=
  { env := renEnv r st.env, net := st.net }

theorem lookup_renEnv {r : Name → Name} (hr : Function.Injective r) (env : LEnv)
    (x : Name) : (renEnv r env).lookup (r x) = env.lookup x := by
  induction env with
  | nil => rfl
  | cons p rest ih =>
      obtain ⟨y, v⟩ := p
      simp only [renEnv, List.map_cons, List.lookup]
      have hxy : (r x == r y) = (x == y) := by
        by_cases h : x = y
        · simp [h]
        · have h2 : r x ≠ r y := fun hc => h (hr hc)
          simp [h, h2]
      rw [hxy]
      cases hb : (x == y) with
      | true => simp
      | false => simpa [renEnv] using ih

theorem setVar_renEnv {r : Name → Name} (hr : Function.Injective r) (env : LEnv)
    (x : Name) (v : LVal) :
    setVar (renEnv r env) (r x) v = renEnv r (setVar env x v) := by
  induction env with
  | nil => rfl
  | cons p rest ih =>
      obtain ⟨y, w⟩ := p
      by_cases h : y = x
      · simp [renEnv, setVar, h]
      · have h' : r y ≠ r x := fun hc => h (hr hc)
        simp only [renEnv, List.map_cons, setVar, h, h', if_false]
        simpa [renEnv] using ih

/-- **The renaming pass preserves the meaning of expressions.** -/
theorem ren_eval {r : Name → Name} (hr : Function.Injective r) (net : Network)
    (env : LEnv) (e : LExp) :
    evalL net (renEnv r env) (renE r e) = evalL net env e := by
  induction e with
  | num n => rfl
  | bool b => rfl
  | var x => simp [renE, evalL, lookup_renEnv hr]
  | add a b iha ihb => simp [renE, evalL, iha, ihb]
  | sub a b iha ihb => simp [renE, evalL, iha, ihb]
  | mul a b iha ihb => simp [renE, evalL, iha, ihb]
  | lt a b iha ihb => simp [renE, evalL, iha, ihb]
  | eq a b iha ihb => simp [renE, evalL, iha, ihb]
  | ne a b iha ihb => simp [renE, evalL, iha, ihb]
  | andE a b iha ihb => simp [renE, evalL, iha, ihb]
  | orE a b iha ihb => simp [renE, evalL, iha, ihb]
  | size a b iha ihb => simp [renE, evalL, iha, ihb]

/-- A `pushItems` call whose arguments do not all evaluate to numbers is a
runtime error. -/
theorem execL_pushCall_eq_none (limit : Item → ℕ) (f : ℕ) (x : Name)
    (es ed ei ej ea : LExp) (st : LState)
    (h : ∀ a b i j r : Int, evalL st.net st.env es = some (.num a) →
      evalL st.net st.env ed = some (.num b) → evalL st.net st.env ei = some (.num i) →
      evalL st.net st.env ej = some (.num j) → evalL st.net st.env ea = some (.num r) → False) :
    execL limit f (.pushCall x es ed ei ej ea) st = none := by
  simp [execL]

/-- **The renaming pass preserves the meaning of programs.**  Renaming every
identifier by an injective map changes neither what the program does to the
network nor, up to that renaming, the final environment. -/
theorem ren_exec (limit : Item → ℕ) {r : Name → Name} (hr : Function.Injective r) :
    ∀ (f : ℕ) (s : LStmt) (st : LState),
      execL limit f (renS r s) (renState r st) = (execL limit f s st).map (renState r) := by
  intro f s st
  induction f, s, st using execL.induct (limit := limit) with
  | case1 f st => simp [renS, execL]
  | case2 f s1 s2 st ih1 ih2 =>
      simp only [renS, execL, ih1]
      cases h1 : execL limit f s1 st with
      | none => simp
      | some stm => simpa using ih2 stm
  | case3 f x e st =>
      simp only [renS, execL, renState, ren_eval hr, Option.map_map]
      rfl
  | case4 f x e st =>
      simp only [renS, execL, renState, ren_eval hr, Option.map_map, setVar_renEnv hr]
      rfl
  | case5 f c s1 s2 st hc =>
      simp only [renS, execL, renState, ren_eval hr, hc, Option.map_none]
  | case6 f c s1 s2 st v hc hv ih =>
      simp only [renS, execL, renState, ren_eval hr, hc, hv, if_true]
      exact ih
  | case7 f c s1 s2 st v hc hv ih =>
      simp only [renS, execL, renState, ren_eval hr, hc, if_neg hv]
      exact ih
  | case8 c body st => simp [renS, execL]
  | case9 f c body st hc =>
      simp only [renS, execL, renState, ren_eval hr, hc, Option.map_none]
  | case10 f c body st v hc hv ihbody ihrest =>
      have hcr : evalL (renState r st).net (renState r st).env (renE r c) = some v := by
        simpa only [renState, ren_eval hr] using hc
      simp only [renS, execL, hcr, hc, hv, if_true, ihbody]
      cases hb : execL limit f body st with
      | none => simp
      | some stm => simpa only [Option.map_some, Option.bind_some] using ihrest stm
  | case11 f c body st v hc hv =>
      simp only [renS, execL, renState, ren_eval hr, hc, if_neg hv, Option.map_some]
  | case12 f x es ed ei ej ea st a b i j r' h5 h4 h3 h2 h1 hp =>
      simp only [renS, execL, renState, ren_eval hr, h1, h2, h3, h4, h5, hp,
        Option.map_none]
  | case13 f x es ed ei ej ea st a b i j r' h5 h4 h3 h2 h1 k net' hp =>
      simp only [renS, execL, renState, ren_eval hr, h1, h2, h3, h4, h5, hp,
        Option.map_some]
      rfl
  | case14 f x es ed ei ej ea st hno =>
      rw [execL_pushCall_eq_none limit f x es ed ei ej ea st hno]
      simp only [renS]
      rw [execL_pushCall_eq_none limit f (r x) (renE r es) (renE r ed) (renE r ei)
        (renE r ej) (renE r ea) (renState r st) ?_]
      · rfl
      · intro a b i j r' h1 h2 h3 h4 h5
        simp only [renState, ren_eval hr] at h1 h2 h3 h4 h5
        exact hno a b i j r' h1 h2 h3 h4 h5

/-! ## A concrete obfuscating renaming -/

/-- The `n`-th obfuscated identifier: `_l`, `_ll`, `_lll`, … -/
def obfOf (n : ℕ) : Name := String.ofList ('_' :: 'l' :: List.replicate n 'l')

/-- An identifier that the pass does not renumber is prefixed by `_g`. -/
def gname (x : Name) : Name := String.ofList ('_' :: 'g' :: x.toList)

/-- **Obfuscated identifiers are pairwise distinct.** -/
theorem obfOf_injective : Function.Injective obfOf := by
  intro n m h
  have h' : ('_' :: 'l' :: List.replicate n 'l') = ('_' :: 'l' :: List.replicate m 'l') :=
    String.ofList_inj.mp h
  simpa using congrArg List.length h'

theorem obfOf_ne_gname (n : ℕ) (x : Name) : obfOf n ≠ gname x := by
  intro h
  have h' : ('_' :: 'l' :: List.replicate n 'l') = ('_' :: 'g' :: x.toList) :=
    String.ofList_inj.mp h
  simp at h'

theorem gname_injective : Function.Injective gname := by
  intro x y h
  have h' : ('_' :: 'g' :: x.toList) = ('_' :: 'g' :: y.toList) := String.ofList_inj.mp h
  simp only [List.cons.injEq, true_and] at h'
  exact String.toList_inj.mp h'

/-- The obfuscating renaming for a list `ns` of identifiers: the `k`-th
identifier of `ns` becomes `obfOf k`, anything else is prefixed. -/
def obfWith (ns : List Name) (x : Name) : Name :=
  if x ∈ ns then obfOf (ns.idxOf x) else gname x

/-- **The obfuscating renaming is injective**, so `ren_exec` applies to it and
the obfuscated program means what the original meant. -/
theorem obfWith_injective (ns : List Name) : Function.Injective (obfWith ns) := by
  intro x y h
  by_cases hx : x ∈ ns <;> by_cases hy : y ∈ ns
  · simp only [obfWith, if_pos hx, if_pos hy] at h
    have hidx := obfOf_injective h
    have h1 : ns[ns.idxOf x]? = some x := List.getElem?_idxOf hx
    have h2 : ns[ns.idxOf y]? = some y := List.getElem?_idxOf hy
    rw [hidx, h2] at h1
    exact (Option.some.injEq _ _ ▸ h1).symm
  · simp only [obfWith, if_pos hx, if_neg hy] at h
    exact absurd h (obfOf_ne_gname _ _)
  · simp only [obfWith, if_neg hx, if_pos hy] at h
    exact absurd h.symm (obfOf_ne_gname _ _)
  · simp only [obfWith, if_neg hx, if_neg hy] at h
    exact gname_injective h

/-! ## The two passes composed -/

/-- **End-to-end correctness.**  Compiling a TS0 program to Lua0 and then
destroying its identifiers yields a program that, run on the correspondingly
renamed state, computes what the TS0 program computes. -/
theorem emitted_exec (limit : Item → ℕ) (ns : List Name) (f : ℕ) (s : TStmt)
    (st st' : TState) (h : execT limit f s st = some st') :
    execL limit f (renS (obfWith ns) (cS s)) (renState (obfWith ns) (toLState st))
      = some (renState (obfWith ns) (toLState st')) := by
  rw [ren_exec limit (obfWith_injective ns) f (cS s) (toLState st),
    toLua_exec limit f s st st' h]
  rfl

/-- The obfuscated compiled program still conserves every item of the
network. -/
theorem emitted_conserves (limit : Item → ℕ) (ns : List Name) (f : ℕ) (s : TStmt)
    (st st' : TState) (h : execT limit f s st = some st') (it : Item) :
    netCount st'.net it = netCount st.net it :=
  execL_conserves limit f (renS (obfWith ns) (cS s)) (renState (obfWith ns) (toLState st))
    (renState (obfWith ns) (toLState st')) (emitted_exec limit ns f s st st' h) it

end CCLua
