import RequestProject.Nix.NixWars.Scene3D

/-!
# One point system for all fifteen games

Every door of the board keeps its own state vector, and every door has its own
idea of what doing well looks like: credits in NixWars, gold in Red Shard, cubes
turned in Monster Q*bert, aliens shot down in Shard Invaders.  Until now those
numbers were incomparable, and a player who left a cabinet left everything they
had earned in it behind.

This file gives all fifteen one currency.

* a **scoring rule** (`ScoreRule`) reads a score out of a door's state vector by
  *name*: a base, fields that pay, and fields that cost.  `rules_name_real_fields`
  checks that every name a rule mentions is a field the door actually has, and
  `fieldIndex_correct` that the index the rule reads is the place that field
  occupies in the door's serialized state (behind the three session fields);
* a **rate** turns a game's own points into shards, the common currency, so that
  scores from different cabinets can be added up.  Every game pays
  (`rates_pos`);
* a **purse** is one record per game.  Crediting a game ratchets: a record never
  falls (`purseCredit_mono`), and only the game played is touched
  (`purseCredit_other`);
* two purses **merge** by taking the better record of each game, which makes the
  purse a join-semilattice: merging is commutative, associative and idempotent
  (`mergePurse_comm`, `mergePurse_assoc`, `mergePurse_idem`), it never loses a
  record (`mergePurse_ge_left`, `mergePurse_ge_right`) and it invents none
  (`mergePurse_least`).  So two sessions of the same player — two browsers, two
  tapes, two nodes of the mail network — can be reconciled in any order and any
  number of times and give the same purse.

`purseTotal` is the purse in shards: each record at its game's rate, added up.
It is monotone in the purse (`purseTotal_mono`), which is what makes a point
earned anywhere spendable everywhere in `Merge/World.lean`.
-/

set_option maxRecDepth 100000

namespace NixWars

namespace Merge

/-! ## Reading a score out of a state vector -/

/-- Every door's serialized state begins with the three session fields — caller,
shard, game — before the game's own fields. -/
def sessionFields : Nat := 3

/-- Where a named game field sits in the door's serialized state vector. -/
def fieldIndex (names : List String) (f : String) : Nat := sessionFields + names.idxOf f

/-- A game's scoring rule: a base, the fields that pay (with their weights) and
the fields that cost. -/
structure ScoreRule where
  /-- Points awarded before any field is read. -/
  base : Nat
  /-- Fields that pay, with their weights. -/
  credits : List (String × Nat)
  /-- Fields that cost, with their weights. -/
  debits : List (String × Nat)
  deriving DecidableEq, Repr, Inhabited

/-- The weighted sum of a list of named fields, read out of a state vector. -/
def weigh (names : List String) (st : List Nat) (terms : List (String × Nat)) : Nat :=
  (terms.map (fun t => t.2 * st.getD (fieldIndex names t.1) 0)).sum

/-- The score a rule reads out of a state vector. -/
def ScoreRule.score (r : ScoreRule) (names : List String) (st : List Nat) : Nat :=
  r.base + weigh names st r.credits - weigh names st r.debits

/-- Every field name a rule mentions. -/
def ScoreRule.mentions (r : ScoreRule) : List String :=
  r.credits.map (·.1) ++ r.debits.map (·.1)

/-! ## The cabinets, with their rules and their rates -/

/-- A cabinet of the merged arcade: the door, its field names, the state it
opens in, its compiled transition table, how it is scored, and the rate at which
its points buy shards. -/
structure Cabinet where
  /-- The door's name on the board. -/
  name : String
  /-- The names of the game's own fields, in order. -/
  names : List String
  /-- The state the cabinet opens in. -/
  init : List Nat
  /-- Its compiled command table. -/
  door : Wasm.DoorIR
  /-- How a state of this cabinet is scored. -/
  rule : ScoreRule
  /-- Shards paid per point of this game's own score. -/
  rate : Nat

