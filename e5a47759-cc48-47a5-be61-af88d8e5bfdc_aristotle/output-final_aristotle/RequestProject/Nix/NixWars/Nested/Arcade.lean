import RequestProject.Nix.NixWars.Nested.Db
import RequestProject.Nix.NixWars.Merge.World

/-!
# The cabinet in the arcade *is* the database

`Nested/Db.lean` proves that the trading game's `Market` record is a view of a
real database and that a keypress settles a transaction against it.  That is a
statement about the game's own state record.  This file ties it to the cabinet
that actually stands in the merged arcade.

The arcade's third cabinet is the Shard Market (`marketCabinet_is_the_market`),
and `Merge.stepState` steps a cabinet by the very compiled table the board's
WebAssembly module runs.  `stepState_market` says that table, run on a state
vector whose game fields are a trader, is the trading game's own step function;
and `arcade_play_is_trade` puts the two together:

> pressing a key at the trading cabinet **in the arcade** leaves the cabinet
> showing exactly the view of the world's database after the corresponding
> trade has settled in it.

So the cabinet on the floor of the voxel hall is not a simulation of trading —
it is the world's book, drawn as a state vector.
-/

set_option maxRecDepth 100000

namespace NixWars

namespace Nested

/-- Where the trading game stands on the floor of the merged arcade. -/
def marketCabinet : Nat := 2

/-- **The arcade's third cabinet is the Shard Market.** -/
theorem marketCabinet_is_the_market :
    (Merge.cabinets[marketCabinet]?).map (·.name) = some "market" := rfl

/-- Which key of that cabinet's pad plays each command. -/
def cmdIndex : MarketCmd → Nat
  | .buy => 0
  | .sell => 1
  | .hold => 2

/-- **The compiled table in the cabinet is the trading game.**  Stepping the
cabinet's state vector — the three session fields, then the trader — by the
table the board itself runs is stepping the trader. -/
theorem stepState_market (hd : List Nat) (hlen : hd.length = Merge.sessionFields) (s : Market)
    (c : MarketCmd) (arg : Nat) :
    Merge.stepState marketCabinet (hd ++ marketSerialize s) (cmdIndex c) arg
      = hd ++ marketSerialize (marketStep s c) := by
  have htake : (hd ++ marketSerialize s).take Merge.sessionFields = hd := by
    rw [← hlen, List.take_left]
  have hdrop : (hd ++ marketSerialize s).drop Merge.sessionFields = marketSerialize s := by
    rw [← hlen, List.drop_left]
  cases c with
  | buy =>
      have h : Merge.stepState marketCabinet (hd ++ marketSerialize s) (cmdIndex .buy) arg
          = (hd ++ marketSerialize s).take Merge.sessionFields
            ++ runIR (marketStepIR .buy) ((hd ++ marketSerialize s).drop Merge.sessionFields)
                arg := rfl
      rw [h, htake, hdrop, marketStepIR_correct .buy s arg]
      rfl
  | sell =>
      have h : Merge.stepState marketCabinet (hd ++ marketSerialize s) (cmdIndex .sell) arg
          = (hd ++ marketSerialize s).take Merge.sessionFields
            ++ runIR (marketStepIR .sell) ((hd ++ marketSerialize s).drop Merge.sessionFields)
                arg := rfl
      rw [h, htake, hdrop, marketStepIR_correct .sell s arg]
      rfl
  | hold =>
      have h : Merge.stepState marketCabinet (hd ++ marketSerialize s) (cmdIndex .hold) arg
          = (hd ++ marketSerialize s).take Merge.sessionFields
            ++ runIR (marketStepIR .hold) ((hd ++ marketSerialize s).drop Merge.sessionFields)
                arg := rfl
      rw [h, htake, hdrop, marketStepIR_correct .hold s arg]
      rfl

/-- **Playing the trading cabinet in the arcade is trading in the real
database.**  The cabinet's state vector carries the session fields and the view
of caller `o`'s row; pressing a key steps it by the arcade's own compiled table;
and what it lands on is the view of the database *after* the corresponding
transaction has settled in it. -/
theorem arcade_play_is_trade (db : Db) (hwf : WF db) (o : Nat) (a : Account)
    (ha : findAcct db o = some a) (hfloat : 1 ≤ db.float)
    (hhouse : shardPrice db.clock ≤ db.house)
    (hd : List Nat) (hlen : hd.length = Merge.sessionFields) (c : MarketCmd) (arg : Nat) :
    Merge.stepState marketCabinet (hd ++ marketSerialize (view db o)) (cmdIndex c) arg
      = hd ++ marketSerialize (view (applyTx db (txOf o c)) o) := by
  rw [stepState_market hd hlen (view db o) c arg,
    play_is_trade db hwf o a ha hfloat hhouse c]

end Nested

end NixWars
