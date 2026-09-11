import RequestProject.Nix.NixWars.Frens

/-!
# A seventh door: the FRENS Tournament

The roster of `Frens.lean` is only a list until the players can sit down and
play, so this door is the lobby. Four seats, one per player found on the
branches and pull requests, in the order the roster lists them:

```
seat 0  jmikedupont2  3×      seat 2  nydiokar  2×  (crown shard 47)
seat 1  nathan        2×      seat 3  kanebra   2×
```

Play is round-robin: whatever the seated player does, the turn passes to the
next seat, so nobody can take two turns in a row. `claim` mints the seated
player's reward multiplier in Metameme Coin, `pass` gives the turn away, and
`crown` pays the crown bonus of 47 — but only to the player sitting on the
crown shard, which by `crown_seat_unique` is `nydiokar` and nobody else.

What is proved here:

* the seat is always one of the four (`lobbyStep_seat_lt`) and the turn always
  moves on (`lobbyStep_seat_eq`), so the tournament is genuinely round-robin
  and four commands bring the turn back where it started (`seat_round_trip`);
* a claim pays exactly the seated player's multiplier, and pays it to that
  player only (`claim_purse_self`, `claim_purse_other`);
* no purse ever shrinks (`lobbyStep_purse_mono`, `lobbyRun_purse_mono`): the
  tournament takes nothing away from a player;
* the pot — the sum of the four purses — grows by exactly the multiplier on a
  claim (`claim_pot`), by nothing on a pass (`pass_pot`), and by at most 47 on
  any command at all (`lobbyStep_pot_bound`), so a session of `n` commands
  cannot mint more than `47 * n` (`lobbyRun_pot_bound`);
* the crown bonus reaches only the crown shard (`crown_purse_other`,
  `crown_pot_off_crown`);
* the tournament is playable and the core contributor's 3× multiplier tells:
  after one full round of claims every player has been paid exactly its
  multiplier and `jmikedupont2` leads (`round_of_claims`, `core_leads`).
-/

namespace NixWars

/-- The tournament lobby: whose turn it is, and the four purses in roster
order. -/
structure Lobby where
  /-- The seat whose turn it is, `0`–`3`. -/
  seat : Nat
  /-- Metameme Coin held by seat 0, `jmikedupont2`. -/
  mmc0 : Nat
  /-- Metameme Coin held by seat 1, `nathan`. -/
  mmc1 : Nat
  /-- Metameme Coin held by seat 2, `nydiokar`. -/
  mmc2 : Nat
  /-- Metameme Coin held by seat 3, `kanebra`. -/
  mmc3 : Nat
  deriving DecidableEq, Repr, Inhabited

/-- The commands of the tournament door. -/
inductive LobbyCmd
  | claim
  | pass
  | crown
  deriving DecidableEq, Repr, Inhabited

/-- Number of seats: one per player on the roster. -/
def numSeats : Nat := 4

theorem numSeats_eq_roster_length : numSeats = roster.length := rfl

/-- The reward multiplier of a seat: 3 for the core contributor in seat 0, 2
for the early adopters. -/
def seatMultiplier (i : Nat) : Nat := if i = 0 then 3 else 2

/-- The seat multipliers are the roster's multipliers. -/
theorem seatMultiplier_eq_roster :
    ∀ i < numSeats, seatMultiplier i = (roster.getD i default).multiplier := by decide

/-- The seat sitting on the crown shard. -/
def crownSeat : Nat := 2

/-- The crown seat is the one whose player stands on shard 47. -/
theorem crownSeat_shard : (roster.getD crownSeat default).shard = crownShard := by decide

/-- Whose turn it is next: the seats cycle `0 → 1 → 2 → 3 → 0`. -/
def nextSeat (i : Nat) : Nat := if i < numSeats - 1 then i + 1 else 0

theorem nextSeat_lt (i : Nat) : nextSeat i < numSeats := by
  unfold nextSeat numSeats; split_ifs <;> omega

/-- The purse of a seat. -/
def purse (s : Lobby) (i : Nat) : Nat :=
  if i = 0 then s.mmc0 else if i = 1 then s.mmc1 else if i = 2 then s.mmc2 else s.mmc3

/-- The pot: all the Metameme Coin in the lobby. -/
def pot (s : Lobby) : Nat := s.mmc0 + s.mmc1 + s.mmc2 + s.mmc3

