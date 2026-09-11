import RequestProject.Nix.NixWars.Nested.Db

/-!
# Nested worlds: a game inside a game

`Nested/Db.lean` gave the arcade's trading cabinet a real database to trade in.
This file gives the *world* the same treatment one level down.  A `Tower` is a
stack of worlds, outermost first: level `0` is the world you are standing in,
level `1` is the miniature world standing inside one of its cabinets (which
cabinet is the level's `slot`), level `2` is the miniature world inside one of
*its* cabinets, and so on.  Every level is a world in its own right, with its
own database, its own accounts and its own market.

What is proved:

* **every level is a real world.**  `playAt_is_trade` is `play_is_trade` at
  depth `k`: at any level of the nest, pressing a key at the trading cabinet
  settles a transaction against *that world's* database and the screen is the
  view of it.  A game inside a game is not a mock-up.
* **the levels do not leak into each other.**  Playing at level `k` leaves every
  other level exactly as it was (`playAt_other_level`), leaves the shape of the
  nest alone (`playAt_depth`, `playAt_slots`), and keeps each level's book
  balanced (`playAt_credits`, `playAt_shards`).
* **cashing out of a miniature world is not a money pump.**  `cashOut` moves
  `n * miniRate` shards inside the little world into `n` shards in the big one.
  Each world's own books still balance (`cashOut_shards_outer`,
  `cashOut_shards_inner`, `cashOut_credits`), the player's holdings measured in
  the small world's unit are exactly what they were (`cashOut_two_level_worth`),
  and, measured across the whole nest, the player's worth is unchanged
  (`cashOut_worth`) — you cannot get rich by walking into the arcade inside the
  arcade.
* **the nest is finite** (`dbAt_eq_none`): below the last level there is no
  world, so the regress stops.
-/

set_option maxRecDepth 4000

namespace NixWars

namespace Nested

/-! ## The nest -/

/-- One world of the nest: its database, and which cabinet of the world above
it stands in. -/
structure Level where
  /-- This world's own database. -/
  db : Db
  /-- Which cabinet of the world above this world stands in. -/
  slot : Nat
  deriving DecidableEq, Repr, Inhabited

/-- A stack of worlds, outermost first: the world you stand in, the miniature
world inside one of its cabinets, the miniature world inside one of *its*
cabinets, and so on. -/
structure Tower where
  /-- The worlds, outermost first. -/
  levels : List Level
  deriving DecidableEq, Repr, Inhabited

/-- How many worlds deep the nest goes. -/
def Tower.depth (t : Tower) : Nat := t.levels.length

/-- The database of the world `k` levels down, if there is one. -/
def dbAt (t : Tower) (k : Nat) : Option Db := (t.levels[k]?).map (·.db)

/-- **The nest is finite**: below the last world there is nothing. -/
theorem dbAt_eq_none (t : Tower) (k : Nat) (h : t.depth ≤ k) : dbAt t k = none := by
  simp only [dbAt, List.getElem?_eq_none (by simpa [Tower.depth] using h), Option.map_none]

/-- Change the world `k` levels down and no other. -/
def modifyLevel (t : Tower) (k : Nat) (f : Level → Level) : Tower :=
  match t.levels[k]? with
  | some l => ⟨t.levels.set k (f l)⟩
  | none => t

theorem modifyLevel_depth (t : Tower) (k : Nat) (f : Level → Level) :
    (modifyLevel t k f).depth = t.depth := by
  simp only [modifyLevel, Tower.depth]
  cases h : t.levels[k]? <;> simp [List.length_set]

theorem modifyLevel_self {t : Tower} {k : Nat} {l : Level} (h : t.levels[k]? = some l)
    (f : Level → Level) : (modifyLevel t k f).levels[k]? = some (f l) := by
  have hk : k < t.levels.length := by
    by_contra hc
    rw [List.getElem?_eq_none (by omega)] at h
    simp at h
  simp only [modifyLevel, h]
  exact List.getElem?_set_self hk

theorem modifyLevel_ne (t : Tower) (k : Nat) (f : Level → Level) {j : Nat} (hj : j ≠ k) :
    (modifyLevel t k f).levels[j]? = t.levels[j]? := by
  simp only [modifyLevel]
  cases h : t.levels[k]? with
  | none => rfl
  | some l => exact List.getElem?_set_ne (fun hc => hj hc.symm)

/-! ## Playing at a level -/

/-- Settle a transaction in the world `k` levels down. -/
def playAt (t : Tower) (k : Nat) (tx : Tx) : Tower :=
  modifyLevel t k (fun l => { l with db := applyTx l.db tx })

