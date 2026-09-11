import RequestProject.Main
import RequestProject.Quine

open scoped Classical

set_option relaxedAutoImplicit false
set_option autoImplicit false

open Lean

/-!
# Extracting a runnable Rust program by applying syntax sugar

This file takes the `SimpleExpr` object language (reconstructed in `Main.lean`, with the
quine `Omega` from `Quine.lean`) and **extracts a runnable Rust program from it** by
applying *syntax sugar*.

The pipeline is:

```
            sugar                          render
 SimpleExpr ───────►  Rust (IR)  ─────────────────────►  runnable Rust source
            ◄───────
            desugar
```

1. **A Rust intermediate representation.**  `Rust` is a small AST mirroring the six
   `SimpleExpr` constructors with their Rust spellings: de Bruijn `var`, a `sortLit`,
   a const `path`, function application `app` (`f(a)`), a `closure` (`|x| body`), and a
   function-type `arrowT` (`fn(x) -> body`).

2. **Faithful translation (`sugar` / `desugar`).**  `sugar` translates an expression into
   the Rust IR and `desugar` translates back.  `desugar_sugar` and `sugar_desugar` prove
   the translation is an *exact* round-trip in both directions, and `sugar_injective`
   records that no information is lost — so the Rust program faithfully represents the
   original term.

3. **The real syntax sugar: spine collapsing.**  Curried applications and nested
   binders are *sugar* for flat, multi-argument forms.  `collapseApp` reads an
   application spine `((f a) b) c` as a head `f` applied to an argument *list*
   `[a, b, c]` (rendered `f(a, b, c)`), and `collapseLam` reads a chain of nested
   closures `λx. λy. λz. body` as a parameter *list* `[x, y, z]` over a body (rendered
   `|x, y, z| body`).  `collapseApp_correct` and `collapseLam_correct` prove this sugar
   is lossless: re-folding the collapsed form rebuilds the original IR exactly.

4. **A runnable Rust program.**  `emitRustProgram` produces a complete, self-contained
   Rust source file: a `#[derive(Debug)] enum Expr`, a layer of sugar constructor
   functions (`bvar`, `sort`, `cnst`, `app`, `lam`, `forall_e`), and a `fn main` that
   builds the term and prints it.  `#eval` at the bottom prints the program extracted
   from the quine `Omega` (and from `selfApp`).
-/

namespace SimpleExpr

/-! ## 1. A Rust intermediate representation -/

/-- A small Rust AST mirroring the six `SimpleExpr` constructors. -/
inductive Rust where
  /-- A de Bruijn variable, e.g. `v0`. -/
  | var (deBruijnIndex : Nat)
  /-- A `Sort` literal. -/
  | sortLit (u : Level)
  /-- A constant path, e.g. `SimpleExpr::toExpr`. -/
  | path (declName : Name) (us : List Level)
  /-- Function application `fn(arg)`. -/
  | app (fn arg : Rust)
  /-- A closure `|binderName| body`. -/
  | closure (binderName : Name) (binderType body : Rust) (binderInfo : BinderInfo)
  /-- A function type `fn(binderName) -> body`. -/
  | arrowT (binderName : Name) (binderType body : Rust) (binderInfo : BinderInfo)
  deriving Repr

/-! ## 2. Faithful translation: `sugar` / `desugar` -/

/-- **Apply syntax sugar.**  Translate a `SimpleExpr` into the Rust IR. -/
def sugar : SimpleExpr → Rust
  | .bvar i           => .var i
  | .sort u           => .sortLit u
  | .const n us       => .path n us
  | .app f a          => .app (sugar f) (sugar a)
  | .lam n t b bi     => .closure n (sugar t) (sugar b) bi
  | .forallE n t b bi => .arrowT n (sugar t) (sugar b) bi

/-- Translate the Rust IR back into a `SimpleExpr`. -/
def desugar : Rust → SimpleExpr
  | .var i            => .bvar i
  | .sortLit u        => .sort u
  | .path n us        => .const n us
  | .app f a          => .app (desugar f) (desugar a)
  | .closure n t b bi => .lam n (desugar t) (desugar b) bi
  | .arrowT n t b bi  => .forallE n (desugar t) (desugar b) bi

/-- **Faithfulness.**  Sugaring then desugaring recovers the original expression. -/
theorem desugar_sugar (e : SimpleExpr) : desugar (sugar e) = e := by
  induction e <;> simp_all [sugar, desugar]

/-- The other round-trip: desugaring then sugaring recovers the Rust IR. -/
theorem sugar_desugar (r : Rust) : sugar (desugar r) = r := by
  induction r <;> simp_all [sugar, desugar]