/-- The fifteen cabinets, each with its scoring rule and its exchange rate. -/
def cabinets : List Cabinet :=
  [ ⟨"nixwars", fieldNames, sessionSerialize initialSession, Wasm.nixWarsIR,
      ⟨0, [("credits", 1)], []⟩, 1⟩,
    ⟨"dash", dashFieldNames, gsSerialize initialDashSession, Wasm.dashIR,
      ⟨0, [("score", 1)], []⟩, 5⟩,
    ⟨"market", marketFieldNames, gsSerialize initialMarketSession, Wasm.marketIR,
      ⟨0, [("credits", 1)], []⟩, 1⟩,
    ⟨"lord", lordFieldNames, gsSerialize initialLordSession, Wasm.lordIR,
      ⟨0, [("gold", 1), ("level", 10)], []⟩, 2⟩,
    ⟨"hunt", huntFieldNames, gsSerialize initialHuntSession, Wasm.huntIR,
      ⟨0, [("turn", 1), ("alive", 10)], []⟩, 3⟩,
    ⟨"zx81", tapeFieldNames, gsSerialize initialZx81Session, Wasm.zx81IR,
      ⟨0, [("cycles", 1)], []⟩, 1⟩,
    ⟨"frens", lobbyFieldNames, gsSerialize initialLobbySession, Wasm.lobbyIR,
      ⟨0, [("mmc0", 1), ("mmc1", 1), ("mmc2", 1), ("mmc3", 1)], []⟩, 1⟩,
    ⟨"tycoon", tycoonFieldNames, gsSerialize initialTycoonSession, Wasm.tycoonIR,
      ⟨0, [("cash", 1), ("mines", 5), ("forges", 5)], []⟩, 1⟩,
    ⟨"meme", memeFieldNames, gsSerialize initialMemeSession, Wasm.memeIR,
      ⟨0, [("champfit", 1)], []⟩, 2⟩,
    ⟨"hyper", hyperFieldNames, gsSerialize initialHyperSession, Wasm.hyperIR,
      ⟨0, [("level", 1), ("muses", 3)], []⟩, 7⟩,
    ⟨"oracle", oracleFieldNames, gsSerialize initialOracleSession, Wasm.oracleIR,
      ⟨0, [("bounty", 1), ("evidence", 1)], []⟩, 1⟩,
    ⟨"vote", voteFieldNames, gsSerialize initialVoteSession, Wasm.voteIR,
      ⟨0, [("ayes", 1), ("passed", 47)], []⟩, 1⟩,
    ⟨"qbert", qbertFieldNames, gsSerialize initialQbertSession, Wasm.qbertIR,
      ⟨0, [("c0", 1), ("c1", 1), ("c2", 1), ("c3", 1), ("c4", 1), ("c5", 1), ("c6", 1),
        ("c7", 1), ("c8", 1), ("c9", 1)], []⟩, 3⟩,
    ⟨"frontier", frontierFieldNames, gsSerialize initialFrontierSession, Wasm.frontierIR,
      ⟨0, [("docked", 47)], []⟩, 5⟩,
    ⟨"invaders", invadersFieldNames, gsSerialize initialInvadersSession, Wasm.invadersIR,
      ⟨50, [], [("a0", 10), ("a1", 10), ("a2", 10), ("a3", 10), ("a4", 10)]⟩, 2⟩ ]

/-- How many games the merged arcade holds. -/
def numGames : Nat := 15

theorem cabinets_length : cabinets.length = numGames := by decide

/-- The cabinets are the fifteen doors of the board, in the order the 3D arcade
already lists them. -/
theorem cabinets_are_the_doors :
    cabinets.map (·.name) = Scene3D.doorScenes.map (·.1) := by decide

/-- No two cabinets share a name. -/
theorem cabinets_names_nodup : (cabinets.map (·.name)).Nodup := by decide

/-- Every cabinet's state vector is the three session fields followed by the
game's own fields, and its compiled table is written for exactly that many
fields. -/
theorem cabinets_fields_correct :
    ∀ c ∈ cabinets, c.init.length = sessionFields + c.names.length ∧
      c.door.fields = c.names.length := by decide

/-- Every command of every cabinet writes a full state vector back. -/
theorem cabinets_table_widths :
    ∀ c ∈ cabinets, ∀ p ∈ c.door.table, p.2.length = c.names.length := by decide

/-- **The rules score real fields**: every field name a scoring rule mentions is
a field of the door it scores. -/
theorem rules_name_real_fields :
    ∀ c ∈ cabinets, ∀ f ∈ c.rule.mentions, f ∈ c.names := by decide

/-- **And they read it where it lives**: the index a rule reads a field at is the
place that field occupies in the door's serialized state. -/
theorem fieldIndex_correct :
    ∀ c ∈ cabinets, ∀ f ∈ c.rule.mentions,
      c.names[fieldIndex c.names f - sessionFields]? = some f := by decide