/-- Playing changes nothing about the shape of the nest. -/
theorem playAt_depth (t : Tower) (k : Nat) (tx : Tx) : (playAt t k tx).depth = t.depth :=
  modifyLevel_depth t k _

/-- Playing never moves a world to a different cabinet. -/
theorem playAt_slots (t : Tower) (k : Nat) (tx : Tx) (j : Nat) :
    ((playAt t k tx).levels[j]?).map (·.slot) = (t.levels[j]?).map (·.slot) := by
  by_cases hj : j = k
  · subst hj
    cases h : t.levels[j]? with
    | none => simp [playAt, modifyLevel, h]
    | some l => rw [playAt, modifyLevel_self h]; simp
  · rw [playAt, modifyLevel_ne t k _ hj]

/-- The world you played in, after the trade. -/
theorem dbAt_playAt_self {t : Tower} {k : Nat} {l : Level} (h : t.levels[k]? = some l) (tx : Tx) :
    dbAt (playAt t k tx) k = some (applyTx l.db tx) := by
  simp [dbAt, playAt, modifyLevel_self h]

/-- **The levels do not leak into each other**: a trade in one world leaves
every other world of the nest exactly as it was. -/
theorem playAt_other_level (t : Tower) (k : Nat) (tx : Tx) {j : Nat} (hj : j ≠ k) :
    dbAt (playAt t k tx) j = dbAt t j := by
  simp [dbAt, playAt, modifyLevel_ne t k _ hj]

/-- Every world of the nest keeps one row per caller. -/
def TowerWF (t : Tower) : Prop := ∀ l ∈ t.levels, WF l.db

theorem playAt_wf (t : Tower) (hwf : TowerWF t) (k : Nat) (tx : Tx) : TowerWF (playAt t k tx) := by
  intro l hl
  simp only [playAt, modifyLevel] at hl
  cases h : t.levels[k]? with
  | none => rw [h] at hl; exact hwf l hl
  | some l0 =>
      rw [h] at hl
      rcases List.mem_or_eq_of_mem_set hl with hmem | hmem
      · exact hwf l hmem
      · rw [hmem]
        exact applyTx_wf l0.db (hwf l0 (List.mem_of_getElem? h)) tx

/-- **Every world's book balances**, at whatever depth it is played. -/
theorem playAt_credits {t : Tower} (hwf : TowerWF t) {k : Nat} {l : Level}
    (h : t.levels[k]? = some l) (tx : Tx) :
    totalCredits (applyTx l.db tx) = totalCredits l.db :=
  applyTx_credits l.db (hwf l (List.mem_of_getElem? h)) tx

theorem playAt_shards {t : Tower} (hwf : TowerWF t) {k : Nat} {l : Level}
    (h : t.levels[k]? = some l) (tx : Tx) :
    totalShards (applyTx l.db tx) = totalShards l.db :=
  applyTx_shards l.db (hwf l (List.mem_of_getElem? h)) tx

/-- **A game inside a game is a real game.**  At any depth of the nest, the
trading cabinet of that world is a view of that world's own database, and
pressing a key at it settles the corresponding transaction there: the screen
after the keypress is the view of the world after the trade. -/
theorem playAt_is_trade (t : Tower) (hwf : TowerWF t) (k : Nat) (l : Level)
    (h : t.levels[k]? = some l) (o : Nat) (a : Account) (ha : findAcct l.db o = some a)
    (hfloat : 1 ≤ l.db.float) (hhouse : shardPrice l.db.clock ≤ l.db.house) (c : MarketCmd) :
    (dbAt (playAt t k (txOf o c)) k).map (fun db => view db o) =
      some (marketStep (view l.db o) c) := by
  rw [dbAt_playAt_self h]
  simp only [Option.map_some]
  rw [play_is_trade l.db (hwf l (List.mem_of_getElem? h)) o a ha hfloat hhouse c]

/-! ## Cashing out of a miniature world -/

/-- Four shards inside a miniature world are worth one shard in the world above
it — the same factor the nest is drawn at. -/
def miniRate : Nat := 4

/-- What caller `o` holds in the world `k` levels down. -/
def heldAt (t : Tower) (k o : Nat) : Nat :=
  match t.levels[k]? with
  | some l =>
      match findAcct l.db o with
      | some a => a.held
      | none => 0
  | none => 0

/-- Whether caller `o` can cash `n` shards out of the miniature world at level
`k + 1` into the world at level `k`: the little world's account must hold
`n * miniRate`, and the big world's shelf must have `n` to hand over. -/
def canCash (t : Tower) (k o n : Nat) : Bool :=
  match t.levels[k]?, t.levels[k+1]? with
  | some outer, some inner =>
      match findAcct inner.db o, findAcct outer.db o with
      | some ai, some _ => decide (n * miniRate ≤ ai.held) && decide (n ≤ outer.db.float)
      | _, _ => false
  | _, _ => false

