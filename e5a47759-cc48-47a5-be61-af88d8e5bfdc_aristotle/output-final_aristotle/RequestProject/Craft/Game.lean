import RequestProject.Craft.CCLuaEmit
import RequestProject.Craft.CCColors
import RequestProject.Craft.ClaimLifecycle
import RequestProject.Craft.HopperGlob
import RequestProject.Craft.FileSystemPaths

/-!
# Factory Floor: a verified game that uses every component of the development

The demo site (`index.html`) is a playable game whose rules are *this* file.  A
turn of the game touches every piece of the development at once:

* the board is the inventory network of `RequestProject.Main`, and a manual
  transfer is literally `Hopper.netTransfer`;
* an item may only be moved if it matches the player's **item filter**, which is
  a `hopper.lua` glob pattern (`RequestProject.HopperGlob`);
* a chest only accepts items when its **bundled-cable gate** is switched on,
  which is the CC:Tweaked `colors` bit-set API (`RequestProject.CCColors`);
* the player may `cd` around the computer's **virtual file system**, and the
  move is rejected unless the ComputerCraft path layer says the destination is
  inside the level's root (`RequestProject.FileSystemPaths`);
* the order the player is filling is a **claim** of the Mekanism resource
  network router, and it advances through that router's state machine
  (`RequestProject.ClaimLifecycle`);
* and the player can run the on-board **hopper daemon**, which is the Lua
  program that the verified TypeScript-to-Lua compiler emitted
  (`RequestProject.CCLuaCompile`, `RequestProject.CCLuaRename`).

What is proved below: no move of the game creates or destroys an item, no move
overfills a slot, no move can take the player outside the level root, the claim
stays well formed and can be advanced at most four times in a whole play, a
transfer only ever moves an item the filter admits into a chest whose gate is
open, and winning a level requires the items to have been in the network from
the start.  A concrete level, a winning play and several rejected plays are
checked by evaluation.
-/

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace Factory

open Hopper CCLua

/-! ## The board -/

/-- A level: the stack limit, the sandbox root of the in-game computer, and the
delivery order (so many of an item into a given chest). -/
structure Level where
  /-- The per-item stack limit. -/
  limit : Item → ℕ
  /-- The directory the player is confined to. -/
  root : List Char
  /-- The item the order asks for. -/
  target : Item
  /-- The index of the output chest in the network. -/
  goal : ℕ
  /-- How many of `target` the output chest must hold. -/
  quota : ℕ

/-- The state of a play. -/
structure GameState where
  /-- The chests, as a network of inventories. -/
  net : Network
  /-- Which bundled-cable colours are currently on. -/
  gates : CCColors.ColorSet
  /-- The claim being filled. -/
  claim : ClaimLifecycle.Claim
  /-- The current working directory. -/
  cwd : List Char
  /-- The item filter, a `hopper.lua` pattern. -/
  filter : String
  /-- How many items the player has moved by hand. -/
  moved : ℕ
deriving Repr

/-- The moves a player can make. -/
inductive Move where
  /-- Move up to `req` items from slot `i` of chest `a` to slot `j` of chest `b`. -/
  | push (a i b j req : ℕ)
  /-- Switch the bundled-cable colour of chest `k` on or off. -/
  | wire (k : ℕ) (on : Bool)
  /-- Set the item filter to a `hopper.lua` glob pattern. -/
  | setFilter (p : String)
  /-- Change directory on the in-game computer. -/
  | cd (p : String)
  /-- Advance the claim to a new status. -/
  | advance (t : ClaimLifecycle.Status)
  /-- Run the compiled hopper daemon with the given loop bound. -/
  | runDaemon (fuel : ℕ)
deriving Repr, DecidableEq

/-! ## The hopper daemon: the program the verified compiler emitted -/

/-- The daemon's TypeScript source: sweep the four slots of the input chest and
push whatever is there into the matching slot of the buffer chest. -/
def daemonTS : TStmt :=
  .seq (.letD "i" (.lit 0)) <|
  .seq (.letD "moved" (.lit 0)) <|
  .whileDo (.lt (.var "i") (.lit 4)) <|
    .seq (.ifElse (.size (.lit 0) (.var "i"))
            (.seq (.push "k" (.lit 0) (.lit 1) (.var "i") (.var "i") (.lit 64))
                  (.assign "moved" (.add (.var "moved") (.var "k"))))
            .skip)
         (.incr "i")

