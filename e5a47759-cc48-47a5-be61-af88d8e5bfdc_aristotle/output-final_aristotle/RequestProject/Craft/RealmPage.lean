import RequestProject.Craft.RealmChain

/-!
# Pages: one static file per move

A **page** is exactly what a player publishes after making a move: the opening
position and every block of the game so far.  Nothing else — no server, no state
kept anywhere.  `Page.valid` is the whole check a reader has to run, and
`Page.commit` is the single number that goes on chain.

The theorems here are the ones a player needs before staking on a page:

* `page_valid` — the page you publish after any number of moves verifies;
* `page_extends` — the next page contains this one, block for block, so a page
  really does carry the whole history;
* `page_states` — every state hash on the page is the hash of the position the
  moves on the page actually reach, so "all previous game states" is not just a
  claim: it is checkable, and the positions themselves can be recomputed
  (`page_replay`);
* `page_commit_unique` — under collision-freedom, two verified pages with the
  same committed number are the same page.
-/

namespace Realm

/-- A published page. -/
structure Page where
  /-- the opening position, printed in full on every page -/
  init : State
  /-- one block per move played so far -/
  blocks : List Block
  deriving DecidableEq, Repr, Inhabited

/-- The moves the page claims were played. -/
def Page.moves (p : Page) : List Move := p.blocks.map Block.mv

/-- The check a reader runs, using nothing but the page. -/
def Page.valid (p : Page) : Bool := verify p.init p.blocks

/-- The number the player commits on chain. -/
def Page.commit (p : Page) : Nat := headHash p.init p.blocks

/-- Every position of the game, recomputed from the page. -/
def Page.states (p : Page) : List State := trace p.init p.moves

/-- The position the page ends in. -/
def Page.final (p : Page) : Option State := play p.init p.moves

/-- The page published after the first `n` moves of the game `ms`. -/
def pageOf (st : State) (ms : List Move) (n : Nat) : Page := ⟨st, (record st ms).take n⟩

theorem take_prefix_take_succ {α} (l : List α) (n : Nat) : l.take n <+: l.take (n + 1) := by
  have h : (l.take (n + 1)).take n = l.take n := by
    rw [List.take_take]
    congr 1
    omega
  rw [← h]
  exact List.take_prefix _ _

/-- Publishing a page after any number of moves publishes a page that verifies. -/
theorem page_valid (st : State) (ms : List Move) (n : Nat) : (pageOf st ms n).valid = true := by
  unfold Page.valid pageOf
  refine verify_prefix (cs := (record st ms).drop n) ?_
  rw [List.take_append_drop]
  exact verify_record st ms

/-- Each page contains the page before it, block for block: nothing of the history
is dropped or rewritten when a move is played. -/
theorem page_extends (st : State) (ms : List Move) (n : Nat) :
    (pageOf st ms n).blocks <+: (pageOf st ms (n + 1)).blocks :=
  take_prefix_take_succ _ _

/-- A page of a game is a page of the same game played on. -/
theorem page_of_extension (st : State) (ms ns : List Move) (n : Nat) :
    (pageOf st ms n).blocks <+: (pageOf st (ms ++ ns) (n + 1)).blocks := by
  refine List.IsPrefix.trans ?_ (take_prefix_take_succ (record st (ms ++ ns)) n)
  exact List.IsPrefix.take (record_prefix st ms ns) n

/-- The states the page records are the states the game really passes through. -/
theorem page_states (p : Page) (h : p.valid = true) (i : Nat) (hi : i < p.blocks.length) :
    ∃ s, play p.init (p.moves.take (i + 1)) = some s ∧ p.blocks[i].state = hashState s :=
  verify_states h i hi

/-- A valid page replays: all of it, from the opening position, by the rules. -/
theorem page_replay (p : Page) (h : p.valid = true) : (play p.init p.moves).isSome :=
  verify_playable h

theorem trace_length {st : State} {ms : List Move} (h : (play st ms).isSome) :
    (trace st ms).length = ms.length + 1 := by
  induction ms generalizing st with
  | nil => rfl
  | cons m ms ih =>
    rw [play] at h
    cases hstep : step st m with
    | none => rw [hstep] at h; simp at h
    | some st' =>
      rw [hstep] at h
      simp only [Option.bind_some] at h
      rw [show trace st (m :: ms) = (match step st m with
        | none => [st]
        | some st' => st :: trace st' ms) from rfl, hstep]
      simp only [List.length_cons]
      rw [ih h]

