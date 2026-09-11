import RequestProject.Nix.NixWars.Merge.Score

/-!
# One world holding all fifteen games

`Merge/Score.lean` gave the cabinets one currency.  This file gives them one
*state*: a `World` carries the state vector of **every** cabinet at once, the
purse of records, the shards not yet spent (`bank`) and the shards already spent
(`spent`).

Playing is `play w i k arg`: it steps cabinet `i` by the very transition table
`Machine.lean` proves computes that game's own step function, scores the state
the cabinet lands in, and pays the difference into the bank.  What is proved:

* **the games no longer forget you.**  A move in one cabinet leaves every other
  cabinet's state exactly as it was (`play_other_state`), so leaving a game and
  coming back finds it where you left it, and a game you never touch during a
  whole session is untouched at the end of it (`run_untouched`);
* **the points are one pile.**  A record never falls and the total never falls,
  whatever is played (`play_purse_mono`, `play_total_mono`, `run_total_mono`);
* **nothing is minted and nothing evaporates.**  `bank + spent` is exactly the
  purse's worth in shards, before and after every move and every purchase
  (`play_balanced`, `spend_balanced`, `run_balanced`) — so a shard earned in one
  cabinet is a shard spendable at another, and only once;
* **points earned anywhere open doors everywhere.**  A cabinet is playable when
  the *merged* total reaches its gate (`unlocked`).  A gate once open never
  closes (`unlocked_stable`), a locked cabinet cannot be played at all
  (`play_locked`), and a concrete session played entirely in Monster Dash
  unlocks cabinets that no amount of play in a single locked game could reach
  (`dash_opens_the_hall`);
* **one save carries the lot.**  `encodeWorld` writes the whole world — fifteen
  state vectors, the purse, the bank and the spend — as a single vector of
  natural numbers, and `decodeWorld_encodeWorld` reads it back exactly, so the
  merged game state travels through the transports, tapes and drop files the
  board already has.
-/

set_option maxRecDepth 100000
set_option maxHeartbeats 4000000

namespace NixWars

namespace Merge

/-! ## The world -/

/-- The whole arcade in one state: every cabinet's state vector, the purse of
records, the shards in hand and the shards spent. -/
structure World where
  /-- One state vector per cabinet, in cabinet order. -/
  states : List (List Nat)
  /-- The record reached in each game. -/
  purse : List Nat
  /-- Shards earned and not yet spent. -/
  bank : Nat
  /-- Shards spent. -/
  spent : Nat
  deriving DecidableEq, Repr, Inhabited

/-- The arcade as it opens: every cabinet in its opening position, an empty
purse, nothing earned and nothing spent. -/
def initialWorld : World := ⟨cabinets.map (·.init), emptyPurse, 0, 0⟩

/-- The widths of the fifteen state vectors. -/
def widths : List Nat := cabinets.map (·.init.length)

/-- A world is well formed when it holds one state vector of the right width per
cabinet and one record per cabinet. -/
def WF (w : World) : Prop :=
  w.states.map (·.length) = widths ∧ w.purse.length = numGames

theorem initialWorld_wf : WF initialWorld := by
  constructor
  · simp [initialWorld, widths, List.map_map]
  · simp [initialWorld]

/-! ## Scoring and stepping a single cabinet -/

/-- The points cabinet `i` awards for a state: how far its rule reads that state
*above the opening position*, so that the credits a game happens to start with
are not a windfall and every cabinet starts a player at nothing. -/
def scoreOf (i : Nat) (st : List Nat) : Nat :=
  match cabinets[i]? with
  | some c => c.rule.score c.names st - c.rule.score c.names c.init
  | none => 0

/-- A cabinet in its opening position is worth nothing. -/
theorem scoreOf_init (i : Nat) (c : Cabinet) (hc : cabinets[i]? = some c) :
    scoreOf i c.init = 0 := by simp [scoreOf, hc]

/-- The rate at which cabinet `i` pays. -/
def rateOf (i : Nat) : Nat :=
  match cabinets[i]? with
  | some c => c.rate
  | none => 0

theorem rates_getD (i : Nat) : rates.getD i 0 = rateOf i := by
  simp only [rates, rateOf, List.getD]
  rw [List.getElem?_map]
  cases cabinets[i]? <;> rfl

