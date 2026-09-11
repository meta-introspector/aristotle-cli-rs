import RequestProject.Nix.NixWars.MarketMachine
import RequestProject.Nix.NixWars.Tournament

/-!
# The FRENS Tournament, compiled

The seventh door goes through the pipeline unchanged: its rules are compiled
into the expression language of `Machine.lean`, and `lobbyStepIR_correct`
proves the compiled table computes exactly `lobbyStep`. The same compiler then
turns it into WebAssembly with no new code.

The only new shapes the lobby needs are a seat test (`eqIR`, already used by
Monster Dash and the market) and the round-robin successor, which is one
comparison. Nothing multiplies two unknowns, so the static overflow bound of
the compiler is unaffected.
-/

namespace NixWars

/-- The commands of the tournament door, as the page names them. -/
inductive LobbyTag
  | claim
  | pass
  | crown
  deriving DecidableEq, Repr, Inhabited

/-- A tag is a command; the lobby takes no numeric argument. -/
def LobbyTag.cmd : LobbyTag → LobbyCmd
  | .claim => .claim
  | .pass => .pass
  | .crown => .crown

/-- The state vector is `[seat, mmc0, mmc1, mmc2, mmc3]`. -/
def lobbyFieldNames : List String := ["seat", "mmc0", "mmc1", "mmc2", "mmc3"]

/-! ## The compiled lobby -/

/-- The round-robin successor, compiled. -/
def nextSeatIR : Expr := .cond (.le (.fld 0) (.lit 2)) (.add (.fld 0) (.lit 1)) (.lit 0)

theorem eval_nextSeatIR (st : List Nat) (v : Nat) :
    nextSeatIR.eval st v = nextSeat (st.getD 0 0) := by
  simp only [nextSeatIR, Expr.eval, nextSeat, numSeats]
  split_ifs <;> omega

/-- The reward multiplier of the seated player, compiled. -/
def seatMultiplierIR : Expr := .cond (.le (.fld 0) (.lit 0)) (.lit 3) (.lit 2)

theorem eval_seatMultiplierIR (st : List Nat) (v : Nat) :
    seatMultiplierIR.eval st v = seatMultiplier (st.getD 0 0) := by
  simp only [seatMultiplierIR, Expr.eval, seatMultiplier]
  split_ifs <;> omega

/-- Is the seated player in seat `k`? -/
def isSeatIR (k : Nat) : Expr := eqIR (.fld 0) (.lit k)

theorem eval_isSeatIR (st : List Nat) (v : Nat) (k : Nat) :
    (isSeatIR k).eval st v = if st.getD 0 0 = k then 1 else 0 := by
  simp only [isSeatIR, eqIR, Expr.eval]
  split_ifs <;> omega

/-- Field `k + 1` of the state vector is the purse of seat `k`; paying the
seated player `amount` leaves the other purses alone. -/
def payIR (k : Nat) (amount : Expr) : Expr :=
  .cond (isSeatIR k) (.add (.fld (k + 1)) amount) (.fld (k + 1))

/-- The compiled transition table of the tournament door. -/
def lobbyStepIR : LobbyTag → List Expr
  | .claim =>
      [ nextSeatIR,
        payIR 0 seatMultiplierIR, payIR 1 seatMultiplierIR,
        payIR 2 seatMultiplierIR, payIR 3 seatMultiplierIR ]
  | .pass => [nextSeatIR, .fld 1, .fld 2, .fld 3, .fld 4]
  | .crown =>
      [ nextSeatIR, .fld 1, .fld 2, payIR 2 (.lit 47), .fld 4 ]

/-- **The compiled table is the FRENS Tournament.** -/
theorem lobbyStepIR_correct (tag : LobbyTag) (s : Lobby) (v : Nat) :
    runIR (lobbyStepIR tag) (lobbySerialize s) v
      = lobbySerialize (lobbyStep s tag.cmd) := by
  cases tag with
  | claim =>
      simp only [runIR, lobbyStepIR, payIR, List.map, Expr.eval, eval_nextSeatIR,
        eval_seatMultiplierIR, eval_isSeatIR, lobbySerialize, lobbyStep, LobbyTag.cmd,
        payTo, List.getD_cons_zero, List.getD_cons_succ]
      split_ifs <;> simp_all
  | pass =>
      simp [runIR, lobbyStepIR, Expr.eval, eval_nextSeatIR, lobbySerialize, lobbyStep,
        LobbyTag.cmd]
  | crown =>
      simp only [runIR, lobbyStepIR, payIR, List.map, Expr.eval, eval_nextSeatIR,
        eval_isSeatIR, lobbySerialize, lobbyStep, LobbyTag.cmd, payTo, crownSeat,
        List.getD_cons_zero, List.getD_cons_succ]
      by_cases h : s.seat = 2 <;> simp [h, crownShard]

/-- The commands with the names the page uses. -/
def lobbyTagsWithNames : List (String × LobbyTag) :=
  [("claim", .claim), ("pass", .pass), ("crown", .crown)]

end NixWars
