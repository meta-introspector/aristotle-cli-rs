import RequestProject.Nix.NixWars.Session

/-!
# A fourth door: Legend of the Red Shard

The classic BBS combat door, in the shape the rest of this development uses.
A hero has hit points, gold, a level, and the champion currently in front of
them; `attack` trades a hit for a hit, `heal` buys hit points with gold, `flee`
resets the fight and `rest` recovers slowly.

Everything is a natural number, so "hit points never go negative" is a typing
statement; the content is that death is final (`lordStep_dead`), that a heal
that happens is paid for exactly (`lord_heal_pays`), that the hero never
exceeds the maximum hit points, and that the ladder can actually be climbed
(`lord_levels_up`).

Because it is a `DoorGame` it inherits the stateless session and all five
wires with no new transport code.
-/

namespace NixWars

/-- The hero of Legend of the Red Shard. -/
structure Hero where
  /-- Hit points. Zero means dead, and dead is final. -/
  hp : Nat
  /-- Gold pieces. -/
  gold : Nat
  /-- Level reached on the ladder. -/
  level : Nat
  /-- Hit points left in the champion currently being fought. -/
  foe : Nat
  /-- Turn counter. -/
  turn : Nat
  deriving DecidableEq, Repr, Inhabited

/-- The commands of the door. -/
inductive LordCmd
  | attack
  | heal
  | flee
  | rest
  deriving DecidableEq, Repr, Inhabited

/-- The hero cannot be healed above this. -/
def lordMaxHp : Nat := 59

/-- The champion guarding level `n` has `3n + 2` hit points. -/
def foeHp (level : Nat) : Nat := 3 * level + 2

/-- What a heal costs. -/
def healCost : Nat := 10

/-- What a heal gives. -/
def healGain : Nat := 7

/-- The transition function. Every command is refused outright once the hero is
dead. -/
def lordStep (s : Hero) : LordCmd → Hero
  | .attack =>
      if s.hp = 0 then s
      else if s.foe ≤ s.level then
        { s with gold := s.gold + 2 * s.level, level := s.level + 1,
                 foe := foeHp (s.level + 1), turn := s.turn + 1 }
      else
        { s with hp := s.hp - 1, foe := s.foe - s.level, turn := s.turn + 1 }
  | .heal =>
      if s.hp = 0 then s
      else if healCost ≤ s.gold then
        { s with hp := min lordMaxHp (s.hp + healGain), gold := s.gold - healCost,
                 turn := s.turn + 1 }
      else s
  | .flee =>
      if s.hp = 0 then s
      else { s with foe := foeHp s.level, turn := s.turn + 1 }
  | .rest =>
      if s.hp = 0 then s
      else { s with hp := min lordMaxHp (s.hp + 1), turn := s.turn + 1 }

/-- The hero as a payload. -/
def lordSerialize (s : Hero) : List Nat := [s.hp, s.gold, s.level, s.foe, s.turn]

/-- Reading a hero back from a payload. -/
def lordDeserialize : List Nat → Option Hero
  | [hp, gold, level, foe, turn] =>
      some { hp := hp, gold := gold, level := level, foe := foe, turn := turn }
  | _ => none

theorem lordDeserialize_lordSerialize (s : Hero) :
    lordDeserialize (lordSerialize s) = some s := by
  cases s
  simp [lordSerialize, lordDeserialize]

/-- **Legend of the Red Shard as a door game.** -/
def redShard : DoorGame where
  State := Hero
  Cmd := LordCmd
  step := lordStep
  serialize := lordSerialize
  deserialize := lordDeserialize
  deserialize_serialize := lordDeserialize_lordSerialize

/-- A fresh hero at the bottom of the ladder. -/
def initialHero : Hero :=
  { hp := 20, gold := 10, level := 1, foe := foeHp 1, turn := 0 }

/-! ### Invariants -/