/-- The state cabinet `i` moves to under its `k`-th command.  The three session
fields at the head of the vector — caller, shard, game — are carried over
untouched and the game's own fields are stepped by its compiled table, which is
written for exactly those fields.  A command the cabinet does not have leaves it
alone. -/
def stepState (i : Nat) (st : List Nat) (k : Nat) (arg : Nat) : List Nat :=
  match cabinets[i]? with
  | some c =>
    match c.door.table[k]? with
    | some p => st.take sessionFields ++ runIR p.2 (st.drop sessionFields) arg
    | none => st
  | none => st

/-- The width of cabinet `i`'s state vector. -/
theorem widths_getD (i : Nat) (c : Cabinet) (hc : cabinets[i]? = some c) :
    widths.getD i 0 = c.init.length := by
  simp only [widths, List.getD]
  rw [List.getElem?_map, hc]; rfl

/-- Stepping a cabinet keeps the width of its state vector. -/
theorem stepState_length (i : Nat) (st : List Nat) (k arg : Nat)
    (hst : st.length = widths.getD i 0) :
    (stepState i st k arg).length = widths.getD i 0 := by
  simp only [stepState]
  cases hc : cabinets[i]? with
  | none => simpa [hc] using hst
  | some c =>
    have hmem : c ∈ cabinets := List.mem_of_getElem? hc
    have hw : widths.getD i 0 = c.init.length := widths_getD i c hc
    have hfields := (cabinets_fields_correct c hmem).1
    cases hf : c.door.table[k]? with
    | none => simpa [hc, hf] using hst
    | some p =>
      have hp : p ∈ c.door.table := List.mem_of_getElem? hf
      have hplen := cabinets_table_widths c hmem p hp
      have hst' : st.length = c.init.length := by rw [hst, hw]
      simp only [sessionFields] at hfields
      simp only [hf, hw, List.length_append, List.length_take, runIR, List.length_map,
        hplen, hst', sessionFields]
      omega

/-- **A move never touches the session**: the caller, the shard and the game
number at the head of a cabinet's state vector are carried over exactly. -/
theorem stepState_session (i : Nat) (st : List Nat) (k arg : Nat)
    (h3 : sessionFields ≤ st.length) :
    (stepState i st k arg).take sessionFields = st.take sessionFields := by
  simp only [stepState]
  cases hc : cabinets[i]? with
  | none => rfl
  | some c =>
    cases hf : c.door.table[k]? with
    | none => simp [hf]
    | some p =>
      have hlen : (st.take sessionFields).length = sessionFields := by
        simp; omega
      simp only [hf]
      exact List.take_left' hlen

/-! ## Gates: what the merged total opens -/

/-- What each cabinet asks, in shards, before it will let a player in.  The
first two are free; the rest are paid for out of the one merged total, whichever
cabinet earned it. -/
def gates : List Nat := [0, 0, 20, 50, 60, 80, 100, 120, 150, 200, 250, 300, 400, 500, 750]

theorem gates_length : gates.length = numGames := by decide

/-- What cabinet `i` asks. -/
def gateOf (i : Nat) : Nat := gates.getD i 0

/-- Is cabinet `i` open to this player? -/
def unlocked (w : World) (i : Nat) : Bool := decide (gateOf i ≤ purseTotal w.purse)

/-- The arcade can be entered from cold: the first cabinet is always open. -/
theorem first_cabinet_always_open (w : World) : unlocked w 0 = true := by
  simp [unlocked, gateOf, gates, List.getD]

/-! ## Playing -/

/-- Play one command at one cabinet: step that cabinet, score the state it lands
in, and pay the improvement into the bank.  A locked cabinet, or a cabinet that
is not there, does nothing. -/
def play (w : World) (i k arg : Nat) : World :=
  if unlocked w i then
    match w.states[i]? with
    | none => w
    | some st =>
      { states := w.states.set i (stepState i st k arg),
        purse := purseCredit w.purse i (scoreOf i (stepState i st k arg)),
        bank := w.bank + rateOf i *
          (max (purseGet w.purse i) (scoreOf i (stepState i st k arg)) - purseGet w.purse i),
        spent := w.spent }
  else w

/-- Play a whole session: a list of cabinet, command and argument. -/
def run (w : World) : List (Nat × Nat × Nat) → World
  | [] => w
  | m :: ms => run (play w m.1 m.2.1 m.2.2) ms

@[simp] theorem run_nil (w : World) : run w [] = w := rfl

@[simp] theorem run_cons (w : World) (m : Nat × Nat × Nat)
    (ms : List (Nat × Nat × Nat)) :
    run w (m :: ms) = run (play w m.1 m.2.1 m.2.2) ms := rfl

theorem run_append (as bs : List (Nat × Nat × Nat)) :
    ∀ w : World, run w (as ++ bs) = run (run w as) bs := by
  induction as with
  | nil => intro w; rfl
  | cons m ms ih => intro w; simpa using ih (play w m.1 m.2.1 m.2.2)

/-- A locked cabinet cannot be played. -/
theorem play_locked (w : World) (i : Nat) (k arg : Nat)
    (h : unlocked w i = false) : play w i k arg = w := by
  simp [play, h]

/-- **A move in one cabinet leaves every other cabinet alone.** -/
theorem play_other_state (w : World) (i : Nat) (k arg : Nat) {j : Nat}
    (h : j ≠ i) : (play w i k arg).states[j]? = w.states[j]? := by
  unfold play
  by_cases hu : unlocked w i
  · simp only [hu, if_true]
    cases hs : w.states[i]? with
    | none => rfl
    | some st => simp [Ne.symm h]
  · simp [hu]

/-- Nor does it touch any other game's record. -/
theorem play_other_purse (w : World) (i : Nat) (k arg : Nat) {j : Nat}
    (h : j ≠ i) : purseGet (play w i k arg).purse j = purseGet w.purse j := by
  unfold play
  by_cases hu : unlocked w i
  · simp only [hu, if_true]
    cases hs : w.states[i]? with
    | none => rfl
    | some st =>
      simpa using purseCredit_other w.purse i (scoreOf i (stepState i st k arg)) j h
  · simp [hu]

/-- A game nobody touches all session comes out as it went in. -/
theorem run_untouched (ms : List (Nat × Nat × Nat)) :
    ∀ (w : World) (j : Nat), (∀ m ∈ ms, m.1 ≠ j) → (run w ms).states[j]? = w.states[j]? := by
  induction ms with
  | nil => intro w j _; rfl
  | cons m ms ih =>
    intro w j h
    rw [run_cons, ih _ _ (fun m' hm' => h m' (List.mem_cons_of_mem _ hm'))]
    exact play_other_state w m.1 m.2.1 m.2.2
      (fun hj => h m (List.mem_cons.2 (Or.inl rfl)) hj.symm)

