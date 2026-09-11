import RequestProject.Nix.NixWars.DashMachine
import RequestProject.Nix.NixWars.Market

/-!
# The Shard Market, compiled

The third door goes through the same pipeline as the first two: its rules are
compiled into the expression language of `Machine.lean`, and
`marketStepIR_correct` proves the compiled table computes exactly `marketStep`.
It is then compiled to WebAssembly by the same compiler, with no new code.

The one new thing the market needs is the price rotation `47 → 59 → 71 → 47`,
which the machine builds out of two equality tests. Because the quote is a
state field rather than a function of the clock, nothing in the table
multiplies two unknowns, and the static overflow bound stays comfortable.
-/

namespace NixWars

/-- The commands of the market door, as the page names them. -/
inductive MarketTag
  | buy
  | sell
  | hold
  deriving DecidableEq, Repr, Inhabited

/-- A tag is a command; the market takes no numeric argument. -/
def MarketTag.cmd : MarketTag → MarketCmd
  | .buy => .buy
  | .sell => .sell
  | .hold => .hold

/-- The state vector is `[credits, held, price, turn]`. -/
def marketFieldNames : List String := ["credits", "held", "price", "turn"]

/-! ## Evaluating the pieces -/

theorem eval_modIR (st : List Nat) (v : Nat) (a b : Expr) :
    (modIR a b).eval st v = a.eval st v % b.eval st v := by
  have h := Nat.div_add_mod (a.eval st v) (b.eval st v)
  simp only [modIR, Expr.eval]
  omega

theorem eval_eqIR (st : List Nat) (v : Nat) (a b : Expr) :
    (eqIR a b).eval st v = if a.eval st v = b.eval st v then 1 else 0 := by
  simp only [eqIR, Expr.eval]
  split_ifs with h₁ h₂ h₃ <;> omega

/-! ## The compiled market -/

/-- The price rotation, compiled: `47 → 59 → 71 → 47`. -/
def nextPriceIR : Expr :=
  .cond (eqIR (.fld 2) (.lit 47)) (.lit 59)
    (.cond (eqIR (.fld 2) (.lit 59)) (.lit 71) (.lit 47))

/-- The compiled rotation computes the next quote. -/
theorem eval_nextPriceIR (st : List Nat) (v : Nat) :
    nextPriceIR.eval st v = nextPrice (st.getD 2 0) := by
  simp only [nextPriceIR, Expr.eval, eval_eqIR, nextPrice]
  split_ifs <;> simp_all

/-- The compiled transition table of the market door. -/
def marketStepIR : MarketTag → List Expr
  | .buy =>
      let afford : Expr := .le (.fld 2) (.fld 0)
      [ .cond afford (.sub (.fld 0) (.fld 2)) (.fld 0),
        .cond afford (.add (.fld 1) (.lit 1)) (.fld 1),
        .cond afford nextPriceIR (.fld 2),
        .cond afford (.add (.fld 3) (.lit 1)) (.fld 3) ]
  | .sell =>
      let holding : Expr := .le (.lit 1) (.fld 1)
      [ .cond holding (.add (.fld 0) (.fld 2)) (.fld 0),
        .cond holding (.sub (.fld 1) (.lit 1)) (.fld 1),
        .cond holding nextPriceIR (.fld 2),
        .cond holding (.add (.fld 3) (.lit 1)) (.fld 3) ]
  | .hold => [.fld 0, .fld 1, nextPriceIR, .add (.fld 3) (.lit 1)]

/-- **The compiled table is the Shard Market.** -/
theorem marketStepIR_correct (tag : MarketTag) (s : Market) (v : Nat) :
    runIR (marketStepIR tag) (marketSerialize s) v
      = marketSerialize (marketStep s tag.cmd) := by
  cases tag with
  | buy =>
      by_cases h : s.price ≤ s.credits
      · simp [runIR, marketStepIR, Expr.eval, eval_nextPriceIR, marketSerialize, marketStep,
          MarketTag.cmd, h]
      · simp [runIR, marketStepIR, Expr.eval, marketSerialize, marketStep,
          MarketTag.cmd, h]
  | sell =>
      by_cases h : 1 ≤ s.held
      · simp [runIR, marketStepIR, Expr.eval, eval_nextPriceIR, marketSerialize, marketStep,
          MarketTag.cmd, h]
      · simp [runIR, marketStepIR, Expr.eval, marketSerialize, marketStep,
          MarketTag.cmd, h]
  | hold =>
      simp [runIR, marketStepIR, Expr.eval, eval_nextPriceIR, marketSerialize, marketStep,
        MarketTag.cmd]

/-- The commands with the names the page uses. -/
def marketTagsWithNames : List (String × MarketTag) :=
  [("buy", .buy), ("sell", .sell), ("hold", .hold)]

end NixWars