/-- Every game pays: no cabinet's points are worthless. -/
theorem rates_pos : ∀ c ∈ cabinets, 0 < c.rate := by decide

/-! ## The purse -/

/-- A fresh purse: no record in any game. -/
def emptyPurse : List Nat := List.replicate numGames 0

/-- A player's record in one game. -/
def purseGet (p : List Nat) (i : Nat) : Nat := p.getD i 0

/-- Record a score in one game: a record never falls, so what is stored is the
better of what was there and what was just scored. -/
def purseCredit (p : List Nat) (i v : Nat) : List Nat := p.set i (max (p.getD i 0) v)

/-- Merge two purses: the better record of each game. -/
def mergePurse (a b : List Nat) : List Nat := List.zipWith max a b

/-- The exchange rates, in cabinet order. -/
def rates : List Nat := cabinets.map (·.rate)

theorem rates_length : rates.length = numGames := by decide

/-- A purse in shards: every record at its game's rate, added up. -/
def purseTotal (p : List Nat) : Nat := (List.zipWith (· * ·) rates p).sum

@[simp] theorem emptyPurse_length : emptyPurse.length = numGames := by
  simp [emptyPurse]

@[simp] theorem purseGet_empty (i : Nat) : purseGet emptyPurse i = 0 := by
  simp [purseGet, emptyPurse, List.getD]

@[simp] theorem purseTotal_empty : purseTotal emptyPurse = 0 := by decide

@[simp] theorem purseCredit_length (p : List Nat) (i v : Nat) :
    (purseCredit p i v).length = p.length := by simp [purseCredit]

/-- Crediting the game just played stores the better of the old record and the
new score. -/
theorem purseCredit_self (p : List Nat) (i v : Nat) (hi : i < p.length) :
    purseGet (purseCredit p i v) i = max (purseGet p i) v := by
  simp [purseCredit, purseGet, List.getD, hi]

/-- Crediting one game leaves every other record alone. -/
theorem purseCredit_other (p : List Nat) (i v j : Nat) (h : j ≠ i) :
    purseGet (purseCredit p i v) j = purseGet p j := by
  simp [purseCredit, purseGet, List.getD, Ne.symm h]

/-- **A record never falls.** -/
theorem purseCredit_mono (p : List Nat) (i v j : Nat) :
    purseGet p j ≤ purseGet (purseCredit p i v) j := by
  by_cases h : j = i
  · subst h
    by_cases hi : j < p.length
    · simp [purseCredit_self p j v hi]
    · simp [purseGet, List.getElem?_eq_none (by omega : p.length ≤ j)]
  · simp [purseCredit_other p i v j h]

/-! ## Merging purses -/

@[simp] theorem mergePurse_length (a b : List Nat) :
    (mergePurse a b).length = min a.length b.length := by
  simp [mergePurse]

theorem purseGet_merge (a b : List Nat) (i : Nat) (ha : i < a.length) (hb : i < b.length) :
    purseGet (mergePurse a b) i = max (purseGet a i) (purseGet b i) := by
  have hi : i < (mergePurse a b).length := by
    simp only [mergePurse_length, lt_min_iff]; omega
  simp only [purseGet, List.getD, mergePurse] at hi ⊢
  rw [List.getElem?_eq_getElem hi, List.getElem?_eq_getElem ha, List.getElem?_eq_getElem hb]
  simp [List.getElem_zipWith]

/-- Merging is commutative: it does not matter which purse is "mine". -/
theorem mergePurse_comm (a b : List Nat) : mergePurse a b = mergePurse b a := by
  unfold mergePurse
  induction a generalizing b with
  | nil => cases b <;> rfl
  | cons x xs ih => cases b with
    | nil => rfl
    | cons y ys => rw [List.zipWith_cons_cons, List.zipWith_cons_cons, Nat.max_comm x y, ih ys]

/-- Merging is associative: three purses reconcile in any order. -/
theorem mergePurse_assoc (a b c : List Nat) :
    mergePurse (mergePurse a b) c = mergePurse a (mergePurse b c) := by
  unfold mergePurse
  induction a generalizing b c with
  | nil => simp
  | cons x xs ih => cases b with
    | nil => simp
    | cons y ys => cases c with
      | nil => simp
      | cons z zs =>
        rw [List.zipWith_cons_cons, List.zipWith_cons_cons, List.zipWith_cons_cons,
          List.zipWith_cons_cons, Nat.max_assoc, ih ys zs]