/-- A valid page holds one recomputed position per move, plus the opening one. -/
theorem page_states_length (p : Page) (h : p.valid = true) :
    p.states.length = p.blocks.length + 1 := by
  unfold Page.states
  rw [trace_length (ms := p.moves) (verify_playable h), Page.moves, List.length_map]

/-- Under collision-freedom, the committed number determines the page. -/
theorem page_commit_unique (hinj : Function.Injective hashWords) {p q : Page}
    (hp : p.valid = true) (hq : q.valid = true) (hi : p.init = q.init)
    (hc : p.commit = q.commit) : p = q := by
  obtain ⟨pi, pb⟩ := p
  obtain ⟨qi, qb⟩ := q
  simp only at hi
  subst hi
  simp only [Page.valid] at hp hq
  simp only [Page.commit] at hc
  simp only [Page.mk.injEq, true_and]
  exact verify_head_unique hinj hp hq hc

/-! ## Staking

A player stakes a bond on the page they publish.  A challenger who thinks the page
is a forgery presents it to the judge, who verifies it — the whole check being
`Page.valid` together with "this is the page you committed to".  Nothing else is
needed, and in particular the judge keeps no state of the game. -/

/-- A staked claim: *this page is the history, and this is the number I committed.* -/
structure Claim where
  /-- the published page -/
  page : Page
  /-- who published it -/
  player : Nat
  /-- what they staked on it -/
  bond : Nat
  /-- the number they put on chain -/
  commit : Nat
  deriving DecidableEq, Repr, Inhabited

/-- The judge's test: the page verifies, and it is the page that was committed. -/
def Claim.honest (c : Claim) : Bool := c.page.valid && c.commit == c.page.commit

/-- The judge's verdict: what goes back to the claimant, and what to the challenger. -/
def settle (c : Claim) : Nat × Nat := if c.honest then (c.bond, 0) else (0, c.bond)

/-- Settling a challenge moves money around but never creates or destroys any. -/
theorem settle_conserves (c : Claim) : (settle c).1 + (settle c).2 = c.bond := by
  unfold settle; split <;> simp

/-- An honest player keeps the whole bond, whoever challenges. -/
theorem settle_honest (c : Claim) (h : c.honest = true) : settle c = (c.bond, 0) := by
  simp [settle, h]

/-- A forged page is slashed in full. -/
theorem settle_forged (c : Claim) (h : c.honest = false) : settle c = (0, c.bond) := by
  simp [settle, h]

/-- Slashable is exactly "the page does not verify, or is not the page committed". -/
theorem slashable_iff (c : Claim) :
    (settle c).1 = 0 ∧ 0 < c.bond ↔ (c.page.valid = false ∨ c.commit ≠ c.page.commit) ∧ 0 < c.bond := by
  unfold settle
  by_cases h : c.honest = true
  · rw [if_pos h]
    simp only [Claim.honest, Bool.and_eq_true, beq_iff_eq] at h
    simp [h.1, h.2]
  · rw [if_neg h]
    simp only [Claim.honest, Bool.and_eq_true, beq_iff_eq, not_and_or,
      Bool.not_eq_true] at h
    simp [h]

/-- **Playing by the rules is safe.**  A player who publishes the page of the moves
they actually played, and commits its hash, can never be slashed. -/
theorem play_never_slashed (st : State) (ms : List Move) (n : Nat) (player bond : Nat) :
    settle ⟨pageOf st ms n, player, bond, (pageOf st ms n).commit⟩ = (bond, 0) := by
  apply settle_honest
  simp [Claim.honest, page_valid]

/-- **A rival history cannot be produced.**  Under collision-freedom, an honest
claim and any other honest claim on the same opening position and the same
committed number are claims about the very same page. -/
theorem honest_claims_agree (hinj : Function.Injective hashWords) {c d : Claim}
    (hc : c.honest = true) (hd : d.honest = true) (hi : c.page.init = d.page.init)
    (h : c.commit = d.commit) : c.page = d.page := by
  simp [Claim.honest, Bool.and_eq_true, beq_iff_eq] at hc hd
  exact page_commit_unique hinj hc.1 hd.1 hi (by rw [← hc.2, ← hd.2, h])

end Realm
