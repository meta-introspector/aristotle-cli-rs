import Mathlib
import RequestProject.Gvcs.Henge.Calendar
import RequestProject.Gvcs.Henge.ClockTower

/-!
# Henge Tycoon: the rules of the game

The game the page plays.  A player quarries stone, raises parts of a henge, a
clock tower and an observatory, lets days pass, and mints a *token* — a picture
of the build at a moment — which then earns stake for every day it is held.

Everything here is a total, decidable function on a small record, so the same
rules can be replayed by a browser and checked by hand.  What is proved:

* `solvent_run` — **the balance never reaches zero.**  Starting solvent, no
  legal sequence of moves can leave the player broke; illegal moves are refused
  rather than allowed to overdraw.
* `run_memes` — **the token count is exactly the number of mints.**  A save
  cannot claim more tokens than the play that produced it contains.
* `hold_stake` — **holding earns.**  Waiting `n` days with `k` tokens held adds
  exactly `n * k` stake, so a longer hold is worth strictly more.
* `score_run_mono`, `unlocked_run_mono` — score never falls and a badge, once
  unlocked, stays unlocked.
* `decodeSave_encodeSave` — **saving and loading round-trip**, so a shared code
  is the save it claims to be.
-/

namespace LifeTrac
namespace Henge

/-! ## Parts -/

/-- A thing the player can put in the world. -/
inductive Part
  | sarsen | lintel | bluestone | heelStone
  | gear | dial | bell
  | lens | plinth | sticker
deriving DecidableEq, Repr, Inhabited

/-- Every part, in build order. -/
def allParts : List Part :=
  [.sarsen, .lintel, .bluestone, .heelStone, .gear, .dial, .bell, .lens, .plinth, .sticker]

/-- What a part costs to place. -/
def partCost : Part → ℕ
  | .sarsen => 5 | .lintel => 8 | .bluestone => 3 | .heelStone => 12
  | .gear => 6 | .dial => 10 | .bell => 15
  | .lens => 20 | .plinth => 4 | .sticker => 1

/-- What a part is worth to the score. -/
def partScore : Part → ℕ
  | .sarsen => 10 | .lintel => 25 | .bluestone => 6 | .heelStone => 40
  | .gear => 12 | .dial => 30 | .bell => 45
  | .lens => 60 | .plinth => 8 | .sticker => 1

theorem partCost_pos (p : Part) : 0 < partCost p := by cases p <;> decide

/-! ## The save -/

/-- Everything the game remembers. -/
structure Save where
  day : ℕ
  coins : ℕ
  parts : List Part
  memes : ℕ
  stake : ℕ
deriving DecidableEq, Repr

/-- The opening position: one coin, one day, nothing built. -/
def newGame : Save := { day := 0, coins := 10, parts := [], memes := 0, stake := 0 }

/-- How many of a part are standing. -/
def countOf (s : Save) (p : Part) : ℕ := s.parts.count p

/-- The build score: the parts, plus five a token. -/
def score (s : Save) : ℕ := (s.parts.map partScore).sum + 5 * s.memes

/-! ## Moves -/

/-- What a player can do in a turn. -/
inductive Move
  | quarry
  | place (p : Part)
  | nextDay
  | mint
deriving DecidableEq, Repr

/-- What a part needs standing before it can go up: a lintel needs two sarsens
under it, a dial needs a gear, a bell needs a dial, a lens needs a plinth. -/
def prereqOk (s : Save) : Part → Bool
  | .lintel => 2 ≤ countOf s .sarsen
  | .dial => 1 ≤ countOf s .gear
  | .bell => 1 ≤ countOf s .dial
  | .lens => 1 ≤ countOf s .plinth
  | _ => true

/-- What minting a token costs. -/
def mintFee : ℕ := 7

/-- The score a build needs before it is worth minting. -/
def mintThreshold : ℕ := 20

/-- One turn.  A move that cannot be paid for, or whose parts are not standing,
is refused; nothing ever goes into the red. -/
def step (s : Save) : Move → Option Save
  | .quarry => some { s with coins := s.coins + 3 }
  | .place p =>
      if partCost p < s.coins ∧ prereqOk s p then
        some { s with coins := s.coins - partCost p, parts := p :: s.parts }
      else none
  | .nextDay => some { s with day := s.day + 1, coins := s.coins + 1, stake := s.stake + s.memes }
  | .mint =>
      if mintFee < s.coins ∧ mintThreshold ≤ score s then
        some { s with coins := s.coins - mintFee, memes := s.memes + 1 }
      else none

/-- A whole play. -/
def run (s : Save) : List Move → Option Save
  | [] => some s
  | m :: ms => (step s m).bind (fun t => run t ms)

@[simp] theorem run_nil (s : Save) : run s [] = some s := rfl