/-- **Death is final.** A hero at zero hit points is frozen: no command of the
door changes anything. -/
theorem lordStep_dead (s : Hero) (h : s.hp = 0) (c : LordCmd) : lordStep s c = s := by
  cases c <;> simp [lordStep, h]

/-- Hit points never rise above the maximum. -/
theorem lordStep_hp_le (s : Hero) (c : LordCmd) (h : s.hp ≤ lordMaxHp) :
    (lordStep s c).hp ≤ lordMaxHp := by
  cases c <;>
    · simp only [lordStep]
      split_ifs <;> first | omega | (dsimp only; omega)

/-- The level never goes down. -/
theorem lordStep_level_ge (s : Hero) (c : LordCmd) : s.level ≤ (lordStep s c).level := by
  cases c <;> · simp only [lordStep]; split_ifs <;> simp

/-- Turns only move forward. -/
theorem lordStep_turn_ge (s : Hero) (c : LordCmd) : s.turn ≤ (lordStep s c).turn := by
  cases c <;> · simp only [lordStep]; split_ifs <;> simp

/-- **A heal is paid for exactly**: the gold left plus the price is the gold
there was, so the door never charges a hero who cannot pay. -/
theorem lord_heal_pays (s : Hero) (halive : s.hp ≠ 0) (h : healCost ≤ s.gold) :
    (lordStep s .heal).gold + healCost = s.gold ∧
      (lordStep s .heal).hp = min lordMaxHp (s.hp + healGain) := by
  simp [lordStep, halive, h]

/-- A heal that cannot be afforded changes nothing. -/
theorem lord_heal_refused (s : Hero) (h : ¬ healCost ≤ s.gold) : lordStep s .heal = s := by
  simp only [lordStep]
  split_ifs <;> rfl

/-- An attack that does not finish the champion costs exactly one hit point. -/
theorem lord_attack_costs_one (s : Hero) (halive : s.hp ≠ 0) (h : ¬ s.foe ≤ s.level) :
    (lordStep s .attack).hp + 1 = s.hp := by
  simp only [lordStep, if_neg halive, if_neg h]
  omega

/-- The level never goes down over a whole session. -/
theorem lord_run_level_ge (s : Hero) (cs : List LordCmd) :
    s.level ≤ (redShard.run s cs).level := by
  induction cs generalizing s with
  | nil => exact le_rfl
  | cons c cs ih => exact le_trans (lordStep_level_ge s c) (ih (lordStep s c))

/-- Hit points stay under the cap over a whole session. -/
theorem lord_run_hp_le (s : Hero) (cs : List LordCmd) (h : s.hp ≤ lordMaxHp) :
    (redShard.run s cs).hp ≤ lordMaxHp := by
  induction cs generalizing s with
  | nil => exact h
  | cons c cs ih => exact ih (lordStep s c) (lordStep_hp_le s c h)

/-- **The ladder can be climbed.** Five attacks from a fresh hero kill the
level-one champion: the hero reaches level two, with gold, and four hit points
spent. -/
theorem lord_levels_up :
    redShard.run initialHero (List.replicate 5 LordCmd.attack) =
      { hp := 16, gold := 12, level := 2, foe := foeHp 2, turn := 5 } := by
  rfl

/-! ### The fourth door inherits the whole BBS -/

/-- A Legend of the Red Shard session as a URL. -/
def lordUrl (s : GameSession redShard) : String := transmit urlTransport s

theorem lordUrl_roundtrip (s : GameSession redShard) :
    receive redShard urlTransport (lordUrl s) = some s :=
  receive_transmit urlTransport s

/-- Legend of the Red Shard is stateless too. -/
theorem lord_play_eq (s : GameSession redShard) (cs : List redShard.Cmd) :
    runOverWire (g := redShard) urlTransport (lordUrl s) cs
      = some (lordUrl { s with state := redShard.run s.state cs }) :=
  runOverWire_eq urlTransport s cs

end NixWars
