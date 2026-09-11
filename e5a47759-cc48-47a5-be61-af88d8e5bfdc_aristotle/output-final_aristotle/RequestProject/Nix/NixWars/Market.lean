import RequestProject.Nix.NixWars.Shards

/-!
# A third door: the Shard Market

The board's economy door. A trader holds credits and shards, and the market
quotes one price at a time, cycling through the three largest Monster primes:

```
47, 59, 71, 47, 59, 71, …
```

so the clock, not the player, sets the price. `buy` takes one shard off the
market if it can be paid for, `sell` puts one back, `hold` lets the clock run.
Every command advances the clock, which is what makes the door a game: the
price has moved by the time you can trade again.

What is proved here:

* the quoted price is always a Monster prime (`marketStep_price_mem`), and it
  always agrees with the clock (`marketStep_price_eq`, `run_price_eq`) — the
  price field is exactly `47, 59, 71` indexed by `turn % 3`;
* trades are exact — an accepted buy pays the price with no truncation
  (`marketBuy_credits_exact`), and a refused trade changes nothing
  (`marketBuy_refused`, `marketSell_refused`);
* wealth, measured at the price of the moment, is conserved by every trade
  (`market_value_invariant`): the door creates no credits out of nothing;
* over a whole session credits can grow by at most 71 per command
  (`market_run_credits_bound`) — the market can be beaten, but only at the rate
  of the clock;
* it *can* be beaten: buying at 47 and selling at 59 turns a profit
  (`market_arbitrage`).
-/

namespace NixWars

/-- A trader on the shard market. -/
structure Market where
  /-- Credits in hand. -/
  credits : Nat
  /-- Shards held. -/
  held : Nat
  /-- The price currently quoted. -/
  price : Nat
  /-- Turn counter, which is also the market clock. -/
  turn : Nat
  deriving DecidableEq, Repr, Inhabited

/-- The commands of the market door. -/
inductive MarketCmd
  | buy
  | sell
  | hold
  deriving DecidableEq, Repr, Inhabited

/-- The price quoted on turn `t`: the three largest Monster primes in
rotation. -/
def shardPrice (t : Nat) : Nat :=
  if t % 3 = 0 then 47 else if t % 3 = 1 then 59 else 71

/-- The next quote after `p`. -/
def nextPrice (p : Nat) : Nat := if p = 47 then 59 else if p = 59 then 71 else 47

/-- Every price is a Monster prime. -/
theorem shardPrice_mem_monsterPrimes (t : Nat) : shardPrice t ∈ monsterPrimes := by
  unfold shardPrice
  split_ifs <;> decide

theorem shardPrice_le (t : Nat) : shardPrice t ≤ 71 := by
  unfold shardPrice; split_ifs <;> decide

theorem shardPrice_pos (t : Nat) : 0 < shardPrice t := by
  unfold shardPrice; split_ifs <;> decide

/-- Rotating the quote is stepping the clock. -/
theorem nextPrice_shardPrice (t : Nat) : nextPrice (shardPrice t) = shardPrice (t + 1) := by
  have h : t % 3 = 0 ∨ t % 3 = 1 ∨ t % 3 = 2 := by omega
  have h1 : (t + 1) % 3 = (t % 3 + 1) % 3 := by omega
  rcases h with h | h | h <;> simp [shardPrice, nextPrice, h, h1]

/-- The transition function of the market door. Every command turns the
clock and moves the quote. -/
def marketStep (s : Market) : MarketCmd → Market
  | .buy =>
      if s.price ≤ s.credits then
        { credits := s.credits - s.price, held := s.held + 1,
          price := nextPrice s.price, turn := s.turn + 1 }
      else s
  | .sell =>
      if 1 ≤ s.held then
        { credits := s.credits + s.price, held := s.held - 1,
          price := nextPrice s.price, turn := s.turn + 1 }
      else s
  | .hold => { s with price := nextPrice s.price, turn := s.turn + 1 }

/-- The trader as a payload. -/
def marketSerialize (s : Market) : List Nat := [s.credits, s.held, s.price, s.turn]

/-- Reading a trader back from a payload. -/
def marketDeserialize : List Nat → Option Market
  | [credits, held, price, turn] =>
      some { credits := credits, held := held, price := price, turn := turn }
  | _ => none