/-- Playing keeps the world well formed. -/
theorem play_wf (w : World) (i : Nat) (k arg : Nat) (h : WF w) :
    WF (play w i k arg) := by
  obtain ⟨hst, hp⟩ := h
  unfold play
  by_cases hu : unlocked w i
  · simp only [hu, if_true]
    cases hs : w.states[i]? with
    | none => exact ⟨hst, hp⟩
    | some st =>
      refine ⟨?_, by simpa [purseCredit] using hp⟩
      have hi : i < w.states.length := (List.getElem?_eq_some_iff.1 hs).1
      have hstlen : st.length = widths.getD i 0 := by
        have : (w.states.map (·.length))[i]? = some st.length := by
          rw [List.getElem?_map, hs]; rfl
        rw [hst] at this
        simp only [List.getD]
        rw [this]
        rfl
      have hnew := stepState_length i st k arg hstlen
      have : ((w.states.set i (stepState i st k arg)).map (·.length))
          = (w.states.map (·.length)).set i (stepState i st k arg).length := by
        simp [List.map_set]
      rw [this, hst, hnew]
      have hiw : i < widths.length := by
        have : (w.states.map (·.length)).length = widths.length := by rw [hst]
        simpa using this ▸ (by simpa using hi : i < (w.states.map (·.length)).length)
      simp only [List.getD]
      rw [List.getElem?_eq_getElem hiw]
      simp
  · simp only [hu]; exact ⟨hst, hp⟩