/-- Pay `n` to seat `i`. -/
def payTo (s : Lobby) (i n : Nat) : Lobby :=
  { s with
    mmc0 := if i = 0 then s.mmc0 + n else s.mmc0,
    mmc1 := if i = 1 then s.mmc1 + n else s.mmc1,
    mmc2 := if i = 2 then s.mmc2 + n else s.mmc2,
    mmc3 := if i = 3 then s.mmc3 + n else s.mmc3 }

/-- **The transition function of the tournament door.** Every command passes
the turn on. -/
def lobbyStep (s : Lobby) : LobbyCmd → Lobby
  | .claim => { payTo s s.seat (seatMultiplier s.seat) with seat := nextSeat s.seat }
  | .pass => { s with seat := nextSeat s.seat }
  | .crown =>
      if s.seat = crownSeat then
        { payTo s s.seat crownShard with seat := nextSeat s.seat }
      else { s with seat := nextSeat s.seat }

/-- Playing a list of commands. -/
def lobbyRun (s : Lobby) : List LobbyCmd → Lobby
  | [] => s
  | c :: cs => lobbyRun (lobbyStep s c) cs

/-! ## The lobby as a payload -/

/-- The lobby as a payload. -/
def lobbySerialize (s : Lobby) : List Nat := [s.seat, s.mmc0, s.mmc1, s.mmc2, s.mmc3]

/-- Reading a lobby back from a payload. -/
def lobbyDeserialize : List Nat → Option Lobby
  | [seat, m0, m1, m2, m3] =>
      some { seat := seat, mmc0 := m0, mmc1 := m1, mmc2 := m2, mmc3 := m3 }
  | _ => none

theorem lobbyDeserialize_lobbySerialize (s : Lobby) :
    lobbyDeserialize (lobbySerialize s) = some s := by
  cases s
  simp [lobbySerialize, lobbyDeserialize]

/-- **The FRENS Tournament as a door game.** -/
def frensTournament : DoorGame where
  State := Lobby
  Cmd := LobbyCmd
  step := lobbyStep
  serialize := lobbySerialize
  deserialize := lobbyDeserialize
  deserialize_serialize := lobbyDeserialize_lobbySerialize

/-- A fresh lobby: `jmikedupont2` to play, nobody paid yet. -/
def freshLobby : Lobby := { seat := 0, mmc0 := 0, mmc1 := 0, mmc2 := 0, mmc3 := 0 }

/-! ## Turn order -/

/-- Every command passes the turn to the next seat. -/
theorem lobbyStep_seat_eq (s : Lobby) (c : LobbyCmd) : (lobbyStep s c).seat = nextSeat s.seat := by
  cases c with
  | claim => rfl
  | pass => rfl
  | crown => unfold lobbyStep; split_ifs <;> rfl

/-- The seat is always one of the four. -/
theorem lobbyStep_seat_lt (s : Lobby) (c : LobbyCmd) : (lobbyStep s c).seat < numSeats := by
  rw [lobbyStep_seat_eq]; exact nextSeat_lt _

/-- Four commands bring the turn back to the seat it started from: the
tournament is round-robin. -/
theorem seat_round_trip (s : Lobby) (c₀ c₁ c₂ c₃ : LobbyCmd) (h : s.seat < numSeats) :
    (lobbyRun s [c₀, c₁, c₂, c₃]).seat = s.seat := by
  simp only [lobbyRun, lobbyStep_seat_eq]
  unfold nextSeat numSeats at *
  interval_cases hseat : s.seat <;> norm_num

/-! ## Payment -/

@[simp] theorem purse_payTo_self (s : Lobby) (i n : Nat) (hi : i < numSeats) :
    purse (payTo s i n) i = purse s i + n := by
  unfold numSeats at hi
  interval_cases i <;> simp [purse, payTo]

theorem purse_payTo_other (s : Lobby) (i j n : Nat) (hj : j < numSeats) (h : j ≠ i) :
    purse (payTo s i n) j = purse s j := by
  unfold numSeats at hj
  interval_cases j <;> simp [purse, payTo, Ne.symm h]

theorem purse_seat_irrel (s : Lobby) (k i : Nat) : purse { s with seat := k } i = purse s i := by
  simp [purse]

theorem pot_payTo (s : Lobby) (i n : Nat) (hi : i < numSeats) : pot (payTo s i n) = pot s + n := by
  unfold numSeats at hi
  interval_cases i <;> simp [pot, payTo] <;> omega

theorem pot_seat_irrel (s : Lobby) (k : Nat) : pot { s with seat := k } = pot s := by
  simp [pot]