/-- Cash `n` shards out of the miniature world at level `k + 1` into the world
at level `k`.  Inside the little world the shards go back on its shelf; in the
big world they come off its shelf. -/
def cashOut (t : Tower) (k o n : Nat) : Tower :=
  if canCash t k o n then
    modifyLevel
      (modifyLevel t k (fun l => { l with db :=
        { l.db with
          accounts := onAcct o (fun a => { a with held := a.held + n }) l.db.accounts,
          float := l.db.float - n } }))
      (k + 1)
      (fun l => { l with db :=
        { l.db with
          accounts := onAcct o (fun a => { a with held := a.held - n * miniRate }) l.db.accounts,
          float := l.db.float + n * miniRate } })
  else t

/-- Cashing out does not change the shape of the nest. -/
theorem cashOut_depth (t : Tower) (k o n : Nat) : (cashOut t k o n).depth = t.depth := by
  simp only [cashOut]
  split
  · rw [modifyLevel_depth, modifyLevel_depth]
  · rfl

/-- Cashing out touches only the two worlds it joins. -/
theorem cashOut_other_level (t : Tower) (k o n : Nat) {j : Nat} (h1 : j ≠ k) (h2 : j ≠ k + 1) :
    (cashOut t k o n).levels[j]? = t.levels[j]? := by
  simp only [cashOut]
  split
  · rw [modifyLevel_ne _ _ _ h2, modifyLevel_ne _ _ _ h1]
  · rfl

/-- The pieces the two worlds are made of, when a cash-out is possible. -/
theorem canCash_iff (t : Tower) (k o n : Nat) :
    canCash t k o n = true ↔
      ∃ outer inner ai ao, t.levels[k]? = some outer ∧ t.levels[k+1]? = some inner ∧
        findAcct inner.db o = some ai ∧ findAcct outer.db o = some ao ∧
        n * miniRate ≤ ai.held ∧ n ≤ outer.db.float := by
  constructor
  · intro h
    cases ho : t.levels[k]? with
    | none => simp [canCash, ho] at h
    | some outer =>
      cases hi : t.levels[k+1]? with
      | none => simp [canCash, ho, hi] at h
      | some inner =>
        cases hai : findAcct inner.db o with
        | none => simp [canCash, ho, hi, hai] at h
        | some ai =>
          cases hao : findAcct outer.db o with
          | none => simp [canCash, ho, hi, hai, hao] at h
          | some ao =>
            simp only [canCash, ho, hi, hai, hao, Bool.and_eq_true, decide_eq_true_eq] at h
            exact ⟨outer, inner, ai, ao, rfl, rfl, hai, hao, h.1, h.2⟩
  · rintro ⟨outer, inner, ai, ao, ho, hi, hai, hao, h1, h2⟩
    simp [canCash, ho, hi, hai, hao, h1, h2]

/-- The world above, after the cash-out. -/
theorem cashOut_outer {t : Tower} {k o n : Nat} (h : canCash t k o n = true) {outer : Level}
    (ho : t.levels[k]? = some outer) :
    (cashOut t k o n).levels[k]? = some { outer with db :=
      { outer.db with
        accounts := onAcct o (fun a => { a with held := a.held + n }) outer.db.accounts,
        float := outer.db.float - n } } := by
  simp only [cashOut, h, if_true]
  rw [modifyLevel_ne _ _ _ (by omega), modifyLevel_self ho]

/-- The miniature world, after the cash-out. -/
theorem cashOut_inner {t : Tower} {k o n : Nat} (h : canCash t k o n = true) {inner : Level}
    (hi : t.levels[k+1]? = some inner) :
    (cashOut t k o n).levels[k+1]? = some { inner with db :=
      { inner.db with
        accounts := onAcct o (fun a => { a with held := a.held - n * miniRate }) inner.db.accounts,
        float := inner.db.float + n * miniRate } } := by
  simp only [cashOut, h, if_true]
  refine modifyLevel_self ?_ _
  rw [modifyLevel_ne _ _ _ (by omega)]
  exact hi