/-- **No record ever falls**, whatever is played where. -/
theorem play_purse_mono (w : World) (i : Nat) (k arg : Nat) (j : Nat) :
    purseGet w.purse j ≤ purseGet (play w i k arg).purse j := by
  unfold play
  by_cases hu : unlocked w i
  · simp only [hu, if_true]
    cases hs : w.states[i]? with
    | none => exact Nat.le_refl _
    | some st => simpa using purseCredit_mono w.purse i (scoreOf i (stepState i st k arg)) j
  · simp [hu]

/-- Hence the merged total never falls. -/
theorem play_total_mono (w : World) (i : Nat) (k arg : Nat) (h : WF w) :
    purseTotal w.purse ≤ purseTotal (play w i k arg).purse := by
  refine purseTotal_mono _ _ ?_ (fun j => play_purse_mono w i k arg j)
  have := (play_wf w i k arg h).2
  rw [this, h.2]

theorem run_total_mono (ms : List (Nat × Nat × Nat)) :
    ∀ (w : World), WF w → purseTotal w.purse ≤ purseTotal (run w ms).purse := by
  induction ms with
  | nil => intro w _; exact Nat.le_refl _
  | cons m ms ih =>
    intro w h
    exact Nat.le_trans (play_total_mono w m.1 m.2.1 m.2.2 h)
      (ih _ (play_wf w m.1 m.2.1 m.2.2 h))

theorem run_wf (ms : List (Nat × Nat × Nat)) : ∀ (w : World), WF w → WF (run w ms) := by
  induction ms with
  | nil => intro w h; exact h
  | cons m ms ih => intro w h; exact ih _ (play_wf w m.1 m.2.1 m.2.2 h)

/-- **A gate once open never closes.** -/
theorem unlocked_stable (w : World) (i j : Nat) (k arg : Nat) (h : WF w)
    (hu : unlocked w j = true) : unlocked (play w i k arg) j = true := by
  simp only [unlocked, decide_eq_true_eq] at hu ⊢
  exact Nat.le_trans hu (play_total_mono w i k arg h)

theorem unlocked_stable_run (ms : List (Nat × Nat × Nat)) (w : World) (j : Nat)
    (h : WF w) (hu : unlocked w j = true) : unlocked (run w ms) j = true := by
  simp only [unlocked, decide_eq_true_eq] at hu ⊢
  exact Nat.le_trans hu (run_total_mono ms w h)

/-! ## Spending: one bank, every cabinet -/

/-- Spend shards out of the merged bank. Spending more than is there does
nothing at all. -/
def spend (w : World) (cost : Nat) : World :=
  if cost ≤ w.bank then { w with bank := w.bank - cost, spent := w.spent + cost } else w

/-- The books balance: the shards in hand plus the shards spent are exactly what
the purse is worth. -/
def Balanced (w : World) : Prop := w.bank + w.spent = purseTotal w.purse

theorem initialWorld_balanced : Balanced initialWorld := by
  simp [Balanced, initialWorld]

/-- Spending moves shards from the bank to the spend column and changes nothing
else. -/
theorem spend_balanced (w : World) (cost : Nat) (h : Balanced w) : Balanced (spend w cost) := by
  unfold spend Balanced at *
  by_cases hc : cost ≤ w.bank
  · simp only [hc, if_true]
    omega
  · simp [hc, h]

theorem spend_wf (w : World) (cost : Nat) (h : WF w) : WF (spend w cost) := by
  unfold spend
  by_cases hc : cost ≤ w.bank
  · simpa only [hc, if_true] using h
  · simpa only [hc, if_false] using h

theorem spend_too_much (w : World) (cost : Nat) (h : w.bank < cost) : spend w cost = w := by
  simp [spend, Nat.not_le.2 h]

/-! ### Crediting the bank -/