theorem run_cons (s : Save) (m : Move) (ms : List Move) :
    run s (m :: ms) = (step s m).bind (fun t => run t ms) := rfl

theorem run_append (s : Save) (ms ns : List Move) :
    run s (ms ++ ns) = (run s ms).bind (fun t => run t ns) := by
  induction ms generalizing s with
  | nil => simp
  | cons m ms ih =>
      rw [List.cons_append, run_cons, run_cons]
      cases step s m with
      | none => simp
      | some t => simpa using ih t

/-! ## The balance never reaches zero -/

/-- A save is solvent when the player still has a coin. -/
def Solvent (s : Save) : Prop := 0 < s.coins

/-- One legal move always leaves the player with a coin: a move that would
spend the last coin is refused, so solvency of the *previous* position is not
even needed. -/
theorem solvent_step {s t : Save} {m : Move} (h : step s m = some t) : Solvent t := by
  cases m with
  | quarry => cases h; simp [Solvent]
  | place p =>
      simp only [step] at h
      split at h
      · rename_i hc
        cases h
        simp only [Solvent] at *
        omega
      · exact absurd h (by simp)
  | nextDay => cases h; simp [Solvent]
  | mint =>
      simp only [step] at h
      split at h
      · rename_i hc
        cases h
        simp only [Solvent] at *
        omega
      · exact absurd h (by simp)

/-- **The balance never reaches zero.**  A play that starts solvent ends
solvent, whatever the player does. -/
theorem solvent_run {s t : Save} {ms : List Move} (hs : Solvent s) (h : run s ms = some t) :
    Solvent t := by
  induction ms generalizing s with
  | nil => cases h; exact hs
  | cons m ms ih =>
      rw [run_cons] at h
      cases hstep : step s m with
      | none => rw [hstep] at h; simp at h
      | some u =>
          rw [hstep] at h
          exact ih (solvent_step hstep) (by simpa using h)

/-- The opening position is solvent. -/
theorem newGame_solvent : Solvent newGame := by norm_num [Solvent, newGame]

/-! ## Tokens are counted, not claimed -/

theorem memes_step {s t : Save} {m : Move} (h : step s m = some t) :
    t.memes = s.memes + (if m = Move.mint then 1 else 0) := by
  cases m <;> simp only [step] at h
  · cases h; simp
  · split at h
    · cases h; simp
    · exact absurd h (by simp)
  · cases h; simp
  · split at h
    · cases h; simp
    · exact absurd h (by simp)

/-- **A save cannot claim more tokens than it minted.**  After a play, the token
count is exactly the starting count plus the number of `mint` moves. -/
theorem run_memes {s t : Save} {ms : List Move} (h : run s ms = some t) :
    t.memes = s.memes + ms.count Move.mint := by
  induction ms generalizing s with
  | nil => cases h; simp
  | cons m ms ih =>
      rw [run_cons] at h
      cases hstep : step s m with
      | none => rw [hstep] at h; simp at h
      | some u =>
          rw [hstep] at h
          have hu := ih (by simpa using h)
          have hm := memes_step hstep
          rw [hu, hm, List.count_cons]
          by_cases hmm : m = Move.mint
          · subst hmm; simp; omega
          · simp [hmm]

/-! ## Holding earns -/

/-- Wait `n` days. -/
def holdDays (n : ℕ) : List Move := List.replicate n Move.nextDay

/-- **Every day held earns more.**  Holding `k` tokens for `n` days adds exactly
`n * k` stake, and moves the calendar on `n` days. -/
theorem hold_stake (s : Save) (n : ℕ) :
    run s (holdDays n) =
      some { s with day := s.day + n, coins := s.coins + n, stake := s.stake + n * s.memes } := by
  induction n generalizing s with
  | zero => simp [holdDays]
  | succ n ih =>
      rw [holdDays, List.replicate_succ, run_cons]
      simp only [step, Option.bind_some]
      rw [show (List.replicate n Move.nextDay) = holdDays n from rfl, ih]
      congr 1
      simp only [Save.mk.injEq]
      and_intros <;> first | omega | ring | trivial

/-- Holding strictly longer is strictly better, as long as a token is held. -/
theorem hold_strict {s : Save} (hk : 0 < s.memes) {m n : ℕ} (hmn : m < n)
    {a b : Save} (ha : run s (holdDays m) = some a) (hb : run s (holdDays n) = some b) :
    a.stake < b.stake := by
  rw [hold_stake] at ha hb
  have ha' := Option.some_inj.1 ha
  have hb' := Option.some_inj.1 hb
  subst ha'; subst hb'
  have hlt : m * s.memes < n * s.memes := Nat.mul_lt_mul_of_pos_right hmn hk
  exact Nat.add_lt_add_left hlt _

/-! ## Score and badges -/