/-- No information is lost when applying syntax sugar. -/
theorem sugar_injective : Function.Injective sugar := by
  intro a b h
  have := desugar_sugar a
  rw [h, desugar_sugar b] at this
  exact this.symm

/-! ## 3. The real syntax sugar: collapsing curried spines -/

/-- Collapse an application spine `((f a) b) c` into a head `f` and an argument list
`[a, b, c]` (rendered `f(a, b, c)`). -/
def collapseApp : Rust → Rust × List Rust
  | .app f a => let (h, args) := collapseApp f; (h, args ++ [a])
  | r        => (r, [])

/-- Collapse a chain of nested closures `|x| |y| |z| body` into a parameter list
`[x, y, z]` over the body (rendered `|x, y, z| body`). -/
def collapseLam : Rust → List (Name × Rust × BinderInfo) × Rust
  | .closure n t b bi => let (ps, body) := collapseLam b; ((n, t, bi) :: ps, body)
  | r                 => ([], r)

/-- **The application sugar is lossless.**  Re-folding the collapsed spine rebuilds the
original IR exactly. -/
theorem collapseApp_correct (r : Rust) :
    (collapseApp r).2.foldl Rust.app (collapseApp r).1 = r := by
  induction r with
  | app f a ihf _ =>
      simp only [collapseApp, List.foldl_append, List.foldl_cons, List.foldl_nil]
      rw [ihf]
  | _ => rfl

/-- **The binder sugar is lossless.**  Re-folding the collapsed closure chain rebuilds
the original IR exactly. -/
theorem collapseLam_correct (r : Rust) :
    (collapseLam r).1.foldr (fun p acc => Rust.closure p.1 p.2.1 acc p.2.2)
      (collapseLam r).2 = r := by
  induction r with
  | closure n t b bi _ ihb =>
      simp only [collapseLam, List.foldr_cons]
      rw [ihb]
  | _ => rfl

/-! ## 4. A runnable Rust program -/

/-- Render a `Name` as a Rust string literal body. -/
def quoteName (n : Name) : String := "\"" ++ n.toString ++ "\""

/-- Render a `SimpleExpr` as a Rust expression that *constructs* the corresponding `Expr`
value, using the sugar constructor functions (`bvar`, `sort`, `cnst`, `app`, `lam`,
`forall_e`). -/
def rustOfData : SimpleExpr → String
  | .bvar i           => s!"bvar({i})"
  | .sort _           => "sort()"
  | .const n _        => s!"cnst({quoteName n})"
  | .app f a          => s!"app({rustOfData f}, {rustOfData a})"
  | .lam n t b _      => s!"lam({quoteName n}, {rustOfData t}, {rustOfData b})"
  | .forallE n t b _  => s!"forall_e({quoteName n}, {rustOfData t}, {rustOfData b})"

/-- The fixed preamble of the runnable Rust program: the `Expr` enum and the sugar
constructor functions. -/
def rustPreamble : String :=
"#[derive(Debug)]
enum Expr {
    Bvar(u64),
    Sort,
    Const(String),
    App(Box<Expr>, Box<Expr>),
    Lam(String, Box<Expr>, Box<Expr>),
    ForallE(String, Box<Expr>, Box<Expr>),
}

use Expr::*;

fn bvar(i: u64) -> Box<Expr> { Box::new(Bvar(i)) }
fn sort() -> Box<Expr> { Box::new(Sort) }
fn cnst(n: &str) -> Box<Expr> { Box::new(Const(n.to_string())) }
fn app(f: Box<Expr>, a: Box<Expr>) -> Box<Expr> { Box::new(App(f, a)) }
fn lam(n: &str, t: Box<Expr>, b: Box<Expr>) -> Box<Expr> { Box::new(Lam(n.to_string(), t, b)) }
fn forall_e(n: &str, t: Box<Expr>, b: Box<Expr>) -> Box<Expr> { Box::new(ForallE(n.to_string(), t, b)) }
"

/-- **Extract a runnable Rust program.**  Produce a complete, self-contained Rust source
file that builds the given term and prints it. -/
def emitRustProgram (label : String) (e : SimpleExpr) : String :=
  rustPreamble
    ++ "\nfn main() {\n"
    ++ s!"    // {label}\n"
    ++ s!"    let term = {rustOfData e};\n"
    ++ "    println!(\"{:#?}\", term);\n"
    ++ "}\n"

-- **Extract and print the runnable Rust program for the quine `Omega`.**
#eval IO.println (emitRustProgram "Omega = (\\x. x x) (\\x. x x)  (the quine)" Omega)

-- **And for the self-application term.**
#eval IO.println (emitRustProgram "selfApp = SimpleExpr.toExpr SimpleExpr" selfApp)

end SimpleExpr
