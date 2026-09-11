/-!
# Foundation and Empire — a turn-based space-empire game

A 4X game (explore, expand, exploit, exterminate) of the 1980s–2000s kind,
cut down to arithmetic a proof can hold: twelve star systems on the rim of the
71-shard ring, two empires, one move per turn.

A system carries an owner (`0` = unclaimed), a population, an industry level
and the two players' fleets in orbit. An empire carries credits and a
technology level. Five commands:

```
build s        a shipyard on a system you own lays down one hull
jump s d n     n of your hulls cross to another system (1 credit each)
colonise s     a hull in orbit of an unclaimed system plants a colony
research       one technology level
pass           end of turn; after the second player passes, the round produces
```

Everything is deterministic: no dice, no clock, no hidden information. That is
what makes a game *replayable from its log*, which is what the ledger in
`RequestProject.NixWars.Ledger` needs.

The headline facts proved here: an illegal command is a no-op, a finished game
is frozen, the galaxy keeps its twelve systems forever, hulls are only ever
created by `build` (one at a time, paid for), a jump never creates a hull, a
battle annihilates one of the two fleets, an unclaimed system is only claimed
by `colonise`, a system only changes hands when the attacker's fleet survives,
technology and the round counter never go backwards, and the campaign flown by
the built-in autopilot conquers the galaxy.
-/

namespace NixWars

/-- Number of star systems in the galaxy. -/
def numSystems : Nat := 12

/-- Systems a player must hold to win. -/
def victorySystems : Nat := 8

/-- Cost, in credits, of one hull. -/
def shipCost : Nat := 5

/-- Cost, in credits, of planting a colony. -/
def colonyCost : Nat := 20

/-- Cost, in credits, of one technology level. -/
def techCost : Nat := 30

/-- Largest population, and largest industry level, of a system. -/
def sysCap : Nat := 9

/-- A star system. -/
structure Sys where
  /-- `0` if unclaimed, otherwise the player who holds it. -/
  owner : Nat
  /-- Colonists, in billions. -/
  pop : Nat
  /-- Industry level: how many hulls a round of production pays for. -/
  ind : Nat
  /-- Player one's hulls in orbit. -/
  s1 : Nat
  /-- Player two's hulls in orbit. -/
  s2 : Nat
  deriving DecidableEq, Repr, Inhabited

/-- The other player. -/
def foe (p : Nat) : Nat := if p = 1 then 2 else 1

/-- The hulls player `p` has in orbit of a system. -/
def Sys.fleet (s : Sys) (p : Nat) : Nat :=
  if p = 1 then s.s1 else if p = 2 then s.s2 else 0

/-- Set the hulls player `p` has in orbit of a system. -/
def Sys.setFleet (s : Sys) (p n : Nat) : Sys :=
  if p = 1 then { s with s1 := n } else if p = 2 then { s with s2 := n } else s

/-- The galaxy: the systems, the two empires, whose turn it is and who won. -/
structure Galaxy where
  /-- The star systems, always `numSystems` of them. -/
  sys : List Sys
  /-- Player one's credits. -/
  cred1 : Nat
  /-- Player two's credits. -/
  cred2 : Nat
  /-- Player one's technology level. -/
  tech1 : Nat
  /-- Player two's technology level. -/
  tech2 : Nat
  /-- Completed rounds. -/
  round : Nat
  /-- Whose turn it is: `1` or `2`. -/
  active : Nat
  /-- `0` while the game runs, otherwise the winner. -/
  winner : Nat
  deriving DecidableEq, Repr, Inhabited

/-- The credits of player `p`. -/
def Galaxy.cred (g : Galaxy) (p : Nat) : Nat :=
  if p = 1 then g.cred1 else if p = 2 then g.cred2 else 0

/-- Set the credits of player `p`. -/
def Galaxy.setCred (g : Galaxy) (p n : Nat) : Galaxy :=
  if p = 1 then { g with cred1 := n } else if p = 2 then { g with cred2 := n } else g

/-- The technology level of player `p`. -/
def Galaxy.tech (g : Galaxy) (p : Nat) : Nat :=
  if p = 1 then g.tech1 else if p = 2 then g.tech2 else 0

/-- Set the technology level of player `p`. -/
def Galaxy.setTech (g : Galaxy) (p n : Nat) : Galaxy :=
  if p = 1 then { g with tech1 := n } else if p = 2 then { g with tech2 := n } else g

/-- The system at index `i` (an unclaimed empty system outside the galaxy). -/
def Galaxy.sysAt (g : Galaxy) (i : Nat) : Sys := g.sys.getD i default

/-- Replace the system at index `i`. -/
def Galaxy.setAt (g : Galaxy) (i : Nat) (s : Sys) : Galaxy :=
  { g with sys := g.sys.set i s }

