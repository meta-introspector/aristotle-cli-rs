import RequestProject.Gvcs.Realm.Chain

/-!
# Staking on a game

Two players each lock a bond somewhere public and start playing.  Every move,
the mover publishes a page and the digest of that page's transcript; the digest
is the only thing that has to go on a chain.  When the game is over — or when
one player claims the other broke the rules — the escrow is settled from the
transcript alone.

* `culprit` — who was to move when the first bad move was made.  A fraud proof
  is the index of that move; `culprit_isSome` says a fraud proof always names
  somebody, because everything before the bad move replays.
* `settle` — the payout: a cheat loses the pot, a winner takes the pot, an
  unfinished or drawn game is refunded.
* `settle_conserves` — **the escrow is never created or destroyed**: whatever
  happens, the two payouts add up to the two bonds.
* `settle_refund_of_unfinished`, `settle_pays_winner`, `vale_not_slashed`,
  `horde_not_slashed` — a player who neither breaks a rule nor loses the game
  keeps their bond.  This is the property that makes it safe to stake: the only
  way to lose money is to cheat or to be beaten, and both are checkable by
  anyone holding the page.
-/

namespace LifeTrac
namespace Realm

/-- The pot to the side named, or the bonds back if nobody is named. -/
def potTo : Option Side → Nat → Nat × Nat
  | some false, bond => (2 * bond, 0)
  | some true, bond => (0, 2 * bond)
  | none, bond => (bond, bond)

theorem potTo_conserves (b : Option Side) (bond : Nat) :
    (potTo b bond).1 + (potTo b bond).2 = 2 * bond := by
  match b with
  | none => simp [potTo]; omega
  | some true => simp [potTo]
  | some false => simp [potTo]

/-- Who was to move when the game first went wrong, if it did. -/
def culprit (ms : List Move) : Option Side :=
  (firstBad ms).bind (fun i => (run (ms.take i)).map (·.turn))

/-- **A fraud proof names somebody.**  Everything before the first bad move
replays, so the position it was made from — and therefore the player who made
it — is determined by the transcript. -/
theorem culprit_isSome {ms : List Move} {i : Nat} (h : firstBad ms = some i) :
    ∃ b, culprit ms = some b := by
  obtain ⟨_, h2, _⟩ := firstBad_spec h
  unfold culprit
  rw [h]
  cases hr : run (ms.take i) with
  | none => rw [valid, hr] at h2; simp at h2
  | some s => exact ⟨s.turn, by simp [hr]⟩

/-- A game nobody has cheated at has no culprit. -/
theorem culprit_eq_none_of_valid {ms : List Move} (h : valid ms = true) : culprit ms = none := by
  simp [culprit, firstBad_eq_none_iff.mpr h]

/-- Settling the escrow, when each side has locked `bond`.  The pair is what the
Ash Vale and the Iron Horde walk away with: the pot goes to the other side if
somebody cheated, otherwise to the winner, otherwise back where it came from. -/
def settle (ms : List Move) (bond : Nat) : Nat × Nat :=
  match culprit ms with
  | some c => potTo (some (!c)) bond
  | none => potTo ((run ms).bind winner) bond

/-- **Nothing is minted and nothing is burned.**  However the game went, the two
payouts are exactly the two bonds. -/
theorem settle_conserves (ms : List Move) (bond : Nat) :
    (settle ms bond).1 + (settle ms bond).2 = 2 * bond := by
  unfold settle
  cases culprit ms with
  | some c => exact potTo_conserves _ _
  | none => exact potTo_conserves _ _

/-- A legal game that nobody has won yet is refunded. -/
theorem settle_refund_of_unfinished {ms : List Move} {bond : Nat} (hv : valid ms = true)
    (hw : (run ms).bind winner = none) : settle ms bond = (bond, bond) := by
  unfold settle
  rw [culprit_eq_none_of_valid hv, hw]
  rfl

/-- A legal game that somebody has won pays the pot to the winner. -/
theorem settle_pays_winner {ms : List Move} {bond : Nat} {s : State} {w : Side}
    (hv : run ms = some s) (hw : winner s = some w) :
    settle ms bond = potTo (some w) bond := by
  have hvalid : valid ms = true := by unfold valid; rw [hv]; rfl
  unfold settle
  rw [culprit_eq_none_of_valid hvalid, hv]
  simp [hw]

/-- **The Ash Vale keeps its bond unless it cheats or is beaten.**  If it walks
away with nothing, then either the first illegal move of the game was its own,
or the game was legal and the Iron Horde won it. -/
theorem vale_not_slashed {ms : List Move} {bond : Nat} (hb : 0 < bond)
    (h : (settle ms bond).1 = 0) :
    culprit ms = some false ∨ (valid ms = true ∧ (run ms).bind winner = some true) := by
  unfold settle at h
  cases hc : culprit ms with
  | some c =>
    rw [hc] at h
    cases c
    · exact Or.inl rfl
    · simp [potTo] at h; omega
  | none =>
    rw [hc] at h
    cases hw : (run ms).bind winner with
    | none => rw [hw] at h; simp [potTo] at h; omega
    | some b =>
      cases b
      · rw [hw] at h; simp [potTo] at h; omega
      · refine Or.inr ⟨?_, rfl⟩
        unfold valid
        cases hr : run ms with
        | none => rw [hr] at hw; simp at hw
        | some s => rfl

/-- **The Iron Horde keeps its bond unless it cheats or is beaten.** -/
theorem horde_not_slashed {ms : List Move} {bond : Nat} (hb : 0 < bond)
    (h : (settle ms bond).2 = 0) :
    culprit ms = some true ∨ (valid ms = true ∧ (run ms).bind winner = some false) := by
  unfold settle at h
  cases hc : culprit ms with
  | some c =>
    rw [hc] at h
    cases c
    · simp [potTo] at h; omega
    · exact Or.inl rfl
  | none =>
    rw [hc] at h
    cases hw : (run ms).bind winner with
    | none => rw [hw] at h; simp [potTo] at h; omega
    | some b =>
      cases b
      · refine Or.inr ⟨?_, rfl⟩
        unfold valid
        cases hr : run ms with
        | none => rw [hr] at hw; simp at hw
        | some s => rfl
      · rw [hw] at h; simp [potTo] at h; omega

end Realm
end LifeTrac
