import RequestProject.Gvcs.Sneakernet.Fhe
import RequestProject.Gvcs.Sneakernet.Uucp

/-!
# Sealed moves: a multiplayer game played by post

A `SealedGame` is a turn-based game whose *rule book* is a boolean circuit:
the state and the move are encoded as bits, and one circuit decides whether the
move is legal.  Because the rule book is a circuit, it can be evaluated
homomorphically: a relay that holds only ciphertexts can compute an encrypted
verdict for a mailed move, and the referee decrypts a single bit to learn
whether the move may be applied.

The guarantees:

* `verdict_correct` — the sealed verdict computed on ciphertexts decrypts to
  the true legality of the move; a player cannot mail in an illegal move and
  have it accepted, and cannot have a legal move rejected;
* `verdict_correct_boot` — the same with bootstrapping, so the rule book may be
  a circuit of any depth;
* `refereeStep_legal` and `reach_runMail` — **no cheating**: the referee's
  state only ever changes by a legal move, so whatever arrives in the post, the
  resulting position is reachable by legal play;
* `runMail_append` — mail may be processed in any number of batches;
* `mail_no_cheat` — the same statement for moves that travelled over the
  sneakernet of `Uucp.lean`.

`Patch` at the end is a concrete instance: a 2×2 patch of ground that players
dig and fill, with its rule book given as an explicit seven-input circuit and
its specification checked exhaustively.
-/

namespace LifeTrac
namespace Sneakernet

/-- A game whose legality test is a boolean circuit, so it can be checked on
ciphertexts. -/
structure SealedGame where
  /-- Positions of the game. -/
  State : Type
  /-- Moves of the game. -/
  Move : Type
  /-- Number of bits in the encoding of a position. -/
  ns : ℕ
  /-- Number of bits in the encoding of a move. -/
  nm : ℕ
  /-- The rule book, in the clear. -/
  legal : State → Move → Bool
  /-- The effect of a move. -/
  apply : State → Move → State
  /-- Bit encoding of a position. -/
  encodeState : State → Fin ns → Bool
  /-- Bit encoding of a move. -/
  encodeMove : Move → Fin nm → Bool
  /-- The rule book as a circuit on the state bits followed by the move bits. -/
  circuit : BCirc (ns + nm)
  /-- The circuit is the rule book. -/
  circuit_spec : ∀ s a,
    circuit.eval (Fin.append (encodeState s) (encodeMove a)) = legal s a

namespace SealedGame

variable (G : SealedGame)

/-- The bits the rule book reads: the position, then the move. -/
def bits (s : G.State) (a : G.Move) : Fin (G.ns + G.nm) → Bool :=
  Fin.append (G.encodeState s) (G.encodeMove a)

/-- The relay's computation: the rule book run on ciphertexts.  The relay never
sees the move. -/
def verdictCt (cs : Fin (G.ns + G.nm) → ℤ) : ℤ := G.circuit.evalEnc cs

/-- The relay's computation with a refresh after every gate. -/
def verdictCtBoot {p B : ℤ} (R : Refresh p B)
    (cs : Fin (G.ns + G.nm) → ℤ) : ℤ := G.circuit.evalR R cs

/-- **The sealed verdict is the truth.**  If the ciphertexts really do encrypt
the bits of the position and of the move, then the verdict the relay produces
decrypts to the legality of that move. -/
theorem verdict_correct {p B : ℤ} {s : G.State} {a : G.Move}
    {cs : Fin (G.ns + G.nm) → ℤ} (hcs : ∀ i, Enc p B (G.bits s a i) (cs i))
    (hfit : BCirc.bound B G.circuit < p) :
    dec p (G.verdictCt cs) = G.legal s a := by
  rw [verdictCt, BCirc.dec_evalEnc hcs G.circuit hfit]
  exact G.circuit_spec s a

/-- The bootstrapped version: with recryption the rule book may be a circuit of
any size and depth. -/
theorem verdict_correct_boot {p B : ℤ} (R : Refresh p B) (hB : 1 ≤ B)
    (hfit : BCirc.gateBound B < p) {s : G.State} {a : G.Move}
    {cs : Fin (G.ns + G.nm) → ℤ} (hcs : ∀ i, Enc p B (G.bits s a i) (cs i)) :
    dec p (G.verdictCtBoot R cs) = G.legal s a := by
  rw [verdictCtBoot, BCirc.dec_evalR R hB hfit hcs G.circuit]
  exact G.circuit_spec s a

/-! ### Playing by post -/

