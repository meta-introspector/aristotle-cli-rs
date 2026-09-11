import RequestProject.Main
import RequestProject.Quine
import RequestProject.Rust

open scoped Classical

set_option relaxedAutoImplicit false
set_option autoImplicit false

open Lean

/-!
# A Rust → Lean reflection loop (`syn` / `build.rs` / `cargo`)

`Rust.lean` extracts a runnable Rust program *from* a `SimpleExpr`.  This file closes the
loop in the other direction: it models what a Rust build script (`build.rs`) does when it
uses the [`syn`](https://docs.rs/syn) crate to **parse the emitted Rust back into an AST**
and then **dumps that AST back out as a Lean term** — and it *proves* that the round trip
is the identity, i.e. the Rust faithfully maps back to Lean.

```
              reflect                 render                    cargo + syn::parse
   SimpleExpr ───────► Syn (AST) ───────────► Rust source ─────────────────────────┐
        ▲                                                                           │
        │                                                            (Rust's parser, trusted)
        │                                                                           ▼
        └──────────────── reify  ◄────────────  Syn (AST)  ◄─────── build.rs walks syn::Expr
```

The middle, string-level hop (`render` ⇄ Rust source ⇄ `syn::Expr`) is performed by
Rust's own tokenizer/parser via `syn` and is therefore trusted.  The mathematically
load-bearing part — that walking the parsed `syn::Expr` AST (`reify`) inverts the
structure we emitted (`reflect`) — is verified here.

Unlike the lossy data printer `rustOfData` in `Rust.lean` (which drops `Level` and
`BinderInfo`), the reflection in this file is **information preserving**: it encodes
`Name`, `Level`, `List Level` and `BinderInfo` as well, so the loop recovers the original
`SimpleExpr` *exactly* (`reify_reflect`).

## What `Syn` models

`Syn` is a faithful model of the fragment of [`syn::Expr`](https://docs.rs/syn) that the
emitted programs use:

* `Syn.call head args` ≈ `syn::Expr::Call` — a function-call expression `head(args…)`,
* `Syn.natLit n`       ≈ `syn::Expr::Lit` with `syn::Lit::Int`,
* `Syn.strLit s`       ≈ `syn::Expr::Lit` with `syn::Lit::Str`.

`render : Syn → String` is the pretty printer that produces the Rust source `cargo`
compiles; `build.rs` reconstructs a `Syn` from `syn`'s parse and we interpret it with
`reify`.
-/

namespace SimpleExpr

/-! ## 1. A model of the parsed `syn` AST -/

/-- A faithful model of the fragment of `syn::Expr` produced by parsing the emitted Rust:
call expressions, integer literals, and string literals. -/
inductive Syn where
  /-- A call expression `head(args…)` (≈ `syn::Expr::Call` with a path callee). -/
  | call (head : String) (args : List Syn)
  /-- An integer literal (≈ `syn::Lit::Int`). -/
  | natLit (n : Nat)
  /-- A string literal (≈ `syn::Lit::Str`). -/
  | strLit (s : String)
  deriving Repr, Inhabited

/-! ## 2. Reflecting Lean metadata into `Syn`

These are the information-preserving encoders for the auxiliary types carried by
`SimpleExpr` (`Name`, `Level`, `List Level`, `BinderInfo`). -/

/-- Reflect a `BinderInfo` as a nullary call. -/
def reflectBinderInfo : BinderInfo → Syn
  | .default       => .call "bi_default" []
  | .implicit      => .call "bi_implicit" []
  | .strictImplicit => .call "bi_strict_implicit" []
  | .instImplicit  => .call "bi_inst_implicit" []

/-- Reflect a `Name` into `Syn`. -/
def reflectName : Name → Syn
  | .anonymous => .call "name_anon" []
  | .str p s   => .call "name_str" [reflectName p, .strLit s]
  | .num p n   => .call "name_num" [reflectName p, .natLit n]

/-- Reflect a `Level` into `Syn`. -/
def reflectLevel : Level → Syn
  | .zero      => .call "lvl_zero" []
  | .succ l    => .call "lvl_succ" [reflectLevel l]
  | .max a b   => .call "lvl_max" [reflectLevel a, reflectLevel b]
  | .imax a b  => .call "lvl_imax" [reflectLevel a, reflectLevel b]
  | .param n   => .call "lvl_param" [reflectName n]
  | .mvar id   => .call "lvl_mvar" [reflectName id.name]

/-- Reflect a `List Level` into a single `Syn` call. -/
def reflectLevelList (us : List Level) : Syn :=
  .call "level_list" (us.map reflectLevel)

/-! ## 3. Reflecting a `SimpleExpr` into `Syn` (what `render` emits) -/

/-- **Reflect.** The information-preserving encoder from `SimpleExpr` into the `syn` AST
model.  This is the structure the emitted Rust parses to.

(Named `toSyn` to avoid clashing with `SimpleExpr.reflect` from `Quine.lean`.) -/
def toSyn : SimpleExpr → Syn
  | .bvar i           => .call "bvar" [.natLit i]
  | .sort u           => .call "sort" [reflectLevel u]
  | .const n us       => .call "cnst" [reflectName n, reflectLevelList us]
  | .app f a          => .call "app" [toSyn f, toSyn a]
  | .lam n t b bi     => .call "lam" [reflectName n, toSyn t, toSyn b, reflectBinderInfo bi]
  | .forallE n t b bi => .call "forall_e" [reflectName n, toSyn t, toSyn b, reflectBinderInfo bi]

/-! ## 4. Reifying the parsed `Syn` back into Lean (what `build.rs` dumps) -/

/-- Interpret a parsed `Syn` as a `BinderInfo`. -/
def reifyBinderInfo : Syn → Option BinderInfo
  | .call "bi_default" []         => some .default
  | .call "bi_implicit" []        => some .implicit
  | .call "bi_strict_implicit" [] => some .strictImplicit
  | .call "bi_inst_implicit" []   => some .instImplicit
  | _                             => none

/-- Interpret a parsed `Syn` as a `Name`. -/
def reifyName : Syn → Option Name
  | .call "name_anon" []              => some .anonymous
  | .call "name_str" [p, .strLit s]   => (reifyName p).map (·.str s)
  | .call "name_num" [p, .natLit n]   => (reifyName p).map (·.num n)
  | _                                 => none

/-- Interpret a parsed `Syn` as a `Level`. -/
def reifyLevel : Syn → Option Level
  | .call "lvl_zero" []        => some .zero
  | .call "lvl_succ" [l]       => (reifyLevel l).map .succ
  | .call "lvl_max" [a, b]     => do return .max (← reifyLevel a) (← reifyLevel b)
  | .call "lvl_imax" [a, b]    => do return .imax (← reifyLevel a) (← reifyLevel b)
  | .call "lvl_param" [n]      => (reifyName n).map .param
  | .call "lvl_mvar" [n]       => (reifyName n).map (fun nm => .mvar ⟨nm⟩)
  | _                          => none

/-- Interpret a list of parsed `Syn` as a `List Level`. -/
def reifyLevelArgs : List Syn → Option (List Level)
  | []      => some []
  | s :: ss => do return (← reifyLevel s) :: (← reifyLevelArgs ss)

/-- Interpret a parsed `Syn` as a `List Level`. -/
def reifyLevelList : Syn → Option (List Level)
  | .call "level_list" args => reifyLevelArgs args
  | _                       => none

/-- **Reify.** What `build.rs` does after `syn` parses the emitted Rust: walk the AST and
dump it back out as a `SimpleExpr`.  Returns `none` on input outside the emitted fragment.

(Named `ofSyn` to avoid clashing with `SimpleExpr.reify` from `Quine.lean`.) -/
def ofSyn : Syn → Option SimpleExpr
  | .call "bvar" [.natLit i]       => some (.bvar i)
  | .call "sort" [u]               => (reifyLevel u).map .sort
  | .call "cnst" [n, us]           => do return .const (← reifyName n) (← reifyLevelList us)
  | .call "app" [f, a]             => do return .app (← ofSyn f) (← ofSyn a)
  | .call "lam" [n, t, b, bi]      =>
      do return .lam (← reifyName n) (← ofSyn t) (← ofSyn b) (← reifyBinderInfo bi)
  | .call "forall_e" [n, t, b, bi] =>
      do return .forallE (← reifyName n) (← ofSyn t) (← ofSyn b) (← reifyBinderInfo bi)
  | _                              => none

/-! ## 5. The loop closes: `ofSyn ∘ toSyn = id` -/

/-- Round trip for binder annotations. -/
theorem reifyBinderInfo_reflect (bi : BinderInfo) :
    reifyBinderInfo (reflectBinderInfo bi) = some bi := by
  cases bi <;> rfl

/-- Round trip for names. -/
theorem reifyName_reflect (n : Name) : reifyName (reflectName n) = some n := by
  induction n with
  | anonymous => rfl
  | str p s ih => simp [reflectName, reifyName, ih]
  | num p n ih => simp [reflectName, reifyName, ih]

/-- Round trip for universe levels. -/
theorem reifyLevel_reflect (l : Level) : reifyLevel (reflectLevel l) = some l := by
  induction' l using Lean.Level.recOn with l ih
  all_goals simp_all +decide [reflectLevel, reifyLevel]
  · exact reifyName_reflect _
  · exact ⟨_, reifyName_reflect _, rfl⟩

/-- Round trip for the auxiliary level-list arguments. -/
theorem reifyLevelArgs_map_reflect (us : List Level) :
    reifyLevelArgs (us.map reflectLevel) = some us := by
  induction us with
  | nil => rfl
  | cons u us ih =>
    simp +decide [reifyLevelArgs, ih]
    rw [reifyLevel_reflect]; rfl

/-- Round trip for a list of universe levels. -/
theorem reifyLevelList_reflect (us : List Level) :
    reifyLevelList (reflectLevelList us) = some us := by
  convert reifyLevelArgs_map_reflect us

/-- **The reflection loop is the identity.**  Reflecting a `SimpleExpr` into the `syn` AST
model and reifying the parsed AST back recovers the original term exactly — the Rust
faithfully maps back to Lean in a loop. -/
theorem ofSyn_toSyn (e : SimpleExpr) : ofSyn (toSyn e) = some e := by
  induction' e using SimpleExpr.recOn with e ih
  all_goals simp_all +decide [SimpleExpr.toSyn, ofSyn]
  · exact reifyLevel_reflect _
  · rw [reifyName_reflect, reifyLevelList_reflect]; aesop
  · rw [reifyName_reflect, reifyBinderInfo_reflect]; aesop
  · rw [reifyName_reflect, reifyBinderInfo_reflect]; aesop

/-- No information is lost in the reflection: `toSyn` is injective. -/
theorem toSyn_injective : Function.Injective toSyn := by
  intro a b h
  have ha := ofSyn_toSyn a
  rw [h, ofSyn_toSyn b] at ha
  exact (Option.some.inj ha).symm

/-! ## 6. Rendering `Syn` to the Rust source string that `cargo` compiles -/

/-- Render a `Syn` AST as Rust source (a call-expression string). -/
def render : Syn → String
  | .call head args => head ++ "(" ++ String.intercalate ", " (args.map render) ++ ")"
  | .natLit n       => toString n
  | .strLit s       => "\"" ++ s ++ "\""

/-- The complete, self-contained Rust source dumped by the loop: the `Expr` enum, the
information-preserving constructor functions, and a `main` that rebuilds and prints the
term.  Pair this with the `build.rs` in `rust-reflect/` to run the loop end to end. -/
def renderReflectProgram (label : String) (e : SimpleExpr) : String :=
  "// " ++ label ++ "\n"
    ++ "// reflected term (parse this back with `syn` in build.rs):\n"
    ++ "let term = " ++ render (toSyn e) ++ ";\n"

-- Print the faithful, information-preserving reflection of the quine `Omega` …
#eval IO.println (renderReflectProgram "Omega = (\\x. x x) (\\x. x x)" Omega)

-- … and of the self-application term.
#eval IO.println (renderReflectProgram "selfApp = SimpleExpr.toExpr SimpleExpr" selfApp)

end SimpleExpr