/-- Merging a purse with itself changes nothing, so a purse may be merged any
number of times. -/
@[simp] theorem mergePurse_idem (a : List Nat) : mergePurse a a = a := by
  unfold mergePurse
  induction a with
  | nil => rfl
  | cons x xs ih => rw [List.zipWith_cons_cons, Nat.max_self, ih]

/-- Merging never loses one of your own records. -/
theorem mergePurse_ge_left (a b : List Nat) (i : Nat) (ha : i < a.length) (hb : i < b.length) :
    purseGet a i ≤ purseGet (mergePurse a b) i := by
  rw [purseGet_merge a b i ha hb]; exact Nat.le_max_left _ _

/-- Nor one of theirs. -/
theorem mergePurse_ge_right (a b : List Nat) (i : Nat) (ha : i < a.length) (hb : i < b.length) :
    purseGet b i ≤ purseGet (mergePurse a b) i := by
  rw [purseGet_merge a b i ha hb]; exact Nat.le_max_right _ _

/-- And it invents nothing: the merge is the *least* purse holding both, so no
record appears that neither player had. -/
theorem mergePurse_least (a b c : List Nat) (i : Nat) (ha : i < a.length) (hb : i < b.length)
    (h1 : purseGet a i ≤ purseGet c i) (h2 : purseGet b i ≤ purseGet c i) :
    purseGet (mergePurse a b) i ≤ purseGet c i := by
  rw [purseGet_merge a b i ha hb]; exact Nat.max_le.2 ⟨h1, h2⟩

/-! ## The total, in shards -/

theorem zipWith_mul_sum_mono : ∀ (r a b : List Nat), a.length = b.length →
    (∀ i, a.getD i 0 ≤ b.getD i 0) →
    (List.zipWith (· * ·) r a).sum ≤ (List.zipWith (· * ·) r b).sum := by
  intro r
  induction r with
  | nil => intro a b _ _; simp
  | cons x xs ih =>
    intro a b hlen hle
    cases a with
    | nil => cases b with
      | nil => simp
      | cons y ys => simp at hlen
    | cons u us => cases b with
      | nil => simp at hlen
      | cons v vs =>
        have h0 : u ≤ v := by simpa [List.getD] using hle 0
        have hrest : ∀ i, us.getD i 0 ≤ vs.getD i 0 := by
          intro i; simpa [List.getD] using hle (i + 1)
        have hind := ih us vs (by simpa using hlen) hrest
        simp only [List.zipWith_cons_cons, List.sum_cons]
        exact Nat.add_le_add (Nat.mul_le_mul_left x h0) hind

/-- **The total is monotone**: a purse that beats another in every game is worth
at least as many shards. -/
theorem purseTotal_mono (a b : List Nat) (hlen : a.length = b.length)
    (h : ∀ i, purseGet a i ≤ purseGet b i) : purseTotal a ≤ purseTotal b :=
  zipWith_mul_sum_mono rates a b hlen h

/-- Crediting a game never lowers the total. -/
theorem purseTotal_credit_mono (p : List Nat) (i v : Nat) :
    purseTotal p ≤ purseTotal (purseCredit p i v) :=
  purseTotal_mono p (purseCredit p i v) (by simp) (fun j => purseCredit_mono p i v j)

/-- Merging two purses is worth at least as much as either. -/
theorem purseTotal_merge_ge_left (a b : List Nat) (hlen : a.length = b.length) :
    purseTotal a ≤ purseTotal (mergePurse a b) := by
  refine purseTotal_mono a (mergePurse a b) (by simp [hlen]) (fun i => ?_)
  by_cases ha : i < a.length
  · exact mergePurse_ge_left a b i ha (by omega)
  · simp [purseGet, List.getElem?_eq_none (by omega : a.length ≤ i)]

theorem purseTotal_merge_ge_right (a b : List Nat) (hlen : a.length = b.length) :
    purseTotal b ≤ purseTotal (mergePurse a b) := by
  rw [mergePurse_comm]
  exact purseTotal_merge_ge_left b a hlen.symm

end Merge

end NixWars