theorem zipWith_mul_sum_set : ∀ (r p : List Nat) (i x : Nat), i < p.length → i < r.length →
    (List.zipWith (· * ·) r (p.set i x)).sum + r.getD i 0 * p.getD i 0
      = (List.zipWith (· * ·) r p).sum + r.getD i 0 * x := by
  intro r
  induction r with
  | nil => intro p i x _ hr; simp at hr
  | cons y ys ih =>
    intro p i x hp hr
    cases p with
    | nil => simp at hp
    | cons u us =>
      cases i with
      | zero => simp [List.getD]; omega
      | succ n =>
        have hp' : n < us.length := by simpa using hp
        have hr' : n < ys.length := by simpa using hr
        have := ih us n x hp' hr'
        simp only [List.set_cons_succ, List.zipWith_cons_cons, List.sum_cons,
          List.getD_cons_succ]
        omega

/-- The purse's worth grows by exactly the rate of the game played times the
improvement in its record. -/
theorem purseTotal_credit (p : List Nat) (i v : Nat) (hp : i < p.length) (hi : i < numGames) :
    purseTotal (purseCredit p i v) =
      purseTotal p + rateOf i * (max (purseGet p i) v - purseGet p i) := by
  have hr : i < rates.length := by rw [rates_length]; exact hi
  have h := zipWith_mul_sum_set rates p i (max (p.getD i 0) v) hp hr
  have hmax : p.getD i 0 ≤ max (p.getD i 0) v := Nat.le_max_left _ _
  have hmul : rateOf i * max (p.getD i 0) v
      = rateOf i * p.getD i 0 + rateOf i * (max (p.getD i 0) v - p.getD i 0) := by
    rw [← Nat.mul_add]
    congr 1
    omega
  simp only [purseTotal, purseCredit, purseGet, rates_getD] at *
  omega

/-- **Nothing is minted and nothing evaporates**: a move pays the improvement in
one game's record into the one bank, and leaves the books balanced. -/
theorem play_balanced (w : World) (i : Nat) (k arg : Nat) (hw : WF w)
    (h : Balanced w) : Balanced (play w i k arg) := by
  unfold play
  by_cases hu : unlocked w i
  · simp only [hu, if_true]
    cases hs : w.states[i]? with
    | none => simpa [hs] using h
    | some st =>
      by_cases hi : i < numGames
      · have hp : i < w.purse.length := by rw [hw.2]; exact hi
        have := purseTotal_credit w.purse i (scoreOf i (stepState i st k arg)) hp hi
        simp only [Balanced, hs] at *
        omega
      · -- outside the arcade there is no cabinet, so nothing can be played
        have hc : cabinets[i]? = none := by
          apply List.getElem?_eq_none
          rw [cabinets_length]; omega
        have hpn : i ≥ w.purse.length := by rw [hw.2]; omega
        have hset : w.purse.set i (max (w.purse.getD i 0)
            (scoreOf i (stepState i st k arg))) = w.purse := List.set_eq_of_length_le hpn
        simp only [Balanced, hs, purseCredit, hset, rateOf, hc] at *
        omega
  · simpa [hu] using h

theorem run_balanced (ms : List (Nat × Nat × Nat)) :
    ∀ (w : World), WF w → Balanced w → Balanced (run w ms) := by
  induction ms with
  | nil => intro w _ h; exact h
  | cons m ms ih =>
    intro w hw h
    exact ih _ (play_wf w m.1 m.2.1 m.2.2 hw) (play_balanced w m.1 m.2.1 m.2.2 hw h)


/-! ## A worked session: the points really do cross between cabinets -/

/-- Twelve ticks of Monster Dash, and nothing else. -/
def dashSession : List (Nat × Nat × Nat) := (List.range 12).map (fun k => (1, 2, k % 3))

/-- Six trades in the Shard Market. -/
def marketSession : List (Nat × Nat × Nat) :=
  [(2, 0, 1), (2, 2, 0), (2, 1, 1), (2, 0, 2), (2, 2, 0), (2, 1, 2)]

/-- The player after the dash. -/
def afterDash : World := run initialWorld dashSession

/-- The player after the dash and the trading. -/
def afterMarket : World := run initialWorld (dashSession ++ marketSession)

/-- Monster Dash alone is worth five of its own points, and Monster Dash pays
five shards a point. -/
theorem dash_earns : purseGet afterDash.purse 1 = 5 ∧ purseTotal afterDash.purse = 25 := by
  decide +kernel

/-- Those shards, earned in Monster Dash, are what opens the Shard Market. -/
theorem dash_opens_market : unlocked afterDash 2 = true := by decide