/-- How many systems player `p` holds. -/
def Galaxy.holdings (g : Galaxy) (p : Nat) : Nat :=
  (g.sys.filter (fun s => s.owner == p)).length

/-- All the hulls player `p` has anywhere. -/
def Galaxy.hulls (g : Galaxy) (p : Nat) : Nat :=
  (g.sys.map (fun s => s.fleet p)).sum

/-- A command. -/
inductive Move where
  /-- Lay down one hull at a system you hold. -/
  | build (s : Nat)
  /-- Send `n` hulls from one system to another. -/
  | jump (src dst n : Nat)
  /-- Plant a colony on an unclaimed system a hull of yours orbits. -/
  | colonise (s : Nat)
  /-- Buy one technology level. -/
  | research
  /-- End your turn. -/
  | pass
  deriving DecidableEq, Repr, Inhabited

/-- Is the command legal for the player to move? -/
def legal (g : Galaxy) (m : Move) : Bool :=
  if g.winner ≠ 0 then false else
  let p := g.active
  match m with
  | .build s =>
      s < numSystems && (g.sysAt s).owner == p && 1 ≤ (g.sysAt s).ind && shipCost ≤ g.cred p
  | .jump src dst n =>
      src < numSystems && dst < numSystems && src ≠ dst && 1 ≤ n &&
        n ≤ (g.sysAt src).fleet p && n ≤ g.cred p
  | .colonise s =>
      s < numSystems && (g.sysAt s).owner == 0 && 1 ≤ (g.sysAt s).fleet p && colonyCost ≤ g.cred p
  | .research => techCost ≤ g.cred p
  | .pass => true

/-- A battle in orbit: the smaller fleet is destroyed and takes as many of the
larger one with it. If the attacker is left alone above a system its foe held,
the system changes hands and is sacked. -/
def resolve (p : Nat) (s : Sys) : Sys :=
  let a := s.fleet p
  let d := s.fleet (foe p)
  let k := min a d
  let captured := 0 < a - k && d - k == 0 && s.owner == foe p
  { owner := if captured then p else s.owner,
    pop := if captured then s.pop / 2 else s.pop,
    ind := if captured then s.ind / 2 else s.ind,
    s1 := if p = 1 then a - k else if p = 2 then d - k else s.s1,
    s2 := if p = 1 then d - k else if p = 2 then a - k else s.s2 }

