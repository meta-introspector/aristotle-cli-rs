import Mathlib
import RequestProject.Solfunmeme.Meme.Engine

/-!
# What the FHME engine guarantees

The engine is a fold, so a play-through is reproducible by construction.  These
are the properties the rest of the system leans on:

* **Replay** — `run_append`, `Claim.verify_iff`: a verifier accepts exactly the
  honest play-throughs, and can do it incrementally.
* **Progress is permanent** — days, parts, memes, blocks, stake, and both ledger
  columns are monotone along any tape, hence badges never un-unlock
  (`unlocked_mono`).
* **The economy balances** — `ledger_run`: current brainrot plus everything ever
  spent equals everything ever earned, and everything ever spent is exactly the
  parts and the memes it bought.  In particular a claimed meme count is *backed*:
  `mintCost * memes ≤ earned` (`mint_backed`).
* **Holding pays** — `stake_ticks`: after `d` days the stake is `d * blocks`, so
  each further day held earns strictly more whenever the balance is nonzero
  (`stake_strict_mono`), and the balance itself never drops (`blocks_pos`).
-/

namespace Meme.Engine

/-! ## Tapes -/

@[simp] theorem run_nil (s : State) : run s [] = s := rfl

@[simp] theorem run_cons (s : State) (i : Input) (xs : List Input) :
    run s (i :: xs) = run (step s i) xs := rfl

/-- Replay is compositional: a long game can be checked in pieces. -/
theorem run_append (s : State) (xs ys : List Input) :
    run s (xs ++ ys) = run (run s xs) ys := by
  simp [run, List.foldl_append]

/-! ## Input codes -/

/-- Distinct inputs get distinct hash codes, so a tape is hashed faithfully. -/
theorem code_injective : Function.Injective Input.code := by
  intro a b hab
  cases a <;> cases b <;> simp [Input.code] at hab ⊢ <;> omega

/-! ## Monotone quantities -/

/-- A state quantity that no input can decrease. -/
def StepMono (f : State → Nat) : Prop := ∀ s i, f s ≤ f (step s i)

theorem StepMono.run {f : State → Nat} (hf : StepMono f) (s : State) (xs : List Input) :
    f s ≤ f (run s xs) := by
  induction xs generalizing s with
  | nil => simp
  | cons i t ih => exact le_trans (hf s i) (ih (step s i))

theorem stepMono_day : StepMono State.day := by
  intro s i; cases i <;> simp [step] <;> split <;> simp

theorem stepMono_parts : StepMono State.parts := by
  intro s i; cases i <;> simp [step] <;> split <;> simp

theorem stepMono_memes : StepMono State.memes := by
  intro s i; cases i <;> simp [step] <;> split <;> simp

theorem stepMono_blocks : StepMono State.blocks := by
  intro s i; cases i <;> simp [step] <;> split <;> simp

theorem stepMono_stake : StepMono State.stake := by
  intro s i; cases i <;> simp [step] <;> split <;> simp

theorem stepMono_earned : StepMono State.earned := by
  intro s i; cases i <;> simp [step] <;> split <;> simp

theorem stepMono_spent : StepMono State.spent := by
  intro s i; cases i <;> simp [step] <;> split <;> simp

theorem day_mono (s : State) (xs : List Input) : s.day ≤ (run s xs).day :=
  stepMono_day.run s xs

theorem parts_mono (s : State) (xs : List Input) : s.parts ≤ (run s xs).parts :=
  stepMono_parts.run s xs

theorem memes_mono (s : State) (xs : List Input) : s.memes ≤ (run s xs).memes :=
  stepMono_memes.run s xs

theorem blocks_mono (s : State) (xs : List Input) : s.blocks ≤ (run s xs).blocks :=
  stepMono_blocks.run s xs

theorem stake_mono (s : State) (xs : List Input) : s.stake ≤ (run s xs).stake :=
  stepMono_stake.run s xs

theorem earned_mono (s : State) (xs : List Input) : s.earned ≤ (run s xs).earned :=
  stepMono_earned.run s xs

theorem spent_mono (s : State) (xs : List Input) : s.spent ≤ (run s xs).spent :=
  stepMono_spent.run s xs

/-- Your balance never goes to zero by playing: whatever you held, you still hold. -/
theorem blocks_pos {s : State} (h : 0 < s.blocks) (xs : List Input) :
    0 < (run s xs).blocks :=
  lt_of_lt_of_le h (blocks_mono s xs)

/-! ## Badges are permanent -/

theorem meets_mono {b : Badge} {s : State} (xs : List Input) (h : b.meets s = true) :
    b.meets (run s xs) = true := by
  cases b <;>
    simp only [Badge.meets, decide_eq_true_eq] at h ⊢
  · exact le_trans h (memes_mono s xs)
  · exact le_trans h (memes_mono s xs)
  · exact le_trans h (parts_mono s xs)
  · exact le_trans h (day_mono s xs)
  · exact le_trans h (stake_mono s xs)

/-- An unlocked badge stays unlocked, no matter what is played afterwards. -/
theorem unlocked_mono {b : Badge} {s : State} (xs : List Input) (h : b ∈ unlocked s) :
    b ∈ unlocked (run s xs) := by
  simp only [unlocked, List.mem_filter] at h ⊢
  exact ⟨h.1, meets_mono xs h.2⟩

/-! ## The ledger -/

/-- The accounting invariant: brainrot in hand plus everything ever spent is
everything ever earned, and every unit spent bought either a part or a meme. -/
def Ledger (s : State) : Prop :=
  s.brainrot + s.spent = s.earned ∧ s.spent = partCost * s.parts + mintCost * s.memes