/-- The identifiers the obfuscation pass renumbers. -/
def daemonNames : List Name := ["i", "moved", "k"]

/-- The Lua the compiler emits for the daemon, after the identifier-destroying
pass — this is exactly the program the page decrypts and runs. -/
def daemon : LStmt := renS (obfWith daemonNames) (cS daemonTS)

/-- The chest the daemon fills; its gate has to be open for the daemon to run. -/
def daemonDst : ℕ := 1

/-! ## The rules -/

/-- Is chest `k`'s bundled-cable gate on? -/
def gateOpen (g : CCColors.ColorSet) (k : ℕ) : Bool :=
  CCColors.test g (CCColors.colorOf k)

/-- The item sitting in slot `i` of chest `a`, if any. -/
def itemAt (net : Network) (a i : ℕ) : Option Item :=
  ((net.getD a []).getD i none).map Stack.item

/-- Does the current filter admit this item?  This is the `hopper.lua` matcher. -/
def accepts (filter : String) (it : Item) : Bool :=
  (HopperGlob.globStr filter it).isSome

/-- One move.  `none` means the move is illegal and is refused. -/
def step (lv : Level) (st : GameState) : Move → Option GameState
  | .push a i b j req =>
      match itemAt st.net a i with
      | none => none
      | some it =>
          if gateOpen st.gates b = true ∧ accepts st.filter it = true then
            match pushStep lv.limit st.net a i b j req with
            | none => none
            | some (k, net') => some { st with net := net', moved := st.moved + k }
          else none
  | .wire k on =>
      some { st with gates :=
        if on then CCColors.combine st.gates (CCColors.colorOf k)
        else CCColors.subtract st.gates (CCColors.colorOf k) }
  | .setFilter p => some { st with filter := p }
  | .cd p =>
      let tgt := CCFileSystem.combineL st.cwd p.toList
      if CCFileSystem.containsL lv.root tgt = true then some { st with cwd := tgt } else none
  | .advance t => (ClaimLifecycle.transition st.claim t).map (fun c => { st with claim := c })
  | .runDaemon fuel =>
      if gateOpen st.gates daemonDst = true then
        match execL lv.limit fuel daemon { env := [], net := st.net } with
        | none => none
        | some ls => some { st with net := ls.net }
      else none

/-- A whole play: a list of moves, executed in order.  Any illegal move aborts
the play. -/
def run (lv : Level) : GameState → List Move → Option GameState
  | st, [] => some st
  | st, m :: ms => (step lv st m).bind (fun st' => run lv st' ms)

/-- The winning condition: the output chest holds the order, and the claim has
been carried all the way to `completed`. -/
def wonB (lv : Level) (st : GameState) : Bool :=
  decide (lv.quota ≤ countOf (st.net.getD lv.goal []) lv.target) &&
    decide (st.claim.status = ClaimLifecycle.Status.completed)

/-- `wonB`, as a proposition. -/
def Won (lv : Level) (st : GameState) : Prop :=
  lv.quota ≤ countOf (st.net.getD lv.goal []) lv.target ∧
    st.claim.status = ClaimLifecycle.Status.completed

theorem wonB_iff (lv : Level) (st : GameState) : wonB lv st = true ↔ Won lv st := by
  simp [wonB, Won]

/-- Did a play win?  (`none`, an aborted play, does not.) -/
def solved (lv : Level) : Option GameState → Bool
  | none => false
  | some st => wonB lv st

/-! ## Conservation and safety -/