/-- Positions reachable from `s` by legal play. -/
inductive Reach : G.State → G.State → Prop
  | refl (s : G.State) : Reach s s
  | step {s t : G.State} (h : Reach s t) (a : G.Move) (hl : G.legal t a = true) :
      Reach s (G.apply t a)

theorem Reach.trans {s t u : G.State} (h₁ : G.Reach s t) (h₂ : G.Reach t u) :
    G.Reach s u := by
  induction h₂ with
  | refl => exact h₁
  | step _ a hl ih => exact Reach.step ih a hl

/-- The referee applies a move only if the rule book accepts it. -/
def applyChecked (s : G.State) (a : G.Move) : G.State :=
  if G.legal s a then G.apply s a else s

theorem reach_applyChecked (s : G.State) (a : G.Move) : G.Reach s (G.applyChecked s a) := by
  unfold applyChecked
  by_cases h : G.legal s a = true
  · simp only [h, if_true]
    exact Reach.step (Reach.refl s) a h
  · simp only [Bool.not_eq_true] at h
    simp only [h, Bool.false_eq_true, if_false]
    exact Reach.refl s

/-- **Nothing changes except by a legal move.** -/
theorem applyChecked_legal {s : G.State} {a : G.Move} (h : G.applyChecked s a ≠ s) :
    G.legal s a = true := by
  by_contra hc
  simp only [Bool.not_eq_true] at hc
  exact h (by simp [applyChecked, hc])

/-- A sealed move as it travels: the ciphertext bits are what is carried, the
move itself is only known to its author and to the referee's key. -/
structure Sealed (G : SealedGame) where
  /-- The site that posted the move. -/
  author : String
  /-- The move being played. -/
  move : G.Move
  /-- The ciphertext bits actually carried. -/
  ct : Fin G.nm → ℤ

/-- The ciphertext really does carry the bits of the stated move. -/
def Sealed.Honest {G : SealedGame} (p B : ℤ) (m : Sealed G) : Prop :=
  ∀ i, Enc p B (G.encodeMove m.move i) (m.ct i)

/-- The referee's step: recompute the verdict from the encrypted position and
the encrypted move, decrypt the single verdict bit, and apply the move only if
it says yes. -/
def refereeStep {p : ℤ} (s : G.State) (sct : Fin G.ns → ℤ) (m : Sealed G) : G.State :=
  if dec p (G.verdictCt (Fin.append sct m.ct)) then G.apply s m.move else s

/-- Ciphertexts of the position bits and of the move bits together are
ciphertexts of the bits the rule book reads. -/
theorem enc_bits_append {p B : ℤ} {s : G.State} {a : G.Move}
    {sct : Fin G.ns → ℤ} {mct : Fin G.nm → ℤ}
    (hs : ∀ i, Enc p B (G.encodeState s i) (sct i))
    (hm : ∀ i, Enc p B (G.encodeMove a i) (mct i)) :
    ∀ i, Enc p B (G.bits s a i) (Fin.append sct mct i) := by
  intro i
  refine Fin.addCases (motive := fun j =>
    Enc p B (G.bits s a j) (Fin.append sct mct j)) ?_ ?_ i
  · intro j
    simpa [bits, Fin.append_left] using hs j
  · intro j
    simpa [bits, Fin.append_left, Fin.append_right] using hm j

/-- The sealed pipeline is exactly the checked application of the move: the
encryption changes nothing about which moves are accepted. -/
theorem refereeStep_eq_applyChecked {p B : ℤ} {s : G.State}
    {sct : Fin G.ns → ℤ} {m : Sealed G}
    (hs : ∀ i, Enc p B (G.encodeState s i) (sct i)) (hm : m.Honest p B)
    (hfit : BCirc.bound B G.circuit < p) :
    G.refereeStep (p := p) s sct m = G.applyChecked s m.move := by
  have hcs := G.enc_bits_append hs hm
  have := G.verdict_correct hcs hfit
  unfold refereeStep applyChecked
  rw [this]

/-- Whatever arrives in the post, the referee only ever moves to a legally
reachable position. -/
theorem reach_refereeStep {p B : ℤ} {s : G.State}
    {sct : Fin G.ns → ℤ} {m : Sealed G}
    (hs : ∀ i, Enc p B (G.encodeState s i) (sct i)) (hm : m.Honest p B)
    (hfit : BCirc.bound B G.circuit < p) :
    G.Reach s (G.refereeStep (p := p) s sct m) := by
  rw [G.refereeStep_eq_applyChecked hs hm hfit]
  exact G.reach_applyChecked s m.move