theorem ledger_start (b : Nat) : Ledger (start b) := by
  constructor <;> simp [start]

theorem ledger_step {s : State} (h : Ledger s) (i : Input) : Ledger (step s i) := by
  obtain ⟨h1, h2⟩ := h
  simp only [Ledger]
  cases i with
  | tap => refine ⟨?_, ?_⟩ <;> simp [step] <;> omega
  | steal n => refine ⟨?_, ?_⟩ <;> simp [step] <;> omega
  | hold n => refine ⟨?_, ?_⟩ <;> simp [step] <;> omega
  | tick => refine ⟨?_, ?_⟩ <;> simp [step] <;> omega
  | mint =>
      by_cases hle : mintCost ≤ s.brainrot
      · refine ⟨?_, ?_⟩ <;> simp [step, hle, Nat.mul_add] <;> omega
      · refine ⟨?_, ?_⟩ <;> simp [step, hle] <;> omega
  | build n =>
      by_cases hle : partCost * n ≤ s.brainrot
      · refine ⟨?_, ?_⟩ <;> simp [step, hle, Nat.mul_add] <;> omega
      · refine ⟨?_, ?_⟩ <;> simp [step, hle] <;> omega

theorem ledger_run {s : State} (h : Ledger s) (xs : List Input) : Ledger (run s xs) := by
  induction xs generalizing s with
  | nil => simpa using h
  | cons i t ih => exact ih (ledger_step h i)

/-- A claimed meme count is backed by brainrot actually earned. -/
theorem mint_backed {s : State} (h : Ledger s) : mintCost * s.memes ≤ s.earned := by
  obtain ⟨h1, h2⟩ := h; omega

/-- …and so is the tycoon. -/
theorem parts_backed {s : State} (h : Ledger s) : partCost * s.parts ≤ s.earned := by
  obtain ⟨h1, h2⟩ := h; omega

/-- A tape of length `n` can mint at most `n` memes. -/
theorem memes_le_length (s : State) (xs : List Input) :
    (run s xs).memes ≤ s.memes + xs.length := by
  induction xs generalizing s with
  | nil => simp
  | cons i t ih =>
      refine le_trans (ih (step s i)) ?_
      have : (step s i).memes ≤ s.memes + 1 := by
        cases i <;> simp [step] <;> split <;> simp
      simp only [List.length_cons]
      omega

/-! ## Holding -/

/-- Ticks do not change the balance… -/
theorem blocks_ticks (s : State) (d : Nat) :
    (run s (List.replicate d .tick)).blocks = s.blocks := by
  induction d generalizing s with
  | zero => simp
  | succ n ih => simpa [List.replicate_succ, step] using ih (step s .tick)

/-- …and each day held pays one unit of stake per block. -/
theorem stake_ticks (s : State) (d : Nat) :
    (run s (List.replicate d .tick)).stake = s.stake + d * s.blocks := by
  induction d generalizing s with
  | zero => simp
  | succ n ih =>
      have h := ih (step s .tick)
      simp only [List.replicate_succ, run_cons, h]
      simp [step]
      ring

/-- Days really do accumulate. -/
theorem day_ticks (s : State) (d : Nat) :
    (run s (List.replicate d .tick)).day = s.day + d := by
  induction d generalizing s with
  | zero => simp
  | succ n ih =>
      have h := ih (step s .tick)
      simp only [List.replicate_succ, run_cons, h]
      simp [step]
      omega

/-- Holding strictly longer pays strictly more, as long as you hold anything. -/
theorem stake_strict_mono {s : State} (hb : 0 < s.blocks) {d e : Nat} (hde : d < e) :
    (run s (List.replicate d .tick)).stake < (run s (List.replicate e .tick)).stake := by
  rw [stake_ticks, stake_ticks]
  exact Nat.add_lt_add_left (Nat.mul_lt_mul_of_lt_of_le hde (le_refl s.blocks) hb) s.stake

/-! ## Verifying a published claim -/

/-- A claim verifies exactly when it is the honest replay of its own tape. -/
theorem Claim.verify_iff (c : Claim) :
    c.verify = true ↔ c.final = run (start c.blocks) c.tape := by
  rw [Claim.verify, beq_iff_eq]
  exact eq_comm

/-- Anything a verified claim asserts about the monotone quantities is true of
the replay: in particular the meme count is the real one, and the balance is
still positive. -/
theorem Claim.verified_blocks_pos {c : Claim} (hv : c.verify = true) (h : 0 < c.blocks) :
    0 < c.final.blocks := by
  rw [Claim.verify_iff] at hv
  rw [hv]
  exact blocks_pos (by simpa [start] using h) c.tape

/-- A verified claim's meme count is backed by earnings — you cannot claim memes
you never paid for. -/
theorem Claim.verified_mint_backed {c : Claim} (hv : c.verify = true) :
    mintCost * c.final.memes ≤ c.final.earned := by
  rw [Claim.verify_iff] at hv
  rw [hv]
  exact mint_backed (ledger_run (ledger_start c.blocks) c.tape)

/-- …and it is at most the length of the tape it published. -/
theorem Claim.verified_memes_le {c : Claim} (hv : c.verify = true) :
    c.final.memes ≤ c.tape.length := by
  rw [Claim.verify_iff] at hv
  rw [hv]
  simpa [start] using memes_le_length (start c.blocks) c.tape

end Meme.Engine