theorem marketDeserialize_marketSerialize (s : Market) :
    marketDeserialize (marketSerialize s) = some s := by
  cases s
  simp [marketSerialize, marketDeserialize]

/-- **The shard market as a door game.** -/
def shardMarket : DoorGame where
  State := Market
  Cmd := MarketCmd
  step := marketStep
  serialize := marketSerialize
  deserialize := marketDeserialize
  deserialize_serialize := marketDeserialize_marketSerialize

/-- A fresh trader: 100 credits, nothing held, the clock at zero and the first
Monster prime quoted. -/
def initialMarket : Market := { credits := 100, held := 0, price := 47, turn := 0 }

/-! ## The quote follows the clock -/

/-- The state is *on the clock* when its quote is the one the turn calls for. -/
def OnClock (s : Market) : Prop := s.price = shardPrice s.turn

theorem initialMarket_onClock : OnClock initialMarket := rfl

/-- **Being on the clock is an invariant.** -/
theorem marketStep_price_eq (s : Market) (c : MarketCmd) (h : OnClock s) :
    OnClock (marketStep s c) := by
  simp only [OnClock] at h ⊢
  cases c with
  | buy =>
      by_cases hb : s.price ≤ s.credits
      · simp only [marketStep, if_pos hb]
        simp [h, nextPrice_shardPrice]
      · simpa [marketStep, hb] using h
  | sell =>
      by_cases hb : 1 ≤ s.held
      · simp only [marketStep, if_pos hb]
        simp [h, nextPrice_shardPrice]
      · simpa [marketStep, hb] using h
  | hold =>
      simp only [marketStep]
      simp [h, nextPrice_shardPrice]

/-- The quote is on the clock for a whole session. -/
theorem run_price_eq (s : Market) (cs : List MarketCmd) (h : OnClock s) :
    OnClock (shardMarket.run s cs) := by
  induction cs generalizing s with
  | nil => exact h
  | cons c cs ih => exact ih (marketStep s c) (marketStep_price_eq s c h)

/-- **The quote is always a Monster prime**, for any trader on the clock. -/
theorem marketStep_price_mem (s : Market) (c : MarketCmd) (h : OnClock s) :
    (marketStep s c).price ∈ monsterPrimes := by
  rw [marketStep_price_eq s c h]
  exact shardPrice_mem_monsterPrimes _

/-- On the clock, the quote never exceeds 71. -/
theorem price_le (s : Market) (h : OnClock s) : s.price ≤ 71 := by
  rw [h]; exact shardPrice_le _

/-! ## Trades are exact -/

/-- An accepted buy pays exactly the price: the subtraction never truncates. -/
theorem marketBuy_credits_exact (s : Market) (h : s.price ≤ s.credits) :
    (marketStep s .buy).credits + s.price = s.credits := by
  simp [marketStep, h]

/-- A buy that cannot be paid for changes nothing. -/
theorem marketBuy_refused (s : Market) (h : ¬ s.price ≤ s.credits) :
    marketStep s .buy = s := by simp [marketStep, h]

/-- A sell with nothing to sell changes nothing. -/
theorem marketSell_refused (s : Market) (h : s.held = 0) :
    marketStep s .sell = s := by simp [marketStep, h]

/-- The total value held by a trader, at the price of the moment. -/
def marketValue (s : Market) : Nat := s.credits + s.held * s.price

/-- **Trading creates nothing.** Valued at the price it happens at, a buy or a
sell leaves the trader's wealth exactly where it was. -/
theorem market_value_invariant (s : Market) (c : MarketCmd) (hc : c ≠ .hold) :
    (marketStep s c).credits + (marketStep s c).held * s.price = marketValue s := by
  cases c with
  | buy =>
      by_cases h : s.price ≤ s.credits
      · simp only [marketStep, if_pos h, marketValue]
        have hmul : (s.held + 1) * s.price = s.held * s.price + s.price := by ring
        omega
      · simp [marketStep, h, marketValue]
  | sell =>
      by_cases h : 1 ≤ s.held
      · simp only [marketStep, if_pos h, marketValue]
        obtain ⟨n, hn⟩ : ∃ n, s.held = n + 1 := ⟨s.held - 1, by omega⟩
        rw [hn]
        have hmul : (n + 1) * s.price = n * s.price + s.price := by ring
        simp only [Nat.add_sub_cancel]
        omega
      · simp [marketStep, Nat.lt_one_iff.mp (Nat.not_le.mp h), marketValue]
  | hold => exact absurd rfl hc