/-- Process a whole mailbag of moves, checking each one. -/
def runMail (s : G.State) : List G.Move → G.State
  | [] => s
  | a :: as => runMail (G.applyChecked s a) as

@[simp] theorem runMail_nil (s : G.State) : G.runMail s [] = s := rfl

@[simp] theorem runMail_cons (s : G.State) (a : G.Move) (as : List G.Move) :
    G.runMail s (a :: as) = G.runMail (G.applyChecked s a) as := rfl

/-- Mail may be processed in any number of batches. -/
theorem runMail_append (s : G.State) (as bs : List G.Move) :
    G.runMail s (as ++ bs) = G.runMail (G.runMail s as) bs := by
  induction as generalizing s with
  | nil => rfl
  | cons a as ih => simp [ih]

/-- **No cheating.**  However the mail is routed, delayed, duplicated or
reordered, the position the referee ends up in is one that legal play could
have produced. -/
theorem reach_runMail (s : G.State) (as : List G.Move) : G.Reach s (G.runMail s as) := by
  induction as generalizing s with
  | nil => exact Reach.refl s
  | cons a as ih => exact Reach.trans G (G.reach_applyChecked s a) (ih _)

/-- Moves arriving over the sneakernet: the payloads that landed in the inbox,
in whatever order the courier delivered them. -/
theorem mail_no_cheat (s : G.State) (w : Wire G.Move) {n : ℕ}
    (hn : Wire.maxHops w < n) (order : List G.Move)
    (h : (order : Multiset G.Move) = (Wire.steps w n).inbox.map Delivery.payload) :
    (order : Multiset G.Move) = Wire.payloads w ∧ G.Reach s (G.runMail s order) :=
  ⟨by rw [h, Wire.delivered_all w hn], G.reach_runMail s order⟩

end SealedGame

/-! ### A concrete game: a 2 × 2 patch of ground -/

namespace Patch

/-- The four cells of the patch: `true` is solid ground, `false` is a hole. -/
abbrev State := Fin 4 → Bool

/-- A move: which cell, and whether to dig (`true`) or to fill (`false`). -/
abbrev Move := Fin 4 × Bool

/-- Digging needs solid ground, filling needs a hole. -/
def legal (s : State) (a : Move) : Bool := if a.2 then s a.1 else !(s a.1)

/-- Digging leaves a hole, filling leaves solid ground. -/
def apply (s : State) (a : Move) : State := Function.update s a.1 (!a.2)

/-- The state bits are the four cells. -/
def encodeState (s : State) : Fin 4 → Bool := s

/-- The move bits: the two index bits, then the dig/fill bit. -/
def encodeMove (a : Move) : Fin 3 → Bool :=
  ![decide (a.1.val % 2 = 1), decide (a.1.val / 2 = 1), a.2]

open BCirc in
/-- `i`-th cell selected by the two index bits. -/
def selCirc : BCirc (4 + 3) :=
  .xor
    (.xor
      (.and (.and (.not (.var 4)) (.not (.var 5))) (.var 0))
      (.and (.and (.var 4) (.not (.var 5))) (.var 1)))
    (.xor
      (.and (.and (.not (.var 4)) (.var 5)) (.var 2))
      (.and (.and (.var 4) (.var 5)) (.var 3)))

/-- The rule book as a circuit: the move is legal exactly when the dig/fill bit
agrees with the selected cell. -/
def circuit : BCirc (4 + 3) := .not (.xor (.var 6) selCirc)

theorem circuit_spec (s : State) (a : Move) :
    circuit.eval (Fin.append (encodeState s) (encodeMove a)) = legal s a := by
  revert s a
  decide

/-- The 2×2 digging patch as a sealed game. -/
def game : SealedGame where
  State := State
  Move := Move
  ns := 4
  nm := 3
  legal := legal
  apply := Patch.apply
  encodeState := encodeState
  encodeMove := encodeMove
  circuit := circuit
  circuit_spec := circuit_spec

/-- Digging a hole that is already there is refused. -/
example : game.legal (fun _ => false) (0, true) = false := by decide

/-- Digging solid ground is allowed, and leaves a hole. -/
example : game.legal (fun _ => true) (0, true) = true := by decide

example : game.applyChecked (fun _ => true) (0, true) 0 = false := by decide

/-- A refused move leaves the patch exactly as it was. -/
example : ∀ i, game.applyChecked (fun _ => false) (0, true) i = false := by decide

end Patch

end Sneakernet
end LifeTrac