/-- **The big world's book still balances after a cash-out.** -/
theorem cashOut_shards_outer {t : Tower} (hwf : TowerWF t) {k o n : Nat}
    {outer : Level} (ho : t.levels[k]? = some outer)
    {ao : Account} (hao : findAcct outer.db o = some ao) (hn : n ≤ outer.db.float) :
    totalShards
        { outer.db with
          accounts := onAcct o (fun a => { a with held := a.held + n }) outer.db.accounts,
          float := outer.db.float - n } = totalShards outer.db := by
  have hs := sum_onAcct (·.held) o (fun a => { a with held := a.held + n })
    outer.db.accounts (hwf outer (List.mem_of_getElem? ho)) hao
  simp only [totalShards] at *
  omega

/-- **The little world's book still balances after a cash-out.** -/
theorem cashOut_shards_inner {t : Tower} (hwf : TowerWF t) {k o n : Nat}
    {inner : Level} (hi : t.levels[k+1]? = some inner)
    {ai : Account} (hai : findAcct inner.db o = some ai) (hn : n * miniRate ≤ ai.held) :
    totalShards
        { inner.db with
          accounts :=
            onAcct o (fun a => { a with held := a.held - n * miniRate }) inner.db.accounts,
          float := inner.db.float + n * miniRate } = totalShards inner.db := by
  have hs := sum_onAcct (·.held) o (fun a => { a with held := a.held - n * miniRate })
    inner.db.accounts (hwf inner (List.mem_of_getElem? hi)) hai
  simp only [totalShards] at *
  omega

/-- Cashing out moves no credits at all, in either world. -/
theorem cashOut_credits (db : Db) (hwf : WF db) (o : Nat) {a : Account}
    (ha : findAcct db o = some a) (f : Account → Account)
    (hf : ∀ x : Account, (f x).credits = x.credits) :
    ((onAcct o f db.accounts).map (·.credits)).sum = (db.accounts.map (·.credits)).sum := by
  have hs := sum_onAcct (·.credits) o f db.accounts hwf ha
  simp only [hf] at hs
  omega

/-- What the caller holds in the big world after the cash-out. -/
theorem heldAt_cashOut_outer {t : Tower} (hwf : TowerWF t) {k o n : Nat}
    (h : canCash t k o n = true) {outer : Level} (ho : t.levels[k]? = some outer)
    {ao : Account} (hao : findAcct outer.db o = some ao) :
    heldAt (cashOut t k o n) k o = ao.held + n := by
  have hfind := find?_onAcct_self o (fun a => { a with held := a.held + n }) (fun _ => rfl)
    outer.db.accounts (hwf outer (List.mem_of_getElem? ho)) hao
  simp only [heldAt, cashOut_outer h ho, findAcct]
  rw [hfind]

/-- What the caller holds in the little world after the cash-out. -/
theorem heldAt_cashOut_inner {t : Tower} (hwf : TowerWF t) {k o n : Nat}
    (h : canCash t k o n = true) {inner : Level} (hi : t.levels[k+1]? = some inner)
    {ai : Account} (hai : findAcct inner.db o = some ai) :
    heldAt (cashOut t k o n) (k + 1) o = ai.held - n * miniRate := by
  have hfind := find?_onAcct_self o (fun a => { a with held := a.held - n * miniRate })
    (fun _ => rfl) inner.db.accounts (hwf inner (List.mem_of_getElem? hi)) hai
  simp only [heldAt, cashOut_inner h hi, findAcct]
  rw [hfind]

/-- What the caller held in a world before anything happened. -/
theorem heldAt_of {t : Tower} {k o : Nat} {l : Level} (hl : t.levels[k]? = some l)
    {a : Account} (ha : findAcct l.db o = some a) : heldAt t k o = a.held := by
  simp only [heldAt, hl, ha]

/-- **Cashing out of the game inside the game is not a money pump.**  Measured
in the little world's own unit, what the player holds across the two worlds is
exactly what they held before. -/
theorem cashOut_two_level_worth {t : Tower} (hwf : TowerWF t) {k o n : Nat}
    (h : canCash t k o n = true) :
    heldAt (cashOut t k o n) k o * miniRate + heldAt (cashOut t k o n) (k + 1) o =
      heldAt t k o * miniRate + heldAt t (k + 1) o := by
  obtain ⟨outer, inner, ai, ao, ho, hi, hai, hao, h1, h2⟩ := (canCash_iff t k o n).1 h
  rw [heldAt_cashOut_outer hwf h ho hao, heldAt_cashOut_inner hwf h hi hai,
    heldAt_of ho hao, heldAt_of hi hai]
  have : (ao.held + n) * miniRate = ao.held * miniRate + n * miniRate := by ring
  omega

/-- Cashing out leaves every world it does not join untouched. -/
theorem heldAt_cashOut_other (t : Tower) (k o n : Nat) {j : Nat} (h1 : j ≠ k) (h2 : j ≠ k + 1) :
    heldAt (cashOut t k o n) j o = heldAt t j o := by
  simp only [heldAt, cashOut_other_level t k o n h1 h2]