/-- Production at one system: a held system grows, builds up its industry and
pays its owner `ind * (2 + tech)` credits. -/
def produceOne (acc : Galaxy × Nat) (s : Sys) : Galaxy × Nat :=
  if s.owner == 0 then (acc.1, acc.2 + 1) else
    let pop := min sysCap (s.pop + 1)
    let ind := if s.ind < pop && s.ind < sysCap then s.ind + 1 else s.ind
    let s' := { s with pop := pop, ind := ind }
    let gain := ind * (2 + acc.1.tech s.owner)
    ((acc.1.setAt acc.2 s').setCred s.owner (acc.1.cred s.owner + gain), acc.2 + 1)

/-- One round of production, over the whole galaxy. -/
def produce (g : Galaxy) : Galaxy :=
  let g := (g.sys.foldl produceOne (g, 0)).1
  { g with round := g.round + 1 }

/-- Has someone won? A player wins by holding `victorySystems` systems, or by
leaving the other empire with none once it had some. -/
def crown (g : Galaxy) : Galaxy :=
  if victorySystems ≤ g.holdings 1 then { g with winner := 1 }
  else if victorySystems ≤ g.holdings 2 then { g with winner := 2 }
  else g

/-- Ending a turn: the first player hands over, the second player's pass ends
the round and the galaxy produces. -/
def endTurn (g : Galaxy) : Galaxy :=
  if g.active = 1 then { g with active := 2 }
  else produce { g with active := 1 }

/-- The effect of a legal command. -/
def apply (g : Galaxy) (m : Move) : Galaxy :=
  let p := g.active
  match m with
  | .build s =>
      let c := g.sysAt s
      let g := g.setAt s (c.setFleet p (c.fleet p + 1))
      g.setCred p (g.cred p - shipCost)
  | .jump src dst n =>
      let a := g.sysAt src
      let g := g.setAt src (a.setFleet p (a.fleet p - n))
      let b := g.sysAt dst
      let g := g.setAt dst (resolve p (b.setFleet p (b.fleet p + n)))
      g.setCred p (g.cred p - n)
  | .colonise s =>
      let c := g.sysAt s
      let c := { c.setFleet p (c.fleet p - 1) with owner := p, pop := 1, ind := 1 }
      let g := g.setAt s c
      g.setCred p (g.cred p - colonyCost)
  | .research => (g.setTech p (g.tech p + 1)).setCred p (g.cred p - techCost)
  | .pass => endTurn g

/-- One move of the game: an illegal command, or a command in a finished game,
changes nothing. -/
def step (g : Galaxy) (m : Move) : Galaxy :=
  if legal g m then crown (apply g m) else g

/-- Replay a log of moves from a starting galaxy. -/
def replay (g : Galaxy) (l : List Move) : Galaxy := l.foldl step g

/-- Every state a log passes through, the starting one first. -/
def states (g : Galaxy) : List Move → List Galaxy
  | [] => [g]
  | m :: rest => g :: states (step g m) rest

/-- Is every move of the log legal where it is played? -/
def legalRun (g : Galaxy) (l : List Move) : Bool :=
  match l with
  | [] => true
  | m :: rest => legal g m && legalRun (step g m) rest

/-- An unclaimed, empty system. -/
def emptySys : Sys := { owner := 0, pop := 0, ind := 0, s1 := 0, s2 := 0 }

/-- A homeworld. -/
def home (p : Nat) : Sys :=
  if p = 1 then { owner := 1, pop := 6, ind := 4, s1 := 2, s2 := 0 }
  else { owner := 2, pop := 6, ind := 4, s1 := 0, s2 := 2 }

/-- The opening position: Terminus at one end of the rim, Trantor at the
other, ten unclaimed systems between them. -/
def genesis : Galaxy :=
  { sys := home 1 :: (List.replicate 10 emptySys ++ [home 2]),
    cred1 := 60, cred2 := 60, tech1 := 0, tech2 := 0,
    round := 0, active := 1, winner := 0 }

/-- The names of the twelve systems, in order. -/
def systemNames : List String :=
  ["TERMINUS", "ANACREON", "SMYRNO", "KALGAN", "SIWENNA", "ASKONE",
   "GLYPTAL IV", "LORIS", "VEGA", "NEOTRANTOR", "SANTANNI", "TRANTOR"]

/-! ## The rules keep their shape -/

theorem systemNames_length : systemNames.length = numSystems := by decide

theorem genesis_length : genesis.sys.length = numSystems := by decide

/-! ## Accessors -/

theorem fleet_setFleet_self {p : Nat} (hp : p = 1 ∨ p = 2) (s : Sys) (n : Nat) :
    (s.setFleet p n).fleet p = n := by
  rcases hp with rfl | rfl <;> rfl

theorem fleet_setFleet_foe {p : Nat} (hp : p = 1 ∨ p = 2) (s : Sys) (n : Nat) :
    (s.setFleet p n).fleet (foe p) = s.fleet (foe p) := by
  rcases hp with rfl | rfl <;> rfl

@[simp] theorem owner_setFleet (s : Sys) (p n : Nat) : (s.setFleet p n).owner = s.owner := by
  unfold Sys.setFleet; repeat (first | rfl | split)

@[simp] theorem pop_setFleet (s : Sys) (p n : Nat) : (s.setFleet p n).pop = s.pop := by
  unfold Sys.setFleet; repeat (first | rfl | split)

@[simp] theorem ind_setFleet (s : Sys) (p n : Nat) : (s.setFleet p n).ind = s.ind := by
  unfold Sys.setFleet; repeat (first | rfl | split)

theorem cred_setCred (g : Galaxy) {p : Nat} (hp : p = 1 ∨ p = 2) (q n : Nat) :
    (g.setCred q n).cred p = if p = q then n else g.cred p := by
  rcases hp with rfl | rfl <;>
    (by_cases hq1 : q = 1 <;> by_cases hq2 : q = 2 <;>
      simp [Galaxy.setCred, Galaxy.cred, hq1, hq2] <;> omega)

theorem cred_setCred_self {p : Nat} (hp : p = 1 ∨ p = 2) (g : Galaxy) (n : Nat) :
    (g.setCred p n).cred p = n := by
  rw [cred_setCred g hp]; simp

theorem tech_setTech (g : Galaxy) {p : Nat} (hp : p = 1 ∨ p = 2) (n : Nat) :
    (g.setTech p n).tech p = n := by
  rcases hp with rfl | rfl <;> rfl

@[simp] theorem tech_setCred (g : Galaxy) (p n q : Nat) : (g.setCred p n).tech q = g.tech q := by
  unfold Galaxy.setCred Galaxy.tech; repeat (first | rfl | split)

@[simp] theorem tech_setAt (g : Galaxy) (i : Nat) (s : Sys) (q : Nat) :
    (g.setAt i s).tech q = g.tech q := by
  unfold Galaxy.setAt Galaxy.tech; repeat (first | rfl | split)

@[simp] theorem sys_setAt (g : Galaxy) (i : Nat) (s : Sys) : (g.setAt i s).sys = g.sys.set i s := rfl

@[simp] theorem cred_setAt (g : Galaxy) (i : Nat) (s : Sys) (p : Nat) :
    (g.setAt i s).cred p = g.cred p := by
  unfold Galaxy.setAt Galaxy.cred; repeat (first | rfl | split)

@[simp] theorem cred_setTech (g : Galaxy) (p n q : Nat) : (g.setTech p n).cred q = g.cred q := by
  unfold Galaxy.setTech Galaxy.cred; repeat (first | rfl | split)

theorem sysAt_setAt_self {g : Galaxy} {i : Nat} (h : i < g.sys.length) (s : Sys) :
    (g.setAt i s).sysAt i = s := by
  simp [Galaxy.sysAt, Galaxy.setAt, List.getD_eq_getElem?_getD, List.getElem?_set_self h]

theorem sysAt_setAt_other (g : Galaxy) {i j : Nat} (h : i ≠ j) (s : Sys) :
    (g.setAt i s).sysAt j = g.sysAt j := by
  simp [Galaxy.sysAt, Galaxy.setAt, List.getD_eq_getElem?_getD, List.getElem?_set_ne h]

theorem sysAt_setAt_oob {g : Galaxy} {i : Nat} (h : g.sys.length ≤ i) (s : Sys) (j : Nat) :
    (g.setAt i s).sysAt j = g.sysAt j := by
  simp [Galaxy.sysAt, Galaxy.setAt, List.set_eq_of_length_le h]

@[simp] theorem sysAt_setCred (g : Galaxy) (p n i : Nat) : (g.setCred p n).sysAt i = g.sysAt i := by
  unfold Galaxy.setCred Galaxy.sysAt; repeat (first | rfl | split)

@[simp] theorem sysAt_setTech (g : Galaxy) (p n i : Nat) : (g.setTech p n).sysAt i = g.sysAt i := by
  unfold Galaxy.setTech Galaxy.sysAt; repeat (first | rfl | split)

@[simp] theorem winner_setCred (g : Galaxy) (p n : Nat) : (g.setCred p n).winner = g.winner := by
  unfold Galaxy.setCred; repeat (first | rfl | split)

@[simp] theorem winner_setTech (g : Galaxy) (p n : Nat) : (g.setTech p n).winner = g.winner := by
  unfold Galaxy.setTech; repeat (first | rfl | split)

@[simp] theorem winner_setAt (g : Galaxy) (i : Nat) (s : Sys) : (g.setAt i s).winner = g.winner := rfl

@[simp] theorem active_setCred (g : Galaxy) (p n : Nat) : (g.setCred p n).active = g.active := by
  unfold Galaxy.setCred; repeat (first | rfl | split)

@[simp] theorem active_setTech (g : Galaxy) (p n : Nat) : (g.setTech p n).active = g.active := by
  unfold Galaxy.setTech; repeat (first | rfl | split)

@[simp] theorem active_setAt (g : Galaxy) (i : Nat) (s : Sys) : (g.setAt i s).active = g.active := rfl

@[simp] theorem round_setCred (g : Galaxy) (p n : Nat) : (g.setCred p n).round = g.round := by
  unfold Galaxy.setCred; repeat (first | rfl | split)

@[simp] theorem round_setTech (g : Galaxy) (p n : Nat) : (g.setTech p n).round = g.round := by
  unfold Galaxy.setTech; repeat (first | rfl | split)

@[simp] theorem round_setAt (g : Galaxy) (i : Nat) (s : Sys) : (g.setAt i s).round = g.round := rfl

@[simp] theorem setAt_length (g : Galaxy) (i : Nat) (s : Sys) :
    (g.setAt i s).sys.length = g.sys.length := by
  simp [Galaxy.setAt]

@[simp] theorem setCred_sys (g : Galaxy) (p n : Nat) : (g.setCred p n).sys = g.sys := by
  unfold Galaxy.setCred; repeat (first | rfl | split)

@[simp] theorem setTech_sys (g : Galaxy) (p n : Nat) : (g.setTech p n).sys = g.sys := by
  unfold Galaxy.setTech; repeat (first | rfl | split)

theorem produceOne_length (acc : Galaxy × Nat) (s : Sys) :
    (produceOne acc s).1.sys.length = acc.1.sys.length := by
  unfold produceOne; split <;> simp

theorem produceOne_active (acc : Galaxy × Nat) (s : Sys) :
    (produceOne acc s).1.active = acc.1.active := by
  unfold produceOne Galaxy.setCred Galaxy.setAt; split <;> repeat (first | rfl | split)

theorem produceOne_over (acc : Galaxy × Nat) (s : Sys) :
    (produceOne acc s).1.winner = acc.1.winner := by
  unfold produceOne Galaxy.setCred Galaxy.setAt; split <;> repeat (first | rfl | split)

theorem produceOne_round (acc : Galaxy × Nat) (s : Sys) :
    (produceOne acc s).1.round = acc.1.round := by
  unfold produceOne Galaxy.setCred Galaxy.setAt; split <;> repeat (first | rfl | split)

theorem produceOne_cred (acc : Galaxy × Nat) (s : Sys) {p : Nat} (hp : p = 1 ∨ p = 2) :
    acc.1.cred p ≤ (produceOne acc s).1.cred p := by
  unfold produceOne
  split
  · exact Nat.le_refl _
  · simp only [cred_setCred _ hp, cred_setAt]
    split
    · rename_i h; rw [h]; omega
    · exact Nat.le_refl _

theorem fold_produce_length (l : List Sys) (acc : Galaxy × Nat) :
    (l.foldl produceOne acc).1.sys.length = acc.1.sys.length := by
  induction l generalizing acc with
  | nil => rfl
  | cons a t ih => simp only [List.foldl_cons]; rw [ih, produceOne_length]

theorem fold_produce_active (l : List Sys) (acc : Galaxy × Nat) :
    (l.foldl produceOne acc).1.active = acc.1.active := by
  induction l generalizing acc with
  | nil => rfl
  | cons a t ih => simp only [List.foldl_cons]; rw [ih, produceOne_active]

theorem fold_produce_over (l : List Sys) (acc : Galaxy × Nat) :
    (l.foldl produceOne acc).1.winner = acc.1.winner := by
  induction l generalizing acc with
  | nil => rfl
  | cons a t ih => simp only [List.foldl_cons]; rw [ih, produceOne_over]

theorem fold_produce_round (l : List Sys) (acc : Galaxy × Nat) :
    (l.foldl produceOne acc).1.round = acc.1.round := by
  induction l generalizing acc with
  | nil => rfl
  | cons a t ih => simp only [List.foldl_cons]; rw [ih, produceOne_round]

theorem fold_produce_cred (l : List Sys) (acc : Galaxy × Nat) {p : Nat} (hp : p = 1 ∨ p = 2) :
    acc.1.cred p ≤ (l.foldl produceOne acc).1.cred p := by
  induction l generalizing acc with
  | nil => exact Nat.le_refl _
  | cons a t ih =>
      simp only [List.foldl_cons]
      exact Nat.le_trans (produceOne_cred acc a hp) (ih _)

theorem produce_length (g : Galaxy) : (produce g).sys.length = g.sys.length := by
  simpa [produce] using fold_produce_length g.sys (g, 0)

theorem produce_active (g : Galaxy) : (produce g).active = g.active := by
  simpa [produce] using fold_produce_active g.sys (g, 0)

theorem produce_over (g : Galaxy) : (produce g).winner = g.winner := by
  simpa [produce] using fold_produce_over g.sys (g, 0)

/-- A round of production never costs a player a credit. -/
theorem produce_cred {p : Nat} (hp : p = 1 ∨ p = 2) (g : Galaxy) :
    g.cred p ≤ (produce g).cred p := by
  have h := fold_produce_cred g.sys (g, 0) hp
  rcases hp with hh | hh <;> subst hh <;> simpa [produce, Galaxy.cred] using h

@[simp] theorem endTurn_length (g : Galaxy) : (endTurn g).sys.length = g.sys.length := by
  unfold endTurn
  split
  · rfl
  · rw [produce_length]

@[simp] theorem endTurn_winner (g : Galaxy) : (endTurn g).winner = g.winner := by
  unfold endTurn
  split
  · rfl
  · rw [produce_over]

theorem apply_length (g : Galaxy) (m : Move) : (apply g m).sys.length = g.sys.length := by
  cases m <;> simp [apply]

theorem crown_length (g : Galaxy) : (crown g).sys.length = g.sys.length := by
  unfold crown; repeat (first | rfl | split)

/-- The galaxy never gains or loses a star system. -/
theorem step_length (g : Galaxy) (m : Move) : (step g m).sys.length = g.sys.length := by
  unfold step; split
  · rw [crown_length, apply_length]
  · rfl

/-- The galaxy never gains or loses a star system, however long the log. -/
theorem replay_length (g : Galaxy) (l : List Move) : (replay g l).sys.length = g.sys.length := by
  induction l generalizing g with
  | nil => rfl
  | cons m t ih => simp [replay, List.foldl_cons] at *; rw [ih, step_length]

/-- An illegal command changes nothing. -/
theorem step_illegal {g : Galaxy} {m : Move} (h : legal g m = false) : step g m = g := by
  simp [step, h]

/-- A finished game is frozen: no command changes it, ever. -/
theorem step_over {g : Galaxy} (h : g.winner ≠ 0) (m : Move) : step g m = g := by
  apply step_illegal
  simp [legal, h]

/-- A finished game is frozen for the whole rest of the log. -/
theorem replay_over {g : Galaxy} (h : g.winner ≠ 0) (l : List Move) : replay g l = g := by
  induction l generalizing g with
  | nil => rfl
  | cons m t ih => simp only [replay, List.foldl_cons]; rw [step_over h m]; exact ih h

/-- Replaying a log one move longer is one more step. -/
theorem replay_append (g : Galaxy) (l : List Move) (m : Move) :
    replay g (l ++ [m]) = step (replay g l) m := by
  simp [replay]

/-- The list of states of a log always starts with the starting state. -/
theorem states_cons (g : Galaxy) (l : List Move) : ∃ r, states g l = g :: r := by
  cases l <;> exact ⟨_, rfl⟩

/-- The recorded states really are the states the log passes through: the last
one is the state the log replays to. -/
theorem states_getLast (g : Galaxy) (l : List Move) :
    (states g l).getLast? = some (replay g l) := by
  induction l generalizing g with
  | nil => rfl
  | cons m t ih =>
      have h : states g (m :: t) = g :: states (step g m) t := rfl
      obtain ⟨r, hr⟩ := states_cons (step g m) t
      rw [h, hr, List.getLast?_cons_cons, ← hr]
      simpa [replay, List.foldl_cons] using ih (step g m)

theorem states_length (g : Galaxy) (l : List Move) : (states g l).length = l.length + 1 := by
  induction l generalizing g with
  | nil => rfl
  | cons m t ih =>
      have h : states g (m :: t) = g :: states (step g m) t := rfl
      simp [h, ih]

/-! ## The crown and the clock -/

@[simp] theorem crown_round (g : Galaxy) : (crown g).round = g.round := by
  unfold crown; repeat (first | rfl | split)

@[simp] theorem crown_active (g : Galaxy) : (crown g).active = g.active := by
  unfold crown; repeat (first | rfl | split)

@[simp] theorem crown_sysAt (g : Galaxy) (i : Nat) : (crown g).sysAt i = g.sysAt i := by
  unfold crown Galaxy.sysAt; repeat (first | rfl | split)

@[simp] theorem crown_cred (g : Galaxy) (p : Nat) : (crown g).cred p = g.cred p := by
  unfold crown Galaxy.cred; repeat (first | rfl | split)

@[simp] theorem crown_tech (g : Galaxy) (p : Nat) : (crown g).tech p = g.tech p := by
  unfold crown Galaxy.tech; repeat (first | rfl | split)

theorem produce_round (g : Galaxy) : (produce g).round = g.round + 1 := by
  have h := fold_produce_round g.sys (g, 0)
  simp [produce, h]

/-- The round counter never goes backwards. -/
theorem step_round (g : Galaxy) (m : Move) : g.round ≤ (step g m).round := by
  have hap : ∀ m : Move, g.round ≤ (apply g m).round := by
    intro m
    cases m with
    | build s => simp [apply]
    | jump a b n => simp [apply]
    | colonise s => simp [apply]
    | research => simp [apply]
    | pass =>
        show g.round ≤ (endTurn g).round
        unfold endTurn
        split
        · simp
        · rw [produce_round]; simp
  unfold step
  split
  · rw [crown_round]; exact hap m
  · exact Nat.le_refl _

/-- Whoever is to move is always one of the two players. -/
theorem step_active {g : Galaxy} (h : g.active = 1 ∨ g.active = 2) (m : Move) :
    (step g m).active = 1 ∨ (step g m).active = 2 := by
  have hap : (apply g m).active = 1 ∨ (apply g m).active = 2 := by
    cases m with
    | build s => simpa [apply] using h
    | jump a b n => simpa [apply] using h
    | colonise s => simpa [apply] using h
    | research => simpa [apply] using h
    | pass =>
        show (endTurn g).active = 1 ∨ (endTurn g).active = 2
        unfold endTurn
        split
        · exact Or.inr rfl
        · rw [produce_active]; exact Or.inl rfl
  unfold step
  split
  · rw [crown_active]; exact hap
  · exact h

/-- The active player always has one of the two treasuries. -/
theorem genesis_active : genesis.active = 1 := rfl

/-! ## Battles -/

theorem foe_ne {p : Nat} (hp : p = 1 ∨ p = 2) : foe p ≠ p := by
  rcases hp with rfl | rfl <;> decide

theorem foe_mem {p : Nat} (hp : p = 1 ∨ p = 2) : foe p = 1 ∨ foe p = 2 := by
  rcases hp with rfl | rfl <;> decide

/-- A battle annihilates at least one of the two fleets. -/
theorem resolve_annihilates {p : Nat} (hp : p = 1 ∨ p = 2) (s : Sys) :
    (resolve p s).fleet p = 0 ∨ (resolve p s).fleet (foe p) = 0 := by
  rcases hp with rfl | rfl <;> simp [resolve, Sys.fleet, foe] <;> omega

/-- A battle never adds a hull to either fleet. -/
theorem resolve_le {p q : Nat} (hp : p = 1 ∨ p = 2) (hq : q = 1 ∨ q = 2) (s : Sys) :
    (resolve p s).fleet q ≤ s.fleet q := by
  rcases hp with rfl | rfl <;> rcases hq with rfl | rfl <;>
    simp [resolve, Sys.fleet, foe] <;> omega

/-- A system only changes hands in a battle if the attacker still has a hull
in orbit and the defender has none. -/
theorem resolve_owner {p : Nat} (hp : p = 1 ∨ p = 2) (s : Sys)
    (h : (resolve p s).owner ≠ s.owner) :
    (resolve p s).owner = p ∧ 0 < (resolve p s).fleet p ∧ (resolve p s).fleet (foe p) = 0 := by
  rcases hp with rfl | rfl <;>
    (simp only [resolve, Sys.fleet, foe] at h ⊢
     split at h <;> simp_all <;> omega)

/-! ## What a command can and cannot do -/

/-- Building a hull changes nobody's flag. -/
theorem build_owner (g : Galaxy) (s i : Nat) :
    ((apply g (.build s)).sysAt i).owner = (g.sysAt i).owner := by
  by_cases h : s = i
  · subst h
    by_cases hs : s < g.sys.length
    · simp [apply, sysAt_setAt_self hs]
    · simp [apply, sysAt_setAt_oob (Nat.le_of_not_lt hs)]
  · simp [apply, sysAt_setAt_other g h]

/-- Buying technology changes nobody's flag. -/
theorem research_owner (g : Galaxy) (i : Nat) :
    ((apply g .research).sysAt i).owner = (g.sysAt i).owner := by
  simp [apply]

/-- Buying technology raises the buyer's level by exactly one. -/
theorem research_tech {g : Galaxy} (hp : g.active = 1 ∨ g.active = 2) :
    (apply g .research).tech g.active = g.tech g.active + 1 := by
  simpa [apply] using tech_setTech g hp (g.tech g.active + 1)

/-- And is paid for. -/
theorem research_costs {g : Galaxy} (hp : g.active = 1 ∨ g.active = 2) :
    (apply g .research).cred g.active = g.cred g.active - techCost := by
  simp [apply, cred_setCred_self hp]

/-- Building a hull puts exactly one hull in orbit of the yard. -/
theorem build_adds_one {g : Galaxy} {s : Nat} (hp : g.active = 1 ∨ g.active = 2)
    (hs : s < g.sys.length) :
    ((apply g (.build s)).sysAt s).fleet g.active = (g.sysAt s).fleet g.active + 1 := by
  simp [apply, sysAt_setAt_self hs, fleet_setFleet_self hp]

/-- Building a hull touches no other system. -/
theorem build_elsewhere (g : Galaxy) {s i : Nat} (h : s ≠ i) :
    (apply g (.build s)).sysAt i = g.sysAt i := by
  simp [apply, sysAt_setAt_other g h]

/-- A hull is paid for. -/
theorem build_costs {g : Galaxy} {s : Nat} (hp : g.active = 1 ∨ g.active = 2) :
    (apply g (.build s)).cred g.active = g.cred g.active - shipCost := by
  simp [apply, cred_setCred_self hp]

/-- A colony can only be planted on an unclaimed system. -/
theorem colonise_neutral {g : Galaxy} {s : Nat} (h : legal g (.colonise s) = true) :
    (g.sysAt s).owner = 0 := by
  unfold legal at h
  split at h
  · exact absurd h (by simp)
  · simp only [Bool.and_eq_true, beq_iff_eq, decide_eq_true_eq] at h
    exact h.1.1.2

/-- A planted colony flies the flag of the player who planted it. -/
theorem colonise_claims {g : Galaxy} {s : Nat} (hs : s < g.sys.length) :
    ((apply g (.colonise s)).sysAt s).owner = g.active := by
  simp [apply, sysAt_setAt_self hs]

/-- Planting a colony touches no other system. -/
theorem colonise_elsewhere (g : Galaxy) {s i : Nat} (h : s ≠ i) :
    (apply g (.colonise s)).sysAt i = g.sysAt i := by
  simp [apply, sysAt_setAt_other g h]

/-- A jump touches no system but the two it joins. -/
theorem jump_elsewhere (g : Galaxy) {src dst i n : Nat} (h1 : src ≠ i) (h2 : dst ≠ i) :
    (apply g (.jump src dst n)).sysAt i = g.sysAt i := by
  simp [apply, sysAt_setAt_other _ h2, sysAt_setAt_other _ h1]

/-- A jump costs one credit a hull. -/
theorem jump_costs {g : Galaxy} {src dst n : Nat} (hp : g.active = 1 ∨ g.active = 2) :
    (apply g (.jump src dst n)).cred g.active = g.cred g.active - n := by
  simp [apply, cred_setCred_self hp]

/-! ## Two admirals

The Foundation, on Terminus at the rim, expands towards the core; the Empire,
on Trantor, expands towards the rim and then digs in, massing hulls on its
frontier world. Neither admiral is a recorded tape: both are policies, and the
campaign below is what they play.
-/

/-- The first system, in a given order of preference, passing a test. -/
def firstOf (g : Galaxy) (order : List Nat) (p : Sys → Bool) : Option Nat :=
  order.find? (fun i => p (g.sysAt i))

/-- Terminus outwards. -/
def rimOrder : List Nat := List.range numSystems

/-- Trantor outwards. -/
def coreOrder : List Nat := (List.range numSystems).reverse

/-- Lay down a hull at the first yard in the order, keeping `reserve` credits
back for what the hull is for; otherwise end the turn. -/
def buildOrPass (p : Nat) (order : List Nat) (g : Galaxy) (reserve : Nat) : Move :=
  match firstOf g order (fun s => s.owner == p && 1 ≤ s.ind) with
  | some i => if shipCost + reserve ≤ g.cred p then .build i else .pass
  | none => .pass

/-- An admiral: claim what you can reach, and when there is nothing left to
claim, take it from the other empire. `cap` is the number of systems this
admiral is content with before it stops colonising and arms instead. -/
def admiral (p : Nat) (order border : List Nat) (cap : Nat) (g : Galaxy) : Move :=
  if g.active != p then .pass else
  let cred := g.cred p
  if cap ≤ g.holdings p then buildOrPass p border g 0 else
  match firstOf g order (fun s => s.owner == 0 && 1 ≤ s.fleet p) with
  | some i => if colonyCost ≤ cred then .colonise i else .pass
  | none =>
  match firstOf g order (fun s => s.owner == 0) with
  | some dst =>
      match firstOf g order (fun s => 1 ≤ s.fleet p) with
      | some src => if colonyCost + 1 ≤ cred && src != dst then .jump src dst 1
                    else buildOrPass p order g colonyCost
      | none => buildOrPass p order g colonyCost
  | none =>
  match firstOf g order (fun s => s.owner == foe p) with
  | some tgt =>
      let need := (g.sysAt tgt).fleet (foe p) + 1
      match firstOf g order (fun s => need ≤ s.fleet p) with
      | some src => if need ≤ cred && src != tgt then .jump src tgt need
                    else buildOrPass p border g 0
      | none => buildOrPass p border g 0
  | none => .pass

/-- Whoever is to move, plays. -/
def duel (g : Galaxy) : Move :=
  if g.active == 1 then admiral 1 rimOrder rimOrder numSystems g
  else admiral 2 coreOrder rimOrder 5 g

/-- The log the two admirals play, `n` commands of it. -/
def autoLog (g : Galaxy) : Nat → List Move
  | 0 => []
  | n + 1 => let m := duel g; m :: autoLog (step g m) n

/-- The campaign: the seventy-eight commands the two admirals play. -/
def campaign : List Move := autoLog genesis 78

/-! ## What the campaign proves

Every one of the seventy-eight commands is legal where it is played, the
Foundation ends the campaign holding eight of the twelve systems, and it does
not hold eight a command sooner: the last command is the battle of Loris,
where twenty-one Foundation hulls meet the twenty the Empire had massed there,
and the one that survives takes the system.
-/

set_option maxRecDepth 100000

theorem campaign_length : campaign.length = 78 := by decide

theorem campaign_legal : legalRun genesis campaign = true := by decide

/-- The Foundation wins. -/
theorem foundation_wins : (replay genesis campaign).winner = 1 := by decide

theorem foundation_holds_eight : (replay genesis campaign).holdings 1 = 8 := by decide

theorem empire_holds_four : (replay genesis campaign).holdings 2 = 4 := by decide

/-- And not a command sooner. -/
theorem campaign_tight : (replay genesis (campaign.take 77)).winner = 0 := by decide

/-- The last command of the campaign is the attack on Loris. -/
theorem campaign_last : campaign.getLast? = some (Move.jump 0 7 21) := by decide

/-- Before it, Loris is Imperial and twenty hulls are massed over it. -/
theorem loris_defended :
    ((replay genesis (campaign.take 77)).sysAt 7).owner = 2 ∧
      ((replay genesis (campaign.take 77)).sysAt 7).s2 = 20 := by decide

/-- After it, Loris is the Foundation's, one hull survives, and the Empire's
fleet there is gone. -/
theorem loris_taken :
    ((replay genesis campaign).sysAt 7).owner = 1 ∧
      ((replay genesis campaign).sysAt 7).s1 = 1 ∧
      ((replay genesis campaign).sysAt 7).s2 = 0 := by decide

/-- Five rounds pass. -/
theorem campaign_rounds : (replay genesis campaign).round = 5 := by decide

end NixWars