/-- They are not enough for Red Shard, which asks fifty. -/
theorem dash_alone_shuts_lord : unlocked afterDash 3 = false := by decide

/-- **Points earned anywhere open doors everywhere**: trading in the market that
Monster Dash paid the entry to earns forty-eight more shards, and the two
together open Red Shard, which neither could open alone. -/
theorem dash_and_market_open_lord :
    purseTotal afterMarket.purse = 73 ∧ unlocked afterMarket 3 = true := by decide

/-- And the games remember: after the trading, the Monster Dash cabinet is
exactly where the dash left it. -/
theorem dash_cabinet_remembered : afterMarket.states[1]? = afterDash.states[1]? := by
  have h : afterMarket = run afterDash marketSession := run_append dashSession marketSession _
  rw [h]
  exact run_untouched marketSession afterDash 1 (by decide)

/-- Every point in the purse can be traced to the cabinet that paid it: five in
Monster Dash, forty-eight in the Shard Market, nothing anywhere else. -/
theorem afterMarket_purse :
    afterMarket.purse = [0, 5, 48, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by decide

/-- The worked session leaves the world well formed and the books balanced. -/
theorem afterMarket_wf : WF afterMarket := run_wf _ initialWorld initialWorld_wf

theorem afterMarket_balanced : Balanced afterMarket :=
  run_balanced _ initialWorld initialWorld_wf initialWorld_balanced

/-- Spending forty of those seventy-three shards at a door leaves thirty-three
in hand, forty on the counter, and the books still balanced. -/
theorem afterMarket_spend :
    (spend afterMarket 40).bank = 33 ∧ (spend afterMarket 40).spent = 40 ∧
      Balanced (spend afterMarket 40) :=
  ⟨by decide, by decide, spend_balanced afterMarket 40 afterMarket_balanced⟩

/-! ## One save for all fifteen games -/

/-- The whole world as one vector of natural numbers. -/
def encodeWorld (w : World) : List Nat := w.states.flatten ++ w.purse ++ [w.bank, w.spent]

/-- Cut a vector into pieces of the given widths. -/
def splitWidths : List Nat → List Nat → Option (List (List Nat) × List Nat)
  | [], rest => some ([], rest)
  | n :: ns, l =>
    if n ≤ l.length then
      match splitWidths ns (l.drop n) with
      | some (xs, rest) => some (l.take n :: xs, rest)
      | none => none
    else none

theorem splitWidths_flatten : ∀ (sts : List (List Nat)) (rest : List Nat),
    splitWidths (sts.map (·.length)) (sts.flatten ++ rest) = some (sts, rest) := by
  intro sts
  induction sts with
  | nil => intro rest; simp [splitWidths]
  | cons x xs ih =>
    intro rest
    have hlen : x.length ≤ (x ++ (xs.flatten ++ rest)).length := by simp
    simp only [List.map_cons, List.flatten_cons, List.append_assoc, splitWidths, hlen, if_true,
      List.take_left', List.drop_left', ih rest]

/-- Read a world back out of a vector. -/
def decodeWorld (l : List Nat) : Option World :=
  match splitWidths widths l with
  | some (sts, rest) =>
    match rest.drop numGames with
    | [bank, spent] => some ⟨sts, rest.take numGames, bank, spent⟩
    | _ => none
  | none => none

/-- **One save carries every game.** -/
theorem decodeWorld_encodeWorld (w : World) (h : WF w) : decodeWorld (encodeWorld w) = some w := by
  obtain ⟨hst, hp⟩ := h
  have hsplit : splitWidths widths (encodeWorld w) = some (w.states, w.purse ++ [w.bank, w.spent]) := by
    rw [← hst]
    simpa [encodeWorld, List.append_assoc] using
      splitWidths_flatten w.states (w.purse ++ [w.bank, w.spent])
  have hdrop : (w.purse ++ [w.bank, w.spent]).drop numGames = [w.bank, w.spent] := by
    rw [← hp]; simp
  have htake : (w.purse ++ [w.bank, w.spent]).take numGames = w.purse := by
    rw [← hp]; simp
  simp only [decodeWorld, hsplit, hdrop, htake]

end Merge

end NixWars