theorem score_step {s t : Save} {m : Move} (h : step s m = some t) : score s ≤ score t := by
  cases m <;> simp only [step] at h
  · cases h; simp [score]
  · split at h
    · cases h; simp [score]
    · exact absurd h (by simp)
  · cases h; simp [score]
  · split at h
    · cases h; simp [score]
    · exact absurd h (by simp)

theorem score_run_mono {s t : Save} {ms : List Move} (h : run s ms = some t) :
    score s ≤ score t := by
  induction ms generalizing s with
  | nil => cases h; exact le_refl _
  | cons m ms ih =>
      rw [run_cons] at h
      cases hstep : step s m with
      | none => rw [hstep] at h; simp at h
      | some u =>
          rw [hstep] at h
          exact le_trans (score_step hstep) (ih (by simpa using h))

/-- A badge: a name and the score that earns it. -/
structure Badge where
  name : String
  need : ℕ
deriving DecidableEq, Repr

/-- The badges, in order of difficulty. -/
def badges : List Badge :=
  [⟨"First Stone", 10⟩, ⟨"Trilithon", 45⟩, ⟨"Circle", 120⟩,
   ⟨"Clockwork", 200⟩, ⟨"Bellringer", 300⟩, ⟨"Stargazer", 450⟩, ⟨"Henge Tycoon", 700⟩]

/-- The badges a save has earned. -/
def unlocked (s : Save) : List Badge := badges.filter (fun b => b.need ≤ score s)

/-- **A badge, once earned, is never lost.** -/
theorem unlocked_run_mono {s t : Save} {ms : List Move} (h : run s ms = some t) :
    ∀ b ∈ unlocked s, b ∈ unlocked t := by
  intro b hb
  rw [unlocked, List.mem_filter] at hb ⊢
  exact ⟨hb.1, by
    have := score_run_mono h
    have hbs : b.need ≤ score s := by simpa using hb.2
    simpa using le_trans hbs this⟩

/-! ## Saving and loading -/

/-- A part, as a number. -/
def partCode : Part → ℕ
  | .sarsen => 0 | .lintel => 1 | .bluestone => 2 | .heelStone => 3
  | .gear => 4 | .dial => 5 | .bell => 6
  | .lens => 7 | .plinth => 8 | .sticker => 9

/-- A number, as a part. -/
def partOfCode : ℕ → Option Part
  | 0 => some .sarsen | 1 => some .lintel | 2 => some .bluestone | 3 => some .heelStone
  | 4 => some .gear | 5 => some .dial | 6 => some .bell
  | 7 => some .lens | 8 => some .plinth | 9 => some .sticker
  | _ => none

@[simp] theorem partOfCode_partCode (p : Part) : partOfCode (partCode p) = some p := by
  cases p <;> rfl

/-- The save, as a list of numbers: the code a player shares. -/
def encodeSave (s : Save) : List ℕ :=
  s.day :: s.coins :: s.memes :: s.stake :: s.parts.map partCode

/-- A list of numbers, read back as a save. -/
def decodeSave : List ℕ → Option Save
  | d :: c :: m :: k :: rest =>
      (rest.mapM partOfCode).map
        (fun ps => ({ day := d, coins := c, parts := ps, memes := m, stake := k } : Save))
  | _ => none

theorem mapM_partOfCode (ps : List Part) : (ps.map partCode).mapM partOfCode = some ps := by
  induction ps with
  | nil => rfl
  | cons p ps ih =>
      simp only [List.map_cons, List.mapM_cons, partOfCode_partCode, ih]
      rfl

/-- **Saving and loading round-trip.**  A shared code is exactly the save it
was made from. -/
theorem decodeSave_encodeSave (s : Save) : decodeSave (encodeSave s) = some s := by
  cases s
  simp only [encodeSave, decodeSave, mapM_partOfCode, Option.map_some]

/-- **Two different saves never share a code.** -/
theorem encodeSave_injective : Function.Injective encodeSave := by
  intro a b hab
  have ha := decodeSave_encodeSave a
  rw [hab, decodeSave_encodeSave b] at ha
  exact (Option.some_inj.1 ha).symm

/-! ## A worked play -/

/-- A short opening: quarry, raise two sarsens, lay a lintel. -/
def opening : List Move :=
  [.quarry, .quarry, .place .sarsen, .quarry, .place .sarsen, .quarry, .quarry,
   .place .lintel, .nextDay]

theorem opening_runs : run newGame opening =
    some { day := 1, coins := 8, parts := [.lintel, .sarsen, .sarsen], memes := 0, stake := 0 } := by
  decide

theorem opening_score : (run newGame opening).map score = some 45 := by decide

theorem opening_unlocks :
    (run newGame opening).map (fun s => (unlocked s).map Badge.name) =
      some ["First Stone", "Trilithon"] := by
  decide

end Henge
end LifeTrac