/-- Two neighbouring terms of a sum may be traded against each other without
changing it. -/
theorem sum_range_swap_two (d k : Nat) (hk : k + 1 < d) (f g : Nat → Nat)
    (hne : ∀ j, j ≠ k → j ≠ k + 1 → f j = g j)
    (heq : f k + f (k + 1) = g k + g (k + 1)) :
    ∑ j ∈ Finset.range d, f j = ∑ j ∈ Finset.range d, g j := by
  have hmem1 : k + 1 ∈ Finset.range d := Finset.mem_range.mpr hk
  have hmem2 : k ∈ (Finset.range d).erase (k + 1) :=
    Finset.mem_erase.mpr ⟨by omega, Finset.mem_range.mpr (by omega)⟩
  have key : ∀ h : Nat → Nat,
      ∑ j ∈ Finset.range d, h j
        = (∑ j ∈ ((Finset.range d).erase (k + 1)).erase k, h j) + h k + h (k + 1) := by
    intro h
    rw [← Finset.sum_erase_add (Finset.range d) h hmem1,
      ← Finset.sum_erase_add ((Finset.range d).erase (k + 1)) h hmem2]
  rw [key f, key g]
  have hrest : ∑ j ∈ ((Finset.range d).erase (k + 1)).erase k, f j
      = ∑ j ∈ ((Finset.range d).erase (k + 1)).erase k, g j := by
    refine Finset.sum_congr rfl ?_
    intro j hj
    exact hne j (Finset.mem_erase.mp hj).1 (Finset.mem_erase.mp (Finset.mem_erase.mp hj).2).1
  omega

/-- What caller `o` is worth across the whole nest, counted in the innermost
world's unit: a shard held `k` levels down is worth `miniRate ^ (depth - 1 - k)`,
so a shard in the world you are standing in is worth a purse of them in the game
inside the game. -/
def playerWorth (t : Tower) (o : Nat) : Nat :=
  ∑ k ∈ Finset.range t.depth, heldAt t k o * miniRate ^ (t.depth - 1 - k)

/-- **You cannot get rich by walking into the arcade inside the arcade.**
Cashing shards out of a miniature world into the world above leaves the
player's worth, measured across the whole nest, exactly where it was. -/
theorem cashOut_worth {t : Tower} (hwf : TowerWF t) {k o n : Nat}
    (h : canCash t k o n = true) (hk : k + 1 < t.depth) :
    playerWorth (cashOut t k o n) o = playerWorth t o := by
  obtain ⟨outer, inner, ai, ao, ho, hi, hai, hao, h1, h2⟩ := (canCash_iff t k o n).1 h
  have hd : (cashOut t k o n).depth = t.depth := cashOut_depth t k o n
  simp only [playerWorth, hd]
  refine sum_range_swap_two t.depth k hk _ _ ?_ ?_
  · intro j hj1 hj2
    rw [heldAt_cashOut_other t k o n hj1 hj2]
  · rw [heldAt_cashOut_outer hwf h ho hao, heldAt_cashOut_inner hwf h hi hai,
      heldAt_of ho hao, heldAt_of hi hai]
    have hexp : t.depth - 1 - k = (t.depth - 1 - (k + 1)) + 1 := by omega
    have hE : miniRate ^ (t.depth - 1 - k)
        = miniRate * miniRate ^ (t.depth - 1 - (k + 1)) := by
      rw [hexp, pow_succ]; ring
    rw [hE]
    have hF : (ai.held - n * miniRate) * miniRate ^ (t.depth - 1 - (k + 1))
        = ai.held * miniRate ^ (t.depth - 1 - (k + 1))
          - n * miniRate * miniRate ^ (t.depth - 1 - (k + 1)) := by
      rw [Nat.sub_mul]
    have hG : (ao.held + n) * (miniRate * miniRate ^ (t.depth - 1 - (k + 1)))
        = ao.held * (miniRate * miniRate ^ (t.depth - 1 - (k + 1)))
          + n * (miniRate * miniRate ^ (t.depth - 1 - (k + 1))) := by ring
    have hH : n * miniRate * miniRate ^ (t.depth - 1 - (k + 1))
        = n * (miniRate * miniRate ^ (t.depth - 1 - (k + 1))) := by ring
    have hI : n * miniRate * miniRate ^ (t.depth - 1 - (k + 1))
        ≤ ai.held * miniRate ^ (t.depth - 1 - (k + 1)) :=
      Nat.mul_le_mul_right _ h1
    omega

end Nested

end NixWars