/-- **No move creates or destroys an item.** -/
theorem step_conserves (lv : Level) (st st' : GameState) (m : Move)
    (h : step lv st m = some st') (it : Item) :
    netCount st'.net it = netCount st.net it := by
  cases m with
  | push a i b j req =>
      simp only [step] at h
      split at h
      · exact absurd h (by simp)
      · split at h
        · split at h
          · exact absurd h (by simp)
          · rename_i k net' hp
            obtain ⟨hab, ha, hb, hi, hj, rfl⟩ := pushStep_eq lv.limit st.net a i b j req k net' hp
            simp only [Option.some.injEq] at h
            subst h
            exact netTransfer_conserves lv.limit st.net a i b j req it hab ha hb hi hj
        · exact absurd h (by simp)
  | wire k on => simp only [step, Option.some.injEq] at h; subst h; rfl
  | setFilter p => simp only [step, Option.some.injEq] at h; subst h; rfl
  | cd p =>
      simp only [step] at h
      split at h
      · simp only [Option.some.injEq] at h; subst h; rfl
      · exact absurd h (by simp)
  | advance t =>
      rcases hh : ClaimLifecycle.transition st.claim t with _ | c
      · simp [step, hh] at h
      · simp only [step, hh, Option.map_some] at h
        simp only [Option.some.injEq] at h
        subst h; rfl
  | runDaemon f =>
      simp only [step] at h
      split at h
      · split at h
        · exact absurd h (by simp)
        · rename_i ls hls
          simp only [Option.some.injEq] at h
          subst h
          exact execL_conserves lv.limit f daemon { env := [], net := st.net } ls hls it
      · exact absurd h (by simp)

/-- **No move overfills a slot**: the stack-limit invariant is preserved. -/
theorem step_valid (lv : Level) (st st' : GameState) (m : Move)
    (h : step lv st m = some st') (hv : NetValid lv.limit st.net) :
    NetValid lv.limit st'.net := by
  cases m with
  | push a i b j req =>
      simp only [step] at h
      split at h
      · exact absurd h (by simp)
      · split at h
        · split at h
          · exact absurd h (by simp)
          · rename_i k net' hp
            obtain ⟨_, _, _, _, _, rfl⟩ := pushStep_eq lv.limit st.net a i b j req k net' hp
            simp only [Option.some.injEq] at h
            subst h
            exact netTransfer_valid lv.limit st.net a i b j req hv
        · exact absurd h (by simp)
  | wire k on => simp only [step, Option.some.injEq] at h; subst h; exact hv
  | setFilter p => simp only [step, Option.some.injEq] at h; subst h; exact hv
  | cd p =>
      simp only [step] at h
      split at h
      · simp only [Option.some.injEq] at h; subst h; exact hv
      · exact absurd h (by simp)
  | advance t =>
      rcases hh : ClaimLifecycle.transition st.claim t with _ | c
      · simp [step, hh] at h
      · simp only [step, hh, Option.map_some] at h
        simp only [Option.some.injEq] at h
        subst h; exact hv
  | runDaemon f =>
      simp only [step] at h
      split at h
      · split at h
        · exact absurd h (by simp)
        · rename_i ls hls
          simp only [Option.some.injEq] at h
          subst h
          exact execL_valid lv.limit f daemon { env := [], net := st.net } ls hls hv
      · exact absurd h (by simp)

/-- **A whole play conserves every item.** -/
theorem run_conserves (lv : Level) (ms : List Move) (st st' : GameState)
    (h : run lv st ms = some st') (it : Item) :
    netCount st'.net it = netCount st.net it := by
  induction ms generalizing st with
  | nil => simp only [run, Option.some.injEq] at h; subst h; rfl
  | cons m ms ih =>
      simp only [run] at h
      rcases hm : step lv st m with _ | st1
      · rw [hm] at h; simp at h
      · rw [hm] at h
        simp only [Option.bind_some] at h
        rw [ih st1 h, step_conserves lv st st1 m hm it]

/-- **A whole play preserves the stack-limit invariant.** -/
theorem run_valid (lv : Level) (ms : List Move) (st st' : GameState)
    (h : run lv st ms = some st') (hv : NetValid lv.limit st.net) :
    NetValid lv.limit st'.net := by
  induction ms generalizing st with
  | nil => simp only [run, Option.some.injEq] at h; subst h; exact hv
  | cons m ms ih =>
      simp only [run] at h
      rcases hm : step lv st m with _ | st1
      · rw [hm] at h; simp at h
      · rw [hm] at h
        simp only [Option.bind_some] at h
        exact ih st1 h (step_valid lv st st1 m hm hv)

/-! ## The transfer rule bites -/

/-- **A hand transfer only ever moves an item the filter admits, into a chest
whose gate is open.** -/
theorem push_rule (lv : Level) (st st' : GameState) (a i b j req : ℕ)
    (h : step lv st (.push a i b j req) = some st') :
    ∃ it, itemAt st.net a i = some it ∧ accepts st.filter it = true ∧
      gateOpen st.gates b = true := by
  simp only [step] at h
  split at h
  · exact absurd h (by simp)
  · rename_i it hit
    split at h
    · rename_i hc
      exact ⟨it, hit, hc.2, hc.1⟩
    · exact absurd h (by simp)

/-- **The daemon only runs when the buffer chest's gate is open.** -/
theorem daemon_rule (lv : Level) (st st' : GameState) (f : ℕ)
    (h : step lv st (.runDaemon f) = some st') :
    gateOpen st.gates daemonDst = true := by
  simp only [step] at h
  split at h
  · assumption
  · exact absurd h (by simp)

/-- The player's move counter never goes down. -/
theorem step_moved_mono (lv : Level) (st st' : GameState) (m : Move)
    (h : step lv st m = some st') : st.moved ≤ st'.moved := by
  cases m with
  | push a i b j req =>
      simp only [step] at h
      split at h
      · exact absurd h (by simp)
      · split at h
        · split at h
          · exact absurd h (by simp)
          · simp only [Option.some.injEq] at h; subst h; exact Nat.le_add_right _ _
        · exact absurd h (by simp)
  | wire k on => simp only [step, Option.some.injEq] at h; subst h; exact le_refl _
  | setFilter p => simp only [step, Option.some.injEq] at h; subst h; exact le_refl _
  | cd p =>
      simp only [step] at h
      split at h
      · simp only [Option.some.injEq] at h; subst h; exact le_refl _
      · exact absurd h (by simp)
  | advance t =>
      rcases hh : ClaimLifecycle.transition st.claim t with _ | c
      · simp [step, hh] at h
      · simp only [step, hh, Option.map_some, Option.some.injEq] at h
        subst h; exact le_refl _
  | runDaemon f =>
      simp only [step] at h
      split at h
      · split at h
        · exact absurd h (by simp)
        · simp only [Option.some.injEq] at h; subst h; exact le_refl _
      · exact absurd h (by simp)

/-! ## The sandbox: the player cannot leave the level root -/

open CCFileSystem in
/-- A path that the ComputerCraft `contains` check accepts has no `".."`
component once sanitised: `cd` can never climb out of the level root. -/
theorem no_dotdot_of_containsL (a b : List Char) (h : containsL a b = true) :
    dd ∉ pathParts (sanitizeL false b) := by
  set bb := sanitizeL false b with hbb
  simp only [containsL, ← hbb] at h
  have h1 : bb ≠ dd := by
    intro hc; rw [if_pos hc] at h; simp at h
  rw [if_neg h1] at h
  have h2 : (dd ++ ['/']).isPrefixOf bb = false := by
    by_contra hc
    simp only [Bool.not_eq_false] at hc
    rw [if_pos hc] at h
    simp at h
  intro hmem
  obtain ⟨k, rest, hk, _⟩ := sanitizeL_dotdot_prefix false b
  rw [← hbb] at hk
  rcases k with _ | k
  · rw [List.replicate_zero, List.nil_append] at hk
    rw [hk] at hmem
    exact absurd hmem (by simpa using ‹dd ∉ rest›)
  · have hparts : pathParts bb = dd :: (List.replicate k dd ++ rest) := by
      rw [hk]; rfl
    have hjoin : joinParts (pathParts bb) = bb := joinParts_pathParts bb
    rw [hparts] at hjoin
    rcases hrest : (List.replicate k dd ++ rest) with _ | ⟨p, ps⟩
    · rw [hrest] at hjoin
      exact h1 (by rw [← hjoin]; rfl)
    · rw [hrest] at hjoin
      have : bb = dd ++ '/' :: joinParts (p :: ps) := by rw [← hjoin]; rfl
      rw [this] at h2
      simp [dd, List.isPrefixOf] at h2

/-- **The working directory stays inside the level root.** -/
theorem step_cwd_inside (lv : Level) (st st' : GameState) (m : Move)
    (h : step lv st m = some st') (hcwd : CCFileSystem.containsL lv.root st.cwd = true) :
    CCFileSystem.containsL lv.root st'.cwd = true := by
  cases m with
  | push a i b j req =>
      simp only [step] at h
      split at h
      · exact absurd h (by simp)
      · split at h
        · split at h
          · exact absurd h (by simp)
          · simp only [Option.some.injEq] at h; subst h; exact hcwd
        · exact absurd h (by simp)
  | wire k on => simp only [step, Option.some.injEq] at h; subst h; exact hcwd
  | setFilter p => simp only [step, Option.some.injEq] at h; subst h; exact hcwd
  | cd p =>
      simp only [step] at h
      split at h
      · rename_i hc
        simp only [Option.some.injEq] at h; subst h; exact hc
      · exact absurd h (by simp)
  | advance t =>
      rcases hh : ClaimLifecycle.transition st.claim t with _ | c
      · simp [step, hh] at h
      · simp only [step, hh, Option.map_some, Option.some.injEq] at h
        subst h; exact hcwd
  | runDaemon f =>
      simp only [step] at h
      split at h
      · split at h
        · exact absurd h (by simp)
        · simp only [Option.some.injEq] at h; subst h; exact hcwd
      · exact absurd h (by simp)

/-- **Over a whole play, the working directory stays inside the level root …** -/
theorem run_cwd_inside (lv : Level) (ms : List Move) (st st' : GameState)
    (h : run lv st ms = some st') (hcwd : CCFileSystem.containsL lv.root st.cwd = true) :
    CCFileSystem.containsL lv.root st'.cwd = true := by
  induction ms generalizing st with
  | nil => simp only [run, Option.some.injEq] at h; subst h; exact hcwd
  | cons m ms ih =>
      simp only [run] at h
      rcases hm : step lv st m with _ | st1
      · rw [hm] at h; simp at h
      · rw [hm] at h
        simp only [Option.bind_some] at h
        exact ih st1 h (step_cwd_inside lv st st1 m hm hcwd)

/-- **… so it never contains a `".."` component: no play escapes the sandbox.** -/
theorem run_cwd_no_escape (lv : Level) (ms : List Move) (st st' : GameState)
    (h : run lv st ms = some st') (hcwd : CCFileSystem.containsL lv.root st.cwd = true) :
    CCFileSystem.dd ∉ CCFileSystem.pathParts (CCFileSystem.sanitizeL false st'.cwd) :=
  no_dotdot_of_containsL lv.root st'.cwd (run_cwd_inside lv ms st st' h hcwd)

/-! ## The claim -/

/-- **The claim stays well formed.** -/
theorem step_claim_wf (lv : Level) (st st' : GameState) (m : Move)
    (h : step lv st m = some st') (hw : ClaimLifecycle.Wf st.claim) :
    ClaimLifecycle.Wf st'.claim := by
  cases m with
  | push a i b j req =>
      simp only [step] at h
      split at h
      · exact absurd h (by simp)
      · split at h
        · split at h
          · exact absurd h (by simp)
          · simp only [Option.some.injEq] at h; subst h; exact hw
        · exact absurd h (by simp)
  | wire k on => simp only [step, Option.some.injEq] at h; subst h; exact hw
  | setFilter p => simp only [step, Option.some.injEq] at h; subst h; exact hw
  | cd p =>
      simp only [step] at h
      split at h
      · simp only [Option.some.injEq] at h; subst h; exact hw
      · exact absurd h (by simp)
  | advance t =>
      rcases hh : ClaimLifecycle.transition st.claim t with _ | c
      · simp [step, hh] at h
      · simp only [step, hh, Option.map_some, Option.some.injEq] at h
        subst h
        exact ClaimLifecycle.wf_transition hw hh
  | runDaemon f =>
      simp only [step] at h
      split at h
      · split at h
        · exact absurd h (by simp)
        · simp only [Option.some.injEq] at h; subst h; exact hw
      · exact absurd h (by simp)

/-- How many `advance` moves a play contains. -/
def advCount : List Move → ℕ
  | [] => 0
  | (.advance _) :: ms => advCount ms + 1
  | _ :: ms => advCount ms

/-- No move ever sends the claim backwards. -/
theorem step_rank_mono (lv : Level) (st st' : GameState) (m : Move)
    (h : step lv st m = some st') :
    ClaimLifecycle.rank st.claim.status ≤ ClaimLifecycle.rank st'.claim.status := by
  cases m with
  | advance t =>
      rcases hh : ClaimLifecycle.transition st.claim t with _ | c
      · simp [step, hh] at h
      · simp only [step, hh, Option.map_some, Option.some.injEq] at h
        subst h
        obtain ⟨hal, hst, -⟩ := ClaimLifecycle.transition_eq_some hh
        rw [hst]
        exact le_of_lt (ClaimLifecycle.rank_lt_of_allowed hal)
  | push a i b j req =>
      simp only [step] at h
      split at h
      · exact absurd h (by simp)
      · split at h
        · split at h
          · exact absurd h (by simp)
          · simp only [Option.some.injEq] at h; subst h; exact le_refl _
        · exact absurd h (by simp)
  | wire k on => simp only [step, Option.some.injEq] at h; subst h; exact le_refl _
  | setFilter p => simp only [step, Option.some.injEq] at h; subst h; exact le_refl _
  | cd p =>
      simp only [step] at h
      split at h
      · simp only [Option.some.injEq] at h; subst h; exact le_refl _
      · exact absurd h (by simp)
  | runDaemon f =>
      simp only [step] at h
      split at h
      · split at h
        · exact absurd h (by simp)
        · simp only [Option.some.injEq] at h; subst h; exact le_refl _
      · exact absurd h (by simp)

/-- An `advance` move strictly advances the claim. -/
theorem step_rank_lt_of_advance (lv : Level) (st st' : GameState)
    (t : ClaimLifecycle.Status) (h : step lv st (.advance t) = some st') :
    ClaimLifecycle.rank st.claim.status < ClaimLifecycle.rank st'.claim.status := by
  rcases hh : ClaimLifecycle.transition st.claim t with _ | c
  · simp [step, hh] at h
  · simp only [step, hh, Option.map_some, Option.some.injEq] at h
    subst h
    obtain ⟨hal, hst, -⟩ := ClaimLifecycle.transition_eq_some hh
    rw [hst]
    exact ClaimLifecycle.rank_lt_of_allowed hal

theorem rank_le_four (s : ClaimLifecycle.Status) : ClaimLifecycle.rank s ≤ 4 := by
  cases s <;> simp [ClaimLifecycle.rank]

/-- Every `advance` in a successful play costs one rank. -/
theorem run_rank_add (lv : Level) (ms : List Move) (st st' : GameState)
    (h : run lv st ms = some st') :
    ClaimLifecycle.rank st.claim.status + advCount ms ≤
      ClaimLifecycle.rank st'.claim.status := by
  induction ms generalizing st with
  | nil => simp only [run, Option.some.injEq] at h; subst h; simp [advCount]
  | cons m ms ih =>
      simp only [run] at h
      rcases hm : step lv st m with _ | st1
      · rw [hm] at h; simp at h
      · rw [hm] at h
        simp only [Option.bind_some] at h
        have hrest := ih st1 h
        cases m with
        | advance t =>
            have hlt := step_rank_lt_of_advance lv st st1 t hm
            simp only [advCount]
            omega
        | push a i b j req =>
            have := step_rank_mono lv st st1 _ hm
            simp only [advCount]; omega
        | wire k on =>
            have := step_rank_mono lv st st1 _ hm
            simp only [advCount]; omega
        | setFilter p =>
            have := step_rank_mono lv st st1 _ hm
            simp only [advCount]; omega
        | cd p =>
            have := step_rank_mono lv st st1 _ hm
            simp only [advCount]; omega
        | runDaemon f =>
            have := step_rank_mono lv st st1 _ hm
            simp only [advCount]; omega

/-- **A whole play can advance the claim at most four times.** -/
theorem run_advCount_le_four (lv : Level) (ms : List Move) (st st' : GameState)
    (h : run lv st ms = some st') : advCount ms ≤ 4 := by
  have h1 := run_rank_add lv ms st st' h
  have h2 := rank_le_four st'.claim.status
  omega

/-! ## Winning requires the items to have been there all along -/

theorem countOf_getD_le_netCount (net : Network) (a : ℕ) (it : Item) :
    countOf (net.getD a []) it ≤ netCount net it := by
  by_cases ha : a < net.length
  · have hmem : countOf (net.getD a []) it ∈ net.map (fun inv => countOf inv it) := by
      refine List.mem_map.2 ⟨net.getD a [], ?_, rfl⟩
      rw [List.getD_eq_getElem net [] ha]
      exact List.getElem_mem ha
    exact List.single_le_sum (fun x _ => Nat.zero_le x) _ hmem
  · rw [List.getD_eq_default _ _ (Nat.le_of_not_lt ha)]
    simp [countOf, netCount]

/-- **You cannot win with items that were not in the factory to begin with.** -/
theorem win_needs_supply (lv : Level) (ms : List Move) (st st' : GameState)
    (h : run lv st ms = some st') (hw : Won lv st') :
    lv.quota ≤ netCount st.net lv.target := by
  have h1 : lv.quota ≤ countOf (st'.net.getD lv.goal []) lv.target := hw.1
  have h2 := countOf_getD_le_netCount st'.net lv.goal lv.target
  have h3 := run_conserves lv ms st st' h lv.target
  omega

/-! ## A concrete level, a winning play, and some rejected ones -/

open ClaimLifecycle in
/-- Level 1 of the demo site. -/
def level1 : Level where
  limit := fun _ => 64
  root := "disk/factory".toList
  target := "minecraft:iron_ingot"
  goal := 2
  quota := 30

/-- The starting position: iron and dirt in the input chest, an empty buffer and
an empty output chest, every gate off, a filter that admits nothing, and a fresh
claim. -/
def start1 : GameState where
  net :=
    [[some ⟨"minecraft:iron_ingot", 40⟩, some ⟨"minecraft:dirt", 12⟩, none, none],
     [none, none, none, none],
     [none, none, none, none]]
  gates := 0
  claim := ClaimLifecycle.newClaim
  cwd := "disk/factory".toList
  filter := ""
  moved := 0

/-- A winning play: power the buffer, run the compiled daemon, set a filter that
admits iron only, power the output chest, move the iron across, and walk the
claim through the router's state machine. -/
def solution1 : List Move :=
  [ .wire 1 true,
    .runDaemon 50,
    .setFilter "minecraft:iron*",
    .wire 2 true,
    .cd "orders",
    .push 1 0 2 0 40,
    .advance ClaimLifecycle.Status.inTransit,
    .advance ClaimLifecycle.Status.arrived,
    .advance ClaimLifecycle.Status.delivering,
    .advance ClaimLifecycle.Status.completed ]

/-- **The play wins.** -/
theorem solution1_wins : solved level1 (run level1 start1 solution1) = true := by
  native_decide

/-- Four advances, the most a play can contain. -/
theorem solution1_advCount : advCount solution1 = 4 := by decide

/-! ### Level 2: two stacks, a side chest, and a filter with alternatives -/

/-- Level 2 of the demo site: a bigger order, and a fourth chest. -/
def level2 : Level where
  limit := fun _ => 64
  root := "disk/factory".toList
  target := "mekanism:ingot_osmium"
  goal := 3
  quota := 50

/-- The starting position of level 2: the order is larger than any single stack,
so two stacks have to be merged in the output chest. -/
def start2 : GameState where
  net :=
    [[some ⟨"mekanism:ingot_osmium", 30⟩, some ⟨"mekanism:dust_iron", 20⟩,
      some ⟨"mekanism:ingot_osmium", 25⟩, none],
     [none, none, none, none],
     [some ⟨"mekanism:ingot_osmium", 10⟩, none, none, none],
     [none, none, none, none]]
  gates := 0
  claim := ClaimLifecycle.newClaim
  cwd := "disk/factory".toList
  filter := ""
  moved := 0

/-- A winning play for level 2.  It also switches a gate back off, which is the
`colors.subtract` half of the bundled-cable API. -/
def solution2 : List Move :=
  [ .wire 1 true,
    .runDaemon 50,
    .wire 1 false,
    .setFilter "*ingot_osmium|*ingot",
    .wire 3 true,
    .cd "orders/osmium",
    .push 1 0 3 0 30,
    .push 1 2 3 0 25,
    .advance ClaimLifecycle.Status.inTransit,
    .advance ClaimLifecycle.Status.arrived,
    .advance ClaimLifecycle.Status.delivering,
    .advance ClaimLifecycle.Status.completed ]

/-- **The level 2 play wins.** -/
theorem solution2_wins : solved level2 (run level2 start2 solution2) = true := by
  native_decide

-- The dust the daemon also carried into the buffer is not admitted by the filter.
#guard (run level2 start2
  [.wire 1 true, .runDaemon 50, .setFilter "*ingot_osmium|*ingot", .wire 3 true,
   .push 1 1 3 1 20]).isNone

-- A transfer into a chest whose gate is off is refused.
#guard (run level1 start1 [.setFilter "*", .push 0 0 2 0 40]).isNone

-- So is a transfer of an item the filter does not admit.
#guard (run level1 start1
  [.wire 2 true, .setFilter "minecraft:iron*", .push 0 1 2 0 12]).isNone

-- The claim cannot be jumped straight to `completed`.
#guard (run level1 start1 [.advance ClaimLifecycle.Status.completed]).isNone

-- And the player cannot climb out of the level root.
#guard (run level1 start1 [.cd ".."]).isNone
#guard (run level1 start1 [.cd "orders/../.."]).isNone
#guard (run level1 start1 [.cd "orders/../pending"]).isSome

end Factory