/-! ## The clock, and how fast a fortune can grow -/

/-- Turns only move forward. -/
theorem marketStep_turn_le (s : Market) (c : MarketCmd) : s.turn ≤ (marketStep s c).turn := by
  cases c with
  | buy => simp only [marketStep]; split_ifs <;> simp
  | sell => simp only [marketStep]; split_ifs <;> simp
  | hold => simp [marketStep]

/-- No command earns more than the highest price on the board. -/
theorem marketStep_credits_bound (s : Market) (c : MarketCmd) (h : OnClock s) :
    (marketStep s c).credits ≤ s.credits + 71 := by
  have hp : s.price ≤ 71 := price_le s h
  cases c with
  | buy =>
      by_cases hb : s.price ≤ s.credits
      · simp [marketStep, hb]
        omega
      · simp [marketStep, hb]
  | sell =>
      by_cases hb : 1 ≤ s.held
      · simp [marketStep, hb]
        omega
      · simp [marketStep, hb]
  | hold => simp [marketStep]

/-- Holdings change by at most one shard per command. -/
theorem marketStep_held_bound (s : Market) (c : MarketCmd) :
    (marketStep s c).held ≤ s.held + 1 := by
  cases c with
  | buy => simp only [marketStep]; split_ifs <;> simp
  | sell =>
      by_cases h : 1 ≤ s.held
      · simp [marketStep, h]
        omega
      · simp [marketStep, h]
  | hold => simp [marketStep]

/-- **No get-rich-quick scheme.** Over a session of `n` commands, credits grow
by at most `71 * n`: the clock, not cleverness, bounds the profit. -/
theorem market_run_credits_bound (s : Market) (cs : List MarketCmd) (h : OnClock s) :
    (shardMarket.run s cs).credits ≤ s.credits + 71 * cs.length := by
  induction cs generalizing s with
  | nil => exact Nat.le_add_right _ _
  | cons c cs ih =>
      have h1 := ih (marketStep s c) (marketStep_price_eq s c h)
      have h2 := marketStep_credits_bound s c h
      have hrun : shardMarket.run s (c :: cs) = shardMarket.run (marketStep s c) cs := rfl
      rw [hrun]
      calc (shardMarket.run (marketStep s c) cs).credits
          ≤ (marketStep s c).credits + 71 * cs.length := h1
        _ ≤ s.credits + 71 + 71 * cs.length := by omega
        _ = s.credits + 71 * (c :: cs).length := by simp [List.length_cons]; ring

/-! ## The market can be beaten -/

/-- **Arbitrage.** Buy on turn 0 at 47, sell on turn 1 at 59: twelve credits of
profit, and the trader is back to holding nothing. -/
theorem market_arbitrage :
    shardMarket.run initialMarket [.buy, .sell]
      = { credits := 112, held := 0, price := 71, turn := 2 } := by
  rfl

/-- Three round trips of the clock leave the trader better off than they
started. -/
theorem market_profit_grows :
    100 < (shardMarket.run initialMarket
      [.buy, .sell, .hold, .buy, .sell, .hold, .buy, .sell]).credits := by
  decide

/-! ## The third door inherits the whole BBS -/

/-- A market session as a URL. -/
def marketUrl (s : GameSession shardMarket) : String := transmit urlTransport s

theorem marketUrl_roundtrip (s : GameSession shardMarket) :
    receive shardMarket urlTransport (marketUrl s) = some s :=
  receive_transmit urlTransport s

/-- The market door is stateless too: playing over the wire is playing. -/
theorem market_play_eq (s : GameSession shardMarket) (cs : List shardMarket.Cmd) :
    runOverWire (g := shardMarket) urlTransport (marketUrl s) cs
      = some (marketUrl { s with state := shardMarket.run s.state cs }) :=
  runOverWire_eq urlTransport s cs

end NixWars