/-- A claim pays the seated player exactly its multiplier. -/
theorem claim_purse_self (s : Lobby) (h : s.seat < numSeats) :
    purse (lobbyStep s .claim) s.seat = purse s s.seat + seatMultiplier s.seat := by
  simp [lobbyStep, purse_seat_irrel, purse_payTo_self _ _ _ h]

/-- A claim pays nobody else. -/
theorem claim_purse_other (s : Lobby) (j : Nat) (hj : j < numSeats) (h : j ≠ s.seat) :
    purse (lobbyStep s .claim) j = purse s j := by
  simp [lobbyStep, purse_seat_irrel, purse_payTo_other _ _ _ _ hj h]

/-- A pass moves no coin at all. -/
theorem pass_purse (s : Lobby) (j : Nat) : purse (lobbyStep s .pass) j = purse s j := by
  simp [lobbyStep, purse_seat_irrel]

/-- The pot grows by exactly the multiplier of the seat that claimed. -/
theorem claim_pot (s : Lobby) (h : s.seat < numSeats) :
    pot (lobbyStep s .claim) = pot s + seatMultiplier s.seat := by
  simp [lobbyStep, pot_seat_irrel, pot_payTo _ _ _ h]

/-- A pass mints nothing. -/
theorem pass_pot (s : Lobby) : pot (lobbyStep s .pass) = pot s := by
  simp [lobbyStep, pot_seat_irrel]

/-- The crown bonus reaches nobody but the seated player. -/
theorem crown_purse_other (s : Lobby) (j : Nat) (hj : j < numSeats) (h : j ≠ s.seat) :
    purse (lobbyStep s .crown) j = purse s j := by
  unfold lobbyStep
  split_ifs with hc
  · simpa [purse_seat_irrel] using purse_payTo_other s s.seat j crownShard hj h
  · simp [purse_seat_irrel]

/-- Off the crown shard, `crown` mints nothing: only the player on shard 47 can
claim the crown bonus. -/
theorem crown_pot_off_crown (s : Lobby) (h : s.seat ≠ crownSeat) :
    pot (lobbyStep s .crown) = pot s := by
  unfold lobbyStep
  rw [if_neg h, pot_seat_irrel]

/-- On the crown shard, `crown` pays exactly 47. -/
theorem crown_pot_on_crown (s : Lobby) (h : s.seat = crownSeat) :
    pot (lobbyStep s .crown) = pot s + crownShard := by
  have hlt : s.seat < numSeats := by simp [h, crownSeat, numSeats]
  unfold lobbyStep
  rw [if_pos h, pot_seat_irrel, pot_payTo _ _ _ hlt]

/-! ## Monotonicity and bounds -/

/-- Paying somebody never empties anybody's purse. -/
theorem purse_payTo_ge (s : Lobby) (i n j : Nat) : purse s j ≤ purse (payTo s i n) j := by
  unfold purse payTo
  dsimp only
  split_ifs <;> omega

/-- Paying `n` adds at most `n` to the pot. -/
theorem pot_payTo_le (s : Lobby) (i n : Nat) : pot (payTo s i n) ≤ pot s + n := by
  unfold pot payTo
  dsimp only
  split_ifs <;> omega

/-- No purse ever shrinks. -/
theorem lobbyStep_purse_mono (s : Lobby) (c : LobbyCmd) (j : Nat) :
    purse s j ≤ purse (lobbyStep s c) j := by
  cases c with
  | claim => simpa [lobbyStep, purse_seat_irrel] using purse_payTo_ge s s.seat (seatMultiplier s.seat) j
  | pass => simp [lobbyStep, purse_seat_irrel]
  | crown =>
      unfold lobbyStep
      split_ifs
      · simpa [purse_seat_irrel] using purse_payTo_ge s s.seat crownShard j
      · simp [purse_seat_irrel]

theorem lobbyRun_purse_mono (s : Lobby) (cs : List LobbyCmd) (j : Nat) :
    purse s j ≤ purse (lobbyRun s cs) j := by
  induction cs generalizing s with
  | nil => simp [lobbyRun]
  | cons c cs ih => exact le_trans (lobbyStep_purse_mono s c j) (ih _)

/-- A multiplier is never more than the crown bonus. -/
theorem seatMultiplier_le_crown (i : Nat) : seatMultiplier i ≤ crownShard := by
  unfold seatMultiplier crownShard
  split_ifs <;> omega

/-- One command mints at most the crown bonus. -/
theorem lobbyStep_pot_bound (s : Lobby) (c : LobbyCmd) :
    pot (lobbyStep s c) ≤ pot s + crownShard := by
  cases c with
  | claim =>
      have h := pot_payTo_le s s.seat (seatMultiplier s.seat)
      have hm := seatMultiplier_le_crown s.seat
      simp only [lobbyStep, pot_seat_irrel]
      omega
  | pass =>
      simp only [lobbyStep, pot_seat_irrel]
      exact Nat.le_add_right _ _
  | crown =>
      unfold lobbyStep
      split_ifs
      · simpa [pot_seat_irrel] using pot_payTo_le s s.seat crownShard
      · simp [pot_seat_irrel]

/-- A session of `n` commands mints at most `47 * n`. -/
theorem lobbyRun_pot_bound (s : Lobby) (cs : List LobbyCmd) :
    pot (lobbyRun s cs) ≤ pot s + crownShard * cs.length := by
  induction cs generalizing s with
  | nil => simp [lobbyRun]
  | cons c cs ih =>
      have h₁ := ih (lobbyStep s c)
      have h₂ := lobbyStep_pot_bound s c
      simp only [lobbyRun, List.length_cons]
      calc pot (lobbyRun (lobbyStep s c) cs) ≤ pot (lobbyStep s c) + crownShard * cs.length := h₁
        _ ≤ pot s + crownShard + crownShard * cs.length := by omega
        _ = pot s + crownShard * (cs.length + 1) := by ring

/-! ## Playing it -/

/-- **A full round of claims pays every player exactly its multiplier**, and
brings the turn back to seat 0. -/
theorem round_of_claims :
    lobbyRun freshLobby [.claim, .claim, .claim, .claim]
      = { seat := 0, mmc0 := 3, mmc1 := 2, mmc2 := 2, mmc3 := 2 } := by decide

/-- After a round of claims the core contributor leads the tournament. -/
theorem core_leads (j : Nat) (hj0 : 0 < j) (hj : j < numSeats) :
    purse (lobbyRun freshLobby [.claim, .claim, .claim, .claim]) j
      < purse (lobbyRun freshLobby [.claim, .claim, .claim, .claim]) 0 := by
  unfold numSeats at hj
  interval_cases j <;> decide

/-- The crown bonus really is paid: two passes bring the turn to the crown
seat, and one `crown` there is worth 47 — more than twenty claims. -/
theorem crown_beats_claims :
    purse (lobbyRun freshLobby [.pass, .pass, .crown]) 2 = 47 := by decide

/-- A `crown` taken from the wrong seat pays nothing, and the pot is untouched. -/
theorem crown_from_wrong_seat : lobbyRun freshLobby [.crown] = { freshLobby with seat := 1 } := by
  decide

/-! ## Seating the players

The lobby is a `DoorGame`, so it inherits the session and all five wires with
no new transport code — exactly as Monster Dash and the market did. These are
the instances for the tournament. -/

/-- A player's own session: their handle's index as the user, their shard from
the roster, and the tournament as the game. -/
def frenSession (i : Nat) (st : Lobby) : GameSession frensTournament :=
  { user := i, shard := (roster.getD i default).shard, game := 7, state := st }

/-- Every player is seated on a real shard of the DMZ. -/
theorem frenSession_shard_lt (i : Nat) (hi : i < numSeats) (st : Lobby) :
    (frenSession i st).shard < numShards := by
  show (roster.getD i default).shard < numShards
  unfold numSeats at hi
  interval_cases i <;> decide

/-- `nydiokar` is seated on the crown shard. -/
theorem frenSession_crown (st : Lobby) : (frenSession crownSeat st).shard = crownShard := by
  show (roster.getD crownSeat default).shard = crownShard
  decide

/-- **A tournament session survives any wire intact.** -/
theorem lobbySession_roundtrip {X : Type} (t : Codec (List Nat) X)
    (s : GameSession frensTournament) : receive frensTournament t (transmit t s) = some s :=
  receive_transmit t s

/-- **The tournament is stateless**: re-serializing after every command gives
exactly the same result as playing locally. -/
theorem lobby_play_over_wire {X : Type} (t : Codec (List Nat) X)
    (s : GameSession frensTournament) (cs : List LobbyCmd) :
    runOverWire (g := frensTournament) t (transmit t s) cs
      = some (transmit t { s with state := frensTournament.run s.state cs }) :=
  runOverWire_eq t s cs

/-- Two tabs holding the same transmission hold the same tournament. -/
theorem lobby_transmit_injective {X : Type} (t : Codec (List Nat) X)
    {s₁ s₂ : GameSession frensTournament} (h : transmit t s₁ = transmit t s₂) : s₁ = s₂ :=
  transmit_injective t h

end NixWars
